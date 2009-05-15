Return-Path: <linux-kernel-owner+w=401wt.eu-S1762302AbZEONWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762302AbZEONWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762973AbZEONVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:21:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36815 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758809AbZEONVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:21:14 -0400
Message-Id: <20090515132018.646195868@chello.nl>
References: <20090515131925.616419905@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 15 May 2009 15:19:28 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/4] perf_counter: frequency based adaptive irq_period
Content-Disposition: inline; filename=perf_counter-freq.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of specifying the irq_period for a counter, provide a target interrupt
frequency and dynamically adapt the irq_period to match this frequency.

Paul, please verify ppc64, I only did a very quick pass over that code.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>
CC: Corey Ashford <cjashfor@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/perf_counter.c |   13 +++----
 arch/x86/kernel/cpu/perf_counter.c |    9 +----
 include/linux/perf_counter.h       |   10 ++++-
 kernel/perf_counter.c              |   63 +++++++++++++++++++++++++++++--------
 4 files changed, 68 insertions(+), 27 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -286,11 +286,8 @@ static int __hw_perf_counter_init(struct
 		hwc->nmi = 1;
 	}
 
-	hwc->irq_period	= hw_event->irq_period;
-	if ((s64)hwc->irq_period <= 0 || hwc->irq_period > x86_pmu.max_period)
-		hwc->irq_period = x86_pmu.max_period;
-
-	atomic64_set(&hwc->period_left, hwc->irq_period);
+	atomic64_set(&hwc->period_left,
+			min(x86_pmu.max_period, hwc->irq_period));
 
 	/*
 	 * Raw event type provide the config in the event structure
@@ -458,7 +455,7 @@ x86_perf_counter_set_period(struct perf_
 			     struct hw_perf_counter *hwc, int idx)
 {
 	s64 left = atomic64_read(&hwc->period_left);
-	s64 period = hwc->irq_period;
+	s64 period = min(x86_pmu.max_period, hwc->irq_period);
 	int err;
 
 	/*
Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -130,7 +130,11 @@ struct perf_counter_hw_event {
 	 */
 	__u64			config;
 
-	__u64			irq_period;
+	union {
+		__u64		irq_period;
+		__u64		irq_freq;
+	};
+
 	__u32			record_type;
 	__u32			read_format;
 
@@ -146,8 +150,9 @@ struct perf_counter_hw_event {
 				mmap           :  1, /* include mmap data     */
 				munmap         :  1, /* include munmap data   */
 				comm	       :  1, /* include comm data     */
+				freq           :  1, /* use freq, not period  */
 
-				__reserved_1   : 52;
+				__reserved_1   : 51;
 
 	__u32			extra_config_len;
 	__u32			wakeup_events;	/* wakeup every n events */
@@ -337,6 +342,7 @@ struct hw_perf_counter {
 	atomic64_t			prev_count;
 	u64				irq_period;
 	atomic64_t			period_left;
+	u64				interrupts;
 #endif
 };
 
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1046,6 +1046,38 @@ int perf_counter_task_enable(void)
 	return 0;
 }
 
+void perf_adjust_freq(struct perf_counter_context *ctx)
+{
+	struct perf_counter *counter;
+	u64 irq_period;
+	u64 events, period;
+	s64 delta;
+
+	spin_lock(&ctx->lock);
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		if (counter->state != PERF_COUNTER_STATE_ACTIVE)
+			continue;
+
+		if (!counter->hw_event.freq || !counter->hw_event.irq_freq)
+			continue;
+
+		events = HZ * counter->hw.interrupts * counter->hw.irq_period;
+		period = div64_u64(events, counter->hw_event.irq_freq);
+
+		delta = (s64)(1 + period - counter->hw.irq_period);
+		delta >>= 1;
+
+		irq_period = counter->hw.irq_period + delta;
+
+		if (!irq_period)
+			irq_period = 1;
+
+		counter->hw.irq_period = irq_period;
+		counter->hw.interrupts = 0;
+	}
+	spin_unlock(&ctx->lock);
+}
+
 /*
  * Round-robin a context's counters:
  */
