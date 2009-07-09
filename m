Return-Path: <linux-kernel-owner+w=401wt.eu-S1760227AbZGIKmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbZGIKmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 06:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757388AbZGIKmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 06:42:38 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:13876 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159AbZGIKmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 06:42:37 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/8] Fix hrtick handling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090615190528.GL21741@gandalf.sssup.it>
References: <cover.1245092261.git.fabio@helm.retis>
	 <20090615190528.GL21741@gandalf.sssup.it>
Content-Type: text/plain
Date: Thu, 09 Jul 2009 12:42:30 +0200
Message-Id: <1247136150.9777.363.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 21:05 +0200, Fabio Checconi wrote:
> The current hrtick implementation can end up asking to the hrtimer code
> to wake up ksoftirqd while holding rq->lock, causing a spinlock recursion.
> This patch uses __hrtimer_start_range_ns() to disable the wakeup in the
> reprogramming path.

Right, A while back I did the following patch and handed that to someone
on IRC to continue with, but I guess that never happened.

The thing that currently gets us into trouble is that when we
hrtimer_start() an already expired timer we try to run it in place.
However we cannot do that in context because we might start the timer
under locks that the timer callback also wants, leading to a deadlock.

The current solution is to queue it in a softirq and kick the softirq.
This however has the problem that we cannot do a wakeup when holding the
rq->lock, which is where __hrtimer_start*() enters.

We can avoid all of this mess by simply failing the hrtimer_start*()
with -ETIME when we pass it an already expired timer, which is what the
below patch does.

All that needs doing is (testing and possibly fwd porting this patch,
its a few weeks old now) auditing all hrtimer usage sites to make sure
the new behaviour does as expected etc..

Not-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/hrtimer.h   |    5 ---
 include/linux/interrupt.h |    1 -
 kernel/hrtimer.c          |   75 ++++++++++++++++++---------------------------
 kernel/perf_counter.c     |   27 ++++++++++++----
 kernel/sched.c            |   15 +++------
 5 files changed, 55 insertions(+), 68 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index dd44de5..46a9951 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -339,11 +339,6 @@ extern int hrtimer_start(struct hrtimer *timer, ktime_t tim,
 			 const enum hrtimer_mode mode);
 extern int hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 			unsigned long range_ns, const enum hrtimer_mode mode);
-extern int
-__hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
-			 unsigned long delta_ns,
-			 const enum hrtimer_mode mode, int wakeup);
-
 extern int hrtimer_cancel(struct hrtimer *timer);
 extern int hrtimer_try_to_cancel(struct hrtimer *timer);
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index dd574d5..62d3073 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -337,7 +337,6 @@ enum
 	BLOCK_SOFTIRQ,
 	TASKLET_SOFTIRQ,
 	SCHED_SOFTIRQ,
-	HRTIMER_SOFTIRQ,
 	RCU_SOFTIRQ,	/* Preferable RCU should always be the last softirq */
 
 	NR_SOFTIRQS
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 050382e..ba85ffd 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -699,19 +699,10 @@ static inline void hrtimer_init_timer_hres(struct hrtimer *timer)
  * and expiry check is done in the hrtimer_interrupt or in the softirq.
  */
 static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base,
-					    int wakeup)
+					    struct hrtimer_clock_base *base)
 {
-	if (base->cpu_base->hres_active && hrtimer_reprogram(timer, base)) {
-		if (wakeup) {
-			spin_unlock(&base->cpu_base->lock);
-			raise_softirq_irqoff(HRTIMER_SOFTIRQ);
-			spin_lock(&base->cpu_base->lock);
-		} else
-			__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
-
-		return 1;
-	}
+	if (base->cpu_base->hres_active && hrtimer_reprogram(timer, base))
+		return -ETIME;
 
 	return 0;
 }
@@ -941,18 +932,31 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 	return 0;
 }
 
-int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
-		unsigned long delta_ns, const enum hrtimer_mode mode,
-		int wakeup)
+/**
+ * hrtimer_start_range_ns - (re)start an hrtimer on the current CPU
+ * @timer:	the timer to be added
+ * @tim:	expiry time
+ * @delta_ns:	"slack" range for the timer
+ * @mode:	expiry mode: absolute (HRTIMER_ABS) or relative (HRTIMER_REL)
+ *
+ * Returns:
+ *  0       on success
+ *  -EEXIST when the timer was active
+ *  -ETIME  when the timer has already expired
+ */
+int hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
+		unsigned long delta_ns, const enum hrtimer_mode mode)
 {
 	struct hrtimer_clock_base *base, *new_base;
 	unsigned long flags;
-	int ret, leftmost;
+	int tmp, leftmost, ret = 0;
 
 	base = lock_hrtimer_base(timer, &flags);
 
 	/* Remove an active timer from the queue: */
-	ret = remove_hrtimer(timer, base);
+	tmp = remove_hrtimer(timer, base);
+	if (tmp)
+		ret = -EEXIST;
 
 	/* Switch the timer base, if necessary: */
 	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
@@ -983,30 +987,19 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	 *
 	 * XXX send_remote_softirq() ?
 	 */
-	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases))
-		hrtimer_enqueue_reprogram(timer, new_base, wakeup);
+	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)) {
+		tmp = hrtimer_enqueue_reprogram(timer, new_base);
+		if (tmp < 0) {
+			__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
+					 reprogram);
+			ret = tmp;
+		}
+	}
 
 	unlock_hrtimer_base(timer, &flags);
 
 	return ret;
 }
