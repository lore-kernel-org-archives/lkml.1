Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbYHUUvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbYHUUvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYHUUvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:51:04 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:49125 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753009AbYHUUu7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:50:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkwFAEhwrUhMRKxB/2dsb2JhbACBZa8NCQcBCIY7XwMGAX0
Date: Thu, 21 Aug 2008 16:50:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC PATCH] Writer-biased low-latency rwlock v8
Message-ID: <20080821205045.GA24909@Krystal>
References: <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org> <20080816211954.GB7358@Krystal> <alpine.LFD.1.10.0808161422290.3324@nehalem.linux-foundation.org> <20080817075335.GA25019@Krystal> <alpine.LFD.1.10.0808170909420.3324@nehalem.linux-foundation.org> <20080817191034.GA5258@Krystal> <20080818232500.GF6732@linux.vnet.ibm.com> <20080819060417.GB24085@Krystal> <20080819073345.GA30285@Krystal> <alpine.LFD.1.10.0808190946560.3324@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.LFD.1.10.0808190946560.3324@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:31:29 up 77 days, 22:11,  7 users,  load average: 1.28, 0.85,
	0.81
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Tue, 19 Aug 2008, Mathieu Desnoyers wrote:
> > 
> > It strikes me that Intel has a nice (probably slow?) cmpxchg16b
> > instruction on x86_64. Therefore, we could atomically update 128 bits,
> > which gives the following table :
> 
> Stop this crapola.
> 
> Take a look at the rwsem thing I pointed you to. After you understand 
> that, come back.
> 
> The WHOLE POINT of that thing was to use only 32-bit atomics on the hot 
> path. Don't even start think9ing about cmpxchg16b. If you cannot do your 
> atomics in 32-bit, they're broken.
> 
> Please. I realize that the rwsem implementation I did is subtle. But 
> really. Spend the time to understand it.
> 
> 			Linus

You are right, before posting my new version, let's review your rwsem
implementation. Let's pseudo-code the fastpath in C (I don't like to
review the instruction set when thinking conceptually). Comments
inlined. My new patch follows.

* Read lock fast path

my_rwlock_rdlock :
int v = atomic_add_return(0x4, &lock);
if (v & 0x3)
  __my_rwlock_rdlock(lock);
return

Ok, so the reader just say "hey, I'm there" by adding itself to the
reader could. Unlikely to overflow, but could. Then checks the writer
mask, if set, call the read slowpath. In my solution, I do basically the
same as the writer fast path you did : I expect all bits to be 0.
Therefore, if there are many readers at once, I use the slow path even
though there is not "real" contention on the lock. Given that I need to
limit the number of readers to a smaller amount of bits, I need to
detect overflow before-the-fact (this is my new v8 implementation, will
be posted shortly). BTW, you could accelerate the slow path by passing
"v" :

my_rwlock_rdlock :
int v = atomic_add_return(0x4, &lock);
if (v & 0x3)
  __my_rwlock_rdlock(lock, v);
return;


* Write lock fast path

my_rwlock_wrlock :
if (cmpcxhg(&lock, 0, 0x1) != 0)
  __my_rwlock_wrlock(lock);
return;

Writer expects all bits to be 0 (lock uncontended). If true, take the
lock by setting 0x1, else take the slow path. Yes, that's more or less
what I have too. Here too, you could accelerate the write slow path by
passing v.

my_rwlock_wrlock :
int v = cmpcxhg(&lock, 0, 0x1);
if (v)
  __my_rwlock_wrlock(lock, v);
return;


* Read and write unlock fastpath

my_rwlock_unlock :
int v = atomic_read(&lock);
if (!(v & 0x1)) {
  /* unlock reader */
  v = atomic_sub_return(0x4, &lock);
  if (v & 0x3)
    __my_rwlock_rdunlock(lock);
  return;
} else {
  /* unlock writer */
  if (!(v == 0x1))
    __my_rwlock_wrunlock(lock);
  if (cmpxchg(&lock, v, 0) != v)
    __my_rwlock_wrunlock(lock);
  return;
}

Hrm, why don't you split the unlocks ? You could remove the initial read
from the writer unlock. You could also accelerate the slow path by
passing v.

my_rwlock_rdunlock:
  int v = atomic_read(&lock);
  /* unlock reader */
  v = atomic_sub_return(0x4, &lock);
  if (v & 0x3)
    __my_rwlock_rdunlock(lock, v);
  return;

my_rwlock_wrunlock:
  /* unlock writer */
  int v = cmpxchg(&lock, 0x1, 0);
  if (v != 0x1)
    __my_rwlock_wrunlock(lock, v);
  return;


Ok, so I've looks at the slow paths, and I must say it looks pretty much
like what I have, except that :

- I keep reader and writer "pending" counts for each execution context.
  This allow me to keep very low interrupt and softirq latency by moving
  a pending writer successively up in execution priorities. Because
  I need more counters, I need to deal with overflow beforehand by
  busy-looping if a counter overflow is detected.
- I don't need the contention bit, because no contention is indicated by
  the whole bits being 0. Given that I need to detect overflows, I have
  to do a cmpxchg instead of a xadd, which implies that I need to know
  the value beforehand and don't have the ability to use a mask like
  you do in the read fast path. Given that I do a cmpxchg which also
  changes the reader count, I can't afford to try to only consider parts
  of the word in this cmpxchg.

Note that my v8 now implements support for readers in any execution context :
- preemptable
- non-preemptable
- softirq
- irq


Writer-biased low-latency rwlock v8

Writer subscription low-latency rwlock favors writers against reader threads,
but lets softirq and irq readers in even when there are subscribed writers
waiting for the lock. Very frequent writers could starve reader threads.

Changelog since v7 :
Allow both preemptable and non-preemptable thread readers and writers.
Allow preemptable readers and writers to sleep using a wait queue. Use two bits
for the wait queue : WQ_ACTIVE (there is a thread waiting to be woken up) and
WQ_MUTEX (wait queue protection, single bit).

Changelog since v6 :
Made many single-instruction functions static inline, moved to the header.
Separated in slowpath and fastpath C file implementations. The fastpath is meant
to be reimplemented in assembly. Architectures which choose to implement an
optimized fast path must define HAVE_WBIAS_RWLOCK_FASTPATH, which will disable
the generic C version.
Rename to wbias-rwlock.c
Added support for IRQ/Softirq/preemption latency profiling, provided by a
separate patch.
Readers and writers will busy loop if the counter for their context is full. We
can now have less bits reserved for almost unused context (e.g. softirq). This
let us remove any NR_CPUS limitation.

Changelog since v5 :
Test irqs_disabled() in the reader to select the appropriate read context
when interrupts are disabled. Softirqs are already tested with in_softirq(),
which includes softirq disabled sections.
Change subscription behavior : A writer is subscribed until it gets into the
"mutex held" section. Reader threads test for subscription mask or writer mutex
to detect writers. It makes the trylock/subscription API much more efficient.
Updated benchmarks in changelog, with [min,avg,max] delays for each lock use
(contended and uncontended case). Also include "reader thread protection only"
scenario where the writer does not disable interrupts nor bottom-halves.

Changelog since v4 :
rename _fast -> trylock uncontended
Remove the read from the uncontended read and write cases : just do a cmpxchg
expecting "sub_expect", 0 for "lock", 1 subscriber for a "trylock".
Use the value returned by the first cmpxchg as following value instead of doing
an unnecessary read.

Here is why read + rmw is wrong (quoting Linus) :

"This is actually potentially very slow.

Why? If the lock is uncontended, but is not in the current CPU's caches,
the read -> rmw operation generates multiple cache coherency protocol
events. First it gets the line in shared mode (for the read), and then
later it turns it into exclusive mode."

Changelog since v3 :
Added writer subscription and trylock. The writer subscription keeps the reader
threads out of the lock.

Changelog since v2 :
Add writer bias in addition to low-latency wrt interrupts and softirqs.
Added contention delays performance tests for thread and interrupt contexts to
changelog.

Changelog since v1 :
- No more spinlock to protect against concurrent writes, it is done within
  the existing atomic variable.
- Write fastpath with a single atomic op.


I used LTTng traces and eventually made a small patch to lockdep to detect
whenever a spinlock or a rwlock is used both with interrupts enabled and
disabled. Those sites are likely to produce very high latencies and should IMHO
be considered as bogus. The basic bogus scenario is to have a spinlock held on
CPU A with interrupts enabled being interrupted and then a softirq runs. On CPU
B, the same lock is acquired with interrupts off. We therefore disable
interrupts on CPU B for the duration of the softirq currently running on the CPU
A, which is really not something that helps keeping short latencies. My
preliminary results shows that there are a lot of inconsistent spinlock/rwlock
irq on/off uses in the kernel.

This kind of scenario is pretty easy to fix for spinlocks (either move
the interrupt disable within the spinlock section if the spinlock is
never used by an interrupt handler or make sure that every users has
interrupts disabled).

The problem comes with rwlocks : it is correct to have readers both with
and without irq disable, even when interrupt handlers use the read lock.
However, the write lock has to disable interrupt in that case, and we
suffer from the high latency I pointed out. The tasklist_lock is the
perfect example of this. In the following patch, I try to address this
issue.

The core idea is this :

This writer biased rwlock writer subscribes to the preemptable lock, which
locks out the preemptable reader threads. It waits for all the preemptable
reader threads to exit their critical section. Then, it disables preemption,
subscribes for the non-preemptable lock. Then, it waits until all
non-preemptable reader threads exited their critical section and takes the mutex
(1 bit within the "long"). Then it disables softirqs, locks out the softirqs,
waits for all softirqs to exit their critical section, disables irqs and locks
out irqs. It then waits for irqs to exit their critical section. Only then is
the writer allowed to modify the data structure.

The writer fast path checks for a non-contended lock (all bits set to 0) and
does an atomic cmpxchg to set the subscriptions, witer mutex, softirq exclusion
and irq exclusion bits.

The reader does an atomic cmpxchg to check if there is any contention on the
lock. If not, it increments the reader count for its context (preemptable
thread, non-preemptable thread, softirq, irq).

The test module is available at :

http://ltt.polymtl.ca/svn/trunk/tests/kernel/test-wbias-rwlock.c

** Performance tests

Dual quad-core Xeon 2.0GHz E5405

* Latency

This section presents the detailed breakdown of latency preemption, softirq and
interrupt latency generated by the Writer-biased rwlocks. In the "High
contention" section, is compares the "irqoff latency tracer" results between
standard Linux kernel rwlocks and the wbias-rwlocks.

get_cycles takes [min,avg,max] 72,75,78 cycles, results calibrated on avg

** Single writer test, no contention **
SINGLE_WRITER_TEST_DURATION 10s

IRQ latency for cpu 6 disabled 99490 times, [min,avg,max] 471,485,1527 cycles
SoftIRQ latency for cpu 6 disabled 99490 times, [min,avg,max] 693,704,3969 cycles
Preemption latency for cpu 6 disabled 99490 times, [min,avg,max] 909,917,4593 cycles


** Single trylock writer test, no contention **
SINGLE_WRITER_TEST_DURATION 10s

IRQ latency for cpu 2 disabled 10036 times, [min,avg,max] 393,396,849 cycles
SoftIRQ latency for cpu 2 disabled 10036 times, [min,avg,max] 609,614,1317 cycles
Preemption latency for cpu 2 disabled 10036 times, [min,avg,max] 825,826,1971 cycles


