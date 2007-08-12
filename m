Return-Path: <linux-kernel-owner+w=401wt.eu-S937836AbXHLTGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937836AbXHLTGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 15:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937494AbXHLTF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 15:05:58 -0400
Received: from www.osadl.org ([213.239.205.134]:33511 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937371AbXHLTF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 15:05:57 -0400
Subject: Re: [PATCH 2/4] posix-timers: fix creation race
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <20070812170522.GA4299@tv-sign.ru>
References: <20070812170522.GA4299@tv-sign.ru>
Content-Type: text/plain
Date: Sun, 12 Aug 2007 21:05:55 +0200
Message-Id: <1186945555.12828.89.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-12 at 21:05 +0400, Oleg Nesterov wrote:
> sys_timer_create() sets ->it_process and unlocks ->siglock, then checks
> tmr->it_sigev_notify to define if get_task_struct() is needed.
> 
> We already passed ->it_id to the caller, another thread can delete this
> timer and free its memory in between.
> 
> As a minimal fix, move this code under ->siglock, sys_timer_delete() takes
> it too before calling release_posix_timer(). A proper serialization would
> be to take ->it_lock, we add a partly initialized timer on posix_timers_id,
> not good.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> --- t/kernel/posix-timers.c~2_CREATE	2007-08-12 17:59:17.000000000 +0400
> +++ t/kernel/posix-timers.c	2007-08-12 18:11:33.000000000 +0400
> @@ -547,13 +547,12 @@ sys_timer_create(const clockid_t which_c
>  				new_timer->it_process = process;
>  				list_add(&new_timer->list,
>  					 &process->signal->posix_timers);
> -				spin_unlock_irqrestore(&process->sighand->siglock, flags);
>  				if (new_timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
>  					get_task_struct(process);
>  			} else {
> -				spin_unlock_irqrestore(&process->sighand->siglock, flags);
>  				process = NULL;
>  			}
> +			spin_unlock_irqrestore(&process->sighand->siglock, flags);
>  		}
>  		read_unlock(&tasklist_lock);
>  		if (!process) {
> 

