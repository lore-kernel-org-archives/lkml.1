Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbXLETAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbXLETAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXLETAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:00:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:2101 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbXLETAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:00:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,255,1194249600"; 
   d="scan'208";a="238395184"
Date: Wed, 5 Dec 2007 19:59:20 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@gmail.com, suresh.b.siddha@intel.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com
Subject: [patch 1/2] x86, ptrace: support for branch trace store(BTS)
Message-ID: <20071205195920.A19413@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Resend using different mail client


Changes to the last version:
- split implementation into two layers: ds/bts and ptrace
- renamed TIF's
- save/restore ds save area msr in __switch_to_xtra()
- make block-stepping only look at BTF bit


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6-x86/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/process_32.c	2007-12-04 16:44:47.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/process_32.c	2007-12-04 18:12:42.%N +0100
@@ -594,11 +594,21 @@
 		 struct tss_struct *tss)
 {
 	struct thread_struct *prev, *next;
+	unsigned long debugctl;
 
 	prev = &prev_p->thread;
 	next = &next_p->thread;
 
-	if (next->debugctlmsr != prev->debugctlmsr)
+	debugctl = prev->debugctlmsr;
+	if (next->ds_area_msr != prev->ds_area_msr) {
+		/* we clear debugctl to make sure DS
+		 * is not in use when we change it */
+		debugctl = 0;
+		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0);
+		wrmsr(MSR_IA32_DS_AREA, next->ds_area_msr, 0);
+	}
+
+	if (next->debugctlmsr != debugctl)
 		wrmsr(MSR_IA32_DEBUGCTLMSR, next->debugctlmsr, 0);
 
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
@@ -622,6 +632,13 @@
 	}
 #endif
 
