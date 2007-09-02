Return-Path: <linux-kernel-owner+w=401wt.eu-S1759047AbXIBTMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047AbXIBTMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 15:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbXIBTMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 15:12:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:48206 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbXIBTMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 15:12:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,200,1186383600"; 
   d="scan'208";a="124323682"
Date: Sun, 2 Sep 2007 12:12:30 -0700 (PDT)
From: Tong Li <tong.n.li@intel.com>
X-X-Sender: tongli@tongli.jf.intel.com
To: Ingo Molnar <mingo@elte.hu>
cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Simple Really Fair Scheduler
In-Reply-To: <20070902120154.GA23769@elte.hu>
Message-ID: <Pine.LNX.4.64.0709021106230.30970@tongli.jf.intel.com>
References: <20070902120154.GA23769@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I like this patch since it's really simple. CFS does provide a nice 
infrastructure to enable new algorithmic changes/extensions. My only 
concern was the O(log N) complexity under heavy load, but I'm willing to 
agree that it's OK in the common case. Some comments on the code:

> * Ingo Molnar <mingo@elte.hu> wrote:
>
> static void update_stats_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
> {
> -	s64 key;
> +	u64 key;
>
> 	/*
> 	 * Are we enqueueing a waiting task? (for current tasks
> @@ -442,26 +448,7 @@ static void update_stats_enqueue(struct
> 	/*
> 	 * Update the key:
> 	 */
> -	key = cfs_rq->fair_clock;
> -
> -	/*
> -	 * Optimize the common nice 0 case:
> -	 */
> -	if (likely(se->load.weight == NICE_0_LOAD)) {
> -		key -= se->wait_runtime;
> -	} else {
> -		u64 tmp;
> -
> -		if (se->wait_runtime < 0) {
> -			tmp = -se->wait_runtime;
> -			key += (tmp * se->load.inv_weight) >>
> -					(WMULT_SHIFT - NICE_0_SHIFT);
> -		} else {
> -			tmp = se->wait_runtime;
> -			key -= (tmp * se->load.inv_weight) >>
> -					(WMULT_SHIFT - NICE_0_SHIFT);
> -		}
> -	}
> +	key = se->exec_runtime;
>
> 	se->fair_key = key;
> }

Should we use the weighted fair clock exec_runtime as the key? This way 
tasks with larger weights will have their keys incremented more slowly and 
thus be given more CPU time. This is what other virtual-clock based fair 
scheduling algorithms commonly do.

> @@ -583,6 +570,20 @@ static void __enqueue_sleeper(struct cfs
> 	cfs_rq->sleeper_bonus += delta_fair;
> }
>
> +/*
> + * Newly woken tasks are put into the "middle" of all runnable
> + * task's current runtime:
> + */
> +static u64 avg_exec_runtime(struct cfs_rq *cfs_rq)
> +{
> +	u64 avg_exec_runtime = cfs_rq->exec_runtime;
> +
> +	if (cfs_rq->nr_running)
> +		do_div(avg_exec_runtime, cfs_rq->nr_running);
> +
> +	return avg_exec_runtime;
> +}
> +
> static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
> {
> 	struct task_struct *tsk = task_of(se);
> @@ -640,8 +641,10 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
> 	 */
> 	update_curr(cfs_rq);
>
> -	if (wakeup)
> +	if (wakeup) {
> +		se->exec_runtime = avg_exec_runtime(cfs_rq);
> 		enqueue_sleeper(cfs_rq, se);
> +	}
>
> 	update_stats_enqueue(cfs_rq, se);
> 	__enqueue_entity(cfs_rq, se);
> @@ -1126,6 +1129,7 @@ static void task_new_fair(struct rq *rq,
> 		schedstat_add(cfs_rq, wait_runtime, se->wait_runtime);
> 	}
>
> +	se->exec_runtime = avg_exec_runtime(cfs_rq);
> 	__enqueue_entity(cfs_rq, se);
> }

What's the intuition behind avg_exec_runtime? I thought the original CFS 
approach, i.e., setting a newly arriving task's key to be the current fair 
clock, adjusted by wait_runtime, was good. It matches other fair queuing 
algorithms and thus has provably good properties.

   tong
