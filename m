Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978Ab0AKEfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab0AKEfc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 23:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808Ab0AKEfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 23:35:31 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:39709 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751451Ab0AKEfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 23:35:25 -0500
Date: Sun, 10 Jan 2010 23:25:21 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100111042521.GB32213@Krystal>
References: <1263079000.28171.3795.camel@gandalf.stny.rr.com> <20100110000318.GD9044@linux.vnet.ibm.com> <1263084099.2231.5.camel@frodo> <20100110014456.GG25790@Krystal> <1263089578.2231.22.camel@frodo> <20100110052508.GG9044@linux.vnet.ibm.com> <1263124209.28171.3798.camel@gandalf.stny.rr.com> <20100110174512.GH9044@linux.vnet.ibm.com> <20100110182423.GA22821@Krystal> <20100111011705.GJ9044@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100111011705.GJ9044@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 22:13:29 up 25 days, 11:31,  4 users,  load average: 0.14, 0.15,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
[...]
> > Even when taking the spinlocks, efficient iteration on active threads is
> > done with for_each_cpu(cpu, mm_cpumask(current->mm)), which depends on
> > the same cpumask, and thus requires the same memory barriers around the
> > updates.
> 
> Ouch!!!  Good point and good catch!!!
> 
> > We could switch to an inefficient iteration on all online CPUs instead,
> > and check read runqueue ->mm with the spinlock held. Is that what you
> > propose ? This will cause reading of large amounts of runqueue
> > information, especially on large systems running few threads. The other
> > way around is to iterate on all the process threads: in this case, small
> > systems running many threads will have to read information about many
> > inactive threads, which is not much better.
> 
> I am not all that worried about exactly what we do as long as it is
> pretty obviously correct.  We can then improve performance when and as
> the need arises.  We might need to use any of the strategies you
> propose, or perhaps even choose among them depending on the number of
> threads in the process, the number of CPUs, and so forth.  (I hope not,
> but...)
> 
> My guess is that an obviously correct approach would work well for a
> slowpath.  If someone later runs into performance problems, we can fix
> them with the added knowledge of what they are trying to do.
> 

OK, here is what I propose. Let's choose between two implementations
(v3a and v3b), which implement two "obviously correct" approaches. In
summary:

* baseline (based on 2.6.32.2)
   text	   data	    bss	    dec	    hex	filename
  76887	   8782	   2044	  87713	  156a1	kernel/sched.o

* v3a: ipi to many using mm_cpumask

- adds smp_mb__before_clear_bit()/smp_mb__after_clear_bit() before and
  after mm_cpumask stores in context_switch(). They are only executed
  when oldmm and mm are different. (it's my turn to hide behind an
  appropriately-sized boulder for touching the scheduler). ;) Note that
  it's not that bad, as these barriers turn into simple compiler barrier()
  on:
    avr32, blackfin, cris, frb, h8300, m32r, m68k, mn10300, score, sh,
    sparc, x86 and xtensa.
  The less lucky architectures gaining two smp_mb() are:
    alpha, arm, ia64, mips, parisc, powerpc and s390.
  ia64 is gaining only one smp_mb() thanks to its acquire semantic.
- size
   text	   data	    bss	    dec	    hex	filename
  77239	   8782	   2044	  88065	  15801	kernel/sched.o
  -> adds 352 bytes of text
- Number of lines (system call source code, w/o comments) : 18

* v3b: iteration on min(num_online_cpus(), nr threads in the process),
  taking runqueue spinlocks, allocating a cpumask, ipi to many to the
  cpumask. Does not allocate the cpumask if only a single IPI is needed.

- only adds sys_membarrier() and related functions.
- size
   text	   data	    bss	    dec	    hex	filename
  78047	   8782	   2044	  88873	  15b29	kernel/sched.o
  -> adds 1160 bytes of text
- Number of lines (system call source code, w/o comments) : 163

I'll reply to this email with the two implementations. Comments are
welcome.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
