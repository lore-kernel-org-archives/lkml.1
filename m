Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbYE3ELk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbYE3ELk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbYE3EBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:01:13 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45482 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753384AbYE3EA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:26 -0400
Message-Id: <20080530040024.319403256@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:57:00 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 40/41] x86: Replace xxx_pda() operations with x86_xx_percpu().
Content-Disposition: inline; filename=zero_based_replace_pda_operations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is now possible to use percpu operations for pda access since the pda is
in the percpu area. Drop the pda operations.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/kernel/apic_64.c                 |    4 -
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c   |    2 
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    2 
 arch/x86/kernel/nmi_64.c                  |    5 +
 arch/x86/kernel/process_64.c              |   16 ++---
 arch/x86/kernel/smp.c                     |    4 -
 arch/x86/kernel/time_64.c                 |    2 
 arch/x86/kernel/tlb_64.c                  |   12 ++--
 arch/x86/kernel/x8664_ksyms_64.c          |    2 
 include/asm-x86/current_64.h              |    4 -
 include/asm-x86/hardirq_64.h              |    6 +-
 include/asm-x86/mmu_context_64.h          |   12 ++--
 include/asm-x86/pda.h                     |   86 ------------------------------
 include/asm-x86/smp.h                     |    2 
 include/asm-x86/thread_info_64.h          |    2 
 15 files changed, 37 insertions(+), 124 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_64.c	2008-05-24 00:14:00.936487393 -0700
+++ linux-2.6/arch/x86/kernel/apic_64.c	2008-05-24 00:15:07.877737074 -0700
@@ -481,7 +481,7 @@ static void local_apic_timer_interrupt(v
 	/*
 	 * the NMI deadlock-detector uses this.
 	 */
-	add_pda(apic_timer_irqs, 1);
+	x86_inc_percpu(pda.apic_timer_irqs);
 
 	evt->event_handler(evt);
 }
@@ -986,7 +986,7 @@ asmlinkage void smp_spurious_interrupt(v
 	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
 		ack_APIC_irq();
 
-	add_pda(irq_spurious_count, 1);
+	x86_inc_percpu(pda.irq_spurious_count);
 	irq_exit();
 }
 
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c	2008-05-24 00:14:00.946486866 -0700
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_amd_64.c	2008-05-24 00:15:07.877737074 -0700
@@ -237,7 +237,7 @@ asmlinkage void mce_threshold_interrupt(
 		}
 	}
 out:
-	add_pda(irq_threshold_count, 1);
+	x86_inc_percpu(pda.irq_threshold_count);
 	irq_exit();
 }
 
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_intel_64.c	2008-05-24 00:14:00.956487483 -0700
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel_64.c	2008-05-24 00:15:07.907736191 -0700
@@ -26,7 +26,7 @@ asmlinkage void smp_thermal_interrupt(vo
 	if (therm_throt_process(msr_val & 1))
 		mce_log_therm_throt_event(smp_processor_id(), msr_val);
 
-	add_pda(irq_thermal_count, 1);
+	x86_inc_percpu(pda.irq_thermal_count);
 	irq_exit();
 }
 
Index: linux-2.6/arch/x86/kernel/nmi_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/nmi_64.c	2008-05-24 00:14:00.966487850 -0700
+++ linux-2.6/arch/x86/kernel/nmi_64.c	2008-05-24 00:15:07.937736041 -0700
@@ -328,7 +328,8 @@ nmi_watchdog_tick(struct pt_regs *regs, 
 		touched = 1;
 	}
 
