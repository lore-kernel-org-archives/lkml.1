Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbYGCMQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbYGCMQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbYGCMQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:16:09 -0400
Received: from smtpsrv0.isis.unc.edu ([152.2.1.139]:40736 "EHLO smtp.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758305AbYGCMQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:16:05 -0400
X-Greylist: delayed 1243 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2008 08:16:04 EDT
Message-ID: <20080703073035.5w35c70kjc4o0s4c@webmail4.isis.unc.edu>
Date: Thu, 03 Jul 2008 07:30:35 -0400
From: jha@email.unc.edu
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "James H. Anderson" <anderson@cs.unc.edu>, jeffay@cs.unc.edu
Subject: Re: [PATCH] sched: fix unfairness when upgrade weight
References: <48687CDB.5070702@cn.fujitsu.com>
	<1215035379.28676.32.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1215035379.28676.32.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: UNC-CH Webmail 2.0
X-Organization: University of North Carolina at Chapel Hill
X-Originating-IP: 147.32.80.98
X-Remote-Browser: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US;
	rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

In the scenarios below, processes are changing weights.  In the 
scheduling literature, people instead talk about processes leaving and 
joining the system.  A weight change is viewed as a special case where 
a process leaves with its old weight and re-joins with its new weight.  
It is well known that allowing tasks with non-zero lag to leave causes 
the sorts of problems you are observing -- in fact, this is one of the 
"classic" issues people have looked at w.r.t. fairness.  We have looked 
at this extensively on multiprocessors.  However, your scenarios (as I 
understand them) really involve just a single processor.  The most 
accessible resource I know on this issue that just focuses on 
uniprocessors is:

A Proportional Share Resource Allocation Algorithm For Real-Time, 
Time-Shared Systems
IEEE Real-Time Systems Symposium, December 1996.
http://www.cs.unc.edu/~jeffay/papers/RTSS-96a.pdf

A slightly longer version of this paper exists that contains some of 
the missing proofs, but I always have trouble locating it on-line (it's 
in a non-obvious place, I think).   I've cc'ed Kevin Jeffay, one of the 
co-authors.  Maybe he can point you to the longer version.

BTW, if I recall correctly, the very lag scaling idea you mentioned is 
discussed in Kevin's paper.

Hope this helps.

-Jim Anderson


Quoting Peter Zijlstra <peterz@infradead.org>:

> Hi Lai,
>
> On Mon, 2008-06-30 at 14:27 +0800, Lai Jiangshan wrote:
>> When two or more process upgrade their priority,
>> unfairness will happen, several of them may get all cpu-usage,
>> and the other cannot be scheduled to run for a long time.
>>
>> example:
>> # (create 2 processes and set affinity to cpu#0)
>> # renice 19 pid1 pid2
>> # renice -19 pid1 pid2
>>
>> step3 upgrade the 2 processes' weight, these 2 processes should
>> share the cpu#0 as soon as possible after step3, and any of them
>> should get 50% cpu-usage. But sometimes one of them gets all cpu-usage
>> for tens of seconds before they share the cpu#0.
>>
>> fair-group example:
>> # mkdir 1 2 (create 2 fair-groups)
>> # (create 2 processes and set affinity to cpu#0)
>> # echo pid1 > 1/tasks ; echo pid2 > 2/tasks
>> # echo 2 > 1/cpu.shares ; echo 2 > 2/cpu.shares
>> # echo $((2**18)) > 1/cpu.shares ; echo $((2**18)) > 2/cpu.shares
>>
>> The reason why such unfairness happened:
>>
>> When a sched_entity is running, if its weight is low, its vruntime
>> increases by a large value every time and if its weight
>> is high, its vruntime increases by a small value.
>>
>> So when the two sched_entity's weight is low, they will still
>> fairness even if difference of their vruntime is large, but if
>> their weight are upgraded, this large difference of vruntime
>> will bring unfairness.
>>
>> example:
>> se1's vruntime         se2's vruntime
>>     1000M               (R) 1020M
>> 	(assume vruntime is increases by about 50M every time)
>> (R) 1050M                   1020M
>>     1050M               (R) 1070M
>> (R) 1100M                   1070M
>>     1100M               (R) 1120M
>> 	(fairness, even if difference of their vruntime is large)
>> 	(upgrade their weight, vruntime is increases by about 10K)
>> (R) 1100M+10K               1120M
>> (R) 1100M+20K               1120M
>> (R) 1100M+30K               1120M
>> (R) 1100M+40K               1120M
>> (R) 1100M+50K               1120M
>> 	(se1 gets all cpu-usage for long time (mybe about tens
>> of seconds))
>> 	(unfairness, difference=20M is too large for new weight)
>
> My initial response to this email was: sure, that's because you cannot
> renice two tasks atomically - we'll just have to live with that.
>
> However after a bit more thought it occurred to me this is because we're
> changing the weight of a task with non-zero lag.
>
> I think the proper solution to this problem is to scale the lag
> according to the change in weights. But lets ask James, who is an expert
> in this area.
>
>
> So while I think you're right in that we have an issue, I don't like
> your solution.
>
> How about something like these patches (compile tested only).
>
> ---
> Subject: sched: fair: avg_vruntime
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> In order to implement a deadline scheduler we need to be able to test
> eligibility. This requires knowing the current virtual time. We use a 
> property
> of fair schedulers to determine this in an numerically stable way, namely the
> sum of all lags is 0. Therefore the average of all virtual times is the
> position of lag=0.
>
> We can't just take the average of vruntime - as it will use the full range
> of its u64 and will wrap around. Instead we'll use the average of
> (vruntime - min_vruntime)
>
> \Sum_{i}^{n} 1/n (v_{i} - v) = 1/n (\Sum_{i}^{n} v_{i}) - vn
>
> By factoring out the 1/n (never storing that) we avoid rounding, which
> would bring an accumulating error.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> kernel/sched.c       |    3 ++
> kernel/sched_debug.c |    3 ++
> kernel/sched_fair.c  |   68 
> ++++++++++++++++++++++++++++++++++++++++++---------
> 3 files changed, 62 insertions(+), 12 deletions(-)
>
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c	2008-07-02 17:56:31.000000000 +0200
> +++ linux-2.6/kernel/sched.c	2008-07-02 23:43:44.000000000 +0200
> @@ -377,6 +377,9 @@ struct cfs_rq {
> 	struct load_weight load;
> 	unsigned long nr_running;
>
> +	long nr_queued;
> +	s64 avg_vruntime;
> +
> 	u64 exec_clock;
> 	u64 min_vruntime;
> 	u64 pair_start;
> Index: linux-2.6/kernel/sched_debug.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_debug.c	2008-07-02 17:56:30.000000000 +0200
> +++ linux-2.6/kernel/sched_debug.c	2008-07-02 23:36:09.000000000 +0200
> @@ -161,6 +161,9 @@ void print_cfs_rq(struct seq_file *m, in
> 			SPLIT_NS(spread0));
> 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
> 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
> +	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "avg_vruntime",
> +			SPLIT_NS(avg_vruntime(cfs_rq)));
> +
> #ifdef CONFIG_SCHEDSTATS
> #define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
>
> Index: linux-2.6/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_fair.c	2008-07-02 17:56:30.000000000 +0200
> +++ linux-2.6/kernel/sched_fair.c	2008-07-02 23:43:44.000000000 +0200
> @@ -221,6 +221,55 @@ static inline s64 entity_key(struct cfs_
> 	return se->vruntime - cfs_rq->min_vruntime;
> }
>
> +static void
> +avg_vruntime_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
> +{
> +	s64 key = entity_key(cfs_rq, se);
> +	cfs_rq->avg_vruntime += key;
> +	cfs_rq->nr_queued++;
> +}
> +
> +static void
> +avg_vruntime_sub(struct cfs_rq *cfs_rq, struct sched_entity *se)
> +{
> +	s64 key = entity_key(cfs_rq, se);
> +	cfs_rq->avg_vruntime -= key;
> +	cfs_rq->nr_queued--;
> +}
> +
> +static inline
> +void avg_vruntime_update(struct cfs_rq *cfs_rq, s64 delta)
> +{
> +	cfs_rq->avg_vruntime -= cfs_rq->nr_queued * delta;
> +}
> +
> +static u64 avg_vruntime(struct cfs_rq *cfs_rq)
> +{
> +	s64 avg = cfs_rq->avg_vruntime;
> +
> +	if (cfs_rq->nr_queued)
> +		avg = div_s64(avg, cfs_rq->nr_queued);
> +
> +	return cfs_rq->min_vruntime + avg;
> +}
> +
> +/*
> + * maintain cfs_rq->min_vruntime to be a monotonic increasing
> + * value tracking the leftmost vruntime in the tree.
> + */
> +static void
> +update_min_vruntime(struct cfs_rq *cfs_rq, struct sched_entity *se)
> +{
> +	/*
> +	 * open coded max_vruntime() to allow updating avg_vruntime
> +	 */
> +	s64 delta = (s64)(se->vruntime - cfs_rq->min_vruntime);
> +	if (delta > 0) {
> +		avg_vruntime_update(cfs_rq, delta);
> +		cfs_rq->min_vruntime = se->vruntime;
> +	}
> +}
> +
> /*
>  * Enqueue an entity into the rb-tree:
>  */
> @@ -232,6 +281,8 @@ static void __enqueue_entity(struct cfs_
> 	s64 key = entity_key(cfs_rq, se);
> 	int leftmost = 1;
>
> +	avg_vruntime_add(cfs_rq, se);
> +
> 	/*
> 	 * Find the right place in the rbtree:
> 	 */
> @@ -256,12 +307,7 @@ static void __enqueue_entity(struct cfs_
> 	 */
> 	if (leftmost) {
> 		cfs_rq->rb_leftmost = &se->run_node;
> -		/*
> -		 * maintain cfs_rq->min_vruntime to be a monotonic increasing
> -		 * value tracking the leftmost vruntime in the tree.
> -		 */
> -		cfs_rq->min_vruntime =
> -			max_vruntime(cfs_rq->min_vruntime, se->vruntime);
> +		update_min_vruntime(cfs_rq, se);
> 	}
>
> 	rb_link_node(&se->run_node, parent, link);
> @@ -272,17 +318,13 @@ static void __dequeue_entity(struct cfs_
> {
> 	if (cfs_rq->rb_leftmost == &se->run_node) {
> 		struct rb_node *next_node;
> -		struct sched_entity *next;
>
> 		next_node = rb_next(&se->run_node);
> 		cfs_rq->rb_leftmost = next_node;
>
> 		if (next_node) {
> -			next = rb_entry(next_node,
> -					struct sched_entity, run_node);
> -			cfs_rq->min_vruntime =
> -				max_vruntime(cfs_rq->min_vruntime,
> -					     next->vruntime);
> +			update_min_vruntime(cfs_rq, rb_entry(next_node,
> +						struct sched_entity, run_node));
> 		}
> 	}
>
> @@ -290,6 +332,8 @@ static void __dequeue_entity(struct cfs_
> 		cfs_rq->next = NULL;
>
> 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
> +
> +	avg_vruntime_sub(cfs_rq, se);
> }
>
> static inline struct rb_node *first_fair(struct cfs_rq *cfs_rq)
>
>
> ---
> Subject: sched: non-zero lag renice
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> In the case where we renice a task which has non-zero lag, its not clear
> what needs to be done, as it has a deviation from fairness.
>
> Try to compensate this by scaling the lag (deviation from fairness) by the
> change in weights.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> kernel/sched.c      |   14 +++++++-------
> kernel/sched_fair.c |   26 ++++++++++++++++++++++++++
> 2 files changed, 33 insertions(+), 7 deletions(-)
>
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c	2008-07-02 23:35:24.000000000 +0200
> +++ linux-2.6/kernel/sched.c	2008-07-02 23:40:12.000000000 +0200
> @@ -4780,12 +4780,9 @@ void set_user_nice(struct task_struct *p
>
> 	if (on_rq) {
> 		enqueue_task(rq, p, 0);
> -		/*
> -		 * If the task increased its priority or is running and
> -		 * lowered its priority, then reschedule its CPU:
> -		 */
> -		if (delta < 0 || (delta > 0 && task_running(rq, p)))
> -			resched_task(rq->curr);
> +
> +		check_class_changed(rq, p, p->sched_class, old_prio,
> +				    task_running(rq, p));
> 	}
> out_unlock:
> 	task_rq_unlock(rq, &flags);
> @@ -8527,6 +8524,7 @@ void sched_move_task(struct task_struct
> static void __set_se_shares(struct sched_entity *se, unsigned long shares)
> {
> 	struct cfs_rq *cfs_rq = se->cfs_rq;
> +	unsigned long old_weight = se->load.weight;
> 	int on_rq;
>
> 	on_rq = se->on_rq;
> @@ -8536,8 +8534,10 @@ static void __set_se_shares(struct sched
> 	se->load.weight = shares;
> 	se->load.inv_weight = 0;
>
> -	if (on_rq)
> +	if (on_rq) {
> 		enqueue_entity(cfs_rq, se, 0);
> +		prio_changed_entity(cfs_rq, se, old_weight, shares);
> +	}
> }
>
> static void set_se_shares(struct sched_entity *se, unsigned long shares)
> Index: linux-2.6/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_fair.c	2008-07-02 23:35:37.000000000 +0200
> +++ linux-2.6/kernel/sched_fair.c	2008-07-02 23:36:37.000000000 +0200
> @@ -1680,6 +1680,28 @@ static void task_new_fair(struct rq *rq,
> 	resched_task(rq->curr);
> }
>
> +static void prio_changed_entity(struct cfs_rq *cfs_rq, struct 
> sched_entity *se,
> +		unsigned long old_weight, unsigned long new_weight)
> +{
> +	u64 avg;
> +	s64 lag;
> +
> +	if (old_weight == new_weight)
> +		return;
> +
> +	dequeue_entity(cfs_rq, se, 0);
> +
> +	avg = avg_vruntime(cfs_rq);
> +	lag = (s64)(se->vruntime - avg);
> +
> +	lag *= new_weight;
> +	lag = div_s64(lag, old_weight);
> +
> +	se->vruntime = avg + lag;
> +
> +	enqueue_entity(cfs_rq, se, 0);
> +}
> +
> /*
>  * Priority of the task has changed. Check to see if we preempt
>  * the current task.
> @@ -1687,6 +1709,10 @@ static void task_new_fair(struct rq *rq,
> static void prio_changed_fair(struct rq *rq, struct task_struct *p,
> 			      int oldprio, int running)
> {
> +	prio_changed_entity(&rq->cfs, &p->se,
> +			    prio_to_weight[USER_PRIO(oldprio)],
> +			    prio_to_weight[USER_PRIO(p->prio)]);
> +
> 	/*
> 	 * Reschedule if we are currently running on this runqueue and
> 	 * our priority decreased, or if we are not currently running on
>
>
>


