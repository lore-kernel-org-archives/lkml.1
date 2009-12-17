Return-Path: <linux-kernel-owner+w=401wt.eu-S1763969AbZLQEvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763969AbZLQEvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762075AbZLQEDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:03:37 -0500
Received: from kroah.org ([198.145.64.141]:55197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761703AbZLQEDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:32 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:43 2009
Message-Id: <20091217035643.635648125@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, Ingo Molnar <mingo@elte.hu>
Subject: [005/151] rcu: Fix synchronization for rcu_process_gp_end() uses of ->completed counter
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

commit d09b62dfa336447c52a5ec9bb88adbc479b0f3b8 upstream.

Impose a clear locking design on the rcu_process_gp_end()
function's use of the ->completed counter.  This is done by
creating a ->completed field in the rcu_node structure, which
can safely be accessed under the protection of that structure's
lock.  Performance and scalability are maintained by using a
form of double-checked locking, so that rcu_process_gp_end()
only acquires the leaf rcu_node structure's ->lock if a grace
period has recently ended.

This fix reduces rcutorture failure rate by at least two orders
of magnitude under heavy stress with force_quiescent_state()
being invoked artificially often.  Without this fix,
unsynchronized access to the ->completed field can cause
rcu_process_gp_end() to advance callbacks whose grace period has
not yet expired.  (Bad idea!)

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
LKML-Reference: <12571987494069-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/rcutree.c |  128 ++++++++++++++++++++++++++++++++++---------------------
 kernel/rcutree.h |    3 +
 2 files changed, 83 insertions(+), 48 deletions(-)

--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -568,6 +568,76 @@ check_for_new_grace_period(struct rcu_st
 }
 
 /*
+ * Advance this CPU's callbacks, but only if the current grace period
+ * has ended.  This may be called only from the CPU to whom the rdp
+ * belongs.  In addition, the corresponding leaf rcu_node structure's
+ * ->lock must be held by the caller, with irqs disabled.
+ */
+static void
+__rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
+{
+	/* Did another grace period end? */
+	if (rdp->completed != rnp->completed) {
+
+		/* Advance callbacks.  No harm if list empty. */
+		rdp->nxttail[RCU_DONE_TAIL] = rdp->nxttail[RCU_WAIT_TAIL];
+		rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_READY_TAIL];
+		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+
+		/* Remember that we saw this grace-period completion. */
+		rdp->completed = rnp->completed;
+	}
+}
+
+/*
+ * Advance this CPU's callbacks, but only if the current grace period
+ * has ended.  This may be called only from the CPU to whom the rdp
+ * belongs.
+ */
+static void
+rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	unsigned long flags;
+	struct rcu_node *rnp;
+
+	local_irq_save(flags);
+	rnp = rdp->mynode;
+	if (rdp->completed == ACCESS_ONCE(rnp->completed) || /* outside lock. */
+	    !spin_trylock(&rnp->lock)) { /* irqs already off, retry later. */
+		local_irq_restore(flags);
+		return;
+	}
+	__rcu_process_gp_end(rsp, rnp, rdp);
+	spin_unlock_irqrestore(&rnp->lock, flags);
+}
+
+/*
+ * Do per-CPU grace-period initialization for running CPU.  The caller
+ * must hold the lock of the leaf rcu_node structure corresponding to
+ * this CPU.
+ */
+static void
+rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
+{
+	/* Prior grace period ended, so advance callbacks for current CPU. */
+	__rcu_process_gp_end(rsp, rnp, rdp);
+
+	/*
+	 * Because this CPU just now started the new grace period, we know
+	 * that all of its callbacks will be covered by this upcoming grace
+	 * period, even the ones that were registered arbitrarily recently.
+	 * Therefore, advance all outstanding callbacks to RCU_WAIT_TAIL.
+	 *
+	 * Other CPUs cannot be sure exactly when the grace period started.
+	 * Therefore, their recently registered callbacks must pass through
+	 * an additional RCU_NEXT_READY stage, so that they will be handled
+	 * by the next RCU grace period.
+	 */
+	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+}
+
+/*
  * Start a new RCU grace period if warranted, re-initializing the hierarchy
  * in preparation for detecting the next grace period.  The caller must hold
  * the root node's ->lock, which is released before return.  Hard irqs must
@@ -594,26 +664,14 @@ rcu_start_gp(struct rcu_state *rsp, unsi
 	dyntick_record_completed(rsp, rsp->completed - 1);
 	note_new_gpnum(rsp, rdp);
 
-	/*
-	 * Because this CPU just now started the new grace period, we know
-	 * that all of its callbacks will be covered by this upcoming grace
-	 * period, even the ones that were registered arbitrarily recently.
-	 * Therefore, advance all outstanding callbacks to RCU_WAIT_TAIL.
-	 *
-	 * Other CPUs cannot be sure exactly when the grace period started.
-	 * Therefore, their recently registered callbacks must pass through
-	 * an additional RCU_NEXT_READY stage, so that they will be handled
-	 * by the next RCU grace period.
-	 */
-	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
-	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
-
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
+		rnp->completed = rsp->completed;
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
+		rcu_start_gp_per_cpu(rsp, rnp, rdp);
 		spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
