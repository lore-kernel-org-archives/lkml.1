Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbZGUWKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbZGUWKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbZGUWKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:10:06 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36276 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551AbZGUWKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:10:05 -0400
Subject: Re: [RFC][patch 1/5] move clock source related code to
	clocksource.c
From: john stultz <johnstul@us.ibm.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1248205851.14209.777.camel@desktop>
References: <20090721191745.788551122@de.ibm.com>
	 <20090721192057.177653956@de.ibm.com>  <1248205851.14209.777.camel@desktop>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 15:00:07 -0700
Message-Id: <1248213607.3298.107.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 12:50 -0700, Daniel Walker wrote:
> On Tue, 2009-07-21 at 21:17 +0200, Martin Schwidefsky wrote:
> > plain text document attachment (clocksource-move.diff)
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > 
> > Move clock source related code from timekeeping.c to clocksource.c
> > where they belong. The selected clocks source "clock" is now defined
> > in clocksource.c and clocksource_init is added to set up the initial
> > clock.
> 
> The problem is most (if not all) the code your moving is actually time
> keeping code .. The reason it seems like clocksource code is cause John
> wasn't very choosy about which structure he added variables too .. So
> really this clean up needs to be in reverse, remove all the timekeeping
> code from the clocksource code.

Not so much that I wasn't very choosy, but that I had to pick my battles
there. At the time, Roman claimed keeping the timekeeping values in the
clocksource (instead of global to timekeeping.c) actually produced
better code.

I do agree with Daniel's main point, that the patch mixes the layers I
tried to establish in the design.

Clocksource: Abstracts out a hardware counter.
NTP: Provides the reference time.
Timekeeping: Manages accumulating the clocksource, and combining input
from ntp's reference time to steer the hardware frequency.

Unfortunately, many timekeeping values got stuffed into the struct
clocksource. I've had plans to try to clean this up and utilize Patrick
Ohly's simpler clockcounter struct as a basis for a clocksource, nesting
the structures somewhat to look something like:


/* minimal structure only giving hardware info and access methods */
struct cyclecounter {
	char *name;
	cycle_t (*read)(const struct cyclecounter *cc);
	cycle_t (*vread)(const struct cyclecounter *cc);
	cycle_t mask;
	u32 mult;
	u32 shift;
};

/* more complicated structure holding timekeeping values */
struct timesource {
	struct cyclecounter counter;
	u32	corrected_mult;
	cycle_t cycle_interval;
	u64	xtime_interval;
	u32	raw_interval;
	cycle_t cycle_last;
	u64	xtime_nsec;
	s64	error; /* probably should be ntp_error */
	...
}

However such a change would be quite a bit of churn to much of the
timekeeping code, and to only marginal benefit. So I've put it off.


Martin, I've not been able to review your changes in extreme detail, but
I'm curious what the motivation for the drastic code rearrangement was?

I see you pushing a fair amount of code down a level, for instance,
except for the locking, getmonotonicraw() basically gets pushed down to
clocksource_read_raw().  The ktime_get/ktime_get_ts/getnstimeofday do
reduce some duplicate code, but that could still be minimized without
pushing stuff down to the clocksource level.

Is there any streamlining performance benefit from the way you moved
things around?

thanks
-john


