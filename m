Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbXCWALJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbXCWALJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 20:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbXCWALJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 20:11:09 -0400
Received: from gw.goop.org ([64.81.55.164]:40708 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbXCWALI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 20:11:08 -0400
Message-ID: <46031B1C.70506@goop.org>
Date: Thu, 22 Mar 2007 17:11:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dan Hecht <dhecht@vmware.com>, Thomas Gleixner <tglx@linutronix.de>,
       Akinobu Mita <mita@miraclelinux.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH RFC] Change softlockup watchdog to ignore stolen time
References: <460311FA.6070400@goop.org> <460324A7.3010604@vmware.com>
In-Reply-To: <460324A7.3010604@vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> No, it is not unlikely.  4-way SMP VMs idling exhibit this behavior
> with NO_HZ or NO_IDLE_HZ because they get quiet enough to schedule
> nothing on the APs.
>
> And that can happen on native hardware as well.

That's a separate problem.

>>
>> Also, softlockup.c's use of jiffies seems archaic now.  Should it be
>> converted to use timers?  Mightn't it report lockups just because there
>> was no timer event?
>>   
>
> This looks good to me, as a first order approximation.  But on native
> hardware, with NO_HZ, this is just broken to begin with.  Perhaps we
> should make SOFTLOCKUP depend on !NO_HZ.

OK, that just means the softlockup should, erm, do something else.  I
guess using an explicit timer would work, but I'm not sure if that
defeats the whole purpose.  Perhaps there should be a per-cpu disable
flag, which would be set when entering idle?

Something like this...

    J

diff -r 3f00aa67786f include/linux/sched.h
--- a/include/linux/sched.h	Thu Mar 22 17:03:13 2007 -0700
+++ b/include/linux/sched.h	Thu Mar 22 17:09:23 2007 -0700
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
diff -r 3f00aa67786f kernel/softlockup.c
--- a/kernel/softlockup.c	Thu Mar 22 17:03:13 2007 -0700
+++ b/kernel/softlockup.c	Thu Mar 22 17:09:23 2007 -0700
@@ -20,6 +20,7 @@ static DEFINE_PER_CPU(unsigned long long
 static DEFINE_PER_CPU(unsigned long long, touch_timestamp);
 static DEFINE_PER_CPU(unsigned long long, print_timestamp);
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
+static DEFINE_PER_CPU(int, enabled);
 
 static int did_panic = 0;
 
@@ -41,6 +42,17 @@ void touch_softlockup_watchdog(void)
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
+void softlockup_enable(void)
+{
+	touch_softlockup_watchdog();
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
@@ -51,8 +63,8 @@ void softlockup_tick(void)
 	unsigned long long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
 	unsigned long long now;
 
-	/* watchdog task hasn't updated timestamp yet */
-	if (touch_timestamp == 0)
+	/* return if not enabled */
+	if (!__get_cpu_var(enabled))
 		return;
 
 	/* report at most once a second */
@@ -95,8 +107,8 @@ static int watchdog(void * __bind_cpu)
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->flags |= PF_NOFREEZE;
 
-	/* initialize timestamp */
-	touch_softlockup_watchdog();
+	/* enable on this cpu */
+	softlockup_enable();
 
 	/*
 	 * Run briefly once per second to reset the softlockup timestamp.
diff -r 3f00aa67786f kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c	Thu Mar 22 17:03:13 2007 -0700
+++ b/kernel/time/tick-sched.c	Thu Mar 22 17:09:23 2007 -0700
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


