Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbYLNV3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbYLNV3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 16:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbYLNV3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 16:29:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53741 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbYLNV3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 16:29:24 -0500
Date: Sun, 14 Dec 2008 22:28:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
Subject: [patch] Performance Counters for Linux, v4
Message-ID: <20081214212829.GA9435@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the v4 release of our performance counters 
subsystem implementation. The kernel changes can be picked up from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters/core

  (also in the master branch. There's also a kernel patch attached 
   below.)

The biggest new feature in this release is the implementation of 
"performance counter inheritance" for the per task counters: the ability 
to extend performance counters to cover the execution of child tasks 
too, transparently and automatically - following them to other CPUs.

This can be used to monitor a hierarchy of tasks without stopping them 
(or impacting them in any observable way), and extending that monitoring 
to all child tasks as well.

We've written a new utility: 'timec', which takes advantage of this new 
kernel capability:

     http://redhat.com/~mingo/perfcounters/timec.c

'timec' works like /usr/bin/time, but it extends the dimension of "time" 
with all the metrics that hardware and software performance counters are 
able to capture.

For example, a full kernel build's statistics on a 16-way x86 box are:

  $ timec -e -5,-4,-3,1,2,3,5 make -j32 bzImage

  Performance counter stats for 'make':

         142420.882  task clock ticks     (millisecs)

            9951033  pagefaults           (events)
             302628  context switches     (events)
              57810  CPU migrations       (events)
       208439082509  instructions         (events)
          657918810  cache references     (events)
          120243697  cache misses         (events)
         3134162468  branch misses        (events)

The CPU elapsed time metric is also a lot more accurate and finegrained 
than /usr/bin/time is able to offer. (the counter measures nanoseconds - 
it is displayed by timec up to microsecond resolution.)

Or here are the stats for a 'hackbench' run that creates and tears down 
a web of 1000 tasks within 3 seconds:

  $ timec -e -5,-4,-3,0,1,3,5 ./hackbench 50

  Time: 3.073

   Performance counter stats for './hackbench':

         23340.852  task clock ticks     (millisecs)

             13173  CPU migrations       (events)
             45992  context switches     (events)
             80053  pagefaults           (events)
       57653910508  cycles               (events)
       43456427830  instructions         (events)
          93659475  cache misses         (events)
         901367477 branch misses (events)

These stats include the summed up counter stats of all the sub-tasks 
propagated back and added up back to the original counter - without 
slowing down the workload. (i could not measure a clearly observable 
impact on even context-switchy workloads)

Another change in v4 is the addition of more types of "software 
counters":

        PERF_COUNT_CPU_CLOCK            = -1,
        PERF_COUNT_TASK_CLOCK           = -2,
        PERF_COUNT_PAGE_FAULTS          = -3,
        PERF_COUNT_CONTEXT_SWITCHES     = -4,
        PERF_COUNT_CPU_MIGRATIONS       = -5,

The page-faults and context-switches per task metric is now implemented, 
plus nr-of-cpu-migrations scheduler metric as well. These sw counters 
are available on all CPUs, regardless of hardware perf-counter support.

There's a new KernelTop profiler update as well:

     http://redhat.com/~mingo/perfcounters/kerneltop.c

There's a high-pass filter useful to filter out rare entries from 
weighted histograms (--filter):

------------------------------------------------------------------------------
 KernelTop:    9152 irqs/sec  [NMI, cache-misses/cache-refs],  (all, 16 CPUs)
------------------------------------------------------------------------------

  weight     events         RIP          kernel function
  ______     ______   ________________   _______________

     2.2      17028 - ffffffff802b3f3f : check_bytes_and_report
     1.4       8630 - ffffffff802b466c : init_object
     1.3        718 - ffffffff802b4031 : check_object
     1.2       2050 - ffffffff8037ae10 : copy_user_generic_string!
     1.2       6631 - ffffffff802b3d7e : slab_pad_check
     1.2       1078 - ffffffff8037ea9a : _raw_spin_lock
     1.1        864 - ffffffff802b6250 : kfree
     1.1        948 - ffffffff802b55e6 : new_slab
     1.0       1001 - ffffffff8055b1c2 : unix_stream_recvmsg
     1.0       6266 - ffffffff802b3b20 : on_freelist
     1.0        588 - ffffffff802b596d : __slab_free
     1.0        956 - ffffffff802602a2 : lock_release
     0.8        571 - ffffffff802b3ead : check_slab
     0.5       3353 - ffffffff8025e8c8 : __lock_acquire

Also a number of bugfixes and small tweaks are included i this release.

There's a handful of updates to the core perfcounter code as well, see 
the Git history for details.

Hardware support is still limited to Core2 and later CPUs - but the 
design is not limited to these CPU types - help is welcome with more CPU 
drivers :-)

Thanks,

	Ingo, Thomas

------------------>

The latest perfcounters/core git tree can be found at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters/core

------------------>
Ingo Molnar (27):
      performance counters: documentation
      performance counters: x86 support
      x86, perfcounters: read out MSR_CORE_PERF_GLOBAL_STATUS with counters disabled
      perfcounters: select ANON_INODES
      perfcounters, x86: simplify disable/enable of counters
      perfcounters, x86: clean up debug code
      perfcounters: consolidate global-disable codepaths
      perf counters: restructure the API
      perf counters: add support for group counters
      perf counters: group counter, fixes
      perf counters: hw driver API
      perf counters: implement PERF_COUNT_CPU_CLOCK
      perf counters: consolidate hw_perf save/restore APIs
      perf counters: implement PERF_COUNT_TASK_CLOCK
      perf counters: add prctl interface to disable/enable counters
      perf counters: clean up state transitions
      perf counters: update docs
      x86: implement atomic64_t on 32-bit
      perfcounters: restructure x86 counter math
      perfcounters: implement "counter inheritance"
      perfcounters: fix task clock counter
      perfcounters: add context switch counter
      perfcounters: add task migrations counter
      perfcounters: add nr-of-faults counter
      perfcounters: fix non-intel-perfmon CPUs
      perfcounters, x86: fix sw counters on non-PMC CPUs
      perfcounters: fix lapic initialization

Thomas Gleixner (4):
      performance counters: core code
      perf counters: protect them against CSTATE transitions
      perf counters: clean up 'raw' type API
      perf counters: expand use of counter->event


 Documentation/perf-counters.txt                |  147 +++
 arch/x86/Kconfig                               |    1 +
 arch/x86/ia32/ia32entry.S                      |    3 +-
 arch/x86/include/asm/atomic_32.h               |  218 ++++
 arch/x86/include/asm/hardirq_32.h              |    1 +
 arch/x86/include/asm/hw_irq.h                  |    2 +
 arch/x86/include/asm/intel_arch_perfmon.h      |   34 +-
 arch/x86/include/asm/irq_vectors.h             |    5 +
 arch/x86/include/asm/mach-default/entry_arch.h |    5 +
 arch/x86/include/asm/pda.h                     |    1 +
 arch/x86/include/asm/thread_info.h             |    4 +-
 arch/x86/include/asm/unistd_32.h               |    1 +
 arch/x86/include/asm/unistd_64.h               |    3 +-
 arch/x86/kernel/apic.c                         |    2 +
 arch/x86/kernel/cpu/Makefile                   |   12 +-
 arch/x86/kernel/cpu/common.c                   |    2 +
 arch/x86/kernel/cpu/perf_counter.c             |  587 +++++++++
 arch/x86/kernel/entry_64.S                     |    5 +
 arch/x86/kernel/irq.c                          |    5 +
 arch/x86/kernel/irqinit_32.c                   |    3 +
 arch/x86/kernel/irqinit_64.c                   |    5 +
 arch/x86/kernel/signal.c                       |    7 +-
 arch/x86/kernel/syscall_table_32.S             |    1 +
 drivers/acpi/processor_idle.c                  |    8 +
 drivers/char/sysrq.c                           |    2 +
 include/linux/perf_counter.h                   |  257 ++++
 include/linux/prctl.h                          |    3 +
 include/linux/sched.h                          |   12 +-
 include/linux/syscalls.h                       |    8 +
 init/Kconfig                                   |   30 +
 kernel/Makefile                                |    1 +
 kernel/exit.c                                  |    7 +-
 kernel/fork.c                                  |    1 +
 kernel/perf_counter.c                          | 1542 ++++++++++++++++++++++++
 kernel/sched.c                                 |   31 +-
 kernel/sys.c                                   |    7 +
 kernel/sys_ni.c                                |    3 +
 37 files changed, 2939 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/perf-counters.txt
 create mode 100644 arch/x86/kernel/cpu/perf_counter.c
 create mode 100644 include/linux/perf_counter.h
 create mode 100644 kernel/perf_counter.c

diff --git a/Documentation/perf-counters.txt b/Documentation/perf-counters.txt
new file mode 100644
index 0000000..fddd321
--- /dev/null
+++ b/Documentation/perf-counters.txt
@@ -0,0 +1,147 @@
+
+Performance Counters for Linux
+------------------------------
+
+Performance counters are special hardware registers available on most modern
+CPUs. These registers count the number of certain types of hw events: such
+as instructions executed, cachemisses suffered, or branches mis-predicted -
+without slowing down the kernel or applications. These registers can also
+trigger interrupts when a threshold number of events have passed - and can
+thus be used to profile the code that runs on that CPU.
+
+The Linux Performance Counter subsystem provides an abstraction of these
+hardware capabilities. It provides per task and per CPU counters, counter
+groups, and it provides event capabilities on top of those.
+
+Performance counters are accessed via special file descriptors.
+There's one file descriptor per virtual counter used.
+
+The special file descriptor is opened via the perf_counter_open()
+system call:
+
+   int sys_perf_counter_open(struct perf_counter_hw_event *hw_event_uptr,
+			     pid_t pid, int cpu, int group_fd);
+
+The syscall returns the new fd. The fd can be used via the normal
+VFS system calls: read() can be used to read the counter, fcntl()
+can be used to set the blocking mode, etc.
+
+Multiple counters can be kept open at a time, and the counters
+can be poll()ed.
+
+When creating a new counter fd, 'perf_counter_hw_event' is:
+
+/*
+ * Hardware event to monitor via a performance monitoring counter:
+ */
+struct perf_counter_hw_event {
+	s64			type;
+
+	u64			irq_period;
+	u32			record_type;
+
+	u32			disabled     :  1, /* off by default */
+				nmi	     :  1, /* NMI sampling   */
+				raw	     :  1, /* raw event type */
+				__reserved_1 : 29;
+
+	u64			__reserved_2;
+};
+
+/*
+ * Generalized performance counter event types, used by the hw_event.type
+ * parameter of the sys_perf_counter_open() syscall:
+ */
+enum hw_event_types {
+	/*
+	 * Common hardware events, generalized by the kernel:
+	 */
+	PERF_COUNT_CYCLES		=  0,
+	PERF_COUNT_INSTRUCTIONS		=  1,
+	PERF_COUNT_CACHE_REFERENCES	=  2,
+	PERF_COUNT_CACHE_MISSES		=  3,
+	PERF_COUNT_BRANCH_INSTRUCTIONS	=  4,
+	PERF_COUNT_BRANCH_MISSES	=  5,
+
+	/*
+	 * Special "software" counters provided by the kernel, even if
+	 * the hardware does not support performance counters. These
+	 * counters measure various physical and sw events of the
+	 * kernel (and allow the profiling of them as well):
+	 */
+	PERF_COUNT_CPU_CLOCK		= -1,
+	PERF_COUNT_TASK_CLOCK		= -2,
+	/*
+	 * Future software events:
+	 */
+	/* PERF_COUNT_PAGE_FAULTS	= -3,
+	   PERF_COUNT_CONTEXT_SWITCHES	= -4, */
+};
+
+These are standardized types of events that work uniformly on all CPUs
+that implements Performance Counters support under Linux. If a CPU is
+not able to count branch-misses, then the system call will return
+-EINVAL.
+
+More hw_event_types are supported as well, but they are CPU
+specific and are enumerated via /sys on a per CPU basis. Raw hw event
+types can be passed in under hw_event.type if hw_event.raw is 1.
+For example, to count "External bus cycles while bus lock signal asserted"
+events on Intel Core CPUs, pass in a 0x4064 event type value and set
+hw_event.raw to 1.
+
+'record_type' is the type of data that a read() will provide for the
+counter, and it can be one of:
+
+/*
+ * IRQ-notification data record type:
+ */
+enum perf_counter_record_type {
+	PERF_RECORD_SIMPLE		=  0,
+	PERF_RECORD_IRQ			=  1,
+	PERF_RECORD_GROUP		=  2,
+};
+
+a "simple" counter is one that counts hardware events and allows
+them to be read out into a u64 count value. (read() returns 8 on
+a successful read of a simple counter.)
+
+An "irq" counter is one that will also provide an IRQ context information:
+the IP of the interrupted context. In this case read() will return
+the 8-byte counter value, plus the Instruction Pointer address of the
+interrupted context.
+
+The parameter 'hw_event_period' is the number of events before waking up
+a read() that is blocked on a counter fd. Zero value means a non-blocking
+counter.
+
+The 'pid' parameter allows the counter to be specific to a task:
+
+ pid == 0: if the pid parameter is zero, the counter is attached to the
+ current task.
+
+ pid > 0: the counter is attached to a specific task (if the current task
+ has sufficient privilege to do so)
+
+ pid < 0: all tasks are counted (per cpu counters)
+
+The 'cpu' parameter allows a counter to be made specific to a full
+CPU:
+
+ cpu >= 0: the counter is restricted to a specific CPU
+ cpu == -1: the counter counts on all CPUs
+
+(Note: the combination of 'pid == -1' and 'cpu == -1' is not valid.)
+
+A 'pid > 0' and 'cpu == -1' counter is a per task counter that counts
+events of that task and 'follows' that task to whatever CPU the task
+gets schedule to. Per task counters can be created by any user, for
+their own tasks.
+
+A 'pid == -1' and 'cpu == x' counter is a per CPU counter that counts
+all events on CPU-x. Per CPU counters need CAP_SYS_ADMIN privilege.
+
+Group counters are created by passing in a group_fd of another counter.
+Groups are scheduled at once and can be used with PERF_RECORD_GROUP
+to record multi-dimensional timestamps.
+
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d4d4cb7..fe94490 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -643,6 +643,7 @@ config X86_UP_IOAPIC
 config X86_LOCAL_APIC
 	def_bool y
 	depends on X86_64 || (X86_32 && (X86_UP_APIC || (SMP && !X86_VOYAGER) || X86_GENERICARCH))
