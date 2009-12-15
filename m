Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934239AbZLOXOv (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 15 Dec 2009 18:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761865AbZLOXOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:14:25 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43878 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762318AbZLOXCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:02:46 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 04/18] rcu: eliminate local variable signaled from force_quiescent_state()
Date: Tue, 15 Dec 2009 15:02:27 -0800
Message-Id: <12609181613720-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091215230213.GA9093@linux.vnet.ibm.com>
References: <20091215230213.GA9093@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Proposed for 2.6.34, not for inclusion.

Because the root rcu_node lock is held across entry to the switch
statement in force_quiescent_state(), it is no longer necessary
to snapshot rsp->signaled to a local variable.  Eliminate both the
snapshotting and the local variable.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 41688ff..1d8cfb1 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1193,7 +1193,6 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	unsigned long flags;
 	long lastcomp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
-	u8 signaled;
 	u8 forcenow;
 	u8 gpdone;
 
@@ -1209,7 +1208,6 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	rsp->n_force_qs++;
 	spin_lock(&rnp->lock);  /* irqs already disabled */
 	lastcomp = rsp->gpnum - 1;
-	signaled = rsp->signaled;
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	if(!rcu_gp_in_progress(rsp)) {
 		rsp->n_force_qs_ngp++;
@@ -1217,7 +1215,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		goto unlock_fqs_ret;  /* no GP in progress, time updated. */
 	}
 	rsp->fqs_active = 1;
-	switch (signaled) {
+	switch (rsp->signaled) {
 	case RCU_GP_IDLE:
 	case RCU_GP_INIT:
 
@@ -1242,11 +1240,10 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		/* Update state, record completion counter. */
 		forcenow = 0;
 		if (lastcomp + 1 == rsp->gpnum &&
-		    lastcomp == rsp->completed &&
-		    rsp->signaled == signaled) {
+		    lastcomp == rsp->completed) {
+			forcenow = rsp->signaled == RCU_SAVE_COMPLETED;
 			rsp->signaled = RCU_FORCE_QS;
 			rsp->completed_fqs = lastcomp;
-			forcenow = signaled == RCU_SAVE_COMPLETED;
 		}
 		if (!forcenow)
 			break;
-- 
1.5.2.5

