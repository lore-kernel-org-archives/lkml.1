Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbXD3K2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbXD3K2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbXD3K23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:28:29 -0400
Received: from mail.suse.de ([195.135.220.2]:51217 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965158AbXD3K17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:27:59 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [24/40] i386: Page-align the GDT
Message-Id: <20070430102758.5941C151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:27:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Xen wants a dedicated page for the GDT.  I believe VMI likes it too.
lguest, KVM and native don't care.

Simple transformation to page-aligned "struct gdt_page".

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/kernel/cpu/common.c |    6 +++---
 arch/i386/kernel/entry.S      |    2 +-
 arch/i386/kernel/head.S       |    2 +-
 arch/i386/kernel/traps.c      |    2 +-
 include/asm-i386/desc.h       |    9 +++++++--
 5 files changed, 13 insertions(+), 8 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/common.c
+++ linux/arch/i386/kernel/cpu/common.c
@@ -22,7 +22,7 @@
 
 #include "cpu.h"
 
-DEFINE_PER_CPU(struct desc_struct, cpu_gdt[GDT_ENTRIES]) = {
+DEFINE_PER_CPU(struct gdt_page, gdt_page) = { .gdt = {
 	[GDT_ENTRY_KERNEL_CS] = { 0x0000ffff, 0x00cf9a00 },
 	[GDT_ENTRY_KERNEL_DS] = { 0x0000ffff, 0x00cf9200 },
 	[GDT_ENTRY_DEFAULT_USER_CS] = { 0x0000ffff, 0x00cffa00 },
@@ -48,8 +48,8 @@ DEFINE_PER_CPU(struct desc_struct, cpu_g
 
 	[GDT_ENTRY_ESPFIX_SS] = { 0x00000000, 0x00c09200 },
 	[GDT_ENTRY_PDA] = { 0x00000000, 0x00c09200 }, /* set in setup_pda */
-};
-EXPORT_PER_CPU_SYMBOL_GPL(cpu_gdt);
+} };
+EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
 DEFINE_PER_CPU(struct i386_pda, _cpu_pda);
 EXPORT_PER_CPU_SYMBOL(_cpu_pda);
Index: linux/arch/i386/kernel/entry.S
===================================================================
--- linux.orig/arch/i386/kernel/entry.S
+++ linux/arch/i386/kernel/entry.S
@@ -557,7 +557,7 @@ END(syscall_badsys)
 #define FIXUP_ESPFIX_STACK \
 	/* since we are on a wrong stack, we cant make it a C code :( */ \
 	movl %fs:PDA_cpu, %ebx; \
-	PER_CPU(cpu_gdt, %ebx); \
+	PER_CPU(gdt_page, %ebx); \
 	GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah); \
 	addl %esp, %eax; \
 	pushl $__KERNEL_DS; \
Index: linux/arch/i386/kernel/head.S
===================================================================
--- linux.orig/arch/i386/kernel/head.S
+++ linux/arch/i386/kernel/head.S
@@ -598,7 +598,7 @@ idt_descr:
 	.word 0				# 32 bit align gdt_desc.address
 ENTRY(early_gdt_descr)
 	.word GDT_ENTRIES*8-1
-	.long per_cpu__cpu_gdt		/* Overwritten for secondary CPUs */
+	.long per_cpu__gdt_page		/* Overwritten for secondary CPUs */
 
 /*
  * The boot_gdt must mirror the equivalent in setup.S and is
Index: linux/arch/i386/kernel/traps.c
===================================================================
--- linux.orig/arch/i386/kernel/traps.c
+++ linux/arch/i386/kernel/traps.c
@@ -1030,7 +1030,7 @@ fastcall void do_spurious_interrupt_bug(
 fastcall unsigned long patch_espfix_desc(unsigned long uesp,
 					  unsigned long kesp)
 {
-	struct desc_struct *gdt = __get_cpu_var(cpu_gdt);
+	struct desc_struct *gdt = __get_cpu_var(gdt_page).gdt;
 	unsigned long base = (kesp - uesp) & -THREAD_SIZE;
 	unsigned long new_kesp = kesp - base;
 	unsigned long lim_pages = (new_kesp | (THREAD_SIZE - 1)) >> PAGE_SHIFT;
Index: linux/include/asm-i386/desc.h
===================================================================
--- linux.orig/include/asm-i386/desc.h
+++ linux/include/asm-i386/desc.h
@@ -18,10 +18,15 @@ struct Xgt_desc_struct {
 	unsigned short pad;
 } __attribute__ ((packed));
 
-DECLARE_PER_CPU(struct desc_struct, cpu_gdt[GDT_ENTRIES]);
+struct gdt_page
+{
+	struct desc_struct gdt[GDT_ENTRIES];
+} __attribute__((aligned(PAGE_SIZE)));
+DECLARE_PER_CPU(struct gdt_page, gdt_page);
+
 static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
 {
-	return per_cpu(cpu_gdt, cpu);
+	return per_cpu(gdt_page, cpu).gdt;
 }
 
 extern struct Xgt_desc_struct idt_descr;
