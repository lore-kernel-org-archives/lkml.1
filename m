Return-Path: <linux-kernel-owner+w=401wt.eu-S932902AbXJQTIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902AbXJQTIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbXJQTE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:04:59 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53176
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759260AbXJQTE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:04:57 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 7/9] RT: Add support for low-priority wake-up to push_rt
	feature
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>
Date: Wed, 17 Oct 2007 14:51:03 -0400
Message-ID: <20071017185102.11272.9240.stgit@novell1.haskins.net>
In-Reply-To: <20071017184745.11272.10024.stgit@novell1.haskins.net>
References: <20071017184745.11272.10024.stgit@novell1.haskins.net>
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

 kernel/sched.c |   88 ++++++++++++++++++++++++++------------------------------
 1 files changed, 41 insertions(+), 47 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d604484..0ee1e21 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1628,6 +1628,13 @@ out:
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
@@ -1988,6 +1995,25 @@ out_set_cpu:
 		this_cpu = smp_processor_id();
 		cpu = task_cpu(p);
 	}
+	
+#if defined(CONFIG_PREEMPT_RT)
+	/*
+	 * If a newly woken up RT task cannot preempt the
+	 * current (RT) task (on a target runqueue) then try
+	 * to find another CPU it can preempt:
+	 */
+	if (rt_task(p) && !TASK_PREEMPTS_CURR(p, rq)) {
+		struct rq *lowest_rq = find_lock_lowest_rq(p, rq);
+		if (lowest_rq) {
+			set_task_cpu(p, lowest_rq->cpu);
+			spin_unlock(&rq->lock);
+
+			/* The new lock was already acquired in find_lowest */ 
+			rq  = lowest_rq;
+			cpu = task_cpu(p);
+		}
+	}
+#endif /* defined(CONFIG_PREEMPT_RT) */
 
 out_activate:
 #endif /* CONFIG_SMP */
@@ -1997,51 +2023,20 @@ out_activate:
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
 
@@ -2358,13 +2353,12 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
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
 	trace_stop_sched_switched(current);

