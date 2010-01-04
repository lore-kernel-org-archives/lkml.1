Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0ADXJd (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 4 Jan 2010 18:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967Ab0ADXJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:09:26 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59996 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab0ADXJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:09:17 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/11] rcu: eliminate local variable lastcomp from force_quiescent_state()
Date: Mon,  4 Jan 2010 15:09:04 -0800
Message-Id: <12626465502985-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20100104230850.GA22111@linux.vnet.ibm.com>
References: <20100104230850.GA22111@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Because rsp->fqs_active is set to 1 across force_quiescent_state()'s
switch statement, rcu_start_gp() will refrain from starting a new
grace period during this time.  Therefore, rsp->gpnum is constant,
and can be propagated to all uses of lastcomp, eliminating this local
variable.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   10 +++-------
 kernel/rcutree.h |    2 --
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 1d8cfb1..62b6433 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1191,7 +1191,6 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 {
 	unsigned long flags;
-	long lastcomp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 	u8 forcenow;
 	u8 gpdone;
@@ -1207,7 +1206,6 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		goto unlock_fqs_ret; /* no emergency and done recently. */
 	rsp->n_force_qs++;
 	spin_lock(&rnp->lock);  /* irqs already disabled */
-	lastcomp = rsp->gpnum - 1;
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	if(!rcu_gp_in_progress(rsp)) {
 		rsp->n_force_qs_ngp++;
@@ -1228,7 +1226,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 			break; /* So gcc recognizes the dead code. */
 
 		/* Record dyntick-idle state. */
-		gpdone = rcu_process_dyntick(rsp, lastcomp,
+		gpdone = rcu_process_dyntick(rsp, rsp->gpnum - 1,
 					     dyntick_save_progress_counter);
 		spin_lock(&rnp->lock);  /* irqs already disabled */
 		if (gpdone)
@@ -1239,11 +1237,9 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 
 		/* Update state, record completion counter. */
 		forcenow = 0;
-		if (lastcomp + 1 == rsp->gpnum &&
-		    lastcomp == rsp->completed) {
+		if (rsp->gpnum - 1 == rsp->completed) {
 			forcenow = rsp->signaled == RCU_SAVE_COMPLETED;
 			rsp->signaled = RCU_FORCE_QS;
-			rsp->completed_fqs = lastcomp;
 		}
 		if (!forcenow)
 			break;
@@ -1253,7 +1249,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
 		spin_unlock(&rnp->lock);  /* irqs remain disabled */
-		gpdone = rcu_process_dyntick(rsp, rsp->completed_fqs,
+		gpdone = rcu_process_dyntick(rsp, rsp->gpnum - 1,
 					     rcu_implicit_dynticks_qs);
 
 		/* Leave state in case more forcing is required. */
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index dc386a7..5348561 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -296,8 +296,6 @@ struct rcu_state {
 	long orphan_qlen;			/* Number of orphaned cbs. */
 	spinlock_t fqslock;			/* Only one task forcing */
 						/*  quiescent states. */
-	long	completed_fqs;			/* Value of completed @ snap. */
-						/*  Protected by fqslock. */
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
 						/*  force_quiescent_state(). */
 	unsigned long n_force_qs;		/* Number of calls to */
-- 
1.5.2.5

