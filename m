Return-Path: <linux-kernel-owner+w=401wt.eu-S1751686AbYJRRhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbYJRRhF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 13:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbYJRRgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 13:36:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892AbYJRRgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 13:36:53 -0400
Date: Sat, 18 Oct 2008 10:35:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: "Luck, Tony" <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
In-Reply-To: <20081018170118.GA22243@Krystal>
Message-ID: <alpine.LFD.2.00.0810181011310.3438@nehalem.linux-foundation.org>
References: <20081016234657.837704867@polymtl.ca> <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org> <20081017012835.GA30195@Krystal> <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com> <20081017172515.GA9639@goodmis.org>
 <57C9024A16AD2D4C97DC78E552063EA3533458AC@orsmsx505.amr.corp.intel.com> <20081017184215.GB9874@Krystal> <57C9024A16AD2D4C97DC78E552063EA35334594F@orsmsx505.amr.corp.intel.com> <20081017202313.GA13597@Krystal> <57C9024A16AD2D4C97DC78E552063EA353345B9B@orsmsx505.amr.corp.intel.com>
 <20081018170118.GA22243@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Oct 2008, Mathieu Desnoyers wrote:
> 
> So, the conclusion it brings about scalability of those time sources
> regarding tracing is :
> - local TSC read scales very well when the number of CPU increases
>   (constant 50% overhead)

You should basically expect it to scale perfectly. Of course the tracing 
itself adds overhead, and at some point the trace data generation may add 
so much cache/memory traffic that you start getting worse scaling because 
of _that_, but just a local TSC access itself will be perfect on any sane 
setup.

> - Comparing the added overhead of both get_cyles+cmpxchg and HPET to
>   the local sync TSC :
> 
>   cores    get_cycles+cmpxchg    HPET
>       1                  0.8%     10%
>       2                  8  %     11%
>       8                 12  %     19%
> 
> So, is it me, or HPET scales even more poorly than a cache-line bouncing
> cmpxchg ? I find it a bit surprising.

I don't think that's strictly true.

The cacheline is going to generally be faster than HPET ever will, since 
caches are really important. But as you can see, the _degradation_ is 
actually worse for the cacheline, since the cacheline works perfectly in 
the UP case (not surprising) and starts degrading a lot more when you 
start getting bouncing.

And I'm not sure what the behaviour would be for many-core, but I would 
not be surprised of the cmpxchg actually ends up losing at some point. The 
HPET is never fast (you can think of it as "uncached access"), and it's 
going to degrade too (contention at the IO hub level), but it's actually 
possible that the contention at some point becomes less than wild 
bouncing.

Many cacheline bouncing issues end up being almost exponential. When you 
*really* get bouncing, things degrade in a major way. I don't think you've 
seen the worst of it with 8 cores ;)

And that's why I'd really like to see the "only local TSC" access, even if 
I admit that the code is going to be much more subtle, and I will also 
admit that especially in the presense of frequency changes *and* hw with 
unsynchronized TSC's you may be in the situation where you never get 
exactly what you want.

But while you may not like some of the "purely local TSC" issues, I would 
like to point out that

 - In _practice_, it's going to be essentially perfect on a lot of 
   machines, and under a lot of loads. 

   For example, yes it's true that frequency changes will make TSC things 
   less reliable on a number of machines, but people already end up 
   disabling dynamic cpufreq when doing various benchmark runs, simply 
   because people want more consistent numbers for benchmarking across 
   different kernels etc.

   So it's entirely possible (and I'd say "likely") that most people are 
   simply willing to do the same thing for tracing if they are tracing 
   things at a level where CPU frequency changes might otherwise matter. 

   So maybe the "local TSC" approach isn't always perfect, but I'd expect 
   that quite often people who do tracing are willing to work around it. 
   The people doing tracing are generally not doing so without being aware 
   of what they are up to..

 - While there is certainly a lot of hardware out there with flaky TSC's, 
   there's also a lot of hardware (especially upcoming) that do *not* have 
   flaky TSC's. We've been complaining to Intel about TSC behavior for 
   years, and the thing is, it actually _is_ improving. It just takes some 
   time.

 - So considering that some of the tracing will actually be very important 
   on machines that have lots of cores, and considering that a lot of the 
   issues can generally be worked around, I really do think that it's 
   worth trying to spend a bit of effort on doing the "local TSC + timely 
   corrections"

For example, you mention that interrupts can be disabled for a time, 
delaying things like regular sync events with some stable external clock 
(say the HPET). That's true, and it would even be a problem if you'd use 
the time of the interrupt itself as the source of the sync, but you don't 
really need to depend on the timing of the interrupt - just that it 
happens "reasonably often" (and now we're talking _much_ longer timeframes 
than some interrupt-disabled time - we're talking tenths of seconds or 
even more).

Then, rather than depend on the time of the interrupt, you just purely can 
check the local TSC against the HPET (or other source), and synchronize 
just _purely_ based on those. That you can do by basically doing something 
like

	do {
		start = read_tsc();
		hpet = read_hpet();
		end = read_tsc();
	} while (end - start > ERROR);

and now, even if you have interrupts enabled (or worry about NMI's), you 
now know that you have a totally _independent_ sync point, ie you know 
that your hpet read value is withing ERROR cycles of the start/end values, 
so now you have a good point for doing future linear interpolation based 
on those kinds of sync points.

And if you make all these linear interpolations be per-CPU (so you have 
per-CPU offsets and frequencies) you never _ever_ need to touch any shared 
data at all, and you know you can scale basically perfectly.

Your linear interpolations may not be _perfect_, but you'll be able to get 
them pretty damn near. In fact, even if the TSC's aren't synchronized at 
all, if they are at least _individually_ stable (just running at slightly 
different frequencies because they are in different clock domains, and/or 
at different start points), you can basically perfect the precision over 
time.

			Linus
