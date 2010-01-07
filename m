Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149Ab0AGWej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab0AGWej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272Ab0AGWeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:34:37 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42516 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab0AGWeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:34:36 -0500
Date: Thu, 7 Jan 2010 14:34:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107223432.GU6764@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100107044007.GA22863@Krystal> <1262852862.4049.78.camel@laptop> <20100107183010.GA14980@redhat.com> <20100107183946.GL6764@linux.vnet.ibm.com> <1262890782.28171.3738.camel@gandalf.stny.rr.com> <20100107191657.GN6764@linux.vnet.ibm.com> <1262893243.28171.3753.camel@gandalf.stny.rr.com> <20100107205830.GR6764@linux.vnet.ibm.com> <1262900140.28171.3773.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262900140.28171.3773.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 04:35:40PM -0500, Steven Rostedt wrote:
> On Thu, 2010-01-07 at 12:58 -0800, Paul E. McKenney wrote:
> 
> > I believe that I am worried about a different scenario.  I do not believe
> > that the scenario you lay out above can actually happen.  The pair of
> > schedules on CPU 2 have to act as a full memory barrier, otherwise,
> > it would not be safe to resume a task on some other CPU.
> 
> I'm not so sure about that. The update of ->curr happens inside a
> spinlock, which is a rmb() ... wmb() pair. Must be, because a spin_lock
> must be an rmb otherwise the loads could move outside the lock, and the
> spin_unlock must be a wmb() otherwise what was written could move
> outside the lock.

If a given task is running on CPU 0, then switches to CPU 1, all of the
CPU-0 activity from that task had -better- be visible when it runs on
CPU 1.  But if you were saying that there are other ways to accomplish
this than a full memory barrier, I do agree.

> >   If the pair
> > of schedules act as a full memory barrier, then the code in
> > synchronize_rcu() that looks at the RCU read-side state would see that
> > CPU 2 is in an RCU read-side critical section.
> > 
> > The scenario that I am (perhaps wrongly) concerned about is enabled by
> > the fact that URCU's rcu_read_lock() has a load, some checks, and a store.
> > It has compiler constraints, but no hardware memory barriers.  This
> > means that CPUs (even x86) can execute an rcu_dereference() before the
> > rcu_read_lock()'s store has executed.
> > 
> > Hacking your example above, keeping mind that x86 can reorder subsequent
> > loads to precede prior stores:
> > 
> > 
> > 	CPU 1				CPU 2
> >      -----------                    -------------
> > 
> > 	<user space>			<kernel space, switching to task>
> > 
> > 					->curr updated
> > 
> > 					<long code path, maybe mb?>
> > 
> > 					<user space>
> > 
> > 					rcu_read_lock(); [load only]
> > 
> > 					obj = list->next
> > 
> > 	list_del(obj)
> > 
> > 	sys_membarrier();
> > 	< kernel space >
> 
> Well, if we just grab the task_rq(task)->lock here, then we should be
> OK? We would guarantee that curr is either the task we want or not.

The lock that CPU 2 just grabbed to protect its ->curr update?  If so,
then I believe that this would work, because the CPU would not be
permitted to re-order the "obj = list->next" to precede CPU 2's
acquisition of this lock.

> > 	if (task_rq(task)->curr != task)
> > 	< but load to obj reordered before store to ->curr >
> > 
> > 	< user space >
> > 
> > 	< misses that CPU 2 is in rcu section >
> > 
> > 	[CPU 2's ->curr update now visible]
> > 
> > 	[CPU 2's rcu_read_lock() store now visible]
> > 
> > 	free(obj);
> > 
> > 					use_object(obj); <=== crash!
> > 
> > 
> > 
> > If the "long code path" happens to include a full memory barrier, or if it
> > happens to be long enough to overflow CPU 2's store buffer, then the
> > above scenario cannot happen.  Until such time as someone applies some
> > unforeseen optimization to the context-switch path.
> > 
> > And, yes, the context-switch path has to have a full memory barrier
> > somewhere, but that somewhere could just as easily come before the
> > update of ->curr.
> 
> Hmm, since ->curr is updated before sched_mm() I'm thinking it would
> have to be after the update of curr.

If I understand what you are getting at, from a coherence viewpoint,
the only requirement is that the memory barrier (or equivalent) come
between the last user-mode instruction and the runqueue update on the
outgoing CPU, and between the runqueue read and the first user-mode
instruction on the incoming CPU.

> > The same scenario applies when using ->cpu_vm_mask instead of ->curr.
> > 
> > Now, I could easily believe that the current context-switch code has
> > sufficient atomic operations, memory barriers, and instructions to
> > prevent this scenario from occurring, but it is feeling a lot like an
> > accident waiting to happen.  Hence my strident complaints.  ;-)
> 
> I'm totally with you on this. I really want a good understanding of what
> can go wrong, and show that we have the necessary infrastructure to
> prevent it.

Sounds good to me!  ;-)

							Thanx, Paul
