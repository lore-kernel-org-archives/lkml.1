Return-Path: <linux-kernel-owner+w=401wt.eu-S938225AbXHLTou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938225AbXHLTou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 15:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937569AbXHLTol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 15:44:41 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:59339 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937364AbXHLTok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 15:44:40 -0400
Date: Sun, 12 Aug 2007 23:44:55 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 2/4] posix-timers: fix creation race
Message-ID: <20070812194455.GA113@tv-sign.ru>
References: <20070812170522.GA4299@tv-sign.ru> <1186945555.12828.89.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186945555.12828.89.camel@chaos>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12, Thomas Gleixner wrote:
>
> On Sun, 2007-08-12 at 21:05 +0400, Oleg Nesterov wrote:
> > sys_timer_create() sets ->it_process and unlocks ->siglock, then checks
> > tmr->it_sigev_notify to define if get_task_struct() is needed.
> > 
> > We already passed ->it_id to the caller, another thread can delete this
> > timer and free its memory in between.
> > 
> > As a minimal fix, move this code under ->siglock, sys_timer_delete() takes
> > it too before calling release_posix_timer(). A proper serialization would
> > be to take ->it_lock, we add a partly initialized timer on posix_timers_id,
> > not good.
> > 
> > Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>

Oooh, thanks, but...

> > --- t/kernel/posix-timers.c~2_CREATE	2007-08-12 17:59:17.000000000 +0400
> > +++ t/kernel/posix-timers.c	2007-08-12 18:11:33.000000000 +0400
> > @@ -547,13 +547,12 @@ sys_timer_create(const clockid_t which_c
> >  				new_timer->it_process = process;
> >  				list_add(&new_timer->list,
> >  					 &process->signal->posix_timers);
> > -				spin_unlock_irqrestore(&process->sighand->siglock, flags);
> >  				if (new_timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
> >  					get_task_struct(process);
> >  			} else {
> > -				spin_unlock_irqrestore(&process->sighand->siglock, flags);
> >  				process = NULL;
> >  			}
> > +			spin_unlock_irqrestore(&process->sighand->siglock, flags);

i'll resend this patch tomorrow. We can't do spin_unlock_irqrestore(&process->...)
if we set process = NULL above.

This all needs a cleanup anyway. The PF_EXITING check and related comment are
bogus.

Other patches do not depend on this one.

Oleg.

