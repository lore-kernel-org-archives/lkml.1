Return-Path: <linux-kernel-owner+w=401wt.eu-S932420Ab0AGGEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab0AGGEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 01:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285Ab0AGGEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 01:04:43 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:61158 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751520Ab0AGGEn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 01:04:43 -0500
Date: Thu, 7 Jan 2010 01:04:39 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107060439.GB25786@Krystal>
References: <20100107044007.GA22863@Krystal> <20100107052851.GA12419@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20100107052851.GA12419@feather>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 00:39:18 up 21 days, 13:57,  5 users,  load average: 0.08, 0.20,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Josh Triplett (josh@joshtriplett.org) wrote:
> On Wed, Jan 06, 2010 at 11:40:07PM -0500, Mathieu Desnoyers wrote:
> > Here is an implementation of a new system call, sys_membarrier(), which
> > executes a memory barrier on all threads of the current process.
> > 
> > It aims at greatly simplifying and enhancing the current signal-based
> > liburcu userspace RCU synchronize_rcu() implementation.
> > (found at http://lttng.org/urcu)
> > 
> > Both the signal-based and the sys_membarrier userspace RCU schemes
> > permit us to remove the memory barrier from the userspace RCU
> > rcu_read_lock() and rcu_read_unlock() primitives, thus significantly
> > accelerating them. These memory barriers are replaced by compiler
> > barriers on the read-side, and all matching memory barriers on the
> > write-side are turned into an invokation of a memory barrier on all
> > active threads in the process. By letting the kernel perform this
> > synchronization rather than dumbly sending a signal to every process
> > threads (as we currently do), we diminish the number of unnecessary wake
> > ups and only issue the memory barriers on active threads. Non-running
> > threads do not need to execute such barrier anyway, because these are
> > implied by the scheduler context switches.
> [...]
> > The current implementation simply executes a memory barrier in an IPI
> > handler on each active cpu. Going through the hassle of taking run queue
> > locks and checking if the thread running on each online CPU belongs to
> > the current thread seems more heavyweight than the cost of the IPI
> > itself (not measured though).
> 
> > --- linux-2.6-lttng.orig/kernel/sched.c	2010-01-06 22:11:32.000000000 -0500
> > +++ linux-2.6-lttng/kernel/sched.c	2010-01-06 23:20:42.000000000 -0500
> > @@ -10822,6 +10822,36 @@ struct cgroup_subsys cpuacct_subsys = {
> >  };
> >  #endif	/* CONFIG_CGROUP_CPUACCT */
> >  
> > +/*
> > + * Execute a memory barrier on all CPUs on SMP systems.
> > + * Do not rely on implicit barriers in smp_call_function(), just in case they
> > + * are ever relaxed in the future.
> > + */
> > +static void membarrier_ipi(void *unused)
> > +{
> > +	smp_mb();
> > +}
> > +
> > +/*
> > + * sys_membarrier - issue memory barrier on current process running threads
> > + *
> > + * Execute a memory barrier on all running threads of the current process.
> > + * Upon completion, the caller thread is ensured that all process threads
> > + * have passed through a state where memory accesses match program order.
> > + * (non-running threads are de facto in such a state)
> > + *
> > + * The current implementation simply executes a memory barrier in an IPI handler
> > + * on each active cpu. Going through the hassle of taking run queue locks and
> > + * checking if the thread running on each online CPU belongs to the current
> > + * thread seems more heavyweight than the cost of the IPI itself.
> > + */
> > +SYSCALL_DEFINE0(membarrier)
> > +{
> > +	on_each_cpu(membarrier_ipi, NULL, 1);
> > +
> > +	return 0;
> > +}
> > +
> 
> Nice idea.  A few things come immediately to mind:
> 
> - If !CONFIG_SMP, this syscall should become (more of) a no-op.  Ideally
>   even if CONFIG_SMP but running with one CPU.  (If you really wanted to
>   go nuts, you could make it a vsyscall that did nothing with 1 CPU, to
>   avoid the syscall overhead, but that seems like entirely too much
>   trouble.)
> 

Sure, will do.

> - Have you tested what happens if a process does "while(1)
>   membarrier();"?  By running on every CPU, including those not owned by
>   the current process, this has the potential to make DoS easier,
>   particularly on systems with many CPUs.  That gets even worse if a
>   process forks multiple threads running that same loop.  Also consider
>   that executing an IPI will do work even on a CPU currently running a
>   real-time task.

Just tried it with a 10,000,000 iterations loop.

The thread doing the system call loop takes 2.0% of user time, 98% of
system time. All other cpus are nearly 100.0% idle. Just to give a bit
more info about my test setup, I also have a thread sitting on a CPU
busy-waiting for the loop to complete. This thread takes 97.7% user
time (but it really is just there to make sure we are indeed doing the
IPIs, not skipping it through the thread_group_empty(current) test). If
I remove this thread, the execution time of the test program shrinks
from 32 seconds down to 1.9 seconds. So yes, the IPI is actually
executed in the first place, because removing the extra thread
accelerates the loop tremendously. I used a 8-core Xeon to test.

> 
> - Rather than groveling through runqueues, could you somehow remotely
>   check the value of current?  In theory, a race in doing so wouldn't
>   matter; finding something other than the current process should mean
>   you don't need to do a barrier, and finding the current process means
>   you might need to do a barrier.

Well, the thing is that sending an IPI to all processors can be done
very efficiently on a lot of architectures because it uses an IPI
broadcast. If we have to select a few processors to which we send the
signal individually, I fear that the solution will scale poorly on
systems where cpus are densely used by threads belonging to the current
process.

So if we go down the route of sending an IPI broadcast as I did, then
the performance improvement of skipping the smp_mb() for some CPU seems
insignificant compared to the IPI. In addition, it would require to add
some preparation code and exchange cache-lines (containing the process
ID), which would actually slow down the non-parallel portion of the
system call (to accelerate the parallelizable portion on only some of
the CPUs).

So I don't think this would buy us anything. However, if we would have a
per-process count of the number of threads in the thread group, then
we could switch to a per-cpu IPI rather than broadcast if we detect that
we have much fewer threads than CPUs.

> 
> - Part of me thinks this ought to become slightly more general, and just
>   deliver a signal that the receiving thread could handle as it likes.
>   However, that would certainly prove more expensive than this, and I
>   don't know that the generality would buy anything.

A general scheme would have to call every threads, even those which are
not running. In the case of this system call, this is a particular case
where we can forget about non-running threads, because the memory
barrier is implied by the scheduler activity that brought them offline.
So I really don't see how we can use this IPI scheme for other things
that this kind of synchronization.

> 
> - Could you somehow register reader threads with the kernel, in a way
>   that makes them easy to detect remotely?

There are two ways I figure out we could do this. One would imply adding
extra shared data between kernel and userspace (which I'd like to avoid,
to keep coupling low). The other alternative would be to add per
task_struct information about this, and new system calls. The added per
task_struct information would use up cache lines (which are very
important, especially in the task_struct) and the added system call at
rcu_read_lock/unlock() would simply kill performance.

Thanks,

Mathieu

> 
> 
> - Josh Triplett

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
