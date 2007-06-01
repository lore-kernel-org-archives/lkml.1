Return-Path: <linux-kernel-owner+w=401wt.eu-S1762990AbXFATdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762990AbXFATdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761446AbXFATd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:33:28 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:50251 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761383AbXFATd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:33:27 -0400
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070601181938.GA30526@elte.hu>
References: <20070529130107.112347096@chello.nl>
	 <1180470525.32594.71.camel@imap.mvista.com>
	 <20070530132431.GA23947@elte.hu>
	 <Pine.LNX.4.58.0705300936390.15841@gandalf.stny.rr.com>
	 <20070530134907.GA27085@elte.hu>
	 <1180544796.32594.184.camel@imap.mvista.com>
	 <1180545380.2958.1.camel@lappy>
	 <1180545913.32594.194.camel@imap.mvista.com>
	 <20070601131249.GA17059@elte.hu>
	 <1180711606.15884.32.camel@imap.mvista.com>
	 <20070601181938.GA30526@elte.hu>
Content-Type: text/plain
Date: Fri, 01 Jun 2007 12:30:36 -0700
Message-Id: <1180726236.15884.102.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-01 at 20:19 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > > > > I see sched_clock() as fast first, accurate second. Whereas the 
> > > > > clocksource thing is accurate first, fast second.
> > > > 
> > > > This is true .. However, if there is a speed different it's small.
> > > 
> > > Ugh. Have you ever compared pmtimer (or even hpet) against TSC based 
> > > sched_clock()? What you write is so wrong that it's not even funny. 
> > > You keep repeating this nonsense despite having been told multiple 
> > > times that you are dead wrong.
> > 
> > Yes I have, and your right there is a difference, and a big difference 
> > .. Above I was referring only to the TSC clocksource, since that's an 
> > apples to apples comparison .. I would never compare the TSC to the 
> > acpi_pm, that's no contest ..
> 
> You still dont get it i think: in real life we end up using the TSC in 
> sched_clock() _much more often_ than we end up using the TSC for 
> clocksource! So your flawed suggestion does not fix anything, it in fact 
> introduces a really bad regression: instead of using the TSC (or 
> jiffies) we'd end up using the pmtimer or hpet for every lock operation 
> when lockstat is enabled, bringing the box to a screeching halt in 
> essence.

My position isn't that we should use the high level clocksource
interface as it is now without changes .. That's never been my position
since I've been working with it.. The high level interface will need to
evolve. 

I'm saying we should use the clocksource structure as the main hook into
the low level architecture code. 

> so what you suggest has a far worse effect on the _majority_ of systems 
> that are even interested in running lockstat, than the case you 
> mentioned that some seldom-used arch which is lazy about sched_clock() 
> falls back to jiffies granularity. It's not a big deal: the stats will 
> have the same granularity. (the op counts in lockstat will still be 
> quite useful)

My suggestion is only as good as the implementation .. Your making some
fairly sweeping assumption about how lockstat _would_ use the
clocksources in it's final form ..

So clearly lockstat has a contraint which is that it can't use slow
clocks.. 

> sched_clock() is a 'fast but occasionally inaccurate clock', while the 
> GTOD clocksource is an accurate clock (but very often slow).

I think we're just taking different perspectives .. The tsc clocksource
is just as fast as the tsc sched_clock() , you can interchange the two
without ill effects .. That's one perspective ..

You can use a yet to be written API that uses the GTOD and a
clocksource, and allows slow clocksources to be used in place of fast
ones with really bad effects, that's another perspective ..

Daniel

