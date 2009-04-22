Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbZDVACY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbZDVACY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 20:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbZDVACP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 20:02:15 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60113 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZDVACO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 20:02:14 -0400
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep for
 more than 2.15 seconds
From: john stultz <johnstul@us.ibm.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <49EE54B4.9020700@ti.com>
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>
	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 17:02:05 -0700
Message-Id: <1240358525.6080.40.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-21 at 18:20 -0500, Jon Hunter wrote:
> john stultz wrote:
> > The concern is many clocksources wrap after a handful of seconds. The
> > acpi_pm is the best example (its only 24 bits wide). 
> > 
> > I brought this issue up earlier, and provided some example code that
> > could be used to limit the idle time appropriately for the current
> > clocksource here:
> > 
> > http://lkml.indiana.edu/hypermail/linux/kernel/0901.3/02693.html
> > 
> > Jon: Did you see that mail, or is there a reason you didn't adapt this
> > code into your patch? 
> 
> Hi John, yes I did read this email and thanks for bringing this up.
> 
> As I looked at this more I noticed that for 64-bit machines that the 
> max_delta_ns would be a 64-bit integer already and so this change would 
> only have an impact for 32-bit machines. I understand that there are 
> more 32-bit machines that 64-bit. However, I was trying to understand 
> how the wrapping of clocksources, such as the one you mention above, is 
> handled today for 64-bit machines that could theoretically sleep for 
> longer periods.

As the actual max_delta_ns currently comes from the clockevent driver,
that is our current limitation. For instance, on a box I'm using, the
lapic's max_delta_ns is a little more then 600ms. The HPET's does allow
for ~149sec timers, which would break with acpi_pm, but I suspect boxes
using the HPET for tick interrupts are currently using HPET for the
clocksource as well, which keeps it safe.

So I suspect its mostly luck that system configs don't hit the issue
that's saved us so far on 64bit boxes.

So yes, while your patch in of itself doesn't create the issue, it does
open the window a bit more. I'm just saying we need to add the
clocksource limiting factor in before more odd configs trip over it. :)


> In addition to this as I was reviewing the "tick_nohz_stop_sched_tick()" 
> function that is configuring the dynamic tick and I noticed that this 
> code would actually stop the timer altogether if the time for the next 
> timer event is greater than NEXT_TIMER_MAX_DELTA jiffies. See code 
> snippet below. This is very unlikely, however, if this scenario was to 
> occur what would be the impact on the clocksource?
> 
>            /*
>            * delta_jiffies >= NEXT_TIMER_MAX_DELTA signals that
>            * there is no timer pending or at least extremly far 
> 
>            * into the future (12 days for HZ=1000). In this case
>            * we simply stop the tick timer:
>            */
>            if (unlikely(delta_jiffies >= NEXT_TIMER_MAX_DELTA)) {
>                    ts->idle_expires.tv64 = KTIME_MAX;
>                    if (ts->nohz_mode == NOHZ_MODE_HIGHRES)
>                            hrtimer_cancel(&ts->sched_timer);
>                    goto out;
>            }

Fair point. Thomas? Why do we kill the timer in the above case? Can that
catch us on an UP box? If so what would ever wake us up if there were no
other system interrupts?

thanks
-john




