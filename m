Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761414AbZLOXLI (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 15 Dec 2009 18:11:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932746AbZLOXJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:09:58 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36901 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762346AbZLOXCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:02:50 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 09/18] rcu: remove redundant grace-period check
Date: Tue, 15 Dec 2009 15:02:32 -0800
Message-Id: <1260918161762-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091215230213.GA9093@linux.vnet.ibm.com>
References: <20091215230213.GA9093@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Proposed for 2.6.34, not for inclusion.

The rcu_process_dyntick() function checks twice for the end of
the current grace period.  However, it holds the current rcu_node
structure's ->lock field throughout, and doesn't get to the second call
to rcu_gp_in_progress() unless there is at least one CPU corresponding
to this rcu_node structure that has not yet checked in for the current
grace period, which would prevent the current grace period from ending.
So the current grace period cannot have ended, and the second check is
redundant, so remove it.

Also, given that this function is used even with !CONFIG_NO_HZ, its name
is quite misleading.  Change from rcu_process_dyntick() to force_qs_rnp().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6268f37..d920285 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1146,8 +1146,7 @@ void rcu_check_callbacks(int cpu, int user)
  * have not yet encountered a quiescent state, using the function specified.
  * The caller must have suppressed start of new grace periods.
  */
-static void rcu_process_dyntick(struct rcu_state *rsp,
-				int (*f)(struct rcu_data *))
+static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 {
 	unsigned long bit;
 	int cpu;
@@ -1172,7 +1171,7 @@ static void rcu_process_dyntick(struct rcu_state *rsp,
 			if ((rnp->qsmask & bit) != 0 && f(rsp->rda[cpu]))
 				mask |= bit;
 		}
-		if (mask != 0 && rcu_gp_in_progress(rsp)) {
+		if (mask != 0) {
 
 			/* rcu_report_qs_rnp() releases rnp->lock. */
 			rcu_report_qs_rnp(mask, rsp, rnp, flags);
@@ -1222,7 +1221,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 			break; /* So gcc recognizes the dead code. */
 
 		/* Record dyntick-idle state. */
-		rcu_process_dyntick(rsp, dyntick_save_progress_counter);
+		force_qs_rnp(rsp, dyntick_save_progress_counter);
 		spin_lock(&rnp->lock);  /* irqs already disabled */
 		if (rcu_gp_in_progress(rsp))
 			rsp->signaled = RCU_FORCE_QS;
@@ -1232,7 +1231,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
 		spin_unlock(&rnp->lock);  /* irqs remain disabled */
-		rcu_process_dyntick(rsp, rcu_implicit_dynticks_qs);
+		force_qs_rnp(rsp, rcu_implicit_dynticks_qs);
 
 		/* Leave state in case more forcing is required. */
 
-- 
1.5.2.5