** Single reader test, no contention **
SINGLE_READER_TEST_DURATION 10s

Preemption latency for cpu 2 disabled 31596702 times, [min,avg,max] 502,508,54256 cycles


** Multiple readers test, no contention (4 readers, busy-loop) **
MULTIPLE_READERS_TEST_DURATION 10s
NR_READERS 4

Preemption latency for cpu 1 disabled 9302974 times, [min,avg,max] 502,2039,88060 cycles
Preemption latency for cpu 3 disabled 9270742 times, [min,avg,max] 508,2045,61342 cycles
Preemption latency for cpu 6 disabled 13331943 times, [min,avg,max] 508,1387,309088 cycles
Preemption latency for cpu 7 disabled 4781453 times, [min,avg,max] 508,4092,230752 cycles


** High contention test **
TEST_DURATION 60s
NR_WRITERS 2
NR_TRYLOCK_WRITERS 1
NR_READERS 4
NR_TRYLOCK_READERS 1
WRITER_DELAY 100us
TRYLOCK_WRITER_DELAY 1000us
TRYLOCK_WRITERS_FAIL_ITER 100
THREAD_READER_DELAY 0   /* busy loop */
INTERRUPT_READER_DELAY 100ms

Standard Linux rwlock

irqsoff latency trace v1.1.5 on 2.6.27-rc3-trace
--------------------------------------------------------------------
 latency: 2902 us, #3/3, CPU#5 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:8)
    -----------------
    | task: wbiasrwlock_wri-4984 (uid:0 nice:-5 policy:0 rt_prio:0)
    -----------------
 => started at: _write_lock_irq
 => ended at:   _write_unlock_irq

#                _------=> CPU#            
#               / _-----=> irqs-off        
#              | / _----=> need-resched    
#              || / _---=> hardirq/softirq 
#              ||| / _--=> preempt-depth   
#              |||| /                      
#              |||||     delay             
#  cmd     pid ||||| time  |   caller      
#     \   /    |||||   \   |   /           
wbiasrwl-4984  5d..1    0us!: _write_lock_irq (0)
wbiasrwl-4984  5d..2 2902us : _write_unlock_irq (0)
wbiasrwl-4984  5d..3 2903us : trace_hardirqs_on (_write_unlock_irq)


Writer-biased rwlock, same test routine

irqsoff latency trace v1.1.5 on 2.6.27-rc3-trace
--------------------------------------------------------------------
 latency: 33 us, #3/3, CPU#7 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:8)
    -----------------
    | task: events/7-27 (uid:0 nice:-5 policy:0 rt_prio:0)
    -----------------
 => started at: _spin_lock_irqsave
 => ended at:   _spin_unlock_irqrestore

#                _------=> CPU#            
#               / _-----=> irqs-off        
#              | / _----=> need-resched    
#              || / _---=> hardirq/softirq 
#              ||| / _--=> preempt-depth   
#              |||| /                      
#              |||||     delay             
#  cmd     pid ||||| time  |   caller      
#     \   /    |||||   \   |   /           
events/7-27    7d...    0us+: _spin_lock_irqsave (0)
events/7-27    7d..1   33us : _spin_unlock_irqrestore (0)
events/7-27    7d..2   33us : trace_hardirqs_on (_spin_unlock_irqrestore)

(latency unrelated to the tests, therefore irq latency <= 33us)

wbias rwlock instrumentation (below) shows that interrupt latency has been 14176
cycles, for a total of 7us.

Detailed writer-biased rwlock latency breakdown :

IRQ latency for cpu 0 disabled 1086419 times, [min,avg,max] 316,2833,14176 cycles
IRQ latency for cpu 1 disabled 1099517 times, [min,avg,max] 316,1820,8254 cycles
IRQ latency for cpu 3 disabled 159088 times, [min,avg,max] 316,1409,5632 cycles
IRQ latency for cpu 4 disabled 161 times, [min,avg,max] 340,1882,5206 cycles
SoftIRQ latency for cpu 0 disabled 1086419 times, [min,avg,max] 2212,5350,166402 cycles
SoftIRQ latency for cpu 1 disabled 1099517 times, [min,avg,max] 2230,4265,138988 cycles
SoftIRQ latency for cpu 3 disabled 159088 times, [min,avg,max] 2212,3319,14992 cycles
SoftIRQ latency for cpu 4 disabled 161 times, [min,avg,max] 2266,3802,7138 cycles
Preemption latency for cpu 3 disabled 59855 times, [min,avg,max] 5266,15706,53494 cycles
Preemption latency for cpu 4 disabled 72 times, [min,avg,max] 5728,14132,28042 cycles
Preemption latency for cpu 5 disabled 55586612 times, [min,avg,max] 196,2080,126526 cycles

Note : preemptable critical sections has been implemented after the previous
latency tests. It should be noted that the worse latency obtained in wbias
rwlock comes from the busy-loop for the wait queue protection mutex (100us) :

IRQ latency for cpu 3 disabled 2822178 times, [min,avg,max] 256,8892,209926 cycles
disable : [<ffffffff803acff5>] rwlock_wait+0x265/0x2c0



* Lock contention delays, per context, 60s test
(number of cycles required to take the lock are benchmarked)


** get_cycles calibration **
get_cycles takes [min,avg,max] 72,77,78 cycles, results calibrated on avg


** Single writer test, no contention **
A bit slower here on the fast path both for lock/unlock probably due to preempt
disable+bh disable+irq disable in wbias rwlock :

* Writer-biased rwlocks v8
writer_thread/0 iterations : 100348, lock delay [min,avg,max] 51,58,279 cycles
writer_thread/0 iterations : 100348, unlock delay [min,avg,max] 57,59,3633 cycles

* Standard rwlock, kernel 2.6.27-rc3
writer_thread/0 iterations : 100322, lock delay [min,avg,max] 37,40,4537 cycles
writer_thread/0 iterations : 100322, unlock delay [min,avg,max] 37,40,25435 cycles


** Single preemptable reader test, no contention **
Writer-biased rwlock has a twice faster lock and unlock uncontended fast path.
Note that wbias rwlock support preemptable readers. Standard rwlocks disables
preemption.

* Writer-biased rwlocks v8
preader_thread/0 iterations : 34204828, lock delay [min,avg,max] 21,23,48537 cycles
preader_thread/0 iterations : 34204828, unlock delay [min,avg,max] 15,22,22497 cycles

* Standard rwlock, kernel 2.6.27-rc3
preader_thread/0 iterations : 31993512, lock delay [min,avg,max] 37,39,264955 cycles
preader_thread/0 iterations : 31993512, unlock delay [min,avg,max] 37,42,151201 cycles


** Single non-preemptable reader test, no contention **
wbias rwlock read is still twice faster than standard rwlock even for read done
in non-preemptable context.

* Writer-biased rwlocks v8
npreader_thread/0 iterations : 33631953, lock delay [min,avg,max] 21,23,14919 cycles
npreader_thread/0 iterations : 33631953, unlock delay [min,avg,max] 15,21,16635 cycles

* Standard rwlock, kernel 2.6.27-rc3
npreader_thread/0 iterations : 31639225, lock delay [min,avg,max] 37,39,127111 cycles
npreader_thread/0 iterations : 31639225, unlock delay [min,avg,max] 37,42,215587 cycles


** Multiple p(reemptable)/n(on-)p(reemptable) readers test, no contention **
This contended case where multiple readers try to access the data structure in
loop, without any writer, shows that standard rwlock average is a little bit
better than wbias rwlock. It could be explained by the fact that wbias rwlock
cmpxchg operation, which is used to keep the count of active readers, may fail
if there is contention and must therefore be retried. The fastpath actually
expects the number of readers to be 0, which isn't the case here.

* Writer-biased rwlocks v8
npreader_thread/0 iterations : 16781774, lock delay [min,avg,max] 33,421,33435 cycles
npreader_thread/0 iterations : 16781774, unlock delay [min,avg,max] 21,222,35925 cycles
npreader_thread/1 iterations : 16819056, lock delay [min,avg,max] 21,421,24957 cycles
npreader_thread/1 iterations : 16819056, unlock delay [min,avg,max] 21,222,37707 cycles
preader_thread/0 iterations : 17151363, lock delay [min,avg,max] 21,425,47745 cycles
preader_thread/0 iterations : 17151363, unlock delay [min,avg,max] 21,223,33207 cycles
preader_thread/1 iterations : 17248440, lock delay [min,avg,max] 21,423,689061 cycles
preader_thread/1 iterations : 17248440, unlock delay [min,avg,max] 15,222,685935 cycles

* Standard rwlock, kernel 2.6.27-rc3
npreader_thread/0 iterations : 19248438, lock delay [min,avg,max] 37,273,364459 cycles
npreader_thread/0 iterations : 19248438, unlock delay [min,avg,max] 43,216,272539 cycles
npreader_thread/1 iterations : 19251717, lock delay [min,avg,max] 37,242,365719 cycles
npreader_thread/1 iterations : 19251717, unlock delay [min,avg,max] 43,249,162847 cycles
preader_thread/0 iterations : 19557931, lock delay [min,avg,max] 37,250,334921 cycles
preader_thread/0 iterations : 19557931, unlock delay [min,avg,max] 37,245,266377 cycles
preader_thread/1 iterations : 19671318, lock delay [min,avg,max] 37,258,390913 cycles
preader_thread/1 iterations : 19671318, unlock delay [min,avg,max] 37,234,604507 cycles



** High contention test **

In high contention test :

TEST_DURATION 60s
NR_WRITERS 2
NR_TRYLOCK_WRITERS 1
NR_PREEMPTABLE_READERS 2
NR_NON_PREEMPTABLE_READERS 2
NR_TRYLOCK_READERS 1
WRITER_DELAY 100us
TRYLOCK_WRITER_DELAY 1000us
TRYLOCK_WRITERS_FAIL_ITER 100
THREAD_READER_DELAY 0   /* busy loop */
INTERRUPT_READER_DELAY 100ms


* Preemptable writers

* Writer-biased rwlocks v8
writer_thread/0 iterations : 556371, lock delay [min,avg,max] 153,9020,3138519 cycles
writer_thread/0 iterations : 556371, unlock delay [min,avg,max] 171,7277,1134309 cycles
writer_thread/1 iterations : 558540, lock delay [min,avg,max] 147,7047,3048447 cycles
writer_thread/1 iterations : 558540, unlock delay [min,avg,max] 171,8554,99633 cycles

* Standard rwlock, kernel 2.6.27-rc3
writer_thread/0 iterations : 222797, lock delay [min,avg,max] 127,336611,4710367 cycles
writer_thread/0 iterations : 222797, unlock delay [min,avg,max] 151,2009,714115 cycles
writer_thread/1 iterations : 6845, lock delay [min,avg,max] 139,17271138,352848961 cycles
writer_thread/1 iterations : 6845, unlock delay [min,avg,max] 217,93935,1991509 cycles


* Non-preemptable readers

* Writer-biased rwlocks v8
npreader_thread/0 iterations : 53472673, lock delay [min,avg,max] 21,804,119709 cycles
npreader_thread/0 iterations : 53472673, unlock delay [min,avg,max] 15,890,90213 cycles
npreader_thread/1 iterations : 53883582, lock delay [min,avg,max] 21,804,120225 cycles
npreader_thread/1 iterations : 53883582, unlock delay [min,avg,max] 15,876,82809 cycles

