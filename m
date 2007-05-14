Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbXENS73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbXENS73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 14:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbXENS7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 14:59:23 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752318AbXENS7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 14:59:22 -0400
Date: Mon, 14 May 2007 11:58:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tglx@linutronix.de
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] timekeeping fix mismerge
Message-Id: <20070514115835.19be36d0.akpm@linux-foundation.org>
In-Reply-To: <1179133802.22481.327.camel@localhost.localdomain>
References: <1179133802.22481.327.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 11:10:02 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> The time keeping code move to kernel/time/timekeeping.c broke the
> clocksource resume logic patch. Fix it up and move the
> clocksource_resume() call to the appropriate place.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index f9217bf..3d1042f 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -273,6 +273,8 @@ static int timekeeping_resume(struct sys_device *dev)
>  	unsigned long flags;
>  	unsigned long now = read_persistent_clock();
>  
> +	clocksource_resume();
> +
>  	write_seqlock_irqsave(&xtime_lock, flags);
>  
>  	if (now && (now > timekeeping_suspend_time)) {
> diff --git a/kernel/timer.c b/kernel/timer.c
> index a6c580a..5ec5490 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1499,8 +1499,6 @@ unregister_time_interpolator(struct time_interpolator *ti)
>  		prev = &curr->next;
>  	}
>  
> -	clocksource_resume();
> -
>  	write_seqlock_irqsave(&xtime_lock, flags);
>  	if (ti == time_interpolator) {
>  		/* we lost the best time-interpolator: */
> 

Urgh, that was probably me trying to manage the maelstrom from a million
monkeys mucking in the same code for multiple months, sigh.

So what do "broke" and "fix" mean in this context?  What are the
consequences of this bug, and of its fix?  Is the above appropriate for
2.6.21.x and if so why?

Thanks.
