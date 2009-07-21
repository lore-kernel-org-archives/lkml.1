Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbZGUWBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbZGUWBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbZGUWBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:01:18 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37046 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbZGUWBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:01:17 -0400
Subject: Re: [RFC][patch 4/5] clocksource_read/clocksource_read_raw inline
 functions
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090721192100.489213669@de.ibm.com>
References: <20090721191745.788551122@de.ibm.com>
	 <20090721192100.489213669@de.ibm.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 15:01:14 -0700
Message-Id: <1248213674.3298.109.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 21:17 +0200, Martin Schwidefsky wrote:
> plain text document attachment (clocksource-read-ns.diff)
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Add clocksource_read / clocksource_read_raw inline functions and use
> them for getnstimeofday, ktime_get, ktime_get_ts and getrawmonotonic.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: john stultz <johnstul@us.ibm.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  include/linux/clocksource.h |   45 +++++++++++++++++++++++++++++++++++++++++++
>  kernel/time/timekeeping.c   |   46 +++-----------------------------------------
>  2 files changed, 49 insertions(+), 42 deletions(-)
> 
> Index: linux-2.6/include/linux/clocksource.h
> ===================================================================
> --- linux-2.6.orig/include/linux/clocksource.h
> +++ linux-2.6/include/linux/clocksource.h
> @@ -284,6 +284,51 @@ static inline s64 cyc2ns(struct clocksou
>  	return ret;
>  }
> 
> +/**
> + * clocksource_read: - Read nanosecond delta from clocksource.
> + * @cs:		pointer to clocksource being read
> + *
> + * Read from the clock source and return the clock value converted
> + * to nanoseconds.
> + */
> +static inline s64 clocksource_read(struct clocksource *cs)
> +{
> +	cycle_t cycle_now, cycle_delta;
> +
> +	/* read clocksource: */
> +	cycle_now = cs->read(cs);
> +
> +	/* calculate the delta since the last update_wall_time: */
> +	cycle_delta = (cycle_now - cs->cycle_last) & cs->mask;
> +
> +	/* convert to nanoseconds: */
> +	return cyc2ns(cs, cycle_delta);
> +}

Oof. So you took out clocksource_read() only to replace with a different
function with the same name? If this move is necessary, could we call
these clocksource_get_ns()/clocksource_get_raw_ns() to avoid the
confusion?

thanks
-john