* Standard rwlock, kernel 2.6.27-rc3
npreader_thread/0 iterations : 68298472, lock delay [min,avg,max] 37,640,733423 cycles
npreader_thread/0 iterations : 68298472, unlock delay [min,avg,max] 37,565,672241 cycles
npreader_thread/1 iterations : 70331311, lock delay [min,avg,max] 37,603,393925 cycles
npreader_thread/1 iterations : 70331311, unlock delay [min,avg,max] 37,558,373477 cycles


* Preemptable readers

* Writer-biased rwlocks v8 (note : preemption enabled, explains higher numbers)
preader_thread/0 iterations : 40652556, lock delay [min,avg,max] 21,1237,5796567 cycles
preader_thread/0 iterations : 40652556, unlock delay [min,avg,max] 15,1196,1655289 cycles
preader_thread/1 iterations : 18260923, lock delay [min,avg,max] 21,4833,3181587 cycles
preader_thread/1 iterations : 18260923, unlock delay [min,avg,max] 21,1228,862395 cycles

* Standard rwlock, kernel 2.6.27-rc3 (note : std rwlock disables preemption)
preader_thread/0 iterations : 69683738, lock delay [min,avg,max] 37,622,742165 cycles
preader_thread/0 iterations : 69683738, unlock delay [min,avg,max] 37,566,1331971 cycles
preader_thread/1 iterations : 79758111, lock delay [min,avg,max] 37,543,757315 cycles
preader_thread/1 iterations : 79758111, unlock delay [min,avg,max] 37,427,813199 cycles


* Interrupt context readers

* Writer-biased rwlocks v8 (note : some of the higher unlock delays (38us) are
caused by the wakeup of the wait queue done at the exit of the critical section
if the waitqueue is active)
interrupt readers on CPU 0, lock delay [min,avg,max] 153,975,8607 cycles
interrupt readers on CPU 0, unlock delay [min,avg,max] 9,2186,45843 cycles
interrupt readers on CPU 1, lock delay [min,avg,max] 69,813,13557 cycles
interrupt readers on CPU 1, unlock delay [min,avg,max] 9,2323,76005 cycles
interrupt readers on CPU 2, lock delay [min,avg,max] 147,949,9111 cycles
interrupt readers on CPU 2, unlock delay [min,avg,max] 9,3232,64269 cycles
interrupt readers on CPU 3, lock delay [min,avg,max] 69,850,22137 cycles
interrupt readers on CPU 3, unlock delay [min,avg,max] 15,1760,46509 cycles
interrupt readers on CPU 4, lock delay [min,avg,max] 135,804,8559 cycles
interrupt readers on CPU 4, unlock delay [min,avg,max] 9,1898,57009 cycles
interrupt readers on CPU 6, lock delay [min,avg,max] 129,904,11877 cycles
interrupt readers on CPU 6, unlock delay [min,avg,max] 9,3009,81321 cycles
interrupt readers on CPU 7, lock delay [min,avg,max] 135,1239,21489 cycles
interrupt readers on CPU 7, unlock delay [min,avg,max] 9,2215,68991 cycles

* Standard rwlock, kernel 2.6.27-rc3 (note : these numbers are not that bad, but
they do not take interrupt latency in account. See tests above for discussion of
this issue)
interrupt readers on CPU 0, lock delay [min,avg,max] 55,573,4417 cycles
interrupt readers on CPU 0, unlock delay [min,avg,max] 43,529,1591 cycles
interrupt readers on CPU 1, lock delay [min,avg,max] 139,591,5731 cycles
interrupt readers on CPU 1, unlock delay [min,avg,max] 31,534,2395 cycles
interrupt readers on CPU 2, lock delay [min,avg,max] 127,671,6043 cycles
interrupt readers on CPU 2, unlock delay [min,avg,max] 37,401,1567 cycles
interrupt readers on CPU 3, lock delay [min,avg,max] 151,676,5569 cycles
interrupt readers on CPU 3, unlock delay [min,avg,max] 127,536,2797 cycles
interrupt readers on CPU 5, lock delay [min,avg,max] 127,531,15397 cycles
interrupt readers on CPU 5, unlock delay [min,avg,max] 31,323,1747 cycles
interrupt readers on CPU 6, lock delay [min,avg,max] 121,548,29125 cycles
interrupt readers on CPU 6, unlock delay [min,avg,max] 31,435,2089 cycles
interrupt readers on CPU 7, lock delay [min,avg,max] 37,613,5485 cycles
interrupt readers on CPU 7, unlock delay [min,avg,max] 49,541,1645 cycles

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
---
 include/linux/wbias-rwlock.h |  548 ++++++++++++++++++++++++++++++++++
 lib/Kconfig                  |    3 
 lib/Kconfig.debug            |    4 
 lib/Makefile                 |    7 
 lib/wbias-rwlock-fastpath.c  |  204 ++++++++++++
 lib/wbias-rwlock.c           |  679 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 1445 insertions(+)

