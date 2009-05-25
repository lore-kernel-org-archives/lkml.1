Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbZEYPlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbZEYPlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 11:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZEYPkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 11:40:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37879 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbZEYPkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 11:40:49 -0400
Message-Id: <20090525153931.616671838@chello.nl>
References: <20090525153902.692238765@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 25 May 2009 17:39:04 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 2/3] perf_counter: x86: remove interrupt throttle
Content-Disposition: inline; filename=perf_counter-x86-remove-throttle.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove the x86 specific interrupt throttle

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/apic/apic.c        |    2 -
 arch/x86/kernel/cpu/perf_counter.c |   47 +++----------------------------------
 include/linux/perf_counter.h       |    2 -
 3 files changed, 5 insertions(+), 46 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -817,8 +817,6 @@ static void local_apic_timer_interrupt(v
 	inc_irq_stat(apic_timer_irqs);
 
 	evt->event_handler(evt);
-
-	perf_counter_unthrottle();
 }
 
 /*
Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -719,11 +719,6 @@ static void intel_pmu_save_and_restart(s
 }
 
 /*
- * Maximum interrupt frequency of 100KHz per CPU
- */
-#define PERFMON_MAX_INTERRUPTS (100000/HZ)
-
-/*
  * This handler is triggered by the local APIC, so the APIC IRQ handling
  * rules apply:
  */
@@ -775,15 +770,14 @@ again:
 	if (status)
 		goto again;
 
-	if (++cpuc->interrupts != PERFMON_MAX_INTERRUPTS)
-		perf_enable();
+	perf_enable();
 
 	return 1;
 }
 
 static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
 {
-	int cpu, idx, throttle = 0, handled = 0;
+	int cpu, idx, handled = 0;
 	struct cpu_hw_counters *cpuc;
 	struct perf_counter *counter;
 	struct hw_perf_counter *hwc;
@@ -792,16 +786,7 @@ static int amd_pmu_handle_irq(struct pt_
 	cpu = smp_processor_id();
 	cpuc = &per_cpu(cpu_hw_counters, cpu);
 
-	if (++cpuc->interrupts == PERFMON_MAX_INTERRUPTS) {
-		throttle = 1;
-		__perf_disable();
-		cpuc->enabled = 0;
-		barrier();
-	}
-
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
-		int disable = 0;
-
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
 
@@ -809,45 +794,23 @@ static int amd_pmu_handle_irq(struct pt_
 		hwc = &counter->hw;
 
 		if (counter->hw_event.nmi != nmi)
-			goto next;
+			continue;
 
 		val = x86_perf_counter_update(counter, hwc, idx);
 		if (val & (1ULL << (x86_pmu.counter_bits - 1)))
-			goto next;
+			continue;
 
 		/* counter overflow */
 		x86_perf_counter_set_period(counter, hwc, idx);
 		handled = 1;
 		inc_irq_stat(apic_perf_irqs);
-		disable = perf_counter_overflow(counter, nmi, regs, 0);
-
-next:
-		if (disable || throttle)
+		if (perf_counter_overflow(counter, nmi, regs, 0))
 			amd_pmu_disable_counter(hwc, idx);
 	}
 
 	return handled;
 }
 
-void perf_counter_unthrottle(void)
-{
-	struct cpu_hw_counters *cpuc;
-
-	if (!x86_pmu_initialized())
-		return;
-
-	cpuc = &__get_cpu_var(cpu_hw_counters);
-	if (cpuc->interrupts >= PERFMON_MAX_INTERRUPTS) {
-		/*
-		 * Clear them before re-enabling irqs/NMIs again:
-		 */
-		cpuc->interrupts = 0;
-		perf_enable();
-	} else {
-		cpuc->interrupts = 0;
-	}
-}
-
 void smp_perf_counter_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -570,7 +570,6 @@ extern void perf_counter_init_task(struc
 extern void perf_counter_exit_task(struct task_struct *child);
 extern void perf_counter_do_pending(void);
 extern void perf_counter_print_debug(void);
-extern void perf_counter_unthrottle(void);
 extern void __perf_disable(void);
 extern bool __perf_enable(void);
 extern void perf_disable(void);
@@ -635,7 +634,6 @@ static inline void perf_counter_init_tas
 static inline void perf_counter_exit_task(struct task_struct *child)	{ }
 static inline void perf_counter_do_pending(void)			{ }
 static inline void perf_counter_print_debug(void)			{ }
-static inline void perf_counter_unthrottle(void)			{ }
 static inline void perf_disable(void)					{ }
 static inline void perf_enable(void)					{ }
 static inline int perf_counter_task_disable(void)	{ return -EINVAL; }

-- 

