Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082Ab0AGVfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab0AGVfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871Ab0AGVfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:35:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47823 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0AGVfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:35:44 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=JjziAcBRXAO3YTuwVlYA:9 a=96rQbOrmWBhq0kgKh6IA:7 a=fhTs8uJg9zEtgZhDYET0l-UlTmoA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: paulmck@linux.vnet.ibm.com
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <20100107205830.GR6764@linux.vnet.ibm.com>
References: <20100107044007.GA22863@Krystal>
	 <1262852862.4049.78.camel@laptop> <20100107183010.GA14980@redhat.com>
	 <20100107183946.GL6764@linux.vnet.ibm.com>
	 <1262890782.28171.3738.camel@gandalf.stny.rr.com>
	 <20100107191657.GN6764@linux.vnet.ibm.com>
	 <1262893243.28171.3753.camel@gandalf.stny.rr.com>
	 <20100107205830.GR6764@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 07 Jan 2010 16:35:40 -0500
Message-ID: <1262900140.28171.3773.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 12:58 -0800, Paul E. McKenney wrote:

> I believe that I am worried about a different scenario.  I do not believe
> that the scenario you lay out above can actually happen.  The pair of
> schedules on CPU 2 have to act as a full memory barrier, otherwise,
> it would not be safe to resume a task on some other CPU.

I'm not so sure about that. The update of ->curr happens inside a
spinlock, which is a rmb() ... wmb() pair. Must be, because a spin_lock
must be an rmb otherwise the loads could move outside the lock, and the
spin_unlock must be a wmb() otherwise what was written could move
outside the lock.


>   If the pair
> of schedules act as a full memory barrier, then the code in
> synchronize_rcu() that looks at the RCU read-side state would see that
> CPU 2 is in an RCU read-side critical section.
> 
> The scenario that I am (perhaps wrongly) concerned about is enabled by
> the fact that URCU's rcu_read_lock() has a load, some checks, and a store.
> It has compiler constraints, but no hardware memory barriers.  This
> means that CPUs (even x86) can execute an rcu_dereference() before the
> rcu_read_lock()'s store has executed.
> 
> Hacking your example above, keeping mind that x86 can reorder subsequent
> loads to precede prior stores:
> 
> 
> 	CPU 1				CPU 2
>      -----------                    -------------
> 
> 	<user space>			<kernel space, switching to task>
> 
> 					->curr updated
> 
> 					<long code path, maybe mb?>
> 
> 					<user space>
> 
> 					rcu_read_lock(); [load only]
> 
> 					obj = list->next
> 
> 	list_del(obj)
> 
> 	sys_membarrier();
> 	< kernel space >

Well, if we just grab the task_rq(task)->lock here, then we should be
OK? We would guarantee that curr is either the task we want or not.

> 
> 	if (task_rq(task)->curr != task)
> 	< but load to obj reordered before store to ->curr >
> 
> 	< user space >
> 
> 	< misses that CPU 2 is in rcu section >
> 
> 	[CPU 2's ->curr update now visible]
> 
> 	[CPU 2's rcu_read_lock() store now visible]
> 
> 	free(obj);
> 
> 					use_object(obj); <=== crash!
> 
> 
> 
> If the "long code path" happens to include a full memory barrier, or if it
> happens to be long enough to overflow CPU 2's store buffer, then the
> above scenario cannot happen.  Until such time as someone applies some
> unforeseen optimization to the context-switch path.
> 
> And, yes, the context-switch path has to have a full memory barrier
> somewhere, but that somewhere could just as easily come before the
> update of ->curr.

Hmm, since ->curr is updated before sched_mm() I'm thinking it would
have to be after the update of curr.

> 
> The same scenario applies when using ->cpu_vm_mask instead of ->curr.
> 
> Now, I could easily believe that the current context-switch code has
> sufficient atomic operations, memory barriers, and instructions to
> prevent this scenario from occurring, but it is feeling a lot like an
> accident waiting to happen.  Hence my strident complaints.  ;-)

I'm totally with you on this. I really want a good understanding of what
can go wrong, and show that we have the necessary infrastructure to
prevent it.

-- Steve


