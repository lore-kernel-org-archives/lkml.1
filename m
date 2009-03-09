Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbZCIXBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbZCIXBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 19:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZCIXBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 19:01:37 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:51786 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbZCIXBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 19:01:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18869.40904.382716.827097@cargo.ozlabs.ibm.com>
Date: Tue, 10 Mar 2009 10:01:28 +1100
From: Paul Mackerras <paulus@samba.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] Performance Counters for Linux, v6
In-Reply-To: <20090309013902.GK10085@erda.amd.com>
References: <20090121185021.GA8852@elte.hu>
	<20090309013902.GK10085@erda.amd.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter writes:

> Some points to mention here. This patch set actually introduces two
> interfaces, a new user/kernel interface and an in-kernel api to access
> performance counters. These are separate things and sometimes mixed
> too much. There is a strong need for an in-kernel api. This is the

We have been concentrating more on the user/kernel API since that is
the one that cannot be changed in an incompatible way once this stuff
goes upstream.  The in-kernel API can be changed at any time and is
still evolving.

> third implementation I am involved (oprofile, perfmon are the others)
> and the things are always the same way. All these subsystems should be
> merged to one in-kernel implemenation and share the same code. The
> different user/kernel i/fs could then coexist and meet the users
> different needs.

It would certainly be good to get oprofile to use the same low-level
machinery as perf_counters.  I'm not sure what the fate of perfmon
will be, but it seems unlikely it will go upstream in anything like
its present form.

> > +static const int intel_perfmon_event_map[] =
> > +{
> > +  [PERF_COUNT_CPU_CYCLES]		= 0x003c,
> > +  [PERF_COUNT_INSTRUCTIONS]		= 0x00c0,
> > +  [PERF_COUNT_CACHE_REFERENCES]		= 0x4f2e,
> > +  [PERF_COUNT_CACHE_MISSES]		= 0x412e,
> > +  [PERF_COUNT_BRANCH_INSTRUCTIONS]	= 0x00c4,
> > +  [PERF_COUNT_BRANCH_MISSES]		= 0x00c5,
> > +  [PERF_COUNT_BUS_CYCLES]		= 0x013c,
> > +};
> 
> I would like to define _all_ the behaviour of the architecture and the
> models in functions instead of parameters and lists. It is hard to
> explain why, because it is more esthetics, but I believe, only nice
> things work best. Let me try.
> 
> 1) The list above seems to be random, there are lots of events and it
> is hard to define, which event is really important. Surely these
> events are important, but it is hard to draw a line here.

I see that list as a convenience for doing a few simple performance
measurements.  For any serious in-depth analysis userspace will know
what processor it's running on and use raw event codes.

> 2) The list assumes/implies the events are available on all
> architectures and cpus. This is probably not the case, and also, the
> existence of an event must not be _important_ for a certain
> architecture. But it has to be there even if it is of no interest.
> 
> 3) Hard to extend. If an event is added here this could have impact to
> all other architectures. Data structures are changing.
> 
> 4) In the kernel the behaviour of a subsystem is offen implemented by
> functions (e.g. struct device_driver). There are lots of ops structs
> in the kernel and there are reasons for it.
> 
> 5) ops structs are more dynamic. The data could be generated
> dynamically and does not have to be static in some tables and
> variables.
> 
> So, instead of making the list a public data structure, better pass
> the type to an arch specific function, e.g.:
> 
> int arch_xxx_setup_event(int event_type);

That's exactly what we have, except that it's called
hw_perf_counter_init and the event_type you have there is in the
struct perf_counter that gets passed in.

> If the type is not supported, an error could be returned. There is no
> more impact. Even the binaries of the builds would be identically if
> hw_event_types would be extended for a single different architecture.
> 
> The same applies also for counters and so on, better implement
> functions.

All of that is already done; hw_perf_counter_init gets to interpret
the counter->hw_event.type and counter->hw_event.raw fields and decide
whether the event is supported, and return an error if not.  On x86 it
looks like there is a further ops structure (struct pmc_x86_ops) which
allows each x86-compatible cpu type to supply its own functions for
doing the interpretation of counter->hw_event and other things.

Paul.
