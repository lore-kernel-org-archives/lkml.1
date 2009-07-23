Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbZGWHXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbZGWHXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 03:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZGWHXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 03:23:42 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:50020 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbZGWHXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 03:23:41 -0400
Date: Thu, 23 Jul 2009 09:23:29 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][patch 1/5] move clock source related code to
 clocksource.c
Message-ID: <20090723092329.54ff552f@skybase>
In-Reply-To: <1248284733.18789.32.camel@work-vm>
References: <20090721191745.788551122@de.ibm.com>
	<20090721192057.177653956@de.ibm.com>
	<1248205851.14209.777.camel@desktop>
	<1248213607.3298.107.camel@localhost>
	<20090722092519.772b238b@skybase>
	<1248284733.18789.32.camel@work-vm>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 10:45:33 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Wed, 2009-07-22 at 09:25 +0200, Martin Schwidefsky wrote:
> > On Tue, 21 Jul 2009 15:00:07 -0700
> > john stultz <johnstul@us.ibm.com> wrote:
> > > I do agree with Daniel's main point, that the patch mixes the layers I
> > > tried to establish in the design.
> > > 
> > > Clocksource: Abstracts out a hardware counter.
> > > NTP: Provides the reference time.
> > > Timekeeping: Manages accumulating the clocksource, and combining input
> > > from ntp's reference time to steer the hardware frequency.
> > 
> > Imho what makes the code hard to understand is that the internals of
> > the clocksource have leaked into the timekeeping code. I'm getting at
> > the cycle, mult and shift values here. The code would be much easier to
> > understand if the clocksource would just return nanoseconds. The bad
> > thing here is that we would loose some bits of precision.
> 
> While I completely agree the code is hard to understand, I really don't
> think that pushing that down to clocksource.c will improve things. 
> 
> As much as you'd prefer it not, I feel the timekeeping code has to deal
> with cycles. The consistent translation and accumulation of clocksource
> cycles into nanoseconds is what timekeeping.c is all about.
> 
> We already have interfaces that return nanoseconds, they're
> gensttimeofday, ktime_get, ktime_get_ts. 

After playing around with the idea move some fields from the struct
clocksource to a need private structure in timekeeping.c I now agree.
The new structure I have in mind currently looks like this:

/* Structure holding internal timekeeping values. */
struct timekeeper {
       cycle_t cycle_interval;
       u64     xtime_interval;
       u32     raw_interval;
       u64     xtime_nsec;
       s64     ntp_error;
       int     xtime_shift;
       int     ntp_shift;
};

The raw_time stays in struct clocksource.

> > > Unfortunately, many timekeeping values got stuffed into the struct
> > > clocksource. I've had plans to try to clean this up and utilize Patrick
> > > Ohly's simpler clockcounter struct as a basis for a clocksource, nesting
> > > the structures somewhat to look something like:
> > > 
> > > 
> > > /* minimal structure only giving hardware info and access methods */
> > > struct cyclecounter {
> > > 	char *name;
> > > 	cycle_t (*read)(const struct cyclecounter *cc);
> > > 	cycle_t (*vread)(const struct cyclecounter *cc);
> > > 	cycle_t mask;
> > > 	u32 mult;
> > > 	u32 shift;
> > > };
> > > 
> > > /* more complicated structure holding timekeeping values */
> > > struct timesource {
> > > 	struct cyclecounter counter;
> > > 	u32	corrected_mult;
> > > 	cycle_t cycle_interval;
> > > 	u64	xtime_interval;
> > > 	u32	raw_interval;
> > > 	cycle_t cycle_last;
> > > 	u64	xtime_nsec;
> > > 	s64	error; /* probably should be ntp_error */
> > > 	...
> > > }
> > > 
> > > However such a change would be quite a bit of churn to much of the
> > > timekeeping code, and to only marginal benefit. So I've put it off.
> > 
> > That would be an improvement, but there are still these pesky cycles in
> > the timesource.
> 
> Again, I think there has to be. Since some portion of the current time
> is unaccumulated, it is inherently cycles based. The timekeeping core
> has to decide when to accumulate those cycles into nanoseconds and store
> them into xtime.  In order to do that, the timekeeping code has to have
> an idea of where the cycle_last value is. Further, for improved
> precision, and ntp steering, we use the *_interval values to accumulate
> in chunks.

Yes, I now agree.

> > > Martin, I've not been able to review your changes in extreme detail, but
> > > I'm curious what the motivation for the drastic code rearrangement was?
> > 
> > It started of with a minor performance optimization, I wanted to get
> > rid of the change_clocksource call every tick. When I looked at the
> > code to understand it I started to move things around.
> > 
> > > I see you pushing a fair amount of code down a level, for instance,
> > > except for the locking, getmonotonicraw() basically gets pushed down to
> > > clocksource_read_raw().  The ktime_get/ktime_get_ts/getnstimeofday do
> > > reduce some duplicate code, but that could still be minimized without
> > > pushing stuff down to the clocksource level.
> > 
> > The background here is that I want to isolate the use ofthe cycles, mult
> > and shift values to clocksource.[ch]
> 
> Again I do completely agree the code needs to be cleaned up.
> Unfortunately there's still a split between the GENERIC_TIME and non
> GENERIC_TIME arches that keeps us from making some cleanups right now.
> I'm trying to get this all unified (see my arch_gettimeoffset patches),
> but until we get all the arches moved over, there's some unfortunate
> uglys we can't get rid of.
> 
> 
> If I can find some cycles today, I'll try to take a rough swing at some
> of the cleanup I mentioned earlier. Probably won't build, but will maybe
> give you an idea of the direction I'm thinking about, and then you can
> let me know where you feel its still too complex. Maybe then we can meet
> in the middle?

I'm already in the middle of doing what you suggested. I'll send an
update soonish.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

