Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbYKYLof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbYKYLof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYKYLoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:44:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:54948 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbYKYLoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:44:04 -0500
Subject: [RFC PATCH] hrtimer: removing all ur callback modes
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       socketcan-users@lists.berlios.de
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Nov 2008 12:43:51 +0100
Message-Id: <1227613431.4259.1537.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is an attempt at removing some of the hrtimer complexity by
reducing the number of callback modes to 1.

This means that all hrtimer callback functions will be ran from HARD-irq
context.

I went through all the 30 odd hrtimer callback functions in the kernel
and saw only one that I'm not quite sure of, which is the one in
net/can/bcm.c - hence I'm CC-ing the folks responsible for that code.

Furthermore, the hrtimer core now calls callbacks directly with IRQs
disabled in case you try to enqueue an expired timer. If this timer is a
periodic timer (which should use hrtimer_forward() to advance its time)
then it might be possible to end up in an inf. recursive loop due to the
fact that hrtimer_forward() doesn't round up to the next timer
granularity, and therefore keeps on calling the callback - obviously
this needs a fix.

Aside from that, this seems to compile and actually boot on my dual core
test box - although I'm sure there are some bugs in, me not hitting any
makes me certain :-)

Not-Quite-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 drivers/input/touchscreen/ads7846.c |    4 +-
 include/linux/hrtimer.h             |   34 +----
 include/linux/interrupt.h           |    3 -
 kernel/hrtimer.c                    |  280 ++++-------------------------------
 kernel/sched.c                      |    2 -
 kernel/time/ntp.c                   |    4 +-
 kernel/time/tick-sched.c            |    1 -
 kernel/trace/trace_sysprof.c        |    1 -
 sound/drivers/pcsp/pcsp.c           |    1 -
 9 files changed, 37 insertions(+), 293 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index b9b7fc6..e1ece89 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -697,7 +697,7 @@ static enum hrtimer_restart ads7846_timer(struct hrtimer *handle)
 	struct ads7846	*ts = container_of(handle, struct ads7846, timer);
 	int		status = 0;
 
-	spin_lock_irq(&ts->lock);
+	spin_lock(&ts->lock);
 
 	if (unlikely(!get_pendown_state(ts) ||
 		     device_suspended(&ts->spi->dev))) {
@@ -728,7 +728,7 @@ static enum hrtimer_restart ads7846_timer(struct hrtimer *handle)
 			dev_err(&ts->spi->dev, "spi_async --> %d\n", status);
 	}
 
