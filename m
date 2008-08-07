Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYHGRlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYHGRlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYHGRlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:41:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44047 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYHGRlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:41:12 -0400
Date: Thu, 7 Aug 2008 13:41:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       akpm@linux-foundation.org, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: LTTng finds abnormally long APIC interrupt handler : 58.2 ms
In-Reply-To: <20080807160907.GA11255@Krystal>
Message-ID: <alpine.DEB.1.10.0808071314320.20931@gandalf.stny.rr.com>
References: <20080805182007.GA4631@Krystal> <alpine.DEB.1.10.0808051523370.28170@gandalf.stny.rr.com> <20080807160907.GA11255@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Aug 2008, Mathieu Desnoyers wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> Hi Steve,
> 
> Yes, I have just made an integration module between LTTng and ftrace and
> I must say it's very powerful :)

Cool!

> 
> Basically, I have the ability, from userspace, to connect special LTTng
> probes which start/stop function tracing. In the present case, I hook
> start function tracing on the kernel_softirq_raise marker and the stop
> function tracing on every other events (to make sure other starts will
> stop quickly without letting function tracing enabled too long).
> 
> I have two modes : The first one can enable tracing for the local CPU,
> to know the function call sequence between marker A and B. However, I
> noticed that this specific problem involves a spin lock shared with
> other processors. Therefore, I need to trace the whole system for that
> time period. I do that by keeping a per-cpu "one-hot bit" which detects
> the interest for any CPU for function tracing, and I atomically xchg
> this value with 1 or 0, and when I detect change between 0 and 1 (or
> reverse), I increment/decrement a system-wide read-mostly function
> tracing active variable.
> 
> It all holds in a small module. Having the ability to connect any marker
> on any generic probe from the lttng marker interface has been very
> useful to do all this. Actually, this module has to be built into the
> kernel because ftrace does not permit breeing the trace_ops data
> structure. :/

I did this purposely. The reason is that there is no safe way to release
the trace_ops, because you never know if something is in the function
you pointed to. If you remove the module after that, it crashes.

I've been thinking of exporting it, and make it so that once you 
register something to the trace_ops, I'll up the module count, and never 
let that module unload.

> 
> Since it was linked to locks, I also integrated lockdep acquire/release
> markers to the same live enabling mechanism.
> 
> I see the same long interrupt issue on 2.6.27-rc2, to which I had to
> port LTTng to get ftrace.
> 
> In the following trace, CPU 4 experiences the 60ms irq handler. I
> narrowed down the code region on this CPU to : (note : any idea to
> automatically turn addresses into symbols, either in text
> post-processing or integrated into the LTTV analyzer, to do like
> ksymoops, is welcome. Is there any specific library I should use ?)

You mean with kallsyms?  I also did some whacky hacks with logdev that
would search a System.map file and find the symbol that way.

> 
> Last event before the delay on CPU 4 :
> 
> locking_lock_acquire: 143.974542821 (/tmp/traceirq7/cpu_4), 0, 0,
>   swapper, , 0, 0x0, IRQ
>   { retaddr = 0xFFFFFFFF80259681 <lock_hrtimer_base+0x31>,
>     subclass = 0, lock = 0xffff880028176c38 , trylock = 0 }
> 
> (note : "lock" is the address of the struct lockdep_map, is that a
> unique lock identifier as I assume, or is it a pointer to a lock "class" ?)

I believe here (if this is the parameter) it is the address of the 
lockdep_map.

> 
>     spin_lock_irqsave(&base->cpu_base->lock, *flags);
> 
> next event on cpu_4 :
> 
> ftrace_entry: 144.034294878 (/tmp/traceirq7/cpu_4), 0, 0,
>   swapper, , 0, 0x0, IRQ
>   { ip = 0xFFFFFFFF802595EC <remove_hrtimer+0x1c>,
>     parent_ip = 0xFFFFFFFF802597D0 <hrtimer_start+0x40> }
> 
> So, what my researchs point me to is the base->cpu_base->lock being
> contended for 60 ms. More to come about the events surrounding this area
> on other CPUs.
> 
> Therefore, I dump the trace for all the lock events linked to the
> 0xffff880028176c38 lock for the time period around the contention. I get
> the following event for lock release on CPU 4. I have put the previous
> lock release from CPU 2 occurring just before. Actually, I see that CPU
> 2 takes and releases this lock many times while cpu 4 contends for it (15
> acquire/release cycles).
> 
> locking_lock_release: 144.030594439 (/tmp/traceirq7/cpu_2), 0, 0,
>   swapper, , 0, 0x0, SOFTIRQ
>   { retaddr = 0xFFFFFFFF802595B8 <hrtimer_run_pending+0xc8>,
>     lock = 0xffff880028176c38, nested = 1 }
> locking_lock_release: 144.034296600 (/tmp/traceirq7/cpu_4), 0, 0,
>   swapper, , 0, 0x0, IRQ
>   { retaddr = 0xFFFFFFFF80258FD0 <switch_hrtimer_base+0x70>,
>     lock = 0xffff880028176c38, nested = 1 }
> 
> CPU 2 acquire/release cycles are identical :
> 
> locking_lock_acquire: 143.954580205 (/tmp/traceirq7/cpu_2), 0, 0,
>   swapper, , 0, 0x0, SOFTIRQ
>   { retaddr = 0xFFFFFFFF80259532 <hrtimer_run_pending+0x42>,
>     subclass = 0, lock = 0xffff880028176c38, trylock = 0 }
> locking_lock_release: 143.954581990 (/tmp/traceirq7/cpu_2), 0, 0,
>   swapper, , 0, 0x0, SOFTIRQ
>   { retaddr = 0xFFFFFFFF802595B8 <hrtimer_run_pending+0xc8>,
>     lock = 0xffff880028176c38, nested = 1 }
> 
> It therefore seems that 
> 
> run_hrtimer_pending() iterates on 15 cpu_base->cb_pending callbacks,
> which takes a while. Note that the fact that the cpu_base->lock is
> released between each callback does not seem to give the control back to
> the contended CPU 4 probably because it runs udelay, given that spinlock
> debugging options are enabled.
> 
> So let's see which functions CPU 2 is calling during the CPU 4
> contention period :
> 
> here is how I did it :
> ./lttv -m textDump -t /tmp/traceirq7 \
>   -e "event.time>=143.974542821&event.time<=144.034296600&state.cpu=2& \
>   (event.name=locking_lock_acquire|event.name=locking_lock_release| \
>   event.name=ftrace_entry)"
> 
> The output, rather long, shows the functions called with the spinlock
> held. I made it available at the following address along with the kernel
> config (for 2.6.27-rc2) and the vmlinux image (to resolve the symbols)
> http://ltt.polymtl.ca/~compudj/60msdebug2/
> 
> In the end, it seems that having a delay in __spin_lock_debug with
> CONFIG_DEBUG_SPINLOCK configs behaves badly when a lock is taken
> repeatedly; it behaves as if the spinlock is contended without being
> released, which can cause long contention periods affecting, amongst
> others, interrupt handlers. Given the TSC are synchronized on this
> computer, the responsible for such long delays between spinlock loops
> seems to be arch/x86/lib/delay.c:delay_tsc().
> 
> Maybe adding some fairness to debug spinlock code would be welcome ?

The spinlock debug code does nasty things (IMO). One is it tries to induce 
contention to see if it can break things. I do not trust any latencies 
when spinlock debug is enabled simply because it purposely adds latencies.

What do you get when spinlock debug is not enabled?

-- Steve
