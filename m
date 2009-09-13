Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbZIMQbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbZIMQbo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 12:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbZIMQbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 12:31:42 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46599 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbZIMQbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 12:31:41 -0400
Date: Sun, 13 Sep 2009 09:31:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH tip/core/rcu 2/4] Add debug checks to TREE_PREEMPT_RCU
	for premature grace periods.
Message-ID: <20090913163146.GG6867@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090913161438.GA32550@linux.vnet.ibm.com> <1252858982.28368.171.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252858982.28368.171.camel@desktop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 13, 2009 at 09:23:02AM -0700, Daniel Walker wrote:
> On Sun, 2009-09-13 at 09:15 -0700, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Check to make sure that there are no blocked tasks for the previous
> > grace period while initializing for the next grace period, verify
> > that rcu_preempt_qs() is given the correct CPU number and is never
> > called for an offline CPU.
> > 
> 
> You've got a couple of whitespace issues in the WARN_ON_ONCE() lines..
> As found by checkpatch,
> 
> ERROR: code indent should use tabs where possible
> #97: FILE: kernel/rcutree_plugin.h:89:
> +^I    ^IWARN_ON_ONCE(cpu != smp_processor_id());$
> 
> ERROR: code indent should use tabs where possible
> #109: FILE: kernel/rcutree_plugin.h:111:
> +^I    ^IWARN_ON_ONCE((rdp->grpmask & rnp->qsmaskinit) == 0);$
> 
> Could you fix these up?

Good catch!  Here is a corrected version.

							Thanx, Paul

------------------------------------------------------------------------

>From f5807ddbd4fff957e6c2efdc874a740ff40f1c94 Mon Sep 17 00:00:00 2001
From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date: Tue, 8 Sep 2009 16:36:30 -0700
Subject: [PATCH tip/core/rcu 2/4] Add debug checks to TREE_PREEMPT_RCU for premature grace periods.

Check to make sure that there are no blocked tasks for the previous
grace period while initializing for the next grace period, verify
that rcu_preempt_qs() is given the correct CPU number and is never
called for an offline CPU.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |    2 ++
 kernel/rcutree_plugin.h |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index bca0aba..3a01405 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -627,6 +627,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {
 		rnp->qsmask = rnp->qsmaskinit;
+		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->gpnum = rsp->gpnum;
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		spin_unlock_irqrestore(&rnp->lock, flags);
@@ -660,6 +661,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++) {
 		spin_lock(&rnp_cur->lock);	/* irqs already disabled. */
 		rnp_cur->qsmask = rnp_cur->qsmaskinit;
+		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->gpnum = rsp->gpnum;
 		spin_unlock(&rnp_cur->lock);	/* irqs already disabled. */
 	}
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 4778936..51413cb 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -86,6 +86,7 @@ static void rcu_preempt_qs(int cpu)
 
 	if (t->rcu_read_lock_nesting &&
 	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
+		WARN_ON_ONCE(cpu != smp_processor_id());
 
 		/* Possibly blocking in an RCU read-side critical section. */
 		rdp = rcu_preempt_state.rda[cpu];
@@ -103,7 +104,11 @@ static void rcu_preempt_qs(int cpu)
 		 * state for the current grace period), then as long
 		 * as that task remains queued, the current grace period
 		 * cannot end.
+		 *
+		 * But first, note that the current CPU must still be
+		 * on line!
 		 */
+		WARN_ON_ONCE((rdp->grpmask & rnp->qsmaskinit) == 0);
 		phase = !(rnp->qsmask & rdp->grpmask) ^ (rnp->gpnum & 0x1);
 		list_add(&t->rcu_node_entry, &rnp->blocked_tasks[phase]);
 		smp_mb();  /* Ensure later ctxt swtch seen after above. */
@@ -259,6 +264,18 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /*
+ * Check that the list of blocked tasks for the newly completed grace
+ * period is in fact empty.  It is a serious bug to complete a grace
+ * period that still has RCU readers blocked!  This function must be
+ * invoked -before- updating this rnp's ->gpnum, and the rnp's ->lock
+ * must be held by the caller.
+ */
+static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
+{
+	WARN_ON_ONCE(!list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]));
+}
+
+/*
  * Check for preempted RCU readers for the specified rcu_node structure.
  * If the caller needs a reliable answer, it must hold the rcu_node's
  * >lock.
@@ -451,6 +468,14 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /*
+ * Because there is no preemptable RCU, there can be no readers blocked,
+ * so there is no need to check for blocked tasks.
+ */
+static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
+{
+}
+
+/*
  * Because preemptable RCU does not exist, there are never any preempted
  * RCU readers.
  */
-- 
1.5.2.5

