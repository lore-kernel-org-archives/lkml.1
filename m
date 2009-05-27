Return-Path: <linux-kernel-owner+w=401wt.eu-S1762501AbZE0QEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbZE0QEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 12:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756680AbZE0QEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 12:04:15 -0400
Received: from www.tglx.de ([62.245.132.106]:46958 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbZE0QEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 12:04:14 -0400
Date: Wed, 27 May 2009 18:01:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jon Hunter <jon-hunter@ti.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] Dynamic Tick: Prevent clocksource wrapping during
 idle
In-Reply-To: <4A1D52E3.3040204@ti.com>
Message-ID: <alpine.LFD.2.00.0905271731070.3397@localhost.localdomain>
References: <4A1D52E3.3040204@ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Jon Hunter wrote:
>  /**
> + * timekeeping_max_deferment - Returns max time the clocksource can be
> deferred
> + *
> + * IMPORTANT: Must be called with xtime_lock held!

  No, that would mean that xtime_lock needs to be write locked. And we
  definitely do not want that.

  The caller needs to observe xtime_lock via read_seqbegin /
  read_seqretry because clock might change.

> + */
> +s64 timekeeping_max_deferment(void)
> +{
> +	s64 max_nsecs;
> +	u64 max_cycles;
> +
> +	/*
> +	 * Calculate the maximum number of cycles that we can pass to the
> +	 * cyc2ns function without overflowing a 64-bit signed result. The
> +	 * maximum number of cycles is equal to ULLONG_MAX/clock->mult which
> +	 * is equivalent to the below.
> +	 * max_cycles < (2^63)/clock->mult
> +	 * max_cycles < 2^(log2((2^63)/clock->mult))
> +	 * max_cycles < 2^(log2(2^63) - log2(clock->mult))
> +	 * max_cycles < 2^(63 - log2(clock->mult))
> +	 * max_cycles < 1 << (63 - log2(clock->mult))
> +	 * Please note that we add 1 to the result of the log2 to account for
> +	 * any rounding errors, ensure the above inequality is satisfied and
> +	 * no overflow will occur.
> +	 */
> +	max_cycles = 1ULL << (63 - (ilog2(clock->mult) + 1));
> +
> +	/*
> +	 * The actual maximum number of cycles we can defer the clocksource is
> +	 * determined by the minimum of max_cycles and clock->mask.
> +	 */
> +	max_cycles = min(max_cycles, clock->mask);
> +	max_nsecs = cyc2ns(clock, max_cycles);

  Why do you want to recalculate the whole stuff over and over ?

  That computation can be done when the clock source is initialized or
  any fundamental change of the clock parameters happens.

  Stick that value into the clocksource struct and just read it out.

> +	/*
> +	 * To ensure that the clocksource does not wrap whilst we are idle,
> +	 * limit the time the clocksource can be deferred by 6.25%. Please
> +	 * note a margin of 6.25% is used because this can be computed with
> +	 * a shift, versus say 5% which would require division.
> +	 */
> +	max_nsecs = max_nsecs - (max_nsecs >> 4);
> +
> +	if (max_nsecs < 0)
> +		max_nsecs = 0;

  How does "max_nsecs = max_nsecs - (max_nsecs >> 4)" ever become
  negative ?

Thanks,

	tglx
