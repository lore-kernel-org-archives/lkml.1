Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbYGOUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbYGOUQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757631AbYGOUPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:15:48 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:13574 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756092AbYGOUPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:15:46 -0400
Subject: Re: [PATCH 02/30] sched: revert the revert of: weight calculations
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: balbir@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <20080630180702.GC23606@balbir.in.ibm.com>
References: <20080627114109.724249622@chello.nl>
	 <20080627115211.057968925@chello.nl>
	 <20080630180702.GC23606@balbir.in.ibm.com>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 22:16:05 +0200
Message-Id: <1216152965.12595.251.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-30 at 23:37 +0530, Balbir Singh wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2008-06-27 13:41:11]:

> >  /*
> > + * delta *= w / rw
> > + */
> > +static inline unsigned long
> > +calc_delta_weight(unsigned long delta, struct sched_entity *se)
> > +{
> > +	for_each_sched_entity(se) {
> > +		delta = calc_delta_mine(delta,
> > +				se->load.weight, &cfs_rq_of(se)->load);
> > +	}
> > +
> > +	return delta;
> > +}
> > +
> > +/*
> > + * delta *= rw / w
> > + */
> > +static inline unsigned long
> > +calc_delta_fair(unsigned long delta, struct sched_entity *se)
> > +{
> > +	for_each_sched_entity(se) {
> > +		delta = calc_delta_mine(delta,
> > +				cfs_rq_of(se)->load.weight, &se->load);
> > +	}
> > +
> > +	return delta;
> > +}
> > +
> 
> These functions can do with better comments

you mean like: 

/*
 * delta *= \Prod_{i} rw_{i} / w_{i} ?
 */

?

> delta is scaled up as we move up the hierarchy
> 
> Why is calc_delta_weight() different from calc_delta_fair()?

Because they do the opposite operation.

I agree though that perhaps the names could have been chosen better.
I've wondered about that at several occasions but so far failed to come
up with anything sane.

> > +/*
> >   * The idea is to set a period in which each task runs once.
> >   *
> >   * When there are too many tasks (sysctl_sched_nr_latency) we have to stretch
> > @@ -362,47 +390,54 @@ static u64 __sched_period(unsigned long 
> >   */
> >  static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
> >  {
> > -	u64 slice = __sched_period(cfs_rq->nr_running);
> > -
> > -	for_each_sched_entity(se) {
> > -		cfs_rq = cfs_rq_of(se);
> > -
> > -		slice *= se->load.weight;
> > -		do_div(slice, cfs_rq->load.weight);
> > -	}
> > -
> > -
> > -	return slice;
> > +	return calc_delta_weight(__sched_period(cfs_rq->nr_running), se);
> >  }
> > 
> >  /*
> >   * We calculate the vruntime slice of a to be inserted task
> >   *
> > - * vs = s/w = p/rw
> > + * vs = s*rw/w = p
> >   */
> >  static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
> >  {
> >  	unsigned long nr_running = cfs_rq->nr_running;
> > -	unsigned long weight;
> > -	u64 vslice;
> > 
> >  	if (!se->on_rq)
> >  		nr_running++;
> > 
> > -	vslice = __sched_period(nr_running);
> > +	return __sched_period(nr_running);
> 
> Do we always return a constant value based on nr_running? Am I
> misreading the diff by any chance?

static u64 __sched_period(unsigned long nr_running)
{
        u64 period = sysctl_sched_latency;
        unsigned long nr_latency = sched_nr_latency;

        if (unlikely(nr_running > nr_latency)) {
                period = sysctl_sched_min_granularity;
                period *= nr_running;
        }

        return period;
}

its not exactly constant..

> > +}
> > +
> > +/*
> > + * The goal of calc_delta_asym() is to be asymmetrically around NICE_0_LOAD, in
> > + * that it favours >=0 over <0.
> > + *
> > + *   -20         |
> > + *               |
> > + *     0 --------+-------
> > + *             .'
> > + *    19     .'
> > + *
> > + */
> > +static unsigned long
> > +calc_delta_asym(unsigned long delta, struct sched_entity *se)
> > +{
> > +	struct load_weight lw = {
> > +		.weight = NICE_0_LOAD,
> > +		.inv_weight = 1UL << (WMULT_SHIFT-NICE_0_SHIFT)
> > +	};
> 
> Could you please explain this
> 
> weight is 1 << 10
> and inv_weight is 1 << 22

we have the relation that:

 x/weight ~= (x*inv_weight) >> 32

or

 inv_weight = (1<<32) / weight

See kernel/sched.c:calc_delta_mine()

when weight is 1<<10, that reduces to 1<<(32-10) = 1<<22

> > 
> >  	for_each_sched_entity(se) {
> > -		cfs_rq = cfs_rq_of(se);
> > +		struct load_weight *se_lw = &se->load;
> > 
> > -		weight = cfs_rq->load.weight;
> > -		if (!se->on_rq)
> > -			weight += se->load.weight;
> > +		if (se->load.weight < NICE_0_LOAD)
> > +			se_lw = &lw;
> 
> Why do we do this?

You're basically asking what the _asym part is about, right?

So, what this patch does is change the virtual time calculation from:

 1 / w, to rw / w

[ actuallly to: \Prod_{i} rw_{i}/w_{i} ]

Now wakeup_gran() has this asymetry:

> > 	/*
> > -	 * More easily preempt - nice tasks, while not making
> > -	 * it harder for + nice tasks.
> >  	 */
> > -	if (unlikely(se->load.weight > NICE_0_LOAD))
> > -		gran = calc_delta_fair(gran, &se->load);

calc_delta_asym() tries to generalize that to the new scheme. As you can
see from the next two patches the code in this patch isn't perfect. This
patch just restores the status quo to before the revert, the next
patches continue.


