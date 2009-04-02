Return-Path: <linux-kernel-owner+w=401wt.eu-S1763463AbZDBTrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763463AbZDBTrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZDBTrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:47:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:53525 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbZDBTra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:47:30 -0400
Date: Thu, 2 Apr 2009 19:45:32 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313112301.096138802@chello.nl>
References: <20090313112301.096138802@chello.nl>
Subject: [tip:timers/urgent] hrtimer: fix rq->lock inversion (again)
Message-ID: <tip-4f70f0be7dd540085b5ac54e1191e212fae1478d@git.kernel.org>
Git-Commit-ID: 4f70f0be7dd540085b5ac54e1191e212fae1478d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 19:45:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f70f0be7dd540085b5ac54e1191e212fae1478d
Gitweb:     http://git.kernel.org/tip/4f70f0be7dd540085b5ac54e1191e212fae1478d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 13 Mar 2009 12:21:27 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Apr 2009 18:26:13 +0200

hrtimer: fix rq->lock inversion (again)

It appears I inadvertly introduced rq->lock recursion to the
hrtimer_start() path when I delegated running already expired
timers to softirq context.

This patch fixes it by introducing a __hrtimer_start_range_ns()
method that will not use raise_softirq_irqoff() but
__raise_softirq_irqoff() which avoids the wakeup.

It then also changes schedule() to check for pending softirqs and
do the wakeup then, I'm not quite sure I like this last bit, nor
am I convinced its really needed.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus@samba.org
LKML-Reference: <20090313112301.096138802@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/hrtimer.h   |    5 ++++
 include/linux/interrupt.h |    1 +
 kernel/hrtimer.c          |   55 +++++++++++++++++++++++++++-----------------
 kernel/sched.c            |   14 +++++++++--
 kernel/softirq.c          |    2 +-
 5 files changed, 52 insertions(+), 25 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index bd37078..0d2f7c8 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -336,6 +336,11 @@ extern int hrtimer_start(struct hrtimer *timer, ktime_t tim,
 			 const enum hrtimer_mode mode);
 extern int hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 			unsigned long range_ns, const enum hrtimer_mode mode);
+extern int
+__hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
+			 unsigned long delta_ns,
+			 const enum hrtimer_mode mode, int wakeup);
+
 extern int hrtimer_cancel(struct hrtimer *timer);
 extern int hrtimer_try_to_cancel(struct hrtimer *timer);
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 9127f6b..564d1c0 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -274,6 +274,7 @@ extern void softirq_init(void);
 #define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
 extern void raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq(unsigned int nr);
+extern void wakeup_softirqd(void);
 
 /* This is the worklist that queues up per-cpu softirq work.
  *
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index f394d2a..cb8a15c 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -651,14 +651,20 @@ static inline void hrtimer_init_timer_hres(struct hrtimer *timer)
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
 
@@ -703,7 +709,8 @@ static inline int hrtimer_is_hres_enabled(void) { return 0; }
 static inline int hrtimer_switch_to_hres(void) { return 0; }
 static inline void hrtimer_force_reprogram(struct hrtimer_cpu_base *base) { }
 static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
-					    struct hrtimer_clock_base *base)
+					    struct hrtimer_clock_base *base,
+					    int wakeup)
 {
 	return 0;
 }
@@ -886,20 +893,9 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
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
@@ -940,12 +936,29 @@ hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim, unsigned long delta_n
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
@@ -961,7 +974,7 @@ EXPORT_SYMBOL_GPL(hrtimer_start_range_ns);
 int
 hrtimer_start(struct hrtimer *timer, ktime_t tim, const enum hrtimer_mode mode)
 {
-	return hrtimer_start_range_ns(timer, tim, 0, mode);
+	return __hrtimer_start_range_ns(timer, tim, 0, mode, 1);
 }
 EXPORT_SYMBOL_GPL(hrtimer_start);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 8e2558c..e46ae81 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -231,13 +231,20 @@ static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
 
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
@@ -1129,7 +1136,8 @@ static __init void init_hrtick(void)
  */
 static void hrtick_start(struct rq *rq, u64 delay)
 {
-	hrtimer_start(&rq->hrtick_timer, ns_to_ktime(delay), HRTIMER_MODE_REL);
+	__hrtimer_start_range_ns(&rq->hrtick_timer, ns_to_ktime(delay), 0,
+			HRTIMER_MODE_REL, 0);
 }
 
 static inline void init_hrtick(void)
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 9041ea7..d2b183e 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -58,7 +58,7 @@ static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
  * to the pending events, so lets the scheduler to balance
  * the softirq load for us.
  */
-static inline void wakeup_softirqd(void)
+void wakeup_softirqd(void)
 {
 	/* Interrupts are disabled: no need to stop preemption */
 	struct task_struct *tsk = __get_cpu_var(ksoftirqd);
