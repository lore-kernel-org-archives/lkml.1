Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbXA1RLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbXA1RLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 12:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932692AbXA1RLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 12:11:51 -0500
Received: from mout1.freenet.de ([194.97.50.132]:43042 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbXA1RLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 12:11:50 -0500
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH -rt] high_res_timers: precisely update_process_times; Take2
Date: Sun, 28 Jan 2007 18:11:49 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200701281811.49919.fzu@wemgehoertderstaat.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


With NO_HZ or HIGH_RES_TIMERS update_process_times() can be called,
when jiffies increments != 1 have to be acounted for.
Cope with these situations by splitting update_process_times() into
__update_process_times() and tick().
New in Take 2 is an attempt to make patch work for SMP also.
This is done by adding 
	unsigned long	update_process_times_jiffies;
to per cpu struct tick_sched.
update_process_times_jiffies is set whenever an unseen yet jiffies value
is seen by a particular cpu after calls to tick_do_update_jiffies64().
Fixes cpufreq_ondemand going nuts here on an AMD64 UP running 2.6.20-rc6-rt2.
Does it work on SMP? (don't have any)

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>


diff -pur rc6-rt2/include/linux/sched.h rc6-rt2-kw/include/linux/sched.h
--- rc6-rt2/include/linux/sched.h	2007-01-26 14:42:55.000000000 +0100
+++ rc6-rt2-kw/include/linux/sched.h	2007-01-28 02:02:29.000000000 +0100
@@ -264,6 +264,13 @@ long io_schedule_timeout(long timeout);
 extern void cpu_init (void);
 extern void trap_init(void);
 extern void update_process_times(int user);
+#ifdef CONFIG_HIGH_RES_TIMERS
+extern void __update_process_times(int user_tick, unsigned long ticks);
+extern void tick(int user_tick);
+#define NO_HIGH_RES_TIMERS_STATIC
+#else
+#define NO_HIGH_RES_TIMERS_STATIC static
+#endif
 extern void scheduler_tick(void);
 
 #ifdef CONFIG_GENERIC_HARDIRQS
Nur in rc6-rt2-kw/include/linux: sched.h~.
diff -pur rc6-rt2/include/linux/tick.h rc6-rt2-kw/include/linux/tick.h
--- rc6-rt2/include/linux/tick.h	2007-01-26 14:42:55.000000000 +0100
+++ rc6-rt2-kw/include/linux/tick.h	2007-01-28 16:19:40.000000000 +0100
@@ -56,6 +56,7 @@ struct tick_sched {
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
 	ktime_t				idle_expires;
+	unsigned long			update_process_times_jiffies;
 };
 
 extern void __init tick_init(void);
diff -pur rc6-rt2/kernel/time/tick-common.c rc6-rt2-kw/kernel/time/tick-common.c
--- rc6-rt2/kernel/time/tick-common.c	2007-01-26 14:42:55.000000000 +0100
+++ rc6-rt2-kw/kernel/time/tick-common.c	2007-01-28 16:20:00.000000000 +0100
@@ -57,6 +57,8 @@ int tick_is_oneshot_available(void)
  */
 static void tick_periodic(int cpu)
 {
+	struct tick_sched *ts = tick_get_tick_sched(smp_processor_id());
+
 	if (tick_do_timer_cpu == cpu) {
 		write_seqlock(&xtime_lock);
 
@@ -67,6 +69,8 @@ static void tick_periodic(int cpu)
 		write_sequnlock(&xtime_lock);
 	}
 
+	ts->update_process_times_jiffies = jiffies;
+
 	update_process_times(user_mode(get_irq_regs()));
 //	profile_tick(CPU_PROFILING);
 }
Nur in rc6-rt2-kw/kernel/time: tick-common.c~.
diff -pur rc6-rt2/kernel/time/tick-sched.c rc6-rt2-kw/kernel/time/tick-sched.c
--- rc6-rt2/kernel/time/tick-sched.c	2007-01-26 14:42:55.000000000 +0100
+++ rc6-rt2-kw/kernel/time/tick-sched.c	2007-01-28 17:21:34.000000000 +0100
@@ -148,6 +148,7 @@ void tick_nohz_update_jiffies(void)
 
 	local_irq_save(flags);
 	tick_do_update_jiffies64(now);
+	ts->update_process_times_jiffies = jiffies;
 	local_irq_restore(flags);
 }
 
@@ -237,6 +238,7 @@ void tick_nohz_stop_sched_tick(void)
 		 * softirq.
 		 */
 		tick_do_update_jiffies64(ktime_get());
+		ts->update_process_times_jiffies = jiffies;
 	}
 	raise_softirq_irqoff(TIMER_SOFTIRQ);
 out:
@@ -265,6 +267,7 @@ void tick_nohz_restart_sched_tick(void)
 
 	local_irq_disable();
 	tick_do_update_jiffies64(now);
+	ts->update_process_times_jiffies = jiffies;
 
 	/* Account the idle time */
 	delta = ktime_sub(now, ts->idle_entrytime);
@@ -310,6 +313,7 @@ void tick_nohz_restart_sched_tick(void)
 		}
 		/* Update jiffies and reread time */
 		tick_do_update_jiffies64(now);
+		ts->update_process_times_jiffies = jiffies;
 		now = ktime_get();
 	}
 	local_irq_enable();
@@ -329,27 +333,36 @@ static void tick_nohz_handler(struct clo
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	struct pt_regs *regs = get_irq_regs();
 	ktime_t now = ktime_get();
-
+	unsigned long ticks;
+	unsigned long jiffies_now;
 	dev->next_event.tv64 = KTIME_MAX;
 
 	/* Check, if the jiffies need an update */
 	tick_do_update_jiffies64(now);
 
-	/*
-	 * When we are idle and the tick is stopped, we have to touch
-	 * the watchdog as we might not schedule for a really long
-	 * time. This happens on complete idle SMP systems while
-	 * waiting on the login prompt. We also increment the "start
-	 * of idle" jiffy stamp so the idle accounting adjustment we
-	 * do when we go busy again does not account too much ticks.
-	 */
-	if (ts->tick_stopped) {
-		touch_softlockup_watchdog();
-		ts->idle_jiffies++;
+	/* Has this jiffie been seen on this cpu ? */
+	jiffies_now = jiffies;
+	ticks = jiffies_now - ts->update_process_times_jiffies;
+	ts->update_process_times_jiffies = jiffies_now;
+
+	if (ticks) {
+		/*
+		 * When we are idle and the tick is stopped, we have to touch
+		 * the watchdog as we might not schedule for a really long
+		 * time. This happens on complete idle SMP systems while
+		 * waiting on the login prompt. We also increment the "start of
+		 * idle" jiffy stamp so the idle accounting adjustment we do
+		 * when we go busy again does not account too much ticks.
+		 */
+		if (ts->tick_stopped) {
+			touch_softlockup_watchdog();
+			ts->idle_jiffies++;
+			__update_process_times(user_mode(regs), 1);
+		} else
+			__update_process_times(user_mode(regs), ticks);
 	}
 
-	update_process_times(user_mode(regs));
-//	profile_tick(CPU_PROFILING);
+	tick(user_mode(regs));
 
 	/* Do not restart, when we are in the idle loop */
 	if (ts->tick_stopped)
@@ -358,6 +371,7 @@ static void tick_nohz_handler(struct clo
 	while (tick_nohz_reprogram(ts, now)) {
 		now = ktime_get();
 		tick_do_update_jiffies64(now);
+		ts->update_process_times_jiffies = jiffies;
 	}
 }
 
@@ -421,34 +435,45 @@ static enum hrtimer_restart tick_sched_t
 	struct hrtimer_cpu_base *base = timer->base->cpu_base;
 	struct pt_regs *regs = get_irq_regs();
 	ktime_t now = ktime_get();
+	unsigned long ticks;
+	unsigned long jiffies_now;
 
 	/* Check, if the jiffies need an update */
 	tick_do_update_jiffies64(now);
 
+	/* Has this jiffie been seen on this cpu ? */
+	jiffies_now = jiffies;
+	ticks = jiffies_now - ts->update_process_times_jiffies;
+	ts->update_process_times_jiffies = jiffies_now;
+
 	/*
 	 * Do not call, when we are not in irq context and have
 	 * no valid regs pointer
 	 */
 	if (regs) {
-		/*
-		 * When we are idle and the tick is stopped, we have to touch
-		 * the watchdog as we might not schedule for a really long
-		 * time. This happens on complete idle SMP systems while
-		 * waiting on the login prompt. We also increment the "start of
-		 * idle" jiffy stamp so the idle accounting adjustment we do
-		 * when we go busy again does not account too much ticks.
-		 */
-		if (ts->tick_stopped) {
-			touch_softlockup_watchdog();
-			ts->idle_jiffies++;
+		if (ticks) {
+			/*
+			 * When we are idle and the tick is stopped, we have to touch
+			 * the watchdog as we might not schedule for a really long
+			 * time. This happens on complete idle SMP systems while
+			 * waiting on the login prompt. We also increment the "start of
+			 * idle" jiffy stamp so the idle accounting adjustment we do
+			 * when we go busy again does not account too much ticks.
+			 */
+			if (ts->tick_stopped) {
+				touch_softlockup_watchdog();
+				ts->idle_jiffies++;
+				__update_process_times(user_mode(regs), 1);
+			} else
+				__update_process_times(user_mode(regs), ticks);
 		}
 		/*
-		 * update_process_times() might take tasklist_lock, hence
+		 * tick() might take tasklist_lock, hence
 		 * drop the base lock. sched-tick hrtimers are per-CPU and
 		 * never accessible by userspace APIs, so this is safe to do.
 		 */
 		spin_unlock(&base->lock);
-		update_process_times(user_mode(regs));
+		tick(user_mode(regs));
 //		profile_tick(CPU_PROFILING);
 		spin_lock(&base->lock);
 	}
Nur in rc6-rt2-kw/kernel/time: tick-sched.c~.
diff -pur rc6-rt2/kernel/timer.c rc6-rt2-kw/kernel/timer.c
--- rc6-rt2/kernel/timer.c	2007-01-26 14:42:55.000000000 +0100
+++ rc6-rt2-kw/kernel/timer.c	2007-01-28 02:03:01.000000000 +0100
@@ -1312,20 +1312,24 @@ static void update_wall_time(void)
 	update_vsyscall(&xtime, clock);
 }
 
-/*
- * Called from the timer interrupt handler to charge one tick to the current 
- * process.  user_tick is 1 if the tick is user time, 0 for system.
- */
-void update_process_times(int user_tick)
+NO_HIGH_RES_TIMERS_STATIC
+void __update_process_times(int user_tick, unsigned long ticks)
 {
-	int cpu = smp_processor_id();
 	struct task_struct *p = current;
 
 	/* Note: this timer irq context must be accounted for as well. */
 	if (user_tick)
-		account_user_time(p, jiffies_to_cputime(1));
+		account_user_time(p, jiffies_to_cputime(ticks));
 	else
-		account_system_time(p, HARDIRQ_OFFSET, jiffies_to_cputime(1));
+		account_system_time(p, HARDIRQ_OFFSET, jiffies_to_cputime(ticks));
+}
+
+NO_HIGH_RES_TIMERS_STATIC
+void tick(int user_tick)
+{
+	int cpu = smp_processor_id();
+	struct task_struct *p = current;
+
 	scheduler_tick();
 	run_local_timers();
 	if (rcu_pending(cpu))
@@ -1334,6 +1338,16 @@ void update_process_times(int user_tick)
 }
 
 /*
+ * Called from the timer interrupt handler to charge one tick to the current 
+ * process.  user_tick is 1 if the tick is user time, 0 for system.
+ */
+void update_process_times(int user_tick)
+{
+	__update_process_times(user_tick, 1);
+	tick(user_tick);
+}
+
+/*
  * Nr of active tasks - counted in fixed-point numbers
  */
 static unsigned long count_active_tasks(void)
