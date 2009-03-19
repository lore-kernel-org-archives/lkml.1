Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbZCSJRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbZCSJRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 05:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbZCSJRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 05:17:44 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:30506 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbZCSJRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 05:17:43 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH -tip] cpuacct: per-cgroup utime/stime statistics - v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090317062155.GE3314@in.ibm.com>
References: <20090317062155.GE3314@in.ibm.com>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 10:17:28 +0100
Message-Id: <1237454248.7867.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 11:51 +0530, Bharata B Rao wrote:
> Hi,
> 
> Here is the next version of the cpuacct stime/utime statistics patch.
> 
> Ingo, Could you please consider this for -tip ?
> 
> Changes for v3:
> - Fix a small race in the cpuacct hierarchy walk.
> 
> v2:
> http://lkml.org/lkml/2009/3/12/170
> 
> v1:
> http://lkml.org/lkml/2009/3/10/150
> --
> 
> cpuacct: Add stime and utime statistics
> 
> Add per-cgroup cpuacct controller statistics like the system and user
> time consumed by the group of tasks.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> Signed-off-by: Balaji Rao <balajirrao@gmail.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  Documentation/cgroups/cpuacct.txt |   17 +++++++
>  kernel/sched.c                    |   92 +++++++++++++++++++++++++++++++++++---
>  2 files changed, 103 insertions(+), 6 deletions(-)
> 
> --- a/Documentation/cgroups/cpuacct.txt
> +++ b/Documentation/cgroups/cpuacct.txt
> @@ -30,3 +30,20 @@ The above steps create a new group g1 an
>  process (bash) into it. CPU time consumed by this bash and its children
>  can be obtained from g1/cpuacct.usage and the same is accumulated in
>  /cgroups/cpuacct.usage also.
> +
> +cpuacct.stat file lists a few statistics which further divide the
> +CPU time obtained by the cgroup into user and system times. Currently
> +the following statistics are supported:
> +
> +utime: Time spent by tasks of the cgroup in user mode.
> +stime: Time spent by tasks of the cgroup in kernel mode.
> +
> +utime and stime are in USER_HZ unit.
> +
> +cpuacct controller uses percpu_counter interface to collect utime and
> +stime. This causes two side effects:
> +
> +- It is theoritically possible to see wrong values for stime and utime.
> +  This is because percpu_counter_read() on 32bit systems is broken.
> +- It is possible to see slightly outdated values for stime and utime
> +  due to the batch processing nature of percpu_counter.
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1442,10 +1442,22 @@ iter_move_one_task(struct rq *this_rq, i
>  		   struct rq_iterator *iterator);
>  #endif
>  
> +/* Time spent by the tasks of the cpu accounting group executing in ... */
> +enum cpuacct_stat_index {
> +	CPUACCT_STAT_UTIME,	/* ... user mode */
> +	CPUACCT_STAT_STIME,	/* ... kernel mode */
> +
> +	CPUACCT_STAT_NSTATS,
> +};
> +
>  #ifdef CONFIG_CGROUP_CPUACCT
>  static void cpuacct_charge(struct task_struct *tsk, u64 cputime);
> +static void cpuacct_update_stats(struct task_struct *tsk,
> +		enum cpuacct_stat_index idx, cputime_t val);
>  #else
>  static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
> +static inline void cpuacct_update_stats(struct task_struct *tsk,
> +		enum cpuacct_stat_index idx, cputime_t val) {}
>  #endif
>  
>  static inline void inc_cpu_load(struct rq *rq, unsigned long load)
> @@ -4387,6 +4399,8 @@ void account_user_time(struct task_struc
>  		cpustat->nice = cputime64_add(cpustat->nice, tmp);
>  	else
>  		cpustat->user = cputime64_add(cpustat->user, tmp);
> +
> +	cpuacct_update_stats(p, CPUACCT_STAT_UTIME, cputime);
>  	/* Account for user time used */
>  	acct_update_integrals(p);
>  }
> @@ -4448,6 +4462,8 @@ void account_system_time(struct task_str
>  	else
>  		cpustat->system = cputime64_add(cpustat->system, tmp);
>  
> +	cpuacct_update_stats(p, CPUACCT_STAT_STIME, cputime);
> +
>  	/* Account for system time used */
>  	acct_update_integrals(p);
>  }
> @@ -9727,6 +9743,7 @@ struct cpuacct {
>  	struct cgroup_subsys_state css;
>  	/* cpuusage holds pointer to a u64-type object on every cpu */
>  	u64 *cpuusage;
> +	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
>  	struct cpuacct *parent;
>  };
>  
> @@ -9751,20 +9768,33 @@ static struct cgroup_subsys_state *cpuac
>  	struct cgroup_subsys *ss, struct cgroup *cgrp)
>  {
>  	struct cpuacct *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
> +	int i;
>  
>  	if (!ca)
> -		return ERR_PTR(-ENOMEM);
> +		goto out;
>  
>  	ca->cpuusage = alloc_percpu(u64);
> -	if (!ca->cpuusage) {
> -		kfree(ca);
> -		return ERR_PTR(-ENOMEM);
> -	}
> +	if (!ca->cpuusage)
> +		goto out_free_ca;
> +
> +	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
> +		if (percpu_counter_init(&ca->cpustat[i], 0))
> +			goto out_free_counters;
>  
>  	if (cgrp->parent)
>  		ca->parent = cgroup_ca(cgrp->parent);
>  
>  	return &ca->css;
> +
> +out_free_counters:
> +	i--;
> +	while (i-- >= 0)
> +		percpu_counter_destroy(&ca->cpustat[i]);
> +	free_percpu(ca->cpuusage);
> +out_free_ca:
> +	kfree(ca);
> +out:
> +	return ERR_PTR(-ENOMEM);
>  }
>  
>  /* destroy an existing cpu accounting group */
> @@ -9772,7 +9802,10 @@ static void
>  cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
>  {
>  	struct cpuacct *ca = cgroup_ca(cgrp);
> +	int i;
>  
> +	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
> +		percpu_counter_destroy(&ca->cpustat[i]);
>  	free_percpu(ca->cpuusage);
>  	kfree(ca);
>  }
> @@ -9859,6 +9892,25 @@ static int cpuacct_percpu_seq_read(struc
>  	return 0;
>  }
>  
> +static const char *cpuacct_stat_desc[] = {
> +	[CPUACCT_STAT_UTIME] = "utime",
> +	[CPUACCT_STAT_STIME] = "stime",
> +};
> +
> +static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
> +		struct cgroup_map_cb *cb)
> +{
> +	struct cpuacct *ca = cgroup_ca(cgrp);
> +	int i;
> +
> +	for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
> +		s64 val = percpu_counter_read(&ca->cpustat[i]);
> +		val = cputime_to_clock_t(val);
> +		cb->fill(cb, cpuacct_stat_desc[i], val);
> +	}
> +	return 0;
> +}
> +
>  static struct cftype files[] = {
>  	{
>  		.name = "usage",
> @@ -9869,7 +9921,10 @@ static struct cftype files[] = {
>  		.name = "usage_percpu",
>  		.read_seq_string = cpuacct_percpu_seq_read,
>  	},
> -
> +	{
> +		.name = "stat",
> +		.read_map = cpuacct_stats_show,
> +	},
>  };
>  
>  static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
> @@ -9908,6 +9963,31 @@ static void cpuacct_charge(struct task_s
>  	rcu_read_unlock();
>  }
>  
> +/*
> + * Charge the system/user time to the task's accounting group.
> + */
> +static void cpuacct_update_stats(struct task_struct *tsk,
> +		enum cpuacct_stat_index idx, cputime_t val)
> +{
> +	struct cpuacct *ca;
> +
> +	if (unlikely(!cpuacct_subsys.active))
> +		return;
> +
> +	/*
> +	 * rcu_read_lock() protects ca thus making sure that hierarchy
> +	 * walk is safe.
> +	 */
> +	rcu_read_lock();
> +	ca = task_ca(tsk);
> +
> +	do {
> +		percpu_counter_add(&ca->cpustat[idx], val);
> +		ca = ca->parent;
> +	} while (ca);
> +	rcu_read_unlock();
> +}
> +
>  struct cgroup_subsys cpuacct_subsys = {
>  	.name = "cpuacct",
>  	.create = cpuacct_create,

