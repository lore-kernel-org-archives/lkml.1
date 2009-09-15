Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbZIOHSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbZIOHSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 03:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758135AbZIOHSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 03:18:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:49516 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758175AbZIOHSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 03:18:31 -0400
Date: Tue, 15 Sep 2009 07:17:56 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, josh@joshtriplett.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, josh@joshtriplett.org,
       mingo@elte.hu
In-Reply-To: <12528585111945-git-send-email->
References: <12528585111945-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Simplify rcu_read_unlock_special() quiescent-state accounting
Message-ID: <tip-ddaad21c6848c599edc9432747a5295ea4d060df@git.kernel.org>
Git-Commit-ID: ddaad21c6848c599edc9432747a5295ea4d060df
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 07:17:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ddaad21c6848c599edc9432747a5295ea4d060df
Gitweb:     http://git.kernel.org/tip/ddaad21c6848c599edc9432747a5295ea4d060df
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sun, 13 Sep 2009 09:15:10 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 08:43:59 +0200

rcu: Simplify rcu_read_unlock_special() quiescent-state accounting

The earlier approach required two scheduling-clock ticks to note an
preemptable-RCU quiescent state in the situation in which the
scheduling-clock interrupt is unlucky enough to always interrupt an
RCU read-side critical section.

With this change, the quiescent state is instead noted by the
outermost rcu_read_unlock() immediately following the first
scheduling-clock tick, or, alternatively, by the first subsequent
context switch.  Therefore, this change also speeds up grace
periods.

Suggested-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
LKML-Reference: <12528585111945-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h   |    1 -
 kernel/rcutree.c        |   15 +++++-------
 kernel/rcutree_plugin.h |   54 ++++++++++++++++++++++------------------------
 3 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f3d74bd..c62a9f8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1740,7 +1740,6 @@ extern cputime_t task_gtime(struct task_struct *p);
 
 #define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
 #define RCU_READ_UNLOCK_NEED_QS (1 << 1) /* RCU core needs CPU response. */
-#define RCU_READ_UNLOCK_GOT_QS  (1 << 2) /* CPU has responded to RCU core. */
 
 static inline void rcu_copy_process(struct task_struct *p)
 {
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e9a4ae9..6c99553 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -107,27 +107,23 @@ static void __cpuinit rcu_init_percpu_data(int cpu, struct rcu_state *rsp,
  */
 void rcu_sched_qs(int cpu)
 {
-	unsigned long flags;
 	struct rcu_data *rdp;
 
-	local_irq_save(flags);
 	rdp = &per_cpu(rcu_sched_data, cpu);
-	rdp->passed_quiesc = 1;
 	rdp->passed_quiesc_completed = rdp->completed;
-	rcu_preempt_qs(cpu);
-	local_irq_restore(flags);
+	barrier();
+	rdp->passed_quiesc = 1;
+	rcu_preempt_note_context_switch(cpu);
 }
 
 void rcu_bh_qs(int cpu)
 {
-	unsigned long flags;
 	struct rcu_data *rdp;
 
-	local_irq_save(flags);
 	rdp = &per_cpu(rcu_bh_data, cpu);
-	rdp->passed_quiesc = 1;
 	rdp->passed_quiesc_completed = rdp->completed;
-	local_irq_restore(flags);
+	barrier();
+	rdp->passed_quiesc = 1;
 }
 
 #ifdef CONFIG_NO_HZ
@@ -615,6 +611,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 
 	/* Advance to a new grace period and initialize state. */
 	rsp->gpnum++;
+	WARN_ON_ONCE(rsp->signaled == RCU_GP_INIT);
 	rsp->signaled = RCU_GP_INIT; /* Hold off force_quiescent_state. */
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	record_gp_stall_check_time(rsp);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index b8e4b03..c9616e4 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -64,34 +64,42 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed);
  * not in a quiescent state.  There might be any number of tasks blocked
  * while in an RCU read-side critical section.
  */
-static void rcu_preempt_qs_record(int cpu)
+static void rcu_preempt_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
-	rdp->passed_quiesc = 1;
 	rdp->passed_quiesc_completed = rdp->completed;
+	barrier();
+	rdp->passed_quiesc = 1;
 }
 
 /*
- * We have entered the scheduler or are between softirqs in ksoftirqd.
- * If we are in an RCU read-side critical section, we need to reflect
- * that in the state of the rcu_node structure corresponding to this CPU.
- * Caller must disable hardirqs.
+ * We have entered the scheduler, and the current task might soon be
+ * context-switched away from.  If this task is in an RCU read-side
+ * critical section, we will no longer be able to rely on the CPU to
+ * record that fact, so we enqueue the task on the appropriate entry
+ * of the blocked_tasks[] array.  The task will dequeue itself when
+ * it exits the outermost enclosing RCU read-side critical section.
+ * Therefore, the current grace period cannot be permitted to complete
+ * until the blocked_tasks[] entry indexed by the low-order bit of
+ * rnp->gpnum empties.
+ *
+ * Caller must disable preemption.
  */
