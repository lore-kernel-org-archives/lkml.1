Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784Ab0AKBVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab0AKBVV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 20:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606Ab0AKBVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 20:21:19 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50826 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab0AKBVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 20:21:18 -0500
Date: Sun, 10 Jan 2010 17:21:19 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100111012119.GK9044@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100110000318.GD9044@linux.vnet.ibm.com> <1263084099.2231.5.camel@frodo> <20100110014456.GG25790@Krystal> <1263089578.2231.22.camel@frodo> <20100110052508.GG9044@linux.vnet.ibm.com> <1263124209.28171.3798.camel@gandalf.stny.rr.com> <20100110160314.GA10587@Krystal> <1263140480.4561.7.camel@frodo> <20100110171020.GA13329@Krystal> <1263157321.4561.25.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263157321.4561.25.camel@frodo>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 04:02:01PM -0500, Steven Rostedt wrote:
> On Sun, 2010-01-10 at 12:10 -0500, Mathieu Desnoyers wrote:
> 
> > > 
> > > 	CPU 0			CPU 1
> > >      ----------		    --------------
> > > 	obj = list->obj;
> > > 				<user space>
> > > 				rcu_read_lock();
> > > 				obj = rcu_dereference(list->obj);
> > > 				obj->foo = bar;
> > > 
> > > 				<preempt>
> > > 				<kernel space>
> > > 
> > > 				schedule();
> > > 				cpumask_clear(mm_cpumask, cpu);
> > > 
> > > 	sys_membarrier();
> > > 	free(obj);
> > > 
> > > 				<store to obj->foo goes to memory>  <- corruption
> > > 
> > 
> > Hrm, having a writer like this in a rcu read-side would be a bit weird.
> > We have to look at the actual rcu_read_lock() implementation in urcu to
> > see why load/stores are important on the rcu read-side.
> 
> No it is not weird, it is common. The read is on the link list that we
> can access. Yes a write should be protected by other locks, so maybe
> that is the weird part.

Not all that weird -- statistical counters are a common example, as
would be setting of flags, for example, those used to indicate that
later pruning operations might be needed.

> > (note: _STORE_SHARED is simply a volatile store)
> > 
> > (Thread-local variable, shared with the thread doing synchronize_rcu())
> > struct urcu_reader __thread urcu_reader;
> > 
> > static inline void _rcu_read_lock(void)
> > {
> >         long tmp;
> > 
> >         tmp = urcu_reader.ctr;
> >         if (likely(!(tmp & RCU_GP_CTR_NEST_MASK))) {
> >                 _STORE_SHARED(urcu_reader.ctr, _LOAD_SHARED(urcu_gp_ctr));
> >                 /*
> >                  * Set active readers count for outermost nesting level before
> >                  * accessing the pointer. See force_mb_all_threads().
> >                  */
> >                 barrier();
> >         } else {
> >                 _STORE_SHARED(urcu_reader.ctr, tmp + RCU_GP_COUNT);
> >         }
> > }
> > 
> > So as you see here, we have to ensure that the store to urcu_reader.ctr
> > is globally visible before entering the critical section (previous
> > stores must complete before following loads). For rcu_read_unlock, it's
> > the opposite:
> > 
> > static inline void _rcu_read_unlock(void)
> > {
> >         long tmp;
> > 
> >         tmp = urcu_reader.ctr;
> >         /*
> >          * Finish using rcu before decrementing the pointer.
> >          * See force_mb_all_threads().
> >          */
> >         if (likely((tmp & RCU_GP_CTR_NEST_MASK) == RCU_GP_COUNT)) {
> >                 barrier();
> >                 _STORE_SHARED(urcu_reader.ctr, urcu_reader.ctr - RCU_GP_COUNT);
> >         } else {
> >                 _STORE_SHARED(urcu_reader.ctr, urcu_reader.ctr - RCU_GP_COUNT);
> >         }
> > }
> 
> Thanks for the insight of the code. I need to get around and look at
> your userspace implementation ;-)
> 
> > 
> > We need to ensure that previous loads complete before following stores.
> > 
> > Therefore, the race with unlock showing that we need to order loads
> > before stores:
> > 
> > 	CPU 0			CPU 1
> >         --------------          --------------
> >                                 <user space> (already in read-side C.S.)
> >                                 obj = rcu_dereference(list->next);
> >                                   -> load list->next
> >                                 copy = obj->foo;
> >                                 rcu_read_unlock();
> >                                   -> store to urcu_reader.ctr
> >                                 <urcu_reader.ctr store is globally visible>
> >         list_del(obj);
> >                                 <preempt>
> >                                 <kernel space>
> > 
> >                                 schedule();
> >                                 cpumask_clear(mm_cpumask, cpu);
> 
> 				but here we are switching to a new task.
> 
> > 
> >         sys_membarrier();
> >         set global g.p. (urcu_gp_ctr) phase to 1
> >         wait for all urcu_reader.ctr in phase 0
> >         set global g.p. (urcu_gp_ctr) phase to 0
> >         wait for all urcu_reader.ctr in phase 1
> >         sys_membarrier();
> >         free(obj);
> >                                 <list->next load hits memory>
> >                                 <obj->foo load hits memory> <- corruption
> 
> load of obj->foo is really load foo(obj) into some register. And for the
> above to fail, that means that this load happened even after we switched
> to kernel space, and that load of foo(obj) is still pending to get into
> the thread stack that saved that register.
> 
> But I'm sure Paul will point me to some arch that does this ;-)

Given the recent dual-core non-cache-coherent Blackfin, I would not want
to make guarantees that this will never happen.  Yes, it was experimental,
but there are lots of strange CPUs showing up.  And we really should put
the ordering dependency in core non-arch-specific code -- less
vulnerable that way.

							Thanx, Paul

> > > So, if there's no smp_wmb() between the <preempt> and cpumask_clear()
> > > then we have an issue?
> > 
> > Considering the scenario above, we would need a full smp_mb() (or
> > equivalent) rather than just smp_wmb() to be strictly correct.
> 
> I agree with Paul, we should just punt and grab the rq locks. That seems
> to be the safest way without resorting to funny tricks to save 15% on a
> slow path.
> 
> -- Steve
> 
> 
