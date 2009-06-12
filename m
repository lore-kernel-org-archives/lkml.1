Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbZFLFIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbZFLFIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 01:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbZFLFIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 01:08:31 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:50250 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbZFLFIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 01:08:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18993.58058.194954.997480@drongo.ozlabs.ibm.com>
Date: Fri, 12 Jun 2009 15:08:26 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] perf_counter: powerpc: Implement generalized cache
	events for POWER processors
In-Reply-To: <20090611100720.GC12703@elte.hu>
References: <18992.36329.189378.17992@drongo.ozlabs.ibm.com>
	<18992.36430.933526.742969@drongo.ozlabs.ibm.com>
	<20090611100720.GC12703@elte.hu>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> Ah, cool! I tried to construct the table so that Power would be able 
> to fill it in a meaningful way - it seems like that was indeed 
> possible.

Yes, by and large.  The coverage is a little spotty on some processors
but there's enough there to be useful IMO.

> Any particular observations you have about the cache events 
> generalization? Would you do more of them (which ones?), fewer of 
> them?

One thing I noticed is that most of our processors have events for
counting how many times data for a load comes from each of various
sources.  On our larger machines it's not a simple hierarchy because
data can come from an L2 or L3 cache in another chip or another node,
or from memory.  On POWER6 for example there are separate events for
data being loaded from each possible source, further divided up by the
cacheline state (shared or modified) for the cache sources.  So we
have ~ 18 separate data source events for POWER6 (not counting the L1
hit case).  And similarly for events counting where instructions are
fetched from and where PTEs are fetched from.

It's a slightly different way of looking at things, I guess, looking
at the distribution of where a processor is getting its data from
instead of focusing on a particular cache and counting how often it
does or doesn't supply data on request.

Does x86 have anything similar?

> We can also add transparent fallback logic to the tools perhaps: for 
> example a 'hits == total-misses' combo counter.
> 
> This can be expressed in the sampling space too: the latest tools do 
> weighted samples, so we can actually do _negative_, weighted 
> sampling: the misses can subtract from a function's ->count value.

Cute, I hadn't noticed that.

> I dont know whether we should do such combo counters in the kernel 
> itself - i'm slightly against that notion. (seems complex)

Yeah.

When thinking about having "composite" events, i.e. a counter whose
value is computed from two or more hardware counters, I couldn't see
how to do sampling in the general case.  It's easy if we're just
adding multiple counters, but sampling when subtracting counters is
hard.  For example, if you want to sample every N cache hits, and
you're computing hits as accesses - misses, I couldn't see a decent
way to know when to take the sample, not without having to take an
interrupt on every access in some circumstances.

> One last-minute change we are thinking about is to change 'L2' to 
> 'LLC'. This matters on systems which have a L3 cache. The first 
> level and the last level cache are generally the most important 
> ones. What do you think?

It's probably a good idea.  I'll have to put in code to detect whether
the system has L3 caches and adjust the table (or switch to a
different table), but that's doable.

There aren't "last level cache" events on POWER processors, except to
the extent that the "data loaded from memory" events imply that no
cache had the data.  But there's 3 separate memory-source events on
POWER6, for instance, for memory attached to this core, another core
in this node, or another node.

Actually, it looks like the L3 miss event we have on POWER6 for
instance just refers to the local L3.  It could be a miss in the local
L3 but a hit in the L3 in another node, so the data will come from the
remote L3 but still be counted as an L3 miss.

> > +	[C(BPU)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
> > +		[C(OP_READ)] = {	0x430e6,	0x400052	},
> > +		[C(OP_WRITE)] = {	-1,		-1		},
> > +		[C(OP_PREFETCH)] = {	-1,		-1		},
> 
> Ah, the RESULT_ACCESS/RESULT_MISS tabularization is a nice aesthetic 
> touch - will do that for x86 too.

Yeah, it is quite clear while using only 1/4 of the vertical space.

> Btw., a very small nit, any way i could convince you to do such 
> mass-initializations in the Power code, in the way we do elsewhere 
> in perfcounters, by using vertical spacing:

Sure.

Paul.
