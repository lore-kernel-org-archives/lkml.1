Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967917Ab0B1MgV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 07:36:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966312Ab0B1MgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 07:36:20 -0500
Date: Sun, 28 Feb 2010 13:33:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 07/43] sched: implement try_to_wake_up_local()
Message-ID: <20100228123313.GA5495@redhat.com>
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267187000-18791-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wow ;)

I didn't read the whole series yet, still I'd like to ask a couple
of questions right now. Tejun, I am just trying to understand this
code.

On 02/26, Tejun Heo wrote:
>
> @@ -2438,6 +2438,10 @@ static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
>  		rq->idle_stamp = 0;
>  	}
>  #endif
> +	/*
> +	 * Wake up is complete, fire wake up notifier.  This allows
> +	 * try_to_wake_up_local() to be called from wake up notifiers.
> +	 */
>  	if (success)
>  		fire_sched_notifiers(p, wakeup);

Could you explain the comment? ttwu_post_activation() sets state = TASK_RUNNING
few lines above, what try_to_wake_up_local() can do if called from ->wakeup()
notifier ?

> +bool try_to_wake_up_local(struct task_struct *p, unsigned int state,
> +			  int wake_flags)
> +{
> ...
> +	if (!p->se.on_rq) {
> +		if (likely(!task_running(rq, p))) {
> +			schedstat_inc(rq, ttwu_count);
> +			schedstat_inc(rq, ttwu_local);
> +		}
> +		ttwu_activate(p, rq, wake_flags & WF_SYNC, false, true);
> +		success = true;
> +	}

Shouldn't try_to_wake_up_local() check task_contributes_to_load() to
account ->nr_uninterruptible?

> @@ -5498,6 +5549,11 @@ need_resched_nonpreemptible:
>  		if (unlikely(signal_pending_state(prev->state, prev))) {
>  			prev->state = TASK_RUNNING;
>  		} else {
> +			/*
> +			 * Fire sleep notifier before changing any scheduler
> +			 * state.  This allows try_to_wake_up_local() to be
> +			 * called from sleep notifiers.
> +			 */
>  			fire_sched_notifiers(prev, sleep);
>  			deactivate_task(rq, prev, 1);

Again, I don't understand the comment... If ->sleep() notifier wakes up
this task, we shouldn't do deactivate_task() ?

Probably both comment mean a notifier could wake up another task bound
to this rq, in this case it looks a bit confusing, imho.


Off-topic, but it is a bit sad wait_task_inactive() can not use ->sleep()
notifier to avoid schedule_timeout(), afaics we can't add the notifier
to !current task.

Oleg.