-	spin_unlock_irq(&ts->lock);
+	spin_unlock(&ts->lock);
 	return HRTIMER_NORESTART;
 }
 
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 3eba438..bd37078 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -43,26 +43,6 @@ enum hrtimer_restart {
 };
 
 /*
- * hrtimer callback modes:
- *
- *	HRTIMER_CB_SOFTIRQ:		Callback must run in softirq context
- *	HRTIMER_CB_IRQSAFE_PERCPU:	Callback must run in hardirq context
- *					Special mode for tick emulation and
- *					scheduler timer. Such timers are per
- *					cpu and not allowed to be migrated on
- *					cpu unplug.
- *	HRTIMER_CB_IRQSAFE_UNLOCKED:	Callback should run in hardirq context
- *					with timer->base lock unlocked
- *					used for timers which call wakeup to
- *					avoid lock order problems with rq->lock
- */
-enum hrtimer_cb_mode {
-	HRTIMER_CB_SOFTIRQ,
-	HRTIMER_CB_IRQSAFE_PERCPU,
-	HRTIMER_CB_IRQSAFE_UNLOCKED,
-};
-
-/*
  * Values to track state of the timer
  *
  * Possible states:
@@ -70,7 +50,6 @@ enum hrtimer_cb_mode {
  * 0x00		inactive
  * 0x01		enqueued into rbtree
  * 0x02		callback function running
- * 0x04		callback pending (high resolution mode)
  *
  * Special cases:
  * 0x03		callback function running and enqueued
@@ -92,8 +71,7 @@ enum hrtimer_cb_mode {
 #define HRTIMER_STATE_INACTIVE	0x00
 #define HRTIMER_STATE_ENQUEUED	0x01
 #define HRTIMER_STATE_CALLBACK	0x02
-#define HRTIMER_STATE_PENDING	0x04
-#define HRTIMER_STATE_MIGRATE	0x08
+#define HRTIMER_STATE_MIGRATE	0x04
 
 /**
  * struct hrtimer - the basic hrtimer structure
@@ -109,8 +87,6 @@ enum hrtimer_cb_mode {
  * @function:	timer expiry callback function
  * @base:	pointer to the timer base (per cpu and per clock)
  * @state:	state information (See bit values above)
- * @cb_mode:	high resolution timer feature to select the callback execution
- *		 mode
  * @cb_entry:	list head to enqueue an expired timer into the callback list
  * @start_site:	timer statistics field to store the site where the timer
  *		was started
@@ -129,7 +105,6 @@ struct hrtimer {
 	struct hrtimer_clock_base	*base;
 	unsigned long			state;
 	struct list_head		cb_entry;
-	enum hrtimer_cb_mode		cb_mode;
 #ifdef CONFIG_TIMER_STATS
 	int				start_pid;
 	void				*start_site;
@@ -188,15 +163,11 @@ struct hrtimer_clock_base {
  * @check_clocks:	Indictator, when set evaluate time source and clock
  *			event devices whether high resolution mode can be
  *			activated.
- * @cb_pending:		Expired timers are moved from the rbtree to this
- *			list in the timer interrupt. The list is processed
- *			in the softirq.
  * @nr_events:		Total number of timer interrupt events
  */
 struct hrtimer_cpu_base {
 	spinlock_t			lock;
 	struct hrtimer_clock_base	clock_base[HRTIMER_MAX_CLOCK_BASES];
-	struct list_head		cb_pending;
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t				expires_next;
 	int				hres_active;
@@ -404,8 +375,7 @@ static inline int hrtimer_active(const struct hrtimer *timer)
  */
 static inline int hrtimer_is_queued(struct hrtimer *timer)
 {
-	return timer->state &
-		(HRTIMER_STATE_ENQUEUED | HRTIMER_STATE_PENDING);
+	return timer->state & HRTIMER_STATE_ENQUEUED;
 }
 
 /*
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 9fc6026..f676cd1 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -251,9 +251,6 @@ enum
 	BLOCK_SOFTIRQ,
 	TASKLET_SOFTIRQ,
 	SCHED_SOFTIRQ,
-#ifdef CONFIG_HIGH_RES_TIMERS
-	HRTIMER_SOFTIRQ,
-#endif
 	RCU_SOFTIRQ, 	/* Preferable RCU should always be the last softirq */
 
 	NR_SOFTIRQS
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 47e6334..c87cd5f 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -442,22 +442,6 @@ static inline void debug_hrtimer_activate(struct hrtimer *timer) { }
 static inline void debug_hrtimer_deactivate(struct hrtimer *timer) { }
 #endif
 
-/*
- * Check, whether the timer is on the callback pending list
- */
-static inline int hrtimer_cb_pending(const struct hrtimer *timer)
-{
-	return timer->state & HRTIMER_STATE_PENDING;
-}
-
-/*
- * Remove a timer from the callback pending list
- */
-static inline void hrtimer_remove_cb_pending(struct hrtimer *timer)
-{
-	list_del_init(&timer->cb_entry);
-}
-
 /* High resolution timer related functions */
 #ifdef CONFIG_HIGH_RES_TIMERS
 
@@ -651,6 +635,8 @@ static inline void hrtimer_init_timer_hres(struct hrtimer *timer)
 {
 }
 
+static void __run_hrtimer(struct hrtimer *timer);
+
 /*
  * When High resolution timers are active, try to reprogram. Note, that in case
  * the state has HRTIMER_STATE_CALLBACK set, no reprogramming and no expiry
@@ -661,31 +647,14 @@ static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 					    struct hrtimer_clock_base *base)
 {
 	if (base->cpu_base->hres_active && hrtimer_reprogram(timer, base)) {
-
-		/* Timer is expired, act upon the callback mode */
-		switch(timer->cb_mode) {
-		case HRTIMER_CB_IRQSAFE_PERCPU:
-		case HRTIMER_CB_IRQSAFE_UNLOCKED:
-			/*
-			 * This is solely for the sched tick emulation with
-			 * dynamic tick support to ensure that we do not
-			 * restart the tick right on the edge and end up with
-			 * the tick timer in the softirq ! The calling site
-			 * takes care of this. Also used for hrtimer sleeper !
-			 */
-			debug_hrtimer_deactivate(timer);
-			return 1;
-		case HRTIMER_CB_SOFTIRQ:
-			/*
-			 * Move everything else into the softirq pending list !
-			 */
-			list_add_tail(&timer->cb_entry,
-				      &base->cpu_base->cb_pending);
-			timer->state = HRTIMER_STATE_PENDING;
-			return 1;
-		default:
-			BUG();
-		}
+		/* 
+		 * XXX: recursion check? 
+		 * hrtimer_forward() should round up with timer granularity 
+		 * so that we never get into inf recursion here, 
+		 * it doesn't do that though
+		 */
+		__run_hrtimer(timer);
+		return 1;
 	}
 	return 0;
 }
