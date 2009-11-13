Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbZKMJbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbZKMJbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZKMJbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:31:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:53304 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbZKMJbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:31:42 -0500
Date: Fri, 13 Nov 2009 09:31:25 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12580941042308-git-send-email->
References: <12580941042308-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Simplify association of forced quiescent states with grace periods
Message-ID: <tip-8e9aa8f067d2dcd9457980ced618e1cffbcfba46@git.kernel.org>
Git-Commit-ID: 8e9aa8f067d2dcd9457980ced618e1cffbcfba46
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e9aa8f067d2dcd9457980ced618e1cffbcfba46
Gitweb:     http://git.kernel.org/tip/8e9aa8f067d2dcd9457980ced618e1cffbcfba46
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Thu, 12 Nov 2009 22:35:04 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Nov 2009 10:18:36 +0100

rcu: Simplify association of forced quiescent states with grace periods

The force_quiescent_state() function also took a snapshot
of the ->completed field, which was as obnoxious as it was in
rcu_sched_qs() and friends.  So snapshot ->gpnum-1.

Also, since the dyntick_record_completed() and
dyntick_recall_completed() functions are now simple assignments
that are independent of CONFIG_NO_HZ, and since their names are
now misleading, get rid of them.

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
LKML-Reference: <12580941042308-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |   27 +++------------------------
 1 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b4efb9e..3df0438 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -178,29 +178,9 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
 	return &rsp->node[0];
 }
 
-/*
- * Record the specified "completed" value, which is later used to validate
- * dynticks counter manipulations and CPU-offline checks.  Specify
- * "rsp->completed - 1" to unconditionally invalidate any future dynticks
- * manipulations and CPU-offline checks.  Such invalidation is useful at
- * the beginning of a grace period.
- */
-static void dyntick_record_completed(struct rcu_state *rsp, long comp)
-{
-	rsp->completed_fqs = comp;
-}
-
 #ifdef CONFIG_SMP
 
 /*
- * Recall the previously recorded value of the completion for dynticks.
- */
-static long dyntick_recall_completed(struct rcu_state *rsp)
-{
-	return rsp->completed_fqs;
-}
-
-/*
  * If the specified CPU is offline, tell the caller that it is in
  * a quiescent state.  Otherwise, whack it with a reschedule IPI.
  * Grace periods can end up waiting on an offline CPU when that
@@ -702,7 +682,6 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	rsp->signaled = RCU_GP_INIT; /* Hold off force_quiescent_state. */
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	record_gp_stall_check_time(rsp);
-	dyntick_record_completed(rsp, rsp->completed - 1);
 
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {
@@ -1214,7 +1193,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		goto unlock_ret; /* no emergency and done recently. */
 	rsp->n_force_qs++;
 	spin_lock(&rnp->lock);
-	lastcomp = rsp->completed;
+	lastcomp = rsp->gpnum - 1;
 	signaled = rsp->signaled;
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	if (lastcomp == rsp->gpnum) {
@@ -1248,7 +1227,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		if (lastcomp == rsp->completed &&
 		    rsp->signaled == signaled) {
 			rsp->signaled = RCU_FORCE_QS;
-			dyntick_record_completed(rsp, lastcomp);
+			rsp->completed_fqs = lastcomp;
 			forcenow = signaled == RCU_SAVE_COMPLETED;
 		}
 		spin_unlock(&rnp->lock);
@@ -1259,7 +1238,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	case RCU_FORCE_QS:
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
-		if (rcu_process_dyntick(rsp, dyntick_recall_completed(rsp),
+		if (rcu_process_dyntick(rsp, rsp->completed_fqs,
 					rcu_implicit_dynticks_qs))
 			goto unlock_ret;
 
