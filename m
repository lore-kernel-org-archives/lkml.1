Return-Path: <linux-kernel-owner+w=401wt.eu-S933622AbXHVVWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622AbXHVVWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763567AbXHVVWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:22:23 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46038 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762371AbXHVVWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:22:21 -0400
Date: Wed, 22 Aug 2007 14:22:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de
Subject: Re: [PATCH RFC] Priority boosting for preemptible RCU
Message-ID: <20070822212216.GE8786@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070822190254.GA1135@linux.vnet.ibm.com> <20070822124340.16a891f2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822124340.16a891f2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 12:43:40PM -0700, Andrew Morton wrote:
> On Wed, 22 Aug 2007 12:02:54 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Hello!
> > 
> > This patch is a forward-port of RCU priority boosting (described in
> > http://lwn.net/Articles/220677/).  It applies to 2.6.22 on top of
> > the patches sent in the http://lkml.org/lkml/2007/8/7/276 series and
> > the hotplug patch (http://lkml.org/lkml/2007/8/17/262).  Passes several
> > hours of rcutorture on x86_64 and POWER, so OK for experimentation but
> > not ready for inclusion.
> 
> It'd be nice to have a brief summary of why we might want this code in Linux.

Good point -- will add something like the following in the next rev:

	RCU priority boosting is needed when running a workload that might
	include CPU-bound user tasks running at realtime priorities with
	a CONFIG_PREEMPT build of the kernel.  In this situation, RCU
	priority boosting is needed to avoid OOM.

Does that cover it?

> > ...
> >
> > +#ifdef CONFIG_PREEMPT_RCU_BOOST
> 
> Do we really need this?  Why not just enable the feature all the time?

In the near term, because it has not had the amount of testing time that
the rest of RCU has had, so would want a way to disable it easily.  It
also adds a small bit of code to some hot code paths -- I don't believe
this to be measurable, let alone significant, but...

> > ...
> >  
> > +#ifdef CONFIG_PREEMPT_RCU_BOOST
> > +extern void init_rcu_boost_late(void);
> > +extern void __rcu_preempt_boost(void);
> > +#define rcu_preempt_boost() \
> > +	do { \
> > +		if (unlikely(current->rcu_read_lock_nesting > 0)) \
> > +			__rcu_preempt_boost(); \
> > +	} while (0)
> 
> This could be a C function, couldn't it?  Probably an inlined one.

Good point!

> > +#else /* #ifdef CONFIG_PREEMPT_RCU_BOOST */
> > +#define init_rcu_boost_late()
> > +#define rcu_preempt_boost()
> 
> These need the `do {} while(0)' thing.  I don't immediately recall why, but
> trust me ;)  At least to avoid "empty body in an else-statement" warnings.

These are very restricted things that are only invoked in a few places,
but certainly doesn't hurt to add the "armor".  Will do.

> But, again, the rule should be: only code in cpp when it is not possible to
> code in C.  These could be coded in C.

Agreed.

> > +#ifdef CONFIG_PREEMPT_RCU_BOOST
> > +#define set_rcu_prio(p, prio)  ((p)->rcu_prio = (prio))
> > +#define get_rcu_prio(p) ((p)->rcu_prio)
> > +#else /* #ifdef CONFIG_PREEMPT_RCU_BOOST */
> > +#define set_rcu_prio(p, prio)  do { } while (0)
> > +#define get_rcu_prio(p) MAX_PRIO
> > +#endif /* #else #ifdef CONFIG_PREEMPT_RCU_BOOST */
> 
> More macros-which-don't-need-to-be-macros.

Will fix.

> > +config PREEMPT_RCU_BOOST_STATS_INTERVAL
> 
> Four new config options?  Sob.  Zero would be preferable.

Hmmm...  I should be able to fold this into PREEMPT_RCU_BOOST_STATS,
now that you mention it.  Zero to disable, other number to specify
interval.  And I should move this to the kernel-hacking group as
well.  Would that help?

> >   * PREEMPT_RCU data structures.
> > @@ -82,6 +83,525 @@ static struct rcu_ctrlblk rcu_ctrlblk = 
> >  };
> >  static DEFINE_PER_CPU(int [2], rcu_flipctr) = { 0, 0 };
> >  
> > +#ifndef CONFIG_PREEMPT_RCU_BOOST
> > +static inline void init_rcu_boost_early(void) { }
> > +static inline void rcu_read_unlock_unboost(void) { }
> > +#else /* #ifndef CONFIG_PREEMPT_RCU_BOOST */
> > +
> > +/* Defines possible event indices for ->rbs_stats[] (first index). */
> > +
> > +#define RCU_BOOST_DAT_BLOCK	0
> > +#define RCU_BOOST_DAT_BOOST	1
> > +#define RCU_BOOST_DAT_UNLOCK	2
> > +#define N_RCU_BOOST_DAT_EVENTS	3
> > +
> > +/* RCU-boost per-CPU array element. */
> > +
> > +struct rcu_boost_dat {
> > +	spinlock_t rbs_mutex;
> 
> It would be more conventional to name this rbs_lock.

OK.

> > +	struct list_head rbs_toboost;
> > +	struct list_head rbs_boosted;
> > +	unsigned long rbs_blocked;
> > +	unsigned long rbs_boost_attempt;
> > +	unsigned long rbs_boost;
> > +	unsigned long rbs_unlock;
> > +	unsigned long rbs_unboosted;
> > +#ifdef CONFIG_PREEMPT_RCU_BOOST_STATS
> > +	unsigned long rbs_stats[N_RCU_BOOST_DAT_EVENTS][N_RCU_BOOST_STATE];
> > +#endif /* #ifdef CONFIG_PREEMPT_RCU_BOOST_STATS */
> > +};
> > +#define RCU_BOOST_ELEMENTS 4
> > +
> > +int rcu_boost_idx = -1; /* invalid value in case someone uses RCU early. */
> > +DEFINE_PER_CPU(struct rcu_boost_dat, rcu_boost_dat[RCU_BOOST_ELEMENTS]);
> 
> Do these need global scope?

Not anymore, good catch, will fix.

> > +static struct task_struct *rcu_boost_task = NULL;
> 
> Please always pass all patches through scripts/checkpatch.pl

Good point!!!

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
> > +		rbdp->rbs_stats[event][RCU_BOOST_INVALID]++;
> > +	}
> > +}
> 
> 	if (oldstate >= RCU_BOOST_IDLE && oldstate <= RCU_BOOSTED)
> 		rbdp->rbs_stats[event][oldstate]++;
> 	else
> 		rbdp->rbs_stats[event][RCU_BOOST_INVALID]++;
> 
> Much less fuss, no?

Old habits die hard.  ;-)

> > +#define rcu_boost_dat_stat_block(rbdp, oldstate) \
> > +	rcu_boost_dat_stat(rbdp, RCU_BOOST_DAT_BLOCK, oldstate)
> > +#define rcu_boost_dat_stat_boost(rbdp, oldstate) \
> > +	rcu_boost_dat_stat(rbdp, RCU_BOOST_DAT_BOOST, oldstate)
> > +#define rcu_boost_dat_stat_unlock(rbdp, oldstate) \
> > +	rcu_boost_dat_stat(rbdp, RCU_BOOST_DAT_UNLOCK, oldstate)
> 
> c-not-cpp.

Will fix.

> > +/*
> > + * Print out RCU booster task statistics at the specified interval.
> > + */
> > +static void rcu_boost_dat_stat_print(void)
> > +{
> > +	/* Three decimal digits per byte plus spacing per number and line. */
> > +	char buf[N_RCU_BOOST_STATE * (sizeof(long) * 3 + 2) + 2];
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
> 	if (xtime.tv_sec - lastprint < CONFIG_PREEMPT_RCU_BOOST_STATS_INTERVAL)
> 		return;
> 
> or even time_after()..

Fair enough.

> > +	/* Sum up the state/event-independent counters. */
> > +
> > +	sum.rbs_blocked = 0;
> > +	sum.rbs_boost_attempt = 0;
> > +	sum.rbs_boost = 0;
> > +	sum.rbs_unlock = 0;
> > +	sum.rbs_unboosted = 0;
> > +	for_each_possible_cpu(cpu)
> > +		for (i = 0; i < RCU_BOOST_ELEMENTS; i++) {
> > +			rbdp = per_cpu(rcu_boost_dat, cpu);
> > +			sum.rbs_blocked += rbdp[i].rbs_blocked;
> > +			sum.rbs_boost_attempt += rbdp[i].rbs_boost_attempt;
> > +			sum.rbs_boost += rbdp[i].rbs_boost;
> > +			sum.rbs_unlock += rbdp[i].rbs_unlock;
> > +			sum.rbs_unboosted += rbdp[i].rbs_unboosted;
> > +		}
> > +
> > +	/* Sum up the state/event-dependent counters. */
> > +
> > +	for (event = 0; event < N_RCU_BOOST_DAT_EVENTS; event++)
> > +		for (state = 0; state < N_RCU_BOOST_STATE; state++) {
> > +			sum.rbs_stats[event][state] = 0;
> > +			for_each_possible_cpu(cpu) {
> > +				for (i = 0; i < RCU_BOOST_ELEMENTS; i++) {
> > +					sum.rbs_stats[event][state]
> > +					    += per_cpu(rcu_boost_dat,
> > +						       cpu)[i].rbs_stats[event][state];
> > +				}
> > +			}
> > +		}
> 
> for_each_possible_cpu() can sometimes do a *lot* more work than
> for_each_online_cpu().  And even for_each_present_cpu().

for_each_online_cpu() would not cut it here, but for_each_present_cpu()
might -- as long as no platforms physically hotplug the CPUs.

> > +	/* Print them out! */
> > +
> > +	printk(KERN_ALERT
> > +	       "rcu_boost_dat: idx=%d "
> > +	       "b=%lu ul=%lu ub=%lu boost: a=%lu b=%lu\n",
> > +	       rcu_boost_idx,
> > +	       sum.rbs_blocked, sum.rbs_unlock, sum.rbs_unboosted,
> > +	       sum.rbs_boost_attempt, sum.rbs_boost);
> > +	for (event = 0; event < N_RCU_BOOST_DAT_EVENTS; event++) {
> > +		i = 0;
> > +		for (state = 0; state < N_RCU_BOOST_STATE; state++) {
> > +			i += sprintf(&buf[i], " %ld%c",
> > +				     sum.rbs_stats[event][state],
> > +				     rcu_boost_state_error[event][state]);
> > +		}
> > +		printk(KERN_ALERT "rcu_boost_dat %s %s\n",
> > +		       rcu_boost_state_event[event], buf);
> > +	}
> > +
> > +	/* Go away and don't come back for awhile. */
> > +
> > +	lastprint = xtime.tv_sec;
> > +}
> > +
> > +#else /* #ifdef CONFIG_PREEMPT_RCU_BOOST_STATS */
> > +
> > +#define rcu_boost_dat_stat_block(rbdp, oldstate)
> > +#define rcu_boost_dat_stat_boost(rbdp, oldstate)
> > +#define rcu_boost_dat_stat_unlock(rbdp, oldstate)
> > +#define rcu_boost_dat_stat_print()
> 
> argh.

OK, will make functions of these as well...

> > +#endif /* #else #ifdef CONFIG_PREEMPT_RCU_BOOST_STATS */
> > +
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
> > +			rbdp[i].rbs_mutex = SPIN_LOCK_UNLOCKED;
> 
> Doesn't this confound lockdep?   We're supposed to use spin_lock_init().

OK, will fix.

> Andy, can we have a checkpatch rule for SPIN_LOCK_UNLOCKED please?  It's
> basically always wrong.

Even for static initializers for top-level variables?

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
> > +					for (k = 0; k < N_RCU_BOOST_STATE; k++)
> > +						rbdp[i].rbs_stats[j][k] = 0;
> > +			}
> > +#endif /* #ifdef CONFIG_PREEMPT_RCU_BOOST_STATS */
> > +		}
> > +		smp_wmb();  /* Make sure readers see above initialization. */
> > +		rcu_boost_idx = 0;  /* Allow readers to access data. */
> > +	}
> > +}
> > +
> > +/*
> > + * Return the list on which the calling task should add itself, or
> > + * NULL if too early during initialization.
> > + */
> > +static inline struct rcu_boost_dat *rcu_rbd_new(void)
> > +{
> > +	int cpu = raw_smp_processor_id();  /* locks used, so preemption OK. */
> 
> plain old smp_processor_id() could have been used here.

Good point, missed this one on conversion from -rt.

> > +	int idx = rcu_boost_idx;
> > +
> > +	smp_read_barrier_depends(); barrier(); /* rmb() on Alpha for idx. */
> 
> newline, please.

Or dump the line entirely in favor of rcu_dereference() in the initializer
of idx.

> > +	if (unlikely(idx < 0))
> > +		return (NULL);
> 
> return-is-not-a-function

You lost me on this one...  You presumably aren't asking it to be converted
to a macro.  You want it manually inlined where called?

> > +	return &per_cpu(rcu_boost_dat, cpu)[idx];
> > +}
> > +
> > +/*
> > + * Return the list from which to boost target tasks.
> > + * May only be invoked by the booster task, so guaranteed to
> > + * already be initialized.  Use rcu_boost_dat element least recently
> > + * the destination for task blocking in RCU read-side critical sections.
> > + */
> > +static inline struct rcu_boost_dat *rcu_rbd_boosting(int cpu)
> > +{
> > +	int idx = (rcu_boost_idx + 1) & (RCU_BOOST_ELEMENTS - 1);
> > +
> > +	return &per_cpu(rcu_boost_dat, cpu)[idx];
> > +}
> > +
> > +#define PREEMPT_RCU_BOOSTER_PRIO 49  /* Match curr_irq_prio manually. */
> > +			             /*  Administrators can always adjust */
> > +				     /*  via the /proc interface. */
> > +
> > +/*
> > + * Boost the specified task from an RCU viewpoint.
> > + * Boost the target task to a priority just a bit less-favored than
> > + * that of the RCU-boost task, but boost to a realtime priority even
> > + * if the RCU-boost task is running at a non-realtime priority.
> > + * We check the priority of the RCU-boost task each time we boost
> > + * in case the sysadm manually changes the priority.
> > + */
> > +static void rcu_boost_prio(struct task_struct *taskp)
> > +{
> > +	unsigned long oldirq;
> 
> It's conventional to name this "flags".

OK.  I clearly copied the wrong code (probably long ago).

> > +	int rcuprio;
> > +
> > +	spin_lock_irqsave(&current->pi_lock, oldirq);
> > +	rcuprio = rt_mutex_getprio(current) + 1;
> > +	if (rcuprio >= MAX_USER_RT_PRIO)
> > +		rcuprio = MAX_USER_RT_PRIO - 1;
> > +	spin_unlock_irqrestore(&current->pi_lock, oldirq);
> > +	spin_lock_irqsave(&taskp->pi_lock, oldirq);
> 
> Sometimes we'll just do spin_unlock+spin_lock here and leave irqs disabled.
> Saves a few cycles.

Feels a bit scary, but could do that.

> > +	if (taskp->rcu_prio != rcuprio) {
> > +		taskp->rcu_prio = rcuprio;
> > +		if (taskp->rcu_prio != taskp->prio)
> > +			rt_mutex_setprio(taskp, taskp->rcu_prio);
> > +	}
> > +	spin_unlock_irqrestore(&taskp->pi_lock, oldirq);
> > +}
> > +
> > +/*
> > + * Unboost the specified task from an RCU viewpoint.
> > + */
> > +static void rcu_unboost_prio(struct task_struct *taskp)
> > +{
> > +	int nprio;
> > +	unsigned long oldirq;
> 
> `flags' would reduce the surprise factor a bit.

Fair enough!

> > +	spin_lock_irqsave(&taskp->pi_lock, oldirq);
> > +	taskp->rcu_prio = MAX_PRIO;
> > +	nprio = rt_mutex_getprio(taskp);
> > +	if (nprio > taskp->prio)
> > +		rt_mutex_setprio(taskp, nprio);
> > +	spin_unlock_irqrestore(&taskp->pi_lock, oldirq);
> > +}
> > +
> >
> > ...
> >
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
> 
> I suppose using
> 
> 	struct sched_param sp = { .sched_priority = PREEMPT_RCU_BOOSTER_PRIO, };
> 
> would provide a bit of future-safety here.

OK.

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
> > +		}
> > +
> > +		/*
> > +		 * Sleep to allow any unstalled RCU read-side critical
> > +		 * sections to age out of the list.  @@@ FIXME: reduce,
> > +		 * adjust, or eliminate in case of OOM.
> > +		 */
> > +
> > +		schedule_timeout_uninterruptible(HZ / 100);
> 
> Boy, that's a long time.