@@ -724,11 +693,6 @@ static int hrtimer_switch_to_hres(void)
 	return 1;
 }
 
-static inline void hrtimer_raise_softirq(void)
-{
-	raise_softirq(HRTIMER_SOFTIRQ);
-}
-
 #else
 
 static inline int hrtimer_hres_active(void) { return 0; }
@@ -747,7 +711,6 @@ static inline int hrtimer_reprogram(struct hrtimer *timer,
 {
 	return 0;
 }
-static inline void hrtimer_raise_softirq(void) { }
 
 #endif /* CONFIG_HIGH_RES_TIMERS */
 
@@ -890,10 +853,7 @@ static void __remove_hrtimer(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base,
 			     unsigned long newstate, int reprogram)
 {
-	/* High res. callback list. NOP for !HIGHRES */
-	if (hrtimer_cb_pending(timer))
-		hrtimer_remove_cb_pending(timer);
-	else {
+	if (timer->state & HRTIMER_STATE_ENQUEUED) {
 		/*
 		 * Remove the timer from the rbtree and replace the
 		 * first entry pointer if necessary.
@@ -953,7 +913,7 @@ hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim, unsigned long delta_n
 {
 	struct hrtimer_clock_base *base, *new_base;
 	unsigned long flags;
-	int ret, raise;
+	int ret;
 
 	base = lock_hrtimer_base(timer, &flags);
 
@@ -988,26 +948,8 @@ hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim, unsigned long delta_n
 	enqueue_hrtimer(timer, new_base,
 			new_base->cpu_base == &__get_cpu_var(hrtimer_bases));
 
-	/*
-	 * The timer may be expired and moved to the cb_pending
-	 * list. We can not raise the softirq with base lock held due
-	 * to a possible deadlock with runqueue lock.
-	 */
-	raise = timer->state == HRTIMER_STATE_PENDING;
-
-	/*
-	 * We use preempt_disable to prevent this task from migrating after
-	 * setting up the softirq and raising it. Otherwise, if me migrate
-	 * we will raise the softirq on the wrong CPU.
-	 */
-	preempt_disable();
-
 	unlock_hrtimer_base(timer, &flags);
 
-	if (raise)
-		hrtimer_raise_softirq();
-	preempt_enable();
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(hrtimer_start_range_ns);
@@ -1192,75 +1134,6 @@ int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp)
 }
 EXPORT_SYMBOL_GPL(hrtimer_get_res);
 
-static void run_hrtimer_pending(struct hrtimer_cpu_base *cpu_base)
-{
-	spin_lock_irq(&cpu_base->lock);
-
-	while (!list_empty(&cpu_base->cb_pending)) {
-		enum hrtimer_restart (*fn)(struct hrtimer *);
-		struct hrtimer *timer;
-		int restart;
-		int emulate_hardirq_ctx = 0;
-
-		timer = list_entry(cpu_base->cb_pending.next,
-				   struct hrtimer, cb_entry);
-
-		debug_hrtimer_deactivate(timer);
-		timer_stats_account_hrtimer(timer);
-
-		fn = timer->function;
-		/*
-		 * A timer might have been added to the cb_pending list
-		 * when it was migrated during a cpu-offline operation.
-		 * Emulate hardirq context for such timers.
-		 */
-		if (timer->cb_mode == HRTIMER_CB_IRQSAFE_PERCPU ||
-		    timer->cb_mode == HRTIMER_CB_IRQSAFE_UNLOCKED)
-			emulate_hardirq_ctx = 1;
-
-		__remove_hrtimer(timer, timer->base, HRTIMER_STATE_CALLBACK, 0);
-		spin_unlock_irq(&cpu_base->lock);
-
-		if (unlikely(emulate_hardirq_ctx)) {
-			local_irq_disable();
-			restart = fn(timer);
-			local_irq_enable();
-		} else
-			restart = fn(timer);
-
-		spin_lock_irq(&cpu_base->lock);
-
-		timer->state &= ~HRTIMER_STATE_CALLBACK;
-		if (restart == HRTIMER_RESTART) {
-			BUG_ON(hrtimer_active(timer));
-			/*
-			 * Enqueue the timer, allow reprogramming of the event
-			 * device
-			 */
-			enqueue_hrtimer(timer, timer->base, 1);
-		} else if (hrtimer_active(timer)) {
-			/*
-			 * If the timer was rearmed on another CPU, reprogram
-			 * the event device.
-			 */
-			struct hrtimer_clock_base *base = timer->base;
-
-			if (base->first == &timer->node &&
-			    hrtimer_reprogram(timer, base)) {
-				/*
-				 * Timer is expired. Thus move it from tree to
-				 * pending list again.
-				 */
-				__remove_hrtimer(timer, base,
-						 HRTIMER_STATE_PENDING, 0);
-				list_add_tail(&timer->cb_entry,
-					      &base->cpu_base->cb_pending);
-			}
-		}
-	}
-	spin_unlock_irq(&cpu_base->lock);
-}
-
 static void __run_hrtimer(struct hrtimer *timer)
 {
 	struct hrtimer_clock_base *base = timer->base;
@@ -1268,25 +1141,21 @@ static void __run_hrtimer(struct hrtimer *timer)
 	enum hrtimer_restart (*fn)(struct hrtimer *);
 	int restart;
 
+	WARN_ON(!irqs_disabled());
+
 	debug_hrtimer_deactivate(timer);
 	__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
 	timer_stats_account_hrtimer(timer);
-
 	fn = timer->function;
-	if (timer->cb_mode == HRTIMER_CB_IRQSAFE_PERCPU ||
-	    timer->cb_mode == HRTIMER_CB_IRQSAFE_UNLOCKED) {
-		/*
-		 * Used for scheduler timers, avoid lock inversion with
-		 * rq->lock and tasklist_lock.
-		 *
-		 * These timers are required to deal with enqueue expiry
-		 * themselves and are not allowed to migrate.
-		 */
-		spin_unlock(&cpu_base->lock);
-		restart = fn(timer);
-		spin_lock(&cpu_base->lock);
-	} else
-		restart = fn(timer);
+
+	/*
+	 * Because we run timers from hardirq context, there is no chance
+	 * they get migrated to another cpu, therefore its safe to unlock
+	 * the timer base.
+	 */
+	spin_unlock(&cpu_base->lock);
+	restart = fn(timer);
+	spin_lock(&cpu_base->lock);
 
 	/*
 	 * Note: We clear the CALLBACK bit after enqueue_hrtimer to avoid
@@ -1311,7 +1180,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	struct hrtimer_clock_base *base;
 	ktime_t expires_next, now;
-	int i, raise = 0;
+	int i;
 
 	BUG_ON(!cpu_base->hres_active);
 	cpu_base->nr_events++;
@@ -1360,16 +1229,6 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 				break;
 			}
 
-			/* Move softirq callbacks to the pending list */
-			if (timer->cb_mode == HRTIMER_CB_SOFTIRQ) {
-				__remove_hrtimer(timer, base,
-						 HRTIMER_STATE_PENDING, 0);
-				list_add_tail(&timer->cb_entry,
-					      &base->cpu_base->cb_pending);
-				raise = 1;
-				continue;
-			}
-
 			__run_hrtimer(timer);
 		}
 		spin_unlock(&cpu_base->lock);
@@ -1383,10 +1242,6 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 		if (tick_program_event(expires_next, 0))
 			goto retry;
 	}
-
-	/* Raise softirq ? */
-	if (raise)
-		raise_softirq(HRTIMER_SOFTIRQ);
 }
 
 /**
@@ -1413,11 +1268,6 @@ void hrtimer_peek_ahead_timers(void)
 	local_irq_restore(flags);
 }
 
-static void run_hrtimer_softirq(struct softirq_action *h)
-{
-	run_hrtimer_pending(&__get_cpu_var(hrtimer_bases));
-}
-
 #endif	/* CONFIG_HIGH_RES_TIMERS */
 
 /*
@@ -1429,8 +1279,6 @@ static void run_hrtimer_softirq(struct softirq_action *h)
  */
 void hrtimer_run_pending(void)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-
 	if (hrtimer_hres_active())
 		return;
 
