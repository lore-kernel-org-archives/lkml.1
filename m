Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZGVH3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZGVH3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 03:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZGVH3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 03:29:39 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:41797 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZGVH3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 03:29:39 -0400
Date: Wed, 22 Jul 2009 09:29:34 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][patch 4/5] clocksource_read/clocksource_read_raw inline
 functions
Message-ID: <20090722092934.4fa16eba@skybase>
In-Reply-To: <1248213674.3298.109.camel@localhost>
References: <20090721191745.788551122@de.ibm.com>
	<20090721192100.489213669@de.ibm.com>
	<1248213674.3298.109.camel@localhost>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009 15:01:14 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Tue, 2009-07-21 at 21:17 +0200, Martin Schwidefsky wrote:
> > plain text document attachment (clocksource-read-ns.diff)
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > 
> > Add clocksource_read / clocksource_read_raw inline functions and use
> > them for getnstimeofday, ktime_get, ktime_get_ts and getrawmonotonic.
> > 
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: john stultz <johnstul@us.ibm.com>
> > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > ---
> >  include/linux/clocksource.h |   45 +++++++++++++++++++++++++++++++++++++++++++
> >  kernel/time/timekeeping.c   |   46 +++-----------------------------------------
> >  2 files changed, 49 insertions(+), 42 deletions(-)
> > 
> > Index: linux-2.6/include/linux/clocksource.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/clocksource.h
> > +++ linux-2.6/include/linux/clocksource.h
> > @@ -284,6 +284,51 @@ static inline s64 cyc2ns(struct clocksou
> >  	return ret;
> >  }
> > 
> > +/**
> > + * clocksource_read: - Read nanosecond delta from clocksource.
> > + * @cs:		pointer to clocksource being read
> > + *
> > + * Read from the clock source and return the clock value converted
> > + * to nanoseconds.
> > + */
> > +static inline s64 clocksource_read(struct clocksource *cs)
> > +{
> > +	cycle_t cycle_now, cycle_delta;
> > +
> > +	/* read clocksource: */
> > +	cycle_now = cs->read(cs);
> > +
> > +	/* calculate the delta since the last update_wall_time: */
> > +	cycle_delta = (cycle_now - cs->cycle_last) & cs->mask;
> > +
> > +	/* convert to nanoseconds: */
> > +	return cyc2ns(cs, cycle_delta);
> > +}
> 
> Oof. So you took out clocksource_read() only to replace with a different
> function with the same name? If this move is necessary, could we call
> these clocksource_get_ns()/clocksource_get_raw_ns() to avoid the
> confusion?

The code that uses the old clocksource_read is accessing other fields
from the struct clocksource. So the old inline function seems
redundant to me. The new one do more and returns a value where you
don't need anything else from the clocksource (namely nanoseconds).
To reuse the name adds a little confusion while you look at the patches,
the end result should be pretty clear, no? But if you prefer to add the
_ns suffix that is fine with me.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

