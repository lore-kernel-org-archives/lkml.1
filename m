Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476Ab0AMK1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab0AMK1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464Ab0AMK1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:27:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:58657 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407Ab0AMK1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:27:13 -0500
Date: Wed, 13 Jan 2010 10:26:40 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12626465501781-git-send-email->
References: <12626465501781-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Remove leg of force_quiescent_state() switch statement
Message-ID: <tip-ee47eb9f4da6f44af965d6d049e77ee8c8a4b822@git.kernel.org>
Git-Commit-ID: ee47eb9f4da6f44af965d6d049e77ee8c8a4b822
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:26:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee47eb9f4da6f44af965d6d049e77ee8c8a4b822
Gitweb:     http://git.kernel.org/tip/ee47eb9f4da6f44af965d6d049e77ee8c8a4b822
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 4 Jan 2010 15:09:07 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:06:04 +0100

rcu: Remove leg of force_quiescent_state() switch statement

The comparisons of rsp->gpnum nad rsp->completed in
rcu_process_dyntick() and force_quiescent_state() can be
replaced by the much more clear rcu_gp_in_progress() predicate
function.  After doing this, it becomes clear that the
RCU_SAVE_COMPLETED leg of the force_quiescent_state() function's
switch statement is almost completely a no-op.  A small change
to the RCU_SAVE_DYNTICK leg renders it a complete no-op, after
which it can be removed.  Doing so also eliminates the forcenow
local variable from force_quiescent_state().

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
LKML-Reference: <12626465501781-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |   22 +++++-----------------
 kernel/rcutree.h |    5 ++---
 2 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e497119..6268f37 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1144,6 +1144,7 @@ void rcu_check_callbacks(int cpu, int user)
 /*
  * Scan the leaf rcu_node structures, processing dyntick state for any that
  * have not yet encountered a quiescent state, using the function specified.
+ * The caller must have suppressed start of new grace periods.
  */
 static void rcu_process_dyntick(struct rcu_state *rsp,
 				int (*f)(struct rcu_data *))
@@ -1157,7 +1158,7 @@ static void rcu_process_dyntick(struct rcu_state *rsp,
 	rcu_for_each_leaf_node(rsp, rnp) {
 		mask = 0;
 		spin_lock_irqsave(&rnp->lock, flags);
-		if (rnp->completed != rsp->gpnum - 1) {
+		if (!rcu_gp_in_progress(rsp)) {
 			spin_unlock_irqrestore(&rnp->lock, flags);
 			return;
 		}
@@ -1171,7 +1172,7 @@ static void rcu_process_dyntick(struct rcu_state *rsp,
 			if ((rnp->qsmask & bit) != 0 && f(rsp->rda[cpu]))
 				mask |= bit;
 		}
-		if (mask != 0 && rnp->completed == rsp->gpnum - 1) {
+		if (mask != 0 && rcu_gp_in_progress(rsp)) {
 
 			/* rcu_report_qs_rnp() releases rnp->lock. */
 			rcu_report_qs_rnp(mask, rsp, rnp, flags);
@@ -1189,7 +1190,6 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 {
 	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root(rsp);
-	u8 forcenow;
 
 	if (!rcu_gp_in_progress(rsp))
 		return;  /* No grace period in progress, nothing to force. */
@@ -1224,21 +1224,9 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		/* Record dyntick-idle state. */
 		rcu_process_dyntick(rsp, dyntick_save_progress_counter);
 		spin_lock(&rnp->lock);  /* irqs already disabled */
-		if (!rcu_gp_in_progress(rsp))
-			break;
-		/* fall into next case. */
-
-	case RCU_SAVE_COMPLETED:
-
-		/* Update state, record completion counter. */
-		forcenow = 0;
-		if (rsp->gpnum - 1 == rsp->completed) {
-			forcenow = rsp->signaled == RCU_SAVE_COMPLETED;
+		if (rcu_gp_in_progress(rsp))
 			rsp->signaled = RCU_FORCE_QS;
-		}
-		if (!forcenow)
-			break;
-		/* fall into next case. */
+		break;
 
 	case RCU_FORCE_QS:
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 5348561..edb6fae 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -237,12 +237,11 @@ struct rcu_data {
 #define RCU_GP_IDLE		0	/* No grace period in progress. */
 #define RCU_GP_INIT		1	/* Grace period being initialized. */
 #define RCU_SAVE_DYNTICK	2	/* Need to scan dyntick state. */
-#define RCU_SAVE_COMPLETED	3	/* Need to save rsp->completed. */
-#define RCU_FORCE_QS		4	/* Need to force quiescent state. */
+#define RCU_FORCE_QS		3	/* Need to force quiescent state. */
 #ifdef CONFIG_NO_HZ
 #define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
 #else /* #ifdef CONFIG_NO_HZ */
-#define RCU_SIGNAL_INIT		RCU_SAVE_COMPLETED
+#define RCU_SIGNAL_INIT		RCU_FORCE_QS
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
 #define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
