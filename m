Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129Ab0AZKn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab0AZKn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 05:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890Ab0AZKn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 05:43:57 -0500
Received: from www.tglx.de ([62.245.132.106]:56757 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab0AZKn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 05:43:56 -0500
Date: Tue, 26 Jan 2010 11:43:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jason Wessel <jason.wessel@windriver.com>
cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       John Stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Magnus Damm <damm@igel.co.jp>
Subject: Re: [PATCH 3/4] kgdb,clocksource: Prevent kernel hang in kernel
 debugger
In-Reply-To: <1264480000-6997-4-git-send-email-jason.wessel@windriver.com>
Message-ID: <alpine.LFD.2.00.1001261142280.5926@localhost.localdomain>
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com> <1264480000-6997-4-git-send-email-jason.wessel@windriver.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010, Jason Wessel wrote:
> This is a regression fix against: 0f8e8ef7c204988246da5a42d576b7fa5277a8e4
> 
> Spin locks were added to the clocksource_resume_watchdog() which cause
> the kernel debugger to deadlock on an SMP system frequently.
> 
> The kernel debugger can try for the lock, but if it fails it should
> continue to touch the clocksource watchdog anyway, else it will trip
> if the general kernel execution has been paused for too long.
> 
> This introduces an possible race condition where the kernel debugger
> might not process the list correctly if a clocksource is being added
> or removed at the time of this call.  This race is sufficiently rare vs
> having the kernel debugger hang the kernel
> 
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
> CC: John Stultz <johnstul@us.ibm.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Magnus Damm <damm@igel.co.jp>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  kernel/time/clocksource.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index e85c234..74f9ba6 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -463,7 +463,12 @@ void clocksource_resume(void)
>   */
>  void clocksource_touch_watchdog(void)
>  {
> -	clocksource_resume_watchdog();
> +	unsigned long flags;
> +
> +	int got_lock = spin_trylock_irqsave(&watchdog_lock, flags);
> +	clocksource_reset_watchdog();
> +	if (got_lock)
> +		spin_unlock_irqrestore(&watchdog_lock, flags);

Just for the record. This patch would not compile on any platform
which has CONFIG_CLOCKSOURCE_WATCHDOG=n

Thanks,

	tglx
