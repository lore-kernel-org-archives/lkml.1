Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZIUMxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZIUMxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 08:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbZIUMxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 08:53:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:54262 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986AbZIUMxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 08:53:46 -0400
Date: Mon, 21 Sep 2009 12:53:08 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, arjan@linux.intel.com,
       efault@gmx.de, fweisbec@gmail.com, benh@kernel.crashing.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       benh@kernel.crashing.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/rename] perf: Tidy up after the big rename
Message-ID: <tip-57c0c15b5244320065374ad2c54f4fbec77a6428@git.kernel.org>
Git-Commit-ID: 57c0c15b5244320065374ad2c54f4fbec77a6428
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 21 Sep 2009 12:53:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57c0c15b5244320065374ad2c54f4fbec77a6428
Gitweb:     http://git.kernel.org/tip/57c0c15b5244320065374ad2c54f4fbec77a6428
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 21 Sep 2009 12:20:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 21 Sep 2009 14:34:11 +0200

perf: Tidy up after the big rename

 - provide compatibility Kconfig entry for existing PERF_COUNTERS .config's

 - provide courtesy copy of old perf_counter.h, for user-space projects

 - small indentation fixups

 - fix up MAINTAINERS

 - fix small x86 printout fallout

 - fix up small PowerPC comment fallout (use 'counter' as in register)

Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 MAINTAINERS                      |    2 +-
 arch/powerpc/include/asm/paca.h  |    2 +-
 arch/powerpc/kernel/perf_event.c |   12 +-
 arch/x86/kernel/cpu/perf_event.c |   14 +-
 include/linux/perf_counter.h     |  441 ++++++++++++++++++++++++++++++++++++++
 include/linux/perf_event.h       |   98 +++++-----
 init/Kconfig                     |   37 +++-
 kernel/perf_event.c              |    4 +-
 8 files changed, 534 insertions(+), 76 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 43761a0..751a307 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4000,7 +4000,7 @@ S:	Maintained
 F:	include/linux/delayacct.h
 F:	kernel/delayacct.c
 
-PERFORMANCE COUNTER SUBSYSTEM
+PERFORMANCE EVENTS SUBSYSTEM
 M:	Peter Zijlstra <a.p.zijlstra@chello.nl>
 M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@elte.hu>
diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index 154f405..7d8514c 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -122,7 +122,7 @@ struct paca_struct {
 	u8 soft_enabled;		/* irq soft-enable flag */
 	u8 hard_enabled;		/* set if irqs are enabled in MSR */
 	u8 io_sync;			/* writel() needs spin_unlock sync */
-	u8 perf_event_pending;	/* PM interrupt while soft-disabled */
+	u8 perf_event_pending;		/* PM interrupt while soft-disabled */
 
 	/* Stuff for accurate time accounting */
 	u64 user_time;			/* accumulated usermode TB ticks */
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index c98321f..197b7d9 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -41,7 +41,7 @@ DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
 struct power_pmu *ppmu;
 
 /*
- * Normally, to ignore kernel events we set the FCS (freeze events
+ * Normally, to ignore kernel events we set the FCS (freeze counters
  * in supervisor mode) bit in MMCR0, but if the kernel runs with the
  * hypervisor bit set in the MSR, or if we are running on a processor
  * where the hypervisor bit is forced to 1 (as on Apple G5 processors),
@@ -159,7 +159,7 @@ void perf_event_print_debug(void)
 }
 
 /*
- * Read one performance monitor event (PMC).
+ * Read one performance monitor counter (PMC).
  */
 static unsigned long read_pmc(int idx)
 {
@@ -409,7 +409,7 @@ static void power_pmu_read(struct perf_event *event)
 		val = read_pmc(event->hw.idx);
 	} while (atomic64_cmpxchg(&event->hw.prev_count, prev, val) != prev);
 
-	/* The events are only 32 bits wide */
+	/* The counters are only 32 bits wide */
 	delta = (val - prev) & 0xfffffffful;
 	atomic64_add(delta, &event->count);
 	atomic64_sub(delta, &event->hw.period_left);
@@ -543,7 +543,7 @@ void hw_perf_disable(void)
 		}
 
 		/*
-		 * Set the 'freeze events' bit.
+		 * Set the 'freeze counters' bit.
 		 * The barrier is to make sure the mtspr has been
 		 * executed and the PMU has frozen the events
 		 * before we return.
@@ -1124,7 +1124,7 @@ const struct pmu *hw_perf_event_init(struct perf_event *event)
 }
 
 /*
- * A event has overflowed; update its count and record
+ * A counter has overflowed; update its count and record
  * things if requested.  Note that interrupts are hard-disabled
  * here so there is no possibility of being interrupted.
  */
