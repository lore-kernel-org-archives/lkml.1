Return-Path: <linux-kernel-owner+w=401wt.eu-S1423021AbXDTHMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423021AbXDTHMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 03:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXDTHMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 03:12:31 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:18272 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbXDTHMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 03:12:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lkmT7YXR6CY1jL8voBzxag9oYyLu/ncTnVVufgvPN/x5/77BKCRQB0SOTsQyA1KqW6Du7xVJfgprLYfVaxD6usTX8/qlRsikqf7bRTgtPeSVLV/QH2cu0U2fFlQ8eRUpkJJkkJKQ+8Skzq7rhg1YPvPUcLkoBWUa7jTxpX5+LhM=
Message-ID: <f2b55d220704200012j4e79de39o419b5fea0d0e9b4a@mail.gmail.com>
Date: Fri, 20 Apr 2007 00:12:29 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "hui Bill Huey" <billh@gnuppy.monkey.org>
Subject: Re: Renice X for cpu schedulers
Cc: "Lee Revell" <rlrevell@joe-job.com>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Con Kolivas" <kernel@kolivas.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Mike Galbraith" <efault@gmx.de>, "ck list" <ck@vds.kolivas.org>,
       linux-kernel@vger.kernel.org, "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070420052507.GA1928@gnuppy.monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070417062621.GL2986@holomorphy.com>
	 <20070418221432.e4dbcf4f.akpm@linux-foundation.org>
	 <20070419063810.GA22418@elte.hu>
	 <200704192159.35546.kernel@kolivas.org>
	 <462763A4.8080601@bigpond.net.au> <46276C83.40608@bigpond.net.au>
	 <75b66ecd0704190722l5ba8db7n52734c209504e802@mail.gmail.com>
	 <f2b55d220704191832x7d364b3bw93690ccaa29e2630@mail.gmail.com>
	 <20070420052507.GA1928@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, hui Bill Huey <billh@gnuppy.monkey.org> wrote:
> DSP operations like, particularly with digital synthesis, tend to max
> the CPU doing vector operations on as many processors as it can get
> a hold of. In a live performance critical application, it's important
> to be able to deliver a protected amount of CPU to a thread doing that
> work as well as response to external input such as controllers, etc...

Actual fractional CPU reservation is a bit different, and is probably
best handled with "container"-type infrastructure (not quite
virtualization, but not quite scheduling classes either).  SGI
pioneered this (in "open systems" space -- IBM probably had it first,
as usual) with GRIO in XFS.  (That was I/O throughput reservation of
course, not "CPU bandwidth" -- but IIRC IRIX had CPU reservation too).
 There's a more general class of techniques in which it's worth
spending idle cycles speculating along paths that might or might not
be taken depending on unpredictable I/O; I'd be surprised if you
couldn't approximate most of the sane balancing strategies in this
area within the "economic dispatch" scheduler model.  (Good JIT
bytecode engines more or less do this already if you let them, with a
cap on JIT cache size serving as a crude CPU throttle.)

> > In practice, you probably don't want to burden desktop Linux with
> > priority inheritance where you don't have to.  Priority queues with
> > algorithmically efficient decrease-key operations (Fibonacci heaps and
> > their ilk) are complicated to implement and have correspondingly high
> > constant factors.  (However, a sufficiently clever heuristic for
> > assigning quasi-static task priorities would usually short-circuit the
> > priority cascade; if you can keep N small in the
> > tasks-with-unpredictable-priority queue, you can probably use a
> > simpler flavor with O(log N) decrease-key.  Ask someone who knows more
> > about data structures than I do.)
>
> These are app issue and not really somethings that's mutable in kernel
> per se with regard to the -rt patch.

I don't know where the -rt patch enters in.  But if you need agile
reprioritization with a deep runnable queue, either under direct
application control or as a side effect of priority inheritance or a
related OS-enforced protocol, then you need a kernel-level data
structure with a fancier interface than the classic
insert/find/delete-min priority queue.  From what I've read (this is
not my area of expertise and I don't have Knuth handy), the relatively
simple heap-based implementations of priority queues can't
reprioritize an entry any more quickly than find+delete+insert, which
pretty much rules them out as a basis for a scalable scheduler with
priority inheritance (let alone PCP emulation).

> I have Solaris style adaptive locks in my tree with my lockstat patch
> under -rt. I've also modified my lockstat patch to track readers
> correctly now with rwsem and the like to see where the single reader
> limitation in the rtmutex blows it.

Ooh, that's neat.  The next time I can cook up an excuse to run a
kernel that won't load this damn WiFi driver, I'll try it out.  Some
of the people I work with are real engineers and respect in-system
instrumentation.

> So far I've seen less than 10 percent of in-kernel contention events
> actually worth spinning on and the rest of the stats imply that the
> mutex owner in question is either preempted or blocked on something
> else.

That's a good thing; it implies that in-kernel algorithms don't take
locks needlessly as a matter of cargo-cult habit.  Attempting to take
a lock (other than an uncontended futex, which is practically free)
should almost always transfer control to the thread that has the power
to deliver the information (or the free slot) that you're looking for
-- or in the case of an external data source/sink, should send you
into low-power mode until time and tide give you something new to do.
Think of it as a just-in-time inventory system; if you keep too much
product in stock (or free warehouse space), you're wasting space and
harming responsiveness to a shift in demand.  Once in a while you have
to play Sokoban in order to service a request promptly; that's exactly
the case that priority inheritance is meant to help with.

The fiddly part, on a non-real-time-no-matter-what-the-label-says
system with an opaque cache architecture and mysterious hidden costs
of context switching, is to minimize the lossage resulting from brutal
timer- or priority-inheritance-driven preemption.  Given the way
people code these days -- OK, it was probably just as bad back in the
day -- the only thing worse than letting the axe fall at random is to
steal the CPU away the moment a contended lock is released, because
the next 20 lines of code probably poke one last time at all the data
structures the task had in cache right before entering the critical
section.  That doesn't hurt so bad on RTOS-friendly hardware -- an
MMU-less system with either zero or near-infinite cache -- but it's
got to make this year's Intel/AMD/whatever kotatsu stall left and
right when that task gets rescheduled.

> I've been trying to get folks to try this on a larger machine than my
> 2x AMD64 box so that I there is more data regarding Linux contention
> and overschedulling in -rt.

Dave Miller, maybe?  He seems to be one of the few people around here
with the skills and the institutional motivation to push for
scalability under the typical half-assed middle-tier application
workload.  Which, make no mistake, stands to benefit a lot more from a
properly engineered SCHED_OTHER scheduler than any "real-time" media
gadget that sells by the forklift-load at Fry's.  (NUMA boxen might
also benefit, but AFAICT their target applications are different
enough not to count.)  And if anyone from Cavium is lurking, now would
be a real good time to show up and shoulder some of the load.  Heck,
even Intel ought to pitch in -- the Yonah team may have saved your ass
for now, but you'll be playing the 32-thread throughput-per-erg stakes
soon enough.

Cheers,
- Michael
