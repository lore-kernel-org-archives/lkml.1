Return-Path: <linux-kernel-owner+w=401wt.eu-S965663AbXCTSkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965663AbXCTSkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965753AbXCTSkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:40:17 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49506 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965825AbXCTSju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:39:50 -0400
Subject: Re: [PATCH] time : SMP friendly alignment of struct clocksource
From: john stultz <johnstul@us.ibm.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1174413862.3101.185.camel@imap.mvista.com>
References: <20070320110936.1e445e6e.dada1@cosmosbay.com>
	 <1174413482.17430.1.camel@localhost>
	 <1174413862.3101.185.camel@imap.mvista.com>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 11:38:01 -0700
Message-Id: <1174415881.17430.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 11:04 -0700, Daniel Walker wrote:
> On Tue, 2007-03-20 at 10:58 -0700, john stultz wrote:
> 
> > >  	/* timekeeping specific data, ignore */
> > > -	cycle_t cycle_last, cycle_interval;
> > > -	u64 xtime_nsec, xtime_interval;
> > > +	cycle_t cycle_interval;
> > > +	u64	xtime_interval;
> > > +	/*
> > > +	 * Second part is written at each timer interrupt
> > > +	 * Keep it in a different cache line to dirty no
> > > +	 * more than one cache line.
> > > +	 */
> > > +	cycle_t cycle_last ____cacheline_aligned_in_smp;
> > > +	u64 xtime_nsec;
> > >  	s64 error;
> 
> What was the motivation for having these (cycle_last for example) in the
> clocksource structure. I recall them being added in there at one point,
> but I'm not sure why.. Specifically the ones that are updated often.

Roman claimed it produced better code, and the values are functionally
clocksource specific (meaning if the clocksource changed, and they were
global, you would have to reset them anyway).

I think logically those values are more timekeeping oriented then
clocksource oriented, but one could argue that since we manipulate
clocksource.mult in the timekeeping's NTP code, mult is timekeeping
specific as well.

If you really wanted a clean design, you'd probably have to keep all of
those values as a timekeeping_clocksource struct, and then have smaller
clocksource structs (name, mult, shift, read) that is filled in by the
clocksource driver and copied over on clocksource changes. That way the
timekeeping code wouldn't manipulate the clocksource structure directly.

But really, it seems like work for little to no reward (plus opens the
issue of "but i want a ntp frequency adjusted sched_clock!" which would
not be possible).

-john

