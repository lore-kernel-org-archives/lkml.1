Return-Path: <linux-kernel-owner+w=401wt.eu-S1750741AbXCWX1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750741AbXCWX1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 19:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbXCWX1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 19:27:46 -0400
Received: from mail07.syd.optusnet.com.au ([211.29.132.188]:43016 "EHLO
	mail07.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbXCWX1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 19:27:45 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Andy Whitcroft <apw@shadowen.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: debug rsdl 0.33
Date: Sat, 24 Mar 2007 10:26:56 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, "Martin J. Bligh" <mbligh@mbligh.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <4603C7EC.6030906@shadowen.org> <200703240845.30484.kernel@kolivas.org>
In-Reply-To: <200703240845.30484.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703241026.57143.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 March 2007 08:45, Con Kolivas wrote:
> On Friday 23 March 2007 23:28, Andy Whitcroft wrote:
> > Andy Whitcroft wrote:
> > > Con Kolivas wrote:
> > >> On Friday 23 March 2007 05:17, Andy Whitcroft wrote:
> > >>> Ok, I have yet a third x86_64 machine is is blowing up with the
> > >>> latest 2.6.21-rc4-mm1+hotfixes+rsdl-0.32 but working with
> > >>> 2.6.21-rc4-mm1+hotfixes-RSDL.  I have results on various hotfix
> > >>> levels so I have just fired off a set of tests across the affected
> > >>> machines on that latest hotfix stack plus the RSDL backout and the
> > >>> results should be in in the next hour or two.
> > >>>
> > >>> I think there is a strong correlation between RSDL and these hangs.
> > >>> Any suggestions as to the next step.
> > >>
> > >> Found a nasty in requeue_task
> > >> +	if (list_empty(old_array->queue + old_prio))
> > >> +		__clear_bit(old_prio, p->array->prio_bitmap);
> > >>
> > >> see anything wrong there? I do :P
> > >>
> > >> I'll queue that up with the other changes pending and hopefully that
> > >> will fix your bug.
> > >
> > > Tests queued with your rdsl-0.33 patch (I am assuming its in there).
> > > Will let you know how it looks.
> >
> > Hmmm, this is good for the original machine (as was 0.32) but not for
> > either of the other two.  I am seeing panics as below on those two.
>
> This machine seems most sensitive to it (first column):
> elm3b6
> amd64
> newisys
> 4cpu
> config: amd64
>
> Can you throw this debugging patch at it please? The console output might
> be very helpful. On top of sched-rsdl-0.33 thanks!

Better yet this one which checks the expired array as well and after 
pull_task.

If anyone's getting a bug they think might be due to rsdl please try this (on 
rsdl 0.33).

---
 kernel/sched.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

Index: linux-2.6.21-rc4-mm1/kernel/sched.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/kernel/sched.c	2007-03-24 08:32:19.000000000 +1100
+++ linux-2.6.21-rc4-mm1/kernel/sched.c	2007-03-24 10:22:59.000000000 +1100
@@ -659,6 +659,35 @@ static inline void set_task_entitlement(
 	p->time_slice = p->quota;
 }
 
+static int debug_rqbitmap(struct rq *rq)
+{
+	struct list_head *queue;
+	int idx = 0, error = 0;
+	struct prio_array *array;
+
+	for (idx = 0; idx < MAX_PRIO; idx++) {
+		array = rq->active;
+		queue = array->queue + idx;
+		if (!list_empty(queue)) {
+			if (!test_bit(idx, rq->dyn_bitmap)) {
+				__set_bit(idx, rq->dyn_bitmap);
+				error = 1;
+				printk(KERN_ERR "MISSING DYNAMIC BIT %d\n", idx);
+			}
+		}
+		array = rq->expired;
+		queue = array->queue + idx;
+		if (!list_empty(queue)) {
+			if (!test_bit(idx, rq->exp_bitmap)) {
+				__set_bit(idx, rq->exp_bitmap);
+				error = 1;
+				printk(KERN_ERR "MISSING EXPIRED BIT %d\n", idx);
+			}
+		}
+	}
+	return error;
+}
+
 /*
  * There is no specific hard accounting. The dynamic bits can have
  * false positives. rt_tasks can only be on the active queue.
@@ -679,6 +708,7 @@ static void dequeue_task(struct task_str
 	list_del_init(&p->run_list);
 	if (list_empty(p->array->queue + p->prio))
 		__clear_bit(p->prio, p->array->prio_bitmap);
+	WARN_ON(debug_rqbitmap(rq));
 }
 
 /*
@@ -797,12 +827,14 @@ static void enqueue_task(struct task_str
 {
 	__enqueue_task(p, rq);
 	list_add_tail(&p->run_list, p->array->queue + p->prio);
+	WARN_ON(debug_rqbitmap(rq));
 }
 
 static inline void enqueue_task_head(struct task_struct *p, struct rq *rq)
 {
 	__enqueue_task(p, rq);
 	list_add(&p->run_list, p->array->queue + p->prio);
+	WARN_ON(debug_rqbitmap(rq));
 }
 
 /*
@@ -820,6 +852,7 @@ static void requeue_task(struct task_str
 			__clear_bit(old_prio, old_array->prio_bitmap);
 		set_dynamic_bit(p, rq);
 	}
+	WARN_ON(debug_rqbitmap(rq));
 }
 
 /*
@@ -906,6 +939,7 @@ static inline void __activate_task(struc
 {
 	enqueue_task(p, rq);
 	inc_nr_running(p, rq);
+	WARN_ON(debug_rqbitmap(rq));
 }
 
 /*
@@ -1006,6 +1040,7 @@ static void deactivate_task(struct task_
 {
 	dec_nr_running(p, rq);
 	dequeue_task(p, rq);
+	WARN_ON(debug_rqbitmap(rq));
 }
 
 /*
@@ -1718,9 +1753,11 @@ void fastcall wake_up_new_task(struct ta
 		 * Parent and child are on different CPUs, now get the
 		 * parent runqueue to update the parent's ->flags:
 		 */
