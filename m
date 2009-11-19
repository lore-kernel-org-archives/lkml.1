Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbZKSWvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbZKSWvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 17:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbZKSWvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 17:51:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39142 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250AbZKSWvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 17:51:50 -0500
Subject: Re: [PATCH 1/1] sched: move update_curr() in
 check_preempt_wakeup() to avoid redundant call
From: Peter Zijlstra <peterz@infradead.org>
To: Jupyung Lee <jupyung@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1258451500-6714-1-git-send-email-jupyung@gmail.com>
References: <1258451500-6714-1-git-send-email-jupyung@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Nov 2009 23:51:53 +0100
Message-ID: <1258671113.11284.299.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 18:51 +0900, Jupyung Lee wrote:
> Impact: micro-optimization
> 
> If a RT task is woken up while a non-RT task is running, 
> check_preempt_wakeup() is called to check whether the new task can 
> preempt the old task. The function returns quickly without going deeper 
> because it is apparent that a RT task can always preempt a non-RT task.
> 
> In this situation, check_preempt_wakeup() always calls update_curr() to
> update vruntime value of the currently running task. However, the function
> call is unnecessary and redundant at that moment because (1) a non-RT task can 
> always be preempted by a RT task regardless of its vruntime value, and
> (2) update_curr() will be called shortly when the context switch between two occurs.
> 
> By moving update_curr() in check_preempt_wakeup(), we can avoid redundant
> call to update_curr(), slightly reducing the time taken to wake up RT tasks.

So far so good, but then you let me figure out why you placed it where
you did.

Anyway, I think the patch is good and took the patch, thanks!

> Signed-off-by: Jupyung Lee <jupyung@gmail.com>
> ---
>  kernel/sched_fair.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 37087a7..32256c0 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1596,8 +1596,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
>  	int sync = wake_flags & WF_SYNC;
>  	int scale = cfs_rq->nr_running >= sched_nr_latency;
>  
> -	update_curr(cfs_rq);
> -
>  	if (unlikely(rt_prio(p->prio))) {
>  		resched_task(curr);
>  		return;
> @@ -1655,6 +1653,8 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
>  
>  	BUG_ON(!pse);
>  
> +	update_curr(cfs_rq);
> +
>  	if (wakeup_preempt_entity(se, pse) == 1) {
>  		resched_task(curr);
>  		/*


