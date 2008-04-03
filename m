Return-Path: <linux-kernel-owner+w=401wt.eu-S1759690AbYDCVXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759690AbYDCVXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbYDCVXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:23:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325AbYDCVXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:23:16 -0400
Date: Thu, 3 Apr 2008 14:07:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Introduce clocksource_forward_now
Message-Id: <20080403140732.9f30a501.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0804021322490.26791@localhost.localdomain>
References: <1205878279.28128.114.camel@localhost>
	<1205878420.28128.117.camel@localhost>
	<Pine.LNX.4.64.0804021322490.26791@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008 13:39:43 +0200 (CEST)
Roman Zippel <zippel@linux-m68k.org> wrote:

> Hi,
> 
> On Tue, 18 Mar 2008, john stultz wrote:
> 
> > My solution is to introduce CLOCK_MONOTONIC_RAW. This exposes a
> > nanosecond based time value, that increments starting at bootup and has
> > no frequency adjustments made to it what so ever.
> 
> There is a problem with the time offset since the last update_wall_time() 
> call, which isn't taken into account when switching clocks (possibly 
> during suspend/resume too), so that the clock might jump back during a 
> clock switch.
> To avoid making the whole more complex it's better to do small cleanup 
> first, so this patch introduces clocksource_forward_now() which takes care 
> of this offset since the last update_wall_time() call and adds it to the 
> clock, so there is no need anymore to deal with it explicitly.
> This is also gets rid of the timekeeping_suspend_nsecs hack, instead of 
> waiting until resume, the value is accumulated during suspend. In the end 
> there is only a single user of __get_nsec_offset() left, so I integrated 
> it back to getnstimeofday().
> 

It's unclear what tree this was agaisnt, but it was the wrong one.

> --- linux-2.6.orig/kernel/time/timekeeping.c
> +++ linux-2.6/kernel/time/timekeeping.c

Hopefully these changes will work when mixed with the pending 2.6.26
changes, but nobody yet knows.

> @@ -459,10 +452,10 @@ void update_wall_time(void)
>  	 */
>  	while (offset >= clock->cycle_interval) {
>  		/* accumulate one interval */
> -		clock->xtime_nsec += clock->xtime_interval;
> -		clock->cycle_last += clock->cycle_interval;
>  		offset -= clock->cycle_interval;
> +		clock->cycle_last += clock->cycle_interval;
>  
> +		clock->xtime_nsec += clock->xtime_interval;
>  		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
>  			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
>  			xtime.tv_sec++;

This do-nothing change conflited with
clocksource-introduce-clock_monotonic_raw.patch (and fixes).  Please check
that the result is OK (ie: clocksource.raw_snsec ddd not need any changes)


