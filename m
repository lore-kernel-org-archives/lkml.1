Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbXGQNFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbXGQNFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764680AbXGQNFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:05:35 -0400
Received: from mail.screens.ru ([213.234.233.54]:54849 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764415AbXGQNFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:05:34 -0400
Date: Tue, 17 Jul 2007 17:07:05 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeremy Katz <jeremy.katz@windriver.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>
Subject: Re: [PATCH] posix-timer: fix deletion race
Message-ID: <20070717130705.GA74@tv-sign.ru>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain> <1184662429.12353.426.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184662429.12353.426.camel@chaos>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17, Thomas Gleixner wrote:
>
> Jeremy Katz experienced a posix-timer related bug on 2.6.14. This is
> caused by a subtle race, which is there since the original posix timer
> commit and persists until today.
> 
> timer_delete does:
> lock_timer();
> timer->it_process = NULL;
> unlock_timer();
> release_posix_timer();
> 
> timer->it_process is checked in lock_timer() to prevent access to a
> timer, which is on the way to be deleted, but the check happens after
> idr_lock is dropped. This allows release_posix_timer() to delete the
> timer before the lock code can check the timer:
> 
> CPU 0				CPU 1
> lock_timer();			
> timer->it_process = NULL;
> unlock_timer();
> 				lock_timer()
> 					spin_lock(idr_lock);
> 					timer = idr_find();
> 					spin_lock(timer->lock);
> 					spin_unlock(idr_lock);
> release_posix_timer();
> 	spin_lock(idr_lock);
> 	idr_remove(timer);
> 	spin_unlock(idr_lock);
> 	free_timer(timer);
> 					if (timer->......)

This is funny. I do remember this bug was discussed a couple of years ago,
and the conclusion was "we can fix it later" :)

> --- a/kernel/posix-timers.c
> +++ b/kernel/posix-timers.c
> @@ -605,13 +605,14 @@ static struct k_itimer * lock_timer(timer_t timer_id, unsigned long *flags)
>  	timr = (struct k_itimer *) idr_find(&posix_timers_id, (int) timer_id);
>  	if (timr) {
>  		spin_lock(&timr->it_lock);
> -		spin_unlock(&idr_lock);
>  
>  		if ((timr->it_id != timer_id) || !(timr->it_process) ||
>  				timr->it_process->tgid != current->tgid) {
> -			unlock_timer(timr, *flags);
> +			spin_unlock(&timr->it_lock);
> +			spin_unlock_irqrestore(&idr_lock, *flags);
>  			timr = NULL;
> -		}
> +		} else
> +			spin_unlock(&idr_lock);
>  	} else
>  		spin_unlock_irqrestore(&idr_lock, *flags);

I think we can make a simpler patch,

--- posix-timers.c~	2007-06-29 14:45:04.000000000 +0400
+++ posix-timers.c	2007-07-17 16:59:45.000000000 +0400
@@ -449,6 +449,9 @@ static void release_posix_timer(struct k
 		idr_remove(&posix_timers_id, tmr->it_id);
 		spin_unlock_irqrestore(&idr_lock, flags);
 	}
+
+	spin_unlock_wait(tmr->it_lock);
+
 	sigqueue_free(tmr->sigq);
 	if (unlikely(tmr->it_process) &&
 	    tmr->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))


What do you think? Instead of complicating the lock_timer(), release_posix_timer()
just makes sure that nobody can "use" tmr.

(Actually, I am not sure this is my idea, perhaps something like above was suggested
 by somebody else, I forgot the discussion completely).

Oleg.

