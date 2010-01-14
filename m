Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463Ab0ANFOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab0ANFOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 00:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057Ab0ANFN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 00:13:59 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39179 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab0ANFN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 00:13:58 -0500
Date: Wed, 13 Jan 2010 21:13:53 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100114051353.GA6843@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100110052508.GG9044@linux.vnet.ibm.com> <1263124209.28171.3798.camel@gandalf.stny.rr.com> <20100110174512.GH9044@linux.vnet.ibm.com> <20100110182423.GA22821@Krystal> <20100111011705.GJ9044@linux.vnet.ibm.com> <20100111042521.GB32213@Krystal> <20100111162537.GD6632@linux.vnet.ibm.com> <20100111202104.GA2816@Krystal> <20100111214803.GG6632@linux.vnet.ibm.com> <4B4E87C8.7080402@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4E87C8.7080402@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 10:56:08AM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > On Mon, Jan 11, 2010 at 03:21:04PM -0500, Mathieu Desnoyers wrote:
> >> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> >>> On Sun, Jan 10, 2010 at 11:25:21PM -0500, Mathieu Desnoyers wrote:
> >>>> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> >>>> [...]
> >>>>>> Even when taking the spinlocks, efficient iteration on active threads is
> >>>>>> done with for_each_cpu(cpu, mm_cpumask(current->mm)), which depends on
> >>>>>> the same cpumask, and thus requires the same memory barriers around the
> >>>>>> updates.
> >>>>> Ouch!!!  Good point and good catch!!!
> >>>>>
> >>>>>> We could switch to an inefficient iteration on all online CPUs instead,
> >>>>>> and check read runqueue ->mm with the spinlock held. Is that what you
> >>>>>> propose ? This will cause reading of large amounts of runqueue
> >>>>>> information, especially on large systems running few threads. The other
> >>>>>> way around is to iterate on all the process threads: in this case, small
> >>>>>> systems running many threads will have to read information about many
> >>>>>> inactive threads, which is not much better.
> >>>>> I am not all that worried about exactly what we do as long as it is
> >>>>> pretty obviously correct.  We can then improve performance when and as
> >>>>> the need arises.  We might need to use any of the strategies you
> >>>>> propose, or perhaps even choose among them depending on the number of
> >>>>> threads in the process, the number of CPUs, and so forth.  (I hope not,
> >>>>> but...)
> >>>>>
> >>>>> My guess is that an obviously correct approach would work well for a
> >>>>> slowpath.  If someone later runs into performance problems, we can fix
> >>>>> them with the added knowledge of what they are trying to do.
> >>>>>
> >>>> OK, here is what I propose. Let's choose between two implementations
> >>>> (v3a and v3b), which implement two "obviously correct" approaches. In
> >>>> summary:
> >>>>
> >>>> * baseline (based on 2.6.32.2)
> >>>>    text	   data	    bss	    dec	    hex	filename
> >>>>   76887	   8782	   2044	  87713	  156a1	kernel/sched.o
> >>>>
> >>>> * v3a: ipi to many using mm_cpumask
> >>>>
> >>>> - adds smp_mb__before_clear_bit()/smp_mb__after_clear_bit() before and
> >>>>   after mm_cpumask stores in context_switch(). They are only executed
> >>>>   when oldmm and mm are different. (it's my turn to hide behind an
> >>>>   appropriately-sized boulder for touching the scheduler). ;) Note that
> >>>>   it's not that bad, as these barriers turn into simple compiler barrier()
> >>>>   on:
> >>>>     avr32, blackfin, cris, frb, h8300, m32r, m68k, mn10300, score, sh,
> >>>>     sparc, x86 and xtensa.
> >>>>   The less lucky architectures gaining two smp_mb() are:
> >>>>     alpha, arm, ia64, mips, parisc, powerpc and s390.
> >>>>   ia64 is gaining only one smp_mb() thanks to its acquire semantic.
> >>>> - size
> >>>>    text	   data	    bss	    dec	    hex	filename
> >>>>   77239	   8782	   2044	  88065	  15801	kernel/sched.o
> >>>>   -> adds 352 bytes of text
> >>>> - Number of lines (system call source code, w/o comments) : 18
> >>>>
> >>>> * v3b: iteration on min(num_online_cpus(), nr threads in the process),
> >>>>   taking runqueue spinlocks, allocating a cpumask, ipi to many to the
> >>>>   cpumask. Does not allocate the cpumask if only a single IPI is needed.
> >>>>
> >>>> - only adds sys_membarrier() and related functions.
> >>>> - size
> >>>>    text	   data	    bss	    dec	    hex	filename
> >>>>   78047	   8782	   2044	  88873	  15b29	kernel/sched.o
> >>>>   -> adds 1160 bytes of text
> >>>> - Number of lines (system call source code, w/o comments) : 163
> >>>>
> >>>> I'll reply to this email with the two implementations. Comments are
> >>>> welcome.
> >>> Cool!!!  Just for completeness, I point out the following trivial
> >>> implementation:
> >>>
> >>> /*
> >>>  * sys_membarrier - issue memory barrier on current process running threads
> >>>  *
> >>>  * Execute a memory barrier on all running threads of the current process.
> >>>  * Upon completion, the caller thread is ensured that all process threads
> >>>  * have passed through a state where memory accesses match program order.
> >>>  * (non-running threads are de facto in such a state)
> >>>  *
> >>>  * Note that synchronize_sched() has the side-effect of doing a memory
> >>>  * barrier on each CPU.
> >>>  */
> >>> SYSCALL_DEFINE0(membarrier)
> >>> {
> >>> 	synchronize_sched();
> >>> }
> >>>
> >>> This does unnecessarily hit all CPUs in the system, but has the same
> >>> minimal impact that in-kernel RCU already has.  It has long latency,
> >>> (milliseconds) which might well disqualify it from consideration for
> >>> some applications.  On the other hand, it automatically batches multiple
> >>> concurrent calls to sys_membarrier().
> >> Benchmarking this implementation:
> >>
> >> 1000 calls to sys_membarrier() take:
> >>
> >> T=1: 0m16.007s
> >> T=2: 0m16.006s
> >> T=3: 0m16.010s
> >> T=4: 0m16.008s
> >> T=5: 0m16.005s
> >> T=6: 0m16.005s
> >> T=7: 0m16.005s
> >>
> >> For a 16 ms per call (my HZ is 250), as you expected. So this solution
> >> brings a slowdown of 10,000 times compared to the IPI-based solution.
> >> We'd be better off using signals instead.
> > 
> >>From a latency viewpoint, yes.  But synchronize_sched() consumes far
> > less CPU time than do signals, avoids waking up sleeping CPUs, batches
> > concurrent requests, and seems to be of some use in the kernel.  ;-)
> > 
> > But, as I said, just for completeness.
> > 
> > 							Thanx, Paul
> 
> 
> Actually, I like this implementation.
> (synchronize_sched() need be changed to synchronize_kernel_and_user_sched()
> or something else)

