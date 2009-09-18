Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbZIRQuk (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 18 Sep 2009 12:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbZIRQuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:50:25 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36682 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387AbZIRQuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:50:19 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] Fix thinko in commit #de078d875, actually initialize full tree
Date: Fri, 18 Sep 2009 09:50:19 -0700
Message-Id: <125329262011-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090918164955.GA22272@linux.vnet.ibm.com>
References: <20090918164955.GA22272@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Commit #de078d875 repeatedly and incorrectly initializes the root rcu_node
structure's ->gpnum field rather than initializing the ->gpnum field of
each node in the tree.  Fix this.  Also add an additional consistency
check to catch this in the future.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |   11 ++++-------
 kernel/rcutree_plugin.h |    4 +++-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 30e0e91..dd6e743 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -596,8 +596,6 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 {
 	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
 	struct rcu_node *rnp = rcu_get_root(rsp);
-	struct rcu_node *rnp_cur;
-	struct rcu_node *rnp_end;
 
 	if (!cpu_needs_another_gp(rsp, rdp)) {
 		spin_unlock_irqrestore(&rnp->lock, flags);
@@ -654,13 +652,12 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	 * one corresponding to this CPU, due to the fact that we have
 	 * irqs disabled.
 	 */
-	rnp_end = &rsp->node[NUM_RCU_NODES];
-	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++) {
-		spin_lock(&rnp_cur->lock);	/* irqs already disabled. */
+	for (rnp = &rsp->node[0]; rnp < &rsp->node[NUM_RCU_NODES]; rnp++) {
+		spin_lock(&rnp->lock);	/* irqs already disabled. */
 		rcu_preempt_check_blocked_tasks(rnp);
-		rnp_cur->qsmask = rnp_cur->qsmaskinit;
+		rnp->qsmask = rnp->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
-		spin_unlock(&rnp_cur->lock);	/* irqs already disabled. */
+		spin_unlock(&rnp->lock);	/* irqs already disabled. */
 	}
 
 	rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state now OK. */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index a2d586c..55c6497 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -476,10 +476,12 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
 
 /*
  * Because there is no preemptable RCU, there can be no readers blocked,
- * so there is no need to check for blocked tasks.
+ * so there is no need to check for blocked tasks.  So check only for
+ * bogus qsmask values.
  */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 {
+	WARN_ON_ONCE(rnp->qsmask);
 }
 
 /*
-- 
1.5.2.5

