Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067Ab0ALRNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0ALRNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 12:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917Ab0ALRNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 12:13:47 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:65415 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab0ALRNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 12:13:45 -0500
Date: Tue, 12 Jan 2010 12:13:41 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v4)
Message-ID: <20100112171341.GA17269@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:00:59 up 27 days,  1:19,  4 users,  load average: 0.45, 0.25,
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

Changelog since v2:
- simply send-to-many to the mm_cpumask. It contains the list of processors we
  have to IPI to (which use the mm), and this mask is updated atomically.

Changelog since v3a:
- Confirm that each CPU indeed runs the current task's ->mm before sending an
  IPI. Ensures that we do not disturn RT tasks in the presence of lazy TLB
  shootdown.
- Document memory barriers needed in switch_mm().
- Surround helper functions with #ifdef CONFIG_SMP.

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

For my Intel Xeon E5405
(10,000,000 sys_membarrier calls, one thread is doing the sys_membarrier, the
others are busy looping)

T=1: 0m20.173s
T=2: 0m20.506s
T=3: 0m22.632s
T=4: 0m24.759s
T=5: 0m26.633s
T=6: 0m29.654s
T=7: 0m30.669s

The expected top pattern, when using 1 CPU for a thread doing sys_membarrier()
in a loop and other 7 threads busy-waiting in user-space on a variable shows
that the thread doing sys_membarrier is doing mostly system calls, and other
threads are mostly running in user-space. Note that IPI handlers are not taken
into account in the cpu time sampling.

Cpu0  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  : 99.7%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.3%hi,  0.0%si,  0.0%st
Cpu2  : 99.3%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.7%hi,  0.0%si,  0.0%st
Cpu3  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu4  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu5  : 96.0%us,  1.3%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  2.6%si,  0.0%st
Cpu6  :  1.3%us, 98.7%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu7  : 96.1%us,  3.3%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.3%hi,  0.3%si,  0.0%st

Results in liburcu:

Operations in 10s, 6 readers, 2 writers:

(what we previously had)
memory barriers in reader: 973494744 reads, 892368 writes
signal-based scheme:      6289946025 reads,   1251 writes

(what we have now, with dynamic sys_membarrier check)
memory barriers in reader: 907693804 reads, 817793 writes
sys_membarrier scheme:    4316818891 reads, 503790 writes

So the dynamic sys_membarrier availability check adds some overhead to the
read-side, but besides that, we can see that we are close to the read-side
performance of the signal-based scheme and also close (5/8) to the performance
of the memory-barrier write-side. We have a write-side speedup of 400:1 over the
signal-based scheme by using the sys_membarrier system call. This allows a 4.5:1
read-side speedup over the memory barrier scheme.

The system call number is only assigned for x86_64 in this RFC patch. Note that
switch_mm() memory barrier audit is required for each architecture before
assigning a system call number.

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
 arch/x86/include/asm/mmu_context.h |   18 +++++-
 arch/x86/include/asm/unistd_64.h   |    2 
 kernel/sched.c                     |  105 +++++++++++++++++++++++++++++++++++++
 3 files changed, 123 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/x86/include/asm/unistd_64.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/include/asm/unistd_64.h	2010-01-12 10:25:47.000000000 -0500
