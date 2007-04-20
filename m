Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbXDTIWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbXDTIWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbXDTIWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:22:05 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:47101
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbXDTIWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:22:00 -0400
Date: Fri, 20 Apr 2007 01:21:02 -0700
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
       Steven Rostedt <rostedt@goodmis.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: Renice X for cpu schedulers
Message-ID: <20070420082102.GB628@gnuppy.monkey.org>
References: <20070417062621.GL2986@holomorphy.com> <20070418221432.e4dbcf4f.akpm@linux-foundation.org> <20070419063810.GA22418@elte.hu> <200704192159.35546.kernel@kolivas.org> <462763A4.8080601@bigpond.net.au> <46276C83.40608@bigpond.net.au> <75b66ecd0704190722l5ba8db7n52734c209504e802@mail.gmail.com> <f2b55d220704191832x7d364b3bw93690ccaa29e2630@mail.gmail.com> <20070420052507.GA1928@gnuppy.monkey.org> <f2b55d220704200012j4e79de39o419b5fea0d0e9b4a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220704200012j4e79de39o419b5fea0d0e9b4a@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 12:12:29AM -0700, Michael K. Edwards wrote:
> Actual fractional CPU reservation is a bit different, and is probably
> best handled with "container"-type infrastructure (not quite
> virtualization, but not quite scheduling classes either).  SGI
> pioneered this (in "open systems" space -- IBM probably had it first,
> as usual) with GRIO in XFS.  (That was I/O throughput reservation of

I'm very aware of this having grow up on those systems and see what 30k
USD of hardware can do for you with the right kernel facilties. It
would be a mind blower to get OpenGL and friends back to that level of
performance with regards to React/Pro's rt abilities, frame drop would
just be gone and we'd own gaming. No joke.

We have a number of former SGI XFS engineers here at NetApp and I should
ask them about the GRIO implementation.

> course, not "CPU bandwidth" -- but IIRC IRIX had CPU reservation too).
> There's a more general class of techniques in which it's worth
> spending idle cycles speculating along paths that might or might not
> be taken depending on unpredictable I/O; I'd be surprised if you
> couldn't approximate most of the sane balancing strategies in this
> area within the "economic dispatch" scheduler model.  (Good JIT

What is that ? never heard of it before.
 
> I don't know where the -rt patch enters in.  But if you need agile
> reprioritization with a deep runnable queue, either under direct
> application control or as a side effect of priority inheritance or a
> related OS-enforced protocol, then you need a kernel-level data
> structure with a fancier interface than the classic
> insert/find/delete-min priority queue.  From what I've read (this is
> not my area of expertise and I don't have Knuth handy), the relatively
> simple heap-based implementations of priority queues can't
> reprioritize an entry any more quickly than find+delete+insert, which
> pretty much rules them out as a basis for a scalable scheduler with
> priority inheritance (let alone PCP emulation).

The -rt patch has turnstile-esque infrastructure that's stack allocated.
Linux's lock hierarchy is relatively shallow (compensated with a heavy
use of per CPU method and RCU-ified algorithms in place of rwlocks) so
I've encountered nothing close to this that would demand such an overly
sophisticated mechanism. I'm aware of PCP and preemptions thresholds.
I created the lockstat infrastructure as a means of precisely measuring
contention in -rt in anticipation to experiment with these techniques.

I mention -rt because it's the most likely place to encounter what you're
talking about, not an app.
 
> >I have Solaris style adaptive locks in my tree with my lockstat patch
> >under -rt. I've also modified my lockstat patch to track readers

...

> Ooh, that's neat.  The next time I can cook up an excuse to run a
> kernel that won't load this damn WiFi driver, I'll try it out.  Some
> of the people I work with are real engineers and respect in-system
> instrumentation.

It's not publically released yet since I'm still stuck in .20-rc6 land
and the soft lock up detector triggers. I need to forward port it and
my lockstat changes to the most recent -rt patch.

I've been stalled on revision control problem that I'm trying to solve
with monotone for at least a month (of my own spare time).

> That's a good thing; it implies that in-kernel algorithms don't take
> locks needlessly as a matter of cargo-cult habit.  Attempting to take

The jury is still out on this until I can record what the rtmutex owner's
state is in. No further conclusion can be made until then. I think
this is very interesting pursuit/investigation.

> a lock (other than an uncontended futex, which is practically free)
> should almost always transfer control to the thread that has the power
> to deliver the information (or the free slot) that you're looking for
> -- or in the case of an external data source/sink, should send you
> into low-power mode until time and tide give you something new to do.

> Think of it as a just-in-time inventory system; if you keep too much
> product in stock (or free warehouse space), you're wasting space and
> harming responsiveness to a shift in demand.  Once in a while you have
> to play Sokoban in order to service a request promptly; that's exactly
> the case that priority inheritance is meant to help with.

What did you mean by this ? Victor Yodaiken's stuff ?

> The fiddly part, on a non-real-time-no-matter-what-the-label-says
> system with an opaque cache architecture and mysterious hidden costs
> of context switching, is to minimize the lossage resulting from brutal
> timer- or priority-inheritance-driven preemption.  Given the way
> people code these days -- OK, it was probably just as bad back in the
> day -- the only thing worse than letting the axe fall at random is to
> steal the CPU away the moment a contended lock is released, because

My adaptive spin stuff in front of an rtmutex is design to complement
Steve Rostedt's owner stealing code also in that path and prevent this
from happening. I record stealing events as well.

> the next 20 lines of code probably poke one last time at all the data
> structures the task had in cache right before entering the critical
> section.  That doesn't hurt so bad on RTOS-friendly hardware -- an
> MMU-less system with either zero or near-infinite cache -- but it's
> got to make this year's Intel/AMD/whatever kotatsu stall left and
> right when that task gets rescheduled.

Cache and tlb's are a bitch.

> >I've been trying to get folks to try this on a larger machine than my
> >2x AMD64 box so that I there is more data regarding Linux contention
> >and overschedulling in -rt.
> 
> Dave Miller, maybe?  He seems to be one of the few people around here

Don't know. I do know that somebody is going to try -rt on large hardware
because they go some crazy app that needs both tons of CPU and rt abilties,
like IRIX. I wouldn't mind the help and access to an 8x machine.

bill

