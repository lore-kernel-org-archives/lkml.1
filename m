Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbZGWTVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbZGWTVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZGWTVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:21:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:36982 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbZGWTVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:21:14 -0400
Message-Id: <20090723191957.059953420@chello.nl>
References: <20090723191642.780643661@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 21:16:47 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 05/13] perf_counter: Rework software counters
Content-Disposition: inline; filename=perf-fast-swcounter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reimplement the software counters to deal with fast moving event
sources. This means being able to generate multiple overflows from a
single 'event' as well as support throttling.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
---
 kernel/perf_counter.c |  164 ++++++++++++++++++++++++++++----------------------
 1 file changed, 94 insertions(+), 70 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -3312,87 +3312,81 @@ int perf_counter_overflow(struct perf_co
  * Generic software counter infrastructure
  */
 
-static void perf_swcounter_update(struct perf_counter *counter)
+/*
+ * We directly increment counter->count and keep a second value in
+ * counter->hw.period_left to count intervals. This period counter
+ * is kept in the range [-sample_period, 0] so that we can use the
+ * sign as trigger.
+ */
+
+static u64 perf_swcounter_set_period(struct perf_counter *counter)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
-	u64 prev, now;
-	s64 delta;
+	u64 period = hwc->last_period;
+	u64 nr, offset;
+	s64 old, val;
+
+	hwc->last_period = hwc->sample_period;
 
 again:
-	prev = atomic64_read(&hwc->prev_count);
-	now = atomic64_read(&hwc->count);
-	if (atomic64_cmpxchg(&hwc->prev_count, prev, now) != prev)
-		goto again;
+	old = val = atomic64_read(&hwc->period_left);
+	if (val < 0)
+		return 0;
 
-	delta = now - prev;
+	nr = div64_u64(period + val, period);
+	offset = nr * period;
+	val -= offset;
+	if (atomic64_cmpxchg(&hwc->period_left, old, val) != old)
+		goto again;
 
-	atomic64_add(delta, &counter->count);
-	atomic64_sub(delta, &hwc->period_left);
+	return nr;
 }
 
-static void perf_swcounter_set_period(struct perf_counter *counter)
+static void perf_swcounter_overflow(struct perf_counter *counter,
+				    int nmi, struct perf_sample_data *data)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
-	s64 left = atomic64_read(&hwc->period_left);
-	s64 period = hwc->sample_period;
+	u64 overflow;
 
-	if (unlikely(left <= -period)) {
-		left = period;
-		atomic64_set(&hwc->period_left, left);
-		hwc->last_period = period;
-	}
+	data->period = counter->hw.last_period;
+	overflow = perf_swcounter_set_period(counter);
 
-	if (unlikely(left <= 0)) {
-		left += period;
-		atomic64_add(period, &hwc->period_left);
-		hwc->last_period = period;
-	}
+	if (hwc->interrupts == MAX_INTERRUPTS)
+		return;
 
-	atomic64_set(&hwc->prev_count, -left);
-	atomic64_set(&hwc->count, -left);
+	for (; overflow; overflow--) {
+		if (perf_counter_overflow(counter, nmi, data)) {
+			/*
+			 * We inhibit the overflow from happening when
+			 * hwc->interrupts == MAX_INTERRUPTS.
+			 */
+			break;
+		}
+	}
 }
 
-static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
+static void perf_swcounter_unthrottle(struct perf_counter *counter)
 {
-	enum hrtimer_restart ret = HRTIMER_RESTART;
-	struct perf_sample_data data;
-	struct perf_counter *counter;
-	u64 period;
-
-	counter	= container_of(hrtimer, struct perf_counter, hw.hrtimer);
-	counter->pmu->read(counter);
-
-	data.addr = 0;
-	data.regs = get_irq_regs();
 	/*
-	 * In case we exclude kernel IPs or are somehow not in interrupt
-	 * context, provide the next best thing, the user IP.
+	 * Nothing to do, we already reset hwc->interrupts.
 	 */
-	if ((counter->attr.exclude_kernel || !data.regs) &&
-			!counter->attr.exclude_user)
-		data.regs = task_pt_regs(current);
+}
 