Index: linux-2.6-lttng/include/linux/wbias-rwlock.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/wbias-rwlock.h	2008-08-21 16:33:58.000000000 -0400
@@ -0,0 +1,548 @@
+#ifndef _LINUX_WBIAS_RWLOCK_H
+#define _LINUX_WBIAS_RWLOCK_H
+
+/*
+ * Writer-biased low-latency rwlock
+ *
+ * Allows writer bias wrt readers threads and also minimally impact the irq
+ * latency of the system.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ * August 2008
+ */
+
+#include <linux/hardirq.h>
+#include <linux/wait.h>
+
+#include <asm/atomic.h>
+
+/*
+ * Those are the maximum number of writers and readers for each context.
+ * Carefully chosen using a precise rule of thumb.
+ * The readers and writers will busy-loop when the count reaches its max,
+ * therefore no overflow is possible. The number of execution threads which can
+ * enter a specific lock or subscribe for it is MAX - 1 (because 0 has to be
+ * counted). Therefore, the minimum values for those MAX is 2, which allows 0 or
+ * 1 execution context to hold the lock or subscribe at any given time.
+ *
+ * General rule : there should be no reader from context lower than the priority
+ * of the writer. e.g. if a writer lock is taken in softirq context or when
+ * softirqs are disabled, only softirq and irq readers are allowed.
+ *
+ * A writer should use the lock primitives protecting it against the highest
+ * reader priority which reads the structure.
+ *
+ * Must keep 5 more bits for writer :
+ * WRITER_MUTEX, SOFTIRQ_WMASK, HARDIRQ_WOFFSET, WQ_MUTEX, WQ_ACTIVE
+ *
+ * PTHREAD stands for preemptable thread.
+ * NPTHREAD stands for non-preemptable thread.
+ *
+ * The ordering of WQ_MUTEX, ACTIVE_MUTEX wrt the checks done by the
+ * busy-looping/waiting threads is tricky. WQ_MUTEX protects the waitqueue and
+ * ACTIVE_MUTEX changes. WQ_MUTEX must be taken with interrupts off.
+ *
+ * Upon unlock, the following sequence is done :
+ * - atomically unlock and return the lock value, which contains the WQ_MUTEX
+ *   and ACTIVE_MUTEX at the moment of the unlock.
+ * - check if either ACTIVE_MUTEX or WQ_MUTEX are set, if so :
+ *   - take WQ_MUTEX
+ *   - wake a thread
+ *   - release WQ_MUTEX
+ *
+ * When a thread is ready to be added to the wait queue :
+ * - the last busy-looping iteration fails.
+ * - take the WQ_MUTEX
+ * - check again for the failed condition, since its status may have changed
+ *   since the busy-loop failed. If the condition now succeeds, return to
+ *   busy-looping after releasing the WQ_MUTEX.
+ * - Add the current thread to the wait queue, change state.
+ * - Atomically release WQ_MUTEX and set WQ_ACTIVE if the list passed from
+ *   inactive to active.
+ *
+ * Upon wakeup :
+ * - take WQ_MUTEX
+ * - Set state to running, remove from the wait queue.
+ * - Atomically release WQ_MUTEX and clear WQ_ACTIVE if the list passed to
+ *   inactive.
+ */
+
+#ifdef CONFIG_DEBUG_WBIAS_RWLOCK
+#define PTHREAD_RMAX	2
+#define NPTHREAD_RMAX	2
+#define SOFTIRQ_RMAX	2
+#define HARDIRQ_RMAX	2
+
+#define PTHREAD_WMAX	2
+#define NPTHREAD_WMAX	2
+#elif (BITS_PER_LONG == 32)
+#define PTHREAD_RMAX	64
+#define NPTHREAD_RMAX	16
+#define SOFTIRQ_RMAX	16
+#define HARDIRQ_RMAX	8
+
+#define PTHREAD_WMAX	32
+#define NPTHREAD_WMAX	16
+#else
+#define PTHREAD_RMAX	16384
+#define NPTHREAD_RMAX	2048
+#define SOFTIRQ_RMAX	512
+#define HARDIRQ_RMAX	256
+
+#define PTHREAD_WMAX	512
+#define NPTHREAD_WMAX	256
+#endif
+
+#define PTHREAD_ROFFSET		1UL
+#define PTHREAD_RMASK		((PTHREAD_RMAX - 1) * PTHREAD_ROFFSET)
+#define NPTHREAD_ROFFSET	(PTHREAD_RMASK + 1)
+#define NPTHREAD_RMASK		((NPTHREAD_RMAX - 1) * NPTHREAD_ROFFSET)
+#define SOFTIRQ_ROFFSET		((NPTHREAD_RMASK | PTHREAD_RMASK) + 1)
+#define SOFTIRQ_RMASK		((SOFTIRQ_RMAX - 1) * SOFTIRQ_ROFFSET)
+#define HARDIRQ_ROFFSET		\
+	((SOFTIRQ_RMASK | NPTHREAD_RMASK | PTHREAD_RMASK) + 1)
+#define HARDIRQ_RMASK		((HARDIRQ_RMAX - 1) * HARDIRQ_ROFFSET)
+
+#define PTHREAD_WOFFSET	\
+	((HARDIRQ_RMASK | SOFTIRQ_RMASK | NPTHREAD_RMASK | PTHREAD_RMASK) + 1)
+#define PTHREAD_WMASK	((PTHREAD_WMAX - 1) * PTHREAD_WOFFSET)
+#define NPTHREAD_WOFFSET ((PTHREAD_WMASK | HARDIRQ_RMASK | SOFTIRQ_RMASK | \
+			NPTHREAD_RMASK | PTHREAD_RMASK) + 1)
+#define NPTHREAD_WMASK	((NPTHREAD_WMAX - 1) * NPTHREAD_WOFFSET)
+#define WRITER_MUTEX	((PTHREAD_WMASK | NPTHREAD_WMASK | HARDIRQ_RMASK | \
+			SOFTIRQ_RMASK | NPTHREAD_RMASK | PTHREAD_RMASK) + 1)
+#define SOFTIRQ_WMASK		(WRITER_MUTEX << 1)
+#define SOFTIRQ_WOFFSET		SOFTIRQ_WMASK
+#define HARDIRQ_WMASK		(SOFTIRQ_WMASK << 1)
+#define HARDIRQ_WOFFSET		HARDIRQ_WMASK
+#define WQ_MUTEX		(HARDIRQ_WMASK << 1)
+#define WQ_ACTIVE		(WQ_MUTEX << 1)
+
+#define NR_PREEMPT_BUSY_LOOPS	100
+
+typedef struct wbias_rwlock {
+	atomic_long_t v;
+	wait_queue_head_t wq_read;	/* Preemptable readers wait queue */
+	wait_queue_head_t wq_write;	/* Preemptable writers wait queue */
+} wbias_rwlock_t;
+
+#define __RAW_WBIAS_RWLOCK_UNLOCKED	{ 0 }
+
+#define __WBIAS_RWLOCK_UNLOCKED(x)					\
+	{								\
+		.v = __RAW_WBIAS_RWLOCK_UNLOCKED,			\
+		.wq_read = __WAIT_QUEUE_HEAD_INITIALIZER((x).wq_read),	\
+		.wq_write = __WAIT_QUEUE_HEAD_INITIALIZER((x).wq_write),\
+	}
+
+#define DEFINE_WBIAS_RWLOCK(x)	wbias_rwlock_t x = __WBIAS_RWLOCK_UNLOCKED(x)
+
+/*
+ * Internal slow paths.
+ */
+extern int _wbias_read_lock_slow(wbias_rwlock_t *rwlock,
+		long v, long roffset, long rmask, long wmask, int trylock);
+extern int _wbias_read_lock_slow_preempt(wbias_rwlock_t *rwlock,
+		long v, long roffset, long rmask, long wmask, int trylock);
+extern void _wbias_write_lock_irq_slow(wbias_rwlock_t *rwlock, long v);
+extern int _wbias_write_trylock_irq_else_subscribe_slow(wbias_rwlock_t *rwlock,
+		long v);
+extern int _wbias_write_trylock_irq_subscribed_slow(wbias_rwlock_t *rwlock,
+		long v);
+extern void _wbias_write_lock_bh_slow(wbias_rwlock_t *rwlock, long v);
+extern int _wbias_write_trylock_bh_else_subscribe_slow(wbias_rwlock_t *rwlock,
+		long v);
+extern int _wbias_write_trylock_bh_subscribed_slow(wbias_rwlock_t *rwlock,
+		long v);
+extern void _wbias_write_lock_atomic_slow(wbias_rwlock_t *rwlock, long v);
+extern int
+_wbias_write_trylock_atomic_else_subscribe_slow(wbias_rwlock_t *rwlock,
+		long v);
+extern int _wbias_write_trylock_atomic_subscribed_slow(wbias_rwlock_t *rwlock,
+		long v);
+extern void _wbias_write_lock_slow(wbias_rwlock_t *rwlock, long v);
+extern int _wbias_write_trylock_else_subscribe_slow(wbias_rwlock_t *rwlock,
+		long v);
+extern int _wbias_write_trylock_subscribed_slow(wbias_rwlock_t *rwlock,
+		long v);
+extern void _wbias_rwlock_wakeup(wbias_rwlock_t *rwlock, long v);
+
+static inline void wbias_rwlock_preempt_check(wbias_rwlock_t *rwlock, long v)
+{
+	if (unlikely(v & (WQ_ACTIVE | WQ_MUTEX)))
+		_wbias_rwlock_wakeup(rwlock, v);
+}
+
+/*
+ * rwlock-specific latency tracing, maps to standard macros by default.
+ */
+#ifdef CONFIG_WBIAS_RWLOCK_LATENCY_TEST
+#include <linux/wbias-latency-trace.h>
+#else
+static inline void wbias_rwlock_profile_latency_reset(void)
+{ }
+static inline void wbias_rwlock_profile_latency_print(void)
+{ }
+
+#define wbias_rwlock_irq_save(flags)	local_irq_save(flags)
+#define wbias_rwlock_irq_restore(flags)	local_irq_restore(flags)
+#define wbias_rwlock_irq_disable()	local_irq_disable()
+#define wbias_rwlock_irq_enable()	local_irq_enable()
+#define wbias_rwlock_bh_disable()	local_bh_disable()
+#define wbias_rwlock_bh_enable()	local_bh_enable()
+#define wbias_rwlock_bh_enable_ip(ip)	local_bh_enable_ip(ip)
+#define wbias_rwlock_preempt_disable()	preempt_disable()
+#define wbias_rwlock_preempt_enable()	preempt_enable()
+#define wbias_rwlock_preempt_enable_no_resched()	\
+		preempt_enable_no_resched()
+#endif
+
+
+/*
+ * API
+ */
+
+
+/*
+ * This table represents which write lock should be taken depending on the
+ * highest priority read context and the write context used.
+ *
+ * e.g. given the highest priority context from which we take the read lock is
+ * interrupt context (IRQ) and that we always use the write lock from
+ * non-preemptable context (NP), we should use the IRQ version of the write
+ * lock.
+ *
+ * X means : don't !
+ *
+ * Highest priority reader context / Writer context   P     NP    BH    IRQ
+ * ------------------------------------------------------------------------
+ * P                                                | P     X     X     X
+ * NP                                               | NP    NP    X     X
+ * BH                                               | BH    BH    BH    X
+ * IRQ                                              | IRQ   IRQ   IRQ   IRQ
+ */
+
+
+/* Reader lock */
+
+/*
+ * many readers, from irq/softirq/thread context.
+ * protects against writers.
+ */
+
+/*
+ * Called from interrupt disabled or interrupt context.
+ */
+static inline void wbias_read_lock_irq(wbias_rwlock_t *rwlock)
+{
+	long v = atomic_long_cmpxchg(&rwlock->v, 0, HARDIRQ_ROFFSET);
+	if (likely(!v))
+		return;
+	_wbias_read_lock_slow(rwlock, v,
+		HARDIRQ_ROFFSET, HARDIRQ_RMASK, HARDIRQ_WMASK, 0);
+}
+
+static inline int wbias_read_trylock_irq(wbias_rwlock_t *rwlock)
+{
+	long v = atomic_long_cmpxchg(&rwlock->v, 0, HARDIRQ_ROFFSET);
+	if (likely(!v))
+		return 1;
+	return _wbias_read_lock_slow(rwlock, v,
+		HARDIRQ_ROFFSET, HARDIRQ_RMASK, HARDIRQ_WMASK, 1);
+}
+
+static inline void wbias_read_unlock_irq(wbias_rwlock_t *rwlock)
+{
+	long v;
+	v = atomic_long_sub_return(HARDIRQ_ROFFSET, &rwlock->v);
+	wbias_rwlock_preempt_check(rwlock, v);
+}
+
+
+/*
+ * Called from softirq context.
+ */
+
+static inline void wbias_read_lock_bh(wbias_rwlock_t *rwlock)
+{
+	long v = atomic_long_cmpxchg(&rwlock->v, 0, SOFTIRQ_ROFFSET);
+	if (likely(!v))
+		return;
+	_wbias_read_lock_slow(rwlock, v,
+		SOFTIRQ_ROFFSET, SOFTIRQ_RMASK, SOFTIRQ_WMASK, 0);
+}
+
+static inline int wbias_read_trylock_bh(wbias_rwlock_t *rwlock)
+{
+	long v = atomic_long_cmpxchg(&rwlock->v, 0, SOFTIRQ_ROFFSET);
+	if (likely(!v))
+		return 1;
+	return _wbias_read_lock_slow(rwlock, v,
+		SOFTIRQ_ROFFSET, SOFTIRQ_RMASK, SOFTIRQ_WMASK, 1);
+}
+
+static inline void wbias_read_unlock_bh(wbias_rwlock_t *rwlock)
+{
+	long v;
+	v = atomic_long_sub_return(SOFTIRQ_ROFFSET, &rwlock->v);
+	wbias_rwlock_preempt_check(rwlock, v);
+}
+
+
+/*
+ * Called from non-preemptable thread context.
+ */
+
+static inline void wbias_read_lock_inatomic(wbias_rwlock_t *rwlock)
+{
+	long v = atomic_long_cmpxchg(&rwlock->v, 0, NPTHREAD_ROFFSET);
+	if (likely(!v))
+		return;
+	_wbias_read_lock_slow(rwlock, v,
+		NPTHREAD_ROFFSET, NPTHREAD_RMASK,
+		NPTHREAD_WMASK | WRITER_MUTEX, 0);
+}
+
+static inline int wbias_read_trylock_inatomic(wbias_rwlock_t *rwlock)
+{
+	long v = atomic_long_cmpxchg(&rwlock->v, 0, NPTHREAD_ROFFSET);
+	if (likely(!v))
+		return 1;
+	return _wbias_read_lock_slow(rwlock, v,
+		NPTHREAD_ROFFSET, NPTHREAD_RMASK,
+		NPTHREAD_WMASK | WRITER_MUTEX, 1);
+}
+
+static inline void wbias_read_unlock_inatomic(wbias_rwlock_t *rwlock)
+{
+	long v;
+	v = atomic_long_sub_return(NPTHREAD_ROFFSET, &rwlock->v);
+	wbias_rwlock_preempt_check(rwlock, v);
+}
+
+
+/*
+ * Called from preemptable thread context.
+ */
+
+static inline void wbias_read_lock(wbias_rwlock_t *rwlock)
+{
+	long v = atomic_long_cmpxchg(&rwlock->v, 0, PTHREAD_ROFFSET);
+	if (likely(!v))
+		return;
+	_wbias_read_lock_slow_preempt(rwlock, v,
+		PTHREAD_ROFFSET, PTHREAD_RMASK,
+		PTHREAD_WMASK | NPTHREAD_WMASK | WRITER_MUTEX, 0);
+}
+
+static inline int wbias_read_trylock(wbias_rwlock_t *rwlock)
+{
+	long v = atomic_long_cmpxchg(&rwlock->v, 0, PTHREAD_ROFFSET);
+	if (likely(!v))
+		return 1;
+	return _wbias_read_lock_slow_preempt(rwlock, v,
+		PTHREAD_ROFFSET, PTHREAD_RMASK,
+		PTHREAD_WMASK | NPTHREAD_WMASK | WRITER_MUTEX, 1);
+}
+
+static inline void wbias_read_unlock(wbias_rwlock_t *rwlock)
+{
+	long v;
+	v = atomic_long_sub_return(PTHREAD_ROFFSET, &rwlock->v);
+	wbias_rwlock_preempt_check(rwlock, v);
+}
+
+
+/*
+ * Automatic selection of the right locking primitive depending on the
+ * current context. Should be used when the context cannot be statically
+ * determined or as a compatibility layer for the old rwlock.
+ */
+static inline void wbias_read_lock_generic(wbias_rwlock_t *rwlock)
+{
+	if (in_irq() || irqs_disabled())
+		wbias_read_lock_irq(rwlock);
+	else if (in_softirq())
+		wbias_read_lock_bh(rwlock);
+	else if (in_atomic())
+		wbias_read_lock_inatomic(rwlock);
+	else
+		wbias_read_lock(rwlock);
+}
+
+static inline int wbias_read_trylock_generic(wbias_rwlock_t *rwlock)
+{
+	if (in_irq() || irqs_disabled())
+		return wbias_read_trylock_irq(rwlock);
+	else if (in_softirq())
+		return wbias_read_trylock_bh(rwlock);
+	else if (in_atomic())
+		return wbias_read_trylock_inatomic(rwlock);
+	else
+		return wbias_read_trylock(rwlock);
+}
+
+static inline void wbias_read_unlock_generic(wbias_rwlock_t *rwlock)
+{
+	if (in_irq() || irqs_disabled())
+		wbias_read_unlock_irq(rwlock);
+	else if (in_softirq())
+		wbias_read_unlock_bh(rwlock);
+	else if (in_atomic())
+		wbias_read_unlock_inatomic(rwlock);
+	else
+		wbias_read_unlock(rwlock);
+}
+
+/* Writer Lock */
+
+
+/*
+ * Safe against other writers in same context.
+ * If used in irq handler or with irq off context, safe against :
+ * - irq readers.
+ * If used in softirq handler or softirq off context, safe against :
+ * - irq/softirq readers.
+ * If used in non-preemptable context, safe against :
+ * - irq/softirq/non-preemptable readers.
+ * If used in preemptable context, safe against :
+ * - irq/softirq/non-preemptable/preemptable readers.
+ *
+ * Write lock use :
+ *  wbias_write_lock_irq(&lock);
+ *  ...
+ *  wbias_write_unlock_irq(&lock);
+ *
+ * or
+ *
+ * int i;
+ *
+ * repeat:
+ *  if (wbias_write_trylock_irq_else_subscribe(&lock))
+ *    goto locked;
+ *  for (i = 0; i < NR_LOOPS; i++)
+ *    if (wbias_write_trylock_irq_subscribed(&lock))
+ *      goto locked;
+ *  do_failed_to_grab_lock(...);
+ *  wbias_write_unsubscribe(&lock);
+ *  goto repeat;
+ * locked:
+ *  ...
+ * unlock:
+ *  wbias_write_unlock_irq(&lock);
+ */
+void wbias_write_lock_irq(wbias_rwlock_t *rwlock);
+int wbias_write_trylock_irq_else_subscribe(wbias_rwlock_t *rwlock);
+int wbias_write_trylock_irq_subscribed(wbias_rwlock_t *rwlock);
+
+static inline void wbias_write_unlock_irq(wbias_rwlock_t *rwlock)
+{
+	long v;
+	/*
+	 * atomic_long_sub makes sure we commit the data before reenabling
+	 * the lock.
+	 */
+	v = atomic_long_sub_return(HARDIRQ_WOFFSET
+			| SOFTIRQ_WOFFSET | WRITER_MUTEX,
+			&rwlock->v);
+	wbias_rwlock_irq_enable();
+	wbias_rwlock_bh_enable();
+	wbias_rwlock_preempt_enable();
+	wbias_rwlock_preempt_check(rwlock, v);
+}
+
+/*
+ * Safe against other writers in same context.
+ * If used in softirq handler or softirq off context, safe against :
+ * - softirq readers.
+ * If used in non-preemptable context, safe against :
+ * - softirq/npthread readers.
+ * If used in preemptable context, safe against :
+ * - softirq/npthread/pthread readers.
+ */
+void wbias_write_lock_bh(wbias_rwlock_t *rwlock);
+int wbias_write_trylock_bh_else_subscribe(wbias_rwlock_t *rwlock);
+int wbias_write_trylock_bh_subscribed(wbias_rwlock_t *rwlock);
+
+static inline void wbias_write_unlock_bh(wbias_rwlock_t *rwlock)
+{
+	long v;
+	/*
+	 * atomic_long_sub makes sure we commit the data before reenabling
+	 * the lock.
+	 */
+	v = atomic_long_sub_return(SOFTIRQ_WOFFSET | WRITER_MUTEX, &rwlock->v);
+	wbias_rwlock_bh_enable();
+	wbias_rwlock_preempt_enable();
+	wbias_rwlock_preempt_check(rwlock, v);
+}
+
+/*
+ * Safe against other writers in same context.
+ * If used in non-preemptable context, safe against :
+ * - non-preemptable readers.
+ * If used in preemptable context, safe against :
+ * - non-preemptable and preemptable thread readers.
+ */
+void wbias_write_lock_atomic(wbias_rwlock_t *rwlock);
+int wbias_write_trylock_atomic_else_subscribe(wbias_rwlock_t *rwlock);
+int wbias_write_trylock_atomic_subscribed(wbias_rwlock_t *rwlock);
+
+static inline void wbias_write_unlock_atomic(wbias_rwlock_t *rwlock)
+{
+	long v;
+	/*
+	 * atomic_long_sub makes sure we commit the data before reenabling
+	 * the lock.
+	 */
+	v = atomic_long_sub_return(WRITER_MUTEX, &rwlock->v);
+	wbias_rwlock_preempt_enable();
+	wbias_rwlock_preempt_check(rwlock, v);
+}
+
+/*
+ * Safe against other writers in same context.
+ * Safe against preemptable thread readers.
+ */
+void wbias_write_lock(wbias_rwlock_t *rwlock);
+int wbias_write_trylock_else_subscribe(wbias_rwlock_t *rwlock);
+int wbias_write_trylock_subscribed(wbias_rwlock_t *rwlock);
+
+static inline void wbias_write_unlock(wbias_rwlock_t *rwlock)
+{
+	long v;
+	/*
+	 * atomic_long_sub makes sure we commit the data before reenabling
+	 * the lock.
+	 */
+	v = atomic_long_sub_return(WRITER_MUTEX, &rwlock->v);
+	wbias_rwlock_preempt_check(rwlock, v);
+}
+
+/*
+ * Unsubscribe writer after a failed trylock.
+ * Should not be called after a successful trylock, since it unsubscribes
+ * when the lock is successfully taken.
+ */
+static inline void wbias_write_unsubscribe_atomic(wbias_rwlock_t *rwlock)
+{
+	long v;
+	v = atomic_long_sub_return(PTHREAD_WOFFSET | NPTHREAD_WOFFSET,
+		&rwlock->v);
+	wbias_rwlock_preempt_enable();
+	wbias_rwlock_preempt_check(rwlock, v);
+}
+
+#define wbias_write_unsubscribe_irq(rwlock)	\
+	wbias_write_unsubscribe_atomic(rwlock)
+#define wbias_write_unsubscribe_bh(rwlock)	\
+	wbias_write_unsubscribe_atomic(rwlock)
+
+static inline void wbias_write_unsubscribe(wbias_rwlock_t *rwlock)
+{
+	long v;
+	v = atomic_long_sub_return(PTHREAD_WOFFSET, &rwlock->v);
+	wbias_rwlock_preempt_check(rwlock, v);
+}
+
+#endif /* _LINUX_WBIAS_RWLOCK_H */
Index: linux-2.6-lttng/lib/Makefile
===================================================================
--- linux-2.6-lttng.orig/lib/Makefile	2008-08-21 04:06:52.000000000 -0400
+++ linux-2.6-lttng/lib/Makefile	2008-08-21 04:07:01.000000000 -0400
@@ -43,6 +43,13 @@ obj-$(CONFIG_DEBUG_PREEMPT) += smp_proce
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
 
