Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762560AbZLOXDX (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 15 Dec 2009 18:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762466AbZLOXDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:03:14 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33539 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934170AbZLOXCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:02:46 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 03/18] rcu: prohibit starting new grace periods while forcing quiescent states
Date: Tue, 15 Dec 2009 15:02:26 -0800
Message-Id: <12609181611516-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091215230213.GA9093@linux.vnet.ibm.com>
References: <20091215230213.GA9093@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Proposed for 2.6.34, not for inclusion.

Reduce the number and variety of race conditions by prohibiting the
start of a new grace period while force_quiescent_state() is active.
A new fqs_active flag in the rcu_state structure is used to trace
whether or not force_quiescent_state() is active, and this new flag
is tested by rcu_start_gp().  If the CPU that closed out the last
grace period needs another grace period, this new grace period may
be delayed up to one scheduling-clock tick, but it will eventually
get started.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   31 +++++++++++++++++--------------
 kernel/rcutree.h |    2 ++
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d42ad30..41688ff 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -659,7 +659,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
-	if (!cpu_needs_another_gp(rsp, rdp)) {
+	if (!cpu_needs_another_gp(rsp, rdp) || rsp->fqs_active) {
 		if (rnp->completed == rsp->completed) {
 			spin_unlock_irqrestore(&rnp->lock, flags);
 			return;
@@ -1195,6 +1195,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	struct rcu_node *rnp = rcu_get_root(rsp);
 	u8 signaled;
 	u8 forcenow;
+	u8 gpdone;
 
 	if (!rcu_gp_in_progress(rsp))
 		return;  /* No grace period in progress, nothing to force. */
@@ -1206,15 +1207,16 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	    (long)(rsp->jiffies_force_qs - jiffies) >= 0)
 		goto unlock_fqs_ret; /* no emergency and done recently. */
 	rsp->n_force_qs++;
-	spin_lock(&rnp->lock);
+	spin_lock(&rnp->lock);  /* irqs already disabled */
 	lastcomp = rsp->gpnum - 1;
 	signaled = rsp->signaled;
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	if(!rcu_gp_in_progress(rsp)) {
 		rsp->n_force_qs_ngp++;
-		spin_unlock(&rnp->lock);
+		spin_unlock(&rnp->lock);  /* irqs remain disabled */
 		goto unlock_fqs_ret;  /* no GP in progress, time updated. */
 	}
+	rsp->fqs_active = 1;
 	switch (signaled) {
 	case RCU_GP_IDLE:
 	case RCU_GP_INIT:
@@ -1223,15 +1225,16 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 
 	case RCU_SAVE_DYNTICK:
 
-		spin_unlock(&rnp->lock);
+		spin_unlock(&rnp->lock);  /* irqs remain disabled */
 		if (RCU_SIGNAL_INIT != RCU_SAVE_DYNTICK)
 			break; /* So gcc recognizes the dead code. */
 
 		/* Record dyntick-idle state. */
-		if (rcu_process_dyntick(rsp, lastcomp,
-					dyntick_save_progress_counter))
-			goto unlock_fqs_ret;
-		spin_lock(&rnp->lock);
+		gpdone = rcu_process_dyntick(rsp, lastcomp,
+					     dyntick_save_progress_counter);
+		spin_lock(&rnp->lock);  /* irqs already disabled */
+		if (gpdone)
+			break;
 		/* fall into next case. */
 
 	case RCU_SAVE_COMPLETED:
@@ -1252,17 +1255,17 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	case RCU_FORCE_QS:
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
-		spin_unlock(&rnp->lock);
-		if (rcu_process_dyntick(rsp, rsp->completed_fqs,
-					rcu_implicit_dynticks_qs))
-			goto unlock_fqs_ret;
+		spin_unlock(&rnp->lock);  /* irqs remain disabled */
+		gpdone = rcu_process_dyntick(rsp, rsp->completed_fqs,
+					     rcu_implicit_dynticks_qs);
 
 		/* Leave state in case more forcing is required. */
 
-		spin_lock(&rnp->lock);
+		spin_lock(&rnp->lock);  /* irqs already disabled */
 		break;
 	}
-	spin_unlock(&rnp->lock);
+	rsp->fqs_active = 0;
+	spin_unlock(&rnp->lock);  /* irqs remain disabled */
 unlock_fqs_ret:
 	spin_unlock_irqrestore(&rsp->fqslock, flags);
 }
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index d2a0046..dc386a7 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -277,6 +277,8 @@ struct rcu_state {
 
 	u8	signaled ____cacheline_internodealigned_in_smp;
 						/* Force QS state. */
+	u8	fqs_active;			/* force_quiescent_state() */
+						/*  is running. */
 	long	gpnum;				/* Current gp number. */
 	long	completed;			/* # of last completed gp. */
 
-- 
1.5.2.5

