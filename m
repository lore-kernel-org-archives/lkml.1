Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbXJKWNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbXJKWNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 18:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756126AbXJKWNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 18:13:13 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:45342
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754915AbXJKWNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 18:13:10 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/7] RT: Push waiting rt tasks
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>
Date: Thu, 11 Oct 2007 17:59:48 -0400
Message-ID: <20071011215948.27097.38002.stgit@novell1.haskins.net>
In-Reply-To: <20071011213916.27097.42597.stgit@novell1.haskins.net>
References: <20071011213916.27097.42597.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

This has been complied tested (and no more ;-)


The idea here is when we find a situation that we just scheduled in an
RT task and we either pushed a lesser RT task away or more than one RT
task was scheduled on this CPU before scheduling occurred.

The answer that this patch does is to do a O(n) search of CPUs for the
CPU with the lowest prio task running. When that CPU is found the next
highest RT task is pushed to that CPU.

Some notes:

1) no lock is taken while looking for the lowest priority CPU. When one
is found, only that CPU's lock is taken and after that a check is made
to see if it is still a candidate to push the RT task over. If not, we
try the search again, for a max of 3 tries.

2) I only do this for the second highest RT task on the CPU queue. This
can be easily changed to do it for all RT tasks until no more can be
pushed off to other CPUs.

This is a simple approach right now, and is only being posted for
comments.  I'm sure more can be done to make this more efficient or just
simply better.

-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---

 kernel/sched.c    |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched_rt.c |   42 ++++++++++++++++++++++++++
 2 files changed, 126 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 93fd6de..0f0af6d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -304,6 +304,7 @@ struct rq {
 #ifdef CONFIG_PREEMPT_RT
 	unsigned long rt_nr_running;
 	unsigned long rt_nr_uninterruptible;
+	int curr_prio;
 #endif
 
 	unsigned long switch_timestamp;
@@ -1485,6 +1486,87 @@ next_in_queue:
 static int double_lock_balance(struct rq *this_rq, struct rq *busiest);
 
 /*
+ * If the current CPU has more than one RT task, see if the non
+ * running task can migrate over to a CPU that is running a task
+ * of lesser priority.
+ */
+static int push_rt_task(struct rq *this_rq)
+{
+	struct task_struct *next_task;
+	struct rq *lowest_rq = NULL;
+	int tries;
+	int cpu;
+	int dst_cpu = -1;
+	int ret = 0;
+
+	BUG_ON(!spin_is_locked(&this_rq->lock));
+
+	next_task = rt_next_highest_task(this_rq);
+	if (!next_task)
+		return 0;
+
+	/* We might release this_rq lock */
+	get_task_struct(next_task);
+
+	/* Only try this algorithm three times */
+	for (tries = 0; tries < 3; tries++) {
+		/*
+		 * Scan each rq for the lowest prio.
+		 */
+		for_each_cpu_mask(cpu, next_task->cpus_allowed) {
+			struct rq *rq = &per_cpu(runqueues, cpu);
+
+			if (cpu == smp_processor_id())
+				continue;
+
+			/* no locking for now */
+			if (rq->curr_prio > next_task->prio &&
+			    (!lowest_rq || rq->curr_prio < lowest_rq->curr_prio)) {
+				dst_cpu = cpu;
+				lowest_rq = rq;
+			}
+		}
+
+		if (!lowest_rq)
+			break;
+
+		if (double_lock_balance(this_rq, lowest_rq)) {
+			/*
+			 * We had to unlock the run queue. In
+			 * the mean time, next_task could have
+			 * migrated already or had its affinity changed.
+			 */
+			if (unlikely(task_rq(next_task) != this_rq ||
+				     !cpu_isset(dst_cpu, next_task->cpus_allowed))) {
+				spin_unlock(&lowest_rq->lock);
+				break;
+			}
+		}
+
+		/* if the prio of this runqueue changed, try again */
+		if (lowest_rq->curr_prio <= next_task->prio) {
+			spin_unlock(&lowest_rq->lock);
+			continue;
+		}
+
+		deactivate_task(this_rq, next_task, 0);
+		set_task_cpu(next_task, dst_cpu);
+		activate_task(lowest_rq, next_task, 0);
+
+		set_tsk_need_resched(lowest_rq->curr);
+
+		spin_unlock(&lowest_rq->lock);
+		ret = 1;
+
+		break;
+	}
+
+	put_task_struct(next_task);
+
+	return ret;
+}
+
+/*
  * Pull RT tasks from other CPUs in the RT-overload
  * case. Interrupts are disabled, local rq is locked.
  */
@@ -2207,7 +2289,8 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 * If we pushed an RT task off the runqueue,
 	 * then kick other CPUs, they might run it:
 	 */
-	if (unlikely(rt_task(current) && prev->se.on_rq && rt_task(prev))) {
+	rq->curr_prio = current->prio;
+	if (unlikely(rt_task(current) && push_rt_task(rq))) {
 		schedstat_inc(rq, rto_schedule);
 		smp_send_reschedule_allbutself_cpumask(current->cpus_allowed);
 	}
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 369827b..6eca644 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -96,6 +96,48 @@ static struct task_struct *pick_next_task_rt(struct rq *rq)
 	return next;
 }
 
+#ifdef CONFIG_PREEMPT_RT
+static struct task_struct *rt_next_highest_task(struct rq *rq)
+{
+	struct rt_prio_array *array = &rq->rt.active;
+	struct task_struct *next;
+	struct list_head *queue;
+	int idx;
+
+	if (likely (rq->rt_nr_running < 2))
+		return NULL;
+
+	idx = sched_find_first_bit(array->bitmap);
+	if (idx >= MAX_RT_PRIO) {
+		WARN_ON(1); /* rt_nr__running is bad */
+		return NULL;
+	}
+
+	queue = array->queue + idx;
+	if (queue->next->next != queue) {
+		/* same prio task */
+		next = list_entry(queue->next->next, struct task_struct, run_list);
+		goto out;
+	}
+
+	/* slower, but more flexible */
+	idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
+	if (idx >= MAX_RT_PRIO) {
+		WARN_ON(1); /* rt_nr_running was 2 and above! */
+		return NULL;
+	}
+
+	queue = array->queue + idx;
+	next = list_entry(queue->next, struct task_struct, run_list);
+
+ out:
+	return next;
+	
+}
+#else  /* CONFIG_PREEMPT_RT */
+
+#endif /* CONFIG_PREEMPT_RT */
+
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 {
 	update_curr_rt(rq);

