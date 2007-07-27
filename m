Return-Path: <linux-kernel-owner+w=401wt.eu-S938518AbXG0Xgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938518AbXG0Xgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937829AbXG0Xgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:36:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936615AbXG0Xgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:36:39 -0400
Message-ID: <46AA8171.2060400@redhat.com>
Date: Fri, 27 Jul 2007 19:36:17 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Tong Li <tong.n.li@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>  <20070725110159.GA15076@elte.hu> <20070725120358.GA30755@elte.hu>  <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com>  <20070725192442.GC4463@elte.hu>  <Pine.LNX.4.64.0707261123060.9352@tongli.jf.intel.com>  <20070726213154.GA26569@elte.hu> <1185487225.3122.11.camel@tongli.jf.intel.com> <Pine.LNX.4.64.0707261806450.5321@tongli.jf.intel.com> <46AA287D.8070200@redhat.com> <Pine.LNX.4.64.0707271159420.12201@tongli.jf.intel.com>
In-Reply-To: <Pine.LNX.4.64.0707271159420.12201@tongli.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tong Li wrote:
> On Fri, 27 Jul 2007, Chris Snook wrote:
> 
>> Tong Li wrote:
>>> I'd like to clarify that I'm not trying to push this particular code 
>>> to the kernel. I'm a researcher. My intent was to point out that we 
>>> have a problem in the scheduler and my dwrr algorithm can potentially 
>>> help fix it. The patch itself was merely a proof-of-concept. I'd be 
>>> thrilled if the algorithm can be proven useful in the real world. I 
>>> appreciate the people who have given me comments. Since then, I've 
>>> revised my algorithm/code. Now it doesn't require global locking but 
>>> retains strong fairness properties (which I was able to prove 
>>> mathematically).
>>
>> Thanks for doing this work.  Please don't take the implementation 
>> criticism as a lack of appreciation for the work.  I'd like to see 
>> dwrr in the scheduler, but I'm skeptical that re-introducing expired 
>> runqueues is the most efficient way to do it.
>>
>> Given the inherently controversial nature of scheduler code, 
>> particularly that which attempts to enforce fairness, perhaps a 
>> concise design document would help us come to an agreement about what 
>> we think the scheduler should do and what tradeoffs we're willing to 
>> make to do those things.  Do you have a design document we could discuss?
>>
>>     -- Chris
>>
> 
> Thanks for the interest. Attached is a design doc I wrote several months 
> ago (with small modifications). It talks about the two pieces of my 
> design: group scheduling and dwrr. The description was based on the 
> original O(1) scheduler, but as my CFS patch showed, the algorithm is 
> applicable to other underlying schedulers as well. It's interesting that 
> I started working on this in January for the purpose of eventually 
> writing a paper about it. So I knew reasonably well the related research 
> work but was totally unaware that people in the Linux community were 
> also working on similar things. This is good. If you are interested, I'd 
> like to help with the algorithms and theory side of the things.
> 
>   tong
> 
> -------------------------------------------
> Overview:
> 
> Trio extends the existing Linux scheduler with support for 
> proportional-share scheduling. It uses a scheduling algorithm, called 
> Distributed Weighted Round-Robin (DWRR), which retains the existing 
> scheduler design as much as possible, and extends it to achieve 
> proportional fairness with O(1) time complexity and a constant error 
> bound, compared to the ideal fair scheduling algorithm. The goal of Trio 
> is not to improve interactive performance; rather, it relies on the 
> existing scheduler for interactivity and extends it to support MP 
> proportional fairness.
> 
> Trio has two unique features: (1) it enables users to control shares of 
> CPU time for any thread or group of threads (e.g., a process, an 
> application, etc.), and (2) it enables fair sharing of CPU time across 
> multiple CPUs. For example, with ten tasks running on eight CPUs, Trio 
> allows each task to take an equal fraction of the total CPU time. These 
> features enable Trio to complement the existing Linux scheduler to 
> enable greater user flexibility and stronger fairness.
> 
> Background:
> 
> Over the years, there has been a lot of criticism that conventional Unix 
> priorities and the nice interface provide insufficient support for users 
> to accurately control CPU shares of different threads or applications. 
> Many have studied scheduling algorithms that achieve proportional 
> fairness. Assuming that each thread has a weight that expresses its 
> desired CPU share, informally, a scheduler is proportionally fair if (1) 
> it is work-conserving, and (2) it allocates CPU time to threads in exact 
> proportion to their weights in any time interval. Ideal proportional 
> fairness is impractical since it requires that all runnable threads be 
> running simultaneously and scheduled with infinitesimally small quanta. 
> In practice, every proportional-share scheduling algorithm approximates 
> the ideal algorithm with the goal of achieving a constant error bound. 
> For more theoretical background, please refer to the following papers:

