Return-Path: <linux-kernel-owner+w=401wt.eu-S938459AbXHLT7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938459AbXHLT7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 15:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933285AbXHLT7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 15:59:11 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41215 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936897AbXHLT7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 15:59:10 -0400
Date: Sun, 12 Aug 2007 23:59:04 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 2/4] posix-timers: fix creation race
Message-ID: <20070812195904.GB113@tv-sign.ru>
References: <20070812170522.GA4299@tv-sign.ru> <1186945555.12828.89.camel@chaos> <20070812194455.GA113@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812194455.GA113@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12, Oleg Nesterov wrote:
>
> > > -				spin_unlock_irqrestore(&process->sighand->siglock, flags);
> > >  				process = NULL;
> > >  			}
> > > +			spin_unlock_irqrestore(&process->sighand->siglock, flags);
> 
> i'll resend this patch tomorrow. We can't do spin_unlock_irqrestore(&process->...)
> if we set process = NULL above.

Another attempt, no cleanups, just a minimal fix for now.


[PATCH 2/4] posix-timers: fix creation race

sys_timer_create() sets ->it_process and unlocks ->siglock, then checks
tmr->it_sigev_notify to define if get_task_struct() is needed.

We already passed ->it_id to the caller, another thread can delete this
timer and free its memory in between.

As a minimal fix, move this code under ->siglock, sys_timer_delete() takes
it too before calling release_posix_timer(). A proper serialization would
be to take ->it_lock, we add a partly initialized timer on posix_timers_id,
not good.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/posix-timers.c~	2007-08-12 23:50:46.000000000 +0400
+++ t/kernel/posix-timers.c	2007-08-12 23:52:07.000000000 +0400
@@ -547,9 +547,9 @@ sys_timer_create(const clockid_t which_c
 				new_timer->it_process = process;
 				list_add(&new_timer->list,
 					 &process->signal->posix_timers);
-				spin_unlock_irqrestore(&process->sighand->siglock, flags);
 				if (new_timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
 					get_task_struct(process);
+				spin_unlock_irqrestore(&process->sighand->siglock, flags);
 			} else {
 				spin_unlock_irqrestore(&process->sighand->siglock, flags);
 				process = NULL;