+	select HAVE_PERF_COUNTERS if (!M386 && !M486)
 
 config X86_IO_APIC
 	def_bool y
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 256b00b..3c14ed0 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -823,7 +823,8 @@ ia32_sys_call_table:
 	.quad compat_sys_signalfd4
 	.quad sys_eventfd2
 	.quad sys_epoll_create1
-	.quad sys_dup3			/* 330 */
+	.quad sys_dup3				/* 330 */
 	.quad sys_pipe2
 	.quad sys_inotify_init1
+	.quad sys_perf_counter_open
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index ad5b9f6..9927e01 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -255,5 +255,223 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
+/* An 64bit atomic type */
+
+typedef struct {
+	unsigned long long counter;
+} atomic64_t;
+
+#define ATOMIC64_INIT(val)	{ (val) }
+
+/**
+ * atomic64_read - read atomic64 variable
+ * @v: pointer of type atomic64_t
+ *
+ * Atomically reads the value of @v.
+ * Doesn't imply a read memory barrier.
+ */
+#define __atomic64_read(ptr)		((ptr)->counter)
+
+static inline unsigned long long
+cmpxchg8b(unsigned long long *ptr, unsigned long long old, unsigned long long new)
+{
+	asm volatile(
+
+		LOCK_PREFIX "cmpxchg8b (%[ptr])\n"
+
+		     :		"=A" (old)
+
+		     : [ptr]	"D" (ptr),
+				"A" (old),
+				"b" (ll_low(new)),
+				"c" (ll_high(new))
+
+		     : "memory");
+
+	return old;
+}
+
+static inline unsigned long long
+atomic64_cmpxchg(atomic64_t *ptr, unsigned long long old_val,
+		 unsigned long long new_val)
+{
+	return cmpxchg8b(&ptr->counter, old_val, new_val);
+}
+
+/**
+ * atomic64_set - set atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ * @new_val:  value to assign
+ *
+ * Atomically sets the value of @ptr to @new_val.
+ */
+static inline void atomic64_set(atomic64_t *ptr, unsigned long long new_val)
+{
+	unsigned long long old_val;
+
+	do {
+		old_val = atomic_read(ptr);
+	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
+}
+
+/**
+ * atomic64_read - read atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ *
+ * Atomically reads the value of @ptr and returns it.
+ */
+static inline unsigned long long atomic64_read(atomic64_t *ptr)
+{
+	unsigned long long curr_val;
+
+	do {
+		curr_val = __atomic64_read(ptr);
+	} while (atomic64_cmpxchg(ptr, curr_val, curr_val) != curr_val);
+
+	return curr_val;
+}
+
+/**
+ * atomic64_add_return - add and return
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr and returns @delta + *@ptr
+ */
+static inline unsigned long long
+atomic64_add_return(unsigned long long delta, atomic64_t *ptr)
+{
+	unsigned long long old_val, new_val;
+
+	do {
+		old_val = atomic_read(ptr);
+		new_val = old_val + delta;
+
+	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
+
+	return new_val;
+}
+
+static inline long atomic64_sub_return(unsigned long long delta, atomic64_t *ptr)
+{
+	return atomic64_add_return(-delta, ptr);
+}
+
+static inline long atomic64_inc_return(atomic64_t *ptr)
+{
+	return atomic64_add_return(1, ptr);
+}
+
+static inline long atomic64_dec_return(atomic64_t *ptr)
+{
+	return atomic64_sub_return(1, ptr);
+}
+
+/**
+ * atomic64_add - add integer to atomic64 variable
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr.
+ */
+static inline void atomic64_add(unsigned long long delta, atomic64_t *ptr)
+{
+	atomic64_add_return(delta, ptr);
+}
+
+/**
+ * atomic64_sub - subtract the atomic64 variable
+ * @delta: integer value to subtract
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically subtracts @delta from @ptr.
+ */
+static inline void atomic64_sub(unsigned long long delta, atomic64_t *ptr)
+{
+	atomic64_add(-delta, ptr);
+}
+
+/**
+ * atomic64_sub_and_test - subtract value from variable and test result
+ * @delta: integer value to subtract
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically subtracts @delta from @ptr and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+static inline int
+atomic64_sub_and_test(unsigned long long delta, atomic64_t *ptr)
+{
+	unsigned long long old_val = atomic64_sub_return(delta, ptr);
+
+	return old_val == 0;
+}
+
+/**
+ * atomic64_inc - increment atomic64 variable
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically increments @ptr by 1.
+ */
+static inline void atomic64_inc(atomic64_t *ptr)
+{
+	atomic64_add(1, ptr);
+}
+
+/**
+ * atomic64_dec - decrement atomic64 variable
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically decrements @ptr by 1.
+ */
+static inline void atomic64_dec(atomic64_t *ptr)
+{
+	atomic64_sub(1, ptr);
+}
+
+/**
+ * atomic64_dec_and_test - decrement and test
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically decrements @ptr by 1 and
+ * returns true if the result is 0, or false for all other
+ * cases.
+ */
+static inline int atomic64_dec_and_test(atomic64_t *ptr)
+{
+	return atomic64_sub_and_test(1, ptr);
+}
+
+/**
+ * atomic64_inc_and_test - increment and test
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically increments @ptr by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+static inline int atomic64_inc_and_test(atomic64_t *ptr)
+{
+	return atomic64_sub_and_test(-1, ptr);
+}
+
+/**
+ * atomic64_add_negative - add and test if negative
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr and returns true
+ * if the result is negative, or false when
+ * result is greater than or equal to zero.
+ */
+static inline int
+atomic64_add_negative(unsigned long long delta, atomic64_t *ptr)
+{
+	long long old_val = atomic64_add_return(delta, ptr);
+
+	return old_val < 0;
+}
+
 #include <asm-generic/atomic.h>
 #endif /* _ASM_X86_ATOMIC_32_H */
diff --git a/arch/x86/include/asm/hardirq_32.h b/arch/x86/include/asm/hardirq_32.h
index cf7954d..7a07897 100644
--- a/arch/x86/include/asm/hardirq_32.h
+++ b/arch/x86/include/asm/hardirq_32.h
@@ -9,6 +9,7 @@ typedef struct {
 	unsigned long idle_timestamp;
 	unsigned int __nmi_count;	/* arch dependent */
 	unsigned int apic_timer_irqs;	/* arch dependent */
+	unsigned int apic_perf_irqs;	/* arch dependent */
 	unsigned int irq0_irqs;
 	unsigned int irq_resched_count;
 	unsigned int irq_call_count;
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 8de644b..aa93e53 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -30,6 +30,8 @@
 /* Interrupt handlers registered during init_IRQ */
 extern void apic_timer_interrupt(void);
 extern void error_interrupt(void);
+extern void perf_counter_interrupt(void);
+
 extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
 extern void reschedule_interrupt(void);
diff --git a/arch/x86/include/asm/intel_arch_perfmon.h b/arch/x86/include/asm/intel_arch_perfmon.h
index fa0fd06..71598a9 100644
--- a/arch/x86/include/asm/intel_arch_perfmon.h
+++ b/arch/x86/include/asm/intel_arch_perfmon.h
@@ -1,22 +1,24 @@
 #ifndef _ASM_X86_INTEL_ARCH_PERFMON_H
 #define _ASM_X86_INTEL_ARCH_PERFMON_H
 
-#define MSR_ARCH_PERFMON_PERFCTR0		0xc1
-#define MSR_ARCH_PERFMON_PERFCTR1		0xc2
+#define MSR_ARCH_PERFMON_PERFCTR0			      0xc1
+#define MSR_ARCH_PERFMON_PERFCTR1			      0xc2
 
-#define MSR_ARCH_PERFMON_EVENTSEL0		0x186
-#define MSR_ARCH_PERFMON_EVENTSEL1		0x187
+#define MSR_ARCH_PERFMON_EVENTSEL0			     0x186
+#define MSR_ARCH_PERFMON_EVENTSEL1			     0x187
 
-#define ARCH_PERFMON_EVENTSEL0_ENABLE	(1 << 22)
-#define ARCH_PERFMON_EVENTSEL_INT	(1 << 20)
-#define ARCH_PERFMON_EVENTSEL_OS	(1 << 17)
-#define ARCH_PERFMON_EVENTSEL_USR	(1 << 16)
+#define ARCH_PERFMON_EVENTSEL0_ENABLE			  (1 << 22)
+#define ARCH_PERFMON_EVENTSEL_INT			  (1 << 20)
+#define ARCH_PERFMON_EVENTSEL_OS			  (1 << 17)
+#define ARCH_PERFMON_EVENTSEL_USR			  (1 << 16)
 
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL	(0x3c)
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK	(0x00 << 8)
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX (0)
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		      0x3c
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX 		 0
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT \
-	(1 << (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX))
+		(1 << (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX))
+
+#define ARCH_PERFMON_BRANCH_MISSES_RETIRED			 6
 
 union cpuid10_eax {
 	struct {
@@ -28,4 +30,12 @@ union cpuid10_eax {
 	unsigned int full;
 };
 
+#ifdef CONFIG_PERF_COUNTERS
+extern void init_hw_perf_counters(void);
+extern void perf_counters_lapic_init(int nmi);
+#else
+static inline void init_hw_perf_counters(void)		{ }
+static inline void perf_counters_lapic_init(int nmi)	{ }
+#endif
+
 #endif /* _ASM_X86_INTEL_ARCH_PERFMON_H */
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 0005adb..b8d277f 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -87,6 +87,11 @@
 #define LOCAL_TIMER_VECTOR	0xef
 
 /*
+ * Performance monitoring interrupt vector:
+ */
+#define LOCAL_PERF_VECTOR	0xee
+
+/*
  * First APIC vector available to drivers: (vectors 0x30-0xee) we
  * start at 0x31(0x41) to spread out vectors evenly between priority
  * levels. (0x80 is the syscall vector)
diff --git a/arch/x86/include/asm/mach-default/entry_arch.h b/arch/x86/include/asm/mach-default/entry_arch.h
index 6b1add8..ad31e5d 100644
--- a/arch/x86/include/asm/mach-default/entry_arch.h
+++ b/arch/x86/include/asm/mach-default/entry_arch.h
@@ -25,10 +25,15 @@ BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
  * a much simpler SMP time architecture:
  */
 #ifdef CONFIG_X86_LOCAL_APIC
+
 BUILD_INTERRUPT(apic_timer_interrupt,LOCAL_TIMER_VECTOR)
 BUILD_INTERRUPT(error_interrupt,ERROR_APIC_VECTOR)
 BUILD_INTERRUPT(spurious_interrupt,SPURIOUS_APIC_VECTOR)
 
+#ifdef CONFIG_PERF_COUNTERS
+BUILD_INTERRUPT(perf_counter_interrupt, LOCAL_PERF_VECTOR)
+#endif
+
 #ifdef CONFIG_X86_MCE_P4THERMAL
 BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
 #endif
diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index 2fbfff8..90a8d9d 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -30,6 +30,7 @@ struct x8664_pda {
 	short isidle;
 	struct mm_struct *active_mm;
 	unsigned apic_timer_irqs;
+	unsigned apic_perf_irqs;
 	unsigned irq0_irqs;
 	unsigned irq_resched_count;
 	unsigned irq_call_count;
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e44d379..810bf26 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -80,6 +80,7 @@ struct thread_info {
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
+#define TIF_PERF_COUNTERS	11	/* notify perf counter work */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* 32bit process */
 #define TIF_FORK		18	/* ret_from_fork */
@@ -103,6 +104,7 @@ struct thread_info {
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
+#define _TIF_PERF_COUNTERS	(1 << TIF_PERF_COUNTERS)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
@@ -135,7 +137,7 @@ struct thread_info {
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_NOTIFY_RESUME)
+	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_PERF_COUNTERS|_TIF_NOTIFY_RESUME)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index f2bba78..7e47658 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -338,6 +338,7 @@
 #define __NR_dup3		330
 #define __NR_pipe2		331
 #define __NR_inotify_init1	332
+#define __NR_perf_counter_open	333
 
 #ifdef __KERNEL__
 
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index d2e415e..53025fe 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -653,7 +653,8 @@ __SYSCALL(__NR_dup3, sys_dup3)
 __SYSCALL(__NR_pipe2, sys_pipe2)
 #define __NR_inotify_init1			294
 __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
-
+#define __NR_perf_counter_open		295
+__SYSCALL(__NR_perf_counter_open, sys_perf_counter_open)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 1771dd7..0579ec1 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -31,6 +31,7 @@
 #include <linux/dmi.h>
 #include <linux/dmar.h>
 
+#include <asm/intel_arch_perfmon.h>
 #include <asm/atomic.h>
 #include <asm/smp.h>
 #include <asm/mtrr.h>
@@ -1143,6 +1144,7 @@ void __cpuinit setup_local_APIC(void)
 		apic_write(APIC_ESR, 0);
 	}
 #endif
+	perf_counters_lapic_init(0);
 
 	preempt_disable();
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 82ec607..89e5336 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -1,5 +1,5 @@
 #
-# Makefile for x86-compatible CPU details and quirks
+# Makefile for x86-compatible CPU details, features and quirks
 #
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
@@ -16,11 +16,13 @@ obj-$(CONFIG_CPU_SUP_CENTAUR_64)	+= centaur_64.o
 obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
 obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 
-obj-$(CONFIG_X86_MCE)	+= mcheck/
-obj-$(CONFIG_MTRR)	+= mtrr/
-obj-$(CONFIG_CPU_FREQ)	+= cpufreq/
+obj-$(CONFIG_PERF_COUNTERS)		+= perf_counter.o
 
-obj-$(CONFIG_X86_LOCAL_APIC) += perfctr-watchdog.o
+obj-$(CONFIG_X86_MCE)			+= mcheck/
+obj-$(CONFIG_MTRR)			+= mtrr/
+obj-$(CONFIG_CPU_FREQ)			+= cpufreq/
+
+obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o
 
 quiet_cmd_mkcapflags = MKCAP   $@
       cmd_mkcapflags = $(PERL) $(srctree)/$(src)/mkcapflags.pl $< $@
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index b9c9ea0..4461011 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -17,6 +17,7 @@
 #include <asm/mmu_context.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
+#include <asm/intel_arch_perfmon.h>
 #include <asm/pat.h>
 #include <asm/asm.h>
 #include <asm/numa.h>
@@ -750,6 +751,7 @@ void __init identify_boot_cpu(void)
 #else
 	vgetcpu_set_mode();
 #endif
+	init_hw_perf_counters();
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
new file mode 100644
index 0000000..8a154bd
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -0,0 +1,587 @@
+/*
+ * Performance counter x86 architecture code
+ *
+ *  Copyright(C) 2008 Thomas Gleixner <tglx@linutronix.de>
+ *  Copyright(C) 2008 Red Hat, Inc., Ingo Molnar
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/perf_counter.h>
+#include <linux/capability.h>
+#include <linux/notifier.h>
+#include <linux/hardirq.h>
+#include <linux/kprobes.h>
+#include <linux/module.h>
+#include <linux/kdebug.h>
+#include <linux/sched.h>
+
+#include <asm/intel_arch_perfmon.h>
+#include <asm/apic.h>
+
+static bool perf_counters_initialized __read_mostly;
+
+/*
+ * Number of (generic) HW counters:
+ */
+static int nr_hw_counters __read_mostly;
+static u32 perf_counter_mask __read_mostly;
+
+/* No support for fixed function counters yet */
+
+#define MAX_HW_COUNTERS		8
+
+struct cpu_hw_counters {
+	struct perf_counter	*counters[MAX_HW_COUNTERS];
+	unsigned long		used[BITS_TO_LONGS(MAX_HW_COUNTERS)];
+};
+
+/*
+ * Intel PerfMon v3. Used on Core2 and later.
+ */
+static DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters);
+
+const int intel_perfmon_event_map[] =
+{
+  [PERF_COUNT_CYCLES]			= 0x003c,
+  [PERF_COUNT_INSTRUCTIONS]		= 0x00c0,
+  [PERF_COUNT_CACHE_REFERENCES]		= 0x4f2e,
+  [PERF_COUNT_CACHE_MISSES]		= 0x412e,
+  [PERF_COUNT_BRANCH_INSTRUCTIONS]	= 0x00c4,
+  [PERF_COUNT_BRANCH_MISSES]		= 0x00c5,
+};
+
+const int max_intel_perfmon_events = ARRAY_SIZE(intel_perfmon_event_map);
+
+/*
+ * Propagate counter elapsed time into the generic counter.
+ * Can only be executed on the CPU where the counter is active.
+ * Returns the delta events processed.
+ */
+static void
+x86_perf_counter_update(struct perf_counter *counter,
+			struct hw_perf_counter *hwc, int idx)
+{
+	u64 prev_raw_count, new_raw_count, delta;
+
+	WARN_ON_ONCE(counter->state != PERF_COUNTER_STATE_ACTIVE);
+	/*
+	 * Careful: an NMI might modify the previous counter value.
+	 *
+	 * Our tactic to handle this is to first atomically read and
+	 * exchange a new raw count - then add that new-prev delta
+	 * count to the generic counter atomically:
+	 */
+again:
+	prev_raw_count = atomic64_read(&hwc->prev_count);
+	rdmsrl(hwc->counter_base + idx, new_raw_count);
+
+	if (atomic64_cmpxchg(&hwc->prev_count, prev_raw_count,
+					new_raw_count) != prev_raw_count)
+		goto again;
+
+	/*
+	 * Now we have the new raw value and have updated the prev
+	 * timestamp already. We can now calculate the elapsed delta
+	 * (counter-)time and add that to the generic counter.
+	 *
+	 * Careful, not all hw sign-extends above the physical width
+	 * of the count, so we do that by clipping the delta to 32 bits:
+	 */
+	delta = (u64)(u32)((s32)new_raw_count - (s32)prev_raw_count);
+	WARN_ON_ONCE((int)delta < 0);
+
+	atomic64_add(delta, &counter->count);
+	atomic64_sub(delta, &hwc->period_left);
+}
+
+/*
+ * Setup the hardware configuration for a given hw_event_type
+ */
+static int __hw_perf_counter_init(struct perf_counter *counter)
+{
+	struct perf_counter_hw_event *hw_event = &counter->hw_event;
+	struct hw_perf_counter *hwc = &counter->hw;
+
+	if (unlikely(!perf_counters_initialized))
+		return -EINVAL;
+
+	/*
+	 * Count user events, and generate PMC IRQs:
+	 * (keep 'enabled' bit clear for now)
+	 */
+	hwc->config = ARCH_PERFMON_EVENTSEL_USR | ARCH_PERFMON_EVENTSEL_INT;
+
+	/*
+	 * If privileged enough, count OS events too, and allow
+	 * NMI events as well:
+	 */
+	hwc->nmi = 0;
+	if (capable(CAP_SYS_ADMIN)) {
+		hwc->config |= ARCH_PERFMON_EVENTSEL_OS;
+		if (hw_event->nmi)
+			hwc->nmi = 1;
+	}
+
+	hwc->config_base	= MSR_ARCH_PERFMON_EVENTSEL0;
+	hwc->counter_base	= MSR_ARCH_PERFMON_PERFCTR0;
+
+	hwc->irq_period		= hw_event->irq_period;
+	/*
+	 * Intel PMCs cannot be accessed sanely above 32 bit width,
+	 * so we install an artificial 1<<31 period regardless of
+	 * the generic counter period:
+	 */
+	if ((s64)hwc->irq_period <= 0 || hwc->irq_period > 0x7FFFFFFF)
+		hwc->irq_period = 0x7FFFFFFF;
+
+	atomic64_set(&hwc->period_left, hwc->irq_period);
+
+	/*
+	 * Raw event type provide the config in the event structure
+	 */
+	if (hw_event->raw) {
+		hwc->config |= hw_event->type;
+	} else {
+		if (hw_event->type >= max_intel_perfmon_events)
+			return -EINVAL;
+		/*
+		 * The generic map:
+		 */
+		hwc->config |= intel_perfmon_event_map[hw_event->type];
+	}
+	counter->wakeup_pending = 0;
+
+	return 0;
+}
+
+void hw_perf_enable_all(void)
+{
+	if (unlikely(!perf_counters_initialized))
+		return;
+
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, perf_counter_mask, 0);
+}
+
+u64 hw_perf_save_disable(void)
+{
+	u64 ctrl;
+
+	if (unlikely(!perf_counters_initialized))
+		return 0;
+
+	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0, 0);
+
+	return ctrl;
+}
+EXPORT_SYMBOL_GPL(hw_perf_save_disable);
+
+void hw_perf_restore(u64 ctrl)
+{
+	if (unlikely(!perf_counters_initialized))
+		return;
+
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, ctrl, 0);
+}
+EXPORT_SYMBOL_GPL(hw_perf_restore);
+
+static inline void
+__x86_perf_counter_disable(struct perf_counter *counter,
+			   struct hw_perf_counter *hwc, unsigned int idx)
+{
+	int err;
+
+	err = wrmsr_safe(hwc->config_base + idx, hwc->config, 0);
+	WARN_ON_ONCE(err);
+}
+
+static DEFINE_PER_CPU(u64, prev_left[MAX_HW_COUNTERS]);
+
+/*
+ * Set the next IRQ period, based on the hwc->period_left value.
+ * To be called with the counter disabled in hw:
+ */
+static void
+__hw_perf_counter_set_period(struct perf_counter *counter,
+			     struct hw_perf_counter *hwc, int idx)
+{
+	s32 left = atomic64_read(&hwc->period_left);
+	s32 period = hwc->irq_period;
+
+	WARN_ON_ONCE(period <= 0);
+
+	/*
+	 * If we are way outside a reasoable range then just skip forward:
+	 */
+	if (unlikely(left <= -period)) {
+		left = period;
+		atomic64_set(&hwc->period_left, left);
+	}
+
+	if (unlikely(left <= 0)) {
+		left += period;
+		atomic64_set(&hwc->period_left, left);
+	}
+
+	WARN_ON_ONCE(left <= 0);
+
+	per_cpu(prev_left[idx], smp_processor_id()) = left;
+
+	/*
+	 * The hw counter starts counting from this counter offset,
+	 * mark it to be able to extra future deltas:
+	 */
+	atomic64_set(&hwc->prev_count, (u64)(s64)-left);
+
+	wrmsr(hwc->counter_base + idx, -left, 0);
+}
+
+static void
+__x86_perf_counter_enable(struct perf_counter *counter,
+			  struct hw_perf_counter *hwc, int idx)
+{
+	wrmsr(hwc->config_base + idx,
+	      hwc->config | ARCH_PERFMON_EVENTSEL0_ENABLE, 0);
+}
+
+/*
+ * Find a PMC slot for the freshly enabled / scheduled in counter:
+ */
+static void x86_perf_counter_enable(struct perf_counter *counter)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	struct hw_perf_counter *hwc = &counter->hw;
+	int idx = hwc->idx;
+
+	/* Try to get the previous counter again */
+	if (test_and_set_bit(idx, cpuc->used)) {
+		idx = find_first_zero_bit(cpuc->used, nr_hw_counters);
+		set_bit(idx, cpuc->used);
+		hwc->idx = idx;
+	}
+
+	perf_counters_lapic_init(hwc->nmi);
+
+	__x86_perf_counter_disable(counter, hwc, idx);
+
+	cpuc->counters[idx] = counter;
+
+	__hw_perf_counter_set_period(counter, hwc, idx);
+	__x86_perf_counter_enable(counter, hwc, idx);
+}
+
+void perf_counter_print_debug(void)
+{
+	u64 ctrl, status, overflow, pmc_ctrl, pmc_count, prev_left;
+	int cpu, idx;
+
+	if (!nr_hw_counters)
+		return;
+
+	local_irq_disable();
+
+	cpu = smp_processor_id();
+
+	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
+	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
+	rdmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, overflow);
+
+	printk(KERN_INFO "\n");
+	printk(KERN_INFO "CPU#%d: ctrl:       %016llx\n", cpu, ctrl);
+	printk(KERN_INFO "CPU#%d: status:     %016llx\n", cpu, status);
+	printk(KERN_INFO "CPU#%d: overflow:   %016llx\n", cpu, overflow);
+
+	for (idx = 0; idx < nr_hw_counters; idx++) {
+		rdmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + idx, pmc_ctrl);
+		rdmsrl(MSR_ARCH_PERFMON_PERFCTR0  + idx, pmc_count);
+
+		prev_left = per_cpu(prev_left[idx], cpu);
+
+		printk(KERN_INFO "CPU#%d: PMC%d ctrl:  %016llx\n",
+			cpu, idx, pmc_ctrl);
+		printk(KERN_INFO "CPU#%d: PMC%d count: %016llx\n",
+			cpu, idx, pmc_count);
+		printk(KERN_INFO "CPU#%d: PMC%d left:  %016llx\n",
+			cpu, idx, prev_left);
+	}
+	local_irq_enable();
+}
+
+static void x86_perf_counter_disable(struct perf_counter *counter)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	struct hw_perf_counter *hwc = &counter->hw;
+	unsigned int idx = hwc->idx;
+
+	__x86_perf_counter_disable(counter, hwc, idx);
+
+	clear_bit(idx, cpuc->used);
+	cpuc->counters[idx] = NULL;
+
+	/*
+	 * Drain the remaining delta count out of a counter
+	 * that we are disabling:
+	 */
+	x86_perf_counter_update(counter, hwc, idx);
+}
+
+static void perf_store_irq_data(struct perf_counter *counter, u64 data)
+{
+	struct perf_data *irqdata = counter->irqdata;
+
+	if (irqdata->len > PERF_DATA_BUFLEN - sizeof(u64)) {
+		irqdata->overrun++;
+	} else {
+		u64 *p = (u64 *) &irqdata->data[irqdata->len];
+
+		*p = data;
+		irqdata->len += sizeof(u64);
+	}
+}
+
+/*
+ * Save and restart an expired counter. Called by NMI contexts,
+ * so it has to be careful about preempting normal counter ops:
+ */
+static void perf_save_and_restart(struct perf_counter *counter)
+{
+	struct hw_perf_counter *hwc = &counter->hw;
+	int idx = hwc->idx;
+	u64 pmc_ctrl;
+
+	rdmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + idx, pmc_ctrl);
+
+	x86_perf_counter_update(counter, hwc, idx);
+	__hw_perf_counter_set_period(counter, hwc, idx);
+
+	if (pmc_ctrl & ARCH_PERFMON_EVENTSEL0_ENABLE)
+		__x86_perf_counter_enable(counter, hwc, idx);
+}
+
+static void
+perf_handle_group(struct perf_counter *sibling, u64 *status, u64 *overflown)
+{
+	struct perf_counter *counter, *group_leader = sibling->group_leader;
+
+	/*
+	 * Store sibling timestamps (if any):
+	 */
+	list_for_each_entry(counter, &group_leader->sibling_list, list_entry) {
+		x86_perf_counter_update(counter, &counter->hw, counter->hw.idx);
+		perf_store_irq_data(sibling, counter->hw_event.type);
+		perf_store_irq_data(sibling, atomic64_read(&counter->count));
+	}
+}
+
+/*
+ * This handler is triggered by the local APIC, so the APIC IRQ handling
+ * rules apply:
+ */
+static void __smp_perf_counter_interrupt(struct pt_regs *regs, int nmi)
+{
+	int bit, cpu = smp_processor_id();
+	u64 ack, status, saved_global;
+	struct cpu_hw_counters *cpuc;
+
+	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, saved_global);
+
+	/* Disable counters globally */
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0, 0);
+	ack_APIC_irq();
+
+	cpuc = &per_cpu(cpu_hw_counters, cpu);
+
+	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
+	if (!status)
+		goto out;
+
+again:
+	ack = status;
+	for_each_bit(bit, (unsigned long *) &status, nr_hw_counters) {
+		struct perf_counter *counter = cpuc->counters[bit];
+
+		clear_bit(bit, (unsigned long *) &status);
+		if (!counter)
+			continue;
+
+		perf_save_and_restart(counter);
+
+		switch (counter->hw_event.record_type) {
+		case PERF_RECORD_SIMPLE:
+			continue;
+		case PERF_RECORD_IRQ:
+			perf_store_irq_data(counter, instruction_pointer(regs));
+			break;
+		case PERF_RECORD_GROUP:
+			perf_handle_group(counter, &status, &ack);
+			break;
+		}
+		/*
+		 * From NMI context we cannot call into the scheduler to
+		 * do a task wakeup - but we mark these counters as
+		 * wakeup_pending and initate a wakeup callback:
+		 */
+		if (nmi) {
+			counter->wakeup_pending = 1;
+			set_tsk_thread_flag(current, TIF_PERF_COUNTERS);
+		} else {
+			wake_up(&counter->waitq);
+		}
+	}
+
+	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, ack, 0);
+
+	/*
+	 * Repeat if there is more work to be done:
+	 */
+	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
+	if (status)
+		goto again;
+out:
+	/*
+	 * Restore - do not reenable when global enable is off:
+	 */
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, saved_global, 0);
+}
+
+void smp_perf_counter_interrupt(struct pt_regs *regs)
+{
+	irq_enter();
+	inc_irq_stat(apic_perf_irqs);
+	apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
+	__smp_perf_counter_interrupt(regs, 0);
+
+	irq_exit();
+}
+
+/*
+ * This handler is triggered by NMI contexts:
+ */
+void perf_counter_notify(struct pt_regs *regs)
+{
+	struct cpu_hw_counters *cpuc;
+	unsigned long flags;
+	int bit, cpu;
+
+	local_irq_save(flags);
+	cpu = smp_processor_id();
+	cpuc = &per_cpu(cpu_hw_counters, cpu);
+
+	for_each_bit(bit, cpuc->used, nr_hw_counters) {
+		struct perf_counter *counter = cpuc->counters[bit];
+
+		if (!counter)
+			continue;
+
+		if (counter->wakeup_pending) {
+			counter->wakeup_pending = 0;
+			wake_up(&counter->waitq);
+		}
+	}
+
+	local_irq_restore(flags);
+}
+
+void __cpuinit perf_counters_lapic_init(int nmi)
+{
+	u32 apic_val;
+
+	if (!perf_counters_initialized)
+		return;
+	/*
+	 * Enable the performance counter vector in the APIC LVT:
+	 */
+	apic_val = apic_read(APIC_LVTERR);
+
+	apic_write(APIC_LVTERR, apic_val | APIC_LVT_MASKED);
+	if (nmi)
+		apic_write(APIC_LVTPC, APIC_DM_NMI);
+	else
+		apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
+	apic_write(APIC_LVTERR, apic_val);
+}
+
+static int __kprobes
+perf_counter_nmi_handler(struct notifier_block *self,
+			 unsigned long cmd, void *__args)
+{
+	struct die_args *args = __args;
+	struct pt_regs *regs;
+
+	if (likely(cmd != DIE_NMI_IPI))
+		return NOTIFY_DONE;
+
+	regs = args->regs;
+
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+	__smp_perf_counter_interrupt(regs, 1);
+
+	return NOTIFY_STOP;
+}
+
+static __read_mostly struct notifier_block perf_counter_nmi_notifier = {
+	.notifier_call		= perf_counter_nmi_handler
+};
+
+void __init init_hw_perf_counters(void)
+{
+	union cpuid10_eax eax;
+	unsigned int unused;
+	unsigned int ebx;
+
+	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
+		return;
+
+	/*
+	 * Check whether the Architectural PerfMon supports
+	 * Branch Misses Retired Event or not.
+	 */
+	cpuid(10, &(eax.full), &ebx, &unused, &unused);
+	if (eax.split.mask_length <= ARCH_PERFMON_BRANCH_MISSES_RETIRED)
+		return;
+
+	printk(KERN_INFO "Intel Performance Monitoring support detected.\n");
+
+	printk(KERN_INFO "... version:      %d\n", eax.split.version_id);
+	printk(KERN_INFO "... num_counters: %d\n", eax.split.num_counters);
+	nr_hw_counters = eax.split.num_counters;
+	if (nr_hw_counters > MAX_HW_COUNTERS) {
+		nr_hw_counters = MAX_HW_COUNTERS;
+		WARN(1, KERN_ERR "hw perf counters %d > max(%d), clipping!",
+			nr_hw_counters, MAX_HW_COUNTERS);
+	}
+	perf_counter_mask = (1 << nr_hw_counters) - 1;
+	perf_max_counters = nr_hw_counters;
+
+	printk(KERN_INFO "... bit_width:    %d\n", eax.split.bit_width);
+	printk(KERN_INFO "... mask_length:  %d\n", eax.split.mask_length);
+
+	perf_counters_initialized = true;
+
+	perf_counters_lapic_init(0);
+	register_die_notifier(&perf_counter_nmi_notifier);
+}
+
+static void x86_perf_counter_read(struct perf_counter *counter)
+{
+	x86_perf_counter_update(counter, &counter->hw, counter->hw.idx);
+}
+
+static const struct hw_perf_counter_ops x86_perf_counter_ops = {
+	.hw_perf_counter_enable		= x86_perf_counter_enable,
+	.hw_perf_counter_disable	= x86_perf_counter_disable,
+	.hw_perf_counter_read		= x86_perf_counter_read,
+};
+
+const struct hw_perf_counter_ops *
+hw_perf_counter_init(struct perf_counter *counter)
+{
+	int err;
+
+	err = __hw_perf_counter_init(counter);
+	if (err)
+		return NULL;
+
+	return &x86_perf_counter_ops;
+}
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 3194636..fc013cf 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -984,6 +984,11 @@ apicinterrupt ERROR_APIC_VECTOR \
 apicinterrupt SPURIOUS_APIC_VECTOR \
 	spurious_interrupt smp_spurious_interrupt
 