@@ -1444,8 +1292,6 @@ void hrtimer_run_pending(void)
 	 */
 	if (tick_check_oneshot_change(!hrtimer_is_hres_enabled()))
 		hrtimer_switch_to_hres();
-
-	run_hrtimer_pending(cpu_base);
 }
 
 /*
@@ -1482,14 +1328,6 @@ void hrtimer_run_queues(void)
 					hrtimer_get_expires_tv64(timer))
 				break;
 
-			if (timer->cb_mode == HRTIMER_CB_SOFTIRQ) {
-				__remove_hrtimer(timer, base,
-					HRTIMER_STATE_PENDING, 0);
-				list_add_tail(&timer->cb_entry,
-					&base->cpu_base->cb_pending);
-				continue;
-			}
-
 			__run_hrtimer(timer);
 		}
 		spin_unlock(&cpu_base->lock);
@@ -1516,9 +1354,6 @@ void hrtimer_init_sleeper(struct hrtimer_sleeper *sl, struct task_struct *task)
 {
 	sl->timer.function = hrtimer_wakeup;
 	sl->task = task;
-#ifdef CONFIG_HIGH_RES_TIMERS
-	sl->timer.cb_mode = HRTIMER_CB_IRQSAFE_UNLOCKED;
-#endif
 }
 
 static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode)
@@ -1655,18 +1490,16 @@ static void __cpuinit init_hrtimers_cpu(int cpu)
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
 		cpu_base->clock_base[i].cpu_base = cpu_base;
 
-	INIT_LIST_HEAD(&cpu_base->cb_pending);
 	hrtimer_init_hres(cpu_base);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-static int migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
-				struct hrtimer_clock_base *new_base, int dcpu)
+static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
+				 struct hrtimer_clock_base *new_base, int dcpu)
 {
 	struct hrtimer *timer;
 	struct rb_node *node;
-	int raise = 0;
 
 	while ((node = rb_first(&old_base->active))) {
 		timer = rb_entry(node, struct hrtimer, node);
@@ -1674,18 +1507,6 @@ static int migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 		debug_hrtimer_deactivate(timer);
 
 		/*
-		 * Should not happen. Per CPU timers should be
-		 * canceled _before_ the migration code is called
-		 */
-		if (timer->cb_mode == HRTIMER_CB_IRQSAFE_PERCPU) {
-			__remove_hrtimer(timer, old_base,
-					 HRTIMER_STATE_INACTIVE, 0);
-			WARN(1, "hrtimer (%p %p)active but cpu %d dead\n",
-			     timer, timer->function, dcpu);
-			continue;
-		}
-
-		/*
 		 * Mark it as STATE_MIGRATE not INACTIVE otherwise the
 		 * timer could be seen as !active and just vanish away
 		 * under us on another CPU
@@ -1708,48 +1529,19 @@ static int migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 		 * otherwise we end up with a stale timer.
 		 */
 		if (timer->state == HRTIMER_STATE_MIGRATE) {
-			timer->state = HRTIMER_STATE_PENDING;
-			list_add_tail(&timer->cb_entry,
-				      &new_base->cpu_base->cb_pending);
-			raise = 1;
+			/* XXX: running on offline cpu */
+			__run_hrtimer(timer);
 		}
 #endif
 		/* Clear the migration state bit */
 		timer->state &= ~HRTIMER_STATE_MIGRATE;
 	}
