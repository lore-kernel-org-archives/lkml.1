Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbXG1TXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbXG1TXr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 15:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbXG1TXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 15:23:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:9190 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbXG1TXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 15:23:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,194,1183359600"; 
   d="scan'208";a="255922565"
Date: Sat, 28 Jul 2007 12:23:35 -0700 (PDT)
From: Tong Li <tong.n.li@intel.com>
X-X-Sender: tongli@tongli.jf.intel.com
To: Chris Snook <csnook@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
In-Reply-To: <46AA8171.2060400@redhat.com>
Message-ID: <Pine.LNX.4.64.0707281121580.22772@tongli.jf.intel.com>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> 
 <20070725110159.GA15076@elte.hu> <20070725120358.GA30755@elte.hu> 
 <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com>  <20070725192442.GC4463@elte.hu>
  <Pine.LNX.4.64.0707261123060.9352@tongli.jf.intel.com>  <20070726213154.GA26569@elte.hu>
 <1185487225.3122.11.camel@tongli.jf.intel.com> <Pine.LNX.4.64.0707261806450.5321@tongli.jf.intel.com>
 <46AA287D.8070200@redhat.com> <Pine.LNX.4.64.0707271159420.12201@tongli.jf.intel.com>
 <46AA8171.2060400@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007, Chris Snook wrote:

> I don't think that achieving a constant error bound is always a good thing. 
> We all know that fairness has overhead.  If I have 3 threads and 2 
> processors, and I have a choice between fairly giving each thread 1.0 billion 
> cycles during the next second, or unfairly giving two of them 1.1 billion 
> cycles and giving the other 0.9 billion cycles, then we can have a useful 
> discussion about where we want to draw the line on the fairness/performance 
> tradeoff.  On the other hand, if we can give two of them 1.1 billion cycles 
> and still give the other one 1.0 billion cycles, it's madness to waste those 
> 0.2 billion cycles just to avoid user jealousy.  The more complex the memory 
> topology of a system, the more "free" cycles you'll get by tolerating 
> short-term unfairness.  As a crude heuristic, scaling some fairly low 
> tolerance by log2(NCPUS) seems appropriate, but eventually we should take the 
> boot-time computed migration costs into consideration.

I think we are in agreement. To avoid confusion, I think we should be more 
precise on what fairness means. Lag (i.e., ideal fair time - actual 
service time) is the commonly used metric for fairness. The definition is 
that a scheduler is proportionally fair if for any task in any time 
interval, the task's lag is bounded by a constant (note it's in terms of 
absolute time). The knob here is this constant and can help trade off 
performance and fairness. The reason for a constant bound is that we want 
consistent fairness properties regardless of the number of tasks. For 
example, we don't want the system to be much less fair as the number of 
tasks increases. With DWRR, the lag bound is the max weight of currently 
running tasks, multiplied by sysctl_base_round_slice. So if all tasks are 
of nice 0, i.e., weight 1, and sysctl_base_round_slice equals 30 ms, then 
we are guaranteed each task is at most 30ms off of the ideal case. This is 
a useful property. Just like what you mentioned about the migration cost, 
this property allows the scheduler or user to accurately reason about the 
tradeoffs. If we want to trade fairness for performance, we can increase 
sysctl_base_round_slice to, say, 100ms; doing so we also know accurately 
the worst impact it has on fairness.

> Adding system calls, while great for research, is not something which is done 
> lightly in the published kernel.  If we're going to implement a user 
> interface beyond simply interpreting existing priorities more precisely, it 
> would be nice if this was part of a framework with a broader vision, such as 
> a scheduler economy.

Agreed. I've seen papers on scheduler economy but not familiar enough to 
comment on it.

>
>> Scheduling Algorithm:
>> 
>> The scheduler keeps a set data structures, called Trio groups, to maintain 
>> the weight or reservation of each thread group (including one or more 
>> threads) and the local weight of each member thread. When scheduling a 
>> thread, it consults these data structures and computes (in constant time) a 
>> system-wide weight for the thread that represents an equivalent CPU share. 
>> Consequently, the scheduling algorithm, DWRR, operates solely based on the 
>> system-wide weight (or weight for short, hereafter) of each thread. Having 
>> a flat space of system-wide weights for individual threads avoids 
>> performing seperate scheduling at each level of the group hierarchy and 
>> thus greatly simplies the implementation for group scheduling.
>
> Implementing a flat weight space efficiently is nontrivial.  I'm curious to 
> see how you reworked the original patch without global locking.

I simply removed the locking and changed a little bit in idle_balance(). 
The lock was trying to avoid a thread from reading or writing the global 
highest round value while another thread is writing to it. For writes, 
it's simple to ensure without locking only one write takes effect when 
multiple writes are concurrent. For the case that there's one write going 
on and multiple threads read, without locking, the only problem is that a 
reader may read a stale value and thus thinks the current highest round is 
X while it's actually X + 1. The end effect is that a thread can be at 
most two rounds behind the highest round. This changes DWRR's lag bound to 
2 * (max weight of current tasks) * sysctl_base_round_slice, which is 
still constant.

> I had a feeling this patch was originally designed for the O(1) scheduler, 
> and this is why.  The old scheduler had expired arrays, so adding a 
> round-expired array wasn't a radical departure from the design.  CFS does not 
> have an expired rbtree, so adding one *is* a radical departure from the 
> design.  I think we can implement DWRR or something very similar without 
> using this implementation method.  Since we've already got a tree of queued 
> tasks, it might be easiest to basically break off one subtree (usually just 
> one task, but not necessarily) and migrate it to a less loaded tree whenever 
> we can reduce the difference between the load on the two trees by at least 
> half.  This would prevent both overcorrection and undercorrection.

Yes, the description was based on O(1) and the intent was exactly not to 
be much a departure from its design. I totally agree the same philosophy 
should apply to an implementation based on CFS.

> The idea of rounds was another implementation detail that bothered me.  In 
> the old scheduler, quantizing CPU time was a necessary evil.  Now that we can 
> account for CPU time with nanosecond resolution, doing things on an as-needed 
> basis seems more appropriate, and should reduce the need for global 
> synchronization.

Without the global locking, the global synchronization here is simply 
ping-ponging a cache line once of while. This doesn't look expensive to 
me, but if it does after benchmarking, adjusting sysctl_base_round_slice 
can reduce the ping-pong frequency. There might also be a smart 
implementation that can alleviate this problem.

I don't understand why quantizing CPU time is a bad thing. Could you 
educate me on this?

I guess it's worth mentioning that although we now have nanosecond-level 
accounting, scheduling in the common case still occurs at timer tick 
granularity.

> In summary, I think the accounting is sound, but the enforcement is 
> sub-optimal for the new scheduler.  A revision of the algorithm more 
> cognizant of the capabilities and design of the current scheduler would seem 
> to be in order.
>
> I've referenced many times my desire to account for CPU/memory hierarchy in 
> these patches.  At present, I'm not sure we have sufficient infrastructure in 
> the kernel to automatically optimize for system topology, but I think 
> whatever design we pursue should have some concept of this hierarchy, even if 
> we end up using a depth-1 tree in the short term while we figure out how to 
> optimize this.
>

Agreed.

   tong
