Return-Path: <linux-kernel-owner+w=401wt.eu-S1751464AbZGaHqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbZGaHqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 03:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZGaHqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 03:46:07 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:49886 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZGaHqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 03:46:06 -0400
Date: Fri, 31 Jul 2009 09:45:49 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>
Subject: Re: [RFC][patch 11/12] timekeeper read clock helper functions
Message-ID: <20090731094549.335fb996@skybase>
In-Reply-To: <1248989994.3374.13.camel@localhost>
References: <20090729134125.313191633@de.ibm.com>
	<20090729134231.768960500@de.ibm.com>
	<1248989994.3374.13.camel@localhost>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009 14:39:54 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Wed, 2009-07-29 at 15:41 +0200, Martin Schwidefsky wrote:
> > plain text document attachment (timekeeper-helper.diff)
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > 
> > Add timekeeper_read_clock_ntp and timekeeper_read_clock_raw and use
> > them for getnstimeofday, ktime_get, ktime_get_ts and getrawmonotonic.
> >
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: john stultz <johnstul@us.ibm.com>
> > Cc: Daniel Walker <dwalker@fifo99.com>
> > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > ---
> >  kernel/time/timekeeping.c |   91 +++++++++++++++++++---------------------------
> >  1 file changed, 38 insertions(+), 53 deletions(-)
> > 
> > Index: linux-2.6/kernel/time/timekeeping.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/time/timekeeping.c
> > +++ linux-2.6/kernel/time/timekeeping.c
> > @@ -84,6 +84,40 @@ static void timekeeper_setup_internals(s
> >  	timekeeper.shift = clock->shift;
> >  }
> > 
> > +/* Timekeeper helper functions. */
> > +static inline s64 timekeeper_read_clock_ntp(void)
> > +{
> > +	cycle_t cycle_now, cycle_delta;
> > +	struct clocksource *clock;
> > +
> > +	/* read clocksource: */
> > +	clock = timekeeper.clock;
> > +	cycle_now = clock->read(clock);
> > +
> 
> I know it seems nice to have it here, but I think these helpers would be
> more reusable in other contexts if they took the cycle_now value as an
> argument. Also I'd drop the ntp bit, just to avoid confusing it with
> some ntp specific function. So:
> 
>  timekeeping_get_ns(cycle_t now);
>  timekeeping_get_ns_raw(cycle_t now);
> 
> That way in some situations we don't have to make two accesses to the
> hardware if we want to get both values at the same point.
> 
> Seem reasonable?

The new names are fine but if we pull out the ->read call to the
caller we again have a rather strange mix. The caller gets the cycle
value using some clock, the helper uses the value of the timekeeper
clock or the timerkeeper mult/shift. I would like to keep the ->read
call in the helper. Is there a situation where we need both
calculations for the same cycles value? There is none in the current
code as far as I can see.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