+obj-y += wbias-rwlock.o
+ifneq ($(CONFIG_HAVE_WBIAS_RWLOCK_FASTPATH),y)
+obj-y += wbias-rwlock-fastpath.o
+endif
+obj-$(CONFIG_WBIAS_RWLOCK_LATENCY_TEST) += wbias-rwlock-latency-trace.o
+
+
 ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
   lib-y += dec_and_lock.o
 endif
Index: linux-2.6-lttng/lib/wbias-rwlock.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/lib/wbias-rwlock.c	2008-08-21 16:28:34.000000000 -0400
@@ -0,0 +1,679 @@
+/*
+ * Writer-biased low-latency rwlock
+ *
+ * Allows writer bias wrt readers threads and also minimally impact the irq
+ * and softirq latency of the system.
+ *
+ * A typical case leading to long interrupt latencies :
+ *
+ * - rwlock shared between
+ *   - Rare update in thread context
+ *   - Frequent slow read in thread context (task list iteration)
+ *   - Fast interrupt handler read
+ *
+ * The slow write must therefore disable interrupts around the write lock,
+ * but will therefore add up to the global interrupt latency; worse case being
+ * the duration of the slow read.
+ *
+ * This writer biased rwlock writer subscribes to the preemptable lock, which
+ * locks out the preemptable reader threads. It waits for all the preemptable
+ * reader threads to exit their critical section. Then, it disables preemption,
+ * subscribes for the non-preemptable lock. Then, it waits until all
+ * non-preemptable reader threads exited their critical section and takes the
+ * mutex (1 bit within the "long"). Then it disables softirqs, locks out the
+ * softirqs, waits for all softirqs to exit their critical section, disables
+ * irqs and locks out irqs. It then waits for irqs to exit their critical
+ * section. Only then is the writer allowed to modify the data structure.
+ *
+ * The writer fast path checks for a non-contended lock (all bits set to 0) and
+ * does an atomic cmpxchg to set the subscriptions, witer mutex, softirq
+ * exclusion and irq exclusion bits.
+ *
+ * The reader does an atomic cmpxchg to check if there is any contention on the
+ * lock. If not, it increments the reader count for its context (preemptable
+ * thread, non-preemptable thread, softirq, irq).
+ *
+ * Copyright 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/wbias-rwlock.h>
+#include <linux/wait.h>
+#include <linux/freezer.h>
+#include <linux/module.h>
+
+#ifdef WBIAS_RWLOCK_DEBUG
+#define printk_dbg printk
+#else
+#define printk_dbg(fmt, args...)
+#endif
+
+/*
+ * Lock out a specific execution context from the read lock. Wait for both the
+ * rmask and the wmask to be empty before proceeding to take the lock.
+ *
+ * Decrement wsuboffset when taking the wmask.
+ */
+static long _wbias_write_lock_ctx_wait(wbias_rwlock_t *rwlock,
+		long v, long rmask, long wmask, long woffset, long wsuboffset)
+{
+	long newv;
+
+	for (;;) {
+		if (v & (rmask | wmask)) {
+			/* Order v reads */
+			barrier();
+			v = atomic_long_read(&rwlock->v);
+			continue;
+		}
+		newv = atomic_long_cmpxchg(&rwlock->v,
+				v, v - wsuboffset + woffset);
+		if (likely(newv == v))
+			break;
+		else
+			v = newv;
+	}
+	printk_dbg("lib writer got in with v %lX, new %lX, rmask %lX\n",
+		v, v - wsuboffset + woffset, rmask);
+	return v - wsuboffset + woffset;
+}
+
+/*
+ * mask, v & mask_fill == mask_fill are the conditions for which we wait.
+ */
+static void rwlock_wait(wbias_rwlock_t *rwlock, long v, long mask,
+		long mask_fill, int check_mask_fill, int write)
+{
+	DECLARE_WAITQUEUE(wbias_rwlock_wq, current);
+	int wq_active;
+
+	/*
+	 * Busy-loop waiting for the waitqueue mutex.
+	 */
+	wbias_rwlock_irq_disable();
+	v = _wbias_write_lock_ctx_wait(rwlock, v, 0, WQ_MUTEX, WQ_MUTEX, 0);
+	/*
+	 * Before we go to sleep, check that the lock we were expecting
+	 * did not free between the moment we last checked for the lock and the
+	 * moment we took the WQ_MUTEX.
+	 */
+	if (!(v & mask || (check_mask_fill && (v & mask_fill) == mask_fill))) {
+		atomic_long_sub(WQ_MUTEX, &rwlock->v);
+		wbias_rwlock_irq_enable();
+		return;
+	}
+	/*
+	 * Got the waitqueue mutex, get into the wait queue.
+	 */
+	__set_current_state(TASK_UNINTERRUPTIBLE);
+	wq_active = waitqueue_active(&rwlock->wq_read)
+			|| waitqueue_active(&rwlock->wq_write);
+	/*
+	 * Only one thread will be woken up at a time.
+	 */
+	if (write)
+		add_wait_queue_exclusive_locked(&rwlock->wq_write,
+			&wbias_rwlock_wq);
+	else
+		__add_wait_queue(&rwlock->wq_read, &wbias_rwlock_wq);
+	if (!wq_active)
+		atomic_long_sub(WQ_MUTEX - WQ_ACTIVE, &rwlock->v);
+	else
+		atomic_long_sub(WQ_MUTEX, &rwlock->v);
+	wbias_rwlock_irq_enable();
+	try_to_freeze();
+	schedule();
+	/*
+	 * Woken up; Busy-loop waiting for the waitqueue mutex.
+	 */
+	wbias_rwlock_irq_disable();
+	v = atomic_long_read(&rwlock->v);
+	_wbias_write_lock_ctx_wait(rwlock, v, 0, WQ_MUTEX, WQ_MUTEX, 0);
+	__set_current_state(TASK_RUNNING);
+	if (write)
+		remove_wait_queue_locked(&rwlock->wq_write, &wbias_rwlock_wq);
+	else
+		remove_wait_queue_locked(&rwlock->wq_read, &wbias_rwlock_wq);
+	wq_active = waitqueue_active(&rwlock->wq_read)
+			|| waitqueue_active(&rwlock->wq_write);
+	if (!wq_active)
+		atomic_long_sub(WQ_MUTEX + WQ_ACTIVE, &rwlock->v);
+	else
+		atomic_long_sub(WQ_MUTEX, &rwlock->v);
+	wbias_rwlock_irq_enable();
+}
+
+/*
+ * Reader lock
+ *
+ * First try to get the uncontended lock. If it is non-zero (can be common,
+ * since we allow multiple readers), pass the returned cmpxchg v to the loop
+ * to try to get the reader lock.
+ *
+ * trylock will fail if a writer is subscribed or holds the lock, but will
+ * spin if there is concurency to win the cmpxchg. It could happen if, for
+ * instance, other concurrent reads need to update the roffset or if a
+ * writer updated the lock bits which does not contend us. Since many
+ * concurrent readers is a common case, it makes sense not to fail is it
+ * happens.
+ *
+ * the non-trylock case will spin for both situations.
+ *
+ * Busy-loop if the reader count is full.
+ */
+
+int _wbias_read_lock_slow(wbias_rwlock_t *rwlock,
+		long v, long roffset, long rmask, long wmask, int trylock)
+{
+	long newv;
+
+	for (;;) {
+		if (v & wmask || ((v & rmask) == rmask)) {
+			if (!trylock) {
+				/* Order v reads */
+				barrier();
+				v = atomic_long_read(&rwlock->v);
+				continue;
+			} else
+				return 0;
+		}
+
+		newv = atomic_long_cmpxchg(&rwlock->v, v, v + roffset);
+		if (likely(newv == v))
+			break;
+		else
+			v = newv;
+	}
+	printk_dbg("lib reader got in with v %lX, wmask %lX\n", v, wmask);
+	return 1;
+}
+EXPORT_SYMBOL(_wbias_read_lock_slow);
+
+int _wbias_read_lock_slow_preempt(wbias_rwlock_t *rwlock,
+		long v, long roffset, long rmask, long wmask, int trylock)
+{
+	int try = NR_PREEMPT_BUSY_LOOPS;
+	long newv;
+
+	might_sleep();
+	for (;;) {
+		if (v & wmask || ((v & rmask) == rmask)) {
+			if (unlikely(!(--try))) {
+				rwlock_wait(rwlock, v, wmask, rmask, 1, 0);
+				try = NR_PREEMPT_BUSY_LOOPS;
+			}
+			if (!trylock) {
+				/* Order v reads */
+				barrier();
+				v = atomic_long_read(&rwlock->v);
+				continue;
+			} else
+				return 0;
+		}
+
+		newv = atomic_long_cmpxchg(&rwlock->v, v, v + roffset);
+		if (likely(newv == v))
+			break;
+		else
+			v = newv;
+	}
+	printk_dbg("lib reader got in with v %lX, wmask %lX\n", v, wmask);
+	return 1;
+}
+EXPORT_SYMBOL(_wbias_read_lock_slow_preempt);
+
+/* Writer lock */
+
+static long _wbias_write_lock_ctx_wait_preempt(wbias_rwlock_t *rwlock,
+		long v, long rmask)
+{
+	int try = NR_PREEMPT_BUSY_LOOPS;
+
+	while (v & rmask) {
+		if (unlikely(!(--try))) {
+			rwlock_wait(rwlock, v, rmask, 0, 0, 1);
+			try = NR_PREEMPT_BUSY_LOOPS;
+		}
+		v = atomic_long_read(&rwlock->v);
+		/* Order v reads */
+		barrier();
+	}
+	printk_dbg("lib writer got in with v %lX, rmask %lX\n", v, rmask);
+	return v;
+}
+
+/*
+ * Lock out a specific execution context from the read lock. First lock the read
+ * context out of the lock, then wait for every readers to exit their critical
+ * section. This function should always be called when the WRITER_MUTEX bit is
+ * held because it expects to the the woffset bit as a one-hot.
+ */
+static void _wbias_write_lock_ctx_exclusive(wbias_rwlock_t *rwlock,
+		long rmask, long woffset)
+{
+	long v;
+
+	atomic_long_add(woffset, &rwlock->v);
+	do {
+		v = atomic_long_read(&rwlock->v);
+		/* Order v reads */
+		barrier();
+	} while (v & rmask);
+	printk_dbg("lib writer got in with v %lX, woffset %lX, rmask %lX\n",
+		v, woffset, rmask);
+}
+
+/*
+ * Subscribe to write lock.
+ * Busy-loop if the writer count reached its max.
+ */
+static long _wbias_write_subscribe(wbias_rwlock_t *rwlock, long v,
+		long wmask, long woffset)
+{
+	long newv;
+
+	for (;;) {
+		if ((v & wmask) == wmask) {
+			/* Order v reads */
+			barrier();
+			v = atomic_long_read(&rwlock->v);
+			continue;
+		}
+		newv = atomic_long_cmpxchg(&rwlock->v, v, v + woffset);
+		if (likely(newv == v))
+			break;
+		else
+			v = newv;
+	}
+	return v + woffset;
+}
+
+void _wbias_write_lock_irq_slow(wbias_rwlock_t *rwlock, long v)
+{
+	WARN_ON_ONCE(!in_softirq() || !irqs_disabled());
+
+	wbias_rwlock_irq_enable();
+	wbias_rwlock_bh_enable();
+	wbias_rwlock_preempt_enable();
+
+	/* lock out preemptable threads */
+	v = _wbias_write_subscribe(rwlock, v, PTHREAD_WMASK, PTHREAD_WOFFSET);
+
+	/*
+	 * continue when no preemptable reader threads left, but keep
+	 * subscription.
+	 */
+	v = _wbias_write_lock_ctx_wait_preempt(rwlock, v, PTHREAD_RMASK);
+
+	/*
+	 * lock out non-preemptable threads. Atomically unsubscribe from
+	 * preemptable thread lock out and subscribe for non-preemptable thread
+	 * lock out. Preemptable threads must check for NPTHREAD_WMASK and
+	 * WRITER_MUTEX too.
+	 */
+	wbias_rwlock_preempt_disable();
+	v = _wbias_write_subscribe(rwlock, v, NPTHREAD_WMASK,
+		NPTHREAD_WOFFSET - PTHREAD_WOFFSET);
+
+	/* lock out other writers when no non-preemptable reader threads left */
+	_wbias_write_lock_ctx_wait(rwlock, v, NPTHREAD_RMASK,
+		WRITER_MUTEX, WRITER_MUTEX, NPTHREAD_WOFFSET);
+
+	/* lock out softirqs */
+	wbias_rwlock_bh_disable();
+	_wbias_write_lock_ctx_exclusive(rwlock, SOFTIRQ_RMASK, SOFTIRQ_WOFFSET);
+
+	/* lock out hardirqs */
+	wbias_rwlock_irq_disable();
+	_wbias_write_lock_ctx_exclusive(rwlock, HARDIRQ_RMASK, HARDIRQ_WOFFSET);
+
+	/* atomic_long_cmpxchg orders writes */
+}
+
+/*
+ * Will take the lock or subscribe. Will fail if there is contention caused by
+ * other writers. Will also fail if there is concurrent cmpxchg update, even if
+ * it is only a writer subscription. It is not considered as a common case and
+ * therefore does not justify looping.
+ *
+ * Disables preemption if fails.
+ */
+int _wbias_write_trylock_irq_else_subscribe_slow(wbias_rwlock_t *rwlock,
+		long v)
+{
+	WARN_ON_ONCE(!in_softirq() || !irqs_disabled());
+
+	wbias_rwlock_irq_enable();
+	wbias_rwlock_bh_enable();
+
+	/* lock out preemptable and non-preemptable threads */
+	v = _wbias_write_subscribe(rwlock, v,
+		PTHREAD_WMASK | NPTHREAD_WMASK,
+		PTHREAD_WOFFSET | NPTHREAD_WOFFSET);
+
+	if (likely(!(v & ~(PTHREAD_WMASK | NPTHREAD_WMASK)))) {
+		/* no other reader nor writer present, try to take the lock */
+		wbias_rwlock_bh_disable();
+		wbias_rwlock_irq_disable();
+		if (likely(atomic_long_cmpxchg(&rwlock->v, v,
+			v - (PTHREAD_WOFFSET | NPTHREAD_WOFFSET)
+			+ (SOFTIRQ_WOFFSET | HARDIRQ_WOFFSET | WRITER_MUTEX))
+				== v))
+			return 1;
+		wbias_rwlock_irq_enable();
+		wbias_rwlock_bh_enable();
+	}
+	return 0;
+}
+
+int _wbias_write_trylock_irq_subscribed_slow(wbias_rwlock_t *rwlock,
+		long v)
+{
+	WARN_ON_ONCE(!in_softirq() || !irqs_disabled());
+
+	wbias_rwlock_irq_enable();
+	wbias_rwlock_bh_enable();
+
+	if (likely(!(v & ~(PTHREAD_WMASK | NPTHREAD_WMASK)))) {
+		/* no other reader nor writer present, try to take the lock */
+		wbias_rwlock_bh_disable();
+		wbias_rwlock_irq_disable();
+		if (likely(atomic_long_cmpxchg(&rwlock->v, v,
+			v - (PTHREAD_WOFFSET | NPTHREAD_WOFFSET)
+			+ (SOFTIRQ_WOFFSET | HARDIRQ_WOFFSET | WRITER_MUTEX))
+				== v))
+			return 1;
+		wbias_rwlock_irq_enable();
+		wbias_rwlock_bh_enable();
+	}
+	return 0;
+}
+
+
+void _wbias_write_lock_bh_slow(wbias_rwlock_t *rwlock, long v)
+{
+	WARN_ON_ONCE(v & (HARDIRQ_RMASK | HARDIRQ_WMASK));
+	WARN_ON_ONCE(in_interrupt() || irqs_disabled());
+
+	wbias_rwlock_bh_enable();
+	wbias_rwlock_preempt_enable();
+
+	/* lock out preemptable threads */
+	v = _wbias_write_subscribe(rwlock, v, PTHREAD_WMASK, PTHREAD_WOFFSET);
+
+	/*
+	 * continue when no preemptable reader threads left, but keep
+	 * subscription.
+	 */
+	v = _wbias_write_lock_ctx_wait_preempt(rwlock, v, PTHREAD_RMASK);
+
+	/*
+	 * lock out non-preemptable threads. Atomically unsubscribe from
+	 * preemptable thread lock out and subscribe for non-preemptable thread
+	 * lock out. Preemptable threads must check for NPTHREAD_WMASK and
+	 * WRITER_MUTEX too.
+	 */
+	wbias_rwlock_preempt_disable();
+	v = _wbias_write_subscribe(rwlock, v, NPTHREAD_WMASK,
+		NPTHREAD_WOFFSET - PTHREAD_WOFFSET);
+
+	/* lock out other writers when no non-preemptable reader threads left */
+	_wbias_write_lock_ctx_wait(rwlock, v, NPTHREAD_RMASK,
+		WRITER_MUTEX, WRITER_MUTEX, NPTHREAD_WOFFSET);
+
+	/* lock out softirqs */
+	wbias_rwlock_bh_disable();
+	_wbias_write_lock_ctx_exclusive(rwlock, SOFTIRQ_RMASK, SOFTIRQ_WOFFSET);
+
+	/* atomic_long_cmpxchg orders writes */
+}
+
+/*
+ * Will take the lock or subscribe. Will fail if there is contention caused by
+ * other writers. Will also fail if there is concurrent cmpxchg update, even if
+ * it is only a writer subscription. It is not considered as a common case and
+ * therefore does not justify looping.
+ *
+ * Disables preemption if fails.
+ */
+int _wbias_write_trylock_bh_else_subscribe_slow(wbias_rwlock_t *rwlock,
+		long v)
+{
+	WARN_ON_ONCE(v & (HARDIRQ_RMASK | HARDIRQ_WMASK));
+	WARN_ON_ONCE(in_interrupt() || irqs_disabled());
+
+	wbias_rwlock_bh_enable();
+
+	/* lock out preemptable and non-preemptable threads */
+	v = _wbias_write_subscribe(rwlock, v,
+		PTHREAD_WMASK | NPTHREAD_WMASK,
+		PTHREAD_WOFFSET | NPTHREAD_WOFFSET);
+
+	if (likely(!(v & ~(PTHREAD_WMASK | NPTHREAD_WMASK)))) {
+		/* no other reader nor writer present, try to take the lock */
+		wbias_rwlock_bh_disable();
+		if (likely(atomic_long_cmpxchg(&rwlock->v, v,
+			v - (PTHREAD_WOFFSET | NPTHREAD_WOFFSET)
+			+ (SOFTIRQ_WOFFSET | WRITER_MUTEX))
+				== v))
+			return 1;
+		wbias_rwlock_bh_enable();
+	}
+	return 0;
+}
+
+int _wbias_write_trylock_bh_subscribed_slow(wbias_rwlock_t *rwlock,
+		long v)
+{
+	WARN_ON_ONCE(v & (HARDIRQ_RMASK | HARDIRQ_WMASK));
+	WARN_ON_ONCE(in_interrupt() || irqs_disabled());
+
+	wbias_rwlock_bh_enable();
+
+	if (likely(!(v & ~(PTHREAD_WMASK | NPTHREAD_WMASK)))) {
+		/* no other reader nor writer present, try to take the lock */
+		wbias_rwlock_bh_disable();
+		if (likely(atomic_long_cmpxchg(&rwlock->v, v,
+			v - (PTHREAD_WOFFSET | NPTHREAD_WOFFSET)
+			+ (SOFTIRQ_WOFFSET | WRITER_MUTEX))
+				== v))
+			return 1;
+		wbias_rwlock_bh_enable();
+	}
+	return 0;
+}
+
+void _wbias_write_lock_atomic_slow(wbias_rwlock_t *rwlock, long v)
+{
+	WARN_ON_ONCE(v & (HARDIRQ_RMASK | SOFTIRQ_RMASK
+			| HARDIRQ_WMASK | SOFTIRQ_WMASK));
+	WARN_ON_ONCE(in_interrupt() || irqs_disabled());
+
+	wbias_rwlock_preempt_enable();
+
+	/* lock out preemptable threads */
+	v = _wbias_write_subscribe(rwlock, v, PTHREAD_WMASK, PTHREAD_WOFFSET);
+
+	/*
+	 * continue when no preemptable reader threads left, but keep
+	 * subscription.
+	 */
+	v = _wbias_write_lock_ctx_wait_preempt(rwlock, v, PTHREAD_RMASK);
+
+	/*
+	 * lock out non-preemptable threads. Atomically unsubscribe from
+	 * preemptable thread lock out and subscribe for non-preemptable thread
+	 * lock out. Preemptable threads must check for NPTHREAD_WMASK and
+	 * WRITER_MUTEX too.
+	 */
+	wbias_rwlock_preempt_disable();
+	v = _wbias_write_subscribe(rwlock, v, NPTHREAD_WMASK,
+		NPTHREAD_WOFFSET - PTHREAD_WOFFSET);
+
+	/* lock out other writers when no non-preemptable reader threads left */
+	_wbias_write_lock_ctx_wait(rwlock, v, NPTHREAD_RMASK,
+		WRITER_MUTEX, WRITER_MUTEX, NPTHREAD_WOFFSET);
+
+	/* atomic_long_cmpxchg orders writes */
+}
+
+/*
+ * Will take the lock or subscribe. Will fail if there is contention caused by
+ * other writers. Will also fail if there is concurrent cmpxchg update, even if
+ * it is only a writer subscription. It is not considered as a common case and
+ * therefore does not justify looping.
+ *
+ * Disables preemption if fails.
+ */
+int _wbias_write_trylock_atomic_else_subscribe_slow(wbias_rwlock_t *rwlock,
+		long v)
+{
+	WARN_ON_ONCE(v & (HARDIRQ_RMASK | SOFTIRQ_RMASK
+			| HARDIRQ_WMASK | SOFTIRQ_WMASK));
+	WARN_ON_ONCE(in_interrupt() || irqs_disabled());
+
+	/* lock out preemptable and non-preemptable threads */
+	v = _wbias_write_subscribe(rwlock, v,
+		PTHREAD_WMASK | NPTHREAD_WMASK,
+		PTHREAD_WOFFSET | NPTHREAD_WOFFSET);
+
+	if (likely(!(v & ~(PTHREAD_WMASK | NPTHREAD_WMASK)))) {
+		/* no other reader nor writer present, try to take the lock */
+		if (likely(atomic_long_cmpxchg(&rwlock->v, v,
+			v - (PTHREAD_WOFFSET | NPTHREAD_WOFFSET) + WRITER_MUTEX)
+				== v))
+			return 1;
+	}
+	return 0;
+}
+
+int _wbias_write_trylock_atomic_subscribed_slow(wbias_rwlock_t *rwlock,
+		long v)
+{
+	WARN_ON_ONCE(v & (HARDIRQ_RMASK | SOFTIRQ_RMASK
+			| HARDIRQ_WMASK | SOFTIRQ_WMASK));
+	WARN_ON_ONCE(in_interrupt() || irqs_disabled());
+
+	if (likely(!(v & ~(PTHREAD_WMASK | NPTHREAD_WMASK)))) {
+		/* no other reader nor writer present, try to take the lock */
+		if (likely(atomic_long_cmpxchg(&rwlock->v, v,
+			v - (PTHREAD_WOFFSET | NPTHREAD_WOFFSET) + WRITER_MUTEX)
+				== v))
+			return 1;
+	}
+	return 0;
+}
+
+void _wbias_write_lock_slow(wbias_rwlock_t *rwlock, long v)
+{
+	int try = NR_PREEMPT_BUSY_LOOPS;
+	long newv;
+
+	WARN_ON_ONCE(v & (HARDIRQ_RMASK | SOFTIRQ_RMASK | NPTHREAD_RMASK
+			| HARDIRQ_WMASK | SOFTIRQ_WMASK | NPTHREAD_WMASK));
+	WARN_ON_ONCE(in_atomic() || irqs_disabled());
+	might_sleep();
+
+	/* lock out preemptable threads */
+	v = _wbias_write_subscribe(rwlock, v, PTHREAD_WMASK, PTHREAD_WOFFSET);
+
+	/* lock out other writers when no preemptable reader threads left */
+	for (;;) {
+		if (v & (PTHREAD_RMASK | WRITER_MUTEX)) {
+			if (unlikely(!(--try))) {
+				rwlock_wait(rwlock, v,
+					PTHREAD_RMASK | WRITER_MUTEX, 0, 0, 1);
+				try = NR_PREEMPT_BUSY_LOOPS;
+			}
+			/* Order v reads */
+			barrier();
+			v = atomic_long_read(&rwlock->v);
+			continue;
+		}
+		newv = atomic_long_cmpxchg(&rwlock->v,
+			v, v - PTHREAD_WOFFSET + WRITER_MUTEX);
+		if (likely(newv == v))
+			break;
+		else
+			v = newv;
+	}
+
+	/* atomic_long_cmpxchg orders writes */
+}
+
+/*
+ * Will take the lock or subscribe. Will fail if there is contention caused by
+ * other writers. Will also fail if there is concurrent cmpxchg update, even if
+ * it is only a writer subscription. It is not considered as a common case and
+ * therefore does not justify looping.
+ */
+int _wbias_write_trylock_else_subscribe_slow(wbias_rwlock_t *rwlock,
+		long v)
+{
+	WARN_ON_ONCE(v & (HARDIRQ_RMASK | SOFTIRQ_RMASK | NPTHREAD_RMASK
+			| HARDIRQ_WMASK | SOFTIRQ_WMASK | NPTHREAD_WMASK));
+	WARN_ON_ONCE(in_atomic() || irqs_disabled());
+	might_sleep();
+
+	/* lock out preemptable threads */
+	v = _wbias_write_subscribe(rwlock, v, PTHREAD_WMASK, PTHREAD_WOFFSET);
+
+	if (likely(!(v & ~PTHREAD_WMASK))) {
+		/* no other reader nor writer present, try to take the lock */
+		if (likely(atomic_long_cmpxchg(&rwlock->v, v,
+			v - PTHREAD_WOFFSET + WRITER_MUTEX) == v))
+			return 1;
+	}
+	return 0;
+}
+
+int _wbias_write_trylock_subscribed_slow(wbias_rwlock_t *rwlock,
+		long v)
+{
+	WARN_ON_ONCE(v & (HARDIRQ_RMASK | SOFTIRQ_RMASK | NPTHREAD_RMASK
+			| HARDIRQ_WMASK | SOFTIRQ_WMASK | NPTHREAD_WMASK));
+	WARN_ON_ONCE(in_atomic() || irqs_disabled());
+	might_sleep();
+
+	if (likely(!(v & ~PTHREAD_WMASK))) {
+		/* no other reader nor writer present, try to take the lock */
+		if (likely(atomic_long_cmpxchg(&rwlock->v, v,
+			v - PTHREAD_WOFFSET + WRITER_MUTEX) == v))
+			return 1;
+	}
+	return 0;
+}
+
+/*
+ * Called from any context (irq/softirq/preempt/non-preempt). Contains a
+ * busy-loop; must therefore disable interrupts, but only for a short time.
+ */
+void _wbias_rwlock_wakeup(wbias_rwlock_t *rwlock, long v)
+{
+	unsigned long flags;
+	/*
+	 * If there is at least one non-preemptable writer subscribed or holding
+	 * higher priority write masks, let it handle the wakeup when it exits
+	 * its critical section which excludes any preemptable context anyway.
+	 * The same applies to preemptable readers, which are the only ones
+	 * which can cause a preemptable writer to sleep.
+	 */
+	if (v & (HARDIRQ_WMASK | SOFTIRQ_WMASK | WRITER_MUTEX | NPTHREAD_WMASK
+		| PTHREAD_RMASK))
+		return;
+	/*
+	 * Busy-loop waiting for the waitqueue mutex.
+	 */
+	wbias_rwlock_irq_save(flags);
+	_wbias_write_lock_ctx_wait(rwlock, v, 0, WQ_MUTEX, WQ_MUTEX, 0);
+	/*
+	 * First do an exclusive wake-up of the first writer if there is one
+	 * waiting, else wake-up the readers.
+	 */
+	if (waitqueue_active(&rwlock->wq_write))
+		wake_up_locked(&rwlock->wq_write);
+	else
+		wake_up_locked(&rwlock->wq_read);
+	atomic_long_sub(WQ_MUTEX, &rwlock->v);
+	wbias_rwlock_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(_wbias_rwlock_wakeup);
Index: linux-2.6-lttng/lib/wbias-rwlock-fastpath.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/lib/wbias-rwlock-fastpath.c	2008-08-21 16:30:59.000000000 -0400
@@ -0,0 +1,204 @@
+/*
+ * Writer-biased low-latency rwlock
+ *
+ * Allows writer bias wrt readers and also minimally impact the irq latency
+ * of the system. Architecture-agnostic fastpath which can be replaced by
+ * architecture-specific assembly code by setting the Kconfig option
+ * HAVE_WBIAS_RWLOCK_FASTPATH.
+ *
+ * See wbias-rwlock.c for details. It contains the slow paths.
+ *
+ * Copyright 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/wbias-rwlock.h>
+#include <linux/module.h>
+
+void wbias_write_lock_irq(wbias_rwlock_t *rwlock)
+{
+	long v;
+
+	wbias_rwlock_preempt_disable();
+	wbias_rwlock_bh_disable();
+	wbias_rwlock_irq_disable();
+	/* no other reader nor writer present, try to take the lock */
+	v = atomic_long_cmpxchg(&rwlock->v, 0,
+			SOFTIRQ_WOFFSET | HARDIRQ_WOFFSET | WRITER_MUTEX);
+	if (likely(!v))
+		return;
+	else
+		_wbias_write_lock_irq_slow(rwlock, v);
+}
+EXPORT_SYMBOL_GPL(wbias_write_lock_irq);
+
+/*
+ * Disables preemption even if fails.
+ */
+int wbias_write_trylock_irq_else_subscribe(wbias_rwlock_t *rwlock)
+{
+	long v;
+
+	wbias_rwlock_preempt_disable();
+	wbias_rwlock_bh_disable();
+	wbias_rwlock_irq_disable();
+	/* no other reader nor writer present, try to take the lock */
+	v = atomic_long_cmpxchg(&rwlock->v, 0,
+			SOFTIRQ_WOFFSET | HARDIRQ_WOFFSET | WRITER_MUTEX);
+	if (likely(!v))
+		return 1;
+	else
+		return _wbias_write_trylock_irq_else_subscribe_slow(rwlock, v);
+}
+EXPORT_SYMBOL_GPL(wbias_write_trylock_irq_else_subscribe);
+
+int wbias_write_trylock_irq_subscribed(wbias_rwlock_t *rwlock)
+{
+	long v;
+
+	wbias_rwlock_bh_disable();
+	wbias_rwlock_irq_disable();
+	/* no other reader nor writer present, try to take the lock */
+	v = atomic_long_cmpxchg(&rwlock->v, PTHREAD_WOFFSET | NPTHREAD_WOFFSET,
+			SOFTIRQ_WOFFSET | HARDIRQ_WOFFSET | WRITER_MUTEX);
+	if (likely(v == (PTHREAD_WOFFSET | NPTHREAD_WOFFSET)))
+		return 1;
+	else
+		return _wbias_write_trylock_irq_subscribed_slow(rwlock, v);
+}
+EXPORT_SYMBOL_GPL(wbias_write_trylock_irq_subscribed);
+
+void wbias_write_lock_bh(wbias_rwlock_t *rwlock)
+{
+	long v;
+
+	wbias_rwlock_preempt_disable();
+	wbias_rwlock_bh_disable();
+	/* no other reader nor writer present, try to take the lock */
+	v = atomic_long_cmpxchg(&rwlock->v, 0, SOFTIRQ_WOFFSET | WRITER_MUTEX);
+	if (likely(!v))
+		return;
+	else
+		_wbias_write_lock_bh_slow(rwlock, v);
+}
+EXPORT_SYMBOL_GPL(wbias_write_lock_bh);
+
+/*
+ * Disables preemption even if fails.
+ */
+int wbias_write_trylock_bh_else_subscribe(wbias_rwlock_t *rwlock)
+{
+	long v;
+
+	wbias_rwlock_preempt_disable();
+	wbias_rwlock_bh_disable();
+	/* no other reader nor writer present, try to take the lock */
+	v = atomic_long_cmpxchg(&rwlock->v, 0, SOFTIRQ_WOFFSET | WRITER_MUTEX);
+	if (likely(!v))
+		return 1;
+	else
+		return _wbias_write_trylock_bh_else_subscribe_slow(rwlock, v);
+}
+EXPORT_SYMBOL_GPL(wbias_write_trylock_bh_else_subscribe);
+
+int wbias_write_trylock_bh_subscribed(wbias_rwlock_t *rwlock)
+{
+	long v;
+
+	/* no other reader nor writer present, try to take the lock */
+	v = atomic_long_cmpxchg(&rwlock->v, PTHREAD_WOFFSET | NPTHREAD_WOFFSET,
+			SOFTIRQ_WOFFSET | WRITER_MUTEX);
+	if (likely(v == (PTHREAD_WOFFSET | NPTHREAD_WOFFSET)))
+		return 1;
+	else
+		return _wbias_write_trylock_bh_subscribed_slow(rwlock, v);
+}
+EXPORT_SYMBOL_GPL(wbias_write_trylock_bh_subscribed);
+
+
+void wbias_write_lock_atomic(wbias_rwlock_t *rwlock)
+{
+	long v;
+
+	wbias_rwlock_preempt_disable();
+	/* no other reader nor writer present, try to take the lock */
+	v = atomic_long_cmpxchg(&rwlock->v, 0, WRITER_MUTEX);
+	if (likely(!v))
+		return;
+	else
+		_wbias_write_lock_atomic_slow(rwlock, v);
+}
+EXPORT_SYMBOL_GPL(wbias_write_lock_atomic);
+
+int wbias_write_trylock_atomic_else_subscribe(wbias_rwlock_t *rwlock)
+{
+	long v;
+
+	wbias_rwlock_preempt_disable();
+	/* no other reader nor writer present, try to take the lock */
+	v = atomic_long_cmpxchg(&rwlock->v, 0, WRITER_MUTEX);
+	if (likely(!v))
+		return 1;
+	else
+		return _wbias_write_trylock_atomic_else_subscribe_slow(rwlock,
+				v);
+}
+EXPORT_SYMBOL_GPL(wbias_write_trylock_atomic_else_subscribe);
+
+int wbias_write_trylock_atomic_subscribed(wbias_rwlock_t *rwlock)
+{
+	long v;
+
+	/* no other reader nor writer present, try to take the lock */
+	v = atomic_long_cmpxchg(&rwlock->v, PTHREAD_WOFFSET | NPTHREAD_WOFFSET,
+			WRITER_MUTEX);
+	if (likely(v == (PTHREAD_WOFFSET | NPTHREAD_WOFFSET)))
+		return 1;
+	else
+		return _wbias_write_trylock_atomic_subscribed_slow(rwlock, v);
+}
+EXPORT_SYMBOL_GPL(wbias_write_trylock_atomic_subscribed);
+
+
+void wbias_write_lock(wbias_rwlock_t *rwlock)
+{
+	long v;
+
+	/* no other reader nor writer present, try to take the lock */
+	v = atomic_long_cmpxchg(&rwlock->v, 0, WRITER_MUTEX);
+	if (likely(!v))
+		return;
+	else
+		_wbias_write_lock_slow(rwlock, v);
+}
+EXPORT_SYMBOL_GPL(wbias_write_lock);
+
+int wbias_write_trylock_else_subscribe(wbias_rwlock_t *rwlock)
+{
+	long v;
+
+	/* no other reader nor writer present, try to take the lock */
+	v = atomic_long_cmpxchg(&rwlock->v, 0, WRITER_MUTEX);
+	if (likely(!v))
+		return 1;
+	else
+		return _wbias_write_trylock_else_subscribe_slow(rwlock, v);
+}
+EXPORT_SYMBOL_GPL(wbias_write_trylock_else_subscribe);
+
+/*
+ * Should be called with preemption off, already subscribed.
+ * Supports having NPTHREAD_WOFFSET set even if unused to balance unsubscribe.
+ */
+int wbias_write_trylock_subscribed(wbias_rwlock_t *rwlock)
+{
+	long v;
+
+	/* no other reader nor writer present, try to take the lock */
+	v = atomic_long_cmpxchg(&rwlock->v, PTHREAD_WOFFSET | NPTHREAD_WOFFSET,
+			WRITER_MUTEX);
+	if (likely(v == (PTHREAD_WOFFSET | NPTHREAD_WOFFSET)))
+		return 1;
+	else
+		return _wbias_write_trylock_subscribed_slow(rwlock, v);
+}
+EXPORT_SYMBOL_GPL(wbias_write_trylock_subscribed);
Index: linux-2.6-lttng/lib/Kconfig
===================================================================
--- linux-2.6-lttng.orig/lib/Kconfig	2008-08-21 04:06:52.000000000 -0400
+++ linux-2.6-lttng/lib/Kconfig	2008-08-21 04:07:01.000000000 -0400
@@ -157,4 +157,7 @@ config CHECK_SIGNATURE
 config HAVE_LMB
 	boolean
 
+config HAVE_WBIAS_RWLOCK_FASTPATH
+	def_bool n
+
 endmenu
Index: linux-2.6-lttng/lib/Kconfig.debug
===================================================================
--- linux-2.6-lttng.orig/lib/Kconfig.debug	2008-08-21 12:26:46.000000000 -0400
+++ linux-2.6-lttng/lib/Kconfig.debug	2008-08-21 12:27:38.000000000 -0400
@@ -680,6 +680,10 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	help
 	  Provide stacktrace filter for fault-injection capabilities
 
+config DEBUG_WBIAS_RWLOCK
+	boolean "Debug writer-biased rwlock"
+	help
+
 config LATENCYTOP
 	bool "Latency measuring infrastructure"
 	select FRAME_POINTER if !MIPS

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
