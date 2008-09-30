Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbYI3PRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbYI3PRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbYI3PRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:17:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50362 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbYI3PRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:17:32 -0400
Date: Tue, 30 Sep 2008 17:16:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [GIT pull] timer fixes for .27
Message-ID: <20080930151643.GA19878@elte.hu>
References: <alpine.LFD.2.00.0809292255490.17289@localhost.localdomain> <alpine.LFD.2.00.0809300733150.3389@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0809300733150.3389@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 30 Sep 2008, Thomas Gleixner wrote:
> > 
> > Please pull the latest timers-fixes-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus
> 
> Did you forget to push? The tip of that branch is still commit 
> 1eda81495a49a4ee91d8863b0a441a624375efea ("x86: prevent stale state of 
> c1e_mask ...") which I already pulled last week.

hm, i just re-ran the pushout script - see below.

	Ingo

--------->
Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Thomas Gleixner (4):
      hrtimer: migrate pending list on cpu offline
      hrtimer: fix migration of CB_IRQSAFE_NO_SOFTIRQ hrtimers
      hrtimer: mark migration state
      hrtimer: prevent migration of per CPU hrtimers


 include/linux/hrtimer.h      |   18 ++++++--
 kernel/hrtimer.c             |   95 +++++++++++++++++++++++++++++++++++++----
 kernel/sched.c               |    4 +-
 kernel/time/tick-sched.c     |    2 +-
 kernel/trace/trace_sysprof.c |    2 +-
 5 files changed, 103 insertions(+), 18 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 6d93dce..2f245fe 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -47,14 +47,22 @@ enum hrtimer_restart {
  *	HRTIMER_CB_IRQSAFE:		Callback may run in hardirq context
  *	HRTIMER_CB_IRQSAFE_NO_RESTART:	Callback may run in hardirq context and
  *					does not restart the timer
- *	HRTIMER_CB_IRQSAFE_NO_SOFTIRQ:	Callback must run in hardirq context
- *					Special mode for tick emultation
+ *	HRTIMER_CB_IRQSAFE_PERCPU:	Callback must run in hardirq context
+ *					Special mode for tick emulation and
+ *					scheduler timer. Such timers are per
+ *					cpu and not allowed to be migrated on
+ *					cpu unplug.
+ *	HRTIMER_CB_IRQSAFE_UNLOCKED:	Callback should run in hardirq context
+ *					with timer->base lock unlocked
+ *					used for timers which call wakeup to
+ *					avoid lock order problems with rq->lock
  */
 enum hrtimer_cb_mode {
 	HRTIMER_CB_SOFTIRQ,
 	HRTIMER_CB_IRQSAFE,
 	HRTIMER_CB_IRQSAFE_NO_RESTART,
-	HRTIMER_CB_IRQSAFE_NO_SOFTIRQ,
+	HRTIMER_CB_IRQSAFE_PERCPU,
+	HRTIMER_CB_IRQSAFE_UNLOCKED,
 };
 
 /*
@@ -67,9 +75,10 @@ enum hrtimer_cb_mode {
  * 0x02		callback function running
  * 0x04		callback pending (high resolution mode)
  *
- * Special case:
+ * Special cases:
  * 0x03		callback function running and enqueued
  *		(was requeued on another CPU)
+ * 0x09		timer was migrated on CPU hotunplug
  * The "callback function running and enqueued" status is only possible on
  * SMP. It happens for example when a posix timer expired and the callback
  * queued a signal. Between dropping the lock which protects the posix timer
@@ -87,6 +96,7 @@ enum hrtimer_cb_mode {
 #define HRTIMER_STATE_ENQUEUED	0x01
 #define HRTIMER_STATE_CALLBACK	0x02
 #define HRTIMER_STATE_PENDING	0x04
+#define HRTIMER_STATE_MIGRATE	0x08
 
 /**
  * struct hrtimer - the basic hrtimer structure
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index b8e4dce..cdec83e 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -672,13 +672,14 @@ static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 			 */
 			BUG_ON(timer->function(timer) != HRTIMER_NORESTART);
 			return 1;
-		case HRTIMER_CB_IRQSAFE_NO_SOFTIRQ:
+		case HRTIMER_CB_IRQSAFE_PERCPU:
+		case HRTIMER_CB_IRQSAFE_UNLOCKED:
 			/*
 			 * This is solely for the sched tick emulation with
 			 * dynamic tick support to ensure that we do not
 			 * restart the tick right on the edge and end up with
 			 * the tick timer in the softirq ! The calling site
-			 * takes care of this.
+			 * takes care of this. Also used for hrtimer sleeper !
 			 */
 			debug_hrtimer_deactivate(timer);
 			return 1;
@@ -1245,7 +1246,8 @@ static void __run_hrtimer(struct hrtimer *timer)
 	timer_stats_account_hrtimer(timer);
 
 	fn = timer->function;
-	if (timer->cb_mode == HRTIMER_CB_IRQSAFE_NO_SOFTIRQ) {
+	if (timer->cb_mode == HRTIMER_CB_IRQSAFE_PERCPU ||
+	    timer->cb_mode == HRTIMER_CB_IRQSAFE_UNLOCKED) {
 		/*
 		 * Used for scheduler timers, avoid lock inversion with
 		 * rq->lock and tasklist_lock.
@@ -1452,7 +1454,7 @@ void hrtimer_init_sleeper(struct hrtimer_sleeper *sl, struct task_struct *task)
 	sl->timer.function = hrtimer_wakeup;
 	sl->task = task;
 #ifdef CONFIG_HIGH_RES_TIMERS
-	sl->timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
+	sl->timer.cb_mode = HRTIMER_CB_IRQSAFE_UNLOCKED;
 #endif
 }
 
@@ -1591,29 +1593,95 @@ static void __cpuinit init_hrtimers_cpu(int cpu)
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
-				struct hrtimer_clock_base *new_base)
+static int migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
+				struct hrtimer_clock_base *new_base, int dcpu)
 {
 	struct hrtimer *timer;
 	struct rb_node *node;
+	int raise = 0;
 
 	while ((node = rb_first(&old_base->active))) {
 		timer = rb_entry(node, struct hrtimer, node);
 		BUG_ON(hrtimer_callback_running(timer));
 		debug_hrtimer_deactivate(timer);
-		__remove_hrtimer(timer, old_base, HRTIMER_STATE_INACTIVE, 0);
+
+		/*
+		 * Should not happen. Per CPU timers should be
+		 * canceled _before_ the migration code is called
+		 */
+		if (timer->cb_mode == HRTIMER_CB_IRQSAFE_PERCPU) {
+			__remove_hrtimer(timer, old_base,
+					 HRTIMER_STATE_INACTIVE, 0);
+			WARN(1, "hrtimer (%p %p)active but cpu %d dead\n",
+			     timer, timer->function, dcpu);
+			continue;
+		}
+
+		/*
+		 * Mark it as STATE_MIGRATE not INACTIVE otherwise the
+		 * timer could be seen as !active and just vanish away
+		 * under us on another CPU
+		 */
+		__remove_hrtimer(timer, old_base, HRTIMER_STATE_MIGRATE, 0);
 		timer->base = new_base;
 		/*
 		 * Enqueue the timer. Allow reprogramming of the event device
 		 */
 		enqueue_hrtimer(timer, new_base, 1);
+
+#ifdef CONFIG_HIGH_RES_TIMERS
+		/*
+		 * Happens with high res enabled when the timer was
+		 * already expired and the callback mode is
+		 * HRTIMER_CB_IRQSAFE_UNLOCKED (hrtimer_sleeper). The
+		 * enqueue code does not move them to the soft irq
+		 * pending list for performance/latency reasons, but
+		 * in the migration state, we need to do that
+		 * otherwise we end up with a stale timer.
+		 */
+		if (timer->state == HRTIMER_STATE_MIGRATE) {
+			timer->state = HRTIMER_STATE_PENDING;
+			list_add_tail(&timer->cb_entry,
+				      &new_base->cpu_base->cb_pending);
+			raise = 1;
+		}
+#endif
+		/* Clear the migration state bit */
+		timer->state &= ~HRTIMER_STATE_MIGRATE;
+	}
+	return raise;
+}
+
+#ifdef CONFIG_HIGH_RES_TIMERS
+static int migrate_hrtimer_pending(struct hrtimer_cpu_base *old_base,
+				   struct hrtimer_cpu_base *new_base)
+{
+	struct hrtimer *timer;
+	int raise = 0;
+
+	while (!list_empty(&old_base->cb_pending)) {
+		timer = list_entry(old_base->cb_pending.next,
+				   struct hrtimer, cb_entry);
+
+		__remove_hrtimer(timer, timer->base, HRTIMER_STATE_PENDING, 0);
+		timer->base = &new_base->clock_base[timer->base->index];
+		list_add_tail(&timer->cb_entry, &new_base->cb_pending);
+		raise = 1;
 	}
+	return raise;
+}
+#else
+static int migrate_hrtimer_pending(struct hrtimer_cpu_base *old_base,
+				   struct hrtimer_cpu_base *new_base)
+{
+	return 0;
 }
+#endif
 
 static void migrate_hrtimers(int cpu)
 {
 	struct hrtimer_cpu_base *old_base, *new_base;
-	int i;
+	int i, raise = 0;
 
 	BUG_ON(cpu_online(cpu));
 	old_base = &per_cpu(hrtimer_bases, cpu);
@@ -1626,14 +1694,21 @@ static void migrate_hrtimers(int cpu)
 	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
-		migrate_hrtimer_list(&old_base->clock_base[i],
-				     &new_base->clock_base[i]);
+		if (migrate_hrtimer_list(&old_base->clock_base[i],
+					 &new_base->clock_base[i], cpu))
+			raise = 1;
 	}
 
+	if (migrate_hrtimer_pending(old_base, new_base))
+		raise = 1;
+
 	spin_unlock(&old_base->lock);
 	spin_unlock(&new_base->lock);
 	local_irq_enable();
 	put_cpu_var(hrtimer_bases);
+
+	if (raise)
+		hrtimer_raise_softirq();
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 13dd2db..ad1962d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -201,7 +201,7 @@ void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
 	hrtimer_init(&rt_b->rt_period_timer,
 			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	rt_b->rt_period_timer.function = sched_rt_period_timer;
-	rt_b->rt_period_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
+	rt_b->rt_period_timer.cb_mode = HRTIMER_CB_IRQSAFE_UNLOCKED;
 }
 
 static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
@@ -1119,7 +1119,7 @@ static void init_rq_hrtick(struct rq *rq)
 
 	hrtimer_init(&rq->hrtick_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	rq->hrtick_timer.function = hrtick;
-	rq->hrtick_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
+	rq->hrtick_timer.cb_mode = HRTIMER_CB_IRQSAFE_PERCPU;
 }
 #else
 static inline void hrtick_clear(struct rq *rq)
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 39019b3..cb02324 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -625,7 +625,7 @@ void tick_setup_sched_timer(void)
 	 */
 	hrtimer_init(&ts->sched_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 	ts->sched_timer.function = tick_sched_timer;
-	ts->sched_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
+	ts->sched_timer.cb_mode = HRTIMER_CB_IRQSAFE_PERCPU;
 
 	/* Get the next period (per cpu) */
 	ts->sched_timer.expires = tick_init_jiffy_update();
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index bb948e5..db58fb6 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -202,7 +202,7 @@ static void start_stack_timer(int cpu)
 
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = stack_trace_timer_fn;
-	hrtimer->cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
+	hrtimer->cb_mode = HRTIMER_CB_IRQSAFE_PERCPU;
 
 	hrtimer_start(hrtimer, ns_to_ktime(sample_period), HRTIMER_MODE_REL);
 }
