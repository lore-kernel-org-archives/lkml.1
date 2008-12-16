Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbYLPHyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbYLPHyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbYLPHx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:53:59 -0500
Received: from viefep16-int.chello.at ([62.179.121.36]:37701 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751158AbYLPHx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:53:58 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 1/3] From: Mike Galbraith <efault@gmx.de>
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: efault@gmx.de, linux-kernel@vger.kernel.org
In-Reply-To: <20081216074636.002108651@chello.nl>
References: <20081216074529.570706654@chello.nl>
	 <20081216074636.002108651@chello.nl>
Content-Type: text/plain
Date: Tue, 16 Dec 2008 08:54:02 +0100
Message-Id: <1229414042.14605.49.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I suck!

Subject: sched: fix wakeup preemption clock

On Tue, 2008-12-16 at 08:45 +0100, Peter Zijlstra wrote:
> plain text document attachment (sched-fix-wakeup-clock.patch)
> From: Mike Galbraith <efault@gmx.de>
> 
> It was possible to do the preemption check against an old time stamp.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c      |    2 +-
>  kernel/sched_fair.c |    7 +++----
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index ce55b6a..efe5c6d 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2259,6 +2259,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
>  
>  	smp_wmb();
>  	rq = task_rq_lock(p, &flags);
> +	update_rq_clock(rq);
>  	old_state = p->state;
>  	if (!(old_state & state))
>  		goto out;
> @@ -2316,7 +2317,6 @@ out_activate:
>  		schedstat_inc(p, se.nr_wakeups_local);
>  	else
>  		schedstat_inc(p, se.nr_wakeups_remote);
> -	update_rq_clock(rq);
>  	activate_task(rq, p, 1);
>  	success = 1;
>  
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 08ffffd..6ae5115 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1343,12 +1343,11 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
>  {
>  	struct task_struct *curr = rq->curr;
>  	struct sched_entity *se = &curr->se, *pse = &p->se;
> +	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
>  
> -	if (unlikely(rt_prio(p->prio))) {
> -		struct cfs_rq *cfs_rq = task_cfs_rq(curr);
> +	update_curr(cfs_rq);
>  
> -		update_rq_clock(rq);
> -		update_curr(cfs_rq);
> +	if (unlikely(rt_prio(p->prio))) {
>  		resched_task(curr);
>  		return;
>  	}
> 

