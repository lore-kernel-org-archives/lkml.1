Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbZHMXbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbZHMXbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 19:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbZHMXbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 19:31:25 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51301 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbZHMXbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 19:31:24 -0400
Subject: Re: [patch 11/14] timekeeper read clock helper functions
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>
In-Reply-To: <20090813154201.810817188@de.ibm.com>>
References: <20090813154034.613706651@de.ibm.com> >
	  <20090813154201.810817188@de.ibm.com>>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 16:30:18 -0700
Message-Id: <1250206218.7149.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 17:40 +0200, Martin Schwidefsky wrote:
> plain text document attachment (timekeeper-helper.diff)
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Add timekeeper_read_clock_ntp and timekeeper_read_clock_raw and use
> them for getnstimeofday, ktime_get, ktime_get_ts and getrawmonotonic.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: john stultz <johnstul@us.ibm.com>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  kernel/time/timekeeping.c |   91 +++++++++++++++++++---------------------------
>  1 file changed, 38 insertions(+), 53 deletions(-)
> 
> Index: linux-2.6/kernel/time/timekeeping.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/timekeeping.c
> +++ linux-2.6/kernel/time/timekeeping.c
> @@ -95,6 +95,40 @@ static void timekeeper_setup_internals(s
>  	timekeeper.mult = clock->mult;
>  }
> 
> +/* Timekeeper helper functions. */
> +static inline s64 timekeeping_get_ns(void)
> +{
> +	cycle_t cycle_now, cycle_delta;
> +	struct clocksource *clock;
> +
> +	/* read clocksource: */
> +	clock = timekeeper.clock;
> +	cycle_now = clock->read(clock);
> +
> +	/* calculate the delta since the last update_wall_time: */
> +	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> +
> +	/* return delta convert to nanoseconds using ntp adjusted mult. */
> +	return clocksource_cyc2ns(cycle_delta, timekeeper.mult,
> +				  timekeeper.shift);
> +}

Again, not a huge issue, but if we kept the read() out of this function
and instead passed the cycle_now value in as a argument, we could also
use this function in  timekeeping_forward_now()


thanks
-john


