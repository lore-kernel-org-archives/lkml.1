Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZKMGe4 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 13 Nov 2009 01:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZKMGeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 01:34:44 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53219 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbZKMGen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 01:34:43 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/2] rcu: simplify association of forced quiescent states with grace periods
Date: Thu, 12 Nov 2009 22:35:04 -0800
Message-Id: <12580941042308-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091113063439.GA560@linux.vnet.ibm.com>
References: <20091113063439.GA560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

The force_quiescent_state() function also took a snapshot
of the ->completed field, which was as obnoxious as it was in
rcu_sched_qs() and friends.  So snapshot ->gpnum-1.  Also, since the
dyntick_record_completed() and dyntick_recall_completed() functions are
now simple assignments that are independent of CONFIG_NO_HZ, and since
their names are now misleading, get rid of them.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   27 +++------------------------
 1 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0490371..f93f0e2 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -178,29 +178,9 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
 	return &rsp->node[0];
 }
 
-/*
- * Record the specified "completed" value, which is later used to validate
- * dynticks counter manipulations and CPU-offline checks.  Specify
- * "rsp->completed - 1" to unconditionally invalidate any future dynticks
- * manipulations and CPU-offline checks.  Such invalidation is useful at
- * the beginning of a grace period.
- */
-static void dyntick_record_completed(struct rcu_state *rsp, long comp)
-{
-	rsp->completed_fqs = comp;
-}
-
 #ifdef CONFIG_SMP
 
 /*
- * Recall the previously recorded value of the completion for dynticks.
- */
-static long dyntick_recall_completed(struct rcu_state *rsp)
-{
-	return rsp->completed_fqs;
-}
-
-/*
  * If the specified CPU is offline, tell the caller that it is in
  * a quiescent state.  Otherwise, whack it with a reschedule IPI.
  * Grace periods can end up waiting on an offline CPU when that
@@ -702,7 +682,6 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	rsp->signaled = RCU_GP_INIT; /* Hold off force_quiescent_state. */
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	record_gp_stall_check_time(rsp);
-	dyntick_record_completed(rsp, rsp->completed - 1);
 
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {
@@ -1201,7 +1180,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		goto unlock_ret; /* no emergency and done recently. */
 	rsp->n_force_qs++;
 	spin_lock(&rnp->lock);
-	lastcomp = rsp->completed;
+	lastcomp = rsp->gpnum - 1;
 	signaled = rsp->signaled;
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	if (lastcomp == rsp->gpnum) {
@@ -1235,7 +1214,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		if (lastcomp == rsp->completed &&
 		    rsp->signaled == signaled) {
 			rsp->signaled = RCU_FORCE_QS;
-			dyntick_record_completed(rsp, lastcomp);
+			rsp->completed_fqs = lastcomp;
 			forcenow = signaled == RCU_SAVE_COMPLETED;
 		}
 		spin_unlock(&rnp->lock);
@@ -1246,7 +1225,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	case RCU_FORCE_QS:
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
-		if (rcu_process_dyntick(rsp, dyntick_recall_completed(rsp),
+		if (rcu_process_dyntick(rsp, rsp->completed_fqs,
 					rcu_implicit_dynticks_qs))
 			goto unlock_ret;
 
-- 
1.5.2.5