+	if (test_tsk_thread_flag(prev_p, TIF_BTS_TRACE_TS))
+		ptrace_bts_take_timestamp(prev_p, BTS_TASK_DEPARTS);
+
+	if (test_tsk_thread_flag(next_p, TIF_BTS_TRACE_TS))
+		ptrace_bts_take_timestamp(next_p, BTS_TASK_ARRIVES);
+
+
 	if (!test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
 		/*
 		 * Disable the bitmap via an invalid offset. We still cache
Index: linux-2.6-x86/include/asm-x86/ptrace-abi.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ptrace-abi.h	2007-12-04 16:44:47.%N +0100
+++ linux-2.6-x86/include/asm-x86/ptrace-abi.h	2007-12-04 17:21:28.%N +0100
@@ -80,4 +80,56 @@
 
 #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
 
+/* Return maximal BTS buffer size in number of records,
+   if successuf; -1, otherwise.
+   EOPNOTSUPP...processor does not support bts tracing */
+#define PTRACE_BTS_MAX_BUFFER_SIZE 40
+
+/* Allocate new bts buffer (free old one, if exists) of size DATA bts records;
+   parameter ADDR is ignored.
+   Return 0, if successful; -1, otherwise.
+   EOPNOTSUPP...processor does not support bts tracing
+   EINVAL.......invalid size in records
+   ENOMEM.......out of memory */
+#define PTRACE_BTS_ALLOCATE_BUFFER 41
+
+/* Return the size of the bts buffer in number of bts records,
+   if successful; -1, otherwise.
+   EOPNOTSUPP...processor does not support bts tracing
+   ENXIO........no buffer allocated */
+#define PTRACE_BTS_GET_BUFFER_SIZE 42
+
+/* Return the index of the next bts record to be written,
+   if successful; -1, otherwise.
+   EOPNOTSUPP...processor does not support bts tracing
+   ENXIO........no buffer allocated
+   After the first warp-around, this is the start of the circular bts buffer. */
+#define PTRACE_BTS_GET_INDEX 43
+
+/* Read the DATA'th bts record into a ptrace_bts_record buffer provided in ADDR.
+   Return 0, if successful; -1, otherwise
+   EOPNOTSUPP...processor does not support bts tracing
+   ENXIO........no buffer allocated
+   EINVAL.......invalid index */
+#define PTRACE_BTS_READ_RECORD 44
+
+/* Configure last branch trace; the configuration is given as a bit-mask of
+   PTRACE_BTS_O_* options in DATA; parameter ADDR is ignored.
+   Return 0, if successful; -1, otherwise
+   EOPNOTSUPP...processor does not support bts tracing
+   ENXIO........no buffer allocated */
+#define PTRACE_BTS_CONFIG 45
+
+/* Return the configuration as bit-mask of PTRACE_BTS_O_* options
+   if successful; -1, otherwise.
+   EOPNOTSUPP...processor does not support bts tracing
+   ENXIO........no buffer allocated */
+#define PTRACE_BTS_STATUS 46
+
+/* Trace configuration options */
+/* Collect last branch trace */
+#define PTRACE_BTS_O_TRACE_TASK 0x1
+/* Take timestamps when the task arrives and departs */
+#define PTRACE_BTS_O_TIMESTAMPS 0x2
+
 #endif
Index: linux-2.6-x86/include/asm-x86/ptrace.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ptrace.h	2007-12-04 16:44:47.%N +0100
+++ linux-2.6-x86/include/asm-x86/ptrace.h	2007-12-04 18:17:52.%N +0100
@@ -4,8 +4,19 @@
 #include <linux/compiler.h>	/* For __user */
 #include <asm/ptrace-abi.h>
 
+
 #ifndef __ASSEMBLY__
 
+#ifdef __KERNEL__
+
+#include <asm/ds.h>
+
+struct task_struct;
+extern void ptrace_bts_take_timestamp(struct task_struct *, enum bts_qualifier);
+
+#endif /* __KERNEL__ */
+
+
 #ifdef __i386__
 /* this struct defines the way the registers are stored on the
    stack during a system call. */
Index: linux-2.6-x86/arch/x86/kernel/Makefile_32
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/Makefile_32	2007-12-04 16:44:47.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/Makefile_32	2007-12-04 17:21:28.%N +0100
@@ -11,6 +11,7 @@
 		quirks.o i8237.o topology.o alternative.o i8253.o tsc_32.o rtc.o
 
 obj-y				+= ptrace.o
+obj-y				+= ds.o
 obj-y				+= tls.o
 obj-y				+= step.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
Index: linux-2.6-x86/include/asm-x86/thread_info_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/thread_info_32.h	2007-12-04 16:44:47.%N +0100
+++ linux-2.6-x86/include/asm-x86/thread_info_32.h	2007-12-04 17:21:28.%N +0100
@@ -139,6 +139,8 @@
 #define TIF_NOTSC		20	/* TSC is not accessible in userland */
 #define TIF_FORCED_TF		21	/* true if TF in eflags artificially */
 #define TIF_DEBUGCTLMSR		22	/* uses thread_struct.debugctlmsr */
+#define TIF_DS_AREA_MSR 	23      /* uses thread_struct.ds_area_msr */
+#define TIF_BTS_TRACE_TS        24      /* record scheduling event timestamps */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -155,6 +157,8 @@
 #define _TIF_NOTSC		(1<<TIF_NOTSC)
 #define _TIF_FORCED_TF		(1<<TIF_FORCED_TF)
 #define _TIF_DEBUGCTLMSR	(1<<TIF_DEBUGCTLMSR)
+#define _TIF_DS_AREA_MSR	(1<<TIF_DS_AREA_MSR)
+#define _TIF_BTS_TRACE_TS	(1<<TIF_BTS_TRACE_TS)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
@@ -164,8 +168,12 @@
 #define _TIF_ALLWORK_MASK	(0x0000FFFF & ~_TIF_SECCOMP)
 
 /* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW_NEXT (_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_DEBUG | _TIF_DEBUGCTLMSR)
-#define _TIF_WORK_CTXSW_PREV (_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_DEBUGCTLMSR)
+#define _TIF_WORK_CTXSW \
+    (_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_DEBUGCTLMSR | \
+     _TIF_DS_AREA_MSR | _TIF_BTS_TRACE_TS)
+#define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
+#define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW | _TIF_DEBUG)
+
 
 /*
  * Thread-synchronous status.
Index: linux-2.6-x86/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_32.h	2007-12-04 16:44:47.%N +0100
+++ linux-2.6-x86/include/asm-x86/processor_32.h	2007-12-04 17:21:28.%N +0100
@@ -360,6 +360,9 @@
 	unsigned long	io_bitmap_max;
 /* MSR_IA32_DEBUGCTLMSR value to switch in if TIF_DEBUGCTLMSR is set.  */
 	unsigned long	debugctlmsr;
+/* Debug Store - if not 0 points to a DS Save Area configuration;
+ *               goes into MSR_IA32_DS_AREA */
+	unsigned long	ds_area_msr;
 };
 
 #define INIT_THREAD  {							\
Index: linux-2.6-x86/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/process_64.c	2007-12-04 16:44:47.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/process_64.c	2007-12-04 18:13:10.%N +0100
@@ -550,11 +550,21 @@
 				    struct tss_struct *tss)
 {
 	struct thread_struct *prev, *next;
+	unsigned long debugctl;
 
 	prev = &prev_p->thread,
 	next = &next_p->thread;
 
-	if (next->debugctlmsr != prev->debugctlmsr)
+	debugctl = prev->debugctlmsr;
+	if (next->ds_area_msr != prev->ds_area_msr) {
+		/* we clear debugctl to make sure DS
+		 * is not in use when we change it */
+		debugctl = 0;
+		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0);
+		wrmsrl(MSR_IA32_DS_AREA, next->ds_area_msr);
+	}
+
+	if (next->debugctlmsr != debugctl)
 		wrmsrl(MSR_IA32_DEBUGCTLMSR, next->debugctlmsr);
 
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
@@ -580,6 +590,16 @@
 		 */
 		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
 	}