+#ifdef CONFIG_PERF_COUNTERS
+apicinterrupt LOCAL_PERF_VECTOR \
+	perf_counter_interrupt smp_perf_counter_interrupt
+#endif
+
 /*
  * Exception entry points.
  */
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index d1d4dc5..d92bc71 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -56,6 +56,10 @@ static int show_other_interrupts(struct seq_file *p)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_timer_irqs);
 	seq_printf(p, "  Local timer interrupts\n");
+	seq_printf(p, "CNT: ");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
+	seq_printf(p, "  Performance counter interrupts\n");
 #endif
 #ifdef CONFIG_SMP
 	seq_printf(p, "RES: ");
@@ -160,6 +164,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	sum += irq_stats(cpu)->apic_timer_irqs;
+	sum += irq_stats(cpu)->apic_perf_irqs;
 #endif
 #ifdef CONFIG_SMP
 	sum += irq_stats(cpu)->irq_resched_count;
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 607db63..6a33b5e 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -160,6 +160,9 @@ void __init native_init_IRQ(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+# ifdef CONFIG_PERF_COUNTERS
+	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
+# endif
 #endif
 
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_MCE_P4THERMAL)
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 8670b3c..91d785c 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -138,6 +138,11 @@ static void __init apic_intr_init(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+
+	/* Performance monitoring interrupt: */
+#ifdef CONFIG_PERF_COUNTERS
+	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
+#endif
 }
 
 void __init native_init_IRQ(void)
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index b1cc6da..dee553c 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -6,7 +6,7 @@
  *  2000-06-20  Pentium III FXSR, SSE support by Gareth Hughes
  *  2000-2002   x86-64 support by Andi Kleen
  */
