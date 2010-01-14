Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613Ab0ANJJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab0ANJJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 04:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756589Ab0ANJJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 04:09:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:47102 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab0ANJJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 04:09:07 -0500
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
In-Reply-To: <20100113193603.GA27327@Krystal>
References: <20100113013757.GA29314@Krystal>
	 <1263400738.4244.242.camel@laptop>  <20100113193603.GA27327@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 10:08:16 +0100
Message-ID: <1263460096.4244.282.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 14:36 -0500, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Tue, 2010-01-12 at 20:37 -0500, Mathieu Desnoyers wrote:
> > > +       for_each_cpu(cpu, tmpmask) {
> > > +               spin_lock_irq(&cpu_rq(cpu)->lock);
> > > +               mm = cpu_curr(cpu)->mm;
> > > +               spin_unlock_irq(&cpu_rq(cpu)->lock);
> > > +               if (current->mm != mm)
> > > +                       cpumask_clear_cpu(cpu, tmpmask);
> > > +       } 
> > 
> > Why not:
> > 
> >   rcu_read_lock();
> >   if (current->mm != cpu_curr(cpu)->mm)
> >     cpumask_clear_cpu(cpu, tmpmask);
> >   rcu_read_unlock();
> > 
> > the RCU read lock ensures the task_struct obtained remains valid, and it
> > avoids taking the rq->lock.
> > 
> 
> If we go for a simple rcu_read_lock, I think that we need a smp_mb()
> after switch_to() updates the current task on the remote CPU, before it
> returns to user-space. Do we have this guarantee for all architectures ?
> 
> So what I'm looking for, overall, is:
> 
> schedule()
>   ...
>   switch_mm()
>     smp_mb()
>     clear mm_cpumask
>     set mm_cpumask
>   switch_to()
>     update current task
>     smp_mb()
> 
> If we have that, then the rcu_read_lock should work.
> 
> What the rq lock currently gives us is the guarantee that if the current
> thread changes on a remote CPU while we are not holding this lock, then
> a full scheduler execution is performed, which implies a memory barrier
> if we change the current thread (it does, right ?).

I'm not quite seeing it, we have 4 possibilities, switches between
threads with:

 a) our mm, another mm

   - if we observe the former, we'll send an IPI (redundant)
   - if we observe the latter, the switch_mm will have issued an mb

 b) another mm, our mm

   - if we observe the former, we're good because the cpu didn't run our
     thread when we called sys_membarrier()
   - if we observe the latter, we'll send an IPI (redundant)

 c) our mm, our mm

   - no matter which task we observe, we'll match and send an IPI

 d) another mm, another mm

   - no matter which task we observe, we'll not match and not send an
     IPI.


Or am I missing something?

