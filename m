Return-Path: <linux-kernel-owner+w=401wt.eu-S1759714AbXJXOJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714AbXJXOJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759124AbXJXOHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:07:54 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:49117
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759043AbXJXOHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:07:50 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 7/9] RT: Add support for low-priority wake-up to push_rt
	feature
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Wed, 24 Oct 2007 09:53:09 -0400
Message-ID: <20071024135309.7960.25431.stgit@novell1.haskins.net>
In-Reply-To: <20071024134431.7960.41984.stgit@novell1.haskins.net>
References: <20071024134431.7960.41984.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are three events that require consideration for redistributing RT
tasks:

1) When one or more higher-priority tasks preempts a lower-one from a
   RQ
2) When a lower-priority task is woken up on a RQ
3) When a RQ downgrades its current priority

Steve Rostedt's push_rt patch addresses (1).  It hooks in right after
a new task has been switched-in.  If this was the result of an RT
preemption, or if more than one task was awoken at the same time, we
can try to push some of those other tasks away.

This patch addresses (2).  When we wake up a task, we check to see
if it would preempt the current task on the queue.  If it will not, we
attempt to find a better suited CPU (e.g. one running something lower
priority than the task being woken) and try to activate the task there.

Finally, we have (3).  In theory, we only need to balance_rt_tasks() if
the following conditions are met:
   1) One or more CPUs are in overload, AND
   2) We are about to switch to a task that lowers our priority.

(3) will be addressed in a later patch.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |  109 ++++++++++++++++++++++++++++++++------------------------
 1 files changed, 62 insertions(+), 47 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9e5cc2c..6cc4389 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1636,6 +1636,13 @@ out:
 	return ret;
 }
 
+/* Push all tasks that we can to other CPUs */
+static void push_rt_tasks(struct rq *this_rq)
+{
+	while (push_rt_task(this_rq))
+		;
+}
+
 /*
  * Pull RT tasks from other CPUs in the RT-overload
  * case. Interrupts are disabled, local rq is locked.
@@ -1996,6 +2003,46 @@ out_set_cpu:
 		this_cpu = smp_processor_id();
 		cpu = task_cpu(p);
 	}
+	
+#if defined(CONFIG_PREEMPT_RT)
+       /*
+        * If a newly woken up RT task will not run immediately on its affined
+        * RQ, try to find another CPU it can preempt:
+        */
+	if (rt_task(p) && (p->prio >= rq->highest_prio)) {
+		struct rq *lowest_rq = find_lock_lowest_rq(p, rq);
+
+		if (lowest_rq) {
+			/*
+			 * We may have dropped this_rq->lock, so check to be
+			 * sure we are still eligible to wake up this task
+			 * somewhere...
+			 *
+			 * Basically the task could already be running on this
+			 * RQ, or it could have already migrated away to a
+			 * different RQ. 
+			 */
+			if (!task_running(rq, p) && (task_rq(p) == rq)) {
+				set_task_cpu(p, lowest_rq->cpu);
+				spin_unlock(&rq->lock);
+
+				/*
+				 * The new lock was already acquired in
+				 * find_lowest
+				 */ 
+				rq  = lowest_rq;
+				cpu = task_cpu(p);
+			} else
+				spin_unlock(&lowest_rq->lock);
+		}
+
+		old_state = p->state;
+		if (!(old_state & state))
+			goto out;
+		if (p->se.on_rq)
+			goto out_running;
+	}
+#endif /* defined(CONFIG_PREEMPT_RT) */
 
 out_activate:
 #endif /* CONFIG_SMP */
@@ -2005,51 +2052,20 @@ out_activate:
 	trace_start_sched_wakeup(p, rq);
 
 	/*
-	 * If a newly woken up RT task cannot preempt the
-	 * current (RT) task (on a target runqueue) then try
-	 * to find another CPU it can preempt:
+	 * Sync wakeups (i.e. those types of wakeups where the waker
+	 * has indicated that it will leave the CPU in short order)
+	 * don't trigger a preemption, if the woken up task will run on
+	 * this cpu. (in this case the 'I will reschedule' promise of
+	 * the waker guarantees that the freshly woken up task is going
+	 * to be considered on this CPU.)
 	 */
-	if (rt_task(p) && !TASK_PREEMPTS_CURR(p, rq)) {
-		struct rq *this_rq = cpu_rq(this_cpu);
-		/*
-		 * Special-case: the task on this CPU can be
-		 * preempted. In that case there's no need to
-		 * trigger reschedules on other CPUs, we can
-		 * mark the current task for reschedule.
-		 *
-		 * (Note that it's safe to access this_rq without
-		 * extra locking in this particular case, because
-		 * we are on the current CPU.)
-		 */
-		if (TASK_PREEMPTS_CURR(p, this_rq))
-			set_tsk_need_resched(this_rq->curr);
-		else
-			/*
-			 * Neither the intended target runqueue
-			 * nor the current CPU can take this task.
-			 * Trigger a reschedule on all other CPUs
-			 * nevertheless, maybe one of them can take
-			 * this task:
-			 */
-			smp_send_reschedule_allbutself_cpumask(p->cpus_allowed);
-
-		schedstat_inc(this_rq, rto_wakeup);
-	} else {
-		/*
-		 * Sync wakeups (i.e. those types of wakeups where the waker
-		 * has indicated that it will leave the CPU in short order)
-		 * don't trigger a preemption, if the woken up task will run on
-		 * this cpu. (in this case the 'I will reschedule' promise of
-		 * the waker guarantees that the freshly woken up task is going
-		 * to be considered on this CPU.)
-		 */
-		if (!sync || cpu != this_cpu)
-			check_preempt_curr(rq, p);
-		else {
-			if (TASK_PREEMPTS_CURR(p, rq))
-				set_tsk_need_resched_delayed(rq->curr);
-		}
+	if (!sync || cpu != this_cpu)
+		check_preempt_curr(rq, p);
+	else {
+		if (TASK_PREEMPTS_CURR(p, rq))
+			set_tsk_need_resched_delayed(rq->curr);
 	}
+
 	if (rq->curr && p && rq && _need_resched())
 		trace_special_pid(p->pid, PRIO(p), PRIO(rq->curr));
 
@@ -2366,13 +2382,12 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 * the lock was owned by prev, we need to release it
 	 * first via finish_lock_switch and then reaquire it.
 	 */
-	if (unlikely(rt_task(current))) {
+	if (unlikely(rq->rt_nr_running > 1)) {
 		spin_lock(&rq->lock);
-		/* push_rt_task will return true if it moved an RT */
-		while (push_rt_task(rq))
-			;
+		push_rt_tasks(rq);
 		spin_unlock(&rq->lock);
 	}
+
 #endif
 
 	fire_sched_in_preempt_notifiers(current);

