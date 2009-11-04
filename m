Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZKDIwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZKDIwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 03:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbZKDIwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 03:52:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:50508 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbZKDIwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 03:52:31 -0500
Date: Wed, 4 Nov 2009 08:52:09 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12571987492350-git-send-email->
References: <12571987492350-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Fix note_new_gpnum() uses of ->gpnum
Message-ID: <tip-561b39222a9a53eb2e465b851c5d38479072490a@git.kernel.org>
Git-Commit-ID: 561b39222a9a53eb2e465b851c5d38479072490a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  561b39222a9a53eb2e465b851c5d38479072490a
Gitweb:     http://git.kernel.org/tip/561b39222a9a53eb2e465b851c5d38479072490a
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 2 Nov 2009 13:52:29 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 09:43:58 +0100

rcu: Fix note_new_gpnum() uses of ->gpnum

Impose a clear locking design on the note_new_gpnum()
function's use of the ->gpnum counter.  This is done by updating
rdp->gpnum only from the corresponding leaf rcu_node structure's
rnp->gpnum field, and even then only under the protection of
that same rcu_node structure's ->lock field.  Performance and
scalability are maintained using a form of double-checked
locking, and excessive spinning is avoided by use of the
spin_trylock() function.  The use of spin_trylock() is safe due
to the fact that CPUs who fail to acquire this lock will try
again later. The hierarchical nature of the rcu_node data
structure limits contention (which could be limited further if
need be using the RCU_FANOUT kernel parameter).

Without this patch, obscure but quite possible races could
result in a quiescent state that occurred during one grace
period to be accounted to the following grace period, causing
this following grace period to end prematurely.  Not good!

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
LKML-Reference: <12571987492350-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |   32 +++++++++++++++++++++++++++-----
 1 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b478089..683c4f3 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -538,13 +538,33 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 /*
  * Update CPU-local rcu_data state to record the newly noticed grace period.
  * This is used both when we started the grace period and when we notice
- * that someone else started the grace period.
+ * that someone else started the grace period.  The caller must hold the
+ * ->lock of the leaf rcu_node structure corresponding to the current CPU,
+ *  and must have irqs disabled.
  */
+static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
+{
+	if (rdp->gpnum != rnp->gpnum) {
+		rdp->qs_pending = 1;
+		rdp->passed_quiesc = 0;
+		rdp->gpnum = rnp->gpnum;
+	}
+}
+
 static void note_new_gpnum(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	rdp->qs_pending = 1;
-	rdp->passed_quiesc = 0;
-	rdp->gpnum = rsp->gpnum;
+	unsigned long flags;
+	struct rcu_node *rnp;
+
+	local_irq_save(flags);
+	rnp = rdp->mynode;
+	if (rdp->gpnum == ACCESS_ONCE(rnp->gpnum) || /* outside lock. */
+	    !spin_trylock(&rnp->lock)) { /* irqs already off, retry later. */
+		local_irq_restore(flags);
+		return;
+	}
+	__note_new_gpnum(rsp, rnp, rdp);
+	spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -635,6 +655,9 @@ rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 	 */
 	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
 	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+
+	/* Set state so that this CPU will detect the next quiescent state. */
+	__note_new_gpnum(rsp, rnp, rdp);
 }
 
 /*
@@ -662,7 +685,6 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	record_gp_stall_check_time(rsp);
 	dyntick_record_completed(rsp, rsp->completed - 1);
-	note_new_gpnum(rsp, rdp);
 
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {
