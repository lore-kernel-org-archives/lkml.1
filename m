Return-Path: <linux-kernel-owner+w=401wt.eu-S1752412AbXA1CDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbXA1CDo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 21:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbXA1CDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 21:03:44 -0500
Received: from mout2.freenet.de ([194.97.50.155]:48458 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbXA1CDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 21:03:43 -0500
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] high_res_timers: precisely update_process_times; Re: [patch 36/46] tick-management: dyntick / highres functionality
Date: Sun, 28 Jan 2007 03:03:35 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
References: <20070123211159.178138000@localhost.localdomain> <20070123211208.550932000@localhost.localdomain>
In-Reply-To: <20070123211208.550932000@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701280303.36441.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 23. Januar 2007 23:01 schrieb Thomas Gleixner:
> 
> Add functions to provide dynamic ticks and high resolution timers.
> The code which keeps track of jiffies and handles the long idle
> periods is shared between tick based and high resolution timer based
> dynticks. The dyntick functionality can be disabled on the kernel
> commandline. Provide also the infrastructure to support high resolution
> timers.

cpufreq_ondemand didn't work here on kernels 2.6.20-rc4-rt1 and above.
Following patch against 20-rc6-rt2 helps.

      Karsten
-------------------------------------------------------------------------------
From: Karsten Wiese <fzu@wemgehoertderstaat.de>

high_res_timers: precisely update_process_times

Sometimes tick_sched_timer() calls tick_do_update_jiffies64() and
jiffies is updated by !=1.
Cope with these situations by splitting update_process_times() into
__update_process_times() and tick() and
exchanging call to update_process_times() from tick_sched_timer()
by calls to the splits.
Fixes cpufreq_ondemand going nuts here. 

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>


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
diff -pur rc6-rt2/kernel/time/tick-sched.c rc6-rt2-kw/kernel/time/tick-sched.c
--- rc6-rt2/kernel/time/tick-sched.c	2007-01-26 14:42:55.000000000 +0100
+++ rc6-rt2-kw/kernel/time/tick-sched.c	2007-01-28 01:45:14.000000000 +0100
@@ -41,9 +41,9 @@ struct tick_sched *tick_get_tick_sched(i
 /*
  * Must be called with interrupts disabled !
  */
-static void tick_do_update_jiffies64(ktime_t now)
+static unsigned long tick_do_update_jiffies64(ktime_t now)
 {
-	unsigned long ticks = 1;
+	unsigned long ticks = 0;
 	ktime_t delta;
 
 	/* Reevalute with xtime_lock held */
@@ -51,7 +51,7 @@ static void tick_do_update_jiffies64(kti
 
 	delta = ktime_sub(now, last_jiffies_update);
 	if (delta.tv64 >= tick_period.tv64) {
-
+		ticks = 1;
 		delta = ktime_sub(delta, tick_period);
 		last_jiffies_update = ktime_add(last_jiffies_update,
 						tick_period);
@@ -68,6 +68,7 @@ static void tick_do_update_jiffies64(kti
 		do_timer(ticks);
 	}
 	write_sequnlock(&xtime_lock);
+	return ticks;
 }
 
 /*
@@ -423,32 +424,36 @@ static enum hrtimer_restart tick_sched_t
 	ktime_t now = ktime_get();
 
 	/* Check, if the jiffies need an update */
-	tick_do_update_jiffies64(now);
+	unsigned long ticks = tick_do_update_jiffies64(now);
 
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
