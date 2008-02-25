Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbYBYQbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbYBYQbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 11:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbYBYQ3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 11:29:31 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53934
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755010AbYBYQ32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 11:29:28 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [(RT RFC) PATCH v2 5/9] adaptive real-time lock support
To: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, pavel@ucw.cz,
       acme@redhat.com, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com, ghaskins@novell.com
Date: Mon, 25 Feb 2008 11:01:03 -0500
Message-ID: <20080225160103.11268.25579.stgit@novell1.haskins.net>
In-Reply-To: <20080225155959.11268.35541.stgit@novell1.haskins.net>
References: <20080225155959.11268.35541.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are pros and cons when deciding between the two basic forms of
locking primitives (spinning vs sleeping).  Without going into great
detail on either one, we note that spinlocks have the advantage of
lower overhead for short hold locks.  However, they also have a
con in that they create indeterminate latencies since preemption
must traditionally be disabled while the lock is held (to prevent deadlock).

We want to avoid non-deterministic critical sections in -rt. Therefore,
when realtime is enabled, most contexts are converted to threads, and
likewise most spinlock_ts are converted to sleepable rt-mutex derived
locks.  This allows the holder of the lock to remain fully preemptible,
thus reducing a major source of latencies in the kernel.

However, converting what was once a true spinlock into a sleeping lock
may also decrease performance since the locks will now sleep under
contention.  Since the fundamental lock used to be a spinlock, it is
highly likely that it was used in a short-hold path and that release
is imminent.  Therefore sleeping only serves to cause context-thrashing.

Adaptive RT locks use a hybrid approach to solve the problem.  They
spin when possible, and sleep when necessary (to avoid deadlock, etc).
This significantly improves many areas of the performance of the -rt
kernel.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Peter Morreale <pmorreale@novell.com>
Signed-off-by: Sven Dietrich <sdietrich@novell.com>
---

 kernel/Kconfig.preempt    |   20 +++++++
 kernel/rtmutex.c          |   30 +++++++---
 kernel/rtmutex_adaptive.h |  138 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 178 insertions(+), 10 deletions(-)

diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index e493257..d2432fa 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -183,6 +183,26 @@ config RCU_TRACE
 	  Say Y/M here if you want to enable RCU tracing in-kernel/module.
 	  Say N if you are unsure.
 
+config ADAPTIVE_RTLOCK
+        bool "Adaptive real-time locks"
+        default y
+        depends on PREEMPT_RT && SMP
+        help
+          PREEMPT_RT allows for greater determinism by transparently
+          converting normal spinlock_ts into preemptible rtmutexes which
+          sleep any waiters under contention.  However, in many cases the
+          lock will be released in less time than it takes to context
+          switch.  Therefore, the "sleep under contention" policy may also
+          degrade throughput performance due to the extra context switches.
+
+          This option alters the rtmutex derived spinlock_t replacement
+          code to use an adaptive spin/sleep algorithm.  It will spin
+          unless it determines it must sleep to avoid deadlock.  This
+          offers a best of both worlds solution since we achieve both
+          high-throughput and low-latency.
+
+          If unsure, say Y.
+
 config SPINLOCK_BKL
 	bool "Old-Style Big Kernel Lock"
 	depends on (PREEMPT || SMP) && !PREEMPT_RT
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index bf9e230..3802ef8 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -7,6 +7,8 @@
  *  Copyright (C) 2005-2006 Timesys Corp., Thomas Gleixner <tglx@timesys.com>
  *  Copyright (C) 2005 Kihon Technologies Inc., Steven Rostedt
  *  Copyright (C) 2006 Esben Nielsen
+ *  Copyright (C) 2008 Novell, Inc., Sven Dietrich, Peter Morreale,
+ *                                   and Gregory Haskins
  *
  *  See Documentation/rt-mutex-design.txt for details.
  */
@@ -17,6 +19,7 @@
 #include <linux/hardirq.h>
 
 #include "rtmutex_common.h"
+#include "rtmutex_adaptive.h"
 
 #ifdef CONFIG_RTLOCK_LATERAL_STEAL
 int rtmutex_lateral_steal __read_mostly = 1;
@@ -734,6 +737,7 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 {
 	struct rt_mutex_waiter waiter;
 	unsigned long saved_state, state, flags;
+	DECLARE_ADAPTIVE_WAITER(adaptive);
 
 	debug_rt_mutex_init_waiter(&waiter);
 	waiter.task = NULL;
@@ -780,6 +784,8 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 				continue;
 		}
 
+		prepare_adaptive_wait(lock, &adaptive);
+
 		/*
 		 * Prevent schedule() to drop BKL, while waiting for
 		 * the lock ! We restore lock_depth when we come back.
@@ -791,16 +797,20 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 
 		debug_rt_mutex_print_deadlock(&waiter);
 
-		update_current(TASK_UNINTERRUPTIBLE, &saved_state);
-		/*
-		 * The xchg() in update_current() is an implicit barrier
-		 * which we rely upon to ensure current->state is visible
-		 * before we test waiter.task.
-		 */
-		if (waiter.task)
-			schedule_rt_mutex(lock);
-		else
-			update_current(TASK_RUNNING_MUTEX, &saved_state);
+		/* adaptive_wait() returns 1 if we need to sleep */
+		if (adaptive_wait(lock, &waiter, &adaptive)) {
+			update_current(TASK_UNINTERRUPTIBLE, &saved_state);
+			/*
+			 * The xchg() in update_current() is an implicit
+			 * barrier which we rely upon to ensure current->state
+			 * is visible before we test waiter.task.
+			 */
+			if (waiter.task)
+				schedule_rt_mutex(lock);
+			else
+				update_current(TASK_RUNNING_MUTEX,
+					       &saved_state);
+		}
 
 		spin_lock_irqsave(&lock->wait_lock, flags);
 		current->flags |= saved_flags;
