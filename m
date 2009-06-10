Return-Path: <linux-kernel-owner+w=401wt.eu-S1760018AbZFJPnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbZFJPnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 11:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbZFJPnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 11:43:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:52817 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbZFJPnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 11:43:10 -0400
Date: Wed, 10 Jun 2009 15:42:33 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: More aggressive frequency adjustment
Message-ID: <tip-bd2b5b12849a3446abad0b25e920f86f5480b309@git.kernel.org>
Git-Commit-ID: bd2b5b12849a3446abad0b25e920f86f5480b309
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 10 Jun 2009 15:42:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd2b5b12849a3446abad0b25e920f86f5480b309
Gitweb:     http://git.kernel.org/tip/bd2b5b12849a3446abad0b25e920f86f5480b309
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 10 Jun 2009 13:40:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Jun 2009 16:55:26 +0200

perf_counter: More aggressive frequency adjustment

Also employ the overflow handler to adjust the frequency, this results
in a stable frequency in about 40~50 samples, instead of that many ticks.

This also means we can start sampling at a sample period of 1 without
running head-first into the throttle.

It relies on sched_clock() to accurately measure the time difference
between the overflow NMIs.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    5 +-
 include/linux/perf_counter.h       |    1 +
 kernel/perf_counter.c              |  130 ++++++++++++++++++++++++------------
 3 files changed, 92 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 49f2585..240ca56 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -696,10 +696,11 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	if (!attr->exclude_kernel)
 		hwc->config |= ARCH_PERFMON_EVENTSEL_OS;
 
-	if (!hwc->sample_period)
+	if (!hwc->sample_period) {
 		hwc->sample_period = x86_pmu.max_period;
+		atomic64_set(&hwc->period_left, hwc->sample_period);
+	}
 
-	atomic64_set(&hwc->period_left, hwc->sample_period);
 	counter->destroy = hw_perf_counter_destroy;
 
 	/*
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 3586df8..282d8cc 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -371,6 +371,7 @@ struct hw_perf_counter {
 
 	u64				freq_count;
 	u64				freq_interrupts;
+	u64				freq_stamp;
 #endif
 };
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 5eacaaf..51c571e 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1184,13 +1184,33 @@ static void perf_counter_cpu_sched_in(struct perf_cpu_context *cpuctx, int cpu)
 static void perf_log_throttle(struct perf_counter *counter, int enable);
 static void perf_log_period(struct perf_counter *counter, u64 period);
 
-static void perf_adjust_freq(struct perf_counter_context *ctx)
+static void perf_adjust_period(struct perf_counter *counter, u64 events)
+{
+	struct hw_perf_counter *hwc = &counter->hw;
+	u64 period, sample_period;
+	s64 delta;
+
+	events *= hwc->sample_period;
+	period = div64_u64(events, counter->attr.sample_freq);
+
+	delta = (s64)(period - hwc->sample_period);
+	delta = (delta + 7) / 8; /* low pass filter */
+
+	sample_period = hwc->sample_period + delta;
+
+	if (!sample_period)
+		sample_period = 1;
+
+	perf_log_period(counter, sample_period);
+
+	hwc->sample_period = sample_period;
+}
+
+static void perf_ctx_adjust_freq(struct perf_counter_context *ctx)
 {
 	struct perf_counter *counter;
 	struct hw_perf_counter *hwc;
-	u64 interrupts, sample_period;
-	u64 events, period, freq;
-	s64 delta;
+	u64 interrupts, freq;
 
 	spin_lock(&ctx->lock);
 	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
@@ -1202,6 +1222,9 @@ static void perf_adjust_freq(struct perf_counter_context *ctx)
 		interrupts = hwc->interrupts;
 		hwc->interrupts = 0;
 
+		/*
+		 * unthrottle counters on the tick
+		 */
 		if (interrupts == MAX_INTERRUPTS) {
 			perf_log_throttle(counter, 1);
 			counter->pmu->unthrottle(counter);
@@ -1211,6 +1234,9 @@ static void perf_adjust_freq(struct perf_counter_context *ctx)
 		if (!counter->attr.freq || !counter->attr.sample_freq)
 			continue;
 
+		/*
+		 * if the specified freq < HZ then we need to skip ticks
+		 */
 		if (counter->attr.sample_freq < HZ) {
 			freq = counter->attr.sample_freq;
 
@@ -1226,20 +1252,20 @@ static void perf_adjust_freq(struct perf_counter_context *ctx)
 		} else
 			freq = HZ;
 
-		events = freq * interrupts * hwc->sample_period;
-		period = div64_u64(events, counter->attr.sample_freq);
-
-		delta = (s64)(1 + period - hwc->sample_period);
-		delta >>= 1;
-
-		sample_period = hwc->sample_period + delta;
-
-		if (!sample_period)
-			sample_period = 1;
+		perf_adjust_period(counter, freq * interrupts);
 
-		perf_log_period(counter, sample_period);
-
-		hwc->sample_period = sample_period;
+		/*
+		 * In order to avoid being stalled by an (accidental) huge
+		 * sample period, force reset the sample period if we didn't
+		 * get any events in this freq period.
+		 */
+		if (!interrupts) {
+			perf_disable();
+			counter->pmu->disable(counter);
+			atomic_set(&hwc->period_left, 0);
+			counter->pmu->enable(counter);
+			perf_enable();
+		}
 	}
 	spin_unlock(&ctx->lock);
 }
