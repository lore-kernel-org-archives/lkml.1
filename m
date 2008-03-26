Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbYCZPO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbYCZPO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYCZPOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:14:49 -0400
Received: from www.tglx.de ([62.245.132.106]:37199 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbYCZPOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:14:47 -0400
Date: Wed, 26 Mar 2008 16:14:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Gabriel C <crazy@frugalware.org>
Subject: [GIT pull] hrtimer fixes for 2.6.25
Message-ID: <alpine.LFD.1.00.0803261610470.3781@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull hrtimer fixes for 2.6.25 from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git master

The two patches fix the real problem of the false positives of the
clocksource watchdog which were uncoverd by Andis clocksource watchdog
patch. The revert of Andis patch was shooting the messenger.

The real causes of the problems are:

1) commit 1077f5a917b7c630231037826b344b2f7f5b903f
   use init_timer_deferrable for clocksource_watchdog

   which allows the clocksource watchdog timer to be deferred for
   later expiry time. 

   That's wrong as we can miss the wrap around of the pm_timer.

2) Andis watchdog patch rotates the watchdog from one CPU to the
   other. When NOHZ is enabled this might enqueue the watchdog timer
   on an idle CPU which is in a long idle sleep. The idle CPU might
   not notice the new timer which expires perhaps earlier than the one
   which was used to setup the idle sleep time and therefor delays it
   until the scheduled idle sleep ends. This applies to all users of
   add_timer_on(). The solution is to notify the idle CPU about the
   newly added timer so it can reevaluate the timer wheel for the idle
   sleep.

Gabriel confirmed, that the patches solve the problem.

The two patches are necessary fixes even without Andis reverted
watchdog patch, which is rescheduled for .26.

Thanks,

	tglx
---

Thomas Gleixner (2):
      clocksource: revert: use init_timer_deferrable for clocksource_watchdog
      NOHZ: reevaluate idle sleep length after add_timer_on()

 include/linux/sched.h     |    6 ++++++
 kernel/sched.c            |   43 +++++++++++++++++++++++++++++++++++++++++++
 kernel/time/clocksource.c |    2 +-
 kernel/timer.c            |   10 +++++++++-
 4 files changed, 59 insertions(+), 2 deletions(-)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index fed07d0..6a1e7af 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1541,6 +1541,12 @@ static inline void idle_task_exit(void) {}
 
 extern void sched_idle_next(void);
 
+#if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
+extern void wake_up_idle_cpu(int cpu);
+#else
+static inline void wake_up_idle_cpu(int cpu) { }
+#endif
+
 #ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_latency;
 extern unsigned int sysctl_sched_min_granularity;
diff --git a/kernel/sched.c b/kernel/sched.c
index 28c73f0..8dcdec6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1052,6 +1052,49 @@ static void resched_cpu(int cpu)
 	resched_task(cpu_curr(cpu));
 	spin_unlock_irqrestore(&rq->lock, flags);
 }
+
+#ifdef CONFIG_NO_HZ
+/*
+ * When add_timer_on() enqueues a timer into the timer wheel of an
+ * idle CPU then this timer might expire before the next timer event
+ * which is scheduled to wake up that CPU. In case of a completely
+ * idle system the next event might even be infinite time into the
+ * future. wake_up_idle_cpu() ensures that the CPU is woken up and
+ * leaves the inner idle loop so the newly added timer is taken into
+ * account when the CPU goes back to idle and evaluates the timer
+ * wheel for the next timer event.
+ */
+void wake_up_idle_cpu(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	if (cpu == smp_processor_id())
+		return;
+
+	/*
+	 * This is safe, as this function is called with the timer
+	 * wheel base lock of (cpu) held. When the CPU is on the way
+	 * to idle and has not yet set rq->curr to idle then it will
+	 * be serialized on the timer wheel base lock and take the new
+	 * timer into account automatically.
+	 */
+	if (rq->curr != rq->idle)
+		return;
+
+	/*
+	 * We can set TIF_RESCHED on the idle task of the other CPU
+	 * lockless. The worst case is that the other CPU runs the
+	 * idle task through an additional NOOP schedule()
+	 */
+	set_tsk_thread_flag(rq->idle, TIF_NEED_RESCHED);
+
+	/* NEED_RESCHED must be visible before we test polling */
+	smp_mb();
+	if (!tsk_is_polling(rq->idle))
+		smp_send_reschedule(cpu);
+}
+#endif
+
 #else
 static void __resched_task(struct task_struct *p, int tif_bit)
 {
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 278534b..7f60097 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -174,7 +174,7 @@ static void clocksource_check_watchdog(struct clocksource *cs)
 			if (watchdog)
 				del_timer(&watchdog_timer);
 			watchdog = cs;
-			init_timer_deferrable(&watchdog_timer);
+			init_timer(&watchdog_timer);
 			watchdog_timer.function = clocksource_watchdog;
 
 			/* Reset watchdog cycles */
diff --git a/kernel/timer.c b/kernel/timer.c
index 99b00a2..b024106 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -451,10 +451,18 @@ void add_timer_on(struct timer_list *timer, int cpu)
 	spin_lock_irqsave(&base->lock, flags);
 	timer_set_base(timer, base);
 	internal_add_timer(base, timer);
+	/*
+	 * Check whether the other CPU is idle and needs to be
+	 * triggered to reevaluate the timer wheel when nohz is
+	 * active. We are protected against the other CPU fiddling
+	 * with the timer by holding the timer base lock. This also
+	 * makes sure that a CPU on the way to idle can not evaluate
+	 * the timer wheel.
+	 */
+	wake_up_idle_cpu(cpu);
 	spin_unlock_irqrestore(&base->lock, flags);
 }
 
-
 /**
  * mod_timer - modify a timer's timeout
  * @timer: the timer to be modified
