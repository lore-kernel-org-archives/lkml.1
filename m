Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647Ab0ANC6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab0ANC6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248Ab0ANC57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:57:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54965 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab0ANC56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:57:58 -0500
Message-ID: <4B4E87C8.7080402@cn.fujitsu.com>
Date: Thu, 14 Jan 2010 10:56:08 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory	barrier
References: <20100110014456.GG25790@Krystal> <1263089578.2231.22.camel@frodo> <20100110052508.GG9044@linux.vnet.ibm.com> <1263124209.28171.3798.camel@gandalf.stny.rr.com> <20100110174512.GH9044@linux.vnet.ibm.com> <20100110182423.GA22821@Krystal> <20100111011705.GJ9044@linux.vnet.ibm.com> <20100111042521.GB32213@Krystal> <20100111162537.GD6632@linux.vnet.ibm.com> <20100111202104.GA2816@Krystal> <20100111214803.GG6632@linux.vnet.ibm.com>
In-Reply-To: <20100111214803.GG6632@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Mon, Jan 11, 2010 at 03:21:04PM -0500, Mathieu Desnoyers wrote:
>> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
>>> On Sun, Jan 10, 2010 at 11:25:21PM -0500, Mathieu Desnoyers wrote:
>>>> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
>>>> [...]
>>>>>> Even when taking the spinlocks, efficient iteration on active threads is
>>>>>> done with for_each_cpu(cpu, mm_cpumask(current->mm)), which depends on
>>>>>> the same cpumask, and thus requires the same memory barriers around the
>>>>>> updates.
>>>>> Ouch!!!  Good point and good catch!!!
>>>>>
>>>>>> We could switch to an inefficient iteration on all online CPUs instead,
>>>>>> and check read runqueue ->mm with the spinlock held. Is that what you
>>>>>> propose ? This will cause reading of large amounts of runqueue
>>>>>> information, especially on large systems running few threads. The other
>>>>>> way around is to iterate on all the process threads: in this case, small
>>>>>> systems running many threads will have to read information about many
>>>>>> inactive threads, which is not much better.
>>>>> I am not all that worried about exactly what we do as long as it is
>>>>> pretty obviously correct.  We can then improve performance when and as
>>>>> the need arises.  We might need to use any of the strategies you
>>>>> propose, or perhaps even choose among them depending on the number of
>>>>> threads in the process, the number of CPUs, and so forth.  (I hope not,
>>>>> but...)
>>>>>
>>>>> My guess is that an obviously correct approach would work well for a
>>>>> slowpath.  If someone later runs into performance problems, we can fix
>>>>> them with the added knowledge of what they are trying to do.
>>>>>
>>>> OK, here is what I propose. Let's choose between two implementations
>>>> (v3a and v3b), which implement two "obviously correct" approaches. In
>>>> summary:
>>>>
>>>> * baseline (based on 2.6.32.2)
>>>>    text	   data	    bss	    dec	    hex	filename
>>>>   76887	   8782	   2044	  87713	  156a1	kernel/sched.o
>>>>
>>>> * v3a: ipi to many using mm_cpumask
>>>>
>>>> - adds smp_mb__before_clear_bit()/smp_mb__after_clear_bit() before and
>>>>   after mm_cpumask stores in context_switch(). They are only executed
>>>>   when oldmm and mm are different. (it's my turn to hide behind an
>>>>   appropriately-sized boulder for touching the scheduler). ;) Note that
>>>>   it's not that bad, as these barriers turn into simple compiler barrier()
>>>>   on:
>>>>     avr32, blackfin, cris, frb, h8300, m32r, m68k, mn10300, score, sh,
>>>>     sparc, x86 and xtensa.
>>>>   The less lucky architectures gaining two smp_mb() are:
>>>>     alpha, arm, ia64, mips, parisc, powerpc and s390.
>>>>   ia64 is gaining only one smp_mb() thanks to its acquire semantic.
>>>> - size
>>>>    text	   data	    bss	    dec	    hex	filename
>>>>   77239	   8782	   2044	  88065	  15801	kernel/sched.o
>>>>   -> adds 352 bytes of text
>>>> - Number of lines (system call source code, w/o comments) : 18
>>>>
>>>> * v3b: iteration on min(num_online_cpus(), nr threads in the process),
>>>>   taking runqueue spinlocks, allocating a cpumask, ipi to many to the
>>>>   cpumask. Does not allocate the cpumask if only a single IPI is needed.
>>>>
>>>> - only adds sys_membarrier() and related functions.
>>>> - size
>>>>    text	   data	    bss	    dec	    hex	filename
>>>>   78047	   8782	   2044	  88873	  15b29	kernel/sched.o
>>>>   -> adds 1160 bytes of text
>>>> - Number of lines (system call source code, w/o comments) : 163
>>>>
>>>> I'll reply to this email with the two implementations. Comments are
>>>> welcome.
>>> Cool!!!  Just for completeness, I point out the following trivial
>>> implementation:
>>>
>>> /*
>>>  * sys_membarrier - issue memory barrier on current process running threads
>>>  *
>>>  * Execute a memory barrier on all running threads of the current process.
>>>  * Upon completion, the caller thread is ensured that all process threads
>>>  * have passed through a state where memory accesses match program order.
>>>  * (non-running threads are de facto in such a state)
>>>  *
>>>  * Note that synchronize_sched() has the side-effect of doing a memory
>>>  * barrier on each CPU.
>>>  */
>>> SYSCALL_DEFINE0(membarrier)
>>> {
>>> 	synchronize_sched();
>>> }
>>>
>>> This does unnecessarily hit all CPUs in the system, but has the same
>>> minimal impact that in-kernel RCU already has.  It has long latency,
>>> (milliseconds) which might well disqualify it from consideration for
>>> some applications.  On the other hand, it automatically batches multiple
>>> concurrent calls to sys_membarrier().
>> Benchmarking this implementation:
>>
>> 1000 calls to sys_membarrier() take:
>>
>> T=1: 0m16.007s
>> T=2: 0m16.006s
>> T=3: 0m16.010s
>> T=4: 0m16.008s
>> T=5: 0m16.005s
>> T=6: 0m16.005s
>> T=7: 0m16.005s
>>
>> For a 16 ms per call (my HZ is 250), as you expected. So this solution
>> brings a slowdown of 10,000 times compared to the IPI-based solution.
>> We'd be better off using signals instead.
> 
>>From a latency viewpoint, yes.  But synchronize_sched() consumes far
> less CPU time than do signals, avoids waking up sleeping CPUs, batches
> concurrent requests, and seems to be of some use in the kernel.  ;-)
> 
> But, as I said, just for completeness.
> 
> 							Thanx, Paul
> 


