Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbYAJWwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbYAJWwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYAJWwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:52:08 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:59191 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbYAJWwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:52:05 -0500
Subject: Re: [RFC PATCH 13/22 -v2] handle accurate time keeping over long
	delays
From: john stultz <johnstul@us.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tony Luck <tony.luck@intel.com>, bob.picco@hp.com,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20080110220012.GA9508@Krystal>
References: <20080109232914.676624725@goodmis.org>
	 <20080109233044.288563621@goodmis.org>
	 <1199923219.6350.16.camel@localhost.localdomain>
	 <12c511ca0801101154q224c7a43sa016190cf209d304@mail.gmail.com>
	 <1199996959.6108.18.camel@localhost.localdomain>
	 <20080110204259.GB5836@Krystal>
	 <1200000314.30225.30.camel@localhost.localdomain>
	 <20080110220012.GA9508@Krystal>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 14:51:57 -0800
Message-Id: <1200005517.30225.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 17:00 -0500, Mathieu Desnoyers wrote:
> * john stultz (johnstul@us.ibm.com) wrote:
> > 
> > On Thu, 2008-01-10 at 15:42 -0500, Mathieu Desnoyers wrote:
> > > I think it's about time I introduce the approach I have taken for LTTng
> > > timestamping. Basically, one of the main issues with the clock sources
> > > is the xtime lock : having a read seqlock nested over a write seqlock is
> > > a really, really bad idea. This can happen with NMIs. Basically, it
> > > would cause a deadlock.
> > > 
> > > What I have done is an RCU algorithm that extends a 32 bits TSC (that's
> > > the case on MIPS, for instance) to 64 bits. The update of the MSBs is
> > > done by a periodical timer (fired often enough to make sure we always
> > > detect the 32 LSBs wrap-around) and the read-side only has to disable
> > > preemption.
> > > 
> > > I use a 2 slots array, each of them keeping, alternatively, the last 64
> > > bits counter value, to implement the RCU algorithm.
> > > 
> > > Since we are discussing time source modification, this is one that I
> > > would really like to see in the Linux kernel : it would provide the kind
> > > of time source needed for function entry/exit tracing and for generic
> > > kernel tracing as well.
> > 
> > Hmm. I know powerpc has had a similar lock-free dual structure method
> > and for just a raw cycles based method you've shown below (or for some
> > of the bits Steven is working on), I think it should be fine.
> > 
> > The concern I've had with this method for general timekeeping, is that
> > I'm not sure it can handle the frequency corrections made by NTP. Since
> > we have to make sure time does not jump backwards, consider this
> > exaggerated situation:
> > 
> > time = base + (now - last)*mult;
> > 
> > So we have two structures:
> > base: 60		base: 180
> > last: 10		last: 30
> > mult: 06		mult: 05
> > 
> > Where the second structure has just been updated lock-free, however just
> > before the atomic pointer switch we were preempted, or somehow delayed,
> > and some time has past.
> > 
> > Now imagine two cpus now race to get the time. Both read the same now
> > value, but get different structure pointer values. (Note: You can create
> > the same race if you reverse the order and grab the pointer first, then
> > the cycle. However I think this example makes it easier to understand).
> > 
> > now = 50
> > cpu1:
> >   60 + (50-10)*6 = 300
> > cpu2:
> >   180 + (50-30)*5 = 280
> > 
> > 
> > Alternatively:
> > now=50: 60 + (50-10)*6 = 300
> > now=51: 180 + (51-30)*5 = 285
> > 
> > Eek. That's not good.
> > 
> > I'm not sure how this can be avoided, but I'd be very interested in
> > hearing ideas! Bounding the issue is a possibility, but then starts to
> > run amok with NO_HZ and -rt deferment.
> > 
> > thanks
> > -john
> > 
> 
> I suggest we try to see the problem differently (and see how far we can
> get with this) :
> 
> Let's suppose we have a 32 bits cycles counter given by the
> architecture. We use the lockless algorithm to extend it to 64 bits : we
> therefore have a 64 bits cycle counter that can be read locklessly.
> 
> Then, from this 64 bits counter (let's call it "now") (which has the
> advantage of never overflowing, or after enough years so nobody
> cares...), we can calculate the current time with :

Hmm. Maybe I'm missing something here. I'm not sure I'm following the
importance of the 64bit extension. 

The clocksource code deals with counters in a range of widths (from
64bit TSC to 24bit ACPI PM). The only requirement there is that have
accumulate often enough that it doesn't wrap twice between
accumulations. Currently this is done in update_wall_time(), but the
patch Steven sent that started this thread adds an interim step using
cycle_accumulated, allowing update_wall_time() to be deferred for longer
periods of time.

I do see how the method you're describing could be applied to just the
cycle_accumulated management, and maybe that's the whole point?

However my concern is that when we do the frequency adjustment in
update_wall_time, I'm not sure the method works. Thus we still would
have to have a lock in there for gettimeofday().

But let's continue...

> time = base + (now - last) * mul
> 
> NTP would adjust time by modifying mul, last and base; base would be
> recalculated from the formula with : base + (now - last) * mul each time
> we modify the clock rate (mul), we also read the current "now" value
> (which is saved as "last"). This would be done system-wide and would be
> kept in a data structure separate from the 2 64 bits slots array.
> Ideally, this NTP correction update could also be done atomically with a
> 2 slots array.
> 
> Whenever we need to read the time, we then have to insure that the "now"
> value we use is consistent with the current NTP time correction. We want
> to eliminate races where we would use value from the wrong NTP "window"
> with a "now" value not belonging to this window. (an NTP window would be
> defined by a tuple of base, last and mul values)
> 
> If "now" is lower than "last", we are using an old timestamp with a
> new copy of the structure and must therefore re-read the "now" value.

Ok, that would avoid one type of error, but in both of my examples in
the last mail, now was greater then last.

> If, when we are about to return the "time" value calculated, we figure
> out that the current NTP window pointer have changed, we must make sure
> that the time value we are about to return is lower than the new base or
> otherwise time could go backward. If we detect that time is higher than
> the new base, we re-read the "now" value and re-do the calculation.

Again, I'm not sure I see how this resolves the previous example given,
as in that case the update code was delayed in between its reading of
now and the final pointer change.

The issue is that the race isn't just between the readers and the
writer, but that time races against writer as well. So if you don't lock
the readers out during the write, I'm not sure how you can avoid the
window for inconsistencies.

thanks
-john


