Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbYHGQJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbYHGQJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbYHGQJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:09:13 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:57895 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331AbYHGQJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:09:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMEAOS0mkhMRKxB/2dsb2JhbACBWKs8
Date: Thu, 7 Aug 2008 12:09:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       akpm@linux-foundation.org, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: LTTng finds abnormally long APIC interrupt handler : 58.2 ms
Message-ID: <20080807160907.GA11255@Krystal>
References: <20080805182007.GA4631@Krystal> <alpine.DEB.1.10.0808051523370.28170@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808051523370.28170@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:59:33 up 63 days, 18:40,  7 users,  load average: 0.71, 0.89,
	1.20
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Tue, 5 Aug 2008, Mathieu Desnoyers wrote:
> 
> > Hi,
> > 
> > I would like to bring an interesting kernel latency issue I am
> > experiencing.
> > 
> > A trace taken with LTTng on a x86_64 dual quad-core, Linux kernel
> > 2.6.26.1, shows that IRQ 239 handler (LOCAL_TIMER_VECTOR ->
> > smp_apic_timer_interrupt) runs for about 58.2 ms on 2 of the 8 cores,
> > and a bit later on the other 6. It can be repeated by taking a trace
> > shortly after boot : it happens at about 120 seconds after the cycle
> > counters has been reset.
> > 
> > The execution trace of one interrupt handler is (edited for clarity) :
> 
> Mathieu,
> 
> Have you tried using ftrace to see what functions are being called here?
> 

Hi Steve,

Yes, I have just made an integration module between LTTng and ftrace and
I must say it's very powerful :)

Basically, I have the ability, from userspace, to connect special LTTng
probes which start/stop function tracing. In the present case, I hook
start function tracing on the kernel_softirq_raise marker and the stop
function tracing on every other events (to make sure other starts will
stop quickly without letting function tracing enabled too long).

I have two modes : The first one can enable tracing for the local CPU,
to know the function call sequence between marker A and B. However, I
noticed that this specific problem involves a spin lock shared with
other processors. Therefore, I need to trace the whole system for that
time period. I do that by keeping a per-cpu "one-hot bit" which detects
the interest for any CPU for function tracing, and I atomically xchg
this value with 1 or 0, and when I detect change between 0 and 1 (or
reverse), I increment/decrement a system-wide read-mostly function
tracing active variable.

It all holds in a small module. Having the ability to connect any marker
on any generic probe from the lttng marker interface has been very
useful to do all this. Actually, this module has to be built into the
kernel because ftrace does not permit breeing the trace_ops data
structure. :/

Since it was linked to locks, I also integrated lockdep acquire/release
markers to the same live enabling mechanism.

I see the same long interrupt issue on 2.6.27-rc2, to which I had to
port LTTng to get ftrace.

In the following trace, CPU 4 experiences the 60ms irq handler. I
narrowed down the code region on this CPU to : (note : any idea to
automatically turn addresses into symbols, either in text
post-processing or integrated into the LTTV analyzer, to do like
ksymoops, is welcome. Is there any specific library I should use ?)

Last event before the delay on CPU 4 :

locking_lock_acquire: 143.974542821 (/tmp/traceirq7/cpu_4), 0, 0,
  swapper, , 0, 0x0, IRQ
  { retaddr = 0xFFFFFFFF80259681 <lock_hrtimer_base+0x31>,
    subclass = 0, lock = 0xffff880028176c38 , trylock = 0 }

(note : "lock" is the address of the struct lockdep_map, is that a
unique lock identifier as I assume, or is it a pointer to a lock "class" ?)

    spin_lock_irqsave(&base->cpu_base->lock, *flags);

next event on cpu_4 :

ftrace_entry: 144.034294878 (/tmp/traceirq7/cpu_4), 0, 0,
  swapper, , 0, 0x0, IRQ
  { ip = 0xFFFFFFFF802595EC <remove_hrtimer+0x1c>,
    parent_ip = 0xFFFFFFFF802597D0 <hrtimer_start+0x40> }

So, what my researchs point me to is the base->cpu_base->lock being
contended for 60 ms. More to come about the events surrounding this area
on other CPUs.

Therefore, I dump the trace for all the lock events linked to the
0xffff880028176c38 lock for the time period around the contention. I get
the following event for lock release on CPU 4. I have put the previous
lock release from CPU 2 occurring just before. Actually, I see that CPU
2 takes and releases this lock many times while cpu 4 contends for it (15
acquire/release cycles).

locking_lock_release: 144.030594439 (/tmp/traceirq7/cpu_2), 0, 0,
  swapper, , 0, 0x0, SOFTIRQ
  { retaddr = 0xFFFFFFFF802595B8 <hrtimer_run_pending+0xc8>,
    lock = 0xffff880028176c38, nested = 1 }
locking_lock_release: 144.034296600 (/tmp/traceirq7/cpu_4), 0, 0,
  swapper, , 0, 0x0, IRQ
  { retaddr = 0xFFFFFFFF80258FD0 <switch_hrtimer_base+0x70>,
    lock = 0xffff880028176c38, nested = 1 }

CPU 2 acquire/release cycles are identical :

locking_lock_acquire: 143.954580205 (/tmp/traceirq7/cpu_2), 0, 0,
  swapper, , 0, 0x0, SOFTIRQ
  { retaddr = 0xFFFFFFFF80259532 <hrtimer_run_pending+0x42>,
    subclass = 0, lock = 0xffff880028176c38, trylock = 0 }
locking_lock_release: 143.954581990 (/tmp/traceirq7/cpu_2), 0, 0,
  swapper, , 0, 0x0, SOFTIRQ
  { retaddr = 0xFFFFFFFF802595B8 <hrtimer_run_pending+0xc8>,
    lock = 0xffff880028176c38, nested = 1 }

It therefore seems that 

run_hrtimer_pending() iterates on 15 cpu_base->cb_pending callbacks,
which takes a while. Note that the fact that the cpu_base->lock is
released between each callback does not seem to give the control back to
the contended CPU 4 probably because it runs udelay, given that spinlock
debugging options are enabled.

So let's see which functions CPU 2 is calling during the CPU 4
contention period :

here is how I did it :
./lttv -m textDump -t /tmp/traceirq7 \
  -e "event.time>=143.974542821&event.time<=144.034296600&state.cpu=2& \
  (event.name=locking_lock_acquire|event.name=locking_lock_release| \
  event.name=ftrace_entry)"

The output, rather long, shows the functions called with the spinlock
held. I made it available at the following address along with the kernel
config (for 2.6.27-rc2) and the vmlinux image (to resolve the symbols)
http://ltt.polymtl.ca/~compudj/60msdebug2/

In the end, it seems that having a delay in __spin_lock_debug with
CONFIG_DEBUG_SPINLOCK configs behaves badly when a lock is taken
repeatedly; it behaves as if the spinlock is contended without being
released, which can cause long contention periods affecting, amongst
others, interrupt handlers. Given the TSC are synchronized on this
computer, the responsible for such long delays between spinlock loops
seems to be arch/x86/lib/delay.c:delay_tsc().

Maybe adding some fairness to debug spinlock code would be welcome ?

Mathieu


> -- Steve
> 
> > 
> > Format :
> > event name: timestamp
> >   pid, tgid, process name, execution mode
> >   { event data }
> > 
> > kernel_irq_entry: 121.733399510
> >   0, 0, swapper, IRQ
> >   { irq_id = 239, kernel_mode = 1, ip = 0xFFFFFFFF80213936 }
> > kernel_softirq_raise: 121.733400143
> >   0, 0, swapper, IRQ
> >   { softirq_id = 1 [run_timer_softirq+0x0/0x230] }
> > 
> > (takes a while : 58.2 ms)
> > 
> > kernel_sched_try_wakeup: 121.791694536
> >   0, 0, swapper, IRQ
> >   { pid = 8, state = 1 }
> > kernel_softirq_raise: 121.791696762
> >   0, 0, swapper, IRQ
> >   { softirq_id = 6 [run_rebalance_domains+0x0/0x6e0] }
> > kernel_irq_exit: 121.791697692
> >   0, 0, swapper, SYSCALL
> >   { handled = 1 }
> > 
> > Where pid = 8  is kernel thread watchdog/1
> > 
> > The same trace happens on the other CPUs which also have a long
> > interrupt handler. The surroundings of the problem points out to
> > run_local_timers(), which is the function responsible for raising the
> > TIMER_SOFTIRQ. (which is the last event that occurs on the system for a
> > while). It could also be the caller : update_process_times(), any
> > function called from update_process_times() after the run_local_timers()
> > call or actually any function executing between the "raise" and the "try
> > wakeup" events.
> > 
> > The kernel config is attached below, so is the dmesg.
> > 
> > Any idea regarding what is happening here ?
> > 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
