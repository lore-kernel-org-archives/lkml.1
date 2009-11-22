Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbZKVQxq (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sun, 22 Nov 2009 11:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZKVQxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 11:53:46 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46178 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402AbZKVQxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 11:53:42 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] rcu: re-arrange code to reduce #ifdef pain
Date: Sun, 22 Nov 2009 08:53:50 -0800
Message-Id: <1258908830885-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091122165321.GA19922@linux.vnet.ibm.com>
References: <20091122165321.GA19922@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Remove #ifdefs from kernel/rcupdate.c and include/linux/rcupdate.h
by moving code to include/linux/rcutiny.h, include/linux/rcutree.h,
and kernel/rcutree.c.  Also remove some definitions that are no longer
used.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   12 -----
 include/linux/rcutiny.h  |   11 +++++
 include/linux/rcutree.h  |    4 +-
 kernel/rcupdate.c        |  104 ----------------------------------------------
 kernel/rcutree.c         |   80 +++++++++++++++++++++++++++++++++++
 kernel/rcutree_plugin.h  |   24 +++++++++++
 6 files changed, 118 insertions(+), 117 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 2f1bc42..24440f4 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -52,11 +52,6 @@ struct rcu_head {
 };
 
 /* Exported common interfaces */
-#ifdef CONFIG_TREE_PREEMPT_RCU
-extern void synchronize_rcu(void);
-#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-#define synchronize_rcu synchronize_sched
-#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 extern void synchronize_rcu_bh(void);
 extern void synchronize_sched(void);
 extern void rcu_barrier(void);
@@ -67,13 +62,6 @@ extern int sched_expedited_torture_stats(char *page);
 
 /* Internal to kernel */
 extern void rcu_init(void);
-extern void rcu_scheduler_starting(void);
-#ifndef CONFIG_TINY_RCU
-extern int rcu_needs_cpu(int cpu);
-#else
-static inline int rcu_needs_cpu(int cpu) { return 0; }
-#endif
-extern int rcu_scheduler_active;
 
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index a3b6272..c4ba9a7 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -39,6 +39,11 @@ void rcu_bh_qs(int cpu);
 #define rcu_init_sched()	do { } while (0)
 extern void rcu_check_callbacks(int cpu, int user);
 
+static inline int rcu_needs_cpu(int cpu)
+{
+	return 0;
+}
+
 /*
  * Return the number of grace periods.
  */
@@ -57,6 +62,8 @@ static inline long rcu_batches_completed_bh(void)
 
 extern int rcu_expedited_torture_stats(char *page);
 
+#define synchronize_rcu synchronize_sched
+
 static inline void synchronize_rcu_expedited(void)
 {
 	synchronize_sched();
@@ -86,6 +93,10 @@ static inline void rcu_exit_nohz(void)
 
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
+static inline void rcu_scheduler_starting(void)
+{
+}
+
 static inline void exit_rcu(void)
 {
 }
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 111a652..c93eee5 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -35,12 +35,14 @@ struct notifier_block;
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern int rcu_needs_cpu(int cpu);
+extern void rcu_scheduler_starting(void);
 extern int rcu_expedited_torture_stats(char *page);
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
 extern void __rcu_read_lock(void);
 extern void __rcu_read_unlock(void);
+extern void synchronize_rcu(void);
 extern void exit_rcu(void);
 
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
@@ -55,7 +57,7 @@ static inline void __rcu_read_unlock(void)
 	preempt_enable();
 }
 
