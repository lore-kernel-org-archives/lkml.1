Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbYDHHlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbYDHHlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 03:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYDHHll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 03:41:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960AbYDHHlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 03:41:40 -0400
Date: Tue, 8 Apr 2008 00:34:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
       hch@infradead.org, mmlnx@us.ibm.com, dipankar@in.ibm.com,
       dsmith@redhat.com, rostedt@goodmis.org, adrian.bunk@movial.fi,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, rusty@au1.ibm.com, jkenisto@linux.vnet.ibm.com,
       oleg@tv-sign.ru
Subject: Re: [PATCH,RFC] Add call_rcu_sched()
Message-Id: <20080408003449.873574d7.akpm@linux-foundation.org>
In-Reply-To: <20080406213719.GA10533@linux.vnet.ibm.com>
References: <20080321143615.GA936@linux.vnet.ibm.com>
	<20080321224026.GA10169@linux.vnet.ibm.com>
	<20080406213719.GA10533@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Apr 2008 14:37:19 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> Hello!
> 
> Third cut of patch to provide the call_rcu_sched().  This is again to
> synchronize_sched() as call_rcu() is to synchronize_rcu().
> 
> Should be fine for experimental use, but not ready for inclusion.

Let me know when to come out of hiding ;)

> Passes multi-hour rcutorture sessions with concurrent CPU hotplugging.
> 
> Fixes since the first version include a bug that could result in
> indefinite blocking (spotted by Gautham Shenoy), better resiliency
> against CPU-hotplug operations, and other minor fixes.
> 
> Fixes since the second version include reworking grace-period detection
> to avoid deadlocks that could happen when running concurrently with
> CPU hotplug, adding Mathieu's fix to avoid the softlockup messages,
> as well as Mathieu's fix to allow use earlier in boot.
> 
> Known/suspected shortcomings:
> 
> o	Only moderately tested on x86-64 and POWER -- a few hours of
> 	rcutorture with concurrent CPU hotplugging.  In particular, I
> 	still do not trust the sleep/wakeup logic between call_rcu_sched()
> 	and rcu_sched_grace_period().
> 
> o	Need to add call_rcu_sched() testing to rcutorture.
> 
> o	Still needs rcu_barrier_sched() -- intending to incorporate
> 	the version Mathieu provided.
> 
> This patch also fixes a long-standing bug in the earlier preemptable-RCU
> implementation of synchronize_rcu() that could result in loss of
> concurrent external changes to a task's CPU affinity mask.  I still cannot
> remember who reported this...
>
> ...
>
> +#define call_rcu_sched(head, func) call_rcu(head, func)
> +
>  extern void __rcu_init(void);
> +#define rcu_init_sched()	do { } while (0)

There are lots of creepy macros-which-probably-dont-need-to-be-macros in
here.

> +
> +static inline int
> +rcu_qsctr_inc_needed_dyntick(int cpu)

Unneeded newline.

> +{
> +	long curr;
> +	long snap;
> +	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
> +
> +	curr = rdssp->dynticks;
> +	snap = rdssp->sched_dynticks_snap;
> +	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
> +
> +	/*
> +	 * If the CPU remained in dynticks mode for the entire time
> +	 * and didn't take any interrupts, NMIs, SMIs, or whatever,
> +	 * then it cannot be in the middle of an rcu_read_lock(), so
> +	 * the next rcu_read_lock() it executes must use the new value
> +	 * of the counter.  Therefore, this CPU has been in a quiescent
> +	 * state the entire time, and we don't need to wait for it.
> +	 */
> +
> +	if ((curr == snap) && ((curr & 0x1) == 0))
> +		return 0;
> +
> +	/*
> +	 * If the CPU passed through or entered a dynticks idle phase with
> +	 * no active irq handlers, then, as above, this CPU has already
> +	 * passed through a quiescent state.
> +	 */
> +
> +	if ((curr - snap) > 2 || (snap & 0x1) == 0)
> +		return 0;
> +
> +	/* We need this CPU to go through a quiescent state. */
> +
> +	return 1;
> +}

That's a pretty big inline.  It only has a single callsite so the compiler
should inline it for us.  And if it grows a second callsite, the inlining
is probably wrong.

> +static inline int
> +rcu_qsctr_inc_needed(int cpu)

Unneeded newline.

>  /*
>   * Get here when RCU is idle.  Decide whether we need to
>   * move out of idle state, and return non-zero if so.
> @@ -821,6 +924,13 @@ void rcu_check_callbacks(int cpu, int us
>  	unsigned long flags;
>  	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
>  
> +	if (user ||
> +	    (idle_cpu(cpu) && !in_softirq() &&
> +	     hardirq_count() <= (1 << HARDIRQ_SHIFT))) {

I think this test could do with a bigfatcomment explaining what it is doing.

> +		smp_mb();	/* Guard against aggressive schedule(). */
> +	     	rcu_qsctr_inc(cpu);
> +	}
> +
>  	rcu_check_mb(cpu);
>  	if (rcu_ctrlblk.completed == rdp->completed)
>  		rcu_try_flip();
>
> ...
>
> +
> +	/*
> +	 * The rcu_sched grace-period processing might have bypassed
> +	 * this CPU, given that it was not in the rcu_cpu_online_map
> +	 * when the grace-period scan started.  This means that the
> +	 * grace-period task might sleep.  So make sure that if this
> +	 * should happen, the first callback posted to this CPU will
> +	 * wake up the grace-period task if need be.
> +	 */
> +
> +	local_irq_save(flags);
> +	rdp = RCU_DATA_ME();
> +	spin_lock(&rdp->lock);

