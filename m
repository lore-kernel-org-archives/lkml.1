Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZKNDvT (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 13 Nov 2009 22:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932267AbZKNDvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 22:51:17 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50636 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329AbZKNDvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 22:51:15 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/2] rcu: eliminate __rcu_pending() false positives
Date: Fri, 13 Nov 2009 19:51:39 -0800
Message-Id: <12581706991966-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091114035100.GA9599@linux.vnet.ibm.com>
References: <20091114035100.GA9599@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Now that there are both ->gpnum and ->completed fields in the rcu_node
structure, __rcu_pending() should check rdp->gpnum and rdp->completed
against rnp->gpnum and rdp->completed, respectively, instead of the prior
comparison against the rcu_state fields rsp->gpnum and rsp->completed.
Given the old comparison, __rcu_pending() could return 1, resulting in
a needless raise_softirq(RCU_SOFTIRQ).  This useless work would happen
if RCU responded to a scheduling-clock interrupt after the rcu_state
fields had been updated, but before the rcu_node fields had been updated.

Changing the comparison from the rcu_state fields to the rcu_node fields
prevents this useless work from happening.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 1089d08..e3565cd 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1390,6 +1390,8 @@ EXPORT_SYMBOL_GPL(call_rcu_bh);
  */
 static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 {
+	struct rcu_node *rnp = rdp->mynode;
+
 	rdp->n_rcu_pending++;
 
 	/* Check for CPU stalls, if enabled. */
@@ -1414,13 +1416,13 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 
 	/* Has another RCU grace period completed?  */
-	if (ACCESS_ONCE(rsp->completed) != rdp->completed) { /* outside lock */
+	if (ACCESS_ONCE(rnp->completed) != rdp->completed) { /* outside lock */
 		rdp->n_rp_gp_completed++;
 		return 1;
 	}
 
 	/* Has a new RCU grace period started? */
-	if (ACCESS_ONCE(rsp->gpnum) != rdp->gpnum) { /* outside lock */
+	if (ACCESS_ONCE(rnp->gpnum) != rdp->gpnum) { /* outside lock */
 		rdp->n_rp_gp_started++;
 		return 1;
 	}
-- 
1.5.2.5

