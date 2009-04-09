Return-Path: <linux-kernel-owner+w=401wt.eu-S937261AbZDIXO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937261AbZDIXO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937117AbZDIXNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:13:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:54266 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937233AbZDIXNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:13:43 -0400
Date: Thu, 9 Apr 2009 23:12:48 GMT
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, rjw@sisk.pl, hpa@linux.intel.com, pavel@ucw.cz
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com, rjw@sisk.pl, pavel@ucw.cz
In-Reply-To: <49DE7F79.4030106@zytor.com>
References: <49DE7F79.4030106@zytor.com>
Subject: [tip:x86/setup] x86, setup: "glove box" BIOS calls -- infrastructure
Message-ID: <tip-7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac@git.kernel.org>
Git-Commit-ID: 7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 23:12:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac
Gitweb:     http://git.kernel.org/tip/7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 1 Apr 2009 18:08:28 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 9 Apr 2009 16:08:11 -0700

x86, setup: "glove box" BIOS calls -- infrastructure

Impact: new interfaces (not yet used)

For all the platforms out there, there is an infinite number of buggy
BIOSes.  This adds infrastructure to treat BIOS interrupts more like
toxic waste and "glove box" them -- we switch out the register set,
perform the BIOS interrupt, and then restore the previous state.

LKML-Reference: <49DE7F79.4030106@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>


---
 arch/x86/boot/Makefile                   |    5 +-
 arch/x86/boot/bioscall.S                 |   82 ++++++++++++++++++++++++++++++
 arch/x86/boot/boot.h                     |   48 +++++++++++++++++
 arch/x86/boot/header.S                   |    2 +-
 arch/x86/boot/regs.c                     |   29 +++++++++++
 arch/x86/boot/setup.ld                   |    6 ++
 arch/x86/kernel/acpi/realmode/Makefile   |    2 +-
 arch/x86/kernel/acpi/realmode/bioscall.S |    1 +
 arch/x86/kernel/acpi/realmode/regs.c     |    1 +
 9 files changed, 172 insertions(+), 4 deletions(-)

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
diff --git a/arch/x86/boot/bioscall.S b/arch/x86/boot/bioscall.S
new file mode 100644
index 0000000..22b4b3e
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
+ * touching memory they shouldn't be.
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
