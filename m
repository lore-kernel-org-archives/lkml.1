Return-Path: <linux-kernel-owner+w=401wt.eu-S934035AbXC0Ftc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035AbXC0Ftc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934030AbXC0FtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:49:03 -0400
Received: from gw.goop.org ([64.81.55.164]:59351 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934029AbXC0Fs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:48:59 -0400
Message-Id: <20070327054106.809292985@goop.org>
References: <20070327053816.881735237@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 26 Mar 2007 22:38:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, virtualization@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Zachary Amsden <zach@vmware.com>,
       James Morris <jmorris@namei.org>, Dan Hecht <dhecht@vmware.com>,
       Paul Mackerras <paulus@samba.org>, Prarit Bhargava <prarit@redhat.com>,
       Chris Lalancette <clalance@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 2/2] percpu enable flag for softlockup watchdog
Content-Disposition: inline; filename=softlockup-percpu-enable-flag.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On a NO_HZ system, there may be an arbitrarily long delay between
ticks on a CPU.  When we're disabling ticks for a CPU, also disable
the softlockup watchdog timer.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: James Morris <jmorris@namei.org>
Cc: Dan Hecht <dhecht@vmware.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>

---
 include/linux/sched.h    |    8 ++++++++
 kernel/softlockup.c      |   23 +++++++++++++++++++----
 kernel/time/tick-sched.c |   34 +++++++++++++++-------------------
 3 files changed, 42 insertions(+), 23 deletions(-)

===================================================================
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -232,10 +232,18 @@ extern void scheduler_tick(void);
 
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 extern void softlockup_tick(void);
+extern void softlockup_enable(void);
+extern void softlockup_disable(void);
 extern void spawn_softlockup_task(void);
 extern void touch_softlockup_watchdog(void);
 #else
 static inline void softlockup_tick(void)
+{
+}
+static inline void softlockup_enable(void)
+{
+}
+static inline void softlockup_disable(void)
 {
 }
 static inline void spawn_softlockup_task(void)
===================================================================
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -20,6 +20,7 @@ static DEFINE_PER_CPU(unsigned long long
 static DEFINE_PER_CPU(unsigned long long, touch_timestamp);
 static DEFINE_PER_CPU(unsigned long long, print_timestamp);
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
+static DEFINE_PER_CPU(int, enabled);
 
 static int did_panic = 0;
 
@@ -41,6 +42,18 @@ void touch_softlockup_watchdog(void)
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
+void softlockup_enable(void)
+{
+	touch_softlockup_watchdog();
+	wmb();			/* update timestamp before enable */
+	__get_cpu_var(enabled) = 1;
+}
+
+void softlockup_disable(void)
+{
+	__get_cpu_var(enabled) = 0;
+}
+
 /*
  * This callback runs from the timer interrupt, and checks
  * whether the watchdog thread has hung or not:
@@ -51,8 +64,8 @@ void softlockup_tick(void)
 	unsigned long long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
 	unsigned long long now;
 
-	/* watchdog task hasn't updated timestamp yet */
-	if (touch_timestamp == 0)
+	/* return if not enabled */
+	if (!__get_cpu_var(enabled))
 		return;
 
 	/* report at most once a second */
@@ -95,8 +108,8 @@ static int watchdog(void * __bind_cpu)
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->flags |= PF_NOFREEZE;
 
-	/* initialize timestamp */
-	touch_softlockup_watchdog();
+	/* enable on this cpu */
+	softlockup_enable();
 
 	/*
 	 * Run briefly once per second to reset the softlockup timestamp.
@@ -109,6 +122,8 @@ static int watchdog(void * __bind_cpu)
 		touch_softlockup_watchdog();
 		schedule();
 	}
+
+	softlockup_disable();
 
 	return 0;
 }
===================================================================
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -228,6 +228,8 @@ void tick_nohz_stop_sched_tick(void)
 			ts->idle_tick = ts->sched_timer.expires;
 			ts->tick_stopped = 1;
 			ts->idle_jiffies = last_jiffies;
+
+			softlockup_disable();
 		}
 		/*
 		 * calculate the expiry time for the next timer wheel
@@ -255,6 +257,7 @@ void tick_nohz_stop_sched_tick(void)
 		cpu_clear(cpu, nohz_cpu_mask);
 	}
 	raise_softirq_irqoff(TIMER_SOFTIRQ);
+
 out:
 	ts->next_jiffies = next_jiffies;
 	ts->last_jiffies = last_jiffies;
@@ -311,6 +314,8 @@ void tick_nohz_restart_sched_tick(void)
 	ts->tick_stopped  = 0;
 	hrtimer_cancel(&ts->sched_timer);
 	ts->sched_timer.expires = ts->idle_tick;
+
+	softlockup_enable();
 
 	while (1) {
 		/* Forward the time to expire in the future */
@@ -355,17 +360,12 @@ static void tick_nohz_handler(struct clo
 	tick_do_update_jiffies64(now);
 
 	/*
-	 * When we are idle and the tick is stopped, we have to touch
-	 * the watchdog as we might not schedule for a really long
-	 * time. This happens on complete idle SMP systems while
-	 * waiting on the login prompt. We also increment the "start
-	 * of idle" jiffy stamp so the idle accounting adjustment we
-	 * do when we go busy again does not account too much ticks.
-	 */
-	if (ts->tick_stopped) {
-		touch_softlockup_watchdog();
+	 * Increment the "start of idle" jiffy stamp so the idle
+	 * accounting adjustment we do when we go busy again does not
+	 * account too much ticks.
+	 */
+	if (ts->tick_stopped)
 		ts->idle_jiffies++;
-	}
 
 	update_process_times(user_mode(regs));
 	profile_tick(CPU_PROFILING);
@@ -450,17 +450,12 @@ static enum hrtimer_restart tick_sched_t
 	 */
 	if (regs) {
 		/*
-		 * When we are idle and the tick is stopped, we have to touch
-		 * the watchdog as we might not schedule for a really long
-		 * time. This happens on complete idle SMP systems while
-		 * waiting on the login prompt. We also increment the "start of
-		 * idle" jiffy stamp so the idle accounting adjustment we do
-		 * when we go busy again does not account too much ticks.
+		 * Increment the "start of idle" jiffy stamp so the
+		 * idle accounting adjustment we do when we go busy
+		 * again does not account too much ticks.
 		 */
-		if (ts->tick_stopped) {
-			touch_softlockup_watchdog();
+		if (ts->tick_stopped)
 			ts->idle_jiffies++;
-		}
 		/*
 		 * update_process_times() might take tasklist_lock, hence
 		 * drop the base lock. sched-tick hrtimers are per-CPU and
@@ -522,6 +517,7 @@ void tick_cancel_sched_timer(int cpu)
 	if (ts->sched_timer.base)
 		hrtimer_cancel(&ts->sched_timer);
 	ts->tick_stopped = 0;
+	softlockup_enable();
 	ts->nohz_mode = NOHZ_MODE_INACTIVE;
 }
 #endif /* HIGH_RES_TIMERS */

-- 