-	return raise;
 }
 
-#ifdef CONFIG_HIGH_RES_TIMERS
-static int migrate_hrtimer_pending(struct hrtimer_cpu_base *old_base,
-				   struct hrtimer_cpu_base *new_base)
-{
-	struct hrtimer *timer;
-	int raise = 0;
-
-	while (!list_empty(&old_base->cb_pending)) {
-		timer = list_entry(old_base->cb_pending.next,
-				   struct hrtimer, cb_entry);
-
-		__remove_hrtimer(timer, timer->base, HRTIMER_STATE_PENDING, 0);
-		timer->base = &new_base->clock_base[timer->base->index];
-		list_add_tail(&timer->cb_entry, &new_base->cb_pending);
-		raise = 1;
-	}
-	return raise;
-}
-#else
-static int migrate_hrtimer_pending(struct hrtimer_cpu_base *old_base,
-				   struct hrtimer_cpu_base *new_base)
-{
-	return 0;
-}
-#endif
-
 static void migrate_hrtimers(int cpu)
 {
 	struct hrtimer_cpu_base *old_base, *new_base;
-	int i, raise = 0;
+	int i;
 
 	BUG_ON(cpu_online(cpu));
 	old_base = &per_cpu(hrtimer_bases, cpu);
@@ -1764,20 +1556,13 @@ static void migrate_hrtimers(int cpu)
 	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
-		if (migrate_hrtimer_list(&old_base->clock_base[i],
-					 &new_base->clock_base[i], cpu))
-			raise = 1;
+		migrate_hrtimer_list(&old_base->clock_base[i],
+				     &new_base->clock_base[i], cpu);
 	}
 
