Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYIDVRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYIDVRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbYIDVQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:16:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbYIDVQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:16:49 -0400
Date: Thu, 4 Sep 2008 17:16:47 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, npiggin@suse.de,
       gregory.haskins@gmail.com
Subject: Re: [TIP/SCHED/DEVEL PATCH v3 6/6] sched: create "pushable_tasks"
 list to limit pushing to one attempt
In-Reply-To: <20080904125530.23633.44703.stgit@dev.haskins.net>
Message-ID: <alpine.DEB.1.10.0809041706050.3849@gandalf.stny.rr.com>
References: <20080904125029.23633.88210.stgit@dev.haskins.net> <20080904125530.23633.44703.stgit@dev.haskins.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 4 Sep 2008, Gregory Haskins wrote:
> 
> However, the current implementation suffers from a limitation in the
> push logic.  Once overloaded, all tasks (other than current) on the
> RQ are analyzed on every push operation, even if it was previously
> unpushable (due to affinity, etc).  Whats more, the operation stops
> at the first task that is unpushable and will not look at items
> lower in the queue.  This causes two problems:
> 
> 1) We can have the same tasks analyzed over and over again during each
>    push, which extends out the fast path in the scheduler for no
>    gain.  Consider a RQ that has dozens of tasks that are bound to a
>    core.  Each one of those tasks will be encountered and skipped
>    for each push operation while they are queued.
> 
> 2) There may be lower-priority tasks under the unpushable task that
>    could have been successfully pushed, but will never be considered
>    until either the unpushable task is cleared, or a pull operation
>    succeeds.  The net result is a potential latency source for mid
>    priority tasks.

Yep, we knew of these limitations when we created it. It was a big
TODO. Thanks for actually doing it. It is what? One year already?

;-)

