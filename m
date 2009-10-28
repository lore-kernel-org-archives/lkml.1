Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbZJ1PQg (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 28 Oct 2009 11:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbZJ1PQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 11:16:35 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40944 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388AbZJ1PQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 11:16:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/2] rcu: fix long-grace-period race between forcing and initialization
Date: Wed, 28 Oct 2009 08:14:49 -0700
Message-Id: <1256742889199-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091028151419.GA7838@linux.vnet.ibm.com>
References: <20091028151419.GA7838@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Very long RCU read-side critical sections (50 milliseconds or so) can
cause a race between force_quiescent_state() and rcu_start_gp() as
follows on kernel builds with multi-level rcu_node hierarchies:

1.	CPU 0 calls force_quiescent_state(), sees that there is a
	grace period in progress, and acquires ->fsqlock.

2.	CPU 1 detects the end of the grace period, and so
	cpu_quiet_msk_finish() sets rsp->completed to rsp->gpnum.
	This operation is carried out under the root rnp->lock,
	but CPU 0 has not yet acquired that lock.  Note that
	rsp->signaled is still RCU_SAVE_DYNTICK from the last
	grace period.

3.	CPU 1 calls rcu_start_gp(), but no one wants a new grace
	period, so it drops the root rnp->lock and returns.

4.	CPU 0 acquires the root rnp->lock and picks up rsp->completed
	and rsp->signaled, then drops rnp->lock.  It then enters the
	RCU_SAVE_DYNTICK leg of the switch statement.

5.	CPU 2 invokes call_rcu(), and now needs a new grace period.
	It calls rcu_start_gp(), which acquires the root rnp->lock, sets
	rsp->signaled to RCU_GP_INIT (too bad that CPU 0 is already in
	the RCU_SAVE_DYNTICK leg of the switch statement!)  and starts
	initializing the rcu_node hierarchy.  If there are multiple
	levels to the hierarchy, it will drop the root rnp->lock and
	initialize the lower levels of the hierarchy.

6.	CPU 0 notes that rsp->completed has not changed, which permits
	both CPU 2 and CPU 0 to try updating it concurrently.  If CPU 0's
	update prevails, later calls to force_quiescent_state() can
	count old quiescent states against the new grace period, which
	can in turn result in premature ending of grace periods.

	Not good.

This patch adds an RCU_GP_IDLE state for rsp->signaled that is set
initially at boot time and any time a grace period ends.  This prevents
CPU 0 from getting into the workings of force_quiescent_state() in
step 4.  Additional locking and checks prevent the concurrent update
of rsp->signaled in step 6.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   16 +++++++++++-----
 kernel/rcutree.h |    7 ++++---
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 055f1a9..0d9faee 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -61,7 +61,7 @@ static struct lock_class_key rcu_root_class;
 		NUM_RCU_LVL_2, \
 		NUM_RCU_LVL_3, /* == MAX_RCU_LVLS */ \
 	}, \
-	.signaled = RCU_SIGNAL_INIT, \
+	.signaled = RCU_GP_IDLE, \
 	.gpnum = -300, \
 	.completed = -300, \
 	.onofflock = __SPIN_LOCK_UNLOCKED(&name.onofflock), \
@@ -659,14 +659,17 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	 * irqs disabled.
 	 */
 	rcu_for_each_node_breadth_first(rsp, rnp) {
-		spin_lock(&rnp->lock);	/* irqs already disabled. */
+		spin_lock(&rnp->lock);		/* irqs already disabled. */
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
-		spin_unlock(&rnp->lock);	/* irqs already disabled. */
+		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 	}
 
+	rnp = rcu_get_root(rsp);
+	spin_lock(&rnp->lock);			/* irqs already disabled. */
 	rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state now OK. */
+	spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 	spin_unlock_irqrestore(&rsp->onofflock, flags);
 }
 
@@ -708,6 +711,7 @@ static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags)
 {
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 	rsp->completed = rsp->gpnum;
+	rsp->signaled = RCU_GP_IDLE;
 	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
 }
@@ -1151,9 +1155,10 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	}
 	spin_unlock(&rnp->lock);
 	switch (signaled) {
+	case RCU_GP_IDLE:
 	case RCU_GP_INIT:
 
-		break; /* grace period still initializing, ignore. */
+		break; /* grace period idle or initializing, ignore. */
 
 	case RCU_SAVE_DYNTICK:
 
@@ -1167,7 +1172,8 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 
 		/* Update state, record completion counter. */
 		spin_lock(&rnp->lock);
-		if (lastcomp == rsp->completed) {
+		if (lastcomp == rsp->completed &&
+		    rsp->signaled == RCU_SAVE_DYNTICK) {
 			rsp->signaled = RCU_FORCE_QS;
 			dyntick_record_completed(rsp, lastcomp);
 		}
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 599161f..e1bc649 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -201,9 +201,10 @@ struct rcu_data {
 };
 
 /* Values for signaled field in struct rcu_state. */
-#define RCU_GP_INIT		0	/* Grace period being initialized. */
-#define RCU_SAVE_DYNTICK	1	/* Need to scan dyntick state. */
-#define RCU_FORCE_QS		2	/* Need to force quiescent state. */
+#define RCU_GP_IDLE		0	/* No grace period in progress. */
+#define RCU_GP_INIT		1	/* Grace period being initialized. */
+#define RCU_SAVE_DYNTICK	2	/* Need to scan dyntick state. */
+#define RCU_FORCE_QS		3	/* Need to force quiescent state. */
 #ifdef CONFIG_NO_HZ
 #define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
 #else /* #ifdef CONFIG_NO_HZ */
-- 
1.5.2.5