+		WARN_ON(debug_rqbitmap(rq));
 		task_rq_unlock(rq, &flags);
 		this_rq = task_rq_lock(current, &flags);
 	}
+	WARN_ON(debug_rqbitmap(this_rq));
 	task_rq_unlock(this_rq, &flags);
 }
 
@@ -2124,6 +2161,8 @@ static void pull_task(struct rq *src_rq,
 	enqueue_pulled_task(src_rq, this_rq, p);
 	p->timestamp = (p->timestamp - src_rq->most_recent_timestamp)
 				+ this_rq->most_recent_timestamp;
+	WARN_ON(debug_rqbitmap(src_rq));
+	WARN_ON(debug_rqbitmap(this_rq));
 	try_preempt(p, this_rq);
 }
 
@@ -3357,6 +3396,7 @@ static inline void major_prio_rotation(s
 	rq->dyn_bitmap = rq->active->prio_bitmap;
 	rq->best_static_prio = MAX_PRIO - 1;
 	rq->prio_rotation++;
+	WARN_ON(debug_rqbitmap(rq));
 }
 
 /*
@@ -3399,6 +3439,8 @@ static inline void rotate_runqueue_prior
 		}
 		memset(rq->prio_quota, 0, ARRAY_SIZE(rq->prio_quota));
 		major_prio_rotation(rq);
+		WARN_ON(debug_rqbitmap(rq));
+
 	} else {
 		/* Minor rotation */
 		new_prio_level = rq->prio_level + 1;
@@ -3409,6 +3451,7 @@ static inline void rotate_runqueue_prior
 			__set_bit(new_prio_level, rq->dyn_bitmap);
 		}
 		rq_quota(rq, rq->prio_level) = 0;
+		WARN_ON(debug_rqbitmap(rq));
 	}
 	rq->prio_level = new_prio_level;
 	/*
@@ -3431,6 +3474,10 @@ static void task_running_tick(struct rq 
 		return;
 
 	spin_lock(&rq->lock);
+	if (!p->time_slice) {
+		printk(KERN_ERR "NO TIME_SLICE IN TRT \n");
+		p->time_slice++;
+	}
 	/*
 	 * Accounting is performed by both the task and the runqueue. This
 	 * allows frequently sleeping tasks to get their proper quota of
@@ -3460,6 +3507,7 @@ static void task_running_tick(struct rq 
 		set_tsk_need_resched(p);
 	}
 out_unlock:
+	WARN_ON(debug_rqbitmap(rq));
 	spin_unlock(&rq->lock);
 }
 
@@ -3479,6 +3527,7 @@ void scheduler_tick(void)
 
 	if (!idle_at_tick)
 		task_running_tick(rq, p, 1);
+	WARN_ON(debug_rqbitmap(rq));
 #ifdef CONFIG_SMP
 	update_load(rq);
 	rq->idle_at_tick = idle_at_tick;
@@ -3548,6 +3597,7 @@ static inline struct task_struct *next_d
 	struct prio_array *array = rq->active;
 	int expirations = 0;
 
+	WARN_ON(debug_rqbitmap(rq));
 retry:
 	if (idx >= MAX_PRIO) {
 		BUG_ON(++expirations > 1);
@@ -3601,6 +3651,7 @@ retry:
 	if (next->static_prio < rq->best_static_prio &&
 	    next->policy != SCHED_BATCH)
 		rq->best_static_prio = next->static_prio;
+	WARN_ON(debug_rqbitmap(rq));
 	return next;
 }
 

-- 
-ck
