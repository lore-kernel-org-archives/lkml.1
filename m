Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab0BWBrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:47:53 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51987 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab0BWBrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:47:51 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, jkacur@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC 2/2] rcu: add RCU_CPU_STALL_VERBOSE to dump detailed per-task information
Date: Mon, 22 Feb 2010 17:47:46 -0800
Message-Id: <1266889666-3471-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100223014654.GA3404@linux.vnet.ibm.com>
References: <20100223014654.GA3404@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When RCU detects a grace-period stall, it currently just prints out the
PID of any tasks doing the stalling.  This patch adds RCU_CPU_STALL_VERBOSE,
which enables the more-verbose reporting from sched_show_task().

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |    4 +++
 kernel/rcutree.h        |    1 +
 kernel/rcutree_plugin.h |   52 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug       |   12 ++++++++++
 4 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6f652f1..ce642e2 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -471,6 +471,10 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
 	trigger_all_cpu_backtrace();
 
+	/* If so configured, complain about tasks blocking the grace period. */
+
+	rcu_print_detail_task_stall(rsp);
+
 	force_quiescent_state(rsp, 0);  /* Kick them all. */
 }
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index d2a0046..458c047 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -347,6 +347,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 				      unsigned long flags);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+static void rcu_print_detail_task_stall(struct rcu_state *rsp);
 static void rcu_print_task_stall(struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index e31cda7..7021fde 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -300,6 +300,50 @@ EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
+#ifdef CONFIG_RCU_CPU_STALL_VERBOSE
+
+/*
+ * Dump detailed information for all tasks blocking the current RCU
+ * grace period on the specified rcu_node structure.
+ */
+static void rcu_print_detail_task_stall_rnp(struct rcu_node *rnp)
+{
+	unsigned long flags;
+	struct list_head *lp;
+	int phase;
+	struct task_struct *t;
+
+	if (rcu_preempted_readers(rnp)) {
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		phase = rnp->gpnum & 0x1;
+		lp = &rnp->blocked_tasks[phase];
+		list_for_each_entry(t, lp, rcu_node_entry)
+			sched_show_task(t);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	}
+}
+
+/*
+ * Dump detailed information for all tasks blocking the current RCU
+ * grace period.
+ */
+static void rcu_print_detail_task_stall(struct rcu_state *rsp)
+{
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	rcu_print_detail_task_stall_rnp(rnp);
+	rcu_for_each_leaf_node(rsp, rnp)
+		rcu_print_detail_task_stall_rnp(rnp);
+}
+
+#else /* #ifdef CONFIG_RCU_CPU_STALL_VERBOSE */
+
+static void rcu_print_detail_task_stall(struct rcu_state *rsp)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_VERBOSE */
+
 /*
  * Scan the current list of tasks blocked within RCU read-side critical
  * sections, printing out the tid of each.
@@ -742,6 +786,14 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
  * Because preemptable RCU does not exist, we never have to check for
  * tasks blocked within RCU read-side critical sections.
  */
+static void rcu_print_detail_task_stall(struct rcu_state *rsp)
+{
+}
+
+/*
+ * Because preemptable RCU does not exist, we never have to check for
+ * tasks blocked within RCU read-side critical sections.
+ */
 static void rcu_print_task_stall(struct rcu_node *rnp)
 {
 }
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 25c3ed5..7500988 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -769,6 +769,18 @@ config RCU_CPU_STALL_DETECTOR
 
 	  Say N if you are unsure.
 
+config RCU_CPU_STALL_VERBOSE
+	bool "Print additional per-task information for RCU_CPU_STALL_DETECTOR"
+	depends on RCU_CPU_STALL_DETECTOR && TREE_PREEMPT_RCU
+	default n
+	help
+	  This option causes RCU to printk detailed per-task information
+	  for any tasks that are stalling the current RCU grace period.
+
+	  Say N if you are unsure.
+
+	  Say Y if you want to enable such checks.
+
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
-- 
1.6.6

