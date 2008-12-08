Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbYLHBXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbYLHBXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 20:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYLHBW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 20:22:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33841 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbYLHBWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 20:22:50 -0500
Date: Mon, 8 Dec 2008 02:22:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>
Subject: [patch] Performance Counters for Linux, v2
Message-ID: <20081208012211.GA23106@elte.hu>
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


[ Performance counters are special hardware registers available on most 
  modern CPUs. These register count the number of certain types of hw 
  events: such as instructions executed, cachemisses suffered, or 
  branches mis-predicted, without slowing down the kernel or 
  applications. These registers can also trigger interrupts when a 
  threshold number of events have passed - and can thus be used to 
  profile the code that runs on that CPU. ]

This is version 2 of our Performance Counters subsystem implementation.

The biggest user-visible change in this release is a new user-space 
text-mode profiling utility that is based on this code: KernelTop.

KernelTop can be downloaded from:

  http://redhat.com/~mingo/perfcounters/kerneltop.c

It's a standalone .c file that needs no extra libraries - it only needs a 
CONFIG_PERF_COUNTERS=y kernel to run on.

This utility is intended for kernel developers - it's basically a dynamic 
kernel profiler that gets hardware counter events dispatched to it 
continuously, which it feeds into a histogram and outputs it 
periodically.

Here is a screenshot of it:

------------------------------------------------------------------------------
  KernelTop: 250880 irqs/sec  [NMI, 10000 cycles], (all, cpu: 0)
------------------------------------------------------------------------------

             events         RIP          kernel function
             ______   ________________   _______________

              17319 - ffffffff8106f8fa : audit_syscall_exit
              16300 - ffffffff81042ce2 : sys_rt_sigprocmask
              11031 - ffffffff8106fdc8 : audit_syscall_entry
              10880 - ffffffff8100bd8d : rff_trace
               9780 - ffffffff810a232f : kfree	[ehci_hcd]
               9707 - ffffffff81298cb7 : _spin_lock_irq	[ehci_hcd]
               7903 - ffffffff8106db17 : unroll_tree_refs
               7266 - ffffffff81138d10 : copy_user_generic_string
               5751 - ffffffff8100be45 : sysret_check
               4803 - ffffffff8100bea8 : sysret_signal
               4696 - ffffffff8100bdb0 : system_call
               4425 - ffffffff8100bdc0 : system_call_after_swapgs
               2855 - ffffffff810ae183 : path_put	[ext3]
               2773 - ffffffff8100bedb : auditsys
               1589 - ffffffff810b6864 : dput	[sunrpc]
               1253 - ffffffff8100be40 : ret_from_sys_call
                690 - ffffffff8105034c : current_kernel_time	[ext3]
                673 - ffffffff81042bd4 : sys_sigprocmask
                611 - ffffffff8100bf25 : sysret_audit

It will correctly profile core kernel, module space and vsyscall areas as 
well. It allows the use of the most common hw counters: cycles, 
instructions, branches, cachemisses, cache-references and branch-misses.

KernelTop does not have to be started/stopped - it will continously 
profile the system and updates the histogram as the workload changes. The 
histogram is not cumulative: old workload effects will time out 
gradually. For example if the system goes idle, then the profiler output 
will go down to near zero within 10-20 seconds. So there's no need to 
stop or restart profiling - it all updates automatically, as the workflow 
changes its characteristics.

KernelTop can also profile raw event IDs. For example, on a Core2 CPU, to 
profile the "Number of instruction length decoder stalls" (raw event 
0x0087) during a hackbench run, i did this:

  $ ./kerneltop -e -$(printf "%d\n" 0x00000087) -c 10000 -n 1

------------------------------------------------------------------------------
 KernelTop:     331 irqs/sec  [NMI, 10000 raw:0087],  (all, 2 CPUs)
------------------------------------------------------------------------------

             events         RIP          kernel function
             ______   ________________   _______________

               1016 - ffffffff802a611e : kmem_cache_alloc_node
                898 - ffffffff804ca381 : sock_wfree
                 64 - ffffffff80567306 : schedule
                 50 - ffffffff804cdb39 : skb_release_head_state
                 45 - ffffffff8053ed54 : unix_write_space
                 33 - ffffffff802a6a4d : __kmalloc_node
                 18 - ffffffff802a642c : cache_alloc_refill
                 13 - ffffffff804cdd50 : __alloc_skb
                  7 - ffffffff8053ec0a : unix_shutdown

[ The printf is done to pass in a negative event number as a parameter. ]

We also made a good number of internal changes as well to the subsystem:

There's a new "counter group record" facility that is a straightforward 
extension of the existing "irq record" notification type. This record 
type can be set on a 'master' counter, and if the master counter triggers 
an IRQ or an NMI, all the 'secondary' counters are read out atomically 
and are put into the counter-group record. The result can then be read() 
out by userspace via a single system call. (Based on extensive feedback 
from Paul Mackerras and David Miller, thanks guys!)

