Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZG3Hd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZG3Hd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 03:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZG3Hd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 03:33:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38834 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZG3HdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 03:33:25 -0400
Subject: Re: [PATCH] sched: enhance the pre/post scheduling logic
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, mingo@elte.hu,
       akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <20090729150422.17691.55590.stgit@dev.haskins.net>
References: <1248856884.6987.3043.camel@twins>
	 <20090729150422.17691.55590.stgit@dev.haskins.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Jul 2009 09:36:25 +0200
Message-Id: <1248939385.6391.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 11:08 -0400, Gregory Haskins wrote:

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 3ab08e4..df14cae 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1045,7 +1045,6 @@ struct sched_class {
>  			      struct rq *busiest, struct sched_domain *sd,
>  			      enum cpu_idle_type idle);
>  	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
> -	int (*needs_post_schedule) (struct rq *this_rq);
>  	void (*post_schedule) (struct rq *this_rq);
>  	void (*task_wake_up) (struct rq *this_rq, struct task_struct *task);

awesome, one method less ;-)

> +#ifdef CONFIG_SMP
> +
> +/* assumes rq->lock is held */
> +static inline void pre_schedule(struct rq *rq, struct task_struct *prev)
> +{
> +	if (prev->sched_class->pre_schedule)
> +		prev->sched_class->pre_schedule(rq, prev);
> +}
> +
> +/* rq->lock is NOT held, but preemption is disabled */
> +static inline void post_schedule(struct rq *rq)
> +{
> +	if (rq->post_schedule) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&rq->lock, flags);
> +		if (rq->curr->sched_class->post_schedule)
> +			rq->curr->sched_class->post_schedule(rq);
> +		spin_unlock_irqrestore(&rq->lock, flags);
> +
> +		rq->post_schedule = 0;
> +	}
> +}
> +
> +#else
>  
> -	return post_schedule;
> +static inline void pre_schedule(struct rq *rq, struct task_struct *p)
> +{
> +}
> +
> +static inline void post_schedule(struct rq *rq)
> +{
>  }
>  
> +#endif

Wouldn't you sleep much safer at night if both versions were to check
those assumptions under SCHED_DEBUG? :-)

> @@ -2844,14 +2873,14 @@ asmlinkage void schedule_tail(struct task_struct *prev)
>  	__releases(rq->lock)
>  {
>  	struct rq *rq = this_rq();
> -	int post_schedule;
>  
> -	post_schedule = finish_task_switch(rq, prev);
> +	finish_task_switch(rq, prev);
>  
> -#ifdef CONFIG_SMP
> -	if (post_schedule)
> -		current->sched_class->post_schedule(rq);
> -#endif
> +	/*
> +	 * FIXME: do we need to worry about rq being invalidated by the
> +	 * task_switch?
> +	 */
> +	post_schedule(rq);
>  
>  #ifdef __ARCH_WANT_UNLOCKED_CTXSW
>  	/* In this case, finish_task_switch does not reenable preemption */

You know I really can't take patches with FIXME's in ;-)

I think only switch_to() messes with your stacks, finish_task_switch()
should be safe, but double check me.


OK, so I stuck the patch in anyway.. 
