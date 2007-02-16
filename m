Return-Path: <linux-kernel-owner+w=401wt.eu-S1751482AbXBPWJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbXBPWJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946141AbXBPWJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:09:27 -0500
Received: from epsilon2.look.ca ([207.136.100.6]:49411 "EHLO gozer.look.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750850AbXBPWJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:09:26 -0500
Date: Fri, 16 Feb 2007 17:10:22 -0500
To: Daniel Walker <dwalker@mvista.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Message-ID: <20070216221022.GA8721@infidigm.net>
References: <20070216013024.GA32287@infidigm.net> <y0mr6sq2hfj.fsf@ton.toronto.redhat.com> <1171647921.3422.12.camel@imap.mvista.com> <20070216181027.GC6425@infidigm.net> <1171650530.3422.25.camel@imap.mvista.com> <20070216193428.GE6425@infidigm.net> <1171659979.3422.60.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1171659979.3422.60.camel@imap.mvista.com>
User-Agent: Mutt/1.5.9i
From: Jeff Muizelaar <jeff@infidigm.net>
X-SA-Exim-Mail-From: jeff@infidigm.net
Subject: Re: Using sched_clock for mmio-trace
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Version: 3.1 (built Tue Feb 24 05:09:27 GMT 2004)
X-SA-Exim-Scanned: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 01:06:19PM -0800, Daniel Walker wrote:
> On Fri, 2007-02-16 at 14:34 -0500, Jeff Muizelaar wrote:
> > It think it would be better if you had sometime like
> > 'clocksource_get_clock_with_features()' that took flags describing the
> > needed characteristics instead of the unwanted ones.
> > 
> > e.g.
> > clocksource_get_clock_with_features(CLOCKSOURCE_STABLE)
> > or
> > clocksource_get_clock_with_features(CLOCKSOURCE_PM_UNAFFECTED)
> > 
> 
> One reason I did it the other way is because it's easier to specify what
> you know you don't want, than to specify all the things that you know
> you do want.
> 
> Almost everyone would want every flags listed,
> 
> clocksource_get_clock_with_features(CLOCKSOURCE_PM_UNAFFECTED|CLOCKSOURCE_STABLE
> |CLOCKSOURC_ATOMIC|CLOCKSOURCE_64BITS|CLOCKSOURCE_CONTINUOUS);

I still meant for _with_features to have same semantics so calling:

clocksource_get_clock_with_features(CLOCKSOURCE_PM_UNAFFECTED|CLOCKSOURCE_STABLE
 |CLOCKSOURC_ATOMIC|CLOCKSOURCE_64BITS|CLOCKSOURCE_CONTINUOUS);

would be equivalent to calling:

clocksource_get_masked_clock(CLOCKSOURCE_PM_AFFECTED|CLOCKSOURCE_UNSTABLE
 |CLOCKSOURC_NOT_ATOMIC|CLOCKSOURCE_64BITS|CLOCKSOURCE_NOT_CONTINUOUS);

The only difference is that the naming is reversed. i.e. it isn't a
doulbe negative.

perhaps a better name would clocksource_get_clock_must_have() or
clocksource_get_clock_must_be()
 
> Gets pretty ugly .. The clocksource interface already has a positive
> rating to describe the "best" clocks in the system, which is used to
> return the "best" clock .. Where the maintainers of the system give each
> clock a rating. I would imagine most people would just get the so called
> "best" clock which has the best rating..
> 
> I'm starting to think this long flags stringing effect could happen with
> negative flags also, but it's seems a lot less likely.

The amount of flag stringing should be the same.

> 
> > instead of
> > 
> > clocksource_get_clock_masked(CLOCKSOURCE_UNSTABLE)
> > clocksource_get_clock_masked(CLOCKSOURCE_PM_AFFECTED)
> > 
> > Especially awkward is the CLOCKSOURCE_64BIT flag, as there isn't really
> > anyway to specify that I want a 64bit timer, only a way to specify that
> > I don't.
> 
> I might add a way to get specific flags, but I still think the flags
> should be mostly negative features.

Yeah, the problem is that all of the features are negative except for
CLOCKSOURCE_64BIT, so you can't mask for it.

> > It also isn't clear what the implications of some of the flags are:
> > e.g:
> > 	NOT_CONTINUOUS - don't really have any idea what this means.
> 
> It means the clock uses an interrupt to extend it's precision, or it's
> not a real cycle counter and depends only on an interrupt for timing.
> 
> > 	UNSTABLE - this means the frequency can change right?
> > 		Does PM_AFFECTED imply UNSTABLE?
> 
> PM_AFFECTED means it could become unstable, and CLOCKSOURC_UNSTABLE
> means it's already become unstable.
> 
> > 	NOT_ATOMIC - does this affect me as user?
> 
> It could .. The PIT clock for example takes a spinlock. Some users might
> not want to use that clock cause they call from a context where that
> isn't acceptable (LTT for example). It's also slower to read from.
> 
> > 	PM_AFFECTED - it looks like the stp code deals with cpu speed
> > 		changing. Does the clocksource code do this for me with
> > 		cyc2ns?  If it does are there any reason I would want to
> > 		avoid PM_AFFECTED clocks? If it doesn't how do I know
> > 		that I need to correct it myself.
> 
> There is a block notification system that lets you know when a clock
> becomes unstable . cyc2ns doesn't compensate for frequency changes . The
> TSC for example could fluctuate frequency pretty often. sched_clock for
> example uses the clock no matter what the state is , which is why I
> leave unstable clock in the list.

It might be good if something like these explanations could be added as
comments beside the feature flags.

So, if I was a systemtap style user of the clocksource api, I'd still have to
do something like:

init() {
	// assume this gives me the tsc
	clock = clocksource_get_masked_clock(CLOCKSOURCE_NOT_ATOMIC);
	register a cpu_freq notifier
}

trace() {
	trace.time =
	compute_cyc2_ns_by_hand_using_info_from_cpu_freq(clocksource_read(clock))
}

In this case it doesn't look like using the clocksource stuff helps this
style of user much as all that is abstracted away is really the reading
the tsc. On the other hand it sounds like if you want all this stuff
taken care of for you, most people should be using do_gettimeofday()
instead.

-Jeff
