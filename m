Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbZLCNWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbZLCNWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZLCNWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:22:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:32819 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415AbZLCNWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:22:32 -0500
Date: Thu, 3 Dec 2009 13:22:00 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, josh@joshtriplett.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, josh@joshtriplett.org,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <12597846163698-git-send-email->
References: <12597846163698-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Rename "quiet" functions
Message-ID: <tip-d3f6bad3911736e44ba11f3f3f6ac4e8c837fdfc@git.kernel.org>
Git-Commit-ID: d3f6bad3911736e44ba11f3f3f6ac4e8c837fdfc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3f6bad3911736e44ba11f3f3f6ac4e8c837fdfc
Gitweb:     http://git.kernel.org/tip/d3f6bad3911736e44ba11f3f3f6ac4e8c837fdfc
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 2 Dec 2009 12:10:13 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Dec 2009 11:34:26 +0100

rcu: Rename "quiet" functions

The number of "quiet" functions has grown recently, and the
names are no longer very descriptive.  The point of all of these
functions is to do some portion of the task of reporting a
quiescent state, so rename them accordingly:

o	cpu_quiet() becomes rcu_report_qs_rdp(), which reports a
	quiescent state to the per-CPU rcu_data structure.  If this
	turns out to be a new quiescent state for this grace period,
	then rcu_report_qs_rnp() will be invoked to propagate the
	quiescent state up the rcu_node hierarchy.

o	cpu_quiet_msk() becomes rcu_report_qs_rnp(), which reports
	a quiescent state for a given CPU (or possibly a set of CPUs)
	up the rcu_node hierarchy.

o	cpu_quiet_msk_finish() becomes rcu_report_qs_rsp(), which
	reports a full set of quiescent states to the global rcu_state
	structure.

o	task_quiet() becomes rcu_report_unblock_qs_rnp(), which reports
	a quiescent state due to a task exiting an RCU read-side critical
	section that had previously blocked in that same critical section.
	As indicated by the new name, this type of quiescent state is
	reported up the rcu_node hierarchy (using rcu_report_qs_rnp()
	to do so).

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12597846163698-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c        |   66 ++++++++++++++++++++++++++--------------------
 kernel/rcutree.h        |    3 +-
 kernel/rcutree_plugin.h |   12 ++++----
 3 files changed, 45 insertions(+), 36 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 4ca7e02..a9f5103 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -740,11 +740,13 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 }
 
 /*
- * Clean up after the prior grace period and let rcu_start_gp() start up
- * the next grace period if one is needed.  Note that the caller must
- * hold rnp->lock, as required by rcu_start_gp(), which will release it.
+ * Report a full set of quiescent states to the specified rcu_state
+ * data structure.  This involves cleaning up after the prior grace
+ * period and letting rcu_start_gp() start up the next grace period
+ * if one is needed.  Note that the caller must hold rnp->lock, as
+ * required by rcu_start_gp(), which will release it.
  */
-static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags)
+static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	__releases(rcu_get_root(rsp)->lock)
 {
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
@@ -754,15 +756,16 @@ static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags)
 }
 
 /*
- * Similar to cpu_quiet(), for which it is a helper function.  Allows
- * a group of CPUs to be quieted at one go, though all the CPUs in the
- * group must be represented by the same leaf rcu_node structure.
- * That structure's lock must be held upon entry, and it is released
- * before return.
+ * Similar to rcu_report_qs_rdp(), for which it is a helper function.
+ * Allows quiescent states for a group of CPUs to be reported at one go
+ * to the specified rcu_node structure, though all the CPUs in the group
+ * must be represented by the same rcu_node structure (which need not be
+ * a leaf rcu_node structure, though it often will be).  That structure's
+ * lock must be held upon entry, and it is released before return.
  */
 static void
-cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
-	      unsigned long flags)
+rcu_report_qs_rnp(unsigned long mask, struct rcu_state *rsp,
+		  struct rcu_node *rnp, unsigned long flags)
 	__releases(rnp->lock)
 {
 	struct rcu_node *rnp_c;
@@ -798,21 +801,23 @@ cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
 
 	/*
 	 * Get here if we are the last CPU to pass through a quiescent
-	 * state for this grace period.  Invoke cpu_quiet_msk_finish()
+	 * state for this grace period.  Invoke rcu_report_qs_rsp()
 	 * to clean up and start the next grace period if one is needed.
 	 */
-	cpu_quiet_msk_finish(rsp, flags); /* releases rnp->lock. */
+	rcu_report_qs_rsp(rsp, flags); /* releases rnp->lock. */
 }
 
 /*
- * Record a quiescent state for the specified CPU, which must either be
- * the current CPU.  The lastcomp argument is used to make sure we are
- * still in the grace period of interest.  We don't want to end the current
- * grace period based on quiescent states detected in an earlier grace
- * period!
+ * Record a quiescent state for the specified CPU to that CPU's rcu_data
+ * structure.  This must be either called from the specified CPU, or
+ * called when the specified CPU is known to be offline (and when it is
+ * also known that no other CPU is concurrently trying to help the offline
+ * CPU).  The lastcomp argument is used to make sure we are still in the
+ * grace period of interest.  We don't want to end the current grace period
+ * based on quiescent states detected in an earlier grace period!
  */
 static void
