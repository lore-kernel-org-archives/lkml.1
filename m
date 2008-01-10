Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbYAJAZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbYAJAZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbYAJAZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:25:05 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:54395 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbYAJAZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:25:03 -0500
Date: Wed, 9 Jan 2008 19:25:00 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: john stultz <johnstul@us.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 13/22 -v2] handle accurate time keeping over long
 delays
In-Reply-To: <1199924357.6350.27.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0801091924150.5513@gandalf.stny.rr.com>
References: <20080109232914.676624725@goodmis.org>  <20080109233044.288563621@goodmis.org>
 <1199924357.6350.27.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 9 Jan 2008, john stultz wrote:
> > Index: linux-compile-i386.git/kernel/time/timekeeping.c
> > ===================================================================
> > --- linux-compile-i386.git.orig/kernel/time/timekeeping.c	2008-01-09 14:07:34.000000000 -0500
> > +++ linux-compile-i386.git/kernel/time/timekeeping.c	2008-01-09 15:17:31.000000000 -0500
> > @@ -448,27 +449,29 @@ static void clocksource_adjust(s64 offse
> >   */
> >  void update_wall_time(void)
> >  {
> > -	cycle_t offset;
> > +	cycle_t cycle_now, offset;
> >
> >  	/* Make sure we're fully resumed: */
> >  	if (unlikely(timekeeping_suspended))
> >  		return;
> >
> >  #ifdef CONFIG_GENERIC_TIME
> > -	offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
> > +	cycle_now = clocksource_read(clock);
> >  #else
> > -	offset = clock->cycle_interval;
> > +	cycle_now = clock->cycle_last + clock->cycle_interval;
> >  #endif
> > +	offset = (cycle_now - clock->cycle_last) & clock->mask;
>
> It seems this offset addition was to merge against the colliding
> xtime_cache changes in mainline. However, I don't think its quite right,
> and might be causing incorrect time() or vtime() results if NO_HZ is
> enabled.

Yeah, this had a bit of clashes in its life in the RT kernel.

>
> > +	clocksource_accumulate(clock, cycle_now);
> > +
> >  	clock->xtime_nsec += (s64)xtime.tv_nsec << clock->shift;
> >
> >  	/* normally this loop will run just once, however in the
> >  	 * case of lost or late ticks, it will accumulate correctly.
> >  	 */
> > -	while (offset >= clock->cycle_interval) {
> > +	while (clock->cycle_accumulated >= clock->cycle_interval) {
> >  		/* accumulate one interval */
> >  		clock->xtime_nsec += clock->xtime_interval;
> > -		clock->cycle_last += clock->cycle_interval;
> > -		offset -= clock->cycle_interval;
> > +		clock->cycle_accumulated -= clock->cycle_interval;
> >
> >  		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
> >  			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
> > @@ -482,7 +485,7 @@ void update_wall_time(void)
> >  	}
> >
> >  	/* correct the clock when NTP error is too big */
> > -	clocksource_adjust(offset);
> > +	clocksource_adjust(clock->cycle_accumulated);
>
>
> I suspect the following is needed, but haven't been able to test it yet.

Thanks, I'll pull it in and start testing it.

-- Steve

