Return-Path: <linux-kernel-owner+w=401wt.eu-S933834AbXGKTdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834AbXGKTdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765847AbXGKTUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:20:09 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38293 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763945AbXGKTTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:44 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 28/33] Code for actual protected-mode entry
Date: Wed, 11 Jul 2007 12:18:53 -0700
Message-Id: <11841815433948-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184181543569-git-send-email-hpa@zytor.com>
References: <1184181538674-git-send-email-hpa@zytor.com>
 <118418153862-git-send-email-hpa@zytor.com>
 <11841815382283-git-send-email-hpa@zytor.com>
 <11841815392122-git-send-email-hpa@zytor.com>
 <11841815393975-git-send-email-hpa@zytor.com>
 <11841815393014-git-send-email-hpa@zytor.com>
 <1184181539416-git-send-email-hpa@zytor.com>
 <118418153972-git-send-email-hpa@zytor.com>
 <11841815391923-git-send-email-hpa@zytor.com>
 <11841815403678-git-send-email-hpa@zytor.com>
 <11841815403041-git-send-email-hpa@zytor.com>
 <11841815402349-git-send-email-hpa@zytor.com>
 <11841815401013-git-send-email-hpa@zytor.com>
 <1184181540369-git-send-email-hpa@zytor.com>
 <11841815401476-git-send-email-hpa@zytor.com>
 <11841815411443-git-send-email-hpa@zytor.com>
 <1184181541746-git-send-email-hpa@zytor.com>
 <11841815411436-git-send-email-hpa@zytor.com>
 <11841815412873-git-send-email-hpa@zytor.com>
 <11841815412175-git-send-email-hpa@zytor.com>
 <1184181541492-git-send-email-hpa@zytor.com>
 <11841815421028-git-send-email-hpa@zytor.com>
 <118418154292-git-send-email-hpa@zytor.com>
 <11841815421819-git-send-email-hpa@zytor.com>
 <11841815423652-git-send-email-hpa@zytor.com>
 <11841815422973-git-send-email-hpa@zytor.com>
 <11841815423976-git-send-email-hpa@zytor.com>
 <1184181543569-git-send-email-hpa@zytor.com>
Message-Id: <43b8a8153855d9af17029fcfcadebd8d4b14b7c4.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

This is the code which actually does the switch to protected mode,
including all preparation.  It is also responsible for invoking the
boot loader hooks, if present.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/pm.c     |  170 +++++++++++++++++++++++++++++++++++++++++++++++
 arch/i386/boot/pmjump.S |   54 +++++++++++++++
 2 files changed, 224 insertions(+), 0 deletions(-)
 create mode 100644 arch/i386/boot/pm.c
 create mode 100644 arch/i386/boot/pmjump.S

