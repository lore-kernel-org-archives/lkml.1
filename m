Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229Ab0ARJ61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0ARJ61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 04:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101Ab0ARJ6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 04:58:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40375 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0ARJ6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 04:58:24 -0500
Subject: Re: [PATCH 06/40] sched: add wakeup/sleep sched_notifiers and
 allow NULL notifier ops
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <1263776272-382-7-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	 <1263776272-382-7-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 10:57:13 +0100
Message-ID: <1263808633.4283.152.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 09:57 +0900, Tejun Heo wrote:

> @@ -2439,6 +2440,8 @@ static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
>  		rq->idle_stamp = 0;
>  	}
>  #endif
> +	if (success)
> +		fire_sched_notifiers(p, wakeup);
>  }
>  
>  /**

So why can't you call fire_sched_notifier(p, wakeup) right next to
activate_task(rq, p, 1) in ttwu_activate() ?

> @@ -5481,10 +5484,12 @@ need_resched_nonpreemptible:
>  	clear_tsk_need_resched(prev);
>  
>  	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
> -		if (unlikely(signal_pending_state(prev->state, prev)))
> +		if (unlikely(signal_pending_state(prev->state, prev))) {
>  			prev->state = TASK_RUNNING;
> -		else
> +		} else {
> +			fire_sched_notifiers(prev, sleep);
>  			deactivate_task(rq, prev, 1);
> +		}
>  		switch_count = &prev->nvcsw;
>  	}
>  