-#define __synchronize_sched() synchronize_rcu()
+#define synchronize_rcu synchronize_sched
 
 static inline void exit_rcu(void)
 {
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index eb6b534..9b7fd47 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -44,7 +44,6 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
-#include <linux/kernel_stat.h>
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
@@ -53,8 +52,6 @@ struct lockdep_map rcu_lock_map =
 EXPORT_SYMBOL_GPL(rcu_lock_map);
 #endif
 
-int rcu_scheduler_active __read_mostly;
-
 /*
  * Awaken the corresponding synchronize_rcu() instance now that a
  * grace period has elapsed.
@@ -66,104 +63,3 @@ void wakeme_after_rcu(struct rcu_head  *head)
 	rcu = container_of(head, struct rcu_synchronize, head);
 	complete(&rcu->completion);
 }
-
-#ifndef CONFIG_TINY_RCU
-
-#ifdef CONFIG_TREE_PREEMPT_RCU
-
-/**
- * synchronize_rcu - wait until a grace period has elapsed.
- *
- * Control will return to the caller some time after a full grace
- * period has elapsed, in other words after all currently executing RCU
- * read-side critical sections have completed.  RCU read-side critical
- * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
- * and may be nested.
- */
-void synchronize_rcu(void)
-{
-	struct rcu_synchronize rcu;
-
-	if (!rcu_scheduler_active)
-		return;
-
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-}
-EXPORT_SYMBOL_GPL(synchronize_rcu);
-
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-
-/**
- * synchronize_sched - wait until an rcu-sched grace period has elapsed.
- *
- * Control will return to the caller some time after a full rcu-sched
- * grace period has elapsed, in other words after all currently executing
- * rcu-sched read-side critical sections have completed.   These read-side
- * critical sections are delimited by rcu_read_lock_sched() and
- * rcu_read_unlock_sched(), and may be nested.  Note that preempt_disable(),
- * local_irq_disable(), and so on may be used in place of
- * rcu_read_lock_sched().
- *
- * This means that all preempt_disable code sequences, including NMI and
- * hardware-interrupt handlers, in progress on entry will have completed
- * before this primitive returns.  However, this does not guarantee that
- * softirq handlers will have completed, since in some kernels, these
- * handlers can run in process context, and can block.
- *
- * This primitive provides the guarantees made by the (now removed)
- * synchronize_kernel() API.  In contrast, synchronize_rcu() only
- * guarantees that rcu_read_lock() sections will have completed.
- * In "classic RCU", these two guarantees happen to be one and
- * the same, but can differ in realtime RCU implementations.
- */
-void synchronize_sched(void)
-{
-	struct rcu_synchronize rcu;
-
-	if (rcu_blocking_is_gp())
-		return;
-
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu_sched(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-}
-EXPORT_SYMBOL_GPL(synchronize_sched);
-
-/**
- * synchronize_rcu_bh - wait until an rcu_bh grace period has elapsed.
- *
- * Control will return to the caller some time after a full rcu_bh grace
- * period has elapsed, in other words after all currently executing rcu_bh
- * read-side critical sections have completed.  RCU read-side critical
- * sections are delimited by rcu_read_lock_bh() and rcu_read_unlock_bh(),
- * and may be nested.
- */
-void synchronize_rcu_bh(void)
-{
-	struct rcu_synchronize rcu;
-
-	if (rcu_blocking_is_gp())
-		return;
-
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu_bh(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-}
-EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
-
-#endif /* #ifndef CONFIG_TINY_RCU */
-
-void rcu_scheduler_starting(void)
-{
-	WARN_ON(num_online_cpus() != 1);
-	WARN_ON(nr_context_switches() > 0);
-	rcu_scheduler_active = 1;
-}
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e3d3bbd..4ca7e02 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -46,6 +46,7 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/time.h>
+#include <linux/kernel_stat.h>
 
 #include "rcutree.h"
 
@@ -79,6 +80,8 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
+static int rcu_scheduler_active __read_mostly;
+
 
 /*
  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
@@ -1396,6 +1399,68 @@ void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
+/**
+ * synchronize_sched - wait until an rcu-sched grace period has elapsed.
+ *
+ * Control will return to the caller some time after a full rcu-sched
+ * grace period has elapsed, in other words after all currently executing
+ * rcu-sched read-side critical sections have completed.   These read-side
+ * critical sections are delimited by rcu_read_lock_sched() and
+ * rcu_read_unlock_sched(), and may be nested.  Note that preempt_disable(),
+ * local_irq_disable(), and so on may be used in place of
+ * rcu_read_lock_sched().
+ *
+ * This means that all preempt_disable code sequences, including NMI and
+ * hardware-interrupt handlers, in progress on entry will have completed
+ * before this primitive returns.  However, this does not guarantee that
+ * softirq handlers will have completed, since in some kernels, these
+ * handlers can run in process context, and can block.
+ *
+ * This primitive provides the guarantees made by the (now removed)
+ * synchronize_kernel() API.  In contrast, synchronize_rcu() only
+ * guarantees that rcu_read_lock() sections will have completed.
+ * In "classic RCU", these two guarantees happen to be one and
+ * the same, but can differ in realtime RCU implementations.
+ */
+void synchronize_sched(void)
+{
+	struct rcu_synchronize rcu;
+
+	if (rcu_blocking_is_gp())
+		return;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu_sched(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
+EXPORT_SYMBOL_GPL(synchronize_sched);
+
+/**
+ * synchronize_rcu_bh - wait until an rcu_bh grace period has elapsed.
+ *
+ * Control will return to the caller some time after a full rcu_bh grace
+ * period has elapsed, in other words after all currently executing rcu_bh
+ * read-side critical sections have completed.  RCU read-side critical
+ * sections are delimited by rcu_read_lock_bh() and rcu_read_unlock_bh(),
+ * and may be nested.
+ */
+void synchronize_rcu_bh(void)
+{
+	struct rcu_synchronize rcu;
+
+	if (rcu_blocking_is_gp())
+		return;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu_bh(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
+EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
+
 /*
  * Check to see if there is any immediate RCU-related work to be done
  * by the current CPU, for the specified type of RCU, returning 1 if so.
@@ -1480,6 +1545,21 @@ int rcu_needs_cpu(int cpu)
 	       rcu_preempt_needs_cpu(cpu);
 }
 
+/*
+ * This function is invoked towards the end of the scheduler's initialization
+ * process.  Before this is called, the idle task might contain
+ * RCU read-side critical sections (during which time, this idle
+ * task is booting the system).  After this function is called, the
+ * idle tasks are prohibited from containing RCU read-side critical
+ * sections.
+ */
+void rcu_scheduler_starting(void)
+{
+	WARN_ON(num_online_cpus() != 1);
+	WARN_ON(nr_context_switches() > 0);
+	rcu_scheduler_active = 1;
+}
+
 static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
 static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 0bdb592..1d295c7 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -425,6 +425,30 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
+/**
+ * synchronize_rcu - wait until a grace period has elapsed.
+ *
+ * Control will return to the caller some time after a full grace
+ * period has elapsed, in other words after all currently executing RCU
+ * read-side critical sections have completed.  RCU read-side critical
+ * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
+ * and may be nested.
+ */
+void synchronize_rcu(void)
+{
+	struct rcu_synchronize rcu;
+
+	if (!rcu_scheduler_active)
+		return;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
+EXPORT_SYMBOL_GPL(synchronize_rcu);
+
 /*
  * Wait for an rcu-preempt grace period.  We are supposed to expedite the
  * grace period, but this is the crude slow compatability hack, so just
-- 
1.5.2.5

