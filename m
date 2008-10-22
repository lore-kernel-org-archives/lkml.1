Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbYJVPxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbYJVPxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbYJVPxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:53:30 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:58112 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754163AbYJVPx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:53:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoEAHjp/khMQWQ+/2dsb2JhbACBcsRZg08
Date: Wed, 22 Oct 2008 11:53:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
Message-ID: <20081022155324.GA12650@Krystal>
References: <20081017012835.GA30195@Krystal> <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com> <20081017172515.GA9639@goodmis.org> <57C9024A16AD2D4C97DC78E552063EA3533458AC@orsmsx505.amr.corp.intel.com> <20081017184215.GB9874@Krystal> <57C9024A16AD2D4C97DC78E552063EA35334594F@orsmsx505.amr.corp.intel.com> <20081017202313.GA13597@Krystal> <57C9024A16AD2D4C97DC78E552063EA353345B9B@orsmsx505.amr.corp.intel.com> <20081018170118.GA22243@Krystal> <alpine.LFD.2.00.0810181011310.3438@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810181011310.3438@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:10:42 up 139 days, 19:51,  9 users,  load average: 1.06, 0.95,
	1.08
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Sat, 18 Oct 2008, Mathieu Desnoyers wrote:
> > 
> > So, the conclusion it brings about scalability of those time sources
> > regarding tracing is :
> > - local TSC read scales very well when the number of CPU increases
> >   (constant 50% overhead)
> 
> You should basically expect it to scale perfectly. Of course the tracing 
> itself adds overhead, and at some point the trace data generation may add 
> so much cache/memory traffic that you start getting worse scaling because 
> of _that_, but just a local TSC access itself will be perfect on any sane 
> setup.
> 

Given the rest of tracing mainly consists in reading cache-hot data to
put it in per-cpu buffers, it actually scales very well.

> > - Comparing the added overhead of both get_cyles+cmpxchg and HPET to
> >   the local sync TSC :
> > 
> >   cores    get_cycles+cmpxchg    HPET
> >       1                  0.8%     10%
> >       2                  8  %     11%
> >       8                 12  %     19%
> > 
> > So, is it me, or HPET scales even more poorly than a cache-line bouncing
> > cmpxchg ? I find it a bit surprising.
> 
> I don't think that's strictly true.
> 
> The cacheline is going to generally be faster than HPET ever will, since 
> caches are really important. But as you can see, the _degradation_ is 
> actually worse for the cacheline, since the cacheline works perfectly in 
> the UP case (not surprising) and starts degrading a lot more when you 
> start getting bouncing.
> 
> And I'm not sure what the behaviour would be for many-core, but I would 
> not be surprised of the cmpxchg actually ends up losing at some point. The 
> HPET is never fast (you can think of it as "uncached access"), and it's 
> going to degrade too (contention at the IO hub level), but it's actually 
> possible that the contention at some point becomes less than wild 
> bouncing.
> 

Too bad I don't have enough cores to generate a meaningful figure, but
I've been surprised to see how bad the HPET evolved between 2 and 8
cores (11% impact -> 19% impact) vs cacheline (8% -> 12%). The real big
step for cacheline bouncing seems to be between 1 and 2 CPUs, but after
that it seems to increase much more slowly than HPET.

> Many cacheline bouncing issues end up being almost exponential. When you 
> *really* get bouncing, things degrade in a major way. I don't think you've 
> seen the worst of it with 8 cores ;)
> 

I wonder how this can end up being exponential considering I could
switch this cache-line bouncing access into an uncached memory access.
This would slow down the few CPU cases, but would likely behave much
like the HPET read. And the performance impact of that would be expected
to increase linearly with the number of cores. I think what makes this
linear with the number of cores is because we are talking about a single
cache-line exchange. I standard programs, we have to bounce many
cache-lines between the CPUs, which therefore follows a time complexity
of O(nr cores * nr shared cache-lines). If the number of shared
cache-lines is big, it may look like an exponential increase.

I also wonder how many 8+ cores with non-sync TSC systems there are out
there, and if tracing is a vital requirement for them, and also I wonder
if it's worth all the effort we are putting into this. I am always
tempted to just detect this kind of behavior, keep a slower-but-solid
solution, and point to some documentation that says what workarounds can
be enabled.

