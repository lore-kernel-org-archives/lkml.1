Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007Ab0AGU6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0AGU6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349Ab0AGU6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:58:36 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59581 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab0AGU6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:58:35 -0500
Date: Thu, 7 Jan 2010 12:58:30 -0800
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
Message-ID: <20100107205830.GR6764@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100107044007.GA22863@Krystal> <1262852862.4049.78.camel@laptop> <20100107183010.GA14980@redhat.com> <20100107183946.GL6764@linux.vnet.ibm.com> <1262890782.28171.3738.camel@gandalf.stny.rr.com> <20100107191657.GN6764@linux.vnet.ibm.com> <1262893243.28171.3753.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262893243.28171.3753.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 02:40:43PM -0500, Steven Rostedt wrote:
> On Thu, 2010-01-07 at 11:16 -0800, Paul E. McKenney wrote:
> 
> > > Note, we are not suggesting optimizations. It has nothing to do with
> > > performance of the syscall. We just can't allow one process to be DoSing
> > > another process on another cpu by it sending out millions of IPIs.
> > > Mathieu already showed that you could cause a 2x slowdown to the
> > > unrelated tasks.
> > 
> > I would have said that we are trying to optimize our way out of a DoS
> > situation, but point taken.  Whatever we choose to call it, the discussion
> > is on the suggested modifications, not strictly on the original patch.  ;-)
> 
> OK, I just want to get a better understanding of what can go wrong. A
> sys_membarrier() is used as follows, correct? (using a list example)
> 
> 	<user space>
> 
> 	list_del(obj);
> 
> 	synchronize_rcu();  -> calls sys_membarrier();
> 
> 	free(obj);
> 
> 
> And we need to protect against:
> 
> 	<user space>
> 
> 	read_rcu_lock();
> 
> 	obj = list->next;
> 
> 	use_object(obj);
> 
> 	read_rcu_unlock();

Yep!

> where we want to make sure that the synchronize_rcu() makes sure that we
> have passed the grace period of all takers of read_rcu_lock(). Now I
> have not looked at the code that implements userspace rcu, so I'm making
> a lot of assumptions here. But the problem that we need to avoid is:
> 
> 
> 	CPU 1				CPU 2
>      -----------                    -------------
> 
> 	<user space>			<user space>
> 
> 					rcu_read_lock();
> 
> 					obj = list->next
> 
> 	list_del(obj)
> 
> 					< Interrupt >
> 					< kernel space>
> 					<schedule>
> 
> 					<kernel_thread>
> 
> 					<schedule>
> 
> 					< back to original task >
> 
> 	sys_membarrier();
> 	< kernel space >
> 
> 	if (task_rq(task)->curr != task)
> 	< but still sees kernel thread >
> 
> 	< user space >
> 
> 	< misses that we are still in rcu section >
> 
> 	free(obj);
> 
> 					< user space >
> 
> 					use_object(obj); <=== crash!
> 
> 
> 
> I guess what I'm trying to do here is to understand what can go wrong,
> and then when we understand the issues, we can find a solution.

I believe that I am worried about a different scenario.  I do not believe
that the scenario you lay out above can actually happen.  The pair of
schedules on CPU 2 have to act as a full memory barrier, otherwise,
it would not be safe to resume a task on some other CPU.  If the pair
of schedules act as a full memory barrier, then the code in
synchronize_rcu() that looks at the RCU read-side state would see that
CPU 2 is in an RCU read-side critical section.

The scenario that I am (perhaps wrongly) concerned about is enabled by
the fact that URCU's rcu_read_lock() has a load, some checks, and a store.
It has compiler constraints, but no hardware memory barriers.  This
means that CPUs (even x86) can execute an rcu_dereference() before the
rcu_read_lock()'s store has executed.

Hacking your example above, keeping mind that x86 can reorder subsequent
loads to precede prior stores:


	CPU 1				CPU 2
     -----------                    -------------

	<user space>			<kernel space, switching to task>

					->curr updated

					<long code path, maybe mb?>

					<user space>

					rcu_read_lock(); [load only]

					obj = list->next

	list_del(obj)

	sys_membarrier();
	< kernel space >

	if (task_rq(task)->curr != task)
	< but load to obj reordered before store to ->curr >

	< user space >

	< misses that CPU 2 is in rcu section >

	[CPU 2's ->curr update now visible]

	[CPU 2's rcu_read_lock() store now visible]

	free(obj);

					use_object(obj); <=== crash!



If the "long code path" happens to include a full memory barrier, or if it
happens to be long enough to overflow CPU 2's store buffer, then the
above scenario cannot happen.  Until such time as someone applies some
unforeseen optimization to the context-switch path.

And, yes, the context-switch path has to have a full memory barrier
somewhere, but that somewhere could just as easily come before the
update of ->curr.

The same scenario applies when using ->cpu_vm_mask instead of ->curr.

Now, I could easily believe that the current context-switch code has
sufficient atomic operations, memory barriers, and instructions to
prevent this scenario from occurring, but it is feeling a lot like an
accident waiting to happen.  Hence my strident complaints.  ;-)

							Thanx, Paul
