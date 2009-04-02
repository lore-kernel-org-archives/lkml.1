Return-Path: <linux-kernel-owner+w=401wt.eu-S1763444AbZDBPw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763444AbZDBPw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760281AbZDBPwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:52:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:41345 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760222AbZDBPwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:52:49 -0400
Subject: Re: [PATCH v2 1/2] sched: Nominate idle load balancer from a
 semi-idle package.
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Balbir Singh <balbir@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20090402123829.14569.67639.stgit@sofia.in.ibm.com>
References: <20090402123607.14569.33649.stgit@sofia.in.ibm.com>
	 <20090402123829.14569.67639.stgit@sofia.in.ibm.com>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 21:22:11 +0530
Message-Id: <1238687531.3099.30.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some minor issues:

On Thu, 2009-04-02 at 18:08 +0530, Gautham R Shenoy wrote:
> Currently the nomination of idle-load balancer is done by choosing the first
> idle cpu in the nohz.cpu_mask. This may not be power-efficient, since
> such an idle cpu could come from a completely idle core/package thereby
> preventing the whole core/package from being in a low-power state.
> 
> For eg, consider a quad-core dual package system. The cpu numbering need
> not be sequential and can something like [0, 2, 4, 6] and [1, 3, 5, 7].
> With sched_mc/smt_power_savings and the power-aware IRQ balance, we try to keep
> as fewer Packages/Cores active. But the current idle load balancer logic
> goes against this by choosing the first_cpu in the nohz.cpu_mask and not
> taking the system topology into consideration.
> 
> Improve the algorithm to nominate the idle load balancer from a semi idle
> cores/packages thereby increasing the probability of the cores/packages being
> in deeper sleep states for longer duration.
> 
> The algorithm is activated only when sched_mc/smt_power_savings != 0.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> ---
> 
>  kernel/sched.c |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 100 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 706517c..4fc1ec0 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4283,10 +4283,108 @@ static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
>  static struct {
>  	atomic_t load_balancer;
>  	cpumask_var_t cpu_mask;
> +	cpumask_var_t tmpmask;

Can you find some better name than tmpmask.

>  } nohz ____cacheline_aligned = {
>  	.load_balancer = ATOMIC_INIT(-1),
>  };
>  
> +#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
> +/**

^^^^^^
This comment is not valid and even Randy send patches to fix these
comments and also shared the error messages because of these comments by
your earlier patches. Replace it with /*

> + * lowest_flag_domain: Returns the lowest sched_domain
> + * that has the given flag set for a particular cpu.
> + * @cpu: The cpu whose lowest level of sched domain is to
> + * be returned.
> + *
> + * @flag: The flag to check for the lowest sched_domain
> + * for the given cpu
> + */
> +static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
> +{
> +	struct sched_domain *sd;
> +
> +	for_each_domain(cpu, sd)
> +		if (sd && (sd->flags & flag))
> +			break;
> +
> +	return sd;
> +}
> +
> +/**

Ditto.

> + * for_each_flag_domain: Iterates over all the scheduler domains
> + * for a given cpu that has the 'flag' set, starting from
> + * the lowest to the highest.
> + * @cpu: The cpu whose domains we're iterating over.
> + * @sd: variable holding the value of the power_savings_sd
> + * for cpu

This can be come in one line:

+ * @sd: variable holding the value of the power_savings_sd for cpu

> + */
> +#define for_each_flag_domain(cpu, sd, flag) \
> +	for (sd = lowest_flag_domain(cpu, flag); \
> +		(sd && (sd->flags & flag)); sd = sd->parent)
> +
> +static inline int is_semi_idle_group(struct sched_group *ilb_group)
> +{
> +	cpumask_and(nohz.tmpmask, nohz.cpu_mask, sched_group_cpus(ilb_group));
> +
> +	/*
> +	 * A sched_group is semi-idle when it has atleast one busy cpu
> +	 * and atleast one idle cpu.
> +	 */
> +	if (!(cpumask_empty(nohz.tmpmask) ||
> +		cpumask_equal(nohz.tmpmask, sched_group_cpus(ilb_group))))
> +		return 1;
> +
> +	return 0;
> +}
> +/**

Ditto.

> + * find_new_ilb: Finds or nominates a new idle load balancer.
> + * @cpu: The cpu which is nominating a new idle_load_balancer.
> + *
> + * This algorithm picks the idle load balancer such that it belongs to a
> + * semi-idle powersavings sched_domain. The idea is to try and avoid
> + * completely idle packages/cores just for the purpose of idle load balancing
> + * when there are other idle cpu's which are better suited for that job.
> + */
> +static int find_new_ilb(int cpu)
> +{
> +	struct sched_domain *sd;
> +	struct sched_group *ilb_group;
> +
> +	/*
> +	 * Optimization for the case when there is no idle cpu or
> +	 * only 1 idle cpu to choose from.
> +	 */
> +	if (cpumask_weight(nohz.cpu_mask) < 2)
> +		goto out_done;
> +

We can simply avoid these gotos.

--
JSR

