Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab0BWQZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 11:25:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52698 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab0BWQZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 11:25:22 -0500
Subject: Re: [PATCHv4 2/2] powerpc: implement arch_scale_smt_power for
 Power7
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Joel Schopp <jschopp@austin.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       ego@in.ibm.com
In-Reply-To: <23662.1266905307@neuling.org>
References: <1264017638.5717.121.camel@jschopp-laptop>
	 <1264017847.5717.132.camel@jschopp-laptop>
	 <1264548495.12239.56.camel@jschopp-laptop>
	 <1264720855.9660.22.camel@jschopp-laptop>
	 <1264721088.10385.1.camel@jschopp-laptop>
	 <1265403478.6089.41.camel@jschopp-laptop>
	 <1266142340.5273.418.camel@laptop> <25851.1266445258@neuling.org>
	 <1266499023.26719.597.camel@laptop> <14639.1266559532@neuling.org>
	 <1266573672.1806.70.camel@laptop> <24165.1266577276@neuling.org>
	 <23662.1266905307@neuling.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Feb 2010 17:24:41 +0100
Message-ID: <1266942281.11845.521.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 17:08 +1100, Michael Neuling wrote:

> I have some comments on the code inline but... 
> 
> So when I run this, I don't get processes pulled down to the lower
> threads.  A simple test case of running 1 CPU intensive process at
> SCHED_OTHER on a machine with 2 way SMT system (a POWER6 but enabling
> SD_ASYM_PACKING).  The single processes doesn't move to lower threads as
> I'd hope.
> 
> Also, are you sure you want to put this in generic code?  It seem to be
> quite POWER7 specific functionality, so would be logically better in
> arch/powerpc.  I guess some other arch *might* need it, but seems
> unlikely.  

Well, there are no arch hooks in the load-balancing (aside from the
recent cpu_power stuff, and that really is the wrong thing to poke at
for this), and I did hear some other people express interest in such a
constraint.

Also, load-balancing is complex enough as it is, so I prefer to keep
everything in the generic code where possible, clearly things like
sched_domain creation need arch topology bits, and the arch_scale*
things require other arch information like cpu frequency.


> > @@ -2493,6 +2494,28 @@ static inline void update_sg_lb_stats(st
> >  		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
> >  }
> >  
> > +static int update_sd_pick_busiest(struct sched_domain *sd,
> > +	       			  struct sd_lb_stats *sds,
> > +				  struct sched_group *sg,
> > +			  	  struct sg_lb_stats *sgs)
> > +{
> > +	if (sgs->sum_nr_running > sgs->group_capacity)
> > +		return 1;
> > +
> > +	if (sgs->group_imb)
> > +		return 1;
> > +
> > +	if ((sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running) {
> 
> If we are asymetric packing...
> 
> 
> > +		if (!sds->busiest)
> > +			return 1;
> 
> This just seems to be a null pointer check.
> 
> From the tracing I've done, this is always true (always NULL) at this
> point so we return here.

Right, so we need to have a busiest group to take a task from, if there
is no busiest yet, take this group.

And in your scenario, with there being only a single task, we'd only hit
this once at most, so yes it makes sense this is always NULL.

> > +
> > +		if (group_first_cpu(sds->busiest) < group_first_cpu(sg))
> > +			return 1;
> 
> I'm a bit lost as to what this is for.  Any clues you could provide
> would be appreciated. :-)
> 
> Is the first cpu in this domain's busiest group before the first cpu in
> this group.  If, so pick this as the busiest?
> 
> Should this be the other way around if we want to pack the busiest to
> the first cpu?  Mark it as the busiest if it's after (not before).  
> 
> Is group_first_cpu guaranteed to give us the first physical cpu (ie.
> thread 0 in our case) or are these virtualised at this point?
> 
> I'm not seeing this hit anyway due to the null pointer check above.

So this says, if all things being equal, and we already have a busiest,
but this candidate (sg) is higher than the current (busiest) take this
one.

The idea is to move the highest SMT task down.

> > @@ -2562,6 +2585,38 @@ static inline void update_sd_lb_stats(st
> >  	} while (group != sd->groups);
> >  }
> >  
> > +int __weak sd_asym_packing_arch(void)
> > +{
> > +	return 0;
> > +}

arch_sd_asym_packing() is what you used in topology.h

> > +static int check_asym_packing(struct sched_domain *sd,
> > +				    struct sd_lb_stats *sds,
> > +				    unsigned long *imbalance)
> > +{
> > +	int i, cpu, busiest_cpu;
> > +
> > +	if (!(sd->flags & SD_ASYM_PACKING))
> > +		return 0;
> > +
> > +	if (!sds->busiest)
> > +		return 0;
> > +
> > +	i = 0;
> > +	busiest_cpu = group_first_cpu(sds->busiest);
> > +	for_each_cpu(cpu, sched_domain_span(sd)) {
> > +		i++;
> > +		if (cpu == busiest_cpu)
> > +			break;
> > +	}
> > +
> > +	if (sds->total_nr_running > i)
> > +		return 0;
> 
> This seems to be the core of the packing logic.
> 
> We make sure the busiest_cpu is not past total_nr_running.  If it is we
> mark as imbalanced.  Correct?
> 
> It seems if a non zero thread/group had a pile of processes running on
> it and a lower thread had much less, this wouldn't fire, but I'm
> guessing normal load balancing would kick in that case to fix the
> imbalance.
> 
> Any corrections to my ramblings appreciated :-)

Right, so we're concerned the scenario where there's less tasks than SMT
siblings, if there's more they should all be running and the regular
load-balancer will deal with it.

If there's less the group will normally be balanced and we fall out and
end up in check_asym_packing().

So what I tried doing with that loop is detect if there's a hole in the
packing before busiest. Now that I think about it, what we need to check
is if this_cpu (the removed cpu argument) is idle and less than busiest.

So something like:

static int check_asym_pacing(struct sched_domain *sd,
                             struct sd_lb_stats *sds,
                             int this_cpu, unsigned long *imbalance)
{
	int busiest_cpu;

	if (!(sd->flags & SD_ASYM_PACKING))
		return 0;

	if (!sds->busiest)
		return 0;

	busiest_cpu = group_first_cpu(sds->busiest);
	if (cpu_rq(this_cpu)->nr_running || this_cpu > busiest_cpu)
		return 0;

	*imbalance = (sds->max_load * sds->busiest->cpu_power) /
			SCHED_LOAD_SCALE;
	return 1;
}

Does that make sense?

I still see two problems with this though,.. regular load-balancing only
balances on the first cpu of a domain (see the *balance = 0, condition
in update_sg_lb_stats()), this means that if SMT[12] are idle we'll not
pull properly. Also, nohz balancing might mess this up further.

We could maybe play some games with the balance decision in
update_sg_lb_stats() for SD_ASYM_PACKING domains and idle == CPU_IDLE,
no ideas yet on nohz though.



