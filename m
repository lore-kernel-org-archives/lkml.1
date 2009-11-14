Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbZKNKTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbZKNKTl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 05:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbZKNKTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 05:19:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:37660 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061AbZKNKTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 05:19:39 -0500
Date: Sat, 14 Nov 2009 10:18:55 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258170699933-git-send-email->
References: <1258170699933-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Further cleanups of use of lastcomp
Message-ID: <tip-560d4bc0df9a5e63b980432282d8c2bd3559ec74@git.kernel.org>
Git-Commit-ID: 560d4bc0df9a5e63b980432282d8c2bd3559ec74
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  560d4bc0df9a5e63b980432282d8c2bd3559ec74
Gitweb:     http://git.kernel.org/tip/560d4bc0df9a5e63b980432282d8c2bd3559ec74
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Fri, 13 Nov 2009 19:51:38 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 14 Nov 2009 10:31:42 +0100

rcu: Further cleanups of use of lastcomp

Now that a copy of the rsp->completed flag is available in all
rcu_node structures, make full use of it.  It is still
legitimate to access rsp->completed while holding the root
rcu_node structure's lock, however.

Also, tighten up force_quiescent_state()'s checks for end of
current grace period.

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
LKML-Reference: <1258170699933-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3df0438..24bbf2c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -817,7 +817,7 @@ cpu_quiet(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
 
 	rnp = rdp->mynode;
 	spin_lock_irqsave(&rnp->lock, flags);
-	if (lastcomp != ACCESS_ONCE(rsp->completed)) {
+	if (lastcomp != rnp->completed) {
 
 		/*
 		 * Someone beat us to it for this grace period, so leave.
@@ -935,7 +935,6 @@ static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
 static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
-	long lastcomp;
 	unsigned long mask;
 	struct rcu_data *rdp = rsp->rda[cpu];
 	struct rcu_node *rnp;
@@ -971,7 +970,6 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 		rnp = rnp->parent;
 	} while (rnp != NULL);
-	lastcomp = rsp->completed;
 
 	spin_unlock_irqrestore(&rsp->onofflock, flags);
 
@@ -1145,7 +1143,7 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 	rcu_for_each_leaf_node(rsp, rnp) {
 		mask = 0;
 		spin_lock_irqsave(&rnp->lock, flags);
-		if (rsp->completed != lastcomp) {
+		if (rnp->completed != lastcomp) {
 			spin_unlock_irqrestore(&rnp->lock, flags);
 			return 1;
 		}
@@ -1159,7 +1157,7 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 			if ((rnp->qsmask & bit) != 0 && f(rsp->rda[cpu]))
 				mask |= bit;
 		}
-		if (mask != 0 && rsp->completed == lastcomp) {
+		if (mask != 0 && rnp->completed == lastcomp) {
 
 			/* cpu_quiet_msk() releases rnp->lock. */
 			cpu_quiet_msk(mask, rsp, rnp, flags);
@@ -1196,7 +1194,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	lastcomp = rsp->gpnum - 1;
 	signaled = rsp->signaled;
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
-	if (lastcomp == rsp->gpnum) {
+	if(!rcu_gp_in_progress(rsp)) {
 		rsp->n_force_qs_ngp++;
 		spin_unlock(&rnp->lock);
 		goto unlock_ret;  /* no GP in progress, time updated. */
@@ -1224,7 +1222,8 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		/* Update state, record completion counter. */
 		forcenow = 0;
 		spin_lock(&rnp->lock);
-		if (lastcomp == rsp->completed &&
+		if (lastcomp + 1 == rsp->gpnum &&
+		    lastcomp == rsp->completed &&
 		    rsp->signaled == signaled) {
 			rsp->signaled = RCU_FORCE_QS;
 			rsp->completed_fqs = lastcomp;
