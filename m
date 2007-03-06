Return-Path: <linux-kernel-owner+w=401wt.eu-S933877AbXCFNC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877AbXCFNC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933285AbXCFNC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:02:59 -0500
Received: from ozlabs.org ([203.10.76.45]:56641 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933877AbXCFNC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:02:58 -0500
Subject: [PATCH 7/8] Page-align the GDT
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <1173186021.4644.38.camel@localhost.localdomain>
References: <1173184747.4644.23.camel@localhost.localdomain>
	 <1173185592.4644.28.camel@localhost.localdomain>
	 <1173185666.4644.30.camel@localhost.localdomain>
	 <1173185734.4644.32.camel@localhost.localdomain>
	 <1173185827.4644.34.camel@localhost.localdomain>
	 <1173185909.4644.36.camel@localhost.localdomain>
	 <1173186021.4644.38.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 00:01:47 +1100
Message-Id: <1173186107.4644.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xen wants a dedicated page for the GDT.  I believe VMI likes it too.
lguest, KVM and native don't care.

Simple transformation to page-aligned "struct gdt_page".

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 576929b5b43f arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c	Tue Mar 06 16:28:38 2007 +1100
+++ b/arch/i386/kernel/cpu/common.c	Tue Mar 06 16:47:11 2007 +1100
@@ -22,8 +22,8 @@
 
 #include "cpu.h"
 
-DEFINE_PER_CPU(struct desc_struct, cpu_gdt[GDT_ENTRIES]);
-EXPORT_PER_CPU_SYMBOL_GPL(cpu_gdt);
+DEFINE_PER_CPU(struct gdt_page, gdt_page);
+EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 DEFINE_PER_CPU(struct i386_pda, _cpu_pda);
 EXPORT_PER_CPU_SYMBOL(_cpu_pda);
 
@@ -628,7 +628,7 @@ static inline void set_kernel_fs(void)
    will soon come up. */
 __cpuinit void init_gdt(int cpu, struct task_struct *idle)
 {
-	struct desc_struct *gdt = per_cpu(cpu_gdt, cpu);
+	struct desc_struct *gdt = per_cpu(gdt_page, cpu).gdt;
 	struct i386_pda *pda = &per_cpu(_cpu_pda, cpu);
 
 	/* Based on boot_gdt_table: set PDA so it can be used immediately */
@@ -649,7 +649,7 @@ void __cpuinit cpu_set_gdt(int cpu)
 {
 	struct Xgt_desc_struct gdt_descr;
 
- 	gdt_descr.address = (unsigned long)per_cpu(cpu_gdt, cpu);
+ 	gdt_descr.address = (unsigned long)per_cpu(gdt_page, cpu).gdt;
 	gdt_descr.size = GDT_SIZE - 1;
 
 	load_gdt(&gdt_descr);
diff -r 576929b5b43f arch/i386/kernel/entry.S
--- a/arch/i386/kernel/entry.S	Tue Mar 06 16:28:38 2007 +1100
+++ b/arch/i386/kernel/entry.S	Tue Mar 06 16:47:11 2007 +1100
@@ -561,7 +561,7 @@ END(syscall_badsys)
 #define FIXUP_ESPFIX_STACK \
 	/* since we are on a wrong stack, we cant make it a C code :( */ \
 	movl %fs:PDA_cpu, %ebx; \
-	PER_CPU(cpu_gdt, %ebx); \
+	PER_CPU(gdt_page, %ebx); \
 	GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah); \
 	addl %esp, %eax; \
 	pushl $__KERNEL_DS; \
diff -r 576929b5b43f arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S	Tue Mar 06 16:28:38 2007 +1100
+++ b/arch/i386/kernel/head.S	Tue Mar 06 16:47:11 2007 +1100
@@ -592,7 +592,7 @@ ENTRY(early_gdt_descr)
 	.long boot_gdt_table
 
 /* The boot Global Descriptor Table: after boot we allocate a per-cpu copy */
-	.align L1_CACHE_BYTES
+	.p2align PAGE_SHIFT
 ENTRY(boot_gdt_table)
 	.quad 0x0000000000000000	/* NULL descriptor */
 	.quad 0x0000000000000000	/* 0x0b reserved */
diff -r 576929b5b43f arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c	Tue Mar 06 16:28:38 2007 +1100
+++ b/arch/i386/kernel/traps.c	Tue Mar 06 16:28:40 2007 +1100
@@ -1018,7 +1018,7 @@ fastcall unsigned long patch_espfix_desc
 fastcall unsigned long patch_espfix_desc(unsigned long uesp,
 					  unsigned long kesp)
 {
-	struct desc_struct *gdt = __get_cpu_var(cpu_gdt);
+	struct desc_struct *gdt = __get_cpu_var(gdt_page).gdt;
 	unsigned long base = (kesp - uesp) & -THREAD_SIZE;
 	unsigned long new_kesp = kesp - base;
 	unsigned long lim_pages = (new_kesp | (THREAD_SIZE - 1)) >> PAGE_SHIFT;
diff -r 576929b5b43f include/asm-i386/desc.h
--- a/include/asm-i386/desc.h	Tue Mar 06 16:28:38 2007 +1100
+++ b/include/asm-i386/desc.h	Tue Mar 06 16:47:22 2007 +1100
@@ -13,7 +13,11 @@
 #include <asm/mmu.h>
 
 extern struct desc_struct boot_gdt_table[GDT_ENTRIES];
-DECLARE_PER_CPU(struct desc_struct, cpu_gdt[GDT_ENTRIES]);
+struct gdt_page
+{
+	struct desc_struct gdt[GDT_ENTRIES];
+} __attribute__((aligned(PAGE_SIZE)));
+DECLARE_PER_CPU(struct gdt_page, gdt_page);
 
 struct Xgt_desc_struct {
 	unsigned short size;
@@ -24,7 +28,7 @@ extern struct Xgt_desc_struct idt_descr;
 extern struct Xgt_desc_struct idt_descr;
 static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
 {
-	return per_cpu(cpu_gdt, cpu);
+	return per_cpu(gdt_page, cpu).gdt;
 }
 
 extern struct desc_struct idt_table[];
@@ -104,7 +108,8 @@ static inline fastcall void native_set_l
 		pack_descriptor(&a, &b, (unsigned long)addr,
 				entries * sizeof(struct desc_struct) - 1,
 				DESCTYPE_LDT, 0);
-		write_gdt_entry(__get_cpu_var(cpu_gdt), GDT_ENTRY_LDT, a, b);
+		write_gdt_entry(__get_cpu_var(gdt_page).gdt, GDT_ENTRY_LDT,
+				a, b);
 		__asm__ __volatile__("lldt %w0"::"q" (GDT_ENTRY_LDT*8));
 	}
 }


