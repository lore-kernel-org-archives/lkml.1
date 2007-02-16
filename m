Return-Path: <linux-kernel-owner+w=401wt.eu-S1946147AbXBPVIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946147AbXBPVIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 16:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946242AbXBPVIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 16:08:21 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:34228 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946147AbXBPVIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 16:08:20 -0500
Subject: Re: Using sched_clock for mmio-trace
From: Daniel Walker <dwalker@mvista.com>
To: Jeff Muizelaar <jeff@infidigm.net>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070216193428.GE6425@infidigm.net>
References: <20070216013024.GA32287@infidigm.net>
	 <y0mr6sq2hfj.fsf@ton.toronto.redhat.com>
	 <1171647921.3422.12.camel@imap.mvista.com>
	 <20070216181027.GC6425@infidigm.net>
	 <1171650530.3422.25.camel@imap.mvista.com>
	 <20070216193428.GE6425@infidigm.net>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 13:06:19 -0800
Message-Id: <1171659979.3422.60.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 14:34 -0500, Jeff Muizelaar wrote:
> On Fri, Feb 16, 2007 at 10:28:50AM -0800, Daniel Walker wrote:
> > On Fri, 2007-02-16 at 13:10 -0500, Jeff Muizelaar wrote:
> > > On Fri, Feb 16, 2007 at 09:45:21AM -0800, Daniel Walker wrote:
> > > > I've been working on a patch set (below), to expose the clocksources
> > > > used by generic time to multiple users . It would allow timestamps from
> > > > different clocks in a generic way. It's not merged, but I'd appreciate
> > > > any input either of you might have..
> > > > 
> > > > ftp://source.mvista.com/pub/dwalker/clocksource/
> > > 
> > > Is it possible to see the resulting clocksource.h and maybe
> > > clocksource.c after the patch set? That would make looking at it much
> > > easier.
> > 
> > Well you could just apply the patch set, but I stuck them in the same
> > directory as above .. I'll delete them in 24 hours or so ..
> > 
> > At one point I replaced sched_clock() , 
> > 
> > ftp://source.mvista.com/pub/dwalker/clocksource/clocksource-v10/add_generic_sched_clock.patch
> > 
> > The API is similar to that version, and sched_clock was the simplest
> > user of the API that I've done.
> 
> Ok, so it would basically be:
> 
> init()
> {
> 	clocksource *clock = clocksource_get_best_clock();
> }
> 
> trace()
> {
> 	trace.time = cyc2ns(clock, clocksource_read(clock));
> }
> 
> This seems pretty sane to me. 

sched_clock has the down side of not taking into account rollover .. The
scheduler doesn't care if it gets a few bad timestamps now and then, but
that might screw up other code..

Also you could read cycles , and then later convert to nanoseconds when
it's needed .. Which makes taking the timestamps a little faster.

> The blk-trace code calibrates a per cpu offset for the sched_clock()
> time (see blk_trace_check_cpu_time and blk_trace_set_ht_offsets). Does
> the clocksource stuff help me with this or would I still need to do
> something like that?

Most of the clocksources are not per cpu .. But the tsc clocksource
doesn't keep any per cpu offset information. There has been some work on
syncing the TSC across cpus so I'm not sure to what extend an offset
would be needed.

> I also noticed that you have a clocksource_get_masked_clock() call. This
> seems like a pretty awkward API to me. The first thing that came to mind
> when I read the name was 'what is a masked clock'. When I realized that
> it meant 'a clock w/o this flag', I still found it awkward that one has
> to specify what that don't want. e.g 'I don't want a clock that is not
> continuous.'

yeah it is a little strange . 

> It think it would be better if you had sometime like
> 'clocksource_get_clock_with_features()' that took flags describing the
> needed characteristics instead of the unwanted ones.
> 
> e.g.
> clocksource_get_clock_with_features(CLOCKSOURCE_STABLE)
> or
> clocksource_get_clock_with_features(CLOCKSOURCE_PM_UNAFFECTED)
> 

One reason I did it the other way is because it's easier to specify what
you know you don't want, than to specify all the things that you know
you do want.

Almost everyone would want every flags listed,

clocksource_get_clock_with_features(CLOCKSOURCE_PM_UNAFFECTED|CLOCKSOURCE_STABLE
|CLOCKSOURC_ATOMIC|CLOCKSOURCE_64BITS|CLOCKSOURCE_CONTINUOUS);

Gets pretty ugly .. The clocksource interface already has a positive
rating to describe the "best" clocks in the system, which is used to
return the "best" clock .. Where the maintainers of the system give each
clock a rating. I would imagine most people would just get the so called
"best" clock which has the best rating..

I'm starting to think this long flags stringing effect could happen with
negative flags also, but it's seems a lot less likely.

> instead of
> 
> clocksource_get_clock_masked(CLOCKSOURCE_UNSTABLE)
> clocksource_get_clock_masked(CLOCKSOURCE_PM_AFFECTED)
> 
> Especially awkward is the CLOCKSOURCE_64BIT flag, as there isn't really
> anyway to specify that I want a 64bit timer, only a way to specify that
> I don't.

I might add a way to get specific flags, but I still think the flags
should be mostly negative features.

> It also isn't clear what the implications of some of the flags are:
> e.g:
> 	NOT_CONTINUOUS - don't really have any idea what this means.

It means the clock uses an interrupt to extend it's precision, or it's
not a real cycle counter and depends only on an interrupt for timing.

> 	UNSTABLE - this means the frequency can change right?
> 		Does PM_AFFECTED imply UNSTABLE?

PM_AFFECTED means it could become unstable, and CLOCKSOURC_UNSTABLE
means it's already become unstable.

> 	NOT_ATOMIC - does this affect me as user?

It could .. The PIT clock for example takes a spinlock. Some users might
not want to use that clock cause they call from a context where that
isn't acceptable (LTT for example). It's also slower to read from.

> 	PM_AFFECTED - it looks like the stp code deals with cpu speed
> 		changing. Does the clocksource code do this for me with
> 		cyc2ns?  If it does are there any reason I would want to
> 		avoid PM_AFFECTED clocks? If it doesn't how do I know
> 		that I need to correct it myself.

There is a block notification system that lets you know when a clock
becomes unstable . cyc2ns doesn't compensate for frequency changes . The
TSC for example could fluctuate frequency pretty often. sched_clock for
example uses the clock no matter what the state is , which is why I
leave unstable clock in the list.

> Hope this helps,

Yeah, thanks for the feedback .

Daniel

