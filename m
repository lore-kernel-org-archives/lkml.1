Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbZIVWZR (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 22 Sep 2009 18:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZIVWZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 18:25:16 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51692 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbZIVWZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 18:25:14 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/4] Apply review feedback from Josh Triplett, part 1
Date: Tue, 22 Sep 2009 15:25:13 -0700
Message-Id: <12536583163749-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090922222443.GA3178@linux.vnet.ibm.com>
References: <20090922222443.GA3178@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcutree.h |    1 -
 kernel/rcutree.c        |   29 ++++++++++++++++----------
 kernel/rcutree.h        |    6 ++--
 kernel/rcutree_plugin.h |   50 +++++++++++++++++++++++-----------------------
 4 files changed, 46 insertions(+), 40 deletions(-)

diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 3768277..88109c8 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -85,7 +85,6 @@ static inline void synchronize_rcu_bh_expedited(void)
 
 extern void __rcu_init(void);
 extern void rcu_check_callbacks(int cpu, int user);
-extern void rcu_restart_cpu(int cpu);
 
 extern long rcu_batches_completed(void);
 extern long rcu_batches_completed_bh(void);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 24f627e..d45ffb8 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -100,6 +100,16 @@ static void __cpuinit rcu_init_percpu_data(int cpu, struct rcu_state *rsp,
 #include "rcutree_plugin.h"
 
 /*
+ * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
+ * permit this function to be invoked without holding the root rcu_node
+ * structure's ->lock, but of course results can be subject to change.
+ */
+static int rcu_gp_in_progress(struct rcu_state *rsp)
+{
+	return ACCESS_ONCE(rsp->completed) != ACCESS_ONCE(rsp->gpnum);
+}
+
+/*
  * Note a quiescent state.  Because we do not need to know
  * how many quiescent states passed, just if there was at least
  * one since the start of the grace period, this just sets a flag.
@@ -172,9 +182,7 @@ cpu_has_callbacks_ready_to_invoke(struct rcu_data *rdp)
 static int
 cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	/* ACCESS_ONCE() because we are accessing outside of lock. */
-	return *rdp->nxttail[RCU_DONE_TAIL] &&
-	       ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum);
+	return *rdp->nxttail[RCU_DONE_TAIL] && !rcu_gp_in_progress(rsp);
 }
 
 /*
@@ -481,7 +489,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 
 	spin_lock_irqsave(&rnp->lock, flags);
 	delta = jiffies - rsp->jiffies_stall;
-	if (delta < RCU_STALL_RAT_DELAY || rsp->gpnum == rsp->completed) {
+	if (delta < RCU_STALL_RAT_DELAY || !rcu_gp_in_progress(rsp)) {
 		spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
@@ -532,8 +540,7 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 		/* We haven't checked in, so go dump stack. */
 		print_cpu_stall(rsp);
 
-	} else if (rsp->gpnum != rsp->completed &&
-		   delta >= RCU_STALL_RAT_DELAY) {
+	} else if (rcu_gp_in_progress(rsp) && delta >= RCU_STALL_RAT_DELAY) {
 
 		/* They had two time units to dump stack, so complain. */
 		print_other_cpu_stall(rsp);
@@ -698,9 +705,9 @@ rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
  * hold rnp->lock, as required by rcu_start_gp(), which will release it.
  */
 static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags)
