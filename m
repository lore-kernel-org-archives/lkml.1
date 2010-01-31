Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554Ab0AaVMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0AaVMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 16:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513Ab0AaVM1
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 16:12:27 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:60138 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab0AaVMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 16:12:23 -0500
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Jan 2010 16:12:16 EST
Message-Id: <20100131210013.668540919@polymtl.ca>
References: <20100131205254.407214951@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 31 Jan 2010 15:52:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 3/3] introduce sys_membarrier(): process-wide memory barrier (v8)
Content-Disposition: inline; filename=sys-membarrier.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 31 Jan 2010 21:00:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is an implementation of a new system call, sys_membarrier(), which
executes a memory barrier on all threads of the current process.
 
It aims at greatly simplifying and enhancing the current signal-based
liburcu userspace RCU synchronize_rcu() implementation.
(found at http://lttng.org/urcu)

Depends on:
"scheduler: add full memory barriers upon task switch at runqueue lock/unlock"
"Create spin lock/spin unlock with distinct memory barrier"

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
  IPI. Ensures that we do not disturb RT tasks in the presence of lazy TLB
  shootdown.
- Document memory barriers needed in switch_mm().
- Surround helper functions with #ifdef CONFIG_SMP.

Changelog since v4:
- Add "int expedited" parameter, use synchronize_sched() in the non-expedited
  case. Thanks to Lai Jiangshan for making us consider seriously using
  synchronize_sched() to provide the low-overhead membarrier scheme.
- Check num_online_cpus() == 1, quickly return without doing nothing.

Changelog since v5:
- Plan ahead for extensibility by introducing mandatory/optional masks to the
  "flags" system call parameter. Past experience with accept4(), signalfd4(),
  eventfd2(), epoll_create1(), dup3(), pipe2(), and inotify_init1() indicates
  that this is the kind of thing we want to plan for. Return -EINVAL if the
  mandatory flags received are unknown.
- Create include/linux/membarrier.h to define these flags.
- Add MEMBARRIER_QUERY optional flag.

Changelog since v6:
- Remove some unlikely() not so unlikely.
- Add the proper scheduler memory barriers needed to only use the RCU read lock
  in sys_membarrier rather than take each runqueue spinlock:
- Move memory barriers from per-architecture switch_mm() to schedule() and
  finish_lock_switch(), where they clearly document that all data protected by
  the rq lock is guaranteed to have memory barriers issued between the scheduler
  update and the task execution. Replacing the spin lock acquire/release
  barriers with these memory barriers imply either no overhead (x86 spinlock
  atomic instruction already implies a full mb) or some hopefully small
  overhead caused by the upgrade of the spinlock acquire/release barriers to
  more heavyweight smp_mb().
- The "generic" version of spinlock-mb.h declares both a mapping to standard
  spinlocks and full memory barriers. Each architecture can specialize this
  header following their own need and declare CONFIG_HAVE_SPINLOCK_MB to use
  their own spinlock-mb.h.
- Note: benchmarks of scheduler overhead with specialized spinlock-mb.h
  implementations on a wide range of architecture would be welcome.

Changelog since v7:
- Move spinlock-mb and scheduler related changes to separate patches.
- Add support for sys_membarrier on x86_32.
- Only x86 32/64 system calls are reserved in this patch. It is planned to
  incrementally reserve syscall IDs on other architectures as these are tested.

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
(one thread is doing the sys_membarrier, the others are busy looping)

* expedited

10,000,000 sys_membarrier calls:

T=1: 0m20.173s
T=2: 0m20.506s
T=3: 0m22.632s
T=4: 0m24.759s
T=5: 0m26.633s
T=6: 0m29.654s
T=7: 0m30.669s

For a 2-3 microseconds/call.

* non-expedited

1000 sys_membarrier calls:

T=1-7: 0m16.002s

For a 16 milliseconds/call. (~5000-8000 times slower than expedited)

The expected top pattern for the expedited scheme, when using 1 CPU for a thread
doing sys_membarrier() in a loop and other 7 threads busy-waiting in user-space
on a variable shows that the thread doing sys_membarrier is doing mostly system
calls, and other threads are mostly running in user-space. Note that IPI
handlers are not taken into account in the cpu time sampling.

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

(what we have now, with dynamic sys_membarrier check, expedited scheme)
memory barriers in reader: 907693804 reads, 817793 writes
sys_membarrier scheme:    4316818891 reads, 503790 writes

(dynamic sys_membarrier check, non-expedited scheme)
memory barriers in reader: 907693804 reads, 817793 writes
sys_membarrier scheme:    8698725501 reads,    313 writes

So the dynamic sys_membarrier availability check adds some overhead to the
read-side, but besides that, with the expedited scheme, we can see that we are
close to the read-side performance of the signal-based scheme and also close
(5/8) to the performance of the memory-barrier write-side. We have a write-side
speedup of 400:1 over the signal-based scheme by using the sys_membarrier system
call. This allows a 4.5:1 read-side speedup over the memory barrier scheme.

The non-expedited scheme adds indeed a much lower overhead on the read-side
both because we do not send IPIs and because we perform less updates, which in
turn generates less cache-line exchanges. The write-side latency becomes even
higher than with the signal-based scheme. The advantage of the non-expedited
sys_membarrier() scheme over signal-based scheme is that it does not require to
wake up all the process threads.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Nicholas Miell <nmiell@comcast.net>
CC: mingo@elte.hu
CC: laijs@cn.fujitsu.com
CC: dipankar@in.ibm.com
CC: akpm@linux-foundation.org
CC: josh@joshtriplett.org
CC: dvhltc@us.ibm.com
CC: niv@us.ibm.com
CC: tglx@linutronix.de
CC: peterz@infradead.org
CC: Valdis.Kletnieks@vt.edu
CC: dhowells@redhat.com
---
 arch/x86/ia32/ia32entry.S          |    1 
 arch/x86/include/asm/unistd_32.h   |    3 
 arch/x86/include/asm/unistd_64.h   |    2 
 arch/x86/kernel/syscall_table_32.S |    1 
 include/linux/Kbuild               |    1 
 include/linux/membarrier.h         |   25 ++++++
 kernel/sched.c                     |  148 +++++++++++++++++++++++++++++++++++++
 7 files changed, 180 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/arch/x86/include/asm/unistd_64.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/include/asm/unistd_64.h	2010-01-31 14:59:32.000000000 -0500
+++ linux-2.6-lttng/arch/x86/include/asm/unistd_64.h	2010-01-31 15:13:13.000000000 -0500
@@ -663,6 +663,8 @@ __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 #define __NR_recvmmsg				299
 __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
+#define __NR_membarrier				300
+__SYSCALL(__NR_membarrier, sys_membarrier)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6-lttng/kernel/sched.c
===================================================================
--- linux-2.6-lttng.orig/kernel/sched.c	2010-01-31 15:12:20.000000000 -0500
+++ linux-2.6-lttng/kernel/sched.c	2010-01-31 15:12:25.000000000 -0500
@@ -71,6 +71,7 @@
 #include <linux/debugfs.h>
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
+#include <linux/membarrier.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -10930,6 +10931,153 @@ struct cgroup_subsys cpuacct_subsys = {
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
+	int cpu;
+
+	for_each_cpu(cpu, mm_cpumask(current->mm)) {
+		if (current->mm == cpu_curr(cpu)->mm)
+			smp_call_function_single(cpu, membarrier_ipi, NULL, 1);
+	}
+}
+
+#endif /* #ifdef CONFIG_SMP */
+
+/*
+ * sys_membarrier - issue memory barrier on current process running threads
+ * @flags: One of these must be set:
+ *         MEMBARRIER_EXPEDITED
+ *             Adds some overhead, fast execution (few microseconds)
+ *         MEMBARRIER_DELAYED
+ *             Low overhead, but slow execution (few milliseconds)
+ *
+ *         MEMBARRIER_QUERY
+ *           This optional flag can be set to query if the kernel supports
+ *           a set of flags.
+ *
+ * return values: Returns -EINVAL if the flags are incorrect. Testing for kernel
+ * sys_membarrier support can be done by checking for -ENOSYS return value.
+ * Return values >= 0 indicate success. For a given set of flags on a given
+ * kernel, this system call will always return the same value. It is therefore
+ * correct to check the return value only once at library load, passing the
+ * MEMBARRIER_QUERY flag in addition to only check if the flags are supported,
+ * without performing any synchronization.
+ *
+ * This system call executes a memory barrier on all running threads of the
+ * current process. Upon completion, the caller thread is ensured that all
+ * process threads have passed through a state where memory accesses match
+ * program order. (non-running threads are de facto in such a state)
+ *
+ * Using the non-expedited mode is recommended for applications which can
+ * afford leaving the caller thread waiting for a few milliseconds. A good
+ * example would be a thread dedicated to execute RCU callbacks, which waits
+ * for callbacks to enqueue most of the time anyway.
+ *
+ * The expedited mode is recommended whenever the application needs to have
+ * control returning to the caller thread as quickly as possible. An example
+ * of such application would be one which uses the same thread to perform
+ * data structure updates and issue the RCU synchronization.
+ *
+ * It is perfectly safe to call both expedited and non-expedited
+ * sys_membarrier() in a process.
+ *
+ * mm_cpumask is used as an approximation. It is a superset of the cpumask
+ * to which we must send IPIs, mainly due to lazy TLB shootdown. Therefore,
+ * we check each runqueue with the rq lock held to make sure our ->mm is indeed
+ * running on them. We hold the RCU read lock to ensure the task structs stay
+ * valid. We rely on memory barriers around context switch (paired with the
+ * scheduler rq lock) to ensure that tasks context switched concurrently with
+ * our ->mm or mm_cpumask accesses are issuing memory barriers between the ->mm
+ * or mm_cpumask updates and any memory access performed by the thread before or
+ * after the call to the scheduler.
+ *
+ * In addition to use the mm_cpumask approximation, checking the ->mm reduces
+ * the risk of disturbing a RT task by sending unnecessary IPIs. There is still
+ * a slight chance to disturb an unrelated task, because we do not lock the
+ * runqueues while sending IPIs, but the real-time effect of this heavy locking
+ * would be worse than the comparatively small disruption of an IPI.
+ *
+ * On uniprocessor systems, this system call simply returns 0 without doing
+ * anything, so user-space knows it is implemented.
+ *
+ * The flags argument has room for extensibility, with 16 lower bits holding
+ * mandatory flags for which older kernels will fail if they encounter an
+ * unknown flag. The high 16 bits are used for optional flags, which older
+ * kernels don't have to care about.
+ */
+SYSCALL_DEFINE1(membarrier, unsigned int, flags)
+{
+#ifdef CONFIG_SMP
+	cpumask_var_t tmpmask;
+	int cpu;
+
+	/*
+	 * Expect _only_ one of expedited or delayed flags.
+	 * Don't care about optional mask for now.
+	 */
+	switch (flags & MEMBARRIER_MANDATORY_MASK) {
+	case MEMBARRIER_EXPEDITED:
+	case MEMBARRIER_DELAYED:
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (unlikely(flags & MEMBARRIER_QUERY
+		     || thread_group_empty(current))
+		     || num_online_cpus() == 1)
+		return 0;
+	if (flags & MEMBARRIER_DELAYED) {
+		synchronize_sched();
+		return 0;
+	}
+	/*
+	 * Memory barrier on the caller thread _before_ sending first
+	 * IPI. Matches memory barriers paired with scheduler rq lock.
+	 */
+	smp_mb();
+	rcu_read_lock();	/* ensures validity of cpu_curr(cpu) tasks */
+	if (!alloc_cpumask_var(&tmpmask, GFP_NOWAIT)) {
+		membarrier_retry();
+		goto out;
+	}
+	cpumask_copy(tmpmask, mm_cpumask(current->mm));
+	preempt_disable();
+	cpumask_clear_cpu(smp_processor_id(), tmpmask);
+	for_each_cpu(cpu, tmpmask)
+		if (current->mm != cpu_curr(cpu)->mm)
+			cpumask_clear_cpu(cpu, tmpmask);
+	smp_call_function_many(tmpmask, membarrier_ipi, NULL, 1);
+	preempt_enable();
+	free_cpumask_var(tmpmask);
+out:
+	rcu_read_unlock();
+	/*
+	 * Memory barrier on the caller thread _after_ we finished
+	 * waiting for the last IPI. Matches memory barriers paired with
+	 * scheduler rq lock.
+	 */
+	smp_mb();
+#endif /* #ifdef CONFIG_SMP */
+	return 0;
+}
+
 #ifndef CONFIG_SMP
 
 int rcu_expedited_torture_stats(char *page)
Index: linux-2.6-lttng/include/linux/membarrier.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/membarrier.h	2010-01-31 15:12:25.000000000 -0500
@@ -0,0 +1,25 @@
+#ifndef _LINUX_MEMBARRIER_H
+#define _LINUX_MEMBARRIER_H
+
+/* First argument to membarrier syscall */
+
+/*
+ * Mandatory flags to the membarrier system call that the kernel must
+ * understand are in the low 16 bits.
+ */
+#define MEMBARRIER_MANDATORY_MASK	0x0000FFFF	/* Mandatory flags */
+
+/*
+ * Optional hints that the kernel can ignore are in the high 16 bits.
+ */
+#define MEMBARRIER_OPTIONAL_MASK	0xFFFF0000	/* Optional hints */
+
+/* Expedited: adds some overhead, fast execution (few microseconds) */
+#define MEMBARRIER_EXPEDITED		(1 << 0)
+/* Delayed: Low overhead, but slow execution (few milliseconds) */
+#define MEMBARRIER_DELAYED		(1 << 1)
+
+/* Query flag support, without performing synchronization */
+#define MEMBARRIER_QUERY		(1 << 16)
+
+#endif
Index: linux-2.6-lttng/include/linux/Kbuild
===================================================================
--- linux-2.6-lttng.orig/include/linux/Kbuild	2010-01-31 14:59:41.000000000 -0500
+++ linux-2.6-lttng/include/linux/Kbuild	2010-01-31 15:12:25.000000000 -0500
@@ -110,6 +110,7 @@ header-y += magic.h
 header-y += major.h
 header-y += map_to_7segment.h
 header-y += matroxfb.h
+header-y += membarrier.h
 header-y += meye.h
 header-y += minix_fs.h
 header-y += mmtimer.h
Index: linux-2.6-lttng/arch/x86/include/asm/unistd_32.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/include/asm/unistd_32.h	2010-01-31 15:13:56.000000000 -0500
+++ linux-2.6-lttng/arch/x86/include/asm/unistd_32.h	2010-01-31 15:14:38.000000000 -0500
@@ -343,10 +343,11 @@
 #define __NR_rt_tgsigqueueinfo	335
 #define __NR_perf_event_open	336
 #define __NR_recvmmsg		337
+#define __NR_membarrier		338
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 338
+#define NR_syscalls 339
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6-lttng/arch/x86/ia32/ia32entry.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86/ia32/ia32entry.S	2010-01-31 15:16:36.000000000 -0500
+++ linux-2.6-lttng/arch/x86/ia32/ia32entry.S	2010-01-31 15:17:24.000000000 -0500
@@ -842,4 +842,5 @@ ia32_sys_call_table:
 	.quad compat_sys_rt_tgsigqueueinfo	/* 335 */
 	.quad sys_perf_event_open
 	.quad compat_sys_recvmmsg
+	.quad sys_membarrier
 ia32_syscall_end:
Index: linux-2.6-lttng/arch/x86/kernel/syscall_table_32.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/syscall_table_32.S	2010-01-31 15:16:32.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/syscall_table_32.S	2010-01-31 15:17:08.000000000 -0500
@@ -337,3 +337,4 @@ ENTRY(sys_call_table)
 	.long sys_rt_tgsigqueueinfo	/* 335 */
 	.long sys_perf_event_open
 	.long sys_recvmmsg
+	.long sys_membarrier

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