I don't think that achieving a constant error bound is always a good thing.  We 
all know that fairness has overhead.  If I have 3 threads and 2 processors, and 
I have a choice between fairly giving each thread 1.0 billion cycles during the 
next second, or unfairly giving two of them 1.1 billion cycles and giving the 
other 0.9 billion cycles, then we can have a useful discussion about where we 
want to draw the line on the fairness/performance tradeoff.  On the other hand, 
if we can give two of them 1.1 billion cycles and still give the other one 1.0 
billion cycles, it's madness to waste those 0.2 billion cycles just to avoid 
user jealousy.  The more complex the memory topology of a system, the more 
"free" cycles you'll get by tolerating short-term unfairness.  As a crude 
heuristic, scaling some fairly low tolerance by log2(NCPUS) seems appropriate, 
but eventually we should take the boot-time computed migration costs into 
consideration.

> [1] A. K. Parekh and R. G. Gallager. A generalized processor sharing
> approach to flow control in integrated services networks: The single-node
> case. IEEE/ACM Transactions on Networking, 1(3):344-357, June 1993.
> 
> [2] C. R. Bennett and H. Zhang. WF2Q: Worst-case fair weighted fair 
> queueing. In Proceedings of IEEE INFOCOM '94, pages 120-128, Mar. 1996.
> 
> Previous proportional-share scheduling algorithms, however, suffer one 
> or more of the following problems:
> 
> (1) Inaccurate fairness with non-constant error bounds;
> (2) High run-time overhead (e.g., logarithmic);
> (3) Poor scalability due to the use of a global thread queue;
> (4) Inefficient support for latency-sensitive applications.
> 
> Since the Linux scheduler has been successful at avoiding problems 2 to 
> 4, this design attempts to extend it with support for accurate 
> proportional fairness while retaining all of its existing benefits.

If we allow a little short-term fairness (and I think we should) we can still 
account for this unfairness and compensate for it (again, with the same 
tolerance) at the next rebalancing.

> User Interface:
> 
> By default, each thread is assigned a weight proportional to its static 
> priority. A set of system calls also allow users to specify a weight or 
> reservation for any thread. Weights are relative. For example, for two 
> threads with weights 3 and 1, the scheduler ensures that the ratio of 
> their CPU time is 3:1. Reservations are absolute and in the form of X% 
> of the total CPU time. For example, a reservation of 80% for a thread 
> means that the thread always receives at least 80% of the total CPU time 
> regardless of other threads.
> 
> The system calls also support specifying weights or reservations for 
> groups of threads. For example, one can specify an 80% reservation for a 
> group of threads (e.g., a process) to control the total CPU share to 
> which the member threads are collectively entitled.  Within the group, 
> the user can further specify local weights to different threads to 
> control their relative shares.

Adding system calls, while great for research, is not something which is done 
lightly in the published kernel.  If we're going to implement a user interface 
beyond simply interpreting existing priorities more precisely, it would be nice 
if this was part of a framework with a broader vision, such as a scheduler economy.

> Scheduling Algorithm:
> 
> The scheduler keeps a set data structures, called Trio groups, to 
> maintain the weight or reservation of each thread group (including one 
> or more threads) and the local weight of each member thread. When 
> scheduling a thread, it consults these data structures and computes (in 
> constant time) a system-wide weight for the thread that represents an 
> equivalent CPU share. Consequently, the scheduling algorithm, DWRR, 
> operates solely based on the system-wide weight (or weight for short, 
> hereafter) of each thread. Having a flat space of system-wide weights 
> for individual threads avoids performing seperate scheduling at each 
> level of the group hierarchy and thus greatly simplies the 
> implementation for group scheduling.

Implementing a flat weight space efficiently is nontrivial.  I'm curious to see 
how you reworked the original patch without global locking.

> For each processor, besides the existing active and expired arrays, DWRR 
> keeps one more array, called round-expired. It also keeps a round number 
> for each processor, initially all zero. A thread is said to be in round 
> R if it is in the active or expired array of a round-R processor. For 
> each thread, DWRR associates it with a round slice, equal to its weight 
> multiplied by a system constant, called base round slice, which controls 
> the total time that the thread can run in any round.  When a thread 
> exhausts its time slice, as in the existing scheduler, DWRR moves it to 
> the expired array. However, when it exhausts its round slice, DWRR moves 
> it to the round-expired array, indicating that the thread has finished 
> round R.  In this way, all threads in the active and expired array on a 
> round-R processor are running in round R, while the threads in the 
> round-expired array have finished round R and are awaiting to start 
> round R+1.  Threads in the active and expired arrays are scheduled the 
> same way as the existing scheduler.