-static void rcu_preempt_qs(int cpu)
+static void rcu_preempt_note_context_switch(int cpu)
 {
 	struct task_struct *t = current;
+	unsigned long flags;
 	int phase;
 	struct rcu_data *rdp;
 	struct rcu_node *rnp;
 
 	if (t->rcu_read_lock_nesting &&
 	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
-		WARN_ON_ONCE(cpu != smp_processor_id());
 
 		/* Possibly blocking in an RCU read-side critical section. */
 		rdp = rcu_preempt_state.rda[cpu];
 		rnp = rdp->mynode;
-		spin_lock(&rnp->lock);
+		spin_lock_irqsave(&rnp->lock, flags);
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
 		t->rcu_blocked_node = rnp;
 
@@ -112,7 +120,7 @@ static void rcu_preempt_qs(int cpu)
 		phase = !(rnp->qsmask & rdp->grpmask) ^ (rnp->gpnum & 0x1);
 		list_add(&t->rcu_node_entry, &rnp->blocked_tasks[phase]);
 		smp_mb();  /* Ensure later ctxt swtch seen after above. */
-		spin_unlock(&rnp->lock);
+		spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 
 	/*
@@ -124,9 +132,8 @@ static void rcu_preempt_qs(int cpu)
 	 * grace period, then the fact that the task has been enqueued
 	 * means that we continue to block the current grace period.
 	 */
-	rcu_preempt_qs_record(cpu);
-	t->rcu_read_unlock_special &= ~(RCU_READ_UNLOCK_NEED_QS |
-					RCU_READ_UNLOCK_GOT_QS);
+	rcu_preempt_qs(cpu);
+	t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
 }
 
 /*
@@ -162,7 +169,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 	special = t->rcu_read_unlock_special;
 	if (special & RCU_READ_UNLOCK_NEED_QS) {
 		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
-		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_GOT_QS;
+		rcu_preempt_qs(smp_processor_id());
 	}
 
 	/* Hardware IRQ handlers cannot block. */
@@ -199,9 +206,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		 */
 		if (!empty && rnp->qsmask == 0 &&
 		    list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1])) {
-			t->rcu_read_unlock_special &=
-				~(RCU_READ_UNLOCK_NEED_QS |
-				  RCU_READ_UNLOCK_GOT_QS);
+			t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
 			if (rnp->parent == NULL) {
 				/* Only one rcu_node in the tree. */
 				cpu_quiet_msk_finish(&rcu_preempt_state, flags);
@@ -352,19 +357,12 @@ static void rcu_preempt_check_callbacks(int cpu)
 	struct task_struct *t = current;
 
 	if (t->rcu_read_lock_nesting == 0) {
-		t->rcu_read_unlock_special &=
-			~(RCU_READ_UNLOCK_NEED_QS | RCU_READ_UNLOCK_GOT_QS);
-		rcu_preempt_qs_record(cpu);
+		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
+		rcu_preempt_qs(cpu);
 		return;
 	}
 	if (per_cpu(rcu_preempt_data, cpu).qs_pending) {
-		if (t->rcu_read_unlock_special & RCU_READ_UNLOCK_GOT_QS) {
-			rcu_preempt_qs_record(cpu);
-			t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_GOT_QS;
-		} else if (!(t->rcu_read_unlock_special &
-			     RCU_READ_UNLOCK_NEED_QS)) {
-			t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
-		}
+		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
 	}
 }
 
@@ -451,7 +449,7 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed);
  * Because preemptable RCU does not exist, we never have to check for
  * CPUs being in quiescent states.
  */
-static void rcu_preempt_qs(int cpu)
+static void rcu_preempt_note_context_switch(int cpu)
 {
 }
 