I assume that splitting the irq-disable from the spin_lock is a little
latency optimisation?

> +	rdp->rcu_sched_sleeping = 1;
> +	spin_unlock_irqrestore(&rdp->lock, flags);
>  }
>  
>  #else /* #ifdef CONFIG_HOTPLUG_CPU */
> @@ -993,26 +1129,194 @@ void call_rcu(struct rcu_head *head, voi
>  }
>  EXPORT_SYMBOL_GPL(call_rcu);
>  
> +void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
> +{
> +	unsigned long flags;
> +	struct rcu_data *rdp;
> +	int wake_gp = 0;
> +
> +	head->func = func;
> +	head->next = NULL;
> +	local_irq_save(flags);
> +	rdp = RCU_DATA_ME();
> +	spin_lock(&rdp->lock);
> +	*rdp->nextschedtail = head;
> +	rdp->nextschedtail = &head->next;
> +	if (rdp->rcu_sched_sleeping) {
> +
> +		/* Grace-period processing might be sleeping... */
> +
> +		rdp->rcu_sched_sleeping = 0;
> +		wake_gp = 1;
> +	}
> +	spin_unlock(&rdp->lock);
> +	local_irq_restore(flags);

spin_unlock_irqrestore() here would be consistent with the above.

> +	if (wake_gp) {
> +
> +		/* Wake up grace-period processing, unless someone beat us. */
> +
> +		spin_lock_irqsave(&rcu_ctrlblk.schedlock, flags);

If wake_gp!=0 is common then we could microoptimise straight-line
performance here by retaining the irq-offness from above.

> +		if (rcu_ctrlblk.sched_sleep != rcu_sched_sleeping)
> +			wake_gp = 0;
> +		rcu_ctrlblk.sched_sleep = rcu_sched_not_sleeping;
> +		spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
> +		if (wake_gp)
> +			wake_up_interruptible(&rcu_ctrlblk.sched_wq);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(call_rcu_sched);
>
> ...
>
> +static int
> +rcu_sched_grace_period(void *arg)

Unneeded newline.

>  {
> -	cpumask_t oldmask;
> +	int couldsleep;		/* might sleep after current pass. */
> +	int couldsleepnext = 0; /* might sleep after next pass. */
>  	int cpu;
> +	unsigned long flags;
> +	struct rcu_data *rdp;
> +	int ret;
>  
> -	if (sched_getaffinity(0, &oldmask) < 0)
> -		oldmask = cpu_possible_map;
> -	for_each_online_cpu(cpu) {
> -		sched_setaffinity(0, cpumask_of_cpu(cpu));
> -		schedule();
> -	}
> -	sched_setaffinity(0, oldmask);
> +	/*
> +	 * Each pass through the following loop handles one
> +	 * rcu_sched grace period cycle.
> +	 */
> +
> +	do {
> +		
> +		/* Save each CPU's current state. */
> +
> +		for_each_online_cpu(cpu) {

Numerous unneeded newline ;)

> +			dyntick_save_progress_counter_sched(cpu);
> +			save_qsctr_sched(cpu);
> +		}
> +
> +		/*
> +		 * Sleep for about an RCU grace-period's worth to
> +		 * allow better batching and to consume less CPU.
> +		 */
> +
> +		schedule_timeout_interruptible(HZ / 20);

eek, a magic number.

> +		/*
> +		 * If there was nothing to do last time, prepare to
> +		 * sleep at the end of the current grace period cycle.
> +		 */
> +
> +		couldsleep = couldsleepnext;
> +		couldsleepnext = 1;
> +		if (couldsleep) {
> +			spin_lock_irqsave(&rcu_ctrlblk.schedlock, flags);
> +			rcu_ctrlblk.sched_sleep = rcu_sched_sleep_prep;
> +			spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
> +		}

If the above locking actually correct and needed?  The write to
rcu_ctrlblk.sched_sleep is a single word...

> +		/*
> +		 * Wait on each CPU in turn to have either visited
> +		 * a quiescent state or been in dynticks-idle mode.
> +		 */
> +
> +		for_each_online_cpu(cpu) {
> +			while (rcu_qsctr_inc_needed(cpu) &&
> +			       rcu_qsctr_inc_needed_dyntick(cpu)) {
> +				/* resched_cpu(cpu); */
> +				schedule_timeout_interruptible(1);
> +			}
> +		}
> +
> +		/*
> +		 * Advance callbacks for each CPU.
> +		 */
> +
> +		for_each_online_cpu(cpu) {

It's more conventional to omit the blank line after the above form of
comment block.

> +			rdp = RCU_DATA_CPU(cpu);
> +			spin_lock_irqsave(&rdp->lock, flags);
> +
> +			/*
> +			 * We are running on this CPU irq-disabled, so no
> +			 * CPU can go offline until we re-enable irqs.

but, but, but.  The cpu at `cpu' could have gone offline just before we
disabled local interrupts.

> +			 * Advance the callbacks!  We share normal RCU's
> +			 * donelist, since callbacks are invoked the
> +			 * same way in either case.
> +			 */
> +
> +			if (rdp->waitschedlist != NULL) {
> +				*rdp->donetail = rdp->waitschedlist;
> +				rdp->donetail = rdp->waitschedtail;
> +
> +				/*
> +				 * Next rcu_check_callbacks() will
> +				 * do the required raise_softirq().
> +				 */
> +			}
> +			if (rdp->nextschedlist != NULL) {
> +				rdp->waitschedlist = rdp->nextschedlist;
> +				rdp->waitschedtail = rdp->nextschedtail;
> +				couldsleep = 0;
> +				couldsleepnext = 0;
> +			} else {
> +				rdp->waitschedlist = NULL;
> +				rdp->waitschedtail = &rdp->waitschedlist;
> +			}
> +			rdp->nextschedlist = NULL;
> +			rdp->nextschedtail = &rdp->nextschedlist;
> +
> +			/* Mark sleep intention. */
> +
> +			rdp->rcu_sched_sleeping = couldsleep;
> +
> +			spin_unlock_irqrestore(&rdp->lock, flags);
> +		}
> +
> +		/* If we saw callbacks on the last scan, go deal with them. */
> +
> +		if (!couldsleep)
> +			continue;
> +
> +		/* Attempt to block... */
> +
> +		spin_lock_irqsave(&rcu_ctrlblk.schedlock, flags);
> +		if (rcu_ctrlblk.sched_sleep != rcu_sched_sleep_prep) {
> +
> +			/*
> +			 * Someone posted a callback after we scanned.
> +			 * Go take care of it.
> +			 */
> +
> +			spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
> +			couldsleepnext = 0;
> +			continue;
> +		}
> +
> +		/* Block until the next person posts a callback. */
> +
> +		rcu_ctrlblk.sched_sleep = rcu_sched_sleeping;
> +		spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
> +		ret = 0;
> +		__wait_event_interruptible(rcu_ctrlblk.sched_wq,
> +			rcu_ctrlblk.sched_sleep != rcu_sched_sleeping,
> +			ret);
> +		if (ret)
> +			flush_signals(current);

That flush_signals() was a surprise.  A desurprising comment would be nice.

> +		couldsleepnext = 0;
> +
> +	} while (!kthread_should_stop());
> +
> +	return (0);
>  }
> -EXPORT_SYMBOL_GPL(__synchronize_sched);
>  
>  /*
>   * Check to see if any future RCU-related work will need to be done
> @@ -1029,7 +1333,9 @@ int rcu_needs_cpu(int cpu)
>  
>  	return (rdp->donelist != NULL ||
>  		!!rdp->waitlistcount ||
> -		rdp->nextlist != NULL);
> +		rdp->nextlist != NULL ||
> +		rdp->nextschedlist != NULL ||
> +		rdp->waitschedlist != NULL);
>  }
>  
>  int rcu_pending(int cpu)
> @@ -1040,7 +1346,9 @@ int rcu_pending(int cpu)
>  
>  	if (rdp->donelist != NULL ||
>  	    !!rdp->waitlistcount ||
> -	    rdp->nextlist != NULL)
> +	    rdp->nextlist != NULL ||
> +	    rdp->nextschedlist != NULL ||
> +	    rdp->waitschedlist != NULL)
>  		return 1;
>  
>  	/* The RCU core needs an acknowledgement from this CPU. */
> @@ -1107,6 +1415,11 @@ void __init __rcu_init(void)
>  		rdp->donetail = &rdp->donelist;
>  		rdp->rcu_flipctr[0] = 0;
>  		rdp->rcu_flipctr[1] = 0;
> +		rdp->nextschedlist = NULL;
> +		rdp->nextschedtail = &rdp->nextschedlist;
> +		rdp->waitschedlist = NULL;
> +		rdp->waitschedtail = &rdp->waitschedlist;
> +		rdp->rcu_sched_sleeping = 0;
>  	}
>  	register_cpu_notifier(&rcu_nb);
>  
> @@ -1129,6 +1442,18 @@ void __init __rcu_init(void)
>  }
>  
>  /*
> + * Late-boot-time RCU initialization that must wait until after scheduler
> + * has been initialized.
> + */
> +void __init rcu_init_sched(void)
> +{
> +	rcu_sched_grace_period_task = kthread_run(rcu_sched_grace_period,
> +						  NULL,
> +						  "rcu_sched_grace_period");
> +	WARN_ON(IS_ERR(rcu_sched_grace_period_task));
> +}
> +
> +/*
>   * Deprecated, use synchronize_rcu() or synchronize_sched() instead.
>   */
>  void synchronize_kernel(void)

I suspect I don't understand any of the RCU code any more.

