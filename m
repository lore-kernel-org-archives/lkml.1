Return-Path: <linux-kernel-owner+w=401wt.eu-S1751563AbYLWMmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbYLWMmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 07:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbYLWMmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 07:42:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45530 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbYLWMlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 07:41:53 -0500
Date: Tue, 23 Dec 2008 13:40:58 +0100
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
       "David S. Miller" <davem@davemloft.net>
Subject: [patch] Performance Counters for Linux, v5
Message-ID: <20081223124058.GA11525@elte.hu>
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


We are pleased to announce version 5 of our performance counters subsystem 
implementation. The Git tree can be found at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters/core

It's also available in tip/master at:

   http://people.redhat.com/mingo/tip.git/README

The combo patch against .28-rc9 is also attached below.

There are a good deal of fundamental changes in this release:

 - Support for fixed-function performance counters on x86.
   This is done in the way we described it earlier: the new hw counters
   are utilized transparently by the kernel - user-space will only notice
   that it can enable up to 2+3 counters on Core2 and 4+3 counters
   on Corei7 at once, if the event IDs match the fixed-purpose counters.

   There's fixed-function counters available for: PERF_COUNT_INSTRUCTIONS,
   PERF_COUNT_CPU_CYCLES and PERF_COUNT_BUS_CYCLES - so using such
   counters wont waste generic event counters. For example, on Nehalem
   we can now count all the generic events at once, without round-robin
   scheduling of counters:

   $ ./timec -e 0,1,2,3,4,5,6 ./hackbench 20
   Time: 1.274

    Performance counter stats for '../hackbench':

      18751.819633  task clock ticks     (msecs)

       44331453557  CPU cycles           (events)
       35013178422  instructions         (events)
         121710024  cache references     (events)
          67371099  cache misses         (events)
       10869698427  branches             (events)
         725940130  branch misses        (events)
       44480332026  bus cycles           (events)

    Wall-clock time elapsed:  1497.000647 msecs

 - Reshaped, more precise counter inheritance support: the final
   counts are now 'pulled' instead of 'pushed' by the child task. This
   means that we propagate the 'truly final' counts of child tasks,
   counted up to the last instruction they spent on a CPU before they
   exit.

 - More accurate per task software-counters. There were bugs in the code
   that caused spurious zero readouts and similar noise - those problems
   are fixed now.

 - ( There's a handful of updates and fixes to other areas of the
     perfcounters code as well, see the Git history for more details.)

The user-space ABI has not changed in an incompatible way over -v4: the
extra bus cycles event type that has been added in a compatible way.

There are new timec.c and kerneltop.c versions available as well:

     http://redhat.com/~mingo/perfcounters/timec.c
     http://redhat.com/~mingo/perfcounters/kerneltop.c

Thanks,

	Ingo, Thomas

------------------>

The latest perfcounters/core git tree can be found at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters/core

------------------>
Alexander van Heukelum (12):
      x86: irq: fix apicinterrupts on 64 bits
      x86: entry_64.S: remove whitespace at end of lines
      x86: move entry_64.S register saving out of the macros
      x86: clean up after: move entry_64.S register saving out of the macros
      x86: introduce save_rest and restructure the PTREGSCALL macro in entry_64.S
      x86: entry_64.S: factor out save_paranoid and paranoid_exit
      x86: entry_64.S: split out some macro's and move common code to paranoid_exit
      x86: split out some macro's and move common code to paranoid_exit, fix
      x86: include ENTRY/END in entry handlers in entry_64.S
      x86: KPROBE_ENTRY should be paired wth KPROBE_END
      x86_64: get rid of the use of KPROBE_ENTRY / KPROBE_END
      i386: get rid of the use of KPROBE_ENTRY / KPROBE_END

Cyrill Gorcunov (5):
      x86: move dwarf2 related macro to dwarf2.h
      x86: introduce ENTRY(KPROBE_ENTRY)_X86 assembly helpers to catch unbalanced declaration v3
      x86: entry_64.S - use ENTRY to define child_rip
      x86: uv bau interrupt -- use proper interrupt number
      x86: entry_64.S - trivial: space, comments fixup

Dan McGee (1):
      x86: remove dead IRQBALANCE code

H. Peter Anvin (4):
      x86: 32 bit: interrupt stub consistency with 64 bit
      x86: 32 bits: shrink and align IRQ stubs
      x86: 64 bits: shrink and align IRQ stubs
      x86: fix up the new IRQ code for older versions of gas

Harvey Harrison (2):
      x86: use the new byteorder headers
      x86: x86_32 has its own irq_regs definition

Hiroshi Shimamoto (28):
      x86: signal: cosmetic unification of restore_sigcontext()
      x86: signal_64.c: get_stack() doesn't need entire regs
      x86: signal: cosmetic unification of signr_convert()
      x86: signal: cosmetic unification of macros for setup_rt_frame()
      x86: signal: cosmetic unification of NR_restart_syscall
      x86: signal_64: remove unused code in __setup_rt_frame()
      x86: signal_32: do save_i387_xstate() at get_sigframe()
      x86: ia32_signal: do save_i387_xstate_ia32 at get_sigframe()
      x86: signal_64: setup fpstate in setup_sigcontext()
      x86: signal_64: make setup_sigcontext() similar
      x86: signal: cosmetic unification of setup_sigcontext()
      x86: signal_32: introduce retcode and rt_retcode
      x86: ia32_signal: remove unnecessary padding
      x86: ia32_signal: cleanup macro COPY
      x86: ia32_signal: introduce COPY_SEG_CPL3
      x86: ia32_signal: cleanup macro RELOAD_SEG
      x86: ia32_signal: remove using temporary variable
      x86: ia32_signal: change order of storing in setup_sigcontext()
      x86: signal: rename COPY_SEG_STRICT to COPY_SEG_CPL3
      x86: signal: cosmetic unification of including headers
      x86: signal: cosmetic unification of sys_sigaltstack()
      x86: signal: cosmetic unification of sys_rt_sigreturn()
      x86: signal: move {setup|restore}_sigcontext()
      x86: signal: cosmetic unification of __setup_sigframe() and __setup_rt_sigframe()
      x86: signal: unify signal_{32|64}.c, prepare
      x86: signal: unify signal_{32|64}.c
      x86: signal: change type of paramter for sys_rt_sigreturn()
      x86: hardirq: introduce inc_irq_stat()

Ingo Molnar (53):
      x86 debug: mark early_printk.o as notrace
      x86: clean up rdtsc_barrier() use
      x86: clean up vget_cycles()
      x86: clean up after: move entry_64.S register saving out of the macros, fix
      x86: entry_64.S: rename
      x86: clean up stack overflow debug check
      x86: ret_from_fork - get rid of jump back
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
      perfcounters: release CPU context when exiting task counters
      perfcounters: flush on setuid exec
      perfcounters: use hw_event.disable flag
      perfcounters: remove warnings
      perfcounters: tweak group scheduling
      x86, perfcounters: rename intel_arch_perfmon.h => perf_counter.h
      x86, perfcounters: prepare for fixed-mode PMCs
      perfcounters: add fixed-mode PMC enumeration
      x86, perfcounters: refactor code for fixed-function PMCs
      perfcounters: hw ops rename
      perfcounters: fix task clock counter
      perfcounters: pull inherited counters
      perfcounters: fix init context lock
      perfcounters: enable lowlevel pmc code to schedule counters
      x86, perfcounters: print out the ->used bitmask
      perfcounters: remove ->nr_inherited
      perfcounters: generalize the counter scheduler
      perfcounters: add PERF_COUNT_BUS_CYCLES
      x86, perfcounters: add support for fixed-function pmcs

Jan Beulich (2):
      x86: simplify X86_MPPARSE config option
      x86: add two missing unwind annotations

Jaswinder Singh (1):
      x86: perf_counter.c intel_perfmon_event_map and max_intel_perfmon_events should be static

Mikael Pettersson (1):
      x86, signals: remove duplicated register setup code in ia32 signal delivery

Prarit Bhargava (1):
      x86: warn of incorrect cpu_khz on AMD systems

Thomas Gleixner (4):
      performance counters: core code
      perf counters: protect them against CSTATE transitions
      perf counters: clean up 'raw' type API
      perf counters: expand use of counter->event

Uros Bizjak (1):
      x86: Implement change_bit with immediate operand as "lock xorb"

Zhaolei (1):
      x86: avoid duplicate running of pud_offset and pmd_offset in one_md_table_init()

gorcunov@gmail.com (1):
      x86: entry_64.S - use X86_EFLAGS_IF instead of hardcoded number

jia zhang (2):
      x86_64: fix the check in stack_overflow_check
      x86, debug: remove the confusing entry in call trace


 Documentation/perf-counters.txt                |  147 ++
 arch/x86/Kconfig                               |   13 +-
 arch/x86/ia32/ia32_signal.c                    |   68 +-
 arch/x86/ia32/ia32entry.S                      |    3 +-
 arch/x86/include/asm/atomic_32.h               |  218 +++
 arch/x86/include/asm/bitops.h                  |   10 +-
 arch/x86/include/asm/byteorder.h               |   74 +-
 arch/x86/include/asm/dwarf2.h                  |   97 +-
 arch/x86/include/asm/hardirq_32.h              |    3 +
 arch/x86/include/asm/hardirq_64.h              |    2 +
 arch/x86/include/asm/hw_irq.h                  |    6 +-
 arch/x86/include/asm/intel_arch_perfmon.h      |   31 -
 arch/x86/include/asm/irq.h                     |    4 -
 arch/x86/include/asm/irq_regs_32.h             |    2 +
 arch/x86/include/asm/irq_vectors.h             |    5 +
 arch/x86/include/asm/linkage.h                 |   60 +
 arch/x86/include/asm/mach-default/entry_arch.h |    5 +
 arch/x86/include/asm/pda.h                     |    1 +
 arch/x86/include/asm/perf_counter.h            |   95 ++
 arch/x86/include/asm/syscalls.h                |    2 +-
 arch/x86/include/asm/thread_info.h             |    4 +-
 arch/x86/include/asm/tsc.h                     |    8 +-
 arch/x86/include/asm/unistd_32.h               |    1 +
 arch/x86/include/asm/unistd_64.h               |    3 +-
 arch/x86/kernel/Makefile                       |    3 +-
 arch/x86/kernel/apic.c                         |   15 +-
 arch/x86/kernel/cpu/Makefile                   |   12 +-
 arch/x86/kernel/cpu/common.c                   |    2 +
 arch/x86/kernel/cpu/perf_counter.c             |  705 ++++++++++
 arch/x86/kernel/cpu/perfctr-watchdog.c         |    2 +-
 arch/x86/kernel/entry_32.S                     |  477 ++++----
 arch/x86/kernel/entry_64.S                     | 1363 ++++++++++---------
 arch/x86/kernel/irq.c                          |    5 +
 arch/x86/kernel/irq_64.c                       |   24 +-
 arch/x86/kernel/irqinit_32.c                   |    5 +-
 arch/x86/kernel/irqinit_64.c                   |   71 +-
 arch/x86/kernel/{signal_32.c => signal.c}      |  574 ++++++---
 arch/x86/kernel/signal_64.c                    |  516 --------
 arch/x86/kernel/smp.c                          |   18 +-
 arch/x86/kernel/syscall_table_32.S             |    1 +
 arch/x86/kernel/time_64.c                      |    2 +
 arch/x86/kernel/traps.c                        |    6 +-
 arch/x86/kernel/vsyscall_64.c                  |    9 +
 arch/x86/lguest/boot.c                         |    3 +-
 arch/x86/mm/init_32.c                          |    2 +
 arch/x86/oprofile/op_model_ppro.c              |    2 +-
 drivers/acpi/processor_idle.c                  |    8 +
 drivers/char/sysrq.c                           |    2 +
 fs/exec.c                                      |    8 +
 include/linux/init_task.h                      |   11 +
 include/linux/kernel_stat.h                    |    8 +
 include/linux/linkage.h                        |    8 -
 include/linux/perf_counter.h                   |  254 ++++
 include/linux/prctl.h                          |    3 +
 include/linux/sched.h                          |   12 +-
 include/linux/syscalls.h                       |    8 +
 init/Kconfig                                   |   30 +
 kernel/Makefile                                |    1 +
 kernel/exit.c                                  |   13 +-
 kernel/fork.c                                  |    1 +
 kernel/perf_counter.c                          | 1686 ++++++++++++++++++++++++
 kernel/sched.c                                 |   76 +-
 kernel/sys.c                                   |    7 +
 kernel/sys_ni.c                                |    3 +
 64 files changed, 4943 insertions(+), 1875 deletions(-)
 create mode 100644 Documentation/perf-counters.txt
 delete mode 100644 arch/x86/include/asm/intel_arch_perfmon.h
 create mode 100644 arch/x86/include/asm/perf_counter.h
 create mode 100644 arch/x86/kernel/cpu/perf_counter.c
 rename arch/x86/kernel/{signal_32.c => signal.c} (74%)
 delete mode 100644 arch/x86/kernel/signal_64.c
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
index ac22bb7..fe94490 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -242,21 +242,13 @@ config X86_FIND_SMP_CONFIG
 	def_bool y
 	depends on X86_MPPARSE || X86_VOYAGER
 
-if ACPI
 config X86_MPPARSE
-	def_bool y
-	bool "Enable MPS table"
+	bool "Enable MPS table" if ACPI
+	default y
 	depends on X86_LOCAL_APIC
 	help
 	  For old smp systems that do not have proper acpi support. Newer systems
 	  (esp with 64bit cpus) with acpi support, MADT and DSDT will override it
-endif
-
-if !ACPI
-config X86_MPPARSE
-	def_bool y
-	depends on X86_LOCAL_APIC
-endif
 
 choice
 	prompt "Subarchitecture Type"
@@ -651,6 +643,7 @@ config X86_UP_IOAPIC
 config X86_LOCAL_APIC
 	def_bool y
 	depends on X86_64 || (X86_32 && (X86_UP_APIC || (SMP && !X86_VOYAGER) || X86_GENERICARCH))
+	select HAVE_PERF_COUNTERS if (!M386 && !M486)
 
 config X86_IO_APIC
 	def_bool y
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 4bc02b2..9ddf2fa 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -197,23 +197,28 @@ struct rt_sigframe
 	/* fp state follows here */
 };
 
-#define COPY(x)		{ 		\
-	unsigned int reg;		\
-	err |= __get_user(reg, &sc->x);	\
-	regs->x = reg;			\
+#define COPY(x)			{		\
+	err |= __get_user(regs->x, &sc->x);	\
 }
 
-#define RELOAD_SEG(seg,mask)						\
-	{ unsigned int cur;						\
-	  unsigned short pre;						\
-	  err |= __get_user(pre, &sc->seg);				\
-	  savesegment(seg, cur);					\
-	  pre |= mask;							\
-	  if (pre != cur) loadsegment(seg, pre); }
+#define COPY_SEG_CPL3(seg)	{			\
+		unsigned short tmp;			\
+		err |= __get_user(tmp, &sc->seg);	\
+		regs->seg = tmp | 3;			\
+}
+
+#define RELOAD_SEG(seg)		{		\
+	unsigned int cur, pre;			\
+	err |= __get_user(pre, &sc->seg);	\
+	savesegment(seg, cur);			\
+	pre |= 3;				\
+	if (pre != cur)				\
+		loadsegment(seg, pre);		\
+}
 
 static int ia32_restore_sigcontext(struct pt_regs *regs,
 				   struct sigcontext_ia32 __user *sc,
-				   unsigned int *peax)
+				   unsigned int *pax)
 {
 	unsigned int tmpflags, gs, oldgs, err = 0;
 	void __user *buf;
@@ -240,18 +245,16 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 	if (gs != oldgs)
 		load_gs_index(gs);
 
-	RELOAD_SEG(fs, 3);
-	RELOAD_SEG(ds, 3);
-	RELOAD_SEG(es, 3);
+	RELOAD_SEG(fs);
+	RELOAD_SEG(ds);
+	RELOAD_SEG(es);
 
 	COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
 	COPY(dx); COPY(cx); COPY(ip);
 	/* Don't touch extended registers */
 
-	err |= __get_user(regs->cs, &sc->cs);
-	regs->cs |= 3;
-	err |= __get_user(regs->ss, &sc->ss);
-	regs->ss |= 3;
+	COPY_SEG_CPL3(cs);
+	COPY_SEG_CPL3(ss);
 
 	err |= __get_user(tmpflags, &sc->flags);
 	regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
@@ -262,9 +265,7 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 	buf = compat_ptr(tmp);
 	err |= restore_i387_xstate_ia32(buf);
 
-	err |= __get_user(tmp, &sc->ax);
-	*peax = tmp;
-
+	err |= __get_user(*pax, &sc->ax);
 	return err;
 }
 
@@ -359,20 +360,15 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
 	err |= __put_user(regs->dx, &sc->dx);
 	err |= __put_user(regs->cx, &sc->cx);
 	err |= __put_user(regs->ax, &sc->ax);
-	err |= __put_user(regs->cs, &sc->cs);
-	err |= __put_user(regs->ss, &sc->ss);
 	err |= __put_user(current->thread.trap_no, &sc->trapno);
 	err |= __put_user(current->thread.error_code, &sc->err);
 	err |= __put_user(regs->ip, &sc->ip);
+	err |= __put_user(regs->cs, (unsigned int __user *)&sc->cs);
 	err |= __put_user(regs->flags, &sc->flags);
 	err |= __put_user(regs->sp, &sc->sp_at_signal);
+	err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);
 
-	tmp = save_i387_xstate_ia32(fpstate);
-	if (tmp < 0)
-		err = -EFAULT;
-	else
-		err |= __put_user(ptr_to_compat(tmp ? fpstate : NULL),
-					&sc->fpstate);
+	err |= __put_user(ptr_to_compat(fpstate), &sc->fpstate);
 
 	/* non-iBCS2 extensions.. */
 	err |= __put_user(mask, &sc->oldmask);
@@ -408,6 +404,8 @@ static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 	if (used_math()) {
 		sp = sp - sig_xstate_ia32_size;
 		*fpstate = (struct _fpstate_ia32 *) sp;
+		if (save_i387_xstate_ia32(*fpstate) < 0)
+			return (void __user *) -1L;
 	}
 
 	sp -= frame_size;
@@ -430,12 +428,10 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 		u16 poplmovl;
 		u32 val;
 		u16 int80;
-		u16 pad;
 	} __attribute__((packed)) code = {
 		0xb858,		 /* popl %eax ; movl $...,%eax */
 		__NR_ia32_sigreturn,
 		0x80cd,		/* int $0x80 */
-		0,
 	};
 
 	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
@@ -511,8 +507,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		u8 movl;
 		u32 val;
 		u16 int80;
-		u16 pad;
-		u8  pad2;
+		u8  pad;
 	} __attribute__((packed)) code = {
 		0xb8,
 		__NR_ia32_rt_sigreturn,
@@ -572,11 +567,6 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->dx = (unsigned long) &frame->info;
 	regs->cx = (unsigned long) &frame->uc;
 
-	/* Make -mregparm=3 work */
-	regs->ax = sig;
-	regs->dx = (unsigned long) &frame->info;
-	regs->cx = (unsigned long) &frame->uc;
-
 	loadsegment(ds, __USER32_DS);
 	loadsegment(es, __USER32_DS);
 
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
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 3600103..9fa9dcd 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -168,7 +168,15 @@ static inline void __change_bit(int nr, volatile unsigned long *addr)
  */
 static inline void change_bit(int nr, volatile unsigned long *addr)
 {
-	asm volatile(LOCK_PREFIX "btc %1,%0" : ADDR : "Ir" (nr));
+	if (IS_IMMEDIATE(nr)) {
+		asm volatile(LOCK_PREFIX "xorb %1,%0"
+			: CONST_MASK_ADDR(nr, addr)
+			: "iq" ((u8)CONST_MASK(nr)));
+	} else {
+		asm volatile(LOCK_PREFIX "btc %1,%0"
+			: BITOP_ADDR(addr)
+			: "Ir" (nr));
+	}
 }
 
 /**
diff --git a/arch/x86/include/asm/byteorder.h b/arch/x86/include/asm/byteorder.h
index e02ae2d..f110ad4 100644
--- a/arch/x86/include/asm/byteorder.h
+++ b/arch/x86/include/asm/byteorder.h
@@ -4,26 +4,33 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
 
-#ifdef __i386__
-
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
-#ifdef CONFIG_X86_BSWAP
-	asm("bswap %0" : "=r" (x) : "0" (x));
-#else
+#ifdef __i386__
+# ifdef CONFIG_X86_BSWAP
+	asm("bswap %0" : "=r" (val) : "0" (val));
+# else
 	asm("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
 	    "rorl $16,%0\n\t"	/* swap words		*/
 	    "xchgb %b0,%h0"	/* swap higher bytes	*/
-	    : "=q" (x)
-	    : "0" (x));
+	    : "=q" (val)
+	    : "0" (val));
+# endif
+
+#else /* __i386__ */
+	asm("bswapl %0"
+	    : "=r" (val)
+	    : "0" (val));
 #endif
-	return x;
+	return val;
 }
+#define __arch_swab32 __arch_swab32
 
-static inline __attribute_const__ __u64 ___arch__swab64(__u64 val)
+static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
 {
+#ifdef __i386__
 	union {
 		struct {
 			__u32 a;
@@ -32,50 +39,27 @@ static inline __attribute_const__ __u64 ___arch__swab64(__u64 val)
 		__u64 u;
 	} v;
 	v.u = val;
-#ifdef CONFIG_X86_BSWAP
+# ifdef CONFIG_X86_BSWAP
 	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
-#else
-	v.s.a = ___arch__swab32(v.s.a);
-	v.s.b = ___arch__swab32(v.s.b);
+# else
+	v.s.a = __arch_swab32(v.s.a);
+	v.s.b = __arch_swab32(v.s.b);
 	asm("xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
-#endif
+# endif
 	return v.u;
-}
-
 #else /* __i386__ */
-
-static inline __attribute_const__ __u64 ___arch__swab64(__u64 x)
-{
 	asm("bswapq %0"
-	    : "=r" (x)
-	    : "0" (x));
-	return x;
-}
-
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
-{
-	asm("bswapl %0"
-	    : "=r" (x)
-	    : "0" (x));
-	return x;
-}
-
+	    : "=r" (val)
+	    : "0" (val));
+	return val;
 #endif
+}
+#define __arch_swab64 __arch_swab64
 
-/* Do not define swab16.  Gcc is smart enough to recognize "C" version and
-   convert it into rotation or exhange.  */
-
-#define __arch__swab64(x) ___arch__swab64(x)
-#define __arch__swab32(x) ___arch__swab32(x)
-
-#define __BYTEORDER_HAS_U64__
-
-#endif /* __GNUC__ */
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _ASM_X86_BYTEORDER_H */
diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
index 804b6e6..3afc5e8 100644
--- a/arch/x86/include/asm/dwarf2.h
+++ b/arch/x86/include/asm/dwarf2.h
@@ -6,56 +6,91 @@
 #endif
 
 /*
-   Macros for dwarf2 CFI unwind table entries.
-   See "as.info" for details on these pseudo ops. Unfortunately
-   they are only supported in very new binutils, so define them
-   away for older version.
+ * Macros for dwarf2 CFI unwind table entries.
+ * See "as.info" for details on these pseudo ops. Unfortunately
+ * they are only supported in very new binutils, so define them
+ * away for older version.
  */
 
 #ifdef CONFIG_AS_CFI
 
-#define CFI_STARTPROC .cfi_startproc
-#define CFI_ENDPROC .cfi_endproc
-#define CFI_DEF_CFA .cfi_def_cfa
-#define CFI_DEF_CFA_REGISTER .cfi_def_cfa_register
-#define CFI_DEF_CFA_OFFSET .cfi_def_cfa_offset
-#define CFI_ADJUST_CFA_OFFSET .cfi_adjust_cfa_offset
-#define CFI_OFFSET .cfi_offset
-#define CFI_REL_OFFSET .cfi_rel_offset
-#define CFI_REGISTER .cfi_register
-#define CFI_RESTORE .cfi_restore
-#define CFI_REMEMBER_STATE .cfi_remember_state
-#define CFI_RESTORE_STATE .cfi_restore_state
-#define CFI_UNDEFINED .cfi_undefined
+#define CFI_STARTPROC		.cfi_startproc
+#define CFI_ENDPROC		.cfi_endproc
+#define CFI_DEF_CFA		.cfi_def_cfa
+#define CFI_DEF_CFA_REGISTER	.cfi_def_cfa_register
+#define CFI_DEF_CFA_OFFSET	.cfi_def_cfa_offset
+#define CFI_ADJUST_CFA_OFFSET	.cfi_adjust_cfa_offset
+#define CFI_OFFSET		.cfi_offset
+#define CFI_REL_OFFSET		.cfi_rel_offset
+#define CFI_REGISTER		.cfi_register
+#define CFI_RESTORE		.cfi_restore
+#define CFI_REMEMBER_STATE	.cfi_remember_state
+#define CFI_RESTORE_STATE	.cfi_restore_state
+#define CFI_UNDEFINED		.cfi_undefined
 
 #ifdef CONFIG_AS_CFI_SIGNAL_FRAME
-#define CFI_SIGNAL_FRAME .cfi_signal_frame
+#define CFI_SIGNAL_FRAME	.cfi_signal_frame
 #else
 #define CFI_SIGNAL_FRAME
 #endif
 
 #else
 
-/* Due to the structure of pre-exisiting code, don't use assembler line
-   comment character # to ignore the arguments. Instead, use a dummy macro. */
+/*
+ * Due to the structure of pre-exisiting code, don't use assembler line
+ * comment character # to ignore the arguments. Instead, use a dummy macro.
+ */
 .macro cfi_ignore a=0, b=0, c=0, d=0
 .endm
 
-#define CFI_STARTPROC	cfi_ignore
-#define CFI_ENDPROC	cfi_ignore
-#define CFI_DEF_CFA	cfi_ignore
+#define CFI_STARTPROC		cfi_ignore
+#define CFI_ENDPROC		cfi_ignore
+#define CFI_DEF_CFA		cfi_ignore
 #define CFI_DEF_CFA_REGISTER	cfi_ignore
 #define CFI_DEF_CFA_OFFSET	cfi_ignore
 #define CFI_ADJUST_CFA_OFFSET	cfi_ignore
