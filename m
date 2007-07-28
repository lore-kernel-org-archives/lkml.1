Return-Path: <linux-kernel-owner+w=401wt.eu-S938439AbXG1C7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938439AbXG1C7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 22:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761089AbXG1C7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 22:59:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761261AbXG1C7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 22:59:34 -0400
Message-ID: <46AAB106.2030104@redhat.com>
Date: Fri, 27 Jul 2007 22:59:18 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Bill Huey (hui)" <billh@gnuppy.monkey.org>
CC: Tong Li <tong.n.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <20070725120358.GA30755@elte.hu> <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com> <20070725192442.GC4463@elte.hu> <Pine.LNX.4.64.0707261123060.9352@tongli.jf.intel.com> <20070726213154.GA26569@elte.hu> <1185487225.3122.11.camel@tongli.jf.intel.com> <Pine.LNX.4.64.0707261806450.5321@tongli.jf.intel.com> <46AA287D.8070200@redhat.com> <Pine.LNX.4.64.0707271159420.12201@tongli.jf.intel.com> <46AA8171.2060400@redhat.com> <20070728005438.GE32582@gnuppy.monkey.org>
In-Reply-To: <20070728005438.GE32582@gnuppy.monkey.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Huey (hui) wrote:
> On Fri, Jul 27, 2007 at 07:36:17PM -0400, Chris Snook wrote:
>> I don't think that achieving a constant error bound is always a good thing. 
>>  We all know that fairness has overhead.  If I have 3 threads and 2 
>> processors, and I have a choice between fairly giving each thread 1.0 
>> billion cycles during the next second, or unfairly giving two of them 1.1 
>> billion cycles and giving the other 0.9 billion cycles, then we can have a 
>> useful discussion about where we want to draw the line on the 
>> fairness/performance tradeoff.  On the other hand, if we can give two of 
>> them 1.1 billion cycles and still give the other one 1.0 billion cycles, 
>> it's madness to waste those 0.2 billion cycles just to avoid user jealousy. 
>>  The more complex the memory topology of a system, the more "free" cycles 
>> you'll get by tolerating short-term unfairness.  As a crude heuristic, 
>> scaling some fairly low tolerance by log2(NCPUS) seems appropriate, but 
>> eventually we should take the boot-time computed migration costs into 
>> consideration.
> 
> You have to consider the target for this kind of code. There are applications
> where you need something that falls within a constant error bound. According
> to the numbers, the current CFS rebalancing logic doesn't achieve that to
> any degree of rigor. So CFS is ok for SCHED_OTHER, but not for anything more
> strict than that.

I've said from the beginning that I think that anyone who desperately needs 
perfect fairness should be explicitly enforcing it with the aid of realtime 
priorities.  The problem is that configuring and tuning a realtime application 
is a pain, and people want to be able to approximate this behavior without doing 
a whole lot of dirty work themselves.  I believe that CFS can and should be 
enhanced to ensure SMP-fairness over potentially short, user-configurable 
intervals, even for SCHED_OTHER.  I do not, however, believe that we should take 
it to the extreme of wasting CPU cycles on migrations that will not improve 
performance for *any* task, just to avoid letting some tasks get ahead of 
others.  We should be as fair as possible but no fairer.  If we've already made 
it as fair as possible, we should account for the margin of error and correct 
for it the next time we rebalance.  We should not burn the surplus just to get 
rid of it.

On a non-NUMA box with single-socket, non-SMT processors, a constant error bound 
is fine.  Once we add SMT, go multi-core, go NUMA, and add inter-chassis 
interconnects on top of that, we need to multiply this error bound at each stage 
in the hierarchy, or else we'll end up wasting CPU cycles on migrations that 
actually hurt the processes they're supposed to be helping, and hurt everyone 
else even more.  I believe we should enforce an error bound that is proportional 
to migration cost.

