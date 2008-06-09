Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbYFIWIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbYFIWIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbYFIWIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:08:36 -0400
Received: from smtp-out.google.com ([216.239.33.17]:32077 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbYFIWIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:08:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=LITtQWH8SNJsnvbDKUu6a6S73M1RsFQiKV52pnIjo7NPLhisa3F4PR5jW+jJuhmcq
	lksWgGoqeYj5hTIdVFP3A==
Date: Mon, 9 Jun 2008 15:07:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Max Krasnyanskiy <maxk@qualcomm.com>
cc: Paul Jackson <pj@sgi.com>, mingo@elte.hu, peterz@infradead.org,
       menage@google.com, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch] sched: prevent bound kthreads from changing
 cpus_allowed
In-Reply-To: <484D99AD.4000306@qualcomm.com>
Message-ID: <alpine.DEB.1.10.0806091447300.10680@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com> <20080605152953.dcfefa47.pj@sgi.com> <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com> <484D99AD.4000306@qualcomm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008, Max Krasnyanskiy wrote:

> Actually I have another use case here. Above example in particular may be ok
> but it does demonstrate the issue nicely. Which is that in some cases kthreads
> are bound to a CPU but do not have a strict "must run here" requirement and
> could be moved if needed.

That isn't a completely accurate description of the patch; the kthread 
itself is always allowed to change its cpu affinity.  This exception, for 
example, allows stopmachine to still work correctly since it uses 
set_cpus_allowed_ptr() for each thread.

This patch simply prohibits other tasks from changing the cpu affinity of 
a kthread that has called kthread_bind().

> For example I need an ability to move workqueue threads.

Let's elaborate a little on that: you're moving workqueue threads from 
their originating cpu to another cpu (hopefully on the same NUMA node) 
using cpusets or sched_setaffinity()?

> Workqueue threads do
> kthread_bind().
> So how about we add something like kthread_bind_strict() which  would set
> PF_THREAD_BOUND ?
> We could also simply add flags argument to the kthread_bind() which would be
> better imo but requires more changes. ie It'd look like
> 	kthread_bind(..., cpu, KTHREAD_BIND_STRICT);
> 
> Things like migration threads, stop machine, etc would use the strict version
> and everything else would use non-strict bind.
> 

It depends on the number of exceptions that we want to allow.  If there's 
one or two, it's sufficient to just use

	p->flags &= ~PF_THREAD_BOUND;

upon return from kthread_bind(), or simply convert the existing code to 
use set_cpus_allowed_ptr() instead:

	kthread_bind(p, cpu);

becomes

	cpumask_t mask = cpumask_of_cpu(cpu);
	set_cpus_allowed_ptr(p, &mask);

Or, if we have more exceptions to the rule than actual strict binding for 
kthreads using kthread_bind(), we can just add

	p->flags |= PF_THREAD_BOUND;

upon return on watchdog and migration threads.

But, to me, the semantics of kthread_bind() are pretty clear.  I think 
it's dangerous to move kthreads such as watchdog or migration threads out 
from under them and that is easily shown if you try to do it.  There are 
perhaps exceptions to the rule where existing kthread_bind() calls could 
be converted to set_cpus_allowed_ptr(), but I think we should enumerate 
those cases and discuss the hazards that could be associated with changing 
their cpu affinity.

I'd also like to hear why you choose to move your workqueue threads off 
their originating cpu.

> On the related note (this seems like the right crowd :). What do people think
> about kthreads and cpusets in general. We currently have a bit of a disconnect
> in the logic.
> 1. kthreads can be put into a cpuset at which point their cpus_allowed mask is
> updated properly
> 2. kthread's cpus_allowed mask is updated properly when cpuset setup changes
> (cpus added, removed, etc).
> 3. kthreads inherit cpuset from a parent (kthreadd for example) _but_  they
> either do kthread_bind() or set_cpus_allowed() and both of those simply ignore
> inherited cpusets.
> 

With my patch, this is slightly different.  Kthreads that have called 
kthread_bind() can have a different cpu affinity than the cpus_allowed of 
their cpuset.  This happens when such a kthread is attached to a cpuset 
and its 'cpus' file subsequently changes.  Cpusets is written correctly to 
use set_cpus_allowed_ptr() so that this change in affinity is now rejected 
for PF_THREAD_BOUND tasks, yet the kthread is still a member of the 
cpuset.

It's debatable whether the kthread should still remain as a member of the 
cpuset, but there are significant advantages: cpusets offers more than 
just a simple way to do sched_setaffinity() over an aggregate of tasks.  

		David
