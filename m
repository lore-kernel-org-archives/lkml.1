Return-Path: <linux-kernel-owner+w=401wt.eu-S1762339AbYHDWy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762339AbYHDWy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYHDWyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:54:46 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58406 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbYHDWyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:54:45 -0400
Date: Mon, 4 Aug 2008 15:54:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Gautham Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] rcu classic: new algorithm for
	callbacks-processing(v2)
Message-ID: <20080804225438.GA18866@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48708F2F.2060406@cn.fujitsu.com> <20080718140930.GT6875@elte.hu> <20080721100433.GC8384@linux.vnet.ibm.com> <20080801211053.GZ14851@linux.vnet.ibm.com> <489565BC.3000408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489565BC.3000408@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 04:01:00PM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> 
> [...]
> 
> >>  /**
> >>   * call_rcu - Queue an RCU callback for invocation after a grace period.
> >>   * @head: structure to be used for queueing the RCU updates.
> >> @@ -133,18 +172,11 @@ void call_rcu(struct rcu_head *head,
> >>  				void (*func)(struct rcu_head *rcu))
> >>  {
> >>  	unsigned long flags;
> >> -	struct rcu_data *rdp;
> >>  
> >>  	head->func = func;
> >>  	head->next = NULL;
> >>  	local_irq_save(flags);
> > 
> > I very much like the gathering of common code from call_rcu() and
> > call_rcu_bh() into __call_rcu().  But why not also move the
> > local_irq_save() and local_irq_restore() to __call_rcu(), perhaps
> > along with the initialization of head->next?
> 
> We should put __get_cpu_var into preempt_disable critical section.
> So I didn't move the local_irq_save() and local_irq_restore()
> to __call_rcu().

Good point -- a preemption just at the call to __call_rcu() does need
to be handled correctly.  I will update the patch.

> I greed your changes except the changes here.
> percpu_ptr() may help for us.

Tell me more about percpu_ptr().

> > (I understand the motivation for keeping the initialization of the
> > fields of "head" at this level -- otherwise, you must add another
> > argument to __call_rcu().  But might be worth considering...)
> > 
> >> -	rdp = &__get_cpu_var(rcu_data);
> >> -	*rdp->nxttail = head;
> >> -	rdp->nxttail = &head->next;
> >> -	if (unlikely(++rdp->qlen > qhimark)) {
> >> -		rdp->blimit = INT_MAX;
> >> -		force_quiescent_state(rdp, &rcu_ctrlblk);
> >> -	}
> >> +	__call_rcu(head, &rcu_ctrlblk, &__get_cpu_var(rcu_data));
> >>  	local_irq_restore(flags);
> >>  }
> >>  EXPORT_SYMBOL_GPL(call_rcu);
> >> @@ -169,20 +201,11 @@ void call_rcu_bh(struct rcu_head *head,
> >>  				void (*func)(struct rcu_head *rcu))
> >>  {
> >>  	unsigned long flags;
> >> -	struct rcu_data *rdp;
> >>  
> >>  	head->func = func;
> >>  	head->next = NULL;
> >>  	local_irq_save(flags);
> >> -	rdp = &__get_cpu_var(rcu_bh_data);
> >> -	*rdp->nxttail = head;
> >> -	rdp->nxttail = &head->next;
> >> -
> >> -	if (unlikely(++rdp->qlen > qhimark)) {
> >> -		rdp->blimit = INT_MAX;
> >> -		force_quiescent_state(rdp, &rcu_bh_ctrlblk);
> >> -	}
> >> -
> >> +	__call_rcu(head, &rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
> >>  	local_irq_restore(flags);
> >>  }
> >>  EXPORT_SYMBOL_GPL(call_rcu_bh);
> >> @@ -211,12 +234,6 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed_
> >>  static inline void raise_rcu_softirq(void)
> >>  {
> >>  	raise_softirq(RCU_SOFTIRQ);
> >> -	/*
> >> -	 * The smp_mb() here is required to ensure that this cpu's
> >> -	 * __rcu_process_callbacks() reads the most recently updated
> >> -	 * value of rcu->cur.
> >> -	 */
> >> -	smp_mb();
> > 
> > I have not yet convinced myself that it is OK to get rid of this memory
> > barrier.  This memory barrier was intended order to handle the following
> > sequence of events:
> > 
> > 	rcu_read_lock_bh();  /* no memory barrier. */
> > 	p = rcu_dereference(some_global_pointer);
> > 	do_something_with(p);
> > 	rcu_read_unlock_bh();  /* no memory barrier. */
> > 
> > 	---- scheduling-clock interrupt occurs, eventually invoking
> > 	---- rcu_check_callbacks()
> > 
> > 	---- And the access to "p" above could potentially be reordered
> > 	---- into the grace-period computation
> > 
> > Such reordering is of course quite unlikely to be harmful, due to the
> > long duration of RCU grace periods.  But I am paranoid.
> > 
> > If this memory barrier turns out to be necessary, one approach would
> > to be to place it at the beginning of rcu_check_callbacks(), which is
> > a better place for it in any case.
> > 
> > Thoughts?
> 
> I hasn't thought it before. I thought that smp_mb is used for
> rcu->cur as the original comment had told.
> 
> I prefer to add memory barrier to rcu_process_callbacks as your patch.

Yeah, that became clear as I wrote the code.  ;-)

> But I has a question here:
> 
> In this case, p->rcu_head is not in donelist. So __rcu_process_callbacks
> is only access to p->rcu_head(p->rcu_head.next). And other cpus don't
> access to p->rcu_head which has been queued on this cpu' rcu_data.
> 
> Is this reordering harmful(How this reordering make other
> cpus' access wrong)?

I have a somewhat different goal here.  I want to simplify the memory
ordering design without giving up too much performance -- the current
state in mainline is much too fragile, in my opinion, especially given
that the grace-period code paths are not fastpaths.

Next step -- hierarchical grace-period detection to handle the 4096-CPU
machines that I was being buttonholed about at OLS...

Would you be interested in applying your multi-tailed list change to
preemptable RCU?

						Thanx, Paul

> [...]
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