-#define CFI_OFFSET	cfi_ignore
-#define CFI_REL_OFFSET	cfi_ignore
-#define CFI_REGISTER	cfi_ignore
-#define CFI_RESTORE	cfi_ignore
-#define CFI_REMEMBER_STATE cfi_ignore
-#define CFI_RESTORE_STATE cfi_ignore
-#define CFI_UNDEFINED cfi_ignore
-#define CFI_SIGNAL_FRAME cfi_ignore
+#define CFI_OFFSET		cfi_ignore
+#define CFI_REL_OFFSET		cfi_ignore
+#define CFI_REGISTER		cfi_ignore
+#define CFI_RESTORE		cfi_ignore
+#define CFI_REMEMBER_STATE	cfi_ignore
+#define CFI_RESTORE_STATE	cfi_ignore
+#define CFI_UNDEFINED		cfi_ignore
+#define CFI_SIGNAL_FRAME	cfi_ignore
 
 #endif
 
+/*
+ * An attempt to make CFI annotations more or less
+ * correct and shorter. It is implied that you know
+ * what you're doing if you use them.
+ */
+#ifdef __ASSEMBLY__
+#ifdef CONFIG_X86_64
+	.macro pushq_cfi reg
+	pushq \reg
+	CFI_ADJUST_CFA_OFFSET 8
+	.endm
+
+	.macro popq_cfi reg
+	popq \reg
+	CFI_ADJUST_CFA_OFFSET -8
+	.endm
+
+	.macro movq_cfi reg offset=0
+	movq %\reg, \offset(%rsp)
+	CFI_REL_OFFSET \reg, \offset
+	.endm
+
+	.macro movq_cfi_restore offset reg
+	movq \offset(%rsp), %\reg
+	CFI_RESTORE \reg
+	.endm
+#else /*!CONFIG_X86_64*/
+
+	/* 32bit defenitions are missed yet */
+
+#endif /*!CONFIG_X86_64*/
+#endif /*__ASSEMBLY__*/
+
 #endif /* _ASM_X86_DWARF2_H */
diff --git a/arch/x86/include/asm/hardirq_32.h b/arch/x86/include/asm/hardirq_32.h
index 5ca135e..7a07897 100644
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
@@ -22,6 +23,8 @@ DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
 #define __ARCH_IRQ_STAT
 #define __IRQ_STAT(cpu, member) (per_cpu(irq_stat, cpu).member)
 
+#define inc_irq_stat(member)	(__get_cpu_var(irq_stat).member++)
+
 void ack_bad_irq(unsigned int irq);
 #include <linux/irq_cpustat.h>
 
diff --git a/arch/x86/include/asm/hardirq_64.h b/arch/x86/include/asm/hardirq_64.h
index 1ba381f..b5a6b5d 100644
--- a/arch/x86/include/asm/hardirq_64.h
+++ b/arch/x86/include/asm/hardirq_64.h
@@ -11,6 +11,8 @@
 
 #define __ARCH_IRQ_STAT 1
 
+#define inc_irq_stat(member)	add_pda(member, 1)
+
 #define local_softirq_pending() read_pda(__softirq_pending)
 
 #define __ARCH_SET_SOFTIRQ_PENDING 1
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index b97aecb..aa93e53 100644
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
@@ -109,9 +111,7 @@ extern asmlinkage void smp_invalidate_interrupt(struct pt_regs *);
 #endif
 #endif
 
-#ifdef CONFIG_X86_32
-extern void (*const interrupt[NR_VECTORS])(void);
-#endif
+extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
 
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
diff --git a/arch/x86/include/asm/intel_arch_perfmon.h b/arch/x86/include/asm/intel_arch_perfmon.h
deleted file mode 100644
index fa0fd06..0000000
--- a/arch/x86/include/asm/intel_arch_perfmon.h
+++ /dev/null
@@ -1,31 +0,0 @@
-#ifndef _ASM_X86_INTEL_ARCH_PERFMON_H
-#define _ASM_X86_INTEL_ARCH_PERFMON_H
-
-#define MSR_ARCH_PERFMON_PERFCTR0		0xc1
-#define MSR_ARCH_PERFMON_PERFCTR1		0xc2
-
-#define MSR_ARCH_PERFMON_EVENTSEL0		0x186
-#define MSR_ARCH_PERFMON_EVENTSEL1		0x187
-
-#define ARCH_PERFMON_EVENTSEL0_ENABLE	(1 << 22)
-#define ARCH_PERFMON_EVENTSEL_INT	(1 << 20)
-#define ARCH_PERFMON_EVENTSEL_OS	(1 << 17)
-#define ARCH_PERFMON_EVENTSEL_USR	(1 << 16)
-
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL	(0x3c)
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK	(0x00 << 8)
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX (0)
-#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT \
-	(1 << (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX))
-
-union cpuid10_eax {
-	struct {
-		unsigned int version_id:8;
-		unsigned int num_counters:8;
-		unsigned int bit_width:8;
-		unsigned int mask_length:8;
-	} split;
-	unsigned int full;
-};
-
-#endif /* _ASM_X86_INTEL_ARCH_PERFMON_H */
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index bae0eda..28e409f 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -31,10 +31,6 @@ static inline int irq_canonicalize(int irq)
 # endif
 #endif
 
-#ifdef CONFIG_IRQBALANCE
-extern int irqbalance_disable(char *str);
-#endif
-
 #ifdef CONFIG_HOTPLUG_CPU
 #include <linux/cpumask.h>
 extern void fixup_irqs(cpumask_t map);
diff --git a/arch/x86/include/asm/irq_regs_32.h b/arch/x86/include/asm/irq_regs_32.h
index af2f02d..86afd74 100644
--- a/arch/x86/include/asm/irq_regs_32.h
+++ b/arch/x86/include/asm/irq_regs_32.h
@@ -9,6 +9,8 @@
 
 #include <asm/percpu.h>
 
+#define ARCH_HAS_OWN_IRQ_REGS
+
 DECLARE_PER_CPU(struct pt_regs *, irq_regs);
 
 static inline struct pt_regs *get_irq_regs(void)
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
diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index f61ee8f..5d98d0b 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -57,5 +57,65 @@
 #define __ALIGN_STR ".align 16,0x90"
 #endif
 
+/*
+ * to check ENTRY_X86/END_X86 and
+ * KPROBE_ENTRY_X86/KPROBE_END_X86
+ * unbalanced-missed-mixed appearance
+ */
+#define __set_entry_x86		.set ENTRY_X86_IN, 0
+#define __unset_entry_x86	.set ENTRY_X86_IN, 1
+#define __set_kprobe_x86	.set KPROBE_X86_IN, 0
+#define __unset_kprobe_x86	.set KPROBE_X86_IN, 1
+
+#define __macro_err_x86 .error "ENTRY_X86/KPROBE_X86 unbalanced,missed,mixed"
+
+#define __check_entry_x86	\
+	.ifdef ENTRY_X86_IN;	\
+	.ifeq ENTRY_X86_IN;	\
+	__macro_err_x86;	\
+	.abort;			\
+	.endif;			\
+	.endif
+
+#define __check_kprobe_x86	\
+	.ifdef KPROBE_X86_IN;	\
+	.ifeq KPROBE_X86_IN;	\
+	__macro_err_x86;	\
+	.abort;			\
+	.endif;			\
+	.endif
+
+#define __check_entry_kprobe_x86	\
+	__check_entry_x86;		\
+	__check_kprobe_x86
+
+#define ENTRY_KPROBE_FINAL_X86 __check_entry_kprobe_x86
+
+#define ENTRY_X86(name)			\
+	__check_entry_kprobe_x86;	\
+	__set_entry_x86;		\
+	.globl name;			\
+	__ALIGN;			\
+	name:
+
+#define END_X86(name)			\
+	__unset_entry_x86;		\
+	__check_entry_kprobe_x86;	\
+	.size name, .-name
+
+#define KPROBE_ENTRY_X86(name)		\
+	__check_entry_kprobe_x86;	\
+	__set_kprobe_x86;		\
+	.pushsection .kprobes.text, "ax"; \
+	.globl name;			\
+	__ALIGN;			\
+	name:
+
+#define KPROBE_END_X86(name)		\
+	__unset_kprobe_x86;		\
+	__check_entry_kprobe_x86;	\
+	.size name, .-name;		\
+	.popsection
+
 #endif /* _ASM_X86_LINKAGE_H */
 
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
diff --git a/arch/x86/include/asm/perf_counter.h b/arch/x86/include/asm/perf_counter.h
new file mode 100644
index 0000000..2e08ed7
--- /dev/null
+++ b/arch/x86/include/asm/perf_counter.h
@@ -0,0 +1,95 @@
+#ifndef _ASM_X86_PERF_COUNTER_H
+#define _ASM_X86_PERF_COUNTER_H
+
+/*
+ * Performance counter hw details:
+ */
+
+#define X86_PMC_MAX_GENERIC					8
+#define X86_PMC_MAX_FIXED					3
+
+#define X86_PMC_IDX_GENERIC				        0
+#define X86_PMC_IDX_FIXED				       32
+#define X86_PMC_IDX_MAX					       64
+
+#define MSR_ARCH_PERFMON_PERFCTR0			      0xc1
+#define MSR_ARCH_PERFMON_PERFCTR1			      0xc2
+
+#define MSR_ARCH_PERFMON_EVENTSEL0			     0x186
+#define MSR_ARCH_PERFMON_EVENTSEL1			     0x187
+
+#define ARCH_PERFMON_EVENTSEL0_ENABLE			  (1 << 22)
+#define ARCH_PERFMON_EVENTSEL_INT			  (1 << 20)
+#define ARCH_PERFMON_EVENTSEL_OS			  (1 << 17)
+#define ARCH_PERFMON_EVENTSEL_USR			  (1 << 16)
+
+/*
+ * Includes eventsel and unit mask as well:
+ */
+#define ARCH_PERFMON_EVENT_MASK				    0xffff
+
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		      0x3c
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX 		 0
+#define ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT \
+		(1 << (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX))
+
+#define ARCH_PERFMON_BRANCH_MISSES_RETIRED			 6
+
+/*
+ * Intel "Architectural Performance Monitoring" CPUID
+ * detection/enumeration details:
+ */
+union cpuid10_eax {
+	struct {
+		unsigned int version_id:8;
+		unsigned int num_counters:8;
+		unsigned int bit_width:8;
+		unsigned int mask_length:8;
+	} split;
+	unsigned int full;
+};
+
+union cpuid10_edx {
+	struct {
+		unsigned int num_counters_fixed:4;
+		unsigned int reserved:28;
+	} split;
+	unsigned int full;
+};
+
+
+/*
+ * Fixed-purpose performance counters:
+ */
+
+/*
+ * All 3 fixed-mode PMCs are configured via this single MSR:
+ */
+#define MSR_ARCH_PERFMON_FIXED_CTR_CTRL			0x38d
+
+/*
+ * The counts are available in three separate MSRs:
+ */
+
+/* Instr_Retired.Any: */
+#define MSR_ARCH_PERFMON_FIXED_CTR0			0x309
+#define X86_PMC_IDX_FIXED_INSTRUCTIONS			(X86_PMC_IDX_FIXED + 0)
+
+/* CPU_CLK_Unhalted.Core: */
+#define MSR_ARCH_PERFMON_FIXED_CTR1			0x30a
+#define X86_PMC_IDX_FIXED_CPU_CYCLES			(X86_PMC_IDX_FIXED + 1)
+
+/* CPU_CLK_Unhalted.Ref: */
+#define MSR_ARCH_PERFMON_FIXED_CTR2			0x30b
+#define X86_PMC_IDX_FIXED_BUS_CYCLES			(X86_PMC_IDX_FIXED + 2)
+
+#ifdef CONFIG_PERF_COUNTERS
+extern void init_hw_perf_counters(void);
+extern void perf_counters_lapic_init(int nmi);
+#else
+static inline void init_hw_perf_counters(void)		{ }
+static inline void perf_counters_lapic_init(int nmi)	{ }
+#endif
+
+#endif /* _ASM_X86_PERF_COUNTER_H */
diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 87803da..3a5252c 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -33,7 +33,7 @@ asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
 			     struct old_sigaction __user *);
 asmlinkage int sys_sigaltstack(unsigned long);
 asmlinkage unsigned long sys_sigreturn(unsigned long);
-asmlinkage int sys_rt_sigreturn(unsigned long);
+asmlinkage int sys_rt_sigreturn(struct pt_regs);
 
 /* kernel/ioport.c */
 asmlinkage long sys_iopl(unsigned long);
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
diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 9cd83a8..38ae163 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -34,8 +34,6 @@ static inline cycles_t get_cycles(void)
 
 static __always_inline cycles_t vget_cycles(void)
 {
-	cycles_t cycles;
-
 	/*
 	 * We only do VDSOs on TSC capable CPUs, so this shouldnt
 	 * access boot_cpu_data (which is not VDSO-safe):
@@ -44,11 +42,7 @@ static __always_inline cycles_t vget_cycles(void)
 	if (!cpu_has_tsc)
 		return 0;
 #endif
-	rdtsc_barrier();
-	cycles = (cycles_t)__native_read_tsc();
-	rdtsc_barrier();
-
-	return cycles;
+	return (cycles_t)__native_read_tsc();
 }
 
 extern void tsc_init(void);
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
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index b62a766..3d4346a 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -12,6 +12,7 @@ CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
+CFLAGS_REMOVE_early_printk.o = -pg
 endif
 
 #
@@ -23,7 +24,7 @@ CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0 $(nostackp)
 CFLAGS_hpet.o		:= $(nostackp)
 CFLAGS_tsc.o		:= $(nostackp)
 
-obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
+obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time_$(BITS).o ioport.o ldt.o
 obj-y			+= setup.o i8259.o irqinit_$(BITS).o setup_percpu.o
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 16f9487..4f859ac 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -31,6 +31,7 @@
 #include <linux/dmi.h>
 #include <linux/dmar.h>
 
+#include <asm/perf_counter.h>
 #include <asm/atomic.h>
 #include <asm/smp.h>
 #include <asm/mtrr.h>
@@ -783,11 +784,7 @@ static void local_apic_timer_interrupt(void)
 	/*
 	 * the NMI deadlock-detector uses this.
 	 */
-#ifdef CONFIG_X86_64
-	add_pda(apic_timer_irqs, 1);
-#else
-	per_cpu(irq_stat, cpu).apic_timer_irqs++;
-#endif
+	inc_irq_stat(apic_timer_irqs);
 
 	evt->event_handler(evt);
 }
@@ -1147,6 +1144,7 @@ void __cpuinit setup_local_APIC(void)
 		apic_write(APIC_ESR, 0);
 	}
 #endif
+	perf_counters_lapic_init(0);
 
 	preempt_disable();
 
@@ -1695,14 +1693,11 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
 		ack_APIC_irq();
 
-#ifdef CONFIG_X86_64
-	add_pda(irq_spurious_count, 1);
-#else
+	inc_irq_stat(irq_spurious_count);
+
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
 	printk(KERN_INFO "spurious APIC interrupt on CPU#%d, "
 	       "should never happen.\n", smp_processor_id());
-	__get_cpu_var(irq_stat).irq_spurious_count++;
-#endif
 	irq_exit();
 }
 
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
index b9c9ea0..ad331b4 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -17,6 +17,7 @@
 #include <asm/mmu_context.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
