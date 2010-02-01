Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab0BAWmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:42:11 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:63946 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753767Ab0BAWmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:42:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAFvmZktGHnlj/2dsb2JhbACBM9hchEUE
Date: Mon, 1 Feb 2010 17:42:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task
	switch at runqueue lock/unlock
Message-ID: <20100201224206.GB3571@Krystal>
References: <20100131210013.446503342@polymtl.ca> <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain> <20100201160929.GA3032@Krystal> <alpine.LFD.2.00.1002010816030.4206@localhost.localdomain> <20100201164856.GA3486@Krystal> <alpine.LFD.2.00.1002010854110.4206@localhost.localdomain> <20100201174500.GA13744@Krystal> <alpine.LFD.2.00.1002011028190.4206@localhost.localdomain> <20100201195629.GA27665@Krystal> <alpine.LFD.2.00.1002011227360.4206@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002011227360.4206@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:30:46 up 47 days,  5:49,  4 users,  load average: 0.93, 2.92,
	2.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Mon, 1 Feb 2010, Mathieu Desnoyers wrote:
> > 
> > The two event pairs we are looking at are:
> > 
> > Pair 1)
> > 
> > * memory accesses (load/stores) performed by user-space thread before
> >   context switch.
> > * cpumask_clear_cpu(cpu, mm_cpumask(prev));
> > 
> > Pair 2)
> >
> > * cpumask_set_cpu(cpu, mm_cpumask(next));
> > * memory accessses (load/stores) performed by user-space thread after
> >   context switch.
> 
> So explain why does that smp_mb() in between the two _help_?
> 
> The user of this will do a
> 
> 	for_each_cpu(mm_cpumask)
> 		send_IPI(cpu, smp_mb);
> 
> but that's not an atomic op _anyway_. So you're reading mm_cpumask 
> somewhere earlier, and doing the send_IPI later. So look at the whole 
> scenario 2:
> 
> 	cpumask_set_cpu(cpu, mm_cpumask(next));
> 	memory accessses performed by user-space
> 
> and think about it from the perspective of another CPU. What does an 
> smp_mb() in between the two do?
> 
> I'll tell you - it does NOTHING. Because it doesn't matter. I see no 
> possible way another CPU can care, because let's assume that the other CPU 
> is doing that
> 
> 	for_each_cpu(mm_cpumask)
> 		send_ipi(smp_mb);
> 
> and you have to realize that the other CPU needs to read that mm_cpumask 
> early in order to do that.
> 
> So you have this situation:
> 
> 	CPU1			CPU2
> 	----			----
> 
> 	cpumask_set_cpu
> 				read mm_cpumask
> 	smp_mb
> 				smp_mb
> 	user memory accessses
> 				send_ipi
> 
> and exactly _what_ is that "smp_mb" on CPU1 protecting against?
> 
> Realize that CPU2 is not ordered (because you wanted to avoid the 
> locking), so the "read mm_cpumask" can happen before or after that 
> cpumask_set_cpu. And it can happen before or after REGARDLESS of that 
> smp_mb. The smp_mb doesn't make any difference to CPU2 that I can see. 
> 
> So the question becomes one of "How can CPU2 care about whether CPU1 is in 
> the mask"? Considering that CPU2 doesn't do any locking, I don't see any 
> way you can get a "consistent" CPU mask _regardless_ of any smp_mb's in 
> there. When it does the "read mm_cpumask()" it might get the value 
> _before_ the cpumask_set_cpu, and it might get the value _after_, and 
> that's true regardless of whether there is a smp_mb there or not. 
> 
> See what I'm asking for? I'm asking for why it matters that we have a 
> memory barrier, and why that mm_cpumask is so magical that _that_ access 
> matters so much. 
> 
> Maybe I'm dense. But If somebody puts memory barriers in the code, I want 
> to know exactly what the reason for the barrier is. Memory ordering is too 
> subtle and non-intuitive to go by gut feel.
> 

I am 100% fine with your request for explanation. I'll do my best to
explain the requirements and ordering as clearly as I can.

Let's define the semantic of this system call clearly, this will help us
below: it orders memory accesses performed by a thread before and after
calling sys_membarrier with respect to _all_ memory accesses (in program
order) performed by all other threads of the same process.

The barriers are not there to "protect" against anything, they merely
enforce ordering of memory accesses. sys_membarrier ensures that a
memory barrier will be issued on all running threads of the current
process executing on other cpus, between two memory barriers issued
locally. A very important point is that the memory barriers _need_ to be
issued on the other running threads after the sys_membarrier first mb
and before its second mb. The second important aspect is the definition
of a running vs non-running thread. Here, any CPU that would still have
unflushed write buffers (or pending reordered read operations) affecting
a thread which belongs to our process should be considered as "running",
because it needs to have memory barriers issued.

Now why is mm_cpumask so important here ? This is the only non-lock
protected data structure we access to find out which CPUs are running
threads belonging to our process.

I'm modifying your scenario to match the requirements expressed above.
In this first scenario, we send an IPI guaranteeing that the newly
scheduled thread (which happens to have set its cpu in the mm_cpumask
before we read it) issues a memory barrier. We end up issuing one extra
memory barrier, as both the scheduler and IPI issue the barriers:

        CPU1                    CPU2
        ----                    ----
                                smp_mb
        cpumask_set_cpu
                                read mm_cpumask
                                send_ipi
                                |
        smp_mb                  |
        user memory accesses    |
                                |
        smp_mb <----------------/
                                smp_mb

Now, let's see what happens if the read mm_cpumask occurs right before
the cpumask_set_cpu. In this scenario, CPU1 is considered as "not
running", because it cannot have any user-space memory accesses
reordered prior to the first smp_mb on CPU2.

        CPU1                    CPU2
        ----                    ----
                                smp_mb
                                read mm_cpumask
                                (no ipi to send)
        cpumask_set_cpu
                                smp_mb
        smp_mb
        user memory accesses

As we see, the smp_mb issued on CPU1 between the cpumask set and user
memory accesses takes care to ensure that no user memory accesses spill
over the barrier. So if sys_membarrier encounters a mm_cpumask with a
cleared cpu bit, it knows for sure that there are no unflushed write
buffers containing user-space data, nor reordered read or write accesses
to user-space data. Removing this barrier could let CPU1 reorder the
user memory accesses before the cpumask_set_cpu, which fails to satisfy
the sys_membarrier guarantees.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
