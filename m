Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605Ab0AZEhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0AZEhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 23:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535Ab0AZEht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 23:37:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754478Ab0AZEht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 23:37:49 -0500
Date: Mon, 25 Jan 2010 20:37:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       John Stultz <johnstul@us.ibm.com>, Magnus Damm <damm@igel.co.jp>
Subject: Re: [PATCH 3/4] kgdb,clocksource: Prevent kernel hang in kernel
 debugger
Message-Id: <20100125203706.740eb6d1.akpm@linux-foundation.org>
In-Reply-To: <1264480000-6997-4-git-send-email-jason.wessel@windriver.com>
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com>
	<1264480000-6997-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010 22:26:39 -0600 Jason Wessel <jason.wessel@windriver.com> wrote:

> This is a regression fix against: 0f8e8ef7c204988246da5a42d576b7fa5277a8e4

It's conventional to quote the patch title as well as the hash.  ie:

0f8e8ef7c204988246da5a42d576b7fa5277a8e4 ("clocksource: Simplify
clocksource watchdog resume logic")

> Spin locks were added to the clocksource_resume_watchdog() which cause
> the kernel debugger to deadlock on an SMP system frequently.

Please fully describe the deadlock.  Without that analysis, the only
way we can work it out is by guessing.  This makes it hard for others to
suggest alternative fixes.

> The kernel debugger can try for the lock, but if it fails it should
> continue to touch the clocksource watchdog anyway, else it will trip
> if the general kernel execution has been paused for too long.
> 
> This introduces an possible race condition where the kernel debugger
> might not process the list correctly if a clocksource is being added
> or removed at the time of this call.  This race is sufficiently rare vs
> having the kernel debugger hang the kernel

A trylock is a pretty ugly "solution" to a locking bug.

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
>  }

If we're going to do this then clocksource_reset_watchdog() should be
uninlined.  It shouldn't have been inlined in the first place.

This trylock should be accompanied with an explanation which fully
describes the reasons for its presence.  Without that, how can the
code reader work this out?

