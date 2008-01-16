Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbYAPRA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbYAPRA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbYAPRAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:00:16 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:51867 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102AbYAPRAO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:00:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAFbHjUdMROHU/2dsb2JhbACBWJAQnDM
Date: Wed, 16 Jan 2008 12:00:11 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20080116170011.GA3651@Krystal>
References: <20080115214636.GD17439@Krystal> <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com> <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com> <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com> <20080116145604.GB31329@Krystal> <Pine.LNX.4.58.0801161003010.15758@gandalf.stny.rr.com> <20080116152838.GA970@Krystal> <Pine.LNX.4.58.0801161041010.15998@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <Pine.LNX.4.58.0801161041010.15998@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:29:03 up 73 days, 21:34,  5 users,  load average: 0.53, 0.44,
	0.32
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> 
> On Wed, 16 Jan 2008, Mathieu Desnoyers wrote:
> > > No, there's probably issues there too, but no need to worry about it,
> > > since I already showed that allowing for clocksource_accumulate to happen
> > > inside the get_monotonic_cycles loop is already flawed.
> > >
> >
> > Yep, I just re-read through your previous email, and totally agree that
> > the algorithm is flawed in the way you pointed out.
> 
> Yeah, but if we replace the loop with a seq lock, then it would work.
> albeit, more cacheline bouncing (caused by writes). (maybe not, see below)
> 

Yes, but then you would trigger a deadlock if you instrument code called
from NMI, SMI, MCE contexts :(

grep -ri NMI drivers/* arch/* |grep -vi PNMI

is quite interesting : actually, it show that a few spots need to handle
those "so special interrupts" : watchdogs, oprofile, virtualization and
much more in architecture specific code.

I just would not like to add a tracer in the kernel that is _so_
intrusive that module writers and architecture maintainers would have to
audit their code and think about the tracer for each implementation that
would deal with these kind of interrupts.

> > > do you actually use the RCU internals? or do you just reimplement an RCU
> > > algorithm?
> > >
> >
> > Nope, I don't use RCU internals in this code. Preempt disable seemed
> > like the best way to handle this utterly short code path and I wanted
> > the write side to be fast enough to be called periodically. What I do is:
> 
> grmble. Then how do you trace preempt_disable?  As my tracer does that
> (see the last patch in the series).
> 

I think using a kind of preempt_disable_notrace() would make sense here.
I mean.. even if you use the seqlock, eventually, you will want to trace
the seqlock behavior. Then you have to find the lightest way to do some
sort of synchronization that will have a predictable execution. seqlock
has the following disadvantage : if the seqlock read has to wait for the
write seqlock to end, we add up some time to the execution of the
code we are trying to profile, which will mix up the results. On the
other hand, if the read-side executes in a constant amount of cycles
which does not depend on the write-side activity, then we get a clearer
picture of what the time should be accounted for. We can even create a
module that will figure out how many nanoseconds are spent for reading
the clock so we can substract this time from our analysis if required.

That's why having to choose between read seqlock and preemption disable
for the read-side, I would strongly prefer the preemption disable.
(constant execution time and it's deadlock-free)

> >
> > - Disable preemption at the read-side :
> >   it makes sure the pointer I get will point to a data structure that
> >   will never change while I am in the preempt disabled code. (see *)
> > - I use per-cpu data to allow the read-side to be as fast as possible
> >   (only need to disable preemption, does not race against other CPUs and
> >   won't generate cache line bouncing). It also allows dealing with
> >   unsynchronized TSCs if needed.
> > - Periodical write side : it's called from an IPI running on each CPU.
> >
> > (*) We expect the read-side (preempt off region) to last shorter than
> > the interval between IPI updates so we can guarantee the data structure
> > it uses won't be modified underneath it. Since the IPI update is
> > launched each seconds or so (depends on the frequency of the counter we
> > are trying to extend), it's more than ok.
> 
> One thing I want to clear up. The major difference between this
> latency_tracer and LTTng is what we consider fast paths.  The latency
> tracer is recording things like enabling and disabling interrupts, preempt
> count changes, or simply profiling all function calls.  Those are what I
> consider fast paths.  The slow path WRT the latency_tracer are things like
> context switches.  This is why I don't have a problem with copying the
> comm at context switch time. Because that _is_ a slow path for the latency
> tracer.

LTTng hooks in the lockdep tracer to trace irq on/off, spinlocks, etc..
in flight recorder mode, we have nothing to write to disk and therefore
we can handle very frequent events. We then do the analysis off-line
using the last MB written in the buffers. The advantage is that the
kernel dumbly writes data to a buffer : we therefore move the complexity
to user-space.

I agree that some kind of tracing, like the one you are doing, might be
done more efficiently if you do a first clever analysis phase directly
in the kernel without writing the raw high event rate data in memory
buffers. However, I believe that it would be more powerful if we combine
the two approaches rather than trying to do everything in or out of the
kernel.  LTTng could provide the comm names, priorities, etc, and your
tracer could provide the top X list of processes that had a bad
behavior. It would mean that the complete overall information would be
made available after a post-processing phase done in an analysis tool
like LTTV, but I don't see any problem with it.

> 
> Placing a read_seqlock in get_monotonic_cycles would not be that bad,
> since the only slow down would be the rmb.  read_seqlocks don't modify
> global data. Only the write_seqlock does. So the cache line bouncing would
> only happen on updates in clocksource_accumulate. But then after the
> caches are all balanced again, the reads will continue fine.
> 

Yep, cache-line bouncing for rare updates in not much of an issue.

> Question: Is a cache-miss a greater cost than a read to a clocksource
>           (besides the TSC)?
> 

If HPET reads are as slow as I expect, then no. Even then, a
synchronized TSC read will take about 100 cycles. If we have to hit main
memory, some tests I have done on a P4 showed that it could take about
600 cycles. However, cacheline bouncing, in my understanding, has more
effects that barely burning cycles : wasting memory I/O, when we
increase the number of CPUs, becomes increasingly bad.

> Also note how I arrange these variables in the clock struct:
> 
> 	struct {
> 		cycle_t cycle_last, cycle_accumulated, cycle_monotonic;
> 		cycle_t cycle_interval;
> 	} ____cacheline_aligned_in_smp;
> 
> I could do the following:
> 
> 	struct {
> 		seqlock_t cycle_lock;
> 		cycle_t cycle_last, cycle_accumulated, cycle_monotonic;
> 		cycle_t cycle_interval;
> 	} ____cacheline_aligned_in_smp;
> 
> Which would help to keep all these in the same cache line. These are all
> updated at the same time, and hopefully this will keep the cache line
> bouncing limited to a single cacheline.
> 

And if the cache line only bounces when the write seqlock is taken, it's
not really an issue. I am more concerned about deadlocks ;)

Mathieu

> -- Steve
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