The other big change is the support of virtual task counters via counter 
scheduling: a task can specify more counters than there are on the CPU, 
the kernel will then schedule the counters periodically to spread out hw 
resources. So for example if a task starts 6 counters on a CPU that has 
only two hardware counters, it still gets this output:

 counter[0 cycles              ]:   5204680573 , delta:   1733680843 events
 counter[1 instructions        ]:   1364468045 , delta:    454818351 events
 counter[2 cache-refs          ]:        12732 , delta:         4399 events
 counter[3 cache-misses        ]:         1009 , delta:          336 events
 counter[4 branch-instructions ]:    125993304 , delta:     42006998 events
 counter[5 branch-misses       ]:         1946 , delta:          649 events

See this sample code at:

  http://redhat.com/~mingo/perfcounters/hello-loop.c

There's also now the ability to do NMI profiling: this works both for per 
CPU and per task counters. NMI counters are transparent and are enabled 
via the PERF_COUNTER_NMI bit in the "hardware event type" parameter of 
the sys_perf_counter_open() system call.

There's also more generic x86 support: all 4 generic PMCs of Nehalem / 
Core i7 are supported - i've run 4 instances of KernelTop and they used 
up four separate PMCs.

There's also perf counters debug output that can be triggered via sysrq, 
for diagnostic purposes.

	Ingo, Thomas

------------------->

The latest performance counters experimental git tree can be found at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters/core

--------------->
Ingo Molnar (2):
      performance counters: documentation
      performance counters: x86 support

Thomas Gleixner (1):
      performance counters: core code


 Documentation/perf-counters.txt                |  104 +++
 arch/x86/Kconfig                               |    1 +
 arch/x86/ia32/ia32entry.S                      |    3 +-
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
 arch/x86/kernel/cpu/perf_counter.c             |  571 ++++++++++++++
 arch/x86/kernel/entry_64.S                     |    6 +
 arch/x86/kernel/irq.c                          |    5 +
 arch/x86/kernel/irqinit_32.c                   |    3 +
 arch/x86/kernel/irqinit_64.c                   |    5 +
 arch/x86/kernel/signal_32.c                    |    8 +-
 arch/x86/kernel/signal_64.c                    |    5 +
 arch/x86/kernel/syscall_table_32.S             |    1 +
 drivers/char/sysrq.c                           |    2 +
 include/linux/perf_counter.h                   |  171 +++++
 include/linux/sched.h                          |    9 +
 include/linux/syscalls.h                       |    6 +
 init/Kconfig                                   |   29 +
 kernel/Makefile                                |    1 +
 kernel/fork.c                                  |    1 +
 kernel/perf_counter.c                          |  945 ++++++++++++++++++++++++
 kernel/sched.c                                 |   24 +
 kernel/sys_ni.c                                |    3 +
 33 files changed, 1954 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/perf-counters.txt
 create mode 100644 arch/x86/kernel/cpu/perf_counter.c
 create mode 100644 include/linux/perf_counter.h
 create mode 100644 kernel/perf_counter.c

diff --git a/Documentation/perf-counters.txt b/Documentation/perf-counters.txt
new file mode 100644
index 0000000..19033a0
--- /dev/null
+++ b/Documentation/perf-counters.txt
@@ -0,0 +1,104 @@
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
+hardware capabilities. It provides per task and per CPU counters, and
+it provides event capabilities on top of those.
+
+Performance counters are accessed via special file descriptors.
+There's one file descriptor per virtual counter used.
+
+The special file descriptor is opened via the perf_counter_open()
+system call:
+
+ int
+ perf_counter_open(u32 hw_event_type,
+                   u32 hw_event_period,
+                   u32 record_type,
+                   pid_t pid,
+                   int cpu);
+
+The syscall returns the new fd. The fd can be used via the normal
+VFS system calls: read() can be used to read the counter, fcntl()
+can be used to set the blocking mode, etc.
+
+Multiple counters can be kept open at a time, and the counters
+can be poll()ed.
+
+When creating a new counter fd, 'hw_event_type' is one of:
+
+ enum hw_event_types {
+	PERF_COUNT_CYCLES,
+	PERF_COUNT_INSTRUCTIONS,
+	PERF_COUNT_CACHE_REFERENCES,
+	PERF_COUNT_CACHE_MISSES,
+	PERF_COUNT_BRANCH_INSTRUCTIONS,
+	PERF_COUNT_BRANCH_MISSES,
+ };
+
+These are standardized types of events that work uniformly on all CPUs
+that implements Performance Counters support under Linux. If a CPU is
+not able to count branch-misses, then the system call will return
+-EINVAL.
+
+[ Note: more hw_event_types are supported as well, but they are CPU
+  specific and are enumerated via /sys on a per CPU basis. Raw hw event
+  types can be passed in as negative numbers. For example, to count
+  "External bus cycles while bus lock signal asserted" events on Intel
+  Core CPUs, pass in a -0x4064 event type value. ]
+
+The parameter 'hw_event_period' is the number of events before waking up
+a read() that is blocked on a counter fd. Zero value means a non-blocking
+counter.
+
+'record_type' is the type of data that a read() will provide for the
+counter, and it can be one of:
+
+  enum perf_record_type {
+	PERF_RECORD_SIMPLE,
+	PERF_RECORD_IRQ,
+  };
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
+Note: the combination of 'pid == -1' and 'cpu == -1' is not valid.
+
+A 'pid > 0' and 'cpu == -1' counter is a per task counter that counts
+events of that task and 'follows' that task to whatever CPU the task
+gets schedule to. Per task counters can be created by any user, for
+their own tasks.
+
+A 'pid == -1' and 'cpu == x' counter is a per CPU counter that counts
+all events on CPU-x. Per CPU counters need CAP_SYS_ADMIN privilege.
+
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ac22bb7..5a2d74a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -651,6 +651,7 @@ config X86_UP_IOAPIC
 config X86_LOCAL_APIC
 	def_bool y
 	depends on X86_64 || (X86_32 && (X86_UP_APIC || (SMP && !X86_VOYAGER) || X86_GENERICARCH))