> Even the rt overload code (from my memory) is subject to these limitations
> as well until it's moved to use a single global queue while using CPU
> binding to turn off that logic. It's the price you pay for accuracy.
> 
>> If we allow a little short-term fairness (and I think we should) we can 
>> still account for this unfairness and compensate for it (again, with the 
>> same tolerance) at the next rebalancing.
> 
> Again, it's a function of *when* and depends on that application.
> 
>> Adding system calls, while great for research, is not something which is 
>> done lightly in the published kernel.  If we're going to implement a user 
>> interface beyond simply interpreting existing priorities more precisely, it 
>> would be nice if this was part of a framework with a broader vision, such 
>> as a scheduler economy.
> 
> I'm not sure what you mean by scheduler economy, but CFS can and should
> be extended to handle proportional scheduling which is outside of the
> traditional Unix priority semantics. Having a new API to get at this is
> unavoidable if you want it to eventually support -rt oriented appications
> that have bandwidth semantics.

A scheduler economy is basically a credit scheduler, augmented to allow 
processes to exchange credits with each other.  If you want to get more 
sophisticated with fairness, you could price CPU time proportional to load on 
that CPU.

I've been house-hunting lately, so I like to think of it in real estate terms. 
If you're comfortable with your standard of living and you have enough money, 
you can rent the apartment in the chic part of town, right next to the subway 
station.  If you want to be more frugal because you're saving for retirement, 
you can get a place out in the suburbs, but the commute will be more of a pain. 
  If you can't make up your mind and keep moving back and forth, you spend a lot 
on moving and all your stuff gets dented and scratched.

> All deadline based schedulers have API mechanisms like this to support
> extended semantics. This is no different.
> 
>> I had a feeling this patch was originally designed for the O(1) scheduler, 
>> and this is why.  The old scheduler had expired arrays, so adding a 
>> round-expired array wasn't a radical departure from the design.  CFS does 
>> not have an expired rbtree, so adding one *is* a radical departure from the 
>> design.  I think we can implement DWRR or something very similar without 
>> using this implementation method.  Since we've already got a tree of queued 
>> tasks, it might be easiest to basically break off one subtree (usually just 
>> one task, but not necessarily) and migrate it to a less loaded tree 
>> whenever we can reduce the difference between the load on the two trees by 
>> at least half.  This would prevent both overcorrection and undercorrection.
> 
>> The idea of rounds was another implementation detail that bothered me.  In 
>> the old scheduler, quantizing CPU time was a necessary evil.  Now that we 
>> can account for CPU time with nanosecond resolution, doing things on an 
>> as-needed basis seems more appropriate, and should reduce the need for 
>> global synchronization.
> 
> Well, there's nanosecond resolution with no mechanism that exploits it for
> rebalancing. Rebalancing in general is a pain and the code for it is
> generally orthogonal to the in-core scheduler data structures that are in
> use, so I don't understand the objection to this argument and the choice
> of methods. If it it gets the job done, then these kind of choices don't
> have that much meaning.

If we stick to the CFS way of doing things, instead of slapping on a construct 
that is alien to the current code, we can implement it in 20 lines of code, 
rather than 700.  That's an optimization worth making.

>> In summary, I think the accounting is sound, but the enforcement is 
>> sub-optimal for the new scheduler.  A revision of the algorithm more 
>> cognizant of the capabilities and design of the current scheduler would 
>> seem to be in order.
> 
> That would be nice. But the amount of error in Tong's solution is much
> less than the current CFS logic as was previously tested even without
> consideration to high resolution clocks.
> 
> So you have to give some kind of credit for that approach and recognized
> that current methods in CFS are technically a dead end if there's a need for
> strict fairness in a more rigorous run category than SCHED_OTHER.

But this patch is only relevant to SCHED_OTHER.  The realtime scheduler doesn't 
have a concept of fairness, just priorities.  That why each realtime priority 
level has its own separate runqueue.  Realtime schedulers are supposed to be 
dumb as a post, so they cannot heuristically decide to do anything other than 
precisely what you configured them to do, and so they don't get in the way when 
you're context switching a million times a second.

What you're describing is group fairness, which is precisely what I believe we 
can improve in SCHED_OTHER or something similar using the general DWRR concept, 
but implemented in a more efficient and maintainable manner.

>> I've referenced many times my desire to account for CPU/memory hierarchy in 
>> these patches.  At present, I'm not sure we have sufficient infrastructure 
>> in the kernel to automatically optimize for system topology, but I think 
>> whatever design we pursue should have some concept of this hierarchy, even 
>> if we end up using a depth-1 tree in the short term while we figure out how 
>> to optimize this.
> 
> Yes, it would be nice. :)
> 
> bill
> 