-
+#include <linux/perf_counter.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
@@ -891,6 +891,11 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 		tracehook_notify_resume(regs);
 	}
 
+	if (thread_info_flags & _TIF_PERF_COUNTERS) {
+		clear_thread_flag(TIF_PERF_COUNTERS);
+		perf_counter_notify(regs);
+	}
+
 #ifdef CONFIG_X86_32
 	clear_thread_flag(TIF_IRET);
 #endif /* CONFIG_X86_32 */
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index d44395f..496726d 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -332,3 +332,4 @@ ENTRY(sys_call_table)
 	.long sys_dup3			/* 330 */
 	.long sys_pipe2
 	.long sys_inotify_init1
+	.long sys_perf_counter_open
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 5f8d746..a3e66a3 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -270,8 +270,11 @@ static atomic_t c3_cpu_count;
 /* Common C-state entry for C2, C3, .. */
 static void acpi_cstate_enter(struct acpi_processor_cx *cstate)
 {
+	u64 perf_flags;
+
 	/* Don't trace irqs off for idle */
 	stop_critical_timings();
+	perf_flags = hw_perf_save_disable();
 	if (cstate->entry_method == ACPI_CSTATE_FFH) {
 		/* Call into architectural FFH based C-state */
 		acpi_processor_ffh_cstate_enter(cstate);
@@ -284,6 +287,7 @@ static void acpi_cstate_enter(struct acpi_processor_cx *cstate)
 		   gets asserted in time to freeze execution properly. */
 		unused = inl(acpi_gbl_FADT.xpm_timer_block.address);
 	}
+	hw_perf_restore(perf_flags);
 	start_critical_timings();
 }
 #endif /* !CONFIG_CPU_IDLE */
