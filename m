Return-Path: <linux-kernel-owner+w=401wt.eu-S934219AbXC0W2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219AbXC0W2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934231AbXC0W2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:28:43 -0400
Received: from 49.sub-75-208-212.myvzw.com ([75.208.212.49]:55527 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934219AbXC0W2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:28:41 -0400
X-Greylist: delayed 1699 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Mar 2007 18:28:38 EDT
Message-Id: <20070327215827.977837635@goop.org>
References: <20070327214919.800272641@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 27 Mar 2007 14:49:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, virtualization@lists.osdl.org,
       Prarit Bhargava <prarit@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Dan Hecht <dhecht@vmware.com>, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Chris Lalancette <clalance@redhat.com>
Subject: [patch 2/4] percpu enable flag for softlockup watchdog
Content-Disposition: inline; filename=softlockup-percpu-enable-flag.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On a NO_HZ system, there may be an arbitrarily long delay between
ticks on a CPU.  When we're disabling ticks for a CPU, also disable
the softlockup watchdog timer.

This makes the touch_softlockup_watchdog() interface redundant; if a
piece of code knows its going to be holding off timer interrupts long
enough to trigger the watchdog, then it may as well simply temporarily
disable the timer.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Zachary Amsden <zach@vmware.com>
Cc: James Morris <jmorris@namei.org>
Cc: Dan Hecht <dhecht@vmware.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Chris Lalancette <clalance@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>

---
 include/linux/sched.h    |   25 +++++++++++++++++
 kernel/softlockup.c      |   67 ++++++++++++++++++++++++++++++++++++++++++----
 kernel/time/tick-sched.c |   34 ++++++++++-------------
 3 files changed, 102 insertions(+), 24 deletions(-)

===================================================================
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -232,12 +232,37 @@ extern void scheduler_tick(void);
 extern void scheduler_tick(void);
 
 #ifdef CONFIG_DETECT_SOFTLOCKUP
+/* A scheduler tick on this CPU */
 extern void softlockup_tick(void);
+
+/* Scheduler is disabling/re-enabling ticks on this CPU */
+extern void softlockup_tick_disable(void);
+extern void softlockup_tick_enable(void);
+
+/* Some code wants to temporarily disable the watchdog */
+extern int  softlockup_disable(void);
+extern void softlockup_enable(int state);
+
 extern void spawn_softlockup_task(void);
 extern void touch_softlockup_watchdog(void);
 #else
 static inline void softlockup_tick(void)
 {
+}
+static inline void softlockup_tick_disable(void)
+{
+}
+static inline void softlockup_tick_enable(void)
+{
+}
+static inline int softlockup_disable(void)
+{
+	preempt_disable();
+	return 0;
+}
+static inline void softlockup_enable(int state)
+{
+	preempt_enable();
 }
 static inline void spawn_softlockup_task(void)
 {
===================================================================
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -20,6 +20,7 @@ static DEFINE_PER_CPU(unsigned long, tou
 static DEFINE_PER_CPU(unsigned long, touch_timestamp);
 static DEFINE_PER_CPU(unsigned long, print_timestamp);
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
+static DEFINE_PER_CPU(int, enabled);
 
 static int did_panic = 0;
 
@@ -45,11 +46,65 @@ static unsigned long get_timestamp(void)
 	return sched_clock() >> 30;  /* 2^30 ~= 10^9 */
 }
 
-void touch_softlockup_watchdog(void)
+void inline touch_softlockup_watchdog(void)
 {
 	__raw_get_cpu_var(touch_timestamp) = get_timestamp();
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
+
+/*
+ * Disable the watchdog on this CPU.  This is called directly by the
+ * scheduler to tell us it's going tickless.
+ */
+void inline softlockup_tick_disable(void)
+{
+	__get_cpu_var(enabled) = 0;
+}
+
+/*
+ * Disable the watchdog for this CPU, returning the current state to
+ * allow nesting.  Returns with preemptio disabled, since we can't
+ * switch CPUs before we re-enable the watchdog (also, if we're
+ * worried about getting watchdog timeouts, we're not scheduling).
+ */
+int softlockup_disable(void)
+{
+	int ret;
+
+	preempt_disable();
+
+	ret = __get_cpu_var(enabled);
+	softlockup_tick_disable();
+
+	return ret;
+}
+EXPORT_SYMBOL(softlockup_disable);
+
+/*
+ * Re-enable the watchdog on this CPU.  Called directly by the
+ * scheduler to tell us ticks are resuming.
+ */
+void inline softlockup_tick_enable(void)
+{
+	__get_cpu_var(enabled) = 1;
+}
+
+/*
+ * Returns softlockup watchdog state to before the last per-cpu
+ * disable.
+ */
+void softlockup_enable(int state)
+{
+	if (state) {
+		touch_softlockup_watchdog();
+		/* update timestamp before enable */
+		barrier();
+		softlockup_tick_enable();
+	}
+
+	preempt_enable();
+}
+EXPORT_SYMBOL(softlockup_enable);
 
 /*
  * This callback runs from the timer interrupt, and checks
@@ -62,8 +117,8 @@ void softlockup_tick(void)
 	unsigned long print_timestamp;
 	unsigned long now;
 
-	/* watchdog task hasn't updated timestamp yet */
-	if (touch_timestamp == 0)
+	/* return if not enabled */
+	if (!__get_cpu_var(enabled))
 		return;
 
 	print_timestamp = __get_cpu_var(print_timestamp);
@@ -108,8 +163,8 @@ static int watchdog(void * __bind_cpu)
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->flags |= PF_NOFREEZE;
 
-	/* initialize timestamp */
-	touch_softlockup_watchdog();
+	/* enable on this cpu */
+	softlockup_tick_enable();
 
 	/*
 	 * Run briefly once per second to reset the softlockup timestamp.
@@ -122,6 +177,8 @@ static int watchdog(void * __bind_cpu)
 		touch_softlockup_watchdog();
 		schedule();
 	}
+
+	softlockup_tick_disable();
 
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
+			softlockup_tick_disable();
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
+	softlockup_tick_enable();
 
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
+	softlockup_tick_enable();
 	ts->nohz_mode = NOHZ_MODE_INACTIVE;
 }
 #endif /* HIGH_RES_TIMERS */

-- 