+++ linux-2.6-lttng/arch/x86/include/asm/unistd_64.h	2010-01-12 10:25:57.000000000 -0500
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
--- linux-2.6-lttng.orig/kernel/sched.c	2010-01-12 10:25:47.000000000 -0500
+++ linux-2.6-lttng/kernel/sched.c	2010-01-12 12:11:36.000000000 -0500
@@ -10822,6 +10822,111 @@ struct cgroup_subsys cpuacct_subsys = {
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
 
+#ifdef CONFIG_SMP
+
+/*
+ * Execute a memory barrier on all active threads from the current process
+ * on SMP systems. Do not rely on implicit barriers in IPI handler execution,
+ * because batched IPI lists are synchronized with spinlocks rather than full
+ * memory barriers. This is not the bulk of the overhead anyway, so let's stay
+ * on the safe side.
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
+	struct mm_struct *mm;
+	int cpu;
+
+	for_each_cpu(cpu, mm_cpumask(current->mm)) {
+		spin_lock_irq(&cpu_rq(cpu)->lock);
+		mm = cpu_curr(cpu)->mm;
+		spin_unlock_irq(&cpu_rq(cpu)->lock);
+		if (current->mm == mm)
+			smp_call_function_single(cpu, membarrier_ipi, NULL, 1);
+	}
+}
+
+#endif /* #ifdef CONFIG_SMP */
+
+/*
+ * sys_membarrier - issue memory barrier on current process running threads
+ *
+ * Execute a memory barrier on all running threads of the current process.
+ * Upon completion, the caller thread is ensured that all process threads
+ * have passed through a state where memory accesses match program order.
+ * (non-running threads are de facto in such a state)
+ *
+ * mm_cpumask is used as an approximation. It is a superset of the cpumask to
+ * which we must send IPIs, mainly due to lazy TLB shootdown. Therefore,
+ * we check each runqueue to make sure our ->mm is indeed running on them. This
+ * reduces the risk of disturbing a RT task by sending unnecessary IPIs. There
+ * is still a slight chance to disturb an unrelated task, because we do not lock
+ * the runqueues while sending IPIs, but the real-time effect of this heavy
+ * locking would be worse than the comparatively small disruption of an IPI.
+ *
+ * RED PEN: before assinging a system call number for sys_membarrier() to an
+ * architecture, we must ensure that switch_mm issues full memory barriers (or a
+ * synchronizing instruction having the same effect) between:
+ * - user-space code execution and clear mm_cpumask.
+ * - set mm_cpumask and user-space code execution.
+ * In some case adding a comment to this effect will suffice, in others we will
+ * need to add smp_mb__before_clear_bit()/smp_mb__after_clear_bit() or simply
+ * smp_mb(). These barriers are required to ensure we do not _miss_ a CPU that
+ * need to receive an IPI, which would be a bug.
+ *
+ * On uniprocessor systems, this system call simply returns 0 without doing
+ * anything, so user-space knows it is implemented.
+ */
+SYSCALL_DEFINE0(membarrier)
+{
+#ifdef CONFIG_SMP
+	cpumask_var_t tmpmask;
+	struct mm_struct *mm;
+	int cpu;
+
+	if (unlikely(thread_group_empty(current)))
+		return 0;
+	/*
+	 * Memory barrier on the caller thread _before_ sending first
+	 * IPI. Matches memory barriers around mm_cpumask modification in
+	 * switch_mm().
+	 */
+	smp_mb();
+	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL)) {
+		membarrier_retry();
+		goto unlock;
+	}
+	cpumask_copy(tmpmask, mm_cpumask(current->mm));
+	preempt_disable();
+	cpumask_clear_cpu(smp_processor_id(), tmpmask);
+	for_each_cpu(cpu, tmpmask) {
+		spin_lock_irq(&cpu_rq(cpu)->lock);
+		mm = cpu_curr(cpu)->mm;
+		spin_unlock_irq(&cpu_rq(cpu)->lock);
+		if (current->mm != mm)
+			cpumask_clear_cpu(cpu, tmpmask);
+	}
+	smp_call_function_many(tmpmask, membarrier_ipi, NULL, 1);
+	preempt_enable();
+	free_cpumask_var(tmpmask);
+unlock:
+	/*
+	 * Memory barrier on the caller thread _after_ we finished
+	 * waiting for the last IPI. Matches memory barriers around mm_cpumask
+	 * modification in switch_mm().
+	 */
+	smp_mb();
+#endif /* #ifdef CONFIG_SMP */
+	return 0;
+}
+
 #ifndef CONFIG_SMP
 
 int rcu_expedited_torture_stats(char *page)
Index: linux-2.6-lttng/arch/x86/include/asm/mmu_context.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/include/asm/mmu_context.h	2010-01-12 10:59:31.000000000 -0500
+++ linux-2.6-lttng/arch/x86/include/asm/mmu_context.h	2010-01-12 11:59:49.000000000 -0500
@@ -36,6 +36,11 @@ static inline void switch_mm(struct mm_s
 	unsigned cpu = smp_processor_id();
 
 	if (likely(prev != next)) {
+		/*
+		 * smp_mb() between user-space thread execution and
+		 * mm_cpumask clear is required by sys_membarrier().
+		 */
+		smp_mb__before_clear_bit();
 		/* stop flush ipis for the previous mm */
 		cpumask_clear_cpu(cpu, mm_cpumask(prev));
 #ifdef CONFIG_SMP
@@ -43,7 +48,11 @@ static inline void switch_mm(struct mm_s
 		percpu_write(cpu_tlbstate.active_mm, next);
 #endif
 		cpumask_set_cpu(cpu, mm_cpumask(next));
-
+		/*
+		 * smp_mb() between mm_cpumask set and user-space thread
+		 * execution is required by sys_membarrier(). Implied by
+		 * load_cr3.
+		 */
 		/* Re-load page tables */
 		load_cr3(next->pgd);
 
@@ -59,9 +68,14 @@ static inline void switch_mm(struct mm_s
 		BUG_ON(percpu_read(cpu_tlbstate.active_mm) != next);
 
 		if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))) {
-			/* We were in lazy tlb mode and leave_mm disabled
+			/*
+			 * We were in lazy tlb mode and leave_mm disabled
 			 * tlb flush IPI delivery. We must reload CR3
 			 * to make sure to use no freed page tables.
+			 *
+			 * smp_mb() between mm_cpumask set and user-space
+			 * thread execution is required by sys_membarrier().
+			 * Implied by load_cr3.
 			 */
 			load_cr3(next->pgd);
 			load_LDT_nolock(&next->context);

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