@@ -1425,8 +1429,11 @@ static inline void acpi_idle_update_bm_rld(struct acpi_processor *pr,
  */
 static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 {
+	u64 pctrl;
+
 	/* Don't trace irqs off for idle */
 	stop_critical_timings();
+	pctrl = hw_perf_save_disable();
 	if (cx->entry_method == ACPI_CSTATE_FFH) {
 		/* Call into architectural FFH based C-state */
 		acpi_processor_ffh_cstate_enter(cx);
@@ -1441,6 +1448,7 @@ static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 		   gets asserted in time to freeze execution properly. */
 		unused = inl(acpi_gbl_FADT.xpm_timer_block.address);
 	}
+	hw_perf_restore(pctrl);
 	start_critical_timings();
 }
 
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index ce0d9da..52146c2 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -25,6 +25,7 @@
 #include <linux/kbd_kern.h>
 #include <linux/proc_fs.h>
 #include <linux/quotaops.h>
+#include <linux/perf_counter.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/suspend.h>
@@ -244,6 +245,7 @@ static void sysrq_handle_showregs(int key, struct tty_struct *tty)
 	struct pt_regs *regs = get_irq_regs();
 	if (regs)
 		show_regs(regs);
+	perf_counter_print_debug();
 }
 static struct sysrq_key_op sysrq_showregs_op = {
 	.handler	= sysrq_handle_showregs,
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
new file mode 100644
index 0000000..f30486f
--- /dev/null
+++ b/include/linux/perf_counter.h
@@ -0,0 +1,257 @@
+/*
+ *  Performance counters:
+ *
+ *   Copyright(C) 2008, Thomas Gleixner <tglx@linutronix.de>
+ *   Copyright(C) 2008, Red Hat, Inc., Ingo Molnar
+ *
+ *  Data type definitions, declarations, prototypes.
+ *
+ *  Started by: Thomas Gleixner and Ingo Molnar
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+#ifndef _LINUX_PERF_COUNTER_H
+#define _LINUX_PERF_COUNTER_H
+
+#include <asm/atomic.h>
+
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/rculist.h>
+#include <linux/rcupdate.h>
+#include <linux/spinlock.h>
+
+struct task_struct;
+
+/*
+ * User-space ABI bits:
+ */
+
+/*
+ * Generalized performance counter event types, used by the hw_event.type
+ * parameter of the sys_perf_counter_open() syscall:
+ */
+enum hw_event_types {
+	/*
+	 * Common hardware events, generalized by the kernel:
+	 */
+	PERF_COUNT_CYCLES		=  0,
+	PERF_COUNT_INSTRUCTIONS		=  1,
+	PERF_COUNT_CACHE_REFERENCES	=  2,
+	PERF_COUNT_CACHE_MISSES		=  3,
+	PERF_COUNT_BRANCH_INSTRUCTIONS	=  4,
+	PERF_COUNT_BRANCH_MISSES	=  5,
+
+	PERF_HW_EVENTS_MAX		=  6,
+
+	/*
+	 * Special "software" counters provided by the kernel, even if
+	 * the hardware does not support performance counters. These
+	 * counters measure various physical and sw events of the
+	 * kernel (and allow the profiling of them as well):
+	 */
+	PERF_COUNT_CPU_CLOCK		= -1,
+	PERF_COUNT_TASK_CLOCK		= -2,
+	PERF_COUNT_PAGE_FAULTS		= -3,
+	PERF_COUNT_CONTEXT_SWITCHES	= -4,
+	PERF_COUNT_CPU_MIGRATIONS	= -5,
+
+	PERF_SW_EVENTS_MIN		= -6,
+};
+
+/*
+ * IRQ-notification data record type:
+ */
+enum perf_counter_record_type {
+	PERF_RECORD_SIMPLE		=  0,
+	PERF_RECORD_IRQ			=  1,
+	PERF_RECORD_GROUP		=  2,
+};
+
+/*
+ * Hardware event to monitor via a performance monitoring counter:
+ */
+struct perf_counter_hw_event {
+	s64			type;
+
+	u64			irq_period;
+	u32			record_type;
+
+	u32			disabled     :  1, /* off by default      */
+				nmi	     :  1, /* NMI sampling        */
+				raw	     :  1, /* raw event type      */
+				inherit	     :  1, /* children inherit it */
+				__reserved_1 : 28;
+
+	u64			__reserved_2;
+};
+
+/*
+ * Kernel-internal data types:
+ */
+
+/**
+ * struct hw_perf_counter - performance counter hardware details:
+ */
+struct hw_perf_counter {
+#ifdef CONFIG_PERF_COUNTERS
+	u64				config;
+	unsigned long			config_base;
+	unsigned long			counter_base;
+	int				nmi;
+	unsigned int			idx;
+	atomic64_t			prev_count;
+	u64				irq_period;
+	atomic64_t			period_left;
+#endif
+};
+
+/*
+ * Hardcoded buffer length limit for now, for IRQ-fed events:
+ */
+#define PERF_DATA_BUFLEN		2048
+
+/**
+ * struct perf_data - performance counter IRQ data sampling ...
+ */
+struct perf_data {
+	int				len;
+	int				rd_idx;
+	int				overrun;
+	u8				data[PERF_DATA_BUFLEN];
+};
+
+struct perf_counter;
+
+/**
+ * struct hw_perf_counter_ops - performance counter hw ops
+ */
+struct hw_perf_counter_ops {
+	void (*hw_perf_counter_enable)	(struct perf_counter *counter);
+	void (*hw_perf_counter_disable)	(struct perf_counter *counter);
+	void (*hw_perf_counter_read)	(struct perf_counter *counter);
+};
+
+/**
+ * enum perf_counter_active_state - the states of a counter
+ */
+enum perf_counter_active_state {
+	PERF_COUNTER_STATE_OFF		= -1,
+	PERF_COUNTER_STATE_INACTIVE	=  0,
+	PERF_COUNTER_STATE_ACTIVE	=  1,
+};
+
+struct file;
+
+/**
+ * struct perf_counter - performance counter kernel representation:
+ */
+struct perf_counter {
+#ifdef CONFIG_PERF_COUNTERS
+	struct list_head		list_entry;
+	struct list_head		sibling_list;
+	struct perf_counter		*group_leader;
+	const struct hw_perf_counter_ops *hw_ops;
+
+	enum perf_counter_active_state	state;
+	atomic64_t			count;
+
+	struct perf_counter_hw_event	hw_event;
+	struct hw_perf_counter		hw;
+
+	struct perf_counter_context	*ctx;
+	struct task_struct		*task;
+	struct file			*filp;
+
+	unsigned int			nr_inherited;
+	struct perf_counter		*parent;
+	/*
+	 * Protect attach/detach:
+	 */
+	struct mutex			mutex;
+
+	int				oncpu;
+	int				cpu;
+
+	/* read() / irq related data */
+	wait_queue_head_t		waitq;
+	/* optional: for NMIs */
+	int				wakeup_pending;
+	struct perf_data		*irqdata;
+	struct perf_data		*usrdata;
+	struct perf_data		data[2];
+#endif
+};
+
+/**
+ * struct perf_counter_context - counter context structure
+ *
+ * Used as a container for task counters and CPU counters as well:
+ */
+struct perf_counter_context {
+#ifdef CONFIG_PERF_COUNTERS
+	/*
+	 * Protect the list of counters:
+	 */
+	spinlock_t		lock;
+
+	struct list_head	counter_list;
+	int			nr_counters;
+	int			nr_active;
+	struct task_struct	*task;
+#endif
+};
+
+/**
+ * struct perf_counter_cpu_context - per cpu counter context structure
+ */
+struct perf_cpu_context {
+	struct perf_counter_context	ctx;
+	struct perf_counter_context	*task_ctx;
+	int				active_oncpu;
+	int				max_pertask;
+};
+
+/*
+ * Set by architecture code:
+ */
+extern int perf_max_counters;
+
+#ifdef CONFIG_PERF_COUNTERS
+extern void
+perf_counter_show(struct perf_counter *counter, char *str, int trace);
+extern const struct hw_perf_counter_ops *
+hw_perf_counter_init(struct perf_counter *counter);
+
+extern void perf_counter_task_sched_in(struct task_struct *task, int cpu);
+extern void perf_counter_task_sched_out(struct task_struct *task, int cpu);
+extern void perf_counter_task_tick(struct task_struct *task, int cpu);
+extern void perf_counter_init_task(struct task_struct *child);
+extern void perf_counter_exit_task(struct task_struct *child);
+extern void perf_counter_notify(struct pt_regs *regs);
+extern void perf_counter_print_debug(void);
+extern u64 hw_perf_save_disable(void);
+extern void hw_perf_restore(u64 ctrl);
+extern int perf_counter_task_disable(void);
+extern int perf_counter_task_enable(void);
+
+#else
+static inline void
+perf_counter_show(struct perf_counter *counter, char *str, int trace)   { }
+static inline void
+perf_counter_task_sched_in(struct task_struct *task, int cpu)		{ }
+static inline void
+perf_counter_task_sched_out(struct task_struct *task, int cpu)		{ }
+static inline void
+perf_counter_task_tick(struct task_struct *task, int cpu)		{ }
+static inline void perf_counter_init_task(struct task_struct *child)	{ }
+static inline void perf_counter_exit_task(struct task_struct *child)	{ }
+static inline void perf_counter_notify(struct pt_regs *regs)		{ }
+static inline void perf_counter_print_debug(void)			{ }
+static inline void hw_perf_restore(u64 ctrl)			{ }
+static inline u64 hw_perf_save_disable(void)		      { return 0; }
+static inline int perf_counter_task_disable(void)	{ return -EINVAL; }
+static inline int perf_counter_task_enable(void)	{ return -EINVAL; }
+#endif
+
+#endif /* _LINUX_PERF_COUNTER_H */
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index 48d887e..b00df4c 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -85,4 +85,7 @@
 #define PR_SET_TIMERSLACK 29
 #define PR_GET_TIMERSLACK 30
 
+#define PR_TASK_PERF_COUNTERS_DISABLE		31
+#define PR_TASK_PERF_COUNTERS_ENABLE		32
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 55e30d1..2e15be8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -71,6 +71,7 @@ struct sched_param {
 #include <linux/fs_struct.h>
 #include <linux/compiler.h>
 #include <linux/completion.h>
+#include <linux/perf_counter.h>
 #include <linux/pid.h>
 #include <linux/percpu.h>
 #include <linux/topology.h>
@@ -1013,6 +1014,8 @@ struct sched_entity {
 	u64			last_wakeup;
 	u64			avg_overlap;
 
+	u64			nr_migrations;
+
 #ifdef CONFIG_SCHEDSTATS
 	u64			wait_start;
 	u64			wait_max;
@@ -1028,7 +1031,6 @@ struct sched_entity {
 	u64			exec_max;
 	u64			slice_max;
 
-	u64			nr_migrations;
 	u64			nr_migrations_cold;
 	u64			nr_failed_migrations_affine;
 	u64			nr_failed_migrations_running;
@@ -1326,6 +1328,7 @@ struct task_struct {
 	struct list_head pi_state_list;
 	struct futex_pi_state *pi_state_cache;
 #endif
+	struct perf_counter_context perf_counter_ctx;
 #ifdef CONFIG_NUMA
 	struct mempolicy *mempolicy;
 	short il_next;
@@ -2285,6 +2288,13 @@ static inline void inc_syscw(struct task_struct *tsk)
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
 
+/*
+ * Call the function if the target task is executing on a CPU right now:
+ */
+extern void task_oncpu_function_call(struct task_struct *p,
+				     void (*func) (void *info), void *info);
+
+
 #ifdef CONFIG_MM_OWNER
 extern void mm_update_next_owner(struct mm_struct *mm);
 extern void mm_init_owner(struct mm_struct *mm, struct task_struct *p);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 04fb47b..a549678 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -54,6 +54,7 @@ struct compat_stat;
 struct compat_timeval;
 struct robust_list_head;
 struct getcpu_cache;
+struct perf_counter_hw_event;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -624,4 +625,11 @@ asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
+
+asmlinkage int sys_perf_counter_open(
+
+	struct perf_counter_hw_event	*hw_event_uptr		__user,
+	pid_t				pid,
+	int				cpu,
+	int				group_fd);
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index f763762..7d147a3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -732,6 +732,36 @@ config AIO
           by some high performance threaded applications. Disabling
           this option saves about 7k.
 
+config HAVE_PERF_COUNTERS
+	bool
+
+menu "Performance Counters"
+
+config PERF_COUNTERS
+	bool "Kernel Performance Counters"
+	depends on HAVE_PERF_COUNTERS
+	default y
+	select ANON_INODES
+	help
+	  Enable kernel support for performance counter hardware.
+
+	  Performance counters are special hardware registers available
+	  on most modern CPUs. These registers count the number of certain
+	  types of hw events: such as instructions executed, cachemisses
+	  suffered, or branches mis-predicted - without slowing down the
+	  kernel or applications. These registers can also trigger interrupts
+	  when a threshold number of events have passed - and can thus be
+	  used to profile the code that runs on that CPU.
+
+	  The Linux Performance Counter subsystem provides an abstraction of
+	  these hardware capabilities, available via a system call. It
+	  provides per task and per CPU counters, and it provides event
+	  capabilities on top of those.
+
+	  Say Y if unsure.
+
+endmenu
+
 config VM_EVENT_COUNTERS
 	default y
 	bool "Enable VM event counters for /proc/vmstat" if EMBEDDED
diff --git a/kernel/Makefile b/kernel/Makefile
index 19fad00..1f184a1 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -89,6 +89,7 @@ obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
+obj-$(CONFIG_PERF_COUNTERS) += perf_counter.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/exit.c b/kernel/exit.c
index 2d8be7e..d336c90 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1093,11 +1093,12 @@ NORET_TYPE void do_exit(long code)
 	mpol_put(tsk->mempolicy);
 	tsk->mempolicy = NULL;
 #endif
-#ifdef CONFIG_FUTEX
 	/*
-	 * This must happen late, after the PID is not
-	 * hashed anymore:
+	 * These must happen late, after the PID is not
+	 * hashed anymore, but still at a point that may sleep:
 	 */
+	perf_counter_exit_task(tsk);
+#ifdef CONFIG_FUTEX
 	if (unlikely(!list_empty(&tsk->pi_state_list)))
 		exit_pi_state_list(tsk);
 	if (unlikely(current->pi_state_cache))
diff --git a/kernel/fork.c b/kernel/fork.c
index 495da2e..e207860 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -978,6 +978,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto fork_out;
 
 	rt_mutex_init_task(p);
+	perf_counter_init_task(p);
 
 #ifdef CONFIG_PROVE_LOCKING
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
new file mode 100644
index 0000000..539fa82
--- /dev/null
+++ b/kernel/perf_counter.c
@@ -0,0 +1,1542 @@
+/*
+ * Performance counter core code
+ *
+ *  Copyright(C) 2008 Thomas Gleixner <tglx@linutronix.de>
+ *  Copyright(C) 2008 Red Hat, Inc., Ingo Molnar
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/fs.h>
+#include <linux/cpu.h>
+#include <linux/smp.h>
+#include <linux/file.h>
+#include <linux/poll.h>
+#include <linux/sysfs.h>
+#include <linux/ptrace.h>
+#include <linux/percpu.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+#include <linux/anon_inodes.h>
+#include <linux/perf_counter.h>
+
+/*
+ * Each CPU has a list of per CPU counters:
+ */
+DEFINE_PER_CPU(struct perf_cpu_context, perf_cpu_context);
+
+int perf_max_counters __read_mostly = 1;
+static int perf_reserved_percpu __read_mostly;
+static int perf_overcommit __read_mostly = 1;
+
+/*
+ * Mutex for (sysadmin-configurable) counter reservations:
+ */
+static DEFINE_MUTEX(perf_resource_mutex);
+
+/*
+ * Architecture provided APIs - weak aliases:
+ */
+extern __weak const struct hw_perf_counter_ops *
+hw_perf_counter_init(struct perf_counter *counter)
+{
+	return ERR_PTR(-EINVAL);
+}
+
+u64 __weak hw_perf_save_disable(void)		{ return 0; }
+void __weak hw_perf_restore(u64 ctrl)		{ }
+void __weak hw_perf_counter_setup(void)		{ }
+
+static void
+list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
+{
+	struct perf_counter *group_leader = counter->group_leader;
+
+	/*
+	 * Depending on whether it is a standalone or sibling counter,
+	 * add it straight to the context's counter list, or to the group
+	 * leader's sibling list:
+	 */
+	if (counter->group_leader == counter)
+		list_add_tail(&counter->list_entry, &ctx->counter_list);
+	else
+		list_add_tail(&counter->list_entry, &group_leader->sibling_list);
+}
+
+static void
+list_del_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
+{
+	struct perf_counter *sibling, *tmp;
+
+	list_del_init(&counter->list_entry);
+
+	/*
+	 * If this was a group counter with sibling counters then
+	 * upgrade the siblings to singleton counters by adding them
+	 * to the context list directly:
+	 */
+	list_for_each_entry_safe(sibling, tmp,
+				 &counter->sibling_list, list_entry) {
+
+		list_del_init(&sibling->list_entry);
+		list_add_tail(&sibling->list_entry, &ctx->counter_list);
+		sibling->group_leader = sibling;
+	}
+}
+
+/*
+ * Cross CPU call to remove a performance counter
+ *
+ * We disable the counter on the hardware level first. After that we
+ * remove it from the context list.
+ */
+static void __perf_counter_remove_from_context(void *info)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter *counter = info;
+	struct perf_counter_context *ctx = counter->ctx;
+	unsigned long flags;
+	u64 perf_flags;
+
+	/*
+	 * If this is a task context, we need to check whether it is
+	 * the current task context of this cpu. If not it has been
+	 * scheduled out before the smp call arrived.
+	 */
+	if (ctx->task && cpuctx->task_ctx != ctx)
+		return;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+
+	if (counter->state == PERF_COUNTER_STATE_ACTIVE) {
+		counter->hw_ops->hw_perf_counter_disable(counter);
+		counter->state = PERF_COUNTER_STATE_INACTIVE;
+		ctx->nr_active--;
+		cpuctx->active_oncpu--;
+		counter->task = NULL;
+	}
+	ctx->nr_counters--;
+
+	/*
+	 * Protect the list operation against NMI by disabling the
+	 * counters on a global level. NOP for non NMI based counters.
+	 */
+	perf_flags = hw_perf_save_disable();
+	list_del_counter(counter, ctx);
+	hw_perf_restore(perf_flags);
+
+	if (!ctx->task) {
+		/*
+		 * Allow more per task counters with respect to the
+		 * reservation:
+		 */
+		cpuctx->max_pertask =
+			min(perf_max_counters - ctx->nr_counters,
+			    perf_max_counters - perf_reserved_percpu);
+	}
+
+	spin_unlock_irqrestore(&ctx->lock, flags);
+}
+
+
+/*
+ * Remove the counter from a task's (or a CPU's) list of counters.
+ *
+ * Must be called with counter->mutex held.
+ *
+ * CPU counters are removed with a smp call. For task counters we only
+ * call when the task is on a CPU.
+ */
+static void perf_counter_remove_from_context(struct perf_counter *counter)
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	struct task_struct *task = ctx->task;
+
+	if (!task) {
+		/*
+		 * Per cpu counters are removed via an smp call and
+		 * the removal is always sucessful.
+		 */
+		smp_call_function_single(counter->cpu,
+					 __perf_counter_remove_from_context,
+					 counter, 1);
+		return;
+	}
+
+retry:
+	task_oncpu_function_call(task, __perf_counter_remove_from_context,
+				 counter);
+
+	spin_lock_irq(&ctx->lock);
+	/*
+	 * If the context is active we need to retry the smp call.
+	 */
+	if (ctx->nr_active && !list_empty(&counter->list_entry)) {
+		spin_unlock_irq(&ctx->lock);
+		goto retry;
+	}
+
+	/*
+	 * The lock prevents that this context is scheduled in so we
+	 * can remove the counter safely, if the call above did not
+	 * succeed.
+	 */
+	if (!list_empty(&counter->list_entry)) {
+		ctx->nr_counters--;
+		list_del_counter(counter, ctx);
+		counter->task = NULL;
+	}
+	spin_unlock_irq(&ctx->lock);
+}
+
+/*
+ * Cross CPU call to install and enable a preformance counter
+ */
+static void __perf_install_in_context(void *info)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter *counter = info;
+	struct perf_counter_context *ctx = counter->ctx;
+	int cpu = smp_processor_id();
+	unsigned long flags;
+	u64 perf_flags;
+
+	/*
+	 * If this is a task context, we need to check whether it is
+	 * the current task context of this cpu. If not it has been
+	 * scheduled out before the smp call arrived.
+	 */
+	if (ctx->task && cpuctx->task_ctx != ctx)
+		return;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+
+	/*
+	 * Protect the list operation against NMI by disabling the
+	 * counters on a global level. NOP for non NMI based counters.
+	 */
+	perf_flags = hw_perf_save_disable();
+	list_add_counter(counter, ctx);
+	hw_perf_restore(perf_flags);
+
+	ctx->nr_counters++;
+
+	if (cpuctx->active_oncpu < perf_max_counters) {
+		counter->state = PERF_COUNTER_STATE_ACTIVE;
+		counter->oncpu = cpu;
+		ctx->nr_active++;
+		cpuctx->active_oncpu++;
+		counter->hw_ops->hw_perf_counter_enable(counter);
+	}
+
+	if (!ctx->task && cpuctx->max_pertask)
+		cpuctx->max_pertask--;
+
+	spin_unlock_irqrestore(&ctx->lock, flags);
+}
+
+/*
+ * Attach a performance counter to a context
+ *
+ * First we add the counter to the list with the hardware enable bit
+ * in counter->hw_config cleared.
+ *
+ * If the counter is attached to a task which is on a CPU we use a smp
+ * call to enable it in the task context. The task might have been
+ * scheduled away, but we check this in the smp call again.
+ */
+static void
+perf_install_in_context(struct perf_counter_context *ctx,
+			struct perf_counter *counter,
+			int cpu)
+{
+	struct task_struct *task = ctx->task;
+
+	counter->ctx = ctx;
+	if (!task) {
+		/*
+		 * Per cpu counters are installed via an smp call and
+		 * the install is always sucessful.
+		 */
+		smp_call_function_single(cpu, __perf_install_in_context,
+					 counter, 1);
+		return;
+	}
+
+	counter->task = task;
+retry:
+	task_oncpu_function_call(task, __perf_install_in_context,
+				 counter);
+
+	spin_lock_irq(&ctx->lock);
+	/*
+	 * we need to retry the smp call.
+	 */
+	if (ctx->nr_active && list_empty(&counter->list_entry)) {
+		spin_unlock_irq(&ctx->lock);
+		goto retry;
+	}
+
+	/*
+	 * The lock prevents that this context is scheduled in so we
+	 * can add the counter safely, if it the call above did not
+	 * succeed.
+	 */
+	if (list_empty(&counter->list_entry)) {
+		list_add_counter(counter, ctx);
+		ctx->nr_counters++;
+	}
+	spin_unlock_irq(&ctx->lock);
+}
+
+static void
+counter_sched_out(struct perf_counter *counter,
+		  struct perf_cpu_context *cpuctx,
+		  struct perf_counter_context *ctx)
+{
+	if (counter->state != PERF_COUNTER_STATE_ACTIVE)
+		return;
+
+	counter->hw_ops->hw_perf_counter_disable(counter);
+	counter->state = PERF_COUNTER_STATE_INACTIVE;
+	counter->oncpu = -1;
+
+	cpuctx->active_oncpu--;
+	ctx->nr_active--;
+}
+
+static void
+group_sched_out(struct perf_counter *group_counter,
+		struct perf_cpu_context *cpuctx,
+		struct perf_counter_context *ctx)
+{
+	struct perf_counter *counter;
+
+	counter_sched_out(group_counter, cpuctx, ctx);
+
+	/*
+	 * Schedule out siblings (if any):
+	 */
+	list_for_each_entry(counter, &group_counter->sibling_list, list_entry)
+		counter_sched_out(counter, cpuctx, ctx);
+}
+
+/*
+ * Called from scheduler to remove the counters of the current task,
+ * with interrupts disabled.
+ *
+ * We stop each counter and update the counter value in counter->count.
+ *
+ * This does not protect us against NMI, but hw_perf_counter_disable()
+ * sets the disabled bit in the control field of counter _before_
+ * accessing the counter control register. If a NMI hits, then it will
+ * not restart the counter.
+ */
+void perf_counter_task_sched_out(struct task_struct *task, int cpu)
+{
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_counter_context *ctx = &task->perf_counter_ctx;
+	struct perf_counter *counter;
+
+	if (likely(!cpuctx->task_ctx))
+		return;
+
+	spin_lock(&ctx->lock);
+	if (ctx->nr_active) {
+		list_for_each_entry(counter, &ctx->counter_list, list_entry)
+			group_sched_out(counter, cpuctx, ctx);
+	}
+	spin_unlock(&ctx->lock);
+	cpuctx->task_ctx = NULL;
+}
+
+static void
+counter_sched_in(struct perf_counter *counter,
+		 struct perf_cpu_context *cpuctx,
+		 struct perf_counter_context *ctx,
+		 int cpu)
+{
+	if (counter->state == PERF_COUNTER_STATE_OFF)
+		return;
+
+	counter->hw_ops->hw_perf_counter_enable(counter);
+	counter->state = PERF_COUNTER_STATE_ACTIVE;
+	counter->oncpu = cpu;	/* TODO: put 'cpu' into cpuctx->cpu */
+
+	cpuctx->active_oncpu++;
+	ctx->nr_active++;
+}
+
+static void
+group_sched_in(struct perf_counter *group_counter,
+	       struct perf_cpu_context *cpuctx,
+	       struct perf_counter_context *ctx,
+	       int cpu)
+{
+	struct perf_counter *counter;
+
+	counter_sched_in(group_counter, cpuctx, ctx, cpu);
+
+	/*
+	 * Schedule in siblings as one group (if any):
+	 */
+	list_for_each_entry(counter, &group_counter->sibling_list, list_entry)
+		counter_sched_in(counter, cpuctx, ctx, cpu);
+}
+
+/*
+ * Called from scheduler to add the counters of the current task
+ * with interrupts disabled.
+ *
+ * We restore the counter value and then enable it.
+ *
+ * This does not protect us against NMI, but hw_perf_counter_enable()
+ * sets the enabled bit in the control field of counter _before_
+ * accessing the counter control register. If a NMI hits, then it will
+ * keep the counter running.
+ */
+void perf_counter_task_sched_in(struct task_struct *task, int cpu)
+{
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_counter_context *ctx = &task->perf_counter_ctx;
+	struct perf_counter *counter;
+
+	if (likely(!ctx->nr_counters))
+		return;
+
+	spin_lock(&ctx->lock);
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		if (ctx->nr_active == cpuctx->max_pertask)
+			break;
+
+		/*
+		 * Listen to the 'cpu' scheduling filter constraint
+		 * of counters:
+		 */
+		if (counter->cpu != -1 && counter->cpu != cpu)
+			continue;
+
+		group_sched_in(counter, cpuctx, ctx, cpu);
+	}
+	spin_unlock(&ctx->lock);
+
+	cpuctx->task_ctx = ctx;
+}
+
+int perf_counter_task_disable(void)
+{
+	struct task_struct *curr = current;
+	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	struct perf_counter *counter;
+	u64 perf_flags;
+	int cpu;
+
+	if (likely(!ctx->nr_counters))
+		return 0;
+
+	local_irq_disable();
+	cpu = smp_processor_id();
+
+	perf_counter_task_sched_out(curr, cpu);
+
+	spin_lock(&ctx->lock);
+
+	/*
+	 * Disable all the counters:
+	 */
+	perf_flags = hw_perf_save_disable();
+
+	list_for_each_entry(counter, &ctx->counter_list, list_entry)
+		counter->state = PERF_COUNTER_STATE_OFF;
+
+	hw_perf_restore(perf_flags);
+
+	spin_unlock(&ctx->lock);
+
+	local_irq_enable();
+
+	return 0;
+}
+
+int perf_counter_task_enable(void)
+{
+	struct task_struct *curr = current;
+	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	struct perf_counter *counter;
+	u64 perf_flags;
+	int cpu;
+
+	if (likely(!ctx->nr_counters))
+		return 0;
+
+	local_irq_disable();
+	cpu = smp_processor_id();
+
+	spin_lock(&ctx->lock);
+
+	/*
+	 * Disable all the counters:
+	 */
+	perf_flags = hw_perf_save_disable();
+
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		if (counter->state != PERF_COUNTER_STATE_OFF)
+			continue;
+		counter->state = PERF_COUNTER_STATE_INACTIVE;
+	}
+	hw_perf_restore(perf_flags);
+
+	spin_unlock(&ctx->lock);
+
+	perf_counter_task_sched_in(curr, cpu);
+
+	local_irq_enable();
+
+	return 0;
+}
+
+void perf_counter_task_tick(struct task_struct *curr, int cpu)
+{
+	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	struct perf_counter *counter;
+	u64 perf_flags;
+
+	if (likely(!ctx->nr_counters))
+		return;
+
+	perf_counter_task_sched_out(curr, cpu);
+
+	spin_lock(&ctx->lock);
+
+	/*
+	 * Rotate the first entry last (works just fine for group counters too):
+	 */
+	perf_flags = hw_perf_save_disable();
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		list_del(&counter->list_entry);
+		list_add_tail(&counter->list_entry, &ctx->counter_list);
+		break;
+	}
+	hw_perf_restore(perf_flags);
+
+	spin_unlock(&ctx->lock);
+
+	perf_counter_task_sched_in(curr, cpu);
+}
+
+/*
+ * Cross CPU call to read the hardware counter
+ */
+static void __hw_perf_counter_read(void *info)
+{
+	struct perf_counter *counter = info;
+
+	counter->hw_ops->hw_perf_counter_read(counter);
+}
+
+static u64 perf_counter_read(struct perf_counter *counter)
+{
+	/*
+	 * If counter is enabled and currently active on a CPU, update the
+	 * value in the counter structure:
+	 */
+	if (counter->state == PERF_COUNTER_STATE_ACTIVE) {
+		smp_call_function_single(counter->oncpu,
+					 __hw_perf_counter_read, counter, 1);
+	}
+
+	return atomic64_read(&counter->count);
+}
+
+/*
+ * Cross CPU call to switch performance data pointers
+ */
+static void __perf_switch_irq_data(void *info)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter *counter = info;
+	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_data *oldirqdata = counter->irqdata;
+
+	/*
+	 * If this is a task context, we need to check whether it is
+	 * the current task context of this cpu. If not it has been
+	 * scheduled out before the smp call arrived.
+	 */
+	if (ctx->task) {
+		if (cpuctx->task_ctx != ctx)
+			return;
+		spin_lock(&ctx->lock);
+	}
+
+	/* Change the pointer NMI safe */
+	atomic_long_set((atomic_long_t *)&counter->irqdata,
+			(unsigned long) counter->usrdata);
+	counter->usrdata = oldirqdata;
+
+	if (ctx->task)
+		spin_unlock(&ctx->lock);
+}
+
+static struct perf_data *perf_switch_irq_data(struct perf_counter *counter)
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_data *oldirqdata = counter->irqdata;
+	struct task_struct *task = ctx->task;
+
+	if (!task) {
+		smp_call_function_single(counter->cpu,
+					 __perf_switch_irq_data,
+					 counter, 1);
+		return counter->usrdata;
+	}
+
+retry:
+	spin_lock_irq(&ctx->lock);
+	if (counter->state != PERF_COUNTER_STATE_ACTIVE) {
+		counter->irqdata = counter->usrdata;
+		counter->usrdata = oldirqdata;
+		spin_unlock_irq(&ctx->lock);
+		return oldirqdata;
+	}
+	spin_unlock_irq(&ctx->lock);
+	task_oncpu_function_call(task, __perf_switch_irq_data, counter);
+	/* Might have failed, because task was scheduled out */
+	if (counter->irqdata == oldirqdata)
+		goto retry;
+
+	return counter->usrdata;
+}
+
+static void put_context(struct perf_counter_context *ctx)
+{
+	if (ctx->task)
+		put_task_struct(ctx->task);
+}
+
+static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
+{
+	struct perf_cpu_context *cpuctx;
+	struct perf_counter_context *ctx;
+	struct task_struct *task;
+
+	/*
+	 * If cpu is not a wildcard then this is a percpu counter:
+	 */
+	if (cpu != -1) {
+		/* Must be root to operate on a CPU counter: */
+		if (!capable(CAP_SYS_ADMIN))
+			return ERR_PTR(-EACCES);
+
+		if (cpu < 0 || cpu > num_possible_cpus())
+			return ERR_PTR(-EINVAL);
+
+		/*
+		 * We could be clever and allow to attach a counter to an
+		 * offline CPU and activate it when the CPU comes up, but
+		 * that's for later.
+		 */
+		if (!cpu_isset(cpu, cpu_online_map))
+			return ERR_PTR(-ENODEV);
+
+		cpuctx = &per_cpu(perf_cpu_context, cpu);
+		ctx = &cpuctx->ctx;
+
+		return ctx;
+	}
+
+	rcu_read_lock();
+	if (!pid)
+		task = current;
+	else
+		task = find_task_by_vpid(pid);
+	if (task)
+		get_task_struct(task);
+	rcu_read_unlock();
+
+	if (!task)
+		return ERR_PTR(-ESRCH);
+
+	ctx = &task->perf_counter_ctx;
+	ctx->task = task;
+
+	/* Reuse ptrace permission checks for now. */
+	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
+		put_context(ctx);
+		return ERR_PTR(-EACCES);
+	}
+
+	return ctx;
+}
+
+/*
+ * Called when the last reference to the file is gone.
+ */
+static int perf_release(struct inode *inode, struct file *file)
+{
+	struct perf_counter *counter = file->private_data;
+	struct perf_counter_context *ctx = counter->ctx;
+
+	file->private_data = NULL;
+
+	mutex_lock(&counter->mutex);
+
+	perf_counter_remove_from_context(counter);
+	put_context(ctx);
+
+	mutex_unlock(&counter->mutex);
+
+	kfree(counter);
+
+	return 0;
+}
+
+/*
+ * Read the performance counter - simple non blocking version for now
+ */
+static ssize_t
+perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
+{
+	u64 cntval;
+
+	if (count != sizeof(cntval))
+		return -EINVAL;
+
+	mutex_lock(&counter->mutex);
+	cntval = perf_counter_read(counter);
+	mutex_unlock(&counter->mutex);
+
+	return put_user(cntval, (u64 __user *) buf) ? -EFAULT : sizeof(cntval);
+}
+
+static ssize_t
+perf_copy_usrdata(struct perf_data *usrdata, char __user *buf, size_t count)
+{
+	if (!usrdata->len)
+		return 0;
+
+	count = min(count, (size_t)usrdata->len);
+	if (copy_to_user(buf, usrdata->data + usrdata->rd_idx, count))
+		return -EFAULT;
+
+	/* Adjust the counters */
+	usrdata->len -= count;
+	if (!usrdata->len)
+		usrdata->rd_idx = 0;
+	else
+		usrdata->rd_idx += count;
+
+	return count;
+}
+
+static ssize_t
+perf_read_irq_data(struct perf_counter	*counter,
+		   char __user		*buf,
+		   size_t		count,
+		   int			nonblocking)
+{
+	struct perf_data *irqdata, *usrdata;
+	DECLARE_WAITQUEUE(wait, current);
+	ssize_t res;
+
+	irqdata = counter->irqdata;
+	usrdata = counter->usrdata;
+
+	if (usrdata->len + irqdata->len >= count)
+		goto read_pending;
+
+	if (nonblocking)
+		return -EAGAIN;
+
+	spin_lock_irq(&counter->waitq.lock);
+	__add_wait_queue(&counter->waitq, &wait);
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (usrdata->len + irqdata->len >= count)
+			break;
+
+		if (signal_pending(current))
+			break;
+
+		spin_unlock_irq(&counter->waitq.lock);
+		schedule();
+		spin_lock_irq(&counter->waitq.lock);
+	}
+	__remove_wait_queue(&counter->waitq, &wait);
+	__set_current_state(TASK_RUNNING);
+	spin_unlock_irq(&counter->waitq.lock);
+
+	if (usrdata->len + irqdata->len < count)
+		return -ERESTARTSYS;
+read_pending:
+	mutex_lock(&counter->mutex);
+
+	/* Drain pending data first: */
+	res = perf_copy_usrdata(usrdata, buf, count);
+	if (res < 0 || res == count)
+		goto out;
+
+	/* Switch irq buffer: */
+	usrdata = perf_switch_irq_data(counter);
+	if (perf_copy_usrdata(usrdata, buf + res, count - res) < 0) {
+		if (!res)
+			res = -EFAULT;
+	} else {
+		res = count;
+	}
+out:
+	mutex_unlock(&counter->mutex);
+
+	return res;
+}
+
+static ssize_t
+perf_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+{
+	struct perf_counter *counter = file->private_data;
+
+	switch (counter->hw_event.record_type) {
+	case PERF_RECORD_SIMPLE:
+		return perf_read_hw(counter, buf, count);
+
+	case PERF_RECORD_IRQ:
+	case PERF_RECORD_GROUP:
+		return perf_read_irq_data(counter, buf, count,
+					  file->f_flags & O_NONBLOCK);
+	}
+	return -EINVAL;
+}
+
+static unsigned int perf_poll(struct file *file, poll_table *wait)
+{
+	struct perf_counter *counter = file->private_data;
+	unsigned int events = 0;
+	unsigned long flags;
+
+	poll_wait(file, &counter->waitq, wait);
+
+	spin_lock_irqsave(&counter->waitq.lock, flags);
+	if (counter->usrdata->len || counter->irqdata->len)
+		events |= POLLIN;
+	spin_unlock_irqrestore(&counter->waitq.lock, flags);
+
+	return events;
+}
+
+static const struct file_operations perf_fops = {
+	.release		= perf_release,
+	.read			= perf_read,
+	.poll			= perf_poll,
+};
+
+static void cpu_clock_perf_counter_enable(struct perf_counter *counter)
+{
+}
+
+static void cpu_clock_perf_counter_disable(struct perf_counter *counter)
+{
+}
+
+static void cpu_clock_perf_counter_read(struct perf_counter *counter)
+{
+	int cpu = raw_smp_processor_id();
+
+	atomic64_set(&counter->count, cpu_clock(cpu));
+}
+
+static const struct hw_perf_counter_ops perf_ops_cpu_clock = {
+	.hw_perf_counter_enable		= cpu_clock_perf_counter_enable,
+	.hw_perf_counter_disable	= cpu_clock_perf_counter_disable,
+	.hw_perf_counter_read		= cpu_clock_perf_counter_read,
+};
+
+static void task_clock_perf_counter_update(struct perf_counter *counter)
+{
+	u64 prev, now;
+	s64 delta;
+
+	prev = atomic64_read(&counter->hw.prev_count);
+	now = current->se.sum_exec_runtime;
+
+	atomic64_set(&counter->hw.prev_count, now);
+
+	delta = now - prev;
+	if (WARN_ON_ONCE(delta < 0))
+		delta = 0;
+
+	atomic64_add(delta, &counter->count);
+}
+
+static void task_clock_perf_counter_read(struct perf_counter *counter)
+{
+	task_clock_perf_counter_update(counter);
+}
+
+static void task_clock_perf_counter_enable(struct perf_counter *counter)
+{
+	atomic64_set(&counter->hw.prev_count, current->se.sum_exec_runtime);
+}
+
+static void task_clock_perf_counter_disable(struct perf_counter *counter)
+{
+	task_clock_perf_counter_update(counter);
+}
+
+static const struct hw_perf_counter_ops perf_ops_task_clock = {
+	.hw_perf_counter_enable		= task_clock_perf_counter_enable,
+	.hw_perf_counter_disable	= task_clock_perf_counter_disable,
+	.hw_perf_counter_read		= task_clock_perf_counter_read,
+};
+
+static u64 get_page_faults(void)
+{
+	struct task_struct *curr = current;
+
+	return curr->maj_flt + curr->min_flt;
+}
+
+static void page_faults_perf_counter_update(struct perf_counter *counter)
+{
+	u64 prev, now;
+	s64 delta;
+
+	prev = atomic64_read(&counter->hw.prev_count);
+	now = get_page_faults();
+
+	atomic64_set(&counter->hw.prev_count, now);
+
+	delta = now - prev;
+	if (WARN_ON_ONCE(delta < 0))
+		delta = 0;
+
+	atomic64_add(delta, &counter->count);
+}
+
+static void page_faults_perf_counter_read(struct perf_counter *counter)
+{
+	page_faults_perf_counter_update(counter);
+}
+
+static void page_faults_perf_counter_enable(struct perf_counter *counter)
+{
+	/*
+	 * page-faults is a per-task value already,
+	 * so we dont have to clear it on switch-in.
+	 */
+}
+
+static void page_faults_perf_counter_disable(struct perf_counter *counter)
+{
+	page_faults_perf_counter_update(counter);
+}
+
+static const struct hw_perf_counter_ops perf_ops_page_faults = {
+	.hw_perf_counter_enable		= page_faults_perf_counter_enable,
+	.hw_perf_counter_disable	= page_faults_perf_counter_disable,
+	.hw_perf_counter_read		= page_faults_perf_counter_read,
+};
+
+static u64 get_context_switches(void)
+{
+	struct task_struct *curr = current;
+
+	return curr->nvcsw + curr->nivcsw;
+}
+
+static void context_switches_perf_counter_update(struct perf_counter *counter)
+{
+	u64 prev, now;
+	s64 delta;
+
+	prev = atomic64_read(&counter->hw.prev_count);
+	now = get_context_switches();
+
+	atomic64_set(&counter->hw.prev_count, now);
+
+	delta = now - prev;
+	if (WARN_ON_ONCE(delta < 0))
+		delta = 0;
+
+	atomic64_add(delta, &counter->count);
+}
+
+static void context_switches_perf_counter_read(struct perf_counter *counter)
+{
+	context_switches_perf_counter_update(counter);
+}
+
+static void context_switches_perf_counter_enable(struct perf_counter *counter)
+{
+	/*
+	 * ->nvcsw + curr->nivcsw is a per-task value already,
+	 * so we dont have to clear it on switch-in.
+	 */
+}
+
+static void context_switches_perf_counter_disable(struct perf_counter *counter)
+{
+	context_switches_perf_counter_update(counter);
+}
+
+static const struct hw_perf_counter_ops perf_ops_context_switches = {
+	.hw_perf_counter_enable		= context_switches_perf_counter_enable,
+	.hw_perf_counter_disable	= context_switches_perf_counter_disable,
+	.hw_perf_counter_read		= context_switches_perf_counter_read,
+};
+
+static inline u64 get_cpu_migrations(void)
+{
+	return current->se.nr_migrations;
+}
+
+static void cpu_migrations_perf_counter_update(struct perf_counter *counter)
+{
+	u64 prev, now;
+	s64 delta;
+
+	prev = atomic64_read(&counter->hw.prev_count);
+	now = get_cpu_migrations();
+
+	atomic64_set(&counter->hw.prev_count, now);
+
+	delta = now - prev;
+	if (WARN_ON_ONCE(delta < 0))
+		delta = 0;
+
+	atomic64_add(delta, &counter->count);
+}
+
+static void cpu_migrations_perf_counter_read(struct perf_counter *counter)
+{
+	cpu_migrations_perf_counter_update(counter);
+}
+
+static void cpu_migrations_perf_counter_enable(struct perf_counter *counter)
+{
+	/*
+	 * se.nr_migrations is a per-task value already,
+	 * so we dont have to clear it on switch-in.
+	 */
+}
+
+static void cpu_migrations_perf_counter_disable(struct perf_counter *counter)
+{
+	cpu_migrations_perf_counter_update(counter);
+}
+
+static const struct hw_perf_counter_ops perf_ops_cpu_migrations = {
+	.hw_perf_counter_enable		= cpu_migrations_perf_counter_enable,
+	.hw_perf_counter_disable	= cpu_migrations_perf_counter_disable,
+	.hw_perf_counter_read		= cpu_migrations_perf_counter_read,
+};
+
+static const struct hw_perf_counter_ops *
+sw_perf_counter_init(struct perf_counter *counter)
+{
+	const struct hw_perf_counter_ops *hw_ops = NULL;
+
+	switch (counter->hw_event.type) {
+	case PERF_COUNT_CPU_CLOCK:
+		hw_ops = &perf_ops_cpu_clock;
+		break;
+	case PERF_COUNT_TASK_CLOCK:
+		hw_ops = &perf_ops_task_clock;
+		break;
+	case PERF_COUNT_PAGE_FAULTS:
+		hw_ops = &perf_ops_page_faults;
+		break;
+	case PERF_COUNT_CONTEXT_SWITCHES:
+		hw_ops = &perf_ops_context_switches;
+		break;
+	case PERF_COUNT_CPU_MIGRATIONS:
+		hw_ops = &perf_ops_cpu_migrations;
+		break;
+	default:
+		break;
+	}
+	return hw_ops;
+}
+
+/*
+ * Allocate and initialize a counter structure
+ */
+static struct perf_counter *
+perf_counter_alloc(struct perf_counter_hw_event *hw_event,
+		   int cpu,
+		   struct perf_counter *group_leader,
+		   gfp_t gfpflags)
+{
+	const struct hw_perf_counter_ops *hw_ops;
+	struct perf_counter *counter;
+
+	counter = kzalloc(sizeof(*counter), gfpflags);
+	if (!counter)
+		return NULL;
+
+	/*
+	 * Single counters are their own group leaders, with an
+	 * empty sibling list:
+	 */
+	if (!group_leader)
+		group_leader = counter;
+
+	mutex_init(&counter->mutex);
+	INIT_LIST_HEAD(&counter->list_entry);
+	INIT_LIST_HEAD(&counter->sibling_list);
+	init_waitqueue_head(&counter->waitq);
+
+	counter->irqdata		= &counter->data[0];
+	counter->usrdata		= &counter->data[1];
+	counter->cpu			= cpu;
+	counter->hw_event		= *hw_event;
+	counter->wakeup_pending		= 0;
+	counter->group_leader		= group_leader;
+	counter->hw_ops			= NULL;
+
+	hw_ops = NULL;
+	if (!hw_event->raw && hw_event->type < 0)
+		hw_ops = sw_perf_counter_init(counter);
+	if (!hw_ops)
+		hw_ops = hw_perf_counter_init(counter);
+
+	if (!hw_ops) {
+		kfree(counter);
+		return NULL;
+	}
+	counter->hw_ops = hw_ops;
+
+	return counter;
+}
+
+/**
+ * sys_perf_task_open - open a performance counter, associate it to a task/cpu
+ *
+ * @hw_event_uptr:	event type attributes for monitoring/sampling
+ * @pid:		target pid
+ * @cpu:		target cpu
+ * @group_fd:		group leader counter fd
+ */
+asmlinkage int
+sys_perf_counter_open(struct perf_counter_hw_event *hw_event_uptr __user,
+		      pid_t pid, int cpu, int group_fd)
+{
+	struct perf_counter *counter, *group_leader;
+	struct perf_counter_hw_event hw_event;
+	struct perf_counter_context *ctx;
+	struct file *counter_file = NULL;
+	struct file *group_file = NULL;
+	int fput_needed = 0;
+	int fput_needed2 = 0;
+	int ret;
+
+	if (copy_from_user(&hw_event, hw_event_uptr, sizeof(hw_event)) != 0)
+		return -EFAULT;
+
+	/*
+	 * Get the target context (task or percpu):
+	 */
+	ctx = find_get_context(pid, cpu);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	/*
+	 * Look up the group leader (we will attach this counter to it):
+	 */
+	group_leader = NULL;
+	if (group_fd != -1) {
+		ret = -EINVAL;
+		group_file = fget_light(group_fd, &fput_needed);
+		if (!group_file)
+			goto err_put_context;
+		if (group_file->f_op != &perf_fops)
+			goto err_put_context;
+
+		group_leader = group_file->private_data;
+		/*
+		 * Do not allow a recursive hierarchy (this new sibling
+		 * becoming part of another group-sibling):
+		 */
+		if (group_leader->group_leader != group_leader)
+			goto err_put_context;
+		/*
+		 * Do not allow to attach to a group in a different
+		 * task or CPU context:
+		 */
+		if (group_leader->ctx != ctx)
+			goto err_put_context;
+	}
+
+	ret = -EINVAL;
+	counter = perf_counter_alloc(&hw_event, cpu, group_leader, GFP_KERNEL);
+	if (!counter)
+		goto err_put_context;
+
+	ret = anon_inode_getfd("[perf_counter]", &perf_fops, counter, 0);
+	if (ret < 0)
+		goto err_free_put_context;
+
+	counter_file = fget_light(ret, &fput_needed2);
+	if (!counter_file)
+		goto err_free_put_context;
+
+	counter->filp = counter_file;
+	perf_install_in_context(ctx, counter, cpu);
+
+	fput_light(counter_file, fput_needed2);
+
+out_fput:
+	fput_light(group_file, fput_needed);
+
+	return ret;
+
+err_free_put_context:
+	kfree(counter);
+
+err_put_context:
+	put_context(ctx);
+
+	goto out_fput;
+}
+
+/*
+ * Initialize the perf_counter context in a task_struct:
+ */
+static void
+__perf_counter_init_context(struct perf_counter_context *ctx,
+			    struct task_struct *task)
+{
+	memset(ctx, 0, sizeof(*ctx));
+	spin_lock_init(&ctx->lock);
+	INIT_LIST_HEAD(&ctx->counter_list);
+	ctx->task = task;
+}
+
+/*
+ * inherit a counter from parent task to child task:
+ */
+static int
+inherit_counter(struct perf_counter *parent_counter,
+	      struct task_struct *parent,
+	      struct perf_counter_context *parent_ctx,
+	      struct task_struct *child,
+	      struct perf_counter_context *child_ctx)
+{
+	struct perf_counter *child_counter;
+
+	child_counter = perf_counter_alloc(&parent_counter->hw_event,
+					    parent_counter->cpu, NULL,
+					    GFP_ATOMIC);
+	if (!child_counter)
+		return -ENOMEM;
+
+	/*
+	 * Link it up in the child's context:
+	 */
+	child_counter->ctx = child_ctx;
+	child_counter->task = child;
+	list_add_counter(child_counter, child_ctx);
+	child_ctx->nr_counters++;
+
+	child_counter->parent = parent_counter;
+	parent_counter->nr_inherited++;
+	/*
+	 * inherit into child's child as well:
+	 */
+	child_counter->hw_event.inherit = 1;
+
+	/*
+	 * Get a reference to the parent filp - we will fput it
+	 * when the child counter exits. This is safe to do because
+	 * we are in the parent and we know that the filp still
+	 * exists and has a nonzero count:
+	 */
+	atomic_long_inc(&parent_counter->filp->f_count);
+
+	return 0;
+}
+
+static void
+__perf_counter_exit_task(struct task_struct *child,
+			 struct perf_counter *child_counter,
+			 struct perf_counter_context *child_ctx)
+{
+	struct perf_counter *parent_counter;
+	u64 parent_val, child_val;
+	u64 perf_flags;
+
+	/*
+	 * Disable and unlink this counter.
+	 *
+	 * Be careful about zapping the list - IRQ/NMI context
+	 * could still be processing it:
+	 */
+	local_irq_disable();
+	perf_flags = hw_perf_save_disable();
+
+	if (child_counter->state == PERF_COUNTER_STATE_ACTIVE)
+		child_counter->hw_ops->hw_perf_counter_disable(child_counter);
+	list_del_init(&child_counter->list_entry);
+
+	hw_perf_restore(perf_flags);
+	local_irq_enable();
+
+	parent_counter = child_counter->parent;
+	/*
+	 * It can happen that parent exits first, and has counters
+	 * that are still around due to the child reference. These
+	 * counters need to be zapped - but otherwise linger.
+	 */
+	if (!parent_counter)
+		return;
+
+	parent_val = atomic64_read(&parent_counter->count);
+	child_val = atomic64_read(&child_counter->count);
+
+	/*
+	 * Add back the child's count to the parent's count:
+	 */
+	atomic64_add(child_val, &parent_counter->count);
+
+	fput(parent_counter->filp);
+
+	kfree(child_counter);
+}
+
+/*
+ * When a child task exist, feed back counter values to parent counters.
+ *
+ * Note: we are running in child context, but the PID is not hashed
+ * anymore so new counters will not be added.
+ */
+void perf_counter_exit_task(struct task_struct *child)
+{
+	struct perf_counter *child_counter, *tmp;
+	struct perf_counter_context *child_ctx;
+
+	child_ctx = &child->perf_counter_ctx;
+
+	if (likely(!child_ctx->nr_counters))
+		return;
+
+	list_for_each_entry_safe(child_counter, tmp, &child_ctx->counter_list,
+				 list_entry)
+		__perf_counter_exit_task(child, child_counter, child_ctx);
+}
+
+/*
+ * Initialize the perf_counter context in task_struct
+ */
+void perf_counter_init_task(struct task_struct *child)
+{
+	struct perf_counter_context *child_ctx, *parent_ctx;
+	struct perf_counter *counter, *parent_counter;
+	struct task_struct *parent = current;
+	unsigned long flags;
+
+	child_ctx  =  &child->perf_counter_ctx;
+	parent_ctx = &parent->perf_counter_ctx;
+
+	__perf_counter_init_context(child_ctx, child);
+
+	/*
+	 * This is executed from the parent task context, so inherit
+	 * counters that have been marked for cloning:
+	 */
+
+	if (likely(!parent_ctx->nr_counters))
+		return;
+
+	/*
+	 * Lock the parent list. No need to lock the child - not PID
+	 * hashed yet and not running, so nobody can access it.
+	 */
+	spin_lock_irqsave(&parent_ctx->lock, flags);
+
+	/*
+	 * We dont have to disable NMIs - we are only looking at
+	 * the list, not manipulating it:
+	 */
+	list_for_each_entry(counter, &parent_ctx->counter_list, list_entry) {
+		if (!counter->hw_event.inherit || counter->group_leader != counter)
+			continue;
+
+		/*
+		 * Instead of creating recursive hierarchies of counters,
+		 * we link inheritd counters back to the original parent,
+		 * which has a filp for sure, which we use as the reference
+		 * count:
+		 */
+		parent_counter = counter;
+		if (counter->parent)
+			parent_counter = counter->parent;
+
+		if (inherit_counter(parent_counter, parent,
+				  parent_ctx, child, child_ctx))
+			break;
+	}
+
+	spin_unlock_irqrestore(&parent_ctx->lock, flags);
+}
+
+static void __cpuinit perf_counter_init_cpu(int cpu)
+{
+	struct perf_cpu_context *cpuctx;
+
+	cpuctx = &per_cpu(perf_cpu_context, cpu);
+	__perf_counter_init_context(&cpuctx->ctx, NULL);
+
+	mutex_lock(&perf_resource_mutex);
+	cpuctx->max_pertask = perf_max_counters - perf_reserved_percpu;
+	mutex_unlock(&perf_resource_mutex);
+
+	hw_perf_counter_setup();
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+static void __perf_counter_exit_cpu(void *info)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter_context *ctx = &cpuctx->ctx;
+	struct perf_counter *counter, *tmp;
+
+	list_for_each_entry_safe(counter, tmp, &ctx->counter_list, list_entry)
+		__perf_counter_remove_from_context(counter);
+
+}
+static void perf_counter_exit_cpu(int cpu)
+{
+	smp_call_function_single(cpu, __perf_counter_exit_cpu, NULL, 1);
+}
+#else
+static inline void perf_counter_exit_cpu(int cpu) { }
+#endif
+
+static int __cpuinit
+perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (long)hcpu;
+
+	switch (action) {
+
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		perf_counter_init_cpu(cpu);
+		break;
+
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		perf_counter_exit_cpu(cpu);
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata perf_cpu_nb = {
+	.notifier_call		= perf_cpu_notify,
+};
+
+static int __init perf_counter_init(void)
+{
+	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_UP_PREPARE,
+			(void *)(long)smp_processor_id());
+	register_cpu_notifier(&perf_cpu_nb);
+
+	return 0;
+}
+early_initcall(perf_counter_init);
+
+static ssize_t perf_show_reserve_percpu(struct sysdev_class *class, char *buf)
+{
+	return sprintf(buf, "%d\n", perf_reserved_percpu);
+}
+
+static ssize_t
+perf_set_reserve_percpu(struct sysdev_class *class,
+			const char *buf,
+			size_t count)
+{
+	struct perf_cpu_context *cpuctx;
+	unsigned long val;
+	int err, cpu, mpt;
+
+	err = strict_strtoul(buf, 10, &val);
+	if (err)
+		return err;
+	if (val > perf_max_counters)
+		return -EINVAL;
+
+	mutex_lock(&perf_resource_mutex);
+	perf_reserved_percpu = val;
+	for_each_online_cpu(cpu) {
+		cpuctx = &per_cpu(perf_cpu_context, cpu);
+		spin_lock_irq(&cpuctx->ctx.lock);
+		mpt = min(perf_max_counters - cpuctx->ctx.nr_counters,
+			  perf_max_counters - perf_reserved_percpu);
+		cpuctx->max_pertask = mpt;
+		spin_unlock_irq(&cpuctx->ctx.lock);
+	}
+	mutex_unlock(&perf_resource_mutex);
+
+	return count;
+}
+
+static ssize_t perf_show_overcommit(struct sysdev_class *class, char *buf)
+{
+	return sprintf(buf, "%d\n", perf_overcommit);
+}
+
+static ssize_t
+perf_set_overcommit(struct sysdev_class *class, const char *buf, size_t count)
+{
+	unsigned long val;
+	int err;
+
+	err = strict_strtoul(buf, 10, &val);
+	if (err)
+		return err;
+	if (val > 1)
+		return -EINVAL;
+
+	mutex_lock(&perf_resource_mutex);
+	perf_overcommit = val;
+	mutex_unlock(&perf_resource_mutex);
+
+	return count;
+}
+
+static SYSDEV_CLASS_ATTR(
+				reserve_percpu,
+				0644,
+				perf_show_reserve_percpu,
+				perf_set_reserve_percpu
+			);
+
+static SYSDEV_CLASS_ATTR(
+				overcommit,
+				0644,
+				perf_show_overcommit,
+				perf_set_overcommit
+			);
+
+static struct attribute *perfclass_attrs[] = {
+	&attr_reserve_percpu.attr,
+	&attr_overcommit.attr,
+	NULL
+};
+
+static struct attribute_group perfclass_attr_group = {
+	.attrs			= perfclass_attrs,
+	.name			= "perf_counters",
+};
+
+static int __init perf_counter_sysfs_init(void)
+{
+	return sysfs_create_group(&cpu_sysdev_class.kset.kobj,
+				  &perfclass_attr_group);
+}
+device_initcall(perf_counter_sysfs_init);
+
diff --git a/kernel/sched.c b/kernel/sched.c
index e4bb1dd..382cfdb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1852,12 +1852,14 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 		p->se.sleep_start -= clock_offset;
 	if (p->se.block_start)
 		p->se.block_start -= clock_offset;
