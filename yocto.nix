{ pkgs ? import <nixpkgs> {}, ...}:

let
    unstable = import <nixos-unstable> {};
in
with pkgs;
(pkgs.buildFHSUserEnv {
  name = "yocto-env";

  # Packages Yocto is expecting on the host system by default
  targetPkgs = pkgs: (with pkgs; [
    (hiPrio unstable.bzip2_1_1)
    bash
    bashInteractive
    glibcLocales
    glibc_multi
    binutils
    ccache
    chrpath
    cmake
    cpio
    diffstat
    diffutils
    file
    findutils
    gawk
    gcc8
    gitFull
    gnumake
    gnutar
    gzip
    iproute
    netbsd.rpcgen
    nettools
    openssh
    patch
    perl
    procps
    python27
    python37
    SDL
    shadow
    socat
    texinfo
    unzip
    utillinux
    vim
    wget
    which
    xterm
  ]);

  # Headers are required to build
  extraOutputsToInstall = [ "dev" ];

  # Force install locale from "glibcLocales" since there are collisions
  extraBuildCommands = ''
    ln -sf ${glibcLocales}/lib/locale/locale-archive $out/usr/lib/locale
  '';

  profile = ''
    export hardeningDisable=all
    export MAKE=make
    export CC=gcc
    export LD=ld
    export EDITOR=vim
    export STRIP=strip
    export OBJCOPY=objcopy
    export RANLIB=ranlib
    export OBJDUMP=objdump
    export AS=as
    export AR=ar
    export NM=nm
    export CXX=g++
    export SIZE=size
    # Yocto is using the $LOCALEARCHIVE variable
    # instead of NixOS's $LOCALE_ARCHIVE
    export LOCALEARCHIVE=$LOCALE_ARCHIVE
    export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE LOCALE_ARCHIVE LOCALEARCHIVE"
  '';

  multiPkgs = pkgs: (with pkgs; []);
  runScript = "bash";
}).env
