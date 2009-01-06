Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbZAFQTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbZAFQTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbZAFQSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:18:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52874 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbZAFQSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:18:53 -0500
Date: Tue, 6 Jan 2009 17:18:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] timer fixes
Message-ID: <20090106161843.GA18497@elte.hu>
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

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      hrtimer: splitout peek ahead functionality, fix

Peter Zijlstra (1):
      hrtimer: fix recursion deadlock by re-introducing the softirq

Thomas Gleixner (4):
      hrtimer: splitout peek ahead functionality
      hrtimer: fix HOTPLUG_CPU=n compile warning
      hrtimer: simplify hotplug migration
      hrtimer: fixup comments


 include/linux/interrupt.h |    3 +-
 kernel/hrtimer.c          |  142 ++++++++++++++++++++++-----------------------
 2 files changed, 72 insertions(+), 73 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 0702c4d..2062833 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -253,7 +253,8 @@ enum
 	BLOCK_SOFTIRQ,
 	TASKLET_SOFTIRQ,
 	SCHED_SOFTIRQ,
-	RCU_SOFTIRQ, 	/* Preferable RCU should always be the last softirq */
+	HRTIMER_SOFTIRQ,
+	RCU_SOFTIRQ,	/* Preferable RCU should always be the last softirq */
 
 	NR_SOFTIRQS
 };
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index eb2bfef..1455b76 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -634,7 +634,6 @@ static inline void hrtimer_init_timer_hres(struct hrtimer *timer)
 {
 }
 
-static void __run_hrtimer(struct hrtimer *timer);
 
 /*
  * When High resolution timers are active, try to reprogram. Note, that in case
@@ -646,13 +645,9 @@ static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
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
@@ -705,11 +700,6 @@ static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 }
 static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base) { }
 static inline void hrtimer_init_timer_hres(struct hrtimer *timer) { }
-static inline int hrtimer_reprogram(struct hrtimer *timer,
-				    struct hrtimer_clock_base *base)
-{
-	return 0;
-}
 
 #endif /* CONFIG_HIGH_RES_TIMERS */
 
@@ -780,9 +770,11 @@ EXPORT_SYMBOL_GPL(hrtimer_forward);
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
@@ -814,20 +806,8 @@ static void enqueue_hrtimer(struct hrtimer *timer,
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
@@ -836,6 +816,8 @@ static void enqueue_hrtimer(struct hrtimer *timer,
 	 * state of a possibly running callback.
 	 */
 	timer->state |= HRTIMER_STATE_ENQUEUED;
+
+	return leftmost;
 }
 
 /*
@@ -912,7 +894,7 @@ hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim, unsigned long delta_n
 {
 	struct hrtimer_clock_base *base, *new_base;
 	unsigned long flags;
-	int ret;
+	int ret, leftmost;
 
 	base = lock_hrtimer_base(timer, &flags);
 
@@ -940,12 +922,16 @@ hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim, unsigned long delta_n
 
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
 
@@ -1157,13 +1143,13 @@ static void __run_hrtimer(struct hrtimer *timer)
 	spin_lock(&cpu_base->lock);
 
 	/*
-	 * Note: We clear the CALLBACK bit after enqueue_hrtimer to avoid
-	 * reprogramming of the event hardware. This happens at the end of this
-	 * function anyway.
+	 * Note: We clear the CALLBACK bit after enqueue_hrtimer and
+	 * we do not reprogramm the event hardware. Happens either in
+	 * hrtimer_start_range_ns() or in hrtimer_interrupt()
 	 */
 	if (restart != HRTIMER_NORESTART) {
 		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
-		enqueue_hrtimer(timer, base, 0);
+		enqueue_hrtimer(timer, base);
 	}
 	timer->state &= ~HRTIMER_STATE_CALLBACK;
 }
@@ -1243,6 +1229,22 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	}
 }
 
