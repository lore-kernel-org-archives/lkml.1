Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbZI0Gtz (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sun, 27 Sep 2009 02:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZI0Gty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 02:49:54 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41423 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZI0Gtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 02:49:53 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/2] rcu: Apply review feedback from Josh Triplett, part 4
Date: Sat, 26 Sep 2009 23:49:51 -0700
Message-Id: <1254034191918-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090927064753.GA9394@linux.vnet.ibm.com>
References: <20090927064753.GA9394@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

These issues identified during an old-fashioned face-to-face code
review extending over many hours.  This group improves an existing
abstraction and introduces two new ones.

o	Make RCU_INIT_FLAVOR() declare its own variables, removing
	the need to declare them at each call site.

o	Create an rcu_for_each_leaf() macro that scans the leaf nodes
	of the rcu_node tree.

o	Create an rcu_for_each_node_breadth_first() macro that does
	a breadth-first traversal of the rcu_node tree, AKA stepping
	through the array in index-number order.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   53 ++++++++++++++++++++++++----------------------
 kernel/rcutree.h        |   12 ++++++++++
 kernel/rcutree_plugin.h |    4 ---
 3 files changed, 40 insertions(+), 29 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 1ccdd5b..bb313fd 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -461,8 +461,6 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	long delta;
 	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root(rsp);
-	struct rcu_node *rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
-	struct rcu_node *rnp_end = &rsp->node[NUM_RCU_NODES];
 
 	/* Only let one CPU complain about others per time interval. */
 
@@ -473,18 +471,24 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
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
@@ -644,7 +648,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	 * one corresponding to this CPU, due to the fact that we have
 	 * irqs disabled.
 	 */
-	for (rnp = &rsp->node[0]; rnp < &rsp->node[NUM_RCU_NODES]; rnp++) {
+	rcu_for_each_node_breadth_first(rsp, rnp) {
 		spin_lock(&rnp->lock);	/* irqs already disabled. */
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
@@ -1037,33 +1041,32 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
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
@@ -1545,6 +1548,10 @@ static void __init rcu_init_one(struct rcu_state *rsp)
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
@@ -1559,10 +1566,6 @@ do { \
 
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
index 2c73162..d88dfd3 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -424,10 +424,6 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
  */
 static void __init __rcu_init_preempt(void)
 {
-	int i;			/* All used by RCU_INIT_FLAVOR(). */
-	int j;
-	struct rcu_node *rnp;
-
 	RCU_INIT_FLAVOR(&rcu_preempt_state, rcu_preempt_data);
 }
 
-- 
1.5.2.5