+
+	/*
+	 * Last branch recording recofiguration of trace hardware and
+	 * disentangling of trace data per task.
+	 */
+	if (test_tsk_thread_flag(prev_p, TIF_BTS_TRACE_TS))
+		ptrace_bts_take_timestamp(prev_p, BTS_TASK_DEPARTS);
+
+	if (test_tsk_thread_flag(next_p, TIF_BTS_TRACE_TS))
+		ptrace_bts_take_timestamp(next_p, BTS_TASK_ARRIVES);
 }
 
 /*
@@ -683,8 +703,8 @@
 	/*
 	 * Now maybe reload the debug registers and handle I/O bitmaps
 	 */
-	if (unlikely((task_thread_info(next_p)->flags & _TIF_WORK_CTXSW))
-	    || test_tsk_thread_flag(prev_p, TIF_IO_BITMAP))
+	if (unlikely(task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT ||
+		     task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW_PREV))
 		__switch_to_xtra(prev_p, next_p, tss);
 
 	/* If the task has used fpu the last 5 timeslices, just do a full
Index: linux-2.6-x86/include/asm-x86/processor_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_64.h	2007-12-04 16:44:47.%N +0100
+++ linux-2.6-x86/include/asm-x86/processor_64.h	2007-12-04 17:21:28.%N +0100
@@ -240,6 +240,9 @@
 	unsigned io_bitmap_max;
 /* MSR_IA32_DEBUGCTLMSR value to switch in if TIF_DEBUGCTLMSR is set.  */
 	unsigned long	debugctlmsr;
+/* Debug Store - if not 0 points to a DS Save Area configuration;
+ *               goes into MSR_IA32_DS_AREA */
+	unsigned long	ds_area_msr;
 /* cached TLS descriptors. */
 	u64 tls_array[GDT_ENTRY_TLS_ENTRIES];
 } __attribute__((aligned(16)));
Index: linux-2.6-x86/include/asm-x86/thread_info_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/thread_info_64.h	2007-12-04 16:44:47.%N +0100
+++ linux-2.6-x86/include/asm-x86/thread_info_64.h	2007-12-04 17:21:28.%N +0100
@@ -121,6 +121,8 @@
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
 #define TIF_FREEZE		23	/* is freezing for suspend */
 #define TIF_DEBUGCTLMSR		24	/* uses thread_struct.debugctlmsr */
+#define TIF_DS_AREA_MSR 	25      /* uses thread_struct.ds_area_msr */
+#define TIF_BTS_TRACE_TS	26      /* record scheduling event timestamps */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -139,6 +141,8 @@
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_DEBUGCTLMSR	(1<<TIF_DEBUGCTLMSR)
+#define _TIF_DS_AREA_MSR	(1<<TIF_DS_AREA_MSR)
+#define _TIF_BTS_TRACE_TS	(1<<TIF_BTS_TRACE_TS)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
@@ -147,7 +151,10 @@
 #define _TIF_ALLWORK_MASK (0x0000FFFF & ~_TIF_SECCOMP)
 
 /* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW (_TIF_DEBUG|_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR)
+#define _TIF_WORK_CTXSW \
+    (_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_BTS_TRACE_TS)
+#define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
+#define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)
 
 #define PREEMPT_ACTIVE     0x10000000
 
Index: linux-2.6-x86/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/cpu/intel.c	2007-12-04 16:44:47.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/cpu/intel.c	2007-12-04 17:21:28.%N +0100
@@ -11,6 +11,8 @@
 #include <asm/pgtable.h>
 #include <asm/msr.h>
 #include <asm/uaccess.h>
+#include <asm/ptrace.h>
+#include <asm/ds.h>
 
 #include "cpu.h"
 
@@ -219,6 +221,9 @@
 		if (!(l1 & (1<<12)))
 			set_bit(X86_FEATURE_PEBS, c->x86_capability);
 	}
+
+	if (cpu_has_bts)
+		ds_init_intel(c);
 }
 
 static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 * c, unsigned int size)
Index: linux-2.6-x86/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/setup_64.c	2007-12-04 16:44:47.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/setup_64.c	2007-12-04 17:21:28.%N +0100
@@ -60,6 +60,7 @@
 #include <asm/dmi.h>
 #include <asm/cacheflush.h>
 #include <asm/mce.h>
+#include <asm/ds.h>
 
 /*
  * Machine setup..
@@ -850,6 +851,10 @@
 			set_cpu_cap(c, X86_FEATURE_PEBS);
 	}
 
+
+	if (cpu_has_bts)
+		ds_init_intel(c);
+
 	n = c->extended_cpuid_level;
 	if (n >= 0x80000008) {
 		unsigned eax = cpuid_eax(0x80000008);
Index: linux-2.6-x86/arch/x86/kernel/ptrace.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/ptrace.c	2007-12-04 16:44:47.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/ptrace.c	2007-12-04 18:13:37.%N +0100
@@ -2,6 +2,9 @@
 /*
  * Pentium III FXSR, SSE support
  *	Gareth Hughes <gareth@valinux.com>, May 2000
+ *
+ * BTS tracing
+ *	Markus Metzger <markus.t.metzger@intel.com>, Dec 2007
  */
 
 #include <linux/kernel.h>
@@ -26,6 +29,14 @@
 #include <asm/desc.h>
 #include <asm/prctl.h>
 #include <asm/proto.h>
