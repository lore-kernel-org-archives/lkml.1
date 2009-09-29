Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbZI2Eu0 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 29 Sep 2009 00:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZI2EuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 00:50:25 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49251 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbZI2EuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 00:50:22 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/3] rcu: move rcu_barrier() to rcutree, make lightweight rcu_barrier() for rcutiny
Date: Mon, 28 Sep 2009 21:50:22 -0700
Message-Id: <12541998233817-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090929044955.GA12486@linux.vnet.ibm.com>
References: <20090929044955.GA12486@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Move the existing rcu_barrier() implementation to rcutree.c, permitting
creation of a smaller and lighter-weight implementation for rcutiny.c
(which is equivalent to rcutree.c's synchronize_rcu() because rcutiny.c
supports but one CPU).  This opens the way to simplify rcutree.c's
rcu_barrier() implementation in a later patch.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcupdate.c |  120 +----------------------------------------------------
 kernel/rcutiny.c  |   36 ++++++++++++++++
 kernel/rcutree.c  |  119 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 156 insertions(+), 119 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index fd3ec49..7625f20 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -53,16 +53,8 @@ struct lockdep_map rcu_lock_map =
 EXPORT_SYMBOL_GPL(rcu_lock_map);
 #endif
 
-static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
-static atomic_t rcu_barrier_cpu_count;
-static DEFINE_MUTEX(rcu_barrier_mutex);
-static struct completion rcu_barrier_completion;
 int rcu_scheduler_active __read_mostly;
 
-static atomic_t rcu_migrate_type_count = ATOMIC_INIT(0);
-static struct rcu_head rcu_migrate_head[3];
-static DECLARE_WAIT_QUEUE_HEAD(rcu_migrate_wq);
-
 /*
  * Awaken the corresponding synchronize_rcu() instance now that a
  * grace period has elapsed.
@@ -169,120 +161,10 @@ EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
 #endif /* #ifndef CONFIG_TINY_RCU */
 