Actually, I like this implementation.
(synchronize_sched() need be changed to synchronize_kernel_and_user_sched()
or something else)

IPI-implementation and signal-implementation cost too much.
and this implementation just wait until things are done, very low cost.

The time of kernel rcu G.P. is typically 3/HZ seconds
(for all implementations except preemptable rcu). It is a large
latency. but it's nothing important I think:
1) user should also call synchronize_sched() rarely.
2) If user care this latency, user can just implement a userland call_rcu
userland_call_rcu() {
	insert rcu_head to rcu_callback_list.
}

rcu_callback_thread()
{
	for (;;) {
		handl_list = rcu_callback_list;
		rcu_callback_list = NULL;

		userland_synchronize_sched();

		handle the callback in handl_list
	}
}
3) kernel rcu VS userland IPI-implementation RCU:
userland_synchronize_sched() is less latency than kernel rcu?
userland has more priority to send a lot of IPIs?
It sounds crazy for me.

See also this email(2010-1-11) I sent to you offlist:
> /* Lai jiangshan define it for fun */
> #define synchronize_kernel_sched() synchronize_sched()
> 
> /* We can use the current RCU code to implement one of the following */
> extern void synchronize_kernel_and_user_sched(void);
> extern void synchronize_user_sched(void);
> 
> /*
>  * wait until all cpu(which in userspace) enter kernel and call mb()
>  * (recommend)
>  */
> extern void synchronize_user_mb(void);
> 
> void sys_membarrier(void)
> {
> 	/*
> 	 * 1) We add very little overhead to kernel, we just wait at kernel space.
> 	 * 2) Several processes which call sys_membarrier() wait the same *batch*.
> 	 */
> 
> 	synchronize_kernel_and_user_sched();
> 	/* OR synchronize_user_sched()/synchronize_user_mb() */
> }
> 

