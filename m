Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbZKDIwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbZKDIwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 03:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZKDIwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 03:52:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:50500 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbZKDIwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 03:52:19 -0500
Date: Wed, 4 Nov 2009 08:51:42 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12571987491353-git-send-email->
References: <12571987491353-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Prepare for synchronization fixes: clean up for non-NO_HZ handling of ->completed counter
Message-ID: <tip-1d4b3f1a99f9a56fb8bdfd215ef5d827efb26fb5@git.kernel.org>
Git-Commit-ID: 1d4b3f1a99f9a56fb8bdfd215ef5d827efb26fb5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d4b3f1a99f9a56fb8bdfd215ef5d827efb26fb5
Gitweb:     http://git.kernel.org/tip/1d4b3f1a99f9a56fb8bdfd215ef5d827efb26fb5
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 2 Nov 2009 13:52:27 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 09:43:57 +0100

rcu: Prepare for synchronization fixes: clean up for non-NO_HZ handling of ->completed counter

Impose a clear locking design on non-NO_HZ handling of the
->completed counter.  This increases the distance between the
RCU and the CPU-hotplug mechanisms.

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
LKML-Reference: <12571987491353-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |   67 ++++++++++++++++++++++++-----------------------------
 kernel/rcutree.h |    8 +++---
 2 files changed, 34 insertions(+), 41 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f3077c0..bd3ee48 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -176,9 +176,29 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
 	return &rsp->node[0];
 }
 
+/*
+ * Record the specified "completed" value, which is later used to validate
+ * dynticks counter manipulations and CPU-offline checks.  Specify
+ * "rsp->completed - 1" to unconditionally invalidate any future dynticks
+ * manipulations and CPU-offline checks.  Such invalidation is useful at
+ * the beginning of a grace period.
+ */
+static void dyntick_record_completed(struct rcu_state *rsp, long comp)
+{
+	rsp->dynticks_completed = comp;
+}
+
 #ifdef CONFIG_SMP
 
 /*
+ * Recall the previously recorded value of the completion for dynticks.
+ */
+static long dyntick_recall_completed(struct rcu_state *rsp)
+{
+	return rsp->dynticks_completed;
+}
+
+/*
  * If the specified CPU is offline, tell the caller that it is in
  * a quiescent state.  Otherwise, whack it with a reschedule IPI.
  * Grace periods can end up waiting on an offline CPU when that
@@ -335,28 +355,9 @@ void rcu_irq_exit(void)
 		set_need_resched();
 }
 
-/*
- * Record the specified "completed" value, which is later used to validate
- * dynticks counter manipulations.  Specify "rsp->completed - 1" to
- * unconditionally invalidate any future dynticks manipulations (which is
- * useful at the beginning of a grace period).
- */
-static void dyntick_record_completed(struct rcu_state *rsp, long comp)
-{
-	rsp->dynticks_completed = comp;
-}
-
 #ifdef CONFIG_SMP
 
 /*
- * Recall the previously recorded value of the completion for dynticks.
- */
-static long dyntick_recall_completed(struct rcu_state *rsp)
-{
-	return rsp->dynticks_completed;
-}
-
-/*
  * Snapshot the specified CPU's dynticks counter so that we can later
  * credit them with an implicit quiescent state.  Return 1 if this CPU
  * is in dynticks idle mode, which is an extended quiescent state.
@@ -419,24 +420,8 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 
 #else /* #ifdef CONFIG_NO_HZ */
 
-static void dyntick_record_completed(struct rcu_state *rsp, long comp)
-{
-}
-
 #ifdef CONFIG_SMP
 
-/*
- * If there are no dynticks, then the only way that a CPU can passively
- * be in a quiescent state is to be offline.  Unlike dynticks idle, which
- * is a point in time during the prior (already finished) grace period,
- * an offline CPU is always in a quiescent state, and thus can be
- * unconditionally applied.  So just return the current value of completed.
- */
-static long dyntick_recall_completed(struct rcu_state *rsp)
-{
-	return rsp->completed;
-}
-
 static int dyntick_save_progress_counter(struct rcu_data *rdp)
 {
 	return 0;
@@ -1144,6 +1129,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	long lastcomp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 	u8 signaled;
+	u8 forcenow;
 
 	if (!rcu_gp_in_progress(rsp))
 		return;  /* No grace period in progress, nothing to force. */
@@ -1180,16 +1166,23 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		if (rcu_process_dyntick(rsp, lastcomp,
 					dyntick_save_progress_counter))
 			goto unlock_ret;
+		/* fall into next case. */
+
+	case RCU_SAVE_COMPLETED:
 
 		/* Update state, record completion counter. */
+		forcenow = 0;
 		spin_lock(&rnp->lock);
 		if (lastcomp == rsp->completed &&
-		    rsp->signaled == RCU_SAVE_DYNTICK) {
+		    rsp->signaled == signaled) {
 			rsp->signaled = RCU_FORCE_QS;
 			dyntick_record_completed(rsp, lastcomp);
+			forcenow = signaled == RCU_SAVE_COMPLETED;
 		}
 		spin_unlock(&rnp->lock);
-		break;
+		if (!forcenow)
+			break;
+		/* fall into next case. */
 
 	case RCU_FORCE_QS:
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 1899023..8a4c165 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -204,11 +204,12 @@ struct rcu_data {
 #define RCU_GP_IDLE		0	/* No grace period in progress. */
 #define RCU_GP_INIT		1	/* Grace period being initialized. */
 #define RCU_SAVE_DYNTICK	2	/* Need to scan dyntick state. */
-#define RCU_FORCE_QS		3	/* Need to force quiescent state. */
+#define RCU_SAVE_COMPLETED	3	/* Need to save rsp->completed. */
+#define RCU_FORCE_QS		4	/* Need to force quiescent state. */
 #ifdef CONFIG_NO_HZ
 #define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
 #else /* #ifdef CONFIG_NO_HZ */
-#define RCU_SIGNAL_INIT		RCU_FORCE_QS
+#define RCU_SIGNAL_INIT		RCU_SAVE_COMPLETED
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
 #define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
@@ -274,9 +275,8 @@ struct rcu_state {
 	unsigned long jiffies_stall;		/* Time at which to check */
 						/*  for CPU stalls. */
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-#ifdef CONFIG_NO_HZ
 	long dynticks_completed;		/* Value of completed @ snap. */
-#endif /* #ifdef CONFIG_NO_HZ */
+						/*  Protected by fqslock. */
 };
 
 #ifdef RCU_TREE_NONCORE