@@ -1081,6 +1113,9 @@ void perf_counter_task_tick(struct task_
 	cpuctx = &per_cpu(perf_cpu_context, cpu);
 	ctx = &curr->perf_counter_ctx;
 
+	perf_adjust_freq(&cpuctx->ctx);
+	perf_adjust_freq(ctx);
+
 	perf_counter_cpu_sched_out(cpuctx);
 	__perf_counter_task_sched_out(ctx);
 
@@ -2382,6 +2417,8 @@ int perf_counter_overflow(struct perf_co
 	int events = atomic_read(&counter->event_limit);
 	int ret = 0;
 
+	counter->hw.interrupts++;
+
 	/*
 	 * XXX event_limit might not quite work as expected on inherited
 	 * counters
@@ -2450,6 +2487,7 @@ static enum hrtimer_restart perf_swcount
 	enum hrtimer_restart ret = HRTIMER_RESTART;
 	struct perf_counter *counter;
 	struct pt_regs *regs;
+	u64 period;
 
 	counter	= container_of(hrtimer, struct perf_counter, hw.hrtimer);
 	counter->pmu->read(counter);
@@ -2468,7 +2506,8 @@ static enum hrtimer_restart perf_swcount
 			ret = HRTIMER_NORESTART;
 	}
 
-	hrtimer_forward_now(hrtimer, ns_to_ktime(counter->hw.irq_period));
+	period = max_t(u64, 10000, counter->hw.irq_period);
+	hrtimer_forward_now(hrtimer, ns_to_ktime(period));
 
 	return ret;
 }
@@ -2629,8 +2668,9 @@ static int cpu_clock_perf_counter_enable
 	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hwc->hrtimer.function = perf_swcounter_hrtimer;
 	if (hwc->irq_period) {
+		u64 period = max_t(u64, 10000, hwc->irq_period);
 		__hrtimer_start_range_ns(&hwc->hrtimer,
-				ns_to_ktime(hwc->irq_period), 0,
+				ns_to_ktime(period), 0,
 				HRTIMER_MODE_REL, 0);
 	}
 
@@ -2679,8 +2719,9 @@ static int task_clock_perf_counter_enabl
 	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hwc->hrtimer.function = perf_swcounter_hrtimer;
 	if (hwc->irq_period) {
+		u64 period = max_t(u64, 10000, hwc->irq_period);
 		__hrtimer_start_range_ns(&hwc->hrtimer,
-				ns_to_ktime(hwc->irq_period), 0,
+				ns_to_ktime(period), 0,
 				HRTIMER_MODE_REL, 0);
 	}
 
@@ -2811,9 +2852,7 @@ static const struct pmu *tp_perf_counter
 
 static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 {
-	struct perf_counter_hw_event *hw_event = &counter->hw_event;
 	const struct pmu *pmu = NULL;
-	struct hw_perf_counter *hwc = &counter->hw;
 
 	/*
 	 * Software counters (currently) can't in general distinguish
@@ -2826,8 +2865,6 @@ static const struct pmu *sw_perf_counter
 	case PERF_COUNT_CPU_CLOCK:
 		pmu = &perf_ops_cpu_clock;
 
-		if (hw_event->irq_period && hw_event->irq_period < 10000)
-			hw_event->irq_period = 10000;
 		break;
 	case PERF_COUNT_TASK_CLOCK:
 		/*
@@ -2839,8 +2876,6 @@ static const struct pmu *sw_perf_counter
 		else
 			pmu = &perf_ops_cpu_clock;
 
-		if (hw_event->irq_period && hw_event->irq_period < 10000)
-			hw_event->irq_period = 10000;
 		break;
 	case PERF_COUNT_PAGE_FAULTS:
 	case PERF_COUNT_PAGE_FAULTS_MIN:
@@ -2854,9 +2889,6 @@ static const struct pmu *sw_perf_counter
 		break;
 	}
 
-	if (pmu)
-		hwc->irq_period = hw_event->irq_period;
-
 	return pmu;
 }
 
@@ -2872,6 +2904,7 @@ perf_counter_alloc(struct perf_counter_h
 {
 	const struct pmu *pmu;
 	struct perf_counter *counter;
+	struct hw_perf_counter *hwc;
 	long err;
 
 	counter = kzalloc(sizeof(*counter), gfpflags);
@@ -2907,6 +2940,12 @@ perf_counter_alloc(struct perf_counter_h
 
 	pmu = NULL;
 
+	hwc = &counter->hw;
+	if (hw_event->freq && hw_event->irq_freq)
+		hwc->irq_period = TICK_NSEC / hw_event->irq_freq;
+	else
+		hwc->irq_period = hw_event->irq_period;
+
 	/*
 	 * we currently do not support PERF_RECORD_GROUP on inherited counters
 	 */
Index: linux-2.6/arch/powerpc/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_counter.c
+++ linux-2.6/arch/powerpc/kernel/perf_counter.c
@@ -534,7 +534,7 @@ void hw_perf_enable(void)
 			continue;
 		}
 		val = 0;
-		if (counter->hw_event.irq_period) {
+		if (counter->hw.irq_period) {
 			left = atomic64_read(&counter->hw.period_left);
 			if (left < 0x80000000L)
 				val = 0x80000000L - left;
@@ -829,8 +829,6 @@ const struct pmu *hw_perf_counter_init(s
 
 	if (!ppmu)
 		return ERR_PTR(-ENXIO);
-	if ((s64)counter->hw_event.irq_period < 0)
-		return ERR_PTR(-EINVAL);
 	if (!perf_event_raw(&counter->hw_event)) {
 		ev = perf_event_id(&counter->hw_event);
 		if (ev >= ppmu->n_generic || ppmu->generic_events[ev] == 0)
@@ -901,7 +899,7 @@ const struct pmu *hw_perf_counter_init(s
 
 	counter->hw.config = events[n];
 	counter->hw.counter_base = cflags[n];
-	atomic64_set(&counter->hw.period_left, counter->hw_event.irq_period);
+	atomic64_set(&counter->hw.period_left, counter->hw.irq_period);
 
 	/*
 	 * See if we need to reserve the PMU.
@@ -934,6 +932,7 @@ const struct pmu *hw_perf_counter_init(s
 static void record_and_restart(struct perf_counter *counter, long val,
 			       struct pt_regs *regs, int nmi)
 {
+	u64 period = counter->hw.irq_period;
 	s64 prev, delta, left;
 	int record = 0;
 
@@ -948,11 +947,11 @@ static void record_and_restart(struct pe
 	 */
 	val = 0;
 	left = atomic64_read(&counter->hw.period_left) - delta;
-	if (counter->hw_event.irq_period) {
+	if (period) {
 		if (left <= 0) {
-			left += counter->hw_event.irq_period;
+			left += period;
 			if (left <= 0)
-				left = counter->hw_event.irq_period;
+				left = period;
 			record = 1;
 		}
 		if (left < 0x80000000L)

-- 

