Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbZIMQPl (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sun, 13 Sep 2009 12:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbZIMQPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 12:15:13 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44719 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864AbZIMQPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 12:15:07 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
   akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
   josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
   tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
   Valdis.Kletnieks@vt.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/4] Fix synchronize_rcu() for TREE_PREEMPT_RCU
Date: Sun, 13 Sep 2009 09:15:11 -0700
Message-Id: <12528585111916-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090913161438.GA32550@linux.vnet.ibm.com>
References: <20090913161438.GA32550@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

The redirection of synchronize_sched() to synchronize_rcu() was appropriate
for TREE_RCU, but not for TREE_PREEMPT_RCU.  Fix this by creating an
underlying synchronize_sched().  TREE_RCU then redirects synchronize_rcu()
to synchronize_sched(), while TREE_PREEMPT_RCU has its own version of
synchronize_rcu().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   23 +++++------------------
 include/linux/rcutree.h  |    4 ++--
 kernel/rcupdate.c        |   44 +++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 50 insertions(+), 21 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 95e0615..39dce83 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -52,8 +52,13 @@ struct rcu_head {
 };
 
 /* Exported common interfaces */
+#ifdef CONFIG_TREE_PREEMPT_RCU
 extern void synchronize_rcu(void);
+#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#define synchronize_rcu synchronize_sched
+#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 extern void synchronize_rcu_bh(void);
+extern void synchronize_sched(void);
 extern void rcu_barrier(void);
 extern void rcu_barrier_bh(void);
 extern void rcu_barrier_sched(void);
@@ -262,24 +267,6 @@ struct rcu_synchronize {
 extern void wakeme_after_rcu(struct rcu_head  *head);
 
 /**
- * synchronize_sched - block until all CPUs have exited any non-preemptive
- * kernel code sequences.
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
-#define synchronize_sched() __synchronize_sched()
-
-/**
  * call_rcu - Queue an RCU callback for invocation after a grace period.
  * @head: structure to be used for queueing the RCU updates.
  * @func: actual update function to be invoked after the grace period
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index a893077..00d08c0 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -53,6 +53,8 @@ static inline void __rcu_read_unlock(void)
 	preempt_enable();
 }
 
+#define __synchronize_sched() synchronize_rcu()
+
 static inline void exit_rcu(void)
 {
 }
@@ -68,8 +70,6 @@ static inline void __rcu_read_unlock_bh(void)
 	local_bh_enable();
 }
 
-#define __synchronize_sched() synchronize_rcu()
-
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));
 
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index bd5d5c8..28d2f24 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -74,6 +74,8 @@ void wakeme_after_rcu(struct rcu_head  *head)
 	complete(&rcu->completion);
 }
 
+#ifdef CONFIG_TREE_PREEMPT_RCU
+
 /**
  * synchronize_rcu - wait until a grace period has elapsed.
  *
@@ -87,7 +89,7 @@ void synchronize_rcu(void)
 {
 	struct rcu_synchronize rcu;
 
-	if (rcu_blocking_is_gp())
+	if (!rcu_scheduler_active)
 		return;
 
 	init_completion(&rcu.completion);
@@ -98,6 +100,46 @@ void synchronize_rcu(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+
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
 /**
  * synchronize_rcu_bh - wait until an rcu_bh grace period has elapsed.
  *
-- 
1.5.2.5

