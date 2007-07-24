Return-Path: <linux-kernel-owner+w=401wt.eu-S1761614AbXGXSIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614AbXGXSIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbXGXSIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:08:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbXGXSIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:08:10 -0400
Message-ID: <46A64002.8080103@redhat.com>
Date: Tue, 24 Jul 2007 14:08:02 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Tong Li <tong.n.li@intel.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <46A53C88.6060006@redhat.com> <Pine.LNX.4.64.0707240954560.8026@tongli.jf.intel.com>
In-Reply-To: <Pine.LNX.4.64.0707240954560.8026@tongli.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tong Li wrote:
> On Mon, 23 Jul 2007, Chris Snook wrote:
> 
>> This patch is massive overkill.  Maybe you're not seeing the overhead 
>> on your 8-way box, but I bet we'd see it on a 4096-way NUMA box with a 
>> partially-RT workload.  Do you have any data justifying the need for 
>> this patch?
>>
>> Doing anything globally is expensive, and should be avoided at all 
>> costs. The scheduler already rebalances when a CPU is idle, so you're 
>> really just rebalancing the overload here.  On a server workload, we 
>> don't necessarily want to do that, since the overload may be multiple 
>> threads spawned to service a single request, and could be sharing a 
>> lot of data.
>>
>> Instead of an explicit system-wide fairness invariant (which will get 
>> very hard to enforce when you throw SCHED_FIFO processes into the mix 
>> and the scheduler isn't running on some CPUs), try a simpler 
>> invariant.  If we guarantee that the load on CPU X does not differ 
>> from the load on CPU (X+1)%N by more than some small constant, then we 
>> know that the system is fairly balanced.  We can achieve global 
>> fairness with local balancing, and avoid all this overhead.  This has 
>> the added advantage of keeping most of the migrations 
>> core/socket/node-local on SMT/multicore/NUMA systems.
>>
> 
> Chris,
> 
> These are all good comments. Thanks. I see three concerns and I'll try 
> to address each.
> 
> 1. Unjustified effort/cost
> 
> My view is that fairness (or proportional fairness) is a first-order 
> metric and necessary in many cases even at the cost of performance.

In the cases where it's critical, we have realtime.  In the cases where it's 
important, this implementation won't keep latency low enough to make people 
happier.  If you've got a test case to prove me wrong, I'd like to see it.

> A 
> server running multiple client apps certainly doesn't want the clients 
> to see that they are getting different amounts of service, assuming the 
> clients are of equal importance (priority).

A conventional server receives client requests, does a brief amount of work, and 
then gives a response.  This patch doesn't help that workload.  This patch helps 
the case where you've got batch jobs running on a slightly overloaded compute 
server, and unfairness means you end up waiting for a couple threads to finish 
at the end while CPUs sit idle.  I don't think it's that big of a problem, and 
if it is, I think we can solve it in a more elegant way than reintroducing 
expired queues.

> When the clients have 
> different priorities, the server also wants to give them service time 
> proportional to their priority/weight. The same is true for desktops, 
> where users want to nice tasks and see an effect that's consistent with 
> what they expect, i.e., task CPU time should be proportional to their 
> nice values. The point is that it's important to enforce fairness 
> because it enables users to control the system in a deterministic way 
> and it helps each task get good response time. CFS achieves this on 
> local CPUs and this patch makes the support stronger for SMPs. It's 
> overkill to enforce unnecessary degree of fairness, but it is necessary 
> to enforce an error bound, even if large, such that the user can 
> reliably know what kind of CPU time (even performance) he'd get after 
> making a nice value change.

Doesn't CFS already do this?

> This patch ensures an error bound of (max 
> task weight currently in system) * sysctl_base_round_slice compared to 
> an idealized fair system.

The thing that bugs me about this is the diminishing returns.  It looks like it 
will only give a substantial benefit when system load is somewhere between 1.0 
and 2.0.  On a heavily-loaded system, CFS will do the right thing within a good 
margin of error, and on an underloaded system, even a naive scheduler will do 
the right thing.  If you want to optimize smp fairness in this range, that's 
great, but there's probably a lighter-weight way to do it.

> 2. High performance overhead
> 
> Two sources of overhead: (1) the global rw_lock, and (2) task 
> migrations. I agree they can be problems on NUMA, but I'd argue they are 
> not on SMPs. Any global lock can cause two performance problems: (1) 
> serialization, and (2) excessive remote cache accesses and traffic. IMO 
> (1) is not a problem since this is a rw_lock and a write_lock occurs 
> infrequently only when all tasks in the system finish the current round. 
> (2) could be a problem as every read/write lock causes an invalidation. 
> It could be improved by using Nick's ticket lock. On the other hand, 
> this is a single cache line and it's invalidated only when a CPU 
> finishes all tasks in its local active RB tree, where each nice 0 task 
> takes sysctl_base_round_slice (e.g., 30ms) to finish, so it looks to me 
> the invalidations would be infrequent enough and could be noise in the 
> whole system.

Task migrations don't bother me all that much.  Since we're migrating the 
*overload*, I expect those processes to be fairly cache-cold whenever we get 
around to them anyway.  It'd be nice to be SMT/multicore/NUMA-smart about the 
migrations, but that's an implementation detail.

The global lock is what really bothers me.  It's not just that it'll suck in 
certain rare cases (though I think it will), but it's really more the top-down 
design.  If we take a bottom-up approach, first keeping fairness between 
neighbors, it'll function identically on the low-end systems, but it'll be a 
huge win on the big systems, instead of a potential bottleneck.

> The patch can introduce more task migrations. I don't think it's a 
> problem in SMPs. For one, CFS already is doing context switches more 
> frequently than before, and thus even if a task doesn't migration, it 
> may still miss in the local cache because the previous task kicked out 
> its data. In this sense, migration doesn't add more cache misses. Now, 
> in NUMA, the penalty of a cache miss can be much higher if we migrate 
> off-node. Here, I agree that this can be a problem. For NUMA, I'd expect 
> the user to tune sysctl_base_round_slice to a large enough value to 
> avoid frequent migrations (or just affinitize tasks). Benchmarking could 
> also help us determine a reasonable default sysctl_base_round_slice for 
> NUMA.

The kernel should be tuned reasonably by default.  The days in which NUMA 
implied a supercomputer tuned by specialists are over.  NUMA is commodity now. 
As a simple heuristic, I suggest multiplying your default 
sysctl_base_round_slice by (log2(num_nodes)+1).  This scales the migration cost 
proportionally on most simple topologies.  People with gigantic torus-topology 
supercomputers who still bring in specialists to tune everything might still 
want to raise it.

> 3. Hard to enforce fairness when there are non-SCHED_FAIR tasks
> 
> All we want is to enforce fairness among the SCHED_FAIR tasks. 
> Leveraging CFS, this patch makes sure relative CPU time of two 
> SCHED_FAIR tasks in an SMP equals their weight ratio. In other words, if 
> the entire SCHED_FAIR tasks are given X amount of CPU time, then a 
> weight w task is guaranteed with w/X time in any interval of time.

The problem is that there are various reasons why a particular CPU might not get 
to execute this codepath for a little while, and then either your round 
invariant is broken, or you have a performance-killing barrier.  Relaxing your 
invariants and your locking would mitigate this.

Concerns aside, I agree that fairness is important, and I'd really like to see a 
test case that demonstrates the problem.

	-- Chris
