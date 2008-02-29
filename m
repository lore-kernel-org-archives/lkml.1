Return-Path: <linux-kernel-owner+w=401wt.eu-S1762078AbYB2AoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762078AbYB2AoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:44:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbYB2Ans
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:43:48 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:51867 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbYB2Anr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:43:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tTOmkrZSwHJxTuCO0feGlTl9FD+RZVBNsepB8//T0qM6YHXjcKDpk/PuHb54pc/oqd9TUahMNPoqqLd3oevKwO2przHFBRRQR+oMmNsSXzv+g0QQ+0/kYAS774IfDwg5I+kfHSdTlecJU+M43ZwkYcIWNaAL1PRnpumFeDJPVbQ=
Message-ID: <998d0e4a0802281643k74dfa4r4accbc220af1b295@mail.gmail.com>
Date: Fri, 29 Feb 2008 01:43:38 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 1/2] sched: change the fairness model of the CFS group scheduler
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://lkml.org/lkml/2008/2/28/313 has a lot of new bugs.

> +++ linux-2.6.25-rc2/kernel/sched_fair.c

> +	struct sched_entity *se = tg->se[cpu], *top_se;

> +
> +	for_each_sched_entity(se)
> +		top_se = se;
> +

It does unnecesary code execution.
Why don't do once "top_se = se;" instead for each?

> +static inline int depth_se(struct sched_entity *se)
> +{
> +	int depth = 0;
> +
> +	for_each_sched_entity(se)
> +		depth++;
> +
> +	return depth;
> +}
> +

It does unnecesary code execution.
Why don't do "depth = the count of sched entities" instead of ++?

> +	/* First walk up until both entities are at same depth */
> +	se_depth = depth_se(se);
> +	pse_depth = depth_se(pse);
> +
> +	while (se_depth > pse_depth) {
> +		se_depth--;
> +		se = parent_entity(se);
> +	}
> +
> +	while (pse_depth > se_depth) {
> +		pse_depth--;
> +		pse = parent_entity(pse);
> +	}

It does unnecesary code execution.
Exiting the 1st while asserts "se_depth == pse_depth",
the 2nd while never is entered.

>  __load_balance_iterator(struct cfs_rq *cfs_rq, struct rb_node *curr)

> -	p = rb_entry(curr, struct task_struct, se.run_node);
> -	cfs_rq->rb_load_balance_curr = rb_next(curr);
> +	/* Skip over entities that are not tasks */
> +	do {
> +		se = rb_entry(curr, struct sched_entity, run_node);
> +		curr = rb_next(curr);
> +	} while (curr && !entity_is_task(se));

It's wrong, it says that curr is next to the first found entity that is task.

I think that the correct code could be
curr = rb_next(curr);
while (curr) {
   se = rb_entry(curr, struct sched_entity, run_node);
   if (entity_is_task(se)) break;
   curr = rb_next(curr);
} /* se is next to curr and first entity that is task skipping
non-task entities */

> +	cfs_rq->rb_load_balance_curr = curr;
> +
> +	if (entity_is_task(se))
> +		p = task_of(se);
>
>  	return p;

You forgot if (unlikely(curr == NULL)) { ... }

> @@ -1210,21 +1267,28 @@ load_balance_fair(struct rq *this_rq, in

>  		unsigned long maxload, task_load, group_weight;

> -		group_weight = se->load.weight;
> +		if (!task_load)
> +			continue;
> +
> +		group_weight = group_cpu_load(tg, busiest->cpu);

> -		 * 'group_weight' is contributed by tasks of total weight
> +		 * 'group_weight' is contributed by entities of total weight

>  		 * 	maxload = (remload / group_weight) * task_load;
>  		 */
>  		maxload = (rem_load_move * task_load) / group_weight;

The unsigned long division IS SLOW!!! Use multiplication and shift stupid!!!
Be careful with zerodiv exception of "/ group_weight"!!!

> -		/*
> -		 * load_moved holds the task load that was moved. The
> -		 * effective (group) weight moved would be:
> -		 * 	load_moved_eff = load_moved/task_load * group_weight;
> -		 */
> -		load_moved = (group_weight * load_moved) / task_load;
> -
>  		/* Adjust shares on both cpus to reflect load_moved */
> -		group_weight -= load_moved;
> -		set_se_shares(se, group_weight);
> +		if (likely(se)) {
> +			unsigned long load_moved_eff;
> +			unsigned long se_shares;
>
> -		se = busy_cfs_rq->tg->se[this_cpu];
> -		if (!thisload)
> -			group_weight = load_moved;
> -		else
> -			group_weight = se->load.weight + load_moved;
> -		set_se_shares(se, group_weight);
> +			/*
> +			 * load_moved holds the task load that was moved. The
> +			 * effective (group) weight moved would be:
> +			 *	load_moved_eff = load_moved/task_load *
> +			 *					group_weight;
> +			 */
> +			load_moved_eff = (se->load.weight *
> +						 load_moved) / task_load;
> +
> +			set_se_shares(se, se->load.weight - load_moved_eff);
> +			if (!thisload)
> +				se_shares = load_moved_eff;
> +			else
> +				se_shares = this_se->load.weight +
> +							load_moved_eff;
> +			set_se_shares(this_se, se_shares);
> +		}

The unsigned long division IS SLOW!!! Use multiplication and shift stupid!!!
Be careful with zerodiv exception of "/ task_load"!!!

   J.C.Pizarro
