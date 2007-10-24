Return-Path: <linux-kernel-owner+w=401wt.eu-S1758980AbXJXOHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980AbXJXOHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757529AbXJXOHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:07:21 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:49065
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757366AbXJXOHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:07:18 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/9] RT: push-rt
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Wed, 24 Oct 2007 09:52:37 -0400
Message-ID: <20071024135236.7960.91374.stgit@novell1.haskins.net>
In-Reply-To: <20071024134431.7960.41984.stgit@novell1.haskins.net>
References: <20071024134431.7960.41984.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---

 kernel/sched.c    |  141 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 kernel/sched_rt.c |   44 +++++++++++++++++
 2 files changed, 178 insertions(+), 7 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3e75c62..0dabf89 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -304,6 +304,7 @@ struct rq {
 #ifdef CONFIG_PREEMPT_RT
 	unsigned long rt_nr_running;
 	unsigned long rt_nr_uninterruptible;
+	int curr_prio;
 #endif
 
 	unsigned long switch_timestamp;
@@ -1484,6 +1485,123 @@ next_in_queue:
 
 static int double_lock_balance(struct rq *this_rq, struct rq *busiest);
 
+/* Only try this algorithm three times */
+#define RT_PUSH_MAX_TRIES 3
+
+/* Will lock the rq it finds */
+static struct rq *find_lock_lowest_rq(cpumask_t *cpu_mask,
+				      struct task_struct *task,
+				      struct rq *this_rq)
+{
+	struct rq *lowest_rq = NULL;
+	int dst_cpu = -1;
+	int cpu;
+	int tries;
+
+	for (tries = 0; tries < RT_PUSH_MAX_TRIES; tries++) {
+		/*
+		 * Scan each rq for the lowest prio.
+		 */
+		for_each_cpu_mask(cpu, *cpu_mask) {
+			struct rq *rq = &per_cpu(runqueues, cpu);
+
+			if (cpu == smp_processor_id())
+				continue;
+
+			/* We look for lowest RT prio or non-rt CPU */
+			if (rq->curr_prio >= MAX_RT_PRIO) {
+				lowest_rq = rq;
+				dst_cpu = cpu;
+				break;
+			}
+
+			/* no locking for now */
+			if (rq->curr_prio > task->prio &&
+			    (!lowest_rq || rq->curr_prio < lowest_rq->curr_prio)) {
+				lowest_rq = rq;
+				dst_cpu = cpu;
+			}
+		}
+
+		if (!lowest_rq)
+			break;
+
+		/* if the prio of this runqueue changed, try again */
+		if (double_lock_balance(this_rq, lowest_rq)) {
+			/*
+			 * We had to unlock the run queue. In
+			 * the mean time, task could have
+			 * migrated already or had its affinity changed.
+			 */
+			if (unlikely(task_rq(task) != this_rq ||
+				     !cpu_isset(dst_cpu, task->cpus_allowed))) {
+				spin_unlock(&lowest_rq->lock);
+				lowest_rq = NULL;
+				break;
+			}
+
+		}
+
+		/* If this rq is still suitable use it. */
+		if (lowest_rq->curr_prio > task->prio)
+			break;
+
+		/* try again */
+		spin_unlock(&lowest_rq->lock);
+		lowest_rq = NULL;
+	}
+
+	return lowest_rq;
+}
+
+/*
+ * If the current CPU has more than one RT task, see if the non
+ * running task can migrate over to a CPU that is running a task
+ * of lesser priority.
+ */
+static int push_rt_task(struct rq *this_rq)
+{
+	struct task_struct *next_task;
+	struct rq *lowest_rq;
+	int dst_cpu;
+	int ret = 0;
+	cpumask_t cpu_mask;
+
+	assert_spin_locked(&this_rq->lock);
+
+	next_task = rt_next_highest_task(this_rq);
+	if (!next_task)
+		return 0;
+
+	cpus_and(cpu_mask, cpu_online_map, next_task->cpus_allowed);
+
+	/* We might release this_rq lock */
+	get_task_struct(next_task);
+
+	/* find_lock_lowest_rq locks the rq if found */
+	lowest_rq = find_lock_lowest_rq(&cpu_mask, next_task, this_rq);
+	if (!lowest_rq)
+		goto out;
+
+	dst_cpu = lowest_rq->cpu;
+
+	assert_spin_locked(&lowest_rq->lock);
+
+	deactivate_task(this_rq, next_task, 0);
+	set_task_cpu(next_task, dst_cpu);
+	activate_task(lowest_rq, next_task, 0);
+
+	resched_task(lowest_rq->curr);
+
+	spin_unlock(&lowest_rq->lock);
+
+	ret = 1;
+out:
+	put_task_struct(next_task);
+
+	return ret;
+}
+
 /*
  * Pull RT tasks from other CPUs in the RT-overload
  * case. Interrupts are disabled, local rq is locked.
@@ -2202,19 +2320,28 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 * be dropped twice.
 	 *		Manfred Spraul <manfred@colorfullife.com>
 	 */
+	prev_state = prev->state;
+	_finish_arch_switch(prev);
+#if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
+	rq->curr_prio = current->prio;
+#endif
+	finish_lock_switch(rq, prev);
 #if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
 	/*
 	 * If we pushed an RT task off the runqueue,
-	 * then kick other CPUs, they might run it:
+	 * then kick other CPUs, they might run it.
+	 * Note we may release the rq lock, and since
+	 * the lock was owned by prev, we need to release it
+	 * first via finish_lock_switch and then reaquire it.
 	 */
-	if (unlikely(rt_task(current) && rq->rt_nr_running > 1)) {
-		schedstat_inc(rq, rto_schedule);
-		smp_send_reschedule_allbutself_cpumask(current->cpus_allowed);
+	if (unlikely(rt_task(current))) {
+		spin_lock(&rq->lock);
+		/* push_rt_task will return true if it moved an RT */
+		while (push_rt_task(rq))
+			;
+		spin_unlock(&rq->lock);
 	}
 #endif
-	prev_state = prev->state;
-	_finish_arch_switch(prev);
-	finish_lock_switch(rq, prev);
 	fire_sched_in_preempt_notifiers(current);
 	trace_stop_sched_switched(current);
 	/*
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 369827b..8d59e62 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -96,6 +96,50 @@ static struct task_struct *pick_next_task_rt(struct rq *rq)
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
+		WARN_ON(1); /* rt_nr_running is bad */
+		return NULL;
+	}
+
+	queue = array->queue + idx;
+	next = list_entry(queue->next, struct task_struct, run_list);
+	if (unlikely(next != current))
+		return next;
+
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
+#endif /* CONFIG_PREEMPT_RT */
+
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 {
 	update_curr_rt(rq);