diff --git a/arch/i386/boot/pm.c b/arch/i386/boot/pm.c
new file mode 100644
index 0000000..3fa53e1
--- /dev/null
+++ b/arch/i386/boot/pm.c
@@ -0,0 +1,170 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright (C) 1991, 1992 Linus Torvalds
+ *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * arch/i386/boot/pm.c
+ *
+ * Prepare the machine for transition to protected mode.
+ */
+
+#include "boot.h"
+#include <asm/segment.h>
+
+/*
+ * Invoke the realmode switch hook if present; otherwise
+ * disable all interrupts.
+ */
+static void realmode_switch_hook(void)
+{
+	if (boot_params.hdr.realmode_swtch) {
+		asm volatile("lcallw *%0"
+			     : : "m" (boot_params.hdr.realmode_swtch)
+			     : "eax", "ebx", "ecx", "edx");
+	} else {
+		asm volatile("cli");
+		outb(0x80, 0x70); /* Disable NMI */
+		io_delay();
+	}
+}
+
+/*
+ * A zImage kernel is loaded at 0x10000 but wants to run at 0x1000.
+ * A bzImage kernel is loaded and runs at 0x100000.
+ */
+static void move_kernel_around(void)
+{
+	/* Note: rely on the compile-time option here rather than
+	   the LOADED_HIGH flag.  The Qemu kernel loader unconditionally
+	   sets the loadflags to zero. */
+#ifndef __BIG_KERNEL__
+	u16 dst_seg, src_seg;
+	u32 syssize;
+
+	dst_seg =  0x1000 >> 4;
+	src_seg = 0x10000 >> 4;
+	syssize = boot_params.hdr.syssize; /* Size in 16-byte paragraphs */
+
+	while (syssize) {
+		int paras  = (syssize >= 0x1000) ? 0x1000 : syssize;
+		int dwords = paras << 2;
+
+		asm volatile("pushw %%es ; "
+			     "pushw %%ds ; "
+			     "movw %1,%%es ; "
+			     "movw %2,%%ds ; "
+			     "xorw %%di,%%di ; "
+			     "xorw %%si,%%si ; "
+			     "rep;movsl ; "
+			     "popw %%ds ; "
+			     "popw %%es"
+			     : "+c" (dwords)
+			     : "rm" (dst_seg), "rm" (src_seg)
+			     : "esi", "edi");
+
+		syssize -= paras;
+		dst_seg += paras;
+		src_seg += paras;
+	}
+#endif
+}
+
+/*
+ * Disable all interrupts at the legacy PIC.
+ */
+static void mask_all_interrupts(void)
+{
+	outb(0xff, 0xa1);	/* Mask all interrupts on the seconday PIC */
+	io_delay();
+	outb(0xfb, 0x21);	/* Mask all but cascade on the primary PIC */
+	io_delay();
+}
+
+/*
+ * Reset IGNNE# if asserted in the FPU.
+ */
+static void reset_coprocessor(void)
+{
+	outb(0, 0xf0);
+	io_delay();
+	outb(0, 0xf1);
+	io_delay();
+}
+
+/*
+ * Set up the GDT
+ */
+#define GDT_ENTRY(flags,base,limit)		\
+	(((u64)(base & 0xff000000) << 32) |	\
+	 ((u64)flags << 40) |			\
+	 ((u64)(limit & 0x00ff0000) << 32) |	\
+	 ((u64)(base & 0x00ffff00) << 16) |	\
+	 ((u64)(limit & 0x0000ffff)))
+
+struct gdt_ptr {
+	u16 len;
+	u32 ptr;
+} __attribute__((packed));
+
+static void setup_gdt(void)
+{
+	/* There are machines which are known to not boot with the GDT
+	   being 8-byte unaligned.  Intel recommends 16 byte alignment. */
+	static const u64 boot_gdt[] __attribute__((aligned(16))) = {
+		/* CS: code, read/execute, 4 GB, base 0 */
+		[GDT_ENTRY_BOOT_CS] = GDT_ENTRY(0xc09b, 0, 0xfffff),
+		/* DS: data, read/write, 4 GB, base 0 */
+		[GDT_ENTRY_BOOT_DS] = GDT_ENTRY(0xc093, 0, 0xfffff),
+	};
+	struct gdt_ptr gdt;
+
+	gdt.len = sizeof(boot_gdt)-1;
+	gdt.ptr = (u32)&boot_gdt + (ds() << 4);
+
+	asm volatile("lgdtl %0" : : "m" (gdt));
+}
+
+/*
+ * Set up the IDT
+ */
+static void setup_idt(void)
+{
+	static const struct gdt_ptr null_idt = {0, 0};
+	asm volatile("lidtl %0" : : "m" (null_idt));
+}
+
+/*
+ * Actual invocation sequence
+ */
+void go_to_protected_mode(void)
+{
+	/* Hook before leaving real mode, also disables interrupts */
+	realmode_switch_hook();
+
+	/* Move the kernel/setup to their final resting places */
+	move_kernel_around();
+
+	/* Enable the A20 gate */
+	if (enable_a20()) {
+		puts("A20 gate not responding, unable to boot...\n");
+		die();
+	}
+
+	/* Reset coprocessor (IGNNE#) */
+	reset_coprocessor();
+
+	/* Mask all interrupts in the PIC */
+	mask_all_interrupts();
+
+	/* Actual transition to protected mode... */
+	setup_idt();
+	setup_gdt();
+	protected_mode_jump(boot_params.hdr.code32_start,
+			    (u32)&boot_params + (ds() << 4));
+}
diff --git a/arch/i386/boot/pmjump.S b/arch/i386/boot/pmjump.S
new file mode 100644
index 0000000..2e55923
--- /dev/null
+++ b/arch/i386/boot/pmjump.S
@@ -0,0 +1,54 @@
+/* ----------------------------------------------------------------------- *
+ *
+ *   Copyright (C) 1991, 1992 Linus Torvalds
+ *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * arch/i386/boot/pmjump.S
+ *
+ * The actual transition into protected mode
+ */
+
+#include <asm/boot.h>
+#include <asm/segment.h>
+
+	.text
+
+	.globl	protected_mode_jump
+	.type	protected_mode_jump, @function
+
+	.code16
+
+/*
+ * void protected_mode_jump(u32 entrypoint, u32 bootparams);
+ */
+protected_mode_jump:
+	xorl	%ebx, %ebx		# Flag to indicate this is a boot
+	movl	%edx, %esi		# Pointer to boot_params table
+	movl	%eax, 2f		# Patch ljmpl instruction
+	jmp	1f			# Short jump to flush instruction q.
+
+1:
+	movw	$__BOOT_DS, %cx
+
+	movl	%cr0, %edx
+	orb	$1, %dl			# Protected mode (PE) bit
+	movl	%edx, %cr0
+
+	movw	%cx, %ds
+	movw	%cx, %es
+	movw	%cx, %fs
+	movw	%cx, %gs
+	movw	%cx, %ss
+
+	# Jump to the 32-bit entrypoint
+	.byte	0x66, 0xea		# ljmpl opcode
+2:	.long	0			# offset
+	.word	__BOOT_CS		# segment
+
+	.size	protected_mode_jump, .-protected_mode_jump
-- 
1.5.2.2