+#include <asm/ds.h>
+
+
+/*
+ * The maximal size of a BTS buffer per traced task in number of BTS
+ * records.
+ */
+#define PTRACE_BTS_BUFFER_MAX 4000
 
 /*
  * does not yet catch signals sent when the child dies.
@@ -455,6 +466,165 @@
 	return 0;
 }
 
+static int ptrace_bts_max_buffer_size(void)
+{
+	return PTRACE_BTS_BUFFER_MAX;
+}
+
+static int ptrace_bts_get_buffer_size(struct task_struct *child)
+{
+	if (!child->thread.ds_area_msr)
+		return -ENXIO;
+
+	return ds_get_bts_size((void *)child->thread.ds_area_msr);
+}
+
+static int ptrace_bts_get_index(struct task_struct *child)
+{
+	if (!child->thread.ds_area_msr)
+		return -ENXIO;
+
+	return ds_get_bts_index((void *)child->thread.ds_area_msr);
+}
+
+static int ptrace_bts_read_record(struct task_struct *child,
+				  long index,
+				  struct bts_struct __user *out)
+{
+	struct bts_struct ret;
+	int retval;
+
+	if (!child->thread.ds_area_msr)
+		return -ENXIO;
+
+	retval = ds_read_bts((void *)child->thread.ds_area_msr,
+			     index, &ret);
+	if (retval)
+		return retval;
+
+	if (copy_to_user(out, &ret, sizeof(ret)))
+		return -EFAULT;
+
+	return sizeof(ret);
+}
+
+static int ptrace_bts_write_record(struct task_struct *child,
+				   const struct bts_struct *in)
+{
+	int retval;
+
+	if (!child->thread.ds_area_msr)
+		return -ENXIO;
+
+	retval = ds_write_bts((void *)child->thread.ds_area_msr, in);
+	if (retval)
+		return retval;
+
+	return sizeof(*in);
+}
+
+static int ptrace_bts_config(struct task_struct *child,
+			     unsigned long options)
+{
+	unsigned long debugctl_mask = ds_debugctl_mask();
+	int retval;
+
+	retval = ptrace_bts_get_buffer_size(child);
+	if (retval < 0)
+		return retval;
+	if (retval == 0)
+		return -ENXIO;
+
+	if (options & PTRACE_BTS_O_TRACE_TASK) {
+		child->thread.debugctlmsr |= debugctl_mask;
+		set_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
+	} else {
+		/* there is no way for us to check whether we 'own'
+		 * the respective bits in the DEBUGCTL MSR, we're
+		 * about to clear */
+		child->thread.debugctlmsr &= ~debugctl_mask;
+
+		if (!child->thread.debugctlmsr)
+			clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
+	}
+
+	if (options & PTRACE_BTS_O_TIMESTAMPS)
+		set_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
+	else
+		clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
+
+	return 0;
+}
+
+static int ptrace_bts_status(struct task_struct *child)
+{
+	unsigned long debugctl_mask = ds_debugctl_mask();
+	int retval, status = 0;
+
+	retval = ptrace_bts_get_buffer_size(child);
+	if (retval < 0)
+		return retval;
+	if (retval == 0)
+		return -ENXIO;
+
+	if (ptrace_bts_get_buffer_size(child) <= 0)
+		return -ENXIO;
+
+	if (test_tsk_thread_flag(child, TIF_DEBUGCTLMSR) &&
+	    child->thread.debugctlmsr & debugctl_mask)
+		status |= PTRACE_BTS_O_TRACE_TASK;
+	if (test_tsk_thread_flag(child, TIF_BTS_TRACE_TS))
+		status |= PTRACE_BTS_O_TIMESTAMPS;
+
+	return status;
+}
+
+static int ptrace_bts_allocate_bts(struct task_struct *child,
+				   int size_in_records)
+{
+	int retval = 0;
+	void *ds;
+
+	if (size_in_records < 0)
+		return -EINVAL;
+
+	if (size_in_records > ptrace_bts_max_buffer_size())
+		return -EINVAL;
+
+	if (size_in_records == 0) {
+		ptrace_bts_config(child, /* options = */ 0);
+	} else {
+		retval = ds_allocate(&ds, size_in_records);
+		if (retval)
+			return retval;
+	}
+
+	if (child->thread.ds_area_msr)
+		ds_free((void **)&child->thread.ds_area_msr);
+
+	child->thread.ds_area_msr = (unsigned long)ds;
+	if (child->thread.ds_area_msr)
+		set_tsk_thread_flag(child, TIF_DS_AREA_MSR);
+	else
+		clear_tsk_thread_flag(child, TIF_DS_AREA_MSR);
+
+	return retval;
+}
+
+void ptrace_bts_take_timestamp(struct task_struct *tsk,
+			       enum bts_qualifier qualifier)
+{
+	struct bts_struct rec = {
+		.qualifier = qualifier,
+		.variant.timestamp = sched_clock()
+	};
+
+	if (ptrace_bts_get_buffer_size(tsk) <= 0)
+		return;
+
+	ptrace_bts_write_record(tsk, &rec);
+}
+
 /*
  * Called by kernel/ptrace.c when detaching..
  *
@@ -466,6 +636,11 @@
 #ifdef TIF_SYSCALL_EMU
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 #endif
+	ptrace_bts_config(child, /* options = */ 0);
+	if (child->thread.ds_area_msr) {
+	    ds_free((void **)&child->thread.ds_area_msr);
+	    clear_tsk_thread_flag(child, TIF_DS_AREA_MSR);
+	}
 }
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
@@ -626,6 +801,36 @@
 		break;
 #endif
 
