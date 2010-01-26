Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560Ab0AZIqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0AZIqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 03:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575Ab0AZIp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 03:45:58 -0500
Received: from www.tglx.de ([62.245.132.106]:40219 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab0AZIp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 03:45:57 -0500
Date: Tue, 26 Jan 2010 09:45:10 +0100 (CET)
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
Message-ID: <alpine.LFD.2.00.1001260933520.5926@localhost.localdomain>
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

I'm not really excited happy about adding a race condition :) 

If you stop the kernel in the middle of the watchdog code
(i.e. watchdog_lock is held) then clocksource_reset_watchdog() is not
really a guarantee to keep the TSC alive.
 
>  void clocksource_touch_watchdog(void)
>  {
> -	clocksource_resume_watchdog();
> +	unsigned long flags;
> +
> +	int got_lock = spin_trylock_irqsave(&watchdog_lock, flags);

So I prefer

	if (!spin_trylock_irqsave(&watchdog_lock, flags))
		return;

If that results in TSC being marked unstable then that is way better
than having a race which might even crash or lock the machine when the
stop happened in the middle of a list_add().

Thanks,

	tglx
