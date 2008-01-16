Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYAPP7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYAPP7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 10:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYAPP6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 10:58:54 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:58248 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYAPP6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 10:58:53 -0500
Date: Wed, 16 Jan 2008 10:58:43 -0500 (EST)
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
In-Reply-To: <20080116152838.GA970@Krystal>
Message-ID: <Pine.LNX.4.58.0801161041010.15998@gandalf.stny.rr.com>
References: <20080109232914.676624725@goodmis.org> <20080109233044.777564395@goodmis.org>
 <20080115214636.GD17439@Krystal> <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com>
 <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com>
 <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com>
 <20080116145604.GB31329@Krystal> <Pine.LNX.4.58.0801161003010.15758@gandalf.stny.rr.com>
 <20080116152838.GA970@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jan 2008, Mathieu Desnoyers wrote:
> > No, there's probably issues there too, but no need to worry about it,
> > since I already showed that allowing for clocksource_accumulate to happen
> > inside the get_monotonic_cycles loop is already flawed.
> >
>
> Yep, I just re-read through your previous email, and totally agree that
> the algorithm is flawed in the way you pointed out.

Yeah, but if we replace the loop with a seq lock, then it would work.
albeit, more cacheline bouncing (caused by writes). (maybe not, see below)

> > do you actually use the RCU internals? or do you just reimplement an RCU
> > algorithm?
> >
>
> Nope, I don't use RCU internals in this code. Preempt disable seemed
> like the best way to handle this utterly short code path and I wanted
> the write side to be fast enough to be called periodically. What I do is:

grmble. Then how do you trace preempt_disable?  As my tracer does that
(see the last patch in the series).

>
> - Disable preemption at the read-side :
>   it makes sure the pointer I get will point to a data structure that
>   will never change while I am in the preempt disabled code. (see *)
> - I use per-cpu data to allow the read-side to be as fast as possible
>   (only need to disable preemption, does not race against other CPUs and
>   won't generate cache line bouncing). It also allows dealing with
>   unsynchronized TSCs if needed.
> - Periodical write side : it's called from an IPI running on each CPU.
>
> (*) We expect the read-side (preempt off region) to last shorter than
> the interval between IPI updates so we can guarantee the data structure
> it uses won't be modified underneath it. Since the IPI update is
> launched each seconds or so (depends on the frequency of the counter we
> are trying to extend), it's more than ok.

One thing I want to clear up. The major difference between this
latency_tracer and LTTng is what we consider fast paths.  The latency
tracer is recording things like enabling and disabling interrupts, preempt
count changes, or simply profiling all function calls.  Those are what I
consider fast paths.  The slow path WRT the latency_tracer are things like
context switches.  This is why I don't have a problem with copying the
comm at context switch time. Because that _is_ a slow path for the latency
tracer.

Placing a read_seqlock in get_monotonic_cycles would not be that bad,
since the only slow down would be the rmb.  read_seqlocks don't modify
global data. Only the write_seqlock does. So the cache line bouncing would
only happen on updates in clocksource_accumulate. But then after the
caches are all balanced again, the reads will continue fine.

Question: Is a cache-miss a greater cost than a read to a clocksource
          (besides the TSC)?

Also note how I arrange these variables in the clock struct:

	struct {
		cycle_t cycle_last, cycle_accumulated, cycle_monotonic;
		cycle_t cycle_interval;
	} ____cacheline_aligned_in_smp;

I could do the following:

	struct {
		seqlock_t cycle_lock;
		cycle_t cycle_last, cycle_accumulated, cycle_monotonic;
		cycle_t cycle_interval;
	} ____cacheline_aligned_in_smp;

Which would help to keep all these in the same cache line. These are all
updated at the same time, and hopefully this will keep the cache line
bouncing limited to a single cacheline.

-- Steve

