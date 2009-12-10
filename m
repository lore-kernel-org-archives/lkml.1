Return-Path: <linux-kernel-owner+w=401wt.eu-S1761671AbZLJTrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761671AbZLJTrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761627AbZLJTr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:47:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54003 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841AbZLJTr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:47:28 -0500
Date: Thu, 10 Dec 2009 20:47:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timers fixes
Message-ID: <20091210194723.GA19512@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
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
Heiko Carstens (1):
      hrtimer: move timer stats helper functions to hrtimer.c

Thomas Gleixner (2):
      hrtimer: Tune hrtimer_interrupt hang logic
      itimer: Fix the itimer trace print format


 include/linux/hrtimer.h      |   56 +++----------------
 include/trace/events/timer.h |    8 ++--
 kernel/hrtimer.c             |  121 ++++++++++++++++++++++++++---------------
 kernel/time/timer_list.c     |    5 ++-
 4 files changed, 94 insertions(+), 96 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 9bace4b..af634e9 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -162,10 +162,11 @@ struct hrtimer_clock_base {
  * @expires_next:	absolute time of the next event which was scheduled
  *			via clock_set_next_event()
  * @hres_active:	State of high resolution mode
- * @check_clocks:	Indictator, when set evaluate time source and clock
- *			event devices whether high resolution mode can be
- *			activated.
- * @nr_events:		Total number of timer interrupt events
+ * @hang_detected:	The last hrtimer interrupt detected a hang
+ * @nr_events:		Total number of hrtimer interrupt events
+ * @nr_retries:		Total number of hrtimer interrupt retries
+ * @nr_hangs:		Total number of hrtimer interrupt hangs
+ * @max_hang_time:	Maximum time spent in hrtimer_interrupt
  */
 struct hrtimer_cpu_base {
 	spinlock_t			lock;
@@ -173,7 +174,11 @@ struct hrtimer_cpu_base {
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t				expires_next;
 	int				hres_active;
+	int				hang_detected;
 	unsigned long			nr_events;
+	unsigned long			nr_retries;
+	unsigned long			nr_hangs;
+	ktime_t				max_hang_time;
 #endif
 };
 
@@ -435,47 +440,4 @@ extern u64 ktime_divns(const ktime_t kt, s64 div);
 /* Show pending timers: */
 extern void sysrq_timer_list_show(void);
 
-/*
- * Timer-statistics info:
- */
-#ifdef CONFIG_TIMER_STATS
-
-extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
-				     void *timerf, char *comm,
-				     unsigned int timer_flag);
-
-static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
-{
-	if (likely(!timer_stats_active))
-		return;
-	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
-				 timer->function, timer->start_comm, 0);
-}
-
-extern void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer,
-						 void *addr);
-
-static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
-{
-	__timer_stats_hrtimer_set_start_info(timer, __builtin_return_address(0));
-}
-
-static inline void timer_stats_hrtimer_clear_start_info(struct hrtimer *timer)
-{
-	timer->start_site = NULL;
-}
-#else
-static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
-{
-}
-
-static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
-{
-}
-
-static inline void timer_stats_hrtimer_clear_start_info(struct hrtimer *timer)
-{
-}
-#endif
-
 #endif
diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index e5ce87a..9496b96 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -301,8 +301,8 @@ TRACE_EVENT(itimer_state,
 		__entry->interval_usec	= value->it_interval.tv_usec;
 	),
 
-	TP_printk("which=%d expires=%lu it_value=%lu.%lu it_interval=%lu.%lu",
-		  __entry->which, __entry->expires,
+	TP_printk("which=%d expires=%llu it_value=%ld.%ld it_interval=%ld.%ld",
+		  __entry->which, (unsigned long long)__entry->expires,
 		  __entry->value_sec, __entry->value_usec,
 		  __entry->interval_sec, __entry->interval_usec)
 );
@@ -331,8 +331,8 @@ TRACE_EVENT(itimer_expire,
 		__entry->pid	= pid_nr(pid);
 	),
 
