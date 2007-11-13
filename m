Return-Path: <linux-kernel-owner+w=401wt.eu-S1761890AbXKMUCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761890AbXKMUCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758519AbXKMUC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:02:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:11628 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457AbXKMUCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:02:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,411,1188802800"; 
   d="scan'208";a="269955147"
Date: Tue, 13 Nov 2007 11:59:54 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, ak@suse.de
Cc: markus.t.metzger@intel.com, akpm@linux-foundation.org
Subject: [patch] x86, ptrace: support for branch trace store(BTS)
Message-ID: <20071113195954.GA2428@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Support for Intel's last branch recording to ptrace. This gives debuggers
access to this hardware feature and allows them to show an execution trace
of the debugged application.

Last branch recording (see section 18.5 in the Intel 64 and IA-32
Architectures Software Developer's Manual) allows taking an execution
trace of the running application without instrumentation. When a branch
is executed, the hardware logs the source and destination address in a
cyclic buffer given to it by the OS.

This can be a great debugging aid. It shows you how exactly you got
where you currently are without requiring you to do lots of single
stepping and rerunning.

This patch manages the various buffers, configures the trace
hardware, disentangles the trace, and provides a user interface via
ptrace. On the high-level design:
- there is one optional trace buffer per thread_struct
- upon a context switch, the trace hardware is reconfigured to either
  disable tracing or to use the appropriate buffer for the new task.
  - tracing induces ~20% overhead as branch records are sent out on
    the bus. 
  - the hardware collects trace per processor. To disentangle the
    traces for different tasks, we use separate buffers and reconfigure
    the trace hardware.
- the internal buffer interpretation as well as the corresponding
  operations are selected at run-time by hardware detection
  - different processors use different branch record formats

Opens:
- warnings due to code sharing between i386 and x86_64
- support for more processors (to come)
- ptrace command numbers (just picked some numbers randomly)

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process_32.c	2007-11-07 09:08:32.%N +0100
+++ linux-2.6/arch/x86/kernel/process_32.c	2007-11-07 09:09:36.%N +0100
@@ -735,6 +735,18 @@
 		__switch_to_xtra(prev_p, next_p, tss);
 
 	/*
+	 * Last branch recording recofiguration of trace hardware and
+	 * disentangling of trace data per task.
+	 */
+	if (unlikely(task_thread_info(prev_p)->flags & _TIF_BTS_TRACE ||
+		     task_thread_info(prev_p)->flags & _TIF_BTS_TRACE_TS))
+		ptrace_bts_task_departs(prev_p);
+
+	if (unlikely(task_thread_info(next_p)->flags & _TIF_BTS_TRACE ||
+		     task_thread_info(next_p)->flags & _TIF_BTS_TRACE_TS))
+		ptrace_bts_task_arrives(next_p);
+
+	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
 	 * This must be done before restoring TLS segments so
 	 * the GDT and LDT are properly updated, and must be
Index: linux-2.6/arch/x86/kernel/ptrace_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/ptrace_32.c	2007-11-07 09:08:32.%N +0100
+++ linux-2.6/arch/x86/kernel/ptrace_32.c	2007-11-07 09:09:36.%N +0100
@@ -24,6 +24,7 @@
 #include <asm/debugreg.h>
 #include <asm/ldt.h>
 #include <asm/desc.h>
+#include <asm/ptrace_bts.h>
 
 /*
  * does not yet catch signals sent when the child dies.
@@ -274,6 +275,7 @@
 { 
 	clear_singlestep(child);
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
+	ptrace_bts_task_detached(child);
 }
 
 /*
@@ -610,6 +612,37 @@
 					(struct user_desc __user *) data);
 		break;
 
+	case PTRACE_BTS_INIT:
+		ret = ptrace_bts_init();
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
+			 (struct ptrace_bts_record __user *) addr);
+		break;
+
+	case PTRACE_BTS_CONFIG:
+		ptrace_bts_config(child, data);
+		ret = 0;
+		break;
+
+	case PTRACE_BTS_STATUS:
+		ret = ptrace_bts_status(child);
+		break;
+
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
Index: linux-2.6/include/asm-x86/ptrace-abi.h
===================================================================
--- linux-2.6.orig/include/asm-x86/ptrace-abi.h	2007-11-07 09:08:32.%N +0100
+++ linux-2.6/include/asm-x86/ptrace-abi.h	2007-11-07 09:09:36.%N +0100
@@ -78,4 +78,54 @@
 # define PTRACE_SYSEMU_SINGLESTEP 32
 #endif
 
+
+/* Initialize bts tracing. Needs to be called once.
+   Return the type of tracing available */
+#define PTRACE_BTS_INIT 40
+
+/* No trace hardware available or trace hardware unknown */
+#define PTRACE_BTS_T_UNAVAILABLE 0x0
+/* BTS tracing available */
+#define PTRACE_BTS_T_BTS 0x1
+/* CPL0-qualified BTS tracing available */
+#define PTRACE_BTS_T_DSCPL 0x2
+
+/* Allocate new bts buffer (free old one, if exists) of size DATA bts records;
+   parameter ADDR is ignored.
+   Return 0, if successful; -1, otherwise.
+   ENXIO....ptrace bts not initialized
+   EINVAL...invalid size in records
+   ENOMEM...out of memory */
+#define PTRACE_BTS_ALLOCATE_BUFFER 41
+
+/* Return the size of the bts buffer in number of bts records,
+   if successful; -1, otherwise.
+   ENXIO....ptrace bts not initialized or no buffer allocated */
+#define PTRACE_BTS_GET_BUFFER_SIZE 42
+
+/* Return the index of the next bts record to be written,
+   if successful; -1, otherwise.
+   After the first warp-around, this is the start of the circular bts buffer.
+   ENXIO....ptrace bts not initialized or no buffer allocated */
+#define PTRACE_BTS_GET_INDEX 43
+
+/* Read the DATA'th bts record into a ptrace_bts_record buffer provided in ADDR.
+   Return 0, if successful; -1, otherwise
+   ENXIO....ptrace bts not initialized or no buffer allocated
+   EINVAL...invalid index */
+#define PTRACE_BTS_READ_RECORD 44
+
+/* Configure last branch trace; the configuration is given as a bit-mask of
+   PTRACE_BTS_O_* options in DATA; parameter ADDR is ignored. */
+#define PTRACE_BTS_CONFIG 45
+
+/* Return the configuration as bit-mask of PTRACE_BTS_O_* options.*/
+#define PTRACE_BTS_STATUS 46
+
+/* Trace configuration options */
+/* Collect last branch trace */
+#define PTRACE_BTS_O_TRACE_TASK 0x1
+/* Take timestamps when the task arrives and departs */
+#define PTRACE_BTS_O_TIMESTAMPS 0x2
+
 #endif
Index: linux-2.6/include/asm-x86/ptrace.h
===================================================================
--- linux-2.6.orig/include/asm-x86/ptrace.h	2007-11-07 09:08:32.%N +0100
+++ linux-2.6/include/asm-x86/ptrace.h	2007-11-07 09:09:36.%N +0100
@@ -4,8 +4,43 @@
 #include <linux/compiler.h>	/* For __user */
 #include <asm/ptrace-abi.h>
 
 #ifndef __ASSEMBLY__
 
+/* a branch trace record entry
+ *
+ * In order to unify the interface between various processor versions,
+ * we use the below data structure for all processors.
+ */
+enum ptrace_bts_qualifier {
+	PTRACE_BTS_INVALID = 0,
+	PTRACE_BTS_LBR,
+	PTRACE_BTS_TASK_ARRIVES,
+	PTRACE_BTS_TASK_DEPARTS
+};
+
+struct ptrace_bts_record {
+	enum ptrace_bts_qualifier qualifier;
+	union {
+		/* PTRACE_BTS_BRANCH */
+		struct {
+			void *from_ip;
+			void *to_ip;
+		} lbr;
+		/* PTRACE_BTS_TASK_ARRIVES or
+		   PTRACE_BTS_TASK_DEPARTS */
+		unsigned long long timestamp;
+	} variant;
+};
+
+#ifdef __KERNEL__
+
+struct task_struct;
+
+extern void ptrace_bts_task_arrives(struct task_struct *tsk);
+extern void ptrace_bts_task_departs(struct task_struct *tsk);
+
+#endif /* __KERNEL__ */
+
 #ifdef __i386__
 /* this struct defines the way the registers are stored on the
    stack during a system call. */
Index: linux-2.6/arch/x86/kernel/ptrace_bts.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/x86/kernel/ptrace_bts.c	2007-11-07 09:09:36.%N +0100
@@ -0,0 +1,741 @@
+/*
+ * Extend ptrace with execution trace support using the x86 last
+ * branch recording hardware feature.
+ *
+ * Copyright (C) 2007 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, Oct 2007
+ */
+
+#include <asm/ptrace_bts.h>
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/ptrace.h>
+
+#include <asm/uaccess.h>
+
+
+
+static struct ptrace_bts_operations ptrace_bts_ops;
+
+/*
+ * Configure trace hardware to enable tracing
+ * Return 0, on success; -Eerrno, otherwise.
+ */
+static int ptrace_bts_enable(void)
+{
+	if (!ptrace_bts_ops.enable)
+		return -EOPNOTSUPP;
+	return (*ptrace_bts_ops.enable)();
+}
+
+#ifdef __i386__
+static int ptrace_bts_enable_netburst(void)
+{
+	unsigned long long debugctl_msr = 0;
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
+	debugctl_msr |=
+		((1 << 2) | /* TR */
+		 (1 << 3));  /* BTS */
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
+
+	return 0;
+}
+
+static int ptrace_bts_enable_pentium_m(void)
+{
+	unsigned long long debugctl_msr = 0;
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
+	debugctl_msr |=
+		((1 << 6) | /* TR */
+		 (1 << 7));  /* BTS */
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
+
+	return 0;
+}
+#endif /* _i386_ */
+
+static int ptrace_bts_enable_core2(void)
+{
+	unsigned long long debugctl_msr = 0;
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
+	debugctl_msr |=
+		((1 << 6) | /* TR */
+		 (1 << 7) | /* BTS */
+		 (1 << 9));  /* DSCPL */
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
+
+	return 0;
+}
+
+/*
+ * Configure trace hardware to disable tracing
+ * Return 0, on success; -Eerrno, otherwise.
+ */
+static int ptrace_bts_disable(void)
+{
+	if (!ptrace_bts_ops.disable)
+		return -EOPNOTSUPP;
+	return (*ptrace_bts_ops.disable)();
+}
+
+#ifdef __i386__
+static int ptrace_bts_disable_netburst(void)
+{
+	unsigned long long debugctl_msr = 0;
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
+	debugctl_msr &=
+		~((1 << 2) | /* TR */
+		  (1 << 3));  /* BTS */
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
+
+	return 0;
+}
+
+static int ptrace_bts_disable_pentium_m(void)
+{
+	unsigned long long debugctl_msr = 0;
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
+	debugctl_msr &=
+		~((1 << 6) | /* TR */
+		  (1 << 7));  /* BTS */
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
+
+	return 0;
+}
+#endif /* _i386_ */
+
+static int ptrace_bts_disable_core2(void)
+{
+	unsigned long long debugctl_msr = 0;
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
+	debugctl_msr &=
+		~((1 << 6) | /* TR */
+		  (1 << 7) | /* BTS */
+		  (1 << 9));  /* DSCPL */
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
+
+	return 0;
+}
+
+/*
+ * Allocate the DS configuration for the parameter task.
+ * Returns an error, if there was already a DS configuration allocated
+ * for the task.
+ * Returns 0, if successful; -Eerrno, otherwise.
+ */
+static int ptrace_bts_allocate_ds(struct task_struct *child)
+{
+	if (child->thread.ds_area)
+		return -EEXIST;
+
+	if (!ptrace_bts_ops.allocate_ds)
+		return -EOPNOTSUPP;
+	return (*ptrace_bts_ops.allocate_ds)(child);
+}
+
+#ifdef __i386__
+static int ptrace_bts_allocate_ds_32(struct task_struct *child)
+{
+	child->thread.ds_area =
+		(unsigned long)kzalloc(sizeof(struct ptrace_bts_ds_32),
+				       GFP_KERNEL);
+
+	if (!child->thread.ds_area)
+		return -ENOMEM;
+
+	return 0;
+}
+#endif /* _i386_ */
+
+static int ptrace_bts_allocate_ds_64(struct task_struct *child)
+{
+	child->thread.ds_area =
+		(unsigned long)kzalloc(sizeof(struct ptrace_bts_ds_64),
+				       GFP_KERNEL);
+
+	if (!child->thread.ds_area)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/*
+ * Allocate new BTS buffer for the parameter task.
+ * Allocate a new DS configuration, if needed.
+ * If there was an old buffer, that buffer is freed, provided the
+ * allocation of the new buffer succeeded.
+ * A size of zero deallocates the old buffer.
+ * The trace data is not copied to the new buffer.
+ * Returns 0, if successful; -Eerrno, otherwise.
+ */
+int ptrace_bts_allocate_bts(struct task_struct *child,
+			    long size_in_records)
+{
+	if (!child->thread.ds_area) {
+		int err = ptrace_bts_allocate_ds(child);
+		if (err < 0)
+			return err;
+	}
+
+	if (size_in_records < 0)
+		return -EINVAL;
+
+	if (size_in_records > 4000)
+		return -EINVAL;
+
+	if (!ptrace_bts_ops.allocate_bts)
+		return -EOPNOTSUPP;
+	return (*ptrace_bts_ops.allocate_bts)(child, size_in_records);
+}
+
+#ifdef __i386__
+static int ptrace_bts_allocate_bts_32(struct task_struct *child,
+				      long size_in_records)
+{
+	struct ptrace_bts_ds_32 *ds =
+		(struct ptrace_bts_ds_32 *)child->thread.ds_area;
+	long size_in_bytes =
+		size_in_records * sizeof(struct ptrace_bts_32);
+	void *new_buffer = 0;
+
+	if (size_in_bytes) {
+		new_buffer = kzalloc(size_in_bytes, GFP_KERNEL);
+
+		if (!new_buffer)
+			return -ENOMEM;
+	}
+	kfree((void *)ds->bts_buffer_base);
+
+	ds->bts_buffer_base = (u32)new_buffer;
+	ds->bts_index  = ds->bts_buffer_base;
+	ds->bts_absolute_maximum = ds->bts_buffer_base + size_in_bytes;
+	ds->bts_interrupt_threshold = ds->bts_absolute_maximum + 1;
+
+	return 0;
+}
+#endif /* _i386_ */
+
+static int ptrace_bts_allocate_bts_64_noflags(struct task_struct *child,
+					      long size_in_records)
+{
+	struct ptrace_bts_ds_64 *ds =
+		(struct ptrace_bts_ds_64 *)child->thread.ds_area;
+	long size_in_bytes =
+		size_in_records * sizeof(struct ptrace_bts_64_noflags);
+	void *new_buffer = 0;
+
+	if (size_in_bytes) {
+		new_buffer = kzalloc(size_in_bytes, GFP_KERNEL);
+
+		if (!new_buffer)
+			return -ENOMEM;
+	}
+	kfree((void *)ds->bts_buffer_base);
+
+	ds->bts_buffer_base = (u64)new_buffer;
+	ds->bts_index  = ds->bts_buffer_base;
+	ds->bts_absolute_maximum = ds->bts_buffer_base + size_in_bytes;
+	ds->bts_interrupt_threshold = ds->bts_absolute_maximum + 1;
+
+	return 0;
+}
+
+/*
+ * Returns the size of the bts buffer in number of bts records
+ * Return -Eerrno, if an error occured
+ */
+int ptrace_bts_get_buffer_size(struct task_struct *child)
+{
+	if (!child->thread.ds_area)
+		return -ENXIO;
+
+	if (!ptrace_bts_ops.get_buffer_size)
+		return -EOPNOTSUPP;
+	return (*ptrace_bts_ops.get_buffer_size)(child);
+}
+
+#ifdef __i386__
+static int ptrace_bts_get_buffer_size_32(struct task_struct *child)
+{
+	struct ptrace_bts_ds_32 *ds =
+		(struct ptrace_bts_ds_32 *)child->thread.ds_area;
+	int size_in_bytes =
+		ds->bts_absolute_maximum - ds->bts_buffer_base;
+	int size_in_records =
+		size_in_bytes / sizeof(struct ptrace_bts_32);
+	return size_in_records;
+}
+#endif /* _i386_ */
+
+static int ptrace_bts_get_buffer_size_64_noflags(struct task_struct *child)
+{
+	struct ptrace_bts_ds_64 *ds =
+		(struct ptrace_bts_ds_64 *)child->thread.ds_area;
+	int size_in_bytes =
+		ds->bts_absolute_maximum - ds->bts_buffer_base;
+	int size_in_records =
+		size_in_bytes / sizeof(struct ptrace_bts_64_noflags);
+	return size_in_records;
+}
+
+/*
+ * Returns the bts index of the next record to be written such that it
+ * could be used to access this record in a C array of records.
+ * Returns -Eerrno, if an error occured.
+ */
+int ptrace_bts_get_index(struct task_struct *child)
+{
+	if (!child->thread.ds_area)
+		return -ENXIO;
+
+	if (!ptrace_bts_ops.get_index)
+		return -EOPNOTSUPP;
+	return (*ptrace_bts_ops.get_index)(child);
+}
+
+#ifdef __i386__
+static int ptrace_bts_get_index_32(struct task_struct *child)
+{
+	struct ptrace_bts_ds_32 *ds =
+		(struct ptrace_bts_ds_32 *)child->thread.ds_area;
+	int index_offset_in_bytes =
+		ds->bts_index - ds->bts_buffer_base;
+	int index_offset_in_records =
+		index_offset_in_bytes / sizeof(struct ptrace_bts_32);
+
+	return index_offset_in_records;
+}
+#endif /* _i386_ */
+
+static int ptrace_bts_get_index_64_noflags(struct task_struct *child)
+{
+	struct ptrace_bts_ds_64 *ds =
+		(struct ptrace_bts_ds_64 *)child->thread.ds_area;
+	int index_offset_in_bytes =
+		ds->bts_index - ds->bts_buffer_base;
+	int index_offset_in_records =
+		index_offset_in_bytes / sizeof(struct ptrace_bts_64_noflags);
+
+	return index_offset_in_records;
+}
+
+/*
+ * Copies the index'th BTS record into out.
+ * Converts the internal BTS representation into the external one.
+ * Returns the number of bytes copied, if successful; -Eerrno, otherwise.
+ *
+ * pre: out points to a buffer big enough to hold one BTS record
+ */
+int ptrace_bts_read_record(struct task_struct *child,
+			   long index,
+			   struct ptrace_bts_record __user *out)
+{
+	if (!child->thread.ds_area)
+		return -ENXIO;
+
+	if (index < 0)
+		return -EINVAL;
+
+	if (index >= ptrace_bts_get_buffer_size(child))
+		return -EINVAL;
+
+	if (!ptrace_bts_ops.read_record)
+		return -EOPNOTSUPP;
+	return (*ptrace_bts_ops.read_record)(child, index, out);
+}
+
+#ifdef __i386__
+static int ptrace_bts_read_record_32(struct task_struct *child,
+				     long index,
+				     struct ptrace_bts_record __user *out)
+{
+	struct ptrace_bts_ds_32 *ds = (
+		struct ptrace_bts_ds_32 *)child->thread.ds_area;
+	struct ptrace_bts_32 *bts =
+		(struct ptrace_bts_32 *)ds->bts_buffer_base;
+	struct ptrace_bts_32 *record = &bts[index];
+	struct ptrace_bts_record ret;
+
+	memset(&ret, 0, sizeof(ret));
+	if (record->from_ip == PTRACE_BTS_ESCAPE_ADDRESS) {
+		struct ptrace_bts_info_32 *info =
+			(struct ptrace_bts_info_32 *)record;
+
+		ret.qualifier = info->qualifier;
+		ret.variant.timestamp = info->data;
+	} else {
+		ret.qualifier = PTRACE_BTS_LBR;
+		ret.variant.lbr.from_ip = (void *)record->from_ip;
+		ret.variant.lbr.to_ip   = (void *)record->to_ip;
+	}
+	if (copy_to_user(out, &ret, sizeof(ret)))
+		return -EFAULT;
+
+	return sizeof(ret);
+}
+#endif /* _i386_ */
+
+static int ptrace_bts_read_record_64_noflags(struct task_struct *child,
+					     long index,
+					     struct ptrace_bts_record __user *out)
+{
+	struct ptrace_bts_ds_64 *ds =
+		(struct ptrace_bts_ds_64 *)child->thread.ds_area;
+	struct ptrace_bts_64_noflags *bts =
+		(struct ptrace_bts_64_noflags *)ds->bts_buffer_base;
+	struct ptrace_bts_64_noflags *record = &bts[index];
+	struct ptrace_bts_record ret;
+
+	memset(&ret, 0, sizeof(ret));
+	if (record->from_ip == PTRACE_BTS_ESCAPE_ADDRESS) {
+		struct ptrace_bts_info_64_noflags *info =
+			(struct ptrace_bts_info_64_noflags *)record;
+
+		ret.qualifier = info->qualifier;
+		ret.variant.timestamp = info->data;
+	} else {
+		ret.qualifier = PTRACE_BTS_LBR;
+		ret.variant.lbr.from_ip = (void *)record->from_ip;
+		ret.variant.lbr.to_ip   = (void *)record->to_ip;
+	}
+	if (copy_to_user(out, &ret, sizeof(ret)))
+		return -EFAULT;
+
+	return sizeof(ret);
+}
+
+/*
+ * Copies the parameter BTS record into the task's BTS buffer at
+ * ptrace_bts_get_index() and increments the index.
+ * Converts the external BTS info representation into the internal one.
+ * Returns the number of bytes copied, if successful; -Eerrno, otherwise.
+ *
+ * pre: child is not running
+ */
+static int ptrace_bts_write_record(struct task_struct *child,
+				   const struct ptrace_bts_record *in)
+{
+	if (!child->thread.ds_area)
+		return -ENXIO;
+
+	if (ptrace_bts_get_buffer_size(child) <= 0)
+		return -ENXIO;
+
+	if (!ptrace_bts_ops.write_record)
+		return -EOPNOTSUPP;
+	return (*ptrace_bts_ops.write_record)(child, in);
+}
+
+#ifdef __i386__
+static int ptrace_bts_write_record_32(struct task_struct *child,
+				      const struct ptrace_bts_record *in)
+{
+	struct ptrace_bts_ds_32 *ds =
+		(struct ptrace_bts_ds_32 *)child->thread.ds_area;
+	struct ptrace_bts_32 *writep =
+		(struct ptrace_bts_32 *)ds->bts_index;
+
+	switch (in->qualifier) {
+	case PTRACE_BTS_INVALID:
+		memset(writep, 0, sizeof(*writep));
+		break;
+
+	case PTRACE_BTS_LBR: {
+		struct ptrace_bts_32 record;
+
+		memset(&record, 0, sizeof(record));
+		record.from_ip = (u32)in->variant.lbr.from_ip;
+		record.to_ip   = (u32)in->variant.lbr.to_ip;
+
+		*writep = record;
+		break;
+	}
+
+	case PTRACE_BTS_TASK_ARRIVES:
+	case PTRACE_BTS_TASK_DEPARTS: {
+		struct ptrace_bts_info_32 record;
+		struct ptrace_bts_32 *conv =
+			(struct ptrace_bts_32 *)&record;;
+
+		memset(&record, 0, sizeof(record));
+		record.escape = PTRACE_BTS_ESCAPE_ADDRESS;
+		record.qualifier = in->qualifier;
+		record.data      = in->variant.timestamp;
+
+		*writep = *conv;
+
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	ds->bts_index += sizeof(*writep);
+	if (ds->bts_index >= ds->bts_absolute_maximum)
+		ds->bts_index = ds->bts_buffer_base;
+
+	return 0;
+}
+#endif /* _i386_ */
+
+static int ptrace_bts_write_record_64_noflags(struct task_struct *child,
+					      const struct ptrace_bts_record *in)
+{
+	struct ptrace_bts_ds_64 *ds =
+		(struct ptrace_bts_ds_64 *)child->thread.ds_area;
+	struct ptrace_bts_64_noflags *writep =
+		(struct ptrace_bts_64_noflags *)ds->bts_index;
+
+	switch (in->qualifier) {
+	case PTRACE_BTS_INVALID:
+		memset(writep, 0, sizeof(*writep));
+		break;
+
+	case PTRACE_BTS_LBR: {
+		struct ptrace_bts_64_noflags record;
+
+		memset(&record, 0, sizeof(record));
+		record.from_ip = (u64)in->variant.lbr.from_ip;
+		record.to_ip   = (u64)in->variant.lbr.to_ip;
+
+		*writep = record;
+		break;
+	}
+
+	case PTRACE_BTS_TASK_ARRIVES:
+	case PTRACE_BTS_TASK_DEPARTS: {
+		struct ptrace_bts_info_64_noflags record;
+		struct ptrace_bts_64_noflags *conv =
+			(struct ptrace_bts_64_noflags *)&record;;
+
+		memset(&record, 0, sizeof(record));
+		record.escape = PTRACE_BTS_ESCAPE_ADDRESS;
+		record.qualifier = in->qualifier;
+		record.data      = in->variant.timestamp;
+
+		*writep = *conv;
+
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	ds->bts_index += sizeof(*writep);
+	if (ds->bts_index >= ds->bts_absolute_maximum)
+		ds->bts_index = ds->bts_buffer_base;
+
+	return 0;
+}
+
+/*
+ * Configures ptrace_bts structure in traced task's task_struct.
+ */
+void ptrace_bts_config(struct task_struct *child,
+		       unsigned long options)
+{
+	if (options & PTRACE_BTS_O_TRACE_TASK)
+		set_tsk_thread_flag(child, TIF_BTS_TRACE);
+	else
+		clear_tsk_thread_flag(child, TIF_BTS_TRACE);
+
+	if (options & PTRACE_BTS_O_TIMESTAMPS)
+		set_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
+	else
+		clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
+}
+
+/*
+ * Returns the configuration in ptrace_bts structure in traced task's
+ * task_struct.
+ */
+unsigned long ptrace_bts_status(struct task_struct *child)
+{
+	unsigned long status = 0;
+
+	if (test_tsk_thread_flag(child, TIF_BTS_TRACE))
+		status |= PTRACE_BTS_O_TRACE_TASK;
+	if (test_tsk_thread_flag(child, TIF_BTS_TRACE_TS))
+		status |= PTRACE_BTS_O_TIMESTAMPS;
+
+	return status;
+}
+
+/*
+ * This function is called on a context switch for the arriving task
+ * It performs the following tasks:
+ * - enable tracing, if configured
+ * - take timestamp, if configured
+ * - reconfigure trace hardware to use task's DS area
+ *
+ * This function is called only for tasks that are being traced.
+ * Performance is down for those tasks, since tracing writes to memory
+ * on every branch. We need not be too concerned with performance.
+ */
+void ptrace_bts_task_arrives(struct task_struct *tsk)
+{
+	if (test_tsk_thread_flag(tsk, TIF_BTS_TRACE_TS)) {
+		struct ptrace_bts_record rec = {
+			.qualifier = PTRACE_BTS_TASK_ARRIVES,
+			.variant.timestamp = sched_clock()
+		};
+
+		ptrace_bts_write_record(tsk, &rec);
+	}
+
+	if (test_tsk_thread_flag(tsk, TIF_BTS_TRACE)) {
+		wrmsrl(MSR_IA32_DS_AREA, tsk->thread.ds_area);
+		ptrace_bts_enable();
+	}
+}
+
+/*
+ * This function is called on a context switch for the departing task
+ * It performs the following tasks:
+ * - disable tracing, if configured
+ * - take timestamp, if configured
+ *
+ * This function is called only for tasks that are being traced.
+ * Performance is down for those tasks, since tracing writes to memory
+ * on every branch. We need not be too concerned with performance.
+ */
+void ptrace_bts_task_departs(struct task_struct *tsk)
+{
+	if (test_tsk_thread_flag(tsk, TIF_BTS_TRACE))
+		ptrace_bts_disable();
+
+	if (test_tsk_thread_flag(tsk, TIF_BTS_TRACE_TS)) {
+		struct ptrace_bts_record rec = {
+			.qualifier = PTRACE_BTS_TASK_DEPARTS,
+			.variant.timestamp = sched_clock()
+		};
+
+		ptrace_bts_write_record(tsk, &rec);
+	}
+}
+
+/*
+ * Handle detaching from traced task
+ * - free bts buffer, if one was allocated
+ * - free ds configuration, if one was allocated
+ */
+void ptrace_bts_task_detached(struct task_struct *tsk)
+{
+	if (tsk->thread.ds_area) {
+		ptrace_bts_allocate_bts(tsk, /* size = */ 0);
+		kfree((void *)tsk->thread.ds_area);
+	}
+	ptrace_bts_config(tsk, /* options = */ 0);
+}
+
+/*
+ * Supported last branch trace operations configurations to be used as
+ * templates in ptrace_bts_init().
+ */
+#ifdef __i386__
+static const struct ptrace_bts_operations ptrace_bts_ops_netburst = {
+	.enable = ptrace_bts_enable_netburst,
+	.disable = ptrace_bts_disable_netburst,
+	.allocate_ds = ptrace_bts_allocate_ds_32,
+	.allocate_bts = ptrace_bts_allocate_bts_32,
+	.get_buffer_size = ptrace_bts_get_buffer_size_32,
+	.get_index = ptrace_bts_get_index_32,
+	.read_record = ptrace_bts_read_record_32,
+	.write_record = ptrace_bts_write_record_32
+};
+
+static const struct ptrace_bts_operations ptrace_bts_ops_pentium_m = {
+	.enable = ptrace_bts_enable_pentium_m,
+	.disable = ptrace_bts_disable_pentium_m,
+	.allocate_ds = ptrace_bts_allocate_ds_32,
+	.allocate_bts = ptrace_bts_allocate_bts_32,
+	.get_buffer_size = ptrace_bts_get_buffer_size_32,
+	.get_index = ptrace_bts_get_index_32,
+	.read_record = ptrace_bts_read_record_32,
+	.write_record = ptrace_bts_write_record_32
+};
+#endif /* _i386_ */
+
+static const struct ptrace_bts_operations ptrace_bts_ops_core2 = {
+	.enable = ptrace_bts_enable_core2,
+	.disable = ptrace_bts_disable_core2,
+	.allocate_ds = ptrace_bts_allocate_ds_64,
+	.allocate_bts = ptrace_bts_allocate_bts_64_noflags,
+	.get_buffer_size = ptrace_bts_get_buffer_size_64_noflags,
+	.get_index = ptrace_bts_get_index_64_noflags,
+	.read_record = ptrace_bts_read_record_64_noflags,
+	.write_record = ptrace_bts_write_record_64_noflags
+};
+
+/*
+ * Initialize last branch tracing.
+ * Detect hardware and initialize the operations function table.
+ * Return type of trace available on this hardware.
+ */
+static int ptrace_bts_init_intel(void)
+{
+	int ret = PTRACE_BTS_T_UNAVAILABLE;
+
+	switch (current_cpu_data.x86) {
+	case 0x6:
+		switch (current_cpu_data.x86_model) {
+#ifdef __i386__
+		case 0xD:
+		case 0xE: /* Pentium M */
+			ptrace_bts_ops = ptrace_bts_ops_pentium_m;
+
+			ret = PTRACE_BTS_T_BTS;
+			break;
+#endif /* _i386_ */
+		case 0xF: /* Core2 */
+			ptrace_bts_ops = ptrace_bts_ops_core2;
+
+			ret = PTRACE_BTS_T_DSCPL;
+			break;
+		default:
+			/* sorry, don't know about them */
+			break;
+		}
+		break;
+	case 0xF:
+		switch (current_cpu_data.x86_model) {
+#ifdef __i386__
+		case 0x0:
+		case 0x1:
+		case 0x2:
+		case 0x3: /* Netburst */
+			ptrace_bts_ops = ptrace_bts_ops_netburst;
+
+			ret = PTRACE_BTS_T_BTS;
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
+
+	return ret;
+}
+int ptrace_bts_init(void)
+{
+	int ret = PTRACE_BTS_T_UNAVAILABLE;
+
+	if (cpu_has_bts) {
+		switch (current_cpu_data.x86_vendor) {
+		case X86_VENDOR_INTEL:
+			ret = ptrace_bts_init_intel();
+			break;
+		default:
+			/* sorry, don't know about them */
+			break;
+		}
+	}
+
+	return ret;
+}
Index: linux-2.6/include/asm-x86/ptrace_bts.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/asm-x86/ptrace_bts.h	2007-11-07 09:09:36.%N +0100
@@ -0,0 +1,146 @@
+/*
+ * Extend ptrace with execution trace support using the x86 last
+ * branch recording hardware feature.
+ *
+ * Copyright (C) 2007 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, Oct 2007
+ */
+
+#ifndef _ASM_X86_PTRACE_BTS_H
+#define _ASM_X86_PTRACE_BTS_H
+
+#include <asm/types.h>
+#include <linux/ptrace.h>
+
+/*
+ * Debug Store (DS) save area configurations for various processor
+ * variants.
+ * (see Intel64 and IA32 Architectures Software Developer's Manual,
+ *  section 18.5)
+ *
+ * The DS configurations consist of the following fields; they vary in
+ * the size of those fields.
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
+ * 64bit pointers even in 32bit mode. This forces us to do some ugly
+ * casting below.
+ *
+ * The 32bit variant only makes sense for i386, of course, whereas the
+ * 64bit variant is used for i386 and x86_64.
+ */
+#ifdef __i386__
+struct ptrace_bts_ds_32 {
+	u32 bts_buffer_base;
+	u32 bts_index;
+	u32 bts_absolute_maximum;
+	u32 bts_interrupt_threshold;
+	u32 pebs_buffer_base;
+	u32 pebs_index;
+	u32 pebs_absolute_maximum;
+	u32 pebs_interrupt_threshold;
+	u32 pebs_counter_reset_value;
+};
+#endif /* _i386_ */
+
+struct ptrace_bts_ds_64 {
+	u64 bts_buffer_base;
+	u64 bts_index;
+	u64 bts_absolute_maximum;
+	u64 bts_interrupt_threshold;
+	u64 pebs_buffer_base;
+	u64 pebs_index;
+	u64 pebs_absolute_maximum;
+	u64 pebs_interrupt_threshold;
+	u64 pebs_counter_reset_value;
+};
+
+/*
+ * Branch Trace Store (BTS) records for various processor variants.
+ * To the user, we provide a single interface declared in include/asm/ptrace.h.
+ */
+#ifdef __i386__
+struct ptrace_bts_32 {
+	u32 from_ip;
+	u32 to_ip;
+	u32 : 4;
+	u32 was_predicted :1;
+	u32 : 27;
+} __attribute__((packed, aligned(4)));
+#endif /* _i386_ */
+
+struct ptrace_bts_64_noflags {
+	u64 from_ip;
+	u64 to_ip;
+	u64 : 64;
+};
+
+/*
+ * BTS info records for various processor variants.
+ * To the user, we provide a single interface declared in
+ * include/asm/ptrace.h.
+ */
+#define PTRACE_BTS_ESCAPE_ADDRESS (__u64)(0)
+#define PTRACE_BTS_QUALIFIER_BIT_SIZE 8
+
+#ifdef __i386__
+struct ptrace_bts_info_32 {
+	u32 escape;
+	enum ptrace_bts_qualifier qualifier : PTRACE_BTS_QUALIFIER_BIT_SIZE;
+	u64 data : (64 - PTRACE_BTS_QUALIFIER_BIT_SIZE);
+} __attribute__((packed, aligned(4)));
+#endif /* _i386_ */
+
+struct ptrace_bts_info_64_noflags {
+	u64 escape;
+	enum ptrace_bts_qualifier qualifier : PTRACE_BTS_QUALIFIER_BIT_SIZE;
+	u64 data : (64 - PTRACE_BTS_QUALIFIER_BIT_SIZE);
+	u64 : 64;
+} __attribute__((packed, aligned(8)));
+
+/*
+ * A function table holding operations related to last branch recording.
+ * The table is used to abstract from different last branch recording
+ * hardware. It is initialized by ptrace_bts_init; most other ptrace_bts
+ * functions basically forward the request to the function table.
+ * Each function table supports a specific DS/BTS combination.
+ */
+struct ptrace_bts_operations {
+	int (*enable)(void);
+	int (*disable)(void);
+	int (*allocate_ds)(struct task_struct *);
+	int (*allocate_bts)(struct task_struct *, long);
+	int (*get_buffer_size)(struct task_struct *);
+	int (*get_index)(struct task_struct *);
+	int (*read_record)(struct task_struct *, long,
+			   struct ptrace_bts_record __user *);
+	int (*write_record)(struct task_struct *,
+			    const struct ptrace_bts_record*);
+};
+
+extern int ptrace_bts_init(void);
+extern int ptrace_bts_allocate_bts(struct task_struct *child,
+				   long size_in_records);
+extern int ptrace_bts_get_buffer_size(struct task_struct *child);
+extern int ptrace_bts_get_index(struct task_struct *child);
+extern int ptrace_bts_read_record(struct task_struct *child,
+				  long index,
+				  struct ptrace_bts_record __user *out);
+extern void ptrace_bts_config(struct task_struct *child,
+			      unsigned long options);
+extern unsigned long ptrace_bts_status(struct task_struct *child);
+extern void ptrace_bts_task_detached(struct task_struct *tsk);
+
+#endif /* _ASM_X86_PTRACE_BTS_H */
Index: linux-2.6/arch/x86/kernel/Makefile_32
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile_32	2007-11-07 09:08:32.%N +0100
+++ linux-2.6/arch/x86/kernel/Makefile_32	2007-11-07 09:09:36.%N +0100
@@ -7,7 +7,8 @@
 obj-y	:= process_32.o signal_32.o entry_32.o traps_32.o irq_32.o \
 		ptrace_32.o time_32.o ioport_32.o ldt_32.o setup_32.o i8259_32.o sys_i386_32.o \
 		pci-dma_32.o i386_ksyms_32.o i387_32.o bootflag.o e820_32.o\
-		quirks.o i8237.o topology.o alternative.o i8253.o tsc_32.o
+		quirks.o i8237.o topology.o alternative.o i8253.o tsc_32.o\
+		ptrace_bts.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
Index: linux-2.6/include/asm-x86/thread_info_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/thread_info_32.h	2007-11-07 09:08:32.%N +0100
+++ linux-2.6/include/asm-x86/thread_info_32.h	2007-11-07 09:09:36.%N +0100
@@ -137,6 +137,9 @@
 #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
 #define TIF_FREEZE		19	/* is freezing for suspend */
 #define TIF_NOTSC		20	/* TSC is not accessible in userland */
+/* gap to use same numbers for _32 and _64 variants */
+#define TIF_BTS_TRACE           24      /* record branches for this task */
+#define TIF_BTS_TRACE_TS        25      /* record scheduling event timestamps */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -151,6 +154,8 @@
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_NOTSC		(1<<TIF_NOTSC)
+#define _TIF_BTS_TRACE		(1<<TIF_BTS_TRACE)
+#define _TIF_BTS_TRACE_TS	(1<<TIF_BTS_TRACE_TS)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
Index: linux-2.6/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/processor_32.h	2007-11-07 09:08:32.%N +0100
+++ linux-2.6/include/asm-x86/processor_32.h	2007-11-07 09:09:36.%N +0100
@@ -353,6 +353,9 @@
 	unsigned long	esp;
 	unsigned long	fs;
 	unsigned long	gs;
+/* Debug Store - if not 0 points to a DS Save Area configuration;
+ *               goes into MSR_IA32_DS_AREA */
+	unsigned long	ds_area;
 /* Hardware debugging registers */
 	unsigned long	debugreg[8];  /* %%db0-7 debug registers */
 /* fault info */
Index: linux-2.6/arch/x86/kernel/Makefile_64
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile_64	2007-11-07 09:08:32.%N +0100
+++ linux-2.6/arch/x86/kernel/Makefile_64	2007-11-07 09:09:36.%N +0100
@@ -9,7 +9,7 @@
 		x8664_ksyms_64.o i387_64.o syscall_64.o vsyscall_64.o \
 		setup64.o bootflag.o e820_64.o reboot_64.o quirks.o i8237.o \
 		pci-dma_64.o pci-nommu_64.o alternative.o hpet.o tsc_64.o bugs_64.o \
-		i8253.o
+		i8253.o ptrace_bts.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
Index: linux-2.6/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process_64.c	2007-11-07 09:08:32.%N +0100
+++ linux-2.6/arch/x86/kernel/process_64.c	2007-11-07 09:09:36.%N +0100
@@ -677,6 +677,18 @@
 	    || test_tsk_thread_flag(prev_p, TIF_IO_BITMAP))
 		__switch_to_xtra(prev_p, next_p, tss);
 
+	/*
+	 * Last branch recording recofiguration of trace hardware and
+	 * disentangling of trace data per task.
+	 */
+	if (unlikely(task_thread_info(prev_p)->flags & _TIF_BTS_TRACE ||
+		     task_thread_info(prev_p)->flags & _TIF_BTS_TRACE_TS))
+		ptrace_bts_task_departs(prev_p);
+
+	if (unlikely(task_thread_info(next_p)->flags & _TIF_BTS_TRACE ||
+		     task_thread_info(next_p)->flags & _TIF_BTS_TRACE_TS))
+		ptrace_bts_task_arrives(next_p);
+
 	/* If the task has used fpu the last 5 timeslices, just do a full
 	 * restore of the math state immediately to avoid the trap; the
 	 * chances of needing FPU soon are obviously high now
Index: linux-2.6/arch/x86/kernel/ptrace_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/ptrace_64.c	2007-11-07 09:08:32.%N +0100
+++ linux-2.6/arch/x86/kernel/ptrace_64.c	2007-11-07 09:09:36.%N +0100
@@ -28,6 +28,7 @@
 #include <asm/desc.h>
 #include <asm/proto.h>
 #include <asm/ia32.h>
+#include <asm/ptrace_bts.h>
 
 /*
  * does not yet catch signals sent when the child dies.
@@ -224,6 +225,7 @@
 void ptrace_disable(struct task_struct *child)
 { 
 	clear_singlestep(child);
+	ptrace_bts_task_detached(child);
 }
 
 static int putreg(struct task_struct *child,
@@ -555,6 +557,37 @@
 		break;
 	}
 
+	case PTRACE_BTS_INIT:
+		ret = ptrace_bts_init();
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
+			 (struct ptrace_bts_record __user *) addr);
+		break;
+
+	case PTRACE_BTS_CONFIG:
+		ptrace_bts_config(child, data);
+		ret = 0;
+		break;
+
+	case PTRACE_BTS_STATUS:
+		ret = ptrace_bts_status(child);
+		break;
+
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		break;
Index: linux-2.6/include/asm-x86/processor_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/processor_64.h	2007-11-07 09:08:32.%N +0100
+++ linux-2.6/include/asm-x86/processor_64.h	2007-11-07 09:09:36.%N +0100
@@ -223,6 +223,9 @@
 	unsigned long	fs;
 	unsigned long	gs;
 	unsigned short	es, ds, fsindex, gsindex;	
+/* Debug Store - if not 0 points to a DS Save Area configuration;
+ *               goes into MSR_IA32_DS_AREA */
+	unsigned long	ds_area;
 /* Hardware debugging registers */
 	unsigned long	debugreg0;  
 	unsigned long	debugreg1;  
Index: linux-2.6/include/asm-x86/thread_info_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/thread_info_64.h	2007-11-07 09:08:32.%N +0100
+++ linux-2.6/include/asm-x86/thread_info_64.h	2007-11-07 09:09:36.%N +0100
@@ -123,6 +123,8 @@
 #define TIF_DEBUG		21	/* uses debug registers */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
 #define TIF_FREEZE		23	/* is freezing for suspend */
+#define TIF_BTS_TRACE		24	/* record branches for this task */
+#define TIF_BTS_TRACE_TS	25	/* record scheduling event timestamps */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -139,6 +141,8 @@
 #define _TIF_DEBUG		(1<<TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_BTS_TRACE		(1<<TIF_BTS_TRACE)
+#define _TIF_BTS_TRACE_TS	(1<<TIF_BTS_TRACE_TS)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
