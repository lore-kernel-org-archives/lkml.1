Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbZJELxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbZJELxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 07:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758590AbZJELxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 07:53:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36410 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758331AbZJELxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 07:53:30 -0400
Date: Mon, 5 Oct 2009 13:52:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John Kacur <jkacur@redhat.com>
Cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] time: logrithmic time accumulation
Message-ID: <20091005115218.GA7475@elte.hu>
References: <1254525473.7741.88.camel@localhost.localdomain> <alpine.LFD.2.00.0910051228420.5132@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910051228420.5132@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Kacur <jkacur@redhat.com> wrote:

> 
> 
> On Fri, 2 Oct 2009, john stultz wrote:
> 
> > Accumulating one tick at a time works well unless we're using NOHZ. Then
> > it can be an issue, since we may have to run through the loop a few
> > thousand times, which can increase timer interrupt caused latency.
> > 
> > The current solution was to accumulate in half-second intervals with
> > NOHZ. This kept the number of loops down, however it did slightly change
> > how we make NTP adjustments. While not an issue with NTPd users, as NTPd
> > makes adjustments over a longer period of time, other adjtimex() users
> > have noticed the half-second granularity with which we can apply
> > frequency changes to the clock.
> > 
> > For instance, if a application tries to apply a 100ppm frequency
> > correction for 20ms to correct a 2us offset, with NOHZ they either get
> > no correction, or a 50us correction.
> > 
> > Now, there will always be some granularity error for applying frequency
> > corrections. However with users sensitive to this error have seen a
> > 50-500x increase with NOHZ compared to running without NOHZ.
> > 
> > So I figured I'd try another approach then just simply increasing the
> > interval. My approach is to consume the time interval logarithmically.
> > This reduces the number of times  through the loop needed keeping
> > latency down, while still preserving the original granularity error for
> > adjtimex() changes.
> > 
> > Further, this change allows us to remove the xtime_cache code (patch to
> > follow), as xtime is always within one tick of the current time, instead
> > of the half-second updates it saw before.
> > 
> > An earlier version of this patch has been shipping to x86 users in the
> > RedHat MRG releases for awhile without issue, but I've reworked this
> > version to be even more careful about avoiding possible overflows if the
> > shift value gets too large.
> > 
> > Since this is not the most trivial code, and its slightly different then
> > whats been tested for  awhile, it would be good to get this into some
> > trees for testing. Be it -tip or -mm, either would work. If there's no
> > problems it could be a 2.6.33 or 2.6.34 item.
> > 
> > Any comments or feedback would be appreciated!
> > 
> > Signed-off-by: John Stultz <johnstul@us.ibm.com>
> > 
> > diff --git a/include/linux/timex.h b/include/linux/timex.h
> > index e6967d1..0c0ef7d 100644
> > --- a/include/linux/timex.h
> > +++ b/include/linux/timex.h
> > @@ -261,11 +261,7 @@ static inline int ntp_synced(void)
> >  
> >  #define NTP_SCALE_SHIFT		32
> >  
> > -#ifdef CONFIG_NO_HZ
> > -#define NTP_INTERVAL_FREQ  (2)
> > -#else
> >  #define NTP_INTERVAL_FREQ  (HZ)
> > -#endif
> >  #define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
> >  
> >  /* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
> > diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> > index fb0f46f..4cc5656 100644
> > --- a/kernel/time/timekeeping.c
> > +++ b/kernel/time/timekeeping.c
> > @@ -721,6 +721,51 @@ static void timekeeping_adjust(s64 offset)
> >  				timekeeper.ntp_error_shift;
> >  }
> >  
> > +
> > +/**
> > + * logarithmic_accumulation - shifted accumulation of cycles
> > + *
> > + * This functions accumulates a shifted interval of cycles into 
> > + * into a shifted interval nanoseconds. Allows for O(log) accumulation
> > + * loop.
> > + * 
> > + * Returns the unconsumed cycles.
> > + */
> > +static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
> > +{
> > +	u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
> > +
> > +	/* If the offset is smaller then a shifted interval, do nothing */
> > +	if (offset < timekeeper.cycle_interval<<shift)
> > +		return offset;
> > +
> > +	/* accumulate one shifted interval */
> > +	offset -= timekeeper.cycle_interval << shift;
> > +	timekeeper.clock->cycle_last += timekeeper.cycle_interval << shift;
> > +	
> > +	timekeeper.xtime_nsec += timekeeper.xtime_interval << shift;
> > +	while (timekeeper.xtime_nsec >= nsecps) {
> > +		timekeeper.xtime_nsec -= nsecps;
> > +		xtime.tv_sec++;
> > +		second_overflow();
> > +	}
> > +	
> > +	/* accumulate into raw time */
> > +	raw_time.tv_nsec += timekeeper.raw_interval << shift;;
> > +	while (raw_time.tv_nsec >= NSEC_PER_SEC) {
> > +		raw_time.tv_nsec -= NSEC_PER_SEC;
> > +		raw_time.tv_sec++;
> > +	}
> > +
> > +	/* accumulate error between NTP and clock interval */
> > +	timekeeper.ntp_error += tick_length << shift;
> > +	timekeeper.ntp_error -= timekeeper.xtime_interval <<
> > +				(timekeeper.ntp_error_shift + shift);
> > +
> > +	return offset;
> > +}
> > +
> > +
> >  /**
> >   * update_wall_time - Uses the current clocksource to increment the wall time
> >   *
> > @@ -731,6 +776,7 @@ void update_wall_time(void)
> >  	struct clocksource *clock;
> >  	cycle_t offset;
> >  	u64 nsecs;
> > +	int shift = 0, maxshift;
> >  
> >  	/* Make sure we're fully resumed: */
> >  	if (unlikely(timekeeping_suspended))
> > @@ -744,33 +790,22 @@ void update_wall_time(void)
> >  #endif
> >  	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.shift;
> >  
> > -	/* normally this loop will run just once, however in the
> > -	 * case of lost or late ticks, it will accumulate correctly.
> > +	/*
> > +	 * With NO_HZ we may have to accumulate many cycle_intervals
> > +	 * (think "ticks") worth of time at once. To do this efficiently,
> > +	 * we calculate the largest doubling multiple of cycle_intervals
> > +	 * that is smaller then the offset. We then accumulate that 
> > +	 * chunk in one go, and then try to consume the next smaller
> > +	 * doubled multiple.
> >  	 */
> > +	shift = ilog2(offset) - ilog2(timekeeper.cycle_interval);
> > +	shift = max(0, shift);
> > +	/* Bound shift to one less then what overflows tick_length */
> > +	maxshift = (8*sizeof(tick_length) - (ilog2(tick_length)+1)) - 1;
> > +	shift = min(shift, maxshift);	
> >  	while (offset >= timekeeper.cycle_interval) {
> > -		u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
> > -
> > -		/* accumulate one interval */
> > -		offset -= timekeeper.cycle_interval;
> > -		clock->cycle_last += timekeeper.cycle_interval;
> > -
> > -		timekeeper.xtime_nsec += timekeeper.xtime_interval;
> > -		if (timekeeper.xtime_nsec >= nsecps) {
> > -			timekeeper.xtime_nsec -= nsecps;
> > -			xtime.tv_sec++;
> > -			second_overflow();
> > -		}
> > -
> > -		raw_time.tv_nsec += timekeeper.raw_interval;
> > -		if (raw_time.tv_nsec >= NSEC_PER_SEC) {
> > -			raw_time.tv_nsec -= NSEC_PER_SEC;
> > -			raw_time.tv_sec++;
> > -		}
> > -
> > -		/* accumulate error between NTP and clock interval */
> > -		timekeeper.ntp_error += tick_length;
> > -		timekeeper.ntp_error -= timekeeper.xtime_interval <<
> > -					timekeeper.ntp_error_shift;
> > +		offset = logarithmic_accumulation(offset, shift);
> > +		shift--;
> >  	}
> >  
> >  	/* correct the clock when NTP error is too big */
> > 
> > 
> > 
> 
> There are several (6) trailing whitespace errors that checkpatch exposes, 
> but other than that:

Yep, i fixed those already. (also the few inconsistent comment 
capitalizations)

The two patches held up fine in -tip testing so far.

> Signed-off-by: John Kacur <jkacur@redhat.com>

Thanks - i changed that to Reviewed-by (SoB is for being part of the 
patch-flow) and added it to the two commits.

	Ingo