+	case PTRACE_BTS_MAX_BUFFER_SIZE:
+		ret = ptrace_bts_max_buffer_size();
+		break;
+
+	case PTRACE_BTS_ALLOCATE_BUFFER:
+		ret = ptrace_bts_allocate_bts(child, data);
+		break;
+
+	case PTRACE_BTS_GET_BUFFER_SIZE:
+		ret = ptrace_bts_get_buffer_size(child);
+		break;
+
+	case PTRACE_BTS_GET_INDEX:
+		ret = ptrace_bts_get_index(child);
+		break;
+
+	case PTRACE_BTS_READ_RECORD:
+		ret = ptrace_bts_read_record
+			(child, data,
+			 (struct bts_struct __user *) addr);
+		break;
+
+	case PTRACE_BTS_CONFIG:
+		ret = ptrace_bts_config(child, data);
+		break;
+
+	case PTRACE_BTS_STATUS:
+		ret = ptrace_bts_status(child);
+		break;
+
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
@@ -809,6 +1014,13 @@
 	case PTRACE_SETOPTIONS:
 	case PTRACE_SET_THREAD_AREA:
 	case PTRACE_GET_THREAD_AREA:
+	case PTRACE_BTS_MAX_BUFFER_SIZE:
+	case PTRACE_BTS_ALLOCATE_BUFFER:
+	case PTRACE_BTS_GET_BUFFER_SIZE:
+	case PTRACE_BTS_GET_INDEX:
+	case PTRACE_BTS_READ_RECORD:
+	case PTRACE_BTS_CONFIG:
+	case PTRACE_BTS_STATUS:
 		return sys_ptrace(request, pid, addr, data);
 
 	default:
Index: linux-2.6-x86/arch/x86/kernel/Makefile_64
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/Makefile_64	2007-12-04 16:44:47.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/Makefile_64	2007-12-04 17:21:28.%N +0100
@@ -13,6 +13,7 @@
 		i8253.o rtc.o
 
 obj-y				+= ptrace.o
+obj-y				+= ds.o
 obj-y				+= step.o
 
 obj-$(CONFIG_IA32_EMULATION)	+= tls.o
Index: linux-2.6-x86/arch/x86/kernel/step.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/step.c	2007-12-04 16:44:47.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/step.c	2007-12-04 17:21:28.%N +0100
@@ -169,9 +169,14 @@
 	 */
 	if (enable_single_step(child) && block) {
 		set_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
-		write_debugctlmsr(child, DEBUGCTLMSR_BTF);
-	} else if (test_and_clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR)) {
-		write_debugctlmsr(child, 0);
+		write_debugctlmsr(child,
+				  child->thread.debugctlmsr | DEBUGCTLMSR_BTF);
+	} else {
+	    write_debugctlmsr(child,
+			      child->thread.debugctlmsr & ~TIF_DEBUGCTLMSR);
+
+	    if (!child->thread.debugctlmsr)
+		    clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
 	}
 }
 
@@ -190,8 +195,11 @@
 	/*
 	 * Make sure block stepping (BTF) is disabled.
 	 */
-	if (test_and_clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR))
-		write_debugctlmsr(child, 0);
+	write_debugctlmsr(child,
+			  child->thread.debugctlmsr & ~TIF_DEBUGCTLMSR);
+
+	if (!child->thread.debugctlmsr)
+		clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
 
 	/* Always clear TIF_SINGLESTEP... */
 	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
