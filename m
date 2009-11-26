Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZKZSjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZKZSjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 13:39:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbZKZSjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 13:39:03 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:37328 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbZKZSjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 13:39:01 -0500
Message-ID: <4B0ECB45.60906@linux.vnet.ibm.com>
Date: Thu, 26 Nov 2009 19:39:01 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Holger.Wolf@de.ibm.com, epasch@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: Missing recalculation of scheduler tunables in case of cpu hot
 add/remove
References: <4B0EA88E.3030205@linux.vnet.ibm.com> <1259252382.31676.207.camel@laptop>  <4B0EAC06.3010407@linux.vnet.ibm.com> <1259252892.31676.220.camel@laptop>  <4B0EAD7B.90601@linux.vnet.ibm.com> <1259253950.31676.249.camel@laptop>
In-Reply-To: <1259253950.31676.249.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-11-26 at 17:31 +0100, Christian Ehrhardt wrote:
>   
>> [...]
>> The question for now is what we do on cpu hot add/remove?
>> Would hooking somewhere in kernel/cpu.c be the right approach - I'm not 
>> quite sure about my own suggestion yet :-).
>>     
>
> Something like the below might work I suppose, just needs a cleanup and
> such.
>
>   

Looks very promising, I did not expect it would be so easy to hook up to 
the hotplug events, but you're absolutley right the scheduler already 
has hooks for that with rq_online/offline.
 From looking at the patch alone I expect it will loose user updates to 
sysfs. Might just need adding some feedback from the sysctl writer 
functions to set the default values to setval/1+ilog2; that includes 
renaming default to "normalized" or somethng like that. But I'll test 
this patch in depth tomorrow morning anyway and give more detailed feedback.

Thanks a lot!

> diff --git a/kernel/sched.c b/kernel/sched.c
> index 0cbf2ef..210365f 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -814,6 +814,7 @@ const_debug unsigned int sysctl_sched_nr_migrate = 32;
>   * default: 0.25ms
>   */
>  unsigned int sysctl_sched_shares_ratelimit = 250000;
> +unsigned int default_sysctl_sched_shares_ratelimit = 250000;
>
>  /*
>   * Inject some fuzzyness into changing the per-cpu group shares
> @@ -1810,6 +1811,7 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
>  #endif
>
>  static void calc_load_account_active(struct rq *this_rq);
> +static void update_sysctl(void);
>
>  #include "sched_stats.h"
>  #include "sched_idletask.c"
> @@ -7019,22 +7021,24 @@ cpumask_var_t nohz_cpu_mask;
>   *
>   * This idea comes from the SD scheduler of Con Kolivas:
>   */
> -static inline void sched_init_granularity(void)
> +#define SET_SYSCTL(name, factor) \
> +	sysctl_##name = (factor) * default_sysctl_##name
> +
> +static void update_sysctl(void)
>  {
> -	unsigned int factor = 1 + ilog2(num_online_cpus());
> +	unsigned int cpus = max(num_active_cpus(), 8);
> +	unsigned int factor = 1 + ilog2(cpus);
>  	const unsigned long limit = 200000000;
>
> -	sysctl_sched_min_granularity *= factor;
> -	if (sysctl_sched_min_granularity > limit)
> -		sysctl_sched_min_granularity = limit;
> -
> -	sysctl_sched_latency *= factor;
> -	if (sysctl_sched_latency > limit)
> -		sysctl_sched_latency = limit;
> -
> -	sysctl_sched_wakeup_granularity *= factor;
> +	SET_SYSCTL(sched_min_granularity);
> +	SET_SYSCTL(sched_latency);
> +	SET_SYSCTL(sched_wakeup_granularity);
> +	SET_SYSCTL(sched_shares_ratelimit);
> +}
>
> -	sysctl_sched_shares_ratelimit *= factor;
> +static inline void sched_init_granularity(void)
> +{
> +	update_sysctl();
>  }
>
>  #ifdef CONFIG_SMP
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 0ff21af..4d429b8 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -35,12 +35,14 @@
>   *  run vmstat and monitor the context-switches (cs) field)
>   */
>  unsigned int sysctl_sched_latency = 5000000ULL;
> +unsigned int default_sysctl_sched_latency = 5000000ULL;
>
>  /*
>   * Minimal preemption granularity for CPU-bound tasks:
>   * (default: 1 msec * (1 + ilog(ncpus)), units: nanoseconds)
>   */
>  unsigned int sysctl_sched_min_granularity = 1000000ULL;
> +unsigned int default_sysctl_sched_min_granularity = 1000000ULL;
>
>  /*
>   * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
> @@ -70,6 +72,7 @@ unsigned int __read_mostly sysctl_sched_compat_yield;
>   * have immediate wakeup/sleep latencies.
>   */
>  unsigned int sysctl_sched_wakeup_granularity = 1000000UL;
> +unsigned int default_sysctl_sched_wakeup_granularity = 1000000UL;
>
>  const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
>
> @@ -1905,6 +1908,17 @@ move_one_task_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
>
>  	return 0;
>  }
> +
> +static void rq_online_fair(struct rq *rq)
> +{
> +	update_sysctl();
> +}
> +
> +static void rq_offline_fair(struct rq *rq)
> +{
> +	update_sysctl();
> +}
> +
>  #endif /* CONFIG_SMP */
>
>  /*
> @@ -2052,6 +2066,8 @@ static const struct sched_class fair_sched_class = {
>
>  	.load_balance		= load_balance_fair,
>  	.move_one_task		= move_one_task_fair,
> +	.rq_online		= rq_online_fair,
> +	.rq_offline		= rq_offline_fair,
>  #endif
>
>  	.set_curr_task          = set_curr_task_fair,
>
>
>   


-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 

