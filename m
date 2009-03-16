Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbZCPBg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbZCPBg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 21:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbZCPBgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 21:36:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52413 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZCPBgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 21:36:44 -0400
Date: Mon, 16 Mar 2009 10:35:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH -tip] cpuacct: per-cgroup utime/stime statistics -
 v2
Message-Id: <20090316103517.b0f8a20c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090312110924.GC3344@in.ibm.com>
References: <20090312110924.GC3344@in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 16:39:24 +0530
Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:

> Here is the 2nd version of the cpuacct statistics patch. Copying
> linux-arch list also this time to check if archs which define
> CONFIG_VIRT_CPU_ACCOUNTING are ok with this change.
> 
> Changes for v2:
> - stime and utime now exported in clock_t units instead of msecs.
> - Addressed the code review comments from Balbir and Li Zefan.
> - Moved to -tip tree.
> 
> v1:
> - http://lkml.org/lkml/2009/3/10/150
> 
> 
> cpuacct: Add stime and utime statistics
> 
> Add per-cgroup cpuacct controller statistics like the system and user
> time consumed by the group of tasks.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> Signed-off-by: Balaji Rao <balajirrao@gmail.com>
> ---
>  Documentation/cgroups/cpuacct.txt |   17 +++++++
>  kernel/sched.c                    |   86 +++++++++++++++++++++++++++++++++++---
>  2 files changed, 97 insertions(+), 6 deletions(-)
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
> @@ -1434,10 +1434,22 @@ iter_move_one_task(struct rq *this_rq, i
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
> +static void cpuacct_update_stats(struct task_struct *tsk,
> +		enum cpuacct_stat_index idx, cputime_t val) {}
>  #endif
"static inline"  
if no "inline", the complier will show warning as
"this function is defined but not used.."




>  static inline void inc_cpu_load(struct rq *rq, unsigned long load)
> @@ -4379,6 +4391,8 @@ void account_user_time(struct task_struc
>  		cpustat->nice = cputime64_add(cpustat->nice, tmp);
>  	else
>  		cpustat->user = cputime64_add(cpustat->user, tmp);
> +
> +	cpuacct_update_stats(p, CPUACCT_STAT_UTIME, cputime);
>  	/* Account for user time used */
>  	acct_update_integrals(p);
>  }
> @@ -4440,6 +4454,8 @@ void account_system_time(struct task_str
>  	else
>  		cpustat->system = cputime64_add(cpustat->system, tmp);
>  
> +	cpuacct_update_stats(p, CPUACCT_STAT_STIME, cputime);
> +
>  	/* Account for system time used */
>  	acct_update_integrals(p);
>  }
> @@ -9723,6 +9739,7 @@ struct cpuacct {
>  	struct cgroup_subsys_state css;
>  	/* cpuusage holds pointer to a u64-type object on every cpu */
>  	u64 *cpuusage;
> +	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
>  	struct cpuacct *parent;
>  };
>  
> @@ -9747,20 +9764,33 @@ static struct cgroup_subsys_state *cpuac
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
> @@ -9768,7 +9798,10 @@ static void
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
> @@ -9855,6 +9888,25 @@ static int cpuacct_percpu_seq_read(struc
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
> @@ -9865,7 +9917,10 @@ static struct cftype files[] = {
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
> @@ -9895,6 +9950,25 @@ static void cpuacct_charge(struct task_s
>  	}
>  }
>  
> +/*
> + * Account the system/user time to the task's accounting group.
> + */
> +static void cpuacct_update_stats(struct task_struct *tsk,
> +		enum cpuacct_stat_index idx, cputime_t val)
> +{
> +	struct cpuacct *ca;
> +
> +	if (unlikely(!cpuacct_subsys.active))
> +		return;
> +
> +	ca = task_ca(tsk);
> +
> +	do {
> +		percpu_counter_add(&ca->cpustat[idx], val);
> +		ca = ca->parent;
> +	} while (ca);
> +}
> +

IIUC, to make sure accessing "ca" to be safe, we need some condition.
(task_lock() or some other.....

Could you add "why this is safe ?" as comment ?

-Kame



>  struct cgroup_subsys cpuacct_subsys = {
>  	.name = "cpuacct",
>  	.create = cpuacct_create,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

