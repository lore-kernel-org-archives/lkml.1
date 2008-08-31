Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYHaRUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYHaRUW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 13:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYHaRUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 13:20:10 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40322 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbYHaRUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 13:20:07 -0400
Date: Sun, 31 Aug 2008 10:20:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, rostedt@goodmis.org,
       peterz@infradead.org, benh@kernel.crashing.org, davem@davemloft.net,
       tony.luck@intel.com
Subject: Re: [PATCH, RFC, tip/core/rcu] v3 scalable classic RCU
	implementation
Message-ID: <20080831172001.GA7015@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <48B919C2.1040809@cn.fujitsu.com> <48B94BF4.9090103@colorfullife.com> <20080830143438.GF7107@linux.vnet.ibm.com> <48BA7944.8070402@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BA7944.8070402@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 12:58:12PM +0200, Manfred Spraul wrote:
> Paul E. McKenney wrote:
>>
>>> Perhaps it's possible to rely on CPU_DYING, but I haven't figured out yet 
>>> how to handle read-side critical sections in CPU_DYING handlers.
>>> Interrupts after CPU_DYING could be handled by rcu_irq_enter(), 
>>> rcu_irq_exit() [yes, they exist on x86: the arch code enables the local 
>>> interrupts in order to process the currently queued interrupts]
>>>     
>>
>> My feeling is that CPU online/offline will be quite rare, so it should
>> be OK to clean up after the races in force_quiescent_state(), which in
>> this version is called every three ticks in a given grace period.
>>   
> If you add failing cpu offline calls, then the problem appears to be 
> unsolvable:
> If I get it right, the offlining process looks like this:
> * one cpu in the system makes the CPU_DOWN_PREPARE notifier call. These 
> calls can sleep (e.g. slab sleeps on semaphores). The cpu that goes offline 
> is still alive, still doing arbitrary work. cpu_quiet calls on behalf of 
> the cpu would be wrong.
> * stop_machine: all cpus schedule to a special kernel thread [1], only the 
> dying cpu runs.
> * The cpu that goes offline calls the CPU_DYING notifiers.
> * __cpu_disable(): The cpu that goes offline check if it's possible to 
> offline the cpu. At least on i386, this can fail.
> On success:
> * at least on i386: the cpu that goes offline handles outstanding 
> interrupts. I'm not sure, perhaps even softirqs are handled.
> * the cpus stopps handling interrupts.
> * stop machine leaves, the remaining cpus continue their work.

As I understand it, this is the point where the dying CPU disables
interrupts and removes itself from the online masks.  Though I would
feel better if there was an smp_mb() after the last local_irq_disable()
and before the remove_cpu_from_maps()!

> * The CPU_DEAD notifiers are called. They can sleep.
> On failure:
> * all cpus continue their work. call_rcu, synchronize_rcu(), ...
> * some time later: the CPU_DOWN_FAILED callbacks are called.
>
> Is that description correct?

Gautham?

> Then:
> - treating a cpu as always quiet after the rcu notifer was called with 
> CPU_OFFLINE_PREPARE is wrong: the target cpu still runs normal code: user 
> space, kernel space, interrupts, whatever. The target cpu still accepts 
> interrupst, thus treating it as "normal" should work.

Indeed!  My current code doesn't declare them offline until the CPU_DEAD
notifiers are called.  And force_quiescent_state() does not consider
them to be offline until after they have cleared their bit in
cpu_online_map, which does not happen until the outgoing CPU has
disabled interrupts, at least in x86.  So my current code should be
OK on x86.

It -looks- like stop_cpu() expects to be called with irqs disabled,
but I don't see what would be disabling irqs.  (Don't kthreads normally
start with irqs enabled?)  Ah, I see it -- the stop_cpu() threads
sequence through a state machine, and one of the states disables
irqs for everyone.

So the only problem would occur in architectures that re-enable irqs
in the middle of __cpu_disable(), as x86 does (but x86 correctly orders
the clearing of the cpu_online_mask bit, so is OK).  This of course
has the added benefit that irq handlers aren't running on a CPU that
is marked offline.

Checking other architectures:

o	ARM arch/arm/kernel/smp.c __cpu_disable() does not re-enable
	irqs, so is OK.

!	arch/ia64/kernel/smpboot.c __cpu_disable() clears itself
	from the cpu_online mask before flushing pending irqs, which
	might include RCU read-side critical sections.	I believe that
	the "cpu_clear(cpu, cpu_online_map)" must move to after the
	"fixup_irqs()".

o	arch/powerpc/kernel/smp.c __cpu_disable() does not disable
	irqs directly, but calls subarch-specific functions noted
	below.

o	arch/powerpc/platforms/powermac/smp.c smp_core99_cpu_disable()
	does not appear to re-enable irqs, so should be OK.

