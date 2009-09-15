Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbZIOHS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbZIOHS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 03:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758165AbZIOHSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 03:18:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:49502 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758156AbZIOHSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 03:18:13 -0400
Date: Tue, 15 Sep 2009 07:17:44 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12528585111986-git-send-email->
References: <12528585111986-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Add debug checks to TREE_PREEMPT_RCU for premature grace periods
Message-ID: <tip-429e6f07df20175fa59927df415c41c5e1d82d91@git.kernel.org>
Git-Commit-ID: 429e6f07df20175fa59927df415c41c5e1d82d91
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 07:17:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  429e6f07df20175fa59927df415c41c5e1d82d91
Gitweb:     http://git.kernel.org/tip/429e6f07df20175fa59927df415c41c5e1d82d91
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sun, 13 Sep 2009 09:15:09 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 08:43:58 +0200

rcu: Add debug checks to TREE_PREEMPT_RCU for premature grace periods

Check to make sure that there are no blocked tasks for the previous
grace period while initializing for the next grace period, verify
that rcu_preempt_qs() is given the correct CPU number and is never
called for an offline CPU.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
LKML-Reference: <12528585111986-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcutree.c        |    2 ++
 kernel/rcutree_plugin.h |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index da301e2..e9a4ae9 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -632,6 +632,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {
 		rnp->qsmask = rnp->qsmaskinit;
+		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->gpnum = rsp->gpnum;
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		spin_unlock_irqrestore(&rnp->lock, flags);
@@ -665,6 +666,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++) {
 		spin_lock(&rnp_cur->lock);	/* irqs already disabled. */
 		rnp_cur->qsmask = rnp_cur->qsmaskinit;
+		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->gpnum = rsp->gpnum;
 		spin_unlock(&rnp_cur->lock);	/* irqs already disabled. */
 	}
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 4778936..b8e4b03 100644
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
