Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbXDRGhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbXDRGhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 02:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbXDRGhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 02:37:43 -0400
Received: from mx1.suse.de ([195.135.220.2]:49044 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbXDRGhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 02:37:42 -0400
Date: Wed, 18 Apr 2007 08:37:11 +0200
From: Nick Piggin <npiggin@suse.de>
To: Matt Mackall <mpm@selenic.com>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418063711.GH18452@wotan.suse.de>
References: <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418055525.GS11115@waste.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 12:55:25AM -0500, Matt Mackall wrote:
> On Wed, Apr 18, 2007 at 07:00:24AM +0200, Nick Piggin wrote:
> > > It's also not yet clear that a scheduler can't be taught to do the
> > > right thing with X without fiddling with nice levels.
> > 
> > Being fair doesn't prevent that. Implicit unfairness is wrong though,
> > because it will bite people.
> > 
> > What's wrong with allowing X to get more than it's fair share of CPU
> > time by "fiddling with nice levels"? That's what they're there for.
> 
> Why is X special? Because it does work on behalf of other processes?

The high level reason is that giving it more than its fair share of
CPU allows a desktop to remain interactive under load. And it isn't
just about doing work on behalf of other processes. Mouse interrupts
are a big part of it, for example.

> Lots of things do this. Perhaps a scheduler should focus entirely on
> the implicit and directed wakeup matrix and optimizing that
> instead[1].

You could do that, and I tried a variant of it at one point. The
problem was that it leads to unexpected bad things too.

UNIX programs more or less expect fair SCHED_OTHER scheduling, and
given the principle of least surprise...


> Why are processes special? Should user A be able to get more CPU time
> for his job than user B by splitting it into N parallel jobs? Should
> we be fair per process, per user, per thread group, per session, per
> controlling terminal? Some weighted combination of the preceding?[2]

I don't know how that supports your argument for unfairness, but
processes are special only because that's how we've always done
scheduling.  I'm not precluding other groupings for fairness, though.


> Why is the measure CPU time? I can imagine a scheduler that weighed
> memory bandwidth in the equation. Or power consumption. Or execution
> unit usage.

Feel free. And I'd also argue that once you schedule for those metrics
then fairness is also important there too.


> Fairness is nice. It's simple, it's obvious, it's predictable. But
> it's just not clear that it's optimal. If the question is (and it
> was!) "what should the basic requirements for the scheduler be?" it's
> not clear that fairness is a requirement or even how to pick a metric
> for fairness that's obviously and uniquely superior.

What do you mean optimal? If your criteria is fairness, then of course
it is optimal. If your criteria is throughput, then it probably isn't.

Considering it is simple and what we've always done, measuring fairness
by CPU time per process is obvious for a general purpose scheduler.
If you accept that, then I argue that fairness is an optimal property
given that the alternative is unfairness.


> It's instead much easier to try to recognize and rule out really bad
> behaviour with bounded latencies, minimum service guarantees, etc.

It's the bad behaviour that you didn't recognize that is the problem.
If you start with explicit fairness, then unfairness will never be
one of those problems.


> [1] That's basically how Google decides to prioritize webpages, which
> it seems to do moderately well. And how a number of other optimization
> problems are solved.

This is not an optimization problem, it is a heuristic. There is no
right and wrong answer.


> [2] It's trivial to construct two or more perfectly reasonable and
> desirable definitions of fairness that are mutually incompatible.

Probably not if you use common sense, and in the context of a replacement
for the 2.6 scheduler.