+#include <asm/perf_counter.h>
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
index 0000000..da46eca
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -0,0 +1,705 @@
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
+#include <asm/perf_counter.h>
+#include <asm/apic.h>
+
+static bool perf_counters_initialized __read_mostly;
+
+/*
+ * Number of (generic) HW counters:
+ */
+static int nr_counters_generic __read_mostly;
+static u64 perf_counter_mask __read_mostly;
+static u64 counter_value_mask __read_mostly;
+
+static int nr_counters_fixed __read_mostly;
+
+struct cpu_hw_counters {
+	struct perf_counter	*counters[X86_PMC_IDX_MAX];
+	unsigned long		used[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+};
+
+/*
+ * Intel PerfMon v3. Used on Core2 and later.
+ */
+static DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters);
+
+static const int intel_perfmon_event_map[] =
+{
+  [PERF_COUNT_CPU_CYCLES]		= 0x003c,
+  [PERF_COUNT_INSTRUCTIONS]		= 0x00c0,
+  [PERF_COUNT_CACHE_REFERENCES]		= 0x4f2e,
+  [PERF_COUNT_CACHE_MISSES]		= 0x412e,
+  [PERF_COUNT_BRANCH_INSTRUCTIONS]	= 0x00c4,
+  [PERF_COUNT_BRANCH_MISSES]		= 0x00c5,
+  [PERF_COUNT_BUS_CYCLES]		= 0x013c,
+};
+
+static const int max_intel_perfmon_events = ARRAY_SIZE(intel_perfmon_event_map);
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
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, perf_counter_mask);
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
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
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
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
+}
+EXPORT_SYMBOL_GPL(hw_perf_restore);
+
+static inline void
+__pmc_fixed_disable(struct perf_counter *counter,
+		    struct hw_perf_counter *hwc, unsigned int __idx)
+{
+	int idx = __idx - X86_PMC_IDX_FIXED;
+	u64 ctrl_val, mask;
+	int err;
+
+	mask = 0xfULL << (idx * 4);
+
+	rdmsrl(hwc->config_base, ctrl_val);
+	ctrl_val &= ~mask;
+	err = checking_wrmsrl(hwc->config_base, ctrl_val);
+}
+
+static inline void
+__pmc_generic_disable(struct perf_counter *counter,
+			   struct hw_perf_counter *hwc, unsigned int idx)
+{
+	int err;
+
+	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL))
+		return __pmc_fixed_disable(counter, hwc, idx);
+
+	err = wrmsr_safe(hwc->config_base + idx, hwc->config, 0);
+}
+
+static DEFINE_PER_CPU(u64, prev_left[X86_PMC_IDX_MAX]);
+
+/*
+ * Set the next IRQ period, based on the hwc->period_left value.
+ * To be called with the counter disabled in hw:
+ */
+static void
+__hw_perf_counter_set_period(struct perf_counter *counter,
+			     struct hw_perf_counter *hwc, int idx)
+{
+	s64 left = atomic64_read(&hwc->period_left);
+	s32 period = hwc->irq_period;
+	int err;
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
+	per_cpu(prev_left[idx], smp_processor_id()) = left;
+
+	/*
+	 * The hw counter starts counting from this counter offset,
+	 * mark it to be able to extra future deltas:
+	 */
+	atomic64_set(&hwc->prev_count, (u64)-left);
+
+	err = checking_wrmsrl(hwc->counter_base + idx,
+			     (u64)(-left) & counter_value_mask);
+}
+
+static inline void
+__pmc_fixed_enable(struct perf_counter *counter,
+		   struct hw_perf_counter *hwc, unsigned int __idx)
+{
+	int idx = __idx - X86_PMC_IDX_FIXED;
+	u64 ctrl_val, bits, mask;
+	int err;
+
+	/*
+	 * Enable IRQ generation (0x8) and ring-3 counting (0x2),
+	 * and enable ring-0 counting if allowed:
+	 */
+	bits = 0x8ULL | 0x2ULL;
+	if (hwc->config & ARCH_PERFMON_EVENTSEL_OS)
+		bits |= 0x1;
+	bits <<= (idx * 4);
+	mask = 0xfULL << (idx * 4);
+
+	rdmsrl(hwc->config_base, ctrl_val);
+	ctrl_val &= ~mask;
+	ctrl_val |= bits;
+	err = checking_wrmsrl(hwc->config_base, ctrl_val);
+}
+
+static void
+__pmc_generic_enable(struct perf_counter *counter,
+			  struct hw_perf_counter *hwc, int idx)
+{
+	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL))
+		return __pmc_fixed_enable(counter, hwc, idx);
+
+	wrmsr(hwc->config_base + idx,
+	      hwc->config | ARCH_PERFMON_EVENTSEL0_ENABLE, 0);
+}
+
+static int
+fixed_mode_idx(struct perf_counter *counter, struct hw_perf_counter *hwc)
+{
+	unsigned int event;
+
+	if (unlikely(hwc->nmi))
+		return -1;
+
+	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
+
+	if (unlikely(event == intel_perfmon_event_map[PERF_COUNT_INSTRUCTIONS]))
+		return X86_PMC_IDX_FIXED_INSTRUCTIONS;
+	if (unlikely(event == intel_perfmon_event_map[PERF_COUNT_CPU_CYCLES]))
+		return X86_PMC_IDX_FIXED_CPU_CYCLES;
+	if (unlikely(event == intel_perfmon_event_map[PERF_COUNT_BUS_CYCLES]))
+		return X86_PMC_IDX_FIXED_BUS_CYCLES;
+
+	return -1;
+}
+
+/*
+ * Find a PMC slot for the freshly enabled / scheduled in counter:
+ */
+static int pmc_generic_enable(struct perf_counter *counter)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	struct hw_perf_counter *hwc = &counter->hw;
+	int idx;
+
+	idx = fixed_mode_idx(counter, hwc);
+	if (idx >= 0) {
+		/*
+		 * Try to get the fixed counter, if that is already taken
+		 * then try to get a generic counter:
+		 */
+		if (test_and_set_bit(idx, cpuc->used))
+			goto try_generic;
+
+		hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
+		/*
+		 * We set it so that counter_base + idx in wrmsr/rdmsr maps to
+		 * MSR_ARCH_PERFMON_FIXED_CTR0 ... CTR2:
+		 */
+		hwc->counter_base =
+			MSR_ARCH_PERFMON_FIXED_CTR0 - X86_PMC_IDX_FIXED;
+		hwc->idx = idx;
+	} else {
+		idx = hwc->idx;
+		/* Try to get the previous generic counter again */
+		if (test_and_set_bit(idx, cpuc->used)) {
+try_generic:
+			idx = find_first_zero_bit(cpuc->used, nr_counters_generic);
+			if (idx == nr_counters_generic)
+				return -EAGAIN;
+
+			set_bit(idx, cpuc->used);
+			hwc->idx = idx;
+		}
+		hwc->config_base  = MSR_ARCH_PERFMON_EVENTSEL0;
+		hwc->counter_base = MSR_ARCH_PERFMON_PERFCTR0;
+	}
+
+	perf_counters_lapic_init(hwc->nmi);
+
+	__pmc_generic_disable(counter, hwc, idx);
+
+	cpuc->counters[idx] = counter;
+	/*
+	 * Make it visible before enabling the hw:
+	 */
+	smp_wmb();
+
+	__hw_perf_counter_set_period(counter, hwc, idx);
+	__pmc_generic_enable(counter, hwc, idx);
+
+	return 0;
+}
+
+void perf_counter_print_debug(void)
+{
+	u64 ctrl, status, overflow, pmc_ctrl, pmc_count, prev_left, fixed;
+	struct cpu_hw_counters *cpuc;
+	int cpu, idx;
+
+	if (!nr_counters_generic)
+		return;
+
+	local_irq_disable();
+
+	cpu = smp_processor_id();
+	cpuc = &per_cpu(cpu_hw_counters, cpu);
+
+	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
+	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
+	rdmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, overflow);
+	rdmsrl(MSR_ARCH_PERFMON_FIXED_CTR_CTRL, fixed);
+
+	printk(KERN_INFO "\n");
+	printk(KERN_INFO "CPU#%d: ctrl:       %016llx\n", cpu, ctrl);
+	printk(KERN_INFO "CPU#%d: status:     %016llx\n", cpu, status);
+	printk(KERN_INFO "CPU#%d: overflow:   %016llx\n", cpu, overflow);
+	printk(KERN_INFO "CPU#%d: fixed:      %016llx\n", cpu, fixed);
+	printk(KERN_INFO "CPU#%d: used:       %016llx\n", cpu, *(u64 *)cpuc->used);
+
+	for (idx = 0; idx < nr_counters_generic; idx++) {
+		rdmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + idx, pmc_ctrl);
+		rdmsrl(MSR_ARCH_PERFMON_PERFCTR0  + idx, pmc_count);
+
+		prev_left = per_cpu(prev_left[idx], cpu);
+
+		printk(KERN_INFO "CPU#%d:   gen-PMC%d ctrl:  %016llx\n",
+			cpu, idx, pmc_ctrl);
+		printk(KERN_INFO "CPU#%d:   gen-PMC%d count: %016llx\n",
+			cpu, idx, pmc_count);
+		printk(KERN_INFO "CPU#%d:   gen-PMC%d left:  %016llx\n",
+			cpu, idx, prev_left);
+	}
+	for (idx = 0; idx < nr_counters_fixed; idx++) {
+		rdmsrl(MSR_ARCH_PERFMON_FIXED_CTR0 + idx, pmc_count);
+
+		printk(KERN_INFO "CPU#%d: fixed-PMC%d count: %016llx\n",
+			cpu, idx, pmc_count);
+	}
+	local_irq_enable();
+}
+
+static void pmc_generic_disable(struct perf_counter *counter)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	struct hw_perf_counter *hwc = &counter->hw;
+	unsigned int idx = hwc->idx;
+
+	__pmc_generic_disable(counter, hwc, idx);
+
+	clear_bit(idx, cpuc->used);
+	cpuc->counters[idx] = NULL;
+	/*
+	 * Make sure the cleared pointer becomes visible before we
+	 * (potentially) free the counter:
+	 */
+	smp_wmb();
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
+
+	x86_perf_counter_update(counter, hwc, idx);
+	__hw_perf_counter_set_period(counter, hwc, idx);
+
+	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
+		__pmc_generic_enable(counter, hwc, idx);
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
+
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
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
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
+	for_each_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
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
+		 * do a task wakeup - but we mark these generic as
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
+	wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, ack);
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
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, saved_global);
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
+	for_each_bit(bit, cpuc->used, X86_PMC_IDX_MAX) {
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
+	unsigned int ebx;
+	unsigned int unused;
+	union cpuid10_edx edx;
+
+	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
+		return;
+
+	/*
+	 * Check whether the Architectural PerfMon supports
+	 * Branch Misses Retired Event or not.
+	 */
+	cpuid(10, &eax.full, &ebx, &unused, &edx.full);
+	if (eax.split.mask_length <= ARCH_PERFMON_BRANCH_MISSES_RETIRED)
+		return;
+
+	printk(KERN_INFO "Intel Performance Monitoring support detected.\n");
+
+	printk(KERN_INFO "... version:         %d\n", eax.split.version_id);
+	printk(KERN_INFO "... num counters:    %d\n", eax.split.num_counters);
+	nr_counters_generic = eax.split.num_counters;
+	if (nr_counters_generic > X86_PMC_MAX_GENERIC) {
+		nr_counters_generic = X86_PMC_MAX_GENERIC;
+		WARN(1, KERN_ERR "hw perf counters %d > max(%d), clipping!",
+			nr_counters_generic, X86_PMC_MAX_GENERIC);
+	}
+	perf_counter_mask = (1 << nr_counters_generic) - 1;
+	perf_max_counters = nr_counters_generic;
+
+	printk(KERN_INFO "... bit width:       %d\n", eax.split.bit_width);
+	counter_value_mask = (1ULL << eax.split.bit_width) - 1;
+	printk(KERN_INFO "... value mask:      %016Lx\n", counter_value_mask);
+
+	printk(KERN_INFO "... mask length:     %d\n", eax.split.mask_length);
+
+	nr_counters_fixed = edx.split.num_counters_fixed;
+	if (nr_counters_fixed > X86_PMC_MAX_FIXED) {
+		nr_counters_fixed = X86_PMC_MAX_FIXED;
+		WARN(1, KERN_ERR "hw perf counters fixed %d > max(%d), clipping!",
+			nr_counters_fixed, X86_PMC_MAX_FIXED);
+	}
+	printk(KERN_INFO "... fixed counters:  %d\n", nr_counters_fixed);
+
+	perf_counter_mask |= ((1LL << nr_counters_fixed)-1) << X86_PMC_IDX_FIXED;
+
+	printk(KERN_INFO "... counter mask:    %016Lx\n", perf_counter_mask);
+	perf_counters_initialized = true;
+
+	perf_counters_lapic_init(0);
+	register_die_notifier(&perf_counter_nmi_notifier);
+}
+
+static void pmc_generic_read(struct perf_counter *counter)
+{
+	x86_perf_counter_update(counter, &counter->hw, counter->hw.idx);
+}
+
+static const struct hw_perf_counter_ops x86_perf_counter_ops = {
+	.enable		= pmc_generic_enable,
+	.disable	= pmc_generic_disable,
+	.read		= pmc_generic_read,
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
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index 9abd48b..d6f5b9f 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -20,7 +20,7 @@
 #include <linux/kprobes.h>
 
 #include <asm/apic.h>
-#include <asm/intel_arch_perfmon.h>
+#include <asm/perf_counter.h>
 
 struct nmi_watchdog_ctlblk {
 	unsigned int cccr_msr;
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 28b597e..fe70141 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -619,28 +619,37 @@ END(syscall_badsys)
 27:;
 
 /*
- * Build the entry stubs and pointer table with
- * some assembler magic.
+ * Build the entry stubs and pointer table with some assembler magic.
+ * We pack 7 stubs into a single 32-byte chunk, which will fit in a
+ * single cache line on all modern x86 implementations.
  */
-.section .rodata,"a"
+.section .init.rodata,"a"
 ENTRY(interrupt)
 .text
-
+	.p2align 5
+	.p2align CONFIG_X86_L1_CACHE_SHIFT
 ENTRY(irq_entries_start)
 	RING0_INT_FRAME
-vector=0
-.rept NR_VECTORS
-	ALIGN
- .if vector
+vector=FIRST_EXTERNAL_VECTOR
+.rept (NR_VECTORS-FIRST_EXTERNAL_VECTOR+6)/7
+	.balign 32
+  .rept	7
+    .if vector < NR_VECTORS
+      .if vector <> FIRST_EXTERNAL_VECTOR
 	CFI_ADJUST_CFA_OFFSET -4
- .endif
-1:	pushl $~(vector)
+      .endif
+1:	pushl $(~vector+0x80)	/* Note: always in signed byte range */
 	CFI_ADJUST_CFA_OFFSET 4
-	jmp common_interrupt
- .previous
+      .if ((vector-FIRST_EXTERNAL_VECTOR)%7) <> 6
+	jmp 2f
+      .endif
+      .previous
 	.long 1b
- .text
+      .text
 vector=vector+1
+    .endif
+  .endr
+2:	jmp common_interrupt
 .endr
 END(irq_entries_start)
 
@@ -652,8 +661,9 @@ END(interrupt)
  * the CPU automatically disables interrupts when executing an IRQ vector,
  * so IRQ-flags tracing has to follow that:
  */
-	ALIGN
+	.p2align CONFIG_X86_L1_CACHE_SHIFT
 common_interrupt:
+	addl $-0x80,(%esp)	/* Adjust vector into the [-256,-1] range */
 	SAVE_ALL
 	TRACE_IRQS_OFF
 	movl %esp,%eax
@@ -678,65 +688,6 @@ ENDPROC(name)
 /* The include is where all of the SMP etc. interrupts come from */
 #include "entry_arch.h"
 
-KPROBE_ENTRY(page_fault)
-	RING0_EC_FRAME
-	pushl $do_page_fault
-	CFI_ADJUST_CFA_OFFSET 4
-	ALIGN
-error_code:
-	/* the function address is in %fs's slot on the stack */
-	pushl %es
-	CFI_ADJUST_CFA_OFFSET 4
-	/*CFI_REL_OFFSET es, 0*/
-	pushl %ds
-	CFI_ADJUST_CFA_OFFSET 4
-	/*CFI_REL_OFFSET ds, 0*/
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET eax, 0
-	pushl %ebp
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET ebp, 0
-	pushl %edi
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET edi, 0
-	pushl %esi
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET esi, 0
-	pushl %edx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET edx, 0
-	pushl %ecx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET ecx, 0
-	pushl %ebx
-	CFI_ADJUST_CFA_OFFSET 4
-	CFI_REL_OFFSET ebx, 0
-	cld
-	pushl %fs
-	CFI_ADJUST_CFA_OFFSET 4
-	/*CFI_REL_OFFSET fs, 0*/
-	movl $(__KERNEL_PERCPU), %ecx
-	movl %ecx, %fs
-	UNWIND_ESPFIX_STACK
-	popl %ecx
-	CFI_ADJUST_CFA_OFFSET -4
-	/*CFI_REGISTER es, ecx*/
-	movl PT_FS(%esp), %edi		# get the function address
-	movl PT_ORIG_EAX(%esp), %edx	# get the error code
-	movl $-1, PT_ORIG_EAX(%esp)	# no syscall to restart
-	mov  %ecx, PT_FS(%esp)
-	/*CFI_REL_OFFSET fs, ES*/
-	movl $(__USER_DS), %ecx
-	movl %ecx, %ds
-	movl %ecx, %es
-	TRACE_IRQS_OFF
-	movl %esp,%eax			# pt_regs pointer
-	call *%edi
-	jmp ret_from_exception
-	CFI_ENDPROC
-KPROBE_END(page_fault)
-
 ENTRY(coprocessor_error)
 	RING0_INT_FRAME
 	pushl $0
@@ -767,140 +718,6 @@ ENTRY(device_not_available)
 	CFI_ENDPROC
 END(device_not_available)
 
-/*
- * Debug traps and NMI can happen at the one SYSENTER instruction
- * that sets up the real kernel stack. Check here, since we can't
- * allow the wrong stack to be used.
- *
- * "TSS_sysenter_sp0+12" is because the NMI/debug handler will have
- * already pushed 3 words if it hits on the sysenter instruction:
- * eflags, cs and eip.
- *
- * We just load the right stack, and push the three (known) values
- * by hand onto the new stack - while updating the return eip past
- * the instruction that would have done it for sysenter.
- */
-#define FIX_STACK(offset, ok, label)		\
-	cmpw $__KERNEL_CS,4(%esp);		\
-	jne ok;					\
-label:						\
-	movl TSS_sysenter_sp0+offset(%esp),%esp;	\
-	CFI_DEF_CFA esp, 0;			\
-	CFI_UNDEFINED eip;			\
-	pushfl;					\
-	CFI_ADJUST_CFA_OFFSET 4;		\
-	pushl $__KERNEL_CS;			\
-	CFI_ADJUST_CFA_OFFSET 4;		\
-	pushl $sysenter_past_esp;		\
-	CFI_ADJUST_CFA_OFFSET 4;		\
-	CFI_REL_OFFSET eip, 0
-
-KPROBE_ENTRY(debug)
-	RING0_INT_FRAME
-	cmpl $ia32_sysenter_target,(%esp)
-	jne debug_stack_correct
-	FIX_STACK(12, debug_stack_correct, debug_esp_fix_insn)
-debug_stack_correct:
-	pushl $-1			# mark this as an int
-	CFI_ADJUST_CFA_OFFSET 4
-	SAVE_ALL
-	TRACE_IRQS_OFF
-	xorl %edx,%edx			# error code 0
-	movl %esp,%eax			# pt_regs pointer
-	call do_debug
-	jmp ret_from_exception
-	CFI_ENDPROC
-KPROBE_END(debug)
-
-/*
- * NMI is doubly nasty. It can happen _while_ we're handling
- * a debug fault, and the debug fault hasn't yet been able to
- * clear up the stack. So we first check whether we got  an
- * NMI on the sysenter entry path, but after that we need to
- * check whether we got an NMI on the debug path where the debug
- * fault happened on the sysenter path.
- */
-KPROBE_ENTRY(nmi)
-	RING0_INT_FRAME
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
-	movl %ss, %eax
-	cmpw $__ESPFIX_SS, %ax
-	popl %eax
-	CFI_ADJUST_CFA_OFFSET -4
-	je nmi_espfix_stack
-	cmpl $ia32_sysenter_target,(%esp)
-	je nmi_stack_fixup
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
-	movl %esp,%eax
-	/* Do not access memory above the end of our stack page,
-	 * it might not exist.
-	 */
-	andl $(THREAD_SIZE-1),%eax
-	cmpl $(THREAD_SIZE-20),%eax
-	popl %eax
-	CFI_ADJUST_CFA_OFFSET -4
-	jae nmi_stack_correct
-	cmpl $ia32_sysenter_target,12(%esp)
-	je nmi_debug_stack_check
-nmi_stack_correct:
-	/* We have a RING0_INT_FRAME here */
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
-	SAVE_ALL
-	TRACE_IRQS_OFF
-	xorl %edx,%edx		# zero error code
-	movl %esp,%eax		# pt_regs pointer
-	call do_nmi
-	jmp restore_nocheck_notrace
-	CFI_ENDPROC
-
-nmi_stack_fixup:
-	RING0_INT_FRAME
-	FIX_STACK(12,nmi_stack_correct, 1)
-	jmp nmi_stack_correct
-
-nmi_debug_stack_check:
-	/* We have a RING0_INT_FRAME here */
-	cmpw $__KERNEL_CS,16(%esp)
-	jne nmi_stack_correct
-	cmpl $debug,(%esp)
-	jb nmi_stack_correct
-	cmpl $debug_esp_fix_insn,(%esp)
-	ja nmi_stack_correct
-	FIX_STACK(24,nmi_stack_correct, 1)
-	jmp nmi_stack_correct
-
-nmi_espfix_stack:
-	/* We have a RING0_INT_FRAME here.
-	 *
-	 * create the pointer to lss back
-	 */
-	pushl %ss
-	CFI_ADJUST_CFA_OFFSET 4
-	pushl %esp
-	CFI_ADJUST_CFA_OFFSET 4
-	addw $4, (%esp)
-	/* copy the iret frame of 12 bytes */
-	.rept 3
-	pushl 16(%esp)
-	CFI_ADJUST_CFA_OFFSET 4
-	.endr
-	pushl %eax
-	CFI_ADJUST_CFA_OFFSET 4
-	SAVE_ALL
-	TRACE_IRQS_OFF
-	FIXUP_ESPFIX_STACK		# %eax == %esp
-	xorl %edx,%edx			# zero error code
-	call do_nmi
-	RESTORE_REGS
-	lss 12+4(%esp), %esp		# back to espfix stack
-	CFI_ADJUST_CFA_OFFSET -24
-	jmp irq_return
-	CFI_ENDPROC
-KPROBE_END(nmi)
-
 #ifdef CONFIG_PARAVIRT
 ENTRY(native_iret)
 	iret
@@ -916,19 +733,6 @@ ENTRY(native_irq_enable_sysexit)
 END(native_irq_enable_sysexit)
 #endif
 
-KPROBE_ENTRY(int3)
-	RING0_INT_FRAME
-	pushl $-1			# mark this as an int
-	CFI_ADJUST_CFA_OFFSET 4
-	SAVE_ALL
-	TRACE_IRQS_OFF
-	xorl %edx,%edx		# zero error code
-	movl %esp,%eax		# pt_regs pointer
-	call do_int3
-	jmp ret_from_exception
-	CFI_ENDPROC
-KPROBE_END(int3)
-
 ENTRY(overflow)
 	RING0_INT_FRAME
 	pushl $0
@@ -993,14 +797,6 @@ ENTRY(stack_segment)
 	CFI_ENDPROC
 END(stack_segment)
 
-KPROBE_ENTRY(general_protection)
-	RING0_EC_FRAME
-	pushl $do_general_protection
-	CFI_ADJUST_CFA_OFFSET 4
-	jmp error_code
-	CFI_ENDPROC
-KPROBE_END(general_protection)
-
 ENTRY(alignment_check)
 	RING0_EC_FRAME
 	pushl $do_alignment_check
@@ -1051,6 +847,7 @@ ENTRY(kernel_thread_helper)
 	push %eax
 	CFI_ADJUST_CFA_OFFSET 4
 	call do_exit
+	ud2			# padding for call trace
 	CFI_ENDPROC
 ENDPROC(kernel_thread_helper)
 
@@ -1210,3 +1007,227 @@ END(mcount)
 #include "syscall_table_32.S"
 
 syscall_table_size=(.-sys_call_table)
+
+/*
+ * Some functions should be protected against kprobes
+ */
+	.pushsection .kprobes.text, "ax"
+
+ENTRY(page_fault)
+	RING0_EC_FRAME
+	pushl $do_page_fault
+	CFI_ADJUST_CFA_OFFSET 4
+	ALIGN
+error_code:
+	/* the function address is in %fs's slot on the stack */
+	pushl %es
+	CFI_ADJUST_CFA_OFFSET 4
+	/*CFI_REL_OFFSET es, 0*/
+	pushl %ds
+	CFI_ADJUST_CFA_OFFSET 4
+	/*CFI_REL_OFFSET ds, 0*/
+	pushl %eax
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET eax, 0
+	pushl %ebp
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET ebp, 0
+	pushl %edi
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET edi, 0
+	pushl %esi
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET esi, 0
+	pushl %edx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET edx, 0
+	pushl %ecx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET ecx, 0
+	pushl %ebx
+	CFI_ADJUST_CFA_OFFSET 4
+	CFI_REL_OFFSET ebx, 0
+	cld
+	pushl %fs
+	CFI_ADJUST_CFA_OFFSET 4
+	/*CFI_REL_OFFSET fs, 0*/
+	movl $(__KERNEL_PERCPU), %ecx
+	movl %ecx, %fs
+	UNWIND_ESPFIX_STACK
+	popl %ecx
+	CFI_ADJUST_CFA_OFFSET -4
+	/*CFI_REGISTER es, ecx*/
+	movl PT_FS(%esp), %edi		# get the function address
+	movl PT_ORIG_EAX(%esp), %edx	# get the error code
+	movl $-1, PT_ORIG_EAX(%esp)	# no syscall to restart
+	mov  %ecx, PT_FS(%esp)
+	/*CFI_REL_OFFSET fs, ES*/
+	movl $(__USER_DS), %ecx
+	movl %ecx, %ds
+	movl %ecx, %es
+	TRACE_IRQS_OFF
+	movl %esp,%eax			# pt_regs pointer
+	call *%edi
+	jmp ret_from_exception
+	CFI_ENDPROC
+END(page_fault)
+
+/*
+ * Debug traps and NMI can happen at the one SYSENTER instruction
+ * that sets up the real kernel stack. Check here, since we can't
+ * allow the wrong stack to be used.
+ *
+ * "TSS_sysenter_sp0+12" is because the NMI/debug handler will have
+ * already pushed 3 words if it hits on the sysenter instruction:
+ * eflags, cs and eip.
+ *
+ * We just load the right stack, and push the three (known) values
+ * by hand onto the new stack - while updating the return eip past
+ * the instruction that would have done it for sysenter.
+ */
+#define FIX_STACK(offset, ok, label)		\
+	cmpw $__KERNEL_CS,4(%esp);		\
+	jne ok;					\
+label:						\
+	movl TSS_sysenter_sp0+offset(%esp),%esp;	\
+	CFI_DEF_CFA esp, 0;			\
+	CFI_UNDEFINED eip;			\
+	pushfl;					\
+	CFI_ADJUST_CFA_OFFSET 4;		\
+	pushl $__KERNEL_CS;			\
+	CFI_ADJUST_CFA_OFFSET 4;		\
+	pushl $sysenter_past_esp;		\
+	CFI_ADJUST_CFA_OFFSET 4;		\
+	CFI_REL_OFFSET eip, 0
+
+ENTRY(debug)
+	RING0_INT_FRAME
+	cmpl $ia32_sysenter_target,(%esp)
+	jne debug_stack_correct
+	FIX_STACK(12, debug_stack_correct, debug_esp_fix_insn)
+debug_stack_correct:
+	pushl $-1			# mark this as an int
+	CFI_ADJUST_CFA_OFFSET 4
+	SAVE_ALL
+	TRACE_IRQS_OFF
+	xorl %edx,%edx			# error code 0
+	movl %esp,%eax			# pt_regs pointer
+	call do_debug
+	jmp ret_from_exception
+	CFI_ENDPROC
+END(debug)
+
+/*
+ * NMI is doubly nasty. It can happen _while_ we're handling
+ * a debug fault, and the debug fault hasn't yet been able to
+ * clear up the stack. So we first check whether we got  an
+ * NMI on the sysenter entry path, but after that we need to
+ * check whether we got an NMI on the debug path where the debug
+ * fault happened on the sysenter path.
+ */
+ENTRY(nmi)
+	RING0_INT_FRAME
+	pushl %eax
+	CFI_ADJUST_CFA_OFFSET 4
+	movl %ss, %eax
+	cmpw $__ESPFIX_SS, %ax
+	popl %eax
+	CFI_ADJUST_CFA_OFFSET -4
+	je nmi_espfix_stack
+	cmpl $ia32_sysenter_target,(%esp)
+	je nmi_stack_fixup
+	pushl %eax
+	CFI_ADJUST_CFA_OFFSET 4
+	movl %esp,%eax
+	/* Do not access memory above the end of our stack page,
+	 * it might not exist.
+	 */
+	andl $(THREAD_SIZE-1),%eax
+	cmpl $(THREAD_SIZE-20),%eax
+	popl %eax
+	CFI_ADJUST_CFA_OFFSET -4
+	jae nmi_stack_correct
+	cmpl $ia32_sysenter_target,12(%esp)
+	je nmi_debug_stack_check
+nmi_stack_correct:
+	/* We have a RING0_INT_FRAME here */
+	pushl %eax
+	CFI_ADJUST_CFA_OFFSET 4
+	SAVE_ALL
+	TRACE_IRQS_OFF
+	xorl %edx,%edx		# zero error code
+	movl %esp,%eax		# pt_regs pointer
+	call do_nmi
+	jmp restore_nocheck_notrace
+	CFI_ENDPROC
+
+nmi_stack_fixup:
+	RING0_INT_FRAME
+	FIX_STACK(12,nmi_stack_correct, 1)
+	jmp nmi_stack_correct
+
+nmi_debug_stack_check:
+	/* We have a RING0_INT_FRAME here */
+	cmpw $__KERNEL_CS,16(%esp)
+	jne nmi_stack_correct
+	cmpl $debug,(%esp)
+	jb nmi_stack_correct
+	cmpl $debug_esp_fix_insn,(%esp)
+	ja nmi_stack_correct
+	FIX_STACK(24,nmi_stack_correct, 1)
+	jmp nmi_stack_correct
+
+nmi_espfix_stack:
+	/* We have a RING0_INT_FRAME here.
+	 *
+	 * create the pointer to lss back
+	 */
+	pushl %ss
+	CFI_ADJUST_CFA_OFFSET 4
+	pushl %esp
+	CFI_ADJUST_CFA_OFFSET 4
+	addw $4, (%esp)
+	/* copy the iret frame of 12 bytes */
+	.rept 3
+	pushl 16(%esp)
+	CFI_ADJUST_CFA_OFFSET 4
+	.endr
+	pushl %eax
+	CFI_ADJUST_CFA_OFFSET 4
+	SAVE_ALL
+	TRACE_IRQS_OFF
+	FIXUP_ESPFIX_STACK		# %eax == %esp
+	xorl %edx,%edx			# zero error code
+	call do_nmi
+	RESTORE_REGS
+	lss 12+4(%esp), %esp		# back to espfix stack
+	CFI_ADJUST_CFA_OFFSET -24
+	jmp irq_return
+	CFI_ENDPROC
+END(nmi)
+
+ENTRY(int3)
+	RING0_INT_FRAME
+	pushl $-1			# mark this as an int
+	CFI_ADJUST_CFA_OFFSET 4
+	SAVE_ALL
+	TRACE_IRQS_OFF
+	xorl %edx,%edx		# zero error code
+	movl %esp,%eax		# pt_regs pointer
+	call do_int3
+	jmp ret_from_exception
+	CFI_ENDPROC
+END(int3)
+
+ENTRY(general_protection)
+	RING0_EC_FRAME
+	pushl $do_general_protection
+	CFI_ADJUST_CFA_OFFSET 4
+	jmp error_code
+	CFI_ENDPROC
+END(general_protection)
+
+/*
+ * End of kprobes section
+ */
+	.popsection
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b86f332..fc013cf 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -11,15 +11,15 @@
  *
  * NOTE: This code handles signal-recognition, which happens every time
  * after an interrupt and after each system call.
- * 
- * Normal syscalls and interrupts don't save a full stack frame, this is 
+ *
+ * Normal syscalls and interrupts don't save a full stack frame, this is
  * only done for syscall tracing, signals or fork/exec et.al.
- * 
- * A note on terminology:	 
- * - top of stack: Architecture defined interrupt frame from SS to RIP 
- * at the top of the kernel process stack.	
+ *
+ * A note on terminology:
+ * - top of stack: Architecture defined interrupt frame from SS to RIP
+ * at the top of the kernel process stack.
  * - partial stack frame: partially saved registers upto R11.
- * - full stack frame: Like partial stack frame, but all register saved. 
+ * - full stack frame: Like partial stack frame, but all register saved.
  *
  * Some macro usage:
  * - CFI macros are used to generate dwarf2 unwind information for better
@@ -60,7 +60,6 @@
 #define __AUDIT_ARCH_LE	   0x40000000
 
 	.code64
-
 #ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 ENTRY(mcount)
@@ -142,7 +141,7 @@ END(mcount)
 
 #ifndef CONFIG_PREEMPT
 #define retint_kernel retint_restore_args
-#endif	
+#endif
 
 #ifdef CONFIG_PARAVIRT
 ENTRY(native_usergs_sysret64)
@@ -161,29 +160,29 @@ ENTRY(native_usergs_sysret64)
 .endm
 
 /*
- * C code is not supposed to know about undefined top of stack. Every time 
- * a C function with an pt_regs argument is called from the SYSCALL based 
+ * C code is not supposed to know about undefined top of stack. Every time
+ * a C function with an pt_regs argument is called from the SYSCALL based
  * fast path FIXUP_TOP_OF_STACK is needed.
  * RESTORE_TOP_OF_STACK syncs the syscall state after any possible ptregs
  * manipulation.
- */        	
-		
-	/* %rsp:at FRAMEEND */ 
-	.macro FIXUP_TOP_OF_STACK tmp
-	movq	%gs:pda_oldrsp,\tmp
-	movq  	\tmp,RSP(%rsp)
-	movq    $__USER_DS,SS(%rsp)
-	movq    $__USER_CS,CS(%rsp)
-	movq 	$-1,RCX(%rsp)
-	movq	R11(%rsp),\tmp  /* get eflags */
-	movq	\tmp,EFLAGS(%rsp)
+ */
+
+	/* %rsp:at FRAMEEND */
+	.macro FIXUP_TOP_OF_STACK tmp offset=0
+	movq %gs:pda_oldrsp,\tmp
+	movq \tmp,RSP+\offset(%rsp)
+	movq $__USER_DS,SS+\offset(%rsp)
+	movq $__USER_CS,CS+\offset(%rsp)
+	movq $-1,RCX+\offset(%rsp)
+	movq R11+\offset(%rsp),\tmp  /* get eflags */
+	movq \tmp,EFLAGS+\offset(%rsp)
 	.endm
 
-	.macro RESTORE_TOP_OF_STACK tmp,offset=0
-	movq   RSP-\offset(%rsp),\tmp
-	movq   \tmp,%gs:pda_oldrsp
-	movq   EFLAGS-\offset(%rsp),\tmp
-	movq   \tmp,R11-\offset(%rsp)
+	.macro RESTORE_TOP_OF_STACK tmp offset=0
+	movq RSP+\offset(%rsp),\tmp
+	movq \tmp,%gs:pda_oldrsp
+	movq EFLAGS+\offset(%rsp),\tmp
+	movq \tmp,R11+\offset(%rsp)
 	.endm
 
 	.macro FAKE_STACK_FRAME child_rip
@@ -195,7 +194,7 @@ ENTRY(native_usergs_sysret64)
 	pushq %rax /* rsp */
 	CFI_ADJUST_CFA_OFFSET	8
 	CFI_REL_OFFSET	rsp,0
-	pushq $(1<<9) /* eflags - interrupts on */
+	pushq $X86_EFLAGS_IF /* eflags - interrupts on */
 	CFI_ADJUST_CFA_OFFSET	8
 	/*CFI_REL_OFFSET	rflags,0*/
 	pushq $__KERNEL_CS /* cs */
@@ -213,62 +212,184 @@ ENTRY(native_usergs_sysret64)
 	CFI_ADJUST_CFA_OFFSET	-(6*8)
 	.endm
 
-	.macro	CFI_DEFAULT_STACK start=1
+/*
+ * initial frame state for interrupts (and exceptions without error code)
+ */
+	.macro EMPTY_FRAME start=1 offset=0
 	.if \start
-	CFI_STARTPROC	simple
+	CFI_STARTPROC simple
 	CFI_SIGNAL_FRAME
-	CFI_DEF_CFA	rsp,SS+8
+	CFI_DEF_CFA rsp,8+\offset
 	.else
-	CFI_DEF_CFA_OFFSET SS+8
+	CFI_DEF_CFA_OFFSET 8+\offset
 	.endif
-	CFI_REL_OFFSET	r15,R15
-	CFI_REL_OFFSET	r14,R14
-	CFI_REL_OFFSET	r13,R13
-	CFI_REL_OFFSET	r12,R12
-	CFI_REL_OFFSET	rbp,RBP
-	CFI_REL_OFFSET	rbx,RBX
-	CFI_REL_OFFSET	r11,R11
-	CFI_REL_OFFSET	r10,R10
-	CFI_REL_OFFSET	r9,R9
-	CFI_REL_OFFSET	r8,R8
-	CFI_REL_OFFSET	rax,RAX
-	CFI_REL_OFFSET	rcx,RCX
-	CFI_REL_OFFSET	rdx,RDX
-	CFI_REL_OFFSET	rsi,RSI
-	CFI_REL_OFFSET	rdi,RDI
-	CFI_REL_OFFSET	rip,RIP
-	/*CFI_REL_OFFSET	cs,CS*/
-	/*CFI_REL_OFFSET	rflags,EFLAGS*/
-	CFI_REL_OFFSET	rsp,RSP
-	/*CFI_REL_OFFSET	ss,SS*/
 	.endm
+
+/*
+ * initial frame state for interrupts (and exceptions without error code)
+ */
+	.macro INTR_FRAME start=1 offset=0
+	EMPTY_FRAME \start, SS+8+\offset-RIP
+	/*CFI_REL_OFFSET ss, SS+\offset-RIP*/
+	CFI_REL_OFFSET rsp, RSP+\offset-RIP
+	/*CFI_REL_OFFSET rflags, EFLAGS+\offset-RIP*/
+	/*CFI_REL_OFFSET cs, CS+\offset-RIP*/
+	CFI_REL_OFFSET rip, RIP+\offset-RIP
+	.endm
+
+/*
+ * initial frame state for exceptions with error code (and interrupts
+ * with vector already pushed)
+ */
+	.macro XCPT_FRAME start=1 offset=0
+	INTR_FRAME \start, RIP+\offset-ORIG_RAX
+	/*CFI_REL_OFFSET orig_rax, ORIG_RAX-ORIG_RAX*/
+	.endm
+
+/*
+ * frame that enables calling into C.
+ */
+	.macro PARTIAL_FRAME start=1 offset=0
+	XCPT_FRAME \start, ORIG_RAX+\offset-ARGOFFSET
+	CFI_REL_OFFSET rdi, RDI+\offset-ARGOFFSET
+	CFI_REL_OFFSET rsi, RSI+\offset-ARGOFFSET
+	CFI_REL_OFFSET rdx, RDX+\offset-ARGOFFSET
+	CFI_REL_OFFSET rcx, RCX+\offset-ARGOFFSET
+	CFI_REL_OFFSET rax, RAX+\offset-ARGOFFSET
+	CFI_REL_OFFSET r8, R8+\offset-ARGOFFSET
+	CFI_REL_OFFSET r9, R9+\offset-ARGOFFSET
+	CFI_REL_OFFSET r10, R10+\offset-ARGOFFSET
+	CFI_REL_OFFSET r11, R11+\offset-ARGOFFSET
+	.endm
+
+/*
+ * frame that enables passing a complete pt_regs to a C function.
+ */
+	.macro DEFAULT_FRAME start=1 offset=0
+	PARTIAL_FRAME \start, R11+\offset-R15
+	CFI_REL_OFFSET rbx, RBX+\offset
+	CFI_REL_OFFSET rbp, RBP+\offset
+	CFI_REL_OFFSET r12, R12+\offset
+	CFI_REL_OFFSET r13, R13+\offset
+	CFI_REL_OFFSET r14, R14+\offset
+	CFI_REL_OFFSET r15, R15+\offset
+	.endm
+
+/* save partial stack frame */
+ENTRY(save_args)
+	XCPT_FRAME
+	cld
+	movq_cfi rdi, RDI+16-ARGOFFSET
+	movq_cfi rsi, RSI+16-ARGOFFSET
+	movq_cfi rdx, RDX+16-ARGOFFSET
+	movq_cfi rcx, RCX+16-ARGOFFSET
+	movq_cfi rax, RAX+16-ARGOFFSET
+	movq_cfi  r8,  R8+16-ARGOFFSET
+	movq_cfi  r9,  R9+16-ARGOFFSET
+	movq_cfi r10, R10+16-ARGOFFSET
+	movq_cfi r11, R11+16-ARGOFFSET
+
+	leaq -ARGOFFSET+16(%rsp),%rdi	/* arg1 for handler */
+	movq_cfi rbp, 8		/* push %rbp */
+	leaq 8(%rsp), %rbp		/* mov %rsp, %ebp */
+	testl $3, CS(%rdi)
+	je 1f
+	SWAPGS
+	/*
+	 * irqcount is used to check if a CPU is already on an interrupt stack
+	 * or not. While this is essentially redundant with preempt_count it is
+	 * a little cheaper to use a separate counter in the PDA (short of
+	 * moving irq_enter into assembly, which would be too much work)
+	 */
+1:	incl %gs:pda_irqcount
+	jne 2f
+	popq_cfi %rax			/* move return address... */
+	mov %gs:pda_irqstackptr,%rsp
+	EMPTY_FRAME 0
+	pushq_cfi %rax			/* ... to the new stack */
+	/*
+	 * We entered an interrupt context - irqs are off:
+	 */
+2:	TRACE_IRQS_OFF
+	ret
+	CFI_ENDPROC
+END(save_args)
+
+ENTRY(save_rest)
+	PARTIAL_FRAME 1 REST_SKIP+8
+	movq 5*8+16(%rsp), %r11	/* save return address */
+	movq_cfi rbx, RBX+16
+	movq_cfi rbp, RBP+16
+	movq_cfi r12, R12+16
+	movq_cfi r13, R13+16
+	movq_cfi r14, R14+16
+	movq_cfi r15, R15+16
+	movq %r11, 8(%rsp)	/* return address */
+	FIXUP_TOP_OF_STACK %r11, 16
+	ret
+	CFI_ENDPROC
+END(save_rest)
+
+/* save complete stack frame */
+ENTRY(save_paranoid)
+	XCPT_FRAME 1 RDI+8
+	cld
+	movq_cfi rdi, RDI+8
+	movq_cfi rsi, RSI+8
+	movq_cfi rdx, RDX+8
+	movq_cfi rcx, RCX+8
+	movq_cfi rax, RAX+8
+	movq_cfi r8, R8+8
+	movq_cfi r9, R9+8
+	movq_cfi r10, R10+8
+	movq_cfi r11, R11+8
+	movq_cfi rbx, RBX+8
+	movq_cfi rbp, RBP+8
+	movq_cfi r12, R12+8
+	movq_cfi r13, R13+8
+	movq_cfi r14, R14+8
+	movq_cfi r15, R15+8
+	movl $1,%ebx
+	movl $MSR_GS_BASE,%ecx
+	rdmsr
+	testl %edx,%edx
+	js 1f	/* negative -> in kernel */
+	SWAPGS
+	xorl %ebx,%ebx
+1:	ret
+	CFI_ENDPROC
+END(save_paranoid)
+
 /*
- * A newly forked process directly context switches into this.
- */ 	
-/* rdi:	prev */	
+ * A newly forked process directly context switches into this address.
+ *
+ * rdi: prev task we switched from
+ */
 ENTRY(ret_from_fork)
-	CFI_DEFAULT_STACK
+	DEFAULT_FRAME
+
 	push kernel_eflags(%rip)
 	CFI_ADJUST_CFA_OFFSET 8
-	popf				# reset kernel eflags
+	popf					# reset kernel eflags
 	CFI_ADJUST_CFA_OFFSET -8
-	call schedule_tail
+
+	call schedule_tail			# rdi: 'prev' task parameter
+
 	GET_THREAD_INFO(%rcx)
-	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT),TI_flags(%rcx)
-	jnz rff_trace
-rff_action:	
+
+	CFI_REMEMBER_STATE
 	RESTORE_REST
-	testl $3,CS-ARGOFFSET(%rsp)	# from kernel_thread?
+
+	testl $3, CS-ARGOFFSET(%rsp)		# from kernel_thread?
 	je   int_ret_from_sys_call
-	testl $_TIF_IA32,TI_flags(%rcx)
+
+	testl $_TIF_IA32, TI_flags(%rcx)	# 32-bit compat task needs IRET
 	jnz  int_ret_from_sys_call
-	RESTORE_TOP_OF_STACK %rdi,ARGOFFSET
-	jmp ret_from_sys_call
-rff_trace:
-	movq %rsp,%rdi
-	call syscall_trace_leave
-	GET_THREAD_INFO(%rcx)	
-	jmp rff_action
+
+	RESTORE_TOP_OF_STACK %rdi, -ARGOFFSET
+	jmp ret_from_sys_call			# go to the SYSRET fastpath
+
+	CFI_RESTORE_STATE
 	CFI_ENDPROC
 END(ret_from_fork)
 
@@ -278,20 +399,20 @@ END(ret_from_fork)
  * SYSCALL does not save anything on the stack and does not change the
  * stack pointer.
  */
-		
+
 /*
- * Register setup:	
+ * Register setup:
  * rax  system call number
  * rdi  arg0
- * rcx  return address for syscall/sysret, C arg3 
+ * rcx  return address for syscall/sysret, C arg3
  * rsi  arg1
- * rdx  arg2	
+ * rdx  arg2
  * r10  arg3 	(--> moved to rcx for C)
  * r8   arg4
  * r9   arg5
  * r11  eflags for syscall/sysret, temporary for C
- * r12-r15,rbp,rbx saved by C code, not touched. 		
- * 
+ * r12-r15,rbp,rbx saved by C code, not touched.
+ *
  * Interrupts are off on entry.
  * Only called from user space.
  *
@@ -301,7 +422,7 @@ END(ret_from_fork)
  * When user can change the frames always force IRET. That is because
  * it deals with uncanonical addresses better. SYSRET has trouble
  * with them due to bugs in both AMD and Intel CPUs.
- */ 			 		
+ */
 
 ENTRY(system_call)
 	CFI_STARTPROC	simple
@@ -317,7 +438,7 @@ ENTRY(system_call)
 	 */
 ENTRY(system_call_after_swapgs)
 
-	movq	%rsp,%gs:pda_oldrsp 
+	movq	%rsp,%gs:pda_oldrsp
 	movq	%gs:pda_kernelstack,%rsp
 	/*
 	 * No need to follow this irqs off/on section - it's straight
@@ -325,7 +446,7 @@ ENTRY(system_call_after_swapgs)
 	 */
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	SAVE_ARGS 8,1
-	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp) 
+	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	GET_THREAD_INFO(%rcx)
@@ -339,19 +460,19 @@ system_call_fastpath:
 	movq %rax,RAX-ARGOFFSET(%rsp)
 /*
  * Syscall return path ending with SYSRET (fast path)
- * Has incomplete stack frame and undefined top of stack. 
- */		
+ * Has incomplete stack frame and undefined top of stack.
+ */
 ret_from_sys_call:
 	movl $_TIF_ALLWORK_MASK,%edi
 	/* edi:	flagmask */