The global memory barriers is indeed very much a side-effect of
synchronize_sched(), not its main purpose, you are right that its name
is a bit strange for this purpose.  ;-)

> IPI-implementation and signal-implementation cost too much.
> and this implementation just wait until things are done, very low cost.
> 
> The time of kernel rcu G.P. is typically 3/HZ seconds
> (for all implementations except preemptable rcu). It is a large
> latency. but it's nothing important I think:
> 1) user should also call synchronize_sched() rarely.
> 2) If user care this latency, user can just implement a userland call_rcu

In the common case, you are correct.  On the other hand, we did need to
do synchronize_rcu_expedited() and friends in the kernel, so it is
reasonable to expect that user-level RCU uses will also need expedited
interfaces.

> userland_call_rcu() {
> 	insert rcu_head to rcu_callback_list.
> }
> 
> rcu_callback_thread()
> {
> 	for (;;) {
> 		handl_list = rcu_callback_list;
> 		rcu_callback_list = NULL;
> 
> 		userland_synchronize_sched();
> 
> 		handle the callback in handl_list
> 	}
> }
> 3) kernel rcu VS userland IPI-implementation RCU:
> userland_synchronize_sched() is less latency than kernel rcu?
> userland has more priority to send a lot of IPIs?
> It sounds crazy for me.

You say "crazy" as if it was a bad thing.  ;-)

(Sorry, couldn't resist...)

But it is important to keep in mind that sys_membarrier() is just one
part of the user-level RCU implementation.  When you add in the necessary
waiting on per-thread counters, the user-level RCU is probably not that
much cheaper than the expedited in-kernel RCU primitives.

> See also this email(2010-1-11) I sent to you offlist:
> > /* Lai jiangshan define it for fun */
> > #define synchronize_kernel_sched() synchronize_sched()
> > 
> > /* We can use the current RCU code to implement one of the following */
> > extern void synchronize_kernel_and_user_sched(void);
> > extern void synchronize_user_sched(void);
> > 
> > /*
> >  * wait until all cpu(which in userspace) enter kernel and call mb()
> >  * (recommend)
> >  */
> > extern void synchronize_user_mb(void);
> > 
> > void sys_membarrier(void)
> > {
> > 	/*
> > 	 * 1) We add very little overhead to kernel, we just wait at kernel space.
> > 	 * 2) Several processes which call sys_membarrier() wait the same *batch*.
> > 	 */
> > 
> > 	synchronize_kernel_and_user_sched();
> > 	/* OR synchronize_user_sched()/synchronize_user_mb() */
> > }

If I am not getting too confused, Mathieu's latest patch does do
synchronize_sched() for the non-expedited case.  Mathieu pointed it
out in his email of January 9th, though not as a serious suggestion,
from what I can tell.  Your (private) email was indeed next, so as far
as I am concerned you do indeed share the credit/blame for suggesting
use of synchronize_sched() as a long-latency/low-overhead implementation
of sys_membarrier().

Mathieu, given that Lai has now posted publicly, could you please include
at least note crediting him for the first serious suggestion of using
synchronize_sched()?

							Thanx, Paul
