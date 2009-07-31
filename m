Return-Path: <linux-kernel-owner+w=401wt.eu-S1751830AbZGaI2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbZGaI2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 04:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZGaI2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 04:28:18 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:51378 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbZGaI2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 04:28:11 -0400
Date: Fri, 31 Jul 2009 10:27:08 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>
Subject: Re: [RFC][patch 10/12] move NTP adjusted clock multiplier to struct
 timekeeper
Message-ID: <20090731102708.143b1bfd@skybase>
In-Reply-To: <1249027979.3333.8.camel@work-vm>
References: <20090729134125.313191633@de.ibm.com>
	<20090729134231.515027738@de.ibm.com>
	<1248991488.3374.14.camel@localhost>
	<20090731095254.3ed0cb7d@skybase>
	<1249027979.3333.8.camel@work-vm>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009 01:12:59 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Fri, 2009-07-31 at 09:52 +0200, Martin Schwidefsky wrote:
> > On Thu, 30 Jul 2009 15:04:48 -0700
> > john stultz <johnstul@us.ibm.com> wrote:
> > 
> > > On Wed, 2009-07-29 at 15:41 +0200, Martin Schwidefsky wrote:
> > > > plain text document attachment (timekeeper-mult.diff)
> > > > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > > > 
> > > > The clocksource structure has two multipliers, the unmodified multiplier
> > > > clock->mult_orig and the NTP corrected multiplier clock->mult. The NTP
> > > > multiplier is misplaced in the struct clocksource, this is private
> > > > information of the timekeeping code. Add the mult field to the struct
> > > > timekeeper to contain the NTP corrected value, keep the unmodifed
> > > > multiplier in clock->mult and remove clock->mult_orig. For consistency
> > > > add the shift value associated with the NTP corrected mult value to
> > > > struct timekeeper as well.
> > > > 
> > > > Cc: Ingo Molnar <mingo@elte.hu>
> > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > Cc: john stultz <johnstul@us.ibm.com>
> > > > Cc: Daniel Walker <dwalker@fifo99.com>
> > > > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > > > ---
> > > >  arch/arm/plat-omap/common.c |    2 +-
> > > >  include/linux/clocksource.h |    4 +---
> > > >  kernel/time/timekeeping.c   |   43 +++++++++++++++++++++++++------------------
> > > >  3 files changed, 27 insertions(+), 22 deletions(-)
> > > > 
> > > > Index: linux-2.6/include/linux/clocksource.h
> > > > ===================================================================
> > > > --- linux-2.6.orig/include/linux/clocksource.h
> > > > +++ linux-2.6/include/linux/clocksource.h
> > > > @@ -149,8 +149,7 @@ extern u64 timecounter_cyc2time(struct t
> > > >   * @disable:		optional function to disable the clocksource
> > > >   * @mask:		bitmask for two's complement
> > > >   *			subtraction of non 64 bit counters
> > > > - * @mult:		cycle to nanosecond multiplier (adjusted by NTP)
> > > > - * @mult_orig:		cycle to nanosecond multiplier (unadjusted by NTP)
> > > > + * @mult:		cycle to nanosecond multiplier
> > > >   * @shift:		cycle to nanosecond divisor (power of two)
> > > >   * @flags:		flags describing special properties
> > > >   * @vread:		vsyscall based read
> > > > @@ -168,7 +167,6 @@ struct clocksource {
> > > >  	void (*disable)(struct clocksource *cs);
> > > >  	cycle_t mask;
> > > >  	u32 mult;
> > > > -	u32 mult_orig;
> > > >  	u32 shift;
> > > >  	unsigned long flags;
> > > >  	cycle_t (*vread)(void);
> > > > Index: linux-2.6/kernel/time/timekeeping.c
> > > > ===================================================================
> > > > --- linux-2.6.orig/kernel/time/timekeeping.c
> > > > +++ linux-2.6/kernel/time/timekeeping.c
> > > > @@ -29,6 +29,8 @@ struct timekeeper {
> > > >  	s64	ntp_error;
> > > >  	int	xtime_shift;
> > > >  	int	ntp_error_shift;
> > > > +	u32	mult;			/* NTP adjusted clock multiplier */
> > > > +	u32	shift;			/* NTP adjusted clock shift */
> > > 
> > > I'm a little confused here. NTP doesn't adjust the shift value. This
> > > seems redundant with the xtime_shift value introduced in [patch 9/12].
> > 
> > True the NTP code does not adjust the shift value. But mult and shift
> > build a pair, no? I think it is more readable if we use timekeeper.mult 
> > and timekeeper.shift instead of timekeeper.mult and clock->shift.
> > And the xtime_shift does not need to be the same value as the clock
> > shift - at least in theory. It is just a shift to increase precision. 
> > Therefore I would like to use the xtime_shift and ntp_error_shift values
> > exclusively as the shifts for the respective xtime_nsec and ntp_error
> > values. Makes sense ?
> 
> But can't we drop the xtime_shift if we have the clocksource shift kept
> internally? Unless I'm missing something more subtle in your patches,
> they should be the same at all times.

They are the same. Perhaps a good comment in the timekeeper struct is
good enough. Then the patch that introduces the shift values would add
timekeeper.shift, timekeeper.xtime_shift is dropped, and the patch that
add the timekeeper.mult would just use the timekeeper.shift as it is.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

