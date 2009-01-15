Return-Path: <linux-kernel-owner+w=401wt.eu-S1762861AbZAOKOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762861AbZAOKOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761585AbZAOKOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:14:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59218 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760787AbZAOKOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:14:21 -0500
Subject: Re: [BUG] How to get real-time priority using idle priority
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Brian Rogers <brian@xyzw.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1232011723.26761.36.camel@marge.simson.net>
References: <4969D0D7.2060401@xyzw.org>
	 <1231736941.6003.7.camel@marge.simson.net>
	 <1231765433.5789.35.camel@marge.simson.net> <20090112131406.GB670@elte.hu>
	 <496BE8F6.1040308@xyzw.org>  <1232011723.26761.36.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 11:14:16 +0100
Message-Id: <1232014456.8870.26.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 10:28 +0100, Mike Galbraith wrote:

> The real problem (excluding the SCHED_IDLE specific problems), is that
> update_min_vruntime() doesn't work quite as intended, and will slam
> min_vruntime far right if load balancing etc places a task which is far
> right of the currently running task on the runqueue.  If the currently
> running, and up to this point the min_vruntime pace setter, is a hog,
> any task waking to this runqueue after min_vruntime leaps forward has to
> wait for the hog to consume the gap.  In the case of SCHED_IDLE tasks,
> that gap can be huge, but even with a nice 19 tasks it can be quite
> large and painful.
> 
> Removing the if (vruntime == cfs_rq->min_vruntime) test, which will be
> true if the currently running task is the pace setter, cured it for me.

OK, so we have 1 running task A (which is obviously curr and the tree is
equally obviously empty).

A nicely chugs along, doing its thing, carrying min_vruntime along as it
goes.

Then some whacko speed freak SCHED_IDLE task gets inserted due to SMP
balancing, which is very likely far right, in that case

update_curr
  update_min_vruntime
    cfs_rq->rb_leftmost := true (the crazy task sitting in a tree)
      vruntime = se->vruntime

and voila, min_vruntime is waaay right of where it ought to be.

OK, so why did I write it like that to begin with...

Aah, yes.

Say we've just dequeued current

schedule
  deactivate_task(prev)
    dequeue_entity
      update_min_vruntime

Then we'll set

  vruntime = cfs_rq->min_vruntime;

we find !cfs_rq->curr, but do find someone in the tree. Then we _must_
do vruntime = se->vruntime, because

 vruntime = min_vruntime(vruntime := cfs_rq->min_vruntime, se->vruntime)

will not advance vruntime, and cause lags the other way around (which we
fixed with that initial patch: 1af5f730fc1bf7c62ec9fb2d307206e18bf40a69
(sched: more accurate min_vruntime accounting).

Which leads me to suggest the following

---
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8e1352c..f2d2d94 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -283,7 +283,7 @@ static void update_min_vruntime(struct cfs_rq
*cfs_rq)
 						   struct sched_entity,
 						   run_node);
 
-		if (vruntime == cfs_rq->min_vruntime)
+		if (!cfs_rq->curr)
 			vruntime = se->vruntime;
 		else
 			vruntime = min_vruntime(vruntime, se->vruntime);

The below can be split into 3 patches:

 - the idle weight change (do we really need that? why?)
 - the above update_min_vruntime() fix
 - the SCHED_IDLE vs SCHED_OTHER isolation changes (ACK on those)

> If this cures your woes (and Peter acks it), I'll split and submit.
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index deb5ac8..e9f0762 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1320,8 +1320,8 @@ static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
>   * slice expiry etc.
>   */
>  
> -#define WEIGHT_IDLEPRIO		2
> -#define WMULT_IDLEPRIO		(1 << 31)
> +#define WEIGHT_IDLEPRIO		3
> +#define WMULT_IDLEPRIO		1431655765
>  
>  /*
>   * Nice levels are multiplicative, with a gentle 10% change for every
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 8e1352c..761071d 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -283,10 +283,7 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq)
>  						   struct sched_entity,
>  						   run_node);
>  
> -		if (vruntime == cfs_rq->min_vruntime)
> -			vruntime = se->vruntime;
> -		else
> -			vruntime = min_vruntime(vruntime, se->vruntime);
> +		vruntime = min_vruntime(vruntime, se->vruntime);
>  	}
>  
>  	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
> @@ -677,9 +674,13 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
>  			unsigned long thresh = sysctl_sched_latency;
>  
>  			/*
> -			 * convert the sleeper threshold into virtual time
> +			 * Convert the sleeper threshold into virtual time.
> +			 * SCHED_IDLE is a special sub-class.  We care about
> +			 * fairness only relative to other SCHED_IDLE tasks,
> +			 * all of which have the same weight.
>  			 */
> -			if (sched_feat(NORMALIZED_SLEEPER))
> +			if (sched_feat(NORMALIZED_SLEEPER) &&
> +					task_of(se)->policy != SCHED_IDLE)
>  				thresh = calc_delta_fair(thresh, se);
>  
>  			vruntime -= thresh;
> @@ -1340,14 +1341,18 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
>  
>  static void set_last_buddy(struct sched_entity *se)
>  {
> -	for_each_sched_entity(se)
> -		cfs_rq_of(se)->last = se;
> +	for_each_sched_entity(se) {
> +		if (likely(task_of(se)->policy != SCHED_IDLE))
> +			cfs_rq_of(se)->last = se;
> +	}
>  }
>  
>  static void set_next_buddy(struct sched_entity *se)
>  {
> -	for_each_sched_entity(se)
> -		cfs_rq_of(se)->next = se;
> +	for_each_sched_entity(se) {
> +		if (likely(task_of(se)->policy != SCHED_IDLE))
> +			cfs_rq_of(se)->next = se;
> +	}
>  }
>  
>  /*
> @@ -1393,12 +1398,18 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
>  		return;
>  
>  	/*
> -	 * Batch tasks do not preempt (their preemption is driven by
> +	 * Batch and idle tasks do not preempt (their preemption is driven by
>  	 * the tick):
>  	 */
> -	if (unlikely(p->policy == SCHED_BATCH))
> +	if (unlikely(p->policy != SCHED_NORMAL))
>  		return;
>  
> +	/* Idle tasks are by definition preempted by everybody. */
> +	if (unlikely(curr->policy == SCHED_IDLE)) {
> +		resched_task(curr);
> +		return;
> +	}
> +
>  	if (!sched_feat(WAKEUP_PREEMPT))
>  		return;
>  
> 
> 

