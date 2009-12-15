Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934037AbZLOXKZ (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 15 Dec 2009 18:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932854AbZLOXJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:09:59 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33561 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762246AbZLOXCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:02:50 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 06/18] rcu: eliminate second argument of rcu_process_dyntick()
Date: Tue, 15 Dec 2009 15:02:29 -0800
Message-Id: <12609181612426-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091215230213.GA9093@linux.vnet.ibm.com>
References: <20091215230213.GA9093@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Proposed for 2.6.34, not for inclusion.

At this point, the second argument to all calls to rcu_process_dyntick()
is a function of the same field of the structure passed in as the first
argument, namely, rsp->gpnum-1.  So propagate rsp->gpnum-1 to all uses
of the second argument within rcu_process_dyntick() and then eliminate
the second argument.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 62b6433..c7d0070 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1147,7 +1147,7 @@ void rcu_check_callbacks(int cpu, int user)
  * Returns 1 if the current grace period ends while scanning (possibly
  * because we made it end).
  */
-static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
+static int rcu_process_dyntick(struct rcu_state *rsp,
 			       int (*f)(struct rcu_data *))
 {
 	unsigned long bit;
@@ -1159,7 +1159,7 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 	rcu_for_each_leaf_node(rsp, rnp) {
 		mask = 0;
 		spin_lock_irqsave(&rnp->lock, flags);
-		if (rnp->completed != lastcomp) {
+		if (rnp->completed != rsp->gpnum - 1) {
 			spin_unlock_irqrestore(&rnp->lock, flags);
 			return 1;
 		}
@@ -1173,7 +1173,7 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 			if ((rnp->qsmask & bit) != 0 && f(rsp->rda[cpu]))
 				mask |= bit;
 		}
-		if (mask != 0 && rnp->completed == lastcomp) {
+		if (mask != 0 && rnp->completed == rsp->gpnum - 1) {
 
 			/* rcu_report_qs_rnp() releases rnp->lock. */
 			rcu_report_qs_rnp(mask, rsp, rnp, flags);
@@ -1226,7 +1226,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 			break; /* So gcc recognizes the dead code. */
 
 		/* Record dyntick-idle state. */
-		gpdone = rcu_process_dyntick(rsp, rsp->gpnum - 1,
+		gpdone = rcu_process_dyntick(rsp,
 					     dyntick_save_progress_counter);
 		spin_lock(&rnp->lock);  /* irqs already disabled */
 		if (gpdone)
@@ -1249,8 +1249,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
 		spin_unlock(&rnp->lock);  /* irqs remain disabled */
-		gpdone = rcu_process_dyntick(rsp, rsp->gpnum - 1,
-					     rcu_implicit_dynticks_qs);
+		gpdone = rcu_process_dyntick(rsp, rcu_implicit_dynticks_qs);
 
 		/* Leave state in case more forcing is required. */
 
-- 
1.5.2.5