-cpu_quiet(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
+rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
 {
 	unsigned long flags;
 	unsigned long mask;
@@ -827,8 +832,8 @@ cpu_quiet(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
 		 * The race with GP start is resolved by the fact that we
 		 * hold the leaf rcu_node lock, so that the per-CPU bits
 		 * cannot yet be initialized -- so we would simply find our
-		 * CPU's bit already cleared in cpu_quiet_msk() if this race
-		 * occurred.
+		 * CPU's bit already cleared in rcu_report_qs_rnp() if this
+		 * race occurred.
 		 */
 		rdp->passed_quiesc = 0;	/* try again later! */
 		spin_unlock_irqrestore(&rnp->lock, flags);
@@ -846,7 +851,7 @@ cpu_quiet(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
 		 */
 		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
 
-		cpu_quiet_msk(mask, rsp, rnp, flags); /* releases rnp->lock */
+		rcu_report_qs_rnp(mask, rsp, rnp, flags); /* rlses rnp->lock */
 	}
 }
 
@@ -877,8 +882,11 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 	if (!rdp->passed_quiesc)
 		return;
 
-	/* Tell RCU we are done (but cpu_quiet() will be the judge of that). */
-	cpu_quiet(rdp->cpu, rsp, rdp, rdp->passed_quiesc_completed);
+	/*
+	 * Tell RCU we are done (but rcu_report_qs_rdp() will be the
+	 * judge of that).
+	 */
+	rcu_report_qs_rdp(rdp->cpu, rsp, rdp, rdp->passed_quiesc_completed);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -968,13 +976,13 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	/*
 	 * We still hold the leaf rcu_node structure lock here, and
 	 * irqs are still disabled.  The reason for this subterfuge is
-	 * because invoking task_quiet() with ->onofflock held leads
-	 * to deadlock.
+	 * because invoking rcu_report_unblock_qs_rnp() with ->onofflock
+	 * held leads to deadlock.
 	 */
 	spin_unlock(&rsp->onofflock); /* irqs remain disabled. */
 	rnp = rdp->mynode;
 	if (need_quiet)
-		task_quiet(rnp, flags);
+		rcu_report_unblock_qs_rnp(rnp, flags);
 	else
 		spin_unlock_irqrestore(&rnp->lock, flags);
 
@@ -1164,8 +1172,8 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 		}
 		if (mask != 0 && rnp->completed == lastcomp) {
 
-			/* cpu_quiet_msk() releases rnp->lock. */
-			cpu_quiet_msk(mask, rsp, rnp, flags);
+			/* rcu_report_qs_rnp() releases rnp->lock. */
+			rcu_report_qs_rnp(mask, rsp, rnp, flags);
 			continue;
 		}
 		spin_unlock_irqrestore(&rnp->lock, flags);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index a81188c..8bb03cb 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -306,7 +306,8 @@ long rcu_batches_completed(void);
 static void rcu_preempt_note_context_switch(int cpu);
 static int rcu_preempted_readers(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
-static void task_quiet(struct rcu_node *rnp, unsigned long flags);
+static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
+				      unsigned long flags);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 static void rcu_print_task_stall(struct rcu_node *rnp);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 1d295c7..c9f0c97 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -167,7 +167,7 @@ static int rcu_preempted_readers(struct rcu_node *rnp)
  * irqs disabled, and this lock is released upon return, but irqs remain
  * disabled.
  */
-static void task_quiet(struct rcu_node *rnp, unsigned long flags)
+static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 	__releases(rnp->lock)
 {
 	unsigned long mask;
@@ -185,7 +185,7 @@ static void task_quiet(struct rcu_node *rnp, unsigned long flags)
 		 * or tasks were kicked up to root rcu_node due to
 		 * CPUs going offline.
 		 */
-		cpu_quiet_msk_finish(&rcu_preempt_state, flags);
+		rcu_report_qs_rsp(&rcu_preempt_state, flags);
 		return;
 	}
 
@@ -193,7 +193,7 @@ static void task_quiet(struct rcu_node *rnp, unsigned long flags)
 	mask = rnp->grpmask;
 	spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 	spin_lock(&rnp_p->lock);	/* irqs already disabled. */
-	cpu_quiet_msk(mask, &rcu_preempt_state, rnp_p, flags);
+	rcu_report_qs_rnp(mask, &rcu_preempt_state, rnp_p, flags);
 }
 
 /*
@@ -253,12 +253,12 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		/*
 		 * If this was the last task on the current list, and if
 		 * we aren't waiting on any CPUs, report the quiescent state.
-		 * Note that task_quiet() releases rnp->lock.
+		 * Note that rcu_report_unblock_qs_rnp() releases rnp->lock.
 		 */
 		if (empty)
 			spin_unlock_irqrestore(&rnp->lock, flags);
 		else
-			task_quiet(rnp, flags);
+			rcu_report_unblock_qs_rnp(rnp, flags);
 	} else {
 		local_irq_restore(flags);
 	}
@@ -566,7 +566,7 @@ static int rcu_preempted_readers(struct rcu_node *rnp)
 #ifdef CONFIG_HOTPLUG_CPU
 
 /* Because preemptible RCU does not exist, no quieting of tasks. */
-static void task_quiet(struct rcu_node *rnp, unsigned long flags)
+static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 {
 	spin_unlock_irqrestore(&rnp->lock, flags);
 }
