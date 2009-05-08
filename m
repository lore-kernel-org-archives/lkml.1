Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbZEHAyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbZEHAyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZEHAyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:54:20 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54566 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbZEHAyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:54:18 -0400
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep 
 formore than 2.15 seconds
From: john stultz <johnstul@us.ibm.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A02F5A3.3050004@ti.com>
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>
	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com>
	 <1240358525.6080.40.camel@localhost>  <4A02F5A3.3050004@ti.com>
Content-Type: text/plain
Date: Thu, 07 May 2009 17:54:08 -0700
Message-Id: <1241744048.7518.132.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-07 at 09:52 -0500, Jon Hunter wrote:
> john stultz wrote:
> > So yes, while your patch in of itself doesn't create the issue, it does
> > open the window a bit more. I'm just saying we need to add the
> > clocksource limiting factor in before more odd configs trip over it. :)
> 
> Thanks, this helps. I have been looking into this some more and it seems 
> to me that the appropriate place in the tick_nohz_stop_sched_tick() 
> function to check the clocksource upper limit would be in the following 
> code segment:
> 
> 	/* Read jiffies and the time when jiffies were updated last */
>           do {
>                   seq = read_seqbegin(&xtime_lock);
>                   last_update = last_jiffies_update;
>                   last_jiffies = jiffies;
>           } while (read_seqretry(&xtime_lock, seq));
> 
>           /* Get the next timer wheel timer */
>           next_jiffies = get_next_timer_interrupt(last_jiffies);
>           delta_jiffies = next_jiffies - last_jiffies;
> 
> 
> Here is my thinking...
> 
> 1). The above do-while is holding the xtime_lock for updating a couple 
> variables. Given that we would need to hold this lock when querying the 
> max time that the clocksource can be deferred it would seem to make 
> sense to do it in this same loop to avoid requesting the same lock twice 
> in the same function.

Yep. It would be easy to pull:
	max_time_delta = timekeeping_max_deferment()
when you read jiffies.


> 2). The function "get_next_timer_interrupt()" returns the time of when 
> the next timer event is due to expire. If we know the maximum number of 
> jiffies that can elapse before the clocksource wraps, then we can simply 
> compare delta_jiffies with the maximum jiffies for the clocksource and 
> adjust delta_jiffies if it is greater than the maximum jiffies.

Urr. Lets move away from jiffies. Jiffies bad. Human time good.

Its easy to get the max value in ns right now, last_update is already a
ktime_t. 

I think checking if expires (little bit lower in the same function) is
larger then (last_update + max_time_delta) would be much much simpler.


> 3). The maximum jiffies that can elapse before a clocksource wraps 
> should be a constant value which can be derived from the clocksource 
> mask value. Therefore, I was thinking that it would be more 
> efficient/optimal to calculate the maximum jiffies that can elapse 
> before the clocksource wraps when the clocksource is registered and 
> store it in the main clocksource structure.

Yeeks. No, lets not do this. Cluttering up the clocksource with jiffies
values is totally unnecessary.


> So taking the above into account, I was thinking of something along the 
> lines of the following. Let me know if you have any thoughts/comments.
> 
> Cheers
> Jon
> 
> 
> Signed-off-by: Jon Hunter <jon-hunter@ti.com>


So while I really don't like your patch, I think you have the right
idea. Just keep things in nanoseconds, rather then converting them to
jiffies first. It will be much simpler patch and won't affect as much
code.

Look at the simple accessor patch I sent earlier:
http://lkml.indiana.edu/hypermail/linux/kernel/0901.3/02693.html

You could require the xtime_lock be held while calling to doge grabbing
it twice and plug it right in.

thanks
-john

