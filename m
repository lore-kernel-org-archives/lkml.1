Return-Path: <linux-kernel-owner+w=401wt.eu-S933337AbXGQURT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337AbXGQURT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXGQURL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:17:11 -0400
Received: from www.osadl.org ([213.239.205.134]:54182 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755213AbXGQURK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:17:10 -0400
Subject: Re: [PATCH] posix-timer: fix deletion race
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Katz <jeremy.katz@windriver.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Stable Team <stable@kernel.org>
In-Reply-To: <Pine.LNX.4.63.0707171131580.10358@localhost.localdomain>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain>
	 <1184662429.12353.426.camel@chaos>
	 <Pine.LNX.4.63.0707171131580.10358@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 22:17:07 +0200
Message-Id: <1184703427.12353.476.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 11:39 -0700, Jeremy Katz wrote:
> I tried the patch with my test case, but still see the issue.
> Here's my explanation of the double free race:
> CPU 0					CPU 1
> sys_timer_delete():
>  	lock_timer();
>  	...
>  	unlock_timer();			itimer_delete()
>  	release_posix_timer():			spin_lock_irqsave(timer...)
>  		...				...
>  		sigqueue_free()			unlock_timer()
>  		...				sigqueue_free()
>  							BUG_ON(!(q->flags...

With 2.6.14 or with current mainline ?

I doubt that this can happen, as itimer_delete() is only called, when
there are no more references to the shared sig struct. At this point no
other related thread can run sys_timer_delete(). 

If this happens, then something else is completely broken.

> the timer fires during deletion:
> CPU 0					CPU 1
> sys_timer_delete():
>  	lock_timer();
>  	...
>  	unlock_timer();			posix_timer_fn()
>  	release_posix_timer():			spin_lock_irqsave(timer...)
>  		...				...
>  		sigqueue_free()			posix_timer_event()
>  		...					...
>  							send_sigqueue()
>  								BUG_ON(!(q->flags
> 

I do not buy that either. In sys_timer_delete() the active timer is
canceled. If we can not cancel it then we retry until the timer callback
has been processed. This is even true for 2.6.14 (pre hrtimer).

> --- linux-2.6.14-cgl.original/kernel/posix-timers.c	2007-07-11 16:06:47.000000000 -0700
> +++ linux-2.6.14-cgl/kernel/posix-timers.c	2007-07-16 15:25:43.000000000 -0700
> @@ -339,7 +339,9 @@ static int posix_timer_fn(void *data)
>   	int si_private = 0;
>   	int ret = HRTIMER_NORESTART;
> 
> -	spin_lock_irqsave(&timr->it_lock, flags);
> +	if(lock_timer(timr->it_id, &flags) == NULL) {
> +		return ret;
> +	}

This is wrong. You look at something which is not valid anymore, if your
theory is correct. You are just pampering over the real bug.

> @@ -835,7 +844,9 @@ static inline void itimer_delete(struct
>   	unsigned long flags;
> 
>   retry_delete:
> -	spin_lock_irqsave(&timer->it_lock, flags);
> +	/* timer already deleted? */
> +	if (lock_timer(timer->it_id, &flags) == NULL)
> +		return;

Same here.

Can you reproduce the problem against mainline + my patch applied ?

	tglx