I had a feeling this patch was originally designed for the O(1) scheduler, and 
this is why.  The old scheduler had expired arrays, so adding a round-expired 
array wasn't a radical departure from the design.  CFS does not have an expired 
rbtree, so adding one *is* a radical departure from the design.  I think we can 
implement DWRR or something very similar without using this implementation 
method.  Since we've already got a tree of queued tasks, it might be easiest to 
basically break off one subtree (usually just one task, but not necessarily) and 
migrate it to a less loaded tree whenever we can reduce the difference between 
the load on the two trees by at least half.  This would prevent both 
overcorrection and undercorrection.

> When a processor's active array is empty, as usual, the active and 
> expired arrays are switched. When both active and expired are empty, 
> DWRR eventually wants to switch the active and round-expired arrays, 
> thus advancing the current processor to the next round. However, to 
> guarantee fairness, it needs to maintain the invariant that the 
> differences of all processors' rounds are bounded by a constant, where 
> the smaller this constant is, the stronger fairness it can guarantee 
> (the following assumes the constant is 1). With this invariant, it can 
> be shown that, during any time interval, the number of rounds that any 
> two threads go through differs by the constant, which is key to ensuring 
> DWRR's constant error bound compared to the ideal algorithm.
> 
> To enforce the above invariant, DWRR keeps track of the highest round 
> (referred to as highest) among all processors at any time and ensures 
> that no processor in round highest can advance to round highest+1 (thus 
> updating highest), if there exists at least one thread in the system 
> that is still in round highest. There are at least two approaches to 
> maintain a global highest round variable. One is to associate it with a 
> global lock to ensure consistency of its value. However, this may be not 
> be scalable. Thus, a second approach is to use no locking, but it could 
> lead to inconsistencies in the value. However, such inconsistencies 
> don't affect correctness of the kernel and the only impact is that the 
> fairness error of the scheduler can be twice as big as the locking 
> approach, but the error is still bounded by a constant and thus 
> sufficient in most cases. The following describes the operations of 
> DWRR, assuming the locking approach, while the non-locking approach 
> requires only simple changes.

The idea of rounds was another implementation detail that bothered me.  In the 
old scheduler, quantizing CPU time was a necessary evil.  Now that we can 
account for CPU time with nanosecond resolution, doing things on an as-needed 
basis seems more appropriate, and should reduce the need for global synchronization.

> On any processor p, whenever both the active and expired arrays become 
> empty, DWRR compares the round of p with highest. If equal, it performs 
> idle load balancing in two steps: (1) It Identifies runnable threads 
> that are in round highest but not currently running. Such threads can be 
> in the active or expired array of a round highest processor, or in the 
> round-expired array of a round highest - 1 processor. (2) Among those 
> threads from step 1, move X of them to the active array of p, where X is 
> a design choice and does not impact the fairness properties of DWRR. If 
> step 1 returns no suitable threads, DWRR proceeds as if the round of 
> processor p is less than highest, in which case DWRR switches p's active 
> and round-expired arrays, and increments p's round by one, thus allowing 
> all threads in its round-expired array to advance to the next round.
> 
> Whenever the system creates a new thread or awakens an existing one, 
> DWRR inserts the thread into the active array of an idle processor and 
> sets the processor's round to the current value of highest. If no idle 
> processor exists, it starts the thread on the least loaded processor 
> among those in round highest.
> 
> Whenever a processor goes idle (i.e., all of its three arrays are 
> empty), DWRR resets its round to zero. Similar to the existing 
> scheduler, DWRR also performs periodic load balancing but only among 
> processors in round highest. Unlike idle load balancing, periodic load 
> balancing only improves performance and is not necessary for fairness.

In summary, I think the accounting is sound, but the enforcement is sub-optimal 
for the new scheduler.  A revision of the algorithm more cognizant of the 
capabilities and design of the current scheduler would seem to be in order.

I've referenced many times my desire to account for CPU/memory hierarchy in 
these patches.  At present, I'm not sure we have sufficient infrastructure in 
the kernel to automatically optimize for system topology, but I think whatever 
design we pursue should have some concept of this hierarchy, even if we end up 
using a depth-1 tree in the short term while we figure out how to optimize this.

	-- Chris