@@ -1271,7 +1271,7 @@ static void perf_event_interrupt(struct pt_regs *regs)
 
 	/*
 	 * Reset MMCR0 to its normal value.  This will set PMXE and
-	 * clear FC (freeze events) and PMAO (perf mon alert occurred)
+	 * clear FC (freeze counters) and PMAO (perf mon alert occurred)
 	 * and thus allow interrupts to occur again.
 	 * XXX might want to use MSR.PM to keep the events frozen until
 	 * we get back out of this interrupt.
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 0d03629..a3c7adb 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2081,13 +2081,13 @@ void __init init_hw_perf_events(void)
 	perf_events_lapic_init();
 	register_die_notifier(&perf_event_nmi_notifier);
 
-	pr_info("... version:                 %d\n",     x86_pmu.version);
-	pr_info("... bit width:               %d\n",     x86_pmu.event_bits);
-	pr_info("... generic events:        %d\n",     x86_pmu.num_events);
-	pr_info("... value mask:              %016Lx\n", x86_pmu.event_mask);
-	pr_info("... max period:              %016Lx\n", x86_pmu.max_period);
-	pr_info("... fixed-purpose events:  %d\n",     x86_pmu.num_events_fixed);
-	pr_info("... event mask:            %016Lx\n", perf_event_mask);
+	pr_info("... version:                %d\n",     x86_pmu.version);
+	pr_info("... bit width:              %d\n",     x86_pmu.event_bits);
+	pr_info("... generic registers:      %d\n",     x86_pmu.num_events);
+	pr_info("... value mask:             %016Lx\n", x86_pmu.event_mask);
+	pr_info("... max period:             %016Lx\n", x86_pmu.max_period);
+	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_events_fixed);
+	pr_info("... event mask:             %016Lx\n", perf_event_mask);
 }
 
 static inline void x86_pmu_read(struct perf_event *event)
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
new file mode 100644
index 0000000..368bd70
--- /dev/null
+++ b/include/linux/perf_counter.h
@@ -0,0 +1,441 @@
+/*
+ *  NOTE: this file will be removed in a future kernel release, it is
+ *  provided as a courtesy copy of user-space code that relies on the
+ *  old (pre-rename) symbols and constants.
+ *
+ *  Performance events:
+ *
+ *    Copyright (C) 2008-2009, Thomas Gleixner <tglx@linutronix.de>
+ *    Copyright (C) 2008-2009, Red Hat, Inc., Ingo Molnar
+ *    Copyright (C) 2008-2009, Red Hat, Inc., Peter Zijlstra
+ *
+ *  Data type definitions, declarations, prototypes.
+ *
+ *    Started by: Thomas Gleixner and Ingo Molnar
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+#ifndef _LINUX_PERF_COUNTER_H
+#define _LINUX_PERF_COUNTER_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+#include <asm/byteorder.h>
+
+/*
+ * User-space ABI bits:
+ */
+
+/*
+ * attr.type
+ */
+enum perf_type_id {
+	PERF_TYPE_HARDWARE			= 0,
+	PERF_TYPE_SOFTWARE			= 1,
+	PERF_TYPE_TRACEPOINT			= 2,
+	PERF_TYPE_HW_CACHE			= 3,
+	PERF_TYPE_RAW				= 4,
+
+	PERF_TYPE_MAX,				/* non-ABI */
+};
+
+/*
+ * Generalized performance counter event types, used by the
+ * attr.event_id parameter of the sys_perf_counter_open()
+ * syscall:
+ */
+enum perf_hw_id {
+	/*
+	 * Common hardware events, generalized by the kernel:
+	 */
+	PERF_COUNT_HW_CPU_CYCLES		= 0,
+	PERF_COUNT_HW_INSTRUCTIONS		= 1,
+	PERF_COUNT_HW_CACHE_REFERENCES		= 2,
+	PERF_COUNT_HW_CACHE_MISSES		= 3,
+	PERF_COUNT_HW_BRANCH_INSTRUCTIONS	= 4,
+	PERF_COUNT_HW_BRANCH_MISSES		= 5,
+	PERF_COUNT_HW_BUS_CYCLES		= 6,
+
+	PERF_COUNT_HW_MAX,			/* non-ABI */
+};
+
+/*
+ * Generalized hardware cache counters:
+ *
+ *       { L1-D, L1-I, LLC, ITLB, DTLB, BPU } x
+ *       { read, write, prefetch } x
+ *       { accesses, misses }
+ */
+enum perf_hw_cache_id {
+	PERF_COUNT_HW_CACHE_L1D			= 0,
+	PERF_COUNT_HW_CACHE_L1I			= 1,
+	PERF_COUNT_HW_CACHE_LL			= 2,
+	PERF_COUNT_HW_CACHE_DTLB		= 3,
+	PERF_COUNT_HW_CACHE_ITLB		= 4,
+	PERF_COUNT_HW_CACHE_BPU			= 5,
+
+	PERF_COUNT_HW_CACHE_MAX,		/* non-ABI */
+};
+
+enum perf_hw_cache_op_id {
+	PERF_COUNT_HW_CACHE_OP_READ		= 0,
+	PERF_COUNT_HW_CACHE_OP_WRITE		= 1,
+	PERF_COUNT_HW_CACHE_OP_PREFETCH		= 2,
+
+	PERF_COUNT_HW_CACHE_OP_MAX,		/* non-ABI */
+};
+
+enum perf_hw_cache_op_result_id {
+	PERF_COUNT_HW_CACHE_RESULT_ACCESS	= 0,
+	PERF_COUNT_HW_CACHE_RESULT_MISS		= 1,
+
+	PERF_COUNT_HW_CACHE_RESULT_MAX,		/* non-ABI */
+};
+
+/*
+ * Special "software" counters provided by the kernel, even if the hardware
+ * does not support performance counters. These counters measure various
+ * physical and sw events of the kernel (and allow the profiling of them as
+ * well):
+ */
+enum perf_sw_ids {
+	PERF_COUNT_SW_CPU_CLOCK			= 0,
+	PERF_COUNT_SW_TASK_CLOCK		= 1,
+	PERF_COUNT_SW_PAGE_FAULTS		= 2,
+	PERF_COUNT_SW_CONTEXT_SWITCHES		= 3,
+	PERF_COUNT_SW_CPU_MIGRATIONS		= 4,
+	PERF_COUNT_SW_PAGE_FAULTS_MIN		= 5,
+	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
+
+	PERF_COUNT_SW_MAX,			/* non-ABI */
+};
+
+/*
+ * Bits that can be set in attr.sample_type to request information
+ * in the overflow packets.
+ */
+enum perf_counter_sample_format {
+	PERF_SAMPLE_IP				= 1U << 0,
+	PERF_SAMPLE_TID				= 1U << 1,
+	PERF_SAMPLE_TIME			= 1U << 2,
+	PERF_SAMPLE_ADDR			= 1U << 3,
+	PERF_SAMPLE_READ			= 1U << 4,
+	PERF_SAMPLE_CALLCHAIN			= 1U << 5,
+	PERF_SAMPLE_ID				= 1U << 6,
+	PERF_SAMPLE_CPU				= 1U << 7,
+	PERF_SAMPLE_PERIOD			= 1U << 8,
+	PERF_SAMPLE_STREAM_ID			= 1U << 9,
+	PERF_SAMPLE_RAW				= 1U << 10,
+
+	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
+};
+
+/*
+ * The format of the data returned by read() on a perf counter fd,
+ * as specified by attr.read_format:
+ *
+ * struct read_format {
+ *	{ u64		value;
+ *	  { u64		time_enabled; } && PERF_FORMAT_ENABLED
+ *	  { u64		time_running; } && PERF_FORMAT_RUNNING
+ *	  { u64		id;           } && PERF_FORMAT_ID
+ *	} && !PERF_FORMAT_GROUP
+ *
+ *	{ u64		nr;
+ *	  { u64		time_enabled; } && PERF_FORMAT_ENABLED
+ *	  { u64		time_running; } && PERF_FORMAT_RUNNING
+ *	  { u64		value;
+ *	    { u64	id;           } && PERF_FORMAT_ID
+ *	  }		cntr[nr];
+ *	} && PERF_FORMAT_GROUP
+ * };
+ */
+enum perf_counter_read_format {
+	PERF_FORMAT_TOTAL_TIME_ENABLED		= 1U << 0,
+	PERF_FORMAT_TOTAL_TIME_RUNNING		= 1U << 1,
+	PERF_FORMAT_ID				= 1U << 2,
+	PERF_FORMAT_GROUP			= 1U << 3,
+
+	PERF_FORMAT_MAX = 1U << 4, 		/* non-ABI */
+};
+
+#define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
+
+/*
+ * Hardware event to monitor via a performance monitoring counter:
+ */
+struct perf_counter_attr {
+
+	/*
+	 * Major type: hardware/software/tracepoint/etc.
+	 */
+	__u32			type;
+
+	/*
+	 * Size of the attr structure, for fwd/bwd compat.
+	 */
+	__u32			size;
+
+	/*
+	 * Type specific configuration information.
+	 */
+	__u64			config;
+
+	union {
+		__u64		sample_period;
+		__u64		sample_freq;
+	};
+
+	__u64			sample_type;
+	__u64			read_format;
+
+	__u64			disabled       :  1, /* off by default        */
+				inherit	       :  1, /* children inherit it   */
+				pinned	       :  1, /* must always be on PMU */
+				exclusive      :  1, /* only group on PMU     */
+				exclude_user   :  1, /* don't count user      */
+				exclude_kernel :  1, /* ditto kernel          */
+				exclude_hv     :  1, /* ditto hypervisor      */
+				exclude_idle   :  1, /* don't count when idle */
+				mmap           :  1, /* include mmap data     */
+				comm	       :  1, /* include comm data     */
+				freq           :  1, /* use freq, not period  */
+				inherit_stat   :  1, /* per task counts       */
+				enable_on_exec :  1, /* next exec enables     */
+				task           :  1, /* trace fork/exit       */
+				watermark      :  1, /* wakeup_watermark      */
+
+				__reserved_1   : 49;
+
+	union {
+		__u32		wakeup_events;	  /* wakeup every n events */
+		__u32		wakeup_watermark; /* bytes before wakeup   */
+	};
+	__u32			__reserved_2;
+
+	__u64			__reserved_3;
+};
+
+/*
+ * Ioctls that can be done on a perf counter fd:
+ */
+#define PERF_COUNTER_IOC_ENABLE		_IO ('$', 0)
+#define PERF_COUNTER_IOC_DISABLE	_IO ('$', 1)
+#define PERF_COUNTER_IOC_REFRESH	_IO ('$', 2)
+#define PERF_COUNTER_IOC_RESET		_IO ('$', 3)
+#define PERF_COUNTER_IOC_PERIOD		_IOW('$', 4, u64)
+#define PERF_COUNTER_IOC_SET_OUTPUT	_IO ('$', 5)
+
+enum perf_counter_ioc_flags {
+	PERF_IOC_FLAG_GROUP		= 1U << 0,
+};
+
+/*
+ * Structure of the page that can be mapped via mmap
+ */
+struct perf_counter_mmap_page {
+	__u32	version;		/* version number of this structure */
+	__u32	compat_version;		/* lowest version this is compat with */
+
+	/*
+	 * Bits needed to read the hw counters in user-space.
+	 *
+	 *   u32 seq;
+	 *   s64 count;
+	 *
+	 *   do {
+	 *     seq = pc->lock;
+	 *
+	 *     barrier()
+	 *     if (pc->index) {
+	 *       count = pmc_read(pc->index - 1);
+	 *       count += pc->offset;
+	 *     } else
+	 *       goto regular_read;
+	 *
+	 *     barrier();
+	 *   } while (pc->lock != seq);
+	 *
+	 * NOTE: for obvious reason this only works on self-monitoring
+	 *       processes.
+	 */
+	__u32	lock;			/* seqlock for synchronization */
+	__u32	index;			/* hardware counter identifier */
+	__s64	offset;			/* add to hardware counter value */
+	__u64	time_enabled;		/* time counter active */
+	__u64	time_running;		/* time counter on cpu */
+
+		/*
+		 * Hole for extension of the self monitor capabilities
+		 */
+
+	__u64	__reserved[123];	/* align to 1k */
+
+	/*
+	 * Control data for the mmap() data buffer.
+	 *
+	 * User-space reading the @data_head value should issue an rmb(), on
+	 * SMP capable platforms, after reading this value -- see
+	 * perf_counter_wakeup().
+	 *
+	 * When the mapping is PROT_WRITE the @data_tail value should be
+	 * written by userspace to reflect the last read data. In this case
+	 * the kernel will not over-write unread data.
+	 */
+	__u64   data_head;		/* head in the data section */
+	__u64	data_tail;		/* user-space written tail */
+};
+
+#define PERF_EVENT_MISC_CPUMODE_MASK		(3 << 0)
+#define PERF_EVENT_MISC_CPUMODE_UNKNOWN		(0 << 0)
+#define PERF_EVENT_MISC_KERNEL			(1 << 0)
+#define PERF_EVENT_MISC_USER			(2 << 0)
+#define PERF_EVENT_MISC_HYPERVISOR		(3 << 0)
+
+struct perf_event_header {
+	__u32	type;
+	__u16	misc;
+	__u16	size;
+};
+
+enum perf_event_type {
+
+	/*
+	 * The MMAP events record the PROT_EXEC mappings so that we can
+	 * correlate userspace IPs to code. They have the following structure:
+	 *
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *
+	 *	u32				pid, tid;
+	 *	u64				addr;
+	 *	u64				len;
+	 *	u64				pgoff;
+	 *	char				filename[];
+	 * };
+	 */
+	PERF_EVENT_MMAP			= 1,
+
+	/*
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *	u64				id;
+	 *	u64				lost;
+	 * };
+	 */
+	PERF_EVENT_LOST			= 2,
+
+	/*
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *
+	 *	u32				pid, tid;
+	 *	char				comm[];
+	 * };
+	 */
+	PERF_EVENT_COMM			= 3,
+
+	/*
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *	u32				pid, ppid;
+	 *	u32				tid, ptid;
+	 *	u64				time;
+	 * };
+	 */
+	PERF_EVENT_EXIT			= 4,
+
+	/*
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *	u64				time;
+	 *	u64				id;
+	 *	u64				stream_id;
+	 * };
+	 */
+	PERF_EVENT_THROTTLE		= 5,
+	PERF_EVENT_UNTHROTTLE		= 6,
+
+	/*
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *	u32				pid, ppid;
+	 *	u32				tid, ptid;
+	 *	{ u64				time;     } && PERF_SAMPLE_TIME
+	 * };
+	 */
+	PERF_EVENT_FORK			= 7,
+
+	/*
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *	u32				pid, tid;
+	 *
+	 *	struct read_format		values;
+	 * };
+	 */
+	PERF_EVENT_READ			= 8,
+
+	/*
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *
+	 *	{ u64			ip;	  } && PERF_SAMPLE_IP
+	 *	{ u32			pid, tid; } && PERF_SAMPLE_TID
+	 *	{ u64			time;     } && PERF_SAMPLE_TIME
+	 *	{ u64			addr;     } && PERF_SAMPLE_ADDR
+	 *	{ u64			id;	  } && PERF_SAMPLE_ID
+	 *	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
+	 *	{ u32			cpu, res; } && PERF_SAMPLE_CPU
+	 *	{ u64			period;   } && PERF_SAMPLE_PERIOD
+	 *
+	 *	{ struct read_format	values;	  } && PERF_SAMPLE_READ
+	 *
+	 *	{ u64			nr,
+	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
+	 *
+	 *	#
+	 *	# The RAW record below is opaque data wrt the ABI
+	 *	#
+	 *	# That is, the ABI doesn't make any promises wrt to
+	 *	# the stability of its content, it may vary depending
+	 *	# on event, hardware, kernel version and phase of
+	 *	# the moon.
+	 *	#
+	 *	# In other words, PERF_SAMPLE_RAW contents are not an ABI.
+	 *	#
+	 *
+	 *	{ u32			size;
+	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
+	 * };
+	 */
+	PERF_EVENT_SAMPLE		= 9,
+
+	PERF_EVENT_MAX,			/* non-ABI */
+};
+
+enum perf_callchain_context {
+	PERF_CONTEXT_HV			= (__u64)-32,
+	PERF_CONTEXT_KERNEL		= (__u64)-128,
+	PERF_CONTEXT_USER		= (__u64)-512,
+
+	PERF_CONTEXT_GUEST		= (__u64)-2048,
+	PERF_CONTEXT_GUEST_KERNEL	= (__u64)-2176,
+	PERF_CONTEXT_GUEST_USER		= (__u64)-2560,
+
+	PERF_CONTEXT_MAX		= (__u64)-4095,
+};
+
+#define PERF_FLAG_FD_NO_GROUP		(1U << 0)
+#define PERF_FLAG_FD_OUTPUT		(1U << 1)
+
+/*
+ * In case some app still references the old symbols:
+ */
+
+#define __NR_perf_counter_open		__NR_perf_event_open
+
+#define PR_TASK_PERF_COUNTERS_DISABLE	PR_TASK_PERF_EVENTS_DISABLE
+#define PR_TASK_PERF_COUNTERS_ENABLE	PR_TASK_PERF_EVENTS_ENABLE
+
+#endif /* _LINUX_PERF_COUNTER_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ae9d9ed..acefaf7 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1,15 +1,15 @@
 /*
- *  Performance events:
+ * Performance events:
  *
  *    Copyright (C) 2008-2009, Thomas Gleixner <tglx@linutronix.de>
  *    Copyright (C) 2008-2009, Red Hat, Inc., Ingo Molnar
  *    Copyright (C) 2008-2009, Red Hat, Inc., Peter Zijlstra
  *
- *  Data type definitions, declarations, prototypes.
+ * Data type definitions, declarations, prototypes.
  *
  *    Started by: Thomas Gleixner and Ingo Molnar
  *
- *  For licencing details see kernel-base/COPYING
+ * For licencing details see kernel-base/COPYING
  */
 #ifndef _LINUX_PERF_EVENT_H
 #define _LINUX_PERF_EVENT_H
