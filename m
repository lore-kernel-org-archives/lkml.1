Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbZBUFZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbZBUFZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 00:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZBUFZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 00:25:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59373 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbZBUFZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 00:25:31 -0500
Date: Sat, 21 Feb 2009 00:25:29 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rt/workqueue: assign the waiters higher priority to the
 workqueue thread
In-Reply-To: <499f8c5c.1185300a.4d42.ffff9404@mx.google.com>
Message-ID: <alpine.DEB.2.00.0902210025140.30069@gandalf.stny.rr.com>
References: <499f8c5c.1185300a.4d42.ffff9404@mx.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks Frederic, I'll take a look at this on Monday

-- Steve



On Sat, 21 Feb 2009, Frederic Weisbecker wrote:

> When a work is embedeed inside the worklist of a barrier, it must check
> the priority of more waiters than usual:
> 
> - the propagated higher priority of the barrier ancestors (the barrier in
>   which our barrier parent is embedeed in)
> 
> - the priority of the task waiting for the completion of the barrier
>   we are embedeed in
> 
> - the higher priority work which follows our barrier ancestor
> 
> But once this check is done, we forget to assign the higher priority
> found and simply assign the priority of the current work to the current
> workqueue thread, thus omitting the PI from all waiters.
> 
> This patch fixes it and also adds some comments, the current code is rather
> complex.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/workqueue.c |   19 ++++++++++++++++++-
>  1 files changed, 18 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 90a54eb..e7ff441 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -325,17 +325,34 @@ again:
>  		 */
>  		struct lockdep_map lockdep_map = work->lockdep_map;
>  #endif
> +		/*
> +		 * Iteration over each "waiter" priority to see which one
> +		 * we have to inherit.
> +		 */
>  
> +		/* Firstly: the current job */
>  		prio = work->entry.prio;
> +
> +		/* In a barrier's worklist, we must handle yet other waiters */
>  		if (unlikely(worklist != &cwq->worklist)) {
> +			/*
> +			 * If we are in a nested barrier, check the propagated
> +			 * priority of the "grandfather" barrier waiting for us.
> +			 */
>  			prio = min(prio, cwq->barrier->prev_prio);
> +
> +			/* Check the task waiting for the parent barrier */
>  			prio = min(prio, cwq->barrier->waiter_prio);
> +
> +			/* Check the higher priority work that follows the
> +			 * ancestor barrier
> +			 */
>  			prio = min(prio, plist_first(&cwq->worklist)->prio);
>  		}
>  		prio = max(prio, 0);
>  
>  		if (likely(cwq->thread->prio != prio))
> -			rt_mutex_setprio(cwq->thread, work->entry.prio);
> +			rt_mutex_setprio(cwq->thread, prio);
>  
>  		cwq->current_work = work;
>  		plist_del(&work->entry, worklist);
> -- 
> 1.6.1
> 
> 
> 
> 
