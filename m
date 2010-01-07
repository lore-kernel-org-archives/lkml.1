Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687Ab0AGGgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab0AGGgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 01:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509Ab0AGGgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 01:36:08 -0500
Received: from relay1-v.mail.gandi.net ([217.70.178.75]:39347 "EHLO
	relay1-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0AGGgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 01:36:07 -0500
Date: Wed, 6 Jan 2010 22:35:59 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
Message-ID: <20100107063558.GC12939@feather>
References: <20100107044007.GA22863@Krystal>
 <1262842854.28171.3710.camel@gandalf.stny.rr.com>
 <20100107061955.GC25786@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107061955.GC25786@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 01:19:55AM -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Wed, 2010-01-06 at 23:40 -0500, Mathieu Desnoyers wrote:
> > > Here is an implementation of a new system call, sys_membarrier(), which
> > > executes a memory barrier on all threads of the current process.
> > > 
> > > It aims at greatly simplifying and enhancing the current signal-based
> > > liburcu userspace RCU synchronize_rcu() implementation.
> > > (found at http://lttng.org/urcu)
> > > 
> > 
> > Nice.
> > 
> > > Both the signal-based and the sys_membarrier userspace RCU schemes
> > > permit us to remove the memory barrier from the userspace RCU
> > > rcu_read_lock() and rcu_read_unlock() primitives, thus significantly
> > > accelerating them. These memory barriers are replaced by compiler
> > > barriers on the read-side, and all matching memory barriers on the
> > > write-side are turned into an invokation of a memory barrier on all
> > > active threads in the process. By letting the kernel perform this
> > > synchronization rather than dumbly sending a signal to every process
> > > threads (as we currently do), we diminish the number of unnecessary wake
> > > ups and only issue the memory barriers on active threads. Non-running
> > > threads do not need to execute such barrier anyway, because these are
> > > implied by the scheduler context switches.
> > > 
> > > To explain the benefit of this scheme, let's introduce two example threads:
> > > 
> > > Thread A (non-frequent, e.g. executing liburcu synchronize_rcu())
> > > Thread B (frequent, e.g. executing liburcu rcu_read_lock()/rcu_read_unlock())
> > > 
> > > In a scheme where all smp_mb() in thread A synchronize_rcu() are
> > > ordering memory accesses with respect to smp_mb() present in
> > > rcu_read_lock/unlock(), we can change all smp_mb() from
> > > synchronize_rcu() into calls to sys_membarrier() and all smp_mb() from
> > > rcu_read_lock/unlock() into compiler barriers "barrier()".
> > > 
> > > Before the change, we had, for each smp_mb() pairs:
> > > 
> > > Thread A                    Thread B
> > > prev mem accesses           prev mem accesses
> > > smp_mb()                    smp_mb()
> > > follow mem accesses         follow mem accesses
> > > 
> > > After the change, these pairs become:
> > > 
> > > Thread A                    Thread B
> > > prev mem accesses           prev mem accesses
> > > sys_membarrier()            barrier()
> > > follow mem accesses         follow mem accesses
> > > 
> > > As we can see, there are two possible scenarios: either Thread B memory
> > > accesses do not happen concurrently with Thread A accesses (1), or they
> > > do (2).
> > > 
> > > 1) Non-concurrent Thread A vs Thread B accesses:
> > > 
> > > Thread A                    Thread B
> > > prev mem accesses
> > > sys_membarrier()
> > > follow mem accesses
> > >                             prev mem accesses
> > >                             barrier()
> > >                             follow mem accesses
> > > 
> > > In this case, thread B accesses will be weakly ordered. This is OK,
> > > because at that point, thread A is not particularly interested in
> > > ordering them with respect to its own accesses.
> > > 
> > > 2) Concurrent Thread A vs Thread B accesses
> > > 
> > > Thread A                    Thread B
> > > prev mem accesses           prev mem accesses
> > > sys_membarrier()            barrier()
> > > follow mem accesses         follow mem accesses
> > > 
> > > In this case, thread B accesses, which are ensured to be in program
> > > order thanks to the compiler barrier, will be "upgraded" to full
> > > smp_mb() thanks to the IPIs executing memory barriers on each active
> > > system threads. Each non-running process threads are intrinsically
> > > serialized by the scheduler.
> > > 
> > > The current implementation simply executes a memory barrier in an IPI
> > > handler on each active cpu. Going through the hassle of taking run queue
> > > locks and checking if the thread running on each online CPU belongs to
> > > the current thread seems more heavyweight than the cost of the IPI
> > > itself (not measured though).
> > > 
> > 
> > 
> > I don't think you need to grab any locks. Doing an rcu_read_lock()
> > should prevent tasks from disappearing (since destruction of tasks use
> > RCU). You may still need to grab the tasklist_lock under read_lock().
> > 
> > So what you could do, is find each task that is a thread of the calling
> > task, and then just check task_rq(task)->curr != task. Just send the
> > IPI's to those tasks that pass the test.
> 
> I guess you mean
> 
> "then just check task_rq(task)->curr == task" ... ?
> 
> > 
> > If the task->rq changes, or the task->rq->curr changes, and makes the
> > condition fail (or even pass), the events that cause those changes are
> > probably good enough than needing to call smp_mb();
> 
> I see your point.
> 
> This would probably be good for machines with very large number of cpus
> and without IPI broadcast support, running processes with only few
> threads.

Or with expensive IPIs and/or expensive user-kernel switches.

> I really start to think that we should have some way to compare
> the number of threads belonging to a process and choose between the
> broadcast IPI and the per-cpu IPI depending if we are over or under an
> arbitrary threshold.

The number of threads doesn't matter nearly as much as the number of
threads typically running at a time compared to the number of
processors.  Of course, we can't measure that as easily, but I don't
know that your proposed heuristic would approximate it well.

- Josh Triplett
