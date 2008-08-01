Return-Path: <linux-kernel-owner+w=401wt.eu-S1762766AbYHAVSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762766AbYHAVSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761023AbYHAVLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:11:02 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:42975 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760548AbYHAVK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:10:56 -0400
Date: Fri, 1 Aug 2008 14:10:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Gautham Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] rcu classic: new algorithm for
	callbacks-processing(v2)
Message-ID: <20080801211053.GZ14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48708F2F.2060406@cn.fujitsu.com> <20080718140930.GT6875@elte.hu> <20080721100433.GC8384@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721100433.GC8384@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 03:04:33AM -0700, Paul E. McKenney wrote:
> On Fri, Jul 18, 2008 at 04:09:30PM +0200, Ingo Molnar wrote:
> > 
> > * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> > 
> > > This is v2, it's a little deference from v1 that I
> > > had send to lkml.
> > > use ACCESS_ONCE
> > > use rcu_batch_after/rcu_batch_before for batch # comparison.
> > > 
> > > rcutorture test result:
> > > (hotplugs: do cpu-online/offline once per second)
> > > 
> > > No CONFIG_NO_HZ:           OK, 12hours
> > > No CONFIG_NO_HZ, hotplugs: OK, 12hours
> > > CONFIG_NO_HZ=y:            OK, 24hours
> > > CONFIG_NO_HZ=y, hotplugs:  Failed.
> > > (Failed also without my patch applied, exactly the same bug occurred,
> > > http://lkml.org/lkml/2008/7/3/24)
> > 
> > thanks, i've applied this to tip/core/rcu - but it would be nice have an 
> > ack/nak from Paul as well, before we can proceed further.
> 
> I like the general approach -- simplification is a good thing.
> 
> So, for the moment:
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> I need to do a more detailed review (e.g., the memory-barrier changes
> and the incorporation of some grace-period processing into call_rcu()),
> after which I will either ask for changes or give a Reviewed-by.
> 
> I need to do this more-detailed review before we ship to mainline.
> (Gak, already two weeks since Jiangshan sent this!!!  My apologies!!!)


> diff -urpNa -X dontdiff linux-2.6.26/include/linux/rcuclassic.h linux-2.6.26-ljsimp/include/linux/rcuclassic.h
> --- linux-2.6.26/include/linux/rcuclassic.h	2008-07-13 14:51:29.000000000 -0700
> +++ linux-2.6.26-ljsimp/include/linux/rcuclassic.h	2008-07-24 13:44:59.000000000 -0700
> @@ -45,7 +45,7 @@
>  struct rcu_ctrlblk {
>  	long	cur;		/* Current batch number.                      */
>  	long	completed;	/* Number of the last completed batch         */
> -	int	next_pending;	/* Is the next batch already waiting?         */
> +	long	pending;	/* Number of the last pending batch           */

I vaguely remember some issue with cache locality motivating the change
to a simple flag.  However, if this change causes problems on large SMP
machines, a better fix would be to go to a hierarchical grace-period
detection algorithm.  So I am OK with this change.

>  	int	signaled;
>  
> @@ -66,11 +66,7 @@ static inline int rcu_batch_after(long a
>  	return (a - b) > 0;
>  }
>  
> -/*
> - * Per-CPU data for Read-Copy UPdate.
> - * nxtlist - new callbacks are added here
> - * curlist - current batch for which quiescent cycle started if any
> - */
> +/* Per-CPU data for Read-Copy UPdate. */
>  struct rcu_data {
>  	/* 1) quiescent state handling : */
>  	long		quiescbatch;     /* Batch # for grace period */
> @@ -78,12 +74,24 @@ struct rcu_data {
>  	int		qs_pending;	 /* core waits for quiesc state */
>  
>  	/* 2) batch handling */
> -	long  	       	batch;           /* Batch # for current RCU batch */
> +	/*
> +	 * if nxtlist is not NULL, then:
> +	 * batch:
> +	 *	The batch # for the last entry of nxtlist
> +	 * [*nxttail[1], NULL = *nxttail[2]):
> +	 *	Entries that batch # <= batch
> +	 * [*nxttail[0], *nxttail[1]):
> +	 *	Entries that batch # <= batch - 1
> +	 * [nxtlist, *nxttail[0]):
> +	 *	Entries that batch # <= batch - 2
> +	 *	The grace period for these entries has completed, and
> +	 *	the other grace-period-completed entries may be moved
> +	 *	here temporarily in rcu_process_callbacks().
> +	 */
> +	long  	       	batch;
>  	struct rcu_head *nxtlist;
> -	struct rcu_head **nxttail;
> +	struct rcu_head **nxttail[3];
>  	long            qlen; 	 	 /* # of queued callbacks */
> -	struct rcu_head *curlist;
> -	struct rcu_head **curtail;
>  	struct rcu_head *donelist;
>  	struct rcu_head **donetail;
>  	long		blimit;		 /* Upper limit on a processed batch */
> diff -urpNa -X dontdiff linux-2.6.26/kernel/rcuclassic.c linux-2.6.26-ljsimp/kernel/rcuclassic.c
> --- linux-2.6.26/kernel/rcuclassic.c	2008-07-13 14:51:29.000000000 -0700
> +++ linux-2.6.26-ljsimp/kernel/rcuclassic.c	2008-07-24 13:46:58.000000000 -0700
> @@ -60,12 +60,14 @@ EXPORT_SYMBOL_GPL(rcu_lock_map);
>  static struct rcu_ctrlblk rcu_ctrlblk = {
>  	.cur = -300,
>  	.completed = -300,
> +	.pending = -300,
>  	.lock = __SPIN_LOCK_UNLOCKED(&rcu_ctrlblk.lock),
>  	.cpumask = CPU_MASK_NONE,
>  };
>  static struct rcu_ctrlblk rcu_bh_ctrlblk = {
>  	.cur = -300,
>  	.completed = -300,
> +	.pending = -300,
>  	.lock = __SPIN_LOCK_UNLOCKED(&rcu_bh_ctrlblk.lock),
>  	.cpumask = CPU_MASK_NONE,
>  };
> @@ -118,6 +120,43 @@ static inline void force_quiescent_state
>  }
>  #endif
>  
> +static void __call_rcu(struct rcu_head *head, struct rcu_ctrlblk *rcp,
> +		struct rcu_data *rdp)
> +{
> +	long batch;
> +	smp_mb(); /* reads the most recently updated value of rcu->cur. */

A better comment would be something like:

	smb_mb(); /* Read of rcu->cur must happen after any change by caller. */

> +
> +	/*
> +	 * Determine the batch number of this callback.
> +	 *
> +	 * Using ACCESS_ONCE to avoid the following error when gcc eliminates
> +	 * local variable "batch" and emits codes like this:
> +	 *	1) rdp->batch = rcp->cur + 1 # gets old value
> +	 *	......
> +	 *	2)rcu_batch_after(rcp->cur + 1, rdp->batch) # gets new value
> +	 * then [*nxttail[0], *nxttail[1]) may contain callbacks
> +	 * that batch# = rdp->batch, see the comment of struct rcu_data.
> +	 */
> +	batch = ACCESS_ONCE(rcp->cur) + 1;
> +
> +	if (rdp->nxtlist && rcu_batch_after(batch, rdp->batch)) {
> +		/* process callbacks */
> +		rdp->nxttail[0] = rdp->nxttail[1];
> +		rdp->nxttail[1] = rdp->nxttail[2];
> +		if (rcu_batch_after(batch - 1, rdp->batch))
> +			rdp->nxttail[0] = rdp->nxttail[2];
> +	}
> +
> +	rdp->batch = batch;
> +	*rdp->nxttail[2] = head;
> +	rdp->nxttail[2] = &head->next;
> +
> +	if (unlikely(++rdp->qlen > qhimark)) {
> +		rdp->blimit = INT_MAX;
> +		force_quiescent_state(rdp, &rcu_ctrlblk);
> +	}
> +}
> +
>  /**
>   * call_rcu - Queue an RCU callback for invocation after a grace period.
>   * @head: structure to be used for queueing the RCU updates.
> @@ -133,18 +172,11 @@ void call_rcu(struct rcu_head *head,
>  				void (*func)(struct rcu_head *rcu))
>  {
>  	unsigned long flags;
> -	struct rcu_data *rdp;
>  
>  	head->func = func;
>  	head->next = NULL;
>  	local_irq_save(flags);

I very much like the gathering of common code from call_rcu() and
call_rcu_bh() into __call_rcu().  But why not also move the
local_irq_save() and local_irq_restore() to __call_rcu(), perhaps
along with the initialization of head->next?

(I understand the motivation for keeping the initialization of the
fields of "head" at this level -- otherwise, you must add another
argument to __call_rcu().  But might be worth considering...)

> -	rdp = &__get_cpu_var(rcu_data);
> -	*rdp->nxttail = head;
> -	rdp->nxttail = &head->next;
> -	if (unlikely(++rdp->qlen > qhimark)) {
> -		rdp->blimit = INT_MAX;
> -		force_quiescent_state(rdp, &rcu_ctrlblk);
> -	}
> +	__call_rcu(head, &rcu_ctrlblk, &__get_cpu_var(rcu_data));
>  	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL_GPL(call_rcu);
> @@ -169,20 +201,11 @@ void call_rcu_bh(struct rcu_head *head,
>  				void (*func)(struct rcu_head *rcu))
>  {
>  	unsigned long flags;
> -	struct rcu_data *rdp;
>  
>  	head->func = func;
>  	head->next = NULL;
>  	local_irq_save(flags);
> -	rdp = &__get_cpu_var(rcu_bh_data);
> -	*rdp->nxttail = head;
> -	rdp->nxttail = &head->next;
> -
> -	if (unlikely(++rdp->qlen > qhimark)) {
> -		rdp->blimit = INT_MAX;
> -		force_quiescent_state(rdp, &rcu_bh_ctrlblk);
> -	}
> -
> +	__call_rcu(head, &rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
>  	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL_GPL(call_rcu_bh);
> @@ -211,12 +234,6 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed_
>  static inline void raise_rcu_softirq(void)
>  {
>  	raise_softirq(RCU_SOFTIRQ);
> -	/*
> -	 * The smp_mb() here is required to ensure that this cpu's
> -	 * __rcu_process_callbacks() reads the most recently updated
> -	 * value of rcu->cur.
> -	 */
> -	smp_mb();

I have not yet convinced myself that it is OK to get rid of this memory
barrier.  This memory barrier was intended order to handle the following
sequence of events:

	rcu_read_lock_bh();  /* no memory barrier. */
	p = rcu_dereference(some_global_pointer);
	do_something_with(p);
	rcu_read_unlock_bh();  /* no memory barrier. */

	---- scheduling-clock interrupt occurs, eventually invoking
	---- rcu_check_callbacks()

	---- And the access to "p" above could potentially be reordered
	---- into the grace-period computation

Such reordering is of course quite unlikely to be harmful, due to the
long duration of RCU grace periods.  But I am paranoid.

If this memory barrier turns out to be necessary, one approach would
to be to place it at the beginning of rcu_check_callbacks(), which is
a better place for it in any case.

Thoughts?

>  }
>  
>  /*
> @@ -276,14 +293,8 @@ static void rcu_do_batch(struct rcu_data
>   */
>  static void rcu_start_batch(struct rcu_ctrlblk *rcp)
>  {
> -	if (rcp->next_pending &&
> +	if (rcp->cur != rcp->pending &&
>  			rcp->completed == rcp->cur) {
> -		rcp->next_pending = 0;
> -		/*
> -		 * next_pending == 0 must be visible in
> -		 * __rcu_process_callbacks() before it can see new value of cur.
> -		 */
> -		smp_wmb();

These memory barriers were added to allow for the fact that we run much
of the grace-period machinery without holding locks.

>  		rcp->cur++;
>  
>  		/*
> @@ -364,13 +375,15 @@ static void rcu_check_quiescent_state(st
>   * which is dead and hence not processing interrupts.
>   */
>  static void rcu_move_batch(struct rcu_data *this_rdp, struct rcu_head *list,
> -				struct rcu_head **tail)
> +				struct rcu_head **tail, long batch)
>  {
> -	local_irq_disable();
> -	*this_rdp->nxttail = list;
> -	if (list)
> -		this_rdp->nxttail = tail;
> -	local_irq_enable();
> +	if (list) {
> +		local_irq_disable();
> +		this_rdp->batch = batch;
> +		*this_rdp->nxttail[2] = list;
> +		this_rdp->nxttail[2] = tail;
> +		local_irq_enable();
> +	}
>  }
>  
>  static void __rcu_offline_cpu(struct rcu_data *this_rdp,
> @@ -384,9 +397,9 @@ static void __rcu_offline_cpu(struct rcu
>  	if (rcp->cur != rcp->completed)
>  		cpu_quiet(rdp->cpu, rcp);
>  	spin_unlock_bh(&rcp->lock);
> -	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail);
> -	rcu_move_batch(this_rdp, rdp->curlist, rdp->curtail);
> -	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail);
> +	/* spin_lock implies smp_mb() */

Almost.  Please note that spin_lock() and spin_unlock() are permitted
to imply semi-permeable memory barriers.  See the ia64 implementation for
an example of this.  The upshot is that spin_lock() is permitted to
allow prior memory references to "bleed" into the critical section, and
spin_unlock() is likewise permitted to allow subsequent memory
references to "bleed" into the critical section.  So, if you have code
as follows:

	a = 1;
	spin_lock(&my_lock);
	b = 1;
	c = 1;
	spin_unlock(&my_lock);
	d = 1;

Then the following is a perfectly legal execution ordering:

	spin_lock(&my_lock);
	d = 1;
	c = 1;
	b = 1;
	a = 1;
	spin_unlock(&my_lock);

Not sure if this causes the code any problems, but at the very least,
the comment needs to change.

more later...

							Thanx, Paul

> +	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail, rcp->cur + 1);
> +	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail[2], rcp->cur + 1);
>  }
>  
>  static void rcu_offline_cpu(int cpu)
> @@ -416,37 +429,45 @@ static void rcu_offline_cpu(int cpu)
>  static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
>  					struct rcu_data *rdp)
>  {
> -	if (rdp->curlist && !rcu_batch_before(rcp->completed, rdp->batch)) {
> -		*rdp->donetail = rdp->curlist;
> -		rdp->donetail = rdp->curtail;
> -		rdp->curlist = NULL;
> -		rdp->curtail = &rdp->curlist;
> -	}
> -
> -	if (rdp->nxtlist && !rdp->curlist) {
> +	if (rdp->nxtlist) {
>  		local_irq_disable();
> -		rdp->curlist = rdp->nxtlist;
> -		rdp->curtail = rdp->nxttail;
> -		rdp->nxtlist = NULL;
> -		rdp->nxttail = &rdp->nxtlist;
> -		local_irq_enable();
>  
>  		/*
> -		 * start the next batch of callbacks
> +		 * move the other grace-period-completed entries to
> +		 * [rdp->nxtlist, *rdp->nxttail[0]) temporarily
>  		 */
> +		if (!rcu_batch_before(rcp->completed, rdp->batch))
> +			rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2];
> +		else if (!rcu_batch_before(rcp->completed, rdp->batch - 1))
> +			rdp->nxttail[0] = rdp->nxttail[1];
>  
> -		/* determine batch number */
> -		rdp->batch = rcp->cur + 1;
> -		/* see the comment and corresponding wmb() in
> -		 * the rcu_start_batch()
> +		/*
> +		 * the grace period for entries in
> +		 * [rdp->nxtlist, *rdp->nxttail[0]) has completed and
> +		 * move these entries to donelist
>  		 */
> -		smp_rmb();
> +		if (rdp->nxttail[0] != &rdp->nxtlist) {
> +			*rdp->donetail = rdp->nxtlist;
> +			rdp->donetail = rdp->nxttail[0];
> +			rdp->nxtlist = *rdp->nxttail[0];
> +			*rdp->donetail = NULL;
> +
> +			if (rdp->nxttail[1] == rdp->nxttail[0])
> +				rdp->nxttail[1] = &rdp->nxtlist;
> +			if (rdp->nxttail[2] == rdp->nxttail[0])
> +				rdp->nxttail[2] = &rdp->nxtlist;
> +			rdp->nxttail[0] = &rdp->nxtlist;
> +		}
> +
> +		local_irq_enable();
>  
> -		if (!rcp->next_pending) {
> +		if (rcu_batch_after(rdp->batch, rcp->pending)) {
>  			/* and start it/schedule start if it's a new batch */
>  			spin_lock(&rcp->lock);
> -			rcp->next_pending = 1;
> -			rcu_start_batch(rcp);
> +			if (rcu_batch_after(rdp->batch, rcp->pending)) {
> +				rcp->pending = rdp->batch;
> +				rcu_start_batch(rcp);
> +			}
>  			spin_unlock(&rcp->lock);
>  		}
>  	}
> @@ -464,15 +485,26 @@ static void rcu_process_callbacks(struct
>  
>  static int __rcu_pending(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
>  {
> -	/* This cpu has pending rcu entries and the grace period
> -	 * for them has completed.
> -	 */
> -	if (rdp->curlist && !rcu_batch_before(rcp->completed, rdp->batch))
> -		return 1;
> +	if (rdp->nxtlist) {
> +		/*
> +		 * This cpu has pending rcu entries and the grace period
> +		 * for them has completed.
> +		 */
> +		if (!rcu_batch_before(rcp->completed, rdp->batch))
> +			return 1;
> +		if (!rcu_batch_before(rcp->completed, rdp->batch - 1) &&
> +				rdp->nxttail[0] != rdp->nxttail[1])
> +			return 1;
> +		if (rdp->nxttail[0] != &rdp->nxtlist)
> +			return 1;
>  
> -	/* This cpu has no pending entries, but there are new entries */
> -	if (!rdp->curlist && rdp->nxtlist)
> -		return 1;
> +		/*
> +		 * This cpu has pending rcu entries and the new batch
> +		 * for then hasn't been started nor scheduled start
> +		 */
> +		if (rcu_batch_after(rdp->batch, rcp->pending))
> +			return 1;
> +	}
>  
>  	/* This cpu has finished callbacks to invoke */
>  	if (rdp->donelist)
> @@ -508,7 +540,7 @@ int rcu_needs_cpu(int cpu)
>  	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
>  	struct rcu_data *rdp_bh = &per_cpu(rcu_bh_data, cpu);
>  
> -	return (!!rdp->curlist || !!rdp_bh->curlist || rcu_pending(cpu));
> +	return !!rdp->nxtlist || !!rdp_bh->nxtlist || rcu_pending(cpu);
>  }
>  
>  void rcu_check_callbacks(int cpu, int user)
> @@ -527,8 +559,7 @@ static void rcu_init_percpu_data(int cpu
>  						struct rcu_data *rdp)
>  {
>  	memset(rdp, 0, sizeof(*rdp));
> -	rdp->curtail = &rdp->curlist;
> -	rdp->nxttail = &rdp->nxtlist;
> +	rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2] = &rdp->nxtlist;
>  	rdp->donetail = &rdp->donelist;
>  	rdp->quiescbatch = rcp->completed;
>  	rdp->qs_pending = 0;
