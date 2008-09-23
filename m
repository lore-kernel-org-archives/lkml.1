Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbYIWOfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbYIWOfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYIWOex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 10:34:53 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:57152 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751216AbYIWOew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 10:34:52 -0400
Date: Tue, 23 Sep 2008 20:04:10 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] sched: Nominate the idle load balancer from a
	semi-idle group.
Message-ID: <20080923143410.GB26191@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080923101938.GE4598@in.ibm.com> <1222167277.16700.73.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222167277.16700.73.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 12:54:37PM +0200, Peter Zijlstra wrote:
> On Tue, 2008-09-23 at 15:49 +0530, Gautham R Shenoy wrote:
> > sched: Nominate the idle load balancer from a semi-idle group.
> > 
> > From: Gautham R Shenoy <ego@in.ibm.com>
> > 
> > Currently  the first cpu in the nohz cpu mask is nominated as
> > the idle load balancer.
> > 
> > However, this could be a cpu from an idle group,
> > thereby not yiedling the expected power savings.
> > 
> > Improve the logic to pick an idle cpu from a semi-idle group
> > for performing the task of idle load balancing, when
> > sched_mc/smt_powersavings is enabled.
> > 
> > This patch has no effect when sched_mc/smt_powersavings is turned off.
> > 
> > The patch is based on linux-2.6.27-rc5 and depends on the fix for
> > sched_mc_powersavings posted here--> http://lkml.org/lkml/2008/9/5/135
> 
> Is already in sched-devel...
> 
> > SPEC-Power Results: on a large multi-socket multi-core x86.
> > ----------------------------------------------------------------
> > Summary with the patch:
> >          9% improvement in the overall score
> >          8% decrease in the Power consumption at 100% utilization.
> 
> Seems to me that that's a contradiction, if it were utilized at 100%
> we'd never hit the idle path and all this code would just sit there not
> doing anything much.

Well, the SAR output shows that the idle time averaged across
all the CPUs at "SPECPower's 100% utilization" is around 4-5%. So this
could have provided the additional power savings.

> 
> > 	12% decrease in the Power consumption at idle.
> > 
> > ----------------------------------------------------------------
> > kernel_version |Final Score |ssj ops | 100% Watts | Idle Watts |
> > ---------------|------------|--------|-------------------------|
> > 2.6.27-rc5     |   x        |   y    |    z       |    w       |
> > ---------------|------------|--------|------------|------------|
> > 2.6.27-rc5 +   |  1.05x     | 0.98y  |  0.94z     |  0.92w     |
> > sched_mc_fix   |            |        |            |            |
> > ---------------|------------|--------|------------|------------|
> > 2.6.27-rc5 +   |  1.09x     | 0.97y  |  0.92z     |  0.88w     |
> > sched_mc_fix + |            |        |            |            |
> > this_patch     |            |        |            |            |
> > ----------------------------------------------------------------
> > 
> > Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> > ---
> > 
> >  kernel/sched.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++------
> >  1 files changed, 77 insertions(+), 9 deletions(-)
> > 
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index cc1f81b..c186719 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -3960,6 +3960,82 @@ static void run_rebalance_domains(struct softirq_action *h)
> >  #endif
> >  }
> >  
> > +#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
> > +/**
> > + * lowest_powersavings_sd: Returns the lowest level of power savings
> > + * domain of the given cpu.
> > + * @cpu: The cpu whose lowest level of power savings domain to
> > + * be returned.
> > + *
> > + * Power savings domain is the sched_domain where in we perform
> > + * load balancing for power savings. Such a domain would have
> > + * SD_POWERSAVINGS_BALANCE bit set in it's flags.
> > + */
> > +static inline struct sched_domain *lowest_powersavings_sd(int cpu)
> > +{
> > +	struct sched_domain *sd;
> > +
> > +	for_each_domain(cpu, sd)
> > +		if (sd && (sd->flags & SD_POWERSAVINGS_BALANCE))
> > +			break;
> > +
> > +	return sd;
> > +}
> > +
> > +/**
> > + * for_each_powersavings_domain: Iterates over all the power savings
> > + * scheduler domains (see comment for lowest_powersavings_sd) from
> > + * the lowest to the highest.
> > + * @cpu: The cpu whose powersavings_sd we're iterating over.
> > + * @sd: variable holding the value of the power_savings_sd
> > + * for cpu
> > + */
> > +#define for_each_powersaving_domain(cpu, sd) \
> > +	for (sd = lowest_powersavings_sd(cpu); \
> > +		(sd && (sd->flags & SD_POWERSAVINGS_BALANCE)); sd = sd->parent)
> 
> How about for_each_domain_flag(cpu, sd, flag) ?
Yes, does make sense. Will change it.

> 
> (missing empty line)
> 
> > +/**
> > + * find_new_ilb: Finds or nominates a new idle load balancer.
> > + * @cpu: The cpu which is nominating a new idle_load_balancer.
> > + *
> > + * This algorithm picks the idle load balancer such that it belongs to a
> > + * semi-idle powersavings sched_domain. The idea is to try and avoid
> > + * completely idle packages/cores just for the purpose of idle load balancing
> > + * when there are other idle cpu's which are better suited for that job.
> > + */
> > +static int find_new_ilb(int cpu)
> > +{
> > +	struct sched_domain *sd;
> > +	struct sched_group *ilb_group;
> > +	cpumask_t cpumask;
> 
> Mike Travis will hate you ;-)
 Don't we have enough stack space here ?! After all it's just one
 cpumask_t.
 
> 
> > +	for_each_powersaving_domain(cpu, sd) {
> > +		ilb_group = sd->groups;
> > +
> > +		do {
> > +			cpus_and(cpumask, nohz.cpu_mask, ilb_group->cpumask);
> > +
> > +			/*
> > +			 * If there exists atleast one busy cpu within
> > +			 * this group, we should wake up the idle cpu from
> > +			 * here.
> > +			 */
> > +			if (!(cpus_empty(cpumask) ||
> > +				cpus_equal(cpumask, ilb_group->cpumask)))
> > +				return first_cpu(cpumask);
> > +
> > +			ilb_group = ilb_group->next;
> > +
> > +		} while (ilb_group != sd->groups);
> > +	}
> > +	return first_cpu(nohz.cpu_mask);
> > +}
> > +#else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
> > +static inline int find_new_ilb(int call_cpu)
> > +{
> > +	return first_cpu(nohz.cpu_mask);
> > +}
> > +#endif
> > +
> >  /*
> >   * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
> >   *
> > @@ -3984,15 +4060,7 @@ static inline void trigger_load_balance(struct rq *rq, int cpu)
> >  		}
> >  
> >  		if (atomic_read(&nohz.load_balancer) == -1) {
> > -			/*
> > -			 * simple selection for now: Nominate the
> > -			 * first cpu in the nohz list to be the next
> > -			 * ilb owner.
> > -			 *
> > -			 * TBD: Traverse the sched domains and nominate
> > -			 * the nearest cpu in the nohz.cpu_mask.
> > -			 */
> > -			int ilb = first_cpu(nohz.cpu_mask);
> > +			int ilb = find_new_ilb(cpu);
> >  
> >  			if (ilb < nr_cpu_ids)
> >  				resched_cpu(ilb);
> 
> I guess so..

Thanks for reviewing the patch.
-- 
Thanks and Regards
gautham