Index: linux-2.6-x86/arch/x86/kernel/ds.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-x86/arch/x86/kernel/ds.c	2007-12-04 17:21:28.%N +0100
@@ -0,0 +1,429 @@
+/*
+ * Debug Store support
+ *
+ * This provides a low-level interface to the hardware's Debug Store
+ * feature that is used for last branch recording (LBR) and
+ * precise-event based sampling (PEBS).
+ *
+ * Different architectures use a different DS layout/pointer size.
+ * The below functions therefore work on a void*.
+ *
+ *
+ * Since there is no user for PEBS, yet, only LBR (or branch
+ * trace store, BTS) is supported.
+ *
+ *
+ * Copyright (C) 2007 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, Dec 2007
+ */
+
+#include <asm/ds.h>
+
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+
+
+/*
+ * Debug Store (DS) save area configuration (see Intel64 and IA32
+ * Architectures Software Developer's Manual, section 18.5)
+ *
+ * The DS configuration consists of the following fields; different
+ * architetures vary in the size of those fields.
+ * - double-word aligned base linear address of the BTS buffer
+ * - write pointer into the BTS buffer
+ * - end linear address of the BTS buffer (one byte beyond the end of
+ *   the buffer)
+ * - interrupt pointer into BTS buffer
+ *   (interrupt occurs when write pointer passes interrupt pointer)
+ * - double-word aligned base linear address of the PEBS buffer
+ * - write pointer into the PEBS buffer
+ * - end linear address of the PEBS buffer (one byte beyond the end of
+ *   the buffer)
+ * - interrupt pointer into PEBS buffer
+ *   (interrupt occurs when write pointer passes interrupt pointer)
+ * - value to which counter is reset following counter overflow
+ *
+ * On later architectures, the last branch recording hardware uses
+ * 64bit pointers even in 32bit mode.
+ *
+ *
+ * Branch Trace Store (BTS) records store information about control
+ * flow changes. They at least provide the following information:
+ * - source linear address
+ * - destination linear address
+ *
+ * Netburst supported a predicated bit that had been dropped in later
+ * architectures. We do not suppor it.
+ *
+ *
+ * In order to abstract from the actual DS and BTS layout, we describe
+ * the access to the relevant fields.
+ * Thanks to Andi Kleen for proposing this design.
+ *
+ * The implementation, however, is not as general as it might seem. In
+ * order to stay somewhat simple and efficient, we assume an
+ * underlying unsigned type (mostly a pointer type) and we expect the
+ * field to be at least as big as that type.
+ */
+
+/*
+ * A special from_ip address to indicate that the BTS record is an
+ * info record that needs to be interpreted or skipped.
+ */
+#define BTS_ESCAPE_ADDRESS (-1)
+
+/*
+ * A field access descriptor
+ */
+struct access_desc {
+	unsigned char offset;
+	unsigned char size;
+};
+
+/*
+ * The configuration for a particular DS/BTS hardware implementation.
+ */
+struct ds_configuration {
+	/* the DS configuration */
+	unsigned char  sizeof_ds;
+	struct access_desc bts_buffer_base;
+	struct access_desc bts_index;
+	struct access_desc bts_absolute_maximum;
+	struct access_desc bts_interrupt_threshold;
+	/* the BTS configuration */
+	unsigned char  sizeof_bts;
+	struct access_desc from_ip;
+	struct access_desc to_ip;
+	/* BTS variants used to store additional information like
+	   timestamps */
+	struct access_desc info_type;
+	struct access_desc info_data;
+	unsigned long debugctl_mask;
+};
+
+/*
+ * The global configuration used by the below accessor functions
+ */
+static struct ds_configuration ds_cfg;
+
+/*
+ * Accessor functions for some DS and BTS fields using the above
+ * global ptrace_bts_cfg.
+ */
+static inline void *get_bts_buffer_base(char *base)
+{
+	return *(void **)(base + ds_cfg.bts_buffer_base.offset);
+}
+static inline void set_bts_buffer_base(char *base, void *value)
+{
+	(*(void **)(base + ds_cfg.bts_buffer_base.offset)) = value;
+}
+static inline void *get_bts_index(char *base)
+{
+	return *(void **)(base + ds_cfg.bts_index.offset);
+}
+static inline void set_bts_index(char *base, void *value)
+{
+	(*(void **)(base + ds_cfg.bts_index.offset)) = value;
+}
+static inline void *get_bts_absolute_maximum(char *base)
+{
+	return *(void **)(base + ds_cfg.bts_absolute_maximum.offset);
+}
+static inline void set_bts_absolute_maximum(char *base, void *value)
+{
+	(*(void **)(base + ds_cfg.bts_absolute_maximum.offset)) = value;
+}
+static inline void *get_bts_interrupt_threshold(char *base)
+{
+	return *(void **)(base + ds_cfg.bts_interrupt_threshold.offset);
+}
+static inline void set_bts_interrupt_threshold(char *base, void *value)
+{
+	(*(void **)(base + ds_cfg.bts_interrupt_threshold.offset)) = value;
+}
+static inline long get_from_ip(char *base)
+{
+	return *(long *)(base + ds_cfg.from_ip.offset);
+}
+static inline void set_from_ip(char *base, long value)
+{
+	(*(long *)(base + ds_cfg.from_ip.offset)) = value;
+}
+static inline long get_to_ip(char *base)
+{
+	return *(long *)(base + ds_cfg.to_ip.offset);
+}
+static inline void set_to_ip(char *base, long value)
+{
+	(*(long *)(base + ds_cfg.to_ip.offset)) = value;
+}
+static inline unsigned char get_info_type(char *base)
+{
+	return *(unsigned char *)(base + ds_cfg.info_type.offset);
+}
+static inline void set_info_type(char *base, unsigned char value)
+{
+	(*(unsigned char *)(base + ds_cfg.info_type.offset)) = value;
+}
+/*
+ * The info data might overlap with the info type on some architectures.
+ * We therefore read and write the exact number of bytes.
+ */
+static inline unsigned long long get_info_data(char *base)
+{
+	unsigned long long value = 0;
+	memcpy(&value,
+	       base + ds_cfg.info_data.offset,
+	       ds_cfg.info_data.size);
+	return value;
+}
+static inline void set_info_data(char *base, unsigned long long value)
+{
+	memcpy(base + ds_cfg.info_data.offset,
+	       &value,
+	       ds_cfg.info_data.size);
+}
+
+
+int ds_allocate(void **dsp, size_t bts_size_in_records)
+{
+	size_t bts_size_in_bytes = 0;
+	void *bts = 0;
+	void *ds = 0;
+
+	if (!ds_cfg.sizeof_ds || !ds_cfg.sizeof_bts)
+		return -EOPNOTSUPP;
+
+	if (bts_size_in_records < 0)
+		return -EINVAL;
+
+	bts_size_in_bytes =
+		bts_size_in_records * ds_cfg.sizeof_bts;
+
+	if (bts_size_in_bytes <= 0)
+		return -EINVAL;
+
+	bts = kzalloc(bts_size_in_bytes, GFP_KERNEL);
+
+	if (!bts)
+		return -ENOMEM;
+
+	ds = kzalloc(ds_cfg.sizeof_ds, GFP_KERNEL);
+
+	if (!ds) {
+		kfree(bts);
+		return -ENOMEM;
+	}
+
+	set_bts_buffer_base(ds, bts);
+	set_bts_index(ds, bts);
+	set_bts_absolute_maximum(ds, bts + bts_size_in_bytes);
+	set_bts_interrupt_threshold(ds, bts + bts_size_in_bytes + 1);
+
+	*dsp = ds;
+	return 0;
+}
+
+int ds_free(void **dsp)
+{
+	if (*dsp)
+		kfree(get_bts_buffer_base(*dsp));
+	kfree(*dsp);
+	*dsp = 0;
+
+	return 0;
+}
+
+int ds_get_bts_size(void *ds)
+{
+	size_t size_in_bytes;
+
+	if (!ds_cfg.sizeof_ds || !ds_cfg.sizeof_bts)
+		return -EOPNOTSUPP;
+
+	size_in_bytes =
+		get_bts_absolute_maximum(ds) -
+		get_bts_buffer_base(ds);
+
+	return size_in_bytes / ds_cfg.sizeof_bts;
+}
+
+int ds_get_bts_index(void *ds)
+{
+	size_t index_offset_in_bytes;
+
+	if (!ds_cfg.sizeof_ds || !ds_cfg.sizeof_bts)
+		return -EOPNOTSUPP;
+
+	index_offset_in_bytes =
+		get_bts_index(ds) -
+		get_bts_buffer_base(ds);
+
+	return index_offset_in_bytes / ds_cfg.sizeof_bts;
+}
+
+int ds_read_bts(void *ds, size_t index, struct bts_struct *out)
+{
+	void *bts;
+
+	if (!ds_cfg.sizeof_ds || !ds_cfg.sizeof_bts)
+		return -EOPNOTSUPP;
+
+	if (index < 0)
+		return -EINVAL;
+
+	if (index >= ds_get_bts_size(ds))
+		return -EINVAL;
+
+	bts = get_bts_buffer_base(ds);
+	bts = (char *)bts + (index * ds_cfg.sizeof_bts);
+
+	memset(out, 0, sizeof(*out));
+	if (get_from_ip(bts) == BTS_ESCAPE_ADDRESS) {
+		out->qualifier         = get_info_type(bts);
+		out->variant.timestamp = get_info_data(bts);
+	} else {
+		out->qualifier = BTS_BRANCH;
+		out->variant.lbr.from_ip = get_from_ip(bts);
+		out->variant.lbr.to_ip   = get_to_ip(bts);
+	}
+
+	return 0;
+}
+
+int ds_write_bts(void *ds, const struct bts_struct *in)
+{
+	void *bts;
+
+	if (!ds_cfg.sizeof_ds || !ds_cfg.sizeof_bts)
+		return -EOPNOTSUPP;
+
+	if (ds_get_bts_size(ds) <= 0)
+		return -ENXIO;
+
+	bts = get_bts_index(ds);
+
+	memset(bts, 0, ds_cfg.sizeof_bts);
+	switch (in->qualifier) {
+	case BTS_INVALID:
+		break;
+
+	case BTS_BRANCH:
+		set_from_ip(bts, in->variant.lbr.from_ip);
+		set_to_ip(bts, in->variant.lbr.to_ip);
+		break;
+
+	case BTS_TASK_ARRIVES:
+	case BTS_TASK_DEPARTS:
+		set_from_ip(bts, BTS_ESCAPE_ADDRESS);
+		set_info_type(bts, in->qualifier);
+		set_info_data(bts, in->variant.timestamp);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	bts = (char *)bts + ds_cfg.sizeof_bts;
+	if (bts >= get_bts_absolute_maximum(ds))
+		bts = get_bts_buffer_base(ds);
+	set_bts_index(ds, bts);
+
+	return 0;
+}
+
+unsigned long ds_debugctl_mask(void)
+{
+	return ds_cfg.debugctl_mask;
+}
+
+#ifdef __i386__
+static const struct ds_configuration ds_cfg_netburst = {
+	.sizeof_ds = 9 * 4,
+	.bts_buffer_base = { 0, 4 },
+	.bts_index = { 4, 4 },
+	.bts_absolute_maximum = { 8, 4 },
+	.bts_interrupt_threshold = { 12, 4 },
+	.sizeof_bts = 3 * 4,
+	.from_ip = { 0, 4 },
+	.to_ip = { 4, 4 },
+	.info_type = { 4, 1 },
+	.info_data = { 5, 7 },
+	.debugctl_mask = (1<<2)|(1<<3)
+};
+
+static const struct ds_configuration ds_cfg_pentium_m = {
+	.sizeof_ds = 9 * 4,
+	.bts_buffer_base = { 0, 4 },
+	.bts_index = { 4, 4 },
+	.bts_absolute_maximum = { 8, 4 },
+	.bts_interrupt_threshold = { 12, 4 },
+	.sizeof_bts = 3 * 4,
+	.from_ip = { 0, 4 },
+	.to_ip = { 4, 4 },
+	.info_type = { 4, 1 },
+	.info_data = { 5, 7 },
+	.debugctl_mask = (1<<6)|(1<<7)
+};
+#endif /* _i386_ */
+
+static const struct ds_configuration ds_cfg_core2 = {
+	.sizeof_ds = 9 * 8,
+	.bts_buffer_base = { 0, 8 },
+	.bts_index = { 8, 8 },
+	.bts_absolute_maximum = { 16, 8 },
+	.bts_interrupt_threshold = { 24, 8 },
+	.sizeof_bts = 3 * 8,
+	.from_ip = { 0, 8 },
+	.to_ip = { 8, 8 },
+	.info_type = { 8, 1 },
+	.info_data = { 9, 7 },
+	.debugctl_mask = (1<<6)|(1<<7)|(1<<9)
+};
+
+static inline void
+ds_configure(const struct ds_configuration *cfg)
+{
+	ds_cfg = *cfg;
+}
+
+void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
+{
+	switch (c->x86) {
+	case 0x6:
+		switch (c->x86_model) {
+#ifdef __i386__
+		case 0xD:
+		case 0xE: /* Pentium M */
+			ds_configure(&ds_cfg_pentium_m);
+			break;
+#endif /* _i386_ */
+		case 0xF: /* Core2 */
+			ds_configure(&ds_cfg_core2);
+			break;
+		default:
+			/* sorry, don't know about them */
+			break;
+		}
+		break;
+	case 0xF:
+		switch (c->x86_model) {
+#ifdef __i386__
+		case 0x0:
+		case 0x1:
+		case 0x2: /* Netburst */
+			ds_configure(&ds_cfg_netburst);
+			break;
+#endif /* _i386_ */
+		default:
+			/* sorry, don't know about them */
+			break;
+		}
+		break;
+	default:
+		/* sorry, don't know about them */
+		break;
+	}
+}
Index: linux-2.6-x86/include/asm-x86/ds.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-x86/include/asm-x86/ds.h	2007-12-04 18:18:55.%N +0100
@@ -0,0 +1,65 @@
+/*
+ * Debug Store (DS) support
+ *
+ * This provides a low-level interface to the hardware's Debug Store
+ * feature that is used for last branch recording (LBR) and
+ * precise-event based sampling (PEBS).
+ *
+ * Different architectures use a different DS layout/pointer size.
+ * The below functions therefore work on a void*.
+ *
+ *
+ * Since there is no user for PEBS, yet, only LBR (or branch
+ * trace store, BTS) is supported.
+ *
+ *
+ * Copyright (C) 2007 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, Dec 2007
+ */
+
+#ifndef _ASM_X86_DS_H
+#define _ASM_X86_DS_H
+
+#include <linux/types.h>
+#include <linux/init.h>
+
+struct cpuinfo_x86;
+
+
+/* a branch trace record entry
+ *
+ * In order to unify the interface between various processor versions,
+ * we use the below data structure for all processors.
+ */
+enum bts_qualifier {
+	BTS_INVALID = 0,
+	BTS_BRANCH,
+	BTS_TASK_ARRIVES,
+	BTS_TASK_DEPARTS
+};
+
+struct bts_struct {
+	enum bts_qualifier qualifier;
+	union {
+		/* BTS_BRANCH */
+		struct {
+			long from_ip;
+			long to_ip;
+		} lbr;
+		/* BTS_TASK_ARRIVES or
+		   BTS_TASK_DEPARTS */
+		unsigned long long timestamp;
+	} variant;
+};
+
+
+extern int ds_allocate(void **, size_t);
+extern int ds_free(void **);
+extern int ds_get_bts_size(void *);
+extern int ds_get_bts_index(void *);
+extern int ds_read_bts(void *, size_t, struct bts_struct *);
+extern int ds_write_bts(void *, const struct bts_struct *);
+extern unsigned long ds_debugctl_mask(void);
+extern void __cpuinit ds_init_intel(struct cpuinfo_x86 *c);
+
+#endif /* _ASM_X86_DS_H */
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
