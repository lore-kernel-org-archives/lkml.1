Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbZFBWZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbZFBWZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbZFBWYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:24:50 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58640 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZFBWYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:24:48 -0400
Subject: Re: [PATCH] sched: sched_clock() clocksource handling.
From: john stultz <johnstul@us.ibm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090602071718.GA17710@linux-sh.org>
References: <20090602071718.GA17710@linux-sh.org>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 15:24:45 -0700
Message-Id: <1243981485.3501.92.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-02 at 16:17 +0900, Paul Mundt wrote:
> As there was no additional feedback on the most recent version of this
> patch, I'm resubmitting it for inclusion. As far as I know there are no
> more outstanding concerns.
> 
> --
> 
> sched: sched_clock() clocksource handling.
> 
> There are presently a number of issues and limitations with how the
> clocksource and sched_clock() interaction works today. Configurations
> tend to be grouped in to one of the following:
> 
>     - Platform provides a clocksource unsuitable for sched_clock()
>       and prefers to use the generic jiffies-backed implementation.
> 
>     - Platform provides its own clocksource and sched_clock() that
>       wraps in to it.
> 
>     - Platform uses a generic clocksource (ie, drivers/clocksource/)
>       combined with the generic jiffies-backed sched_clock().
> 
>     - Platform supports multiple sched_clock()-capable clocksources.
> 
> This patch adds a new CLOCK_SOURCE_USE_FOR_SCHED_CLOCK flag to address
> these issues, which can be set for any sched_clock()-capable clocksource.
> 
> The generic sched_clock() implementation is likewise switched over to
> always read from a designated sched_clocksource, which is default
> initialized to the jiffies clocksource and updated based on the
> availability of CLOCK_SOURCE_USE_FOR_SCHED_CLOCK sources. As this uses
> the generic cyc2ns() logic on the clocksource ->read(), most of the
> platform-specific sched_clock() implementations can subsequently be
> killed off.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Yea, I think this is nicer then your earlier patch. Thanks for reworking
it. Although there are a few concerns though that came up from an email
with Peter:

From: 	Peter Zijlstra <peterz@infradead.org>
"
> 2) How long does it have to be monotonic for? 

Forever? (per cpu)

> Is it ok if it wraps every few seconds?

No, if it wraps it needs to wrap on u64.
"


>  /*
>   * Scheduler clock - returns current time in nanosec units.
> @@ -38,8 +40,15 @@
>   */
>  unsigned long long __attribute__((weak)) sched_clock(void)
>  {
> -	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
> -					* (NSEC_PER_SEC / HZ);
> +	unsigned long long time;
> +	struct clocksource *clock;
> +
> +	rcu_read_lock();
> +	clock = rcu_dereference(sched_clocksource);
> +	time = cyc2ns(clock, clocksource_read(clock));
> +	rcu_read_unlock();
> +
> +	return time;
>  }

So in the above, cyc2ns could overflow prior to a u64 wrap. 


cyc2ns does the following:
	(cycles * cs->mult) >> cs->shift;

The (cycles*cs->mult) bit may overflow for large cycle values, and its
likely that could be fairly quickly, as ideally we have a large shift
value to keep the precision high so mult will also be large.

I just went through some of the math here with Jon Hunter in this
thread: http://lkml.org/lkml/2009/5/15/466

None the less, either sched_clock will have to handle overflows or we'll
need to do something like the timekeeping code where there's an periodic
accumulation step that keeps the unaccumulated cycles small.

That said, the x86 sched_clock() uses cycles_2_ns() which is similar
(but with a smaller scale value). So its likely it would also overflow
prior to the u64 boundary as well.


> diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
> index c3f6c30..727d881 100644
> --- a/kernel/time/jiffies.c
> +++ b/kernel/time/jiffies.c
> @@ -52,7 +52,7 @@
> 
>  static cycle_t jiffies_read(struct clocksource *cs)
>  {
> -	return (cycle_t) jiffies;
> +	return (cycle_t) (jiffies - INITIAL_JIFFIES);
>  }

Also, on 32bit systems this will may overflow ~monthly. However, this
isn't different then the existing sched_clock() implementation, so
either its been already handled and sched_clock is more robust then I
thought or there's a bug there.

thanks
-john


