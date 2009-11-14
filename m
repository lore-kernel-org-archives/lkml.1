Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285AbZKNDvR (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 13 Nov 2009 22:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757338AbZKNDvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 22:51:15 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50634 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782AbZKNDvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 22:51:15 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/2] rcu: further cleanups of use of lastcomp
Date: Fri, 13 Nov 2009 19:51:38 -0800
Message-Id: <1258170699933-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091114035100.GA9599@linux.vnet.ibm.com>
References: <20091114035100.GA9599@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that a copy of the rsp->completed flag is available in all rcu_node
structures, make full use of it.  It is still legitimate to access
rsp->completed while holding the root rcu_node structure's lock, however.
Also, tighten up force_quiescent_state()'s checks for end of current
grace period.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f93f0e2..1089d08 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -817,7 +817,7 @@ cpu_quiet(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
 
 	rnp = rdp->mynode;
 	spin_lock_irqsave(&rnp->lock, flags);
-	if (lastcomp != ACCESS_ONCE(rsp->completed)) {
+	if (lastcomp != rnp->completed) {
 
 		/*
 		 * Someone beat us to it for this grace period, so leave.
@@ -935,7 +935,6 @@ static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
 static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
-	long lastcomp;
 	unsigned long mask;
 	struct rcu_data *rdp = rsp->rda[cpu];
 	struct rcu_node *rnp;
@@ -958,7 +957,6 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 		rnp = rnp->parent;
 	} while (rnp != NULL);
-	lastcomp = rsp->completed;
 
 	spin_unlock_irqrestore(&rsp->onofflock, flags);
 
@@ -1132,7 +1130,7 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 	rcu_for_each_leaf_node(rsp, rnp) {
 		mask = 0;
 		spin_lock_irqsave(&rnp->lock, flags);
-		if (rsp->completed != lastcomp) {
+		if (rnp->completed != lastcomp) {
 			spin_unlock_irqrestore(&rnp->lock, flags);
 			return 1;
 		}
@@ -1146,7 +1144,7 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 			if ((rnp->qsmask & bit) != 0 && f(rsp->rda[cpu]))
 				mask |= bit;
 		}
-		if (mask != 0 && rsp->completed == lastcomp) {
+		if (mask != 0 && rnp->completed == lastcomp) {
 
 			/* cpu_quiet_msk() releases rnp->lock. */
 			cpu_quiet_msk(mask, rsp, rnp, flags);
@@ -1183,7 +1181,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	lastcomp = rsp->gpnum - 1;
 	signaled = rsp->signaled;
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
-	if (lastcomp == rsp->gpnum) {
+	if(!rcu_gp_in_progress(rsp)) {
 		rsp->n_force_qs_ngp++;
 		spin_unlock(&rnp->lock);
 		goto unlock_ret;  /* no GP in progress, time updated. */
@@ -1211,7 +1209,8 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		/* Update state, record completion counter. */
 		forcenow = 0;
 		spin_lock(&rnp->lock);
-		if (lastcomp == rsp->completed &&
+		if (lastcomp + 1 == rsp->gpnum &&
+		    lastcomp == rsp->completed &&
 		    rsp->signaled == signaled) {
 			rsp->signaled = RCU_FORCE_QS;
 			rsp->completed_fqs = lastcomp;
-- 
1.5.2.5

