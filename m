Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbZIWTNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbZIWTNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 15:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbZIWTNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 15:13:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:53530 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbZIWTNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 15:13:46 -0400
Date: Wed, 23 Sep 2009 19:13:11 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <12537246442687-git-send-email->
References: <12537246442687-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Clean up code based on review feedback from Josh Triplett
Message-ID: <tip-fc2219d49ef1606e7fd2c88af2b423b01ff3d319@git.kernel.org>
Git-Commit-ID: fc2219d49ef1606e7fd2c88af2b423b01ff3d319
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 23 Sep 2009 19:13:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc2219d49ef1606e7fd2c88af2b423b01ff3d319
Gitweb:     http://git.kernel.org/tip/fc2219d49ef1606e7fd2c88af2b423b01ff3d319
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 23 Sep 2009 09:50:41 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Sep 2009 19:46:29 +0200

rcu: Clean up code based on review feedback from Josh Triplett

These issues identified during an old-fashioned face-to-face code
review extended over many hours.

o	Bury various forms of the "rsp->completed == rsp->gpnum"
	comparison into an rcu_gp_in_progress() function, which has
	the beneficial side-effect of forcing consistent use of
	ACCESS_ONCE().

o	Replace hand-coded arithmetic with DIV_ROUND_UP().

o	Bury several "!list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x01])"
	instances into an rcu_preempted_readers() function, as this
	expression indicates that there are no readers blocked
	within RCU read-side critical sections blocking the current
	grace period.  (Though there might well be similar readers
	blocking the next grace period.)

o	Remove a dangling rcu_restart_cpu() declaration that has
	been dangling for almost 20 minor releases of the kernel.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12537246442687-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
index 52b06f6..f85b684 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -101,6 +101,16 @@ static void __cpuinit rcu_init_percpu_data(int cpu, struct rcu_state *rsp,
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
@@ -173,9 +183,7 @@ cpu_has_callbacks_ready_to_invoke(struct rcu_data *rdp)
 static int
 cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	/* ACCESS_ONCE() because we are accessing outside of lock. */
-	return *rdp->nxttail[RCU_DONE_TAIL] &&
-	       ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum);
+	return *rdp->nxttail[RCU_DONE_TAIL] && !rcu_gp_in_progress(rsp);
 }
 
 /*
@@ -482,7 +490,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 
 	spin_lock_irqsave(&rnp->lock, flags);
 	delta = jiffies - rsp->jiffies_stall;
-	if (delta < RCU_STALL_RAT_DELAY || rsp->gpnum == rsp->completed) {
+	if (delta < RCU_STALL_RAT_DELAY || !rcu_gp_in_progress(rsp)) {
 		spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
@@ -537,8 +545,7 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 		/* We haven't checked in, so go dump stack. */
 		print_cpu_stall(rsp);
 
-	} else if (rsp->gpnum != rsp->completed &&
-		   delta >= RCU_STALL_RAT_DELAY) {
+	} else if (rcu_gp_in_progress(rsp) && delta >= RCU_STALL_RAT_DELAY) {
 
 		/* They had two time units to dump stack, so complain. */
 		print_other_cpu_stall(rsp);
@@ -703,9 +710,9 @@ rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
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
@@ -1092,7 +1099,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	struct rcu_node *rnp = rcu_get_root(rsp);
 	u8 signaled;
 
-	if (ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum))
+	if (!rcu_gp_in_progress(rsp))
 		return;  /* No grace period in progress, nothing to force. */
 	if (!spin_trylock_irqsave(&rsp->fqslock, flags)) {
 		rsp->n_force_qs_lh++; /* Inexact, can lose counts.  Tough! */
@@ -1251,7 +1258,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
 
 	/* Start a new grace period if one not already started. */
-	if (ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum)) {
+	if (!rcu_gp_in_progress(rsp)) {
 		unsigned long nestflag;
 		struct rcu_node *rnp_root = rcu_get_root(rsp);
 
@@ -1331,7 +1338,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
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
index 1cee04f..8ff1ba7 100644
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
@@ -461,6 +461,15 @@ static void rcu_preempt_note_context_switch(int cpu)
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
@@ -483,15 +492,6 @@ static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
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