-sysret_check:		
+sysret_check:
 	LOCKDEP_SYS_EXIT
 	GET_THREAD_INFO(%rcx)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	movl TI_flags(%rcx),%edx
 	andl %edi,%edx
-	jnz  sysret_careful 
+	jnz  sysret_careful
 	CFI_REMEMBER_STATE
 	/*
 	 * sysretq will re-enable interrupts:
@@ -366,7 +487,7 @@ sysret_check:
 
 	CFI_RESTORE_STATE
 	/* Handle reschedules */
-	/* edx:	work, edi: workmask */	
+	/* edx:	work, edi: workmask */
 sysret_careful:
 	bt $TIF_NEED_RESCHED,%edx
 	jnc sysret_signal
@@ -379,7 +500,7 @@ sysret_careful:
 	CFI_ADJUST_CFA_OFFSET -8
 	jmp sysret_check
 
-	/* Handle a signal */ 
+	/* Handle a signal */
 sysret_signal:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
@@ -388,17 +509,20 @@ sysret_signal:
 	jc sysret_audit
 #endif
 	/* edx:	work flags (arg3) */
-	leaq do_notify_resume(%rip),%rax
 	leaq -ARGOFFSET(%rsp),%rdi # &pt_regs -> arg1
 	xorl %esi,%esi # oldset -> arg2
-	call ptregscall_common
+	SAVE_REST
+	FIXUP_TOP_OF_STACK %r11
+	call do_notify_resume
+	RESTORE_TOP_OF_STACK %r11
+	RESTORE_REST
 	movl $_TIF_WORK_MASK,%edi
 	/* Use IRET because user could have changed frame. This
 	   works because ptregscall_common has called FIXUP_TOP_OF_STACK. */
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	jmp int_with_check
-	
+
 badsys:
 	movq $-ENOSYS,RAX-ARGOFFSET(%rsp)
 	jmp ret_from_sys_call
@@ -437,7 +561,7 @@ sysret_audit:
 #endif	/* CONFIG_AUDITSYSCALL */
 
 	/* Do syscall tracing */
-tracesys:			 
+tracesys:
 #ifdef CONFIG_AUDITSYSCALL
 	testl $(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%rcx)
 	jz auditsys
@@ -460,8 +584,8 @@ tracesys:
 	call *sys_call_table(,%rax,8)
 	movq %rax,RAX-ARGOFFSET(%rsp)
 	/* Use IRET because user could have changed frame */
-		
-/* 
+
+/*
  * Syscall return path ending with IRET.
  * Has correct top of stack, but partial stack frame.
  */
@@ -505,18 +629,18 @@ int_very_careful:
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	SAVE_REST
-	/* Check for syscall exit trace */	
+	/* Check for syscall exit trace */
 	testl $_TIF_WORK_SYSCALL_EXIT,%edx
 	jz int_signal
 	pushq %rdi
 	CFI_ADJUST_CFA_OFFSET 8
-	leaq 8(%rsp),%rdi	# &ptregs -> arg1	
+	leaq 8(%rsp),%rdi	# &ptregs -> arg1
 	call syscall_trace_leave
 	popq %rdi
 	CFI_ADJUST_CFA_OFFSET -8
 	andl $~(_TIF_WORK_SYSCALL_EXIT|_TIF_SYSCALL_EMU),%edi
 	jmp int_restore_rest
-	
+
 int_signal:
 	testl $_TIF_DO_NOTIFY_MASK,%edx
 	jz 1f
@@ -531,22 +655,24 @@ int_restore_rest:
 	jmp int_with_check
 	CFI_ENDPROC
 END(system_call)
-		
-/* 
+
+/*
  * Certain special system calls that need to save a complete full stack frame.
- */ 								
-	
+ */
 	.macro PTREGSCALL label,func,arg
-	.globl \label
-\label:
-	leaq	\func(%rip),%rax
-	leaq    -ARGOFFSET+8(%rsp),\arg /* 8 for return address */
-	jmp	ptregscall_common
+ENTRY(\label)
+	PARTIAL_FRAME 1 8		/* offset 8: return address */
+	subq $REST_SKIP, %rsp
+	CFI_ADJUST_CFA_OFFSET REST_SKIP
+	call save_rest
+	DEFAULT_FRAME 0 8		/* offset 8: return address */
+	leaq 8(%rsp), \arg	/* pt_regs pointer */
+	call \func
+	jmp ptregscall_common
+	CFI_ENDPROC
 END(\label)
 	.endm
 
-	CFI_STARTPROC
-
 	PTREGSCALL stub_clone, sys_clone, %r8
 	PTREGSCALL stub_fork, sys_fork, %rdi
 	PTREGSCALL stub_vfork, sys_vfork, %rdi
@@ -554,25 +680,18 @@ END(\label)
 	PTREGSCALL stub_iopl, sys_iopl, %rsi
 
 ENTRY(ptregscall_common)
-	popq %r11
-	CFI_ADJUST_CFA_OFFSET -8
-	CFI_REGISTER rip, r11
-	SAVE_REST
-	movq %r11, %r15
-	CFI_REGISTER rip, r15
-	FIXUP_TOP_OF_STACK %r11
-	call *%rax
-	RESTORE_TOP_OF_STACK %r11
-	movq %r15, %r11
-	CFI_REGISTER rip, r11
-	RESTORE_REST
-	pushq %r11
-	CFI_ADJUST_CFA_OFFSET 8
-	CFI_REL_OFFSET rip, 0
-	ret
+	DEFAULT_FRAME 1 8	/* offset 8: return address */
+	RESTORE_TOP_OF_STACK %r11, 8
+	movq_cfi_restore R15+8, r15
+	movq_cfi_restore R14+8, r14
+	movq_cfi_restore R13+8, r13
+	movq_cfi_restore R12+8, r12
+	movq_cfi_restore RBP+8, rbp
+	movq_cfi_restore RBX+8, rbx
+	ret $REST_SKIP		/* pop extended registers */
 	CFI_ENDPROC
 END(ptregscall_common)
-	
+
 ENTRY(stub_execve)
 	CFI_STARTPROC
 	popq %r11
@@ -588,11 +707,11 @@ ENTRY(stub_execve)
 	jmp int_ret_from_sys_call
 	CFI_ENDPROC
 END(stub_execve)
-	
+
 /*
  * sigreturn is special because it needs to restore all registers on return.
  * This cannot be done with SYSRET, so use the IRET return path instead.
- */                
+ */
 ENTRY(stub_rt_sigreturn)
 	CFI_STARTPROC
 	addq $8, %rsp
@@ -608,70 +727,70 @@ ENTRY(stub_rt_sigreturn)
 END(stub_rt_sigreturn)
 
 /*
- * initial frame state for interrupts and exceptions
+ * Build the entry stubs and pointer table with some assembler magic.
+ * We pack 7 stubs into a single 32-byte chunk, which will fit in a
+ * single cache line on all modern x86 implementations.
  */
-	.macro _frame ref
-	CFI_STARTPROC simple
-	CFI_SIGNAL_FRAME
-	CFI_DEF_CFA rsp,SS+8-\ref
-	/*CFI_REL_OFFSET ss,SS-\ref*/
-	CFI_REL_OFFSET rsp,RSP-\ref
-	/*CFI_REL_OFFSET rflags,EFLAGS-\ref*/
-	/*CFI_REL_OFFSET cs,CS-\ref*/
-	CFI_REL_OFFSET rip,RIP-\ref
-	.endm
+	.section .init.rodata,"a"
+ENTRY(interrupt)
+	.text
+	.p2align 5
+	.p2align CONFIG_X86_L1_CACHE_SHIFT
+ENTRY(irq_entries_start)
+	INTR_FRAME
+vector=FIRST_EXTERNAL_VECTOR
+.rept (NR_VECTORS-FIRST_EXTERNAL_VECTOR+6)/7
+	.balign 32
+  .rept	7
+    .if vector < NR_VECTORS
+      .if vector <> FIRST_EXTERNAL_VECTOR
+	CFI_ADJUST_CFA_OFFSET -8
+      .endif
+1:	pushq $(~vector+0x80)	/* Note: always in signed byte range */
+	CFI_ADJUST_CFA_OFFSET 8
+      .if ((vector-FIRST_EXTERNAL_VECTOR)%7) <> 6
+	jmp 2f
+      .endif
+      .previous
+	.quad 1b
+      .text
+vector=vector+1
+    .endif
+  .endr
+2:	jmp common_interrupt
+.endr
+	CFI_ENDPROC
+END(irq_entries_start)
 
-/* initial frame state for interrupts (and exceptions without error code) */
-#define INTR_FRAME _frame RIP
-/* initial frame state for exceptions with error code (and interrupts with
-   vector already pushed) */
-#define XCPT_FRAME _frame ORIG_RAX
+.previous
+END(interrupt)
+.previous
 
-/* 
+/*
  * Interrupt entry/exit.
  *
  * Interrupt entry points save only callee clobbered registers in fast path.
- *	
- * Entry runs with interrupts off.	
- */ 
+ *
+ * Entry runs with interrupts off.
+ */
 
-/* 0(%rsp): interrupt number */ 
+/* 0(%rsp): ~(interrupt number) */
 	.macro interrupt func
-	cld
-	SAVE_ARGS
-	leaq -ARGOFFSET(%rsp),%rdi	# arg1 for handler
-	pushq %rbp
-	/*
-	 * Save rbp twice: One is for marking the stack frame, as usual, and the
-	 * other, to fill pt_regs properly. This is because bx comes right
-	 * before the last saved register in that structure, and not bp. If the
-	 * base pointer were in the place bx is today, this would not be needed.
-	 */
-	movq %rbp, -8(%rsp)
-	CFI_ADJUST_CFA_OFFSET	8
-	CFI_REL_OFFSET		rbp, 0
-	movq %rsp,%rbp
-	CFI_DEF_CFA_REGISTER	rbp
-	testl $3,CS(%rdi)
-	je 1f
-	SWAPGS
-	/* irqcount is used to check if a CPU is already on an interrupt
-	   stack or not. While this is essentially redundant with preempt_count
-	   it is a little cheaper to use a separate counter in the PDA
-	   (short of moving irq_enter into assembly, which would be too
-	    much work) */
-1:	incl	%gs:pda_irqcount
-	cmoveq %gs:pda_irqstackptr,%rsp
-	push    %rbp			# backlink for old unwinder
-	/*
-	 * We entered an interrupt context - irqs are off:
-	 */
-	TRACE_IRQS_OFF
+	subq $10*8, %rsp
+	CFI_ADJUST_CFA_OFFSET 10*8
+	call save_args
+	PARTIAL_FRAME 0
 	call \func
 	.endm
 
-ENTRY(common_interrupt)
+	/*
+	 * The interrupt stubs push (~vector+0x80) onto the stack and
+	 * then jump to common_interrupt.
+	 */
+	.p2align CONFIG_X86_L1_CACHE_SHIFT
+common_interrupt:
 	XCPT_FRAME
+	addq $-0x80,(%rsp)		/* Adjust vector to [-256,-1] range */
 	interrupt do_IRQ
 	/* 0(%rsp): oldrsp-ARGOFFSET */
 ret_from_intr:
@@ -685,12 +804,12 @@ exit_intr:
 	GET_THREAD_INFO(%rcx)
 	testl $3,CS-ARGOFFSET(%rsp)
 	je retint_kernel
-	
+
 	/* Interrupt came from user space */
 	/*
 	 * Has a correct top of stack, but a partial stack frame
 	 * %rcx: thread info. Interrupts off.
-	 */		
+	 */
 retint_with_reschedule:
 	movl $_TIF_WORK_MASK,%edi
 retint_check:
@@ -763,20 +882,20 @@ retint_careful:
 	pushq %rdi
 	CFI_ADJUST_CFA_OFFSET	8
 	call  schedule
-	popq %rdi		
+	popq %rdi
 	CFI_ADJUST_CFA_OFFSET	-8
 	GET_THREAD_INFO(%rcx)
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	jmp retint_check
-	
+
 retint_signal:
 	testl $_TIF_DO_NOTIFY_MASK,%edx
 	jz    retint_swapgs
 	TRACE_IRQS_ON
 	ENABLE_INTERRUPTS(CLBR_NONE)
 	SAVE_REST
-	movq $-1,ORIG_RAX(%rsp) 			
+	movq $-1,ORIG_RAX(%rsp)
 	xorl %esi,%esi		# oldset
 	movq %rsp,%rdi		# &pt_regs
 	call do_notify_resume
@@ -798,324 +917,216 @@ ENTRY(retint_kernel)
 	jnc  retint_restore_args
 	call preempt_schedule_irq
 	jmp exit_intr
-#endif	
+#endif
 
 	CFI_ENDPROC
 END(common_interrupt)
-	
+
 /*
  * APIC interrupts.
- */		
-	.macro apicinterrupt num,func
+ */
+.macro apicinterrupt num sym do_sym
+ENTRY(\sym)
 	INTR_FRAME
 	pushq $~(\num)
 	CFI_ADJUST_CFA_OFFSET 8
-	interrupt \func
+	interrupt \do_sym
 	jmp ret_from_intr
 	CFI_ENDPROC
-	.endm
-
-ENTRY(thermal_interrupt)
-	apicinterrupt THERMAL_APIC_VECTOR,smp_thermal_interrupt
-END(thermal_interrupt)
-
-ENTRY(threshold_interrupt)
-	apicinterrupt THRESHOLD_APIC_VECTOR,mce_threshold_interrupt
-END(threshold_interrupt)
-
-#ifdef CONFIG_SMP	
-ENTRY(reschedule_interrupt)
-	apicinterrupt RESCHEDULE_VECTOR,smp_reschedule_interrupt
-END(reschedule_interrupt)
+END(\sym)
+.endm
 
-	.macro INVALIDATE_ENTRY num
-ENTRY(invalidate_interrupt\num)
-	apicinterrupt INVALIDATE_TLB_VECTOR_START+\num,smp_invalidate_interrupt	
-END(invalidate_interrupt\num)
-	.endm
+#ifdef CONFIG_SMP
+apicinterrupt IRQ_MOVE_CLEANUP_VECTOR \
+	irq_move_cleanup_interrupt smp_irq_move_cleanup_interrupt
+#endif
 
-	INVALIDATE_ENTRY 0
-	INVALIDATE_ENTRY 1
-	INVALIDATE_ENTRY 2
-	INVALIDATE_ENTRY 3
-	INVALIDATE_ENTRY 4
-	INVALIDATE_ENTRY 5
-	INVALIDATE_ENTRY 6
-	INVALIDATE_ENTRY 7
-
-ENTRY(call_function_interrupt)
-	apicinterrupt CALL_FUNCTION_VECTOR,smp_call_function_interrupt
-END(call_function_interrupt)
-ENTRY(call_function_single_interrupt)
-	apicinterrupt CALL_FUNCTION_SINGLE_VECTOR,smp_call_function_single_interrupt
-END(call_function_single_interrupt)
-ENTRY(irq_move_cleanup_interrupt)
-	apicinterrupt IRQ_MOVE_CLEANUP_VECTOR,smp_irq_move_cleanup_interrupt
-END(irq_move_cleanup_interrupt)
+apicinterrupt UV_BAU_MESSAGE \
+	uv_bau_message_intr1 uv_bau_message_interrupt
+apicinterrupt LOCAL_TIMER_VECTOR \
+	apic_timer_interrupt smp_apic_timer_interrupt
+
+#ifdef CONFIG_SMP
+apicinterrupt INVALIDATE_TLB_VECTOR_START+0 \
+	invalidate_interrupt0 smp_invalidate_interrupt
+apicinterrupt INVALIDATE_TLB_VECTOR_START+1 \
+	invalidate_interrupt1 smp_invalidate_interrupt
+apicinterrupt INVALIDATE_TLB_VECTOR_START+2 \
+	invalidate_interrupt2 smp_invalidate_interrupt
+apicinterrupt INVALIDATE_TLB_VECTOR_START+3 \
+	invalidate_interrupt3 smp_invalidate_interrupt
+apicinterrupt INVALIDATE_TLB_VECTOR_START+4 \
+	invalidate_interrupt4 smp_invalidate_interrupt
+apicinterrupt INVALIDATE_TLB_VECTOR_START+5 \
+	invalidate_interrupt5 smp_invalidate_interrupt
+apicinterrupt INVALIDATE_TLB_VECTOR_START+6 \
+	invalidate_interrupt6 smp_invalidate_interrupt
+apicinterrupt INVALIDATE_TLB_VECTOR_START+7 \
+	invalidate_interrupt7 smp_invalidate_interrupt
 #endif
 