+	select HAVE_PERF_COUNTERS
 
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
diff --git a/arch/x86/include/asm/hardirq_32.h b/arch/x86/include/asm/hardirq_32.h
index 5ca135e..b3e475d 100644
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
index b97aecb..c22900e 100644
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
index 16f9487..8ab8c18 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -31,6 +31,7 @@
 #include <linux/dmi.h>
 #include <linux/dmar.h>
 
+#include <asm/intel_arch_perfmon.h>
 #include <asm/atomic.h>
 #include <asm/smp.h>
 #include <asm/mtrr.h>
@@ -1147,6 +1148,7 @@ void __cpuinit setup_local_APIC(void)
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
index 0000000..82440cb
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -0,0 +1,571 @@
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
+	int			enable_all;
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
+ * Setup the hardware configuration for a given hw_event_type
+ */
+int hw_perf_counter_init(struct perf_counter *counter, s32 hw_event_type)
+{
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
+		if (hw_event_type & PERF_COUNT_NMI)
+			hwc->nmi = 1;
+	}
+
+	hwc->config_base = MSR_ARCH_PERFMON_EVENTSEL0;
+	hwc->counter_base = MSR_ARCH_PERFMON_PERFCTR0;
+
+	hwc->irq_period = counter->__irq_period;
+	/*
+	 * Intel PMCs cannot be accessed sanely above 32 bit width,
+	 * so we install an artificial 1<<31 period regardless of
+	 * the generic counter period:
+	 */
+	if (!hwc->irq_period)
+		hwc->irq_period = 0x7FFFFFFF;
+
+	hwc->next_count = -((s32) hwc->irq_period);
+
+	/*
+	 * Negative event types mean raw encoded event+umask values:
+	 */
+	if (hw_event_type < 0) {
+		counter->hw_event_type = -hw_event_type;
+		counter->hw_event_type &= ~PERF_COUNT_NMI;
+	} else {
+		hw_event_type &= ~PERF_COUNT_NMI;
+		if (hw_event_type >= max_intel_perfmon_events)
+			return -EINVAL;
+		/*
+		 * The generic map:
+		 */
+		counter->hw_event_type = intel_perfmon_event_map[hw_event_type];
+	}
+	hwc->config |= counter->hw_event_type;
+	counter->wakeup_pending = 0;
+
+	return 0;
+}
+
+static void __hw_perf_enable_all(void)
+{
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, perf_counter_mask, 0);
+}
+
+void hw_perf_enable_all(void)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+
+	cpuc->enable_all = 1;
+	__hw_perf_enable_all();
+}
+
+void hw_perf_disable_all(void)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+
+	cpuc->enable_all = 0;
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0, 0);
+}
+
+static DEFINE_PER_CPU(u64, prev_next_count[MAX_HW_COUNTERS]);
+
+static void __hw_perf_counter_enable(struct hw_perf_counter *hwc, int idx)
+{
+	per_cpu(prev_next_count[idx], smp_processor_id()) = hwc->next_count;
+
+	wrmsr(hwc->counter_base + idx, hwc->next_count, 0);
+	wrmsr(hwc->config_base + idx, hwc->config, 0);
+}
+
+void hw_perf_counter_enable(struct perf_counter *counter)
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
+	wrmsr(hwc->config_base + idx,
+	      hwc->config & ~ARCH_PERFMON_EVENTSEL0_ENABLE, 0);
+
+	cpuc->counters[idx] = counter;
+	counter->hw.config |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+	__hw_perf_counter_enable(hwc, idx);
+}
+
+#ifdef CONFIG_X86_64
+static inline void atomic64_counter_set(struct perf_counter *counter, u64 val)
+{
+	atomic64_set(&counter->count, val);
+}
+
+static inline u64 atomic64_counter_read(struct perf_counter *counter)
+{
+	return atomic64_read(&counter->count);
+}
+#else
+/*
+ * Todo: add proper atomic64_t support to 32-bit x86:
+ */
+static inline void atomic64_counter_set(struct perf_counter *counter, u64 val64)
+{
+	u32 *val32 = (void *)&val64;
+
+	atomic_set(counter->count32 + 0, *(val32 + 0));
+	atomic_set(counter->count32 + 1, *(val32 + 1));
+}
+
+static inline u64 atomic64_counter_read(struct perf_counter *counter)
+{
+	return atomic_read(counter->count32 + 0) |
+		(u64) atomic_read(counter->count32 + 1) << 32;
+}
+#endif
+
+static void __hw_perf_save_counter(struct perf_counter *counter,
+				   struct hw_perf_counter *hwc, int idx)
+{
+	s64 raw = -1;
+	s64 delta;
+	int err;
+
+	/*
+	 * Get the raw hw counter value:
+	 */
+	err = rdmsrl_safe(hwc->counter_base + idx, &raw);
+	WARN_ON_ONCE(err);
+
+	/*
+	 * Rebase it to zero (it started counting at -irq_period),
+	 * to see the delta since ->prev_count:
+	 */
+	delta = (s64)hwc->irq_period + (s64)(s32)raw;
+
+	atomic64_counter_set(counter, hwc->prev_count + delta);
+
+	/*
+	 * Adjust the ->prev_count offset - if we went beyond
+	 * irq_period of units, then we got an IRQ and the counter
+	 * was set back to -irq_period:
+	 */
+	while (delta >= (s64)hwc->irq_period) {
+		hwc->prev_count += hwc->irq_period;
+		delta -= (s64)hwc->irq_period;
+	}
+
+	/*
+	 * Calculate the next raw counter value we'll write into
+	 * the counter at the next sched-in time:
+	 */
+	delta -= (s64)hwc->irq_period;
+
+	hwc->next_count = (s32)delta;
+}
+
+void perf_counter_print_debug(void)
+{
+	u64 ctrl, status, overflow, pmc_ctrl, pmc_count, next_count;
+	int cpu, err, idx;
+
+	local_irq_disable();
+
+	cpu = smp_processor_id();
+
+	err = rdmsrl_safe(MSR_CORE_PERF_GLOBAL_CTRL, &ctrl);
+	WARN_ON_ONCE(err);
+
+	err = rdmsrl_safe(MSR_CORE_PERF_GLOBAL_STATUS, &status);
+	WARN_ON_ONCE(err);
+
+	err = rdmsrl_safe(MSR_CORE_PERF_GLOBAL_OVF_CTRL, &overflow);
+	WARN_ON_ONCE(err);
+
+	printk(KERN_INFO "\n");
+	printk(KERN_INFO "CPU#%d: ctrl:       %016llx\n", cpu, ctrl);
+	printk(KERN_INFO "CPU#%d: status:     %016llx\n", cpu, status);
+	printk(KERN_INFO "CPU#%d: overflow:   %016llx\n", cpu, overflow);
+
+	for (idx = 0; idx < nr_hw_counters; idx++) {
+		err = rdmsrl_safe(MSR_ARCH_PERFMON_EVENTSEL0 + idx, &pmc_ctrl);
+		WARN_ON_ONCE(err);
+
+		err = rdmsrl_safe(MSR_ARCH_PERFMON_PERFCTR0 + idx, &pmc_count);
+		WARN_ON_ONCE(err);
+
+		next_count = per_cpu(prev_next_count[idx], cpu);
+
+		printk(KERN_INFO "CPU#%d: PMC%d ctrl:  %016llx\n",
+			cpu, idx, pmc_ctrl);
+		printk(KERN_INFO "CPU#%d: PMC%d count: %016llx\n",
+			cpu, idx, pmc_count);
+		printk(KERN_INFO "CPU#%d: PMC%d next:  %016llx\n",
+			cpu, idx, next_count);
+	}
+	local_irq_enable();
+}
+
+void hw_perf_counter_disable(struct perf_counter *counter)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	struct hw_perf_counter *hwc = &counter->hw;
+	unsigned int idx = hwc->idx;
+
+	counter->hw.config &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+	wrmsr(hwc->config_base + idx, hwc->config, 0);
+
+	clear_bit(idx, cpuc->used);
+	cpuc->counters[idx] = NULL;
+	__hw_perf_save_counter(counter, hwc, idx);
+}
+
+void hw_perf_counter_read(struct perf_counter *counter)
+{
+	struct hw_perf_counter *hwc = &counter->hw;
+	unsigned long addr = hwc->counter_base + hwc->idx;
+	s64 offs, val = -1LL;
+	s32 val32;
+	int err;
+
+	/* Careful: NMI might modify the counter offset */
+	do {
+		offs = hwc->prev_count;
+		err = rdmsrl_safe(addr, &val);
+		WARN_ON_ONCE(err);
+	} while (offs != hwc->prev_count);
+
+	val32 = (s32) val;
+	val =  (s64)hwc->irq_period + (s64)val32;
+	atomic64_counter_set(counter, hwc->prev_count + val);
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
+static void perf_save_and_restart(struct perf_counter *counter)
+{
+	struct hw_perf_counter *hwc = &counter->hw;
+	int idx = hwc->idx;
+
+	wrmsr(hwc->config_base + idx,
+	      hwc->config & ~ARCH_PERFMON_EVENTSEL0_ENABLE, 0);
+
+	if (hwc->config & ARCH_PERFMON_EVENTSEL0_ENABLE) {
+		__hw_perf_save_counter(counter, hwc, idx);
+		__hw_perf_counter_enable(hwc, idx);
+	}
+}
+
+static void
+perf_handle_group(struct perf_counter *leader, u64 *status, u64 *overflown)
+{
+	struct perf_counter_context *ctx = leader->ctx;
+	struct perf_counter *counter;
+	int bit;
+
+	list_for_each_entry(counter, &ctx->counters, list) {
+		if (counter->record_type != PERF_RECORD_SIMPLE ||
+		    counter == leader)
+			continue;
+
+		if (counter->active) {
+			/*
+			 * When counter was not in the overflow mask, we have to
+			 * read it from hardware. We read it as well, when it
+			 * has not been read yet and clear the bit in the
+			 * status mask.
+			 */
+			bit = counter->hw.idx;
+			if (!test_bit(bit, (unsigned long *) overflown) ||
+			    test_bit(bit, (unsigned long *) status)) {
+				clear_bit(bit, (unsigned long *) status);
+				perf_save_and_restart(counter);
+			}
+		}
+		perf_store_irq_data(leader, counter->hw_event_type);
+		perf_store_irq_data(leader, atomic64_counter_read(counter));
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
+	struct cpu_hw_counters *cpuc;
+	u64 ack, status;
+
+	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
+	if (!status) {
+		ack_APIC_irq();
+		return;
+	}
+
+	/* Disable counters globally */
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0, 0);
+	ack_APIC_irq();
+
+	cpuc = &per_cpu(cpu_hw_counters, cpu);
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
+		switch (counter->record_type) {
+		case PERF_RECORD_SIMPLE:
+			continue;
+		case PERF_RECORD_IRQ:
+			perf_store_irq_data(counter, instruction_pointer(regs));
+			break;
+		case PERF_RECORD_GROUP:
+			perf_store_irq_data(counter, counter->hw_event_type);
+			perf_store_irq_data(counter,
+					    atomic64_counter_read(counter));
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
+
+	/*
+	 * Do not reenable when global enable is off:
+	 */
+	if (cpuc->enable_all)
+		__hw_perf_enable_all();
+}
+
+void smp_perf_counter_interrupt(struct pt_regs *regs)
+{
+	irq_enter();
+#ifdef CONFIG_X86_64
+	add_pda(apic_perf_irqs, 1);
+#else
+	per_cpu(irq_stat, smp_processor_id()).apic_perf_irqs++;
+#endif
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
+	perf_counters_lapic_init(0);
+	register_die_notifier(&perf_counter_nmi_notifier);
+
+	perf_counters_initialized = true;
+}
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b86f332..ad70f59 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -869,6 +869,12 @@ END(error_interrupt)
 ENTRY(spurious_interrupt)
 	apicinterrupt SPURIOUS_APIC_VECTOR,smp_spurious_interrupt
 END(spurious_interrupt)
+
+#ifdef CONFIG_PERF_COUNTERS
+ENTRY(perf_counter_interrupt)
+	apicinterrupt LOCAL_PERF_VECTOR,smp_perf_counter_interrupt
+END(perf_counter_interrupt)
+#endif
 				
 /*
  * Exception entry points.
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
index 845aa98..de2bb7c 100644
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
index ff02353..eb04dd9 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -204,6 +204,11 @@ static void __init apic_intr_init(void)
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
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index d6dd057..6d39c27 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -6,7 +6,9 @@
  */
 #include <linux/list.h>
 
+#include <linux/perf_counter.h>
 #include <linux/personality.h>
+#include <linux/tracehook.h>
 #include <linux/binfmts.h>
 #include <linux/suspend.h>
 #include <linux/kernel.h>
@@ -17,7 +19,6 @@
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
-#include <linux/tracehook.h>
 #include <linux/elf.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
@@ -694,6 +695,11 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
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
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index a5c9627..066a13f 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -7,6 +7,7 @@
  *  2000-2002   x86-64 support by Andi Kleen
  */
 
+#include <linux/perf_counter.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
@@ -493,6 +494,10 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
 	}
+	if (thread_info_flags & _TIF_PERF_COUNTERS) {
+		clear_thread_flag(TIF_PERF_COUNTERS);
+		perf_counter_notify(regs);
+	}
 
 #ifdef CONFIG_X86_32
 	clear_thread_flag(TIF_IRET);
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index d44395f..496726d 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -332,3 +332,4 @@ ENTRY(sys_call_table)
 	.long sys_dup3			/* 330 */
 	.long sys_pipe2
 	.long sys_inotify_init1
+	.long sys_perf_counter_open
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
index 0000000..22c4469
--- /dev/null
+++ b/include/linux/perf_counter.h
@@ -0,0 +1,171 @@
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
+ * Generalized hardware event types, used by the hw_event_type parameter
+ * of the sys_perf_counter_open() syscall:
+ */
+enum hw_event_types {
+	PERF_COUNT_CYCLES,
+	PERF_COUNT_INSTRUCTIONS,
+	PERF_COUNT_CACHE_REFERENCES,
+	PERF_COUNT_CACHE_MISSES,
+	PERF_COUNT_BRANCH_INSTRUCTIONS,
+	PERF_COUNT_BRANCH_MISSES,
+	/*
+	 * If this bit is set in the type, then trigger NMI sampling:
+	 */
+	PERF_COUNT_NMI			= (1 << 30),
+};
+
+/*
+ * IRQ-notification data record type:
+ */
+enum perf_record_type {
+	PERF_RECORD_SIMPLE,
+	PERF_RECORD_IRQ,
+	PERF_RECORD_GROUP,
+};
+
+/**
+ * struct hw_perf_counter - performance counter hardware details
+ */
+struct hw_perf_counter {
+	u64			config;
+	unsigned long		config_base;
+	unsigned long		counter_base;
+	int			nmi;
+	unsigned int		idx;
+	u64			prev_count;
+	s32			next_count;
+	u64			irq_period;
+};
+
+/*
+ * Hardcoded buffer length limit for now, for IRQ-fed events:
+ */
+#define PERF_DATA_BUFLEN	2048
+
+/**
+ * struct perf_data - performance counter IRQ data sampling ...
+ */
+struct perf_data {
+	int			len;
+	int			rd_idx;
+	int			overrun;
+	u8			data[PERF_DATA_BUFLEN];
+};
+
+/**
+ * struct perf_counter - performance counter kernel representation:
+ */
+struct perf_counter {
+	struct list_head		list;
+	int				active;
+#if BITS_PER_LONG == 64
+	atomic64_t			count;
+#else
+	atomic_t			count32[2];
+#endif
+	u64				__irq_period;
+
+	struct hw_perf_counter		hw;
+
+	struct perf_counter_context	*ctx;
+	struct task_struct		*task;
+
+	/*
+	 * Protect attach/detach:
+	 */
+	struct mutex			mutex;
+
+	int				oncpu;
+	int				cpu;
+
+	s32				hw_event_type;
+	enum perf_record_type		record_type;
+
+	/* read() / irq related data */
+	wait_queue_head_t		waitq;
+	/* optional: for NMIs */
+	int				wakeup_pending;
+	struct perf_data		*irqdata;
+	struct perf_data		*usrdata;
+	struct perf_data		data[2];
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
+	struct list_head	counters;
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
+extern void perf_counter_task_sched_in(struct task_struct *task, int cpu);
+extern void perf_counter_task_sched_out(struct task_struct *task, int cpu);
+extern void perf_counter_task_tick(struct task_struct *task, int cpu);
+extern void perf_counter_init_task(struct task_struct *task);
+extern void perf_counter_notify(struct pt_regs *regs);
+extern void perf_counter_print_debug(void);
+#else
+static inline void
+perf_counter_task_sched_in(struct task_struct *task, int cpu)		{ }
+static inline void
+perf_counter_task_sched_out(struct task_struct *task, int cpu)		{ }
+static inline void
+perf_counter_task_tick(struct task_struct *task, int cpu)		{ }
+static inline void perf_counter_init_task(struct task_struct *task)	{ }
+static inline void perf_counter_notify(struct pt_regs *regs)		{ }
+static inline void perf_counter_print_debug(void)			{ }
+#endif
+
+#endif /* _LINUX_PERF_COUNTER_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 55e30d1..4c53027 100644
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
@@ -1326,6 +1327,7 @@ struct task_struct {
 	struct list_head pi_state_list;
 	struct futex_pi_state *pi_state_cache;
 #endif
+	struct perf_counter_context perf_counter_ctx;
 #ifdef CONFIG_NUMA
 	struct mempolicy *mempolicy;
 	short il_next;
@@ -2285,6 +2287,13 @@ static inline void inc_syscw(struct task_struct *tsk)
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
index 04fb47b..6cce728 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -624,4 +624,10 @@ asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
+asmlinkage int
+sys_perf_counter_open(u32 hw_event_type,
+		      u32 hw_event_period,
+		      u32 record_type,
+		      pid_t pid,
+		      int cpu);
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index f763762..78bede2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -732,6 +732,35 @@ config AIO
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
diff --git a/kernel/fork.c b/kernel/fork.c
index 2a372a0..441fadf 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -975,6 +975,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto fork_out;
 
 	rt_mutex_init_task(p);
+	perf_counter_init_task(p);
 
 #ifdef CONFIG_PROVE_LOCKING
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
new file mode 100644
index 0000000..f84b400
--- /dev/null
+++ b/kernel/perf_counter.c
@@ -0,0 +1,945 @@
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
+int perf_max_counters __read_mostly;
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
+
+int __weak hw_perf_counter_init(struct perf_counter *counter, u32 hw_event_type)
+{
+	return -EINVAL;
+}
+
+void __weak hw_perf_counter_enable(struct perf_counter *counter)	 { }
+void __weak hw_perf_counter_disable(struct perf_counter *counter)	 { }
+void __weak hw_perf_counter_read(struct perf_counter *counter)		 { }
+void __weak hw_perf_disable_all(void) { }
+void __weak hw_perf_enable_all(void) { }
+void __weak hw_perf_counter_setup(void) { }
+
+#if BITS_PER_LONG == 64
+
+/*
+ * Read the cached counter in counter safe against cross CPU / NMI
+ * modifications. 64 bit version - no complications.
+ */
+static inline u64 perf_read_counter_safe(struct perf_counter *counter)
+{
+	return (u64) atomic64_read(&counter->count);
+}
+
+#else
+
+/*
+ * Read the cached counter in counter safe against cross CPU / NMI
+ * modifications. 32 bit version.
+ */
+static u64 perf_read_counter_safe(struct perf_counter *counter)
+{
+	u32 cntl, cnth;
+
+	local_irq_disable();
+	do {
+		cnth = atomic_read(&counter->count32[1]);
+		cntl = atomic_read(&counter->count32[0]);
+	} while (cnth != atomic_read(&counter->count32[1]));
+
+	local_irq_enable();
+
+	return cntl | ((u64) cnth) << 32;
+}
+
+#endif
+
+/*
+ * Cross CPU call to remove a performance counter
+ *
+ * We disable the counter on the hardware level first. After that we
+ * remove it from the context list.
+ */
+static void __perf_remove_from_context(void *info)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter *counter = info;
+	struct perf_counter_context *ctx = counter->ctx;
+
+	/*
+	 * If this is a task context, we need to check whether it is
+	 * the current task context of this cpu. If not it has been
+	 * scheduled out before the smp call arrived.
+	 */
+	if (ctx->task && cpuctx->task_ctx != ctx)
+		return;
+
+	spin_lock(&ctx->lock);
+
+	if (counter->active) {
+		hw_perf_counter_disable(counter);
+		counter->active = 0;
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
+	hw_perf_disable_all();
+	list_del_init(&counter->list);
+	hw_perf_enable_all();
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
+	spin_unlock(&ctx->lock);
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
+static void perf_remove_from_context(struct perf_counter *counter)
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
+					 __perf_remove_from_context,
+					 counter, 1);
+		return;
+	}
+
+retry:
+	task_oncpu_function_call(task, __perf_remove_from_context,
+				 counter);
+
+	spin_lock_irq(&ctx->lock);
+	/*
+	 * If the context is active we need to retry the smp call.
+	 */
+	if (ctx->nr_active && !list_empty(&counter->list)) {
+		spin_unlock_irq(&ctx->lock);
+		goto retry;
+	}
+
+	/*
+	 * The lock prevents that this context is scheduled in so we
+	 * can remove the counter safely, if it the call above did not
+	 * succeed.
+	 */
+	if (!list_empty(&counter->list)) {
+		ctx->nr_counters--;
+		list_del_init(&counter->list);
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
+
+	/*
+	 * If this is a task context, we need to check whether it is
+	 * the current task context of this cpu. If not it has been
+	 * scheduled out before the smp call arrived.
+	 */
+	if (ctx->task && cpuctx->task_ctx != ctx)
+		return;
+
+	spin_lock(&ctx->lock);
+
+	/*
+	 * Protect the list operation against NMI by disabling the
+	 * counters on a global level. NOP for non NMI based counters.
+	 */
+	hw_perf_disable_all();
+	list_add_tail(&counter->list, &ctx->counters);
+	hw_perf_enable_all();
+
+	ctx->nr_counters++;
+
+	if (cpuctx->active_oncpu < perf_max_counters) {
+		hw_perf_counter_enable(counter);
+		counter->active = 1;
+		counter->oncpu = cpu;
+		ctx->nr_active++;
+		cpuctx->active_oncpu++;
+	}
+
+	if (!ctx->task && cpuctx->max_pertask)
+		cpuctx->max_pertask--;
+
+	spin_unlock(&ctx->lock);
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
+	 * If the context is active and the counter has not been added
+	 * we need to retry the smp call.
+	 */
+	if (ctx->nr_active && list_empty(&counter->list)) {
+		spin_unlock_irq(&ctx->lock);
+		goto retry;
+	}
+
+	/*
+	 * The lock prevents that this context is scheduled in so we
+	 * can add the counter safely, if it the call above did not
+	 * succeed.
+	 */
+	if (list_empty(&counter->list)) {
+		list_add_tail(&counter->list, &ctx->counters);
+		ctx->nr_counters++;
+	}
+	spin_unlock_irq(&ctx->lock);
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
+	list_for_each_entry(counter, &ctx->counters, list) {
+		if (!ctx->nr_active)
+			break;
+		if (counter->active) {
+			hw_perf_counter_disable(counter);
+			counter->active = 0;
+			counter->oncpu = -1;
+			ctx->nr_active--;
+			cpuctx->active_oncpu--;
+		}
+	}
+	spin_unlock(&ctx->lock);
+	cpuctx->task_ctx = NULL;
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
+	list_for_each_entry(counter, &ctx->counters, list) {
+		if (ctx->nr_active == cpuctx->max_pertask)
+			break;
+		if (counter->cpu != -1 && counter->cpu != cpu)
+			continue;
+
+		hw_perf_counter_enable(counter);
+		counter->active = 1;
+		counter->oncpu = cpu;
+		ctx->nr_active++;
+		cpuctx->active_oncpu++;
+	}
+	spin_unlock(&ctx->lock);
+	cpuctx->task_ctx = ctx;
+}
+
+void perf_counter_task_tick(struct task_struct *curr, int cpu)
+{
+	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	struct perf_counter *counter;
+
+	if (likely(!ctx->nr_counters))
+		return;
+
+	perf_counter_task_sched_out(curr, cpu);
+
+	spin_lock(&ctx->lock);
+
+	/*
+	 * Rotate the first entry last:
+	 */
+	hw_perf_disable_all();
+	list_for_each_entry(counter, &ctx->counters, list) {
+		list_del(&counter->list);
+		list_add_tail(&counter->list, &ctx->counters);
+		break;
+	}
+	hw_perf_enable_all();
+
+	spin_unlock(&ctx->lock);
+
+	perf_counter_task_sched_in(curr, cpu);
+}
+
+/*
+ * Initialize the perf_counter context in task_struct
+ */
+void perf_counter_init_task(struct task_struct *task)
+{
+	struct perf_counter_context *ctx = &task->perf_counter_ctx;
+
+	spin_lock_init(&ctx->lock);
+	INIT_LIST_HEAD(&ctx->counters);
+	ctx->nr_counters = 0;
+	ctx->task = task;
+}
+
+/*
+ * Cross CPU call to read the hardware counter
+ */
+static void __hw_perf_counter_read(void *info)
+{
+	hw_perf_counter_read(info);
+}
+
+static u64 perf_read_counter(struct perf_counter *counter)
+{
+	/*
+	 * If counter is enabled and currently active on a CPU, update the
+	 * value in the counter structure:
+	 */
+	if (counter->active) {
+		smp_call_function_single(counter->oncpu,
+					 __hw_perf_counter_read, counter, 1);
+	}
+
+	return perf_read_counter_safe(counter);
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
+	if (!counter->active) {
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
+	if (ctx->task) {
+		put_task_struct(ctx->task);
+		ctx->task = NULL;
+	}
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
+		WARN_ON_ONCE(ctx->task);
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
+	perf_remove_from_context(counter);
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
+	cntval = perf_read_counter(counter);
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
+	switch (counter->record_type) {
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
+/*
+ * Allocate and initialize a counter structure
+ */
+static struct perf_counter *
+perf_counter_alloc(u32 hw_event_period, int cpu, u32 record_type)
+{
+	struct perf_counter *counter = kzalloc(sizeof(*counter), GFP_KERNEL);
+
+	if (!counter)
+		return NULL;
+
+	mutex_init(&counter->mutex);
+	INIT_LIST_HEAD(&counter->list);
+	init_waitqueue_head(&counter->waitq);
+
+	counter->irqdata	= &counter->data[0];
+	counter->usrdata	= &counter->data[1];
+	counter->cpu		= cpu;
+	counter->record_type	= record_type;
+	counter->__irq_period	= hw_event_period;
+	counter->wakeup_pending = 0;
+
+	return counter;
+}
+
+/**
+ * sys_perf_task_open - open a performance counter associate it to a task
+ * @hw_event_type:	event type for monitoring/sampling...
+ * @pid:		target pid
+ */
+asmlinkage int
+sys_perf_counter_open(u32 hw_event_type,
+		      u32 hw_event_period,
+		      u32 record_type,
+		      pid_t pid,
+		      int cpu)
+{
+	struct perf_counter_context *ctx;
+	struct perf_counter *counter;
+	int ret;
+
+	ctx = find_get_context(pid, cpu);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	ret = -ENOMEM;
+	counter = perf_counter_alloc(hw_event_period, cpu, record_type);
+	if (!counter)
+		goto err_put_context;
+
+	ret = hw_perf_counter_init(counter, hw_event_type);
+	if (ret)
+		goto err_free_put_context;
+
+	perf_install_in_context(ctx, counter, cpu);
+
+	ret = anon_inode_getfd("[perf_counter]", &perf_fops, counter, 0);
+	if (ret < 0)
+		goto err_remove_free_put_context;
+
+	return ret;
+
+err_remove_free_put_context:
+	mutex_lock(&counter->mutex);
+	perf_remove_from_context(counter);
+	mutex_unlock(&counter->mutex);
+
+err_free_put_context:
+	kfree(counter);
+
+err_put_context:
+	put_context(ctx);
+
+	return ret;
+}
+
+static void __cpuinit perf_init_cpu(int cpu)
+{
+	struct perf_cpu_context *ctx;
+
+	ctx = &per_cpu(perf_cpu_context, cpu);
+	spin_lock_init(&ctx->ctx.lock);
+	INIT_LIST_HEAD(&ctx->ctx.counters);
+
+	mutex_lock(&perf_resource_mutex);
+	ctx->max_pertask = perf_max_counters - perf_reserved_percpu;
+	mutex_unlock(&perf_resource_mutex);
+	hw_perf_counter_setup();
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+static void __perf_exit_cpu(void *info)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter_context *ctx = &cpuctx->ctx;
+	struct perf_counter *counter, *tmp;
+
+	list_for_each_entry_safe(counter, tmp, &ctx->counters, list)
+		__perf_remove_from_context(counter);
+
+}
+static void perf_exit_cpu(int cpu)
+{
+	smp_call_function_single(cpu, __perf_exit_cpu, NULL, 1);
+}
+#else
+static inline void perf_exit_cpu(int cpu) { }
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
+		perf_init_cpu(cpu);
+		break;
+
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		perf_exit_cpu(cpu);
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
index b7480fb..254d56d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2212,6 +2212,27 @@ static int sched_balance_self(int cpu, int flag)
 
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
@@ -2534,6 +2555,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
 	fire_sched_out_preempt_notifiers(prev, next);
+	perf_counter_task_sched_out(prev, cpu_of(rq));
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
 }
@@ -2574,6 +2596,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 */
 	prev_state = prev->state;
 	finish_arch_switch(prev);
+	perf_counter_task_sched_in(current, cpu_of(rq));
 	finish_lock_switch(rq, prev);
 #ifdef CONFIG_SMP
 	if (current->sched_class->post_schedule)
@@ -4296,6 +4319,7 @@ void scheduler_tick(void)
 	rq->idle_at_tick = idle_cpu(cpu);
 	trigger_load_balance(rq, cpu);
 #endif
+	perf_counter_task_tick(curr, cpu);
 }
 
 #if defined(CONFIG_PREEMPT) && (defined(CONFIG_DEBUG_PREEMPT) || \
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
