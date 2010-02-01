Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab0BARpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:45:05 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:43071 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab0BARpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:45:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAB6fZktGHnlj/2dsb2JhbACBM9lfhEUE
Date: Mon, 1 Feb 2010 12:45:00 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task
	switch at runqueue lock/unlock
Message-ID: <20100201174500.GA13744@Krystal>
References: <20100131205254.407214951@polymtl.ca> <20100131210013.446503342@polymtl.ca> <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain> <20100201160929.GA3032@Krystal> <alpine.LFD.2.00.1002010816030.4206@localhost.localdomain> <20100201164856.GA3486@Krystal> <alpine.LFD.2.00.1002010854110.4206@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002010854110.4206@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:02:33 up 47 days,  1:21,  5 users,  load average: 0.48, 0.35,
	0.24
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Mon, 1 Feb 2010, Mathieu Desnoyers wrote:
> > 
> > What we have to be careful about here is that it's not enough to just
> > rely on switch_mm() containing a memory barrier. What we really need to
> > enforce is that switch_mm() issues memory barriers both _before_ and
> > _after_ mm_cpumask modification. The "after" part is usually dealt with
> > by the TLB context switch, but the "before" part usually isn't.
> 
> Ok, whatever. I vote for not doing anything at all, because this just all 
> sounds like some totally crazy crap. You haven't explained the actual 
> races, you haven't explained anything at all, you're apparently just 
> randomly sprinkling smp_mb's around until you think it's all fine.
> 
> Show the actual memory ordering constraints as it is related to the kernel 
> data structures. I'm totally uninterested in general handwaving and "we 
> must have smp_mb's here and here" without very explicit explanations of 
> exactly WHAT the memory orderings are.

It's probably worthwhile to summarize here the mb-related discussions we
had in the previous RFC rounds.

Here is the detailed execution scenario showing the race. The race with
unlock showing that we need to order user-space loads before mm_cpumask
store. This is showing an execution sequence involving the userspace RCU
library and the Linux kernel with sys_membarrier(). As we see below, the
lack of ordering between "cpumask_clear" and user-space execution
creates a race with the scheduler where sys_membarrier() incorrectly
considers CPU 1 as not needing a membarrier_ipi.


        CPU 0                   CPU 1
        --------------          --------------
        <user space>            <user space> (already in read-side C.S.)
                                obj = rcu_dereference(list->next);
                                  -> load list->next
                                copy = obj->foo;
                                rcu_read_unlock();
                                  -> store to urcu_reader.ctr
                                <urcu_reader.ctr store is globally visible>
        list_del(obj);
                                <preempt>
                                <kernel space>

                                schedule();
                                cpumask_clear(mm_cpumask, cpu);

        sys_membarrier();
          <kernel space>
          smp_mb()
          iterates on mm_cpumask
          smp_mb()
        <user space>
        set global g.p. (urcu_gp_ctr) phase to 1
        wait for all urcu_reader.ctr in phase 0
        set global g.p. (urcu_gp_ctr) phase to 0
        wait for all urcu_reader.ctr in phase 1
        sys_membarrier();
          <kernel space>
          smp_mb()
          iterates on mm_cpumask
          smp_mb()
        <user space>
        free(obj);
                                <list->next load hits memory>
                                <obj->foo load hits memory> <- corruption


There is a similar race scenario (symmetric to the one above) between
cpumask_set and a following user-space rcu_read_lock(), which I could
provide upon request.

This results in the following comments around smp_mb() in
sys_membarrier:

First sys_membarrier smp_mb():

        /*
         * Memory barrier on the caller thread before sending first
         * IPI. Orders all memory accesses prior to sys_membarrier() before
         * mm_cpumask read and membarrier_ipi executions.
         * Matches memory barriers before and after mm_cpumask updates.
         */

Second sys_membarrier smp_mb():

        /*
         * Memory barrier on the caller thread after we finished
         * waiting for the last IPI. Orders mm_cpumask read and membarrier_ipi
         * executions before memory accesses following sys_membarrier()
         * execution.
         * Matches memory barriers before and after mm_cpumask updates.
         */

Thanks,

Mathieu


> 
> 		Linus

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
