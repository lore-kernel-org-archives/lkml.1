Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbYDBQC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbYDBQC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbYDBQB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:01:57 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37360 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072AbYDBQB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:01:56 -0400
Subject: Re: [PATCH 2/2] Introduce CLOCK_MONOTONIC_RAW
From: John Stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0804021340290.26791@localhost.localdomain>
References: <1205878279.28128.114.camel@localhost>
	 <1205878420.28128.117.camel@localhost>
	 <Pine.LNX.4.64.0804021340290.26791@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 09:01:51 -0700
Message-Id: <1207152111.6211.13.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-02 at 13:50 +0200, Roman Zippel wrote:
> Hi,
> 
> On Tue, 18 Mar 2008, john stultz wrote:
> 
> > My solution is to introduce CLOCK_MONOTONIC_RAW. This exposes a
> > nanosecond based time value, that increments starting at bootup and has
> > no frequency adjustments made to it what so ever.
> > 
> > The time is accessed from userspace via the posix_clock_gettime()
> > syscall, passing CLOCK_MONOTONIC_RAW as the clock_id.
> 
> This is a reworked version of this patch based on the previous 
> clocksource_forward_now patch, since clocksource_forward_now() takes 
> care of the time offset now, it's not needed to do this at various places.
> I also got rid of the monotonic_raw splitting, so the work done during 
> update_wall_time() is quite a bit simpler.
> 
> bye, Roman
> 
> Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
> 
> ---
>  include/linux/clocksource.h |    5 ++++
>  include/linux/time.h        |    2 +
>  kernel/posix-timers.c       |   15 ++++++++++++++
>  kernel/time/timekeeping.c   |   47 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 69 insertions(+)
> 
> Index: linux-2.6/include/linux/clocksource.h
> ===================================================================
> --- linux-2.6.orig/include/linux/clocksource.h
> +++ linux-2.6/include/linux/clocksource.h
> @@ -79,6 +79,7 @@ struct clocksource {
>  	/* timekeeping specific data, ignore */
>  	cycle_t cycle_interval;
>  	u64	xtime_interval;
> +	u64	raw_interval;
>  	/*
>  	 * Second part is written at each timer interrupt
>  	 * Keep it in a different cache line to dirty no
> @@ -87,6 +88,8 @@ struct clocksource {
>  	cycle_t cycle_last ____cacheline_aligned_in_smp;
>  	u64 xtime_nsec;
>  	s64 error;
> +	u64 raw_nsec;
> +	long raw_sec;


So, with the raw_sec being stored in the clocksource, and there not
being a monotonic_raw value, doesn't this mean the MONOTONIC_RAW value
will clear to zero on clocksource changes? 


>  #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
>  	/* Watchdog related data, used by the framework */
> @@ -215,6 +218,8 @@ static inline void clocksource_calculate
> 
>  	/* Go back from cycles -> shifted ns, this time use ntp adjused mult */
>  	c->xtime_interval = (u64)c->cycle_interval * c->mult;
> +	c->raw_interval = ((u64)c->cycle_interval * c->mult_orig) <<
> +			  (NTP_SCALE_SHIFT - c->shift);
>  }

Could you explain further how this extra shift scaling is beneficial?
(Additionally, if we're using it for more then just NTP's shift, we
might want to change its name).

thanks
-john