+/*
+ * local version of hrtimer_peek_ahead_timers() called with interrupts
+ * disabled.
+ */
+static void __hrtimer_peek_ahead_timers(void)
+{
+	struct tick_device *td;
+
+	if (!hrtimer_hres_active())
+		return;
+
+	td = &__get_cpu_var(tick_cpu_device);
+	if (td && td->evtdev)
+		hrtimer_interrupt(td->evtdev);
+}
+
 /**
  * hrtimer_peek_ahead_timers -- run soft-expired timers now
  *
@@ -1254,20 +1256,23 @@ void hrtimer_interrupt(struct clock_event_device *dev)
  */
 void hrtimer_peek_ahead_timers(void)
 {
-	struct tick_device *td;
 	unsigned long flags;
 
-	if (!hrtimer_hres_active())
-		return;
-
 	local_irq_save(flags);
-	td = &__get_cpu_var(tick_cpu_device);
-	if (td && td->evtdev)
-		hrtimer_interrupt(td->evtdev);
+	__hrtimer_peek_ahead_timers();
 	local_irq_restore(flags);
 }
 
-#endif	/* CONFIG_HIGH_RES_TIMERS */
+static void run_hrtimer_softirq(struct softirq_action *h)
+{
+	hrtimer_peek_ahead_timers();
+}
+
+#else /* CONFIG_HIGH_RES_TIMERS */
+
+static inline void __hrtimer_peek_ahead_timers(void) { }
+
+#endif	/* !CONFIG_HIGH_RES_TIMERS */
 
 /*
  * Called from timer softirq every jiffy, expire hrtimers:
@@ -1513,39 +1518,36 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 		__remove_hrtimer(timer, old_base, HRTIMER_STATE_MIGRATE, 0);
 		timer->base = new_base;
 		/*
-		 * Enqueue the timers on the new cpu, but do not reprogram 
-		 * the timer as that would enable a deadlock between
-		 * hrtimer_enqueue_reprogramm() running the timer and us still
-		 * holding a nested base lock.
-		 *
-		 * Instead we tickle the hrtimer interrupt after the migration
-		 * is done, which will run all expired timers and re-programm
-		 * the timer device.
+		 * Enqueue the timers on the new cpu. This does not
+		 * reprogram the event device in case the timer
+		 * expires before the earliest on this CPU, but we run
+		 * hrtimer_interrupt after we migrated everything to
+		 * sort out already expired timers and reprogram the
+		 * event device.
 		 */
-		enqueue_hrtimer(timer, new_base, 0);
+		enqueue_hrtimer(timer, new_base);
 
 		/* Clear the migration state bit */
 		timer->state &= ~HRTIMER_STATE_MIGRATE;
 	}
 }
 
-static int migrate_hrtimers(int scpu)
+static void migrate_hrtimers(int scpu)
 {
 	struct hrtimer_cpu_base *old_base, *new_base;
-	int dcpu, i;
+	int i;
 
 	BUG_ON(cpu_online(scpu));
-	old_base = &per_cpu(hrtimer_bases, scpu);
-	new_base = &get_cpu_var(hrtimer_bases);
-
-	dcpu = smp_processor_id();
-
 	tick_cancel_sched_timer(scpu);
+
+	local_irq_disable();
+	old_base = &per_cpu(hrtimer_bases, scpu);
+	new_base = &__get_cpu_var(hrtimer_bases);
 	/*
 	 * The caller is globally serialized and nobody else
 	 * takes two locks at once, deadlock is not possible.
 	 */
-	spin_lock_irq(&new_base->lock);
+	spin_lock(&new_base->lock);
 	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
@@ -1554,15 +1556,11 @@ static int migrate_hrtimers(int scpu)
 	}
 
 	spin_unlock(&old_base->lock);
-	spin_unlock_irq(&new_base->lock);
-	put_cpu_var(hrtimer_bases);
+	spin_unlock(&new_base->lock);
 
-	return dcpu;
-}
-
-static void tickle_timers(void *arg)
-{
-	hrtimer_peek_ahead_timers();
+	/* Check, if we got expired work to do */
+	__hrtimer_peek_ahead_timers();
+	local_irq_enable();
 }
 
 #endif /* CONFIG_HOTPLUG_CPU */
@@ -1583,11 +1581,8 @@ static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 	{
-		int dcpu;
-
 		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &scpu);
-		dcpu = migrate_hrtimers(scpu);
-		smp_call_function_single(dcpu, tickle_timers, NULL, 0);
+		migrate_hrtimers(scpu);
 		break;
 	}
 #endif
@@ -1608,6 +1603,9 @@ void __init hrtimers_init(void)
 	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
 			  (void *)(long)smp_processor_id());
 	register_cpu_notifier(&hrtimers_nb);
+#ifdef CONFIG_HIGH_RES_TIMERS
+	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq);
+#endif
 }
 
 /**