> 
> This patch aims to rectify these two conditions by introducing a new
> priority sorted list: "pushable_tasks".  A task is added to the list
> each time a task is activated or preempted.  It is removed from the
> list any time it is deactivated, made current, or fails to push.
> 
> This works because a task only needs to be attempted to push once.
> After an initial failure to push, the other cpus will eventually try to
> pull the task when the conditions are proper.  This also solves the
> problem that we don't completely analyze all tasks due to encountering
> an unpushable tasks.  Now every task will have a push attempted (when
> appropriate).
> 
> This reduces latency both by shorting the critical section of the
> rq->lock for certain workloads, and by making sure the algorithm
> considers all eligible tasks in the system.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> CC: Steven Rostedt <srostedt@redhat.com>
> ---
> 
>  include/linux/init_task.h |    1 
>  include/linux/sched.h     |    1 
>  kernel/sched.c            |    4 ++
>  kernel/sched_rt.c         |  110 +++++++++++++++++++++++++++++++++++++++++----
>  4 files changed, 106 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> index 021d8e7..7f910f4 100644
> --- a/include/linux/init_task.h
> +++ b/include/linux/init_task.h
> @@ -140,6 +140,7 @@ extern struct group_info init_groups;
>  		.nr_cpus_allowed = NR_CPUS,				\
>  	},								\
>  	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
> +	.pushable_tasks = PLIST_NODE_INIT(tsk.pushable_tasks, MAX_PRIO), \
>  	.ptraced	= LIST_HEAD_INIT(tsk.ptraced),			\
>  	.ptrace_entry	= LIST_HEAD_INIT(tsk.ptrace_entry),		\
>  	.real_parent	= &tsk,						\
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index cf8cd8c..3480c8a 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1078,6 +1078,7 @@ struct task_struct {
>  #endif
>  
>  	struct list_head tasks;
> +	struct plist_node pushable_tasks;
>  
>  	struct mm_struct *mm, *active_mm;
>  
> diff --git a/kernel/sched.c b/kernel/sched.c
> index ddc3877..dbb9e8c 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -447,6 +447,7 @@ struct rt_rq {
>  #ifdef CONFIG_SMP
>  	unsigned long rt_nr_migratory;
>  	int overloaded;
> +	struct plist_head pushable_tasks;
>  #endif
>  	int rt_throttled;
>  	u64 rt_time;
> @@ -2383,6 +2384,8 @@ void sched_fork(struct task_struct *p, int clone_flags)
>  	/* Want to start with kernel preemption disabled. */
>  	task_thread_info(p)->preempt_count = 1;
>  #endif
> +	plist_node_init(&p->pushable_tasks, MAX_PRIO);
> +
>  	put_cpu();
>  }
>  
> @@ -8009,6 +8012,7 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
>  #ifdef CONFIG_SMP
>  	rt_rq->rt_nr_migratory = 0;
>  	rt_rq->overloaded = 0;
> +	plist_head_init(&rq->rt.pushable_tasks, &rq->lock);
>  #endif
>  
>  	rt_rq->rt_time = 0;
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 277ccd2..b22d18a 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -49,6 +49,24 @@ static void update_rt_migration(struct rq *rq)
>  		rq->rt.overloaded = 0;
>  	}
>  }
> +
> +static void enqueue_pushable_task(struct rq *rq, struct task_struct *p)
> +{
> +	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
> +	plist_node_init(&p->pushable_tasks, p->prio);
> +	plist_add(&p->pushable_tasks, &rq->rt.pushable_tasks);
> +}
> +
> +static void dequeue_pushable_task(struct rq *rq, struct task_struct *p)
> +{
> +	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
> +}
> +
> +#else
> +
> +#define enqueue_pushable_task(rq, p) do { } while (0)
> +#define dequeue_pushable_task(rq, p) do { } while (0)
> +
>  #endif /* CONFIG_SMP */
>  
>  static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
> @@ -669,6 +687,9 @@ static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
>  
>  	enqueue_rt_entity(rt_se);
>  
> +	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
> +		enqueue_pushable_task(rq, p);
> +
>  	inc_cpu_load(rq, p->se.load.weight);
>  }
>  
> @@ -679,6 +700,8 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
>  	update_curr_rt(rq);
>  	dequeue_rt_entity(rt_se);
>  
> +	dequeue_pushable_task(rq, p);
> +
>  	dec_cpu_load(rq, p->se.load.weight);
>  }
>  
> @@ -824,7 +847,7 @@ static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
>  	return next;
>  }
>  
> -static struct task_struct *pick_next_task_rt(struct rq *rq)
> +static struct task_struct *_pick_next_task_rt(struct rq *rq)
>  {
>  	struct sched_rt_entity *rt_se;
>  	struct task_struct *p;
> @@ -846,6 +869,18 @@ static struct task_struct *pick_next_task_rt(struct rq *rq)
>  
>  	p = rt_task_of(rt_se);
>  	p->se.exec_start = rq->clock;
> +
> +	return p;
> +}
> +
> +static struct task_struct *pick_next_task_rt(struct rq *rq)
> +{
> +	struct task_struct *p = _pick_next_task_rt(rq);
> +
> +	/* The running task is never eligible for pushing */
> +	if (p)
> +		dequeue_pushable_task(rq, p);
> +
>  	return p;
>  }
>  
> @@ -853,6 +888,13 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
>  {
>  	update_curr_rt(rq);
>  	p->se.exec_start = 0;
> +
> +	/*
> +	 * The previous task needs to be made eligible for pushing
> +	 * if it is still active
> +	 */
> +	if (p->se.on_rq && p->rt.nr_cpus_allowed > 1)
> +		enqueue_pushable_task(rq, p);
>  }
>  
>  #ifdef CONFIG_SMP
> @@ -1031,6 +1073,28 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
>  	return lowest_rq;
>  }
>  
> +static inline int has_pushable_tasks(struct rq *rq)
> +{
> +	return !plist_head_empty(&rq->rt.pushable_tasks);
> +}
> +
> +static struct task_struct *pick_next_pushable_task(struct rq *rq)
> +{
> +	struct task_struct *p;
> +
> +	if (!has_pushable_tasks(rq))
> +		return NULL;
> +
> +	p = plist_first_entry(&rq->rt.pushable_tasks,
> +			      struct task_struct, pushable_tasks);
> +
> +	BUG_ON(rq->cpu != task_cpu(p));
> +	BUG_ON(task_current(rq, p));
> +	BUG_ON(p->rt.nr_cpus_allowed <= 1);

I have two new BUG_ONs for you. (This isn't a fast path)

	BUG_ON(!p->se.on_rq);
	BUG_ON(!rt_task(p));


> +
> +	return p;
> +}
> +
>  /*
>   * If the current CPU has more than one RT task, see if the non
>   * running task can migrate over to a CPU that is running a task
> @@ -1040,13 +1104,12 @@ static int push_rt_task(struct rq *rq)
>  {
>  	struct task_struct *next_task;
>  	struct rq *lowest_rq;
> -	int ret = 0;
>  	int paranoid = RT_MAX_TRIES;
>  
>  	if (!rq->rt.overloaded)
>  		return 0;
>  
> -	next_task = pick_next_highest_task_rt(rq, -1);
> +	next_task = pick_next_pushable_task(rq);
>  	if (!next_task)
>  		return 0;
>  
> @@ -1078,12 +1141,19 @@ static int push_rt_task(struct rq *rq)
>  		 * so it is possible that next_task has changed.
>  		 * If it has, then try again.
>  		 */
> -		task = pick_next_highest_task_rt(rq, -1);
> +		task = pick_next_pushable_task(rq);
>  		if (unlikely(task != next_task) && task && paranoid--) {
>  			put_task_struct(next_task);
>  			next_task = task;
>  			goto retry;
>  		}
> +
> +		/*
> +		 * Once we have failed to push this task, we will not
> +		 * try again, since the other cpus will pull from us
> +		 * when they are ready
> +		 */
> +		dequeue_pushable_task(rq, next_task);
>  		goto out;
>  	}
>  
> @@ -1095,11 +1165,10 @@ static int push_rt_task(struct rq *rq)
>  
>  	double_unlock_balance(rq, lowest_rq);
>  
> -	ret = 1;
>  out:
>  	put_task_struct(next_task);
>  
> -	return ret;
> +	return 1;
>  }
>  
>  /*
> @@ -1128,7 +1197,7 @@ static int pull_rt_task(struct rq *this_rq)
>  	if (likely(!rt_overloaded(this_rq)))
>  		return 0;
>  
> -	next = pick_next_task_rt(this_rq);
> +	next = _pick_next_task_rt(this_rq);
>  
>  	for_each_cpu_mask_nr(cpu, this_rq->rd->rto_mask) {
>  		if (this_cpu == cpu)
> @@ -1145,7 +1214,7 @@ static int pull_rt_task(struct rq *this_rq)
>  		if (double_lock_balance(this_rq, src_rq)) {
>  			struct task_struct *old_next = next;
>  
> -			next = pick_next_task_rt(this_rq);
> +			next = _pick_next_task_rt(this_rq);
>  			if (next != old_next)
>  				ret = 1;
>  		}
> @@ -1217,7 +1286,7 @@ static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
>   */
>  static int needs_post_schedule_rt(struct rq *rq)
>  {
> -	return rq->rt.overloaded ? 1 : 0;
> +	return has_pushable_tasks(rq);
>  }
>  
>  static void post_schedule_rt(struct rq *rq)
> @@ -1240,7 +1309,7 @@ static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
>  {
>  	if (!task_running(rq, p) &&
>  	    !test_tsk_need_resched(rq->curr) &&
> -	    rq->rt.overloaded &&
> +	    has_pushable_tasks(rq) &&
>  	    p->rt.nr_cpus_allowed > 1)
>  		push_rt_tasks(rq);
>  }
> @@ -1277,6 +1346,24 @@ static void set_cpus_allowed_rt(struct task_struct *p,
>  	if (p->se.on_rq && (weight != p->rt.nr_cpus_allowed)) {
>  		struct rq *rq = task_rq(p);
>  
> +		if (!task_current(rq, p)) {
> +			/*
> +			 * Make sure we dequeue this task from the pushable list
> +			 * before going further.  It will either remain off of
> +			 * the list because we are no longer pushable, or it
> +			 * will be requeued.
> +			 */
> +			if (p->rt.nr_cpus_allowed > 1)
> +				dequeue_pushable_task(rq, p);
> +
> +			/*
> +			 * Requeue if our weight is changing and still > 1
> +			 */
> +			if (weight > 1)
> +				enqueue_pushable_task(rq, p);
> +
> +		}
> +
>  		if ((p->rt.nr_cpus_allowed <= 1) && (weight > 1)) {
>  			rq->rt.rt_nr_migratory++;
>  		} else if ((p->rt.nr_cpus_allowed > 1) && (weight <= 1)) {
> @@ -1453,6 +1540,9 @@ static void set_curr_task_rt(struct rq *rq)
>  	struct task_struct *p = rq->curr;
>  
>  	p->se.exec_start = rq->clock;
> +
> +	/* The running task is never eligible for pushing */
> +	dequeue_pushable_task(rq, p);
>  }
>  
>  static const struct sched_class rt_sched_class = {
> 

OK, I like the patch, but I'm not 100% that it doesn't have bugs. I'll ACK 
it, but this definitely needs to be heavily tested, before going mainline. 
But for linux-tip, -mm, or linux-next, I think it is, on the surface, 
good to go (with the added BUG_ONs).

I'll pull it into -rt as well.

Acked-by: Steven Rostedt <srostedt@redhat.com>

Thanks,

-- Steve