+#endif
 	if (old_cpu != new_cpu) {
-		schedstat_inc(p, se.nr_migrations);
+		p->se.nr_migrations++;
+#ifdef CONFIG_SCHEDSTATS
 		if (task_hot(p, old_rq->clock, NULL))
 			schedstat_inc(p, se.nr_forced2_migrations);
-	}
 #endif
+	}
 	p->se.vruntime -= old_cfsrq->min_vruntime -
 					 new_cfsrq->min_vruntime;
 
@@ -2212,6 +2214,27 @@ static int sched_balance_self(int cpu, int flag)
 
 #endif /* CONFIG_SMP */
 
+/**
+ * task_oncpu_function_call - call a function on the cpu on which a task runs
+ * @p:		the task to evaluate
+ * @func:	the function to be called
+ * @info:	the function call argument
+ *
+ * Calls the function @func when the task is currently running. This might
+ * be on the current CPU, which just calls the function directly
+ */
+void task_oncpu_function_call(struct task_struct *p,
+			      void (*func) (void *info), void *info)
+{
+	int cpu;
+
+	preempt_disable();
+	cpu = task_cpu(p);
+	if (task_curr(p))
+		smp_call_function_single(cpu, func, info, 1);
+	preempt_enable();
+}
+
 /***
  * try_to_wake_up - wake up a thread
  * @p: the to-be-woken-up thread
@@ -2354,6 +2377,7 @@ static void __sched_fork(struct task_struct *p)
 	p->se.exec_start		= 0;
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
+	p->se.nr_migrations		= 0;
 	p->se.last_wakeup		= 0;
 	p->se.avg_overlap		= 0;
 
@@ -2534,6 +2558,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
 	fire_sched_out_preempt_notifiers(prev, next);
+	perf_counter_task_sched_out(prev, cpu_of(rq));
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
 }
@@ -2574,6 +2599,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 */
 	prev_state = prev->state;
 	finish_arch_switch(prev);
