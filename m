Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbXD2K4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbXD2K4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbXD2K4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:56:32 -0400
Received: from mx1.suse.de ([195.135.220.2]:52227 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346AbXD2Kxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:40 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [48/48] i386: cleanup GDT Access
Message-Id: <20070429105338.EE118151CB@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>

Now we have an explicit per-cpu GDT variable, we don't need to keep the
descriptors around to use them to find the GDT: expose cpu_gdt directly.

We could go further and make load_gdt() pack the descriptor for us, or even
assume it means "load the current cpu's GDT" which is what it always does.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/common.c |    4 +---
 arch/i386/kernel/efi.c        |   16 ++++++++--------
 arch/i386/kernel/entry.S      |    3 +--
 arch/i386/kernel/smpboot.c    |   12 ++++++------
 arch/i386/kernel/traps.c      |    4 +---
 include/asm-i386/desc.h       |    7 ++-----
 6 files changed, 19 insertions(+), 27 deletions(-)

Index: linux/arch/i386/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/common.c
+++ linux/arch/i386/kernel/cpu/common.c
@@ -22,9 +22,6 @@
 
 #include "cpu.h"
 
-DEFINE_PER_CPU(struct Xgt_desc_struct, cpu_gdt_descr);
-EXPORT_PER_CPU_SYMBOL(cpu_gdt_descr);
-
 DEFINE_PER_CPU(struct desc_struct, cpu_gdt[GDT_ENTRIES]) = {
 	[GDT_ENTRY_KERNEL_CS] = { 0x0000ffff, 0x00cf9a00 },
 	[GDT_ENTRY_KERNEL_DS] = { 0x0000ffff, 0x00cf9200 },
@@ -52,6 +49,7 @@ DEFINE_PER_CPU(struct desc_struct, cpu_g
 	[GDT_ENTRY_ESPFIX_SS] = { 0x00000000, 0x00c09200 },
 	[GDT_ENTRY_PDA] = { 0x00000000, 0x00c09200 }, /* set in setup_pda */
 };
+EXPORT_PER_CPU_SYMBOL_GPL(cpu_gdt);
 
 DEFINE_PER_CPU(struct i386_pda, _cpu_pda);
 EXPORT_PER_CPU_SYMBOL(_cpu_pda);
Index: linux/arch/i386/kernel/efi.c
===================================================================
--- linux.orig/arch/i386/kernel/efi.c
+++ linux/arch/i386/kernel/efi.c
@@ -69,13 +69,11 @@ static void efi_call_phys_prelog(void) _
 {
 	unsigned long cr4;
 	unsigned long temp;
-	struct Xgt_desc_struct *cpu_gdt_descr;
+	struct Xgt_desc_struct gdt_descr;
 
 	spin_lock(&efi_rt_lock);
 	local_irq_save(efi_rt_eflags);
 
-	cpu_gdt_descr = &per_cpu(cpu_gdt_descr, 0);
-
 	/*
 	 * If I don't have PSE, I should just duplicate two entries in page
 	 * directory. If I have PSE, I just need to duplicate one entry in
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
+	struct Xgt_desc_struct gdt_descr;
 
-	cpu_gdt_descr->address = (unsigned long)__va(cpu_gdt_descr->address);
-	load_gdt(cpu_gdt_descr);
+	gdt_descr.address = (unsigned long)get_cpu_gdt_table(0);
+	gdt_descr.size = GDT_SIZE - 1;
+	load_gdt(&gdt_descr);
 
 	cr4 = read_cr4();
 
Index: linux/arch/i386/kernel/entry.S
===================================================================
--- linux.orig/arch/i386/kernel/entry.S
+++ linux/arch/i386/kernel/entry.S
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
Index: linux/arch/i386/kernel/smpboot.c
===================================================================
--- linux.orig/arch/i386/kernel/smpboot.c
+++ linux/arch/i386/kernel/smpboot.c
@@ -786,13 +786,9 @@ static inline struct task_struct * alloc
    secondary which will soon come up. */
 static __cpuinit void init_gdt(int cpu, struct task_struct *idle)
 {
-	struct Xgt_desc_struct *cpu_gdt_descr = &per_cpu(cpu_gdt_descr, cpu);
-	struct desc_struct *gdt = per_cpu(cpu_gdt, cpu);
+	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
 	struct i386_pda *pda = &per_cpu(_cpu_pda, cpu);
 
- 	cpu_gdt_descr->address = (unsigned long)gdt;
-	cpu_gdt_descr->size = GDT_SIZE - 1;
-
 	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PDA].a,
 			(u32 *)&gdt[GDT_ENTRY_PDA].b,
 			(unsigned long)pda, sizeof(*pda) - 1,
@@ -1187,7 +1183,11 @@ void __init smp_prepare_cpus(unsigned in
  * it's on the real one. */
 static inline void switch_to_new_gdt(void)
 {
-	load_gdt(&per_cpu(cpu_gdt_descr, smp_processor_id()));
+	struct Xgt_desc_struct gdt_descr;
+
+	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
+	gdt_descr.size = GDT_SIZE - 1;
+	load_gdt(&gdt_descr);
 	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_PDA) : "memory");
 }
 
Index: linux/arch/i386/kernel/traps.c
===================================================================
--- linux.orig/arch/i386/kernel/traps.c
+++ linux/arch/i386/kernel/traps.c
@@ -1030,9 +1030,7 @@ fastcall void do_spurious_interrupt_bug(
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
Index: linux/include/asm-i386/desc.h
===================================================================
--- linux.orig/include/asm-i386/desc.h
+++ linux/include/asm-i386/desc.h
@@ -18,16 +18,13 @@ struct Xgt_desc_struct {
 	unsigned short pad;
 } __attribute__ ((packed));
 
-extern struct Xgt_desc_struct idt_descr;
-DECLARE_PER_CPU(struct Xgt_desc_struct, cpu_gdt_descr);
 DECLARE_PER_CPU(struct desc_struct, cpu_gdt[GDT_ENTRIES]);
-extern struct Xgt_desc_struct early_gdt_descr;
-
 static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
 {
-	return (struct desc_struct *)per_cpu(cpu_gdt_descr, cpu).address;
+	return per_cpu(cpu_gdt, cpu);
 }
 
+extern struct Xgt_desc_struct idt_descr;
 extern struct desc_struct idt_table[];
 extern void set_intr_gate(unsigned int irq, void * addr);
 
