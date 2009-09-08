Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbZIHWyj (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 8 Sep 2009 18:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZIHWyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:54:37 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41968 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbZIHWyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:54:36 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
   akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
   josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
   tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
   "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] Initialize multi-level RCU grace periods holding locks
Date: Tue,  8 Sep 2009 15:54:37 -0700
Message-Id: <12524504773190-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090908225349.GA19524@linux.vnet.ibm.com>
References: <20090908225349.GA19524@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Prior implementations initialized the root and any internal nodes without
holding locks, then initialized the leaves holding locks.  This is a
false economy, as the leaf nodes will usually greatly outnumber the root
and internal nodes.  Acquiring locks on all nodes is conceptually much
simpler as well.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   41 ++++++++++++-----------------------------
 1 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 03866bd..bca0aba 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -640,41 +640,24 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	spin_lock(&rsp->onofflock);  /* irqs already disabled. */
 
 	/*
-	 * Set the quiescent-state-needed bits in all the non-leaf RCU
-	 * nodes for all currently online CPUs.  This operation relies
-	 * on the layout of the hierarchy within the rsp->node[] array.
-	 * Note that other CPUs will access only the leaves of the
-	 * hierarchy, which still indicate that no grace period is in
-	 * progress.  In addition, we have excluded CPU-hotplug operations.
-	 *
-	 * We therefore do not need to hold any locks.  Any required
-	 * memory barriers will be supplied by the locks guarding the
-	 * leaf rcu_nodes in the hierarchy.
-	 */
-
-	rnp_end = rsp->level[NUM_RCU_LVLS - 1];
-	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++) {
-		rnp_cur->qsmask = rnp_cur->qsmaskinit;
-		rnp->gpnum = rsp->gpnum;
-	}
-
-	/*
-	 * Now set up the leaf nodes.  Here we must be careful.  First,
-	 * we need to hold the lock in order to exclude other CPUs, which
-	 * might be contending for the leaf nodes' locks.  Second, as
-	 * soon as we initialize a given leaf node, its CPUs might run
-	 * up the rest of the hierarchy.  We must therefore acquire locks
-	 * for each node that we touch during this stage.  (But we still
-	 * are excluding CPU-hotplug operations.)
+	 * Set the quiescent-state-needed bits in all the rcu_node
+	 * structures for all currently online CPUs in breadth-first
+	 * order, starting from the root rcu_node structure.  This
+	 * operation relies on the layout of the hierarchy within the
+	 * rsp->node[] array.  Note that other CPUs will access only
+	 * the leaves of the hierarchy, which still indicate that no
+	 * grace period is in progress, at least until the corresponding
+	 * leaf node has been initialized.  In addition, we have excluded
+	 * CPU-hotplug operations.
 	 *
 	 * Note that the grace period cannot complete until we finish
 	 * the initialization process, as there will be at least one
 	 * qsmask bit set in the root node until that time, namely the
-	 * one corresponding to this CPU.
+	 * one corresponding to this CPU, due to the fact that we have
+	 * irqs disabled.
 	 */
 	rnp_end = &rsp->node[NUM_RCU_NODES];
-	rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
-	for (; rnp_cur < rnp_end; rnp_cur++) {
+	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++) {
 		spin_lock(&rnp_cur->lock);	/* irqs already disabled. */
 		rnp_cur->qsmask = rnp_cur->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
-- 
1.5.2.5

