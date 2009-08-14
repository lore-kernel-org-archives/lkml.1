Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbZHNLM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbZHNLM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZHNLM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:12:56 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:52749 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbZHNLM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:12:56 -0400
Date: Fri, 14 Aug 2009 13:12:54 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>
Subject: Re: [patch 11/14] timekeeper read clock helper functions
Message-ID: <20090814131254.0ef001a2@skybase>
In-Reply-To: <1250206218.7149.13.camel@localhost.localdomain>
References: <20090813154034.613706651@de.ibm.com>
	<20090813154201.810817188@de.ibm.com>
	<1250206218.7149.13.camel@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009 16:30:18 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Thu, 2009-08-13 at 17:40 +0200, Martin Schwidefsky wrote:
> > Index: linux-2.6/kernel/time/timekeeping.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/time/timekeeping.c
> > +++ linux-2.6/kernel/time/timekeeping.c
> > @@ -95,6 +95,40 @@ static void timekeeper_setup_internals(s
> >  	timekeeper.mult = clock->mult;
> >  }
> > 
> > +/* Timekeeper helper functions. */
> > +static inline s64 timekeeping_get_ns(void)
> > +{
> > +	cycle_t cycle_now, cycle_delta;
> > +	struct clocksource *clock;
> > +
> > +	/* read clocksource: */
> > +	clock = timekeeper.clock;
> > +	cycle_now = clock->read(clock);
> > +
> > +	/* calculate the delta since the last update_wall_time: */
> > +	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> > +
> > +	/* return delta convert to nanoseconds using ntp adjusted mult. */
> > +	return clocksource_cyc2ns(cycle_delta, timekeeper.mult,
> > +				  timekeeper.shift);
> > +}
> 
> Again, not a huge issue, but if we kept the read() out of this function
> and instead passed the cycle_now value in as a argument, we could also
> use this function in  timekeeping_forward_now()

I actually tested how the code would look like if I do that. Didn't like
the result. The thing is that timekeeping_get_ns is a helper that is
supposed to reduce the number of lines you need in the caller. If you
push clock->read(clock) call back into the caller it doesn't help much ..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