+	perf_counter_task_sched_in(current, cpu_of(rq));
 	finish_lock_switch(rq, prev);
 #ifdef CONFIG_SMP
 	if (current->sched_class->post_schedule)
@@ -4296,6 +4322,7 @@ void scheduler_tick(void)
 	rq->idle_at_tick = idle_cpu(cpu);
 	trigger_load_balance(rq, cpu);
 #endif
+	perf_counter_task_tick(curr, cpu);
 }
 
 #if defined(CONFIG_PREEMPT) && (defined(CONFIG_DEBUG_PREEMPT) || \
diff --git a/kernel/sys.c b/kernel/sys.c
index 31deba8..0f66633 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -14,6 +14,7 @@
 #include <linux/prctl.h>
 #include <linux/highuid.h>
 #include <linux/fs.h>
+#include <linux/perf_counter.h>
 #include <linux/resource.h>
 #include <linux/kernel.h>
 #include <linux/kexec.h>
@@ -1716,6 +1717,12 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 		case PR_SET_TSC:
 			error = SET_TSC_CTL(arg2);
 			break;
+		case PR_TASK_PERF_COUNTERS_DISABLE:
+			error = perf_counter_task_disable();
+			break;
+		case PR_TASK_PERF_COUNTERS_ENABLE:
+			error = perf_counter_task_enable();
+			break;
 		case PR_GET_TIMERSLACK:
 			error = current->timer_slack_ns;
 			break;
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index e14a232..4be8bbc 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -174,3 +174,6 @@ cond_syscall(compat_sys_timerfd_settime);
 cond_syscall(compat_sys_timerfd_gettime);
 cond_syscall(sys_eventfd);
 cond_syscall(sys_eventfd2);
+
+/* performance counters: */
+cond_syscall(sys_perf_counter_open);


