Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbZEYTyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbZEYTyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 15:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbZEYTyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 15:54:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:42878 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbZEYTyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 15:54:05 -0400
Date: Mon, 25 May 2009 19:51:51 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090525153931.616671838@chello.nl>
References: <20090525153931.616671838@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: x86: Remove interrupt throttle
Message-ID: <tip-48e22d56ecdeddd1ffb42a02fccba5c6ef42b133@git.kernel.org>
Git-Commit-ID: 48e22d56ecdeddd1ffb42a02fccba5c6ef42b133
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 19:52:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48e22d56ecdeddd1ffb42a02fccba5c6ef42b133
Gitweb:     http://git.kernel.org/tip/48e22d56ecdeddd1ffb42a02fccba5c6ef42b133
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 25 May 2009 17:39:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 May 2009 21:41:12 +0200

perf_counter: x86: Remove interrupt throttle

remove the x86 specific interrupt throttle

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090525153931.616671838@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic.c        |    2 -
 arch/x86/kernel/cpu/perf_counter.c |   47 ++++--------------------------------
 include/linux/perf_counter.h       |    2 -
 3 files changed, 5 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b4f6440..89b63b5 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -763,8 +763,6 @@ static void local_apic_timer_interrupt(void)
 	inc_irq_stat(apic_timer_irqs);
 
 	evt->event_handler(evt);
-
-	perf_counter_unthrottle();
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index c14437f..8c8177f 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -719,11 +719,6 @@ static void intel_pmu_save_and_restart(struct perf_counter *counter)
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
@@ -792,16 +786,7 @@ static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
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
 
@@ -809,45 +794,23 @@ static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
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
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index d3e85de..0c160be 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -570,7 +570,6 @@ extern int perf_counter_init_task(struct task_struct *child);
 extern void perf_counter_exit_task(struct task_struct *child);
 extern void perf_counter_do_pending(void);
 extern void perf_counter_print_debug(void);
-extern void perf_counter_unthrottle(void);
 extern void __perf_disable(void);
 extern bool __perf_enable(void);
 extern void perf_disable(void);
@@ -635,7 +634,6 @@ static inline int perf_counter_init_task(struct task_struct *child)	{ }
 static inline void perf_counter_exit_task(struct task_struct *child)	{ }
 static inline void perf_counter_do_pending(void)			{ }
 static inline void perf_counter_print_debug(void)			{ }
-static inline void perf_counter_unthrottle(void)			{ }
 static inline void perf_disable(void)					{ }
 static inline void perf_enable(void)					{ }
 static inline int perf_counter_task_disable(void)	{ return -EINVAL; }
