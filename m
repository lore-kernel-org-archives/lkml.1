Return-Path: <linux-kernel-owner+w=401wt.eu-S933872AbXCFMyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872AbXCFMyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933875AbXCFMyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:54:45 -0500
Received: from ozlabs.org ([203.10.76.45]:56215 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933872AbXCFMyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:54:44 -0500
Subject: [PATCH 1/8] Remove cpu_gdt_table: use boot_gdt_table until
	migration to per-cpu
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <1173184747.4644.23.camel@localhost.localdomain>
References: <1173184747.4644.23.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 23:53:12 +1100
Message-Id: <1173185592.4644.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux uses three GDTs to boot: the boot_gdt_table, which contains only
the __BOOT_CS and __BOOT_DS entries is used first up, before kernel is
mapped at PAGE_OFFSET.  Then we transition to cpu_gdt_table during
boot, and finally we allocate a per-cpu GDT and switch to that.

We can simplify this by using the boot_gdt_table until switching to
the per-cpu GDT table.  As a bonus, this gets rid of the
horribly-named "cpu_gdt_table" (it's not per-cpu, and the T in GDT
already stands for table).

Finally, some old bogus comments are deleted.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 9cf03cbf8bde arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c	Thu Mar 01 16:40:41 2007 +1100
+++ b/arch/i386/kernel/cpu/common.c	Thu Mar 01 21:58:16 2007 +1100
@@ -694,7 +694,7 @@ __cpuinit int init_gdt(int cpu, struct t
 	 * Initialize the per-CPU GDT with the boot GDT,
 	 * and set up the GDT descriptor:
 	 */
- 	memcpy(gdt, cpu_gdt_table, GDT_SIZE);
+ 	memcpy(gdt, boot_gdt_table, GDT_SIZE);
 	cpu_gdt_descr->size = GDT_SIZE - 1;
 
 	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PDA].a,
diff -r 9cf03cbf8bde arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S	Thu Mar 01 16:40:41 2007 +1100
+++ b/arch/i386/kernel/head.S	Thu Mar 01 22:05:37 2007 +1100
@@ -595,31 +595,19 @@ idt_descr:
 	.word IDT_ENTRIES*8-1		# idt contains 256 entries
 	.long idt_table
 
-# boot GDT descriptor (later on used by CPU#0):
+# The boot GDT descriptor once paging is enabled.
 	.word 0				# 32 bit align gdt_desc.address
 ENTRY(early_gdt_descr)
 	.word GDT_ENTRIES*8-1
-	.long cpu_gdt_table
-
-/*
- * The boot_gdt_table must mirror the equivalent in setup.S and is
- * used only for booting.
- */
+	.long boot_gdt_table
+
+/* The boot Global Descriptor Table: after boot we allocate a per-cpu copy */
 	.align L1_CACHE_BYTES
 ENTRY(boot_gdt_table)
-	.fill GDT_ENTRY_BOOT_CS,8,0
-	.quad 0x00cf9a000000ffff	/* kernel 4GB code at 0x00000000 */
-	.quad 0x00cf92000000ffff	/* kernel 4GB data at 0x00000000 */
-
-/*
- * The Global Descriptor Table contains 28 quadwords, per-CPU.
- */
-	.align L1_CACHE_BYTES
-ENTRY(cpu_gdt_table)
 	.quad 0x0000000000000000	/* NULL descriptor */
 	.quad 0x0000000000000000	/* 0x0b reserved */
-	.quad 0x0000000000000000	/* 0x13 reserved */
-	.quad 0x0000000000000000	/* 0x1b reserved */
+	.quad 0x00cf9a000000ffff	/* boot: 4GB code at 0x00000000 */
+	.quad 0x00cf92000000ffff	/* boot: 4GB data at 0x00000000 */
 	.quad 0x0000000000000000	/* 0x20 unused */
 	.quad 0x0000000000000000	/* 0x28 unused */
 	.quad 0x0000000000000000	/* 0x33 TLS entry 1 */
diff -r 9cf03cbf8bde include/asm-i386/desc.h
--- a/include/asm-i386/desc.h	Thu Mar 01 16:40:41 2007 +1100
+++ b/include/asm-i386/desc.h	Thu Mar 01 21:57:37 2007 +1100
@@ -12,7 +12,7 @@
 
 #include <asm/mmu.h>
 
-extern struct desc_struct cpu_gdt_table[GDT_ENTRIES];
+extern struct desc_struct boot_gdt_table[GDT_ENTRIES];
 
 struct Xgt_desc_struct {
 	unsigned short size;


