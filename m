Return-Path: <linux-kernel-owner+w=401wt.eu-S1422813AbXDTF0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422813AbXDTF0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422708AbXDTF0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:26:10 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:54305
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030515AbXDTF0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:26:09 -0400
Date: Thu, 19 Apr 2007 22:25:07 -0700
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: Lee Revell <rlrevell@joe-job.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: Renice X for cpu schedulers
Message-ID: <20070420052507.GA1928@gnuppy.monkey.org>
References: <20070417062621.GL2986@holomorphy.com> <20070418221432.e4dbcf4f.akpm@linux-foundation.org> <20070419063810.GA22418@elte.hu> <200704192159.35546.kernel@kolivas.org> <462763A4.8080601@bigpond.net.au> <46276C83.40608@bigpond.net.au> <75b66ecd0704190722l5ba8db7n52734c209504e802@mail.gmail.com> <f2b55d220704191832x7d364b3bw93690ccaa29e2630@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220704191832x7d364b3bw93690ccaa29e2630@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 06:32:15PM -0700, Michael K. Edwards wrote:
> But I think SCHED_FIFO on a chain of tasks is fundamentally not the
> right way to handle low audio latency.  The object with a low latency
> requirement isn't the task, it's the device.  When it's starting to
> get urgent to deliver more data to the device, the task that it's
> waiting on should slide up the urgency scale; and if it's waiting on
> something else, that something else should slide up the scale; and so
> forth.  Similarly, responding to user input is urgent; so when user
> input is available (by whatever mechanism), the task that's waiting
> for it should slide up the urgency scale, etc.

DSP operations like, particularly with digital synthesis, tend to max
the CPU doing vector operations on as many processors as it can get
a hold of. In a live performance critical application, it's important
to be able to deliver a protected amount of CPU to a thread doing that
work as well as response to external input such as controllers, etc...

> In practice, you probably don't want to burden desktop Linux with
> priority inheritance where you don't have to.  Priority queues with
> algorithmically efficient decrease-key operations (Fibonacci heaps and
> their ilk) are complicated to implement and have correspondingly high
> constant factors.  (However, a sufficiently clever heuristic for
> assigning quasi-static task priorities would usually short-circuit the
> priority cascade; if you can keep N small in the
> tasks-with-unpredictable-priority queue, you can probably use a
> simpler flavor with O(log N) decrease-key.  Ask someone who knows more
> about data structures than I do.)

These are app issue and not really somethings that's mutable in kernel
per se with regard to the -rt patch.

> More importantly, non-real-time application coders aren't very smart
> about grouping data structure accesses on one side or the other of a
> system call that is likely to release a lock and let something else
> run, flushing application data out of cache.  (Kernel coders aren't
> always smart about this either; see LKML threads a few weeks ago about
> racy, and cache-stall-prone, f_pos handling in VFS.)  So switching
> tasks immediately on lock release is usually the wrong thing to do if
> letting the task run a little longer would allow it to reach a point
> where it has to block anyway.

I have Solaris style adaptive locks in my tree with my lockstat patch
under -rt. I've also modified my lockstat patch to track readers
correctly now with rwsem and the like to see where the single reader
limitation in the rtmutex blows it.

So far I've seen less than 10 percent of in-kernel contention events
actually worth spinning on and the rest of the stats imply that the
mutex owner in question is either preempted or blocked on something
else.

I've been trying to get folks to try this on a larger machine than my
2x AMD64 box so that I there is more data regarding Linux contention
and overschedulling in -rt.
 
> Anyway, I already described the urgency-driven strategy to the extent
> that I've thought it out, elsewhere in this thread.  I only held this
> draft back because I wanted to double-check my latency measurements.

bill

