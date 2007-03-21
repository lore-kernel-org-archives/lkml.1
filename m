Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXCUGx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXCUGx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932205AbXCUGx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:53:56 -0400
Received: from ozlabs.org ([203.10.76.45]:40034 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185AbXCUGxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:53:55 -0400
Subject: [PATCH 4/4] i386 GDT cleanups: cleanup GDT Access
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1174459014.11680.153.camel@localhost.localdomain>
References: <1174457426.11680.132.camel@localhost.localdomain>
	 <1174458636.11680.143.camel@localhost.localdomain>
	 <1174458730.11680.145.camel@localhost.localdomain>
	 <1174458938.11680.150.camel@localhost.localdomain>
	 <1174459014.11680.153.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 17:53:36 +1100
Message-Id: <1174460016.11680.156.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have an explicit per-cpu GDT variable, we don't need to keep
the descriptors around to use them to find the GDT: expose cpu_gdt
directly.

We could go further and make load_gdt() pack the descriptor for us, or
even assume it means "load the current cpu's GDT" which is what it
always does.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/i386/kernel/cpu/common.c |    4 +---
 arch/i386/kernel/efi.c        |   18 +++++++++---------
 arch/i386/kernel/entry.S      |    3 +--
 arch/i386/kernel/smpboot.c    |   12 ++++++------
 arch/i386/kernel/traps.c      |    4 +---
 include/asm-i386/desc.h       |   15 ++++++---------
 6 files changed, 24 insertions(+), 32 deletions(-)

diff -r 0714eeaace72 arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c	Wed Mar 21 15:55:51 2007 +1100
+++ b/arch/i386/kernel/cpu/common.c	Wed Mar 21 16:02:02 2007 +1100
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
diff -r 0714eeaace72 arch/i386/kernel/efi.c
--- a/arch/i386/kernel/efi.c	Wed Mar 21 15:55:51 2007 +1100
+++ b/arch/i386/kernel/efi.c	Wed Mar 21 15:56:22 2007 +1100
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
 
diff -r 0714eeaace72 arch/i386/kernel/entry.S
--- a/arch/i386/kernel/entry.S	Wed Mar 21 15:55:51 2007 +1100
+++ b/arch/i386/kernel/entry.S	Wed Mar 21 16:02:02 2007 +1100
@@ -558,8 +558,7 @@ END(syscall_badsys)
 #define FIXUP_ESPFIX_STACK \
 	/* since we are on a wrong stack, we cant make it a C code :( */ \
 	movl %fs:PDA_cpu, %ebx; \
-	PER_CPU(cpu_gdt_descr, %ebx); \
-	movl GDS_address(%ebx), %ebx; \
+	PER_CPU(cpu_gdt, %ebx); \
 	GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah); \
 	addl %esp, %eax; \
 	pushl $__KERNEL_DS; \
diff -r 0714eeaace72 arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c	Wed Mar 21 15:55:51 2007 +1100
+++ b/arch/i386/kernel/smpboot.c	Wed Mar 21 16:02:02 2007 +1100
@@ -786,12 +786,8 @@ static inline struct task_struct * alloc
    secondary which will soon come up. */
 static __cpuinit void init_gdt(int cpu, struct task_struct *idle)
 {
-	struct Xgt_desc_struct *cpu_gdt_descr = &per_cpu(cpu_gdt_descr, cpu);
-	struct desc_struct *gdt = per_cpu(cpu_gdt, cpu);
+	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
 	struct i386_pda *pda = &per_cpu(_cpu_pda, cpu);
-
- 	cpu_gdt_descr->address = (unsigned long)gdt;
-	cpu_gdt_descr->size = GDT_SIZE - 1;
 
 	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PDA].a,
 			(u32 *)&gdt[GDT_ENTRY_PDA].b,
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
 
diff -r 0714eeaace72 arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c	Wed Mar 21 15:55:51 2007 +1100
+++ b/arch/i386/kernel/traps.c	Wed Mar 21 16:02:02 2007 +1100
@@ -1037,9 +1037,7 @@ fastcall unsigned long patch_espfix_desc
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
diff -r 0714eeaace72 arch/i386/lguest/core.c
--- a/arch/i386/lguest/core.c	Wed Mar 21 15:55:51 2007 +1100
+++ b/arch/i386/lguest/core.c	Wed Mar 21 16:11:14 2007 +1100
@@ -96,7 +96,8 @@ static __init int map_hypervisor(void)
 		struct lguest_ro_state *state = &pages->state;
 
 		/* These fields are static: rest done in copy_in_guest_info */
-		state->host_gdt_desc = per_cpu(cpu_gdt_descr, i);
+		state->host_gdt_desc.size = GDT_SIZE-1;
+		state->host_gdt_desc.address = (long)get_cpu_gdt_table(i);
 		store_idt(&state->host_idt_desc);
 		state->guest_idt_desc.size = sizeof(state->guest_idt)-1;
 		state->guest_idt_desc.address = (long)&state->guest_idt;
diff -r 0714eeaace72 arch/i386/lguest/lguest.c
--- a/arch/i386/lguest/lguest.c	Wed Mar 21 15:55:51 2007 +1100
+++ b/arch/i386/lguest/lguest.c	Wed Mar 21 16:03:12 2007 +1100
@@ -451,6 +451,7 @@ static void lguest_power_off(void)
 
 /* From head.S */
 extern void setup_pda(void);
+extern struct Xgt_desc_struct early_gdt_descr;
 
 static __attribute_used__ __init void lguest_init(void)
 {
diff -r 0714eeaace72 include/asm-i386/desc.h
--- a/include/asm-i386/desc.h	Wed Mar 21 15:55:51 2007 +1100
+++ b/include/asm-i386/desc.h	Wed Mar 21 16:02:02 2007 +1100
@@ -18,16 +18,13 @@ struct Xgt_desc_struct {
 	unsigned short pad;
 } __attribute__ ((packed));
 
+DECLARE_PER_CPU(struct desc_struct, cpu_gdt[GDT_ENTRIES]);
+static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
+{
+	return per_cpu(cpu_gdt, cpu);
+}
+
 extern struct Xgt_desc_struct idt_descr;
-DECLARE_PER_CPU(struct Xgt_desc_struct, cpu_gdt_descr);
-DECLARE_PER_CPU(struct desc_struct, cpu_gdt[GDT_ENTRIES]);
-extern struct Xgt_desc_struct early_gdt_descr;
-
-static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
-{
-	return (struct desc_struct *)per_cpu(cpu_gdt_descr, cpu).address;
-}
-
 extern struct desc_struct idt_table[];
 extern void set_intr_gate(unsigned int irq, void * addr);
 


