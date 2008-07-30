Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbYG3LDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbYG3LDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYG3LDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:03:11 -0400
Received: from aun.it.uu.se ([130.238.12.36]:36559 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbYG3LDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:03:09 -0400
Date: Wed, 30 Jul 2008 13:02:10 +0200 (MEST)
Message-Id: <200807301102.m6UB2AiI022512@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Subject: [BUG] x86: 2.6.27-rc1 does not build with gcc-3.2.3 any more
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attempting to build 2.6.27-rc1 on x86 with gcc-3.2.3 fails with:

  gcc -Wp,-MD,init/.main.o.d  -nostdinc -isystem /home/mikpe/pkgs/linux-x86/gnu/bin/../lib/gcc-lib/i686-pc-linux-gnu/3.2.3/include -D__KERNEL__ -Iinclude  -I/tmp/tmp/linux-2.6.27-rc1/arch/x86/include -include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -O2 -m32 -msoft-float -mregparm=3 -freg-struct-return -mpreferred-stack-boundary=2 -march=i486 -ffreestanding -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -Iinclude/asm-x86/mach-default -fomit-frame-pointer  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(main)"  -D"KBUILD_MODNAME=KBUILD_STR(main)" -c -o init/main.o init/main.c
In file included from include/asm/dma.h:12,
                 from include/linux/bootmem.h:8,
                 from init/main.c:26:
include/asm/io.h: In function `readb':
include/asm/io.h:32: syntax error before string constant
include/asm/io.h: In function `readw':
include/asm/io.h:33: syntax error before string constant
include/asm/io.h: In function `readl':
include/asm/io.h:34: syntax error before string constant
include/asm/io.h: In function `__readb':
include/asm/io.h:36: syntax error before string constant
include/asm/io.h: In function `__readw':
include/asm/io.h:37: syntax error before string constant
include/asm/io.h: In function `__readl':
include/asm/io.h:38: syntax error before string constant
make[1]: *** [init/main.o] Error 1
make: *** [init] Error 2

The preprocessor tricks now used to create readb() et al in io.h
results in code like (reformatted for readability):

static inline __attribute__((always_inline))
unsigned char readb(const volatile void *addr)
{
	unsigned char ret;
	asm volatile("mov" "b" " %1,%0"
		     : "=" "q" (ret)
		     : "m" (*(volatile unsigned char *)addr)
		     : "memory");
	return ret;
}

The problem is that "=q" has been broken up into two adjacent
string literals, and apparently gcc-3.2.3 hasn't done string
literal concatenation at the time it processes the asm().
Hence the syntax error. (This is clearly a gcc bug.)

Switching to gcc-3.3.6 or newer fixes the problem.

The question is, should the kernel be fixed to compile with 3.2.3
again (by generating "=q" not "=" "q"), or should the minimum supported
gcc version be bumped to 3.3.6?

I have no strong feeling about this, except that I want to use the
oldest (== least bloated) gcc possible on my 486 test box.

/Mikael