diff --git a/kernel/rtmutex_adaptive.h b/kernel/rtmutex_adaptive.h
new file mode 100644
index 0000000..862c088
--- /dev/null
+++ b/kernel/rtmutex_adaptive.h
@@ -0,0 +1,138 @@
+/*
+ * Adaptive RT lock support
+ *
+ * There are pros and cons when deciding between the two basic forms of
+ * locking primitives (spinning vs sleeping).  Without going into great
+ * detail on either one, we note that spinlocks have the advantage of
+ * lower overhead for short hold locks.  However, they also have a
+ * con in that they create indeterminate latencies since preemption
+ * must traditionally be disabled while the lock is held (to prevent deadlock).
+ *
+ * We want to avoid non-deterministic critical sections in -rt. Therefore,
+ * when realtime is enabled, most contexts are converted to threads, and
+ * likewise most spinlock_ts are converted to sleepable rt-mutex derived
+ * locks.  This allows the holder of the lock to remain fully preemptible,
+ * thus reducing a major source of latencies in the kernel.
+ *
+ * However, converting what was once a true spinlock into a sleeping lock
+ * may also decrease performance since the locks will now sleep under
+ * contention.  Since the fundamental lock used to be a spinlock, it is
+ * highly likely that it was used in a short-hold path and that release
+ * is imminent.  Therefore sleeping only serves to cause context-thrashing.
+ *
+ * Adaptive RT locks use a hybrid approach to solve the problem.  They
+ * spin when possible, and sleep when necessary (to avoid deadlock, etc).
+ * This significantly improves many areas of the performance of the -rt
+ * kernel.
+ *
+ * Copyright (C) 2008 Novell, Inc.,
+ *          Sven Dietrich, Peter Morreale, and Gregory Haskins
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; version 2
+ *  of the License.
+ */
+
+#ifndef __KERNEL_RTMUTEX_ADAPTIVE_H
+#define __KERNEL_RTMUTEX_ADAPTIVE_H
+
+#include "rtmutex_common.h"
+
+
+#ifdef CONFIG_ADAPTIVE_RTLOCK
+struct adaptive_waiter {
+	struct task_struct *owner;
+};
+
+/*
+ * Adaptive-rtlocks will busywait when possible, and sleep only if
+ * necessary. Note that the busyloop looks racy, and it is....but we do
+ * not care. If we lose any races it simply means that we spin one more
+ * time before seeing that we need to break-out on the next iteration.
+ *
+ * We realize this is a relatively large function to inline, but note that
+ * it is only instantiated 1 or 2 times max, and it makes a measurable
+ * performance different to avoid the call.
+ *
+ * Returns 1 if we should sleep
+ *
+ */
+static inline int
+adaptive_wait(struct rt_mutex *lock, struct rt_mutex_waiter *waiter,
+	      struct adaptive_waiter *adaptive)
+{
+	int sleep = 0;
+
+	for (;;) {
+		/*
+		 * If the task was re-awoken, break out completely so we can
+		 * reloop through the lock-acquisition code.
+		 */
+		if (!waiter->task)
+			break;
+
+		/*
+		 * We need to break if the owner changed so we can reloop
+		 * and safely acquire the owner-pointer again with the
+		 * wait_lock held.
+		 */
+		if (adaptive->owner != rt_mutex_owner(lock))
+			break;
+
+		/*
+		 * If we got here, presumably the lock ownership is still
+		 * current.  We will use it to our advantage to be able to
+		 * spin without disabling preemption...
+		 */
+
+		/*
+		 * .. sleep if the owner is not running..
+		 */
+		if (!adaptive->owner->se.on_rq) {
+			sleep = 1;
+			break;
+		}
+
+		/*
+		 * .. or is running on our own cpu (to prevent deadlock)
+		 */
+		if (task_cpu(adaptive->owner) == task_cpu(current)) {
+			sleep = 1;
+			break;
+		}
+
+		cpu_relax();
+	}
+
+	put_task_struct(adaptive->owner);
+
+	return sleep;
+}
+
+static inline void
+prepare_adaptive_wait(struct rt_mutex *lock, struct adaptive_waiter *adaptive)
+{
+	/*
+	 * We must acquire/lock the owner pointer while holding
+	 * the wait_lock, or we risk racing against the owner
+	 * exiting.
+	 */
+	adaptive->owner = rt_mutex_owner(lock);
+	get_task_struct(adaptive->owner);
+}
+
+#define DECLARE_ADAPTIVE_WAITER(name) \
+     struct adaptive_waiter name = { .owner = NULL, }
+
+#else
+
+#define DECLARE_ADAPTIVE_WAITER(name)
+
+#define adaptive_wait(lock, waiter, busy) 1
+#define prepare_adaptive_wait(lock, busy) {}
+
+#endif /* CONFIG_ADAPTIVE_RTLOCK */
+
+
+#endif /* __KERNEL_RTMUTEX_ADAPTIVE_H */