-ENTRY(apic_timer_interrupt)
-	apicinterrupt LOCAL_TIMER_VECTOR,smp_apic_timer_interrupt
-END(apic_timer_interrupt)
+apicinterrupt THRESHOLD_APIC_VECTOR \
+	threshold_interrupt mce_threshold_interrupt
+apicinterrupt THERMAL_APIC_VECTOR \
+	thermal_interrupt smp_thermal_interrupt
+
+#ifdef CONFIG_SMP
+apicinterrupt CALL_FUNCTION_SINGLE_VECTOR \
+	call_function_single_interrupt smp_call_function_single_interrupt
+apicinterrupt CALL_FUNCTION_VECTOR \
+	call_function_interrupt smp_call_function_interrupt
+apicinterrupt RESCHEDULE_VECTOR \
+	reschedule_interrupt smp_reschedule_interrupt
+#endif
 
-ENTRY(uv_bau_message_intr1)
-	apicinterrupt 220,uv_bau_message_interrupt
-END(uv_bau_message_intr1)
+apicinterrupt ERROR_APIC_VECTOR \
+	error_interrupt smp_error_interrupt
+apicinterrupt SPURIOUS_APIC_VECTOR \
+	spurious_interrupt smp_spurious_interrupt
 
-ENTRY(error_interrupt)
-	apicinterrupt ERROR_APIC_VECTOR,smp_error_interrupt
-END(error_interrupt)
+#ifdef CONFIG_PERF_COUNTERS
+apicinterrupt LOCAL_PERF_VECTOR \
+	perf_counter_interrupt smp_perf_counter_interrupt
+#endif
 
-ENTRY(spurious_interrupt)
-	apicinterrupt SPURIOUS_APIC_VECTOR,smp_spurious_interrupt
-END(spurious_interrupt)
-				
 /*
  * Exception entry points.
- */ 		
-	.macro zeroentry sym
+ */
+.macro zeroentry sym do_sym
+ENTRY(\sym)
 	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq $0	/* push error code/oldrax */ 
-	CFI_ADJUST_CFA_OFFSET 8
-	pushq %rax	/* push real oldrax to the rdi slot */ 
-	CFI_ADJUST_CFA_OFFSET 8
-	CFI_REL_OFFSET rax,0
-	leaq  \sym(%rip),%rax
-	jmp error_entry
+	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
+	subq $15*8,%rsp
+	CFI_ADJUST_CFA_OFFSET 15*8
+	call error_entry
+	DEFAULT_FRAME 0
+	movq %rsp,%rdi		/* pt_regs pointer */
+	xorl %esi,%esi		/* no error code */
+	call \do_sym
+	jmp error_exit		/* %ebx: no swapgs flag */
 	CFI_ENDPROC
-	.endm	
+END(\sym)
+.endm
 
-	.macro errorentry sym
-	XCPT_FRAME
+.macro paranoidzeroentry sym do_sym
+ENTRY(\sym)
+	INTR_FRAME
 	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq %rax
+	pushq $-1		/* ORIG_RAX: no syscall to restart */
 	CFI_ADJUST_CFA_OFFSET 8
-	CFI_REL_OFFSET rax,0
-	leaq  \sym(%rip),%rax
-	jmp error_entry
+	subq $15*8, %rsp
+	call save_paranoid
+	TRACE_IRQS_OFF
+	movq %rsp,%rdi		/* pt_regs pointer */
+	xorl %esi,%esi		/* no error code */
+	call \do_sym
+	jmp paranoid_exit	/* %ebx: no swapgs flag */
 	CFI_ENDPROC
-	.endm
+END(\sym)
+.endm
 
-	/* error code is on the stack already */
-	/* handle NMI like exceptions that can happen everywhere */
-	.macro paranoidentry sym, ist=0, irqtrace=1
-	SAVE_ALL
-	cld
-	movl $1,%ebx
-	movl  $MSR_GS_BASE,%ecx
-	rdmsr
-	testl %edx,%edx
-	js    1f
-	SWAPGS
-	xorl  %ebx,%ebx
-1:
-	.if \ist
-	movq	%gs:pda_data_offset, %rbp
-	.endif
-	.if \irqtrace
-	TRACE_IRQS_OFF
-	.endif
-	movq %rsp,%rdi
-	movq ORIG_RAX(%rsp),%rsi
-	movq $-1,ORIG_RAX(%rsp)
-	.if \ist
-	subq	$EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
-	.endif
-	call \sym
-	.if \ist
-	addq	$EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
-	.endif
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	.if \irqtrace
+.macro paranoidzeroentry_ist sym do_sym ist
+ENTRY(\sym)
+	INTR_FRAME
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
+	pushq $-1		/* ORIG_RAX: no syscall to restart */
+	CFI_ADJUST_CFA_OFFSET 8
+	subq $15*8, %rsp
+	call save_paranoid
 	TRACE_IRQS_OFF
-	.endif
-	.endm
+	movq %rsp,%rdi		/* pt_regs pointer */
+	xorl %esi,%esi		/* no error code */
+	movq %gs:pda_data_offset, %rbp
+	subq $EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
+	call \do_sym
+	addq $EXCEPTION_STKSZ, per_cpu__init_tss + TSS_ist + (\ist - 1) * 8(%rbp)
+	jmp paranoid_exit	/* %ebx: no swapgs flag */
+	CFI_ENDPROC
+END(\sym)
+.endm
 
-	/*
- 	 * "Paranoid" exit path from exception stack.
-  	 * Paranoid because this is used by NMIs and cannot take
-	 * any kernel state for granted.
-	 * We don't do kernel preemption checks here, because only
-	 * NMI should be common and it does not enable IRQs and
-	 * cannot get reschedule ticks.
-	 *
-	 * "trace" is 0 for the NMI handler only, because irq-tracing
-	 * is fundamentally NMI-unsafe. (we cannot change the soft and
-	 * hard flags at once, atomically)
-	 */
-	.macro paranoidexit trace=1
-	/* ebx:	no swapgs flag */
-paranoid_exit\trace:
-	testl %ebx,%ebx				/* swapgs needed? */
-	jnz paranoid_restore\trace
-	testl $3,CS(%rsp)
-	jnz   paranoid_userspace\trace
-paranoid_swapgs\trace:
-	.if \trace
-	TRACE_IRQS_IRETQ 0
-	.endif
-	SWAPGS_UNSAFE_STACK
-paranoid_restore\trace:
-	RESTORE_ALL 8
-	jmp irq_return
-paranoid_userspace\trace:
-	GET_THREAD_INFO(%rcx)
-	movl TI_flags(%rcx),%ebx
-	andl $_TIF_WORK_MASK,%ebx
-	jz paranoid_swapgs\trace
-	movq %rsp,%rdi			/* &pt_regs */
-	call sync_regs
-	movq %rax,%rsp			/* switch stack for scheduling */
-	testl $_TIF_NEED_RESCHED,%ebx
-	jnz paranoid_schedule\trace
-	movl %ebx,%edx			/* arg3: thread flags */
-	.if \trace
-	TRACE_IRQS_ON
-	.endif
-	ENABLE_INTERRUPTS(CLBR_NONE)
-	xorl %esi,%esi 			/* arg2: oldset */
-	movq %rsp,%rdi 			/* arg1: &pt_regs */
-	call do_notify_resume
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	.if \trace
-	TRACE_IRQS_OFF
-	.endif
-	jmp paranoid_userspace\trace
-paranoid_schedule\trace:
-	.if \trace
-	TRACE_IRQS_ON
-	.endif
-	ENABLE_INTERRUPTS(CLBR_ANY)
-	call schedule
-	DISABLE_INTERRUPTS(CLBR_ANY)
-	.if \trace
-	TRACE_IRQS_OFF
-	.endif
-	jmp paranoid_userspace\trace
+.macro errorentry sym do_sym
+ENTRY(\sym)
+	XCPT_FRAME
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
+	subq $15*8,%rsp
+	CFI_ADJUST_CFA_OFFSET 15*8
+	call error_entry
+	DEFAULT_FRAME 0
+	movq %rsp,%rdi			/* pt_regs pointer */
+	movq ORIG_RAX(%rsp),%rsi	/* get error code */
+	movq $-1,ORIG_RAX(%rsp)		/* no syscall to restart */
+	call \do_sym
+	jmp error_exit			/* %ebx: no swapgs flag */
 	CFI_ENDPROC
-	.endm
+END(\sym)
+.endm
 
-/*
- * Exception entry point. This expects an error code/orig_rax on the stack
- * and the exception handler in %rax.	
- */ 		  				
-KPROBE_ENTRY(error_entry)
-	_frame RDI
-	CFI_REL_OFFSET rax,0
-	/* rdi slot contains rax, oldrax contains error code */
-	cld	
-	subq  $14*8,%rsp
-	CFI_ADJUST_CFA_OFFSET	(14*8)
-	movq %rsi,13*8(%rsp)
-	CFI_REL_OFFSET	rsi,RSI
-	movq 14*8(%rsp),%rsi	/* load rax from rdi slot */
-	CFI_REGISTER	rax,rsi
-	movq %rdx,12*8(%rsp)
-	CFI_REL_OFFSET	rdx,RDX
-	movq %rcx,11*8(%rsp)
-	CFI_REL_OFFSET	rcx,RCX
-	movq %rsi,10*8(%rsp)	/* store rax */ 
-	CFI_REL_OFFSET	rax,RAX
-	movq %r8, 9*8(%rsp)
-	CFI_REL_OFFSET	r8,R8
-	movq %r9, 8*8(%rsp)
-	CFI_REL_OFFSET	r9,R9
-	movq %r10,7*8(%rsp)
-	CFI_REL_OFFSET	r10,R10
-	movq %r11,6*8(%rsp)
-	CFI_REL_OFFSET	r11,R11
-	movq %rbx,5*8(%rsp) 
-	CFI_REL_OFFSET	rbx,RBX
-	movq %rbp,4*8(%rsp) 
-	CFI_REL_OFFSET	rbp,RBP
-	movq %r12,3*8(%rsp) 
-	CFI_REL_OFFSET	r12,R12
-	movq %r13,2*8(%rsp) 
-	CFI_REL_OFFSET	r13,R13
-	movq %r14,1*8(%rsp) 
-	CFI_REL_OFFSET	r14,R14
-	movq %r15,(%rsp) 
-	CFI_REL_OFFSET	r15,R15
-	xorl %ebx,%ebx	
-	testl $3,CS(%rsp)
-	je  error_kernelspace
-error_swapgs:	
-	SWAPGS
-error_sti:
-	TRACE_IRQS_OFF
-	movq %rdi,RDI(%rsp) 	
-	CFI_REL_OFFSET	rdi,RDI
-	movq %rsp,%rdi
-	movq ORIG_RAX(%rsp),%rsi	/* get error code */ 
-	movq $-1,ORIG_RAX(%rsp)
-	call *%rax
-	/* ebx:	no swapgs flag (1: don't need swapgs, 0: need it) */
-error_exit:
-	movl %ebx,%eax
-	RESTORE_REST
-	DISABLE_INTERRUPTS(CLBR_NONE)
+	/* error code is on the stack already */
+.macro paranoiderrorentry sym do_sym
+ENTRY(\sym)
+	XCPT_FRAME
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
+	subq $15*8,%rsp
+	CFI_ADJUST_CFA_OFFSET 15*8
+	call save_paranoid
+	DEFAULT_FRAME 0
 	TRACE_IRQS_OFF
-	GET_THREAD_INFO(%rcx)	
-	testl %eax,%eax
-	jne  retint_kernel
-	LOCKDEP_SYS_EXIT_IRQ
-	movl  TI_flags(%rcx),%edx
-	movl  $_TIF_WORK_MASK,%edi
-	andl  %edi,%edx
-	jnz  retint_careful
-	jmp retint_swapgs
+	movq %rsp,%rdi			/* pt_regs pointer */
+	movq ORIG_RAX(%rsp),%rsi	/* get error code */
+	movq $-1,ORIG_RAX(%rsp)		/* no syscall to restart */
+	call \do_sym
+	jmp paranoid_exit		/* %ebx: no swapgs flag */
 	CFI_ENDPROC
+END(\sym)
+.endm
 
-error_kernelspace:
-	incl %ebx
-       /* There are two places in the kernel that can potentially fault with
-          usergs. Handle them here. The exception handlers after
-	   iret run with kernel gs again, so don't set the user space flag.
-	   B stepping K8s sometimes report an truncated RIP for IRET 
-	   exceptions returning to compat mode. Check for these here too. */
-	leaq irq_return(%rip),%rcx
-	cmpq %rcx,RIP(%rsp)
-	je   error_swapgs
-	movl %ecx,%ecx	/* zero extend */
-	cmpq %rcx,RIP(%rsp)
-	je   error_swapgs
-	cmpq $gs_change,RIP(%rsp)
-        je   error_swapgs
-	jmp  error_sti
-KPROBE_END(error_entry)
-	
-       /* Reload gs selector with exception handling */
-       /* edi:  new selector */ 
+zeroentry divide_error do_divide_error
+zeroentry overflow do_overflow
+zeroentry bounds do_bounds
+zeroentry invalid_op do_invalid_op
+zeroentry device_not_available do_device_not_available
+paranoiderrorentry double_fault do_double_fault
+zeroentry coprocessor_segment_overrun do_coprocessor_segment_overrun
+errorentry invalid_TSS do_invalid_TSS
+errorentry segment_not_present do_segment_not_present
+zeroentry spurious_interrupt_bug do_spurious_interrupt_bug
+zeroentry coprocessor_error do_coprocessor_error
+errorentry alignment_check do_alignment_check
+zeroentry simd_coprocessor_error do_simd_coprocessor_error
+
+	/* Reload gs selector with exception handling */
+	/* edi:  new selector */
 ENTRY(native_load_gs_index)
 	CFI_STARTPROC
 	pushf
 	CFI_ADJUST_CFA_OFFSET 8
 	DISABLE_INTERRUPTS(CLBR_ANY | ~(CLBR_RDI))
-        SWAPGS
-gs_change:     
-        movl %edi,%gs   
+	SWAPGS
+gs_change:
+	movl %edi,%gs
 2:	mfence		/* workaround */
 	SWAPGS
-        popf
+	popf
 	CFI_ADJUST_CFA_OFFSET -8
-        ret
+	ret
 	CFI_ENDPROC
-ENDPROC(native_load_gs_index)
-       
-        .section __ex_table,"a"
-        .align 8
-        .quad gs_change,bad_gs
-        .previous
-        .section .fixup,"ax"
+END(native_load_gs_index)
+
+	.section __ex_table,"a"
+	.align 8
+	.quad gs_change,bad_gs
+	.previous
+	.section .fixup,"ax"
 	/* running with kernelgs */
-bad_gs: 
+bad_gs:
 	SWAPGS			/* switch back to user gs */
 	xorl %eax,%eax
-        movl %eax,%gs
-        jmp  2b
-        .previous       
-	
+	movl %eax,%gs
+	jmp  2b
+	.previous
+
 /*
  * Create a kernel thread.
  *
@@ -1138,7 +1149,7 @@ ENTRY(kernel_thread)
 
 	xorl %r8d,%r8d
 	xorl %r9d,%r9d
-	
+
 	# clone now
 	call do_fork
 	movq %rax,RAX(%rsp)
@@ -1149,15 +1160,15 @@ ENTRY(kernel_thread)
 	 * so internally to the x86_64 port you can rely on kernel_thread()
 	 * not to reschedule the child before returning, this avoids the need
 	 * of hacks for example to fork off the per-CPU idle tasks.
-         * [Hopefully no generic code relies on the reschedule -AK]	
+	 * [Hopefully no generic code relies on the reschedule -AK]
 	 */
 	RESTORE_ALL
 	UNFAKE_STACK_FRAME
 	ret
 	CFI_ENDPROC
-ENDPROC(kernel_thread)
-	
-child_rip:
+END(kernel_thread)
+
+ENTRY(child_rip)
 	pushq $0		# fake return address
 	CFI_STARTPROC
 	/*
@@ -1170,8 +1181,9 @@ child_rip:
 	# exit
 	mov %eax, %edi
 	call do_exit
+	ud2			# padding for call trace
 	CFI_ENDPROC
-ENDPROC(child_rip)
+END(child_rip)
 
 /*
  * execve(). This function needs to use IRET, not SYSRET, to set up all state properly.
@@ -1191,10 +1203,10 @@ ENDPROC(child_rip)
 ENTRY(kernel_execve)
 	CFI_STARTPROC
 	FAKE_STACK_FRAME $0
-	SAVE_ALL	
+	SAVE_ALL
 	movq %rsp,%rcx
 	call sys_execve
-	movq %rax, RAX(%rsp)	
+	movq %rax, RAX(%rsp)
 	RESTORE_REST
 	testq %rax,%rax
 	je int_ret_from_sys_call
@@ -1202,129 +1214,7 @@ ENTRY(kernel_execve)
 	UNFAKE_STACK_FRAME
 	ret
 	CFI_ENDPROC
-ENDPROC(kernel_execve)
-
-KPROBE_ENTRY(page_fault)
-	errorentry do_page_fault
-KPROBE_END(page_fault)
-
-ENTRY(coprocessor_error)
-	zeroentry do_coprocessor_error
-END(coprocessor_error)
-
-ENTRY(simd_coprocessor_error)
-	zeroentry do_simd_coprocessor_error	
-END(simd_coprocessor_error)
-
-ENTRY(device_not_available)
-	zeroentry do_device_not_available
-END(device_not_available)
-
-	/* runs on exception stack */
-KPROBE_ENTRY(debug)
- 	INTR_FRAME
-	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq $0
-	CFI_ADJUST_CFA_OFFSET 8		
-	paranoidentry do_debug, DEBUG_STACK
-	paranoidexit
-KPROBE_END(debug)
-
-	/* runs on exception stack */	
-KPROBE_ENTRY(nmi)
-	INTR_FRAME
-	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq $-1
-	CFI_ADJUST_CFA_OFFSET 8
-	paranoidentry do_nmi, 0, 0
-#ifdef CONFIG_TRACE_IRQFLAGS
-	paranoidexit 0
-#else
-	jmp paranoid_exit1
- 	CFI_ENDPROC
-#endif
-KPROBE_END(nmi)
-
-KPROBE_ENTRY(int3)
- 	INTR_FRAME
-	PARAVIRT_ADJUST_EXCEPTION_FRAME
- 	pushq $0
- 	CFI_ADJUST_CFA_OFFSET 8
- 	paranoidentry do_int3, DEBUG_STACK
- 	jmp paranoid_exit1
- 	CFI_ENDPROC
-KPROBE_END(int3)
-
-ENTRY(overflow)
-	zeroentry do_overflow
-END(overflow)
-
-ENTRY(bounds)
-	zeroentry do_bounds
-END(bounds)
-
-ENTRY(invalid_op)
-	zeroentry do_invalid_op	
-END(invalid_op)
-
-ENTRY(coprocessor_segment_overrun)
-	zeroentry do_coprocessor_segment_overrun
-END(coprocessor_segment_overrun)
-
-	/* runs on exception stack */
-ENTRY(double_fault)
-	XCPT_FRAME
-	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	paranoidentry do_double_fault
-	jmp paranoid_exit1
-	CFI_ENDPROC
-END(double_fault)
-
-ENTRY(invalid_TSS)
-	errorentry do_invalid_TSS
-END(invalid_TSS)
-
-ENTRY(segment_not_present)
-	errorentry do_segment_not_present
-END(segment_not_present)
-
-	/* runs on exception stack */
-ENTRY(stack_segment)
-	XCPT_FRAME
-	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	paranoidentry do_stack_segment
-	jmp paranoid_exit1
-	CFI_ENDPROC
-END(stack_segment)
-
-KPROBE_ENTRY(general_protection)
-	errorentry do_general_protection
-KPROBE_END(general_protection)
-
-ENTRY(alignment_check)
-	errorentry do_alignment_check
-END(alignment_check)
-
-ENTRY(divide_error)
-	zeroentry do_divide_error
-END(divide_error)
-
-ENTRY(spurious_interrupt_bug)
-	zeroentry do_spurious_interrupt_bug
-END(spurious_interrupt_bug)
-
-#ifdef CONFIG_X86_MCE
-	/* runs on exception stack */
-ENTRY(machine_check)
-	INTR_FRAME
-	PARAVIRT_ADJUST_EXCEPTION_FRAME
-	pushq $0
-	CFI_ADJUST_CFA_OFFSET 8	
-	paranoidentry do_machine_check
-	jmp paranoid_exit1
-	CFI_ENDPROC
-END(machine_check)
-#endif
+END(kernel_execve)
 
 /* Call softirq on interrupt stack. Interrupts are off. */
 ENTRY(call_softirq)
@@ -1344,40 +1234,33 @@ ENTRY(call_softirq)
 	decl %gs:pda_irqcount
 	ret
 	CFI_ENDPROC
-ENDPROC(call_softirq)
-
-KPROBE_ENTRY(ignore_sysret)
-	CFI_STARTPROC
-	mov $-ENOSYS,%eax
-	sysret
-	CFI_ENDPROC
-ENDPROC(ignore_sysret)
+END(call_softirq)
 
 #ifdef CONFIG_XEN
