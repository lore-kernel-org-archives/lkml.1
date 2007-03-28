Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbXC1QJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbXC1QJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 12:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932773AbXC1QJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 12:09:49 -0400
Received: from mail02.syd.optusnet.com.au ([211.29.132.183]:41508 "EHLO
	mail02.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932768AbXC1QJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 12:09:47 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andy Whitcroft <apw@shadowen.org>, ck list <ck@vds.kolivas.org>
Subject: [PATCH] sched: staircase deadline misc fixes
Date: Thu, 29 Mar 2007 02:37:38 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703290237.38777.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

test.kernel.org found some idle time regressions in the latest update to the
staircase deadline scheduler and Andy Whitcroft helped me track down the 
offending problem which was present in all previous RSDL schedulers but
previously wouldn't be manifest without changes in nice. So here is a bugfix
for the set_load_weight being incorrectly set and a few other minor 
improvements. Thanks Andy!

I'm cautiously optimistic that we're at the thin edge of the bugfix wedge now.

---
set_load_weight() should be performed after p->quota is set. This fixes a
large SMP performance regression.

Make sure rr_interval is never set to less than one jiffy.

Some sanity checking in update_cpu_clock will prevent bogus sched_clock
values.

SCHED_BATCH tasks should not set the rq->best_static_prio field.

Correct sysctl rr_interval description to describe the value in milliseconds.

Style fixes.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 Documentation/sysctl/kernel.txt |    8 ++--
 kernel/sched.c                  |   73 +++++++++++++++++++++++++++++-----------
 2 files changed, 58 insertions(+), 23 deletions(-)

Index: linux-2.6.21-rc5-mm2/kernel/sched.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/kernel/sched.c	2007-03-28 09:01:03.000000000 +1000
+++ linux-2.6.21-rc5-mm2/kernel/sched.c	2007-03-29 00:02:33.000000000 +1000
@@ -88,10 +88,13 @@ unsigned long long __attribute__((weak))
 #define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
 #define SCHED_PRIO(p)		((p)+MAX_RT_PRIO)
 
-/* Some helpers for converting to/from nanosecond timing */
+/* Some helpers for converting to/from various scales.*/
 #define NS_TO_JIFFIES(TIME)	((TIME) / (1000000000 / HZ))
-#define NS_TO_MS(TIME)		((TIME) / 1000000)
+#define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
 #define MS_TO_NS(TIME)		((TIME) * 1000000)
+/* Can return 0 */
+#define MS_TO_JIFFIES(TIME)	((TIME) * HZ / 1000)
+#define JIFFIES_TO_MS(TIME)	((TIME) * 1000 / HZ)
 
 #define TASK_PREEMPTS_CURR(p, curr)	((p)->prio < (curr)->prio)
 
@@ -852,16 +855,15 @@ static void requeue_task(struct task_str
 
 /*
  * task_timeslice - the total duration a task can run during one major
- * rotation.
+ * rotation. Returns value in jiffies.
  */
 static inline int task_timeslice(struct task_struct *p)
 {
-	int slice, rr;
+	int slice;
 
-	slice = rr = p->quota;
+	slice = NS_TO_JIFFIES(p->quota);
 	if (!rt_task(p))
-		slice += (PRIO_RANGE - 1 - TASK_USER_PRIO(p)) * rr;
-	slice = NS_TO_JIFFIES(slice) ? : 1;
+		slice += (PRIO_RANGE - 1 - TASK_USER_PRIO(p)) * slice;
 	return slice;
 }
 
@@ -875,7 +877,7 @@ static inline int task_timeslice(struct 
 	(((lp) * SCHED_LOAD_SCALE) / TIME_SLICE_NICE_ZERO)
 #define TASK_LOAD_WEIGHT(p)	LOAD_WEIGHT(task_timeslice(p))
 #define RTPRIO_TO_LOAD_WEIGHT(rp)	\
-	(LOAD_WEIGHT((rr_interval + 20 + (rp))))
+	(LOAD_WEIGHT((MS_TO_JIFFIES(rr_interval) + 20 + (rp))))
 
 static void set_load_weight(struct task_struct *p)
 {
@@ -973,11 +975,15 @@ static int effective_prio(struct task_st
  * tick still. Below nice 0 they get progressively larger.
  * ie nice -6..0 = rr_interval. nice -10 = 2.5 * rr_interval
  * nice -20 = 10 * rr_interval. nice 1-19 = rr_interval / 2.
+ * Value returned is in nanoseconds.
  */
 static unsigned int rr_quota(struct task_struct *p)
 {
 	int nice = TASK_NICE(p), rr = rr_interval;
 
+	/* Ensure that rr_interval is at least 1 tick */
+	if (unlikely(!MS_TO_JIFFIES(rr)))
+		rr = rr_interval = JIFFIES_TO_MS(1) ? : 1;
 	if (!rt_task(p)) {
 		if (nice < -6) {
 			rr *= nice * nice;
@@ -3198,13 +3204,34 @@ EXPORT_PER_CPU_SYMBOL(kstat);
 /*
  * This is called on clock ticks and on context switches.
  * Bank in p->sched_time the ns elapsed since the last tick or switch.
+ * CPU scheduler quota accounting is also performed here.
+ * The value returned from sched_clock() occasionally gives bogus values so
+ * some sanity checking is required.
  */
 static inline void
-update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long long now)
+update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long long now,
+		 int tick)
 {
 	cputime64_t time_diff = now - p->last_ran;
+	unsigned int min_diff = 1000;
 
-	/* cpu scheduler quota accounting is performed here */
+	if (tick) {
+		/*
+		 * Called from scheduler_tick() there should be less than two
+		 * jiffies worth, and not negative/overflow.
+		 */
+		if (time_diff > JIFFIES_TO_NS(2) || time_diff < min_diff)
+			time_diff = JIFFIES_TO_NS(1);
+	} else {
+		/*
+		 * Called from context_switch there should be less than one
+		 * jiffy worth, and not negative/overflowed. In the case when
+		 * sched_clock fails to return high resolution values this
+		 * also ensures at least 1 min_diff gets banked.
+		 */
+		if (time_diff > JIFFIES_TO_NS(1) || time_diff < min_diff)
+			time_diff = min_diff;
+	}
 	if (p != rq->idle && p->policy != SCHED_FIFO)
 		p->time_slice -= time_diff;
 	p->sched_time += time_diff;
@@ -3353,7 +3380,7 @@ void scheduler_tick(void)
 	int idle_at_tick = idle_cpu(cpu);
 	struct rq *rq = cpu_rq(cpu);
 
-	update_cpu_clock(p, rq, now);
+	update_cpu_clock(p, rq, now, 1);
 
 	if (!idle_at_tick)
 		task_running_tick(rq, p);
@@ -3425,7 +3452,7 @@ retry:
 	}
 	queue = array->queue + idx;
 	next = list_entry(queue->next, struct task_struct, run_list);
-	if (unlikely(next->time_slice < 0)) {
+	if (unlikely(next->time_slice <= 0)) {
 		/*
 		 * Unlucky enough that this task ran out of time_slice
 		 * before it hit a scheduler_tick so it should have its
@@ -3438,7 +3465,8 @@ retry:
 	}
 	rq->prio_level = idx;
 	next->rotation = rq->prio_rotation;
-	if (next->static_prio < rq->best_static_prio)
+	if (next->static_prio < rq->best_static_prio &&
+	    next->policy != SCHED_BATCH)
 		rq->best_static_prio = next->static_prio;
 	return next;
 }
@@ -3533,7 +3561,7 @@ switch_tasks:
 	clear_tsk_need_resched(prev);
 	rcu_qsctr_inc(task_cpu(prev));
 
-	update_cpu_clock(prev, rq, now);
+	update_cpu_clock(prev, rq, now, 0);
 	prev->timestamp = prev->last_ran = now;
 
 	sched_info_switch(prev, next);
@@ -3978,7 +4006,8 @@ void rt_mutex_setprio(struct task_struct
 	rq = task_rq_lock(p, &flags);
 
 	oldprio = p->prio;
-	if ((queued = task_queued(p)))
+	queued = task_queued(p);
+	if (queued)
 		dequeue_task(p, rq);
 	p->prio = prio;
 
@@ -4023,15 +4052,17 @@ void set_user_nice(struct task_struct *p
 		p->static_prio = NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
-	if ((queued = task_queued(p))) {
+	queued = task_queued(p);
+	if (queued) {
 		dequeue_task(p, rq);
 		dec_raw_weighted_load(rq, p);
 	}
 
 	p->static_prio = NICE_TO_PRIO(nice);
-	set_load_weight(p);
 	old_prio = p->prio;
 	p->prio = effective_prio(p);
+	p->quota = rr_quota(p);
+	set_load_weight(p);
 	delta = p->prio - old_prio;
 
 	if (queued) {
@@ -4045,7 +4076,6 @@ void set_user_nice(struct task_struct *p
 			resched_task(rq->curr);
 	}
 out_unlock:
-	p->quota = rr_quota(p);
 	task_rq_unlock(rq, &flags);
 }
 EXPORT_SYMBOL(set_user_nice);
@@ -4166,6 +4196,7 @@ static void __setscheduler(struct task_s
 	p->normal_prio = normal_prio(p);
 	/* we are holding p->pi_lock already */
 	p->prio = rt_mutex_getprio(p);
+	p->quota = rr_quota(p);
 	set_load_weight(p);
 }
 
@@ -4254,7 +4285,8 @@ recheck:
 		spin_unlock_irqrestore(&p->pi_lock, flags);
 		goto recheck;
 	}
-	if ((queued = task_queued(p)))
+	queued = task_queued(p);
+	if (queued)
 		deactivate_task(p, rq);
 	oldprio = p->prio;
 	__setscheduler(p, policy, param->sched_priority);
@@ -7088,7 +7120,8 @@ void normalize_rt_tasks(void)
 		spin_lock_irqsave(&p->pi_lock, flags);
 		rq = __task_rq_lock(p);
 
-		if ((queued = task_queued(p)))
+		queued = task_queued(p);
+		if (queued)
 			deactivate_task(p, task_rq(p));
 		__setscheduler(p, SCHED_NORMAL, 0);
 		if (queued) {
Index: linux-2.6.21-rc5-mm2/Documentation/sysctl/kernel.txt
===================================================================
--- linux-2.6.21-rc5-mm2.orig/Documentation/sysctl/kernel.txt	2007-03-28 09:01:03.000000000 +1000
+++ linux-2.6.21-rc5-mm2/Documentation/sysctl/kernel.txt	2007-03-28 09:01:04.000000000 +1000
@@ -294,9 +294,11 @@ rr_interval:
 This is the smallest duration that any cpu process scheduling unit
 will run for. Increasing this value can increase throughput of cpu
 bound tasks substantially but at the expense of increased latencies
-overall. This value is in _ticks_ and the default value chosen depends
-on the number of cpus available at scheduler initialisation. Valid
-values are from 1-100.
+overall. This value is in milliseconds and the default value chosen
+depends on the number of cpus available at scheduler initialisation
+with a minimum of 8.
+
+Valid values are from 1-100.
 
 ==============================================================
 

-- 
-ck
