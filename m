Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbZIRQuY (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 18 Sep 2009 12:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbZIRQuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:50:24 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38250 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756386AbZIRQuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:50:19 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/3] Add WARN_ON_ONCE() consistency checks covering state transitions
Date: Fri, 18 Sep 2009 09:50:17 -0700
Message-Id: <12532926191947-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090918164955.GA22272@linux.vnet.ibm.com>
References: <20090918164955.GA22272@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o	Verify that qsmask bits stay clear through GP initialization.

o	Verify that cpu_quiet_msk_finish() is never invoked unless there
	actually is an RCU grace period in progress.

o	Verify that all internal-node rcu_node structures have empty
	blocked_tasks[] lists.

o	Verify that child rcu_node structure's bits remain clear after
	acquiring parent's lock.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   13 +++++++++----
 kernel/rcutree_plugin.h |   20 ++++++++++++++------
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 2454999..211442c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -623,8 +623,8 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {
-		rnp->qsmask = rnp->qsmaskinit;
 		rcu_preempt_check_blocked_tasks(rnp);
+		rnp->qsmask = rnp->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		spin_unlock_irqrestore(&rnp->lock, flags);
@@ -657,8 +657,8 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	rnp_end = &rsp->node[NUM_RCU_NODES];
 	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++) {
 		spin_lock(&rnp_cur->lock);	/* irqs already disabled. */
-		rnp_cur->qsmask = rnp_cur->qsmaskinit;
 		rcu_preempt_check_blocked_tasks(rnp);
+		rnp_cur->qsmask = rnp_cur->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
 		spin_unlock(&rnp_cur->lock);	/* irqs already disabled. */
 	}
@@ -703,6 +703,7 @@ rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
 static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags)
 	__releases(rnp->lock)
 {
+	WARN_ON_ONCE(rsp->completed == rsp->gpnum);
 	rsp->completed = rsp->gpnum;
 	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
@@ -720,6 +721,8 @@ cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
 	      unsigned long flags)
 	__releases(rnp->lock)
 {
+	struct rcu_node *rnp_c;
+
 	/* Walk up the rcu_node hierarchy. */
 	for (;;) {
 		if (!(rnp->qsmask & mask)) {
@@ -743,8 +746,10 @@ cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
 			break;
 		}
 		spin_unlock_irqrestore(&rnp->lock, flags);
+		rnp_c = rnp;
 		rnp = rnp->parent;
 		spin_lock_irqsave(&rnp->lock, flags);
+		WARN_ON_ONCE(rnp_c->qsmask);
 	}
 
 	/*
@@ -853,7 +858,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	spin_lock_irqsave(&rsp->onofflock, flags);
 
 	/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
-	rnp = rdp->mynode;
+	rnp = rdp->mynode;	/* this is the outgoing CPU's rnp. */
 	mask = rdp->grpmask;	/* rnp->grplo is constant. */
 	do {
 		spin_lock(&rnp->lock);		/* irqs already disabled. */
@@ -862,7 +867,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 			spin_unlock(&rnp->lock); /* irqs remain disabled. */
 			break;
 		}
-		rcu_preempt_offline_tasks(rsp, rnp);
+		rcu_preempt_offline_tasks(rsp, rnp, rdp);
 		mask = rnp->grpmask;
 		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 		rnp = rnp->parent;
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index eb4bae3..2b996c3 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -206,7 +206,8 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		 */
 		if (!empty && rnp->qsmask == 0 &&
 		    list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1])) {
-			t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
+			struct rcu_node *rnp_p;
+
 			if (rnp->parent == NULL) {
 				/* Only one rcu_node in the tree. */
 				cpu_quiet_msk_finish(&rcu_preempt_state, flags);
@@ -215,9 +216,10 @@ static void rcu_read_unlock_special(struct task_struct *t)
 			/* Report up the rest of the hierarchy. */
 			mask = rnp->grpmask;
 			spin_unlock_irqrestore(&rnp->lock, flags);
-			rnp = rnp->parent;
-			spin_lock_irqsave(&rnp->lock, flags);
-			cpu_quiet_msk(mask, &rcu_preempt_state, rnp, flags);
+			rnp_p = rnp->parent;
+			spin_lock_irqsave(&rnp_p->lock, flags);
+			WARN_ON_ONCE(rnp->qsmask);
+			cpu_quiet_msk(mask, &rcu_preempt_state, rnp_p, flags);
 			return;
 		}
 		spin_unlock(&rnp->lock);
@@ -278,6 +280,7 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 {
 	WARN_ON_ONCE(!list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]));
+	WARN_ON_ONCE(rnp->qsmask);
 }
 
 /*
@@ -302,7 +305,8 @@ static int rcu_preempted_readers(struct rcu_node *rnp)
  * The caller must hold rnp->lock with irqs disabled.
  */
 static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
-				      struct rcu_node *rnp)
+				      struct rcu_node *rnp,
+				      struct rcu_data *rdp)
 {
 	int i;
 	struct list_head *lp;
@@ -314,6 +318,9 @@ static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
 		WARN_ONCE(1, "Last CPU thought to be offlined?");
 		return;  /* Shouldn't happen: at least one CPU online. */
 	}
+	WARN_ON_ONCE(rnp != rdp->mynode &&
+		     (!list_empty(&rnp->blocked_tasks[0]) ||
+		      !list_empty(&rnp->blocked_tasks[1])));
 
 	/*
 	 * Move tasks up to root rcu_node.  Rely on the fact that the
@@ -489,7 +496,8 @@ static int rcu_preempted_readers(struct rcu_node *rnp)
  * tasks that were blocked within RCU read-side critical sections.
  */
 static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
-				      struct rcu_node *rnp)
+				      struct rcu_node *rnp,
+				      struct rcu_data *rdp)
 {
 }
 
-- 
1.5.2.5

