Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbYAPUtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbYAPUtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbYAPUtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:49:25 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:56332 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYAPUtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:49:24 -0500
Date: Wed, 16 Jan 2008 15:49:16 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
In-Reply-To: <20080116201713.GA14336@Krystal>
Message-ID: <Pine.LNX.4.58.0801161535320.16156@gandalf.stny.rr.com>
References: <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com>
 <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com>
 <20080116145604.GB31329@Krystal> <Pine.LNX.4.58.0801161003010.15758@gandalf.stny.rr.com>
 <20080116152838.GA970@Krystal> <Pine.LNX.4.58.0801161041010.15998@gandalf.stny.rr.com>
 <20080116170011.GA3651@Krystal> <Pine.LNX.4.58.0801161428180.14368@gandalf.stny.rr.com>
 <20080116201713.GA14336@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 16 Jan 2008, Mathieu Desnoyers wrote:
> >
> > In-other-words, latency_tracer is LTTng-lite ;-)
> >
>
> If LTTng is already ported to your specific kernel, the learning-curve
> is not big at all. Here is what the latency_tracer over LTTng guide
> could look like :
>
> Well, once you have LTTng in your kernel and have compiled and installed
> the ltt-control and lttv packages (configure, make, make install), all
> that would be needed is :
>
> (there may be some bits in the QUICKSTART GUIDE on
> http://ltt.polymtl.ca, like adding the debugfs mount to fstab and make sure
> the LTTng modules are loaded)
>
> #arm all the markers
> ltt-armall
> #start lttng tracing
> lttctl -n test -t /tmp/trace1 -d -l /mnt/debugfs/ltt
>
> -> start latency tracer
> -> stop latency tracer
> -> trigger latency tracer dump
>
> While the tracing is active, trigger the condition...
>
> (rince, repeat, can handle multiple latency tracer dumps)
>
> #stop lttng tracing
> lttctl -n test -R
> #disarm all markers
> ltt-disarmall
>
> You can easily test the trace with :
> lttv -m textDump -t /tmp/trace1
>
> Your users would issue something like :
>
> lttv -m latencytracerDump -t /tmp/trace1
>
> that's it. LatencytracerDump would be a new specialized plugin, inspired
> from the generic textDump.c plugin and from the state.c module (for
> hooking on specific events rather that on _all_ events). It would
> generate a text output from the trace collected at each latency tracer
> dump.
>

Mathieu,

That's quite a bit. Currently we have tools that already hook into
latency_tracer. e.g. Thomas Gleixner's cyclictest. It turns on the latency
tracer runs a quick test, turns it off. If the latency is ok, the trace is
discarded and it runs the test again. When the latency is not acceptable,
it stops the test. Then all one needs to do is look at the given trace.

Hooking something simple as this to LTTng is not going to fly.

Don't get me wrong, I'm a huge supporter of LTTng, and even recommend it.
But there's things that using LTTng for is like using a sledgehammer for
a tack.  I like to use the tools that are best for the job (which also
mean easiest).  I don't buy the one tracer fits all mentality. And by
pushing that too much, I'm thinking we'll never get a tracer into the
kernel.

What my goal of these patches is, is to get the infrastructure for tracing
into the kernel.  The latency_tracer is like Rusty Russells lguest is for
pvops. LTTng is the Xen equivalent. Where latency_tracer is nothing more
than the quick and dirty tracer. For administrators that want to analyze
their systems, LTTng is much more appropriate. latency_tracer is more of
the first aid in finding latency troubles, and if that doesn't work, then
we can do the LTTng surgery.

Lets go back and focus on the infrastructure again. Namely, the mcount and
notrace parts of the kernel. As well as the tracer timer, which by the
way, we are looking more into what you have done ;-)

-- Steve

