Return-Path: <linux-kernel-owner+w=401wt.eu-S1759363AbYB1K0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbYB1K0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 05:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbYB1K0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 05:26:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33396 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbYB1K0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:26:38 -0500
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>, Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       oleg@tv-sign.ru, rostedt@goodmis.org, maxk@qualcomm.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.00.0802280212070.23040@chino.kir.corp.google.com>
References: <20080227222103.673194000@chello.nl>
	 <20080228075010.GA28781@elte.hu> <20080228020808.3fd22f77.pj@sgi.com>
	 <20080228090847.GA1133@elte.hu> <20080228031710.3405e405.pj@sgi.com>
	 <alpine.DEB.1.00.0802280129580.15900@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802280212070.23040@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 11:26:01 +0100
Message-Id: <1204194361.6243.31.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 02:12 -0800, David Rientjes wrote:
> On Thu, 28 Feb 2008, David Rientjes wrote:
> 
> > Should the kernel refuse to move some threads, such as the migration 
> > or watchdog kthreads, out of the root cpuset where the mems can be 
> > adjusted to disallow access to the cpu to which they are bound?  This is 
> > a quick way to cause a crash or soft lockup.

Indeed, there is a hole in my cpus_match_system() logic in that when the
system set is reduced to a single cpu, the tasks bound to that cpu also
match.

I had wanted to avoid adding PF_ flags (as I remember we're running
short on them), but I think you're right.

Thanks!

> Something like this?
> ---
>  include/linux/sched.h |    1 +
>  kernel/cpuset.c       |    5 ++++-
>  kernel/kthread.c      |    1 +
>  kernel/sched.c        |    6 ++++++
>  4 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1464,6 +1464,7 @@ static inline void put_task_struct(struct task_struct *t)
>  #define PF_SWAPWRITE	0x00800000	/* Allowed to write to swap */
>  #define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
>  #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
> +#define PF_CPU_BOUND	0x04000000	/* Kthread bound to specific cpu */
>  #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
>  #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
>  #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1175,11 +1175,14 @@ static void cpuset_attach(struct cgroup_subsys *ss,
>  	struct mm_struct *mm;
>  	struct cpuset *cs = cgroup_cs(cont);
>  	struct cpuset *oldcs = cgroup_cs(oldcont);
> +	int ret;
>  
>  	mutex_lock(&callback_mutex);
>  	guarantee_online_cpus(cs, &cpus);
> -	set_cpus_allowed(tsk, cpus);
> +	ret = set_cpus_allowed(tsk, cpus);
>  	mutex_unlock(&callback_mutex);
> +	if (ret < 0)
> +		return;
>  
>  	from = oldcs->mems_allowed;
>  	to = cs->mems_allowed;
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -180,6 +180,7 @@ void kthread_bind(struct task_struct *k, unsigned int cpu)
>  	wait_task_inactive(k);
>  	set_task_cpu(k, cpu);
>  	k->cpus_allowed = cpumask_of_cpu(cpu);
> +	k->flags |= PF_CPU_BOUND;
>  }
>  EXPORT_SYMBOL(kthread_bind);
>  
> diff --git a/kernel/sched.c b/kernel/sched.c
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5345,6 +5345,12 @@ int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
>  		goto out;
>  	}
>  
> +	if (unlikely((p->flags & PF_CPU_BOUND) && p != current &&
> +	    	     !cpus_equal(p->cpus_allowed, new_mask))) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
>  	if (p->sched_class->set_cpus_allowed)
>  		p->sched_class->set_cpus_allowed(p, &new_mask);
>  	else {