-ENTRY(xen_hypervisor_callback)
-	zeroentry xen_do_hypervisor_callback
-END(xen_hypervisor_callback)
+zeroentry xen_hypervisor_callback xen_do_hypervisor_callback
 
 /*
-# A note on the "critical region" in our callback handler.
-# We want to avoid stacking callback handlers due to events occurring
-# during handling of the last event. To do this, we keep events disabled
-# until we've done all processing. HOWEVER, we must enable events before
-# popping the stack frame (can't be done atomically) and so it would still
-# be possible to get enough handler activations to overflow the stack.
-# Although unlikely, bugs of that kind are hard to track down, so we'd
-# like to avoid the possibility.
-# So, on entry to the handler we detect whether we interrupted an
-# existing activation in its critical region -- if so, we pop the current
-# activation and restart the handler using the previous one.
-*/
+ * A note on the "critical region" in our callback handler.
+ * We want to avoid stacking callback handlers due to events occurring
+ * during handling of the last event. To do this, we keep events disabled
+ * until we've done all processing. HOWEVER, we must enable events before
+ * popping the stack frame (can't be done atomically) and so it would still
+ * be possible to get enough handler activations to overflow the stack.
+ * Although unlikely, bugs of that kind are hard to track down, so we'd
+ * like to avoid the possibility.
+ * So, on entry to the handler we detect whether we interrupted an
+ * existing activation in its critical region -- if so, we pop the current
+ * activation and restart the handler using the previous one.
+ */
 ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 	CFI_STARTPROC
-/* Since we don't modify %rdi, evtchn_do_upall(struct *pt_regs) will
-   see the correct pointer to the pt_regs */
+/*
+ * Since we don't modify %rdi, evtchn_do_upall(struct *pt_regs) will
+ * see the correct pointer to the pt_regs
+ */
 	movq %rdi, %rsp            # we don't return, adjust the stack frame
 	CFI_ENDPROC
-	CFI_DEFAULT_STACK
+	DEFAULT_FRAME
 11:	incl %gs:pda_irqcount
 	movq %rsp,%rbp
 	CFI_DEF_CFA_REGISTER rbp
@@ -1392,23 +1275,26 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
 END(do_hypervisor_callback)
 
 /*
-# Hypervisor uses this for application faults while it executes.
-# We get here for two reasons:
-#  1. Fault while reloading DS, ES, FS or GS
-#  2. Fault while executing IRET
-# Category 1 we do not need to fix up as Xen has already reloaded all segment
-# registers that could be reloaded and zeroed the others.
-# Category 2 we fix up by killing the current process. We cannot use the
-# normal Linux return path in this case because if we use the IRET hypercall
-# to pop the stack frame we end up in an infinite loop of failsafe callbacks.
-# We distinguish between categories by comparing each saved segment register
-# with its current contents: any discrepancy means we in category 1.
-*/
+ * Hypervisor uses this for application faults while it executes.
+ * We get here for two reasons:
+ *  1. Fault while reloading DS, ES, FS or GS
+ *  2. Fault while executing IRET
+ * Category 1 we do not need to fix up as Xen has already reloaded all segment
+ * registers that could be reloaded and zeroed the others.
+ * Category 2 we fix up by killing the current process. We cannot use the
+ * normal Linux return path in this case because if we use the IRET hypercall
+ * to pop the stack frame we end up in an infinite loop of failsafe callbacks.
+ * We distinguish between categories by comparing each saved segment register
+ * with its current contents: any discrepancy means we in category 1.
+ */
 ENTRY(xen_failsafe_callback)
-	framesz = (RIP-0x30)	/* workaround buggy gas */
-	_frame framesz
-	CFI_REL_OFFSET rcx, 0
-	CFI_REL_OFFSET r11, 8
+	INTR_FRAME 1 (6*8)
+	/*CFI_REL_OFFSET gs,GS*/
+	/*CFI_REL_OFFSET fs,FS*/
+	/*CFI_REL_OFFSET es,ES*/
+	/*CFI_REL_OFFSET ds,DS*/
+	CFI_REL_OFFSET r11,8
+	CFI_REL_OFFSET rcx,0
 	movw %ds,%cx
 	cmpw %cx,0x10(%rsp)
 	CFI_REMEMBER_STATE
@@ -1429,12 +1315,9 @@ ENTRY(xen_failsafe_callback)
 	CFI_RESTORE r11
 	addq $0x30,%rsp
 	CFI_ADJUST_CFA_OFFSET -0x30
-	pushq $0
-	CFI_ADJUST_CFA_OFFSET 8
-	pushq %r11
-	CFI_ADJUST_CFA_OFFSET 8
-	pushq %rcx
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi $0	/* RIP */
+	pushq_cfi %r11
+	pushq_cfi %rcx
 	jmp general_protection
 	CFI_RESTORE_STATE
 1:	/* Segment mismatch => Category 1 (Bad segment). Retry the IRET. */
@@ -1444,11 +1327,223 @@ ENTRY(xen_failsafe_callback)
 	CFI_RESTORE r11
 	addq $0x30,%rsp
 	CFI_ADJUST_CFA_OFFSET -0x30
-	pushq $0
-	CFI_ADJUST_CFA_OFFSET 8
+	pushq_cfi $0
 	SAVE_ALL
 	jmp error_exit
 	CFI_ENDPROC
 END(xen_failsafe_callback)
 
 #endif /* CONFIG_XEN */
+
+/*
+ * Some functions should be protected against kprobes
+ */
+	.pushsection .kprobes.text, "ax"
+
+paranoidzeroentry_ist debug do_debug DEBUG_STACK
+paranoidzeroentry_ist int3 do_int3 DEBUG_STACK
+paranoiderrorentry stack_segment do_stack_segment
+errorentry general_protection do_general_protection
+errorentry page_fault do_page_fault
+#ifdef CONFIG_X86_MCE
+paranoidzeroentry machine_check do_machine_check
+#endif
+
+	/*
+	 * "Paranoid" exit path from exception stack.
+	 * Paranoid because this is used by NMIs and cannot take
+	 * any kernel state for granted.
+	 * We don't do kernel preemption checks here, because only
+	 * NMI should be common and it does not enable IRQs and
+	 * cannot get reschedule ticks.
+	 *
+	 * "trace" is 0 for the NMI handler only, because irq-tracing
+	 * is fundamentally NMI-unsafe. (we cannot change the soft and
+	 * hard flags at once, atomically)
+	 */
+
+	/* ebx:	no swapgs flag */
+ENTRY(paranoid_exit)
+	INTR_FRAME
+	DISABLE_INTERRUPTS(CLBR_NONE)
+	TRACE_IRQS_OFF
+	testl %ebx,%ebx				/* swapgs needed? */
+	jnz paranoid_restore
+	testl $3,CS(%rsp)
+	jnz   paranoid_userspace
+paranoid_swapgs:
+	TRACE_IRQS_IRETQ 0
+	SWAPGS_UNSAFE_STACK
+paranoid_restore:
+	RESTORE_ALL 8
+	jmp irq_return
+paranoid_userspace:
+	GET_THREAD_INFO(%rcx)
+	movl TI_flags(%rcx),%ebx
+	andl $_TIF_WORK_MASK,%ebx
+	jz paranoid_swapgs
+	movq %rsp,%rdi			/* &pt_regs */
+	call sync_regs
+	movq %rax,%rsp			/* switch stack for scheduling */
+	testl $_TIF_NEED_RESCHED,%ebx
+	jnz paranoid_schedule
+	movl %ebx,%edx			/* arg3: thread flags */
+	TRACE_IRQS_ON
+	ENABLE_INTERRUPTS(CLBR_NONE)
+	xorl %esi,%esi 			/* arg2: oldset */
+	movq %rsp,%rdi 			/* arg1: &pt_regs */
+	call do_notify_resume
+	DISABLE_INTERRUPTS(CLBR_NONE)
+	TRACE_IRQS_OFF
+	jmp paranoid_userspace
+paranoid_schedule:
+	TRACE_IRQS_ON
+	ENABLE_INTERRUPTS(CLBR_ANY)
+	call schedule
+	DISABLE_INTERRUPTS(CLBR_ANY)
+	TRACE_IRQS_OFF
+	jmp paranoid_userspace
+	CFI_ENDPROC
+END(paranoid_exit)
+
+/*
+ * Exception entry point. This expects an error code/orig_rax on the stack.
+ * returns in "no swapgs flag" in %ebx.
+ */
+ENTRY(error_entry)
+	XCPT_FRAME
+	CFI_ADJUST_CFA_OFFSET 15*8
+	/* oldrax contains error code */
+	cld
+	movq_cfi rdi, RDI+8
+	movq_cfi rsi, RSI+8
+	movq_cfi rdx, RDX+8
+	movq_cfi rcx, RCX+8
+	movq_cfi rax, RAX+8
+	movq_cfi  r8,  R8+8
+	movq_cfi  r9,  R9+8
+	movq_cfi r10, R10+8
+	movq_cfi r11, R11+8
+	movq_cfi rbx, RBX+8
+	movq_cfi rbp, RBP+8
+	movq_cfi r12, R12+8
+	movq_cfi r13, R13+8
+	movq_cfi r14, R14+8
+	movq_cfi r15, R15+8
+	xorl %ebx,%ebx
+	testl $3,CS+8(%rsp)
+	je error_kernelspace
+error_swapgs:
+	SWAPGS
+error_sti:
+	TRACE_IRQS_OFF
+	ret
+	CFI_ENDPROC
+
+/*
+ * There are two places in the kernel that can potentially fault with
+ * usergs. Handle them here. The exception handlers after iret run with
+ * kernel gs again, so don't set the user space flag. B stepping K8s
+ * sometimes report an truncated RIP for IRET exceptions returning to
+ * compat mode. Check for these here too.
+ */
+error_kernelspace:
+	incl %ebx
+	leaq irq_return(%rip),%rcx
+	cmpq %rcx,RIP+8(%rsp)
+	je error_swapgs
+	movl %ecx,%ecx	/* zero extend */
+	cmpq %rcx,RIP+8(%rsp)
+	je error_swapgs
+	cmpq $gs_change,RIP+8(%rsp)
+	je error_swapgs
+	jmp error_sti
+END(error_entry)
+
+
+/* ebx:	no swapgs flag (1: don't need swapgs, 0: need it) */
+ENTRY(error_exit)
+	DEFAULT_FRAME
+	movl %ebx,%eax
+	RESTORE_REST
+	DISABLE_INTERRUPTS(CLBR_NONE)
+	TRACE_IRQS_OFF
+	GET_THREAD_INFO(%rcx)
+	testl %eax,%eax
+	jne retint_kernel
+	LOCKDEP_SYS_EXIT_IRQ
+	movl TI_flags(%rcx),%edx
+	movl $_TIF_WORK_MASK,%edi
+	andl %edi,%edx
+	jnz retint_careful
+	jmp retint_swapgs
+	CFI_ENDPROC
+END(error_exit)
+
+
+	/* runs on exception stack */
+ENTRY(nmi)
+	INTR_FRAME
+	PARAVIRT_ADJUST_EXCEPTION_FRAME
+	pushq_cfi $-1
+	subq $15*8, %rsp
+	CFI_ADJUST_CFA_OFFSET 15*8
+	call save_paranoid
+	DEFAULT_FRAME 0
+	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
+	movq %rsp,%rdi
+	movq $-1,%rsi
+	call do_nmi
+#ifdef CONFIG_TRACE_IRQFLAGS
+	/* paranoidexit; without TRACE_IRQS_OFF */
+	/* ebx:	no swapgs flag */
+	DISABLE_INTERRUPTS(CLBR_NONE)
+	testl %ebx,%ebx				/* swapgs needed? */
+	jnz nmi_restore
+	testl $3,CS(%rsp)
+	jnz nmi_userspace
+nmi_swapgs:
+	SWAPGS_UNSAFE_STACK
+nmi_restore:
+	RESTORE_ALL 8
+	jmp irq_return
+nmi_userspace:
+	GET_THREAD_INFO(%rcx)
+	movl TI_flags(%rcx),%ebx
+	andl $_TIF_WORK_MASK,%ebx
+	jz nmi_swapgs
+	movq %rsp,%rdi			/* &pt_regs */
+	call sync_regs
+	movq %rax,%rsp			/* switch stack for scheduling */
+	testl $_TIF_NEED_RESCHED,%ebx
+	jnz nmi_schedule
+	movl %ebx,%edx			/* arg3: thread flags */
+	ENABLE_INTERRUPTS(CLBR_NONE)
+	xorl %esi,%esi 			/* arg2: oldset */
+	movq %rsp,%rdi 			/* arg1: &pt_regs */
+	call do_notify_resume
+	DISABLE_INTERRUPTS(CLBR_NONE)
+	jmp nmi_userspace
+nmi_schedule:
+	ENABLE_INTERRUPTS(CLBR_ANY)
+	call schedule
+	DISABLE_INTERRUPTS(CLBR_ANY)
+	jmp nmi_userspace
+	CFI_ENDPROC
+#else
+	jmp paranoid_exit
+	CFI_ENDPROC
+#endif
+END(nmi)
+
+ENTRY(ignore_sysret)
+	CFI_STARTPROC
+	mov $-ENOSYS,%eax
+	sysret
+	CFI_ENDPROC
+END(ignore_sysret)
+
+/*
+ * End of kprobes section
+ */
+	.popsection
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
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 60eb84e..1d3d0e7 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -18,7 +18,6 @@
 #include <asm/idle.h>
 #include <asm/smp.h>
 
-#ifdef CONFIG_DEBUG_STACKOVERFLOW
 /*
  * Probabilistic stack overflow check:
  *
@@ -28,19 +27,18 @@
  */
 static inline void stack_overflow_check(struct pt_regs *regs)
 {
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
 	u64 curbase = (u64)task_stack_page(current);
-	static unsigned long warned = -60*HZ;
-
-	if (regs->sp >= curbase && regs->sp <= curbase + THREAD_SIZE &&
-	    regs->sp <  curbase + sizeof(struct thread_info) + 128 &&
-	    time_after(jiffies, warned + 60*HZ)) {
-		printk("do_IRQ: %s near stack overflow (cur:%Lx,sp:%lx)\n",
-		       current->comm, curbase, regs->sp);
-		show_stack(NULL,NULL);
-		warned = jiffies;
-	}
-}
+
+	WARN_ONCE(regs->sp >= curbase &&
+		  regs->sp <= curbase + THREAD_SIZE &&
+		  regs->sp <  curbase + sizeof(struct thread_info) +
+					sizeof(struct pt_regs) + 128,
+
+		  "do_IRQ: %s near stack overflow (cur:%Lx,sp:%lx)\n",
+			current->comm, curbase, regs->sp);
 #endif
+}
 
 /*
  * do_IRQ handles all normal device IRQ's (the special
@@ -60,9 +58,7 @@ asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
 	irq_enter();
 	irq = __get_cpu_var(vector_irq)[vector];
 
-#ifdef CONFIG_DEBUG_STACKOVERFLOW
 	stack_overflow_check(regs);
-#endif
 
 	desc = irq_to_desc(irq);
 	if (likely(desc))
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 845aa98..6a33b5e 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -129,7 +129,7 @@ void __init native_init_IRQ(void)
 	for (i =  FIRST_EXTERNAL_VECTOR; i < NR_VECTORS; i++) {
 		/* SYSCALL_VECTOR was reserved in trap_init. */
 		if (i != SYSCALL_VECTOR)
-			set_intr_gate(i, interrupt[i]);
+			set_intr_gate(i, interrupt[i-FIRST_EXTERNAL_VECTOR]);
 	}
 
 
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
index ff02353..91d785c 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -24,41 +24,6 @@
 #include <asm/i8259.h>
 
 /*
- * Common place to define all x86 IRQ vectors
- *
- * This builds up the IRQ handler stubs using some ugly macros in irq.h
- *
- * These macros create the low-level assembly IRQ routines that save
- * register context and call do_IRQ(). do_IRQ() then does all the
- * operations that are needed to keep the AT (or SMP IOAPIC)
- * interrupt-controller happy.
- */
-
-#define IRQ_NAME2(nr) nr##_interrupt(void)
-#define IRQ_NAME(nr) IRQ_NAME2(IRQ##nr)
-
-/*
- *	SMP has a few special interrupts for IPI messages
- */
-
-#define BUILD_IRQ(nr)				\
-	asmlinkage void IRQ_NAME(nr);		\
-	asm("\n.text\n.p2align\n"		\
-	    "IRQ" #nr "_interrupt:\n\t"		\
-	    "push $~(" #nr ") ; "		\
-	    "jmp common_interrupt\n"		\
-	    ".previous");
-
-#define BI(x,y) \
-	BUILD_IRQ(x##y)
-
-#define BUILD_16_IRQS(x) \
-	BI(x,0) BI(x,1) BI(x,2) BI(x,3) \
-	BI(x,4) BI(x,5) BI(x,6) BI(x,7) \
-	BI(x,8) BI(x,9) BI(x,a) BI(x,b) \
-	BI(x,c) BI(x,d) BI(x,e) BI(x,f)
-
-/*
  * ISA PIC or low IO-APIC triggered (INTA-cycle or APIC) interrupts:
  * (these are usually mapped to vectors 0x30-0x3f)
  */
@@ -73,37 +38,6 @@
  *
  * (these are usually mapped into the 0x30-0xff vector range)
  */
-				      BUILD_16_IRQS(0x2) BUILD_16_IRQS(0x3)
-BUILD_16_IRQS(0x4) BUILD_16_IRQS(0x5) BUILD_16_IRQS(0x6) BUILD_16_IRQS(0x7)
-BUILD_16_IRQS(0x8) BUILD_16_IRQS(0x9) BUILD_16_IRQS(0xa) BUILD_16_IRQS(0xb)
-BUILD_16_IRQS(0xc) BUILD_16_IRQS(0xd) BUILD_16_IRQS(0xe) BUILD_16_IRQS(0xf)
-
-#undef BUILD_16_IRQS
-#undef BI
-
-
-#define IRQ(x,y) \
-	IRQ##x##y##_interrupt
-
-#define IRQLIST_16(x) \
-	IRQ(x,0), IRQ(x,1), IRQ(x,2), IRQ(x,3), \
-	IRQ(x,4), IRQ(x,5), IRQ(x,6), IRQ(x,7), \
-	IRQ(x,8), IRQ(x,9), IRQ(x,a), IRQ(x,b), \
-	IRQ(x,c), IRQ(x,d), IRQ(x,e), IRQ(x,f)
-
-/* for the irq vectors */
-static void (*__initdata interrupt[NR_VECTORS - FIRST_EXTERNAL_VECTOR])(void) = {
-					  IRQLIST_16(0x2), IRQLIST_16(0x3),
-	IRQLIST_16(0x4), IRQLIST_16(0x5), IRQLIST_16(0x6), IRQLIST_16(0x7),
-	IRQLIST_16(0x8), IRQLIST_16(0x9), IRQLIST_16(0xa), IRQLIST_16(0xb),
-	IRQLIST_16(0xc), IRQLIST_16(0xd), IRQLIST_16(0xe), IRQLIST_16(0xf)
-};
-
-#undef IRQ
-#undef IRQLIST_16
-
-
-
 
 /*
  * IRQ2 is cascade interrupt to second interrupt controller
@@ -204,6 +138,11 @@ static void __init apic_intr_init(void)
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
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal.c
similarity index 74%
rename from arch/x86/kernel/signal_32.c
rename to arch/x86/kernel/signal.c
index d6dd057..dee553c 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal.c
@@ -1,32 +1,37 @@
 /*
  *  Copyright (C) 1991, 1992  Linus Torvalds
+ *  Copyright (C) 2000, 2001, 2002 Andi Kleen SuSE Labs
  *
  *  1997-11-28  Modified for POSIX.1b signals by Richard Henderson
  *  2000-06-20  Pentium III FXSR, SSE support by Gareth Hughes
+ *  2000-2002   x86-64 support by Andi Kleen
  */
-#include <linux/list.h>
-
-#include <linux/personality.h>
-#include <linux/binfmts.h>
-#include <linux/suspend.h>
+#include <linux/perf_counter.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
 #include <linux/kernel.h>
-#include <linux/ptrace.h>
 #include <linux/signal.h>
-#include <linux/stddef.h>
-#include <linux/unistd.h>
 #include <linux/errno.h>
-#include <linux/sched.h>
 #include <linux/wait.h>
+#include <linux/ptrace.h>
 #include <linux/tracehook.h>
-#include <linux/elf.h>
-#include <linux/smp.h>
-#include <linux/mm.h>
+#include <linux/unistd.h>
+#include <linux/stddef.h>
+#include <linux/personality.h>
+#include <linux/uaccess.h>
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
-#include <asm/uaccess.h>
 #include <asm/i387.h>
 #include <asm/vdso.h>
+
+#ifdef CONFIG_X86_64
+#include <asm/proto.h>
+#include <asm/ia32_unistd.h>
+#include <asm/mce.h>
+#endif /* CONFIG_X86_64 */
+
 #include <asm/syscall.h>
 #include <asm/syscalls.h>
 
@@ -45,74 +50,6 @@
 # define FIX_EFLAGS	__FIX_EFLAGS
 #endif
 
-/*
- * Atomically swap in the new signal mask, and wait for a signal.
- */
-asmlinkage int
-sys_sigsuspend(int history0, int history1, old_sigset_t mask)
-{
-	mask &= _BLOCKABLE;
-	spin_lock_irq(&current->sighand->siglock);
-	current->saved_sigmask = current->blocked;
-	siginitset(&current->blocked, mask);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	current->state = TASK_INTERRUPTIBLE;
-	schedule();
-	set_restore_sigmask();
-
-	return -ERESTARTNOHAND;
-}
-
-asmlinkage int
-sys_sigaction(int sig, const struct old_sigaction __user *act,
-	      struct old_sigaction __user *oact)
-{
-	struct k_sigaction new_ka, old_ka;
-	int ret;
-
-	if (act) {
-		old_sigset_t mask;
-
-		if (!access_ok(VERIFY_READ, act, sizeof(*act)) ||
-		    __get_user(new_ka.sa.sa_handler, &act->sa_handler) ||
-		    __get_user(new_ka.sa.sa_restorer, &act->sa_restorer))
-			return -EFAULT;
-
-		__get_user(new_ka.sa.sa_flags, &act->sa_flags);
-		__get_user(mask, &act->sa_mask);
-		siginitset(&new_ka.sa.sa_mask, mask);
-	}
-
-	ret = do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
-
-	if (!ret && oact) {
-		if (!access_ok(VERIFY_WRITE, oact, sizeof(*oact)) ||
-		    __put_user(old_ka.sa.sa_handler, &oact->sa_handler) ||
-		    __put_user(old_ka.sa.sa_restorer, &oact->sa_restorer))
-			return -EFAULT;
-
-		__put_user(old_ka.sa.sa_flags, &oact->sa_flags);
-		__put_user(old_ka.sa.sa_mask.sig[0], &oact->sa_mask);
-	}
-
-	return ret;
-}
-
-asmlinkage int sys_sigaltstack(unsigned long bx)
-{
-	/*
-	 * This is needed to make gcc realize it doesn't own the
-	 * "struct pt_regs"
-	 */
-	struct pt_regs *regs = (struct pt_regs *)&bx;
-	const stack_t __user *uss = (const stack_t __user *)bx;
-	stack_t __user *uoss = (stack_t __user *)regs->cx;
-
-	return do_sigaltstack(uss, uoss, regs->sp);
-}
-
 #define COPY(x)			{		\
 	err |= __get_user(regs->x, &sc->x);	\
 }
@@ -123,7 +60,7 @@ asmlinkage int sys_sigaltstack(unsigned long bx)
 		regs->seg = tmp;			\
 }
 
-#define COPY_SEG_STRICT(seg)	{			\
+#define COPY_SEG_CPL3(seg)	{			\
 		unsigned short tmp;			\
 		err |= __get_user(tmp, &sc->seg);	\
 		regs->seg = tmp | 3;			\
@@ -135,9 +72,6 @@ asmlinkage int sys_sigaltstack(unsigned long bx)
 		loadsegment(seg, tmp);			\
 }
 
-/*
- * Do a signal return; undo the signal stack.
- */
 static int
 restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 		   unsigned long *pax)
@@ -149,14 +83,36 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	/* Always make any pending restarted system calls return -EINTR */
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
 
+#ifdef CONFIG_X86_32
 	GET_SEG(gs);
 	COPY_SEG(fs);
 	COPY_SEG(es);
 	COPY_SEG(ds);
+#endif /* CONFIG_X86_32 */
+
 	COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
 	COPY(dx); COPY(cx); COPY(ip);
-	COPY_SEG_STRICT(cs);
-	COPY_SEG_STRICT(ss);
+
+#ifdef CONFIG_X86_64
+	COPY(r8);
+	COPY(r9);
+	COPY(r10);
+	COPY(r11);
+	COPY(r12);
+	COPY(r13);
+	COPY(r14);
+	COPY(r15);
+#endif /* CONFIG_X86_64 */
+
+#ifdef CONFIG_X86_32
+	COPY_SEG_CPL3(cs);
+	COPY_SEG_CPL3(ss);
+#else /* !CONFIG_X86_32 */
+	/* Kernel saves and restores only the CS segment register on signals,
+	 * which is the bare minimum needed to allow mixed 32/64-bit code.
+	 * App's signal handler can save/restore other segments if needed. */
+	COPY_SEG_CPL3(cs);
+#endif /* CONFIG_X86_32 */
 
 	err |= __get_user(tmpflags, &sc->flags);
 	regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
@@ -169,102 +125,24 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	return err;
 }
 
-asmlinkage unsigned long sys_sigreturn(unsigned long __unused)
-{
-	struct sigframe __user *frame;
-	struct pt_regs *regs;
-	unsigned long ax;
-	sigset_t set;
-
-	regs = (struct pt_regs *) &__unused;
-	frame = (struct sigframe __user *)(regs->sp - 8);
-
-	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
-		goto badframe;
-	if (__get_user(set.sig[0], &frame->sc.oldmask) || (_NSIG_WORDS > 1
-		&& __copy_from_user(&set.sig[1], &frame->extramask,
-				    sizeof(frame->extramask))))
-		goto badframe;
-
-	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	if (restore_sigcontext(regs, &frame->sc, &ax))
-		goto badframe;
-	return ax;
-
-badframe:
-	if (show_unhandled_signals && printk_ratelimit()) {
-		printk("%s%s[%d] bad frame in sigreturn frame:"
-			"%p ip:%lx sp:%lx oeax:%lx",
-		    task_pid_nr(current) > 1 ? KERN_INFO : KERN_EMERG,
-		    current->comm, task_pid_nr(current), frame, regs->ip,
-		    regs->sp, regs->orig_ax);
-		print_vma_addr(" in ", regs->ip);
-		printk(KERN_CONT "\n");
-	}
-
-	force_sig(SIGSEGV, current);
-
-	return 0;
-}
-
-static long do_rt_sigreturn(struct pt_regs *regs)
-{
-	struct rt_sigframe __user *frame;
-	unsigned long ax;
-	sigset_t set;
-
-	frame = (struct rt_sigframe __user *)(regs->sp - sizeof(long));
-	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
-		goto badframe;
-	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
-		goto badframe;
-
-	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
-		goto badframe;
-
-	if (do_sigaltstack(&frame->uc.uc_stack, NULL, regs->sp) == -EFAULT)
-		goto badframe;
-
-	return ax;
-
-badframe:
-	signal_fault(regs, frame, "rt_sigreturn");
-	return 0;
-}
-
-asmlinkage int sys_rt_sigreturn(unsigned long __unused)
-{
-	struct pt_regs *regs = (struct pt_regs *)&__unused;
-
-	return do_rt_sigreturn(regs);
-}
-
-/*
- * Set up a signal frame.
- */
 static int
 setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 		 struct pt_regs *regs, unsigned long mask)
 {
-	int tmp, err = 0;
+	int err = 0;
 
-	err |= __put_user(regs->fs, (unsigned int __user *)&sc->fs);
-	savesegment(gs, tmp);
-	err |= __put_user(tmp, (unsigned int __user *)&sc->gs);
+#ifdef CONFIG_X86_32
+	{
+		unsigned int tmp;
 
+		savesegment(gs, tmp);
+		err |= __put_user(tmp, (unsigned int __user *)&sc->gs);
+	}
+	err |= __put_user(regs->fs, (unsigned int __user *)&sc->fs);
 	err |= __put_user(regs->es, (unsigned int __user *)&sc->es);
 	err |= __put_user(regs->ds, (unsigned int __user *)&sc->ds);
+#endif /* CONFIG_X86_32 */
+
 	err |= __put_user(regs->di, &sc->di);
 	err |= __put_user(regs->si, &sc->si);
 	err |= __put_user(regs->bp, &sc->bp);
@@ -273,19 +151,33 @@ setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 	err |= __put_user(regs->dx, &sc->dx);
 	err |= __put_user(regs->cx, &sc->cx);
 	err |= __put_user(regs->ax, &sc->ax);
+#ifdef CONFIG_X86_64
+	err |= __put_user(regs->r8, &sc->r8);
+	err |= __put_user(regs->r9, &sc->r9);
+	err |= __put_user(regs->r10, &sc->r10);
+	err |= __put_user(regs->r11, &sc->r11);
+	err |= __put_user(regs->r12, &sc->r12);
+	err |= __put_user(regs->r13, &sc->r13);
+	err |= __put_user(regs->r14, &sc->r14);
+	err |= __put_user(regs->r15, &sc->r15);
+#endif /* CONFIG_X86_64 */
+
 	err |= __put_user(current->thread.trap_no, &sc->trapno);
 	err |= __put_user(current->thread.error_code, &sc->err);
 	err |= __put_user(regs->ip, &sc->ip);
+#ifdef CONFIG_X86_32
 	err |= __put_user(regs->cs, (unsigned int __user *)&sc->cs);
 	err |= __put_user(regs->flags, &sc->flags);
 	err |= __put_user(regs->sp, &sc->sp_at_signal);
 	err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);
+#else /* !CONFIG_X86_32 */
+	err |= __put_user(regs->flags, &sc->flags);
+	err |= __put_user(regs->cs, &sc->cs);
+	err |= __put_user(0, &sc->gs);
+	err |= __put_user(0, &sc->fs);
+#endif /* CONFIG_X86_32 */
 
-	tmp = save_i387_xstate(fpstate);
-	if (tmp < 0)
-		err = 1;
-	else
-		err |= __put_user(tmp ? fpstate : NULL, &sc->fpstate);
+	err |= __put_user(fpstate, &sc->fpstate);
 
 	/* non-iBCS2 extensions.. */
 	err |= __put_user(mask, &sc->oldmask);
@@ -295,6 +187,32 @@ setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 }
 
 /*
+ * Set up a signal frame.
+ */
+#ifdef CONFIG_X86_32
+static const struct {
+	u16 poplmovl;
+	u32 val;
+	u16 int80;
+} __attribute__((packed)) retcode = {
+	0xb858,		/* popl %eax; movl $..., %eax */
+	__NR_sigreturn,
+	0x80cd,		/* int $0x80 */
+};
+
+static const struct {
+	u8  movl;
+	u32 val;
+	u16 int80;
+	u8  pad;
+} __attribute__((packed)) rt_retcode = {
+	0xb8,		/* movl $..., %eax */
+	__NR_rt_sigreturn,
+	0x80cd,		/* int $0x80 */
+	0
+};
+
+/*
  * Determine which stack to use..
  */
 static inline void __user *
@@ -328,6 +246,8 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 	if (used_math()) {
 		sp = sp - sig_xstate_size;
 		*fpstate = (struct _fpstate *) sp;
+		if (save_i387_xstate(*fpstate) < 0)
+			return (void __user *)-1L;
 	}
 
 	sp -= frame_size;
@@ -383,9 +303,7 @@ __setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 	 * reasons and because gdb uses it as a signature to notice
 	 * signal handler stack frames.
 	 */
-	err |= __put_user(0xb858, (short __user *)(frame->retcode+0));
-	err |= __put_user(__NR_sigreturn, (int __user *)(frame->retcode+2));
-	err |= __put_user(0x80cd, (short __user *)(frame->retcode+6));
+	err |= __put_user(*((u64 *)&retcode), (u64 *)frame->retcode);
 
 	if (err)
 		return -EFAULT;
@@ -454,9 +372,7 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	 * reasons and because gdb uses it as a signature to notice
 	 * signal handler stack frames.
 	 */
