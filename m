Return-Path: <linux-kernel-owner+w=401wt.eu-S965285AbXG1AzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965285AbXG1AzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 20:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965020AbXG1Ayy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 20:54:54 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:46163
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932985AbXG1Ayx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 20:54:53 -0400
Date: Fri, 27 Jul 2007 17:54:38 -0700
To: Chris Snook <csnook@redhat.com>
Cc: Tong Li <tong.n.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
Message-ID: <20070728005438.GE32582@gnuppy.monkey.org>
References: <20070725120358.GA30755@elte.hu> <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com> <20070725192442.GC4463@elte.hu> <Pine.LNX.4.64.0707261123060.9352@tongli.jf.intel.com> <20070726213154.GA26569@elte.hu> <1185487225.3122.11.camel@tongli.jf.intel.com> <Pine.LNX.4.64.0707261806450.5321@tongli.jf.intel.com> <46AA287D.8070200@redhat.com> <Pine.LNX.4.64.0707271159420.12201@tongli.jf.intel.com> <46AA8171.2060400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AA8171.2060400@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 07:36:17PM -0400, Chris Snook wrote:
> I don't think that achieving a constant error bound is always a good thing. 
>  We all know that fairness has overhead.  If I have 3 threads and 2 
> processors, and I have a choice between fairly giving each thread 1.0 
> billion cycles during the next second, or unfairly giving two of them 1.1 
> billion cycles and giving the other 0.9 billion cycles, then we can have a 
> useful discussion about where we want to draw the line on the 
> fairness/performance tradeoff.  On the other hand, if we can give two of 
> them 1.1 billion cycles and still give the other one 1.0 billion cycles, 
> it's madness to waste those 0.2 billion cycles just to avoid user jealousy. 
>  The more complex the memory topology of a system, the more "free" cycles 
> you'll get by tolerating short-term unfairness.  As a crude heuristic, 
> scaling some fairly low tolerance by log2(NCPUS) seems appropriate, but 
> eventually we should take the boot-time computed migration costs into 
> consideration.

You have to consider the target for this kind of code. There are applications
where you need something that falls within a constant error bound. According
to the numbers, the current CFS rebalancing logic doesn't achieve that to
any degree of rigor. So CFS is ok for SCHED_OTHER, but not for anything more
strict than that.

Even the rt overload code (from my memory) is subject to these limitations
as well until it's moved to use a single global queue while using CPU
binding to turn off that logic. It's the price you pay for accuracy.

> If we allow a little short-term fairness (and I think we should) we can 
> still account for this unfairness and compensate for it (again, with the 
> same tolerance) at the next rebalancing.

Again, it's a function of *when* and depends on that application.

> Adding system calls, while great for research, is not something which is 
> done lightly in the published kernel.  If we're going to implement a user 
> interface beyond simply interpreting existing priorities more precisely, it 
> would be nice if this was part of a framework with a broader vision, such 
> as a scheduler economy.

I'm not sure what you mean by scheduler economy, but CFS can and should
be extended to handle proportional scheduling which is outside of the
traditional Unix priority semantics. Having a new API to get at this is
unavoidable if you want it to eventually support -rt oriented appications
that have bandwidth semantics.

All deadline based schedulers have API mechanisms like this to support
extended semantics. This is no different.

> I had a feeling this patch was originally designed for the O(1) scheduler, 
> and this is why.  The old scheduler had expired arrays, so adding a 
> round-expired array wasn't a radical departure from the design.  CFS does 
> not have an expired rbtree, so adding one *is* a radical departure from the 
> design.  I think we can implement DWRR or something very similar without 
> using this implementation method.  Since we've already got a tree of queued 
> tasks, it might be easiest to basically break off one subtree (usually just 
> one task, but not necessarily) and migrate it to a less loaded tree 
> whenever we can reduce the difference between the load on the two trees by 
> at least half.  This would prevent both overcorrection and undercorrection.

> The idea of rounds was another implementation detail that bothered me.  In 
> the old scheduler, quantizing CPU time was a necessary evil.  Now that we 
> can account for CPU time with nanosecond resolution, doing things on an 
> as-needed basis seems more appropriate, and should reduce the need for 
> global synchronization.

Well, there's nanosecond resolution with no mechanism that exploits it for
rebalancing. Rebalancing in general is a pain and the code for it is
generally orthogonal to the in-core scheduler data structures that are in
use, so I don't understand the objection to this argument and the choice
of methods. If it it gets the job done, then these kind of choices don't
have that much meaning.

> In summary, I think the accounting is sound, but the enforcement is 
> sub-optimal for the new scheduler.  A revision of the algorithm more 
> cognizant of the capabilities and design of the current scheduler would 
> seem to be in order.

That would be nice. But the amount of error in Tong's solution is much
less than the current CFS logic as was previously tested even without
consideration to high resolution clocks.

So you have to give some kind of credit for that approach and recognized
that current methods in CFS are technically a dead end if there's a need for
strict fairness in a more rigorous run category than SCHED_OTHER.

> I've referenced many times my desire to account for CPU/memory hierarchy in 
> these patches.  At present, I'm not sure we have sufficient infrastructure 
> in the kernel to automatically optimize for system topology, but I think 
> whatever design we pursue should have some concept of this hierarchy, even 
> if we end up using a depth-1 tree in the short term while we figure out how 
> to optimize this.

Yes, it would be nice. :)

bill

