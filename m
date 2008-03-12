Return-Path: <linux-kernel-owner+w=401wt.eu-S1751899AbYCLIZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbYCLIZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 04:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbYCLIZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 04:25:46 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:56542 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750800AbYCLIZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 04:25:45 -0400
Date: Wed, 12 Mar 2008 13:55:32 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH 03/17] sched: rt-group: full hierarchy support for
	the rt groups
Message-ID: <20080312082532.GB3784@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080309170850.256853000@chello.nl> <20080309170926.354453000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080309170926.354453000@chello.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2008 at 06:08:53PM +0100, Peter Zijlstra wrote:
> Update the -rt bits to support the full hierarchy support started by Dhaval.
> 

Thanks for the effort. Just a very minor comment. I will try these out
and give more feedback.

> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |   52 ++++++++++++++++++++++++++++++----------------------
>  1 file changed, 30 insertions(+), 22 deletions(-)
> 
> Index: linux-2.6-2/kernel/sched.c
> ===================================================================
> --- linux-2.6-2.orig/kernel/sched.c
> +++ linux-2.6-2/kernel/sched.c
> @@ -7302,10 +7302,12 @@ static void init_tg_cfs_entry(struct tas
>  #endif
> 
>  #ifdef CONFIG_RT_GROUP_SCHED
> -static void init_tg_rt_entry(struct rq *rq, struct task_group *tg,
> -		struct rt_rq *rt_rq, struct sched_rt_entity *rt_se,
> -		int cpu, int add)
> +static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
> +		struct sched_rt_entity *rt_se, int cpu, int add,
> +		struct sched_rt_entity *parent)
>  {
> +	struct rq *rq = cpu_rq(cpu);
> +
>  	tg->rt_rq[cpu] = rt_rq;
>  	init_rt_rq(rt_rq, rq);
>  	rt_rq->tg = tg;
> @@ -7318,6 +7320,11 @@ static void init_tg_rt_entry(struct rq *
>  	if (!rt_se)
>  		return;
> 
> +	if (!parent)
> +		rt_se->rt_rq = &rq->rt;
> +	else
> +		rt_se->rt_rq = parent->my_q;
> +
>  	rt_se->rt_rq = &rq->rt;
>  	rt_se->my_q = rt_rq;
>  	rt_se->parent = NULL;
> @@ -7380,8 +7387,7 @@ void __init sched_init(void)
>  		 * We achieve this by letting init_task_group's tasks sit
>  		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
>  		 */
> -		init_tg_cfs_entry(&init_task_group, &rq->cfs,
> -							NULL, i, 1, NULL);
> +		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, 1, NULL);

Shouldn't this go in the previous patch?

>  #elif defined CONFIG_USER_SCHED
>  		/*
>  		 * In case of task-groups formed thr' the user id of tasks,
> @@ -7394,7 +7400,7 @@ void __init sched_init(void)
>  		 * (init_cfs_rq) and having one entity represent this group of
>  		 * tasks in rq->cfs (i.e init_task_group->se[] != NULL).
>  		 */
> -		init_tg_cfs_entry(rq, &init_task_group,
> +		init_tg_cfs_entry(&init_task_group,
>  				&per_cpu(init_cfs_rq, i),
>  				&per_cpu(init_sched_entity, i), i, 1, NULL);
> 

Shouldn't this go in the previous patch? (my mistake, I missed this one in the
patch I sent out).

> @@ -7405,11 +7411,11 @@ void __init sched_init(void)
>  #ifdef CONFIG_RT_GROUP_SCHED
>  		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
>  #ifdef CONFIG_CGROUP_SCHED
> -		init_tg_rt_entry(rq, &init_task_group, &rq->rt, NULL, i, 1);
> +		init_tg_rt_entry(&init_task_group, &rq->rt, NULL, i, 1, NULL);
>  #elif defined CONFIG_USER_SCHED
> -		init_tg_rt_entry(rq, &init_task_group,
> +		init_tg_rt_entry(&init_task_group,
>  				&per_cpu(init_rt_rq, i),
> -				&per_cpu(init_sched_rt_entity, i), i, 1);
> +				&per_cpu(init_sched_rt_entity, i), i, 1, NULL);
>  #endif
>  #endif
> 
> @@ -7613,11 +7619,11 @@ static void free_fair_sched_group(struct
>  	kfree(tg->se);
>  }
> 
> -static int alloc_fair_sched_group(struct task_group *tg,
> -					struct task_group *parent)
> +static
> +int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
>  {
>  	struct cfs_rq *cfs_rq;
> -	struct sched_entity *se;
> +	struct sched_entity *se, *parent_se;
>  	struct rq *rq;
>  	int i;
> 
> @@ -7643,10 +7649,8 @@ static int alloc_fair_sched_group(struct
>  		if (!se)
>  			goto err;
> 
> -		if (!parent)
> -			init_tg_cfs_entry(tg, cfs_rq, se, i, 0, NULL);
> -		else
> -			init_tg_cfs_entry(tg, cfs_rq, se, i, 0,	parent->se[i]);
> +		parent_se = parent ? parent->se[i] : NULL;
> +		init_tg_cfs_entry(tg, cfs_rq, se, i, 0, parent_se);
>  	}
> 
>  	return 1;
> @@ -7670,7 +7674,8 @@ static inline void free_fair_sched_group
>  {
>  }
> 
> -static inline int alloc_fair_sched_group(struct task_group *tg)
> +static inline
> +int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
>  {
>  	return 1;
>  }
> @@ -7702,10 +7707,11 @@ static void free_rt_sched_group(struct t
>  	kfree(tg->rt_se);
>  }
> 
> -static int alloc_rt_sched_group(struct task_group *tg)
> +static
> +int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
>  {
>  	struct rt_rq *rt_rq;
> -	struct sched_rt_entity *rt_se;
> +	struct sched_rt_entity *rt_se, *parent_se;
>  	struct rq *rq;
>  	int i;
> 
> @@ -7732,7 +7738,8 @@ static int alloc_rt_sched_group(struct t
>  		if (!rt_se)
>  			goto err;
> 
> -		init_tg_rt_entry(rq, tg, rt_rq, rt_se, i, 0);
> +		parent_se = parent ? parent->rt_se[i] : NULL;
> +		init_tg_rt_entry(tg, rt_rq, rt_se, i, 0, parent_se);
>  	}
> 
>  	return 1;
> @@ -7756,7 +7763,8 @@ static inline void free_rt_sched_group(s
>  {
>  }
> 
> -static inline int alloc_rt_sched_group(struct task_group *tg)
> +static inline
> +int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
>  {
>  	return 1;
>  }
> @@ -7792,7 +7800,7 @@ struct task_group *sched_create_group(st
>  	if (!alloc_fair_sched_group(tg, parent))
>  		goto err;
> 
> -	if (!alloc_rt_sched_group(tg))
> +	if (!alloc_rt_sched_group(tg, parent))
>  		goto err;
> 
>  	spin_lock_irqsave(&task_group_lock, flags);
> 
> --

-- 
regards,
Dhaval
