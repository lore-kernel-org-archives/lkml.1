Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab0BMSeK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 13:34:10 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:39578 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab0BMSeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 13:34:05 -0500
Date: Sun, 14 Feb 2010 00:03:56 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>
Subject: Re: change in sched cpu_power causing regressions with SCHED_MC
Message-ID: <20100213183356.GC5882@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
 <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha <suresh.b.siddha@intel.com> [2010-02-12 17:31:19]:

> Peterz,
> 
> We have one more problem that Yanmin and Ling Ma reported. On a dual
> socket quad-core platforms (for example platforms based on NHM-EP), we
> are seeing scenarios where one socket is completely busy (with all the 4
> cores running with 4 tasks) and another socket is completely idle.
> 
> This causes performance issues as those 4 tasks share the memory
> controller, last-level cache bandwidth etc. Also we won't be taking
> advantage of turbo-mode as much as we like. We will have all these
> benefits if we move two of those tasks to the other socket. Now both the
> sockets can potentially go to turbo etc and improve performance.
> 
> In short, your recent change (shown below) broke this behavior. In the
> kernel summit you mentioned you made this change with out affecting the
> behavior of SMT/MC. And my testing immediately after kernel-summit also
> didn't show the problem (perhaps my test didn't hit this specific
> change). But apparently we are having performance issues with this patch
> (Ling Ma's bisect pointed to this patch). I will look more detailed into
> this after the long weekend (to see if we can catch this scenario in
> fix_small_imbalance() etc). But wanted to give you a quick heads up.
> Thanks.
> 
> commit f93e65c186ab3c05ce2068733ca10e34fd00125e
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Tue Sep 1 10:34:32 2009 +0200
> 
>     sched: Restore __cpu_power to a straight sum of power
>     
>     cpu_power is supposed to be a representation of the process
>     capacity of the cpu, not a value to randomly tweak in order to
>     affect placement.
>     
>     Remove the placement hacks.
>     
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
>     Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
>     Acked-by: Gautham R Shenoy <ego@in.ibm.com>
>     Cc: Balbir Singh <balbir@in.ibm.com>
>     LKML-Reference: <20090901083825.810860576@chello.nl>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index da1edc8..584a122 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8464,15 +8464,13 @@ static void free_sched_groups(const struct cpumask *cpu_map,
>   * there are asymmetries in the topology. If there are asymmetries, group
>   * having more cpu_power will pickup more load compared to the group having
>   * less cpu_power.
> - *
> - * cpu_power will be a multiple of SCHED_LOAD_SCALE. This multiple represents
> - * the maximum number of tasks a group can handle in the presence of other idle
> - * or lightly loaded groups in the same sched domain.
>   */
>  static void init_sched_groups_power(int cpu, struct sched_domain *sd)
>  {
>  	struct sched_domain *child;
>  	struct sched_group *group;
> +	long power;
> +	int weight;
> 
>  	WARN_ON(!sd || !sd->groups);
> 
> @@ -8483,22 +8481,20 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
> 
>  	sd->groups->__cpu_power = 0;
> 
> -	/*
> -	 * For perf policy, if the groups in child domain share resources
> -	 * (for example cores sharing some portions of the cache hierarchy
> -	 * or SMT), then set this domain groups cpu_power such that each group
> -	 * can handle only one task, when there are other idle groups in the
> -	 * same sched domain.
> -	 */
> -	if (!child || (!(sd->flags & SD_POWERSAVINGS_BALANCE) &&
> -		       (child->flags &
> -			(SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)))) {
> -		sg_inc_cpu_power(sd->groups, SCHED_LOAD_SCALE);
> +	if (!child) {
> +		power = SCHED_LOAD_SCALE;
> +		weight = cpumask_weight(sched_domain_span(sd));
> +		/*
> +		 * SMT siblings share the power of a single core.
> +		 */
> +		if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1)
> +			power /= weight;
> +		sg_inc_cpu_power(sd->groups, power);
>  		return;
>  	}
> 
>  	/*
> -	 * add cpu_power of each child group to this groups cpu_power
> +	 * Add cpu_power of each child group to this groups cpu_power.
>  	 */
>  	group = child->groups;
>  	do {
> 

I have hit the same problem in older non-HT quad cores also.
(http://lkml.org/lkml/2010/2/8/80)

The following condition in find_busiest_group()
	sds.max_load <= sds.busiest_load_per_task

	treats unequally loaded groups as balanced as longs they are below
	capacity.
        
        We need to change the above condition before we hit the
        fix_small_imbalance() step.
        
--Vaidy
         
