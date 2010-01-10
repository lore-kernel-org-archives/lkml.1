Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361Ab0AJBpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0AJBpD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 20:45:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887Ab0AJBpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 20:45:01 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:48454 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752644Ab0AJBpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 20:45:00 -0500
Date: Sat, 9 Jan 2010 20:44:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100110014456.GG25790@Krystal>
References: <20100109002043.GD6816@linux.vnet.ibm.com> <20100109010231.GA25368@Krystal> <20100109012128.GF6816@linux.vnet.ibm.com> <20100109023842.GA1696@Krystal> <20100109054215.GB9044@linux.vnet.ibm.com> <20100109192006.GA23672@Krystal> <1263078327.28171.3792.camel@gandalf.stny.rr.com> <1263079000.28171.3795.camel@gandalf.stny.rr.com> <20100110000318.GD9044@linux.vnet.ibm.com> <1263084099.2231.5.camel@frodo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1263084099.2231.5.camel@frodo>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 20:32:30 up 24 days,  9:50,  5 users,  load average: 0.93, 0.39,
	0.25
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Sat, 2010-01-09 at 16:03 -0800, Paul E. McKenney wrote:
> > On Sat, Jan 09, 2010 at 06:16:40PM -0500, Steven Rostedt wrote:
> > > On Sat, 2010-01-09 at 18:05 -0500, Steven Rostedt wrote:
> > > 
> > > > Then we should have O(tasks) for spinlocks taken, and 
> > > > O(min(tasks, CPUS)) for IPIs.
> > > 
> > > And for nr tasks >> CPUS, this may help too:
> > > 
> > > > cpumask = 0;
> > > > foreach task {
> > > 
> > > 	if (cpumask == online_cpus)
> > > 		break;
> > > 
> > > > 	spin_lock(task_rq(task)->rq->lock);
> > > > 	if (task_rq(task)->curr == task)
> > > > 		cpu_set(task_cpu(task), cpumask);
> > > > 	spin_unlock(task_rq(task)->rq->lock);
> > > > }
> > > > send_ipi(cpumask);
> > 
> > Good point, erring on the side of sending too many IPIs is safe.  One
> > might even be able to just send the full set if enough of the CPUs were
> > running the current process and none of the remainder were running
> > real-time threads.  And yes, it would then be necessary to throttle
> > calls to sys_membarrier().
> > 
> 
> If you need to throttle calls to sys_membarrier(), than why bother
> optimizing it? Again, this is like calling synchronize_sched() in the
> kernel, which is a very heavy operation, and should only be called by
> those that are not performance critical.
> 
> Why are we struggling so much with optimizing the slow path?
> 
> Here's how I take it. This method is much better that sending signals to
> all threads. The advantage the sys_membarrier gives us, is also a way to
> keep user rcu_read_locks barrier free, which means that rcu_read_locks
> are quick and scale well.
> 
> So what if we have a linear decrease in performance with the number of
> threads on the write side?

Hrm, looking at arch/x86/include/asm/mmu_context.h

switch_mm(), which is basically called each time the scheduler needs to
change the current task, does a

cpumask_clear_cpu(cpu, mm_cpumask(prev));

and

cpumask_set_cpu(cpu, mm_cpumask(next));

which precise goal is to stop the flush ipis for the previous mm. The
100$ question is : why do we have to confirm that the thread is indeed
on the runqueue (taking locks and everything) when we could simply just
bluntly use the mm_cpumask for our own IPIs ?

cpumask_clear_cpu and cpumask_set_cpu translate into clear_bit/set_bit.
cpumask_next does a find_next_bit on the cpumask.

clear_bit/set_bit are atomic and not reordered on x86. PowerPC also uses
ll/sc loops in bitops.h, so I think it should be pretty safe to assume
that mm_cpumask is, by design, made to be used as cpumask to send a
broadcast IPI to all CPUs which run threads belonging to a given
process.

So, how about just using mm_cpumask(current) for the broadcast ? Then we
don't even need to allocate our own cpumask neither.

Or am I missing something ? I just sounds too simple.

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
