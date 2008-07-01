Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbYGAMSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbYGAMSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbYGAMRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:17:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42973 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753676AbYGAMQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:16:36 -0400
Message-Id: <20080701121635.593935000@polaris-admin.engr.sgi.com>
References: <20080701121634.865966000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Jul 2008 05:16:39 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [RFC 5/5] x86_64: Replace xxx_pda() operations with x86_xxx_percpu().
Content-Disposition: inline; filename=zero_based_replace_pda_operations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * It is now possible to use percpu operations for pda access
    since the pda is in the percpu area. Drop the pda operations.

    Thus:

	read_pda     --> x86_read_percpu
	write_pda    --> x86_write_percpu
	add_pda (+1) --> x86_inc_percpu
	or_pda       --> x86_or_percpu

  * Remove unused field (in_bootmem) from the pda.

  * One pda op (test_and_clear_bit_pda) cannot be easily removed
    but since the pda is the first element in the per cpu area,
    then it can be left in place as is.

Based on linux-2.6.tip/master

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/apic_64.c                 |    4 -
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c   |    2 
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    2 
 arch/x86/kernel/nmi.c                     |    3 -
 arch/x86/kernel/process_64.c              |   12 ++--
 arch/x86/kernel/smp.c                     |    4 -
 arch/x86/kernel/time_64.c                 |    2 
 arch/x86/kernel/tlb_64.c                  |   12 ++--
 arch/x86/kernel/traps_64.c                |    2 
 arch/x86/kernel/x8664_ksyms_64.c          |    2 
 arch/x86/xen/smp.c                        |    2 
 include/asm-x86/current.h                 |    3 -
 include/asm-x86/hardirq_64.h              |    6 +-
 include/asm-x86/mmu_context_64.h          |   12 ++--
 include/asm-x86/pda.h                     |   77 ++----------------------------
 include/asm-x86/percpu.h                  |    2 
 include/asm-x86/smp.h                     |    2 
 include/asm-x86/stackprotector.h          |    2 
 include/asm-x86/thread_info.h             |    3 -
 include/asm-x86/topology.h                |    2 
 20 files changed, 47 insertions(+), 109 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/apic_64.c
+++ linux-2.6.tip/arch/x86/kernel/apic_64.c
@@ -457,7 +457,7 @@ static void local_apic_timer_interrupt(v
 	/*
 	 * the NMI deadlock-detector uses this.
 	 */
-	add_pda(apic_timer_irqs, 1);
+	x86_inc_percpu(pda.apic_timer_irqs);
 
 	evt->event_handler(evt);
 }
@@ -965,7 +965,7 @@ asmlinkage void smp_spurious_interrupt(v
 	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
 		ack_APIC_irq();
 
-	add_pda(irq_spurious_count, 1);
+	x86_inc_percpu(pda.irq_spurious_count);
 	irq_exit();
 }
 
--- linux-2.6.tip.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -237,7 +237,7 @@ asmlinkage void mce_threshold_interrupt(
 		}
 	}
 out:
-	add_pda(irq_threshold_count, 1);
+	x86_inc_percpu(pda.irq_threshold_count);
 	irq_exit();
 }
 
--- linux-2.6.tip.orig/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -26,7 +26,7 @@ asmlinkage void smp_thermal_interrupt(vo
 	if (therm_throt_process(msr_val & 1))
 		mce_log_therm_throt_event(smp_processor_id(), msr_val);
 
-	add_pda(irq_thermal_count, 1);
+	x86_inc_percpu(pda.irq_thermal_count);
 	irq_exit();
 }
 
