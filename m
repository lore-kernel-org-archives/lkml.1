Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231Ab0AMTgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab0AMTgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 14:36:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281Ab0AMTgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 14:36:06 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:46306 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752629Ab0AMTgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 14:36:05 -0500
Date: Wed, 13 Jan 2010 14:36:03 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v5)
Message-ID: <20100113193603.GA27327@Krystal>
References: <20100113013757.GA29314@Krystal> <1263400738.4244.242.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1263400738.4244.242.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:24:03 up 28 days,  3:42,  4 users,  load average: 0.11, 0.14,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2010-01-12 at 20:37 -0500, Mathieu Desnoyers wrote:
> > +       for_each_cpu(cpu, tmpmask) {
> > +               spin_lock_irq(&cpu_rq(cpu)->lock);
> > +               mm = cpu_curr(cpu)->mm;
> > +               spin_unlock_irq(&cpu_rq(cpu)->lock);
> > +               if (current->mm != mm)
> > +                       cpumask_clear_cpu(cpu, tmpmask);
> > +       } 
> 
> Why not:
> 
>   rcu_read_lock();
>   if (current->mm != cpu_curr(cpu)->mm)
>     cpumask_clear_cpu(cpu, tmpmask);
>   rcu_read_unlock();
> 
> the RCU read lock ensures the task_struct obtained remains valid, and it
> avoids taking the rq->lock.
> 

If we go for a simple rcu_read_lock, I think that we need a smp_mb()
after switch_to() updates the current task on the remote CPU, before it
returns to user-space. Do we have this guarantee for all architectures ?

So what I'm looking for, overall, is:

schedule()
  ...
  switch_mm()
    smp_mb()
    clear mm_cpumask
    set mm_cpumask
  switch_to()
    update current task
    smp_mb()

If we have that, then the rcu_read_lock should work.

What the rq lock currently gives us is the guarantee that if the current
thread changes on a remote CPU while we are not holding this lock, then
a full scheduler execution is performed, which implies a memory barrier
if we change the current thread (it does, right ?).

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
