Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948Ab0AJVlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0AJVlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 16:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861Ab0AJVlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 16:41:15 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:42203 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753621Ab0AJVlP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 16:41:15 -0500
Date: Sun, 10 Jan 2010 16:41:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100110214112.GA6146@Krystal>
References: <20100110000318.GD9044@linux.vnet.ibm.com> <1263084099.2231.5.camel@frodo> <20100110014456.GG25790@Krystal> <1263089578.2231.22.camel@frodo> <20100110052508.GG9044@linux.vnet.ibm.com> <1263124209.28171.3798.camel@gandalf.stny.rr.com> <20100110160314.GA10587@Krystal> <1263140480.4561.7.camel@frodo> <20100110171020.GA13329@Krystal> <1263157321.4561.25.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1263157321.4561.25.camel@frodo>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:32:38 up 25 days,  5:51,  4 users,  load average: 0.18, 0.20,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
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
> > 
> 
> No it is not weird, it is common. The read is on the link list that we
> can access. Yes a write should be protected by other locks, so maybe
> that is the weird part.

Yes, this is what I thought was a bit weird.

> 
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

Yes

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

Yes, even though this event is very unlikely, I don't want to rely on a
memory barrier that would happen to be missing.


> But I'm sure Paul will point me to some arch that does this ;-)
> 
> > 
> > > 		
> > > So, if there's no smp_wmb() between the <preempt> and cpumask_clear()
> > > then we have an issue?
> > 
> > Considering the scenario above, we would need a full smp_mb() (or
> > equivalent) rather than just smp_wmb() to be strictly correct.
> 
> I agree with Paul, we should just punt and grab the rq locks. That seems
> to be the safest way without resorting to funny tricks to save 15% on a
> slow path.

Allright. I must warn you though: the resulting code is _much_ bigger
than a simple ipi sent to a mm cpumask, because we have to allocate the
cpumask and iterate on cpus/threads (whichever is the smallest). I grows
from a tiny 41 lines to 224 lines.

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
