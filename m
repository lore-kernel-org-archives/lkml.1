Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515Ab0AHX4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab0AHX4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 18:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497Ab0AHX4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 18:56:52 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:62196 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754419Ab0AHX4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 18:56:51 -0500
Date: Fri, 8 Jan 2010 18:56:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Peter Zijlstra <peterz@infradead.org>,
       Josh Triplett <josh@joshtriplett.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v2)
Message-ID: <20100108235649.GA18477@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:53:58 up 23 days,  8:12,  6 users,  load average: 0.22, 0.13,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is an implementation of a new system call, sys_membarrier(), which
executes a memory barrier on all threads of the current process.
 
It aims at greatly simplifying and enhancing the current signal-based
liburcu userspace RCU synchronize_rcu() implementation.
(found at http://lttng.org/urcu)

Changelog since v1:

- Only perform the IPI in CONFIG_SMP.
- Only perform the IPI if the process has more than one thread.
- Only send IPIs to CPUs involved with threads belonging to our process.
- Adaptative IPI scheme (single vs many IPI with threshold).
- Issue smp_mb() at the beginning and end of the system call.

TODO:
- We must make sure that the scheduler issues a memory barrier between
  - Last user-space instruction executed and runqueue ->mm modification.
  - runqueue ->mm modification and first user-space instruction.
  and document their location (so they won't be removed).

Both the signal-based and the sys_membarrier userspace RCU schemes
permit us to remove the memory barrier from the userspace RCU
rcu_read_lock() and rcu_read_unlock() primitives, thus significantly
accelerating them. These memory barriers are replaced by compiler
barriers on the read-side, and all matching memory barriers on the 
write-side are turned into an invokation of a memory barrier on all
active threads in the process. By letting the kernel perform this
synchronization rather than dumbly sending a signal to every process
threads (as we currently do), we diminish the number of unnecessary wake
ups and only issue the memory barriers on active threads. Non-running
threads do not need to execute such barrier anyway, because these are
implied by the scheduler context switches.

To explain the benefit of this scheme, let's introduce two example threads:
 
Thread A (non-frequent, e.g. executing liburcu synchronize_rcu())
Thread B (frequent, e.g. executing liburcu rcu_read_lock()/rcu_read_unlock())

In a scheme where all smp_mb() in thread A synchronize_rcu() are
ordering memory accesses with respect to smp_mb() present in 
rcu_read_lock/unlock(), we can change all smp_mb() from
synchronize_rcu() into calls to sys_membarrier() and all smp_mb() from
rcu_read_lock/unlock() into compiler barriers "barrier()".

Before the change, we had, for each smp_mb() pairs:

Thread A                    Thread B
prev mem accesses           prev mem accesses
smp_mb()                    smp_mb()
follow mem accesses         follow mem accesses

After the change, these pairs become:

Thread A                    Thread B
prev mem accesses           prev mem accesses
sys_membarrier()            barrier()
follow mem accesses         follow mem accesses

As we can see, there are two possible scenarios: either Thread B memory
accesses do not happen concurrently with Thread A accesses (1), or they
do (2).

1) Non-concurrent Thread A vs Thread B accesses:

Thread A                    Thread B
prev mem accesses
sys_membarrier()
follow mem accesses
                            prev mem accesses
                            barrier()
                            follow mem accesses

In this case, thread B accesses will be weakly ordered. This is OK,
because at that point, thread A is not particularly interested in
ordering them with respect to its own accesses.

2) Concurrent Thread A vs Thread B accesses

Thread A                    Thread B
prev mem accesses           prev mem accesses
sys_membarrier()            barrier()
follow mem accesses         follow mem accesses

In this case, thread B accesses, which are ensured to be in program
order thanks to the compiler barrier, will be "upgraded" to full
smp_mb() thanks to the IPIs executing memory barriers on each active
system threads. Each non-running process threads are intrinsically
serialized by the scheduler.

Just tried with a cache-hot kernel compilation using 6/8 CPUs.

Normally:                                              real 2m41.852s
With the sys_membarrier+1 busy-looping thread running: real 5m41.830s

So... 2x slower. That hurts.

So let's try allocating a cpu mask for PeterZ scheme. I prefer to have a
small allocation overhead and benefit from cpumask broadcast if
possible so we scale better. But that all depends on how big the
allocation overhead is.

Impact of allocating a cpumask (time for 10,000,000 sys_membarrier
calls, one thread is doing the sys_membarrier, the others are busy
looping)):

IPI to all:                                            real 0m44.708s
alloc cpumask+local mb()+broadcast IPI to 1 thread:    real 1m2.034s

So, roughly, the cpumask allocation overhead is 17s here, not exactly
cheap. So let's see when it becomes better than single IPIs:

local mb()+single IPI to 1 thread:                     real 0m42.434s
local mb()+single IPI to 7 threads:                    real 3m29.795s