-	    TP_printk("which=%d pid=%d now=%lu", __entry->which,
-		      (int) __entry->pid, __entry->now)
+	TP_printk("which=%d pid=%d now=%llu", __entry->which,
+		  (int) __entry->pid, (unsigned long long)__entry->now)
 );
 
 #endif /*  _TRACE_TIMER_H */
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ede5277..d2f9239 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -557,7 +557,7 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 static int hrtimer_reprogram(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base)
 {
-	ktime_t *expires_next = &__get_cpu_var(hrtimer_bases).expires_next;
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	ktime_t expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
 	int res;
 
@@ -582,7 +582,16 @@ static int hrtimer_reprogram(struct hrtimer *timer,
 	if (expires.tv64 < 0)
 		return -ETIME;
 
-	if (expires.tv64 >= expires_next->tv64)
+	if (expires.tv64 >= cpu_base->expires_next.tv64)
+		return 0;
+
+	/*
+	 * If a hang was detected in the last timer interrupt then we
+	 * do not schedule a timer which is earlier than the expiry
+	 * which we enforced in the hang detection. We want the system
+	 * to make progress.
+	 */
+	if (cpu_base->hang_detected)
 		return 0;
 
 	/*
@@ -590,7 +599,7 @@ static int hrtimer_reprogram(struct hrtimer *timer,
 	 */
 	res = tick_program_event(expires, 0);
 	if (!IS_ERR_VALUE(res))
-		*expires_next = expires;
+		cpu_base->expires_next = expires;
 	return res;
 }
 
@@ -747,17 +756,33 @@ static inline void hrtimer_init_timer_hres(struct hrtimer *timer) { }
 
 #endif /* CONFIG_HIGH_RES_TIMERS */
 
-#ifdef CONFIG_TIMER_STATS
-void __timer_stats_hrtimer_set_start_info(struct hrtimer *timer, void *addr)
+static inline void timer_stats_hrtimer_set_start_info(struct hrtimer *timer)
 {
+#ifdef CONFIG_TIMER_STATS
 	if (timer->start_site)
 		return;
-
-	timer->start_site = addr;
+	timer->start_site = __builtin_return_address(0);
 	memcpy(timer->start_comm, current->comm, TASK_COMM_LEN);
 	timer->start_pid = current->pid;
+#endif
 }
+
+static inline void timer_stats_hrtimer_clear_start_info(struct hrtimer *timer)
+{
+#ifdef CONFIG_TIMER_STATS
+	timer->start_site = NULL;
+#endif
+}
+
+static inline void timer_stats_account_hrtimer(struct hrtimer *timer)
+{
+#ifdef CONFIG_TIMER_STATS
+	if (likely(!timer_stats_active))
+		return;
+	timer_stats_update_stats(timer, timer->start_pid, timer->start_site,
+				 timer->function, timer->start_comm, 0);
 #endif
+}
 
 /*
  * Counterpart to lock_hrtimer_base above:
@@ -1217,30 +1242,6 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 
 #ifdef CONFIG_HIGH_RES_TIMERS
 
-static int force_clock_reprogram;
-
-/*
- * After 5 iteration's attempts, we consider that hrtimer_interrupt()
- * is hanging, which could happen with something that slows the interrupt
- * such as the tracing. Then we force the clock reprogramming for each future
- * hrtimer interrupts to avoid infinite loops and use the min_delta_ns
- * threshold that we will overwrite.
- * The next tick event will be scheduled to 3 times we currently spend on
- * hrtimer_interrupt(). This gives a good compromise, the cpus will spend
- * 1/4 of their time to process the hrtimer interrupts. This is enough to
- * let it running without serious starvation.
- */
-
-static inline void
-hrtimer_interrupt_hanging(struct clock_event_device *dev,
-			ktime_t try_time)
-{
-	force_clock_reprogram = 1;
-	dev->min_delta_ns = (unsigned long)try_time.tv64 * 3;
-	printk(KERN_WARNING "hrtimer: interrupt too slow, "
-	       "forcing clock min delta to %llu ns\n",
-	       (unsigned long long) dev->min_delta_ns);
-}
 /*
  * High resolution timer interrupt
  * Called with interrupts disabled
@@ -1249,21 +1250,15 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 {
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	struct hrtimer_clock_base *base;
-	ktime_t expires_next, now;
-	int nr_retries = 0;
-	int i;
+	ktime_t expires_next, now, entry_time, delta;
+	int i, retries = 0;
 
 	BUG_ON(!cpu_base->hres_active);
 	cpu_base->nr_events++;
 	dev->next_event.tv64 = KTIME_MAX;
 
- retry:
-	/* 5 retries is enough to notice a hang */
-	if (!(++nr_retries % 5))
-		hrtimer_interrupt_hanging(dev, ktime_sub(ktime_get(), now));
-
-	now = ktime_get();
-
+	entry_time = now = ktime_get();
+retry:
 	expires_next.tv64 = KTIME_MAX;
 
 	spin_lock(&cpu_base->lock);
@@ -1325,10 +1320,48 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	spin_unlock(&cpu_base->lock);
 
 	/* Reprogramming necessary ? */
-	if (expires_next.tv64 != KTIME_MAX) {
-		if (tick_program_event(expires_next, force_clock_reprogram))
-			goto retry;
+	if (expires_next.tv64 == KTIME_MAX ||
+	    !tick_program_event(expires_next, 0)) {
+		cpu_base->hang_detected = 0;
+		return;
 	}
+
+	/*
+	 * The next timer was already expired due to:
+	 * - tracing
+	 * - long lasting callbacks
+	 * - being scheduled away when running in a VM
+	 *
+	 * We need to prevent that we loop forever in the hrtimer
+	 * interrupt routine. We give it 3 attempts to avoid
+	 * overreacting on some spurious event.
+	 */
+	now = ktime_get();
+	cpu_base->nr_retries++;
+	if (++retries < 3)
+		goto retry;
+	/*
+	 * Give the system a chance to do something else than looping
+	 * here. We stored the entry time, so we know exactly how long
+	 * we spent here. We schedule the next event this amount of
+	 * time away.
+	 */
+	cpu_base->nr_hangs++;
+	cpu_base->hang_detected = 1;
+	delta = ktime_sub(now, entry_time);
+	if (delta.tv64 > cpu_base->max_hang_time.tv64)
+		cpu_base->max_hang_time = delta;
+	/*
+	 * Limit it to a sensible value as we enforce a longer
+	 * delay. Give the CPU at least 100ms to catch up.
+	 */
+	if (delta.tv64 > 100 * NSEC_PER_MSEC)
+		expires_next = ktime_add_ns(now, 100 * NSEC_PER_MSEC);
+	else
+		expires_next = ktime_add(now, delta);
+	tick_program_event(expires_next, 1);
+	printk_once(KERN_WARNING "hrtimer: interrupt took %llu ns\n",
+		    ktime_to_ns(delta));
 }
 
 /*
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 665c76e..9d80db4 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -150,6 +150,9 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 	P_ns(expires_next);
 	P(hres_active);
 	P(nr_events);
+	P(nr_retries);
+	P(nr_hangs);
+	P_ns(max_hang_time);
 #endif
 #undef P
 #undef P_ns
@@ -254,7 +257,7 @@ static int timer_list_show(struct seq_file *m, void *v)
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Timer List Version: v0.4\n");
+	SEQ_printf(m, "Timer List Version: v0.5\n");
 	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
 	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
 
