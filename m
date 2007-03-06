Return-Path: <linux-kernel-owner+w=401wt.eu-S934102AbXCFM7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102AbXCFM7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934103AbXCFM7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:59:43 -0500
Received: from ozlabs.org ([203.10.76.45]:56558 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934102AbXCFM7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:59:42 -0500
Subject: [PATCH 5/8] Cleanup GDT access
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <1173185827.4644.34.camel@localhost.localdomain>
References: <1173184747.4644.23.camel@localhost.localdomain>
	 <1173185592.4644.28.camel@localhost.localdomain>
	 <1173185666.4644.30.camel@localhost.localdomain>
	 <1173185734.4644.32.camel@localhost.localdomain>
	 <1173185827.4644.34.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 23:58:29 +1100
Message-Id: <1173185909.4644.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have an explicit per-cpu GDT variable, we don't need to keep
the descriptors around to use them to find the GDT.  Also remove the
cpu_pda() accessor: it's just a per-cpu variable.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r e9d5b8e6f5ee arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c	Tue Mar 06 16:20:48 2007 +1100
+++ b/arch/i386/kernel/cpu/common.c	Tue Mar 06 17:04:37 2007 +1100
@@ -22,11 +22,8 @@
 
 #include "cpu.h"
 
-DEFINE_PER_CPU(struct Xgt_desc_struct, cpu_gdt_descr);
-EXPORT_PER_CPU_SYMBOL(cpu_gdt_descr);
-
 DEFINE_PER_CPU(struct desc_struct, cpu_gdt[GDT_ENTRIES]);
-
+EXPORT_PER_CPU_SYMBOL_GPL(cpu_gdt);
 DEFINE_PER_CPU(struct i386_pda, _cpu_pda);
 EXPORT_PER_CPU_SYMBOL(_cpu_pda);
 
@@ -631,14 +628,11 @@ static inline void set_kernel_fs(void)
    will soon come up. */
 __cpuinit void init_gdt(int cpu, struct task_struct *idle)
 {
-	struct Xgt_desc_struct *cpu_gdt_descr = &per_cpu(cpu_gdt_descr, cpu);
 	struct desc_struct *gdt = per_cpu(cpu_gdt, cpu);
 	struct i386_pda *pda = &per_cpu(_cpu_pda, cpu);
 
+	/* Based on boot_gdt_table: set PDA so it can be used immediately */
  	memcpy(gdt, boot_gdt_table, GDT_SIZE);
- 	cpu_gdt_descr->address = (unsigned long)gdt;
-	cpu_gdt_descr->size = GDT_SIZE - 1;
-
 	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PDA].a,
 			(u32 *)&gdt[GDT_ENTRY_PDA].b,
 			(unsigned long)pda, sizeof(*pda) - 1,
@@ -653,9 +647,12 @@ __cpuinit void init_gdt(int cpu, struct 
 /* Move this CPU from boot_gdt_table & boot_pda to this cpu's proper one. */
 void __cpuinit cpu_set_gdt(int cpu)
 {
-	struct Xgt_desc_struct *cpu_gdt_descr = &per_cpu(cpu_gdt_descr, cpu);
-
-	load_gdt(cpu_gdt_descr);
+	struct Xgt_desc_struct gdt_descr;
+
+ 	gdt_descr.address = (unsigned long)per_cpu(cpu_gdt, cpu);
+	gdt_descr.size = GDT_SIZE - 1;
+
+	load_gdt(&gdt_descr);
 	set_kernel_fs();
 }
 
diff -r e9d5b8e6f5ee arch/i386/kernel/efi.c
--- a/arch/i386/kernel/efi.c	Tue Mar 06 16:20:48 2007 +1100
+++ b/arch/i386/kernel/efi.c	Tue Mar 06 17:05:41 2007 +1100
@@ -69,12 +69,10 @@ static void efi_call_phys_prelog(void) _
 {
 	unsigned long cr4;
 	unsigned long temp;
-	struct Xgt_desc_struct *cpu_gdt_descr;
+	struct Xgt_desc_struct gdt_descr;
 
 	spin_lock(&efi_rt_lock);
 	local_irq_save(efi_rt_eflags);
-
-	cpu_gdt_descr = &per_cpu(cpu_gdt_descr, 0);
 
 	/*
 	 * If I don't have PSE, I should just duplicate two entries in page
@@ -105,17 +103,19 @@ static void efi_call_phys_prelog(void) _
 	 */
 	local_flush_tlb();
 
-	cpu_gdt_descr->address = __pa(cpu_gdt_descr->address);
-	load_gdt(cpu_gdt_descr);
+	gdt_descr.address = __pa(get_cpu_gdt_table(0));
+	gdt_descr.size = GDT_SIZE - 1;
+	load_gdt(&gdt_descr);
 }
 
 static void efi_call_phys_epilog(void) __releases(efi_rt_lock)
 {
 	unsigned long cr4;
-	struct Xgt_desc_struct *cpu_gdt_descr = &per_cpu(cpu_gdt_descr, 0);
-
-	cpu_gdt_descr->address = (unsigned long)__va(cpu_gdt_descr->address);
-	load_gdt(cpu_gdt_descr);
+	struct Xgt_desc_struct gdt_descr;
+
+	gdt_descr.address = (unsigned long)get_cpu_gdt_table(0);
+	gdt_descr.size = GDT_SIZE - 1;
+	load_gdt(&gdt_descr);
 
 	cr4 = read_cr4();
 
diff -r e9d5b8e6f5ee arch/i386/kernel/entry.S
--- a/arch/i386/kernel/entry.S	Tue Mar 06 16:20:48 2007 +1100
+++ b/arch/i386/kernel/entry.S	Tue Mar 06 17:04:37 2007 +1100
@@ -561,8 +561,7 @@ END(syscall_badsys)
 #define FIXUP_ESPFIX_STACK \
 	/* since we are on a wrong stack, we cant make it a C code :( */ \
 	movl %fs:PDA_cpu, %ebx; \
-	PER_CPU(cpu_gdt_descr, %ebx); \
-	movl GDS_address(%ebx), %ebx; \
+	PER_CPU(cpu_gdt, %ebx); \
 	GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah); \
 	addl %esp, %eax; \
 	pushl $__KERNEL_DS; \
diff -r e9d5b8e6f5ee arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c	Tue Mar 06 16:20:48 2007 +1100
+++ b/arch/i386/kernel/traps.c	Tue Mar 06 17:04:37 2007 +1100
@@ -1018,9 +1018,7 @@ fastcall unsigned long patch_espfix_desc
 fastcall unsigned long patch_espfix_desc(unsigned long uesp,
 					  unsigned long kesp)
 {
-	int cpu = smp_processor_id();
-	struct Xgt_desc_struct *cpu_gdt_descr = &per_cpu(cpu_gdt_descr, cpu);
-	struct desc_struct *gdt = (struct desc_struct *)cpu_gdt_descr->address;
+	struct desc_struct *gdt = __get_cpu_var(cpu_gdt);
 	unsigned long base = (kesp - uesp) & -THREAD_SIZE;
 	unsigned long new_kesp = kesp - base;
 	unsigned long lim_pages = (new_kesp | (THREAD_SIZE - 1)) >> PAGE_SHIFT;
diff -r e9d5b8e6f5ee include/asm-i386/desc.h
--- a/include/asm-i386/desc.h	Tue Mar 06 16:20:48 2007 +1100
+++ b/include/asm-i386/desc.h	Tue Mar 06 17:04:37 2007 +1100
@@ -13,6 +13,7 @@
 #include <asm/mmu.h>
 
 extern struct desc_struct boot_gdt_table[GDT_ENTRIES];
+DECLARE_PER_CPU(struct desc_struct, cpu_gdt[GDT_ENTRIES]);
 
 struct Xgt_desc_struct {
 	unsigned short size;
@@ -21,13 +22,9 @@ struct Xgt_desc_struct {
 } __attribute__ ((packed));
 
 extern struct Xgt_desc_struct idt_descr;
-DECLARE_PER_CPU(struct Xgt_desc_struct, cpu_gdt_descr);
-DECLARE_PER_CPU(struct desc_struct, cpu_gdt[GDT_ENTRIES]);
-extern struct Xgt_desc_struct early_gdt_descr;
-
 static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
 {
-	return (struct desc_struct *)per_cpu(cpu_gdt_descr, cpu).address;
+	return per_cpu(cpu_gdt, cpu);
 }
 
 extern struct desc_struct idt_table[];
@@ -102,13 +99,12 @@ static inline fastcall void native_set_l
 	if (likely(entries == 0))
 		__asm__ __volatile__("lldt %w0"::"q" (0));
 	else {
-		unsigned cpu = smp_processor_id();
 		__u32 a, b;
 
 		pack_descriptor(&a, &b, (unsigned long)addr,
 				entries * sizeof(struct desc_struct) - 1,
 				DESCTYPE_LDT, 0);
-		write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_LDT, a, b);
+		write_gdt_entry(__get_cpu_var(cpu_gdt), GDT_ENTRY_LDT, a, b);
 		__asm__ __volatile__("lldt %w0"::"q" (GDT_ENTRY_LDT*8));
 	}
 }
diff -r e9d5b8e6f5ee include/asm-i386/pda.h
--- a/include/asm-i386/pda.h	Tue Mar 06 16:20:48 2007 +1100
+++ b/include/asm-i386/pda.h	Tue Mar 06 17:04:26 2007 +1100
@@ -20,8 +20,6 @@ struct i386_pda
 };
 
 DECLARE_PER_CPU(struct i386_pda, _cpu_pda);
-
-#define cpu_pda(i)	(&per_cpu(_cpu_pda, (i)))
 
 #define pda_offset(field) offsetof(struct i386_pda, field)
 


