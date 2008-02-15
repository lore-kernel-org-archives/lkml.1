Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbYBOTtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbYBOTtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbYBOTtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:49:00 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33224 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbYBOTs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:48:59 -0500
Subject: Re: [RFC][PATCH 2/2] sched: fair-group: per root-domain load
	balancing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Paul Jackson <pj@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47B5C1E1.5090706@gmail.com>
References: <20080214155724.772744000@chello.nl>
	 <20080214160234.681387000@chello.nl>  <47B5C1E1.5090706@gmail.com>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 20:46:39 +0100
Message-Id: <1203104799.6301.16.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-15 at 11:46 -0500, Gregory Haskins wrote:
> Peter Zijlstra wrote:
>  
> > @@ -6342,8 +6351,14 @@ static void rq_attach_root(struct rq *rq
> >  		cpu_clear(rq->cpu, old_rd->span);
> >  		cpu_clear(rq->cpu, old_rd->online);
> >  
> > -		if (atomic_dec_and_test(&old_rd->refcount))
> > +		if (atomic_dec_and_test(&old_rd->refcount)) {
> > +			/*
> > +			 * sync with active timers.
> > +			 */
> > +			active = lb_monitor_destroy(&old_rd->lb_monitor);
> > +
> >  			kfree(old_rd);
> 
> Note that this works out to be a bug in my code on -rt since you cannot 
> kfree() while the raw rq->lock is held.  This isn't your problem, per 
> se, but just a heads up that I might need to patch this area ASAP.

Yeah, I saw that patch, should be simple enough to fix.

> > +static int load_balance_shares(struct lb_monitor *lb_monitor)
> > +{
> > +	int cpu = smp_processor_id();
> > +	struct rq *rq = cpu_rq(cpu);
> > +	struct root_domain *rd;
> > +	struct sched_domain *sd, *sd_prev = NULL;
> > +	int state = shares_idle;
> > +
> > +	spin_lock(&rq->lock);
> > +	/*
> > +	 * root_domain will stay valid until timer exits - synchronized by
> > +	 * hrtimer_cancel().
> > +	 */
> > +	rd = rq->rd;
> > +	spin_unlock(&rq->lock);
> 
> I know we talked about this on IRC, I'm am still skeptical about this 
> part of the code.  Normally we only guarantee the stability of the 
> rq->rd pointer while the rq->lock is held or a rd->refcount is added. 

> It would be "safer" to bracket this code with an up/down sequence on the 
> rd->refcount, 

I initially did break out the up/down reference stuff. It has a few
other complications but all quite tractable.

> but perhaps you can convince me that it is not needed? 
> (i.e. I am still not understanding how the timer guarantees the stability).

ok, let me try again.

So we take rq->lock, at this point we know rd is valid.
We also know the timer is active.

So when we release it, the last reference can be dropped and we end up
in the hrtimer_cancel(), right before the kfree().

hrtimer_cancel() will wait for the timer to end. therefore delaying the
kfree() until the running timer finished.

> [up-ref]
> 
> > +
> > +	/*
> > +	 * complicated way to find rd->load_balance
> > +	 */
> > +	rcu_read_lock();
> > +	for_each_domain(cpu, sd) {
> > +		if (!(sd->flags & SD_LOAD_BALANCE))
> > +			continue;
> > +		sd_prev = sd;
> > +	}
> > +	if (sd_prev)
> > +		state = max(state, rebalance_shares(rd, cpu));
> > +	rcu_read_unlock();
> > +
> 
> [down-ref]
> 
> We would of course need to re-work the drop-ref code so it could be 
> freed independent of the rq_attach_root() function, but that should be 
> trivial.
> 
> > +	set_lb_monitor_timeout(lb_monitor, state);
> >  
> >  	return state;
> >  }



