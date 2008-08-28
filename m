Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbYH1J0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbYH1J0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 05:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYH1J0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 05:26:33 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:60823 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbYH1J0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 05:26:32 -0400
Subject: Re: [patch] sched: call resched_task() conditionally from new task
	wake up path.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080828091249.GA3303@in.ibm.com>
References: <20080828091249.GA3303@in.ibm.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 11:25:07 +0200
Message-Id: <1219915507.6443.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-28 at 14:42 +0530, Bharata B Rao wrote:
> Hi,
> 
> sched: call resched_task() conditionally from new task wake up path.
> 
> - During wake up of a new task, task_new_fair() can do a resched_task()
>   on the current task. Later in the code path, check_preempt_curr() also ends
>   up doing the same, which can be avoided. Check if TIF_NEED_RESCHED is
>   already set for the current task.
> 
> - task_new_fair() does a resched_task() on the current task unconditionally.
>   This can be done only in case when child runs before the parent.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> CC: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/sched_fair.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1348,6 +1348,13 @@ static void check_preempt_wakeup(struct 
>  	if (unlikely(se == pse))
>  		return;
>  
> +	/*
> +	 * We can come here with TIF_NEED_RESCHED already set from new task
> +	 * wake up path.
> +	 */
> +	if (test_tsk_need_resched(curr))
> +		return;
> +
>  	cfs_rq_of(pse)->next = pse;
>  
>  	/*
> @@ -1615,10 +1622,10 @@ static void task_new_fair(struct rq *rq,
>  		 * 'current' within the tree based on its new key value.
>  		 */
>  		swap(curr->vruntime, se->vruntime);
> +		resched_task(rq->curr);
>  	}
>  
>  	enqueue_task_fair(rq, p, 0);
> -	resched_task(rq->curr);
>  }
>  
>  /*
> 
> Regards,
> Bharata.

