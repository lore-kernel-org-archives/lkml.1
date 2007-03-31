Return-Path: <linux-kernel-owner+w=401wt.eu-S1751536AbXCaGIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbXCaGIu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 02:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbXCaGIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 02:08:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:55632 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750708AbXCaGIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 02:08:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19jncwHJVpj+bHoA55Y2Z7Ek5/wwXMCrccwAwwho8
	I+NURQ3MnXWbXi
Subject: Re: [test] hackbench.c interactivity results: vanilla versus
	SD/RSDL
From: Mike Galbraith <efault@gmx.de>
To: Xenofon Antidides <xantidides@yahoo.gr>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1175312557.6927.14.camel@Homer.simpson.net>
References: <20070331023615.98478.qmail@web26704.mail.ukl.yahoo.com>
	 <1175311424.6927.6.camel@Homer.simpson.net>
	 <1175312557.6927.14.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Sat, 31 Mar 2007 08:08:43 +0200
Message-Id: <1175321323.6030.13.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-31 at 05:42 +0200, Mike Galbraith wrote:

> Yesterday, I piddled around with tracking interactive backlog as a way
> to detect when the load isn't really an interactive load, that's very
> simple and has potential.

Kinda like the patch below (though it can all be done slow path), or
something like my old throttling patches do (for grins I revived one,
and watched it yawn at your exploit)...

top - 07:49:36 up 6 min, 13 users,  load average: 4.42, 3.11, 1.40

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 6027 root      20   0  1564  104   24 R   45  0.0   0:09.47 1 fiftypercent
 6028 root      19   0  1564  104   24 R   40  0.0   0:09.43 1 fiftypercent
 6025 root      25   0  2892 1240 1032 R   32  0.1   0:09.04 1 sh
 6024 root      16   0  1564  436  356 S   30  0.0   0:10.45 0 fiftypercent
 6026 root      15   0  1564  104   24 R   27  0.0   0:09.52 0 fiftypercent
 6029 root      16   0  1564  104   24 R   18  0.0   0:09.33 0 fiftypercent

...or both, or maybe something clever instead :)

--- kernel/sched.c.org	2007-03-27 15:47:49.000000000 +0200
+++ kernel/sched.c	2007-03-31 06:56:57.000000000 +0200
@@ -109,6 +109,7 @@ unsigned long long __attribute__((weak))
 #define MAX_SLEEP_AVG		(DEF_TIMESLICE * MAX_BONUS)
 #define STARVATION_LIMIT	(MAX_SLEEP_AVG)
 #define NS_MAX_SLEEP_AVG	(JIFFIES_TO_NS(MAX_SLEEP_AVG))
+#define INTERACTIVE_LIMIT	(DEF_TIMESLICE * 4)
 
 /*
  * If a task is 'interactive' then we reinsert it in the active
@@ -167,6 +168,9 @@ unsigned long long __attribute__((weak))
 	(JIFFIES_TO_NS(MAX_SLEEP_AVG * \
 		(MAX_BONUS / 2 + DELTA((p)) + 1) / MAX_BONUS - 1))
 
+#define INTERACTIVE_BACKLOG_EXCEEDED(array) \
+	((array)->interactive_ticks > INTERACTIVE_LIMIT)
+
 #define TASK_PREEMPTS_CURR(p, rq) \
 	((p)->prio < (rq)->curr->prio)
 
@@ -201,6 +205,7 @@ static inline unsigned int task_timeslic
 
 struct prio_array {
 	unsigned int nr_active;
+	int interactive_ticks;
 	DECLARE_BITMAP(bitmap, MAX_PRIO+1); /* include 1 bit for delimiter */
 	struct list_head queue[MAX_PRIO];
 };
@@ -234,6 +239,7 @@ struct rq {
 	 */
 	unsigned long nr_uninterruptible;
 
+	unsigned long switch_timestamp;
 	unsigned long expired_timestamp;
 	/* Cached timestamp set by update_cpu_clock() */
 	unsigned long long most_recent_timestamp;
@@ -691,6 +697,8 @@ static void dequeue_task(struct task_str
 	list_del(&p->run_list);
 	if (list_empty(array->queue + p->prio))
 		__clear_bit(p->prio, array->bitmap);
+	if (TASK_INTERACTIVE(p))
+		array->interactive_ticks -= p->time_slice;
 }
 
 static void enqueue_task(struct task_struct *p, struct prio_array *array)
@@ -700,6 +708,8 @@ static void enqueue_task(struct task_str
 	__set_bit(p->prio, array->bitmap);
 	array->nr_active++;
 	p->array = array;
+	if (TASK_INTERACTIVE(p))
+		array->interactive_ticks += p->time_slice;
 }
 
 /*
@@ -882,7 +892,11 @@ static int recalc_task_prio(struct task_
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
@@ -3051,9 +3065,9 @@ static inline int expired_starving(struc
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
@@ -3131,8 +3145,74 @@ void account_steal_time(struct task_stru
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
+			} else {
+				/* We emptied the array */
+				rq->best_expired_prio = MAX_PRIO;
+				rq->switch_timestamp = jiffies;
+			}
+		}
+		enqueue_task(p, rq->active);
+	}
+}
+
 static void task_running_tick(struct rq *rq, struct task_struct *p)
 {
+	int task_was_interactive;
+
 	if (p->array != rq->active) {
 		/* Task has expired but was not scheduled yet */
 		set_tsk_need_resched(p);
@@ -3161,21 +3241,41 @@ static void task_running_tick(struct rq 
 		}
 		goto out_unlock;
 	}
+
+	/*
+	 * Tick off interactive task ticks from the active array.
+	 */
+	task_was_interactive = TASK_INTERACTIVE(p);
+	if (task_was_interactive && --rq->active->interactive_ticks < 0)
+		rq->active->interactive_ticks = 0;
+
 	if (!--p->time_slice) {
+		int expire_limit = STARVATION_LIMIT;
+
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
+			if (!task_was_interactive)
+				rq->expired_timestamp = jiffies;
 		} else
 			enqueue_task(p, rq->active);
+
+		/*
+		 * If we haven't expired a non-interactive task within
+		 * STARVATION_LIMIT ticks, or the current interactive
+		 * load exceeds INTERACTIVE_BACKLOG, start promoting
+		 * lower priority tasks.
+		 */
+		if (time_after(jiffies, rq->expired_timestamp + expire_limit) ||
+				INTERACTIVE_BACKLOG_EXCEEDED(rq->active))
+			promote_next_lower(rq, p->prio);
 	} else {
 		/*
 		 * Prevent a too long timeslice allowing a task to monopolize
@@ -3356,7 +3456,7 @@ need_resched_nonpreemptible:
 		idle_balance(cpu, rq);
 		if (!rq->nr_running) {
 			next = rq->idle;
-			rq->expired_timestamp = 0;
+			rq->switch_timestamp = jiffies;
 			goto switch_tasks;
 		}
 	}
@@ -3370,7 +3470,8 @@ need_resched_nonpreemptible:
 		rq->active = rq->expired;
 		rq->expired = array;
 		array = rq->active;
-		rq->expired_timestamp = 0;
+		array->interactive_ticks = 0;
+		rq->switch_timestamp = jiffies;
 		rq->best_expired_prio = MAX_PRIO;
 	}
 


