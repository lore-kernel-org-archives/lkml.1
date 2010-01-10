Return-Path: <linux-kernel-owner+w=401wt.eu-S1751219Ab0AJFSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab0AJFSJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 00:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899Ab0AJFSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 00:18:08 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33112 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab0AJFSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 00:18:05 -0500
Date: Sat, 9 Jan 2010 21:18:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100110051803.GE9044@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100109010231.GA25368@Krystal> <20100109012128.GF6816@linux.vnet.ibm.com> <20100109023842.GA1696@Krystal> <20100109054215.GB9044@linux.vnet.ibm.com> <20100109192006.GA23672@Krystal> <1263078327.28171.3792.camel@gandalf.stny.rr.com> <1263079000.28171.3795.camel@gandalf.stny.rr.com> <20100110000318.GD9044@linux.vnet.ibm.com> <1263084099.2231.5.camel@frodo> <20100110014456.GG25790@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100110014456.GG25790@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 08:44:56PM -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Sat, 2010-01-09 at 16:03 -0800, Paul E. McKenney wrote:
> > > On Sat, Jan 09, 2010 at 06:16:40PM -0500, Steven Rostedt wrote:
> > > > On Sat, 2010-01-09 at 18:05 -0500, Steven Rostedt wrote:
> > > > 
> > > > > Then we should have O(tasks) for spinlocks taken, and 
> > > > > O(min(tasks, CPUS)) for IPIs.
> > > > 
> > > > And for nr tasks >> CPUS, this may help too:
> > > > 
> > > > > cpumask = 0;
> > > > > foreach task {
> > > > 
> > > > 	if (cpumask == online_cpus)
> > > > 		break;
> > > > 
> > > > > 	spin_lock(task_rq(task)->rq->lock);
> > > > > 	if (task_rq(task)->curr == task)
> > > > > 		cpu_set(task_cpu(task), cpumask);
> > > > > 	spin_unlock(task_rq(task)->rq->lock);
> > > > > }
> > > > > send_ipi(cpumask);
> > > 
> > > Good point, erring on the side of sending too many IPIs is safe.  One
> > > might even be able to just send the full set if enough of the CPUs were
> > > running the current process and none of the remainder were running
> > > real-time threads.  And yes, it would then be necessary to throttle
> > > calls to sys_membarrier().
> > > 
> > 
> > If you need to throttle calls to sys_membarrier(), than why bother
> > optimizing it? Again, this is like calling synchronize_sched() in the
> > kernel, which is a very heavy operation, and should only be called by
> > those that are not performance critical.
> > 
> > Why are we struggling so much with optimizing the slow path?
> > 
> > Here's how I take it. This method is much better that sending signals to
> > all threads. The advantage the sys_membarrier gives us, is also a way to
> > keep user rcu_read_locks barrier free, which means that rcu_read_locks
> > are quick and scale well.
> > 
> > So what if we have a linear decrease in performance with the number of
> > threads on the write side?
> 
> Hrm, looking at arch/x86/include/asm/mmu_context.h
> 
> switch_mm(), which is basically called each time the scheduler needs to
> change the current task, does a
> 
> cpumask_clear_cpu(cpu, mm_cpumask(prev));
> 
> and
> 
> cpumask_set_cpu(cpu, mm_cpumask(next));
> 
> which precise goal is to stop the flush ipis for the previous mm. The
> 100$ question is : why do we have to confirm that the thread is indeed
> on the runqueue (taking locks and everything) when we could simply just
> bluntly use the mm_cpumask for our own IPIs ?
> 
> cpumask_clear_cpu and cpumask_set_cpu translate into clear_bit/set_bit.
> cpumask_next does a find_next_bit on the cpumask.
> 
> clear_bit/set_bit are atomic and not reordered on x86. PowerPC also uses
> ll/sc loops in bitops.h, so I think it should be pretty safe to assume
> that mm_cpumask is, by design, made to be used as cpumask to send a
> broadcast IPI to all CPUs which run threads belonging to a given
> process.

According to Documentation/atomic_ops.txt, clear_bit/set_bit are atomic,
but do not require memory-barrier semantics.

> So, how about just using mm_cpumask(current) for the broadcast ? Then we
> don't even need to allocate our own cpumask neither.
> 
> Or am I missing something ? I just sounds too simple.

In this case, a pair of memory barriers around the clear_bit/set_bit in
mm and a memory barrier before sampling the mask.  Yes, x86 gives you
memory barriers on atomics whether you need them or not, but they are
not guaranteed.

							Thanx, Paul
