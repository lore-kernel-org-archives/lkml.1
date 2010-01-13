Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445Ab0AMKZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab0AMKZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038Ab0AMKZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:25:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:38001 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab0AMKZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:25:49 -0500
Date: Wed, 13 Jan 2010 10:25:18 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <126264655052-git-send-email->
References: <126264655052-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Prohibit starting new grace periods while forcing quiescent states
Message-ID: <tip-07079d5357a4d53c2b13126c4a38fb40e6e04966@git.kernel.org>
Git-Commit-ID: 07079d5357a4d53c2b13126c4a38fb40e6e04966
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:25:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07079d5357a4d53c2b13126c4a38fb40e6e04966
Gitweb:     http://git.kernel.org/tip/07079d5357a4d53c2b13126c4a38fb40e6e04966
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 4 Jan 2010 15:09:02 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:06:02 +0100

rcu: Prohibit starting new grace periods while forcing quiescent states

Reduce the number and variety of race conditions by prohibiting
the start of a new grace period while force_quiescent_state() is
active. A new fqs_active flag in the rcu_state structure is used
to trace whether or not force_quiescent_state() is active, and
this new flag is tested by rcu_start_gp().  If the CPU that
closed out the last grace period needs another grace period,
this new grace period may be delayed up to one scheduling-clock
tick, but it will eventually get started.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <126264655052-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
