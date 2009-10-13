Return-Path: <linux-kernel-owner+w=401wt.eu-S1760004AbZJMO2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004AbZJMO2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759992AbZJMO2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:28:10 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:8924 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759954AbZJMO2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:28:07 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC v2 PATCH 3/8] sched: Bandwidth initialization for fair
 task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
In-Reply-To: <20090930125204.GD19951@in.ibm.com>
References: <20090930124919.GA19951@in.ibm.com>
	 <20090930125204.GD19951@in.ibm.com>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 16:27:01 +0200
Message-Id: <1255444021.8392.363.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-30 at 18:22 +0530, Bharata B Rao wrote:

> diff --git a/kernel/sched.c b/kernel/sched.c
> index c283d0f..0147f6f 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -262,6 +262,15 @@ static DEFINE_MUTEX(sched_domains_mutex);
>  
>  #include <linux/cgroup.h>
>  
> +#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_CFS_HARD_LIMITS)
> +struct cfs_bandwidth {
> +	spinlock_t		cfs_runtime_lock;
> +	ktime_t			cfs_period;
> +	u64			cfs_runtime;
> +	struct hrtimer		cfs_period_timer;
> +};
> +#endif

too much cfs here..

>  struct cfs_rq;
>  
>  static LIST_HEAD(task_groups);
> @@ -282,6 +291,11 @@ struct task_group {
>  	/* runqueue "owned" by this group on each cpu */
>  	struct cfs_rq **cfs_rq;
>  	unsigned long shares;
> +#ifdef CONFIG_CFS_HARD_LIMITS
> +	struct cfs_bandwidth cfs_bandwidth;
> +	/* If set, throttle when the group exceeds its bandwidth */
> +	int hard_limit_enabled;
> +#endif

What's wrong with doing something like cfs_bandwidth.cfs_runtime ==
RUNTIME_INF ?

>  #endif
>  
>  #ifdef CONFIG_RT_GROUP_SCHED
> @@ -477,6 +491,16 @@ struct cfs_rq {
>  	unsigned long rq_weight;
>  #endif
>  #endif
> +#ifdef CONFIG_CFS_HARD_LIMITS
> +	/* set when the group is throttled  on this cpu */
> +	int cfs_throttled;
> +
> +	/* runtime currently consumed by the group on this rq */
> +	u64 cfs_time;
> +
> +	/* runtime available to the group on this rq */
> +	u64 cfs_runtime;
> +#endif

too much cfs_ again.

>  	/*
>  	 * Number of tasks at this heirarchy.
>  	 */
> @@ -665,6 +689,11 @@ struct rq {
>  	/* BKL stats */
>  	unsigned int bkl_count;
>  #endif
> +	/*
> +	 * Protects the cfs runtime related fields of all cfs_rqs under
> +	 * this rq
> +	 */
> +	spinlock_t runtime_lock;
>  };
>  
>  static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);


> +static inline void rq_runtime_lock(struct rq *rq)
> +{
> +	spin_lock(&rq->runtime_lock);
> +}
> +
> +static inline void rq_runtime_unlock(struct rq *rq)
> +{
> +	spin_unlock(&rq->runtime_lock);
> +}

needless obfuscation.

> CONFIG_RT_GROUP_SCHED
> @@ -10317,6 +10617,23 @@ static struct cftype cpu_files[] = {
>  		.read_u64 = cpu_shares_read_u64,
>  		.write_u64 = cpu_shares_write_u64,
>  	},
> +#ifdef CONFIG_CFS_HARD_LIMITS
> +	{
> +		.name = "cfs_runtime_us",
> +		.read_s64 = cpu_cfs_runtime_read_s64,
> +		.write_s64 = cpu_cfs_runtime_write_s64,
> +	},
> +	{
> +		.name = "cfs_period_us",
> +		.read_u64 = cpu_cfs_period_read_u64,
> +		.write_u64 = cpu_cfs_period_write_u64,
> +	},
> +	{
> +		.name = "cfs_hard_limit",
> +		.read_u64 = cpu_cfs_hard_limit_read_u64,
> +		.write_u64 = cpu_cfs_hard_limit_write_u64,
> +	},
> +#endif /* CONFIG_CFS_HARD_LIMITS */
>  #endif
>  #ifdef CONFIG_RT_GROUP_SCHED
>  	{

I guess that cfs_hard_limit thing is superfluous as well.

