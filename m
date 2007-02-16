Return-Path: <linux-kernel-owner+w=401wt.eu-S1946283AbXBPWts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946283AbXBPWts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbXBPWtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:49:47 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:61404 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbXBPWtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:49:46 -0500
Subject: Re: Using sched_clock for mmio-trace
From: Daniel Walker <dwalker@mvista.com>
To: Jeff Muizelaar <jeff@infidigm.net>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070216221022.GA8721@infidigm.net>
References: <20070216013024.GA32287@infidigm.net>
	 <y0mr6sq2hfj.fsf@ton.toronto.redhat.com>
	 <1171647921.3422.12.camel@imap.mvista.com>
	 <20070216181027.GC6425@infidigm.net>
	 <1171650530.3422.25.camel@imap.mvista.com>
	 <20070216193428.GE6425@infidigm.net>
	 <1171659979.3422.60.camel@imap.mvista.com>
	 <20070216221022.GA8721@infidigm.net>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 14:47:45 -0800
Message-Id: <1171666065.3422.92.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 17:10 -0500, Jeff Muizelaar wrote:

> 
> I still meant for _with_features to have same semantics so calling:
> 
> clocksource_get_clock_with_features(CLOCKSOURCE_PM_UNAFFECTED|CLOCKSOURCE_STABLE
>  |CLOCKSOURC_ATOMIC|CLOCKSOURCE_64BITS|CLOCKSOURCE_CONTINUOUS);
> 
> would be equivalent to calling:
> 
> clocksource_get_masked_clock(CLOCKSOURCE_PM_AFFECTED|CLOCKSOURCE_UNSTABLE
>  |CLOCKSOURC_NOT_ATOMIC|CLOCKSOURCE_64BITS|CLOCKSOURCE_NOT_CONTINUOUS);
> 
> The only difference is that the naming is reversed. i.e. it isn't a
> doulbe negative.

Yes, I assumed that ..

> perhaps a better name would clocksource_get_clock_must_have() or
> clocksource_get_clock_must_be()
>  
> > Gets pretty ugly .. The clocksource interface already has a positive
> > rating to describe the "best" clocks in the system, which is used to
> > return the "best" clock .. Where the maintainers of the system give each
> > clock a rating. I would imagine most people would just get the so called
> > "best" clock which has the best rating..
> > 
> > I'm starting to think this long flags stringing effect could happen with
> > negative flags also, but it's seems a lot less likely.
> 
> The amount of flag stringing should be the same.

I don't think so .. The common case with negative flags is no flags,
then next would be CLOCKSOURCE_UNSTABLE. At most I would guess two
flags .. The other direction your likely to have people using all flags
most of the time. That's why I showed a function call with all the flags
listed.

To be clear the clocksources are already sorted with a rating (no flags
involved). 

So for example, On i386 the clocks are sorts as follows,

tsc (300)
acpi_pm (200)
pit (110)
jiffies (1)

So the bulk of the positive information is already there for you. The
tsc clock is by far the best in the system if it's stable. If you ignore
the flags, then you will always be given the tsc .

> > > instead of
> > > 
> > > clocksource_get_clock_masked(CLOCKSOURCE_UNSTABLE)
> > > clocksource_get_clock_masked(CLOCKSOURCE_PM_AFFECTED)
> > > 
> > > Especially awkward is the CLOCKSOURCE_64BIT flag, as there isn't really
> > > anyway to specify that I want a 64bit timer, only a way to specify that
> > > I don't.
> > 
> > I might add a way to get specific flags, but I still think the flags
> > should be mostly negative features.
> 
> Yeah, the problem is that all of the features are negative except for
> CLOCKSOURCE_64BIT, so you can't mask for it.

It's meant as a negative feature. So you can mask it if you can't handle
the math .. The only 64bit clock I know off is the tsc, and it's got the
highest rating of all clocks.


> It might be good if something like these explanations could be added as
> comments beside the feature flags.

Ok .. On my TODO list ..

> So, if I was a systemtap style user of the clocksource api, I'd still have to
> do something like:
> 
> init() {
> 	// assume this gives me the tsc
> 	clock = clocksource_get_masked_clock(CLOCKSOURCE_NOT_ATOMIC);
> 	register a cpu_freq notifier
> }
> 
> trace() {
> 	trace.time =
> 	compute_cyc2_ns_by_hand_using_info_from_cpu_freq(clocksource_read(clock))
> }
> 
> In this case it doesn't look like using the clocksource stuff helps this
> style of user much as all that is abstracted away is really the reading
> the tsc. On the other hand it sounds like if you want all this stuff
> taken care of for you, most people should be using do_gettimeofday()
> instead.

Instead of using an unstable clock and trying to compensate for it, the
solution is not to use unstable clocks. The clocksource stuff does help
with that.. You can either use the tsc until it becomes unstable, or use
the acpi_pm clock which never becomes unstable. Both are used in the
same way.

> init() {
	  // gives you the acpi_pm
	  clock = clocksource_get_masked_clock(CLOCKSOURCE_PM_AFFECTED|CLOCKSOURCE_NOT_ATOMIC);
> 	register a cpu_freq notifier
> }
> 
> trace() {
> 	trace.time =
	  cyc2ns(clock, clocksource_read(clock))
> }
> 


Daniel

