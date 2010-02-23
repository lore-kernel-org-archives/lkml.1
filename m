Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0BWBHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:07:07 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59974 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab0BWBFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:05:18 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 21/21] rcu: add RCU_CPU_STALL_VERBOSE to dump detailed per-task information
Date: Mon, 22 Feb 2010 17:05:05 -0800
Message-Id: <1266887105-1528-21-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100223010435.GA666@linux.vnet.ibm.com>
References: <20100223010435.GA666@linux.vnet.ibm.com>
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
index b07be37..525d398 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -489,6 +489,10 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
 	trigger_all_cpu_backtrace();
 
+	/* If so configured, complain about tasks blocking the grace period. */
+
+	rcu_print_detail_task_stall(rsp);
+
 	force_quiescent_state(rsp, 0);  /* Kick them all. */
 }
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 6a82c34..2ceb083 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -352,6 +352,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 				      unsigned long flags);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+static void rcu_print_detail_task_stall(struct rcu_state *rsp);
 static void rcu_print_task_stall(struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index aecfe37..3516de7 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -312,6 +312,50 @@ EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 
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
@@ -764,6 +808,14 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
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
index 6af20a8..4cdab45 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -781,6 +781,18 @@ config RCU_CPU_STALL_DETECTOR
 
 	  Say Y if you are unsure.
 
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