-	__releases(rnp->lock)
+	__releases(rcu_get_root(rsp)->lock)
 {
-	WARN_ON_ONCE(rsp->completed == rsp->gpnum);
+	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 	rsp->completed = rsp->gpnum;
 	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
@@ -1087,7 +1094,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	struct rcu_node *rnp = rcu_get_root(rsp);
 	u8 signaled;
 
-	if (ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum))
+	if (!rcu_gp_in_progress(rsp))
 		return;  /* No grace period in progress, nothing to force. */
 	if (!spin_trylock_irqsave(&rsp->fqslock, flags)) {
 		rsp->n_force_qs_lh++; /* Inexact, can lose counts.  Tough! */
@@ -1246,7 +1253,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
 
 	/* Start a new grace period if one not already started. */
-	if (ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum)) {
+	if (!rcu_gp_in_progress(rsp)) {
 		unsigned long nestflag;
 		struct rcu_node *rnp_root = rcu_get_root(rsp);
 
@@ -1326,7 +1333,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 
 	/* Has an RCU GP gone long enough to send resched IPIs &c? */
-	if (ACCESS_ONCE(rsp->completed) != ACCESS_ONCE(rsp->gpnum) &&
+	if (rcu_gp_in_progress(rsp) &&
 	    ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)) {
 		rdp->n_rp_need_fqs++;
 		return 1;
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 8e8287a..9aa8c8a 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -48,14 +48,14 @@
 #elif NR_CPUS <= RCU_FANOUT_SQ
 #  define NUM_RCU_LVLS	      2
 #  define NUM_RCU_LVL_0	      1
-#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT - 1) / RCU_FANOUT)
+#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT)
 #  define NUM_RCU_LVL_2	      (NR_CPUS)
 #  define NUM_RCU_LVL_3	      0
 #elif NR_CPUS <= RCU_FANOUT_CUBE
 #  define NUM_RCU_LVLS	      3
 #  define NUM_RCU_LVL_0	      1
-#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT_SQ - 1) / RCU_FANOUT_SQ)
-#  define NUM_RCU_LVL_2	      (((NR_CPUS) + (RCU_FANOUT) - 1) / (RCU_FANOUT))
+#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_SQ)
+#  define NUM_RCU_LVL_2	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT)
 #  define NUM_RCU_LVL_3	      NR_CPUS
 #else
 # error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 09b7325..01485e8 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -150,6 +150,16 @@ void __rcu_read_lock(void)
 }
 EXPORT_SYMBOL_GPL(__rcu_read_lock);
 
+/*
+ * Check for preempted RCU readers blocking the current grace period
+ * for the specified rcu_node structure.  If the caller needs a reliable
+ * answer, it must hold the rcu_node's ->lock.
+ */
+static int rcu_preempted_readers(struct rcu_node *rnp)
+{
+	return !list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
+}
+
 static void rcu_read_unlock_special(struct task_struct *t)
 {
 	int empty;
@@ -196,7 +206,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 				break;
 			spin_unlock(&rnp->lock);  /* irqs remain disabled. */
 		}
-		empty = list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
+		empty = !rcu_preempted_readers(rnp);
 		list_del_init(&t->rcu_node_entry);
 		t->rcu_blocked_node = NULL;
 
@@ -207,7 +217,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		 * drop rnp->lock and restore irq.
 		 */
 		if (!empty && rnp->qsmask == 0 &&
-		    list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1])) {
+		    !rcu_preempted_readers(rnp)) {
 			struct rcu_node *rnp_p;
 
 			if (rnp->parent == NULL) {
@@ -257,12 +267,12 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
 {
 	unsigned long flags;
 	struct list_head *lp;
-	int phase = rnp->gpnum & 0x1;
+	int phase;
 	struct task_struct *t;
 
-	if (!list_empty(&rnp->blocked_tasks[phase])) {
+	if (rcu_preempted_readers(rnp)) {
 		spin_lock_irqsave(&rnp->lock, flags);
-		phase = rnp->gpnum & 0x1; /* re-read under lock. */
+		phase = rnp->gpnum & 0x1;
 		lp = &rnp->blocked_tasks[phase];
 		list_for_each_entry(t, lp, rcu_node_entry)
 			printk(" P%d", t->pid);
@@ -281,20 +291,10 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
  */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 {
-	WARN_ON_ONCE(!list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]));
+	WARN_ON_ONCE(rcu_preempted_readers(rnp));
 	WARN_ON_ONCE(rnp->qsmask);
 }
 
-/*
- * Check for preempted RCU readers for the specified rcu_node structure.
- * If the caller needs a reliable answer, it must hold the rcu_node's
- * >lock.
- */
-static int rcu_preempted_readers(struct rcu_node *rnp)
-{
-	return !list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 
 /*
@@ -462,6 +462,15 @@ static void rcu_preempt_note_context_switch(int cpu)
 {
 }
 
+/*
+ * Because preemptable RCU does not exist, there are never any preempted
+ * RCU readers.
+ */
+static int rcu_preempted_readers(struct rcu_node *rnp)
+{
+	return 0;
+}
+
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
 /*
@@ -484,15 +493,6 @@ static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 	WARN_ON_ONCE(rnp->qsmask);
 }
 
-/*
- * Because preemptable RCU does not exist, there are never any preempted
- * RCU readers.
- */
-static int rcu_preempted_readers(struct rcu_node *rnp)
-{
-	return 0;
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 
 /*
-- 
1.5.2.5

