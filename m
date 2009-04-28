Return-Path: <linux-kernel-owner+w=401wt.eu-S1752268AbZD1WVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbZD1WVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 18:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbZD1WUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 18:20:55 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:54854 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZD1WUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 18:20:54 -0400
Date: Wed, 29 Apr 2009 03:38:54 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       seto.hidetoshi@jp.fujitsu.com
Subject: Re: [PATCH] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu
	cputime count
Message-ID: <20090428220854.GC12698@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090428153611.EBC6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090428153611.EBC6.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-04-28 15:53:32]:

> 
> I'm not cpuacct expert. please give me comment.
> 
> ====================
> Subject: [PATCH] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu cputime caching
> 
> impact: little performance improvement
> 
> cpuacct_update_stats() is called at every tick updating. and it use percpu_counter
> for avoiding performance degression.
> 
> Unfortunately, it doesn't works on VIRT_CPU_ACCOUNTING=y environment properly.
> if VIRT_CPU_ACCOUNTING=y, every tick update much than 1000 cputime.
> Thus every percpu_counter_add() makes spinlock grabbing and update non-percpu-variable.
> 
> This patch change the batch rule. now, every cpu can store "percpu_counter_bach x jiffies"
> cputime in percpu cache.
> it mean this patch don't have behavior change if VIRT_CPU_ACCOUNTING=n, but
> works well on VIRT_CPU_ACCOUNTING=y too.
> 
> 
> Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
> Cc: Balaji Rao <balajirrao@gmail.com>
> Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  kernel/sched.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: b/kernel/sched.c
> ===================================================================
> --- a/kernel/sched.c	2009-04-28 14:18:36.000000000 +0900
> +++ b/kernel/sched.c	2009-04-28 15:18:07.000000000 +0900
> @@ -10117,6 +10117,7 @@ struct cpuacct {
>  };
> 
>  struct cgroup_subsys cpuacct_subsys;
> +static s32 cpuacct_batch;
> 
>  /* return cpu accounting group corresponding to this container */
>  static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
> @@ -10146,6 +10147,9 @@ static struct cgroup_subsys_state *cpuac
>  	if (!ca->cpuusage)
>  		goto out_free_ca;
> 
> +	if (!cpuacct_batch)
> +		cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
> +

I expect cpuacct_batch to be a large number

>  	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
>  		if (percpu_counter_init(&ca->cpustat[i], 0))
>  			goto out_free_counters;
> @@ -10342,7 +10346,7 @@ static void cpuacct_update_stats(struct 
>  	ca = task_ca(tsk);
> 
>  	do {
> -		percpu_counter_add(&ca->cpustat[idx], val);
> +		__percpu_counter_add(&ca->cpustat[idx], val, cpuacct_batch);

This will make the end result very off the real value due to large
batch value per cpu. If we are going to go this route, we should
probably consider using __percpu_counter_sum so that the batch value
does not show data that is way off.

>  		ca = ca->parent;
>  	} while (ca);
>  	rcu_read_unlock();
> 
> 

-- 
	Balbir
