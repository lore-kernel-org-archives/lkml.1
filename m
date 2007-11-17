Return-Path: <linux-kernel-owner+w=401wt.eu-S933160AbXKQG2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbXKQG2W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 01:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760389AbXKQGYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 01:24:43 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:44631 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925AbXKQGYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 01:24:40 -0500
Message-Id: <20071117062403.546679400@goodmis.org>
References: <20071117062104.177779113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 01:21:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v3 03/17] push RT tasks
Content-Disposition: inline; filename=rt-balance-push-tasks.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an algorithm to push extra RT tasks off a run queue to
other CPU runqueues.

When more than one RT task is added to a run queue, this algorithm takes
an assertive approach to push the RT tasks that are not running onto other
run queues that have lower priority.  The way this works is that the highest
RT task that is not running is looked at and we examine the runqueues on
the CPUS for that tasks affinity mask. We find the runqueue with the lowest
prio in the CPU affinity of the picked task, and if it is lower in prio than
the picked task, we push the task onto that CPU runqueue.

We continue pushing RT tasks off the current runqueue until we don't push any
more.  The algorithm stops when the next highest RT task can't preempt any
other processes on other CPUS.

TODO: The algorithm may stop when there are still RT tasks that can be
 migrated. Specifically, if the highest non running RT task CPU affinity
 is restricted to CPUs that are running higher priority tasks, there may
 be a lower priority task queued that has an affinity with a CPU that is
 running a lower priority task that it could be migrated to.  This
 patch set does not address this issue.

Note: checkpatch reveals two over 80 character instances. I'm not sure
 that breaking them up will help visually, so I left them as is.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 kernel/sched.c    |    8 +
 kernel/sched_rt.c |  223 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 229 insertions(+), 2 deletions(-)

Index: linux-compile.git/kernel/sched.c
===================================================================
--- linux-compile.git.orig/kernel/sched.c	2007-11-16 21:49:27.000000000 -0500
+++ linux-compile.git/kernel/sched.c	2007-11-16 21:49:59.000000000 -0500
@@ -1877,6 +1877,8 @@ static void finish_task_switch(struct rq
 	prev_state = prev->state;
 	finish_arch_switch(prev);
 	finish_lock_switch(rq, prev);
+	schedule_tail_balance_rt(rq);
+
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)
 		mmdrop(mm);
