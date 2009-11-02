Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbZKBVwf (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 2 Nov 2009 16:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbZKBVwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:52:34 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52493 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874AbZKBVwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:52:30 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/3] rcu: Fixes for note_new_gpnum() uses of ->gpnum
Date: Mon,  2 Nov 2009 13:52:29 -0800
Message-Id: <12571987492350-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091102215147.GA9704@linux.vnet.ibm.com>
References: <20091102215147.GA9704@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Imposes a clear locking design on the note_new_gpnum() function's use
of the ->gpnum counter.  This is done by updating rdp->gpnum only from
the corresponding leaf rcu_node structure's rnp->gpnum field, and even
then only under the protection of that same rcu_node structure's ->lock
field.  Performance and scalability are maintained using a form of
double-checked locking, and excessive spinning is avoided by use of
the spin_trylock() function.  The use of spin_trylock() is safe due to
the fact that CPUs who fail to acquire this lock will try again later.
The hierarchical nature of the rcu_node data structure limits contention
(which could be limited further if need be using the RCU_FANOUT kernel
parameter).

Without this patch, obscure but quite possible races could result in
a quiescent state that occurred during one grace period to be accounted
to the following grace period, causing this following grace period to
end prematurely.  Not good!

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   32 +++++++++++++++++++++++++++-----
 1 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ceb4042..af9ea09 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -540,13 +540,33 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
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
@@ -637,6 +657,9 @@ rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 	 */
 	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
 	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+
+	/* Set state so that this CPU will detect the next quiescent state. */
+	__note_new_gpnum(rsp, rnp, rdp);
 }
 
 /*
@@ -664,7 +687,6 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	record_gp_stall_check_time(rsp);
 	dyntick_record_completed(rsp, rsp->completed - 1);
-	note_new_gpnum(rsp, rdp);
 
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {
-- 
1.5.2.5

