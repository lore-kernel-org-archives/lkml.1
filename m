Return-Path: <linux-kernel-owner+w=401wt.eu-S933960AbXC1IiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960AbXC1IiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 04:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965370AbXC1IiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 04:38:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:41582 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933960AbXC1IiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 04:38:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19EkZ4jTSBE4VxApwZ7DZU7cbKKcuhP/+y8ludTWq
	NUpnVauSctJ3DE
Subject: Re: [BUG] scheduler: strange behavor with massive interactive
	processes
From: Mike Galbraith <efault@gmx.de>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1174971852.16403.35.camel@Homer.simpson.net>
References: <87r6rb1nbm.wl%takeuchi_satoru@jp.fujitsu.com>
	 <1174971852.16403.35.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Wed, 28 Mar 2007 10:38:11 +0200
Message-Id: <1175071091.29829.58.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings!

On Tue, 2007-03-27 at 07:04 +0200, Mike Galbraith wrote:
> On Tue, 2007-03-27 at 10:34 +0900, Satoru Takeuchi wrote:

> > When I was executing massive interactive processes, I found that some of them
> > occupy CPU time and the others hardly run.
> > 
> > It seems that some of processes which occupy CPU time always has max effective
> > prio (default+5) and the others have max - 1. What happen here is...
> > 
> >  1. If there are moderate number of max interactive processes, they can be
> >     re-inserted into active queue without falling down its priority again and
> >     again.
> >  2. In this case, the others seldom run, and can't get max effective priority
> >     at next exhausting because scheduler considers them to sleep too long.
> >  3. Goto 1, OOPS!
> 
> Ah, that's a new twist.  Cool testcase.  A mechanism which was put in
> specifically to prevent tasks from jumping straight to max interactive,
> and thus hurting truly interactive tasks, is starving these not truly
> interactive (but nothing says they couldn't be) tasks.

I puttered around with your testcase a bit, and didn't see interactive
tasks starving other interactive tasks so much as plain old interactive
tasks starving expired tasks, which they're supposed to be able to do,
but to a limited degree.  Merely forcing array switches fixes that here,
however array switches can be _very_ rough on interactivity, so I tried
a hybrid of the forced array switch and...

> One way to prevent this may be to do something very simple like (I did
> this here a while back) upon timeslice completion (or possibly better,
> round-robin interval [whenever]), promote a task from a lower priority
> queue.  Tasks are then always crawling up the ladder, and _will_ be
> inserted into the stream no matter what is going on in the system.

...the above, and it seems to work.  Below is a rough (second) cut,
which tries to preserve interactivity, but also ensure that
non-interactive tasks _will_ receive cpu in a reasonable amount of time.
It only engages when we're not expiring non-interactive tasks, ie should
have no effect until we're exclusively running interactive tasks, but
then it should also prevent the interactive/interactive starvation
scenario as well.  It doesn't attempt to enforce fairness, only prevent
terminal starvation.  With this patch^W(mess?;) I got the numbers below,
whereas without it, the distribution was pretty ugly.  I didn't try it
with many many attackers.  (many many false interactive tasks is doomed
unless you detect and switch behavior)

Interactivity still seems to be fine with reasonable non-interactive
loads despite ~reserving more bandwidth for non-interactive tasks.  Only
lightly tested, YMMV, and of course the standard guarantee applies ;)

	-Mike

root@Homer: ./massive_intr 20 180
009417  00003450
009419  00002965
009423  00003068
009406  00002565
009403  00002964
009421  00002949
009422  00002314
009420  00002879
009418  00002730
009415  00003126
009405  00002737
009408  00003664
009424  00003355
009414  00002947
009416  00004340
009407  00003424
009412  00003491
009404  00003101
009413  00002553
009425  00003396

2.6.21-rc5

