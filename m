Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbZGVHdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbZGVHdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 03:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZGVHdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 03:33:17 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:60345 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZGVHdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 03:33:16 -0400
Date: Wed, 22 Jul 2009 09:33:13 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [RFC][patch 3/5] remove clocksource inline functions
Message-ID: <20090722093313.14eda4db@skybase>
In-Reply-To: <1248213835.3298.112.camel@localhost>
References: <20090721191745.788551122@de.ibm.com>
	<20090721192059.454927873@de.ibm.com>
	<1248213835.3298.112.camel@localhost>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009 15:03:55 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Tue, 2009-07-21 at 21:17 +0200, Martin Schwidefsky wrote:
> > plain text document attachment (clocksource-inline.diff)
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > 
> > Remove clocksource_read, clocksource_enable and clocksource_disable
> > inline functions. No functional change.
> > 
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: john stultz <johnstul@us.ibm.com>
> > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > ---
> >  kernel/time/clocksource.c |   18 ++++++++++++------
> >  kernel/time/timekeeping.c |   13 ++++++-------
> >  2 files changed, 18 insertions(+), 13 deletions(-)
> 
> 
> There's a patch Magnus has that (should be) queued for 2.6.31 that makes
> unbreaks the mult_orig manipulations enable/disable does. I suspect this
> will cause this inline function removing to not be that much of a
> benefit.

After moving the enable/disable code over to clocksource.c there is no
reason for the inline function anymore, no?

> > Index: linux-2.6/kernel/time/clocksource.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/time/clocksource.c
> > +++ linux-2.6/kernel/time/clocksource.c
> > @@ -517,7 +517,7 @@ void clocksource_forward_now(void)
> >  	cycle_t cycle_now, cycle_delta;
> >  	s64 nsec;
> > 
> > -	cycle_now = clocksource_read(clock);
> > +	cycle_now = clock->read(clock);
> >  	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> >  	clock->cycle_last = cycle_now;
> > 
> > @@ -567,16 +567,19 @@ void change_clocksource(void)
> > 
> >  	clocksource_forward_now();
> > 
> > -	if (clocksource_enable(new))
> > +	if (new->enable && !new->enable(new))
> >  		return;
> > 
> > +	/* save mult_orig after successful enable */
> > +	new->mult_orig = new->mult;
> > +
> >  	new->raw_time = clock->raw_time;
> >  	old = clock;
> >  	clock = new;
> > -	clocksource_disable(old);
> > +	if (old->disable)
> > +		old->disable(old);
> 
> 	mult_orig needs to be saved to mult at this point.

Yes, it would make sense to do that. The old code doesn't so I did not
want to add it in a cleanup patch. That should be a patch on its own.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

