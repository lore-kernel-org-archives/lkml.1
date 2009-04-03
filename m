Return-Path: <linux-kernel-owner+w=401wt.eu-S933962AbZDCQ6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933962AbZDCQ6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758689AbZDCQ6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:58:14 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:50576 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbZDCQ6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:58:13 -0400
X-SourceIP: 213.93.53.227
Subject: Re: perf_counter: request for three more sample data options
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>, Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090403164135.GB3047@elte.hu>
References: <49D56A7E.80908@linux.vnet.ibm.com>
	 <1238742064.798.8.camel@twins> <49D5B9E7.1020400@linux.vnet.ibm.com>
	 <1238745077.798.17.camel@twins>
	 <18901.52735.579687.568717@cargo.ozlabs.ibm.com>
	 <20090403163756.GH3226@erda.amd.com>  <20090403164135.GB3047@elte.hu>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 18:59:14 +0200
Message-Id: <1238777954.798.266.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 18:41 +0200, Ingo Molnar wrote:
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > On 03.04.09 19:51:11, Paul Mackerras wrote:
> > > Peter Zijlstra writes:
> > > 
> > > > What I was thinking of was re-using some of the cpu_clock()
> > > > infrastructure. That provides us with a jiffy based GTOD sample,
> > > > cpu_clock() then uses TSC and a few filters to compute a current
> > > > timestamp.
> > > > 
> > > > I was thinking about cutting back those filters and thus trusting the
> > > > TSC more -- which on x86 can do any random odd thing. So provided the
> > > > TSC is not doing funny the results will be ok-ish.
> > > > 
> > > > This does mean however, that its not possible to know when its gone bad.
> > > 
> > > I would expect that perfmon would be just reading the TSC and
> > > recording that.  If you can read the TSC and do some correction then
> > > we're ahead. :)
> > > 
> > > > The question to Paul is, does the powerpc sched_clock() call work in NMI
> > > > -- or hard irq disable -- context?
> > > 
> > > Yes - timekeeping is one area where us powerpc guys can be smug. 
> > > :) We have a per-core, 64-bit timebase register which counts at 
> > > a constant frequency and is synchronized across all cores.  So 
> > > sched_clock works in any context on powerpc - all it does is 
> > > read the timebase and do some simple integer arithmetic on it.
> > 
> > Ftrace is using ring_buffer_time_stamp() that finally uses 
> > sched_clock(). But I am not sure if the time is correct when 
> > calling from an NMI handler.
> 
> Yeah, that's a bit icky. Right now we have the following 
> accelerator:
> 
> u64 sched_clock_cpu(int cpu)
> {
>         u64 now, clock, this_clock, remote_clock;
>         struct sched_clock_data *scd;
> 
>         if (sched_clock_stable)
>                 return sched_clock();
> 
> which works rather well on CPUs that set sched_clock_stable. Do you 
> think we could set it on Barcelona?

I think you should couple it to the tsc clocksource detection thingy. On
all systems the tsc is good enough to use as clocksource, we can
short-circuit.

> in the non-stable case we chicken out:
> 
>         /*
>          * Normally this is not called in NMI context - but if it is,
>          * trying to do any locking here is totally lethal.
>          */
>         if (unlikely(in_nmi()))
>                 return scd->clock;
> 
> as we'd have to take a spinlock which isnt safe from NMI context.

Right, I've been looking at doing cpu_clock() differently, but since its
all 64-bit we'd either need to introduce atomic64 into the code, or redo
it in the perf counter code.

So for now I've stuck with a plain sched_clock() timestamp.

