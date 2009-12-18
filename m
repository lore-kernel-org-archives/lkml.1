Return-Path: <linux-kernel-owner+w=401wt.eu-S932559AbZLRS74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbZLRS74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 13:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932420AbZLRS7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 13:59:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41958 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187AbZLRS7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 13:59:52 -0500
Date: Fri, 18 Dec 2009 19:59:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20091218185937.GA24354@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf session: Make events_stats u64 to avoid overflow on 32-bit arches

Frederic Weisbecker (3):
      perf events, x86/stacktrace: Make stack walking optional
      perf events, x86/stacktrace: Fix performance/softlockup by providing a special frame pointer-only stack walker
      hw-breakpoints: Fix hardware breakpoints -> perf events dependency

Masami Hiramatsu (4):
      perf probe: Fix libdwarf include path for Debian
      perf probe: Check whether debugfs path is correct
      kprobe-tracer: Check new event/group name
      perf probe: Check new event name

Peter Zijlstra (1):
      perf events: Dont report side-band events on each cpu for per-task-per-cpu events

Robert P. J. Day (1):
      perf events: Remove unused perf_counter.h header file


 arch/Kconfig                      |    4 +-
 arch/x86/Kconfig                  |    2 +
 arch/x86/include/asm/stacktrace.h |   24 ++
 arch/x86/kernel/cpu/perf_event.c  |    1 +
 arch/x86/kernel/dumpstack.c       |   33 +++-
 arch/x86/kernel/dumpstack.h       |    6 -
 arch/x86/kernel/dumpstack_32.c    |    2 +-
 arch/x86/kernel/dumpstack_64.c    |    4 +-
 arch/x86/kernel/stacktrace.c      |   18 +-
 arch/x86/oprofile/backtrace.c     |    9 +-
 include/linux/perf_counter.h      |  444 -------------------------------------
 kernel/perf_event.c               |   32 ++--
 kernel/trace/trace_kprobe.c       |   31 ++-
 kernel/trace/trace_sysprof.c      |    1 +
 tools/perf/Makefile               |    3 +-
 tools/perf/builtin-probe.c        |    4 +
 tools/perf/builtin-report.c       |    2 +-
 tools/perf/util/event.h           |    4 +-
 tools/perf/util/probe-event.c     |   15 ++
 tools/perf/util/probe-finder.h    |   59 +++---
 20 files changed, 175 insertions(+), 523 deletions(-)
 delete mode 100644 include/linux/perf_counter.h

diff --git a/arch/Kconfig b/arch/Kconfig
index d828758..9d055b4 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -135,9 +135,7 @@ config HAVE_DEFAULT_NO_SPIN_MUTEXES
 
 config HAVE_HW_BREAKPOINT
 	bool
-	depends on HAVE_PERF_EVENTS
-	select ANON_INODES
-	select PERF_EVENTS
+	depends on PERF_EVENTS
 
 config HAVE_USER_RETURN_NOTIFIER
 	bool
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3b2a5ac..55298e8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -50,6 +50,8 @@ config X86
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
 	select HAVE_HW_BREAKPOINT
+	select PERF_EVENTS
+	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
 
diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index cf86a5e..35e8912 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -5,6 +5,29 @@ extern int kstack_depth_to_print;
 
 int x86_is_stack_id(int id, char *name);
 
+struct thread_info;
+struct stacktrace_ops;
+
+typedef unsigned long (*walk_stack_t)(struct thread_info *tinfo,
+				      unsigned long *stack,
+				      unsigned long bp,
+				      const struct stacktrace_ops *ops,
+				      void *data,
+				      unsigned long *end,
+				      int *graph);
+
+extern unsigned long
+print_context_stack(struct thread_info *tinfo,
+		    unsigned long *stack, unsigned long bp,
+		    const struct stacktrace_ops *ops, void *data,
+		    unsigned long *end, int *graph);
+
+extern unsigned long
+print_context_stack_bp(struct thread_info *tinfo,
+		       unsigned long *stack, unsigned long bp,
+		       const struct stacktrace_ops *ops, void *data,
+		       unsigned long *end, int *graph);
+
 /* Generic stack tracer with callbacks */
 
 struct stacktrace_ops {
@@ -14,6 +37,7 @@ struct stacktrace_ops {
 	void (*address)(void *data, unsigned long address, int reliable);
 	/* On negative return stop dumping */
 	int (*stack)(void *data, char *name);
+	walk_stack_t	walk_stack;
 };
 
 void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 45506d5..c223b7e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2336,6 +2336,7 @@ static const struct stacktrace_ops backtrace_ops = {
 	.warning_symbol		= backtrace_warning_symbol,
 	.stack			= backtrace_stack,
 	.address		= backtrace_address,
+	.walk_stack		= print_context_stack_bp,
 };
 
 #include "../dumpstack.h"
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 0a0aa1c..c56bc28 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -109,6 +109,30 @@ print_context_stack(struct thread_info *tinfo,
 	}
 	return bp;
 }
