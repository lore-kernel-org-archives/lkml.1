Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbZJ0ICV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbZJ0ICV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932088AbZJ0ICU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:02:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:21487 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536AbZJ0ICT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:02:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,631,1249282800"; 
   d="scan'208";a="461707717"
Subject: Re: hackbench regression with kernel 2.6.32-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1255691192.7029.13.camel@marge.simson.net>
References: <1255079943.25078.23.camel@ymzhang>
	 <1255084986.8802.46.camel@laptop>  <1255331120.3684.43.camel@ymzhang>
	 <1255357264.10420.15.camel@twins>  <1255403522.3684.57.camel@ymzhang>
	 <1255691192.7029.13.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 27 Oct 2009 16:03:04 +0800
Message-Id: <1256630584.16282.13.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 13:06 +0200, Mike Galbraith wrote:
> On Tue, 2009-10-13 at 11:12 +0800, Zhang, Yanmin wrote:
> 
> > NEXT_BUDDY has no help on volanoMark and tbench.
> 
> Can you try the patch below please?  It does tries to preserve buddy
> affinity where possible, and mitigates over-preemption by strengthening
> buddies a bit.  It improves vmark here by ~7%.
I ran some benchmarks against 2.6.32-rc1+Peter_2_patches+below_patch.
Below result is against 2.6.32-rc1.
hackbench result has about 10% improvement on stoakley (2*4 cores) and
tigerton (4*4 cores).
tbench still has about 5% regression on ﻿stoakley and tigerton.
VolanoMark has 33% regression on tigerton, but has 2% improvement on stoakley.

I also ran the benchmarks against the latest tips/master and got the similiar
results like above testing.
﻿
The testing against tips on Nehalem machine didn't show much improvement/regression.

> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 00f9e71..fb025d4 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2007,8 +2007,12 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
>  
>  	/*
>  	 * Buddy candidates are cache hot:
> +	 *
> +	 * Do not honor buddies if there may be nothing else to
> +	 * prevent us from becoming idle.
>  	 */
>  	if (sched_feat(CACHE_HOT_BUDDY) &&
> +			task_rq(p)->nr_running >= sched_nr_latency &&
>  			(&p->se == cfs_rq_of(&p->se)->next ||
>  			 &p->se == cfs_rq_of(&p->se)->last))
>  		return 1;
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index c32c3e6..428bf55 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -863,18 +863,20 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
>  	struct sched_entity *se = __pick_next_entity(cfs_rq);
>  	struct sched_entity *buddy;
>  
> -	if (cfs_rq->next) {
> +	if (cfs_rq->next && sched_feat(NEXT_BUDDY)) {
>  		buddy = cfs_rq->next;
> -		cfs_rq->next = NULL;
> -		if (wakeup_preempt_entity(buddy, se) < 1)
> +		if (wakeup_preempt_entity(buddy, se) < 1) {
> +			cfs_rq->next = NULL;
>  			return buddy;
> +		}
>  	}
>  
> -	if (cfs_rq->last) {
> +	if (cfs_rq->last && sched_feat(LAST_BUDDY)) {
>  		buddy = cfs_rq->last;
> -		cfs_rq->last = NULL;
> -		if (wakeup_preempt_entity(buddy, se) < 1)
> +		if (wakeup_preempt_entity(buddy, se) < 1) {
> +			cfs_rq->last = NULL;
>  			return buddy;
> +		}
>  	}
>  
>  	return se;
> @@ -1600,9 +1602,9 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
>  	 * Also, during early boot the idle thread is in the fair class, for
>  	 * obvious reasons its a bad idea to schedule back to the idle thread.
>  	 */
> -	if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle))
> +	if (!(wake_flags & WF_FORK) && likely(se->on_rq && curr != rq->idle))
>  		set_last_buddy(se);
> -	if (sched_feat(NEXT_BUDDY) && !(wake_flags & WF_FORK))
> +	if (!(wake_flags & WF_FORK))
>  		set_next_buddy(pse);
>  
>  	/*
> 
> 