> And that's why I'd really like to see the "only local TSC" access, even if 
> I admit that the code is going to be much more subtle, and I will also 
> admit that especially in the presense of frequency changes *and* hw with 
> unsynchronized TSC's you may be in the situation where you never get 
> exactly what you want.
> 
> But while you may not like some of the "purely local TSC" issues, I would 
> like to point out that
> 
>  - In _practice_, it's going to be essentially perfect on a lot of 
>    machines, and under a lot of loads. 
> 
>    For example, yes it's true that frequency changes will make TSC things 
>    less reliable on a number of machines, but people already end up 
>    disabling dynamic cpufreq when doing various benchmark runs, simply 
>    because people want more consistent numbers for benchmarking across 
>    different kernels etc.
> 
>    So it's entirely possible (and I'd say "likely") that most people are 
>    simply willing to do the same thing for tracing if they are tracing 
>    things at a level where CPU frequency changes might otherwise matter. 
> 
>    So maybe the "local TSC" approach isn't always perfect, but I'd expect 
>    that quite often people who do tracing are willing to work around it. 
>    The people doing tracing are generally not doing so without being aware 
>    of what they are up to..

The way I work around this issue in LTTng is to detect non-synchronized
TSCs, print a warning message telling that the time-base used for
tracing is not perfect, and let the user know about some documentation
which explains how to work-around the problem with specific kernel
command line arguments (e.g. idle=poll and disabling freq scaling).
There are however some people who will not be willing to reboot their
computer or change their setup, and this is the use-case where I think
providing a non-perfect solution (which does not scale as well) makes
sense.


> 
>  - While there is certainly a lot of hardware out there with flaky TSC's, 
>    there's also a lot of hardware (especially upcoming) that do *not* have 
>    flaky TSC's. We've been complaining to Intel about TSC behavior for 
>    years, and the thing is, it actually _is_ improving. It just takes some 
>    time.
> 

Hurray ! :)


>  - So considering that some of the tracing will actually be very important 
>    on machines that have lots of cores, and considering that a lot of the 
>    issues can generally be worked around, I really do think that it's 
>    worth trying to spend a bit of effort on doing the "local TSC + timely 
>    corrections"
> 

As we can see in other threads, it seems to have been tried for a while
by very competent people without brilliant success. Given that the
requirements tracing have for timestamps that follows as closely as
possible the event order across CPUs, which is stronger than the
standard kernel time-sources, I think those things should be tried as a
new kernel time source which has more relax constraints, and maybe
eventually become a trace_clock() source if it is judged stable and
precise enough (e.g. we could trace it with a tracer based on a
cache-line bouncing clock to see if the event order is correct on
various loads).

> For example, you mention that interrupts can be disabled for a time, 
> delaying things like regular sync events with some stable external clock 
> (say the HPET). That's true, and it would even be a problem if you'd use 
> the time of the interrupt itself as the source of the sync, but you don't 
> really need to depend on the timing of the interrupt - just that it 
> happens "reasonably often" (and now we're talking _much_ longer timeframes 
> than some interrupt-disabled time - we're talking tenths of seconds or 
> even more).

Even the "reasonably often" can be a problem. Some examples :

- boot time tracing, where interrupts can be off for a while.
- some races within the kernel which could disable interrupts for a
  long while. Yes, this should _never_ happen, but when it does, a
  tracer becomes very handy.

> 
> Then, rather than depend on the time of the interrupt, you just purely can 
> check the local TSC against the HPET (or other source), and synchronize 
> just _purely_ based on those. That you can do by basically doing something 
> like
> 
> 	do {
> 		start = read_tsc();
> 		hpet = read_hpet();
> 		end = read_tsc();
> 	} while (end - start > ERROR);
> 
> and now, even if you have interrupts enabled (or worry about NMI's), you 
> now know that you have a totally _independent_ sync point, ie you know 
> that your hpet read value is withing ERROR cycles of the start/end values, 
> so now you have a good point for doing future linear interpolation based 
> on those kinds of sync points.
> 

Just hope you don't run this on uncommon (e.g. virtualized hardware) and
always have end - start > ERROR, because you would be creating an
infinite loop. This might cause some problems. But yes, that would help
reading the hpet and tsc together. We could probably use the average for
TSC value there too :
  tsc = start + ((start - end) >> 1);

> And if you make all these linear interpolations be per-CPU (so you have 
> per-CPU offsets and frequencies) you never _ever_ need to touch any shared 
> data at all, and you know you can scale basically perfectly.
> 
> Your linear interpolations may not be _perfect_, but you'll be able to get 
> them pretty damn near. In fact, even if the TSC's aren't synchronized at 
> all, if they are at least _individually_ stable (just running at slightly 
> different frequencies because they are in different clock domains, and/or 
> at different start points), you can basically perfect the precision over 
> time.
> 

Hrm, you seem to assume the CPU frequency is nearly constant, but I
suspect AMD systems with idle cores will actually make the overall
frequency jump drastically between high and low CPU load. Therefore, I
don't even think we can really consider those to be individually stable.

The other problem with interpolation is when a CPU starts to accelerate.
In the sched_clock code, what is currently done is to cap the tsc value
to a max within the time window between two HPET reads so it does not
appear to go backwards when the next HPET read occurs. Such case would
clearly mess the event synchronization in a noticeable way.

Mathieu

> 			Linus

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
