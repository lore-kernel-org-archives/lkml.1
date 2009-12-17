Return-Path: <linux-kernel-owner+w=401wt.eu-S1761784AbZLQEwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761784AbZLQEwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761821AbZLQEDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:03:35 -0500
Received: from kroah.org ([198.145.64.141]:55209 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761700AbZLQEDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:33 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:43 2009
Message-Id: <20091217035643.762235033@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, Ingo Molnar <mingo@elte.hu>
Subject: [006/151] rcu: Fix note_new_gpnum() uses of ->gpnum
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

commit 9160306e6f5b68bb64630c9031c517ca1cf463db upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/rcutree.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -538,13 +538,33 @@ static void check_cpu_stall(struct rcu_s
 /*
  * Update CPU-local rcu_data state to record the newly noticed grace period.
  * This is used both when we started the grace period and when we notice
- * that someone else started the grace period.
- */
+ * that someone else started the grace period.  The caller must hold the
+ * ->lock of the leaf rcu_node structure corresponding to the current CPU,
+ *  and must have irqs disabled.
+ */
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
@@ -635,6 +655,9 @@ rcu_start_gp_per_cpu(struct rcu_state *r
 	 */
 	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
 	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+
+	/* Set state so that this CPU will detect the next quiescent state. */
+	__note_new_gpnum(rsp, rnp, rdp);
 }
 
 /*
@@ -662,7 +685,6 @@ rcu_start_gp(struct rcu_state *rsp, unsi
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	record_gp_stall_check_time(rsp);
 	dyntick_record_completed(rsp, rsp->completed - 1);
-	note_new_gpnum(rsp, rdp);
 
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {


