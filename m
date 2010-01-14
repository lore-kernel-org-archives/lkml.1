Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530Ab0ANTeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab0ANTeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 14:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826Ab0ANTeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 14:34:01 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:58712 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753496Ab0ANTeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 14:34:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAEv/TkuuWOiG/2dsb2JhbACBRdc3hDAE
Date: Thu, 14 Jan 2010 14:33:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v5)
Message-ID: <20100114193355.GA23436@Krystal>
References: <20100113013757.GA29314@Krystal> <1263400738.4244.242.camel@laptop> <20100113193603.GA27327@Krystal> <1263460096.4244.282.camel@laptop> <20100114162609.GC3487@Krystal> <1263488625.4244.333.camel@laptop> <20100114175449.GA15387@Krystal> <20100114183739.GA18435@Krystal> <1263495132.28171.3861.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1263495132.28171.3861.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:09:25 up 29 days,  3:27,  5 users,  load average: 0.14, 0.11,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2010-01-14 at 13:37 -0500, Mathieu Desnoyers wrote:
> 
> > To make this painfully clear, I'll reorder the accesses to match that of
> > the CPU to memory:
> > 
> >        CPU 0 (membarrier)                  CPU 1 (another mm -our mm)
> >        <user-space>
> >                                            <kernel-space>
> >                                            switch_mm()
> >                                              smp_mb()
> >                                              clear_mm_cpumask()
> >                                              set_mm_cpumask()
> >                                              smp_mb() (by load_cr3() on x86)
> >                                            switch_to()
> >                                              <buffered current = next>
> >                                            <switch back to user-space>
> >                                            urcu read lock()
> >                                              access critical section data (3)
> >        memory access before membarrier
> >        <call sys_membarrier()>
> >        smp_mb()
> >        mm_cpumask includes CPU 1
> >        rcu_read_lock()
> >        if (CPU 1 mm != our mm)
> >          skip CPU 1.
> 
> I still don't see how the above conditional fails?

First, I just want to fix one detail I had wrong. It does not change the
end result, but it changes the order of the scenario:

  A cpu "current" task struct is not the same thing as that same CPU
rq->curr. So we are talking about the rq->curr update here, not the cpu
"current" task (as I mistakenly assumed previously).

   if (CPU 1 mm != our mm) translates into:

   if (cpu_curr(1)->mm != current->mm)

where cpu_curr(cpu) is:

#define cpu_rq(cpu)             (&per_cpu(runqueues, (cpu)))
#define cpu_curr(cpu)           (cpu_rq(cpu)->curr)

struct rq "curr" field is a struct task_struct *, updated by
schedule() before calling context_switch().

So the requirement is that we need a smp_mb() before and after rq->curr
update in schedule(). The smp_mb() after the update is ensured by
context_switch() -> switch_mm() -> load_cr3(). However, updating my
scenario to match the fact that we are really talking about rq->curr
update here (which happens _before_ switch_mm() and not after), we can
see that the problematic case happens if there is no smp_mb() before
rq->curr update:

It's a case where CPU 1 switches from our mm to another mm:

       CPU 0 (membarrier)                  CPU 1 (another mm -our mm)
       <user-space>                        <user-space>
                                           <buffered access C.S. data>
                                           urcu read unlock()
                                             barrier()
                                             store local gp
                                           <kernel-space>
                                           rq->curr = next (1)
       memory access before membarrier
       <call sys_membarrier()>
       smp_mb()
       mm_cpumask includes CPU 1
       rcu_read_lock()
       if (cpu_curr(1)->mm != our mm)
         skip CPU 1     -> here, rq->curr new version is already visible
       rcu_read_unlock()
       smp_mb()
       <return to user-space>
       memory access after membarrier
       -> this is where we allow freeing
          the old structure although the
          buffered access C.S. data is
          still in flight.
                                           User-space access C.S. data (2)
                                             (buffer flush)
                                           switch_mm()
                                             smp_mb()
                                             clear_mm_cpumask()
                                             set_mm_cpumask()
                                             smp_mb() (by load_cr3() on x86)
                                           switch_to()
                                             <buffered current = next>
                                           <switch back to user-space>
                                             current = next (1) (buffer flush)
                                           access critical section data (3)

As we can see, the reordering of (1) and (2) is problematic, as it lets
the check skip over a CPU that have global side-effects not committed to
memory yet.

Hopefully this explanation helps ?

Thanks,

Mathieu

> 
> -- Steve
> 
> >        rcu_read_unlock()
> >        smp_mb()
> >        <return to user-space>
> >        memory access after membarrier
> >                                              current = next (1) (buffer flush)
> >                                              read gp
> >                                              store local gp (2)
> > 
> > This should make the problem a bit more evident. Access (3) is done
> > outside of the read-side C.S. as far as the userspace synchronize_rcu()
> > is concerned.
> > 
> > Thanks,
> > 
> > Mathieu
> > 
> > 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