-	sum = read_pda(apic_timer_irqs) + read_pda(irq0_irqs);
+	sum = x86_read_percpu(pda.apic_timer_irqs) +
+					x86_read_percpu(pda.irq0_irqs);
 	if (__get_cpu_var(nmi_touch)) {
 		__get_cpu_var(nmi_touch) = 0;
 		touched = 1;
@@ -389,7 +390,7 @@ asmlinkage notrace __kprobes void
 do_nmi(struct pt_regs *regs, long error_code)
 {
 	nmi_enter();
-	add_pda(__nmi_count,1);
+	x86_inc_percpu(pda.__nmi_count);
 	if (!ignore_nmis)
 		default_do_nmi(regs);
 	nmi_exit();
Index: linux-2.6/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process_64.c	2008-05-24 00:14:00.976488140 -0700
+++ linux-2.6/arch/x86/kernel/process_64.c	2008-05-24 00:15:22.687263321 -0700
@@ -74,13 +74,13 @@ void idle_notifier_register(struct notif
 
 void enter_idle(void)
 {
-	write_pda(isidle, 1);
+	x86_write_percpu(pda.isidle, 1);
 	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
 }
 
 static void __exit_idle(void)
 {
-	if (test_and_clear_bit_pda(0, isidle) == 0)
+	if (test_and_clear_bit(0, &per_cpu(pda.isidle, smp_processor_id())) == 0)
 		return;
 	atomic_notifier_call_chain(&idle_notifier, IDLE_END, NULL);
 }
@@ -411,7 +411,7 @@ start_thread(struct pt_regs *regs, unsig
 	load_gs_index(0);
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
-	write_pda(oldrsp, new_sp);
+	x86_write_percpu(pda.oldrsp, new_sp);
 	regs->cs		= __USER_CS;
 	regs->ss		= __USER_DS;
 	regs->flags		= 0x200;
@@ -633,14 +633,14 @@ __switch_to(struct task_struct *prev_p, 
 	/* 
 	 * Switch the PDA and FPU contexts.
 	 */
-	prev->usersp = read_pda(oldrsp);
-	write_pda(oldrsp, next->usersp);
-	write_pda(pcurrent, next_p); 
+	prev->usersp = x86_read_percpu(pda.oldrsp);
+	x86_write_percpu(pda.oldrsp, next->usersp);
+	x86_write_percpu(pda.pcurrent, next_p);
 
-	write_pda(kernelstack,
+	x86_write_percpu(pda.kernelstack,
 	(unsigned long)task_stack_page(next_p) + THREAD_SIZE - PDA_STACKOFFSET);
 #ifdef CONFIG_CC_STACKPROTECTOR
-	write_pda(stack_canary, next_p->stack_canary);
+	x86_write_percpu(pda.stack_canary, next_p->stack_canary);
 	/*
 	 * Build time only check to make sure the stack_canary is at
 	 * offset 40 in the pda; this is a gcc ABI requirement
Index: linux-2.6/arch/x86/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smp.c	2008-05-24 00:14:00.986488228 -0700
+++ linux-2.6/arch/x86/kernel/smp.c	2008-05-24 00:15:07.977736114 -0700
@@ -295,7 +295,7 @@ void smp_reschedule_interrupt(struct pt_
 #ifdef CONFIG_X86_32
 	__get_cpu_var(irq_stat).irq_resched_count++;
 #else
-	add_pda(irq_resched_count, 1);
+	x86_inc_percpu(pda.irq_resched_count);
 #endif
 }
 
@@ -320,7 +320,7 @@ void smp_call_function_interrupt(struct 
 #ifdef CONFIG_X86_32
 	__get_cpu_var(irq_stat).irq_call_count++;
 #else
-	add_pda(irq_call_count, 1);
+	x86_inc_percpu(pda.irq_call_count);
 #endif
 	irq_exit();
 
Index: linux-2.6/arch/x86/kernel/time_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_64.c	2008-05-24 00:14:00.996488252 -0700
+++ linux-2.6/arch/x86/kernel/time_64.c	2008-05-24 00:15:07.997736055 -0700
@@ -46,7 +46,7 @@ EXPORT_SYMBOL(profile_pc);
 
 static irqreturn_t timer_event_interrupt(int irq, void *dev_id)
 {
-	add_pda(irq0_irqs, 1);
+	x86_inc_percpu(pda.irq0_irqs);
 
 	global_clock_event->event_handler(global_clock_event);
 
Index: linux-2.6/arch/x86/kernel/tlb_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tlb_64.c	2008-05-24 00:14:01.006487889 -0700
+++ linux-2.6/arch/x86/kernel/tlb_64.c	2008-05-24 00:15:08.037736066 -0700
@@ -60,9 +60,9 @@ static DEFINE_PER_CPU(union smp_flush_st
  */
 void leave_mm(int cpu)
 {
-	if (read_pda(mmu_state) == TLBSTATE_OK)
+	if (x86_read_percpu(pda.mmu_state) == TLBSTATE_OK)
 		BUG();
-	cpu_clear(cpu, read_pda(active_mm)->cpu_vm_mask);
+	cpu_clear(cpu, x86_read_percpu(pda.active_mm)->cpu_vm_mask);
 	load_cr3(swapper_pg_dir);
 }
 EXPORT_SYMBOL_GPL(leave_mm);
@@ -140,8 +140,8 @@ asmlinkage void smp_invalidate_interrupt
 		 * BUG();
 		 */
 
-	if (f->flush_mm == read_pda(active_mm)) {
-		if (read_pda(mmu_state) == TLBSTATE_OK) {
+	if (f->flush_mm == x86_read_percpu(pda.active_mm)) {
+		if (x86_read_percpu(pda.mmu_state) == TLBSTATE_OK) {
 			if (f->flush_va == TLB_FLUSH_ALL)
 				local_flush_tlb();
 			else
@@ -152,7 +152,7 @@ asmlinkage void smp_invalidate_interrupt
 out:
 	ack_APIC_irq();
 	cpu_clear(cpu, f->flush_cpumask);
-	add_pda(irq_tlb_count, 1);
+	x86_inc_percpu(pda.irq_tlb_count);
 }
 
 void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
@@ -264,7 +264,7 @@ static void do_flush_tlb_all(void *info)
 	unsigned long cpu = smp_processor_id();
 
 	__flush_tlb_all();
-	if (read_pda(mmu_state) == TLBSTATE_LAZY)
+	if (x86_read_percpu(pda.mmu_state) == TLBSTATE_LAZY)
 		leave_mm(cpu);
 }
 
Index: linux-2.6/include/asm-x86/pda.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pda.h	2008-05-24 00:14:01.016487470 -0700
+++ linux-2.6/include/asm-x86/pda.h	2008-05-24 00:15:22.598997235 -0700
@@ -39,92 +39,6 @@ struct x8664_pda {
 
 extern void pda_init(int);
 
-/*
- * There is no fast way to get the base address of the PDA, all the accesses
- * have to mention %fs/%gs.  So it needs to be done this Torvaldian way.
- */
-extern void __bad_pda_field(void) __attribute__((noreturn));
-
-/*
- * proxy_pda doesn't actually exist, but tell gcc it is accessed for
- * all PDA accesses so it gets read/write dependencies right.
- */
-extern struct x8664_pda _proxy_pda;
-
-#define pda_offset(field) offsetof(struct x8664_pda, field)
-
-#define pda_to_op(op, field, val)					\
-do {									\
-	typedef typeof(_proxy_pda.field) T__;				\
-	if (0) { T__ tmp__; tmp__ = (val); }	/* type checking */	\
-	switch (sizeof(_proxy_pda.field)) {				\
-	case 2:								\
-		asm(op "w %1,%%gs:%c2" :				\
-		    "+m" (_proxy_pda.field) :				\
-		    "ri" ((T__)val),					\
-		    "i"(pda_offset(field)));				\
-		break;							\
-	case 4:								\
-		asm(op "l %1,%%gs:%c2" :				\
-		    "+m" (_proxy_pda.field) :				\
-		    "ri" ((T__)val),					\
-		    "i" (pda_offset(field)));				\
-		break;							\
-	case 8:								\
-		asm(op "q %1,%%gs:%c2":					\
-		    "+m" (_proxy_pda.field) :				\
-		    "ri" ((T__)val),					\
-		    "i"(pda_offset(field)));				\
-		break;							\
-	default:							\
-		__bad_pda_field();					\
-	}								\
-} while (0)
-
-#define pda_from_op(op, field)			\
-({						\
-	typeof(_proxy_pda.field) ret__;		\
-	switch (sizeof(_proxy_pda.field)) {	\
-	case 2:					\
-		asm(op "w %%gs:%c1,%0" :	\
-		    "=r" (ret__) :		\
-		    "i" (pda_offset(field)),	\
-		    "m" (_proxy_pda.field));	\
-		break;				\
-	case 4:					\
-		asm(op "l %%gs:%c1,%0":		\
-		    "=r" (ret__):		\
-		    "i" (pda_offset(field)),	\
-		    "m" (_proxy_pda.field));	\
-		break;				\
-	case 8:					\
-		asm(op "q %%gs:%c1,%0":		\
-		    "=r" (ret__) :		\
-		    "i" (pda_offset(field)),	\
-		    "m" (_proxy_pda.field));	\
-		break;				\
-	default:				\
-		__bad_pda_field();		\
-	}					\
-	ret__;					\
-})
-
-#define read_pda(field)		pda_from_op("mov", field)
-#define write_pda(field, val)	pda_to_op("mov", field, val)
-#define add_pda(field, val)	pda_to_op("add", field, val)
-#define sub_pda(field, val)	pda_to_op("sub", field, val)
-#define or_pda(field, val)	pda_to_op("or", field, val)
-
-/* This is not atomic against other CPUs -- CPU preemption needs to be off */
-#define test_and_clear_bit_pda(bit, field)				\
-({									\
-	int old__;							\
-	asm volatile("btr %2,%%gs:%c3\n\tsbbl %0,%0"			\
-		     : "=r" (old__), "+m" (_proxy_pda.field)		\
-		     : "dIr" (bit), "i" (pda_offset(field)) : "memory");\
-	old__;								\
-})
-
 #endif
 
 #define PDA_STACKOFFSET (5*8)
Index: linux-2.6/arch/x86/kernel/x8664_ksyms_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/x8664_ksyms_64.c	2008-05-24 00:13:59.416488421 -0700
+++ linux-2.6/arch/x86/kernel/x8664_ksyms_64.c	2008-05-24 00:15:22.668997592 -0700
@@ -52,8 +52,6 @@ EXPORT_SYMBOL(empty_zero_page);
 EXPORT_SYMBOL(init_level4_pgt);
 EXPORT_SYMBOL(load_gs_index);
 
-EXPORT_SYMBOL(_proxy_pda);
-
 #ifdef CONFIG_PARAVIRT
 /* Virtualized guests may want to use it */
 EXPORT_SYMBOL_GPL(cpu_gdt_descr);
Index: linux-2.6/include/asm-x86/current_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/current_64.h	2008-05-24 00:13:59.356487241 -0700
+++ linux-2.6/include/asm-x86/current_64.h	2008-05-24 00:15:22.528988082 -0700
@@ -5,11 +5,11 @@
 struct task_struct;
 
 #include <asm/pda.h>
+#include <asm/percpu.h>
 
 static inline struct task_struct *get_current(void)
 {
-	struct task_struct *t = read_pda(pcurrent);
-	return t;
+	return x86_read_percpu(pda.pcurrent);
 }
 
 #define current get_current()
Index: linux-2.6/include/asm-x86/hardirq_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/hardirq_64.h	2008-05-24 00:13:59.366487645 -0700
+++ linux-2.6/include/asm-x86/hardirq_64.h	2008-05-24 00:15:22.528988082 -0700
@@ -11,12 +11,12 @@
 
 #define __ARCH_IRQ_STAT 1
 
-#define local_softirq_pending() read_pda(__softirq_pending)
+#define local_softirq_pending() x86_read_percpu(pda.__softirq_pending)
 
 #define __ARCH_SET_SOFTIRQ_PENDING 1
 
-#define set_softirq_pending(x) write_pda(__softirq_pending, (x))
-#define or_softirq_pending(x)  or_pda(__softirq_pending, (x))
+#define set_softirq_pending(x) x86_write_percpu(pda.__softirq_pending, (x))
+#define or_softirq_pending(x)  x86_or_percpu(pda.__softirq_pending, (x))
 
 extern void ack_bad_irq(unsigned int irq);
 
Index: linux-2.6/include/asm-x86/mmu_context_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mmu_context_64.h	2008-05-24 00:13:59.376487037 -0700
+++ linux-2.6/include/asm-x86/mmu_context_64.h	2008-05-24 00:15:22.558986281 -0700
@@ -20,8 +20,8 @@ void destroy_context(struct mm_struct *m
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
 #ifdef CONFIG_SMP
-	if (read_pda(mmu_state) == TLBSTATE_OK)
-		write_pda(mmu_state, TLBSTATE_LAZY);
+	if (x86_read_percpu(pda.mmu_state) == TLBSTATE_OK)
+		x86_write_percpu(pda.mmu_state, TLBSTATE_LAZY);
 #endif
 }
 
@@ -33,8 +33,8 @@ static inline void switch_mm(struct mm_s
 		/* stop flush ipis for the previous mm */
 		cpu_clear(cpu, prev->cpu_vm_mask);
 #ifdef CONFIG_SMP
-		write_pda(mmu_state, TLBSTATE_OK);
-		write_pda(active_mm, next);
+		x86_write_percpu(pda.mmu_state, TLBSTATE_OK);
+		x86_write_percpu(pda.active_mm, next);
 #endif
 		cpu_set(cpu, next->cpu_vm_mask);
 		load_cr3(next->pgd);
@@ -44,8 +44,8 @@ static inline void switch_mm(struct mm_s
 	}
 #ifdef CONFIG_SMP
 	else {
-		write_pda(mmu_state, TLBSTATE_OK);
-		if (read_pda(active_mm) != next)
+		x86_write_percpu(pda.mmu_state, TLBSTATE_OK);
+		if (x86_read_percpu(pda.active_mm) != next)
 			BUG();
 		if (!cpu_test_and_set(cpu, next->cpu_vm_mask)) {
 			/* We were in lazy tlb mode and leave_mm disabled
Index: linux-2.6/include/asm-x86/smp.h
===================================================================
--- linux-2.6.orig/include/asm-x86/smp.h	2008-05-24 00:13:59.386487983 -0700
+++ linux-2.6/include/asm-x86/smp.h	2008-05-24 00:15:22.628996584 -0700
@@ -143,7 +143,7 @@ DECLARE_PER_CPU(int, cpu_number);
 extern int safe_smp_processor_id(void);
 
 #elif defined(CONFIG_X86_64_SMP)
-#define raw_smp_processor_id()	read_pda(cpunumber)
+#define raw_smp_processor_id()	x86_read_percpu(pda.cpunumber)
 
 #define stack_smp_processor_id()					\
 ({								\
Index: linux-2.6/include/asm-x86/thread_info_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/thread_info_64.h	2008-05-24 00:13:59.406488336 -0700
+++ linux-2.6/include/asm-x86/thread_info_64.h	2008-05-24 00:15:22.648997403 -0700
@@ -63,7 +63,7 @@ struct thread_info {
 static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
-	ti = (void *)(read_pda(kernelstack) + PDA_STACKOFFSET - THREAD_SIZE);
+	ti = (void *)(x86_read_percpu(pda.kernelstack) + PDA_STACKOFFSET - THREAD_SIZE);
 	return ti;
 }
 

-- 
