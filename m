Return-Path: <linux-kernel-owner+w=401wt.eu-S1762624AbXGXRH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762624AbXGXRH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbXGXRHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:07:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:18417 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929AbXGXRHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:07:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,574,1175497200"; 
   d="scan'208";a="109408817"
Date: Tue, 24 Jul 2007 10:07:45 -0700 (PDT)
From: Tong Li <tong.n.li@intel.com>
X-X-Sender: tongli@tongli.jf.intel.com
To: Chris Snook <csnook@redhat.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
In-Reply-To: <46A53C88.6060006@redhat.com>
Message-ID: <Pine.LNX.4.64.0707240954560.8026@tongli.jf.intel.com>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>
 <46A53C88.6060006@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007, Chris Snook wrote:

> This patch is massive overkill.  Maybe you're not seeing the overhead on your 
> 8-way box, but I bet we'd see it on a 4096-way NUMA box with a partially-RT 
> workload.  Do you have any data justifying the need for this patch?
>
> Doing anything globally is expensive, and should be avoided at all costs. 
> The scheduler already rebalances when a CPU is idle, so you're really just 
> rebalancing the overload here.  On a server workload, we don't necessarily 
> want to do that, since the overload may be multiple threads spawned to 
> service a single request, and could be sharing a lot of data.
>
> Instead of an explicit system-wide fairness invariant (which will get very 
> hard to enforce when you throw SCHED_FIFO processes into the mix and the 
> scheduler isn't running on some CPUs), try a simpler invariant.  If we 
> guarantee that the load on CPU X does not differ from the load on CPU (X+1)%N 
> by more than some small constant, then we know that the system is fairly 
> balanced.  We can achieve global fairness with local balancing, and avoid all 
> this overhead.  This has the added advantage of keeping most of the 
> migrations core/socket/node-local on SMT/multicore/NUMA systems.
>

Chris,

These are all good comments. Thanks. I see three concerns and I'll try to 
address each.

1. Unjustified effort/cost

My view is that fairness (or proportional fairness) is a first-order 
metric and necessary in many cases even at the cost of performance. A 
server running multiple client apps certainly doesn't want the clients to 
see that they are getting different amounts of service, assuming the 
clients are of equal importance (priority). When the clients have 
different priorities, the server also wants to give them service time 
proportional to their priority/weight. The same is true for desktops, 
where users want to nice tasks and see an effect that's consistent with 
what they expect, i.e., task CPU time should be proportional to their nice 
values. The point is that it's important to enforce fairness because it 
enables users to control the system in a deterministic way and it helps 
each task get good response time. CFS achieves this on local CPUs and this 
patch makes the support stronger for SMPs. It's overkill to enforce 
unnecessary degree of fairness, but it is necessary to enforce an error 
bound, even if large, such that the user can reliably know what kind of 
CPU time (even performance) he'd get after making a nice value change. 
This patch ensures an error bound of (max task weight currently in system) 
* sysctl_base_round_slice compared to an idealized fair system.

2. High performance overhead

Two sources of overhead: (1) the global rw_lock, and (2) task migrations. 
I agree they can be problems on NUMA, but I'd argue they are not on SMPs. 
Any global lock can cause two performance problems: (1) serialization, and 
(2) excessive remote cache accesses and traffic. IMO (1) is not a problem 
since this is a rw_lock and a write_lock occurs infrequently only when all 
tasks in the system finish the current round. (2) could be a problem as 
every read/write lock causes an invalidation. It could be improved by 
using Nick's ticket lock. On the other hand, this is a single cache line 
and it's invalidated only when a CPU finishes all tasks in its local 
active RB tree, where each nice 0 task takes sysctl_base_round_slice 
(e.g., 30ms) to finish, so it looks to me the invalidations would be 
infrequent enough and could be noise in the whole system.

The patch can introduce more task migrations. I don't think it's a problem 
in SMPs. For one, CFS already is doing context switches more frequently 
than before, and thus even if a task doesn't migration, it may still miss 
in the local cache because the previous task kicked out its data. In this 
sense, migration doesn't add more cache misses. Now, in NUMA, the penalty 
of a cache miss can be much higher if we migrate off-node. Here, I agree 
that this can be a problem. For NUMA, I'd expect the user to tune 
sysctl_base_round_slice to a large enough value to avoid frequent 
migrations (or just affinitize tasks). Benchmarking could also help us 
determine a reasonable default sysctl_base_round_slice for NUMA.

3. Hard to enforce fairness when there are non-SCHED_FAIR tasks

All we want is to enforce fairness among the SCHED_FAIR tasks. Leveraging 
CFS, this patch makes sure relative CPU time of two SCHED_FAIR tasks in an 
SMP equals their weight ratio. In other words, if the entire SCHED_FAIR 
tasks are given X amount of CPU time, then a weight w task is guaranteed 
with w/X time in any interval of time.

   tong
