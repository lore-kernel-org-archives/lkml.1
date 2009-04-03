Return-Path: <linux-kernel-owner+w=401wt.eu-S1765843AbZDCO7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765843AbZDCO7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764652AbZDCO7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:59:43 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:52665 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704AbZDCO7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:59:41 -0400
Date: Fri, 3 Apr 2009 20:29:24 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Balbir Singh <balbir@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v2 1/2] sched: Nominate idle load balancer from a
	semi-idle package.
Message-ID: <20090403145924.GB9563@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090402123607.14569.33649.stgit@sofia.in.ibm.com> <20090402123829.14569.67639.stgit@sofia.in.ibm.com> <1238687531.3099.30.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238687531.3099.30.camel@ht.satnam>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaswinder,
Thanks for the review. Comments interspersed.


On Thu, Apr 02, 2009 at 09:22:11PM +0530, Jaswinder Singh Rajput wrote:
> Here are some minor issues:
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 706517c..4fc1ec0 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -4283,10 +4283,108 @@ static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
> >  static struct {
> >  	atomic_t load_balancer;
> >  	cpumask_var_t cpu_mask;
> > +	cpumask_var_t tmpmask;
> 
> Can you find some better name than tmpmask.

Sure, I'll think of it. The cpumask is required to store some
intermediate results when we compute the idle_loadbalancer. Any
suggestions ?

> 
> >  } nohz ____cacheline_aligned = {
> >  	.load_balancer = ATOMIC_INIT(-1),
> >  };
> >  
> > +#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
> > +/**
> 
> ^^^^^^
> This comment is not valid and even Randy send patches to fix these
> comments and also shared the error messages because of these comments by
> your earlier patches. Replace it with /*

I think you're referring to this: http://lkml.org/lkml/2009/3/29/7
I had missed this patch. Thanks for pointing it out.

I think Randy's patch was addressing the issue of structs
not requiring a /** style comments. But in this case,
it's a function, and hence needs kernel-doc style notation. Or am I
missing something here ? Point about the single-line
short function description is well taken.

> 
> > + * lowest_flag_domain: Returns the lowest sched_domain
> > + * that has the given flag set for a particular cpu.
> > + * @cpu: The cpu whose lowest level of sched domain is to
> > + * be returned.
> > + *
> > + * @flag: The flag to check for the lowest sched_domain
> > + * for the given cpu
> > + */
> > +static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
> > +{
> > +	struct sched_domain *sd;
> > +
> > +	for_each_domain(cpu, sd)
> > +		if (sd && (sd->flags & flag))
> > +			break;
> > +
> > +	return sd;
> > +}
> > +
> > +/**
> 
> Ditto.
> 

Ditto :-)

> > + * for_each_flag_domain: Iterates over all the scheduler domains
> > + * for a given cpu that has the 'flag' set, starting from
> > + * the lowest to the highest.
> > + * @cpu: The cpu whose domains we're iterating over.
> > + * @sd: variable holding the value of the power_savings_sd
> > + * for cpu
> 
> This can be come in one line:
Agreed. Will correct this.

> 
> + * @sd: variable holding the value of the power_savings_sd for cpu
> 
> > + */
> > +#define for_each_flag_domain(cpu, sd, flag) \
> > +	for (sd = lowest_flag_domain(cpu, flag); \
> > +		(sd && (sd->flags & flag)); sd = sd->parent)
> > +
> > +static inline int is_semi_idle_group(struct sched_group *ilb_group)
> > +{
> > +	cpumask_and(nohz.tmpmask, nohz.cpu_mask, sched_group_cpus(ilb_group));
> > +
> > +	/*
> > +	 * A sched_group is semi-idle when it has atleast one busy cpu
> > +	 * and atleast one idle cpu.
> > +	 */
> > +	if (!(cpumask_empty(nohz.tmpmask) ||
> > +		cpumask_equal(nohz.tmpmask, sched_group_cpus(ilb_group))))
> > +		return 1;
> > +
> > +	return 0;
> > +}
> > +/**
> 
> Ditto.
> 

Ditto!
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
> > +
> > +	/*
> > +	 * Optimization for the case when there is no idle cpu or
> > +	 * only 1 idle cpu to choose from.
> > +	 */
> > +	if (cpumask_weight(nohz.cpu_mask) < 2)
> > +		goto out_done;
> > +
> 
> We can simply avoid these gotos.

Not really! When we don't have any idle cpu or have only one idle cpu,
it doesn't make sense to walk the domain-hierarchy to find the idle load
balancer. In the former case, there is none. In the latter case, there's
only one.

But to verify what effect this optimization might have,
I ran kernbench on a large box (112 CPUS) and here
are the results.

-----------------------------------------------
make -j$i       patch              patch
                without gotos      with gotos
-----------------------------------------------
1               1230.87 s         1195.95 s
2                850.51 s          596.45 s
4                368.91 s          310.49 s
6                255.61 s          216.31 s
8                201.94 s          167.89 s
10               168.95 s          138.30 s
12               151.64 s          123.14 s
14               135.98 s          108.72 s
28                86.09 s           70.92 s
56                61.11 s           55.52 s
112               49.30 s           47.23 s
------------------------------------------------

Clearly, the patch with gotos gives us a better score than the one
without.

> 
> --
> JSR

-- 
Thanks and Regards
gautham
