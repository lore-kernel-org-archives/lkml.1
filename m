Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbZFJVqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbZFJVqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZFJVqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:46:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50715 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZFJVqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:46:03 -0400
Date: Wed, 10 Jun 2009 23:45:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/setup for v2.6.31
Message-ID: <20090610214550.GA10524@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-setup-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-setup-for-linus

These are the BIOS-call sandboxing patches. This has the chance to 
fix a couple of long-lived Linux boot problems on various weird 
boxes that were too finetuned to the Windows BIOS call environment.

 Thanks,

	Ingo

------------------>
H. Peter Anvin (7):
      x86, setup: "glove box" BIOS calls -- infrastructure
      x86, setup: "glove box" BIOS interrupts in the core boot code
      x86, setup: "glove box" BIOS interrupts in the APM code
      x86, setup: "glove box" BIOS interrupts in the EDD code
      x86, setup: "glove box" BIOS interrupts in the MCA code
      x86, setup: "glove box" BIOS interrupts in the video code
      x86, setup: fix comment in the "glove box" code


 arch/x86/boot/Makefile                   |    5 +-
 arch/x86/boot/a20.c                      |    9 ++-
 arch/x86/boot/apm.c                      |   76 ++++++----------
 arch/x86/boot/bioscall.S                 |   82 ++++++++++++++++++
 arch/x86/boot/boot.h                     |   48 +++++++++++
 arch/x86/boot/edd.c                      |   71 +++++++---------
 arch/x86/boot/header.S                   |    2 +-
 arch/x86/boot/main.c                     |   39 +++++----
 arch/x86/boot/mca.c                      |   27 +++---
 arch/x86/boot/memory.c                   |   79 +++++++++---------
 arch/x86/boot/regs.c                     |   29 ++++++
 arch/x86/boot/setup.ld                   |    6 ++
 arch/x86/boot/tty.c                      |   52 ++++++-----
 arch/x86/boot/video-bios.c               |   27 +++---
 arch/x86/boot/video-vesa.c               |  137 +++++++++++++-----------------
 arch/x86/boot/video-vga.c                |   95 +++++++++++++--------
 arch/x86/boot/video.c                    |   42 ++++-----
 arch/x86/boot/video.h                    |   14 ---
 arch/x86/kernel/acpi/realmode/Makefile   |    2 +-
 arch/x86/kernel/acpi/realmode/bioscall.S |    1 +
 arch/x86/kernel/acpi/realmode/regs.c     |    1 +
 21 files changed, 489 insertions(+), 355 deletions(-)
 create mode 100644 arch/x86/boot/bioscall.S
 create mode 100644 arch/x86/boot/regs.c
 create mode 100644 arch/x86/kernel/acpi/realmode/bioscall.S
 create mode 100644 arch/x86/kernel/acpi/realmode/regs.c

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 6633b6e..658bc52 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -26,9 +26,10 @@ targets		:= vmlinux.bin setup.bin setup.elf bzImage
 targets		+= fdimage fdimage144 fdimage288 image.iso mtools.conf
 subdir-		:= compressed
 
-setup-y		+= a20.o cmdline.o copy.o cpu.o cpucheck.o edd.o
+setup-y		+= a20.o bioscall.o cmdline.o copy.o cpu.o cpucheck.o edd.o
 setup-y		+= header.o main.o mca.o memory.o pm.o pmjump.o
-setup-y		+= printf.o string.o tty.o video.o video-mode.o version.o
+setup-y		+= printf.o regs.o string.o tty.o video.o video-mode.o
+setup-y		+= version.o
 setup-$(CONFIG_X86_APM_BOOT) += apm.o
 
 # The link order of the video-*.o modules can matter.  In particular,
diff --git a/arch/x86/boot/a20.c b/arch/x86/boot/a20.c
index 7c19ce8..64a31a6 100644
--- a/arch/x86/boot/a20.c
+++ b/arch/x86/boot/a20.c
@@ -2,7 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007-2008 rPath, Inc. - All Rights Reserved
- *   Copyright 2009 Intel Corporation
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -90,8 +90,11 @@ static int a20_test_long(void)
 
 static void enable_a20_bios(void)
 {
-	asm volatile("pushfl; int $0x15; popfl"
-		     : : "a" ((u16)0x2401));
+	struct biosregs ireg;
+
+	initregs(&ireg);
+	ireg.ax = 0x2401;
+	intcall(0x15, &ireg, NULL);
 }
 
 static void enable_a20_kbc(void)
diff --git a/arch/x86/boot/apm.c b/arch/x86/boot/apm.c
index 7aa6033..ee27483 100644
--- a/arch/x86/boot/apm.c
+++ b/arch/x86/boot/apm.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   Original APM BIOS checking by Stephen Rothwell, May 1994
  *   (sfr@canb.auug.org.au)
