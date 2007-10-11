Return-Path: <linux-kernel-owner+w=401wt.eu-S1759743AbXJKWPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbXJKWPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 18:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbXJKWNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 18:13:43 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:45373
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759224AbXJKWNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 18:13:41 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 7/7] RT: push-rt enhancements
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>
Date: Thu, 11 Oct 2007 18:00:20 -0400
Message-ID: <20071011220020.27097.83928.stgit@novell1.haskins.net>
In-Reply-To: <20071011213916.27097.42597.stgit@novell1.haskins.net>
References: <20071011213916.27097.42597.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are three events that require consideration for redistributing RT tasks:

1) When one or more higher-priority tasks preempts a lower-one from a RQ
2) When a lower-priority task is woken up on a RQ
3) When a RQ downgrades its current priority

Steve Rostedt's push_rt patch addresses (1).  It hooks in right after a new
task has been switched-in.  If this was the result of an RT preemption, or if
more than one task was awoken at the same time, we can try to push some of
those other tasks away.

This patch addresses (2).  When we wake up a task, we check to see if it would
preempt the current task on the queue.  If it will not, we attempt to find a
better suited CPU (e.g. one running something lower priority than the task
being woken) and try to activate the task there.

Finally, we have (3).  In theory, we only need to balance_rt_tasks() if the
following conditions are met:
   1) One or more CPUs are in overload, AND
   2) We are about to switch to a task that lowers our priority.

(3) will be addressed in a later patch.

In addtion, this patch also enhances the behavior of the push_rt feature such
that it will try to drain as many tasks as it can until there are no more
tasks, or equilibrium is achieved.  The orignal logic only tried to push one
task per event.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |   69 ++++++++++++++++++++++++++++++++++----------------------
 1 files changed, 42 insertions(+), 27 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e8942c5..8a94a07 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1636,6 +1636,12 @@ static int push_rt_task(struct rq *this_rq)
 	return ret;
 }
 
+/* Push all tasks that we can to other CPUs */
+static void push_rt_tasks(struct rq *this_rq)
+{
+	while (push_rt_task(this_rq));
+}
+
 /*
  * Pull RT tasks from other CPUs in the RT-overload
  * case. Interrupts are disabled, local rq is locked.
@@ -1996,7 +2002,31 @@ out_set_cpu:
 		this_cpu = smp_processor_id();
 		cpu = task_cpu(p);
 	}
-
+	
+	/*
+	 * If a newly woken up RT task cannot preempt the
+	 * current (RT) task (on a target runqueue) then try
+	 * to find another CPU it can preempt:
+	 */
+	if (rt_task(p) && !TASK_PREEMPTS_CURR(p, rq)) {
+		int pri = calc_task_cpupri(rq, p);
+
+		new_cpu = find_lowest_cpu(rq->cpu, pri, p);
+		if (new_cpu != cpu) {
+			set_task_cpu(p, new_cpu);
+			task_rq_unlock(rq, &flags);
+			/* might preempt at this point */
+			rq = task_rq_lock(p, &flags);
+			old_state = p->state;
+			if (!(old_state & state))
+				goto out;
+			if (p->se.on_rq)
+				goto out_running;
+			
+			this_cpu = smp_processor_id();
+			cpu = task_cpu(p);
+		}
+	}
 out_activate:
 #endif /* CONFIG_SMP */
 	update_rq_clock(rq);
@@ -2010,30 +2040,13 @@ out_activate:
 	 * to find another CPU it can preempt:
 	 */
 	if (rt_task(p) && !TASK_PREEMPTS_CURR(p, rq)) {
-		struct rq *this_rq = cpu_rq(this_cpu);
 		/*
-		 * Special-case: the task on this CPU can be
-		 * preempted. In that case there's no need to
-		 * trigger reschedules on other CPUs, we can
-		 * mark the current task for reschedule.
-		 *
-		 * (Note that it's safe to access this_rq without
-		 * extra locking in this particular case, because
-		 * we are on the current CPU.)
+		 * FIXME: Do we still need to do this here anymore, or
+		 * does the preemption-check above suffice.  The path
+		 * that makes my head hurt is when we have the
+		 * task_running->out_activate path
 		 */
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
+		push_rt_tasks(rq);
 	} else {
 		/*
 		 * Sync wakeups (i.e. those types of wakeups where the waker
@@ -2357,12 +2370,14 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 */
 #if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
 	/*
-	 * If we pushed an RT task off the runqueue,
-	 * then kick other CPUs, they might run it:
+	 * If there are more than one RT tasks pending, try to push some off
+	 * to other lower-pri CPUs
+	 *
+	 * This covers the case where a high-pri has preempted a lower-pri
+	 * or if multiple RTs are awoken at the same time.
 	 */
-
 	if (unlikely(rq->rt_nr_running > 1))
-		push_rt_task(rq);
+		push_rt_tasks(rq);
 
 #endif
 	prev_state = prev->state;