-static void rcu_barrier_callback(struct rcu_head *notused)
-{
-	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
-		complete(&rcu_barrier_completion);
-}
-
-/*
- * Called with preemption disabled, and from cross-cpu IRQ context.
- */
-static void rcu_barrier_func(void *type)
-{
-	int cpu = smp_processor_id();
-	struct rcu_head *head = &per_cpu(rcu_barrier_head, cpu);
-	void (*call_rcu_func)(struct rcu_head *head,
-			      void (*func)(struct rcu_head *head));
-
-	atomic_inc(&rcu_barrier_cpu_count);
-	call_rcu_func = type;
-	call_rcu_func(head, rcu_barrier_callback);
-}
-
-static inline void wait_migrated_callbacks(void)
-{
-	wait_event(rcu_migrate_wq, !atomic_read(&rcu_migrate_type_count));
-	smp_mb(); /* In case we didn't sleep. */
-}
-
-/*
- * Orchestrate the specified type of RCU barrier, waiting for all
- * RCU callbacks of the specified type to complete.
- */
-static void _rcu_barrier(void (*call_rcu_func)(struct rcu_head *head,
-					       void (*func)(struct rcu_head *head)))
-{
-	BUG_ON(in_interrupt());
-	/* Take cpucontrol mutex to protect against CPU hotplug */
-	mutex_lock(&rcu_barrier_mutex);
-	init_completion(&rcu_barrier_completion);
-	/*
-	 * Initialize rcu_barrier_cpu_count to 1, then invoke
-	 * rcu_barrier_func() on each CPU, so that each CPU also has
-	 * incremented rcu_barrier_cpu_count.  Only then is it safe to
-	 * decrement rcu_barrier_cpu_count -- otherwise the first CPU
-	 * might complete its grace period before all of the other CPUs
-	 * did their increment, causing this function to return too
-	 * early.
-	 */
-	atomic_set(&rcu_barrier_cpu_count, 1);
-	on_each_cpu(rcu_barrier_func, (void *)call_rcu_func, 1);
-	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
-		complete(&rcu_barrier_completion);
-	wait_for_completion(&rcu_barrier_completion);
-	mutex_unlock(&rcu_barrier_mutex);
-	wait_migrated_callbacks();
-}
-
-/**
- * rcu_barrier - Wait until all in-flight call_rcu() callbacks complete.
- */
-void rcu_barrier(void)
-{
-	_rcu_barrier(call_rcu);
-}
-EXPORT_SYMBOL_GPL(rcu_barrier);
-
-/**
- * rcu_barrier_bh - Wait until all in-flight call_rcu_bh() callbacks complete.
- */
-void rcu_barrier_bh(void)
-{
-	_rcu_barrier(call_rcu_bh);
-}
-EXPORT_SYMBOL_GPL(rcu_barrier_bh);
-
-/**
- * rcu_barrier_sched - Wait for in-flight call_rcu_sched() callbacks.
- */
-void rcu_barrier_sched(void)
-{
-	_rcu_barrier(call_rcu_sched);
-}
-EXPORT_SYMBOL_GPL(rcu_barrier_sched);
-
-static void rcu_migrate_callback(struct rcu_head *notused)
-{
-	if (atomic_dec_and_test(&rcu_migrate_type_count))
-		wake_up(&rcu_migrate_wq);
-}
-
 static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
 		unsigned long action, void *hcpu)
 {
-	rcu_cpu_notify(self, action, hcpu);
-	if (action == CPU_DYING) {
-		/*
-		 * preempt_disable() in on_each_cpu() prevents stop_machine(),
-		 * so when "on_each_cpu(rcu_barrier_func, (void *)type, 1);"
-		 * returns, all online cpus have queued rcu_barrier_func(),
-		 * and the dead cpu(if it exist) queues rcu_migrate_callback()s.
-		 *
-		 * These callbacks ensure _rcu_barrier() waits for all
-		 * RCU callbacks of the specified type to complete.
-		 */
-		atomic_set(&rcu_migrate_type_count, 3);
-		call_rcu_bh(rcu_migrate_head, rcu_migrate_callback);
-		call_rcu_sched(rcu_migrate_head + 1, rcu_migrate_callback);
-		call_rcu(rcu_migrate_head + 2, rcu_migrate_callback);
-	} else if (action == CPU_DOWN_PREPARE) {
-		/* Don't need to wait until next removal operation. */
-		/* rcu_migrate_head is protected by cpu_add_remove_lock */
-		wait_migrated_callbacks();
-	}
-
-	return NOTIFY_OK;
+	return rcu_cpu_notify(self, action, hcpu);
 }
 
 void __init rcu_init(void)
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 070c65f..89124b0 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -239,6 +239,42 @@ void call_rcu_bh(struct rcu_head *head,
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
+void rcu_barrier(void)
+{
+	struct rcu_synchronize rcu;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier);
+
+void rcu_barrier_bh(void)
+{
+	struct rcu_synchronize rcu;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu_bh(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier_bh);
+
+void rcu_barrier_sched(void)
+{
+	struct rcu_synchronize rcu;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu_sched(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier_sched);
+
 void __rcu_init(void)
 {
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index bb313fd..678b2e2 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1358,6 +1358,103 @@ int rcu_needs_cpu(int cpu)
 	       rcu_preempt_needs_cpu(cpu);
 }
 
+static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
+static atomic_t rcu_barrier_cpu_count;
+static DEFINE_MUTEX(rcu_barrier_mutex);
+static struct completion rcu_barrier_completion;
+static atomic_t rcu_migrate_type_count = ATOMIC_INIT(0);
+static struct rcu_head rcu_migrate_head[3];
+static DECLARE_WAIT_QUEUE_HEAD(rcu_migrate_wq);
+
+static void rcu_barrier_callback(struct rcu_head *notused)
+{
+	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
+		complete(&rcu_barrier_completion);
+}
+
+/*
+ * Called with preemption disabled, and from cross-cpu IRQ context.
+ */
+static void rcu_barrier_func(void *type)
+{
+	int cpu = smp_processor_id();
+	struct rcu_head *head = &per_cpu(rcu_barrier_head, cpu);
+	void (*call_rcu_func)(struct rcu_head *head,
+			      void (*func)(struct rcu_head *head));
+
+	atomic_inc(&rcu_barrier_cpu_count);
+	call_rcu_func = type;
+	call_rcu_func(head, rcu_barrier_callback);
+}
+
+static inline void wait_migrated_callbacks(void)
+{
+	wait_event(rcu_migrate_wq, !atomic_read(&rcu_migrate_type_count));
+	smp_mb(); /* In case we didn't sleep. */
+}
+
+/*
+ * Orchestrate the specified type of RCU barrier, waiting for all
+ * RCU callbacks of the specified type to complete.
+ */
+static void _rcu_barrier(void (*call_rcu_func)(struct rcu_head *head,
+					       void (*func)(struct rcu_head *head)))
+{
+	BUG_ON(in_interrupt());
+	/* Take cpucontrol mutex to protect against CPU hotplug */
+	mutex_lock(&rcu_barrier_mutex);
+	init_completion(&rcu_barrier_completion);
+	/*
+	 * Initialize rcu_barrier_cpu_count to 1, then invoke
+	 * rcu_barrier_func() on each CPU, so that each CPU also has
+	 * incremented rcu_barrier_cpu_count.  Only then is it safe to
+	 * decrement rcu_barrier_cpu_count -- otherwise the first CPU
+	 * might complete its grace period before all of the other CPUs
+	 * did their increment, causing this function to return too
+	 * early.
+	 */
+	atomic_set(&rcu_barrier_cpu_count, 1);
+	on_each_cpu(rcu_barrier_func, (void *)call_rcu_func, 1);
+	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
+		complete(&rcu_barrier_completion);
+	wait_for_completion(&rcu_barrier_completion);
+	mutex_unlock(&rcu_barrier_mutex);
+	wait_migrated_callbacks();
+}
+
+/**
+ * rcu_barrier - Wait until all in-flight call_rcu() callbacks complete.
+ */
+void rcu_barrier(void)
+{
+	_rcu_barrier(call_rcu);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier);
+
+/**
+ * rcu_barrier_bh - Wait until all in-flight call_rcu_bh() callbacks complete.
+ */
+void rcu_barrier_bh(void)
+{
+	_rcu_barrier(call_rcu_bh);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier_bh);
+
+/**
+ * rcu_barrier_sched - Wait for in-flight call_rcu_sched() callbacks.
+ */
+void rcu_barrier_sched(void)
+{
+	_rcu_barrier(call_rcu_sched);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier_sched);
+
+static void rcu_migrate_callback(struct rcu_head *notused)
+{
+	if (atomic_dec_and_test(&rcu_migrate_type_count))
+		wake_up(&rcu_migrate_wq);
+}
+
 /*
  * Do boot-time initialization of a CPU's per-CPU RCU data.
  */
@@ -1454,6 +1551,28 @@ int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	case CPU_UP_PREPARE_FROZEN:
 		rcu_online_cpu(cpu);
 		break;
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		/* Don't need to wait until next removal operation. */
+		/* rcu_migrate_head is protected by cpu_add_remove_lock */
+		wait_migrated_callbacks();
+		break;
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
+		/*
+		 * preempt_disable() in on_each_cpu() prevents stop_machine(),
+		 * so when "on_each_cpu(rcu_barrier_func, (void *)type, 1);"
+		 * returns, all online cpus have queued rcu_barrier_func(),
+		 * and the dead cpu(if it exist) queues rcu_migrate_callback()s.
+		 *
+		 * These callbacks ensure _rcu_barrier() waits for all
+		 * RCU callbacks of the specified type to complete.
+		 */
+		atomic_set(&rcu_migrate_type_count, 3);
+		call_rcu_bh(rcu_migrate_head, rcu_migrate_callback);
+		call_rcu_sched(rcu_migrate_head + 1, rcu_migrate_callback);
+		call_rcu(rcu_migrate_head + 2, rcu_migrate_callback);
+		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 	case CPU_UP_CANCELED:
-- 
1.5.2.5