@@ -131,19 +131,19 @@ enum perf_event_sample_format {
  * as specified by attr.read_format:
  *
  * struct read_format {
- * 	{ u64		value;
- * 	  { u64		time_enabled; } && PERF_FORMAT_ENABLED
- * 	  { u64		time_running; } && PERF_FORMAT_RUNNING
- * 	  { u64		id;           } && PERF_FORMAT_ID
- * 	} && !PERF_FORMAT_GROUP
+ *	{ u64		value;
+ *	  { u64		time_enabled; } && PERF_FORMAT_ENABLED
+ *	  { u64		time_running; } && PERF_FORMAT_RUNNING
+ *	  { u64		id;           } && PERF_FORMAT_ID
+ *	} && !PERF_FORMAT_GROUP
  *
- * 	{ u64		nr;
- * 	  { u64		time_enabled; } && PERF_FORMAT_ENABLED
- * 	  { u64		time_running; } && PERF_FORMAT_RUNNING
- * 	  { u64		value;
- * 	    { u64	id;           } && PERF_FORMAT_ID
- * 	  }		cntr[nr];
- * 	} && PERF_FORMAT_GROUP
+ *	{ u64		nr;
+ *	  { u64		time_enabled; } && PERF_FORMAT_ENABLED
+ *	  { u64		time_running; } && PERF_FORMAT_RUNNING
+ *	  { u64		value;
+ *	    { u64	id;           } && PERF_FORMAT_ID
+ *	  }		cntr[nr];
+ *	} && PERF_FORMAT_GROUP
  * };
  */
 enum perf_event_read_format {
@@ -152,7 +152,7 @@ enum perf_event_read_format {
 	PERF_FORMAT_ID				= 1U << 2,
 	PERF_FORMAT_GROUP			= 1U << 3,
 
-	PERF_FORMAT_MAX = 1U << 4, 		/* non-ABI */
+	PERF_FORMAT_MAX = 1U << 4,		/* non-ABI */
 };
 
 #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
@@ -216,8 +216,8 @@ struct perf_event_attr {
  * Ioctls that can be done on a perf event fd:
  */
 #define PERF_EVENT_IOC_ENABLE		_IO ('$', 0)
-#define PERF_EVENT_IOC_DISABLE	_IO ('$', 1)
-#define PERF_EVENT_IOC_REFRESH	_IO ('$', 2)
+#define PERF_EVENT_IOC_DISABLE		_IO ('$', 1)
+#define PERF_EVENT_IOC_REFRESH		_IO ('$', 2)
 #define PERF_EVENT_IOC_RESET		_IO ('$', 3)
 #define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, u64)
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
@@ -314,9 +314,9 @@ enum perf_event_type {
 
 	/*
 	 * struct {
-	 * 	struct perf_event_header	header;
-	 * 	u64				id;
-	 * 	u64				lost;
+	 *	struct perf_event_header	header;
+	 *	u64				id;
+	 *	u64				lost;
 	 * };
 	 */
 	PERF_RECORD_LOST			= 2,
@@ -383,23 +383,23 @@ enum perf_event_type {
 	 *	{ u64			id;	  } && PERF_SAMPLE_ID
 	 *	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
 	 *	{ u32			cpu, res; } && PERF_SAMPLE_CPU
-	 * 	{ u64			period;   } && PERF_SAMPLE_PERIOD
+	 *	{ u64			period;   } && PERF_SAMPLE_PERIOD
 	 *
 	 *	{ struct read_format	values;	  } && PERF_SAMPLE_READ
 	 *
 	 *	{ u64			nr,
 	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
 	 *
-	 * 	#
-	 * 	# The RAW record below is opaque data wrt the ABI
-	 * 	#
-	 * 	# That is, the ABI doesn't make any promises wrt to
-	 * 	# the stability of its content, it may vary depending
-	 * 	# on event_id, hardware, kernel version and phase of
-	 * 	# the moon.
-	 * 	#
-	 * 	# In other words, PERF_SAMPLE_RAW contents are not an ABI.
-	 * 	#
+	 *	#
+	 *	# The RAW record below is opaque data wrt the ABI
+	 *	#
+	 *	# That is, the ABI doesn't make any promises wrt to
+	 *	# the stability of its content, it may vary depending
+	 *	# on event, hardware, kernel version and phase of
+	 *	# the moon.
+	 *	#
+	 *	# In other words, PERF_SAMPLE_RAW contents are not an ABI.
+	 *	#
 	 *
 	 *	{ u32			size;
 	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
@@ -503,10 +503,10 @@ struct pmu {
  * enum perf_event_active_state - the states of a event
  */
 enum perf_event_active_state {
-	PERF_EVENT_STATE_ERROR	= -2,
+	PERF_EVENT_STATE_ERROR		= -2,
 	PERF_EVENT_STATE_OFF		= -1,
 	PERF_EVENT_STATE_INACTIVE	=  0,
-	PERF_EVENT_STATE_ACTIVE	=  1,
+	PERF_EVENT_STATE_ACTIVE		=  1,
 };
 
 struct file;
@@ -529,7 +529,7 @@ struct perf_mmap_data {
 
 	long				watermark;	/* wakeup watermark  */
 
-	struct perf_event_mmap_page   *user_page;
+	struct perf_event_mmap_page	*user_page;
 	void				*data_pages[0];
 };
 
@@ -694,14 +694,14 @@ struct perf_cpu_context {
 };
 
 struct perf_output_handle {
-	struct perf_event	*event;
-	struct perf_mmap_data	*data;
-	unsigned long		head;
-	unsigned long		offset;
-	int			nmi;
-	int			sample;
-	int			locked;
-	unsigned long		flags;
+	struct perf_event		*event;
+	struct perf_mmap_data		*data;
+	unsigned long			head;
+	unsigned long			offset;
+	int				nmi;
+	int				sample;
+	int				locked;
+	unsigned long			flags;
 };
 
 #ifdef CONFIG_PERF_EVENTS
@@ -829,22 +829,22 @@ static inline void
 perf_event_task_sched_out(struct task_struct *task,
 			    struct task_struct *next, int cpu)		{ }
 static inline void
-perf_event_task_tick(struct task_struct *task, int cpu)		{ }
+perf_event_task_tick(struct task_struct *task, int cpu)			{ }
 static inline int perf_event_init_task(struct task_struct *child)	{ return 0; }
 static inline void perf_event_exit_task(struct task_struct *child)	{ }
 static inline void perf_event_free_task(struct task_struct *task)	{ }
-static inline void perf_event_do_pending(void)			{ }
-static inline void perf_event_print_debug(void)			{ }
+static inline void perf_event_do_pending(void)				{ }
+static inline void perf_event_print_debug(void)				{ }
 static inline void perf_disable(void)					{ }
 static inline void perf_enable(void)					{ }
-static inline int perf_event_task_disable(void)	{ return -EINVAL; }
-static inline int perf_event_task_enable(void)	{ return -EINVAL; }
+static inline int perf_event_task_disable(void)				{ return -EINVAL; }
+static inline int perf_event_task_enable(void)				{ return -EINVAL; }
 
 static inline void
 perf_sw_event(u32 event_id, u64 nr, int nmi,
 		     struct pt_regs *regs, u64 addr)			{ }
 
-static inline void perf_event_mmap(struct vm_area_struct *vma)	{ }
+static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
 static inline void perf_event_comm(struct task_struct *tsk)		{ }
 static inline void perf_event_fork(struct task_struct *tsk)		{ }
 static inline void perf_event_init(void)				{ }
diff --git a/init/Kconfig b/init/Kconfig
index cfdf5c3..706728b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -920,26 +920,31 @@ config HAVE_PERF_EVENTS
 	help
 	  See tools/perf/design.txt for details.
 
-menu "Performance Counters"
+menu "Kernel Performance Events And Counters"
 
 config PERF_EVENTS
-	bool "Kernel Performance Counters"
-	default y if PROFILING
+	bool "Kernel performance events and counters"
+	default y if (PROFILING || PERF_COUNTERS)
 	depends on HAVE_PERF_EVENTS
 	select ANON_INODES
 	help
-	  Enable kernel support for performance counter hardware.
+	  Enable kernel support for various performance events provided
+	  by software and hardware.
 
-	  Performance counters are special hardware registers available
-	  on most modern CPUs. These registers count the number of certain
+	  Software events are supported either build-in or via the
+	  use of generic tracepoints.
+
+	  Most modern CPUs support performance events via performance
+	  counter registers. These registers count the number of certain
 	  types of hw events: such as instructions executed, cachemisses
 	  suffered, or branches mis-predicted - without slowing down the
 	  kernel or applications. These registers can also trigger interrupts
 	  when a threshold number of events have passed - and can thus be
 	  used to profile the code that runs on that CPU.
 
-	  The Linux Performance Counter subsystem provides an abstraction of
-	  these hardware capabilities, available via a system call. It
+	  The Linux Performance Event subsystem provides an abstraction of
+	  these software and hardware cevent apabilities, available via a
+	  system call and used by the "perf" utility in tools/perf/. It
 	  provides per task and per CPU counters, and it provides event
 	  capabilities on top of those.
 
@@ -950,14 +955,26 @@ config EVENT_PROFILE
 	depends on PERF_EVENTS && EVENT_TRACING
 	default y
 	help
-	 Allow the use of tracepoints as software performance counters.
+	 Allow the use of tracepoints as software performance events.
 
-	 When this is enabled, you can create perf counters based on
+	 When this is enabled, you can create perf events based on
 	 tracepoints using PERF_TYPE_TRACEPOINT and the tracepoint ID
 	 found in debugfs://tracing/events/*/*/id. (The -e/--events
 	 option to the perf tool can parse and interpret symbolic
 	 tracepoints, in the subsystem:tracepoint_name format.)
 
+config PERF_COUNTERS
+	bool "Kernel performance counters (old config option)"
+	depends on HAVE_PERF_EVENTS
+	help
+	  This config has been obsoleted by the PERF_EVENTS
+	  config option - please see that one for details.
+
+	  It has no effect on the kernel whether you enable
+	  it or not, it is a compatibility placeholder.
+
+	  Say N if unsure.
+
 endmenu
 
 config VM_EVENT_COUNTERS
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 6e8b99a..76ac4db 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1,12 +1,12 @@
 /*
- * Performance event core code
+ * Performance events core code:
  *
  *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
  *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
  *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
  *  Copyright  ©  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
  *
- *  For licensing details see kernel-base/COPYING
+ * For licensing details see kernel-base/COPYING
  */
 
 #include <linux/fs.h>