@@ -2110,11 +2112,13 @@ static void double_rq_unlock(struct rq *
 /*
  * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
  */
-static void double_lock_balance(struct rq *this_rq, struct rq *busiest)
+static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
 	__releases(this_rq->lock)
 	__acquires(busiest->lock)
 	__acquires(this_rq->lock)
 {
+	int ret = 0;
+
 	if (unlikely(!irqs_disabled())) {
 		/* printk() doesn't work good under rq->lock */
 		spin_unlock(&this_rq->lock);
@@ -2125,9 +2129,11 @@ static void double_lock_balance(struct r
 			spin_unlock(&this_rq->lock);
 			spin_lock(&busiest->lock);
 			spin_lock(&this_rq->lock);
+			ret = 1;
 		} else
 			spin_lock(&busiest->lock);
 	}
+	return ret;
 }
 
 /*
Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-16 21:49:27.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-16 21:49:59.000000000 -0500
@@ -134,6 +134,225 @@ static void put_prev_task_rt(struct rq *
 }
 
 #ifdef CONFIG_SMP
+/* Only try algorithms three times */
+#define RT_MAX_TRIES 3
+
+static int double_lock_balance(struct rq *this_rq, struct rq *busiest);
+static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep);
+
+/* Return the second highest RT task, NULL otherwise */
+static struct task_struct *pick_next_highest_task_rt(struct rq *rq)
+{
+	struct rt_prio_array *array = &rq->rt.active;
+	struct task_struct *next;
+	struct list_head *queue;
+	int idx;
+
+	assert_spin_locked(&rq->lock);
+
+	if (likely(rq->rt.rt_nr_running < 2))
+		return NULL;
+
+	idx = sched_find_first_bit(array->bitmap);
+	if (unlikely(idx >= MAX_RT_PRIO)) {
+		WARN_ON(1); /* rt_nr_running is bad */
+		return NULL;
+	}
+
+	queue = array->queue + idx;
+	next = list_entry(queue->next, struct task_struct, run_list);
+	if (unlikely(next != rq->curr))
+		return next;
+
+	if (queue->next->next != queue) {
+		/* same prio task */
+		next = list_entry(queue->next->next, struct task_struct, run_list);
+		return next;
+	}
+
+	/* slower, but more flexible */
+	idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
+	if (unlikely(idx >= MAX_RT_PRIO)) {
+		WARN_ON(1); /* rt_nr_running was 2 and above! */
+		return NULL;
+	}
+
+	queue = array->queue + idx;
+	next = list_entry(queue->next, struct task_struct, run_list);
+
+	return next;
+}
+
+/* Will lock the rq it finds */
+static struct rq *find_lock_lowest_rq(struct task_struct *task,
+				      struct rq *this_rq)
+{
+	struct rq *lowest_rq = NULL;
+	cpumask_t cpu_mask;
+	int cpu;
+	int tries;
+
+	cpus_and(cpu_mask, cpu_online_map, task->cpus_allowed);
+
+	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
+		/*
+		 * Scan each rq for the lowest prio.
+		 */
+		for_each_cpu_mask(cpu, cpu_mask) {
+			struct rq *rq = &per_cpu(runqueues, cpu);
+
+			if (cpu == this_rq->cpu)
+				continue;
+
+			/* We look for lowest RT prio or non-rt CPU */
+			if (rq->rt.highest_prio >= MAX_RT_PRIO) {
+				lowest_rq = rq;
+				break;
+			}
+
+			/* no locking for now */
+			if (rq->rt.highest_prio > task->prio &&
+			    (!lowest_rq || rq->rt.highest_prio > lowest_rq->rt.highest_prio)) {
+				lowest_rq = rq;
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
+			 * Also make sure that it wasn't scheduled on its rq.
+			 */
+			if (unlikely(task_rq(task) != this_rq ||
+				     !cpu_isset(lowest_rq->cpu, task->cpus_allowed) ||
+				     task_running(this_rq, task) ||
+				     !task->se.on_rq)) {
+				spin_unlock(&lowest_rq->lock);
+				lowest_rq = NULL;
+				break;
+			}
+		}
+
+		/* If this rq is still suitable use it. */
+		if (lowest_rq->rt.highest_prio > task->prio)
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
+	int ret = 0;
+	int paranoid = RT_MAX_TRIES;
+
+	assert_spin_locked(&this_rq->lock);
+
+	next_task = pick_next_highest_task_rt(this_rq);
+	if (!next_task)
+		return 0;
+
+ retry:
+	if (unlikely(next_task == this_rq->curr))
+		return 0;
+
+	/*
+	 * It's possible that the next_task slipped in of
+	 * higher priority than current. If that's the case
+	 * just reschedule current.
+	 */
+	if (unlikely(next_task->prio < this_rq->curr->prio)) {
+		resched_task(this_rq->curr);
+		return 0;
+	}
+
+	/* We might release this_rq lock */
+	get_task_struct(next_task);
+
+	/* find_lock_lowest_rq locks the rq if found */
+	lowest_rq = find_lock_lowest_rq(next_task, this_rq);
+	if (!lowest_rq) {
+		struct task_struct *task;
+		/*
+		 * find lock_lowest_rq releases this_rq->lock
+		 * so it is possible that next_task has changed.
+		 * If it has, then try again.
+		 */
+		task = pick_next_highest_task_rt(this_rq);
+		if (unlikely(task != next_task) && task && paranoid--) {
+			put_task_struct(next_task);
+			next_task = task;
+			goto retry;
+		}
+		goto out;
+	}
+
+	assert_spin_locked(&lowest_rq->lock);
+
+	deactivate_task(this_rq, next_task, 0);
+	set_task_cpu(next_task, lowest_rq->cpu);
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
+/*
+ * TODO: Currently we just use the second highest prio task on
+ *       the queue, and stop when it can't migrate (or there's
+ *       no more RT tasks).  There may be a case where a lower
+ *       priority RT task has a different affinity than the
+ *       higher RT task. In this case the lower RT task could
+ *       possibly be able to migrate where as the higher priority
+ *       RT task could not.  We currently ignore this issue.
+ *       Enhancements are welcome!
+ */
+static void push_rt_tasks(struct rq *rq)
+{
+	/* push_rt_task will return true if it moved an RT */
+	while (push_rt_task(rq))
+		;
+}
+
+static void schedule_tail_balance_rt(struct rq *rq)
+{
+	/*
+	 * If we have more than one rt_task queued, then
+	 * see if we can push the other rt_tasks off to other CPUS.
+	 * Note we may release the rq lock, and since
+	 * the lock was owned by prev, we need to release it
+	 * first via finish_lock_switch and then reaquire it here.
+	 */
+	if (unlikely(rq->rt.rt_nr_running > 1)) {
+		spin_lock_irq(&rq->lock);
+		push_rt_tasks(rq);
+		spin_unlock_irq(&rq->lock);
+	}
+}
+
 /*
  * Load-balancing iterator. Note: while the runqueue stays locked
  * during the whole iteration, the current task might be
@@ -238,7 +457,9 @@ move_one_task_rt(struct rq *this_rq, int
 	return iter_move_one_task(this_rq, this_cpu, busiest, sd, idle,
 				  &rt_rq_iterator);
 }
-#endif
+#else /* CONFIG_SMP */
+# define schedule_tail_balance_rt(rq)	do { } while (0)
+#endif /* CONFIG_SMP */
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p)
 {

-- 