-
-/**
- * hrtimer_start_range_ns - (re)start an hrtimer on the current CPU
- * @timer:	the timer to be added
- * @tim:	expiry time
- * @delta_ns:	"slack" range for the timer
- * @mode:	expiry mode: absolute (HRTIMER_ABS) or relative (HRTIMER_REL)
- *
- * Returns:
- *  0 on success
- *  1 when the timer was active
- */
-int hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
-		unsigned long delta_ns, const enum hrtimer_mode mode)
-{
-	return __hrtimer_start_range_ns(timer, tim, delta_ns, mode, 1);
-}
 EXPORT_SYMBOL_GPL(hrtimer_start_range_ns);
 
 /**
@@ -1022,7 +1015,7 @@ EXPORT_SYMBOL_GPL(hrtimer_start_range_ns);
 int
 hrtimer_start(struct hrtimer *timer, ktime_t tim, const enum hrtimer_mode mode)
 {
-	return __hrtimer_start_range_ns(timer, tim, 0, mode, 1);
+	return hrtimer_start_range_ns(timer, tim, 0, mode);
 }
 EXPORT_SYMBOL_GPL(hrtimer_start);
 
@@ -1361,11 +1354,6 @@ void hrtimer_peek_ahead_timers(void)
 	local_irq_restore(flags);
 }
 
-static void run_hrtimer_softirq(struct softirq_action *h)
-{
-	hrtimer_peek_ahead_timers();
-}
-
 #else /* CONFIG_HIGH_RES_TIMERS */
 
 static inline void __hrtimer_peek_ahead_timers(void) { }
@@ -1705,9 +1693,6 @@ void __init hrtimers_init(void)
 	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
 			  (void *)(long)smp_processor_id());
 	register_cpu_notifier(&hrtimers_nb);
-#ifdef CONFIG_HIGH_RES_TIMERS
-	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq);
-#endif
 }
 
 /**
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index ef5d8a5..a5c0ac3 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3308,15 +3308,22 @@ static int cpu_clock_perf_counter_enable(struct perf_counter *counter)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
 	int cpu = raw_smp_processor_id();
+	u64 period;
+	int ret;
 
 	atomic64_set(&hwc->prev_count, cpu_clock(cpu));
 	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hwc->hrtimer.function = perf_swcounter_hrtimer;
 	if (hwc->sample_period) {
-		u64 period = max_t(u64, 10000, hwc->sample_period);
-		__hrtimer_start_range_ns(&hwc->hrtimer,
+again:
+		period = max_t(u64, 10000, hwc->sample_period);
+		ret = hrtimer_start_range_ns(&hwc->hrtimer,
 				ns_to_ktime(period), 0,
-				HRTIMER_MODE_REL, 0);
+				HRTIMER_MODE_REL);
+		if (ret == -ETIME) {
+			hwc->sample_period += period;
+			goto again;
+		}
 	}
 
 	return 0;
@@ -3357,7 +3364,8 @@ static void task_clock_perf_counter_update(struct perf_counter *counter, u64 now
 static int task_clock_perf_counter_enable(struct perf_counter *counter)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
-	u64 now;
+	u64 period, now;
+	int ret;
 
 	now = counter->ctx->time;
 
@@ -3365,10 +3373,15 @@ static int task_clock_perf_counter_enable(struct perf_counter *counter)
 	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hwc->hrtimer.function = perf_swcounter_hrtimer;
 	if (hwc->sample_period) {
-		u64 period = max_t(u64, 10000, hwc->sample_period);
-		__hrtimer_start_range_ns(&hwc->hrtimer,
+again:
+		period = max_t(u64, 10000, hwc->sample_period);
+		ret = hrtimer_start_range_ns(&hwc->hrtimer,
 				ns_to_ktime(period), 0,
-				HRTIMER_MODE_REL, 0);
+				HRTIMER_MODE_REL);
+		if (ret == -ETIME) {
+			hwc->sample_period += period;
+			goto again:
+		}
 	}
 
 	return 0;
diff --git a/kernel/sched.c b/kernel/sched.c
index 92dbda2..4157b1c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -228,20 +228,15 @@ static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
 
 	spin_lock(&rt_b->rt_runtime_lock);
 	for (;;) {
-		unsigned long delta;
-		ktime_t soft, hard;
 
 		if (hrtimer_active(&rt_b->rt_period_timer))
 			break;
 
 		now = hrtimer_cb_get_time(&rt_b->rt_period_timer);
-		hrtimer_forward(&rt_b->rt_period_timer, now, rt_b->rt_period);
 
-		soft = hrtimer_get_softexpires(&rt_b->rt_period_timer);
-		hard = hrtimer_get_expires(&rt_b->rt_period_timer);
-		delta = ktime_to_ns(ktime_sub(hard, soft));
-		__hrtimer_start_range_ns(&rt_b->rt_period_timer, soft, delta,
-				HRTIMER_MODE_ABS_PINNED, 0);
+		hrtimer_forward(&rt_b->rt_period_timer, now, rt_b->rt_period);
+		hrtimer_start_expires(&rt_b->rt_period_timer,
+				HRTIMER_MODE_ABS_PINNED);
 	}
 	spin_unlock(&rt_b->rt_runtime_lock);
 }
@@ -1155,8 +1150,8 @@ static __init void init_hrtick(void)
  */
 static void hrtick_start(struct rq *rq, u64 delay)
 {
-	__hrtimer_start_range_ns(&rq->hrtick_timer, ns_to_ktime(delay), 0,
-			HRTIMER_MODE_REL_PINNED, 0);
+	hrtimer_start_range_ns(&rq->hrtick_timer, ns_to_ktime(delay), 0,
+			HRTIMER_MODE_REL_PINNED);
 }
 
 static inline void init_hrtick(void)


