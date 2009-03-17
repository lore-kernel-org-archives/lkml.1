Return-Path: <linux-kernel-owner+w=401wt.eu-S1763478AbZCQLqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763478AbZCQLqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 07:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbZCQLqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 07:46:11 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:54540 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbZCQLqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 07:46:10 -0400
Date: Tue, 17 Mar 2009 17:15:58 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
Subject: Re: [v3 PATCH 4/4] timers: logic to move non pinned timers
Message-ID: <20090317114557.GA32233@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090316111045.GA4686@linux.vnet.ibm.com> <20090316111548.GE4686@linux.vnet.ibm.com> <alpine.LFD.2.00.0903171017590.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903171017590.29264@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner <tglx@linutronix.de> [2009-03-17 11:22:24]:

> On Mon, 16 Mar 2009, Arun R Bharadwaj wrote:
> > @@ -627,6 +628,16 @@ __mod_timer(struct timer_list *timer, un
> >  
> >  	new_base = __get_cpu_var(tvec_bases);
> >  
> > +	current_cpu = smp_processor_id();
> > +	preferred_cpu = get_nohz_load_balancer();
> > +	if (get_sysctl_timer_migration() && idle_cpu(current_cpu) &&
> > +			!pinned && preferred_cpu != -1) {
> > +		new_base = per_cpu(tvec_bases, preferred_cpu);
> > +		timer_set_base(timer, new_base);
> > +		timer->expires = expires;
> > +		internal_add_timer(new_base, timer);
> > +		goto out_unlock;
> > +	}
> 
>   Err. This change breaks the timer->base logic. Why can't it just
>   select the base and use the existing code ?
>

Sure, I'll take care of this.

> > @@ -198,8 +200,16 @@ switch_hrtimer_base(struct hrtimer *time
> >  {
> >  	struct hrtimer_clock_base *new_base;
> >  	struct hrtimer_cpu_base *new_cpu_base;
> > +	int current_cpu, preferred_cpu;
> > +
> > +	current_cpu = smp_processor_id();
> > +	preferred_cpu = get_nohz_load_balancer();
> > +	if (get_sysctl_timer_migration() && !pinned && preferred_cpu != -1
> > +			&& idle_cpu(current_cpu))
> > +		new_cpu_base = &per_cpu(hrtimer_bases, preferred_cpu);
> > +	else
> > +		new_cpu_base = &__get_cpu_var(hrtimer_bases);
> >  
> > -	new_cpu_base = &__get_cpu_var(hrtimer_bases);
> >  	new_base = &new_cpu_base->clock_base[base->index];
> 
>   Hmm. This can lead to high latencies when you enqueue the timer on
>   the other CPU simply because we can not reprogram the timer hardware
>   on the other CPU in the CONFIG_HIGH_RES=y case.
> 
>   Let's assume we are on CPU0 and try to enqueue the timer on CPU1,
>   where the next timer expiry is 5ms away. The timer which we enqueue
>   is due in 500us. So you introduce 4.5ms latency.
>

We are moving timers to the ilb which wakes up every jiffy.
So we can move the timer to the ilb only if it's expiry
time is greater than 1 jiffy. Else we can fire on the same CPU.
This would prevent any latency from being added, right?

--arun

> Thanks,
> 
> 	tglx
> 
> 
