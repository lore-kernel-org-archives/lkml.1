Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbZIQWK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbZIQWK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 18:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZIQWKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 18:10:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:34260 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbZIQWKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 18:10:54 -0400
Date: Thu, 17 Sep 2009 22:10:15 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <12524504773190-git-send-email->
References: <12524504773190-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Initialize multi-level RCU grace periods holding locks
Message-ID: <tip-b835db1f9cadaf008750a32664e35a207782c95e@git.kernel.org>
Git-Commit-ID: b835db1f9cadaf008750a32664e35a207782c95e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 22:10:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b835db1f9cadaf008750a32664e35a207782c95e
Gitweb:     http://git.kernel.org/tip/b835db1f9cadaf008750a32664e35a207782c95e
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Tue, 8 Sep 2009 15:54:37 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Sep 2009 00:05:14 +0200

rcu: Initialize multi-level RCU grace periods holding locks

Prior implementations initialized the root and any internal
nodes without holding locks, then initialized the leaves
holding locks.

This is a false economy, as the leaf nodes will usually greatly
outnumber the root and internal nodes.  Acquiring locks on all
nodes is conceptually much simpler as well.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josht@linux.vnet.ibm.com
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
LKML-Reference: <12524504773190-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcutree.c |   41 ++++++++++++-----------------------------
 1 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index c634a92..da301e2 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -645,41 +645,24 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
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
