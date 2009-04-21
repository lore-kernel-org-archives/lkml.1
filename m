Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbZDUXVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbZDUXVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 19:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZDUXU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 19:20:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46381 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbZDUXU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 19:20:57 -0400
Message-ID: <49EE54B4.9020700@ti.com>
Date: Tue, 21 Apr 2009 18:20:20 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep for
 more than 2.15 seconds
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu> <1240345936.6080.6.camel@localhost>
In-Reply-To: <1240345936.6080.6.camel@localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


john stultz wrote:
> The concern is many clocksources wrap after a handful of seconds. The
> acpi_pm is the best example (its only 24 bits wide). 
> 
> I brought this issue up earlier, and provided some example code that
> could be used to limit the idle time appropriately for the current
> clocksource here:
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0901.3/02693.html
> 
> Jon: Did you see that mail, or is there a reason you didn't adapt this
> code into your patch? 

Hi John, yes I did read this email and thanks for bringing this up.

As I looked at this more I noticed that for 64-bit machines that the 
max_delta_ns would be a 64-bit integer already and so this change would 
only have an impact for 32-bit machines. I understand that there are 
more 32-bit machines that 64-bit. However, I was trying to understand 
how the wrapping of clocksources, such as the one you mention above, is 
handled today for 64-bit machines that could theoretically sleep for 
longer periods.

In addition to this as I was reviewing the "tick_nohz_stop_sched_tick()" 
function that is configuring the dynamic tick and I noticed that this 
code would actually stop the timer altogether if the time for the next 
timer event is greater than NEXT_TIMER_MAX_DELTA jiffies. See code 
snippet below. This is very unlikely, however, if this scenario was to 
occur what would be the impact on the clocksource?

           /*
           * delta_jiffies >= NEXT_TIMER_MAX_DELTA signals that
           * there is no timer pending or at least extremly far 

           * into the future (12 days for HZ=1000). In this case
           * we simply stop the tick timer:
           */
           if (unlikely(delta_jiffies >= NEXT_TIMER_MAX_DELTA)) {
                   ts->idle_expires.tv64 = KTIME_MAX;
                   if (ts->nohz_mode == NOHZ_MODE_HIGHRES)
                           hrtimer_cancel(&ts->sched_timer);
                   goto out;
           }

I understand that clocksources need to be handled correctly, but as I 
looked into this more I wanted to clarify how this is handled today for 
64-bit machines. I appreciate your comments and feedback.

Cheers
Jon
