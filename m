Return-Path: <linux-kernel-owner+w=401wt.eu-S1030535AbXAYT6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030535AbXAYT6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 14:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030536AbXAYT6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 14:58:32 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:49949 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030535AbXAYT6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 14:58:31 -0500
Date: Thu, 25 Jan 2007 11:58:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@freedesktop.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linuxtronix.de,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       oleg@tv-sign.ru, twoerner.k@gmail.com, billh@gnuppy.monkey.org,
       nielsen.esben@googlemail.com, corbet@lwn.net
Subject: Re: [RFC PATCH -rt 1/2] RCU priority boosting that survives semi-vicious testing
Message-ID: <20070125195816.GH1705@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070125021101.GA23428@linux.vnet.ibm.com> <20070125021444.GA22540@linux.vnet.ibm.com> <45B87873.3080207@freedesktop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B87873.3080207@freedesktop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 01:29:23AM -0800, Josh Triplett wrote:
> Overall, this code looks sensible to me.  Some comments on the patch below.
> 
> Paul E. McKenney wrote:
> > --- linux-2.6.20-rc4-rt1/include/linux/rcupreempt.h	2007-01-09 10:59:54.000000000 -0800
> > +++ linux-2.6.20-rc4-rt1-rcub/include/linux/rcupreempt.h	2007-01-09 11:01:12.000000000 -0800
> [...]
> > +enum rcu_boost_state {
> > +	RCU_BOOST_IDLE = 0,	   /* Not yet blocked if in RCU read-side. */
> > +	RCU_BOOST_BLOCKED = 1,	   /* Blocked from RCU read-side. */
> > +	RCU_BOOSTED = 2,	   /* Boosting complete. */
> > +};
> > +
> > +#define N_RCU_BOOST_STATE (RCU_BOOSTED + 1)
> 
> Here, you define the three possible states, the number of states.  But
> later...
> 
> > diff -urpNa -X dontdiff linux-2.6.20-rc4-rt1/kernel/rcupreempt.c linux-2.6.20-rc4-rt1-rcub/kernel/rcupreempt.c
> > --- linux-2.6.20-rc4-rt1/kernel/rcupreempt.c	2007-01-09 10:59:54.000000000 -0800
> > +++ linux-2.6.20-rc4-rt1-rcub/kernel/rcupreempt.c	2007-01-23 15:41:33.000000000 -0800
> > @@ -49,6 +49,7 @@
> [...]
> > +#ifdef CONFIG_PREEMPT_RCU_BOOST_STATS
> > +	long rbs_stats[N_RCU_BOOST_DAT_EVENTS][N_RCU_BOOST_STATE + 1];
> > +#endif /* #ifdef CONFIG_PREEMPT_RCU_BOOST_STATS */
> 
> ...you declare this array to have space for one more than that, and then...
> 
> > +#ifdef CONFIG_PREEMPT_RCU_BOOST_STATS
> > +
> > +/*
> > + * Function to increment indicated ->rbs_stats[] element.
> > + */
> > +static inline void rcu_boost_dat_stat(struct rcu_boost_dat *rbdp,
> > +				      int event,
> > +				      enum rcu_boost_state oldstate)
> > +{
> > +	if (oldstate >= RCU_BOOST_IDLE &&
> > +	    oldstate <= RCU_BOOSTED) {
> > +		rbdp->rbs_stats[event][oldstate]++;
> > +	} else {
> > +		rbdp->rbs_stats[event][N_RCU_BOOST_STATE]++;
> 
> ...you use the last element as what looks like an "unknown" counter.  How
> about instead defining the enum to have an "unknown" state, defining
> N_RCU_BOOST_STATE accordingly, and using N_RCU_BOOST_STATE without the +1 in
> rbs_stats?  I think that would make the code much more self-documenting, and
> less error-prone.

Excellent point.  I have used the N+1 trick for some decades, so perhaps
it is time to retire it anyway.  ;-)

> > +#define rcu_boost_dat_stat_block(rbdp, oldstate) \
> > +	rcu_boost_dat_stat(rbdp, RCU_BOOST_DAT_BLOCK, oldstate)
> > +#define rcu_boost_dat_stat_boost(rbdp, oldstate) \
> > +	rcu_boost_dat_stat(rbdp, RCU_BOOST_DAT_BOOST, oldstate)
> > +#define rcu_boost_dat_stat_unlock(rbdp, oldstate) \
> > +	rcu_boost_dat_stat(rbdp, RCU_BOOST_DAT_UNLOCK, oldstate)
> > +
> > +/*
> > + * Prefix for kprint() strings for periodic statistics messages.
> > + */
> > +static char *rcu_boost_state_event[] = {
> > +	"block:  ",
> > +	"boost:  ",
> > +	"unlock: ",
> > +};
> 
> I don't know for sure, but I *think* that GCC may sometimes generate more
> efficient code if you use a char [][], rather than a char *[].

Hmmm...  "char *[]" says "array of strings" to me, while char[][] seems
more opaque.  Might be just me, though.

> > +
> > +/*
> > + * Indicators for numbers in kprint() strings.  "!" indicates a state-event
> > + * pair that should not happen, while "?" indicates a state that should
> > + * not happen.
> > + */
> > +static char *rcu_boost_state_error[] = {
> > +       /*ibBe*/
> > +	"   ?",  /* block */
> > +	"!  ?",  /* boost */
> > +	"?  ?",  /* unlock */
> > +};
> 
> Likewise.  Also, the columns here don't seem to line up, probably because the
> comment uses spaces and the other lines use a tab.

Yeah, the "*" of the comment has to line up with the leading quote of
the following strings.  I bumped everything over a space's worth, so
that each line now has a leading tab.

> > +static void rcu_boost_dat_stat_print(void)
> > +{
> > +	char buf[N_RCU_BOOST_STATE * (sizeof(long) * 3 + 2) + 2];
> 
> This expression really begs for some constants in place of the magic numbers,
> or failing that, a comment.

How about the following?

	/* Three decimal digits per byte plus spacing per number and line. */

> > +	int cpu;
> > +	int event;
> > +	int i;
> > +	static time_t lastprint = 0;
> > +	struct rcu_boost_dat *rbdp;
> > +	int state;
> > +	struct rcu_boost_dat sum;
> > +
> > +	/* Wait a graceful interval between printk spamming. */
> > +
> > +	if (xtime.tv_sec - lastprint <
> > +	    CONFIG_PREEMPT_RCU_BOOST_STATS_INTERVAL)
> > +		return;
> 
> How about printk_ratelimit?  It takes a parameter for the rate.  (On the other
> hand, it also takes a spinlock, which you might not want here, even in the
> stats code.)

It also allows bursts.  printk_ratelimit() seems to be designed to
prevent log overflow due to excessive error rates.  In contrast I want
to print stats at a more-or-less regular interval, and I don't want
to incur the overhead of gathering and formatting stats if they aren't
going to print.

> > +	/* Print them out! */
> > +
> > +	printk(KERN_ALERT
> > +	       "rcu_boost_dat: idx=%d "
> > +	       "b=%ld ul=%ld ub=%ld boost: a=%ld b=%ld\n",
> > +	       rcu_boost_idx,
> > +	       sum.rbs_blocked, sum.rbs_unlock, sum.rbs_unboosted,
> > +	       sum.rbs_boost_attempt, sum.rbs_boost);
> > +	for (event = 0; event < N_RCU_BOOST_DAT_EVENTS; event++) {
> > +		i = 0;
> > +		for (state = 0; state <= N_RCU_BOOST_STATE; state++) {
> > +			i += sprintf(&buf[i], " %ld%c",
> > +				     sum.rbs_stats[event][state],
> > +				     rcu_boost_state_error[event][state]);
> > +		}
> > +		printk(KERN_ALERT "rcu_boost_dat %s %s\n",
> > +		       rcu_boost_state_event[event], buf);
> > +	}
> 
> Most or all of these counters could likely become unsigned, since negative
> values don't make sense for them.

Good point, fixed.

> > +	/* Go away and don't come back for awhile. */
> > +
> > +	lastprint = xtime.tv_sec;
> > +}
> > +
> > +/*
> > + * Return the current boost index for boosting target tasks.
> > + * May only be invoked by the booster task, so guaranteed to
> > + * already be initialized.
> > + */
> > +static inline int rcu_boost_idx_boosting(void)
> > +{
> > +	return (rcu_boost_idx + 1) & (RCU_BOOST_ELEMENTS - 1);
> > +}
> 
> Quoted for later reference.

Right.  Removed this unused function, good eyes.

> > +/*
> > + * Initialize RCU-boost state.  This happens early in the boot process,
> > + * when the scheduler does not yet exist.  So don't try to use it.
> > + */
> > +static void init_rcu_boost_early(void)
> > +{
> > +	struct rcu_boost_dat *rbdp;
> > +	int cpu;
> > +	int i;
> > +
> > +	for_each_possible_cpu(cpu) {
> > +		rbdp = per_cpu(rcu_boost_dat, cpu);
> > +		for (i = 0; i < RCU_BOOST_ELEMENTS; i++) {
> > +			rbdp[i].rbs_mutex =
> > +				RAW_SPIN_LOCK_UNLOCKED(rbdp[i].rbs_mutex);
> > +			INIT_LIST_HEAD(&rbdp[i].rbs_toboost);
> > +			INIT_LIST_HEAD(&rbdp[i].rbs_boosted);
> > +			rbdp[i].rbs_blocked = 0;
> > +			rbdp[i].rbs_boost_attempt = 0;
> > +			rbdp[i].rbs_boost = 0;
> > +			rbdp[i].rbs_unlock = 0;
> > +			rbdp[i].rbs_unboosted = 0;
> > +#ifdef CONFIG_PREEMPT_RCU_BOOST_STATS
> > +			{
> > +				int j, k;
> > +
> > +				for (j = 0; j < N_RCU_BOOST_DAT_EVENTS; j++)
> > +					for (k = 0; k <= N_RCU_BOOST_STATE; k++)
> > +						rbdp[i].rbs_stats[j][k] = 0;
> > +			}
> > +#endif /* #ifdef CONFIG_PREEMPT_RCU_BOOST_STATS */
> > +		}
> > +		smp_wmb();
> 
> Barrier without an accompanying comment.  You want to make sure the structure
> gets initialized before setting rcu_boost_idx and thus allowing boosting,
> right?

Excellent point!  How about the following:

	smp_wmb();  /* Make sure readers see above initialization. */
	rcu_boost_idx = 0;  /* Allow readers to access data. */

> > +		rcu_boost_idx = 0;
> > +	}
> > +}
> 
> > +/*
> > + * Return the list on which the calling task should add itself, or
> > + * NULL if too early during initialization.
> > + */
> > +static inline struct rcu_boost_dat *rcu_rbd_new(void)
> > +{
> > +	int cpu = raw_smp_processor_id();  /* locks used, so preemption OK. */
> > +	int idx = rcu_boost_idx;
> > +
> > +	smp_read_barrier_depends(); barrier();
> 
> Barriers without accompanying comments, though in this case they seem fairly
> obvious.

It probably won't be obvious to me six months from now.  :-/

How about the following?

	smp_read_barrier_depends(); barrier(); /* rmb() on Alpha for idx. */

I was tempted to use rcu_dereference() here and rcu_assign_pointer() above,
but I was afraid that confusion would result.

> > +	if (unlikely(idx < 0))
> > +		return (NULL);
> > +	return &per_cpu(rcu_boost_dat, cpu)[idx];
> > +}
> > +
> > +/*
> > + * Return the list from which to boost target tasks.
> > + * May only be invoked by the booster task, so guaranteed to
> > + * already be initialized.
> > + */
> > +static inline struct rcu_boost_dat *rcu_rbd_boosting(int cpu)
> > +{
> > +	int idx = (rcu_boost_idx + 1) & (RCU_BOOST_ELEMENTS - 1);
> 
> You defined rcu_boost_idx_boosting for exactly this expression.
> 
> > +	return &per_cpu(rcu_boost_dat, cpu)[idx];
> 
> For that matter, since you wrapped it in the function, you could just call it
> directly in this array index operation.

Since this is the only use of that function, I left it inline and added
a "Use rcu_boost_dat element least recently the destination for task
blocking in RCU read-side critical sections" to rcu_rbd_boosting()'s
comment header.

Seem reasonable?

> > +}
> 
> > +/*
> > + * Priority-boost tasks stuck in RCU read-side critical sections as
> > + * needed (presumably rarely).
> > + */
> > +static int rcu_booster(void *arg)
> > +{
> > +	int cpu;
> > +	struct sched_param sp;
> > +
> > +	sp.sched_priority = PREEMPT_RCU_BOOSTER_PRIO;
> > +	sched_setscheduler(current, SCHED_RR, &sp);
> > +	current->flags |= PF_NOFREEZE;
> > +
> > +	do {
> > +
> > +		/* Advance the lists of tasks. */
> > +
> > +		rcu_boost_idx = (rcu_boost_idx + 1) % RCU_BOOST_ELEMENTS;
> > +		for_each_possible_cpu(cpu) {
> > +
> > +			/*
> > +			 * Boost all sufficiently aged readers.
> > +			 * Readers must first be preempted or block
> > +			 * on a mutex in an RCU read-side critical section,
> > +			 * then remain in that critical section for
> > +			 * RCU_BOOST_ELEMENTS-1 time intervals.
> > +			 * So most of the time we should end up doing
> > +			 * nothing.
> > +			 */
> > +
> > +			rcu_boost_one_reader_list(rcu_rbd_boosting(cpu));
> > +
> > +			/*
> > +			 * Large SMP systems may need to sleep sometimes
> > +			 * in this loop.  Or have multiple RCU-boost tasks.
> > +			 */
> 
> The idea of multiple RCU-boost tasks gives me an idea: what about having
> per-CPU boost queues, and using that to eliminate the need to lock the queues?
> It might not do quite as good a job of scheduling, but it would eliminate
> locking overhead *and* solve the problem you describe here.

Nice try!  ;-)

The problem is that the tasks on a given queue might migrate to some other
CPU before they do their rcu_read_unlock().  We already have per-CPU boost
queues, but their purpose is to promote cache locality in the (hopefully)
common case where the task's block time is short enough that it runs on
the same CPU.  Should also reduce memory contention should there be a
flurry of blocks on many CPUs from within RCU read-side critical sections.

But locking is still required, sad to say!

Unless I am misunderstanding your suggestion, in which case please
enlighten me.

> > +		}
> > +
> > +		/*
> > +		 * Sleep to allow any unstalled RCU read-side critical
> > +		 * sections to age out of the list.  @@@ FIXME: reduce,
> > +		 * adjust, or eliminate in case of OOM.
> > +		 */
> > +
> > +		schedule_timeout_uninterruptible(HZ / 100);
> > +
> > +		/* Print stats if enough time has passed. */
> > +
> > +		rcu_boost_dat_stat_print();
> > +
> > +	} while (!kthread_should_stop());
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Perform the portions of RCU-boost initialization that require the
> > + * scheduler to be up and running.
> > + */
> > +void init_rcu_boost_late(void)
> > +{
> > +	int i;
> > +
> > +	/* Spawn RCU-boost task. */
> > +
> > +	printk(KERN_ALERT "Starting RCU priority booster\n");
> 
> Judging by other initialization code, I think this belongs at KERN_INFO or
> similar.

Works for me!

> > +	rcu_boost_task = kthread_run(rcu_booster, NULL, "RCU Prio Booster");
> > +	if (IS_ERR(rcu_boost_task)) {
> > +		i = PTR_ERR(rcu_boost_task);
> > +		printk(KERN_ALERT
> > +		       "Unable to create RCU Priority Booster, errno %d\n", -i);
> 
> No need for a temporary here.

Good point, fixed!

> > +
> > +		/*
> > +		 * Continue running, but tasks permanently blocked
> > +		 * in RCU read-side critical sections will be able
> > +		 * to stall grace-period processing, potentially
> > +		 * OOMing the machine.
> > +		 */
> > +
> > +		rcu_boost_task = NULL;
> > +	}
> > +}
> > +
> > +/*
> > + * Update task's RCU-boost state to reflect blocking in RCU read-side
> > + * critical section, so that the RCU-boost task can find it in case it
> > + * later needs its priority boosted.
> > + */
> > +void __rcu_preempt_boost(void)
> > +{
> > +	struct rcu_boost_dat *rbdp;
> > +	unsigned long oldirq;
> > +
> > +	/* Identify list to place task on for possible later boosting. */
> > +
> > +	local_irq_save(oldirq);
> > +	rbdp = rcu_rbd_new();
> > +	if (rbdp == NULL) {
> > +		local_irq_restore(oldirq);
> > +		printk("Preempted RCU read-side critical section too early.\n");
> 
> This printk lacks a priority.

Good catch!  I chose KERN_ALERT, but please let me know if one of the
others would be more appropriate.

> > +		return;
> > +	}
> > +	spin_lock(&rbdp->rbs_mutex);
> > +	rbdp->rbs_blocked++;
> > +
> > +	/*
> > +	 * Update state.  We hold the lock and aren't yet on the list,
> > +	 * so the booster cannot mess with us yet.
> > +	 */
> > +
> > +	rcu_boost_dat_stat_block(rbdp, current->rcub_state);
> > +	if (current->rcub_state != RCU_BOOST_IDLE) {
> > +
> > +		/*
> > +		 * We have been here before, so just update stats.
> > +		 * It may seem strange to do all this work just to
> > +		 * accumulate statistics, but this is such a
> > +		 * low-probability code path that we shouldn't care.
> > +		 * If it becomes a problem, it can be fixed.
> > +		 */
> > +
> > +		spin_unlock_irqrestore(&rbdp->rbs_mutex, oldirq);
> > +		return;
> > +	}
> > +	current->rcub_state = RCU_BOOST_BLOCKED;
> > +
> > +	/* Now add ourselves to the list so that the booster can find use. */
> 
> Typo: s/use/us/

Goode catche, fixede!

> > +
> > +	list_add_tail(&current->rcub_entry, &rbdp->rbs_toboost);
> > +	current->rcub_rbdp = rbdp;
> > +	spin_unlock_irqrestore(&rbdp->rbs_mutex, oldirq);
> > +}
> 
> > diff -urpNa -X dontdiff linux-2.6.20-rc4-rt1/kernel/rtmutex.c linux-2.6.20-rc4-rt1-rcub/kernel/rtmutex.c
> > --- linux-2.6.20-rc4-rt1/kernel/rtmutex.c	2007-01-09 10:59:54.000000000 -0800
> > +++ linux-2.6.20-rc4-rt1-rcub/kernel/rtmutex.c	2007-01-09 11:01:12.000000000 -0800
> > @@ -105,11 +105,14 @@ static inline void init_lists(struct rt_
> >   */
> >  int rt_mutex_getprio(struct task_struct *task)
> >  {
> > +	int prio = task->normal_prio;
> > +
> > +	if (get_rcu_prio(task) < prio)
> > +		prio = get_rcu_prio(task);
> 
> int prio = min(task->normal_prio, get_rcu_prio(task)); ?

Good point -- and it even fits nicely on the declaration line for prio!  ;-)

> >  	if (likely(!task_has_pi_waiters(task)))
> > -		return task->normal_prio;
> > +		return prio;
> >  
> > -	return min(task_top_pi_waiter(task)->pi_list_entry.prio,
> > -		   task->normal_prio);
> > +	return min(task_top_pi_waiter(task)->pi_list_entry.prio, prio);
> >  }

Thank you again for the careful and thorough review!!!

I will test these changes and send out an update.

							Thanx, Paul