@@ -1279,9 +1305,9 @@ void perf_counter_task_tick(struct task_struct *curr, int cpu)
 	cpuctx = &per_cpu(perf_cpu_context, cpu);
 	ctx = curr->perf_counter_ctxp;
 
-	perf_adjust_freq(&cpuctx->ctx);
+	perf_ctx_adjust_freq(&cpuctx->ctx);
 	if (ctx)
-		perf_adjust_freq(ctx);
+		perf_ctx_adjust_freq(ctx);
 
 	perf_counter_cpu_sched_out(cpuctx);
 	if (ctx)
@@ -1647,10 +1673,10 @@ static int perf_counter_period(struct perf_counter *counter, u64 __user *arg)
 
 		counter->attr.sample_freq = value;
 	} else {
+		perf_log_period(counter, value);
+
 		counter->attr.sample_period = value;
 		counter->hw.sample_period = value;
-
-		perf_log_period(counter, value);
 	}
 unlock:
 	spin_unlock_irq(&ctx->lock);
@@ -2853,35 +2879,41 @@ void __perf_counter_mmap(struct vm_area_struct *vma)
  * event flow.
  */
 
+struct freq_event {
+	struct perf_event_header	header;
+	u64				time;
+	u64				id;
+	u64				period;
+};
+
 static void perf_log_period(struct perf_counter *counter, u64 period)
 {
 	struct perf_output_handle handle;
+	struct freq_event event;
 	int ret;
 
-	struct {
-		struct perf_event_header	header;
-		u64				time;
-		u64				id;
-		u64				period;
-	} freq_event = {
+	if (counter->hw.sample_period == period)
+		return;
+
+	if (counter->attr.sample_type & PERF_SAMPLE_PERIOD)
+		return;
+
+	event = (struct freq_event) {
 		.header = {
 			.type = PERF_EVENT_PERIOD,
 			.misc = 0,
-			.size = sizeof(freq_event),
+			.size = sizeof(event),
 		},
 		.time = sched_clock(),
 		.id = counter->id,
 		.period = period,
 	};
 
-	if (counter->hw.sample_period == period)
-		return;
-
-	ret = perf_output_begin(&handle, counter, sizeof(freq_event), 0, 0);
+	ret = perf_output_begin(&handle, counter, sizeof(event), 1, 0);
 	if (ret)
 		return;
 
-	perf_output_put(&handle, freq_event);
+	perf_output_put(&handle, event);
 	perf_output_end(&handle);
 }
 
@@ -2923,15 +2955,16 @@ int perf_counter_overflow(struct perf_counter *counter,
 {
 	int events = atomic_read(&counter->event_limit);
 	int throttle = counter->pmu->unthrottle != NULL;
+	struct hw_perf_counter *hwc = &counter->hw;
 	int ret = 0;
 
 	if (!throttle) {
-		counter->hw.interrupts++;
+		hwc->interrupts++;
 	} else {
-		if (counter->hw.interrupts != MAX_INTERRUPTS) {
-			counter->hw.interrupts++;
-			if (HZ*counter->hw.interrupts > (u64)sysctl_perf_counter_limit) {
-				counter->hw.interrupts = MAX_INTERRUPTS;
+		if (hwc->interrupts != MAX_INTERRUPTS) {
+			hwc->interrupts++;
+			if (HZ * hwc->interrupts > (u64)sysctl_perf_counter_limit) {
+				hwc->interrupts = MAX_INTERRUPTS;
 				perf_log_throttle(counter, 0);
 				ret = 1;
 			}
@@ -2945,6 +2978,16 @@ int perf_counter_overflow(struct perf_counter *counter,
 		}
 	}
 
+	if (counter->attr.freq) {
+		u64 now = sched_clock();
+		s64 delta = now - hwc->freq_stamp;
+
+		hwc->freq_stamp = now;
+
+		if (delta > 0 && delta < TICK_NSEC)
+			perf_adjust_period(counter, NSEC_PER_SEC / (int)delta);
+	}
+
 	/*
 	 * XXX event_limit might not quite work as expected on inherited
 	 * counters
@@ -3379,7 +3422,6 @@ static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 		return NULL;
 
 	counter->destroy = tp_perf_counter_destroy;
-	counter->hw.sample_period = counter->attr.sample_period;
 
 	return &perf_ops_generic;
 }
@@ -3483,10 +3525,11 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 	pmu = NULL;
 
 	hwc = &counter->hw;
+	hwc->sample_period = attr->sample_period;
 	if (attr->freq && attr->sample_freq)
-		hwc->sample_period = div64_u64(TICK_NSEC, attr->sample_freq);
-	else
-		hwc->sample_period = attr->sample_period;
+		hwc->sample_period = 1;
+
+	atomic64_set(&hwc->period_left, hwc->sample_period);
 
 	/*
 	 * we currently do not support PERF_SAMPLE_GROUP on inherited counters
@@ -3687,6 +3730,9 @@ inherit_counter(struct perf_counter *parent_counter,
 	else
 		child_counter->state = PERF_COUNTER_STATE_OFF;
 
+	if (parent_counter->attr.freq)
+		child_counter->hw.sample_period = parent_counter->hw.sample_period;
+
 	/*
 	 * Link it up in the child's context:
 	 */