So, roughly, the single IPI overhead is 137s here for 6 more threads,
for 22.8s per thread.

Here is what we can do: Given that it costs almost half as much to
perform the cpumask allocation than to send a single IPI, as we iterate
on the CPUs until we find more than N match or iterated on all cpus.
If we only have N match or less, we send single IPIs. If we need more
than that, then we switch to the cpumask allocation and send a broadcast
IPI to the cpumask we construct for the matching CPUs. Let's call it the
"adaptative IPI scheme".

For my Intel Xeon E5405 (new set of results, disabled kernel debugging)

Just doing local mb()+single IPI to T other threads:

T=1: 0m18.801s
T=2: 0m29.086s
T=3: 0m46.841s
T=4: 0m53.758s
T=5: 1m10.856s
T=6: 1m21.142s
T=7: 1m38.362s

Just doing cpumask alloc+IPI-many to T other threads:

T=1: 0m21.778s
T=2: 0m22.741s
T=3: 0m22.185s
T=4: 0m24.660s
T=5: 0m26.855s
T=6: 0m30.841s
T=7: 0m29.551s

So I think the right threshold should be 1 thread (assuming other
architecture will behave like mine). So starting with 2 threads, we
allocate the cpumask and send IPIs.

The resulting adaptative scheme:

T=1: 0m13.911s
T=2: 0m20.730s
T=3: 0m21.474s
T=4: 0m27.952s
T=5: 0m26.286s
T=6: 0m27.855s
T=7: 0m29.695s

A benchmark taking the runqueue locks (and disabling irqs) for each cpu shows
that it's significantly slower. Thus, as we can manage to only rely on the
scheduler memory barriers between rq ->mm updates and execution of userland
code, so we don't need the spinlocks.

With runqueue locks:

T=1: 0m15.802s
T=2: 0m22.484s
T=3: 0m24.751s
T=4: 0m29.134s
T=5: 0m30.094s
T=6: 0m33.090s
T=7: 0m33.897s

After adding proper memory barriers at the beginning/end of the system call
(they were missing in the previous tests, needed for correctness), without
spinlocks, we end up with:

T=1: 0m14.326s
T=2: 0m20.278s
T=3: 0m21.661s
T=4: 0m22.320s
T=5: 0m27.088s
T=6: 0m29.378s
T=7: 0m30.523s

The expected top pattern, when using 1 CPU for a thread doing sys_membarrier()
in a loop and other threads busy-waiting in user-space on a variable shows that
the thread doing sys_membarrier is doing mostly system calls, and other threads
are mostly running in user-space. Side-note, in this test, it's important to
check that individual threads are not always fully at 100% user-space time (they
range between ~95% and 100%), because when some thread in the test is always at
100% on the same CPU, this means it does not get the IPI at all. (I actually
found out about a bug in my own code while developing it with this test.)

Cpu0  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  : 99.7%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.3%hi,  0.0%si,  0.0%st
Cpu2  : 99.3%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.7%hi,  0.0%si,  0.0%st
Cpu3  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu4  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu5  : 96.0%us,  1.3%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  2.6%si,  0.0%st
Cpu6  :  1.3%us, 98.7%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu7  : 96.1%us,  3.3%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.3%hi,  0.3%si,  0.0%st

The system call number is only assigned for x86_64 in this RFC patch.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: mingo@elte.hu
CC: laijs@cn.fujitsu.com
CC: dipankar@in.ibm.com
CC: akpm@linux-foundation.org
CC: josh@joshtriplett.org
CC: dvhltc@us.ibm.com
CC: niv@us.ibm.com
CC: tglx@linutronix.de
CC: peterz@infradead.org
CC: rostedt@goodmis.org
CC: Valdis.Kletnieks@vt.edu
CC: dhowells@redhat.com
---
 arch/x86/include/asm/unistd_64.h |    2 
 kernel/sched.c                   |  123 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+)

Index: linux-2.6-lttng/arch/x86/include/asm/unistd_64.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/include/asm/unistd_64.h	2010-01-06 23:23:34.000000000 -0500
+++ linux-2.6-lttng/arch/x86/include/asm/unistd_64.h	2010-01-07 00:23:45.000000000 -0500
@@ -661,6 +661,8 @@ __SYSCALL(__NR_pwritev, sys_pwritev)
 __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 #define __NR_perf_event_open			298
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
+#define __NR_membarrier				299
+__SYSCALL(__NR_membarrier, sys_membarrier)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6-lttng/kernel/sched.c
===================================================================
--- linux-2.6-lttng.orig/kernel/sched.c	2010-01-06 23:23:34.000000000 -0500
+++ linux-2.6-lttng/kernel/sched.c	2010-01-08 18:17:44.000000000 -0500
@@ -119,6 +119,11 @@
  */
 #define RUNTIME_INF	((u64)~0ULL)
 
