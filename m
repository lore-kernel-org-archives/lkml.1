Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632Ab0ASQtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab0ASQtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 11:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536Ab0ASQtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 11:49:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:57876 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab0ASQtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 11:49:17 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
In-Reply-To: <20100114162609.GC3487@Krystal>
References: <20100113013757.GA29314@Krystal>
	 <1263400738.4244.242.camel@laptop> <20100113193603.GA27327@Krystal>
	 <1263460096.4244.282.camel@laptop>  <20100114162609.GC3487@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 17:47:47 +0100
Message-ID: <1263919667.4283.732.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 11:26 -0500, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Wed, 2010-01-13 at 14:36 -0500, Mathieu Desnoyers wrote:
> > > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > > On Tue, 2010-01-12 at 20:37 -0500, Mathieu Desnoyers wrote:
> > > > > +       for_each_cpu(cpu, tmpmask) {
> > > > > +               spin_lock_irq(&cpu_rq(cpu)->lock);
> > > > > +               mm = cpu_curr(cpu)->mm;
> > > > > +               spin_unlock_irq(&cpu_rq(cpu)->lock);
> > > > > +               if (current->mm != mm)
> > > > > +                       cpumask_clear_cpu(cpu, tmpmask);
> > > > > +       } 
> > > > 
> > > > Why not:
> > > > 
> > > >   rcu_read_lock();
> > > >   if (current->mm != cpu_curr(cpu)->mm)
> > > >     cpumask_clear_cpu(cpu, tmpmask);
> > > >   rcu_read_unlock();
> > > > 
> > > > the RCU read lock ensures the task_struct obtained remains valid, and it
> > > > avoids taking the rq->lock.
> > > > 
> > > 
> > > If we go for a simple rcu_read_lock, I think that we need a smp_mb()
> > > after switch_to() updates the current task on the remote CPU, before it
> > > returns to user-space. Do we have this guarantee for all architectures ?
> > > 
> > > So what I'm looking for, overall, is:
> > > 
> > > schedule()
> > >   ...
> > >   switch_mm()
> > >     smp_mb()
> > >     clear mm_cpumask
> > >     set mm_cpumask
> > >   switch_to()
> > >     update current task
> > >     smp_mb()
> > > 
> > > If we have that, then the rcu_read_lock should work.
> > > 
> > > What the rq lock currently gives us is the guarantee that if the current
> > > thread changes on a remote CPU while we are not holding this lock, then
> > > a full scheduler execution is performed, which implies a memory barrier
> > > if we change the current thread (it does, right ?).
> > 
> > I'm not quite seeing it, we have 4 possibilities, switches between
> > threads with:
> > 
> >  a) our mm, another mm
> > 
> >    - if we observe the former, we'll send an IPI (redundant)
> >    - if we observe the latter, the switch_mm will have issued an mb
> > 
> >  b) another mm, our mm
> > 
> >    - if we observe the former, we're good because the cpu didn't run our
> >      thread when we called sys_membarrier()
> >    - if we observe the latter, we'll send an IPI (redundant)
> 
> It's this scenario that is causing problem. Let's consider this
> execution:
> 
>        CPU 0 (membarrier)                  CPU 1 (another mm -> our mm)
>        <kernel-space>                      <kernel-space>
>                                            switch_mm()
>                                              smp_mb()
>                                              clear_mm_cpumask()
>                                              set_mm_cpumask()
>                                              smp_mb() (by load_cr3() on x86)
>                                            switch_to()
>        mm_cpumask includes CPU 1
>        rcu_read_lock()
>        if (CPU 1 mm != our mm)
>          skip CPU 1.
>        rcu_read_unlock()
>                                              current = next (1)

OK, so on x86 current uses esp and will be flipped somewhere in the
switch_to() magic, cpu_curr(cpu) as used by CPU 0 uses rq->curr, which
will be set before context_switch() and that always implies a mb() for
non matching ->mm's [*]

>                                            <switch back to user-space>
>                                            read-lock()
>                                              read gp, store local gp
>                                              barrier()
>                                              access critical section (2)
> 
> So if we don't have any memory barrier between (1) and (2), the memory
> operations can be reordered in such a way that CPU 0 will not send IPI
> to a CPU that would need to have it's barrier() promoted into a
> smp_mb().

OK, so I'm utterly failing to make sense of the above, do you need more
than the 2 cpus discussed to make it go boom?

> Replacing these kernel rcu_read_lock/unlock() by rq locks ensures that
> when the scheduler runs concurrently on another CPU, _all_ the scheduling
> code is executed atomically wrt the spin lock taken on cpu 0.

Sure, but taking the rq->lock is fairly heavy handed.

> When x86 uses iret to return to user-space, then we have a serializing
> instruction. But if it uses sysexit, or if we are on a different
> architecture, are we sure that a memory barrier is issued before
> returning to user-space ?

[*] and possibly also for matching ->mm's, because:

OK, so I had a quick look at the switch_to() magic, and from what I can
make of it it implies an mb, if only because poking at the segment
registers implies LOCK semantics.


