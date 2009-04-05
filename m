Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbZDEWTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbZDEWTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 18:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZDEWTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 18:19:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37885 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbZDEWTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 18:19:39 -0400
Date: Mon, 6 Apr 2009 00:19:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] locking updates
Message-ID: <20090405221920.GA20527@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git locking-for-linus

These are two bits from Peter which were still cooking independently 
of other locking items, but which are ready now.

 Thanks,

	Ingo

------------------>
Peter Zijlstra (2):
      hrtimer: fix rq->lock inversion (again)
      lockdep: add stack dumps to asserts


 include/linux/hrtimer.h   |    5 ++++
 include/linux/interrupt.h |    1 +
 kernel/hrtimer.c          |   55 +++++++++++++++++++++++++++-----------------
 kernel/lockdep.c          |    5 ++++
 kernel/sched.c            |   14 +++++++++--
 kernel/softirq.c          |    2 +-
 6 files changed, 57 insertions(+), 25 deletions(-)

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
index c68bffd..4528bf7 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -294,6 +294,7 @@ extern void softirq_init(void);
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
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 981cd48..a288ae1 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -792,6 +792,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 
 		printk("BUG: MAX_LOCKDEP_KEYS too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		dump_stack();
 		return NULL;
 	}
 	class = lock_classes + nr_lock_classes++;
@@ -855,6 +856,7 @@ static struct lock_list *alloc_list_entry(void)
 
 		printk("BUG: MAX_LOCKDEP_ENTRIES too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		dump_stack();
 		return NULL;
 	}
 	return list_entries + nr_list_entries++;
@@ -1681,6 +1683,7 @@ cache_hit:
 
 		printk("BUG: MAX_LOCKDEP_CHAINS too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		dump_stack();
 		return 0;
 	}
 	chain = lock_chains + nr_lock_chains++;
@@ -2540,6 +2543,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		debug_locks_off();
 		printk("BUG: MAX_LOCKDEP_SUBCLASSES too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		dump_stack();
 		return 0;
 	}
 
@@ -2636,6 +2640,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		debug_locks_off();
 		printk("BUG: MAX_LOCK_DEPTH too low!\n");
 		printk("turning off the locking correctness validator.\n");
+		dump_stack();
 		return 0;
 	}
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 196d48b..63256e3 100644
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
@@ -1146,7 +1153,8 @@ static __init void init_hrtick(void)
  */
 static void hrtick_start(struct rq *rq, u64 delay)
 {
-	hrtimer_start(&rq->hrtick_timer, ns_to_ktime(delay), HRTIMER_MODE_REL);
+	__hrtimer_start_range_ns(&rq->hrtick_timer, ns_to_ktime(delay), 0,
+			HRTIMER_MODE_REL, 0);
 }
 
 static inline void init_hrtick(void)
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 4877516..accc851 100644
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