+EXPORT_SYMBOL_GPL(print_context_stack);
+
+unsigned long
+print_context_stack_bp(struct thread_info *tinfo,
+		       unsigned long *stack, unsigned long bp,
+		       const struct stacktrace_ops *ops, void *data,
+		       unsigned long *end, int *graph)
+{
+	struct stack_frame *frame = (struct stack_frame *)bp;
+	unsigned long *ret_addr = &frame->return_address;
+
+	while (valid_stack_ptr(tinfo, ret_addr, sizeof(*ret_addr), end)) {
+		unsigned long addr = *ret_addr;
+
+		if (__kernel_text_address(addr)) {
+			ops->address(data, addr, 1);
+			frame = frame->next_frame;
+			ret_addr = &frame->return_address;
+			print_ftrace_graph_addr(addr, data, ops, tinfo, graph);
+		}
+	}
+	return (unsigned long)frame;
+}
+EXPORT_SYMBOL_GPL(print_context_stack_bp);
 
 
 static void
@@ -141,10 +165,11 @@ static void print_trace_address(void *data, unsigned long addr, int reliable)
 }
 
 static const struct stacktrace_ops print_trace_ops = {
-	.warning = print_trace_warning,
-	.warning_symbol = print_trace_warning_symbol,
-	.stack = print_trace_stack,
-	.address = print_trace_address,
+	.warning		= print_trace_warning,
+	.warning_symbol		= print_trace_warning_symbol,
+	.stack			= print_trace_stack,
+	.address		= print_trace_address,
+	.walk_stack		= print_context_stack,
 };
 
 void
diff --git a/arch/x86/kernel/dumpstack.h b/arch/x86/kernel/dumpstack.h
index 81086c2..4fd1420 100644
--- a/arch/x86/kernel/dumpstack.h
+++ b/arch/x86/kernel/dumpstack.h
@@ -14,12 +14,6 @@
 #define get_bp(bp) asm("movq %%rbp, %0" : "=r" (bp) :)
 #endif
 
-extern unsigned long
-print_context_stack(struct thread_info *tinfo,
-		unsigned long *stack, unsigned long bp,
-		const struct stacktrace_ops *ops, void *data,
-		unsigned long *end, int *graph);
-
 extern void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp, char *log_lvl);
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index e0ed4c7..ae775ca 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -58,7 +58,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 
 		context = (struct thread_info *)
 			((unsigned long)stack & (~(THREAD_SIZE - 1)));
-		bp = print_context_stack(context, stack, bp, ops, data, NULL, &graph);
+		bp = ops->walk_stack(context, stack, bp, ops, data, NULL, &graph);
 
 		stack = (unsigned long *)context->previous_esp;
 		if (!stack)
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index b13af53..0ad9597 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -188,8 +188,8 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			if (ops->stack(data, id) < 0)
 				break;
 