Later patch enables this loop to just sleep when there is nothing
to boost.  That said, making this "HZ" rather than "HZ / 100" would
indeed be appropriate.

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
> > +
> > +	/* Spawn RCU-boost task. */
> > +
> > +	printk(KERN_INFO "Starting RCU priority booster\n");
> > +	rcu_boost_task = kthread_run(rcu_booster, NULL, "RCU Prio Booster");
> > +	if (IS_ERR(rcu_boost_task)) {
> > +		printk(KERN_ALERT
> > +		       "Unable to create RCU Priority Booster, errno %ld\n",
> > +		       -PTR_ERR(rcu_boost_task));
> > +
> > +		/*
> > +		 * Continue running, but tasks permanently blocked
> > +		 * in RCU read-side critical sections will be able
> > +		 * to stall grace-period processing, potentially
> > +		 * OOMing the machine.
> > +		 */
> 
> I don't think we want to try to struggle along like that.  This thread is a
> piece of core infrastructure: if we couldn't start it then just panic
> rather than trying to run the kernel in unknown and untested regions of
> operation.

Interesting point.  At present, we have a -lot- more runtime without
RCU priority boosting than with.  On the other hand, if life is so hard
at boot time that one cannot create a task, probably indeed best to
just give up gracefully.  Will fix.

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
> > +		printk(KERN_ALERT
> > +		       "Preempted RCU read-side critical section too early.\n");
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
> > +	/* Now add ourselves to the list so that the booster can find us. */
> > +
> > +	list_add_tail(&current->rcub_entry, &rbdp->rbs_toboost);
> > +	current->rcub_rbdp = rbdp;
> > +	spin_unlock_irqrestore(&rbdp->rbs_mutex, oldirq);
> > +}
> > +
> 