-	err |= __put_user(0xb8, (char __user *)(frame->retcode+0));
-	err |= __put_user(__NR_rt_sigreturn, (int __user *)(frame->retcode+1));
-	err |= __put_user(0x80cd, (short __user *)(frame->retcode+5));
+	err |= __put_user(*((u64 *)&rt_retcode), (u64 *)frame->retcode);
 
 	if (err)
 		return -EFAULT;
@@ -475,23 +391,298 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	return 0;
 }
+#else /* !CONFIG_X86_32 */
+/*
+ * Determine which stack to use..
+ */
+static void __user *
+get_stack(struct k_sigaction *ka, unsigned long sp, unsigned long size)
+{
+	/* Default to using normal stack - redzone*/
+	sp -= 128;
+
+	/* This is the X/Open sanctioned signal stack switching.  */
+	if (ka->sa.sa_flags & SA_ONSTACK) {
+		if (sas_ss_flags(sp) == 0)
+			sp = current->sas_ss_sp + current->sas_ss_size;
+	}
+
+	return (void __user *)round_down(sp - size, 64);
+}
+
+static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+			    sigset_t *set, struct pt_regs *regs)
+{
+	struct rt_sigframe __user *frame;
+	void __user *fp = NULL;
+	int err = 0;
+	struct task_struct *me = current;
+
+	if (used_math()) {
+		fp = get_stack(ka, regs->sp, sig_xstate_size);
+		frame = (void __user *)round_down(
+			(unsigned long)fp - sizeof(struct rt_sigframe), 16) - 8;
+
+		if (save_i387_xstate(fp) < 0)
+			return -EFAULT;
+	} else
+		frame = get_stack(ka, regs->sp, sizeof(struct rt_sigframe)) - 8;
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		return -EFAULT;
+
+	if (ka->sa.sa_flags & SA_SIGINFO) {
+		if (copy_siginfo_to_user(&frame->info, info))
+			return -EFAULT;
+	}
+
+	/* Create the ucontext.  */
+	if (cpu_has_xsave)
+		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
+	else
+		err |= __put_user(0, &frame->uc.uc_flags);
+	err |= __put_user(0, &frame->uc.uc_link);
+	err |= __put_user(me->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
+	err |= __put_user(sas_ss_flags(regs->sp),
+			  &frame->uc.uc_stack.ss_flags);
+	err |= __put_user(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
+	err |= setup_sigcontext(&frame->uc.uc_mcontext, fp, regs, set->sig[0]);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
+	/* Set up to return from userspace.  If provided, use a stub
+	   already in userspace.  */
+	/* x86-64 should always use SA_RESTORER. */
+	if (ka->sa.sa_flags & SA_RESTORER) {
+		err |= __put_user(ka->sa.sa_restorer, &frame->pretcode);
+	} else {
+		/* could use a vstub here */
+		return -EFAULT;
+	}
+
+	if (err)
+		return -EFAULT;
+
+	/* Set up registers for signal handler */
+	regs->di = sig;
+	/* In case the signal handler was declared without prototypes */
+	regs->ax = 0;
+
+	/* This also works for non SA_SIGINFO handlers because they expect the
+	   next argument after the signal number on the stack. */
+	regs->si = (unsigned long)&frame->info;
+	regs->dx = (unsigned long)&frame->uc;
+	regs->ip = (unsigned long) ka->sa.sa_handler;
+
+	regs->sp = (unsigned long)frame;
+
+	/* Set up the CS register to run signal handlers in 64-bit mode,
+	   even if the handler happens to be interrupting 32-bit code. */
+	regs->cs = __USER_CS;
+
+	return 0;
+}
+#endif /* CONFIG_X86_32 */
+
+#ifdef CONFIG_X86_32
+/*
+ * Atomically swap in the new signal mask, and wait for a signal.
+ */
+asmlinkage int
+sys_sigsuspend(int history0, int history1, old_sigset_t mask)
+{
+	mask &= _BLOCKABLE;
+	spin_lock_irq(&current->sighand->siglock);
+	current->saved_sigmask = current->blocked;
+	siginitset(&current->blocked, mask);
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	current->state = TASK_INTERRUPTIBLE;
+	schedule();
+	set_restore_sigmask();
+
+	return -ERESTARTNOHAND;
+}
+
+asmlinkage int
+sys_sigaction(int sig, const struct old_sigaction __user *act,
+	      struct old_sigaction __user *oact)
+{
+	struct k_sigaction new_ka, old_ka;
+	int ret;
+
+	if (act) {
+		old_sigset_t mask;
+
+		if (!access_ok(VERIFY_READ, act, sizeof(*act)) ||
+		    __get_user(new_ka.sa.sa_handler, &act->sa_handler) ||
+		    __get_user(new_ka.sa.sa_restorer, &act->sa_restorer))
+			return -EFAULT;
+
+		__get_user(new_ka.sa.sa_flags, &act->sa_flags);
+		__get_user(mask, &act->sa_mask);
+		siginitset(&new_ka.sa.sa_mask, mask);
+	}
+
+	ret = do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
+
+	if (!ret && oact) {
+		if (!access_ok(VERIFY_WRITE, oact, sizeof(*oact)) ||
+		    __put_user(old_ka.sa.sa_handler, &oact->sa_handler) ||
+		    __put_user(old_ka.sa.sa_restorer, &oact->sa_restorer))
+			return -EFAULT;
+
+		__put_user(old_ka.sa.sa_flags, &oact->sa_flags);
+		__put_user(old_ka.sa.sa_mask.sig[0], &oact->sa_mask);
+	}
+
+	return ret;
+}
+#endif /* CONFIG_X86_32 */
+
+#ifdef CONFIG_X86_32
+asmlinkage int sys_sigaltstack(unsigned long bx)
+{
+	/*
+	 * This is needed to make gcc realize it doesn't own the
+	 * "struct pt_regs"
+	 */
+	struct pt_regs *regs = (struct pt_regs *)&bx;
+	const stack_t __user *uss = (const stack_t __user *)bx;
+	stack_t __user *uoss = (stack_t __user *)regs->cx;
+
+	return do_sigaltstack(uss, uoss, regs->sp);
+}
+#else /* !CONFIG_X86_32 */
+asmlinkage long
+sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
+		struct pt_regs *regs)
+{
+	return do_sigaltstack(uss, uoss, regs->sp);
+}
+#endif /* CONFIG_X86_32 */
+
+/*
+ * Do a signal return; undo the signal stack.
+ */
+#ifdef CONFIG_X86_32
+asmlinkage unsigned long sys_sigreturn(unsigned long __unused)
+{
+	struct sigframe __user *frame;
+	struct pt_regs *regs;
+	unsigned long ax;
+	sigset_t set;
+
+	regs = (struct pt_regs *) &__unused;
+	frame = (struct sigframe __user *)(regs->sp - 8);
+
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+	if (__get_user(set.sig[0], &frame->sc.oldmask) || (_NSIG_WORDS > 1
+		&& __copy_from_user(&set.sig[1], &frame->extramask,
+				    sizeof(frame->extramask))))
+		goto badframe;
+
+	sigdelsetmask(&set, ~_BLOCKABLE);
+	spin_lock_irq(&current->sighand->siglock);
+	current->blocked = set;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (restore_sigcontext(regs, &frame->sc, &ax))
+		goto badframe;
+	return ax;
+
+badframe:
+	if (show_unhandled_signals && printk_ratelimit()) {
+		printk("%s%s[%d] bad frame in sigreturn frame:"
+			"%p ip:%lx sp:%lx oeax:%lx",
+		    task_pid_nr(current) > 1 ? KERN_INFO : KERN_EMERG,
+		    current->comm, task_pid_nr(current), frame, regs->ip,
+		    regs->sp, regs->orig_ax);
+		print_vma_addr(" in ", regs->ip);
+		printk(KERN_CONT "\n");
+	}
+
+	force_sig(SIGSEGV, current);
+
+	return 0;
+}
+#endif /* CONFIG_X86_32 */
+
+static long do_rt_sigreturn(struct pt_regs *regs)
+{
+	struct rt_sigframe __user *frame;
+	unsigned long ax;
+	sigset_t set;
+
+	frame = (struct rt_sigframe __user *)(regs->sp - sizeof(long));
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
+		goto badframe;
+
+	sigdelsetmask(&set, ~_BLOCKABLE);
+	spin_lock_irq(&current->sighand->siglock);
+	current->blocked = set;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
+		goto badframe;
+
+	if (do_sigaltstack(&frame->uc.uc_stack, NULL, regs->sp) == -EFAULT)
+		goto badframe;
+
+	return ax;
+
+badframe:
+	signal_fault(regs, frame, "rt_sigreturn");
+	return 0;
+}
+
+#ifdef CONFIG_X86_32
+asmlinkage int sys_rt_sigreturn(struct pt_regs regs)
+{
+	return do_rt_sigreturn(&regs);
+}
+#else /* !CONFIG_X86_32 */
+asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
+{
+	return do_rt_sigreturn(regs);
+}
+#endif /* CONFIG_X86_32 */
 
 /*
  * OK, we're invoking a handler:
  */
 static int signr_convert(int sig)
 {
+#ifdef CONFIG_X86_32
 	struct thread_info *info = current_thread_info();
 
 	if (info->exec_domain && info->exec_domain->signal_invmap && sig < 32)
 		return info->exec_domain->signal_invmap[sig];
+#endif /* CONFIG_X86_32 */
 	return sig;
 }
 
+#ifdef CONFIG_X86_32
+
 #define is_ia32	1
 #define ia32_setup_frame	__setup_frame
 #define ia32_setup_rt_frame	__setup_rt_frame
 
+#else /* !CONFIG_X86_32 */
+
+#ifdef CONFIG_IA32_EMULATION
+#define is_ia32	test_thread_flag(TIF_IA32)
+#else /* !CONFIG_IA32_EMULATION */
+#define is_ia32	0
+#endif /* CONFIG_IA32_EMULATION */
+
+#endif /* CONFIG_X86_32 */
+
 static int
 setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	       sigset_t *set, struct pt_regs *regs)
@@ -592,7 +783,13 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	return 0;
 }
 
+#ifdef CONFIG_X86_32
 #define NR_restart_syscall	__NR_restart_syscall
+#else /* !CONFIG_X86_32 */
+#define NR_restart_syscall	\
+	test_thread_flag(TIF_IA32) ? __NR_ia32_restart_syscall : __NR_restart_syscall
+#endif /* CONFIG_X86_32 */
+
 /*
  * Note that 'init' is a special process: it doesn't get signals it doesn't
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
@@ -694,6 +891,11 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
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
deleted file mode 100644
index a5c9627..0000000
--- a/arch/x86/kernel/signal_64.c
+++ /dev/null
@@ -1,516 +0,0 @@
-/*
- *  Copyright (C) 1991, 1992  Linus Torvalds
- *  Copyright (C) 2000, 2001, 2002 Andi Kleen SuSE Labs
- *
- *  1997-11-28  Modified for POSIX.1b signals by Richard Henderson
- *  2000-06-20  Pentium III FXSR, SSE support by Gareth Hughes
- *  2000-2002   x86-64 support by Andi Kleen
- */
-
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/smp.h>
-#include <linux/kernel.h>
-#include <linux/signal.h>
-#include <linux/errno.h>
-#include <linux/wait.h>
-#include <linux/ptrace.h>
-#include <linux/tracehook.h>
-#include <linux/unistd.h>
-#include <linux/stddef.h>
-#include <linux/personality.h>
-#include <linux/compiler.h>
-#include <linux/uaccess.h>
-
-#include <asm/processor.h>
-#include <asm/ucontext.h>
-#include <asm/i387.h>
-#include <asm/proto.h>
-#include <asm/ia32_unistd.h>
-#include <asm/mce.h>
-#include <asm/syscall.h>
-#include <asm/syscalls.h>
-#include "sigframe.h"
-
-#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
-
-#define __FIX_EFLAGS	(X86_EFLAGS_AC | X86_EFLAGS_OF | \
-			 X86_EFLAGS_DF | X86_EFLAGS_TF | X86_EFLAGS_SF | \
-			 X86_EFLAGS_ZF | X86_EFLAGS_AF | X86_EFLAGS_PF | \
-			 X86_EFLAGS_CF)
-
-#ifdef CONFIG_X86_32
-# define FIX_EFLAGS	(__FIX_EFLAGS | X86_EFLAGS_RF)
-#else
-# define FIX_EFLAGS	__FIX_EFLAGS
-#endif
-
-asmlinkage long
-sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
-		struct pt_regs *regs)
-{
-	return do_sigaltstack(uss, uoss, regs->sp);
-}
-
-#define COPY(x)			{		\
-	err |= __get_user(regs->x, &sc->x);	\
-}
-
-#define COPY_SEG_STRICT(seg)	{			\
-		unsigned short tmp;			\
-		err |= __get_user(tmp, &sc->seg);	\
-		regs->seg = tmp | 3;			\
-}
-
-/*
- * Do a signal return; undo the signal stack.
- */
-static int
-restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
-		   unsigned long *pax)
-{
-	void __user *buf;
-	unsigned int tmpflags;
-	unsigned int err = 0;
-
-	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
-
-	COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
-	COPY(dx); COPY(cx); COPY(ip);
-	COPY(r8);
-	COPY(r9);
-	COPY(r10);
-	COPY(r11);
-	COPY(r12);
-	COPY(r13);
-	COPY(r14);
-	COPY(r15);
-
-	/* Kernel saves and restores only the CS segment register on signals,
-	 * which is the bare minimum needed to allow mixed 32/64-bit code.
-	 * App's signal handler can save/restore other segments if needed. */
-	COPY_SEG_STRICT(cs);
-
-	err |= __get_user(tmpflags, &sc->flags);
-	regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
-	regs->orig_ax = -1;		/* disable syscall checks */
-
-	err |= __get_user(buf, &sc->fpstate);
-	err |= restore_i387_xstate(buf);
-
-	err |= __get_user(*pax, &sc->ax);
-	return err;
-}
-
-static long do_rt_sigreturn(struct pt_regs *regs)
-{
-	struct rt_sigframe __user *frame;
-	unsigned long ax;
-	sigset_t set;
-
-	frame = (struct rt_sigframe __user *)(regs->sp - sizeof(long));
-	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
-		goto badframe;
-	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
-		goto badframe;
-
-	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
-		goto badframe;
-
-	if (do_sigaltstack(&frame->uc.uc_stack, NULL, regs->sp) == -EFAULT)
-		goto badframe;
-
-	return ax;
-
-badframe:
-	signal_fault(regs, frame, "rt_sigreturn");
-	return 0;
-}
-
-asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
-{
-	return do_rt_sigreturn(regs);
-}
-
-/*
- * Set up a signal frame.
- */
-
-static inline int
-setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs,
-		unsigned long mask, struct task_struct *me)
-{
-	int err = 0;
-
-	err |= __put_user(regs->cs, &sc->cs);
-	err |= __put_user(0, &sc->gs);
-	err |= __put_user(0, &sc->fs);
-
-	err |= __put_user(regs->di, &sc->di);
-	err |= __put_user(regs->si, &sc->si);
-	err |= __put_user(regs->bp, &sc->bp);
-	err |= __put_user(regs->sp, &sc->sp);
-	err |= __put_user(regs->bx, &sc->bx);
-	err |= __put_user(regs->dx, &sc->dx);
-	err |= __put_user(regs->cx, &sc->cx);
-	err |= __put_user(regs->ax, &sc->ax);
-	err |= __put_user(regs->r8, &sc->r8);
-	err |= __put_user(regs->r9, &sc->r9);
-	err |= __put_user(regs->r10, &sc->r10);
-	err |= __put_user(regs->r11, &sc->r11);
-	err |= __put_user(regs->r12, &sc->r12);
-	err |= __put_user(regs->r13, &sc->r13);
-	err |= __put_user(regs->r14, &sc->r14);
-	err |= __put_user(regs->r15, &sc->r15);
-	err |= __put_user(me->thread.trap_no, &sc->trapno);
-	err |= __put_user(me->thread.error_code, &sc->err);
-	err |= __put_user(regs->ip, &sc->ip);
-	err |= __put_user(regs->flags, &sc->flags);
-	err |= __put_user(mask, &sc->oldmask);
-	err |= __put_user(me->thread.cr2, &sc->cr2);
-
-	return err;
-}
-
-/*
- * Determine which stack to use..
- */
-
-static void __user *
-get_stack(struct k_sigaction *ka, struct pt_regs *regs, unsigned long size)
-{
-	unsigned long sp;
-
-	/* Default to using normal stack - redzone*/
-	sp = regs->sp - 128;
-
-	/* This is the X/Open sanctioned signal stack switching.  */
-	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (sas_ss_flags(sp) == 0)
-			sp = current->sas_ss_sp + current->sas_ss_size;
-	}
-
-	return (void __user *)round_down(sp - size, 64);
-}
-
-static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			    sigset_t *set, struct pt_regs *regs)
-{
-	struct rt_sigframe __user *frame;
-	void __user *fp = NULL;
-	int err = 0;
-	struct task_struct *me = current;
-
-	if (used_math()) {
-		fp = get_stack(ka, regs, sig_xstate_size);
-		frame = (void __user *)round_down(
-			(unsigned long)fp - sizeof(struct rt_sigframe), 16) - 8;
-
-		if (save_i387_xstate(fp) < 0)
-			return -EFAULT;
-	} else
-		frame = get_stack(ka, regs, sizeof(struct rt_sigframe)) - 8;
-
-	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		return -EFAULT;
-
-	if (ka->sa.sa_flags & SA_SIGINFO) {
-		if (copy_siginfo_to_user(&frame->info, info))
-			return -EFAULT;
-	}
-
-	/* Create the ucontext.  */
-	if (cpu_has_xsave)
-		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
-	else
-		err |= __put_user(0, &frame->uc.uc_flags);
-	err |= __put_user(0, &frame->uc.uc_link);
-	err |= __put_user(me->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
-	err |= __put_user(sas_ss_flags(regs->sp),
-			  &frame->uc.uc_stack.ss_flags);
-	err |= __put_user(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
-	err |= setup_sigcontext(&frame->uc.uc_mcontext, regs, set->sig[0], me);
-	err |= __put_user(fp, &frame->uc.uc_mcontext.fpstate);
-	if (sizeof(*set) == 16) {
-		__put_user(set->sig[0], &frame->uc.uc_sigmask.sig[0]);
-		__put_user(set->sig[1], &frame->uc.uc_sigmask.sig[1]);
-	} else
-		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
-
-	/* Set up to return from userspace.  If provided, use a stub
-	   already in userspace.  */
-	/* x86-64 should always use SA_RESTORER. */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		err |= __put_user(ka->sa.sa_restorer, &frame->pretcode);
-	} else {
-		/* could use a vstub here */
-		return -EFAULT;
-	}
-
-	if (err)
-		return -EFAULT;
-
-	/* Set up registers for signal handler */
-	regs->di = sig;
-	/* In case the signal handler was declared without prototypes */
-	regs->ax = 0;
-
-	/* This also works for non SA_SIGINFO handlers because they expect the
-	   next argument after the signal number on the stack. */
-	regs->si = (unsigned long)&frame->info;
-	regs->dx = (unsigned long)&frame->uc;
-	regs->ip = (unsigned long) ka->sa.sa_handler;
-
-	regs->sp = (unsigned long)frame;
-
-	/* Set up the CS register to run signal handlers in 64-bit mode,
-	   even if the handler happens to be interrupting 32-bit code. */
-	regs->cs = __USER_CS;
-
-	return 0;
-}
-
-/*
- * OK, we're invoking a handler
- */
-static int signr_convert(int sig)
-{
-	return sig;
-}
-
-#ifdef CONFIG_IA32_EMULATION
-#define is_ia32	test_thread_flag(TIF_IA32)
-#else
-#define is_ia32	0
-#endif
-
-static int
-setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-	       sigset_t *set, struct pt_regs *regs)
-{
-	int usig = signr_convert(sig);
-	int ret;
-
-	/* Set up the stack frame */
-	if (is_ia32) {
-		if (ka->sa.sa_flags & SA_SIGINFO)
-			ret = ia32_setup_rt_frame(usig, ka, info, set, regs);
-		else
-			ret = ia32_setup_frame(usig, ka, set, regs);
-	} else
-		ret = __setup_rt_frame(sig, ka, info, set, regs);
-
-	if (ret) {
-		force_sigsegv(sig, current);
-		return -EFAULT;
-	}
-
-	return ret;
-}
-
-static int
-handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
-	      sigset_t *oldset, struct pt_regs *regs)
-{
-	int ret;
-
-	/* Are we from a system call? */
-	if (syscall_get_nr(current, regs) >= 0) {
-		/* If so, check system call restarting.. */
-		switch (syscall_get_error(current, regs)) {
-		case -ERESTART_RESTARTBLOCK:
-		case -ERESTARTNOHAND:
-			regs->ax = -EINTR;
-			break;
-
-		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
-				regs->ax = -EINTR;
-				break;
-			}
-		/* fallthrough */
-		case -ERESTARTNOINTR:
-			regs->ax = regs->orig_ax;
-			regs->ip -= 2;
-			break;
-		}
-	}
-
-	/*
-	 * If TF is set due to a debugger (TIF_FORCED_TF), clear the TF
-	 * flag so that register information in the sigcontext is correct.
-	 */
-	if (unlikely(regs->flags & X86_EFLAGS_TF) &&
-	    likely(test_and_clear_thread_flag(TIF_FORCED_TF)))
-		regs->flags &= ~X86_EFLAGS_TF;
-
-	ret = setup_rt_frame(sig, ka, info, oldset, regs);
-
-	if (ret)
-		return ret;
-
-#ifdef CONFIG_X86_64
-	/*
-	 * This has nothing to do with segment registers,
-	 * despite the name.  This magic affects uaccess.h
-	 * macros' behavior.  Reset it to the normal setting.
-	 */
-	set_fs(USER_DS);
-#endif
-
-	/*
-	 * Clear the direction flag as per the ABI for function entry.
-	 */
-	regs->flags &= ~X86_EFLAGS_DF;
-
-	/*
-	 * Clear TF when entering the signal handler, but
-	 * notify any tracer that was single-stepping it.
-	 * The tracer may want to single-step inside the
-	 * handler too.
-	 */
-	regs->flags &= ~X86_EFLAGS_TF;
-
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked, sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-
-	tracehook_signal_handler(sig, info, ka, regs,
-				 test_thread_flag(TIF_SINGLESTEP));
-
-	return 0;
-}
-
-#define NR_restart_syscall	\
-	test_thread_flag(TIF_IA32) ? __NR_ia32_restart_syscall : __NR_restart_syscall
-/*
- * Note that 'init' is a special process: it doesn't get signals it doesn't
- * want to handle. Thus you cannot kill init even with a SIGKILL even by
- * mistake.
- */
-static void do_signal(struct pt_regs *regs)
-{
-	struct k_sigaction ka;
-	siginfo_t info;
-	int signr;
-	sigset_t *oldset;
-
-	/*
-	 * We want the common case to go fast, which is why we may in certain
-	 * cases get here from kernel mode. Just return without doing anything
-	 * if so.
-	 * X86_32: vm86 regs switched out by assembly code before reaching
-	 * here, so testing against kernel CS suffices.
-	 */
-	if (!user_mode(regs))
-		return;
-
-	if (current_thread_info()->status & TS_RESTORE_SIGMASK)
-		oldset = &current->saved_sigmask;
-	else
-		oldset = &current->blocked;
-
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
-		/*
-		 * Re-enable any watchpoints before delivering the
-		 * signal to user space. The processor register will
-		 * have been cleared if the watchpoint triggered
-		 * inside the kernel.
-		 */
-		if (current->thread.debugreg7)
-			set_debugreg(current->thread.debugreg7, 7);
-
-		/* Whee! Actually deliver the signal.  */
-		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
-			/*
-			 * A signal was successfully delivered; the saved
-			 * sigmask will have been stored in the signal frame,
-			 * and will be restored by sigreturn, so we can simply
-			 * clear the TS_RESTORE_SIGMASK flag.
-			 */
-			current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-		}
-		return;
-	}
-
-	/* Did we come from a system call? */
-	if (syscall_get_nr(current, regs) >= 0) {
-		/* Restart the system call - no handlers present */
-		switch (syscall_get_error(current, regs)) {
-		case -ERESTARTNOHAND:
-		case -ERESTARTSYS:
-		case -ERESTARTNOINTR:
-			regs->ax = regs->orig_ax;
-			regs->ip -= 2;
-			break;
-
-		case -ERESTART_RESTARTBLOCK:
-			regs->ax = NR_restart_syscall;
-			regs->ip -= 2;
-			break;
-		}
-	}
-
-	/*
-	 * If there's no signal to deliver, we just put the saved sigmask
-	 * back.
-	 */
-	if (current_thread_info()->status & TS_RESTORE_SIGMASK) {
-		current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
-	}
-}
-
-/*
- * notification of userspace execution resumption
- * - triggered by the TIF_WORK_MASK flags
- */
-void
-do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
-{
-#if defined(CONFIG_X86_64) && defined(CONFIG_X86_MCE)
-	/* notify userspace of pending MCEs */
-	if (thread_info_flags & _TIF_MCE_NOTIFY)
-		mce_notify_user();
-#endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
-
-	/* deal with pending signal delivery */
-	if (thread_info_flags & _TIF_SIGPENDING)
-		do_signal(regs);
-
-	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
-		clear_thread_flag(TIF_NOTIFY_RESUME);
-		tracehook_notify_resume(regs);
-	}
-
-#ifdef CONFIG_X86_32
-	clear_thread_flag(TIF_IRET);
-#endif /* CONFIG_X86_32 */
-}
-
-void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
-{
-	struct task_struct *me = current;
-
-	if (show_unhandled_signals && printk_ratelimit()) {
-		printk(KERN_INFO
-		       "%s[%d] bad frame in %s frame:%p ip:%lx sp:%lx orax:%lx",
-		       me->comm, me->pid, where, frame,
-		       regs->ip, regs->sp, regs->orig_ax);
-		print_vma_addr(" in ", regs->ip);
-		printk(KERN_CONT "\n");
-	}
-
-	force_sig(SIGSEGV, me);
-}
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 18f9b19..d18537c 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -178,11 +178,7 @@ static void native_smp_send_stop(void)
 void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_resched_count++;
-#else
-	add_pda(irq_resched_count, 1);
-#endif
+	inc_irq_stat(irq_resched_count);
 }
 
 void smp_call_function_interrupt(struct pt_regs *regs)
@@ -190,11 +186,7 @@ void smp_call_function_interrupt(struct pt_regs *regs)
 	ack_APIC_irq();
 	irq_enter();
 	generic_smp_call_function_interrupt();
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_call_count++;
-#else
-	add_pda(irq_call_count, 1);
-#endif
+	inc_irq_stat(irq_call_count);
 	irq_exit();
 }
 
