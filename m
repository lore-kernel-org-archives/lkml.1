Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbZJETLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbZJETLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 15:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbZJETLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 15:11:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:42779 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbZJETLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 15:11:11 -0400
Date: Mon, 5 Oct 2009 19:10:10 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12541491934126-git-send-email->
References: <12541491934126-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Clean up code based on review feedback from Josh Triplett, part 4
Message-ID: <tip-a0b6c9a78c41dc36732d6e1e90f0f2f57b29816f@git.kernel.org>
Git-Commit-ID: a0b6c9a78c41dc36732d6e1e90f0f2f57b29816f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 05 Oct 2009 19:10:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a0b6c9a78c41dc36732d6e1e90f0f2f57b29816f
Gitweb:     http://git.kernel.org/tip/a0b6c9a78c41dc36732d6e1e90f0f2f57b29816f
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 28 Sep 2009 07:46:33 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Oct 2009 21:02:04 +0200

rcu: Clean up code based on review feedback from Josh Triplett, part 4

These issues identified during an old-fashioned face-to-face code
review extending over many hours.  This group improves an existing
abstraction and introduces two new ones.  It also fixes an RCU
stall-warning bug found while making the other changes.

o	Make RCU_INIT_FLAVOR() declare its own variables, removing
	the need to declare them at each call site.

o	Create an rcu_for_each_leaf() macro that scans the leaf
	nodes of the rcu_node tree.

o	Create an rcu_for_each_node_breadth_first() macro that does
	a breadth-first traversal of the rcu_node tree, AKA
	stepping through the array in index-number order.

o	If all CPUs corresponding to a given leaf rcu_node
	structure go offline, then any tasks queued on that leaf
	will be moved to the root rcu_node structure.  Therefore,
	the stall-warning code must dump out tasks queued on the
	root rcu_node structure as well as those queued on the leaf
	rcu_node structures.

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
LKML-Reference: <12541491934126-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcutree.c        |   53 ++++++++++++++++++++++++----------------------
 kernel/rcutree.h        |   12 ++++++++++
 kernel/rcutree_plugin.h |    4 ---
 3 files changed, 40 insertions(+), 29 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d559783..e2e272b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -462,8 +462,6 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	long delta;
 	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root(rsp);
-	struct rcu_node *rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
-	struct rcu_node *rnp_end = &rsp->node[NUM_RCU_NODES];
 
 	/* Only let one CPU complain about others per time interval. */
 
@@ -474,18 +472,24 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 		return;
 	}
 	rsp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
+
+	/*
+	 * Now rat on any tasks that got kicked up to the root rcu_node
+	 * due to CPU offlining.
+	 */
+	rcu_print_task_stall(rnp);
 	spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/* OK, time to rat on our buddy... */
 
 	printk(KERN_ERR "INFO: RCU detected CPU stalls:");