-	if (data.regs) {
-		if (perf_counter_overflow(counter, 0, &data))
-			ret = HRTIMER_NORESTART;
-	}
+static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
+			       int nmi, struct perf_sample_data *data)
+{
+	struct hw_perf_counter *hwc = &counter->hw;
 
-	period = max_t(u64, 10000, counter->hw.sample_period);
-	hrtimer_forward_now(hrtimer, ns_to_ktime(period));
+	atomic64_add(nr, &counter->count);
 
-	return ret;
-}
+	if (!hwc->sample_period)
+		return;
 
-static void perf_swcounter_overflow(struct perf_counter *counter,
-				    int nmi, struct perf_sample_data *data)
-{
-	data->period = counter->hw.last_period;
+	if (!data->regs)
+		return;
 
-	perf_swcounter_update(counter);
-	perf_swcounter_set_period(counter);
-	if (perf_counter_overflow(counter, nmi, data))
-		/* soft-disable the counter */
-		;
+	if (!atomic64_add_negative(nr, &hwc->period_left))
+		perf_swcounter_overflow(counter, nmi, data);
 }
 
 static int perf_swcounter_is_counting(struct perf_counter *counter)
@@ -3456,15 +3450,6 @@ static int perf_swcounter_match(struct p
 	return 1;
 }
 
-static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
-			       int nmi, struct perf_sample_data *data)
-{
-	int neg = atomic64_add_negative(nr, &counter->hw.count);
-
-	if (counter->hw.sample_period && !neg && data->regs)
-		perf_swcounter_overflow(counter, nmi, data);
-}
-
 static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 				     enum perf_type_id type,
 				     u32 event, u64 nr, int nmi,
@@ -3543,27 +3528,66 @@ void __perf_swcounter_event(u32 event, u
 
 static void perf_swcounter_read(struct perf_counter *counter)
 {
-	perf_swcounter_update(counter);
 }
 
 static int perf_swcounter_enable(struct perf_counter *counter)
 {
-	perf_swcounter_set_period(counter);
+	struct hw_perf_counter *hwc = &counter->hw;
+
+	if (hwc->sample_period) {
+		hwc->last_period = hwc->sample_period;
+		perf_swcounter_set_period(counter);
+	}
 	return 0;
 }
 
 static void perf_swcounter_disable(struct perf_counter *counter)
 {
-	perf_swcounter_update(counter);
 }
 
 static const struct pmu perf_ops_generic = {
 	.enable		= perf_swcounter_enable,
 	.disable	= perf_swcounter_disable,
 	.read		= perf_swcounter_read,
+	.unthrottle	= perf_swcounter_unthrottle,
 };
 
 /*
+ * hrtimer based swcounter callback
+ */
+
+static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
+{
+	enum hrtimer_restart ret = HRTIMER_RESTART;
+	struct perf_sample_data data;
+	struct perf_counter *counter;
+	u64 period;
+
+	counter	= container_of(hrtimer, struct perf_counter, hw.hrtimer);
+	counter->pmu->read(counter);
+
+	data.addr = 0;
+	data.regs = get_irq_regs();
+	/*
+	 * In case we exclude kernel IPs or are somehow not in interrupt
+	 * context, provide the next best thing, the user IP.
+	 */
+	if ((counter->attr.exclude_kernel || !data.regs) &&
+			!counter->attr.exclude_user)
+		data.regs = task_pt_regs(current);
+
+	if (data.regs) {
+		if (perf_counter_overflow(counter, 0, &data))
+			ret = HRTIMER_NORESTART;
+	}
+
+	period = max_t(u64, 10000, counter->hw.sample_period);
+	hrtimer_forward_now(hrtimer, ns_to_ktime(period));
+
+	return ret;
+}
+
+/*
  * Software counter: cpu wall time clock
  */
 

-- 

