Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbXDWHZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbXDWHZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 03:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbXDWHZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 03:25:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:40725 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbXDWHZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 03:25:47 -0400
Date: Mon, 23 Apr 2007 09:25:15 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] CFS scheduler, -v5
Message-ID: <20070423072515.GA27012@wotan.suse.de>
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu> <20070423012509.GA25162@wotan.suse.de> <20070423025553.GA10407@elte.hu> <20070423032215.GC25162@wotan.suse.de> <20070423034310.GA19845@elte.hu> <20070423040600.GD25162@wotan.suse.de> <20070423071050.GD4518@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423071050.GD4518@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 09:10:50AM +0200, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > > yeah - but they'll all be quad core, so the SMP timeslice 
> > > multiplicator should do the trick. Most of the CFS testers use 
> > > single-CPU systems.
> > 
> > But desktop users could have have quad thread and even 8 thread CPUs 
> > soon, so if the number doesn't work for both then you're in trouble. 
> > It just smells like a hack to scale with CPU numbers.
> 
> hm, i still like Con's approach in this case because it makes 
> independent sense: in essence we calculate the "human visible" effective 
> latency of a physical resource: more CPUs/threads means more parallelism 
> and less visible choppiness of whatever basic chunking of workloads 
> there might be, hence larger size chunking can be done.

If there were no penalty, you would like the timeslice as small as
possible.

There is a penalty, which is why we want larger timeslices.

This penalty is still almost as significant on multiprocessor systems
as it is on single processor systems (remote memory / coherency
traffic make it slightly more on some multiprocessors, but nothing
like the basic cache<->RAM order of magnitude problem).


> > > it doesnt in any test i do, but again, i'm erring on the side of it 
> > > being more interactive.
> > 
> > I'd start by erring on the side of trying to ensure no obvious 
> > performance regressions like this because that's the easy part. 
> > Suppose everybody finds your scheduler wonderfully interactive, but 
> > you can't make it so with a larger timeslice?
> 
> look at CFS's design and you'll see that it can easily take larger 
> timeslices :) I really dont need any reinforcement on that part. But i 

By default, I mean.

> do need reinforcement and test results on the basic part: _can_ this 
> design be interactive enough on the desktop? So far the feedback has 
> been affirmative, but more testing is needed.

It seems to be fairly easy to make a scheduler interactive if the
timeslice is as low as that (not that I've released one for wider
testing, but just by my own observations). So I don't think we'd
need to go to rbtree based scheduling just for that.


> server scheduling, while obviously of prime importance to us, is really 
> 'easy' in comparison technically, because it has alot less human factors 
> and is thus a much more deterministic task.

But there are lots of shades of grey (CPU efficiency on desktops
is often important, and sometimes servers need to do interactive
sorts of things).

It would be much better if a single scheduler with default
settings would be reasonable for all.


> > For _real_ desktop systems, sure, erring on the side of being more 
> > interactive is fine. For RFC patches for testing, I really think you 
> > could be taking advantage of the fact that people will give you 
> > feedback on the issue.
> 
> 90% of the testers are using CFS on desktops. 80% of the scheduler 
> complaints come regarding the human (latency/behavior/consistency) 
> aspect of the upstream scheduler. (Sure, we dont want to turn that 
> around into '80% of the complaints come due to performance' - so i 
> increased the granularity based on your kbuild feedback to that near of 
> SD's, to show that mini-timeslices are not a necessity in CFS, but i 
> really think that server scheduling is the easier part.)

So why not solve that (or at least not introduce obvious regressions),
and then focus on the hard part?
