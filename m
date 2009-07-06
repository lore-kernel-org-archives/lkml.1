Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbZGFUb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbZGFUb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 16:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbZGFUbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 16:31:52 -0400
Received: from www.tglx.de ([62.245.132.106]:41112 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbZGFUbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 16:31:51 -0400
Date: Mon, 6 Jul 2009 22:31:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] optimized ktime_get[_ts] for GENERIC_TIME=y
In-Reply-To: <20090706154933.5a1f8990@skybase>
Message-ID: <alpine.LFD.2.00.0907062215380.19480@localhost.localdomain>
References: <20090706154933.5a1f8990@skybase>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009, Martin Schwidefsky wrote:
> +ktime_t ktime_get(void)
> +{
> +	cycle_t cycle_now, cycle_delta;
> +	struct timespec time;
> +	unsigned long seq;
> +	s64 nsecs;
> +
> +	do {
> +		seq = read_seqbegin(&xtime_lock);
> +		time.tv_sec = xtime.tv_sec + wall_to_monotonic.tv_sec;
> +		time.tv_nsec = xtime.tv_nsec + wall_to_monotonic.tv_nsec;

That's actually a violation of the timespec semantics. tv_nsec can end
up greater than (10^9 - 1). Please use separate sec and nsec variables.

  	        secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
  	     	nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;

> +		/* read clocksource: */
> +		cycle_now = clocksource_read(clock);
> +
> +		/* calculate the delta since the last update_wall_time: */
> +		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> +
> +		/* convert to nanoseconds: */
> +		nsecs = cyc2ns(clock, cycle_delta);

So that needs to be changed to:

		nsecs += cyc2ns(clock, cycle_delta);

> +
> +	} while (read_seqretry(&xtime_lock, seq));
> +	nsecs += time.tv_sec * 1000000000ULL + time.tv_nsec;
> +	return (ktime_t) { .tv64 = nsecs };

This will break all 32bit architectures which do not have
CONFIG_KTIME_SCALAR set.

With the above changes applied:

  return ktime_add_ns(ktime_set(secs, 0), nsecs);

will do the trick. Might need some comments though :)

Thanks,

	tglx
