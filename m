Return-Path: <linux-kernel-owner+w=401wt.eu-S1765437AbYHHXQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765437AbYHHXQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757120AbYHHXQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:16:35 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:44152 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755401AbYHHXQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:16:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FALVqnEhMRKxB/2dsb2JhbACBX6s3
Date: Fri, 8 Aug 2008 19:11:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: LTTng finds abnormally long APIC interrupt handler : 58.2 ms
Message-ID: <20080808231126.GA23766@Krystal>
References: <20080805182007.GA4631@Krystal> <alpine.DEB.1.10.0808051523370.28170@gandalf.stny.rr.com> <20080807160907.GA11255@Krystal> <alpine.DEB.1.10.0808071314320.20931@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808071314320.20931@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:45:44 up 65 days,  3:26,  5 users,  load average: 1.01, 0.85,
	1.52
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> 
> On Thu, 7 Aug 2008, Mathieu Desnoyers wrote:
> 
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
> > Hi Steve,
> > 
> > Yes, I have just made an integration module between LTTng and ftrace and
> > I must say it's very powerful :)
> 
> Cool!
> 
> > 
> > Basically, I have the ability, from userspace, to connect special LTTng
> > probes which start/stop function tracing. In the present case, I hook
> > start function tracing on the kernel_softirq_raise marker and the stop
> > function tracing on every other events (to make sure other starts will
> > stop quickly without letting function tracing enabled too long).
> > 
> > I have two modes : The first one can enable tracing for the local CPU,
> > to know the function call sequence between marker A and B. However, I
> > noticed that this specific problem involves a spin lock shared with
> > other processors. Therefore, I need to trace the whole system for that
> > time period. I do that by keeping a per-cpu "one-hot bit" which detects
> > the interest for any CPU for function tracing, and I atomically xchg
> > this value with 1 or 0, and when I detect change between 0 and 1 (or
> > reverse), I increment/decrement a system-wide read-mostly function
> > tracing active variable.
> > 
> > It all holds in a small module. Having the ability to connect any marker
> > on any generic probe from the lttng marker interface has been very
> > useful to do all this. Actually, this module has to be built into the
> > kernel because ftrace does not permit breeing the trace_ops data
> > structure. :/
> 
> I did this purposely. The reason is that there is no safe way to release
> the trace_ops, because you never know if something is in the function
> you pointed to. If you remove the module after that, it crashes.
> 
> I've been thinking of exporting it, and make it so that once you 
> register something to the trace_ops, I'll up the module count, and never 
> let that module unload.
> 
> > 
> > Since it was linked to locks, I also integrated lockdep acquire/release
> > markers to the same live enabling mechanism.
> > 
> > I see the same long interrupt issue on 2.6.27-rc2, to which I had to
> > port LTTng to get ftrace.
> > 
> > In the following trace, CPU 4 experiences the 60ms irq handler. I
> > narrowed down the code region on this CPU to : (note : any idea to
> > automatically turn addresses into symbols, either in text
> > post-processing or integrated into the LTTV analyzer, to do like
> > ksymoops, is welcome. Is there any specific library I should use ?)
> 
> You mean with kallsyms?  I also did some whacky hacks with logdev that
> would search a System.map file and find the symbol that way.
> 
> > 
> > Last event before the delay on CPU 4 :
> > 
> > locking_lock_acquire: 143.974542821 (/tmp/traceirq7/cpu_4), 0, 0,
> >   swapper, , 0, 0x0, IRQ
> >   { retaddr = 0xFFFFFFFF80259681 <lock_hrtimer_base+0x31>,
> >     subclass = 0, lock = 0xffff880028176c38 , trylock = 0 }
> > 
> > (note : "lock" is the address of the struct lockdep_map, is that a
> > unique lock identifier as I assume, or is it a pointer to a lock "class" ?)
> 
> I believe here (if this is the parameter) it is the address of the 
> lockdep_map.
> 
> > 
> >     spin_lock_irqsave(&base->cpu_base->lock, *flags);
> > 
> > next event on cpu_4 :
> > 
> > ftrace_entry: 144.034294878 (/tmp/traceirq7/cpu_4), 0, 0,
> >   swapper, , 0, 0x0, IRQ
> >   { ip = 0xFFFFFFFF802595EC <remove_hrtimer+0x1c>,
> >     parent_ip = 0xFFFFFFFF802597D0 <hrtimer_start+0x40> }
> > 
> > So, what my researchs point me to is the base->cpu_base->lock being
> > contended for 60 ms. More to come about the events surrounding this area
> > on other CPUs.
> > 
> > Therefore, I dump the trace for all the lock events linked to the
> > 0xffff880028176c38 lock for the time period around the contention. I get
> > the following event for lock release on CPU 4. I have put the previous
> > lock release from CPU 2 occurring just before. Actually, I see that CPU
> > 2 takes and releases this lock many times while cpu 4 contends for it (15
> > acquire/release cycles).
> > 
> > locking_lock_release: 144.030594439 (/tmp/traceirq7/cpu_2), 0, 0,
> >   swapper, , 0, 0x0, SOFTIRQ
> >   { retaddr = 0xFFFFFFFF802595B8 <hrtimer_run_pending+0xc8>,
> >     lock = 0xffff880028176c38, nested = 1 }
> > locking_lock_release: 144.034296600 (/tmp/traceirq7/cpu_4), 0, 0,
> >   swapper, , 0, 0x0, IRQ
> >   { retaddr = 0xFFFFFFFF80258FD0 <switch_hrtimer_base+0x70>,
> >     lock = 0xffff880028176c38, nested = 1 }
> > 
> > CPU 2 acquire/release cycles are identical :
> > 
> > locking_lock_acquire: 143.954580205 (/tmp/traceirq7/cpu_2), 0, 0,
> >   swapper, , 0, 0x0, SOFTIRQ
> >   { retaddr = 0xFFFFFFFF80259532 <hrtimer_run_pending+0x42>,
> >     subclass = 0, lock = 0xffff880028176c38, trylock = 0 }
> > locking_lock_release: 143.954581990 (/tmp/traceirq7/cpu_2), 0, 0,
> >   swapper, , 0, 0x0, SOFTIRQ
> >   { retaddr = 0xFFFFFFFF802595B8 <hrtimer_run_pending+0xc8>,
> >     lock = 0xffff880028176c38, nested = 1 }
> > 
> > It therefore seems that 
> > 
> > run_hrtimer_pending() iterates on 15 cpu_base->cb_pending callbacks,
> > which takes a while. Note that the fact that the cpu_base->lock is
> > released between each callback does not seem to give the control back to
> > the contended CPU 4 probably because it runs udelay, given that spinlock
> > debugging options are enabled.
> > 
> > So let's see which functions CPU 2 is calling during the CPU 4
> > contention period :
> > 
> > here is how I did it :
> > ./lttv -m textDump -t /tmp/traceirq7 \
> >   -e "event.time>=143.974542821&event.time<=144.034296600&state.cpu=2& \
> >   (event.name=locking_lock_acquire|event.name=locking_lock_release| \
> >   event.name=ftrace_entry)"
> > 
> > The output, rather long, shows the functions called with the spinlock
> > held. I made it available at the following address along with the kernel
> > config (for 2.6.27-rc2) and the vmlinux image (to resolve the symbols)
> > http://ltt.polymtl.ca/~compudj/60msdebug2/
> > 
> > In the end, it seems that having a delay in __spin_lock_debug with
> > CONFIG_DEBUG_SPINLOCK configs behaves badly when a lock is taken
> > repeatedly; it behaves as if the spinlock is contended without being
> > released, which can cause long contention periods affecting, amongst
> > others, interrupt handlers. Given the TSC are synchronized on this
> > computer, the responsible for such long delays between spinlock loops
> > seems to be arch/x86/lib/delay.c:delay_tsc().
> > 
> > Maybe adding some fairness to debug spinlock code would be welcome ?
> 
> The spinlock debug code does nasty things (IMO). One is it tries to induce 
> contention to see if it can break things. I do not trust any latencies 
> when spinlock debug is enabled simply because it purposely adds latencies.
> 
> What do you get when spinlock debug is not enabled?
> 
> -- Steve


