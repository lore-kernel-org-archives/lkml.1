Return-Path: <linux-kernel-owner+w=401wt.eu-S1762641AbYHERlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762641AbYHERlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbYHERlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:41:11 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57058 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761162AbYHERlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:41:09 -0400
Date: Tue, 5 Aug 2008 10:40:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       oleg@tv-sign.ru, manfred@colorfullife.com, dipankar@in.ibm.com,
       dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: [PATCH tip/core/rcu] classic RCU locking and memory-barrier
	cleanups
Message-ID: <20080805174058.GE6737@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080805162144.GA8297@linux.vnet.ibm.com> <alpine.DEB.1.10.0808051244550.27713@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808051244550.27713@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 12:48:41PM -0400, Steven Rostedt wrote:

Thank you for looking this over, Steve!

> On Tue, 5 Aug 2008, Paul E. McKenney wrote:
> > ---
> > 
> >  rcuclassic.c |   51 +++++++++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 41 insertions(+), 10 deletions(-)
> > 
> > diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> > index d3553ee..e6f42ef 100644
> > --- a/kernel/rcuclassic.c
> > +++ b/kernel/rcuclassic.c
> > @@ -86,6 +86,7 @@ static void force_quiescent_state(struct rcu_data *rdp,
> >  	int cpu;
> >  	cpumask_t cpumask;
> >  	set_need_resched();
> > +	spin_lock(&rcp->lock);
> >  	if (unlikely(!rcp->signaled)) {
> >  		rcp->signaled = 1;
> >  		/*
> > @@ -111,6 +112,7 @@ static void force_quiescent_state(struct rcu_data *rdp,
> >  		for_each_cpu_mask(cpu, cpumask)
> >  			smp_send_reschedule(cpu);
> >  	}
> > +	spin_unlock(&rcp->lock);
> >  }
> >  #else
> >  static inline void force_quiescent_state(struct rcu_data *rdp,
> > @@ -124,7 +126,9 @@ static void __call_rcu(struct rcu_head *head, struct rcu_ctrlblk *rcp,
> >  		struct rcu_data *rdp)
> >  {
> >  	long batch;
> > -	smp_mb(); /* reads the most recently updated value of rcu->cur. */
> > +
> > +	head->next = NULL;
> > +	smp_mb(); /* Read of rcu->cur must happen after any change by caller. */
> >  
> >  	/*
> >  	 * Determine the batch number of this callback.
> > @@ -174,7 +178,6 @@ void call_rcu(struct rcu_head *head,
> >  	unsigned long flags;
> >  
> >  	head->func = func;
> > -	head->next = NULL;
> >  	local_irq_save(flags);
> >  	__call_rcu(head, &rcu_ctrlblk, &__get_cpu_var(rcu_data));
> >  	local_irq_restore(flags);
> > @@ -203,7 +206,6 @@ void call_rcu_bh(struct rcu_head *head,
> >  	unsigned long flags;
> >  
> >  	head->func = func;
> > -	head->next = NULL;
> >  	local_irq_save(flags);
> >  	__call_rcu(head, &rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
> >  	local_irq_restore(flags);
> > @@ -389,17 +391,17 @@ static void rcu_move_batch(struct rcu_data *this_rdp, struct rcu_head *list,
> >  static void __rcu_offline_cpu(struct rcu_data *this_rdp,
> >  				struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
> >  {
> > -	/* if the cpu going offline owns the grace period
> > +	/*
> > +	 * if the cpu going offline owns the grace period
> >  	 * we can block indefinitely waiting for it, so flush
> >  	 * it here
> >  	 */
> >  	spin_lock_bh(&rcp->lock);
> >  	if (rcp->cur != rcp->completed)
> >  		cpu_quiet(rdp->cpu, rcp);
> > -	spin_unlock_bh(&rcp->lock);
> > -	/* spin_lock implies smp_mb() */
> 
> The spin_unlock is being removed here. Was that the smp_mb that was 
> implied or is it the above spin_lock_bh?

Moving the spinlock down below, combined with adding spinlocks elsewhere,
eliminates the need for the memory barrier -- the locking primitives
provide full ordering and atomicity as well.  This does likely reduce
scalability somewhat, which I will address with a hierarchical approach
in a later patch.

							Thanx, Paul

> >  	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail, rcp->cur + 1);
> >  	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail[2], rcp->cur + 1);
> > +	spin_unlock_bh(&rcp->lock);
> >  
> >  	local_irq_disable();
> >  	this_rdp->qlen += rdp->qlen;
> > @@ -433,16 +435,19 @@ static void rcu_offline_cpu(int cpu)
> >  static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
> >  					struct rcu_data *rdp)
> >  {
> > +	long completed_snap;
> > +
> >  	if (rdp->nxtlist) {
> >  		local_irq_disable();
> > +		completed_snap = ACCESS_ONCE(rcp->completed);
> >  
> >  		/*
> >  		 * move the other grace-period-completed entries to
> >  		 * [rdp->nxtlist, *rdp->nxttail[0]) temporarily
> >  		 */
> > -		if (!rcu_batch_before(rcp->completed, rdp->batch))
> > +		if (!rcu_batch_before(completed_snap, rdp->batch))
> >  			rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2];
> > -		else if (!rcu_batch_before(rcp->completed, rdp->batch - 1))
> > +		else if (!rcu_batch_before(completed_snap, rdp->batch - 1))
> >  			rdp->nxttail[0] = rdp->nxttail[1];
> >  
> >  		/*
> > @@ -483,20 +488,38 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
> >  
> >  static void rcu_process_callbacks(struct softirq_action *unused)
> >  {
> > +	/*
> > +	 * Memory references from any prior RCU read-side critical sections
> > +	 * executed by the interrupted code must be see before any RCU
> > +	 * grace-period manupulations below.
> > +	 */
> > +
> > +	smp_mb(); /* See above block comment. */
> > +
> >  	__rcu_process_callbacks(&rcu_ctrlblk, &__get_cpu_var(rcu_data));
> >  	__rcu_process_callbacks(&rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
> > +
> > +	/*
> > +	 * Memory references from any later RCU read-side critical sections
> > +	 * executed by the interrupted code must be see after any RCU
> > +	 * grace-period manupulations above.
> > +	 */
> > +
> > +	smp_mb(); /* See above block comment. */
> >  }
> >  
> >  static int __rcu_pending(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
> >  {
> >  	if (rdp->nxtlist) {
> > +		long completed_snap = ACCESS_ONCE(rcp->completed);
> > +
> >  		/*
> >  		 * This cpu has pending rcu entries and the grace period
> >  		 * for them has completed.
> >  		 */
> > -		if (!rcu_batch_before(rcp->completed, rdp->batch))
> > +		if (!rcu_batch_before(completed_snap, rdp->batch))
> >  			return 1;
> > -		if (!rcu_batch_before(rcp->completed, rdp->batch - 1) &&
> > +		if (!rcu_batch_before(completed_snap, rdp->batch - 1) &&
> >  				rdp->nxttail[0] != rdp->nxttail[1])
> >  			return 1;
> >  		if (rdp->nxttail[0] != &rdp->nxtlist)
> > @@ -547,6 +570,12 @@ int rcu_needs_cpu(int cpu)
> >  	return !!rdp->nxtlist || !!rdp_bh->nxtlist || rcu_pending(cpu);
> >  }
> >  
> > +/*
> > + * Top-level function driving RCU grace-period detection, normally
> > + * invoked from the scheduler-clock interrupt.  This function simply
> > + * increments counters that are read only from softirq by this same
> > + * CPU, so there are no memory barriers required.
> > + */
> >  void rcu_check_callbacks(int cpu, int user)
> >  {
> >  	if (user ||
> > @@ -590,6 +619,7 @@ void rcu_check_callbacks(int cpu, int user)
> >  static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
> >  						struct rcu_data *rdp)
> >  {
> > +	spin_lock(&rcp->lock);
> >  	memset(rdp, 0, sizeof(*rdp));
> >  	rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2] = &rdp->nxtlist;
> >  	rdp->donetail = &rdp->donelist;
> > @@ -597,6 +627,7 @@ static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
> >  	rdp->qs_pending = 0;
> >  	rdp->cpu = cpu;
> >  	rdp->blimit = blimit;
> > +	spin_unlock(&rcp->lock);
> >  }
> >  
> >  static void __cpuinit rcu_online_cpu(int cpu)
> > 
