Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbYGIQ4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbYGIQ4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYGIQvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:51:40 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53186 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751862AbYGIQva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:51:30 -0400
Message-Id: <20080709165130.013669000@polaris-admin.engr.sgi.com>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 09:51:34 -0700
From: Mike Travis <travis@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [RFC 05/15] x86_64: Replace xxx_pda() operations with x86_xxx_percpu().
Content-Disposition: inline; filename=zero_based_replace_pda_ops
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
 arch/x86/kernel/apic_64.c                 |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c   |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    2 +-
 arch/x86/kernel/nmi.c                     |    3 ++-
 arch/x86/kernel/process_64.c              |   12 ++++++------
 arch/x86/kernel/smp.c                     |    4 ++--
 arch/x86/kernel/time_64.c                 |    2 +-
 arch/x86/kernel/tlb_64.c                  |   12 ++++++------
 arch/x86/kernel/traps_64.c                |    2 +-
 arch/x86/kernel/x8664_ksyms_64.c          |    2 --
 arch/x86/xen/smp.c                        |    2 +-
 11 files changed, 23 insertions(+), 24 deletions(-)

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

-- 
