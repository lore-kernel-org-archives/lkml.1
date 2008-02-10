Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbYBJG7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbYBJG7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 01:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYBJG7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 01:59:14 -0500
Received: from lixom.net ([66.141.50.11]:60789 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbYBJG7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 01:59:13 -0500
Date: Sun, 10 Feb 2008 01:00:56 -0600
From: Olof Johansson <olof@lixom.net>
To: Willy Tarreau <w@1wt.eu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived
	threads
Message-ID: <20080210070056.GA6401@lixom.net>
References: <20080209000456.GA21021@lixom.net> <1202543920.9578.3.camel@homer.simson.net> <20080209080319.GO8953@1wt.eu> <1202554705.10287.12.camel@homer.simson.net> <20080209114009.GP8953@1wt.eu> <1202564259.4035.18.camel@homer.simson.net> <20080209161957.GA3364@1wt.eu> <20080210052941.GA4731@lixom.net> <20080210061558.GC22137@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210061558.GC22137@1wt.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 07:15:58AM +0100, Willy Tarreau wrote:
> On Sat, Feb 09, 2008 at 11:29:41PM -0600, Olof Johansson wrote:
> > 40M:
> > 2.6.22		time 94315 ms
> > 2.6.23		time 107930 ms
> > 2.6.24		time 113291 ms
> > 2.6.24-git19	time 110360 ms
> > 
> > So with more work per thread, the differences become less but they're
> > still there. At the 40M loop, with 500 threads it's quite a bit of
> > runtime per thread.
> 
> No, it's really nothing. I had to push the loop to 1 billion to make the load
> noticeable. You don't have 500 threads, you have 2 threads and that load is
> repeated 500 times. And if we look at the numbers, let's take the worst one :
> > 40M:
> > 2.6.24                time 113291 ms
> 113291/500 = 227 microseconds/loop. This is still very low compared to the
> smallest timeslice you would have (1 ms at HZ=1000).
> 
> So your threads are still completing *before* the scheduler has to preempt
> them.

Hmm? I get that to be 227ms per loop, which is way more than a full
timeslice. Running the program took in the range of 2 minutes, so it's
110000 milliseconds, not microseconds.

> > It seems generally unfortunate that it takes longer for a new thread to
> > move over to the second cpu even when the first is busy with the original
> > thread. I can certainly see cases where this causes suboptimal overall
> > system behaviour.
> 
> In fact, I don't think it takes longer, I think it does not do it at their
> creation, but will do it immediately after the first slice is consumed. This
> would explain the important differences here. I don't know how we could ensure
> that the new thread is created on the second CPU from the start, though.

The math doesn't add up for me. Even if it rebalanced at the end of
the first slice (i.e. after 1ms), that would be a 1ms penalty per
iteration. With 500 threads that'd be a total penalty of 500ms.

> I tried inserting a sched_yield() at the top of the busy loop (1M loops).
> By default, it did not change a thing. Then I simply set sched_compat_yield
> to 1, and the two threads then ran simultaneously with a stable low time
> (2700 ms instead of 10-12 seconds).
> 
> Doing so with 10k loops (initial test) shows times in the range 240-300 ms
> only instead of 2200-6500 ms.

Right, likely because the long-running cases got stuck at the busy loop
at the end, which would end up aborting quicker if the other thread got
scheduled for just a bit. It was a mistake to post that variant of the
testcase, it's not as relevant and doesn't mimic the original workload I
was trying to mimic as well as if the first loop was made larger.

> Ingo, would it be possible (and wise) to ensure that a new thread being
> created gets immediately rebalanced in order to emulate what is done here
> with sched_compat_yield=1 and sched_yield() in both threads just after the
> thread creation ? I don't expect any performance difference doing this,
> but maybe some shell scripts reliying on short-lived pipes would get faster
> on SMP.

There's always the tradeoff of losing cache warmth whenever a thread is
moved, so I'm not sure if it's a good idea to always migrate it at
creation time. It's not a simple problem, really.

> > I agree that the testcase is highly artificial. Unfortunately, it's
> > not uncommon to see these kind of weird testcases from customers tring
> > to evaluate new hardware. :( They tend to be pared-down versions of
> > whatever their real workload is (the real workload is doing things more
> > appropriately, but the smaller version is used for testing). I was lucky
> > enough to get source snippets to base a standalone reproduction case on
> > for this, normally we wouldn't even get copies of their binaries.
> 
> I'm well aware of that. What's important is to be able to explain what is
> causing the difference and why the test case does not represent anything
> related to performance. Maybe the code author wanted to get 500 parallel
> threads and got his code wrong ?

I believe it started out as a simple attempt to parallelize a workload
that sliced the problem too low, instead of slicing it in larger chunks
and have each thread do more work at a time. It did well on 2.6.22 with
almost a 2x speedup, but did worse than the single-treaded testcase on a
2.6.24 kernel.

So yes, it can clearly be handled through explanations and education
and fixen the broken testcase, but I'm still not sure the new behaviour
is desired.


-Olof