!	arch/powerpc/kernel/smp.c generic_cpu_disable() clears itself
	from the cpu_online_mask before invoking fixup_irqs(), which
	momentarily enables irqs.  I believe that the  "cpu_clear(cpu,
	cpu_online_map)" must move to after the "fixup_irqs()".

?	arch/powerpc/platforms/pseries/hotplug-cpu.c pseries_cpu_disable()
	clears itself from the cpu_online_mask before calling
	xics_migrate_irqs_away().  This function rejects already-pending
	irqs, then redirects future irqs.  Not clear to me what happens
	if an irq arrives between the reject and the immediately
	following removal from the global interrupt queue.

o	arch/s390/kernel/smp.c __cpu_disable() does not reenable irqs
	so is OK.

!	arch/sparc64/kernel/smp.c __cpu_disable() clears its bit before
	re-enabling interrupts.  I believe that the "cpu_clear(cpu,
	cpu_online_map)" needs to happen after the local_irq_disable().

?	include/asm-parisc/smp.h __cpu_disable() just returns without
	doing anything.  This means pa-risc does not support hotplug
	CPU?  If so, no problem.

I am sending (untested) patches separately for the amusement of the
arch maintainers.

> __cpu_disable() success:
> - after CPU_DYING, a cpu is either in an interrupt or outside read-side 
> critical sections. Parallel synchronize_rcu() calls are impossible until 
> the cpu is dead. call_rcu() is probably possible.
> - The CPU_DEAD notifiers are called. a synchronize_rcu() call before the 
> rcu notifier is called is possible.
> __cpu_disable() failure:
> - CPU_DYING is called, but the cpu remains fully alive. The system comes 
> fully alive again.
> - some time later, CPU_DEAD is called.
>
> With the current CPU_DYING callback, it's impossible to be both 
> deadlock-free and race-free with the given conditions. If __cpu_disable() 
> succeeds, then the cpu must be treated as gone and always idle. If 
> __cpu_disable() fails, then the cpu must be treated as fully there. Doing 
> both things at the same time is impossible. Waiting until CPU_DOWN_FAILED 
> or CPU_DEAD is called is impossible, too: Either synchronize_rcu() in a 
> CPU_DEAD notifier [called before the rcu notifier] would deadlock or 
> read-side critical sections on the not-killed cpu would race.

Assuming that the ordering of processing pending irqs and marking the
CPU offline in cpu_online_mask can be resolved as noted above, it should
work fine -- if a CPU's bit is clear, we can safely ignore it.  The race
can be resolved by checking the CPU's bit in force_quiescent_state().

Or am I missing something?

> What about moving the CPU_DYING notifier calls behind the __cpu_disable() 
> call?
> Any other solutions?

RCU should ignore the CPU_DYING notifier calls -- only the CPU_DEAD.*
calls should be processed for CPUs being offlined.  Right?

> Btw, as far as I can see, rcupreempt would deadlock if a CPU_DEAD notifier 
> uses synchronize_rcu().
> Probably noone will ever succeed in triggering the deadlock:
> - cpu goes offline.
> - the other cpus in the system are restarted.
> - one cpu does the CPU_DEAD notifier calls.
> - before the rcu notifier is called with CPU_DEAD:
> - one CPU_DEAD notifier sleeps.
> - while CPU_DEAD is sleeping: on the same cpu: kmem_cache_destroy is 
> called. get_online_cpus immediately succeeds.
> - kmem_cache_destroy acquires the cache_chain_mutex.
> - kmem_cache_destroy does synchronize_rcu(), it sleeps.
> - CPU_DEAD processing continues, the slab CPU_DEAD tries to acquire the 
> cache_chain_mutex. it sleeps, too.
> --> deadlock, because the already dead cpu will never signal itself as 
> quiet. Thus synchronize_rcu() will never succeed, thus the slab CPU_DEAD 
> notifier will never return, thus rcu_offline_cpu() is never called.

It is entirely possible that rcu_try_flip_waitack() and
rcu_try_flip_waitmb() need to check the AND of rcu_cpu_online_map and
cpu_online_map.  If this really is a problem (and it might well be),
then the easiest fix is to check for cpu_is_offline(cpu) in both
rcu_try_flip_waitmb_needed() and rcu_try_flip_waitack_needed(), and
that in both versions of both functions.  Thoughts?

> --
>    Manfred
> [1] open question: with rcu_preempt, is it possible that these cpus could 
> be inside read side critical sections?

Yes, they could.  Well, tasks that were previously running on them
might be preempted or blocked waiting on locks while still in RCU
read-side critical sections.  However, when a given CPU goes offline,
rcu_preempt moves that CPU's counters to some surviving CPU.  So RCU
knows that these tasks are still in RCU read-side critical sections,
and will therefore wait for them.

							Thanx, Paul
