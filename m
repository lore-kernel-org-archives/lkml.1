Return-Path: <linux-kernel-owner+w=401wt.eu-S1760566AbXJLQPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760566AbXJLQPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760011AbXJLQHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:07:18 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:61777 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760453AbXJLQHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:07:13 -0400
Subject: [PATCH RT] push RT tasks when overloaded (via schedule)
From: Steven Rostedt <rostedt@goodmis.org>
To: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Fri, 12 Oct 2007 12:05:53 -0400
Message-Id: <1192205153.12339.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cleaned up verison of my original patch.

When an RT task is scheduled, a check is made to see if other RT tasks
are queued on the runqueue. If there is, then a loop is performed to try
to move each RT task onto other CPUs.

With out the patch my rt-migrate-test on 2.6.23-rt1 shows this:

   7:       13   20019      26
 len:    20013   40019   20026
 loops:  73857   73820   73840

with the run of 

  rt-migrate-test -p 60 -l 100 3

Which is 3 RT threads of prios 60, 61 and 62 that are woken up at the
same time (on a 2 way CPU box), and each will try to run for 20ms every
100 ms.  The above output shows that on iteration 7, the 60 prio started
before the 61 prio and finished in 20ms (numbers above are in usecs).
And completed a gettimeofday loop 73,857 times. Which shows that it ran
without being preempted.  The 61 prio thread had to wait for the 60 prio
or 62 prio to finish before it was able to complete. This shows an
unbounded priority inversion WRT RT balancing.

With the patch applied, we never get this, but we may get the following:

  97:       22      40      37
 len:    20042   20040   20037
 loops:     50   73665   73674

Which shows on iteration 97, the 60 prio thread started before the other
two (wake up order may not be predictable with futex_wakeup, which might
be something else we look at).  But it also shows that the prio thread
61 was able to preempt the prio 60 (being pushed there).  The prio 60
thread was preempted and we see this because it only did 50 iterations
in the 20ms time it was given. Obviously, the prio 61 took it over.
This _is_ expected behavior of the test.

For the test, you can get the source code at:

  http://people.redhat.com/srostedt/rt/tests/rt-migrate-test.c

This version of the patch I separated the search algorithm (suggested by
Gregory Haskins) from the attaching the thread.

It stops the search when it finds a CPU with no RT task running.

I also added a loop in the finish_task_switch to keep doing pull_rt_task
until it no longer pushes any rt tasks off the queue.

This version is ready for inclusion sans any comments I get.

-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.23-rt1/kernel/sched.c
===================================================================
--- linux-2.6.23-rt1.orig/kernel/sched.c
+++ linux-2.6.23-rt1/kernel/sched.c
@@ -304,6 +304,7 @@ struct rq {
 #ifdef CONFIG_PREEMPT_RT
 	unsigned long rt_nr_running;
 	unsigned long rt_nr_uninterruptible;
+	int curr_prio;
 #endif
 
 	unsigned long switch_timestamp;
@@ -1484,6 +1485,126 @@ next_in_queue:
 
 static int double_lock_balance(struct rq *this_rq, struct rq *busiest);
 
+/* Only try this algorithm three times */
+#define RT_PUSH_MAX_TRIES 3
+
+/* Will lock the rq it finds */
+static int find_lowest_cpu(cpumask_t *cpu_mask, struct task_struct *task,
+				 struct rq *this_rq)
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
+				dst_cpu = cpu;
+				lowest_rq = rq;
+			}
+		}
+
+		if (!lowest_rq) {
+			dst_cpu = -1;
+			break;
+		}
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
+				dst_cpu = -1;
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
+		dst_cpu = -1;
+	}
+
+	return dst_cpu;
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
+	/* find_lowest_rq locks cpu_rq(dst_cpu) if found */
+	dst_cpu = find_lowest_cpu(&cpu_mask, next_task, this_rq); 
+	if (dst_cpu < 0)
+		goto out;
+
+	lowest_rq = cpu_rq(dst_cpu);
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
@@ -2202,19 +2323,28 @@ static inline void finish_task_switch(st
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
-	 */
-	if (unlikely(rt_task(current) && rq->rt_nr_running > 1)) {
-		schedstat_inc(rq, rto_schedule);
-		smp_send_reschedule_allbutself_cpumask(current->cpus_allowed);
+	 * then kick other CPUs, they might run it.
+	 * Note we may release the rq lock, and since
+	 * the lock was owned by prev, we need to release it
+	 * first via finish_lock_switch and then reaquire it.
+	 */
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
Index: linux-2.6.23-rt1/kernel/sched_rt.c
===================================================================
--- linux-2.6.23-rt1.orig/kernel/sched_rt.c
+++ linux-2.6.23-rt1/kernel/sched_rt.c
@@ -96,6 +96,50 @@ static struct task_struct *pick_next_tas
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


