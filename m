Return-Path: <linux-kernel-owner+w=401wt.eu-S1759073AbZCML03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073AbZCML03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbZCMLXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:23:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:42379 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbZCMLXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:23:47 -0400
Message-Id: <20090313112301.096138802@chello.nl>
References: <20090313112125.886730125@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 13 Mar 2009 12:21:27 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/11] hrtimer: fix rq->lock inversion (again)
Content-Disposition: inline; filename=hrtimer-softirq.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears I inadvertly introduced rq->lock recursion to the hrtimer_start()
path when I delegated running already expired timers to softirq context.

This patch fixes it by introducing a __hrtimer_start_range_ns() method that
will not use raise_softirq_irqoff() but __raise_softirq_irqoff() which avoids
the wakeup.

It then also changes schedule() to check for pending softirqs and do the wakeup
then, I'm not quite sure I like this last bit, nor am I convinced its really
needed.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/interrupt.h |    1 
 kernel/hrtimer.c          |   55 ++++++++++++++++++++++++++++------------------
 kernel/sched.c            |   17 +++++++++++---
 kernel/softirq.c          |    2 -
 4 files changed, 50 insertions(+), 25 deletions(-)

Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -651,14 +651,20 @@ static inline void hrtimer_init_timer_hr
  * and expiry check is done in the hrtimer_interrupt or in the softirq.
  */
 static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base)
+					    struct hrtimer_clock_base *base,
+					    int wakeup)
 {
 	if (base->cpu_base->hres_active && hrtimer_reprogram(timer, base)) {
-		spin_unlock(&base->cpu_base->lock);
-		raise_softirq_irqoff(HRTIMER_SOFTIRQ);
-		spin_lock(&base->cpu_base->lock);
+		if (wakeup) {
+			spin_unlock(&base->cpu_base->lock);
+			raise_softirq_irqoff(HRTIMER_SOFTIRQ);
+			spin_lock(&base->cpu_base->lock);
+		} else
+			__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
+
 		return 1;
 	}
+
 	return 0;
 }
 
@@ -703,7 +709,8 @@ static inline int hrtimer_is_hres_enable
 static inline int hrtimer_switch_to_hres(void) { return 0; }
 static inline void hrtimer_force_reprogram(struct hrtimer_cpu_base *base) { }
 static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base)
+					    struct hrtimer_clock_base *base,
+					    int wakeup)
 {
 	return 0;
 }
@@ -886,20 +893,9 @@ remove_hrtimer(struct hrtimer *timer, st
 	return 0;
 }
 
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
-int
-hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim, unsigned long delta_ns,
-			const enum hrtimer_mode mode)
+int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
+		unsigned long delta_ns, const enum hrtimer_mode mode,
+		int wakeup)
 {
 	struct hrtimer_clock_base *base, *new_base;
 	unsigned long flags;
@@ -940,12 +936,29 @@ hrtimer_start_range_ns(struct hrtimer *t
 	 * XXX send_remote_softirq() ?
 	 */
 	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases))
-		hrtimer_enqueue_reprogram(timer, new_base);
+		hrtimer_enqueue_reprogram(timer, new_base, wakeup);
 
 	unlock_hrtimer_base(timer, &flags);
 
 	return ret;
 }
+
+/**
+ * hrtimer_start_range_ns - (re)start an hrtimer on the current CPU
+ * @timer:	the timer to be added
+ * @tim:	expiry time
+ * @delta_ns:	"slack" range for the timer
+ * @mode:	expiry mode: absolute (HRTIMER_ABS) or relative (HRTIMER_REL)
+ *
+ * Returns:
+ *  0 on success
+ *  1 when the timer was active
+ */
+int hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
+		unsigned long delta_ns, const enum hrtimer_mode mode)
+{
+	return __hrtimer_start_range_ns(timer, tim, delta_ns, mode, 1);
+}
 EXPORT_SYMBOL_GPL(hrtimer_start_range_ns);
 
 /**
@@ -961,7 +974,7 @@ EXPORT_SYMBOL_GPL(hrtimer_start_range_ns
 int
 hrtimer_start(struct hrtimer *timer, ktime_t tim, const enum hrtimer_mode mode)
 {
-	return hrtimer_start_range_ns(timer, tim, 0, mode);
+	return __hrtimer_start_range_ns(timer, tim, 0, mode, 1);
 }
 EXPORT_SYMBOL_GPL(hrtimer_start);
 
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -231,13 +231,20 @@ static void start_rt_bandwidth(struct rt
 
 	spin_lock(&rt_b->rt_runtime_lock);
 	for (;;) {
+		unsigned long delta;
+		ktime_t soft, hard;
+
 		if (hrtimer_active(&rt_b->rt_period_timer))
 			break;
 
 		now = hrtimer_cb_get_time(&rt_b->rt_period_timer);
 		hrtimer_forward(&rt_b->rt_period_timer, now, rt_b->rt_period);
-		hrtimer_start_expires(&rt_b->rt_period_timer,
-				HRTIMER_MODE_ABS);
+
+		soft = hrtimer_get_softexpires(&rt_b->rt_period_timer);
+		hard = hrtimer_get_expires(&rt_b->rt_period_timer);
+		delta = ktime_to_ns(ktime_sub(hard, soft));
+		__hrtimer_start_range_ns(&rt_b->rt_period_timer, soft, delta,
+				HRTIMER_MODE_ABS, 0);
 	}
 	spin_unlock(&rt_b->rt_runtime_lock);
 }
@@ -1170,7 +1177,8 @@ static __init void init_hrtick(void)
  */
 static void hrtick_start(struct rq *rq, u64 delay)
 {
-	hrtimer_start(&rq->hrtick_timer, ns_to_ktime(delay), HRTIMER_MODE_REL);
+	__hrtimer_start_range_ns(&rq->hrtick_timer, ns_to_ktime(delay), 0,
+			HRTIMER_MODE_REL, 0);
 }
 
 static inline void init_hrtick(void)
@@ -4830,6 +4838,9 @@ need_resched_nonpreemptible:
 	if (unlikely(reacquire_kernel_lock(current) < 0))
 		goto need_resched_nonpreemptible;
 
+	if (unlikely(local_softirq_pending()))
+		wakeup_softirqd();
+
 	preempt_enable_no_resched();
 	if (need_resched())
 		goto need_resched;
Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -274,6 +274,7 @@ extern void softirq_init(void);
 #define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
 extern void raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq(unsigned int nr);
+extern void wakeup_softirqd(void);
 
 /* This is the worklist that queues up per-cpu softirq work.
  *
Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c
+++ linux-2.6/kernel/softirq.c
@@ -59,7 +59,7 @@ static DEFINE_PER_CPU(struct task_struct
  * to the pending events, so lets the scheduler to balance
  * the softirq load for us.
  */
-static inline void wakeup_softirqd(void)
+void wakeup_softirqd(void)
 {
 	/* Interrupts are disabled: no need to stop preemption */
 	struct task_struct *tsk = __get_cpu_var(ksoftirqd);

-- 