@@ -646,6 +704,9 @@ rcu_start_gp(struct rcu_state *rsp, unsi
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
+		rnp->completed = rsp->completed;
+		if (rnp == rdp->mynode)
+			rcu_start_gp_per_cpu(rsp, rnp, rdp);
 		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 	}
 
@@ -657,34 +718,6 @@ rcu_start_gp(struct rcu_state *rsp, unsi
 }
 
 /*
- * Advance this CPU's callbacks, but only if the current grace period
- * has ended.  This may be called only from the CPU to whom the rdp
- * belongs.
- */
-static void
-rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
-{
-	long completed_snap;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	completed_snap = ACCESS_ONCE(rsp->completed);  /* outside of lock. */
-
-	/* Did another grace period end? */
-	if (rdp->completed != completed_snap) {
-
-		/* Advance callbacks.  No harm if list empty. */
-		rdp->nxttail[RCU_DONE_TAIL] = rdp->nxttail[RCU_WAIT_TAIL];
-		rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_READY_TAIL];
-		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
-
-		/* Remember that we saw this grace-period completion. */
-		rdp->completed = completed_snap;
-	}
-	local_irq_restore(flags);
-}
-
-/*
  * Clean up after the prior grace period and let rcu_start_gp() start up
  * the next grace period if one is needed.  Note that the caller must
  * hold rnp->lock, as required by rcu_start_gp(), which will release it.
@@ -695,7 +728,6 @@ static void cpu_quiet_msk_finish(struct 
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 	rsp->completed = rsp->gpnum;
 	rsp->signaled = RCU_GP_IDLE;
-	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
 	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
 }
 
@@ -1537,21 +1569,16 @@ static void __cpuinit
 rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
 {
 	unsigned long flags;
-	long lastcomp;
 	unsigned long mask;
 	struct rcu_data *rdp = rsp->rda[cpu];
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	/* Set up local state, ensuring consistent view of global state. */
 	spin_lock_irqsave(&rnp->lock, flags);
-	lastcomp = rsp->completed;
-	rdp->completed = lastcomp;
-	rdp->gpnum = lastcomp;
 	rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
 	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
 	rdp->beenonline = 1;	 /* We have now been online. */
 	rdp->preemptable = preemptable;
-	rdp->passed_quiesc_completed = lastcomp - 1;
 	rdp->qlen_last_fqs_check = 0;
 	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
@@ -1573,6 +1600,11 @@ rcu_init_percpu_data(int cpu, struct rcu
 		spin_lock(&rnp->lock);	/* irqs already disabled. */
 		rnp->qsmaskinit |= mask;
 		mask = rnp->grpmask;
+		if (rnp == rdp->mynode) {
+			rdp->gpnum = rnp->completed; /* if GP in progress... */
+			rdp->completed = rnp->completed;
+			rdp->passed_quiesc_completed = rnp->completed - 1;
+		}
 		spin_unlock(&rnp->lock); /* irqs already disabled. */
 		rnp = rnp->parent;
 	} while (rnp != NULL && !(rnp->qsmaskinit & mask));
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -84,6 +84,9 @@ struct rcu_node {
 	long	gpnum;		/* Current grace period for this node. */
 				/*  This will either be equal to or one */
 				/*  behind the root rcu_node's gpnum. */
+	long	completed;	/* Last grace period completed for this node. */
+				/*  This will either be equal to or one */
+				/*  behind the root rcu_node's gpnum. */
 	unsigned long qsmask;	/* CPUs or groups that need to switch in */
 				/*  order for current grace period to proceed.*/
 				/*  In leaf rcu_node, each bit corresponds to */


