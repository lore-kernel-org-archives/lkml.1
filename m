Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbZD2K6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbZD2K6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbZD2Kvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:32 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:35739
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755732AbZD2KvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:14 -0400
X-BigFish: VPS13(z1857rzzz1202hzzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0KIUZGS-04-0X6-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 06/29] perfcounters: rename struct hw_perf_counter_ops into struct pmu
Date: Wed, 29 Apr 2009 12:47:03 +0200
Message-ID: <1241002046-8832-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0289 (UTC) FILETIME=[5B966390:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames struct hw_perf_counter_ops into struct pmu. It
introduces a structure to describe a cpu specific pmu (performance
monitoring unit). It may contain ops and data. The new name of the
structure fits better, is shorter, and thus better to handle. Where it
was appropriate, names of function and variable have been changed too.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/powerpc/kernel/perf_counter.c |   25 ++++++-------
 arch/x86/kernel/cpu/perf_counter.c |   37 +++++++++----------
 include/linux/perf_counter.h       |    9 ++---
 kernel/perf_counter.c              |   68 +++++++++++++++++-------------------
 4 files changed, 66 insertions(+), 73 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index bd76d0f..d9bbe5e 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -256,7 +256,7 @@ static int check_excludes(struct perf_counter **ctrs, int n_prev, int n_new)
 	return 0;
 }
 
