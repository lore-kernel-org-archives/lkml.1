Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbYBYQbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbYBYQbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 11:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbYBYQ3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 11:29:41 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53958
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756762AbYBYQ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 11:29:38 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [(RT RFC) PATCH v2 7/9] adaptive mutexes
To: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, pavel@ucw.cz,
       acme@redhat.com, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com, ghaskins@novell.com
Date: Mon, 25 Feb 2008 11:01:13 -0500
Message-ID: <20080225160113.11268.538.stgit@novell1.haskins.net>
In-Reply-To: <20080225155959.11268.35541.stgit@novell1.haskins.net>
References: <20080225155959.11268.35541.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter W.Morreale <pmorreale@novell.com>

This patch adds the adaptive spin lock busywait to rtmutexes.  It adds
a new tunable: rtmutex_timeout, which is the companion to the
rtlock_timeout tunable.

Signed-off-by: Peter W. Morreale <pmorreale@novell.com>
---

 kernel/Kconfig.preempt    |   37 ++++++++++++++++++++++
 kernel/rtmutex.c          |   76 +++++++++++++++++++++++++--------------------
 kernel/rtmutex_adaptive.h |   32 ++++++++++++++++++-
 kernel/sysctl.c           |   10 ++++++
 4 files changed, 119 insertions(+), 36 deletions(-)

diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index ac1cbad..864bf14 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -214,6 +214,43 @@ config RTLOCK_DELAY
 	 tunable at runtime via a sysctl.  A setting of 0 (zero) disables
 	 the adaptive algorithm entirely.
 
+config ADAPTIVE_RTMUTEX
+        bool "Adaptive real-time mutexes"
+        default y
+        depends on ADAPTIVE_RTLOCK
+        help
+         This option adds the adaptive rtlock spin/sleep algorithm to
+         rtmutexes.  In rtlocks, a significant gain in throughput
+         can be seen by allowing rtlocks to spin for a distinct
+         amount of time prior to going to sleep for deadlock avoidence.
+ 
+         Typically, mutexes are used when a critical section may need to
+         sleep due to a blocking operation.  In the event the critical 
+	 section does not need to sleep, an additional gain in throughput 
+	 can be seen by avoiding the extra overhead of sleeping.
+ 
+         This option alters the rtmutex code to use an adaptive
+         spin/sleep algorithm.  It will spin unless it determines it must
+         sleep to avoid deadlock.  This offers a best of both worlds
+         solution since we achieve both high-throughput and low-latency.
+ 
+         If unsure, say Y
+ 
+config RTMUTEX_DELAY
+        int "Default delay (in loops) for adaptive mutexes"
+        range 0 10000000
+        depends on ADAPTIVE_RTMUTEX
+        default "3000"
+        help
+         This allows you to specify the maximum delay a task will use
+	 to wait for a rt mutex before going to sleep.  Note that that
+	 although the delay is implemented as a preemptable loop, tasks
+	 of like priority cannot preempt each other and this setting can
+	 result in increased latencies.
+	 
+         The value is tunable at runtime via a sysctl.  A setting of 0
+	 (zero) disables the adaptive algorithm entirely.
+
 config SPINLOCK_BKL
 	bool "Old-Style Big Kernel Lock"
 	depends on (PREEMPT || SMP) && !PREEMPT_RT
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 4a16b13..ea593e0 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -29,6 +29,10 @@ int rtmutex_lateral_steal __read_mostly = 1;
 int rtlock_timeout __read_mostly = CONFIG_RTLOCK_DELAY;
 #endif
 
+#ifdef CONFIG_ADAPTIVE_RTMUTEX
+int rtmutex_timeout __read_mostly = CONFIG_RTMUTEX_DELAY;
+#endif
+
 /*
  * lock->owner state tracking:
  *
@@ -542,34 +546,33 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
 	 * Do the wakeup before the ownership change to give any spinning
 	 * waiter grantees a headstart over the other threads that will
 	 * trigger once owner changes.
+	 *
+	 * We can skip the actual (expensive) wakeup if the
+	 * waiter is already running, but we have to be careful
+	 * of race conditions because they may be about to sleep.
+	 *
+	 * The waiter-side protocol has the following pattern:
+	 * 1: Set state != RUNNING
+	 * 2: Conditionally sleep if waiter->task != NULL;
+	 *
+	 * And the owner-side has the following:
+	 * A: Set waiter->task = NULL
+	 * B: Conditionally wake if the state != RUNNING
+	 *
+	 * As long as we ensure 1->2 order, and A->B order, we
+	 * will never miss a wakeup.
+	 *
+	 * Therefore, this barrier ensures that waiter->task = NULL
+	 * is visible before we test the pendowner->state.  The
+	 * corresponding barrier is in the sleep logic.
 	 */
