Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbXKZX1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbXKZX1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbXKZX1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:27:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50576 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756069AbXKZX1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:27:31 -0500
Date: Mon, 26 Nov 2007 15:26:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] softlockup: do the wakeup from a hrtimer
Message-Id: <20071126152652.8db2793a.akpm@linux-foundation.org>
In-Reply-To: <20071120084611.GA18721@elte.hu>
References: <20071120084611.GA18721@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 09:46:11 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> Subject: softlockup: do the wakeup from a hrtimer
> From: Ingo Molnar <mingo@elte.hu>
> 
> David Miller reported soft lockup false-positives that trigger on NOHZ 
> due to CPUs idling for more than 10 seconds.
> 
> The solution is to drive the wakeup of the watchdog threads not from the 
> timer tick (which has no guaranteed frequency), but from the watchdog 
> tasks themselves.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9409
> 
> Reported-by: David Miller <davem@davemloft.net>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/softlockup.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> Index: linux/kernel/softlockup.c
> ===================================================================
> --- linux.orig/kernel/softlockup.c
> +++ linux/kernel/softlockup.c
> @@ -100,10 +100,6 @@ void softlockup_tick(void)
>  
>  	now = get_timestamp(this_cpu);
>  
> -	/* Wake up the high-prio watchdog task every second: */
> -	if (now > (touch_timestamp + 1))
> -		wake_up_process(per_cpu(watchdog_task, this_cpu));
> -
>  	/* Warn about unreasonable 10+ seconds delays: */
>  	if (now <= (touch_timestamp + softlockup_thresh))
>  		return;
> @@ -141,7 +137,7 @@ static int watchdog(void *__bind_cpu)
>  	while (!kthread_should_stop()) {
>  		set_current_state(TASK_INTERRUPTIBLE);
>  		touch_softlockup_watchdog();
> -		schedule();
> +		msleep(1000);
>  	}
>  
>  	return 0;

I think you wanted msleep_interruptible() there to avoid contributing to
load average?

The set_current_state() can go away.

This will introduce an up-to-one-second delay in responding to
kthread_should_stop().  Is that bad?
