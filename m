Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbXD2K43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbXD2K43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXD2Kxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:53:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbXD2KxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:24 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Sebastien Dugue <sebastien.dugue@bull.net>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [33/48] i386: Rename boot_gdt_table to boot_gdt
Message-Id: <20070429105322.D847515108@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sebastien Dugue <sebastien.dugue@bull.net>

Rename boot_gdt_table to boot_gdt to avoid the duplicate T(able).

Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/head.S       |    9 ++++-----
 arch/i386/kernel/trampoline.S |   12 ++++++------
 2 files changed, 10 insertions(+), 11 deletions(-)

Index: linux/arch/i386/kernel/head.S
===================================================================
--- linux.orig/arch/i386/kernel/head.S
+++ linux/arch/i386/kernel/head.S
@@ -147,8 +147,7 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 /*
  * Non-boot CPU entry point; entered from trampoline.S
  * We can't lgdt here, because lgdt itself uses a data segment, but
- * we know the trampoline has already loaded the boot_gdt_table GDT
- * for us.
+ * we know the trampoline has already loaded the boot_gdt for us.
  *
  * If cpu hotplug is not supported then this code can go in init section
  * which will be freed later
@@ -588,7 +587,7 @@ fault_msg:
 	.word 0				# 32 bit align gdt_desc.address
 boot_gdt_descr:
 	.word __BOOT_DS+7
-	.long boot_gdt_table - __PAGE_OFFSET
+	.long boot_gdt - __PAGE_OFFSET
 
 	.word 0				# 32-bit align idt_desc.address
 idt_descr:
@@ -602,11 +601,11 @@ ENTRY(early_gdt_descr)
 	.long per_cpu__cpu_gdt		/* Overwritten for secondary CPUs */
 
 /*
- * The boot_gdt_table must mirror the equivalent in setup.S and is
+ * The boot_gdt must mirror the equivalent in setup.S and is
  * used only for booting.
  */
 	.align L1_CACHE_BYTES
-ENTRY(boot_gdt_table)
+ENTRY(boot_gdt)
 	.fill GDT_ENTRY_BOOT_CS,8,0
 	.quad 0x00cf9a000000ffff	/* kernel 4GB code at 0x00000000 */
 	.quad 0x00cf92000000ffff	/* kernel 4GB data at 0x00000000 */
Index: linux/arch/i386/kernel/trampoline.S
===================================================================
--- linux.orig/arch/i386/kernel/trampoline.S
+++ linux/arch/i386/kernel/trampoline.S
@@ -29,7 +29,7 @@
  *
  *	TYPE              VALUE
  *	R_386_32          startup_32_smp
- *	R_386_32          boot_gdt_table
+ *	R_386_32          boot_gdt
  */
 
 #include <linux/linkage.h>
@@ -62,8 +62,8 @@ r_base = .
 	 * to 32 bit.
 	 */
 
-	lidtl	boot_idt - r_base	# load idt with 0, 0
-	lgdtl	boot_gdt - r_base	# load gdt with whatever is appropriate
+	lidtl	boot_idt_descr - r_base	# load idt with 0, 0
+	lgdtl	boot_gdt_descr - r_base	# load gdt with whatever is appropriate
 
 	xor	%ax, %ax
 	inc	%ax		# protected mode (PE) bit
@@ -73,11 +73,11 @@ r_base = .
 
 	# These need to be in the same 64K segment as the above;
 	# hence we don't use the boot_gdt_descr defined in head.S
-boot_gdt:
+boot_gdt_descr:
 	.word	__BOOT_DS + 7			# gdt limit
-	.long	boot_gdt_table-__PAGE_OFFSET	# gdt base
+	.long	boot_gdt - __PAGE_OFFSET	# gdt base
 
-boot_idt:
+boot_idt_descr:
 	.word	0				# idt limit = 0
 	.long	0				# idt base = 0L
 