-static void power_perf_read(struct perf_counter *counter)
+static void power_pmu_read(struct perf_counter *counter)
 {
 	long val, delta, prev;
 
@@ -405,7 +405,7 @@ void hw_perf_restore(u64 disable)
 	for (i = 0; i < cpuhw->n_counters; ++i) {
 		counter = cpuhw->counter[i];
 		if (counter->hw.idx && counter->hw.idx != hwc_index[i] + 1) {
-			power_perf_read(counter);
+			power_pmu_read(counter);
 			write_pmc(counter->hw.idx, 0);
 			counter->hw.idx = 0;
 		}
@@ -477,7 +477,7 @@ static void counter_sched_in(struct perf_counter *counter, int cpu)
 	counter->oncpu = cpu;
 	counter->tstamp_running += counter->ctx->time - counter->tstamp_stopped;
 	if (is_software_counter(counter))
-		counter->hw_ops->enable(counter);
+		counter->pmu->enable(counter);
 }
 
 /*
@@ -533,7 +533,7 @@ int hw_perf_group_sched_in(struct perf_counter *group_leader,
  * re-enable the PMU in order to get hw_perf_restore to do the
  * actual work of reconfiguring the PMU.
  */
-static int power_perf_enable(struct perf_counter *counter)
+static int power_pmu_enable(struct perf_counter *counter)
 {
 	struct cpu_hw_counters *cpuhw;
 	unsigned long flags;
@@ -573,7 +573,7 @@ static int power_perf_enable(struct perf_counter *counter)
 /*
  * Remove a counter from the PMU.
  */
-static void power_perf_disable(struct perf_counter *counter)
+static void power_pmu_disable(struct perf_counter *counter)
 {
 	struct cpu_hw_counters *cpuhw;
 	long i;
@@ -583,7 +583,7 @@ static void power_perf_disable(struct perf_counter *counter)
 	local_irq_save(flags);
 	pmudis = hw_perf_save_disable();
 
-	power_perf_read(counter);
+	power_pmu_read(counter);
 
 	cpuhw = &__get_cpu_var(cpu_hw_counters);
 	for (i = 0; i < cpuhw->n_counters; ++i) {
@@ -607,10 +607,10 @@ static void power_perf_disable(struct perf_counter *counter)
 	local_irq_restore(flags);
 }
 
-struct hw_perf_counter_ops power_perf_ops = {
-	.enable = power_perf_enable,
-	.disable = power_perf_disable,
-	.read = power_perf_read
+struct pmu power_pmu = {
+	.enable		= power_pmu_enable,
+	.disable	= power_pmu_disable,
+	.read		= power_pmu_read,
 };
 
 /* Number of perf_counters counting hardware events */
@@ -631,8 +631,7 @@ static void hw_perf_counter_destroy(struct perf_counter *counter)
 	}
 }
 
-const struct hw_perf_counter_ops *
-hw_perf_counter_init(struct perf_counter *counter)
+const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
 {
 	unsigned long ev;
 	struct perf_counter *ctrs[MAX_HWCOUNTERS];
@@ -705,7 +704,7 @@ hw_perf_counter_init(struct perf_counter *counter)
 
 	if (err)
 		return ERR_PTR(err);
-	return &power_perf_ops;
+	return &power_pmu;
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index ad663d5..95de980 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -515,8 +515,8 @@ __pmc_fixed_disable(struct perf_counter *counter,
 }
 
 static inline void
-__pmc_generic_disable(struct perf_counter *counter,
-			   struct hw_perf_counter *hwc, unsigned int idx)
+__x86_pmu_disable(struct perf_counter *counter,
+		  struct hw_perf_counter *hwc, unsigned int idx)
 {
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL))
 		__pmc_fixed_disable(counter, hwc, idx);
@@ -591,8 +591,8 @@ __pmc_fixed_enable(struct perf_counter *counter,
 }
 
 static void
-__pmc_generic_enable(struct perf_counter *counter,
-			  struct hw_perf_counter *hwc, int idx)
+__x86_pmu_enable(struct perf_counter *counter,
+		 struct hw_perf_counter *hwc, int idx)
 {
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL))
 		__pmc_fixed_enable(counter, hwc, idx);
@@ -626,7 +626,7 @@ fixed_mode_idx(struct perf_counter *counter, struct hw_perf_counter *hwc)
 /*
  * Find a PMC slot for the freshly enabled / scheduled in counter:
  */
-static int pmc_generic_enable(struct perf_counter *counter)
+static int x86_pmu_enable(struct perf_counter *counter)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 	struct hw_perf_counter *hwc = &counter->hw;
@@ -667,7 +667,7 @@ try_generic:
 
 	perf_counters_lapic_init(hwc->nmi);
 
-	__pmc_generic_disable(counter, hwc, idx);
+	__x86_pmu_disable(counter, hwc, idx);
 
 	cpuc->counters[idx] = counter;
 	/*
@@ -676,7 +676,7 @@ try_generic:
 	barrier();
 
 	__hw_perf_counter_set_period(counter, hwc, idx);
-	__pmc_generic_enable(counter, hwc, idx);
+	__x86_pmu_enable(counter, hwc, idx);
 
 	return 0;
 }
@@ -731,13 +731,13 @@ void perf_counter_print_debug(void)
 	local_irq_enable();
 }
 
-static void pmc_generic_disable(struct perf_counter *counter)
+static void x86_pmu_disable(struct perf_counter *counter)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 	struct hw_perf_counter *hwc = &counter->hw;
 	unsigned int idx = hwc->idx;
 
-	__pmc_generic_disable(counter, hwc, idx);
+	__x86_pmu_disable(counter, hwc, idx);
 
 	clear_bit(idx, cpuc->used);
 	cpuc->counters[idx] = NULL;
@@ -767,7 +767,7 @@ static void perf_save_and_restart(struct perf_counter *counter)
 	__hw_perf_counter_set_period(counter, hwc, idx);
 
 	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
-		__pmc_generic_enable(counter, hwc, idx);
+		__x86_pmu_enable(counter, hwc, idx);
 }
 
 /*
@@ -805,7 +805,7 @@ again:
 
 		perf_save_and_restart(counter);
 		if (perf_counter_overflow(counter, nmi, regs, 0))
-			__pmc_generic_disable(counter, &counter->hw, bit);
+			__x86_pmu_disable(counter, &counter->hw, bit);
 	}
 
 	hw_perf_ack_status(ack);
@@ -1034,19 +1034,18 @@ void __init init_hw_perf_counters(void)
 	register_die_notifier(&perf_counter_nmi_notifier);
 }
 
-static void pmc_generic_read(struct perf_counter *counter)
+static void x86_pmu_read(struct perf_counter *counter)
 {
 	x86_perf_counter_update(counter, &counter->hw, counter->hw.idx);
 }
 
-static const struct hw_perf_counter_ops x86_perf_counter_ops = {
-	.enable		= pmc_generic_enable,
-	.disable	= pmc_generic_disable,
-	.read		= pmc_generic_read,
+static const struct pmu pmu = {
+	.enable		= x86_pmu_enable,
+	.disable	= x86_pmu_disable,
+	.read		= x86_pmu_read,
 };
 
-const struct hw_perf_counter_ops *
-hw_perf_counter_init(struct perf_counter *counter)
+const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
 {
 	int err;
 
@@ -1054,7 +1053,7 @@ hw_perf_counter_init(struct perf_counter *counter)
 	if (err)
 		return ERR_PTR(err);
 
-	return &x86_perf_counter_ops;
+	return &pmu;
 }
 
 /*
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index be10b3f..c3db52d 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -334,9 +334,9 @@ struct hw_perf_counter {
 struct perf_counter;
 
 /**
- * struct hw_perf_counter_ops - performance counter hw ops
+ * struct pmu - generic performance monitoring unit
  */
-struct hw_perf_counter_ops {
+struct pmu {
 	int (*enable)			(struct perf_counter *counter);
 	void (*disable)			(struct perf_counter *counter);
 	void (*read)			(struct perf_counter *counter);
@@ -381,7 +381,7 @@ struct perf_counter {
 	struct list_head		sibling_list;
 	int 				nr_siblings;
 	struct perf_counter		*group_leader;
-	const struct hw_perf_counter_ops *hw_ops;
+	const struct pmu		*pmu;
 
 	enum perf_counter_active_state	state;
 	enum perf_counter_active_state	prev_state;
@@ -519,8 +519,7 @@ struct perf_cpu_context {
  */
 extern int perf_max_counters;
 
-extern const struct hw_perf_counter_ops *
-hw_perf_counter_init(struct perf_counter *counter);
+extern const struct pmu *hw_perf_counter_init(struct perf_counter *counter);
 
 extern void perf_counter_task_sched_in(struct task_struct *task, int cpu);
 extern void perf_counter_task_sched_out(struct task_struct *task, int cpu);
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 0939609..582108a 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -52,8 +52,7 @@ static DEFINE_MUTEX(perf_resource_mutex);
 /*
  * Architecture provided APIs - weak aliases:
  */
-extern __weak const struct hw_perf_counter_ops *
-hw_perf_counter_init(struct perf_counter *counter)
+extern __weak const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
 {
 	return NULL;
 }
@@ -124,7 +123,7 @@ counter_sched_out(struct perf_counter *counter,
 
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
 	counter->tstamp_stopped = ctx->time;
-	counter->hw_ops->disable(counter);
+	counter->pmu->disable(counter);
 	counter->oncpu = -1;
 
 	if (!is_software_counter(counter))
@@ -417,7 +416,7 @@ counter_sched_in(struct perf_counter *counter,
 	 */
 	smp_wmb();
 
-	if (counter->hw_ops->enable(counter)) {
+	if (counter->pmu->enable(counter)) {
 		counter->state = PERF_COUNTER_STATE_INACTIVE;
 		counter->oncpu = -1;
 		return -EAGAIN;
@@ -1096,7 +1095,7 @@ static void __read(void *info)
 	local_irq_save(flags);
 	if (ctx->is_active)
 		update_context_time(ctx);
-	counter->hw_ops->read(counter);
+	counter->pmu->read(counter);
 	update_counter_times(counter);
 	local_irq_restore(flags);
 }
@@ -1922,7 +1921,7 @@ static void perf_counter_output(struct perf_counter *counter,
 		leader = counter->group_leader;
 		list_for_each_entry(sub, &leader->sibling_list, list_entry) {
 			if (sub != counter)
-				sub->hw_ops->read(sub);
+				sub->pmu->read(sub);
 
 			group_entry.event = sub->hw_event.config;
 			group_entry.counter = atomic64_read(&sub->count);
@@ -2264,7 +2263,7 @@ static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
 	struct pt_regs *regs;
 
 	counter	= container_of(hrtimer, struct perf_counter, hw.hrtimer);
-	counter->hw_ops->read(counter);
+	counter->pmu->read(counter);
 
 	regs = get_irq_regs();
 	/*
@@ -2410,7 +2409,7 @@ static void perf_swcounter_disable(struct perf_counter *counter)
 	perf_swcounter_update(counter);
 }
 
-static const struct hw_perf_counter_ops perf_ops_generic = {
+static const struct pmu perf_ops_generic = {
 	.enable		= perf_swcounter_enable,
 	.disable	= perf_swcounter_disable,
 	.read		= perf_swcounter_read,
@@ -2460,7 +2459,7 @@ static void cpu_clock_perf_counter_read(struct perf_counter *counter)
 	cpu_clock_perf_counter_update(counter);
 }
 
-static const struct hw_perf_counter_ops perf_ops_cpu_clock = {
+static const struct pmu perf_ops_cpu_clock = {
 	.enable		= cpu_clock_perf_counter_enable,
 	.disable	= cpu_clock_perf_counter_disable,
 	.read		= cpu_clock_perf_counter_read,
@@ -2522,7 +2521,7 @@ static void task_clock_perf_counter_read(struct perf_counter *counter)
 	task_clock_perf_counter_update(counter, time);
 }
 
-static const struct hw_perf_counter_ops perf_ops_task_clock = {
+static const struct pmu perf_ops_task_clock = {
 	.enable		= task_clock_perf_counter_enable,
 	.disable	= task_clock_perf_counter_disable,
 	.read		= task_clock_perf_counter_read,
@@ -2574,7 +2573,7 @@ static void cpu_migrations_perf_counter_disable(struct perf_counter *counter)
 	cpu_migrations_perf_counter_update(counter);
 }
 
-static const struct hw_perf_counter_ops perf_ops_cpu_migrations = {
+static const struct pmu perf_ops_cpu_migrations = {
 	.enable		= cpu_migrations_perf_counter_enable,
 	.disable	= cpu_migrations_perf_counter_disable,
 	.read		= cpu_migrations_perf_counter_read,
@@ -2600,8 +2599,7 @@ static void tp_perf_counter_destroy(struct perf_counter *counter)
 	ftrace_profile_disable(perf_event_id(&counter->hw_event));
 }
 
-static const struct hw_perf_counter_ops *
-tp_perf_counter_init(struct perf_counter *counter)
+static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 {
 	int event_id = perf_event_id(&counter->hw_event);
 	int ret;
@@ -2616,18 +2614,16 @@ tp_perf_counter_init(struct perf_counter *counter)
 	return &perf_ops_generic;
 }
 #else
-static const struct hw_perf_counter_ops *
-tp_perf_counter_init(struct perf_counter *counter)
+static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 {
 	return NULL;
 }
 #endif
 
-static const struct hw_perf_counter_ops *
-sw_perf_counter_init(struct perf_counter *counter)
+static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 {
 	struct perf_counter_hw_event *hw_event = &counter->hw_event;
-	const struct hw_perf_counter_ops *hw_ops = NULL;
+	const struct pmu *pmu = NULL;
 	struct hw_perf_counter *hwc = &counter->hw;
 
 	/*
@@ -2639,7 +2635,7 @@ sw_perf_counter_init(struct perf_counter *counter)
 	 */
 	switch (perf_event_id(&counter->hw_event)) {
 	case PERF_COUNT_CPU_CLOCK:
-		hw_ops = &perf_ops_cpu_clock;
+		pmu = &perf_ops_cpu_clock;
 
 		if (hw_event->irq_period && hw_event->irq_period < 10000)
 			hw_event->irq_period = 10000;
@@ -2650,9 +2646,9 @@ sw_perf_counter_init(struct perf_counter *counter)
 		 * use the cpu_clock counter instead.
 		 */
 		if (counter->ctx->task)
-			hw_ops = &perf_ops_task_clock;
+			pmu = &perf_ops_task_clock;
 		else
-			hw_ops = &perf_ops_cpu_clock;
+			pmu = &perf_ops_cpu_clock;
 
 		if (hw_event->irq_period && hw_event->irq_period < 10000)
 			hw_event->irq_period = 10000;
@@ -2661,18 +2657,18 @@ sw_perf_counter_init(struct perf_counter *counter)
 	case PERF_COUNT_PAGE_FAULTS_MIN:
 	case PERF_COUNT_PAGE_FAULTS_MAJ:
 	case PERF_COUNT_CONTEXT_SWITCHES:
-		hw_ops = &perf_ops_generic;
+		pmu = &perf_ops_generic;
 		break;
 	case PERF_COUNT_CPU_MIGRATIONS:
 		if (!counter->hw_event.exclude_kernel)
-			hw_ops = &perf_ops_cpu_migrations;
+			pmu = &perf_ops_cpu_migrations;
 		break;
 	}
 
-	if (hw_ops)
+	if (pmu)
 		hwc->irq_period = hw_event->irq_period;
 
-	return hw_ops;
+	return pmu;
 }
 
 /*
@@ -2685,7 +2681,7 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 		   struct perf_counter *group_leader,
 		   gfp_t gfpflags)
 {
-	const struct hw_perf_counter_ops *hw_ops;
+	const struct pmu *pmu;
 	struct perf_counter *counter;
 	long err;
 
@@ -2713,46 +2709,46 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 	counter->cpu			= cpu;
 	counter->hw_event		= *hw_event;
 	counter->group_leader		= group_leader;
-	counter->hw_ops			= NULL;
+	counter->pmu			= NULL;
 	counter->ctx			= ctx;
 
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
 	if (hw_event->disabled)
 		counter->state = PERF_COUNTER_STATE_OFF;
 
-	hw_ops = NULL;
+	pmu = NULL;
 
 	if (perf_event_raw(hw_event)) {
-		hw_ops = hw_perf_counter_init(counter);
+		pmu = hw_perf_counter_init(counter);
 		goto done;
 	}
 
 	switch (perf_event_type(hw_event)) {
 	case PERF_TYPE_HARDWARE:
-		hw_ops = hw_perf_counter_init(counter);
+		pmu = hw_perf_counter_init(counter);
 		break;
 
 	case PERF_TYPE_SOFTWARE:
-		hw_ops = sw_perf_counter_init(counter);
+		pmu = sw_perf_counter_init(counter);
 		break;
 
 	case PERF_TYPE_TRACEPOINT:
-		hw_ops = tp_perf_counter_init(counter);
+		pmu = tp_perf_counter_init(counter);
 		break;
 	}
 done:
 	err = 0;
-	if (!hw_ops)
+	if (!pmu)
 		err = -EINVAL;
-	else if (IS_ERR(hw_ops))
-		err = PTR_ERR(hw_ops);
+	else if (IS_ERR(pmu))
+		err = PTR_ERR(pmu);
 
 	if (err) {
 		kfree(counter);
 		return ERR_PTR(err);
 	}
 
-	counter->hw_ops = hw_ops;
+	counter->pmu = pmu;
 
 	if (counter->hw_event.mmap)
 		atomic_inc(&nr_mmap_tracking);
-- 
1.6.1.3