@@ -19,75 +20,56 @@
 
 int query_apm_bios(void)
 {
-	u16 ax, bx, cx, dx, di;
-	u32 ebx, esi;
-	u8 err;
+	struct biosregs ireg, oreg;
 
 	/* APM BIOS installation check */
-	ax = 0x5300;
-	bx = cx = 0;
-	asm volatile("pushl %%ebp ; int $0x15 ; popl %%ebp ; setc %0"
-		     : "=d" (err), "+a" (ax), "+b" (bx), "+c" (cx)
-		     : : "esi", "edi");
+	initregs(&ireg);
+	ireg.ah = 0x53;
+	intcall(0x15, &ireg, &oreg);
 
-	if (err)
+	if (oreg.flags & X86_EFLAGS_CF)
 		return -1;		/* No APM BIOS */
 
-	if (bx != 0x504d)	/* "PM" signature */
+	if (oreg.bx != 0x504d)		/* "PM" signature */
 		return -1;
 
-	if (!(cx & 0x02))		/* 32 bits supported? */
+	if (!(oreg.cx & 0x02))		/* 32 bits supported? */
 		return -1;
 
 	/* Disconnect first, just in case */
-	ax = 0x5304;
-	bx = 0;
-	asm volatile("pushl %%ebp ; int $0x15 ; popl %%ebp"
-		     : "+a" (ax), "+b" (bx)
-		     : : "ecx", "edx", "esi", "edi");
-
-	/* Paranoia */
-	ebx = esi = 0;
-	cx = dx = di = 0;
+	ireg.al = 0x04;
+	intcall(0x15, &ireg, NULL);
 
 	/* 32-bit connect */
-	asm volatile("pushl %%ebp ; int $0x15 ; popl %%ebp ; setc %6"
-		     : "=a" (ax), "+b" (ebx), "+c" (cx), "+d" (dx),
-		       "+S" (esi), "+D" (di), "=m" (err)
-		     : "a" (0x5303));
-
-	boot_params.apm_bios_info.cseg = ax;
-	boot_params.apm_bios_info.offset = ebx;
-	boot_params.apm_bios_info.cseg_16 = cx;
-	boot_params.apm_bios_info.dseg = dx;
-	boot_params.apm_bios_info.cseg_len = (u16)esi;
-	boot_params.apm_bios_info.cseg_16_len = esi >> 16;
-	boot_params.apm_bios_info.dseg_len = di;
-
-	if (err)
+	ireg.al = 0x03;
+	intcall(0x15, &ireg, &oreg);
+
+	boot_params.apm_bios_info.cseg        = oreg.ax;
+	boot_params.apm_bios_info.offset      = oreg.ebx;
+	boot_params.apm_bios_info.cseg_16     = oreg.cx;
+	boot_params.apm_bios_info.dseg        = oreg.dx;
+	boot_params.apm_bios_info.cseg_len    = oreg.si;
+	boot_params.apm_bios_info.cseg_16_len = oreg.hsi;
+	boot_params.apm_bios_info.dseg_len    = oreg.di;
+
+	if (oreg.flags & X86_EFLAGS_CF)
 		return -1;
 
 	/* Redo the installation check as the 32-bit connect;
 	   some BIOSes return different flags this way... */
 
-	ax = 0x5300;
-	bx = cx = 0;
-	asm volatile("pushl %%ebp ; int $0x15 ; popl %%ebp ; setc %0"
-		     : "=d" (err), "+a" (ax), "+b" (bx), "+c" (cx)
-		     : : "esi", "edi");
+	ireg.al = 0x00;
+	intcall(0x15, &ireg, &oreg);
 
-	if (err || bx != 0x504d) {
+	if ((oreg.eflags & X86_EFLAGS_CF) || oreg.bx != 0x504d) {
 		/* Failure with 32-bit connect, try to disconect and ignore */
-		ax = 0x5304;
-		bx = 0;
-		asm volatile("pushl %%ebp ; int $0x15 ; popl %%ebp"
-			     : "+a" (ax), "+b" (bx)
-			     : : "ecx", "edx", "esi", "edi");
+		ireg.al = 0x04;
+		intcall(0x15, &ireg, NULL);
 		return -1;
 	}
 
-	boot_params.apm_bios_info.version = ax;
-	boot_params.apm_bios_info.flags = cx;
+	boot_params.apm_bios_info.version = oreg.ax;
+	boot_params.apm_bios_info.flags   = oreg.cx;
 	return 0;
 }
 
diff --git a/arch/x86/boot/bioscall.S b/arch/x86/boot/bioscall.S
new file mode 100644
index 0000000..5077937
--- /dev/null
+++ b/arch/x86/boot/bioscall.S
@@ -0,0 +1,82 @@
+/* -----------------------------------------------------------------------
+ *
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2 or (at your
+ *   option) any later version; incorporated herein by reference.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * "Glove box" for BIOS calls.  Avoids the constant problems with BIOSes
+ * touching registers they shouldn't be.
+ */
+
+	.code16
+	.text
+	.globl	intcall
+	.type	intcall, @function
+intcall:
+	/* Self-modify the INT instruction.  Ugly, but works. */
+	cmpb	%al, 3f
+	je	1f
+	movb	%al, 3f
+	jmp	1f		/* Synchronize pipeline */
+1:
+	/* Save state */
+	pushfl
+	pushw	%fs
+	pushw	%gs
+	pushal
+
+	/* Copy input state to stack frame */
+	subw	$44, %sp
+	movw	%dx, %si
+	movw	%sp, %di
+	movw	$11, %cx
+	rep; movsd
+
+	/* Pop full state from the stack */
+	popal
+	popw	%gs
+	popw	%fs
+	popw	%es
+	popw	%ds
+	popfl
+
+	/* Actual INT */
+	.byte	0xcd		/* INT opcode */
+3:	.byte	0
+
+	/* Push full state to the stack */
+	pushfl
+	pushw	%ds
+	pushw	%es
+	pushw	%fs
+	pushw	%gs
+	pushal
+
+	/* Re-establish C environment invariants */
+	cld
+	movzwl	%sp, %esp
+	movw	%cs, %ax
+	movw	%ax, %ds
+	movw	%ax, %es
+
+	/* Copy output state from stack frame */
+	movw	68(%esp), %di	/* Original %cx == 3rd argument */
+	andw	%di, %di
+	jz	4f
+	movw	%sp, %si
+	movw	$11, %cx
+	rep; movsd
+4:	addw	$44, %sp
+
+	/* Restore state and return */
+	popal
+	popw	%gs
+	popw	%fs
+	popfl
+	retl
+	.size	intcall, .-intcall
diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 7b2692e..98239d2 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -26,6 +27,7 @@
 #include <asm/setup.h>
 #include "bitops.h"
 #include <asm/cpufeature.h>
+#include <asm/processor-flags.h>
 
 /* Useful macros */
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
@@ -241,6 +243,49 @@ int enable_a20(void);
 /* apm.c */
 int query_apm_bios(void);
 
+/* bioscall.c */
+struct biosregs {
+	union {
+		struct {
+			u32 edi;
+			u32 esi;
+			u32 ebp;
+			u32 _esp;
+			u32 ebx;
+			u32 edx;
+			u32 ecx;
+			u32 eax;
+			u32 _fsgs;
+			u32 _dses;
+			u32 eflags;
+		};
+		struct {
+			u16 di, hdi;
+			u16 si, hsi;
+			u16 bp, hbp;
+			u16 _sp, _hsp;
+			u16 bx, hbx;
+			u16 dx, hdx;
+			u16 cx, hcx;
+			u16 ax, hax;
+			u16 gs, fs;
+			u16 es, ds;
+			u16 flags, hflags;
+		};
+		struct {
+			u8 dil, dih, edi2, edi3;
+			u8 sil, sih, esi2, esi3;
+			u8 bpl, bph, ebp2, ebp3;
+			u8 _spl, _sph, _esp2, _esp3;
+			u8 bl, bh, ebx2, ebx3;
+			u8 dl, dh, edx2, edx3;
+			u8 cl, ch, ecx2, ecx3;
+			u8 al, ah, eax2, eax3;
+		};
+	};
+};
+void intcall(u8 int_no, const struct biosregs *ireg, struct biosregs *oreg);
+
 /* cmdline.c */
 int cmdline_find_option(const char *option, char *buffer, int bufsize);
 int cmdline_find_option_bool(const char *option);
@@ -279,6 +324,9 @@ int sprintf(char *buf, const char *fmt, ...);
 int vsprintf(char *buf, const char *fmt, va_list args);
 int printf(const char *fmt, ...);
 
+/* regs.c */
+void initregs(struct biosregs *regs);
+
 /* string.c */
 int strcmp(const char *str1, const char *str2);
 size_t strnlen(const char *s, size_t maxlen);
diff --git a/arch/x86/boot/edd.c b/arch/x86/boot/edd.c
index 1aae8f3..c501a5b 100644
--- a/arch/x86/boot/edd.c
+++ b/arch/x86/boot/edd.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -22,17 +23,17 @@
  */
 static int read_mbr(u8 devno, void *buf)
 {
-	u16 ax, bx, cx, dx;
+	struct biosregs ireg, oreg;
 
-	ax = 0x0201;		/* Legacy Read, one sector */
-	cx = 0x0001;		/* Sector 0-0-1 */
-	dx = devno;
-	bx = (size_t)buf;
-	asm volatile("pushfl; stc; int $0x13; setc %%al; popfl"
-		     : "+a" (ax), "+c" (cx), "+d" (dx), "+b" (bx)
-		     : : "esi", "edi", "memory");
+	initregs(&ireg);
+	ireg.ax = 0x0201;		/* Legacy Read, one sector */
+	ireg.cx = 0x0001;		/* Sector 0-0-1 */
+	ireg.dl = devno;
+	ireg.bx = (size_t)buf;
 
-	return -(u8)ax;		/* 0 or -1 */
+	intcall(0x13, &ireg, &oreg);
+
+	return -(oreg.eflags & X86_EFLAGS_CF); /* 0 or -1 */
 }
 
 static u32 read_mbr_sig(u8 devno, struct edd_info *ei, u32 *mbrsig)
@@ -72,56 +73,46 @@ static u32 read_mbr_sig(u8 devno, struct edd_info *ei, u32 *mbrsig)
 
 static int get_edd_info(u8 devno, struct edd_info *ei)
 {
-	u16 ax, bx, cx, dx, di;
+	struct biosregs ireg, oreg;
 
 	memset(ei, 0, sizeof *ei);
 
 	/* Check Extensions Present */
 
-	ax = 0x4100;
-	bx = EDDMAGIC1;
-	dx = devno;
-	asm("pushfl; stc; int $0x13; setc %%al; popfl"
-	    : "+a" (ax), "+b" (bx), "=c" (cx), "+d" (dx)
-	    : : "esi", "edi");
+	initregs(&ireg);
+	ireg.ah = 0x41;
+	ireg.bx = EDDMAGIC1;
+	ireg.dl = devno;
+	intcall(0x13, &ireg, &oreg);
 
-	if ((u8)ax)
+	if (oreg.eflags & X86_EFLAGS_CF)
 		return -1;	/* No extended information */
 
-	if (bx != EDDMAGIC2)
+	if (oreg.bx != EDDMAGIC2)
 		return -1;
 
 	ei->device  = devno;
-	ei->version = ax >> 8;	/* EDD version number */
-	ei->interface_support = cx; /* EDD functionality subsets */
+	ei->version = oreg.ah;		 /* EDD version number */
+	ei->interface_support = oreg.cx; /* EDD functionality subsets */
 
 	/* Extended Get Device Parameters */
 
 	ei->params.length = sizeof(ei->params);
-	ax = 0x4800;
-	dx = devno;
-	asm("pushfl; int $0x13; popfl"
-	    : "+a" (ax), "+d" (dx), "=m" (ei->params)
-	    : "S" (&ei->params)
-	    : "ebx", "ecx", "edi");
+	ireg.ah = 0x48;
+	ireg.si = (size_t)&ei->params;
+	intcall(0x13, &ireg, &oreg);
 
 	/* Get legacy CHS parameters */
 
 	/* Ralf Brown recommends setting ES:DI to 0:0 */
-	ax = 0x0800;
-	dx = devno;
-	di = 0;
-	asm("pushw %%es; "
-	    "movw %%di,%%es; "
-	    "pushfl; stc; int $0x13; setc %%al; popfl; "
-	    "popw %%es"
-	    : "+a" (ax), "=b" (bx), "=c" (cx), "+d" (dx), "+D" (di)
-	    : : "esi");
-
-	if ((u8)ax == 0) {
-		ei->legacy_max_cylinder = (cx >> 8) + ((cx & 0xc0) << 2);
-		ei->legacy_max_head = dx >> 8;
-		ei->legacy_sectors_per_track = cx & 0x3f;
+	ireg.ah = 0x08;
+	ireg.es = 0;
+	intcall(0x13, &ireg, &oreg);
+
+	if (!(oreg.eflags & X86_EFLAGS_CF)) {
+		ei->legacy_max_cylinder = oreg.ch + ((oreg.cl & 0xc0) << 2);
+		ei->legacy_max_head = oreg.dh;
+		ei->legacy_sectors_per_track = oreg.cl & 0x3f;
 	}
 
 	return 0;
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 5d84d1c..486d97f 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -221,7 +221,7 @@ setup_data:		.quad 0			# 64-bit physical pointer to
 
 # End of setup header #####################################################
 
-	.section ".inittext", "ax"
+	.section ".entrytext", "ax"
 start_of_setup:
 #ifdef SAFE_RESET_DISK_CONTROLLER
 # Reset the disk controller.
diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
index 58f0415..140172b 100644
--- a/arch/x86/boot/main.c
+++ b/arch/x86/boot/main.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -61,11 +62,10 @@ static void copy_boot_params(void)
  */
 static void keyboard_set_repeat(void)
 {
-	u16 ax = 0x0305;
-	u16 bx = 0;
-	asm volatile("int $0x16"
-		     : "+a" (ax), "+b" (bx)
-		     : : "ecx", "edx", "esi", "edi");
+	struct biosregs ireg;
+	initregs(&ireg);
+	ireg.ax = 0x0305;
+	intcall(0x16, &ireg, NULL);
 }
 
 /*
@@ -73,18 +73,22 @@ static void keyboard_set_repeat(void)
  */
 static void query_ist(void)
 {
+	struct biosregs ireg, oreg;
+
 	/* Some older BIOSes apparently crash on this call, so filter
 	   it from machines too old to have SpeedStep at all. */
 	if (cpu.level < 6)
 		return;
 
-	asm("int $0x15"
-	    : "=a" (boot_params.ist_info.signature),
-	      "=b" (boot_params.ist_info.command),
-	      "=c" (boot_params.ist_info.event),
-	      "=d" (boot_params.ist_info.perf_level)
-	    : "a" (0x0000e980),	 /* IST Support */
-	      "d" (0x47534943)); /* Request value */
+	initregs(&ireg);
+	ireg.ax  = 0xe980;	 /* IST Support */
+	ireg.edx = 0x47534943;	 /* Request value */
+	intcall(0x15, &ireg, &oreg);
+
+	boot_params.ist_info.signature  = oreg.eax;
+	boot_params.ist_info.command    = oreg.ebx;
+	boot_params.ist_info.event      = oreg.ecx;
+	boot_params.ist_info.perf_level = oreg.edx;
 }
 
 /*
@@ -93,13 +97,12 @@ static void query_ist(void)
 static void set_bios_mode(void)
 {
 #ifdef CONFIG_X86_64
-	u32 eax, ebx;
+	struct biosregs ireg;
 
-	eax = 0xec00;
-	ebx = 2;
-	asm volatile("int $0x15"
-		     : "+a" (eax), "+b" (ebx)
-		     : : "ecx", "edx", "esi", "edi");
+	initregs(&ireg);
+	ireg.ax = 0xec00;
+	ireg.bx = 2;
+	intcall(0x15, &ireg, NULL);
 #endif
 }
 
diff --git a/arch/x86/boot/mca.c b/arch/x86/boot/mca.c
index 911eaae..a95a531 100644
--- a/arch/x86/boot/mca.c
+++ b/arch/x86/boot/mca.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -16,26 +17,22 @@
 
 int query_mca(void)
 {
-	u8 err;
-	u16 es, bx, len;
-
-	asm("pushw %%es ; "
-	    "int $0x15 ; "
-	    "setc %0 ; "
-	    "movw %%es, %1 ; "
-	    "popw %%es"
-	    : "=acd" (err), "=acdSD" (es), "=b" (bx)
-	    : "a" (0xc000));
-
-	if (err)
+	struct biosregs ireg, oreg;
+	u16 len;
+
+	initregs(&ireg);
+	ireg.ah = 0xc0;
+	intcall(0x15, &ireg, &oreg);
+
+	if (oreg.eflags & X86_EFLAGS_CF)
 		return -1;	/* No MCA present */
 
-	set_fs(es);
-	len = rdfs16(bx);
+	set_fs(oreg.es);
+	len = rdfs16(oreg.bx);
 
 	if (len > sizeof(boot_params.sys_desc_table))
 		len = sizeof(boot_params.sys_desc_table);
 
-	copy_from_fs(&boot_params.sys_desc_table, bx, len);
+	copy_from_fs(&boot_params.sys_desc_table, oreg.bx, len);
 	return 0;
 }
diff --git a/arch/x86/boot/memory.c b/arch/x86/boot/memory.c
index 74b3d2b..cae3feb 100644
--- a/arch/x86/boot/memory.c
+++ b/arch/x86/boot/memory.c
@@ -20,12 +20,16 @@
 static int detect_memory_e820(void)
 {
 	int count = 0;
-	u32 next = 0;
-	u32 size, id, edi;
-	u8 err;
+	struct biosregs ireg, oreg;
 	struct e820entry *desc = boot_params.e820_map;
 	static struct e820entry buf; /* static so it is zeroed */
 
+	initregs(&ireg);
+	ireg.ax  = 0xe820;
+	ireg.cx  = sizeof buf;
+	ireg.edx = SMAP;
+	ireg.di  = (size_t)&buf;
+
 	/*
 	 * Note: at least one BIOS is known which assumes that the
 	 * buffer pointed to by one e820 call is the same one as
@@ -41,22 +45,13 @@ static int detect_memory_e820(void)
 	 */
 
 	do {
-		size = sizeof buf;
-
-		/* Important: %edx and %esi are clobbered by some BIOSes,
-		   so they must be either used for the error output
-		   or explicitly marked clobbered.  Given that, assume there
-		   is something out there clobbering %ebp and %edi, too. */
-		asm("pushl %%ebp; int $0x15; popl %%ebp; setc %0"
-		    : "=d" (err), "+b" (next), "=a" (id), "+c" (size),
-		      "=D" (edi), "+m" (buf)
-		    : "D" (&buf), "d" (SMAP), "a" (0xe820)
-		    : "esi");
+		intcall(0x15, &ireg, &oreg);
+		ireg.ebx = oreg.ebx; /* for next iteration... */
 
 		/* BIOSes which terminate the chain with CF = 1 as opposed
 		   to %ebx = 0 don't always report the SMAP signature on
 		   the final, failing, probe. */
-		if (err)
+		if (oreg.eflags & X86_EFLAGS_CF)
 			break;
 
 		/* Some BIOSes stop returning SMAP in the middle of
@@ -64,60 +59,64 @@ static int detect_memory_e820(void)
 		   screwed up the map at that point, we might have a
 		   partial map, the full map, or complete garbage, so
 		   just return failure. */
-		if (id != SMAP) {
+		if (oreg.eax != SMAP) {
 			count = 0;
 			break;
 		}
 
 		*desc++ = buf;
 		count++;
-	} while (next && count < ARRAY_SIZE(boot_params.e820_map));
+	} while (ireg.ebx && count < ARRAY_SIZE(boot_params.e820_map));
 
 	return boot_params.e820_entries = count;
 }
 
 static int detect_memory_e801(void)
 {
-	u16 ax, bx, cx, dx;
-	u8 err;
+	struct biosregs ireg, oreg;
 
-	bx = cx = dx = 0;
-	ax = 0xe801;
-	asm("stc; int $0x15; setc %0"
-	    : "=m" (err), "+a" (ax), "+b" (bx), "+c" (cx), "+d" (dx));
+	initregs(&ireg);
+	ireg.ax = 0xe801;
+	intcall(0x15, &ireg, &oreg);
 
-	if (err)
+	if (oreg.eflags & X86_EFLAGS_CF)
 		return -1;
 
 	/* Do we really need to do this? */
-	if (cx || dx) {
-		ax = cx;
-		bx = dx;
+	if (oreg.cx || oreg.dx) {
+		oreg.ax = oreg.cx;
+		oreg.bx = oreg.dx;
 	}
 
-	if (ax > 15*1024)
+	if (oreg.ax > 15*1024) {
 		return -1;	/* Bogus! */
-
-	/* This ignores memory above 16MB if we have a memory hole
-	   there.  If someone actually finds a machine with a memory
-	   hole at 16MB and no support for 0E820h they should probably
-	   generate a fake e820 map. */
-	boot_params.alt_mem_k = (ax == 15*1024) ? (dx << 6)+ax : ax;
+	} else if (oreg.ax == 15*1024) {
+		boot_params.alt_mem_k = (oreg.dx << 6) + oreg.ax;
+	} else {
+		/*
+		 * This ignores memory above 16MB if we have a memory
+		 * hole there.  If someone actually finds a machine
+		 * with a memory hole at 16MB and no support for
+		 * 0E820h they should probably generate a fake e820
+		 * map.
+		 */
+		boot_params.alt_mem_k = oreg.ax;
+	}
 
 	return 0;
 }
 
 static int detect_memory_88(void)
 {
-	u16 ax;
-	u8 err;
+	struct biosregs ireg, oreg;
 
-	ax = 0x8800;
-	asm("stc; int $0x15; setc %0" : "=bcdm" (err), "+a" (ax));
+	initregs(&ireg);
+	ireg.ah = 0x88;
+	intcall(0x15, &ireg, &oreg);
 
-	boot_params.screen_info.ext_mem_k = ax;
+	boot_params.screen_info.ext_mem_k = oreg.ax;
 
-	return -err;
+	return -(oreg.eflags & X86_EFLAGS_CF); /* 0 or -1 */
 }
 
 int detect_memory(void)
diff --git a/arch/x86/boot/regs.c b/arch/x86/boot/regs.c
new file mode 100644
index 0000000..958019b
--- /dev/null
+++ b/arch/x86/boot/regs.c
@@ -0,0 +1,29 @@
+/* -----------------------------------------------------------------------
+ *
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2 or (at your
+ *   option) any later version; incorporated herein by reference.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * Simple helper function for initializing a register set.
+ *
+ * Note that this sets EFLAGS_CF in the input register set; this
+ * makes it easier to catch functions which do nothing but don't
+ * explicitly set CF.
+ */
+
+#include "boot.h"
+
+void initregs(struct biosregs *reg)
+{
+	memset(reg, 0, sizeof *reg);
+	reg->eflags |= X86_EFLAGS_CF;
+	reg->ds = ds();
+	reg->es = ds();
+	reg->fs = fs();
+	reg->gs = gs();
+}
diff --git a/arch/x86/boot/setup.ld b/arch/x86/boot/setup.ld
index bb8dc2d..0f6ec45 100644
--- a/arch/x86/boot/setup.ld
+++ b/arch/x86/boot/setup.ld
@@ -15,8 +15,11 @@ SECTIONS
 
 	. = 497;
 	.header		: { *(.header) }
+	.entrytext	: { *(.entrytext) }
 	.inittext	: { *(.inittext) }
 	.initdata	: { *(.initdata) }
+	__end_init = .;
+
 	.text		: { *(.text) }
 	.text32		: { *(.text32) }
 
@@ -52,4 +55,7 @@ SECTIONS
 
 	. = ASSERT(_end <= 0x8000, "Setup too big!");
 	. = ASSERT(hdr == 0x1f1, "The setup header has the wrong offset!");
+	/* Necessary for the very-old-loader check to work... */
+	. = ASSERT(__end_init <= 5*512, "init sections too big!");
+
 }
diff --git a/arch/x86/boot/tty.c b/arch/x86/boot/tty.c
index 7e8e8b2..01ec69c 100644
--- a/arch/x86/boot/tty.c
+++ b/arch/x86/boot/tty.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -22,24 +23,23 @@
 
 void __attribute__((section(".inittext"))) putchar(int ch)
 {
-	unsigned char c = ch;
+	struct biosregs ireg;
 
-	if (c == '\n')
+	if (ch == '\n')
 		putchar('\r');	/* \n -> \r\n */
 
-	/* int $0x10 is known to have bugs involving touching registers
-	   it shouldn't.  Be extra conservative... */
-	asm volatile("pushal; pushw %%ds; int $0x10; popw %%ds; popal"
-		     : : "b" (0x0007), "c" (0x0001), "a" (0x0e00|ch));
+	initregs(&ireg);
+	ireg.bx = 0x0007;
+	ireg.cx = 0x0001;
+	ireg.ah = 0x0e;
+	ireg.al = ch;
+	intcall(0x10, &ireg, NULL);
 }
 
 void __attribute__((section(".inittext"))) puts(const char *str)
 {
-	int n = 0;
-	while (*str) {
+	while (*str)
 		putchar(*str++);
-		n++;
-	}
 }
 
 /*
@@ -49,14 +49,13 @@ void __attribute__((section(".inittext"))) puts(const char *str)
 
 static u8 gettime(void)
 {
-	u16 ax = 0x0200;
-	u16 cx, dx;
+	struct biosregs ireg, oreg;
 
-	asm volatile("int $0x1a"
-		     : "+a" (ax), "=c" (cx), "=d" (dx)
-		     : : "ebx", "esi", "edi");
+	initregs(&ireg);
+	ireg.ah = 0x02;
+	intcall(0x1a, &ireg, &oreg);
 
-	return dx >> 8;
+	return oreg.dh;
 }
 
 /*
@@ -64,19 +63,24 @@ static u8 gettime(void)
  */
 int getchar(void)
 {
-	u16 ax = 0;
-	asm volatile("int $0x16" : "+a" (ax));
+	struct biosregs ireg, oreg;
+
+	initregs(&ireg);
+	/* ireg.ah = 0x00; */
+	intcall(0x16, &ireg, &oreg);
 
-	return ax & 0xff;
+	return oreg.al;
 }
 
 static int kbd_pending(void)
 {
-	u8 pending;
-	asm volatile("int $0x16; setnz %0"
-		     : "=qm" (pending)
-		     : "a" (0x0100));
-	return pending;
+	struct biosregs ireg, oreg;
+
+	initregs(&ireg);
+	ireg.ah = 0x01;
+	intcall(0x16, &ireg, &oreg);
+
+	return !(oreg.eflags & X86_EFLAGS_ZF);
 }
 
 void kbd_flush(void)
diff --git a/arch/x86/boot/video-bios.c b/arch/x86/boot/video-bios.c
index 3fa979c..d660be4 100644
--- a/arch/x86/boot/video-bios.c
+++ b/arch/x86/boot/video-bios.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -29,21 +30,21 @@ static int bios_set_mode(struct mode_info *mi)
 
 static int set_bios_mode(u8 mode)
 {
-	u16 ax;
+	struct biosregs ireg, oreg;
 	u8 new_mode;
 
-	ax = mode;		/* AH=0x00 Set Video Mode */
-	asm volatile(INT10
-		     : "+a" (ax)
-		     : : "ebx", "ecx", "edx", "esi", "edi");
+	initregs(&ireg);
+	ireg.al = mode;		/* AH=0x00 Set Video Mode */
+	intcall(0x10, &ireg, NULL);
 
-	ax = 0x0f00;		/* Get Current Video Mode */
-	asm volatile(INT10
-		     : "+a" (ax)
-		     : : "ebx", "ecx", "edx", "esi", "edi");
+
+	ireg.ah = 0x0f;		/* Get Current Video Mode */
+	intcall(0x10, &ireg, &oreg);
 
 	do_restore = 1;		/* Assume video contents were lost */
-	new_mode = ax & 0x7f;	/* Not all BIOSes are clean with the top bit */
+
+	/* Not all BIOSes are clean with the top bit */
+	new_mode = ireg.al & 0x7f;
 
 	if (new_mode == mode)
 		return 0;	/* Mode change OK */
@@ -53,10 +54,8 @@ static int set_bios_mode(u8 mode)
 		/* Mode setting failed, but we didn't end up where we
 		   started.  That's bad.  Try to revert to the original
 		   video mode. */
-		ax = boot_params.screen_info.orig_video_mode;
-		asm volatile(INT10
-			     : "+a" (ax)
-			     : : "ebx", "ecx", "edx", "esi", "edi");
+		ireg.ax = boot_params.screen_info.orig_video_mode;
+		intcall(0x10, &ireg, NULL);
 	}
 #endif
 	return -1;
diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index 4a58c8c..c700147 100644
--- a/arch/x86/boot/video-vesa.c
+++ b/arch/x86/boot/video-vesa.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -31,7 +32,7 @@ static inline void vesa_store_mode_params_graphics(void) {}
 static int vesa_probe(void)
 {
 #if defined(CONFIG_VIDEO_VESA) || defined(CONFIG_FIRMWARE_EDID)
-	u16 ax, cx, di;
+	struct biosregs ireg, oreg;
 	u16 mode;
 	addr_t mode_ptr;
 	struct mode_info *mi;
@@ -39,13 +40,12 @@ static int vesa_probe(void)
 
 	video_vesa.modes = GET_HEAP(struct mode_info, 0);
 
-	ax = 0x4f00;
-	di = (size_t)&vginfo;
-	asm(INT10
-	    : "+a" (ax), "+D" (di), "=m" (vginfo)
-	    : : "ebx", "ecx", "edx", "esi");
+	initregs(&ireg);
+	ireg.ax = 0x4f00;
+	ireg.di = (size_t)&vginfo;
+	intcall(0x10, &ireg, &oreg);
 
-	if (ax != 0x004f ||
+	if (ireg.ax != 0x004f ||
 	    vginfo.signature != VESA_MAGIC ||
 	    vginfo.version < 0x0102)
 		return 0;	/* Not present */
@@ -65,14 +65,12 @@ static int vesa_probe(void)
 
 		memset(&vminfo, 0, sizeof vminfo); /* Just in case... */
 
-		ax = 0x4f01;
-		cx = mode;
-		di = (size_t)&vminfo;
-		asm(INT10
-		    : "+a" (ax), "+c" (cx), "+D" (di), "=m" (vminfo)
-		    : : "ebx", "edx", "esi");
+		ireg.ax = 0x4f01;
+		ireg.cx = mode;
+		ireg.di = (size_t)&vminfo;
+		intcall(0x10, &ireg, &oreg);
 
-		if (ax != 0x004f)
+		if (ireg.ax != 0x004f)
 			continue;
 
 		if ((vminfo.mode_attr & 0x15) == 0x05) {
@@ -111,20 +109,19 @@ static int vesa_probe(void)
 
 static int vesa_set_mode(struct mode_info *mode)
 {
-	u16 ax, bx, cx, di;
+	struct biosregs ireg, oreg;
 	int is_graphic;
 	u16 vesa_mode = mode->mode - VIDEO_FIRST_VESA;
 
 	memset(&vminfo, 0, sizeof vminfo); /* Just in case... */
 
-	ax = 0x4f01;
-	cx = vesa_mode;
-	di = (size_t)&vminfo;
-	asm(INT10
-	    : "+a" (ax), "+c" (cx), "+D" (di), "=m" (vminfo)
-	    : : "ebx", "edx", "esi");
+	initregs(&ireg);
+	ireg.ax = 0x4f01;
+	ireg.cx = vesa_mode;
+	ireg.di = (size_t)&vminfo;
+	intcall(0x10, &ireg, &oreg);
 
-	if (ax != 0x004f)
+	if (oreg.ax != 0x004f)
 		return -1;
 
 	if ((vminfo.mode_attr & 0x15) == 0x05) {
@@ -141,14 +138,12 @@ static int vesa_set_mode(struct mode_info *mode)
 	}
 
 
-	ax = 0x4f02;
-	bx = vesa_mode;
-	di = 0;
-	asm volatile(INT10
-		     : "+a" (ax), "+b" (bx), "+D" (di)
-		     : : "ecx", "edx", "esi");
+	initregs(&ireg);
+	ireg.ax = 0x4f02;
+	ireg.bx = vesa_mode;
+	intcall(0x10, &ireg, &oreg);
 
-	if (ax != 0x004f)
+	if (oreg.ax != 0x004f)
 		return -1;
 
 	graphic_mode = is_graphic;
@@ -171,50 +166,45 @@ static int vesa_set_mode(struct mode_info *mode)
 /* Switch DAC to 8-bit mode */
 static void vesa_dac_set_8bits(void)
 {
+	struct biosregs ireg, oreg;
 	u8 dac_size = 6;
 
 	/* If possible, switch the DAC to 8-bit mode */
 	if (vginfo.capabilities & 1) {
-		u16 ax, bx;
-
-		ax = 0x4f08;
-		bx = 0x0800;
-		asm volatile(INT10
-			     : "+a" (ax), "+b" (bx)
-			     : : "ecx", "edx", "esi", "edi");
-
-		if (ax == 0x004f)
-			dac_size = bx >> 8;
+		initregs(&ireg);
+		ireg.ax = 0x4f08;
+		ireg.bh = 0x08;
+		intcall(0x10, &ireg, &oreg);
+		if (oreg.ax == 0x004f)
+			dac_size = oreg.bh;
 	}
 
 	/* Set the color sizes to the DAC size, and offsets to 0 */
-	boot_params.screen_info.red_size = dac_size;
+	boot_params.screen_info.red_size   = dac_size;
 	boot_params.screen_info.green_size = dac_size;
-	boot_params.screen_info.blue_size = dac_size;
-	boot_params.screen_info.rsvd_size = dac_size;
+	boot_params.screen_info.blue_size  = dac_size;
+	boot_params.screen_info.rsvd_size  = dac_size;
 
-	boot_params.screen_info.red_pos = 0;
-	boot_params.screen_info.green_pos = 0;
-	boot_params.screen_info.blue_pos = 0;
-	boot_params.screen_info.rsvd_pos = 0;
+	boot_params.screen_info.red_pos    = 0;
+	boot_params.screen_info.green_pos  = 0;
+	boot_params.screen_info.blue_pos   = 0;
+	boot_params.screen_info.rsvd_pos   = 0;
 }
 
 /* Save the VESA protected mode info */
 static void vesa_store_pm_info(void)
 {
-	u16 ax, bx, di, es;
+	struct biosregs ireg, oreg;
 
-	ax = 0x4f0a;
-	bx = di = 0;
-	asm("pushw %%es; "INT10"; movw %%es,%0; popw %%es"
-	    : "=d" (es), "+a" (ax), "+b" (bx), "+D" (di)
-	    : : "ecx", "esi");
+	initregs(&ireg);
+	ireg.ax = 0x4f0a;
+	intcall(0x10, &ireg, &oreg);
 
-	if (ax != 0x004f)
+	if (oreg.ax != 0x004f)
 		return;
 
-	boot_params.screen_info.vesapm_seg = es;
-	boot_params.screen_info.vesapm_off = di;
+	boot_params.screen_info.vesapm_seg = oreg.es;
+	boot_params.screen_info.vesapm_off = oreg.di;
 }
 
 /*
@@ -252,7 +242,7 @@ static void vesa_store_mode_params_graphics(void)
 void vesa_store_edid(void)
 {
 #ifdef CONFIG_FIRMWARE_EDID
-	u16 ax, bx, cx, dx, di;
+	struct biosregs ireg, oreg;
 
 	/* Apparently used as a nonsense token... */
 	memset(&boot_params.edid_info, 0x13, sizeof boot_params.edid_info);
@@ -260,33 +250,26 @@ void vesa_store_edid(void)
 	if (vginfo.version < 0x0200)
 		return;		/* EDID requires VBE 2.0+ */
 
-	ax = 0x4f15;		/* VBE DDC */
-	bx = 0x0000;		/* Report DDC capabilities */
-	cx = 0;			/* Controller 0 */
-	di = 0;			/* ES:DI must be 0 by spec */
-
-	/* Note: The VBE DDC spec is different from the main VESA spec;
-	   we genuinely have to assume all registers are destroyed here. */
-
-	asm("pushw %%es; movw %2,%%es; "INT10"; popw %%es"
-	    : "+a" (ax), "+b" (bx), "+c" (cx), "+D" (di)
-	    : : "esi", "edx");
+	initregs(&ireg);
+	ireg.ax = 0x4f15;		/* VBE DDC */
+	/* ireg.bx = 0x0000; */		/* Report DDC capabilities */
+	/* ireg.cx = 0;	*/		/* Controller 0 */
+	ireg.es = 0;			/* ES:DI must be 0 by spec */
+	intcall(0x10, &ireg, &oreg);
 
-	if (ax != 0x004f)
+	if (oreg.ax != 0x004f)
 		return;		/* No EDID */
 
 	/* BH = time in seconds to transfer EDD information */
 	/* BL = DDC level supported */
 
-	ax = 0x4f15;		/* VBE DDC */
-	bx = 0x0001;		/* Read EDID */
-	cx = 0;			/* Controller 0 */
-	dx = 0;			/* EDID block number */
-	di =(size_t) &boot_params.edid_info; /* (ES:)Pointer to block */
-	asm(INT10
-	    : "+a" (ax), "+b" (bx), "+d" (dx), "=m" (boot_params.edid_info),
-	      "+c" (cx), "+D" (di)
-	    : : "esi");
+	ireg.ax = 0x4f15;		/* VBE DDC */
+	ireg.bx = 0x0001;		/* Read EDID */
+	/* ireg.cx = 0; */		/* Controller 0 */
+	/* ireg.dx = 0;	*/		/* EDID block number */
+	ireg.es = ds();
+	ireg.di =(size_t)&boot_params.edid_info; /* (ES:)Pointer to block */
+	intcall(0x10, &ireg, &oreg);
 #endif /* CONFIG_FIRMWARE_EDID */
 }
 
diff --git a/arch/x86/boot/video-vga.c b/arch/x86/boot/video-vga.c
index 9e0587a..8f8d827 100644
--- a/arch/x86/boot/video-vga.c
+++ b/arch/x86/boot/video-vga.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -39,30 +40,30 @@ static __videocard video_vga;
 /* Set basic 80x25 mode */
 static u8 vga_set_basic_mode(void)
 {
+	struct biosregs ireg, oreg;
 	u16 ax;
 	u8 rows;
 	u8 mode;
 
+	initregs(&ireg);
+
 #ifdef CONFIG_VIDEO_400_HACK
 	if (adapter >= ADAPTER_VGA) {
-		asm volatile(INT10
-			     : : "a" (0x1202), "b" (0x0030)
-			     : "ecx", "edx", "esi", "edi");
+		ireg.ax = 0x1202;
+		ireg.bx = 0x0030;
+		intcall(0x10, &ireg, NULL);
 	}
 #endif
 
 	ax = 0x0f00;
-	asm volatile(INT10
-		     : "+a" (ax)
-		     : : "ebx", "ecx", "edx", "esi", "edi");
-
-	mode = (u8)ax;
+	intcall(0x10, &ireg, &oreg);
+	mode = oreg.al;
 
 	set_fs(0);
 	rows = rdfs8(0x484);	/* rows minus one */
 
 #ifndef CONFIG_VIDEO_400_HACK
-	if ((ax == 0x5003 || ax == 0x5007) &&
+	if ((oreg.ax == 0x5003 || oreg.ax == 0x5007) &&
 	    (rows == 0 || rows == 24))
 		return mode;
 #endif
@@ -71,10 +72,8 @@ static u8 vga_set_basic_mode(void)
 		mode = 3;
 
 	/* Set the mode */
-	ax = mode;
-	asm volatile(INT10
-		     : "+a" (ax)
-		     : : "ebx", "ecx", "edx", "esi", "edi");
+	ireg.ax = mode;		/* AH=0: set mode */
+	intcall(0x10, &ireg, NULL);
 	do_restore = 1;
 	return mode;
 }
@@ -82,43 +81,69 @@ static u8 vga_set_basic_mode(void)
 static void vga_set_8font(void)
 {
 	/* Set 8x8 font - 80x43 on EGA, 80x50 on VGA */
+	struct biosregs ireg;
+
+	initregs(&ireg);
 
 	/* Set 8x8 font */
-	asm volatile(INT10 : : "a" (0x1112), "b" (0));
+	ireg.ax = 0x1112;
+	/* ireg.bl = 0; */
+	intcall(0x10, &ireg, NULL);
 
 	/* Use alternate print screen */
-	asm volatile(INT10 : : "a" (0x1200), "b" (0x20));
+	ireg.ax = 0x1200;
+	ireg.bl = 0x20;
+	intcall(0x10, &ireg, NULL);
 
 	/* Turn off cursor emulation */
-	asm volatile(INT10 : : "a" (0x1201), "b" (0x34));
+	ireg.ax = 0x1201;
+	ireg.bl = 0x34;
+	intcall(0x10, &ireg, NULL);
 
 	/* Cursor is scan lines 6-7 */
-	asm volatile(INT10 : : "a" (0x0100), "c" (0x0607));
+	ireg.ax = 0x0100;
+	ireg.cx = 0x0607;
+	intcall(0x10, &ireg, NULL);
 }
 
 static void vga_set_14font(void)
 {
 	/* Set 9x14 font - 80x28 on VGA */
+	struct biosregs ireg;
+
+	initregs(&ireg);
 
 	/* Set 9x14 font */
-	asm volatile(INT10 : : "a" (0x1111), "b" (0));
+	ireg.ax = 0x1111;
+	/* ireg.bl = 0; */
+	intcall(0x10, &ireg, NULL);
 
 	/* Turn off cursor emulation */
-	asm volatile(INT10 : : "a" (0x1201), "b" (0x34));
+	ireg.ax = 0x1201;
+	ireg.bl = 0x34;
+	intcall(0x10, &ireg, NULL);
 
 	/* Cursor is scan lines 11-12 */
-	asm volatile(INT10 : : "a" (0x0100), "c" (0x0b0c));
+	ireg.ax = 0x0100;
+	ireg.cx = 0x0b0c;
+	intcall(0x10, &ireg, NULL);
 }
 
 static void vga_set_80x43(void)
 {
 	/* Set 80x43 mode on VGA (not EGA) */
+	struct biosregs ireg;
+
+	initregs(&ireg);
 
 	/* Set 350 scans */
-	asm volatile(INT10 : : "a" (0x1201), "b" (0x30));
+	ireg.ax = 0x1201;
+	ireg.bl = 0x30;
+	intcall(0x10, &ireg, NULL);
 
 	/* Reset video mode */
-	asm volatile(INT10 : : "a" (0x0003));
+	ireg.ax = 0x0003;
+	intcall(0x10, &ireg, NULL);
 
 	vga_set_8font();
 }
@@ -225,8 +250,6 @@ static int vga_set_mode(struct mode_info *mode)
  */
 static int vga_probe(void)
 {
-	u16 ega_bx;
-
 	static const char *card_name[] = {
 		"CGA/MDA/HGC", "EGA", "VGA"
 	};
@@ -240,26 +263,26 @@ static int vga_probe(void)
 		sizeof(ega_modes)/sizeof(struct mode_info),
 		sizeof(vga_modes)/sizeof(struct mode_info),
 	};
-	u8 vga_flag;
 
-	asm(INT10
-	    : "=b" (ega_bx)
-	    : "a" (0x1200), "b" (0x10) /* Check EGA/VGA */
-	    : "ecx", "edx", "esi", "edi");
+	struct biosregs ireg, oreg;
+
+	initregs(&ireg);
+
+	ireg.ax = 0x1200;
+	ireg.bl = 0x10;		/* Check EGA/VGA */
+	intcall(0x10, &ireg, &oreg);
 
 #ifndef _WAKEUP
-	boot_params.screen_info.orig_video_ega_bx = ega_bx;
+	boot_params.screen_info.orig_video_ega_bx = oreg.bx;
 #endif
 
 	/* If we have MDA/CGA/HGC then BL will be unchanged at 0x10 */
-	if ((u8)ega_bx != 0x10) {
+	if (oreg.bl != 0x10) {
 		/* EGA/VGA */
-		asm(INT10
-		    : "=a" (vga_flag)
-		    : "a" (0x1a00)
-		    : "ebx", "ecx", "edx", "esi", "edi");
+		ireg.ax = 0x1a00;
+		intcall(0x10, &ireg, &oreg);
 
-		if (vga_flag == 0x1a) {
+		if (oreg.al == 0x1a) {
 			adapter = ADAPTER_VGA;
 #ifndef _WAKEUP
 			boot_params.screen_info.orig_video_isVGA = 1;
diff --git a/arch/x86/boot/video.c b/arch/x86/boot/video.c
index 3bef2c1..bad728b 100644
--- a/arch/x86/boot/video.c
+++ b/arch/x86/boot/video.c
@@ -2,6 +2,7 @@
  *
  *   Copyright (C) 1991, 1992 Linus Torvalds
  *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2.
@@ -18,33 +19,29 @@
 
 static void store_cursor_position(void)
 {
-	u16 curpos;
-	u16 ax, bx;
+	struct biosregs ireg, oreg;
 
-	ax = 0x0300;
-	bx = 0;
-	asm(INT10
-	    : "=d" (curpos), "+a" (ax), "+b" (bx)
-	    : : "ecx", "esi", "edi");
+	initregs(&ireg);
+	ireg.ah = 0x03;
+	intcall(0x10, &ireg, &oreg);
 
-	boot_params.screen_info.orig_x = curpos;
-	boot_params.screen_info.orig_y = curpos >> 8;
+	boot_params.screen_info.orig_x = oreg.dl;
+	boot_params.screen_info.orig_y = oreg.dh;
 }
 
 static void store_video_mode(void)
 {
-	u16 ax, page;
+	struct biosregs ireg, oreg;
 
 	/* N.B.: the saving of the video page here is a bit silly,
 	   since we pretty much assume page 0 everywhere. */
-	ax = 0x0f00;
-	asm(INT10
-	    : "+a" (ax), "=b" (page)
-	    : : "ecx", "edx", "esi", "edi");
+	initregs(&ireg);
+	ireg.ah = 0x0f;
+	intcall(0x10, &ireg, &oreg);
 
 	/* Not all BIOSes are clean with respect to the top bit */
-	boot_params.screen_info.orig_video_mode = ax & 0x7f;
-	boot_params.screen_info.orig_video_page = page >> 8;
+	boot_params.screen_info.orig_video_mode = oreg.al & 0x7f;
+	boot_params.screen_info.orig_video_page = oreg.bh;
 }
 
 /*
@@ -257,7 +254,7 @@ static void restore_screen(void)
 	int y;
 	addr_t dst = 0;
 	u16 *src = saved.data;
-	u16 ax, bx, dx;
+	struct biosregs ireg;
 
 	if (graphic_mode)
 		return;		/* Can't restore onto a graphic mode */
@@ -296,12 +293,11 @@ static void restore_screen(void)
 	}
 
 	/* Restore cursor position */
-	ax = 0x0200;		/* Set cursor position */
-	bx = 0;			/* Page number (<< 8) */
-	dx = (saved.cury << 8)+saved.curx;
-	asm volatile(INT10
-		     : "+a" (ax), "+b" (bx), "+d" (dx)
-		     : : "ecx", "esi", "edi");
+	initregs(&ireg);
+	ireg.ah = 0x02;		/* Set cursor position */
+	ireg.dh = saved.cury;
+	ireg.dl = saved.curx;
+	intcall(0x10, &ireg, NULL);
 }
 #else
 #define save_screen()		((void)0)
diff --git a/arch/x86/boot/video.h b/arch/x86/boot/video.h
index ee63f5d..5bb174a 100644
--- a/arch/x86/boot/video.h
+++ b/arch/x86/boot/video.h
@@ -112,20 +112,6 @@ extern int force_x, force_y;	/* Don't query the BIOS for cols/rows */
 extern int do_restore;		/* Restore screen contents */
 extern int graphic_mode;	/* Graphics mode with linear frame buffer */
 
-/*
- * int $0x10 is notorious for touching registers it shouldn't.
- * gcc doesn't like %ebp being clobbered, so define it as a push/pop
- * sequence here.
- *
- * A number of systems, including the original PC can clobber %bp in
- * certain circumstances, like when scrolling.  There exists at least
- * one Trident video card which could clobber DS under a set of
- * circumstances that we are unlikely to encounter (scrolling when
- * using an extended graphics mode of more than 800x600 pixels), but
- * it's cheap insurance to deal with that here.
- */
-#define INT10 "pushl %%ebp; pushw %%ds; int $0x10; popw %%ds; popl %%ebp"
-
 /* Accessing VGA indexed registers */
 static inline u8 in_idx(u16 port, u8 index)
 {
diff --git a/arch/x86/kernel/acpi/realmode/Makefile b/arch/x86/kernel/acpi/realmode/Makefile
index 1c31cc0..167bc16 100644
--- a/arch/x86/kernel/acpi/realmode/Makefile
+++ b/arch/x86/kernel/acpi/realmode/Makefile
@@ -9,7 +9,7 @@
 always		:= wakeup.bin
 targets		:= wakeup.elf wakeup.lds
 
-wakeup-y	+= wakeup.o wakemain.o video-mode.o copy.o
+wakeup-y	+= wakeup.o wakemain.o video-mode.o copy.o bioscall.o regs.o
 
 # The link order of the video-*.o modules can matter.  In particular,
 # video-vga.o *must* be listed first, followed by video-vesa.o.
diff --git a/arch/x86/kernel/acpi/realmode/bioscall.S b/arch/x86/kernel/acpi/realmode/bioscall.S
new file mode 100644
index 0000000..f51eb0b
--- /dev/null
+++ b/arch/x86/kernel/acpi/realmode/bioscall.S
@@ -0,0 +1 @@
+#include "../../../boot/bioscall.S"
diff --git a/arch/x86/kernel/acpi/realmode/regs.c b/arch/x86/kernel/acpi/realmode/regs.c
new file mode 100644
index 0000000..6206033
--- /dev/null
+++ b/arch/x86/kernel/acpi/realmode/regs.c
@@ -0,0 +1 @@
+#include "../../../boot/regs.c"
