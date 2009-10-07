Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbZJGGSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbZJGGSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 02:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756635AbZJGGSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 02:18:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:60154 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756609AbZJGGS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 02:18:28 -0400
Date: Wed, 7 Oct 2009 06:16:50 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12548908982563-git-send-email->
References: <12548908982563-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Move rcu_barrier() to rcutree
Message-ID: <tip-d0ec774cb2599c858be9d923bb873cf6697520d8@git.kernel.org>
Git-Commit-ID: d0ec774cb2599c858be9d923bb873cf6697520d8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 07 Oct 2009 06:17:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0ec774cb2599c858be9d923bb873cf6697520d8
Gitweb:     http://git.kernel.org/tip/d0ec774cb2599c858be9d923bb873cf6697520d8
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Tue, 6 Oct 2009 21:48:16 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 7 Oct 2009 08:11:20 +0200

rcu: Move rcu_barrier() to rcutree

Move the existing rcu_barrier() implementation to rcutree.c,
consistent with the fact that the rcu_barrier() implementation is
tied quite tightly to the RCU implementation.

This opens the way to simplify and fix rcutree.c's rcu_barrier()
implementation in a later patch.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12548908982563-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcupdate.c |  120 +----------------------------------------------------
 kernel/rcutree.c  |  119 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 120 insertions(+), 119 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index e432422..4001833 100644
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
@@ -165,120 +157,10 @@ void synchronize_rcu_bh(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
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
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e2e272b..0108570 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1363,6 +1363,103 @@ int rcu_needs_cpu(int cpu)
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
@@ -1459,6 +1556,28 @@ int __cpuinit rcu_cpu_notify(struct notifier_block *self,
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