I've used the markers to instrument the "PROVE LOCKING" within lockdep.c
(because hey, ftrace can't do it) ;) and I have pinpointed the cause of
this huge spinlock delay to be the "prove locking correctness" code.

Here are the interesting trace bits. I had to take a 7.5GB trace to find
this. Luckily I had 16GB of ram to handle the throughput.

cpu_1 is contended for 20 ms.
It does wait for the lock, and finally releases it just before the end
of the interrupt handler. The lock is 0xffff88002816e918 and is
used by cpu_4 right before we can get it.

The prove locking instrumentation on CPU 4 when it holds the lock looks
like this (we miss the beginning of the lock section because the
interesting time window started a bit after this lock has been taken,
but we still have what cpu 4 does while cpu 1 is waiting).

The basic question that arises from this trace is : is it normal for
find_usage_backwards to be called ~8500 times during a spinlock ?

Mathieu


tap_prove_locking_separate_irq_context: 122.324468589 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_validate_chain: 122.324470566 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_lookup_chain_cache: 122.324472111 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_inc_chains: 122.324474528 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_deadlock: 122.324475737 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_prevs_add: 122.324477057 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_prev_add: 122.324478446 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_noncircular: 122.324479727 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_noncircular: 122.324483438 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_noncircular: 122.324485223 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_noncircular: 122.324487005 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_noncircular: 122.324489984 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_noncircular: 122.324492089 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL

[skip 50 lines....]

tap_prove_locking_check_noncircular: 122.324603659 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_noncircular: 122.324604879 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_noncircular: 122.324606988 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_noncircular: 122.324609589 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_noncircular: 122.324611560 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_noncircular: 122.324612736 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_noncircular: 122.324613846 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_noncircular: 122.324615637 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_prev_add_irq: 122.324618808 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_usage: 122.324620913 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_backwards: 122.324623085 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_forwards: 122.324626223 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_forwards: 122.324629235 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL

[skip 50 lines....]

tap_prove_locking_find_usage_forwards: 122.324749702 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_forwards: 122.324751309 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_forwards: 122.324753823 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_forwards: 122.324756583 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_forwards: 122.324759919 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_forwards: 122.324761995 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_forwards: 122.324764017 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_forwards: 122.324765907 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_forwards: 122.324768468 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_forwards: 122.324772635 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_forwards: 122.324773763 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_forwards: 122.324775782 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_usage: 122.324780282 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_backwards: 122.324781569 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_backwards: 122.324784859 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_backwards: 122.324787952 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_backwards: 122.324791501 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_backwards: 122.324794183 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL

********* [skip 4211 lines....]  **********

tap_prove_locking_find_usage_backwards: 122.331774094 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL

********* [skip 4147 lines....]  **********

tap_prove_locking_find_usage_backwards: 122.337997892 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_backwards: 122.338000655 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_find_usage_backwards: 122.338002158 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
tap_prove_locking_check_flags: 122.338004938 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
ftrace_entry: 122.338006966 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
  { ip = 0xFFFFFFFF8025B68C <sched_clock_cpu+0x1c>, parent_ip = 0xFFFFFFFF8063F2BB <thread_return+0x4f0> }

Parent IP is :

ffffffff8063f2bb <thread_return+0x4f0>:
#define task_rq(p)              cpu_rq(task_cpu(p))
#define cpu_curr(cpu)           (cpu_rq(cpu)->curr)

static inline void update_rq_clock(struct rq *rq)
{
        rq->clock = sched_clock_cpu(cpu_of(rq));
ffffffff8063f2bb:       49 89 84 24 e0 07 00    mov    %rax,0x7e0(%r12)

ftrace_entry: 122.338009462 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
  { ip = 0xFFFFFFFF8025B56C <__update_sched_clock+0x1c>, parent_ip = 0xFFFFFFFF8025B752 <sched_clock_cpu+0xe2>}

Parent IP is :

ffffffff8025b752 <sched_clock_cpu+0xe2>:
        return tmp;
}

static __always_inline void __ticket_spin_unlock(raw_spinlock_t *lock)
{
        asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
ffffffff8025b752:       41 fe 04 24             incb   (%r12)
                __update_sched_clock(scd, now, NULL);
                clock = scd->clock;
                __raw_spin_unlock(&scd->lock);
        }

ftrace_entry: 122.338011991 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
  { ip = 0xFFFFFFFF806422A9 <_spin_unlock+0x9>, parent_ip = 0xFFFFFFFF8063F333 <thread_return+0x568> }

Parent IP is :

ffffffff8063f333 <thread_return+0x568>:
                ld_moved = move_tasks(this_rq, this_cpu, busiest,
                                        imbalance, sd, CPU_NEWLY_IDLE,
                                        &all_pinned);
                spin_unlock(&busiest->lock);

                if (unlikely(all_pinned)) {
ffffffff8063f333:       8b 4d c8                mov    -0x38(%rbp),%ecx
ffffffff8063f336:       85 c9                   test   %ecx,%ecx
ffffffff8063f338:       0f 85 e7 00 00 00       jne    ffffffff8063f425 <thread_return+0x65a>

tap_prove_locking_check_flags: 122.338013032 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL
locking_lock_release: 122.338014328 (/tmp/traceirq7/cpu_4), 3837, 3837, /sbin/getty, , 1, 0x0, SYSCALL { retaddr = 0xFFFFFFFF8063F333, lock = 0xffff88002816e918, nested = 1 }



-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
