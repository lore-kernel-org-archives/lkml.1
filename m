Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZKBQTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZKBQTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbZKBQTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:19:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:53708 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755669AbZKBQTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:19:10 -0500
Date: Mon, 2 Nov 2009 16:18:14 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1256742889199-git-send-email->
References: <1256742889199-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Fix long-grace-period race between forcing and initialization
Message-ID: <tip-83f5b01ffbbaea6f97c9a79d21e240dbfb69f2f1@git.kernel.org>
Git-Commit-ID: 83f5b01ffbbaea6f97c9a79d21e240dbfb69f2f1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  83f5b01ffbbaea6f97c9a79d21e240dbfb69f2f1
Gitweb:     http://git.kernel.org/tip/83f5b01ffbbaea6f97c9a79d21e240dbfb69f2f1
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 28 Oct 2009 08:14:49 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 16:06:21 +0100

rcu: Fix long-grace-period race between forcing and initialization

Very long RCU read-side critical sections (50 milliseconds or
so) can cause a race between force_quiescent_state() and
rcu_start_gp() as follows on kernel builds with multi-level
rcu_node hierarchies:

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

This patch adds an RCU_GP_IDLE state for rsp->signaled that is
set initially at boot time and any time a grace period ends.
This prevents CPU 0 from getting into the workings of
force_quiescent_state() in step 4.  Additional locking and
checks prevent the concurrent update of rsp->signaled in step 6.

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
LKML-Reference: <1256742889199-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |   16 +++++++++++-----
 kernel/rcutree.h |    7 ++++---
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0536125..f3077c0 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -59,7 +59,7 @@
 		NUM_RCU_LVL_2, \
 		NUM_RCU_LVL_3, /* == MAX_RCU_LVLS */ \
 	}, \
-	.signaled = RCU_SIGNAL_INIT, \
+	.signaled = RCU_GP_IDLE, \
 	.gpnum = -300, \
 	.completed = -300, \
 	.onofflock = __SPIN_LOCK_UNLOCKED(&name.onofflock), \
@@ -657,14 +657,17 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
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
 
@@ -706,6 +709,7 @@ static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags)
 {
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 	rsp->completed = rsp->gpnum;
+	rsp->signaled = RCU_GP_IDLE;
 	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
 }
@@ -1162,9 +1166,10 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	}
 	spin_unlock(&rnp->lock);
 	switch (signaled) {
+	case RCU_GP_IDLE:
 	case RCU_GP_INIT:
 
-		break; /* grace period still initializing, ignore. */
+		break; /* grace period idle or initializing, ignore. */
 
 	case RCU_SAVE_DYNTICK:
 
@@ -1178,7 +1183,8 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 
 		/* Update state, record completion counter. */
 		spin_lock(&rnp->lock);
-		if (lastcomp == rsp->completed) {
+		if (lastcomp == rsp->completed &&
+		    rsp->signaled == RCU_SAVE_DYNTICK) {
 			rsp->signaled = RCU_FORCE_QS;
 			dyntick_record_completed(rsp, lastcomp);
 		}
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 1823c6e..1899023 100644
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
