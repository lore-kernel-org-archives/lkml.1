Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980AbZLOXMh (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 15 Dec 2009 18:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934129AbZLOXMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:12:19 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53803 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934206AbZLOXCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:02:49 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 01/18] rcu: adjust force_quiescent_state() locking, step 1
Date: Tue, 15 Dec 2009 15:02:24 -0800
Message-Id: <1260918161990-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091215230213.GA9093@linux.vnet.ibm.com>
References: <20091215230213.GA9093@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not yet for inclusion, proposing for 2.6.34.

This causes rnp->lock to be held on entry to force_quiescent_state()'s
switch statement.  This is a first step towards prohibiting starting
grace periods while force_quiescent_state() is executing, which will
reduce the number and complexity of races that force_quiescent_state()
is involved in.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 53ae959..eae331d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1204,7 +1204,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	}
 	if (relaxed &&
 	    (long)(rsp->jiffies_force_qs - jiffies) >= 0)
-		goto unlock_ret; /* no emergency and done recently. */
+		goto unlock_fqs_ret; /* no emergency and done recently. */
 	rsp->n_force_qs++;
 	spin_lock(&rnp->lock);
 	lastcomp = rsp->gpnum - 1;
@@ -1213,31 +1213,32 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	if(!rcu_gp_in_progress(rsp)) {
 		rsp->n_force_qs_ngp++;
 		spin_unlock(&rnp->lock);
-		goto unlock_ret;  /* no GP in progress, time updated. */
+		goto unlock_fqs_ret;  /* no GP in progress, time updated. */
 	}
-	spin_unlock(&rnp->lock);
 	switch (signaled) {
 	case RCU_GP_IDLE:
 	case RCU_GP_INIT:
 
+		spin_unlock(&rnp->lock);
 		break; /* grace period idle or initializing, ignore. */
 
 	case RCU_SAVE_DYNTICK:
 
+		spin_unlock(&rnp->lock);
 		if (RCU_SIGNAL_INIT != RCU_SAVE_DYNTICK)
 			break; /* So gcc recognizes the dead code. */
 
 		/* Record dyntick-idle state. */
 		if (rcu_process_dyntick(rsp, lastcomp,
 					dyntick_save_progress_counter))
-			goto unlock_ret;
+			goto unlock_fqs_ret;
+		spin_lock(&rnp->lock);
 		/* fall into next case. */
 
 	case RCU_SAVE_COMPLETED:
 
 		/* Update state, record completion counter. */
 		forcenow = 0;
-		spin_lock(&rnp->lock);
 		if (lastcomp + 1 == rsp->gpnum &&
 		    lastcomp == rsp->completed &&
 		    rsp->signaled == signaled) {
@@ -1245,23 +1246,31 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 			rsp->completed_fqs = lastcomp;
 			forcenow = signaled == RCU_SAVE_COMPLETED;
 		}
-		spin_unlock(&rnp->lock);
-		if (!forcenow)
+		if (!forcenow) {
+			spin_unlock(&rnp->lock);
 			break;
+		}
 		/* fall into next case. */
 
 	case RCU_FORCE_QS:
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
+		spin_unlock(&rnp->lock);
 		if (rcu_process_dyntick(rsp, rsp->completed_fqs,
 					rcu_implicit_dynticks_qs))
-			goto unlock_ret;
+			goto unlock_fqs_ret;
 
 		/* Leave state in case more forcing is required. */
 
 		break;
+
+	default:
+
+		spin_unlock(&rnp->lock);
+		WARN_ON_ONCE(1);
+		break;
 	}
-unlock_ret:
+unlock_fqs_ret:
 	spin_unlock_irqrestore(&rsp->fqslock, flags);
 }
 
-- 
1.5.2.5