@@ -203,11 +195,7 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 	ack_APIC_irq();
 	irq_enter();
 	generic_smp_call_function_single_interrupt();
-#ifdef CONFIG_X86_32
-	__get_cpu_var(irq_stat).irq_call_count++;
-#else
-	add_pda(irq_call_count, 1);
-#endif
+	inc_irq_stat(irq_call_count);
 	irq_exit();
 }
 
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index d44395f..496726d 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -332,3 +332,4 @@ ENTRY(sys_call_table)
 	.long sys_dup3			/* 330 */
 	.long sys_pipe2
 	.long sys_inotify_init1
+	.long sys_perf_counter_open
diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index cb19d65..418a095 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -80,6 +80,8 @@ unsigned long __init calibrate_cpu(void)
 			break;
 	no_ctr_free = (i == 4);
 	if (no_ctr_free) {
+		WARN(1, KERN_WARNING "Warning: AMD perfctrs busy ... "
+		     "cpu_khz value may be incorrect.\n");
 		i = 3;
 		rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
 		wrmsrl(MSR_K7_EVNTSEL3, 0);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 04d242a..d815293 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -481,11 +481,7 @@ do_nmi(struct pt_regs *regs, long error_code)
 {
 	nmi_enter();
 
-#ifdef CONFIG_X86_32
-	{ int cpu; cpu = smp_processor_id(); ++nmi_count(cpu); }
-#else
-	add_pda(__nmi_count, 1);
-#endif
+	inc_irq_stat(__nmi_count);
 
 	if (!ignore_nmis)
 		default_do_nmi(regs);
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 0b8b669..ebf2f12 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -128,7 +128,16 @@ static __always_inline void do_vgettimeofday(struct timeval * tv)
 			gettimeofday(tv,NULL);
 			return;
 		}
+
+		/*
+		 * Surround the RDTSC by barriers, to make sure it's not
+		 * speculated to outside the seqlock critical section and
+		 * does not cause time warps:
+		 */
+		rdtsc_barrier();
 		now = vread();
+		rdtsc_barrier();
+
 		base = __vsyscall_gtod_data.clock.cycle_last;
 		mask = __vsyscall_gtod_data.clock.mask;
 		mult = __vsyscall_gtod_data.clock.mult;
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index a5d8e1a..50a7792 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -590,7 +590,8 @@ static void __init lguest_init_IRQ(void)
 		 * a straightforward 1 to 1 mapping, so force that here. */
 		__get_cpu_var(vector_irq)[vector] = i;
 		if (vector != SYSCALL_VECTOR) {
-			set_intr_gate(vector, interrupt[vector]);
+			set_intr_gate(vector,
+				      interrupt[vector-FIRST_EXTERNAL_VECTOR]);
 			set_irq_chip_and_handler_name(i, &lguest_irq_controller,
 						      handle_level_irq,
 						      "level");
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c483f42..3ffed25 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -102,6 +102,8 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
 		set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
 		pud = pud_offset(pgd, 0);
 		BUG_ON(pmd_table != pmd_offset(pud, 0));
+
+		return pmd_table;
 	}
 #endif
 	pud = pud_offset(pgd, 0);
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index e9f80c7..07c9145 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -18,7 +18,7 @@
 #include <asm/msr.h>
 #include <asm/apic.h>
 #include <asm/nmi.h>
-#include <asm/intel_arch_perfmon.h>
+#include <asm/perf_counter.h>
 
 #include "op_x86_model.h"
 #include "op_counter.h"
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
diff --git a/fs/exec.c b/fs/exec.c
index ec5df9a..d5165d8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -33,6 +33,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
+#include <linux/perf_counter.h>
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
 #include <linux/key.h>
@@ -1017,6 +1018,13 @@ int flush_old_exec(struct linux_binprm * bprm)
 		set_dumpable(current->mm, suid_dumpable);
 	}
 
+	/*
+	 * Flush performance counters when crossing a
+	 * security domain:
+	 */
+	if (!get_dumpable(current->mm))
+		perf_counter_exit_task(current);
+
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
 
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 23fd890..467cff5 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -113,6 +113,16 @@ extern struct group_info init_groups;
 # define CAP_INIT_BSET  CAP_INIT_EFF_SET
 #endif
 
+#ifdef CONFIG_PERF_COUNTERS
+# define INIT_PERF_COUNTERS(tsk)					\
+	.perf_counter_ctx.counter_list =				\
+		LIST_HEAD_INIT(tsk.perf_counter_ctx.counter_list),	\
+	.perf_counter_ctx.lock =					\
+		__SPIN_LOCK_UNLOCKED(tsk.perf_counter_ctx.lock),
+#else
+# define INIT_PERF_COUNTERS(tsk)
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -180,6 +190,7 @@ extern struct group_info init_groups;
 	INIT_IDS							\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
+	INIT_PERF_COUNTERS(tsk)						\
 }
 
 
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 4a145ca..1b2e324 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -66,7 +66,15 @@ static inline unsigned int kstat_irqs(unsigned int irq)
 	return sum;
 }
 
+
+/*
+ * Lock/unlock the current runqueue - to extract task statistics:
+ */
+extern void curr_rq_lock_irq_save(unsigned long *flags);
+extern void curr_rq_unlock_irq_restore(unsigned long *flags);
+extern unsigned long long __task_delta_exec(struct task_struct *tsk, int update);
 extern unsigned long long task_delta_exec(struct task_struct *);
+
 extern void account_user_time(struct task_struct *, cputime_t);
 extern void account_user_time_scaled(struct task_struct *, cputime_t);
 extern void account_system_time(struct task_struct *, int, cputime_t);
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 9fd1f85..fee9e59 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -64,14 +64,6 @@
 	name:
 #endif
 
-#define KPROBE_ENTRY(name) \
-  .pushsection .kprobes.text, "ax"; \
-  ENTRY(name)
-
-#define KPROBE_END(name) \
-  END(name);		 \
-  .popsection
-
 #ifndef END
 #define END(name) \
   .size name, .-name
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
new file mode 100644
index 0000000..ec77d16
--- /dev/null
+++ b/include/linux/perf_counter.h
@@ -0,0 +1,254 @@
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
+#include <asm/perf_counter.h>
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
+	PERF_COUNT_CPU_CYCLES		=  0,
+	PERF_COUNT_INSTRUCTIONS		=  1,
+	PERF_COUNT_CACHE_REFERENCES	=  2,
+	PERF_COUNT_CACHE_MISSES		=  3,
+	PERF_COUNT_BRANCH_INSTRUCTIONS	=  4,
+	PERF_COUNT_BRANCH_MISSES	=  5,
+	PERF_COUNT_BUS_CYCLES		=  6,
+
+	PERF_HW_EVENTS_MAX		=  7,
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
+	int (*enable)			(struct perf_counter *counter);
+	void (*disable)			(struct perf_counter *counter);
+	void (*read)			(struct perf_counter *counter);
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
index 2d8be7e..101b7ee 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -153,6 +153,9 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 {
 	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
 
+#ifdef CONFIG_PERF_COUNTERS
+	WARN_ON_ONCE(!list_empty(&tsk->perf_counter_ctx.counter_list));
+#endif
 	trace_sched_process_free(tsk);
 	put_task_struct(tsk);
 }
@@ -1094,10 +1097,6 @@ NORET_TYPE void do_exit(long code)
 	tsk->mempolicy = NULL;
 #endif
 #ifdef CONFIG_FUTEX
-	/*
-	 * This must happen late, after the PID is not
-	 * hashed anymore:
-	 */
 	if (unlikely(!list_empty(&tsk->pi_state_list)))
 		exit_pi_state_list(tsk);
 	if (unlikely(current->pi_state_cache))
@@ -1363,6 +1362,12 @@ static int wait_task_zombie(struct task_struct *p, int options,
 	 */
 	read_unlock(&tasklist_lock);
 
+	/*
+	 * Flush inherited counters to the parent - before the parent
+	 * gets woken up by child-exit notifications.
+	 */
+	perf_counter_exit_task(p);
+
 	retval = ru ? getrusage(p, RUSAGE_BOTH, ru) : 0;
 	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
 		? p->signal->group_exit_code : p->exit_code;
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
index 0000000..d7a79f3
--- /dev/null
+++ b/kernel/perf_counter.c
@@ -0,0 +1,1686 @@
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
+#include <linux/kernel_stat.h>
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
+	curr_rq_lock_irq_save(&flags);
+	spin_lock(&ctx->lock);
+
+	if (counter->state == PERF_COUNTER_STATE_ACTIVE) {
+		counter->state = PERF_COUNTER_STATE_INACTIVE;
+		counter->hw_ops->disable(counter);
+		ctx->nr_active--;
+		cpuctx->active_oncpu--;
+		counter->task = NULL;
+		counter->oncpu = -1;
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
+	spin_unlock(&ctx->lock);
+	curr_rq_unlock_irq_restore(&flags);
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
+static int
+counter_sched_in(struct perf_counter *counter,
+		 struct perf_cpu_context *cpuctx,
+		 struct perf_counter_context *ctx,
+		 int cpu)
+{
+	if (counter->state == PERF_COUNTER_STATE_OFF)
+		return 0;
+
+	counter->state = PERF_COUNTER_STATE_ACTIVE;
+	counter->oncpu = cpu;	/* TODO: put 'cpu' into cpuctx->cpu */
+	/*
+	 * The new state must be visible before we turn it on in the hardware:
+	 */
+	smp_wmb();
+
+	if (counter->hw_ops->enable(counter)) {
+		counter->state = PERF_COUNTER_STATE_INACTIVE;
+		counter->oncpu = -1;
+		return -EAGAIN;
+	}
+
+	cpuctx->active_oncpu++;
+	ctx->nr_active++;
+
+	return 0;
+}
+
+/*
+ * Cross CPU call to install and enable a performance counter
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
+	curr_rq_lock_irq_save(&flags);
+	spin_lock(&ctx->lock);
+
+	/*
+	 * Protect the list operation against NMI by disabling the
+	 * counters on a global level. NOP for non NMI based counters.
+	 */
+	perf_flags = hw_perf_save_disable();
+
+	list_add_counter(counter, ctx);
+	ctx->nr_counters++;
+
+	counter_sched_in(counter, cpuctx, ctx, cpu);
+
+	if (!ctx->task && cpuctx->max_pertask)
+		cpuctx->max_pertask--;
+
+	hw_perf_restore(perf_flags);
+
+	spin_unlock(&ctx->lock);
+	curr_rq_unlock_irq_restore(&flags);
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
+	counter->state = PERF_COUNTER_STATE_INACTIVE;
+	counter->hw_ops->disable(counter);
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
+void __perf_counter_sched_out(struct perf_counter_context *ctx,
+			      struct perf_cpu_context *cpuctx)
+{
+	struct perf_counter *counter;
+
+	if (likely(!ctx->nr_counters))
+		return;
+
+	spin_lock(&ctx->lock);
+	if (ctx->nr_active) {
+		list_for_each_entry(counter, &ctx->counter_list, list_entry)
+			group_sched_out(counter, cpuctx, ctx);
+	}
+	spin_unlock(&ctx->lock);
+}
+
+/*
+ * Called from scheduler to remove the counters of the current task,
+ * with interrupts disabled.
+ *
+ * We stop each counter and update the counter value in counter->count.
+ *
+ * This does not protect us against NMI, but disable()
+ * sets the disabled bit in the control field of counter _before_
+ * accessing the counter control register. If a NMI hits, then it will
+ * not restart the counter.
+ */
+void perf_counter_task_sched_out(struct task_struct *task, int cpu)
+{
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_counter_context *ctx = &task->perf_counter_ctx;
+
+	if (likely(!cpuctx->task_ctx))
+		return;
+
+	__perf_counter_sched_out(ctx, cpuctx);
+
+	cpuctx->task_ctx = NULL;
+}
+
+static void perf_counter_cpu_sched_out(struct perf_cpu_context *cpuctx)
+{
+	__perf_counter_sched_out(&cpuctx->ctx, cpuctx);
+}
+
+static int
+group_sched_in(struct perf_counter *group_counter,
+	       struct perf_cpu_context *cpuctx,
+	       struct perf_counter_context *ctx,
+	       int cpu)
+{
+	struct perf_counter *counter, *partial_group;
+	int ret = 0;
+
+	if (counter_sched_in(group_counter, cpuctx, ctx, cpu))
+		return -EAGAIN;
+
+	/*
+	 * Schedule in siblings as one group (if any):
+	 */
+	list_for_each_entry(counter, &group_counter->sibling_list, list_entry) {
+		if (counter_sched_in(counter, cpuctx, ctx, cpu)) {
+			partial_group = counter;
+			goto group_error;
+		}
+		ret = -EAGAIN;
+	}
+
+	return ret;
+
+group_error:
+	/*
+	 * Groups can be scheduled in as one unit only, so undo any
+	 * partial group before returning:
+	 */
+	list_for_each_entry(counter, &group_counter->sibling_list, list_entry) {
+		if (counter == partial_group)
+			break;
+		counter_sched_out(counter, cpuctx, ctx);
+	}
+	counter_sched_out(group_counter, cpuctx, ctx);
+
+	return -EAGAIN;
+}
+
+static void
+__perf_counter_sched_in(struct perf_counter_context *ctx,
+			struct perf_cpu_context *cpuctx, int cpu)
+{
+	struct perf_counter *counter;
+
+	if (likely(!ctx->nr_counters))
+		return;
+
+	spin_lock(&ctx->lock);
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		/*
+		 * Listen to the 'cpu' scheduling filter constraint
+		 * of counters:
+		 */
+		if (counter->cpu != -1 && counter->cpu != cpu)
+			continue;
+
+		/*
+		 * If we scheduled in a group atomically and
+		 * exclusively, break out:
+		 */
+		if (group_sched_in(counter, cpuctx, ctx, cpu))
+			break;
+	}
+	spin_unlock(&ctx->lock);
+}
+
+/*
+ * Called from scheduler to add the counters of the current task
+ * with interrupts disabled.
+ *
+ * We restore the counter value and then enable it.
+ *
+ * This does not protect us against NMI, but enable()
+ * sets the enabled bit in the control field of counter _before_
+ * accessing the counter control register. If a NMI hits, then it will
+ * keep the counter running.
+ */
+void perf_counter_task_sched_in(struct task_struct *task, int cpu)
+{
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_counter_context *ctx = &task->perf_counter_ctx;
+
+	__perf_counter_sched_in(ctx, cpuctx, cpu);
+	cpuctx->task_ctx = ctx;
+}
+
+static void perf_counter_cpu_sched_in(struct perf_cpu_context *cpuctx, int cpu)
+{
+	struct perf_counter_context *ctx = &cpuctx->ctx;
+
+	__perf_counter_sched_in(ctx, cpuctx, cpu);
+}
+
+int perf_counter_task_disable(void)
+{
+	struct task_struct *curr = current;
+	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	struct perf_counter *counter;
+	unsigned long flags;
+	u64 perf_flags;
+	int cpu;
+
+	if (likely(!ctx->nr_counters))
+		return 0;
+
+	curr_rq_lock_irq_save(&flags);
+	cpu = smp_processor_id();
+
+	/* force the update of the task clock: */
+	__task_delta_exec(curr, 1);
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
+	curr_rq_unlock_irq_restore(&flags);
+
+	return 0;
+}
+
+int perf_counter_task_enable(void)
+{
+	struct task_struct *curr = current;
+	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	struct perf_counter *counter;
+	unsigned long flags;
+	u64 perf_flags;
+	int cpu;
+
+	if (likely(!ctx->nr_counters))
+		return 0;
+
+	curr_rq_lock_irq_save(&flags);
+	cpu = smp_processor_id();
+
+	/* force the update of the task clock: */
+	__task_delta_exec(curr, 1);
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
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		if (counter->state != PERF_COUNTER_STATE_OFF)
+			continue;
+		counter->state = PERF_COUNTER_STATE_INACTIVE;
+		counter->hw_event.disabled = 0;
+	}
+	hw_perf_restore(perf_flags);
+
+	spin_unlock(&ctx->lock);
+
+	perf_counter_task_sched_in(curr, cpu);
+
+	curr_rq_unlock_irq_restore(&flags);
+
+	return 0;
+}
+
+/*
+ * Round-robin a context's counters:
+ */
+static void rotate_ctx(struct perf_counter_context *ctx)
+{
+	struct perf_counter *counter;
+	u64 perf_flags;
+
+	if (!ctx->nr_counters)
+		return;
+
+	spin_lock(&ctx->lock);
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
+}
+
+void perf_counter_task_tick(struct task_struct *curr, int cpu)
+{
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
+	const int rotate_percpu = 0;
+
+	if (rotate_percpu)
+		perf_counter_cpu_sched_out(cpuctx);
+	perf_counter_task_sched_out(curr, cpu);
+
+	if (rotate_percpu)
+		rotate_ctx(&cpuctx->ctx);
+	rotate_ctx(ctx);
+
+	if (rotate_percpu)
+		perf_counter_cpu_sched_in(cpuctx, cpu);
+	perf_counter_task_sched_in(curr, cpu);
+}
+
+/*
+ * Cross CPU call to read the hardware counter
+ */
+static void __read(void *info)
+{
+	struct perf_counter *counter = info;
+	unsigned long flags;
+
+	curr_rq_lock_irq_save(&flags);
+	counter->hw_ops->read(counter);
+	curr_rq_unlock_irq_restore(&flags);
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
+					 __read, counter, 1);
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
+static int cpu_clock_perf_counter_enable(struct perf_counter *counter)
+{
+	return 0;
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
+	.enable		= cpu_clock_perf_counter_enable,
+	.disable	= cpu_clock_perf_counter_disable,
+	.read		= cpu_clock_perf_counter_read,
+};
+
+/*
+ * Called from within the scheduler:
+ */
+static u64 task_clock_perf_counter_val(struct perf_counter *counter, int update)
+{
+	struct task_struct *curr = counter->task;
+	u64 delta;
+
+	delta = __task_delta_exec(curr, update);
+
+	return curr->se.sum_exec_runtime + delta;
+}
+
+static void task_clock_perf_counter_update(struct perf_counter *counter, u64 now)
+{
+	u64 prev;
+	s64 delta;
+
+	prev = atomic64_read(&counter->hw.prev_count);
+
+	atomic64_set(&counter->hw.prev_count, now);
+
+	delta = now - prev;
+
+	atomic64_add(delta, &counter->count);
+}
+
+static void task_clock_perf_counter_read(struct perf_counter *counter)
+{
+	u64 now = task_clock_perf_counter_val(counter, 1);
+
+	task_clock_perf_counter_update(counter, now);
+}
+
+static int task_clock_perf_counter_enable(struct perf_counter *counter)
+{
+	u64 now = task_clock_perf_counter_val(counter, 0);
+
+	atomic64_set(&counter->hw.prev_count, now);
+
+	return 0;
+}
+
+static void task_clock_perf_counter_disable(struct perf_counter *counter)
+{
+	u64 now = task_clock_perf_counter_val(counter, 0);
+
+	task_clock_perf_counter_update(counter, now);
+}
+
+static const struct hw_perf_counter_ops perf_ops_task_clock = {
+	.enable		= task_clock_perf_counter_enable,
+	.disable	= task_clock_perf_counter_disable,
+	.read		= task_clock_perf_counter_read,
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
+
+	atomic64_add(delta, &counter->count);
+}
+
+static void page_faults_perf_counter_read(struct perf_counter *counter)
+{
+	page_faults_perf_counter_update(counter);
+}
+
+static int page_faults_perf_counter_enable(struct perf_counter *counter)
+{
+	/*
+	 * page-faults is a per-task value already,
+	 * so we dont have to clear it on switch-in.
+	 */
+
+	return 0;
+}
+
+static void page_faults_perf_counter_disable(struct perf_counter *counter)
+{
+	page_faults_perf_counter_update(counter);
+}
+
+static const struct hw_perf_counter_ops perf_ops_page_faults = {
+	.enable		= page_faults_perf_counter_enable,
+	.disable	= page_faults_perf_counter_disable,
+	.read		= page_faults_perf_counter_read,
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
+
+	atomic64_add(delta, &counter->count);
+}
+
+static void context_switches_perf_counter_read(struct perf_counter *counter)
+{
+	context_switches_perf_counter_update(counter);
+}
+
+static int context_switches_perf_counter_enable(struct perf_counter *counter)
+{
+	/*
+	 * ->nvcsw + curr->nivcsw is a per-task value already,
+	 * so we dont have to clear it on switch-in.
+	 */
+
+	return 0;
+}
+
+static void context_switches_perf_counter_disable(struct perf_counter *counter)
+{
+	context_switches_perf_counter_update(counter);
+}
+
+static const struct hw_perf_counter_ops perf_ops_context_switches = {
+	.enable		= context_switches_perf_counter_enable,
+	.disable	= context_switches_perf_counter_disable,
+	.read		= context_switches_perf_counter_read,
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
+
+	atomic64_add(delta, &counter->count);
+}
+
+static void cpu_migrations_perf_counter_read(struct perf_counter *counter)
+{
+	cpu_migrations_perf_counter_update(counter);
+}
+
+static int cpu_migrations_perf_counter_enable(struct perf_counter *counter)
+{
+	/*
+	 * se.nr_migrations is a per-task value already,
+	 * so we dont have to clear it on switch-in.
+	 */
+
+	return 0;
+}
+
+static void cpu_migrations_perf_counter_disable(struct perf_counter *counter)
+{
+	cpu_migrations_perf_counter_update(counter);
+}
+
+static const struct hw_perf_counter_ops perf_ops_cpu_migrations = {
+	.enable		= cpu_migrations_perf_counter_enable,
+	.disable	= cpu_migrations_perf_counter_disable,
+	.read		= cpu_migrations_perf_counter_read,
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
+	counter->state = PERF_COUNTER_STATE_INACTIVE;
+	if (hw_event->disabled)
+		counter->state = PERF_COUNTER_STATE_OFF;
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
+
+	/*
+	 * If we do not self-reap then we have to wait for the
+	 * child task to unschedule (it will happen for sure),
+	 * so that its counter is at its final count. (This
+	 * condition triggers rarely - child tasks usually get
+	 * off their CPU before the parent has a chance to
+	 * get this far into the reaping action)
+	 */
+	if (child != current) {
+		wait_task_inactive(child, 0);
+		list_del_init(&child_counter->list_entry);
+	} else {
+		struct perf_cpu_context *cpuctx;
+		unsigned long flags;
+		u64 perf_flags;
+
+		/*
+		 * Disable and unlink this counter.
+		 *
+		 * Be careful about zapping the list - IRQ/NMI context
+		 * could still be processing it:
+		 */
+		curr_rq_lock_irq_save(&flags);
+		perf_flags = hw_perf_save_disable();
+
+		cpuctx = &__get_cpu_var(perf_cpu_context);
+
+		if (child_counter->state == PERF_COUNTER_STATE_ACTIVE) {
+			child_counter->state = PERF_COUNTER_STATE_INACTIVE;
+			child_counter->hw_ops->disable(child_counter);
+			cpuctx->active_oncpu--;
+			child_ctx->nr_active--;
+			child_counter->oncpu = -1;
+		}
+
+		list_del_init(&child_counter->list_entry);
+
+		child_ctx->nr_counters--;
+
+		hw_perf_restore(perf_flags);
+		curr_rq_unlock_irq_restore(&flags);
+	}
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
diff --git a/kernel/sched.c b/kernel/sched.c
index e4bb1dd..4d84ff4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -638,7 +638,7 @@ static inline int cpu_of(struct rq *rq)
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 
-static inline void update_rq_clock(struct rq *rq)
+inline void update_rq_clock(struct rq *rq)
 {
 	rq->clock = sched_clock_cpu(cpu_of(rq));
 }
@@ -969,6 +969,26 @@ static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
 	}
 }
 
+void curr_rq_lock_irq_save(unsigned long *flags)
+	__acquires(rq->lock)
+{
+	struct rq *rq;
+
+	local_irq_save(*flags);
+	rq = cpu_rq(smp_processor_id());
+	spin_lock(&rq->lock);
+}
+
+void curr_rq_unlock_irq_restore(unsigned long *flags)
+	__releases(rq->lock)
+{
+	struct rq *rq;
+
+	rq = cpu_rq(smp_processor_id());
+	spin_unlock(&rq->lock);
+	local_irq_restore(*flags);
+}
+
 void task_rq_unlock_wait(struct task_struct *p)
 {
 	struct rq *rq = task_rq(p);
@@ -1852,12 +1872,14 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
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
 
@@ -2212,6 +2234,27 @@ static int sched_balance_self(int cpu, int flag)
 
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
@@ -2354,6 +2397,7 @@ static void __sched_fork(struct task_struct *p)
 	p->se.exec_start		= 0;
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
+	p->se.nr_migrations		= 0;
 	p->se.last_wakeup		= 0;
 	p->se.avg_overlap		= 0;
 
@@ -2574,6 +2618,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 */
 	prev_state = prev->state;
 	finish_arch_switch(prev);
+	perf_counter_task_sched_in(current, cpu_of(rq));
 	finish_lock_switch(rq, prev);
 #ifdef CONFIG_SMP
 	if (current->sched_class->post_schedule)
@@ -4067,6 +4112,29 @@ EXPORT_PER_CPU_SYMBOL(kstat);
  * Return any ns on the sched_clock that have not yet been banked in
  * @p in case that task is currently running.
  */
+unsigned long long __task_delta_exec(struct task_struct *p, int update)
+{
+	s64 delta_exec;
+	struct rq *rq;
+
+	rq = task_rq(p);
+	WARN_ON_ONCE(!runqueue_is_locked());
+	WARN_ON_ONCE(!task_current(rq, p));
+
+	if (update)
+		update_rq_clock(rq);
+
+	delta_exec = rq->clock - p->se.exec_start;
+
+	WARN_ON_ONCE(delta_exec < 0);
+
+	return delta_exec;
+}
+
+/*
+ * Return any ns on the sched_clock that have not yet been banked in
+ * @p in case that task is currently running.
+ */
 unsigned long long task_delta_exec(struct task_struct *p)
 {
 	unsigned long flags;
@@ -4290,6 +4358,7 @@ void scheduler_tick(void)
 	update_rq_clock(rq);
 	update_cpu_load(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
+	perf_counter_task_tick(curr, cpu);
 	spin_unlock(&rq->lock);
 
 #ifdef CONFIG_SMP
@@ -4485,6 +4554,7 @@ need_resched_nonpreemptible:
 
 	if (likely(prev != next)) {
 		sched_info_switch(prev, next);
+		perf_counter_task_sched_out(prev, cpu);
 
 		rq->nr_switches++;
 		rq->curr = next;
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
