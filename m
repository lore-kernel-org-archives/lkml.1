Return-Path: <linux-kernel-owner+w=401wt.eu-S1946049AbXBPTdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946049AbXBPTdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932426AbXBPTdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:33:35 -0500
Received: from gamma2.look.ca ([207.136.100.4]:46623 "EHLO gatekeeper.look.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932423AbXBPTde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:33:34 -0500
Date: Fri, 16 Feb 2007 14:34:28 -0500
To: Daniel Walker <dwalker@mvista.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Message-ID: <20070216193428.GE6425@infidigm.net>
References: <20070216013024.GA32287@infidigm.net> <y0mr6sq2hfj.fsf@ton.toronto.redhat.com> <1171647921.3422.12.camel@imap.mvista.com> <20070216181027.GC6425@infidigm.net> <1171650530.3422.25.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1171650530.3422.25.camel@imap.mvista.com>
User-Agent: Mutt/1.5.9i
From: Jeff Muizelaar <jeff@infidigm.net>
X-SA-Exim-Mail-From: jeff@infidigm.net
Subject: Re: Using sched_clock for mmio-trace
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Version: 3.1 (built Tue Feb 24 05:09:27 GMT 2004)
X-SA-Exim-Scanned: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 10:28:50AM -0800, Daniel Walker wrote:
> On Fri, 2007-02-16 at 13:10 -0500, Jeff Muizelaar wrote:
> > On Fri, Feb 16, 2007 at 09:45:21AM -0800, Daniel Walker wrote:
> > > I've been working on a patch set (below), to expose the clocksources
> > > used by generic time to multiple users . It would allow timestamps from
> > > different clocks in a generic way. It's not merged, but I'd appreciate
> > > any input either of you might have..
> > > 
> > > ftp://source.mvista.com/pub/dwalker/clocksource/
> > 
> > Is it possible to see the resulting clocksource.h and maybe
> > clocksource.c after the patch set? That would make looking at it much
> > easier.
> 
> Well you could just apply the patch set, but I stuck them in the same
> directory as above .. I'll delete them in 24 hours or so ..
> 
> At one point I replaced sched_clock() , 
> 
> ftp://source.mvista.com/pub/dwalker/clocksource/clocksource-v10/add_generic_sched_clock.patch
> 
> The API is similar to that version, and sched_clock was the simplest
> user of the API that I've done.

Ok, so it would basically be:

init()
{
	clocksource *clock = clocksource_get_best_clock();
}

trace()
{
	trace.time = cyc2ns(clock, clocksource_read(clock));
}

This seems pretty sane to me. 

The blk-trace code calibrates a per cpu offset for the sched_clock()
time (see blk_trace_check_cpu_time and blk_trace_set_ht_offsets). Does
the clocksource stuff help me with this or would I still need to do
something like that?

I also noticed that you have a clocksource_get_masked_clock() call. This
seems like a pretty awkward API to me. The first thing that came to mind
when I read the name was 'what is a masked clock'. When I realized that
it meant 'a clock w/o this flag', I still found it awkward that one has
to specify what that don't want. e.g 'I don't want a clock that is not
continuous.'

It think it would be better if you had sometime like
'clocksource_get_clock_with_features()' that took flags describing the
needed characteristics instead of the unwanted ones.

e.g.
clocksource_get_clock_with_features(CLOCKSOURCE_STABLE)
or
clocksource_get_clock_with_features(CLOCKSOURCE_PM_UNAFFECTED)


instead of:

clocksource_get_clock_masked(CLOCKSOURCE_UNSTABLE)
clocksource_get_clock_masked(CLOCKSOURCE_PM_AFFECTED)

Especially awkward is the CLOCKSOURCE_64BIT flag, as there isn't really
anyway to specify that I want a 64bit timer, only a way to specify that
I don't.

It also isn't clear what the implications of some of the flags are:
e.g:
	NOT_CONTINUOUS - don't really have any idea what this means.
	UNSTABLE - this means the frequency can change right?
		Does PM_AFFECTED imply UNSTABLE?
	NOT_ATOMIC - does this affect me as user?
	PM_AFFECTED - it looks like the stp code deals with cpu speed
		changing. Does the clocksource code do this for me with
		cyc2ns?  If it does are there any reason I would want to
		avoid PM_AFFECTED clocks? If it doesn't how do I know
		that I need to correct it myself.

Hope this helps,

-Jeff
