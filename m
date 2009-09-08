Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbZIHWyh (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 8 Sep 2009 18:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZIHWyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:54:36 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37395 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbZIHWyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:54:36 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
   akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
   josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
   tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
   "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/3] Need to update rnp->gpnum if preemptable RCU is to be reliable.
Date: Tue,  8 Sep 2009 15:54:36 -0700
Message-Id: <12524504771622-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090908225349.GA19524@linux.vnet.ibm.com>
References: <20090908225349.GA19524@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Without this patch, tasks preempted in RCU read-side critical sections
can fail to block the grace period, given that rnp->gpnum is used to
determine which rnp->blocked_tasks[] element the preempted task is
enqueued on.  Before the patch, rnp->gpnum is always zero, so preempted
tasks are always enqueued on rnp->blocked_tasks[0], which is correct
only when the current CPU has not checked into the current grace period
and the grace-period number is even, or, similarly, if the current CPU
-has- checked into the current grace period and the grace-period number
is odd.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 71bc797..03866bd 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -627,6 +627,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {
 		rnp->qsmask = rnp->qsmaskinit;
+		rnp->gpnum = rsp->gpnum;
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
@@ -652,8 +653,10 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	 */
 
 	rnp_end = rsp->level[NUM_RCU_LVLS - 1];
-	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++)
+	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++) {
 		rnp_cur->qsmask = rnp_cur->qsmaskinit;
+		rnp->gpnum = rsp->gpnum;
+	}
 
 	/*
 	 * Now set up the leaf nodes.  Here we must be careful.  First,
@@ -674,6 +677,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	for (; rnp_cur < rnp_end; rnp_cur++) {
 		spin_lock(&rnp_cur->lock);	/* irqs already disabled. */
 		rnp_cur->qsmask = rnp_cur->qsmaskinit;
+		rnp->gpnum = rsp->gpnum;
 		spin_unlock(&rnp_cur->lock);	/* irqs already disabled. */
 	}
 
-- 
1.5.2.5

