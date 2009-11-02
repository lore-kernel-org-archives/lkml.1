Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbZKBVwc (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 2 Nov 2009 16:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbZKBVwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:52:31 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34120 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811AbZKBVwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:52:30 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/3] rcu: cleanups for non-NO_HZ handling of ->completed counter.
Date: Mon,  2 Nov 2009 13:52:27 -0800
Message-Id: <12571987491353-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091102215147.GA9704@linux.vnet.ibm.com>
References: <20091102215147.GA9704@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Imposes a clear locking design on non-NO_HZ handling of the ->completed
counter.  This increases the distance between the RCU and the CPU-hotplug
mechanisms.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   67 ++++++++++++++++++++++++-----------------------------
 kernel/rcutree.h |    8 +++---
 2 files changed, 34 insertions(+), 41 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0d9faee..154f4f1 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -178,9 +178,29 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
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
@@ -337,28 +357,9 @@ void rcu_irq_exit(void)
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
@@ -421,24 +422,8 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 
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
@@ -1133,6 +1118,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	long lastcomp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 	u8 signaled;
+	u8 forcenow;
 
 	if (!rcu_gp_in_progress(rsp))
 		return;  /* No grace period in progress, nothing to force. */
@@ -1169,16 +1155,23 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
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
index e1bc649..39c325d 100644
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
-- 
1.5.2.5

