Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbZBDOEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbZBDOEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbZBDOEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:04:01 -0500
Received: from fifo99.com ([67.223.236.141]:38756 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbZBDOD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:03:57 -0500
Subject: Re: [PATCH NET-NEXT 01/10] clocksource: allow usage independent of
	timekeeping.c
From: Daniel Walker <dwalker@fifo99.com>
To: Patrick Ohly <patrick.ohly@intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1233752517-30010-2-git-send-email-patrick.ohly@intel.com>
References: <1233752517-30010-1-git-send-email-patrick.ohly@intel.com>
	 <1233752517-30010-2-git-send-email-patrick.ohly@intel.com>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 06:03:55 -0800
Message-Id: <1233756235.15119.54.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 14:01 +0100, Patrick Ohly wrote:

>  /**
> + * struct cyclecounter - hardware abstraction for a free running counter
> + *	Provides completely state-free accessors to the underlying hardware.
> + *	Depending on which hardware it reads, the cycle counter may wrap
> + *	around quickly. Locking rules (if necessary) have to be defined
> + *	by the implementor and user of specific instances of this API.
> + *
> + * @read:		returns the current cycle value
> + * @mask:		bitmask for two's complement
> + *			subtraction of non 64 bit counters,
> + *			see CLOCKSOURCE_MASK() helper macro
> + * @mult:		cycle to nanosecond multiplier
> + * @shift:		cycle to nanosecond divisor (power of two)
> + */
> +struct cyclecounter {
> +	cycle_t (*read)(const struct cyclecounter *cc);
> +	cycle_t mask;
> +	u32 mult;
> +	u32 shift;
> +};

Where are these defined? I don't see any in created in your code.

> +/**
> + * struct timecounter - layer above a %struct cyclecounter which counts nanoseconds
> + *	Contains the state needed by timecounter_read() to detect
> + *	cycle counter wrap around. Initialize with
> + *	timecounter_init(). Also used to convert cycle counts into the
> + *	corresponding nanosecond counts with timecounter_cyc2time(). Users
> + *	of this code are responsible for initializing the underlying
> + *	cycle counter hardware, locking issues and reading the time
> + *	more often than the cycle counter wraps around. The nanosecond
> + *	counter will only wrap around after ~585 years.
> + *
> + * @cc:			the cycle counter used by this instance
> + * @cycle_last:		most recent cycle counter value seen by
> + *			timecounter_read()
> + * @nsec:		continuously increasing count
> + */
> +struct timecounter {
> +	const struct cyclecounter *cc;
> +	cycle_t cycle_last;
> +	u64 nsec;
> +};

If your mixing generic and non-generic code, it seems a little
presumptuous to assume the code would get called more often than the
counter wraps. If this cyclecounter is what I think it is (a
clocksource) they wrap at varied times.

> +/**
> + * cyclecounter_cyc2ns - converts cycle counter cycles to nanoseconds
> + * @tc:		Pointer to cycle counter.
> + * @cycles:	Cycles
> + *
> + * XXX - This could use some mult_lxl_ll() asm optimization. Same code
> + * as in cyc2ns, but with unsigned result.
> + */
> +static inline u64 cyclecounter_cyc2ns(const struct cyclecounter *cc,
> +				      cycle_t cycles)
> +{
> +	u64 ret = (u64)cycles;
> +	ret = (ret * cc->mult) >> cc->shift;
> +	return ret;
> +}

This is just outright duplication.. Why wouldn't you use the function
that already exists for this?

> +/**
> + * clocksource_read_ns - get nanoseconds since last call of this function
> + * @tc:         Pointer to time counter
> + *
> + * When the underlying cycle counter runs over, this will be handled
> + * correctly as long as it does not run over more than once between
> + * calls.
> + *
> + * The first call to this function for a new time counter initializes
> + * the time tracking and returns bogus results.
> + */

"bogus results" doesn't sound very pretty..

Daniel

