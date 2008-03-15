Return-Path: <linux-kernel-owner+w=401wt.eu-S1752284AbYCOEu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbYCOEu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 00:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbYCOEuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 00:50:14 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:54473 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYCOEuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 00:50:12 -0400
Date: Sat, 15 Mar 2008 05:50:02 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/5] introduce CLOCK_MONOTONIC_RAW
In-Reply-To: <1205554018.6122.81.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0803150536290.1791@scrub.home>
References: <1205553852.6122.76.camel@localhost.localdomain> 
 <1205553938.6122.79.camel@localhost.localdomain> <1205554018.6122.81.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 14 Mar 2008, john stultz wrote:

> My solution is to introduce CLOCK_MONOTONIC_RAW. This exposes a
> nanosecond based time value, that increments starting at bootup and has
> no frequency adjustments made to it what so ever.

A general comment: the raw clock doesn't need any adjustments, so updates 
don't have to be done that frequently and you can move most of that logic 
into second_overflow().

> @@ -439,6 +475,7 @@ static void clocksource_adjust(s64 offset)
>  void update_wall_time(void)
>  {
>  	cycle_t offset;
> +	static u64 raw_snsec; /* shifted raw nanosecnds */
>  
>  	/* Make sure we're fully resumed: */
>  	if (unlikely(timekeeping_suspended))

IMO that's really a clock property, so this belongs in the clock 
structure.
(Some day we may want to have multiple active clocks for various purposes 
and thus export multiple raw clocks.)

> @@ -466,6 +504,11 @@ void update_wall_time(void)
>  			second_overflow();
>  		}
>  
> +		if (raw_snsec >= (u64)NSEC_PER_SEC << clock->shift) {
> +			raw_snsec -= (u64)NSEC_PER_SEC << clock->shift;
> +			monotonic_raw.tv_sec++;
> +		}
> +	

You don't really have to use clock->shift as a scale, thus simplifying the 
shifting here (e.g. by using NTP_SCALE_SHIFT).
I'm thinking about doing this for e.g. xtime_nsec as well.

bye, Roman