-	if (!savestate)
-		wake_up_process(pendowner);
-	else {
-		/*
-		 * We can skip the actual (expensive) wakeup if the
-		 * waiter is already running, but we have to be careful
-		 * of race conditions because they may be about to sleep.
-		 *
-		 * The waiter-side protocol has the following pattern:
-		 * 1: Set state != RUNNING
-		 * 2: Conditionally sleep if waiter->task != NULL;
-		 *
-		 * And the owner-side has the following:
-		 * A: Set waiter->task = NULL
-		 * B: Conditionally wake if the state != RUNNING
-		 *
-		 * As long as we ensure 1->2 order, and A->B order, we
-		 * will never miss a wakeup.
-		 *
-		 * Therefore, this barrier ensures that waiter->task = NULL
-		 * is visible before we test the pendowner->state.  The
-		 * corresponding barrier is in the sleep logic.
-		 */
-		smp_mb();
+	smp_mb();
 
-		if ((pendowner->state != TASK_RUNNING)
-		    && (pendowner->state != TASK_RUNNING_MUTEX))
+	if ((pendowner->state != TASK_RUNNING)
+	    && (pendowner->state != TASK_RUNNING_MUTEX)) {
+		if (!savestate)
+			wake_up_process(pendowner);
+		else
 			wake_up_process_mutex(pendowner);
 	}
 
@@ -802,7 +805,7 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 		debug_rt_mutex_print_deadlock(&waiter);
 
 		/* adaptive_wait() returns 1 if we need to sleep */
-		if (adaptive_wait(lock, &waiter, &adaptive)) {
+		if (adaptive_wait(lock, 0, &waiter, &adaptive)) {
 			update_current(TASK_UNINTERRUPTIBLE, &saved_state);
 			/*
 			 * The xchg() in update_current() is an implicit
@@ -1018,6 +1021,7 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	int ret = 0, saved_lock_depth = -1;
 	struct rt_mutex_waiter waiter;
 	unsigned long flags;
+	DECLARE_ADAPTIVE_MUTEX_WAITER(adaptive);
 
 	debug_rt_mutex_init_waiter(&waiter);
 	waiter.task = NULL;
@@ -1038,8 +1042,6 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	if (unlikely(current->lock_depth >= 0))
 		saved_lock_depth = rt_release_bkl(lock, flags);
 
-	set_current_state(state);
-
 	/* Setup the timer, when timeout != NULL */
 	if (unlikely(timeout))
 		hrtimer_start(&timeout->timer, timeout->timer.expires,
@@ -1092,6 +1094,9 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 			if (unlikely(ret))
 				break;
 		}
+
+		mutex_prepare_adaptive_wait(lock, &adaptive);
+
 		saved_flags = current->flags & PF_NOSCHED;
 		current->flags &= ~PF_NOSCHED;
 
@@ -1099,17 +1104,20 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 
 		debug_rt_mutex_print_deadlock(&waiter);
 
-		if (waiter.task)
-			schedule_rt_mutex(lock);
+		if (mutex_adaptive_wait(lock,
+					(state == TASK_INTERRUPTIBLE),
+					&waiter, &adaptive)) {
+			set_current_state(state);
+			if (waiter.task)
+				schedule_rt_mutex(lock);
+			set_current_state(TASK_RUNNING);
+		}
 
 		spin_lock_irq(&lock->wait_lock);
 
 		current->flags |= saved_flags;
-		set_current_state(state);
 	}
 
-	set_current_state(TASK_RUNNING);
-
 	if (unlikely(waiter.task))
 		remove_waiter(lock, &waiter, flags);
 
diff --git a/kernel/rtmutex_adaptive.h b/kernel/rtmutex_adaptive.h
index 60c6328..ad5beea 100644
--- a/kernel/rtmutex_adaptive.h
+++ b/kernel/rtmutex_adaptive.h
@@ -60,7 +60,8 @@ struct adaptive_waiter {
  *
  */
 static inline int
-adaptive_wait(struct rt_mutex *lock, struct rt_mutex_waiter *waiter,
+adaptive_wait(struct rt_mutex *lock, int interruptible,
+	      struct rt_mutex_waiter *waiter,
 	      struct adaptive_waiter *adaptive)
 {
 	int sleep = 0;
@@ -81,6 +82,14 @@ adaptive_wait(struct rt_mutex *lock, struct rt_mutex_waiter *waiter,
 		if (adaptive->owner != rt_mutex_owner(lock))
 			break;
 
+#ifdef CONFIG_ADAPTIVE_RTMUTEX
+		/*
+		 * Mutexes may need to check for signals...
+		 */
+		if (interruptible && signal_pending(current))
+			break;
+#endif
+
 		/*
 		 * If we got here, presumably the lock ownership is still
 		 * current.  We will use it to our advantage to be able to
@@ -136,10 +145,29 @@ extern int rtlock_timeout;
 
 #define DECLARE_ADAPTIVE_WAITER(name)
 
-#define adaptive_wait(lock, waiter, busy) 1
+#define adaptive_wait(lock, intr, waiter, busy) 1
 #define prepare_adaptive_wait(lock, busy) {}
 
 #endif /* CONFIG_ADAPTIVE_RTLOCK */
 
+#ifdef CONFIG_ADAPTIVE_RTMUTEX
+
+#define mutex_adaptive_wait         adaptive_wait
+#define mutex_prepare_adaptive_wait prepare_adaptive_wait
+
+extern int rtmutex_timeout;
+
+#define DECLARE_ADAPTIVE_MUTEX_WAITER(name) \
+     struct adaptive_waiter name = { .owner = NULL,               \
+                                     .timeout = rtmutex_timeout, }
+
+#else
+
+#define DECLARE_ADAPTIVE_MUTEX_WAITER(name)
+
+#define mutex_adaptive_wait(lock, intr, waiter, busy) 1
+#define mutex_prepare_adaptive_wait(lock, busy) {}
+
+#endif /* CONFIG_ADAPTIVE_RTMUTEX */
 
 #endif /* __KERNEL_RTMUTEX_ADAPTIVE_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 55189ea..c353e75 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -862,6 +862,16 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_ADAPTIVE_RTMUTEX
+	{
+		.ctl_name       = CTL_UNNUMBERED,
+		.procname       = "rtmutex_timeout",
+		.data           = &rtmutex_timeout,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+       },
+#endif
 #ifdef CONFIG_PROC_FS
 	{
 		.ctl_name       = CTL_UNNUMBERED,

