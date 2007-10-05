Return-Path: <linux-kernel-owner+w=401wt.eu-S1761101AbXJELrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761101AbXJELrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 07:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXJELrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 07:47:11 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39564 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbXJELrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 07:47:07 -0400
Date: Fri, 5 Oct 2007 17:16:57 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       oleg@tv-sign.ru, srostedt@redhat.com
Subject: Re: [PATCH RFC 6/9] RCU priority boosting for preemptible RCU
Message-ID: <20071005114657.GA17788@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183901.GF3819@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910183901.GF3819@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 11:39:01AM -0700, Paul E. McKenney wrote:

[snip]

> +
> +/*
> + * Return the list from which to boost target tasks.
> + * May only be invoked by the booster task, so guaranteed to
> + * already be initialized.  Use rcu_boost_dat element least recently
> + * the destination for task blocking in RCU read-side critical sections.
> + */
> +static inline struct rcu_boost_dat *rcu_rbd_boosting(int cpu)
> +{
> +	int idx = (rcu_boost_idx + 1) & (RCU_BOOST_ELEMENTS - 1);

Why is this masking required? When we increment 
the rcu_boost_idx in rcu_booster, we do perform a modulo operation 
to ensure that it wraps around RCU_BOOST_ELEMENTS. 


> +
> +	return &per_cpu(rcu_boost_dat, cpu)[idx];
> +}
> +
> +#define PREEMPT_RCU_BOOSTER_PRIO 49  /* Match curr_irq_prio manually. */
> +				     /*  Administrators can always adjust */
> +				     /*  via the /proc interface. */
> +
> +/*
> + * Boost the specified task from an RCU viewpoint.
> + * Boost the target task to a priority just a bit less-favored than
> + * that of the RCU-boost task, but boost to a realtime priority even
> + * if the RCU-boost task is running at a non-realtime priority.
> + * We check the priority of the RCU-boost task each time we boost
> + * in case the sysadm manually changes the priority.
> + */
> +static void rcu_boost_prio(struct task_struct *taskp)
> +{
> +	unsigned long flags;
> +	int rcuprio;
> +
> +	spin_lock_irqsave(&current->pi_lock, flags);
> +	rcuprio = rt_mutex_getprio(current) + 1;
> +	if (rcuprio >= MAX_USER_RT_PRIO)
> +		rcuprio = MAX_USER_RT_PRIO - 1;
> +	spin_unlock_irqrestore(&current->pi_lock, flags);
> +	spin_lock_irqsave(&taskp->pi_lock, flags);
> +	if (taskp->rcu_prio != rcuprio) {
> +		taskp->rcu_prio = rcuprio;
> +		if (taskp->rcu_prio < taskp->prio)
> +			rt_mutex_setprio(taskp, taskp->rcu_prio);
> +	}
> +	spin_unlock_irqrestore(&taskp->pi_lock, flags);
> +}
> +
> +/*
> + * Unboost the specified task from an RCU viewpoint.
> + */
> +static void rcu_unboost_prio(struct task_struct *taskp)
> +{
> +	int nprio;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&taskp->pi_lock, flags);
> +	taskp->rcu_prio = MAX_PRIO;
> +	nprio = rt_mutex_getprio(taskp);
> +	if (nprio > taskp->prio)
> +		rt_mutex_setprio(taskp, nprio);
> +	spin_unlock_irqrestore(&taskp->pi_lock, flags);
> +}
> +
> +/*
> + * Boost all of the RCU-reader tasks on the specified list.
> + */
> +static void rcu_boost_one_reader_list(struct rcu_boost_dat *rbdp)
> +{
> +	LIST_HEAD(list);
> +	unsigned long flags;
> +	struct task_struct *taskp;
> +
> +	/*
> +	 * Splice both lists onto a local list.  We will still
> +	 * need to hold the lock when manipulating the local list
> +	 * because tasks can remove themselves at any time.
> +	 * The reason for splicing the rbs_boosted list is that
> +	 * our priority may have changed, so reboosting may be
> +	 * required.
> +	 */
> +
> +	spin_lock_irqsave(&rbdp->rbs_lock, flags);
> +	list_splice_init(&rbdp->rbs_toboost, &list);
> +	list_splice_init(&rbdp->rbs_boosted, &list);
> +	while (!list_empty(&list)) {
> +
> +		/*
> +		 * Pause for a bit before boosting each task.
> +		 * @@@FIXME: reduce/eliminate pausing in case of OOM.
> +		 */
> +
> +		spin_unlock_irqrestore(&rbdp->rbs_lock, flags);
> +		schedule_timeout_uninterruptible(1);
> +		spin_lock_irqsave(&rbdp->rbs_lock, flags);
> +
> +		/*
> +		 * All tasks might have removed themselves while
> +		 * we were waiting.  Recheck list emptiness.
> +		 */
> +
> +		if (list_empty(&list))
> +			break;
> +
> +		/* Remove first task in local list, count the attempt. */
> +
> +		taskp = list_entry(list.next, typeof(*taskp), rcub_entry);
> +		list_del_init(&taskp->rcub_entry);
> +		rbdp->rbs_boost_attempt++;
> +
> +		/* Ignore tasks in unexpected states. */
> +
> +		if (taskp->rcub_state == RCU_BOOST_IDLE) {
> +			list_add_tail(&taskp->rcub_entry, &rbdp->rbs_toboost);
> +			rcu_boost_dat_stat_boost(rbdp, taskp->rcub_state);
> +			continue;
> +		}
> +
> +		/* Boost the task's priority. */
> +
> +		rcu_boost_prio(taskp);
> +		rbdp->rbs_boost++;
> +		rcu_boost_dat_stat_boost(rbdp, taskp->rcub_state);
> +		taskp->rcub_state = RCU_BOOSTED;
> +		list_add_tail(&taskp->rcub_entry, &rbdp->rbs_boosted);
> +	}
> +	spin_unlock_irqrestore(&rbdp->rbs_lock, flags);
> +}
> +
> +/*
> + * Priority-boost tasks stuck in RCU read-side critical sections as
> + * needed (presumably rarely).
> + */
> +static int rcu_booster(void *arg)
> +{
> +	int cpu;
> +	struct sched_param sp = { .sched_priority = PREEMPT_RCU_BOOSTER_PRIO, };
> +
> +	sched_setscheduler(current, SCHED_RR, &sp);
> +	current->flags |= PF_NOFREEZE;
> +
> +	do {
> +
> +		/* Advance the lists of tasks. */
> +
> +		rcu_boost_idx = (rcu_boost_idx + 1) % RCU_BOOST_ELEMENTS;
> +		for_each_possible_cpu(cpu) {
> +
> +			/*
> +			 * Boost all sufficiently aged readers.
> +			 * Readers must first be preempted or block
> +			 * on a mutex in an RCU read-side critical section,
> +			 * then remain in that critical section for
> +			 * RCU_BOOST_ELEMENTS-1 time intervals.
> +			 * So most of the time we should end up doing
> +			 * nothing.
> +			 */
> +
> +			rcu_boost_one_reader_list(rcu_rbd_boosting(cpu));
> +
> +			/*
> +			 * Large SMP systems may need to sleep sometimes
> +			 * in this loop.  Or have multiple RCU-boost tasks.
> +			 */
> +		}
> +
> +		/*
> +		 * Sleep to allow any unstalled RCU read-side critical
> +		 * sections to age out of the list.  @@@ FIXME: reduce,
> +		 * adjust, or eliminate in case of OOM.
> +		 */
> +
> +		schedule_timeout_uninterruptible(HZ);
> +
> +		/* Print stats if enough time has passed. */
> +
> +		rcu_boost_dat_stat_print();
> +
> +	} while (!kthread_should_stop());
> +
> +	return 0;
> +}
> +
> +/*
> + * Perform the portions of RCU-boost initialization that require the
> + * scheduler to be up and running.
> + */
> +void init_rcu_boost_late(void)
> +{
> +
> +	/* Spawn RCU-boost task. */
> +
> +	printk(KERN_INFO "Starting RCU priority booster\n");
> +	rcu_boost_task = kthread_run(rcu_booster, NULL, "RCU Prio Booster");
> +	if (IS_ERR(rcu_boost_task))
> +		panic("Unable to create RCU Priority Booster, errno %ld\n",
> +		      -PTR_ERR(rcu_boost_task));
> +}
> +
> +/*
> + * Update task's RCU-boost state to reflect blocking in RCU read-side
> + * critical section, so that the RCU-boost task can find it in case it
> + * later needs its priority boosted.
> + */
> +void __rcu_preempt_boost(void)
> +{
> +	struct rcu_boost_dat *rbdp;
> +	unsigned long flags;
> +
> +	/* Identify list to place task on for possible later boosting. */
> +
> +	local_irq_save(flags);
> +	rbdp = rcu_rbd_new();
> +	if (rbdp == NULL) {
> +		local_irq_restore(flags);
> +		printk(KERN_INFO
> +		       "Preempted RCU read-side critical section too early.\n");
> +		return;
> +	}
> +	spin_lock(&rbdp->rbs_lock);
> +	rbdp->rbs_blocked++;
> +
> +	/*
> +	 * Update state.  We hold the lock and aren't yet on the list,
> +	 * so the booster cannot mess with us yet.
> +	 */
> +
> +	rcu_boost_dat_stat_block(rbdp, current->rcub_state);
> +	if (current->rcub_state != RCU_BOOST_IDLE) {
> +
> +		/*
> +		 * We have been here before, so just update stats.
> +		 * It may seem strange to do all this work just to
> +		 * accumulate statistics, but this is such a
> +		 * low-probability code path that we shouldn't care.
> +		 * If it becomes a problem, it can be fixed.
> +		 */
> +
> +		spin_unlock_irqrestore(&rbdp->rbs_lock, flags);
> +		return;
> +	}
> +	current->rcub_state = RCU_BOOST_BLOCKED;
> +
> +	/* Now add ourselves to the list so that the booster can find us. */
> +
> +	list_add_tail(&current->rcub_entry, &rbdp->rbs_toboost);
> +	current->rcub_rbdp = rbdp;
> +	spin_unlock_irqrestore(&rbdp->rbs_lock, flags);
> +}
> +
> +/*
> + * Do the list-removal and priority-unboosting "heavy lifting" when
> + * required.
> + */
> +static void __rcu_read_unlock_unboost(void)
> +{
> +	unsigned long flags;
> +	struct rcu_boost_dat *rbdp;
> +
> +	/* Identify the list structure and acquire the corresponding lock. */
> +
> +	rbdp = current->rcub_rbdp;
> +	spin_lock_irqsave(&rbdp->rbs_lock, flags);
> +
> +	/* Remove task from the list it was on. */
> +
> +	list_del_init(&current->rcub_entry);
> +	rbdp->rbs_unlock++;
> +	current->rcub_rbdp = NULL;
> +
> +	/* Record stats, unboost if needed, and update state. */
> +
> +	rcu_boost_dat_stat_unlock(rbdp, current->rcub_state);
> +	if (current->rcub_state == RCU_BOOSTED) {
> +		rcu_unboost_prio(current);
> +		rbdp->rbs_unboosted++;
> +	}
> +	current->rcub_state = RCU_BOOST_IDLE;
> +	spin_unlock_irqrestore(&rbdp->rbs_lock, flags);
> +}
> +
> +/*
> + * Do any state changes and unboosting needed for rcu_read_unlock().
> + * Pass any complex work on to __rcu_read_unlock_unboost().
> + * The vast majority of the time, no work will be needed, as preemption
> + * and blocking within RCU read-side critical sections is comparatively
> + * rare.
> + */
> +static inline void rcu_read_unlock_unboost(void)
> +{
> +
> +	if (unlikely(current->rcub_state != RCU_BOOST_IDLE))
> +		__rcu_read_unlock_unboost();
> +}
> +
> +#endif /* #else #ifndef CONFIG_PREEMPT_RCU_BOOST */
> +
>  /*
>   * States for rcu_try_flip() and friends.
>   */
> @@ -128,14 +662,6 @@ static DEFINE_PER_CPU(enum rcu_mb_flag_v
>  static cpumask_t rcu_cpu_online_map = CPU_MASK_NONE;
> 
>  /*
> - * Macro that prevents the compiler from reordering accesses, but does
> - * absolutely -nothing- to prevent CPUs from reordering.  This is used
> - * only to mediate communication between mainline code and hardware
> - * interrupt and NMI handlers.
> - */
> -#define ORDERED_WRT_IRQ(x) (*(volatile typeof(x) *)&(x))
> -
> -/*
>   * RCU_DATA_ME: find the current CPU's rcu_data structure.
>   * RCU_DATA_CPU: find the specified CPU's rcu_data structure.
>   */
> @@ -194,7 +720,7 @@ void __rcu_read_lock(void)
>  		me->rcu_read_lock_nesting = nesting + 1;
> 
>  	} else {
> -		unsigned long oldirq;
> +		unsigned long flags;
> 
>  		/*
>  		 * Disable local interrupts to prevent the grace-period
> @@ -203,7 +729,7 @@ void __rcu_read_lock(void)
>  		 * contain rcu_read_lock().
>  		 */
> 
> -		local_irq_save(oldirq);
> +		local_irq_save(flags);
> 
>  		/*
>  		 * Outermost nesting of rcu_read_lock(), so increment
> @@ -233,7 +759,7 @@ void __rcu_read_lock(void)
>  		 */
> 
>  		ORDERED_WRT_IRQ(me->rcu_flipctr_idx) = idx;
> -		local_irq_restore(oldirq);
> +		local_irq_restore(flags);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(__rcu_read_lock);
> @@ -255,7 +781,7 @@ void __rcu_read_unlock(void)
>  		me->rcu_read_lock_nesting = nesting - 1;
> 
>  	} else {
> -		unsigned long oldirq;
> +		unsigned long flags;
> 
>  		/*
>  		 * Disable local interrupts to prevent the grace-period
> @@ -264,7 +790,7 @@ void __rcu_read_unlock(void)
>  		 * contain rcu_read_lock() and rcu_read_unlock().
>  		 */
> 
> -		local_irq_save(oldirq);
> +		local_irq_save(flags);
> 
>  		/*
>  		 * Outermost nesting of rcu_read_unlock(), so we must
> @@ -305,7 +831,10 @@ void __rcu_read_unlock(void)
>  		 */
> 
>  		ORDERED_WRT_IRQ(__get_cpu_var(rcu_flipctr)[idx])--;
> -		local_irq_restore(oldirq);
> +
> +		rcu_read_unlock_unboost();
> +
> +		local_irq_restore(flags);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(__rcu_read_unlock);
> @@ -504,10 +1033,10 @@ rcu_try_flip_waitmb(void)
>   */
>  static void rcu_try_flip(void)
>  {
> -	unsigned long oldirq;
> +	unsigned long flags;
> 
>  	RCU_TRACE_ME(rcupreempt_trace_try_flip_1);
> -	if (unlikely(!spin_trylock_irqsave(&rcu_ctrlblk.fliplock, oldirq))) {
> +	if (unlikely(!spin_trylock_irqsave(&rcu_ctrlblk.fliplock, flags))) {
>  		RCU_TRACE_ME(rcupreempt_trace_try_flip_e1);
>  		return;
>  	}
> @@ -534,7 +1063,7 @@ static void rcu_try_flip(void)
>  		if (rcu_try_flip_waitmb())
>  			rcu_try_flip_state = rcu_try_flip_idle_state;
>  	}
> -	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, oldirq);
> +	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
>  }
> 
>  /*
> @@ -553,16 +1082,16 @@ static void rcu_check_mb(int cpu)
> 
>  void rcu_check_callbacks_rt(int cpu, int user)
>  {
> -	unsigned long oldirq;
> +	unsigned long flags;
>  	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
> 
>  	rcu_check_mb(cpu);
>  	if (rcu_ctrlblk.completed == rdp->completed)
>  		rcu_try_flip();
> -	spin_lock_irqsave(&rdp->lock, oldirq);
> +	spin_lock_irqsave(&rdp->lock, flags);
>  	RCU_TRACE_RDP(rcupreempt_trace_check_callbacks, rdp);
>  	__rcu_advance_callbacks(rdp);
> -	spin_unlock_irqrestore(&rdp->lock, oldirq);
> +	spin_unlock_irqrestore(&rdp->lock, flags);
>  }
> 
>  /*
> @@ -571,18 +1100,19 @@ void rcu_check_callbacks_rt(int cpu, int
>   */
>  void rcu_advance_callbacks_rt(int cpu, int user)
>  {
> -	unsigned long oldirq;
> +	unsigned long flags;
>  	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
> 
>  	if (rcu_ctrlblk.completed == rdp->completed) {
>  		rcu_try_flip();
>  		if (rcu_ctrlblk.completed == rdp->completed)
>  			return;
> +		rcu_read_unlock_unboost();
>  	}
> -	spin_lock_irqsave(&rdp->lock, oldirq);
> +	spin_lock_irqsave(&rdp->lock, flags);
>  	RCU_TRACE_RDP(rcupreempt_trace_check_callbacks, rdp);
>  	__rcu_advance_callbacks(rdp);
> -	spin_unlock_irqrestore(&rdp->lock, oldirq);
> +	spin_unlock_irqrestore(&rdp->lock, flags);
>  }
> 
>  #ifdef CONFIG_HOTPLUG_CPU
> @@ -601,24 +1131,24 @@ void rcu_offline_cpu_rt(int cpu)
>  {
>  	int i;
>  	struct rcu_head *list = NULL;
> -	unsigned long oldirq;
> +	unsigned long flags;
>  	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
>  	struct rcu_head **tail = &list;
> 
>  	/* Remove all callbacks from the newly dead CPU, retaining order. */
> 
> -	spin_lock_irqsave(&rdp->lock, oldirq);
> +	spin_lock_irqsave(&rdp->lock, flags);
>  	rcu_offline_cpu_rt_enqueue(rdp->donelist, rdp->donetail, list, tail);
>  	for (i = GP_STAGES - 1; i >= 0; i--)
>  		rcu_offline_cpu_rt_enqueue(rdp->waitlist[i], rdp->waittail[i],
>  					   list, tail);
>  	rcu_offline_cpu_rt_enqueue(rdp->nextlist, rdp->nexttail, list, tail);
> -	spin_unlock_irqrestore(&rdp->lock, oldirq);
> +	spin_unlock_irqrestore(&rdp->lock, flags);
>  	rdp->waitlistcount = 0;
> 
>  	/* Disengage the newly dead CPU from grace-period computation. */
> 
> -	spin_lock_irqsave(&rcu_ctrlblk.fliplock, oldirq);
> +	spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
>  	rcu_check_mb(cpu);
>  	if (per_cpu(rcu_flip_flag, cpu) == rcu_flipped) {
>  		smp_mb();  /* Subsequent counter accesses must see new value */
> @@ -627,7 +1157,7 @@ void rcu_offline_cpu_rt(int cpu)
>  			   /*  seen -after- acknowledgement. */
>  	}
>  	cpu_clear(cpu, rcu_cpu_online_map);
> -	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, oldirq);
> +	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
> 
>  	/*
>  	 * Place the removed callbacks on the current CPU's queue.
> @@ -640,20 +1170,20 @@ void rcu_offline_cpu_rt(int cpu)
>  	 */
> 
>  	rdp = RCU_DATA_ME();
> -	spin_lock_irqsave(&rdp->lock, oldirq);
> +	spin_lock_irqsave(&rdp->lock, flags);
>  	*rdp->nexttail = list;
>  	if (list)
>  		rdp->nexttail = tail;
> -	spin_unlock_irqrestore(&rdp->lock, oldirq);
> +	spin_unlock_irqrestore(&rdp->lock, flags);
>  }
> 
>  void __devinit rcu_online_cpu_rt(int cpu)
>  {
> -	unsigned long oldirq;
> +	unsigned long flags;
> 
> -	spin_lock_irqsave(&rcu_ctrlblk.fliplock, oldirq);
> +	spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
>  	cpu_set(cpu, rcu_cpu_online_map);
> -	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, oldirq);
> +	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
>  }
> 
>  #else /* #ifdef CONFIG_HOTPLUG_CPU */
> @@ -695,12 +1225,12 @@ void rcu_process_callbacks_rt(struct sof
>  void fastcall call_rcu_preempt(struct rcu_head *head,
>  			       void (*func)(struct rcu_head *rcu))
>  {
> -	unsigned long oldirq;
> +	unsigned long flags;
>  	struct rcu_data *rdp;
> 
>  	head->func = func;
>  	head->next = NULL;
> -	local_irq_save(oldirq);
> +	local_irq_save(flags);
>  	rdp = RCU_DATA_ME();
>  	spin_lock(&rdp->lock);
>  	__rcu_advance_callbacks(rdp);
> @@ -708,7 +1238,7 @@ void fastcall call_rcu_preempt(struct rc
>  	rdp->nexttail = &head->next;
>  	RCU_TRACE_RDP(rcupreempt_trace_next_add, rdp);
>  	spin_unlock(&rdp->lock);
> -	local_irq_restore(oldirq);
> +	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL_GPL(call_rcu_preempt);
> 
> @@ -757,6 +1287,11 @@ int rcu_pending_rt(int cpu)
>  	return 0;
>  }
> 
> +/*
> + * Initialize RCU.  This is called very early in boot, so is restricted
> + * to very simple operations.  Don't even think about messing with anything
> + * that involves the scheduler, as it doesn't exist yet.
> + */
>  void __init rcu_init_rt(void)
>  {
>  	int cpu;
> @@ -778,6 +1313,7 @@ void __init rcu_init_rt(void)
>  		rdp->donelist = NULL;
>  		rdp->donetail = &rdp->donelist;
>  	}
> +	init_rcu_boost_early();
>  }
> 
>  /*
> diff -urpNa -X dontdiff linux-2.6.22-E-hotplug/kernel/rtmutex.c linux-2.6.22-F-boostrcu/kernel/rtmutex.c
> --- linux-2.6.22-E-hotplug/kernel/rtmutex.c	2007-07-08 16:32:17.000000000 -0700
> +++ linux-2.6.22-F-boostrcu/kernel/rtmutex.c	2007-08-24 11:24:59.000000000 -0700
> @@ -111,11 +111,12 @@ static inline void mark_rt_mutex_waiters
>   */
>  int rt_mutex_getprio(struct task_struct *task)
>  {
> +	int prio = min(task->normal_prio, get_rcu_prio(task));
> +
>  	if (likely(!task_has_pi_waiters(task)))
> -		return task->normal_prio;
> +		return prio;
> 
> -	return min(task_top_pi_waiter(task)->pi_list_entry.prio,
> -		   task->normal_prio);
> +	return min(task_top_pi_waiter(task)->pi_list_entry.prio, prio);
>  }
> 
>  /*
> diff -urpNa -X dontdiff linux-2.6.22-E-hotplug/kernel/sched.c linux-2.6.22-F-boostrcu/kernel/sched.c
> --- linux-2.6.22-E-hotplug/kernel/sched.c	2007-07-08 16:32:17.000000000 -0700
> +++ linux-2.6.22-F-boostrcu/kernel/sched.c	2007-08-24 11:24:59.000000000 -0700
> @@ -1702,6 +1702,7 @@ void fastcall sched_fork(struct task_str
>  	 * Make sure we do not leak PI boosting priority to the child:
>  	 */
>  	p->prio = current->normal_prio;
> +	set_rcu_prio(p, MAX_PRIO);
> 
>  	INIT_LIST_HEAD(&p->run_list);
>  	p->array = NULL;
> @@ -1784,6 +1785,7 @@ void fastcall wake_up_new_task(struct ta
>  			else {
>  				p->prio = current->prio;
>  				p->normal_prio = current->normal_prio;
> +				set_rcu_prio(p, MAX_PRIO);
>  				list_add_tail(&p->run_list, &current->run_list);
>  				p->array = current->array;
>  				p->array->nr_active++;
> @@ -3590,6 +3592,8 @@ asmlinkage void __sched schedule(void)
>  	}
>  	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
> 
> +	rcu_preempt_boost();
> +
>  need_resched:
>  	preempt_disable();
>  	prev = current;
> @@ -5060,6 +5064,7 @@ void __cpuinit init_idle(struct task_str
>  	idle->sleep_avg = 0;
>  	idle->array = NULL;
>  	idle->prio = idle->normal_prio = MAX_PRIO;
> +	set_rcu_prio(idle, MAX_PRIO);
>  	idle->state = TASK_RUNNING;
>  	idle->cpus_allowed = cpumask_of_cpu(cpu);
>  	set_task_cpu(idle, cpu);
> diff -urpNa -X dontdiff linux-2.6.22-E-hotplug/lib/Kconfig.debug linux-2.6.22-F-boostrcu/lib/Kconfig.debug
> --- linux-2.6.22-E-hotplug/lib/Kconfig.debug	2007-07-08 16:32:17.000000000 -0700
> +++ linux-2.6.22-F-boostrcu/lib/Kconfig.debug	2007-08-24 11:24:59.000000000 -0700
> @@ -391,6 +391,40 @@ config RCU_TORTURE_TEST
>  	  Say M if you want the RCU torture tests to build as a module.
>  	  Say N if you are unsure.
> 
> +config RCU_TRACE
> +	bool "Enable tracing for RCU - currently stats in debugfs"
> +	select DEBUG_FS
> +	depends on DEBUG_KERNEL
> +	default y
> +	help
> +	  This option provides tracing in RCU which presents stats
> +	  in debugfs for debugging RCU implementation.
> +
> +	  Say Y here if you want to enable RCU tracing
> +	  Say N if you are unsure.
> +
> +config PREEMPT_RCU_BOOST_STATS
> +	bool "Enable RCU priority-boosting statistic printing"
> +	depends on PREEMPT_RCU_BOOST
> +	depends on DEBUG_KERNEL
> +	default n
> +	help
> +	  This option enables debug printk()s of RCU boost statistics,
> +	  which are normally only used to debug RCU priority boost
> +	  implementations.
> +
> +	  Say N if you are unsure.
> +
> +config PREEMPT_RCU_BOOST_STATS_INTERVAL
> +	int "RCU priority-boosting statistic printing interval (seconds)"
> +	depends on PREEMPT_RCU_BOOST_STATS
> +	default 100
> +	range 10 86400
> +	help
> +	  This option controls the timing of debug printk()s of RCU boost
> +	  statistics, which are normally only used to debug RCU priority
> +	  boost implementations.
> +
>  config LKDTM
>  	tristate "Linux Kernel Dump Test Tool Module"
>  	depends on DEBUG_KERNEL

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
