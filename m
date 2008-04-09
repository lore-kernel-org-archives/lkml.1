Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbYDIOma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbYDIOma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 10:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYDIOmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 10:42:23 -0400
Received: from barikada.upol.cz ([158.194.242.200]:43670 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbYDIOmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 10:42:22 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kbuild devel list <linux-kbuild@vger.kernel.org>
Subject: coloring stdout && stderr, small kbuild example
Date: Wed, 9 Apr 2008 17:02:31 +0200
Message-Id: <E1Jjbol-0002zS-4P@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those boring never-ending builds...

Can some dualCPU power be spent, if building is interactive (i.e. sent to
terminal), to have them a bit colored?

My last rant about "colored printk()" led away from kernel developers
and their solutions. But now, let me share something.

(maybe some terminal emulators have more colors, finally?) usage:

olecom@flower:/tmp/blinux$ stty -tostop ; mkfifo stdout.pipe stderr.pipe
olecom@flower:/tmp/blinux$ sh ./colorize-linux-build.sh <stdout.pipe &
[1] 22070
olecom@flower:/tmp/blinux$ COLORIZERR=y sh colorize-linux-build.sh <stderr.pipe &
[2] 22145
olecom@flower:/tmp/blinux$
olecom@flower:/tmp/blinux$ LANG=C make >stdout.pipe 2>stderr.pipe
make -C /mnt/zdev0/linux-2.6 O=/dev/shm/blinux/.
  Using /mnt/zdev0/linux-2.6 as source for kernel
  GEN     /dev/shm/blinux/Makefile
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    /mnt/zdev0/linux-2.6/scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  VDSOSYM arch/x86/vdso/vdso-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syscall-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syms.lds
  LD      arch/x86/vdso/built-in.o
  CC      mm/memory.o

olecom@flower:/tmp/blinux$

make[3]: *** [mm/memory.o] Interrupt
make[2]: *** [mm] Interrupt
make[1]: *** [sub-make] Interrupt
make: *** [all] Interrupt

[1]-  Done                    sh ./colorize-linux-build.sh <stdout.pipe
[2]+  Done                    COLORIZERR=yes sh colorize-linux-build.sh <stderr.pipe
olecom@flower:/tmp/blinux$

________________________________________________________________________
#!/bin/sh
# colorize linux build

# Time-stamp: Wed Apr  9 13:78:13 CEST 2008 olecom@flower.upol.cRAzY

color() {
    # $1 -- regex
    # $2 -- color code
    # $3 -- next color code (default is $D)
    # $4 -- regex match number (s///flags)
    printf %s "`eval echo $TERMINAL_OUTPUT`"
}

# for tty
[ -t 1 ] && {
    # escape symbol
    E=`printf '\033'`
    # default fg && bg rendering ; reset attributes
    D="7" ; RESET="$E[0m"
    # basic attributes (reset bg color and bold, set fg color)
    V="$E[40;22;3"
    # wrap regex with color ; goto exit
    TERMINAL_OUTPUT='{s-"$1"-"$V$2m&$V${3-'$D'}m"-$4 ";" b}'
}

# process stdout

[ -z "$COLORIZERR" ] && {
    sed "
/CC/` color CC '6;1'`
/LD/` color LD '2;1'`
/AS/` color AS '5;1'`
/GEN/`color GEN '2;1'`
/UPD/`color UPD '2;1'`
/CHK/`color CHK '3;1'`
/CA/` color CALL '6'`
s-^-${V}2m-
"
    printf "$RESET
"
}

# process stderr (once)

while read ERROR
do OUT=$OUT'
'$ERROR
done

printf "\033[1;37;41m$OUT$RESET
"
exit
