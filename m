Return-Path: <linux-kernel-owner+w=401wt.eu-S1751540AbZGaILX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbZGaILX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 04:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbZGaILW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 04:11:22 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57294 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZGaILV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 04:11:21 -0400
Subject: Re: [RFC][patch 11/12] timekeeper read clock helper functions
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>
In-Reply-To: <20090731094549.335fb996@skybase>
References: <20090729134125.313191633@de.ibm.com>
	 <20090729134231.768960500@de.ibm.com>	<1248989994.3374.13.camel@localhost>
	 <20090731094549.335fb996@skybase>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 01:11:19 -0700
Message-Id: <1249027879.3333.6.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-31 at 09:45 +0200, Martin Schwidefsky wrote:
> On Thu, 30 Jul 2009 14:39:54 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> 
> > On Wed, 2009-07-29 at 15:41 +0200, Martin Schwidefsky wrote:
> > > plain text document attachment (timekeeper-helper.diff)
> > > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > > 
> > > Add timekeeper_read_clock_ntp and timekeeper_read_clock_raw and use
> > > them for getnstimeofday, ktime_get, ktime_get_ts and getrawmonotonic.
> > >
> > > Cc: Ingo Molnar <mingo@elte.hu>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: john stultz <johnstul@us.ibm.com>
> > > Cc: Daniel Walker <dwalker@fifo99.com>
> > > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > > ---
> > >  kernel/time/timekeeping.c |   91 +++++++++++++++++++---------------------------
> > >  1 file changed, 38 insertions(+), 53 deletions(-)
> > > 
> > > Index: linux-2.6/kernel/time/timekeeping.c
> > > ===================================================================
> > > --- linux-2.6.orig/kernel/time/timekeeping.c
> > > +++ linux-2.6/kernel/time/timekeeping.c
> > > @@ -84,6 +84,40 @@ static void timekeeper_setup_internals(s
> > >  	timekeeper.shift = clock->shift;
> > >  }
> > > 
> > > +/* Timekeeper helper functions. */
> > > +static inline s64 timekeeper_read_clock_ntp(void)
> > > +{
> > > +	cycle_t cycle_now, cycle_delta;
> > > +	struct clocksource *clock;
> > > +
> > > +	/* read clocksource: */
> > > +	clock = timekeeper.clock;
> > > +	cycle_now = clock->read(clock);
> > > +
> > 
> > I know it seems nice to have it here, but I think these helpers would be
> > more reusable in other contexts if they took the cycle_now value as an
> > argument. Also I'd drop the ntp bit, just to avoid confusing it with
> > some ntp specific function. So:
> > 
> >  timekeeping_get_ns(cycle_t now);
> >  timekeeping_get_ns_raw(cycle_t now);
> > 
> > That way in some situations we don't have to make two accesses to the
> > hardware if we want to get both values at the same point.
> > 
> > Seem reasonable?
> 
> The new names are fine but if we pull out the ->read call to the
> caller we again have a rather strange mix. The caller gets the cycle
> value using some clock, the helper uses the value of the timekeeper
> clock or the timerkeeper mult/shift. I would like to keep the ->read
> call in the helper. Is there a situation where we need both
> calculations for the same cycles value? There is none in the current
> code as far as I can see.

One instance: Changing it would allow us to use this code in
timekeeping_forward() as we want to be able to accumulate the current
cycles into xtime and then set cycles_last equal to the read value at
that time. By embedding the read into the timekeeping_read_clock_x() it
avoids us from using the function with any of the management calls. If
you look at the mega-patch I sent out earlier, I think there were a few
uses for such helper functions in update_wall_time and other spots.

Also I have had some discussions with folks that would like to have the
ability to generate multiple CLOCK_ID values at the same "instance".
There isn't a good interface to userland for such a feature, but I'm
hesitant to make it difficult to compute on the kernel side.

thanks
-john


