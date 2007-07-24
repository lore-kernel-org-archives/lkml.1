Return-Path: <linux-kernel-owner+w=401wt.eu-S932456AbXGXIIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbXGXIIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbXGXIIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:08:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbXGXIIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:08:17 -0400
Message-ID: <46A5B35F.90103@redhat.com>
Date: Tue, 24 Jul 2007 04:07:59 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Tong Li <tong.n.li@intel.com>, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <46A53C88.6060006@redhat.com>
In-Reply-To: <46A53C88.6060006@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> Tong Li wrote:
>> This patch extends CFS to achieve better fairness for SMPs. For 
>> example, with 10 tasks (same priority) on 8 CPUs, it enables each task 
>> to receive equal CPU time (80%). The code works on top of CFS and 
>> provides SMP fairness at a coarser time grainularity; local on each 
>> CPU, it relies on CFS to provide fine-grained fairness and good 
>> interactivity.
>>
>> The code is based on the distributed weighted round-robin (DWRR) 
>> algorithm. It keeps two RB trees on each CPU: one is the original 
>> cfs_rq, referred to as active, and one is a new cfs_rq, called 
>> round-expired. Each CPU keeps a round number, initially zero. The 
>> scheduler works exactly the same way as in CFS, but only runs tasks 
>> from the active tree. Each task is assigned a round slice, equal to 
>> its weight times a system constant (e.g., 100ms), controlled by 
>> sysctl_base_round_slice. When a task uses up its round slice, it moves 
>> to the round-expired tree on the same CPU and stops running. Thus, at 
>> any time on each CPU, the active tree contains all tasks that are 
>> running in the current round, while tasks in round-expired have all 
>> finished the current round and await to start the next round. When an 
>> active tree becomes empty, it calls idle_balance() to grab tasks of 
>> the same round from other CPUs. If none can be moved over, it switches 
>> its active and round-expired trees, thus unleashing round-expired 
>> tasks and advancing the local round number by one. An invariant it 
>> maintains is that the round numbers of any two CPUs in the system 
>> differ by at most one. This property ensures fairness across CPUs. The 
>> variable sysctl_base_round_slice controls fairness-performance 
>> tradeoffs: a smaller value leads to better cross-CPU fairness at the 
>> potential cost of performance; on the other hand, the larger the value 
>> is, the closer the system behavior is to the default CFS without the 
>> patch.
>>
>> Any comments and suggestions would be highly appreciated.
> 
> This patch is massive overkill.  Maybe you're not seeing the overhead on 
> your 8-way box, but I bet we'd see it on a 4096-way NUMA box with a 
> partially-RT workload.  Do you have any data justifying the need for 
> this patch?
> 
> Doing anything globally is expensive, and should be avoided at all 
> costs.  The scheduler already rebalances when a CPU is idle, so you're 
> really just rebalancing the overload here.  On a server workload, we 
> don't necessarily want to do that, since the overload may be multiple 
> threads spawned to service a single request, and could be sharing a lot 
> of data.
> 
> Instead of an explicit system-wide fairness invariant (which will get 
> very hard to enforce when you throw SCHED_FIFO processes into the mix 
> and the scheduler isn't running on some CPUs), try a simpler invariant.  
> If we guarantee that the load on CPU X does not differ from the load on 
> CPU (X+1)%N by more than some small constant, then we know that the 
> system is fairly balanced.  We can achieve global fairness with local 
> balancing, and avoid all this overhead.  This has the added advantage of 
> keeping most of the migrations core/socket/node-local on 
> SMT/multicore/NUMA systems.
> 
>     -- Chris

To clarify, I'm not suggesting that the "balance with cpu (x+1)%n only" 
algorithm is the only way to do this.  Rather, I'm pointing out that 
even an extremely simple algorithm can give you fair loading when you 
already have CFS managing the runqueues.  There are countless more 
sophisticated ways we could do this without using global locking, or 
possibly without any locking at all, other than the locking we already 
use during migration.

	-- Chris
