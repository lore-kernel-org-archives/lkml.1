Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbZGVHZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbZGVHZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 03:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZGVHZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 03:25:26 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:39842 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZGVHZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 03:25:25 -0400
Date: Wed, 22 Jul 2009 09:25:19 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][patch 1/5] move clock source related code to
 clocksource.c
Message-ID: <20090722092519.772b238b@skybase>
In-Reply-To: <1248213607.3298.107.camel@localhost>
References: <20090721191745.788551122@de.ibm.com>
	<20090721192057.177653956@de.ibm.com>
	<1248205851.14209.777.camel@desktop>
	<1248213607.3298.107.camel@localhost>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009 15:00:07 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Tue, 2009-07-21 at 12:50 -0700, Daniel Walker wrote:
> > On Tue, 2009-07-21 at 21:17 +0200, Martin Schwidefsky wrote:
> > > plain text document attachment (clocksource-move.diff)
> > > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > > 
> > > Move clock source related code from timekeeping.c to clocksource.c
> > > where they belong. The selected clocks source "clock" is now defined
> > > in clocksource.c and clocksource_init is added to set up the initial
> > > clock.
> > 
> > The problem is most (if not all) the code your moving is actually time
> > keeping code .. The reason it seems like clocksource code is cause John
> > wasn't very choosy about which structure he added variables too .. So
> > really this clean up needs to be in reverse, remove all the timekeeping
> > code from the clocksource code.
> 
> Not so much that I wasn't very choosy, but that I had to pick my battles
> there. At the time, Roman claimed keeping the timekeeping values in the
> clocksource (instead of global to timekeeping.c) actually produced
> better code.

There are only a couple of functions where the performance is
important, these are the ktime_get functions (and variants) and probably
the update_wall_time function.

> I do agree with Daniel's main point, that the patch mixes the layers I
> tried to establish in the design.
> 
> Clocksource: Abstracts out a hardware counter.
> NTP: Provides the reference time.
> Timekeeping: Manages accumulating the clocksource, and combining input
> from ntp's reference time to steer the hardware frequency.

Imho what makes the code hard to understand is that the internals of
the clocksource have leaked into the timekeeping code. I'm getting at
the cycle, mult and shift values here. The code would be much easier to
understand if the clocksource would just return nanoseconds. The bad
thing here is that we would loose some bits of precision.

> Unfortunately, many timekeeping values got stuffed into the struct
> clocksource. I've had plans to try to clean this up and utilize Patrick
> Ohly's simpler clockcounter struct as a basis for a clocksource, nesting
> the structures somewhat to look something like:
> 
> 
> /* minimal structure only giving hardware info and access methods */
> struct cyclecounter {
> 	char *name;
> 	cycle_t (*read)(const struct cyclecounter *cc);
> 	cycle_t (*vread)(const struct cyclecounter *cc);
> 	cycle_t mask;
> 	u32 mult;
> 	u32 shift;
> };
> 
> /* more complicated structure holding timekeeping values */
> struct timesource {
> 	struct cyclecounter counter;
> 	u32	corrected_mult;
> 	cycle_t cycle_interval;
> 	u64	xtime_interval;
> 	u32	raw_interval;
> 	cycle_t cycle_last;
> 	u64	xtime_nsec;
> 	s64	error; /* probably should be ntp_error */
> 	...
> }
> 
> However such a change would be quite a bit of churn to much of the
> timekeeping code, and to only marginal benefit. So I've put it off.

That would be an improvement, but there are still these pesky cycles in
the timesource.
 
> Martin, I've not been able to review your changes in extreme detail, but
> I'm curious what the motivation for the drastic code rearrangement was?

It started of with a minor performance optimization, I wanted to get
rid of the change_clocksource call every tick. When I looked at the
code to understand it I started to move things around.

> I see you pushing a fair amount of code down a level, for instance,
> except for the locking, getmonotonicraw() basically gets pushed down to
> clocksource_read_raw().  The ktime_get/ktime_get_ts/getnstimeofday do
> reduce some duplicate code, but that could still be minimized without
> pushing stuff down to the clocksource level.

The background here is that I want to isolate the use ofthe cycles, mult
and shift values to clocksource.[ch]

> Is there any streamlining performance benefit from the way you moved
> things around?

The biggest gain is the ktime_get optimization that is already in the
tip tree. The call to change_clocksource showed up in the instructions
trace for a cpu wake up and I started to wonder if this is necessary.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