-	for (; rnp_cur < rnp_end; rnp_cur++) {
+	rcu_for_each_leaf_node(rsp, rnp) {
 		rcu_print_task_stall(rnp);
-		if (rnp_cur->qsmask == 0)
+		if (rnp->qsmask == 0)
 			continue;
-		for (cpu = 0; cpu <= rnp_cur->grphi - rnp_cur->grplo; cpu++)
-			if (rnp_cur->qsmask & (1UL << cpu))
-				printk(" %d", rnp_cur->grplo + cpu);
+		for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
+			if (rnp->qsmask & (1UL << cpu))
+				printk(" %d", rnp->grplo + cpu);
 	}
 	printk(" (detected by %d, t=%ld jiffies)\n",
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
@@ -649,7 +653,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	 * one corresponding to this CPU, due to the fact that we have
 	 * irqs disabled.
 	 */
-	for (rnp = &rsp->node[0]; rnp < &rsp->node[NUM_RCU_NODES]; rnp++) {
+	rcu_for_each_node_breadth_first(rsp, rnp) {
 		spin_lock(&rnp->lock);	/* irqs already disabled. */
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
@@ -1042,33 +1046,32 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 	int cpu;
 	unsigned long flags;
 	unsigned long mask;
-	struct rcu_node *rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
-	struct rcu_node *rnp_end = &rsp->node[NUM_RCU_NODES];
+	struct rcu_node *rnp;
 
-	for (; rnp_cur < rnp_end; rnp_cur++) {
+	rcu_for_each_leaf_node(rsp, rnp) {
 		mask = 0;
-		spin_lock_irqsave(&rnp_cur->lock, flags);
+		spin_lock_irqsave(&rnp->lock, flags);
 		if (rsp->completed != lastcomp) {
-			spin_unlock_irqrestore(&rnp_cur->lock, flags);
+			spin_unlock_irqrestore(&rnp->lock, flags);
 			return 1;
 		}
-		if (rnp_cur->qsmask == 0) {
-			spin_unlock_irqrestore(&rnp_cur->lock, flags);
+		if (rnp->qsmask == 0) {
+			spin_unlock_irqrestore(&rnp->lock, flags);
 			continue;
 		}
-		cpu = rnp_cur->grplo;
+		cpu = rnp->grplo;
 		bit = 1;
-		for (; cpu <= rnp_cur->grphi; cpu++, bit <<= 1) {
-			if ((rnp_cur->qsmask & bit) != 0 && f(rsp->rda[cpu]))
+		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
+			if ((rnp->qsmask & bit) != 0 && f(rsp->rda[cpu]))
 				mask |= bit;
 		}
 		if (mask != 0 && rsp->completed == lastcomp) {
 
-			/* cpu_quiet_msk() releases rnp_cur->lock. */
-			cpu_quiet_msk(mask, rsp, rnp_cur, flags);
+			/* cpu_quiet_msk() releases rnp->lock. */
+			cpu_quiet_msk(mask, rsp, rnp, flags);
 			continue;
 		}
-		spin_unlock_irqrestore(&rnp_cur->lock, flags);
+		spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 	return 0;
 }
@@ -1550,6 +1553,10 @@ static void __init rcu_init_one(struct rcu_state *rsp)
  */
 #define RCU_INIT_FLAVOR(rsp, rcu_data) \
 do { \
+	int i; \
+	int j; \
+	struct rcu_node *rnp; \
+	\
 	rcu_init_one(rsp); \
 	rnp = (rsp)->level[NUM_RCU_LVLS - 1]; \
 	j = 0; \
@@ -1564,10 +1571,6 @@ do { \
 
 void __init __rcu_init(void)
 {
-	int i;			/* All used by RCU_INIT_FLAVOR(). */
-	int j;
-	struct rcu_node *rnp;
-
 	rcu_bootup_announce();
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index e6ab31c..676eecd 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -106,6 +106,18 @@ struct rcu_node {
 				/*  blocked_tasks[] array. */
 } ____cacheline_internodealigned_in_smp;
 
+/*
+ * Do a full breadth-first scan of the rcu_node structures for the
+ * specified rcu_state structure.
+ */
+#define rcu_for_each_node_breadth_first(rsp, rnp) \
+	for ((rnp) = &(rsp)->node[0]; \
+	     (rnp) < &(rsp)->node[NUM_RCU_NODES]; (rnp)++)
+
+#define rcu_for_each_leaf_node(rsp, rnp) \
+	for ((rnp) = (rsp)->level[NUM_RCU_LVLS - 1]; \
+	     (rnp) < &(rsp)->node[NUM_RCU_NODES]; (rnp)++)
+
 /* Index values for nxttail array in struct rcu_data. */
 #define RCU_DONE_TAIL		0	/* Also RCU_WAIT head. */
 #define RCU_WAIT_TAIL		1	/* Also RCU_NEXT_READY head. */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 6525021..57200fe 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -423,10 +423,6 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
  */
 static void __init __rcu_init_preempt(void)
 {
-	int i;			/* All used by RCU_INIT_FLAVOR(). */
-	int j;
-	struct rcu_node *rnp;
-
 	RCU_INIT_FLAVOR(&rcu_preempt_state, rcu_preempt_data);
 }
 
