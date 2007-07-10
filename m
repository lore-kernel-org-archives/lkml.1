Return-Path: <linux-kernel-owner+w=401wt.eu-S1761691AbXGJDsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761691AbXGJDsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbXGJDsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:48:14 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35704 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbXGJDsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:48:12 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 28/33] Code for actual protected-mode entry
Date: Mon,  9 Jul 2007 19:52:07 -0700
Message-Id: <11840388782627-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840387733386-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com>
 <11840361432207-git-send-email-hpa@zytor.com>
 <11840362483663-git-send-email-hpa@zytor.com>
 <11840363531039-git-send-email-hpa@zytor.com>
 <11840364593068-git-send-email-hpa@zytor.com>
 <1184036564610-git-send-email-hpa@zytor.com>
 <11840366692770-git-send-email-hpa@zytor.com>
 <11840367741994-git-send-email-hpa@zytor.com>
 <11840368791603-git-send-email-hpa@zytor.com>
 <11840369841576-git-send-email-hpa@zytor.com>
 <11840370903975-git-send-email-hpa@zytor.com>
 <11840371953778-git-send-email-hpa@zytor.com>
 <11840373002601-git-send-email-hpa@zytor.com>
 <11840374052662-git-send-email-hpa@zytor.com>
 <1184037510289-git-send-email-hpa@zytor.com>
 <11840376162370-git-send-email-hpa@zytor.com>
 <11840377211519-git-send-email-hpa@zytor.com>
 <11840378261081-git-send-email-hpa@zytor.com>
 <11840379311574-git-send-email-hpa@zytor.com>
 <11840380363720-git-send-email-hpa@zytor.com>
 <11840381413065-git-send-email-hpa@zytor.com>
 <11840382473923-git-send-email-hpa@zytor.com>
 <11840383522914-git-send-email-hpa@zytor.com>
 <1184038457733-git-send-email-hpa@zytor.com>
 <1184038562864-git-send-email-hpa@zytor.com>
 <11840386682120-git-send-email-hpa@zytor.com>
 <11840387733386-git-send-email-hpa@zytor.com>
Message-Id: <ae628cbaed0874c2c552ddbd77d61340438f9820.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
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
index 0000000..4deb298
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
+	syssize = boot_params.hdr.syssize; /* Size in 16-byte paragraps */
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

