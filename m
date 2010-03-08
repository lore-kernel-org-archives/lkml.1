Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab0CHVWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:22:16 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51626 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab0CHVWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:22:14 -0500
Subject: Re: [RESEND][PATCH] Fix oops on !GENERIC_TIME systems when
 accessing current_clocksource
From: john stultz <johnstul@us.ibm.com>
To: greg kh <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>, stable@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, aaro.koskinen@iki.fi,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1267475683.4216.61.camel@localhost.localdomain>
References: <1267475683.4216.61.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 13:22:07 -0800
Message-ID: <1268083327.3726.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-01 at 12:34 -0800, john stultz wrote:
> No one has replied to this, so I wanted to send it out again.

Just another ping here. I know the patch has made it to -tip, but its
something that should be needed for 2.6.34, 2.6.33-stable.

thanks
-john


> Aaro Koskinen reported an issue in bug #15366, where on non-GENERIC_TIME
> systems,
> accessing /sys/devices/system/clocksource/clocksource0/current_clocksource would oops the system. 
> 
> It seems the timekeeper/clocksource rework missed initializing the
> curr_clocksource value in the !GENERIC_TIME.
> 
> The following patch makes sure it gets initialized, and avoids the
> issue.
> 
> Thanks to Aaro for reporting and diagnosing the issue as well as testing
> the fix!
> 
> Bug Details: http://bugzilla.kernel.org/show_bug.cgi?id=15366
> 
> Too late for 2.6.33, but this likely should go into 2.6.33-stable and
> 2.6.32-stable.
> 
> thanks
> -john
> 
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index e85c234..c436ee5 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -568,6 +568,10 @@ static inline void clocksource_select(void) { }
>   */
>  static int __init clocksource_done_booting(void)
>  {
> +	mutex_lock(&clocksource_mutex);
> +	curr_clocksource = clocksource_default_clock();
> +	mutex_unlock(&clocksource_mutex);
> +
>  	finished_booting = 1;
>  
>  	/*
> 
> 


