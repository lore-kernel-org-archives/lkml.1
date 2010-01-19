Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208Ab0ASRaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab0ASRaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 12:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911Ab0ASRay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 12:30:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50503 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab0ASRam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:30:42 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=D19gQVrFAAAA:8 a=jKtF9JfShlQoTCHitWYA:9 a=WLDztGozk5uui_qvhIUA:7 a=MtQvHTMUuDqAjgCyP3VejgMMaVcA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v5)
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <1263919667.4283.732.camel@laptop>
References: <20100113013757.GA29314@Krystal>
	 <1263400738.4244.242.camel@laptop> <20100113193603.GA27327@Krystal>
	 <1263460096.4244.282.camel@laptop>  <20100114162609.GC3487@Krystal>
	 <1263919667.4283.732.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 19 Jan 2010 12:30:38 -0500
Message-ID: <1263922238.31321.14.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 17:47 +0100, Peter Zijlstra wrote:
> On Thu, 2010-01-14 at 11:26 -0500, Mathieu Desnoyers wrote:

> > It's this scenario that is causing problem. Let's consider this
> > execution:
> > 
> >        CPU 0 (membarrier)                  CPU 1 (another mm -> our mm)
> >        <kernel-space>                      <kernel-space>
> >                                            switch_mm()
> >                                              smp_mb()
> >                                              clear_mm_cpumask()
> >                                              set_mm_cpumask()
> >                                              smp_mb() (by load_cr3() on x86)
> >                                            switch_to()
> >        mm_cpumask includes CPU 1
> >        rcu_read_lock()
> >        if (CPU 1 mm != our mm)
> >          skip CPU 1.
> >        rcu_read_unlock()
> >                                              current = next (1)
> 
> OK, so on x86 current uses esp and will be flipped somewhere in the
> switch_to() magic, cpu_curr(cpu) as used by CPU 0 uses rq->curr, which
> will be set before context_switch() and that always implies a mb() for
> non matching ->mm's [*]


This explanation by Mathieu still does not show the issue. He finally
explained it correctly here:

 http://lkml.org/lkml/2010/1/14/319

The issue is before switch_to. If the read side reads in a pointer but
gets preempted and goes to the kernel, and the kernel updates next
(before the switch_to), and the write side does sys_membarrier(), the:

if (cpu_curr(1)->mm != our mm)

will fail, so no memory barrier will happen yet.

Then the userspace side of the writer will free or change the data, but
the reader side read is still stuck in the bus (still before the
switch_to). Then the reader can get a bad pointer.

Here's a simple explanation:

	CPU 0				CPU 1
      ----------		     -----------
	<userspace>			<userspace>
	obj = get_obj();
					rcu_read_lock();
					obj = get_obj(); <load of obj>
					<obj still being retrieved from memory>
					<interrupt, schedule out>
					<kernelspace>
					rq->curr = next;
					<bus stall>
					<obj still in memory>

	sys_membarrier();
	<kernel space>
	if (curr_cpu(1)->mm != mm) <-- false
	<userspace>

	modify object

					switch_to()
					<obj finally is loaded>
					<schedule kernel thread>
					<schedule task back>
					<userspace>
					refer(obj) <-- corruption!

	
					

> 
> >                                            <switch back to user-space>
> >                                            read-lock()
> >                                              read gp, store local gp
> >                                              barrier()
> >                                              access critical section (2)
> > 
> > So if we don't have any memory barrier between (1) and (2), the memory
> > operations can be reordered in such a way that CPU 0 will not send IPI
> > to a CPU that would need to have it's barrier() promoted into a
> > smp_mb().
> 
> OK, so I'm utterly failing to make sense of the above, do you need more
> than the 2 cpus discussed to make it go boom?

Just 2 cpu's as explained above.

> 
> > Replacing these kernel rcu_read_lock/unlock() by rq locks ensures that
> > when the scheduler runs concurrently on another CPU, _all_ the scheduling
> > code is executed atomically wrt the spin lock taken on cpu 0.
> 
> Sure, but taking the rq->lock is fairly heavy handed.

Yes, but for now it seems to be the only safe way.

> 
> > When x86 uses iret to return to user-space, then we have a serializing
> > instruction. But if it uses sysexit, or if we are on a different
> > architecture, are we sure that a memory barrier is issued before
> > returning to user-space ?
> 
> [*] and possibly also for matching ->mm's, because:
> 
> OK, so I had a quick look at the switch_to() magic, and from what I can
> make of it it implies an mb, if only because poking at the segment
> registers implies LOCK semantics.

The problem is that this issue can be caused before we get to
switch_to().

-- Steve