+/*
+ * IPI vs cpumask broadcast threshold. Threshold of 1 IPI.
+ */
+#define ADAPT_IPI_THRESHOLD	1
+
 static inline int rt_policy(int policy)
 {
 	if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR))
@@ -10822,6 +10827,124 @@ struct cgroup_subsys cpuacct_subsys = {
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
 
+/*
+ * Execute a memory barrier on all CPUs on SMP systems.
+ * Do not rely on implicit barriers in smp_call_function(), just in case they
+ * are ever relaxed in the future.
+ */
+static void membarrier_ipi(void *unused)
+{
+	smp_mb();
+}
+
+/*
+ * Handle out-of-mem by sending per-cpu IPIs instead.
+ */
+static void membarrier_retry(void)
+{
+	int cpu;
+
+	for_each_cpu(cpu, mm_cpumask(current->mm)) {
+		if (cpu_curr(cpu)->mm == current->mm)
+			smp_call_function_single(cpu, membarrier_ipi,
+						 NULL, 1);
+	}
+}
+
+/*
+ * sys_membarrier - issue memory barrier on current process running threads
+ *
+ * Execute a memory barrier on all running threads of the current process.
+ * Upon completion, the caller thread is ensured that all process threads
+ * have passed through a state where memory accesses match program order.
+ * (non-running threads are de facto in such a state)
+ *
+ * The current implementation simply executes a memory barrier in an IPI handler
+ * on each active cpu. Going through the hassle of taking run queue locks and
+ * checking if the thread running on each online CPU belongs to the current
+ * thread seems more heavyweight than the cost of the IPI itself.
+ *
+ * cpu_curr(cpu)->mm read is racy on purpose. It rely on the fact that we race
+ * only with the scheduler, and that the scheduler issues a smp_mb() between the
+ * ->mm update and returning to the newly scheduled thread and between
+ * interruption of a running thread and ->mm update. The worse that could result
+ * from this race is that we issue an IPI for nothing, which doesn't hurt.
+ */
+SYSCALL_DEFINE0(membarrier)
+{
+#ifdef CONFIG_SMP
+	int cpu, i, cpu_ipi[ADAPT_IPI_THRESHOLD], nr_cpus = 0;
+	cpumask_var_t tmpmask;
+	int this_cpu;
+
+	if (likely(!thread_group_empty(current))) {
+		rcu_read_lock();	/* protect cpu_curr(cpu)-> access */
+		/*
+		 * We don't need to include ourself in IPI, as we already
+		 * surround our execution with memory barriers. We also
+		 * don't have to disable preemption here, because if we
+		 * migrate out of "this_cpu", then there is an implied memory
+		 * barrier for the thread now running on "this_cpu".
+		 */
+		this_cpu = raw_smp_processor_id();
+		/*
+		 * Memory barrier on the caller thread _before_ the first
+		 * cpu_curr(cpu)->mm read and also before sending first IPI.
+		 */
+		smp_mb();
+		/* Get CPU IDs up to threshold */
+		for_each_cpu(cpu, mm_cpumask(current->mm)) {
+			if (unlikely(cpu == this_cpu))
+				continue;
+			if (cpu_curr(cpu)->mm == current->mm) {
+				if (nr_cpus == ADAPT_IPI_THRESHOLD) {
+					nr_cpus++;
+					break;
+				}
+				cpu_ipi[nr_cpus++] = cpu;
+			}
+		}
+		if (likely(nr_cpus <= ADAPT_IPI_THRESHOLD)) {
+			for (i = 0; i < nr_cpus; i++) {
+				smp_call_function_single(cpu_ipi[i],
+							 membarrier_ipi,
+							 NULL, 1);
+			}
+		} else {
+			if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL)) {
+				membarrier_retry();
+				goto unlock;
+			}
+			for (i = 0; i < ADAPT_IPI_THRESHOLD; i++)
+				cpumask_set_cpu(cpu_ipi[i], tmpmask);
+			/* Continue previous for_each_cpu() */
+			do {
+				if (cpu_curr(cpu)->mm == current->mm)
+					cpumask_set_cpu(cpu, tmpmask);
+				cpu = cpumask_next(cpu,
+						   mm_cpumask(current->mm));
+				if (unlikely(cpu == this_cpu))
+					continue;
+			} while (cpu < nr_cpu_ids);
+			preempt_disable();	/* explicitly required */
+			smp_call_function_many(tmpmask, membarrier_ipi, NULL,
+					       1);
+			preempt_enable();
+			free_cpumask_var(tmpmask);
+		}
+unlock:
+		/*
+		 * Memory barrier on the caller thread _after_ we finished
+		 * waiting for the last IPI and also after reading the last
+		 * cpu_curr(cpu)->mm.
+		 */
+		smp_mb();
+		rcu_read_unlock();
+	}
+#endif	/* #ifdef CONFIG_SMP */
+	return 0;
+}
+
 #ifndef CONFIG_SMP
 
 int rcu_expedited_torture_stats(char *page)
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