-	if (migrate_hrtimer_pending(old_base, new_base))
-		raise = 1;
-
 	spin_unlock(&old_base->lock);
 	spin_unlock_irq(&new_base->lock);
 	put_cpu_var(hrtimer_bases);
-
-	if (raise)
-		hrtimer_raise_softirq();
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
@@ -1817,9 +1602,6 @@ void __init hrtimers_init(void)
 	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
 			  (void *)(long)smp_processor_id());
 	register_cpu_notifier(&hrtimers_nb);
-#ifdef CONFIG_HIGH_RES_TIMERS
-	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq);
-#endif
 }
 
 /**
diff --git a/kernel/sched.c b/kernel/sched.c
index f6d6ea3..e95bb48 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -209,7 +209,6 @@ void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
 	hrtimer_init(&rt_b->rt_period_timer,
 			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	rt_b->rt_period_timer.function = sched_rt_period_timer;
-	rt_b->rt_period_timer.cb_mode = HRTIMER_CB_IRQSAFE_UNLOCKED;
 }
 
 static inline int rt_bandwidth_enabled(void)
@@ -1125,7 +1124,6 @@ static void init_rq_hrtick(struct rq *rq)
 
 	hrtimer_init(&rq->hrtick_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	rq->hrtick_timer.function = hrtick;
-	rq->hrtick_timer.cb_mode = HRTIMER_CB_IRQSAFE_PERCPU;
 }
 #else	/* CONFIG_SCHED_HRTICK */
 static inline void hrtick_clear(struct rq *rq)
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 8ff15e5..f5f793d 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -131,7 +131,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 {
 	enum hrtimer_restart res = HRTIMER_NORESTART;
 
-	write_seqlock_irq(&xtime_lock);
+	write_seqlock(&xtime_lock);
 
 	switch (time_state) {
 	case TIME_OK:
@@ -164,7 +164,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 	}
 	update_vsyscall(&xtime, clock);
 
-	write_sequnlock_irq(&xtime_lock);
+	write_sequnlock(&xtime_lock);
 
 	return res;
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 342fc9c..502a81e 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -681,7 +681,6 @@ void tick_setup_sched_timer(void)
 	 */
 	hrtimer_init(&ts->sched_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 	ts->sched_timer.function = tick_sched_timer;
-	ts->sched_timer.cb_mode = HRTIMER_CB_IRQSAFE_PERCPU;
 
 	/* Get the next period (per cpu) */
 	hrtimer_set_expires(&ts->sched_timer, tick_init_jiffy_update());
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index 54960ed..f6b0dca 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -202,7 +202,6 @@ static void start_stack_timer(int cpu)
 
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = stack_trace_timer_fn;
-	hrtimer->cb_mode = HRTIMER_CB_IRQSAFE_PERCPU;
 
 	hrtimer_start(hrtimer, ns_to_ktime(sample_period), HRTIMER_MODE_REL);
 }
diff --git a/sound/drivers/pcsp/pcsp.c b/sound/drivers/pcsp/pcsp.c
index 1899cf0..8e52b2a 100644
--- a/sound/drivers/pcsp/pcsp.c
+++ b/sound/drivers/pcsp/pcsp.c
@@ -96,7 +96,6 @@ static int __devinit snd_card_pcsp_probe(int devnum, struct device *dev)
 		return -EINVAL;
 
 	hrtimer_init(&pcsp_chip.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	pcsp_chip.timer.cb_mode = HRTIMER_CB_SOFTIRQ;
 	pcsp_chip.timer.function = pcsp_do_timer;
 
 	card = snd_card_new(index, id, THIS_MODULE, 0);