-			bp = print_context_stack(tinfo, stack, bp, ops,
-						 data, estack_end, &graph);
+			bp = ops->walk_stack(tinfo, stack, bp, ops,
+					     data, estack_end, &graph);
 			ops->stack(data, "<EOE>");
 			/*
 			 * We link to the next stack via the
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index c3eb207..922eefb 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -53,17 +53,19 @@ save_stack_address_nosched(void *data, unsigned long addr, int reliable)
 }
 
 static const struct stacktrace_ops save_stack_ops = {
-	.warning = save_stack_warning,
-	.warning_symbol = save_stack_warning_symbol,
-	.stack = save_stack_stack,
-	.address = save_stack_address,
+	.warning	= save_stack_warning,
+	.warning_symbol	= save_stack_warning_symbol,
+	.stack		= save_stack_stack,
+	.address	= save_stack_address,
+	.walk_stack	= print_context_stack,
 };
 
 static const struct stacktrace_ops save_stack_ops_nosched = {
-	.warning = save_stack_warning,
-	.warning_symbol = save_stack_warning_symbol,
-	.stack = save_stack_stack,
-	.address = save_stack_address_nosched,
+	.warning	= save_stack_warning,
+	.warning_symbol	= save_stack_warning_symbol,
+	.stack		= save_stack_stack,
+	.address	= save_stack_address_nosched,
+	.walk_stack	= print_context_stack,
 };
 
 /*
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 044897b..3855096 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -41,10 +41,11 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
 }
 
 static struct stacktrace_ops backtrace_ops = {
-	.warning = backtrace_warning,
-	.warning_symbol = backtrace_warning_symbol,
-	.stack = backtrace_stack,
-	.address = backtrace_address,
+	.warning	= backtrace_warning,
+	.warning_symbol	= backtrace_warning_symbol,
+	.stack		= backtrace_stack,
+	.address	= backtrace_address,
+	.walk_stack	= print_context_stack,
 };
 
 struct frame_head {
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
deleted file mode 100644
index e3fb256..0000000
--- a/include/linux/perf_counter.h
+++ /dev/null
@@ -1,444 +0,0 @@
-/*
- *  NOTE: this file will be removed in a future kernel release, it is
- *  provided as a courtesy copy of user-space code that relies on the
- *  old (pre-rename) symbols and constants.
- *
- *  Performance events:
- *
- *    Copyright (C) 2008-2009, Thomas Gleixner <tglx@linutronix.de>
- *    Copyright (C) 2008-2009, Red Hat, Inc., Ingo Molnar
- *    Copyright (C) 2008-2009, Red Hat, Inc., Peter Zijlstra
- *
- *  Data type definitions, declarations, prototypes.
- *
- *    Started by: Thomas Gleixner and Ingo Molnar
- *
- *  For licencing details see kernel-base/COPYING
- */
-#ifndef _LINUX_PERF_COUNTER_H
-#define _LINUX_PERF_COUNTER_H
-
-#include <linux/types.h>
-#include <linux/ioctl.h>
-#include <asm/byteorder.h>
-
-/*
- * User-space ABI bits:
- */
-
-/*
- * attr.type
- */
-enum perf_type_id {
-	PERF_TYPE_HARDWARE			= 0,
-	PERF_TYPE_SOFTWARE			= 1,
-	PERF_TYPE_TRACEPOINT			= 2,
-	PERF_TYPE_HW_CACHE			= 3,
-	PERF_TYPE_RAW				= 4,
-
-	PERF_TYPE_MAX,				/* non-ABI */
-};
-
-/*
- * Generalized performance counter event types, used by the
- * attr.event_id parameter of the sys_perf_counter_open()
- * syscall:
- */
-enum perf_hw_id {
-	/*
-	 * Common hardware events, generalized by the kernel:
-	 */
-	PERF_COUNT_HW_CPU_CYCLES		= 0,
-	PERF_COUNT_HW_INSTRUCTIONS		= 1,
-	PERF_COUNT_HW_CACHE_REFERENCES		= 2,
-	PERF_COUNT_HW_CACHE_MISSES		= 3,
-	PERF_COUNT_HW_BRANCH_INSTRUCTIONS	= 4,
-	PERF_COUNT_HW_BRANCH_MISSES		= 5,
-	PERF_COUNT_HW_BUS_CYCLES		= 6,
-
-	PERF_COUNT_HW_MAX,			/* non-ABI */
-};
-
-/*
- * Generalized hardware cache counters:
- *
- *       { L1-D, L1-I, LLC, ITLB, DTLB, BPU } x
- *       { read, write, prefetch } x
- *       { accesses, misses }
- */
-enum perf_hw_cache_id {
-	PERF_COUNT_HW_CACHE_L1D			= 0,
-	PERF_COUNT_HW_CACHE_L1I			= 1,
-	PERF_COUNT_HW_CACHE_LL			= 2,
-	PERF_COUNT_HW_CACHE_DTLB		= 3,
-	PERF_COUNT_HW_CACHE_ITLB		= 4,
-	PERF_COUNT_HW_CACHE_BPU			= 5,
-
-	PERF_COUNT_HW_CACHE_MAX,		/* non-ABI */
-};
-
-enum perf_hw_cache_op_id {
-	PERF_COUNT_HW_CACHE_OP_READ		= 0,
-	PERF_COUNT_HW_CACHE_OP_WRITE		= 1,
-	PERF_COUNT_HW_CACHE_OP_PREFETCH		= 2,
-
-	PERF_COUNT_HW_CACHE_OP_MAX,		/* non-ABI */
-};
-
-enum perf_hw_cache_op_result_id {
-	PERF_COUNT_HW_CACHE_RESULT_ACCESS	= 0,
-	PERF_COUNT_HW_CACHE_RESULT_MISS		= 1,
-
-	PERF_COUNT_HW_CACHE_RESULT_MAX,		/* non-ABI */
-};
-
-/*
- * Special "software" counters provided by the kernel, even if the hardware
- * does not support performance counters. These counters measure various
- * physical and sw events of the kernel (and allow the profiling of them as
- * well):
- */
-enum perf_sw_ids {
-	PERF_COUNT_SW_CPU_CLOCK			= 0,
-	PERF_COUNT_SW_TASK_CLOCK		= 1,
-	PERF_COUNT_SW_PAGE_FAULTS		= 2,
-	PERF_COUNT_SW_CONTEXT_SWITCHES		= 3,
-	PERF_COUNT_SW_CPU_MIGRATIONS		= 4,
-	PERF_COUNT_SW_PAGE_FAULTS_MIN		= 5,
-	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
-	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
-	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
-
-	PERF_COUNT_SW_MAX,			/* non-ABI */
-};
-
-/*
- * Bits that can be set in attr.sample_type to request information
- * in the overflow packets.
- */
-enum perf_counter_sample_format {
-	PERF_SAMPLE_IP				= 1U << 0,
-	PERF_SAMPLE_TID				= 1U << 1,
-	PERF_SAMPLE_TIME			= 1U << 2,
-	PERF_SAMPLE_ADDR			= 1U << 3,
-	PERF_SAMPLE_READ			= 1U << 4,
-	PERF_SAMPLE_CALLCHAIN			= 1U << 5,
-	PERF_SAMPLE_ID				= 1U << 6,
-	PERF_SAMPLE_CPU				= 1U << 7,
-	PERF_SAMPLE_PERIOD			= 1U << 8,
-	PERF_SAMPLE_STREAM_ID			= 1U << 9,
-	PERF_SAMPLE_RAW				= 1U << 10,
-
-	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
-};
-
-/*
- * The format of the data returned by read() on a perf counter fd,
- * as specified by attr.read_format:
- *
- * struct read_format {
- *	{ u64		value;
- *	  { u64		time_enabled; } && PERF_FORMAT_ENABLED
- *	  { u64		time_running; } && PERF_FORMAT_RUNNING
- *	  { u64		id;           } && PERF_FORMAT_ID
- *	} && !PERF_FORMAT_GROUP
- *
- *	{ u64		nr;
- *	  { u64		time_enabled; } && PERF_FORMAT_ENABLED
- *	  { u64		time_running; } && PERF_FORMAT_RUNNING
- *	  { u64		value;
- *	    { u64	id;           } && PERF_FORMAT_ID
- *	  }		cntr[nr];
- *	} && PERF_FORMAT_GROUP
- * };
- */
-enum perf_counter_read_format {
-	PERF_FORMAT_TOTAL_TIME_ENABLED		= 1U << 0,
-	PERF_FORMAT_TOTAL_TIME_RUNNING		= 1U << 1,
-	PERF_FORMAT_ID				= 1U << 2,
-	PERF_FORMAT_GROUP			= 1U << 3,
-
-	PERF_FORMAT_MAX = 1U << 4, 		/* non-ABI */
-};
-
-#define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
-
-/*
- * Hardware event to monitor via a performance monitoring counter:
- */
-struct perf_counter_attr {
-
-	/*
-	 * Major type: hardware/software/tracepoint/etc.
-	 */
-	__u32			type;
-
-	/*
-	 * Size of the attr structure, for fwd/bwd compat.
-	 */
-	__u32			size;
-
-	/*
-	 * Type specific configuration information.
-	 */
-	__u64			config;
-
-	union {
-		__u64		sample_period;
-		__u64		sample_freq;
-	};
-
-	__u64			sample_type;
-	__u64			read_format;
-
-	__u64			disabled       :  1, /* off by default        */
-				inherit	       :  1, /* children inherit it   */
-				pinned	       :  1, /* must always be on PMU */
-				exclusive      :  1, /* only group on PMU     */
-				exclude_user   :  1, /* don't count user      */
-				exclude_kernel :  1, /* ditto kernel          */
-				exclude_hv     :  1, /* ditto hypervisor      */
-				exclude_idle   :  1, /* don't count when idle */
-				mmap           :  1, /* include mmap data     */
-				comm	       :  1, /* include comm data     */
-				freq           :  1, /* use freq, not period  */
-				inherit_stat   :  1, /* per task counts       */
-				enable_on_exec :  1, /* next exec enables     */
-				task           :  1, /* trace fork/exit       */
-				watermark      :  1, /* wakeup_watermark      */
-
-				__reserved_1   : 49;
-
-	union {
-		__u32		wakeup_events;	  /* wakeup every n events */
-		__u32		wakeup_watermark; /* bytes before wakeup   */
-	};
-	__u32			__reserved_2;
-
-	__u64			__reserved_3;
-};
-
-/*
- * Ioctls that can be done on a perf counter fd:
- */
-#define PERF_COUNTER_IOC_ENABLE		_IO ('$', 0)
-#define PERF_COUNTER_IOC_DISABLE	_IO ('$', 1)
-#define PERF_COUNTER_IOC_REFRESH	_IO ('$', 2)
-#define PERF_COUNTER_IOC_RESET		_IO ('$', 3)
-#define PERF_COUNTER_IOC_PERIOD		_IOW('$', 4, u64)
-#define PERF_COUNTER_IOC_SET_OUTPUT	_IO ('$', 5)
-#define PERF_COUNTER_IOC_SET_FILTER	_IOW('$', 6, char *)
-
-enum perf_counter_ioc_flags {
-	PERF_IOC_FLAG_GROUP		= 1U << 0,
-};
-
-/*
- * Structure of the page that can be mapped via mmap
- */
-struct perf_counter_mmap_page {
-	__u32	version;		/* version number of this structure */
-	__u32	compat_version;		/* lowest version this is compat with */
-
-	/*
-	 * Bits needed to read the hw counters in user-space.
-	 *
-	 *   u32 seq;
-	 *   s64 count;
-	 *
-	 *   do {
-	 *     seq = pc->lock;
-	 *
-	 *     barrier()
-	 *     if (pc->index) {
-	 *       count = pmc_read(pc->index - 1);
-	 *       count += pc->offset;
-	 *     } else
-	 *       goto regular_read;
-	 *
-	 *     barrier();
-	 *   } while (pc->lock != seq);
-	 *
-	 * NOTE: for obvious reason this only works on self-monitoring
-	 *       processes.
-	 */
-	__u32	lock;			/* seqlock for synchronization */
-	__u32	index;			/* hardware counter identifier */
-	__s64	offset;			/* add to hardware counter value */
-	__u64	time_enabled;		/* time counter active */
-	__u64	time_running;		/* time counter on cpu */
-
-		/*
-		 * Hole for extension of the self monitor capabilities
-		 */
-
-	__u64	__reserved[123];	/* align to 1k */
-
-	/*
-	 * Control data for the mmap() data buffer.
-	 *
-	 * User-space reading the @data_head value should issue an rmb(), on
-	 * SMP capable platforms, after reading this value -- see
-	 * perf_counter_wakeup().
-	 *
-	 * When the mapping is PROT_WRITE the @data_tail value should be
-	 * written by userspace to reflect the last read data. In this case
-	 * the kernel will not over-write unread data.
-	 */
-	__u64   data_head;		/* head in the data section */
-	__u64	data_tail;		/* user-space written tail */
-};
-
-#define PERF_EVENT_MISC_CPUMODE_MASK		(3 << 0)
-#define PERF_EVENT_MISC_CPUMODE_UNKNOWN		(0 << 0)
-#define PERF_EVENT_MISC_KERNEL			(1 << 0)
-#define PERF_EVENT_MISC_USER			(2 << 0)
-#define PERF_EVENT_MISC_HYPERVISOR		(3 << 0)
-
-struct perf_event_header {
-	__u32	type;
-	__u16	misc;
-	__u16	size;
-};
-
-enum perf_event_type {
-
-	/*
-	 * The MMAP events record the PROT_EXEC mappings so that we can
-	 * correlate userspace IPs to code. They have the following structure:
-	 *
-	 * struct {
-	 *	struct perf_event_header	header;
-	 *
-	 *	u32				pid, tid;
-	 *	u64				addr;
-	 *	u64				len;
-	 *	u64				pgoff;
-	 *	char				filename[];
-	 * };
-	 */
-	PERF_EVENT_MMAP			= 1,
-
-	/*
-	 * struct {
-	 *	struct perf_event_header	header;
-	 *	u64				id;
-	 *	u64				lost;
-	 * };
-	 */
-	PERF_EVENT_LOST			= 2,
-
-	/*
-	 * struct {
-	 *	struct perf_event_header	header;
-	 *
-	 *	u32				pid, tid;
-	 *	char				comm[];
-	 * };
-	 */
-	PERF_EVENT_COMM			= 3,
-
-	/*
-	 * struct {
-	 *	struct perf_event_header	header;
-	 *	u32				pid, ppid;
-	 *	u32				tid, ptid;
-	 *	u64				time;
-	 * };
-	 */
-	PERF_EVENT_EXIT			= 4,
-
-	/*
-	 * struct {
-	 *	struct perf_event_header	header;
-	 *	u64				time;
-	 *	u64				id;
-	 *	u64				stream_id;
-	 * };
-	 */
-	PERF_EVENT_THROTTLE		= 5,
-	PERF_EVENT_UNTHROTTLE		= 6,
-
-	/*
-	 * struct {
-	 *	struct perf_event_header	header;
-	 *	u32				pid, ppid;
-	 *	u32				tid, ptid;
-	 *	u64				time;
-	 * };
-	 */
-	PERF_EVENT_FORK			= 7,
-
-	/*
-	 * struct {
-	 *	struct perf_event_header	header;
-	 *	u32				pid, tid;
-	 *
-	 *	struct read_format		values;
-	 * };
-	 */
-	PERF_EVENT_READ			= 8,
-
-	/*
-	 * struct {
-	 *	struct perf_event_header	header;
-	 *
-	 *	{ u64			ip;	  } && PERF_SAMPLE_IP
-	 *	{ u32			pid, tid; } && PERF_SAMPLE_TID
-	 *	{ u64			time;     } && PERF_SAMPLE_TIME
-	 *	{ u64			addr;     } && PERF_SAMPLE_ADDR
-	 *	{ u64			id;	  } && PERF_SAMPLE_ID
-	 *	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
-	 *	{ u32			cpu, res; } && PERF_SAMPLE_CPU
-	 *	{ u64			period;   } && PERF_SAMPLE_PERIOD
-	 *
-	 *	{ struct read_format	values;	  } && PERF_SAMPLE_READ
-	 *
-	 *	{ u64			nr,
-	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
-	 *
-	 *	#
-	 *	# The RAW record below is opaque data wrt the ABI
-	 *	#
-	 *	# That is, the ABI doesn't make any promises wrt to
-	 *	# the stability of its content, it may vary depending
-	 *	# on event, hardware, kernel version and phase of
-	 *	# the moon.
-	 *	#
-	 *	# In other words, PERF_SAMPLE_RAW contents are not an ABI.
-	 *	#
-	 *
-	 *	{ u32			size;
-	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
-	 * };
-	 */
-	PERF_EVENT_SAMPLE		= 9,
-
-	PERF_EVENT_MAX,			/* non-ABI */
-};
-
-enum perf_callchain_context {
-	PERF_CONTEXT_HV			= (__u64)-32,
-	PERF_CONTEXT_KERNEL		= (__u64)-128,
-	PERF_CONTEXT_USER		= (__u64)-512,
-
-	PERF_CONTEXT_GUEST		= (__u64)-2048,
-	PERF_CONTEXT_GUEST_KERNEL	= (__u64)-2176,
-	PERF_CONTEXT_GUEST_USER		= (__u64)-2560,
-
-	PERF_CONTEXT_MAX		= (__u64)-4095,
-};
-
-#define PERF_FLAG_FD_NO_GROUP		(1U << 0)
-#define PERF_FLAG_FD_OUTPUT		(1U << 1)
-
-/*
- * In case some app still references the old symbols:
- */
-
-#define __NR_perf_counter_open		__NR_perf_event_open
-
-#define PR_TASK_PERF_COUNTERS_DISABLE	PR_TASK_PERF_EVENTS_DISABLE
-#define PR_TASK_PERF_COUNTERS_ENABLE	PR_TASK_PERF_EVENTS_ENABLE
-
-#endif /* _LINUX_PERF_COUNTER_H */
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8ab8698..03cc061 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1381,6 +1381,9 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
 
