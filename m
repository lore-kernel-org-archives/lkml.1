Return-Path: <linux-kernel-owner+w=401wt.eu-S964959AbXCaDXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959AbXCaDXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 23:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965045AbXCaDXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 23:23:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:49456 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S964959AbXCaDXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 23:23:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19jexYWPm9jeyN2B/8+CBDAke5AV9i58aXxs+uB04
	LO/JZtbIl4JaLW
Subject: Re: [test] hackbench.c interactivity results: vanilla versus
	SD/RSDL
From: Mike Galbraith <efault@gmx.de>
To: Xenofon Antidides <xantidides@yahoo.gr>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070331023615.98478.qmail@web26704.mail.ukl.yahoo.com>
References: <20070331023615.98478.qmail@web26704.mail.ukl.yahoo.com>
Content-Type: text/plain
Date: Sat, 31 Mar 2007 05:23:44 +0200
Message-Id: <1175311424.6927.6.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-30 at 19:36 -0700, Xenofon Antidides wrote:

> Something different on many cpus? Sorry I was thinking
> something other. I try 50% run + 50% sleep on one cpu
> and mainline has big problem. Sorry for bad code I
> copy bits to make it work. Start program first then
> run bash 100% cpu (while : ; do : ; done). Try change
> program forks from 1 till 3 or more mainline kernel
> and bash gets 0%.

top - 05:16:41 up 43 min, 13 users,  load average: 9.51, 4.32, 5.67

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 7146 root      15   0  1564  104   24 R   43  0.0   0:20.74 0 fiftypercent
 7142 root      15   0  1564  104   24 S   37  0.0   0:18.08 0 fiftypercent
 7140 root      15   0  1564  436  356 R   21  0.0   0:18.94 1 fiftypercent
 7144 root      15   0  1564  104   24 R   21  0.0   0:18.75 1 fiftypercent
 7143 root      15   0  1564  104   24 R   20  0.0   0:18.85 1 fiftypercent
 7145 root      15   0  1564  104   24 R   19  0.0   0:18.30 1 fiftypercent
 7147 root      15   0  1564  104   24 R   19  0.0   0:18.03 1 fiftypercent
 7141 root      16   0  1564  104   24 R   10  0.0   0:18.29 0 fiftypercent
 6245 root      16   0  3368 1876 1376 R    7  0.2   0:49.81 0 bash

That's mainline with the below (which I'm trying various ideas to improve).

--- linux-2.6.21-rc5/kernel/sched.c.org	2007-03-27 15:47:49.000000000 +0200
+++ linux-2.6.21-rc5/kernel/sched.c	2007-03-30 18:21:12.000000000 +0200
@@ -234,6 +234,7 @@ struct rq {
 	 */
 	unsigned long nr_uninterruptible;
 
+	unsigned long switch_timestamp;
 	unsigned long expired_timestamp;
 	/* Cached timestamp set by update_cpu_clock() */
 	unsigned long long most_recent_timestamp;
@@ -882,7 +883,11 @@ static int recalc_task_prio(struct task_
 	/* Caller must always ensure 'now >= p->timestamp' */
 	unsigned long sleep_time = now - p->timestamp;
 
-	if (batch_task(p))
+	/*
+	 * Migration timestamp adjustment may induce negative time.
+	 * Ignore unquantifiable values as well as SCHED_BATCH tasks.
+	 */ 
+	if (now < p->timestamp || batch_task(p))
 		sleep_time = 0;
 
 	if (likely(sleep_time > 0)) {
@@ -3051,9 +3056,9 @@ static inline int expired_starving(struc
 {
 	if (rq->curr->static_prio > rq->best_expired_prio)
 		return 1;
-	if (!STARVATION_LIMIT || !rq->expired_timestamp)
+	if (!STARVATION_LIMIT)
 		return 0;
-	if (jiffies - rq->expired_timestamp > STARVATION_LIMIT * rq->nr_running)
+	if (jiffies - rq->switch_timestamp > STARVATION_LIMIT * rq->nr_running)
 		return 1;
 	return 0;
 }
@@ -3131,6 +3136,67 @@ void account_steal_time(struct task_stru
 		cpustat->steal = cputime64_add(cpustat->steal, tmp);
 }
 
+/*
+ * Promote and requeue the next lower priority task.  If no task
+ * is available in the active array, switch to the expired array.
+ * @rq: runqueue to search.
+ * @prio: priority at which to begin search.
+ */
+static inline void promote_next_lower(struct rq *rq, int prio)
+{
+	struct prio_array *array = rq->active;
+	struct task_struct *p = NULL;
+	unsigned long long now = rq->most_recent_timestamp;
+	unsigned long *bitmap;
+	unsigned long starving = JIFFIES_TO_NS(rq->nr_running * DEF_TIMESLICE);
+	int idx = prio + 1, found_noninteractive = 0;
+
+repeat:
+	bitmap = array->bitmap;
+	idx = find_next_bit(bitmap, MAX_PRIO, idx);
+	if (idx < MAX_PRIO) {
+		struct list_head *queue = array->queue + idx;
+
+		p = list_entry(queue->next, struct task_struct, run_list);
+		if (!TASK_INTERACTIVE(p))
+			found_noninteractive = 1;
+
+		/* Skip non-starved queues. */
+		if (now < p->last_ran + starving) {
+			idx++;
+			p = NULL;
+			goto repeat;
+		}
+	} else if (!found_noninteractive && array == rq->active) {
+		/* Nobody home, check the expired array. */
+		array = rq->expired;
+		idx = 0;
+		p = NULL;
+		goto repeat;
+	}
+
+	/* Found one, requeue it. */
+	if (p) {
+		dequeue_task(p, p->array);
+		if (array == rq->active)
+			p->prio--;
+		/*
+		 * If we pulled a task from the expired array, correct
+		 * expired array info.  We can't afford a full search
+		 * for best_expired_prio, but do the best we can.
+		 */
+		else {
+			idx = sched_find_first_bit(array->bitmap);
+			if (idx < MAX_PRIO) {
+				if (rq->best_expired_prio > idx)
+					rq->best_expired_prio = idx;
+			} else
+				rq->best_expired_prio = MAX_PRIO;
+		}
+		enqueue_task(p, rq->active);
+	}
+}
+
 static void task_running_tick(struct rq *rq, struct task_struct *p)
 {
 	if (p->array != rq->active) {
@@ -3162,20 +3228,30 @@ static void task_running_tick(struct rq 
 		goto out_unlock;
 	}
 	if (!--p->time_slice) {
+		int task_was_interactive = TASK_INTERACTIVE(p);
 		dequeue_task(p, rq->active);
 		set_tsk_need_resched(p);
 		p->prio = effective_prio(p);
 		p->time_slice = task_timeslice(p);
 		p->first_time_slice = 0;
 
-		if (!rq->expired_timestamp)
-			rq->expired_timestamp = jiffies;
 		if (!TASK_INTERACTIVE(p) || expired_starving(rq)) {
 			enqueue_task(p, rq->expired);
 			if (p->static_prio < rq->best_expired_prio)
 				rq->best_expired_prio = p->static_prio;
-		} else
+			if (!task_was_interactive)
+				rq->expired_timestamp = jiffies;
+		} else {
+			int limit = STARVATION_LIMIT;
 			enqueue_task(p, rq->active);
+
+			/*
+			 * Start promoting lower priority tasks if we haven't
+			 * expired a task within STARVATION_LIMIT tics.
+			 */
+			if (time_after(jiffies, rq->expired_timestamp + limit))
+				promote_next_lower(rq, p->prio);
+		}
 	} else {
 		/*
 		 * Prevent a too long timeslice allowing a task to monopolize
@@ -3356,7 +3432,7 @@ need_resched_nonpreemptible:
 		idle_balance(cpu, rq);
 		if (!rq->nr_running) {
 			next = rq->idle;
-			rq->expired_timestamp = 0;
+			rq->switch_timestamp = jiffies;
 			goto switch_tasks;
 		}
 	}
@@ -3370,7 +3446,7 @@ need_resched_nonpreemptible:
 		rq->active = rq->expired;
 		rq->expired = array;
 		array = rq->active;
-		rq->expired_timestamp = 0;
+		rq->switch_timestamp = jiffies;
 		rq->best_expired_prio = MAX_PRIO;
 	}
 


