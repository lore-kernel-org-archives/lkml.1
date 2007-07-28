Return-Path: <linux-kernel-owner+w=401wt.eu-S1764583AbXG1Gve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764583AbXG1Gve (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 02:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbXG1Gv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 02:51:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444AbXG1Gv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 02:51:26 -0400
Message-ID: <46AAE760.9030602@redhat.com>
Date: Sat, 28 Jul 2007 02:51:12 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@suse.de>
CC: tim.c.chen@linux.intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: pluggable scheduler thread (was Re: Volanomark slows by 80% under
 CFS)
References: <1185573687.19777.44.camel@localhost.localdomain> <46AA8E57.8010105@redhat.com> <20070728005920.GA31622@v2.random> <46AABB5B.3030702@redhat.com> <20070728050141.GC31622@v2.random>
In-Reply-To: <20070728050141.GC31622@v2.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Fri, Jul 27, 2007 at 11:43:23PM -0400, Chris Snook wrote:
>> I'm pretty sure the point of posting a patch that triples CFS performance 
>> on a certain benchmark and arguably improves the semantics of sched_yield 
>> was to improve CFS.  You have a point, but it is a point for a different 
>> thread.  I have taken the liberty of starting this thread for you.
> 
> I've no real interest in starting or participating in flamewars
> (especially the ones not backed by hard numbers). So I adjusted the
> subject a bit in the hope the discussion will not degenerate as you
> predicted, hope you don't mind.

Not at all.  I clearly misread your tone.

> I'm pretty sure the point of posting that email was to show the
> remaining performance regression with the sched_yield fix applied
> too. Given you considered my post both offtopic and inflammatory, I
> guess you think it's possible and reasonably easy to fix that
> remaining regression without a pluggable scheduler, right? So please
> enlighten us on your intend to achieve it.

There are four possibilities that are immediately obvious to me:

a) The remaining difference is due mostly to the algorithmic complexity 
of the rbtree algorithm in CFS.

If this is the case, we should be able to vary the test parameters (CPU 
count, thread count, etc.) graph the results, and see a roughly 
logarithmic divergence between the schedulers as some parameter(s) vary. 
  If this is the problem, we may be able to fix it with data structure 
tweaks or optimized base cases, like how quicksort can be optimized by 
using insertion sort below a certain threshold.

b) The remaining difference is due mostly to how the scheduler handles 
volanomark.

vmstat can give us a comparison of context switches between O(1), CFS, 
and CFS+patch.  If the decrease in throughput correlates with an 
increase in context switches, we may be able to induce more O(1)-like 
behavior by charging tasks for context switch overhead.

c) The remaining difference is due mostly to how the scheduler handles 
something other than volanomark.

If context switch count is not the problem, context switch pattern still 
could be.  I doubt we'd see a 40% difference due to cache misses, but 
it's possible.  Fortunately, oprofile can sample based on cache misses, 
so we can debug this too.

d) The remaining difference is due mostly to some implementation detail 
in CFS.

It's possible there's some constant-factor overhead in CFS that is 
magnified heavily by the context switching volanomark deliberately 
induces.  If this is the case, oprofile sampling on clock cycles should 
catch it.

Tim --

	Since you're already set up to do this benchmarking, would you mind 
varying the parameters a bit and collecting vmstat data?  If you want to 
run oprofile too, that wouldn't hurt.

> Also consider the other numbers likely used nptl so they shouldn't be
> affected by sched_yield changes.
> 
>> Sure there is.  We can run a fully-functional POSIX OS without using any 
>> block devices at all.  We cannot run a fully-functional POSIX OS without a 
>> scheduler. Any feature without which the OS cannot execute userspace code 
>>  is sufficiently primitive that somewhere there is a device on which it will 
>> be impossible to debug if that feature fails to initialize.  It is quite 
>> reasonable to insist on only having one implementation of such features in 
>> any given kernel build.
> 
> Sounds like a red-herring to me... There aren't just pluggable I/O
> schedulers in the kernel, there are pluggable packet schedulers too
> (see `tc qdisc`). And both are switchable at runtime (not just at boot
> time).
> 
> Can you run your fully-functional POSIX OS without a packet scheduler
> and without an I/O scheduler? I wonder where are you going to
> read/write data without HD and network?

If I'm missing both, I'm pretty screwed, but if either one is 
functional, I can send something out.

> Also those pluggable things don't increase the risk of crash much, if
> compared to the complexity of the schedulers.
> 
>> Whether or not these alternatives belong in the source tree as config-time 
>> options is a political question, but preserving boot-time debugging 
>> capability is a perfectly reasonable technical motivation.
> 
> The scheduler is invoked very late in the boot process (printk and
> serial console, kdb are working for ages when scheduler kicks in), so
> it's fully debuggable (no debugger depends on the scheduler, they run
> inside the nmi handler...), I don't really see your point.

I'm more concerned about embedded systems.  These are the same people 
who want userspace character drivers to control their custom hardware. 
Having the robot point to where it hurts is a lot more convenient than 
hooking up a JTAG debugger.

> And even if there would be a subtle bug in the scheduler you'll never
> trigger it at boot with so few tasks and so few context switches.

Sure, but it's the non-subtle bugs that worry me.  These are usually 
related to low-level hardware setup, so they could miss the mainstream 
developers and clobber unsuspecting embedded developers.

I acknowledge that debugging such problems shouldn't be terribly hard on 
mainstream systems, but some people are going to want to choose a single 
scheduler at build time and avoid the hassle.  If we can improve CFS to 
be regression-free, and I think we can if we give ourselves a few 
percent tolerance and keep tracking down the corner cases, the pluggable 
scheduler infrastructure will just be another disused feature.

	-- Chris