+		if (event->cpu != -1 && event->cpu != smp_processor_id())
+			continue;
+
 		hwc = &event->hw;
 
 		interrupts = hwc->interrupts;
@@ -3265,6 +3268,9 @@ static void perf_event_task_output(struct perf_event *event,
 
 static int perf_event_task_match(struct perf_event *event)
 {
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		return 0;
+
 	if (event->attr.comm || event->attr.mmap || event->attr.task)
 		return 1;
 
@@ -3290,12 +3296,11 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 	rcu_read_lock();
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_event_task_ctx(&cpuctx->ctx, task_event);
-	put_cpu_var(perf_cpu_context);
-
 	if (!ctx)
 		ctx = rcu_dereference(task_event->task->perf_event_ctxp);
 	if (ctx)
 		perf_event_task_ctx(ctx, task_event);
+	put_cpu_var(perf_cpu_context);
 	rcu_read_unlock();
 }
 
@@ -3372,6 +3377,9 @@ static void perf_event_comm_output(struct perf_event *event,
 
 static int perf_event_comm_match(struct perf_event *event)
 {
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		return 0;
+
 	if (event->attr.comm)
 		return 1;
 
@@ -3408,15 +3416,10 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 	rcu_read_lock();
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_event_comm_ctx(&cpuctx->ctx, comm_event);
-	put_cpu_var(perf_cpu_context);
-
-	/*
-	 * doesn't really matter which of the child contexts the
-	 * events ends up in.
-	 */
 	ctx = rcu_dereference(current->perf_event_ctxp);
 	if (ctx)
 		perf_event_comm_ctx(ctx, comm_event);
+	put_cpu_var(perf_cpu_context);
 	rcu_read_unlock();
 }
 
@@ -3491,6 +3494,9 @@ static void perf_event_mmap_output(struct perf_event *event,
 static int perf_event_mmap_match(struct perf_event *event,
 				   struct perf_mmap_event *mmap_event)
 {
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		return 0;
+
 	if (event->attr.mmap)
 		return 1;
 
@@ -3564,15 +3570,10 @@ got_name:
 	rcu_read_lock();
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_event_mmap_ctx(&cpuctx->ctx, mmap_event);
-	put_cpu_var(perf_cpu_context);
-
-	/*
-	 * doesn't really matter which of the child contexts the
-	 * events ends up in.
-	 */
 	ctx = rcu_dereference(current->perf_event_ctxp);
 	if (ctx)
 		perf_event_mmap_ctx(ctx, mmap_event);
+	put_cpu_var(perf_cpu_context);
 	rcu_read_unlock();
 
 	kfree(buf);
@@ -3863,6 +3864,9 @@ static int perf_swevent_match(struct perf_event *event,
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
+	if (event->cpu != -1 && event->cpu != smp_processor_id())
+		return 0;
+
 	if (!perf_swevent_is_counting(event))
 		return 0;
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 7ecab06..375f81a 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -282,6 +282,18 @@ static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs);
 static int kretprobe_dispatcher(struct kretprobe_instance *ri,
 				struct pt_regs *regs);
 
+/* Check the name is good for event/group */
+static int check_event_name(const char *name)
+{
+	if (!isalpha(*name) && *name != '_')
+		return 0;
+	while (*++name != '\0') {
+		if (!isalpha(*name) && !isdigit(*name) && *name != '_')
+			return 0;
+	}
+	return 1;
+}
+
 /*
  * Allocate new trace_probe and initialize it (including kprobes).
  */
@@ -293,10 +305,11 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 					     int nargs, int is_return)
 {
 	struct trace_probe *tp;
+	int ret = -ENOMEM;
 
 	tp = kzalloc(SIZEOF_TRACE_PROBE(nargs), GFP_KERNEL);
 	if (!tp)
-		return ERR_PTR(-ENOMEM);
+		return ERR_PTR(ret);
 
 	if (symbol) {
 		tp->symbol = kstrdup(symbol, GFP_KERNEL);
@@ -312,14 +325,20 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 	else
 		tp->rp.kp.pre_handler = kprobe_dispatcher;
 
-	if (!event)
+	if (!event || !check_event_name(event)) {
+		ret = -EINVAL;
 		goto error;
+	}
+
 	tp->call.name = kstrdup(event, GFP_KERNEL);
 	if (!tp->call.name)
 		goto error;
 
-	if (!group)
+	if (!group || !check_event_name(group)) {
+		ret = -EINVAL;
 		goto error;
+	}
+
 	tp->call.system = kstrdup(group, GFP_KERNEL);
 	if (!tp->call.system)
 		goto error;
@@ -330,7 +349,7 @@ error:
 	kfree(tp->call.name);
 	kfree(tp->symbol);
 	kfree(tp);
-	return ERR_PTR(-ENOMEM);
+	return ERR_PTR(ret);
 }
 
 static void free_probe_arg(struct probe_arg *arg)
@@ -695,10 +714,10 @@ static int create_trace_probe(int argc, char **argv)
 	if (!event) {
 		/* Make a new event name */
 		if (symbol)
-			snprintf(buf, MAX_EVENT_NAME_LEN, "%c@%s%+ld",
+			snprintf(buf, MAX_EVENT_NAME_LEN, "%c_%s_%ld",
 				 is_return ? 'r' : 'p', symbol, offset);
 		else
-			snprintf(buf, MAX_EVENT_NAME_LEN, "%c@0x%p",
+			snprintf(buf, MAX_EVENT_NAME_LEN, "%c_0x%p",
 				 is_return ? 'r' : 'p', addr);
 		event = buf;
 	}
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index f669396..a7974a5 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -93,6 +93,7 @@ static const struct stacktrace_ops backtrace_ops = {
 	.warning_symbol		= backtrace_warning_symbol,
 	.stack			= backtrace_stack,
 	.address		= backtrace_address,
+	.walk_stack		= print_context_stack,
 };
 
 static int
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7814dbb..4390d22 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -487,10 +487,11 @@ else
 	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
 endif
 
-ifneq ($(shell sh -c "(echo '\#include <libdwarf/dwarf.h>'; echo '\#include <libdwarf/libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; Dwarf_Ranges *rng; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); dwarf_get_ranges(dbg, 0, &rng, 0, 0, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+ifneq ($(shell sh -c "(echo '\#ifndef _MIPS_SZLONG'; echo '\#define _MIPS_SZLONG 0'; echo '\#endif'; echo '\#include <dwarf.h>'; echo '\#include <libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; Dwarf_Ranges *rng; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); dwarf_get_ranges(dbg, 0, &rng, 0, 0, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -I/usr/include/libdwarf -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(warning No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231);
 	BASIC_CFLAGS += -DNO_LIBDWARF
 else
+	BASIC_CFLAGS += -I/usr/include/libdwarf
 	EXTLIBS += -lelf -ldwarf
 	LIB_OBJS += util/probe-finder.o
 endif
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 7e741f5..c1e6774 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -38,6 +38,7 @@
 #include "util/strlist.h"
 #include "util/event.h"
 #include "util/debug.h"
+#include "util/debugfs.h"
 #include "util/symbol.h"
 #include "util/thread.h"
 #include "util/session.h"
@@ -205,6 +206,9 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	if ((!session.nr_probe && !session.dellist && !session.list_events))
 		usage_with_options(probe_usage, options);
 
+	if (debugfs_valid_mountpoint(debugfs_path) < 0)
+		die("Failed to find debugfs path.");
+
 	if (session.list_events) {
 		if (session.nr_probe != 0 || session.dellist) {
 			pr_warning("  Error: Don't use --list with"
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index e50a6b1..5c2ab53 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -224,7 +224,7 @@ static int __cmd_report(void)
 
 	perf_session__collapse_resort(session);
 	perf_session__output_resort(session, session->events_stats.total);
-	fprintf(stdout, "# Samples: %ld\n#\n", session->events_stats.total);
+	fprintf(stdout, "# Samples: %Ld\n#\n", session->events_stats.total);
 	perf_session__fprintf_hists(session, NULL, false, stdout);
 	if (sort_order == default_sort_order &&
 	    parent_pattern == default_parent_pattern)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 8027309..690a96d 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -95,8 +95,8 @@ typedef union event_union {
 } event_t;
 
 struct events_stats {
-	unsigned long total;
-	unsigned long lost;
+	u64 total;
+	u64 lost;
 };
 
 void event__print_totals(void);
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 2ca6215..29465d4 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -62,6 +62,18 @@ static int e_snprintf(char *str, size_t size, const char *format, ...)
 	return ret;
 }
 
+/* Check the name is good for event/group */
+static bool check_event_name(const char *name)
+{
+	if (!isalpha(*name) && *name != '_')
+		return false;
+	while (*++name != '\0') {
+		if (!isalpha(*name) && !isdigit(*name) && *name != '_')
+			return false;
+	}
+	return true;
+}
+
 /* Parse probepoint definition. */
 static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 {
@@ -82,6 +94,9 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 		ptr = strchr(arg, ':');
 		if (ptr)	/* Group name is not supported yet. */
 			semantic_error("Group name is not supported yet.");
+		if (!check_event_name(arg))
+			semantic_error("%s is bad for event name -it must "
+				       "follow C symbol-naming rule.", arg);
 		pp->event = strdup(arg);
 		arg = tmp;
 	}
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 5e4050c..a4086aa 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -1,9 +1,9 @@
 #ifndef _PROBE_FINDER_H
 #define _PROBE_FINDER_H
 
-#define MAX_PATH_LEN 256
-#define MAX_PROBE_BUFFER 1024
-#define MAX_PROBES 128
+#define MAX_PATH_LEN		 256
+#define MAX_PROBE_BUFFER	1024
+#define MAX_PROBES		 128
 
 static inline int is_c_varname(const char *name)
 {
@@ -12,48 +12,53 @@ static inline int is_c_varname(const char *name)
 }
 
 struct probe_point {
-	char	*event;		/* Event name */
-	char	*group;		/* Event group */
+	char			*event;			/* Event name */
+	char			*group;			/* Event group */
 
 	/* Inputs */
-	char	*file;		/* File name */
-	int	line;		/* Line number */
+	char			*file;			/* File name */
+	int			line;			/* Line number */
 
-	char	*function;	/* Function name */
-	int	offset;		/* Offset bytes */
+	char			*function;		/* Function name */
+	int			offset;			/* Offset bytes */
 
-	int	nr_args;	/* Number of arguments */
-	char	**args;		/* Arguments */
+	int			nr_args;		/* Number of arguments */
+	char			**args;			/* Arguments */
 
-	int	retprobe;	/* Return probe */
+	int			retprobe;		/* Return probe */
 
 	/* Output */
-	int	found;		/* Number of found probe points */
-	char	*probes[MAX_PROBES];	/* Output buffers (will be allocated)*/
+	int			found;			/* Number of found probe points */
+	char			*probes[MAX_PROBES];	/* Output buffers (will be allocated)*/
 };
 
 #ifndef NO_LIBDWARF
 extern int find_probepoint(int fd, struct probe_point *pp);
 
-#include <libdwarf/dwarf.h>
-#include <libdwarf/libdwarf.h>
+/* Workaround for undefined _MIPS_SZLONG bug in libdwarf.h: */
+#ifndef _MIPS_SZLONG
+# define _MIPS_SZLONG		0
+#endif
+
+#include <dwarf.h>
+#include <libdwarf.h>
 
 struct probe_finder {
-	struct probe_point	*pp;	/* Target probe point */
+	struct probe_point	*pp;			/* Target probe point */
 
 	/* For function searching */
-	Dwarf_Addr	addr;		/* Address */
-	Dwarf_Unsigned	fno;		/* File number */
-	Dwarf_Unsigned	lno;		/* Line number */
-	Dwarf_Off	inl_offs;	/* Inline offset */
-	Dwarf_Die	cu_die;		/* Current CU */
+	Dwarf_Addr		addr;			/* Address */
+	Dwarf_Unsigned		fno;			/* File number */
+	Dwarf_Unsigned		lno;			/* Line number */
+	Dwarf_Off		inl_offs;		/* Inline offset */
+	Dwarf_Die		cu_die;			/* Current CU */
 
 	/* For variable searching */
-	Dwarf_Addr	cu_base;	/* Current CU base address */
-	Dwarf_Locdesc	fbloc;		/* Location of Current Frame Base */
-	const char	*var;		/* Current variable name */
-	char		*buf;		/* Current output buffer */
-	int		len;		/* Length of output buffer */
+	Dwarf_Addr		cu_base;		/* Current CU base address */
+	Dwarf_Locdesc		fbloc;			/* Location of Current Frame Base */
+	const char		*var;			/* Current variable name */
+	char			*buf;			/* Current output buffer */
+	int			len;			/* Length of output buffer */
 };
 #endif /* NO_LIBDWARF */
 
