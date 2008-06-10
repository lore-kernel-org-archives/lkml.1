Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbYFJEXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbYFJEXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 00:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbYFJEWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 00:22:55 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46441 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYFJEWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 00:22:54 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5313"; a="3627749"
Message-ID: <484E01B8.7000907@qualcomm.com>
Date: Mon, 09 Jun 2008 21:23:20 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Paul Jackson <pj@sgi.com>, mingo@elte.hu, peterz@infradead.org,
       menage@google.com, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch] sched: prevent bound kthreads from changing cpus_allowed
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com> <20080605152953.dcfefa47.pj@sgi.com> <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com> <484D99AD.4000306@qualcomm.com> <alpine.DEB.1.10.0806091447300.10680@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.10.0806091447300.10680@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
>> For example I need an ability to move workqueue threads.
> 
> Let's elaborate a little on that: you're moving workqueue threads from 
> their originating cpu to another cpu (hopefully on the same NUMA node) 
> using cpusets or sched_setaffinity()?
Yes.

> But, to me, the semantics of kthread_bind() are pretty clear.  I think 
> it's dangerous to move kthreads such as watchdog or migration threads out 
> from under them and that is easily shown if you try to do it.  There are 
> perhaps exceptions to the rule where existing kthread_bind() calls could 
> be converted to set_cpus_allowed_ptr(), but I think we should enumerate 
> those cases and discuss the hazards that could be associated with changing 
> their cpu affinity.
I think what can and cannot be moved is a separate question. As far as cpu
affinity API for kthreads goes it makes sense to support both scenarios.
See below.

> I'd also like to hear why you choose to move your workqueue threads off 
> their originating cpu.
CPU isolation. ie To avoid kernel activity on certain CPUs.

>> On the related note (this seems like the right crowd :). What do people think
>> about kthreads and cpusets in general. We currently have a bit of a disconnect
>> in the logic.
>> 1. kthreads can be put into a cpuset at which point their cpus_allowed mask is
>> updated properly
>> 2. kthread's cpus_allowed mask is updated properly when cpuset setup changes
>> (cpus added, removed, etc).
>> 3. kthreads inherit cpuset from a parent (kthreadd for example) _but_  they
>> either do kthread_bind() or set_cpus_allowed() and both of those simply ignore
>> inherited cpusets.
>>
> With my patch, this is slightly different.  Kthreads that have called 
> kthread_bind() can have a different cpu affinity than the cpus_allowed of 
> their cpuset.  This happens when such a kthread is attached to a cpuset 
> and its 'cpus' file subsequently changes.  Cpusets is written correctly to 
> use set_cpus_allowed_ptr() so that this change in affinity is now rejected 
> for PF_THREAD_BOUND tasks, yet the kthread is still a member of the 
> cpuset.
That would be inconsistent and confusing, I think. If a task is in the cpuset
X all constraints of the cpuset X must apply. If some constraints cannot be
satisfied then that task should not be in the cpuset X.

> It's debatable whether the kthread should still remain as a member of the 
> cpuset, but there are significant advantages: cpusets offers more than 
> just a simple way to do sched_setaffinity() over an aggregate of tasks.  
Yes cpusets are not only about cpu affinity. But again the behaviour should be
consistent across the board. cpuset.cpus must apply to all the task in the
set, not just some of the tasks.

Also I think you missed my other point/suggestion. Yes your patch fixes one
problem, which is kthreads that must not move will not move. Although like I
said the behaviour with regards to the cpuset is not consistent and confusing.
The other thing that I pointed out is that kthreads that _can_ move do not
honor cpuset constrains.
Let me give another example. Forget the workqueues for a second. Kthreads like
scsi_eh, kswapd, kacpid, etc, etc are all started with cpus_allows=ALL_CPUS
even though they inherit a cpuset from kthreadd. Yes I can move them manually
but the behaviour is not consistent, and for no good reason. kthreads can be
stopped/started at any time (module load for example) which means that I'd
have to keep moving them.

To sum it up here is what I'm suggesting:
kthread_bind(task, cpu)
{
   // Set PF_THREAD_BOUND
   // Move into root cpuset
   // Bind to the cpu
}

kthread_setaffinity(task, cpumask)
{
   // Enforce cpuset.cpus_allowed
   // Updated affinity mask and migrate kthread (if needed)
}

Instead of calling set_cpus_allowed_ptr() kthreads that do not need strict cpu
binding will be calling kthread_setaffinity().
That way the behaviour is consistent across the board.

Makes sense ?

Max