--- linux-2.6.tip.orig/arch/x86/kernel/nmi.c
+++ linux-2.6.tip/arch/x86/kernel/nmi.c
@@ -82,7 +82,8 @@ static inline int mce_in_progress(void)
 static inline unsigned int get_timer_irqs(int cpu)
 {
 #ifdef CONFIG_X86_64
-	return read_pda(apic_timer_irqs) + read_pda(irq0_irqs);
+	return x86_read_percpu(pda.apic_timer_irqs) +
+		x86_read_percpu(pda.irq0_irqs);
 #else
 	return per_cpu(irq_stat, cpu).apic_timer_irqs +
 		per_cpu(irq_stat, cpu).irq0_irqs;
--- linux-2.6.tip.orig/arch/x86/kernel/process_64.c
+++ linux-2.6.tip/arch/x86/kernel/process_64.c
@@ -66,7 +66,7 @@ void idle_notifier_register(struct notif
 
 void enter_idle(void)
 {
-	write_pda(isidle, 1);
+	x86_write_percpu(pda.isidle, 1);
 	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
 }
 
@@ -410,7 +410,7 @@ start_thread(struct pt_regs *regs, unsig
 	load_gs_index(0);
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
-	write_pda(oldrsp, new_sp);
+	x86_write_percpu(pda.oldrsp, new_sp);
 	regs->cs		= __USER_CS;
 	regs->ss		= __USER_DS;
 	regs->flags		= 0x200;
@@ -646,11 +646,11 @@ __switch_to(struct task_struct *prev_p, 
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
 	/*
--- linux-2.6.tip.orig/arch/x86/kernel/smp.c
+++ linux-2.6.tip/arch/x86/kernel/smp.c
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
 
--- linux-2.6.tip.orig/arch/x86/kernel/time_64.c
+++ linux-2.6.tip/arch/x86/kernel/time_64.c
@@ -46,7 +46,7 @@ EXPORT_SYMBOL(profile_pc);
 
 static irqreturn_t timer_event_interrupt(int irq, void *dev_id)
 {
-	add_pda(irq0_irqs, 1);
+	x86_inc_percpu(pda.irq0_irqs);
 
 	global_clock_event->event_handler(global_clock_event);
 
--- linux-2.6.tip.orig/arch/x86/kernel/tlb_64.c
+++ linux-2.6.tip/arch/x86/kernel/tlb_64.c
@@ -62,9 +62,9 @@ static DEFINE_PER_CPU(union smp_flush_st
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
@@ -142,8 +142,8 @@ asmlinkage void smp_invalidate_interrupt
 		 * BUG();
 		 */
 
-	if (f->flush_mm == read_pda(active_mm)) {
-		if (read_pda(mmu_state) == TLBSTATE_OK) {
+	if (f->flush_mm == x86_read_percpu(pda.active_mm)) {
+		if (x86_read_percpu(pda.mmu_state) == TLBSTATE_OK) {
 			if (f->flush_va == TLB_FLUSH_ALL)
 				local_flush_tlb();
 			else
@@ -154,7 +154,7 @@ asmlinkage void smp_invalidate_interrupt
 out:
 	ack_APIC_irq();
 	cpu_clear(cpu, f->flush_cpumask);
-	add_pda(irq_tlb_count, 1);
+	x86_inc_percpu(pda.irq_tlb_count);
 }
 
 void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
@@ -269,7 +269,7 @@ static void do_flush_tlb_all(void *info)
 	unsigned long cpu = smp_processor_id();
 
 	__flush_tlb_all();
-	if (read_pda(mmu_state) == TLBSTATE_LAZY)
+	if (x86_read_percpu(pda.mmu_state) == TLBSTATE_LAZY)
 		leave_mm(cpu);
 }
 
--- linux-2.6.tip.orig/arch/x86/kernel/traps_64.c
+++ linux-2.6.tip/arch/x86/kernel/traps_64.c
@@ -878,7 +878,7 @@ asmlinkage notrace __kprobes void
 do_nmi(struct pt_regs *regs, long error_code)
 {
 	nmi_enter();
-	add_pda(__nmi_count, 1);
+	x86_inc_percpu(pda.__nmi_count);
 	if (!ignore_nmis)
 		default_do_nmi(regs);
 	nmi_exit();
--- linux-2.6.tip.orig/arch/x86/kernel/x8664_ksyms_64.c
+++ linux-2.6.tip/arch/x86/kernel/x8664_ksyms_64.c
@@ -58,5 +58,3 @@ EXPORT_SYMBOL(__memcpy);
 EXPORT_SYMBOL(empty_zero_page);
 EXPORT_SYMBOL(init_level4_pgt);
 EXPORT_SYMBOL(load_gs_index);
-
-EXPORT_SYMBOL(_proxy_pda);
--- linux-2.6.tip.orig/arch/x86/xen/smp.c
+++ linux-2.6.tip/arch/x86/xen/smp.c
@@ -68,7 +68,7 @@ static irqreturn_t xen_reschedule_interr
 #ifdef CONFIG_X86_32
 	__get_cpu_var(irq_stat).irq_resched_count++;
 #else
-	add_pda(irq_resched_count, 1);
+	x86_inc_percpu(pda.irq_resched_count);
 #endif
 
 	return IRQ_HANDLED;
--- linux-2.6.tip.orig/include/asm-x86/current.h
+++ linux-2.6.tip/include/asm-x86/current.h
@@ -17,12 +17,13 @@ static __always_inline struct task_struc
 
 #ifndef __ASSEMBLY__
 #include <asm/pda.h>
+#include <asm/percpu.h>
 
 struct task_struct;
 
 static __always_inline struct task_struct *get_current(void)
 {
-	return read_pda(pcurrent);
+	return x86_read_percpu(pda.pcurrent);
 }
 
 #else /* __ASSEMBLY__ */
--- linux-2.6.tip.orig/include/asm-x86/hardirq_64.h
+++ linux-2.6.tip/include/asm-x86/hardirq_64.h
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
 
--- linux-2.6.tip.orig/include/asm-x86/mmu_context_64.h
+++ linux-2.6.tip/include/asm-x86/mmu_context_64.h
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
--- linux-2.6.tip.orig/include/asm-x86/pda.h
+++ linux-2.6.tip/include/asm-x86/pda.h
@@ -21,7 +21,7 @@ struct x8664_pda {
 					   offset 40!!! */
 	char *irqstackptr;
 	short nodenumber;		/* number of current node (32k max) */
-	short in_bootmem;		/* pda lives in bootmem */
+	short unused1;			/* unused */
 	unsigned int __softirq_pending;
 	unsigned int __nmi_count;	/* number of NMI on this CPUs */
 	short mmu_state;
@@ -42,12 +42,6 @@ extern void pda_init(int);
 #define cpu_pda(cpu) (&per_cpu(pda, cpu))
 
 /*
- * There is no fast way to get the base address of the PDA, all the accesses
- * have to mention %fs/%gs.  So it needs to be done this Torvaldian way.
- */
-extern void __bad_pda_field(void) __attribute__((noreturn));
-
-/*
  * proxy_pda doesn't actually exist, but tell gcc it is accessed for
  * all PDA accesses so it gets read/write dependencies right.
  */
@@ -55,69 +49,11 @@ extern struct x8664_pda _proxy_pda;
 
 #define pda_offset(field) offsetof(struct x8664_pda, field)
 
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
+/*
+ * This is not atomic against other CPUs -- CPU preemption needs to be off
+ * NOTE: This relies on the fact that the cpu_pda is the *first* field in
+ *       the per cpu area.  Move it and you'll need to change this.
+ */
 #define test_and_clear_bit_pda(bit, field)				\
 ({									\
 	int old__;							\
@@ -127,6 +63,7 @@ do {									\
 	old__;								\
 })
 
+
 #endif
 
 #define PDA_STACKOFFSET (5*8)
--- linux-2.6.tip.orig/include/asm-x86/percpu.h
+++ linux-2.6.tip/include/asm-x86/percpu.h
@@ -7,7 +7,7 @@
 
 /* Same as asm-generic/percpu.h, except we use %gs as a segment offset. */
 #ifdef CONFIG_SMP
-#define __my_cpu_offset read_pda(data_offset)
+#define __my_cpu_offset (x86_read_percpu(pda.data_offset))
 #define __percpu_seg "%%gs:"
 #else
 #define __percpu_seg ""
--- linux-2.6.tip.orig/include/asm-x86/smp.h
+++ linux-2.6.tip/include/asm-x86/smp.h
@@ -134,7 +134,7 @@ DECLARE_PER_CPU(int, cpu_number);
 extern int safe_smp_processor_id(void);
 
 #elif defined(CONFIG_X86_64_SMP)
-#define raw_smp_processor_id()	read_pda(cpunumber)
+#define raw_smp_processor_id()	x86_read_percpu(pda.cpunumber)
 
 #define stack_smp_processor_id()					\
 ({								\
--- linux-2.6.tip.orig/include/asm-x86/stackprotector.h
+++ linux-2.6.tip/include/asm-x86/stackprotector.h
@@ -32,7 +32,7 @@ static __always_inline void boot_init_st
 	canary += tsc + (tsc << 32UL);
 
 	current->stack_canary = canary;
-	write_pda(stack_canary, canary);
+	x86_write_percpu(pda.stack_canary, canary);
 }
 
 #endif
--- linux-2.6.tip.orig/include/asm-x86/thread_info.h
+++ linux-2.6.tip/include/asm-x86/thread_info.h
@@ -200,7 +200,8 @@ static inline struct thread_info *curren
 static inline struct thread_info *current_thread_info(void)
 {
 	struct thread_info *ti;
-	ti = (void *)(read_pda(kernelstack) + PDA_STACKOFFSET - THREAD_SIZE);
+	ti = (void *)(x86_read_percpu(pda.kernelstack) +
+						PDA_STACKOFFSET - THREAD_SIZE);
 	return ti;
 }
 
--- linux-2.6.tip.orig/include/asm-x86/topology.h
+++ linux-2.6.tip/include/asm-x86/topology.h
@@ -72,7 +72,7 @@ extern cpumask_t *node_to_cpumask_map;
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
 
 /* Returns the number of the current Node. */
-#define numa_node_id()		read_pda(nodenumber)
+#define numa_node_id()		x86_read_percpu(pda.nodenumber)
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 extern int cpu_to_node(int cpu);

-- 
