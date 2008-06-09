Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbYFIU7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbYFIU7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYFIU72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:59:28 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55078 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbYFIU71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:59:27 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5313"; a="3617610"
Message-ID: <484D99AD.4000306@qualcomm.com>
Date: Mon, 09 Jun 2008 13:59:25 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Paul Jackson <pj@sgi.com>, mingo@elte.hu, peterz@infradead.org,
       menage@google.com, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch] sched: prevent bound kthreads from changing cpus_allowed
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com> <20080605152953.dcfefa47.pj@sgi.com> <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
>>  2) Sometimes calls to kthread_bind are binding to any online cpu, such as in:
>>
>> 	drivers/infiniband/hw/ehca/ehca_irq.c:	kthread_bind(cct->task, any_online_cpu(cpu_online_map));
>>
>>     In such cases, the PF_THREAD_BOUND seems inappropriate.  The caller of
>>     kthread_bind() really doesn't seem to care where that thread is bound;
>>     they just want it on a CPU that is still online.
>>
> 
> This particular case is simply moving the thread to any online cpu so that 
> it survives long enough for the subsequent kthread_stop() in 
> destroy_comp_task().  So I don't see a problem with this instance.
> 
> A caller to kthread_bind() can always remove PF_THREAD_BOUND itself upon 
> return, but I haven't found any cases in the tree where that is currently 
> necessary.  And doing that would defeat the semantics of kthread_bind() 
> where these threads are supposed to be bound to a specific cpu and not 
> allowed to run on others.

Actually I have another use case here. Above example in particular may be ok 
but it does demonstrate the issue nicely. Which is that in some cases kthreads 
are bound to a CPU but do not have a strict "must run here" requirement and 
could be moved if needed.
For example I need an ability to move workqueue threads. Workqueue threads do 
kthread_bind().
So how about we add something like kthread_bind_strict() which  would set 
PF_THREAD_BOUND ?
We could also simply add flags argument to the kthread_bind() which would be 
better imo but requires more changes. ie It'd look like
	kthread_bind(..., cpu, KTHREAD_BIND_STRICT);

Things like migration threads, stop machine, etc would use the strict version 
and everything else would use non-strict bind.

---
On the related note (this seems like the right crowd :). What do people think 
about kthreads and cpusets in general. We currently have a bit of a disconnect 
in the logic.
1. kthreads can be put into a cpuset at which point their cpus_allowed mask is 
updated properly
2. kthread's cpus_allowed mask is updated properly when cpuset setup changes 
(cpus added, removed, etc).
3. kthreads inherit cpuset from a parent (kthreadd for example) _but_  they 
either do kthread_bind() or set_cpus_allowed() and both of those simply ignore 
inherited cpusets.

Notice how scenario #3 does not fit into the overall picture. The behaviour is 
inconsistent.
How about this:
- Split sched_setaffinity into

	sched_setaffinity()
	{
		task *p = get_task_by_pid();
		return task_setaffinity(p);
	}

	task_setaffinity(task, cpumask, flags)
	{
		if (flags & FORCE) {
			// Used for kthreads that require strict binding.
			// Detach the task from the current cpuset
			// and put it into the root cpuset.
   			// Set PF_THREAD_BOUND.
		}

		// Rest of the original sched_setaffinity logic
	}

- Have kthreads call task_setaffinity() instead of set_cpus_allowed() directly.
That way the behaviour will be consistent across the board.

Comments ?

Max