--- kernel/sched.c.org	2007-03-27 15:47:49.000000000 +0200
+++ kernel/sched.c	2007-03-28 08:53:17.000000000 +0200
@@ -234,7 +234,8 @@ struct rq {
 	 */
 	unsigned long nr_uninterruptible;
 
-	unsigned long expired_timestamp;
+	unsigned long switch_timestamp;
+	unsigned long last_expired;
 	/* Cached timestamp set by update_cpu_clock() */
 	unsigned long long most_recent_timestamp;
 	struct task_struct *curr, *idle;
@@ -3051,9 +3052,9 @@ static inline int expired_starving(struc
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
@@ -3131,8 +3132,75 @@ void account_steal_time(struct task_stru
 		cpustat->steal = cputime64_add(cpustat->steal, tmp);
 }
 
+/*
+ * Promote and requeue the next lower priority task.  If no task
+ * is available in the active array, switch to the expired array.
+ * @rq: runqueue to search.
+ * @prio: priority at which to begin search.
+ */
+static inline int promote_next_lower(struct rq *rq, int prio)
+{
+	struct prio_array *array = rq->active;
+	unsigned long *bitmap;
+	struct task_struct *p = NULL; 
+	unsigned long long now = rq->most_recent_timestamp;
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
+		if (now < p->last_ran + JIFFIES_TO_NS(HZ)) {
+			idx++;
+			p = NULL;
+			goto repeat;
+		}
+	} else if (!found_noninteractive && array == rq->active){
+		/* Nobody home.  Check the expired array. */
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
+		 * expired task info.
+		 */
+		else {
+			idx = sched_find_first_bit(array->bitmap);
+			if (idx < MAX_PRIO) {
+				/* FIXME this isn't perfect */
+				if (rq->best_expired_prio > idx)
+					rq->best_expired_prio = idx;
+			} else {
+				rq->best_expired_prio = MAX_PRIO;
+#if 0
+				rq->switch_timestamp = jiffies;
+#endif
+			}
+		}
+		enqueue_task(p, rq->active);
+	}
+	return p != NULL;
+}
+
 static void task_running_tick(struct rq *rq, struct task_struct *p)
 {
+	static unsigned long warn_me = INITIAL_JIFFIES;
+	static int promoted;
 	if (p->array != rq->active) {
 		/* Task has expired but was not scheduled yet */
 		set_tsk_need_resched(p);
@@ -3162,20 +3230,31 @@ static void task_running_tick(struct rq 
 		goto out_unlock;
 	}
 	if (!--p->time_slice) {
+		int was_interactive = TASK_INTERACTIVE(p);
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
-		} else
+			if (!was_interactive)
+				rq->last_expired = jiffies;
+		} else {
+			int limit = STARVATION_LIMIT;
 			enqueue_task(p, rq->active);
+
+			/*
+			 * Start promoting lower priority tasks if we haven't
+			 * expired a task within STARVATION_LIMIT tics.
+			 */
+			if (time_after(jiffies, rq->last_expired + limit))
+				promoted += promote_next_lower(rq, p->prio);
+		}
 	} else {
 		/*
 		 * Prevent a too long timeslice allowing a task to monopolize
@@ -3204,6 +3283,12 @@ static void task_running_tick(struct rq 
 	}
 out_unlock:
 	spin_unlock(&rq->lock);
+	if (time_after(jiffies, warn_me)) {
+		if (promoted)
+			printk(KERN_ERR "%d tasks promoted\n", promoted);
+		promoted = 0;
+		warn_me = jiffies + HZ;
+	}
 }
 
 /*
@@ -3356,7 +3441,7 @@ need_resched_nonpreemptible:
 		idle_balance(cpu, rq);
 		if (!rq->nr_running) {
 			next = rq->idle;
-			rq->expired_timestamp = 0;
+			rq->switch_timestamp = jiffies;
 			goto switch_tasks;
 		}
 	}
@@ -3370,7 +3455,7 @@ need_resched_nonpreemptible:
 		rq->active = rq->expired;
 		rq->expired = array;
 		array = rq->active;
-		rq->expired_timestamp = 0;
+		rq->switch_timestamp = jiffies;
 		rq->best_expired_prio = MAX_PRIO;
 	}
 


