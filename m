Return-Path: <linux-kernel-owner+w=401wt.eu-S935241AbZJOSin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935241AbZJOSin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 14:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933788AbZJOSin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 14:38:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:60937 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932867AbZJOSim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 14:38:42 -0400
Date: Thu, 15 Oct 2009 18:37:13 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091015162614.GA19131@linux.vnet.ibm.com>
References: <20091015162614.GA19131@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Fix TREE_PREEMPT_RCU CPU_HOTPLUG bad-luck hang
Message-ID: <tip-237c80c5c8fb7ec128cf2a756b550dc41ad7eac7@git.kernel.org>
Git-Commit-ID: 237c80c5c8fb7ec128cf2a756b550dc41ad7eac7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 18:37:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  237c80c5c8fb7ec128cf2a756b550dc41ad7eac7
Gitweb:     http://git.kernel.org/tip/237c80c5c8fb7ec128cf2a756b550dc41ad7eac7
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Thu, 15 Oct 2009 09:26:14 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 20:33:01 +0200

rcu: Fix TREE_PREEMPT_RCU CPU_HOTPLUG bad-luck hang

If the following sequence of events occurs, then
TREE_PREEMPT_RCU will hang waiting for a grace period to
complete, eventually OOMing the system:

o	A TREE_PREEMPT_RCU build of the kernel is booted on a system
	with more than 64 physical CPUs present (32 on a 32-bit system).
	Alternatively, a TREE_PREEMPT_RCU build of the kernel is booted
	with RCU_FANOUT set to a sufficiently small value that the
	physical CPUs populate two or more leaf rcu_node structures.

o	A task is preempted in an RCU read-side critical section
	while running on a CPU corresponding to a given leaf rcu_node
	structure.

o	All CPUs corresponding to this same leaf rcu_node structure
	record quiescent states for the current grace period.

o	All of these same CPUs go offline (hence the need for enough
	physical CPUs to populate more than one leaf rcu_node structure).
	This causes the preempted task to be moved to the root rcu_node
	structure.

At this point, there is nothing left to cause the quiescent
state to be propagated up the rcu_node tree, so the current
grace period never completes.

The simplest fix, especially after considering the deadlock
possibilities, is to detect this situation when the last CPU is
offlined, and to set that CPU's ->qsmask bit in its leaf
rcu_node structure.  This will cause the next invocation of
force_quiescent_state() to end the grace period.

Without this fix, this hang can be triggered in an hour or so on
some machines with rcutorture and random CPU onlining/offlining.
With this fix, these same machines pass a full 10 hours of this
sort of abuse.

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
LKML-Reference: <20091015162614.GA19131@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c        |   15 ++++++++++++++-
 kernel/rcutree.h        |    6 +++---
 kernel/rcutree_plugin.h |   25 +++++++++++++++++--------
 3 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ddbf111..0536125 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -913,7 +913,20 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 			spin_unlock(&rnp->lock); /* irqs remain disabled. */
 			break;
 		}
-		rcu_preempt_offline_tasks(rsp, rnp, rdp);
+
+		/*
+		 * If there was a task blocking the current grace period,
+		 * and if all CPUs have checked in, we need to propagate
+		 * the quiescent state up the rcu_node hierarchy.  But that
+		 * is inconvenient at the moment due to deadlock issues if
+		 * this should end the current grace period.  So set the
+		 * offlined CPU's bit in ->qsmask in order to force the
+		 * next force_quiescent_state() invocation to clean up this
+		 * mess in a deadlock-free manner.
+		 */
+		if (rcu_preempt_offline_tasks(rsp, rnp, rdp) && !rnp->qsmask)
+			rnp->qsmask |= mask;
+
 		mask = rnp->grpmask;
 		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 		rnp = rnp->parent;
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 599161f..1823c6e 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -306,9 +306,9 @@ static void rcu_print_task_stall(struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
-static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
-				      struct rcu_node *rnp,
-				      struct rcu_data *rdp);
+static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
+				     struct rcu_node *rnp,
+				     struct rcu_data *rdp);
 static void rcu_preempt_offline_cpu(int cpu);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 static void rcu_preempt_check_callbacks(int cpu);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index ebd20ee..ef2a58c 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -304,21 +304,25 @@ static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
  * parent is to remove the need for rcu_read_unlock_special() to
  * make more than two attempts to acquire the target rcu_node's lock.
  *
+ * Returns 1 if there was previously a task blocking the current grace
+ * period on the specified rcu_node structure.
+ *
  * The caller must hold rnp->lock with irqs disabled.
  */
-static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
-				      struct rcu_node *rnp,
-				      struct rcu_data *rdp)
+static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
+				     struct rcu_node *rnp,
+				     struct rcu_data *rdp)
 {
 	int i;
 	struct list_head *lp;
 	struct list_head *lp_root;
+	int retval = rcu_preempted_readers(rnp);
 	struct rcu_node *rnp_root = rcu_get_root(rsp);
 	struct task_struct *tp;
 
 	if (rnp == rnp_root) {
 		WARN_ONCE(1, "Last CPU thought to be offlined?");
-		return;  /* Shouldn't happen: at least one CPU online. */
+		return 0;  /* Shouldn't happen: at least one CPU online. */
 	}
 	WARN_ON_ONCE(rnp != rdp->mynode &&
 		     (!list_empty(&rnp->blocked_tasks[0]) ||
@@ -342,6 +346,8 @@ static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
 			spin_unlock(&rnp_root->lock); /* irqs remain disabled */
 		}
 	}
+
+	return retval;
 }
 
 /*
@@ -532,12 +538,15 @@ static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 
 /*
  * Because preemptable RCU does not exist, it never needs to migrate
- * tasks that were blocked within RCU read-side critical sections.
+ * tasks that were blocked within RCU read-side critical sections, and
+ * such non-existent tasks cannot possibly have been blocking the current
+ * grace period.
  */
-static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
-				      struct rcu_node *rnp,
-				      struct rcu_data *rdp)
+static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
+				     struct rcu_node *rnp,
+				     struct rcu_data *rdp)
 {
+	return 0;
 }
 
 /*
