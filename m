Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab0ADXJ3 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 4 Jan 2010 18:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068Ab0ADXJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:09:25 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36145 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab0ADXJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:09:18 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/11] rcu: eliminate rcu_process_dyntick() return value
Date: Mon,  4 Jan 2010 15:09:06 -0800
Message-Id: <12626465501857-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20100104230850.GA22111@linux.vnet.ibm.com>
References: <20100104230850.GA22111@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Because a new grace period cannot start while we are executing within the
force_quiescent_state() function's switch statement, if any test within
that switch statement or within any function called from that switch
statement shows that the current grace period has ended, we can safely
re-do that test any time before we leave the switch statement.  This
means that we no longer need a return value from rcu_process_dyntick(),
as we can simply invoke rcu_gp_in_progress() to check whether the old
grace period has finished -- there is no longer any need to worry about
whether or not a new grace period has been started.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index c7d0070..e497119 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1144,11 +1144,9 @@ void rcu_check_callbacks(int cpu, int user)
 /*
  * Scan the leaf rcu_node structures, processing dyntick state for any that
  * have not yet encountered a quiescent state, using the function specified.
- * Returns 1 if the current grace period ends while scanning (possibly
- * because we made it end).
  */
-static int rcu_process_dyntick(struct rcu_state *rsp,
-			       int (*f)(struct rcu_data *))
+static void rcu_process_dyntick(struct rcu_state *rsp,
+				int (*f)(struct rcu_data *))
 {
 	unsigned long bit;
 	int cpu;
@@ -1161,7 +1159,7 @@ static int rcu_process_dyntick(struct rcu_state *rsp,
 		spin_lock_irqsave(&rnp->lock, flags);
 		if (rnp->completed != rsp->gpnum - 1) {
 			spin_unlock_irqrestore(&rnp->lock, flags);
-			return 1;
+			return;
 		}
 		if (rnp->qsmask == 0) {
 			spin_unlock_irqrestore(&rnp->lock, flags);
@@ -1181,7 +1179,6 @@ static int rcu_process_dyntick(struct rcu_state *rsp,
 		}
 		spin_unlock_irqrestore(&rnp->lock, flags);
 	}
-	return 0;
 }
 
 /*
@@ -1193,7 +1190,6 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 	u8 forcenow;
-	u8 gpdone;
 
 	if (!rcu_gp_in_progress(rsp))
 		return;  /* No grace period in progress, nothing to force. */
@@ -1226,10 +1222,9 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 			break; /* So gcc recognizes the dead code. */
 
 		/* Record dyntick-idle state. */
-		gpdone = rcu_process_dyntick(rsp,
-					     dyntick_save_progress_counter);
+		rcu_process_dyntick(rsp, dyntick_save_progress_counter);
 		spin_lock(&rnp->lock);  /* irqs already disabled */
-		if (gpdone)
+		if (!rcu_gp_in_progress(rsp))
 			break;
 		/* fall into next case. */
 
@@ -1249,7 +1244,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
 		spin_unlock(&rnp->lock);  /* irqs remain disabled */
-		gpdone = rcu_process_dyntick(rsp, rcu_implicit_dynticks_qs);
+		rcu_process_dyntick(rsp, rcu_implicit_dynticks_qs);
 
 		/* Leave state in case more forcing is required. */
 
-- 
1.5.2.5

