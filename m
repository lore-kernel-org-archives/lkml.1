Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbZAELor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbZAELor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZAELnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:43:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:55626 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbZAELnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:43:01 -0500
Message-Id: <20090105103136.454115015@chello.nl>
References: <20090105102818.829119334@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 05 Jan 2009 11:28:22 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/5] hrtimer: fix recursion deadlock by re-introducing the softirq
Content-Disposition: inline; filename=hrtimer-reintroduce-softirq.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few sites that do:

  spin_lock_irq(&foo)
  hrtimer_start(&bar)
    __run_hrtimer(&bar)
      func()
        spin_lock(&foo)

which obviously deadlocks. In order to avoid this, never call __run_hrtimer()
from hrtimer_start*() context, but instead defer this to softirq context.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/interrupt.h |    3 ++
 kernel/hrtimer.c          |   60 ++++++++++++++++++++--------------------------
 2 files changed, 30 insertions(+), 33 deletions(-)

Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -253,6 +253,9 @@ enum
 	BLOCK_SOFTIRQ,
 	TASKLET_SOFTIRQ,
 	SCHED_SOFTIRQ,
+#ifdef CONFIG_HIGH_RES_TIMERS
+	HRTIMER_SOFTIRQ,
+#endif
 	RCU_SOFTIRQ, 	/* Preferable RCU should always be the last softirq */
 
 	NR_SOFTIRQS
Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -634,7 +634,6 @@ static inline void hrtimer_init_timer_hr
 {
 }
 
-static void __run_hrtimer(struct hrtimer *timer);
 
 /*
  * When High resolution timers are active, try to reprogram. Note, that in case
@@ -646,13 +645,9 @@ static inline int hrtimer_enqueue_reprog
 					    struct hrtimer_clock_base *base)
 {
 	if (base->cpu_base->hres_active && hrtimer_reprogram(timer, base)) {
-		/*
-		 * XXX: recursion check?
-		 * hrtimer_forward() should round up with timer granularity
-		 * so that we never get into inf recursion here,
-		 * it doesn't do that though
-		 */
-		__run_hrtimer(timer);
+		spin_unlock(&base->cpu_base->lock);
+		raise_softirq_irqoff(HRTIMER_SOFTIRQ);
+		spin_lock(&base->cpu_base->lock);
 		return 1;
 	}
 	return 0;
@@ -705,11 +698,6 @@ static inline int hrtimer_enqueue_reprog
 }
 static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base) { }
 static inline void hrtimer_init_timer_hres(struct hrtimer *timer) { }
-static inline int hrtimer_reprogram(struct hrtimer *timer,
-				    struct hrtimer_clock_base *base)
-{
-	return 0;
-}
 
 #endif /* CONFIG_HIGH_RES_TIMERS */
 
@@ -780,9 +768,11 @@ EXPORT_SYMBOL_GPL(hrtimer_forward);
  *
  * The timer is inserted in expiry order. Insertion into the
  * red black tree is O(log(n)). Must hold the base lock.
+ *
+ * Returns 1 when the new timer is the leftmost timer in the tree.
  */
-static void enqueue_hrtimer(struct hrtimer *timer,
-			    struct hrtimer_clock_base *base, int reprogram)
+static int enqueue_hrtimer(struct hrtimer *timer,
+			   struct hrtimer_clock_base *base)
 {
 	struct rb_node **link = &base->active.rb_node;
 	struct rb_node *parent = NULL;
@@ -814,20 +804,8 @@ static void enqueue_hrtimer(struct hrtim
 	 * Insert the timer to the rbtree and check whether it
 	 * replaces the first pending timer
 	 */
-	if (leftmost) {
-		/*
-		 * Reprogram the clock event device. When the timer is already
-		 * expired hrtimer_enqueue_reprogram has either called the
-		 * callback or added it to the pending list and raised the
-		 * softirq.
-		 *
-		 * This is a NOP for !HIGHRES
-		 */
-		if (reprogram && hrtimer_enqueue_reprogram(timer, base))
-			return;
-
+	if (leftmost)
 		base->first = &timer->node;
-	}
 
 	rb_link_node(&timer->node, parent, link);
 	rb_insert_color(&timer->node, &base->active);
@@ -836,6 +814,8 @@ static void enqueue_hrtimer(struct hrtim
 	 * state of a possibly running callback.
 	 */
 	timer->state |= HRTIMER_STATE_ENQUEUED;
+
+	return leftmost;
 }
 
 /*
@@ -912,7 +892,7 @@ hrtimer_start_range_ns(struct hrtimer *t
 {
 	struct hrtimer_clock_base *base, *new_base;
 	unsigned long flags;
-	int ret;
+	int ret, leftmost;
 
 	base = lock_hrtimer_base(timer, &flags);
 
@@ -940,12 +920,16 @@ hrtimer_start_range_ns(struct hrtimer *t
 
 	timer_stats_hrtimer_set_start_info(timer);
 
+	leftmost = enqueue_hrtimer(timer, new_base);
+
 	/*
 	 * Only allow reprogramming if the new base is on this CPU.
 	 * (it might still be on another CPU if the timer was pending)
+	 *
+	 * XXX send_remote_softirq() ?
 	 */
-	enqueue_hrtimer(timer, new_base,
-			new_base->cpu_base == &__get_cpu_var(hrtimer_bases));
+	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases))
+		hrtimer_enqueue_reprogram(timer, new_base);
 
 	unlock_hrtimer_base(timer, &flags);
 
@@ -1163,7 +1147,7 @@ static void __run_hrtimer(struct hrtimer
 	 */
 	if (restart != HRTIMER_NORESTART) {
 		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
-		enqueue_hrtimer(timer, base, 0);
+		enqueue_hrtimer(timer, base);
 	}
 	timer->state &= ~HRTIMER_STATE_CALLBACK;
 }
@@ -1305,6 +1289,11 @@ void hrtimer_peek_ahead_timers(void)
 	local_irq_restore(flags);
 }
 
+static void run_hrtimer_softirq(struct softirq_action *h)
+{
+	hrtimer_peek_ahead_timers();
+}
+
 #endif	/* CONFIG_HIGH_RES_TIMERS */
 
 /*
@@ -1560,7 +1549,7 @@ static void migrate_hrtimer_list(struct 
 		 * is done, which will run all expired timers and re-programm
 		 * the timer device.
 		 */
-		enqueue_hrtimer(timer, new_base, 0);
+		enqueue_hrtimer(timer, new_base);
 
 		/* Clear the migration state bit */
 		timer->state &= ~HRTIMER_STATE_MIGRATE;
@@ -1642,6 +1631,9 @@ void __init hrtimers_init(void)
 	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
 			  (void *)(long)smp_processor_id());
 	register_cpu_notifier(&hrtimers_nb);
+#ifdef CONFIG_HIGH_RES_TIMERS
+	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq);
+#endif
 }
 
 /**

-- 

