Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbXK2IW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbXK2IW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 03:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbXK2IWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 03:22:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:7622 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbXK2IWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 03:22:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,228,1194249600"; 
   d="scan'208";a="328388465"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: [patch 1/2] x86, ptrace: support for branch trace store(BTS)
Date: Thu, 29 Nov 2007 08:14:13 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF5544401024076@swsmsx413.ger.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 1/2] x86, ptrace: support for branch trace store(BTS)
thread-index: AcgyX9OSACcQp3CnRsS4wifjE0TFxg==
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <hpa@zytor.com>,
       <tglx@linutronix.de>, <ak@suse.de>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       <akpm@linux-foundation.org>
X-OriginalArrivalTime: 29 Nov 2007 08:14:09.0962 (UTC) FILETIME=[D19628A0:01C8325F]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to previous version(s):
- moved task arrives/departs notifications to __switch_to_xtra()
- added _TIF_BTS_TRACE and _TIF_BTS_TRACE_TS to _TIF_WORK_CTXSW_*
- split _TIF_WORK_CTXSW into ~_PREV and ~_NEXT for x86_64
- ptrace_bts_init_intel() function called from init_intel()
- removed PTRACE_BTS_INIT ptrace command
- cache DEBUGCTRL MSR
- replace struct declarations and operations struct with
  configuration struct defining offset/size pairs and
  generic operations
- added a patch for the ptrace.2 man page for discussing the API
  in this forum


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process_32.c	2007-11-29 08:36:16.%N
+0100
+++ linux-2.6/arch/x86/kernel/process_32.c	2007-11-29 08:42:35.%N
+0100
@@ -623,6 +623,19 @@
 	}
 #endif
 
+	/*
+	 * Last branch recording recofiguration of trace hardware and
+	 * disentangling of trace data per task.
+	 */
+	if (test_tsk_thread_flag(prev_p, TIF_BTS_TRACE) ||
+	    test_tsk_thread_flag(prev_p, TIF_BTS_TRACE_TS))
+		ptrace_bts_task_departs(prev_p);
+
+	if (test_tsk_thread_flag(next_p, TIF_BTS_TRACE) ||
+	    test_tsk_thread_flag(next_p, TIF_BTS_TRACE_TS))
+		ptrace_bts_task_arrives(next_p);
+
+
 	if (!test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
 		/*
 		 * Disable the bitmap via an invalid offset. We still
cache
Index: linux-2.6/arch/x86/kernel/ptrace_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/ptrace_32.c	2007-11-29 08:36:16.%N
+0100
+++ linux-2.6/arch/x86/kernel/ptrace_32.c	2007-11-29 08:42:35.%N
+0100
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
@@ -610,6 +612,32 @@
 					(struct user_desc __user *)
data);
 		break;
 
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
Index: linux-2.6/include/asm-x86/ptrace-abi.h
===================================================================
--- linux-2.6.orig/include/asm-x86/ptrace-abi.h	2007-11-29 08:36:16.%N
+0100
+++ linux-2.6/include/asm-x86/ptrace-abi.h	2007-11-29 08:42:35.%N
+0100
@@ -78,4 +78,49 @@
 # define PTRACE_SYSEMU_SINGLESTEP 32
 #endif
 
+/*
+ * Maximal BTS buffer size in number of records
+ * This is a macro, not a ptrace command.
+ */
+#define PTRACE_BTS_MAX_BTS_SIZE 4000
+
+
+/* Allocate new bts buffer (free old one, if exists) of size DATA bts
records;
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
+   After the first warp-around, this is the start of the circular bts
buffer.
+   ENXIO....ptrace bts not initialized or no buffer allocated */
+#define PTRACE_BTS_GET_INDEX 43
+
+/* Read the DATA'th bts record into a ptrace_bts_record buffer provided
in ADDR.
+   Return 0, if successful; -1, otherwise
+   ENXIO....ptrace bts not initialized or no buffer allocated
+   EINVAL...invalid index */
+#define PTRACE_BTS_READ_RECORD 44
+
+/* Configure last branch trace; the configuration is given as a
bit-mask of
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
--- linux-2.6.orig/include/asm-x86/ptrace.h	2007-11-29 08:36:16.%N
+0100
+++ linux-2.6/include/asm-x86/ptrace.h	2007-11-29 08:42:35.%N +0100
@@ -4,8 +4,48 @@
 #include <linux/compiler.h>	/* For __user */
 #include <asm/ptrace-abi.h>
 
+
 #ifndef __ASSEMBLY__
 
+/* a branch trace record entry
+ *
+ * In order to unify the interface between various processor versions,
+ * we use the below data structure for all processors.
+ */
+enum ptrace_bts_qualifier {
+	PTRACE_BTS_INVALID = 0,
+	PTRACE_BTS_BRANCH,
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
+#include <linux/init.h>
+
+struct task_struct;
+struct cpuinfo_x86;
+
+extern __cpuinit void ptrace_bts_init_intel(struct cpuinfo_x86 *c);
+extern void ptrace_bts_task_arrives(struct task_struct *tsk);
+extern void ptrace_bts_task_departs(struct task_struct *tsk);
+
+#endif /* __KERNEL__ */
+
 #ifdef __i386__
 /* this struct defines the way the registers are stored on the
    stack during a system call. */
@@ -64,6 +104,7 @@
 #define regs_return_value(regs) ((regs)->eax)
 
 extern unsigned long profile_pc(struct pt_regs *regs);
+
 #endif /* __KERNEL__ */
 
 #else /* __i386__ */
Index: linux-2.6/arch/x86/kernel/ptrace_bts.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/x86/kernel/ptrace_bts.c	2007-11-29 08:42:35.%N
+0100
@@ -0,0 +1,453 @@
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
+struct ptrace_bts_configuration ptrace_bts_cfg;
+
+/*
+ * Allocate the DS configuration for the parameter task.
+ * Returns an error, if there was already a DS configuration allocated
+ * for the task.
+ * Returns 0, if successful; -Eerrno, otherwise.
+ */
+static int ptrace_bts_allocate_ds(struct task_struct *child)
+{
+	if (!ptrace_bts_cfg.sizeof_ds)
+		return -EOPNOTSUPP;
+
+	if (child->thread.ds_area)
+		return -EEXIST;
+
+	child->thread.ds_area =
+		(unsigned long)kzalloc(ptrace_bts_cfg.sizeof_ds,
GFP_KERNEL);
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
+	void *ds = (void *)child->thread.ds_area;
+	size_t size_in_bytes =
+		size_in_records * ptrace_bts_cfg.sizeof_bts;
+	char *new_buffer = 0;
+
+	if (!ptrace_bts_cfg.sizeof_bts)
+		return -EOPNOTSUPP;
+
+	if (size_in_records < 0)
+		return -EINVAL;
+
+	if (size_in_records > PTRACE_BTS_MAX_BTS_SIZE)
+		return -EINVAL;
+
+	if (!ds) {
+		int err = ptrace_bts_allocate_ds(child);
+		if (err < 0)
+			return err;
+		ds = (void *)child->thread.ds_area;
+	}
+
+	if (size_in_bytes) {
+		new_buffer = kzalloc(size_in_bytes, GFP_KERNEL);
+
+		if (!new_buffer)
+			return -ENOMEM;
+	}
+
+	if (ds)
+		kfree(ptrace_bts_get_bts_buffer_base(ds));
+
+	ptrace_bts_set_bts_buffer_base(ds, new_buffer);
+	ptrace_bts_set_bts_index(ds, new_buffer);
+	ptrace_bts_set_bts_absolute_maximum(ds, new_buffer +
size_in_bytes);
+	ptrace_bts_set_bts_interrupt_threshold(ds,
+					       new_buffer +
size_in_bytes + 1);
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
+	void *ds = (void *)child->thread.ds_area;
+	size_t size_in_bytes;
+
+	if (!ptrace_bts_cfg.sizeof_bts)
+		return -EOPNOTSUPP;
+
+	if (!child->thread.ds_area)
+		return -ENXIO;
+
+	size_in_bytes =
+		ptrace_bts_get_bts_absolute_maximum(ds) -
+		ptrace_bts_get_bts_buffer_base(ds);
+	return size_in_bytes / ptrace_bts_cfg.sizeof_bts;
+}
+
+/*
+ * Returns the bts index of the next record to be written such that it
+ * could be used to access this record in a C array of records.
+ * Returns -Eerrno, if an error occured.
+ */
+int ptrace_bts_get_index(struct task_struct *child)
+{
+	void *ds = (void *)child->thread.ds_area;
+	size_t index_offset_in_bytes;
+
+	if (!ptrace_bts_cfg.sizeof_bts)
+		return -EOPNOTSUPP;
+
+	if (!child->thread.ds_area)
+		return -ENXIO;
+
+	index_offset_in_bytes =
+		ptrace_bts_get_bts_index(ds) -
+		ptrace_bts_get_bts_buffer_base(ds);
+	return index_offset_in_bytes / ptrace_bts_cfg.sizeof_bts;
+}
+
+/*
+ * Copies the index'th BTS record into out.
+ * Converts the internal BTS representation into the external one.
+ * Returns the number of bytes copied, if successful; -Eerrno,
otherwise.
+ *
+ * pre: out points to a buffer big enough to hold one BTS record
+ */
+int ptrace_bts_read_record(struct task_struct *child,
+			   long index,
+			   struct ptrace_bts_record __user *out)
+{
+	void *ds = (void *)child->thread.ds_area;
+	struct ptrace_bts_record ret;
+	void *bts;
+
+	if (!ptrace_bts_cfg.sizeof_bts)
+		return -EOPNOTSUPP;
+
+	if (!child->thread.ds_area)
+		return -ENXIO;
+
+	if (index < 0)
+		return -EINVAL;
+
+	if (index >= ptrace_bts_get_buffer_size(child))
+		return -EINVAL;
+
+	bts = ptrace_bts_get_bts_buffer_base(ds);
+	bts = (char *)bts + (index * ptrace_bts_cfg.sizeof_bts);
+
+	memset(&ret, 0, sizeof(ret));
+	if (ptrace_bts_get_from_ip(bts) == PTRACE_BTS_ESCAPE_ADDRESS) {
+		ret.qualifier         = ptrace_bts_get_info_type(bts);
+		ret.variant.timestamp = ptrace_bts_get_info_data(bts);
+	} else {
+		ret.qualifier = PTRACE_BTS_BRANCH;
+		ret.variant.lbr.from_ip = ptrace_bts_get_from_ip(bts);
+		ret.variant.lbr.to_ip   = ptrace_bts_get_to_ip(bts);
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
+ * Returns the number of bytes copied, if successful; -Eerrno,
otherwise.
+ *
+ * pre: child is not running
+ */
+static int ptrace_bts_write_record(struct task_struct *child,
+				   const struct ptrace_bts_record *in)
+{
+	void *ds = (void *)child->thread.ds_area;
+	void *bts;
+
+	if (!ptrace_bts_cfg.sizeof_bts)
+		return -EOPNOTSUPP;
+
+	if (!child->thread.ds_area)
+		return -ENXIO;
+
+	if (ptrace_bts_get_buffer_size(child) <= 0)
+		return -ENXIO;
+
+	bts = ptrace_bts_get_bts_index(ds);
+
+	memset(bts, 0, ptrace_bts_cfg.sizeof_bts);
+	switch (in->qualifier) {
+	case PTRACE_BTS_INVALID:
+		break;
+
+	case PTRACE_BTS_BRANCH:
+		ptrace_bts_set_from_ip(bts, in->variant.lbr.from_ip);
+		ptrace_bts_set_to_ip(bts, in->variant.lbr.to_ip);
+		break;
+
+	case PTRACE_BTS_TASK_ARRIVES:
+	case PTRACE_BTS_TASK_DEPARTS:
+		ptrace_bts_set_from_ip(bts, PTRACE_BTS_ESCAPE_ADDRESS);
+		ptrace_bts_set_info_type(bts, in->qualifier);
+		ptrace_bts_set_info_data(bts, in->variant.timestamp);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+	bts = (char *)bts + ptrace_bts_cfg.sizeof_bts;
+	if (bts >= ptrace_bts_get_bts_absolute_maximum(ds))
+		bts = ptrace_bts_get_bts_buffer_base(ds);
+	ptrace_bts_set_bts_index(ds, bts);
+
+	return ptrace_bts_cfg.sizeof_bts;
+}
+
+/*
+ * Configures ptrace_bts structure in traced task's task_struct.
+ */
+int ptrace_bts_config(struct task_struct *child,
+		       unsigned long options)
+{
+	if (!ptrace_bts_cfg.sizeof_bts)
+		return -EOPNOTSUPP;
+
+	if (options & PTRACE_BTS_O_TRACE_TASK)
+		set_tsk_thread_flag(child, TIF_BTS_TRACE);
+	else
+		clear_tsk_thread_flag(child, TIF_BTS_TRACE);
+
+	if (options & PTRACE_BTS_O_TIMESTAMPS)
+		set_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
+	else
+		clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
+
+	return 0;
+}
+
+/*
+ * Returns the configuration in ptrace_bts structure in traced task's
+ * task_struct.
+ */
+int ptrace_bts_status(struct task_struct *child)
+{
+	int status = 0;
+
+	if (!ptrace_bts_cfg.sizeof_bts)
+		return -EOPNOTSUPP;
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
+	if (!ptrace_bts_cfg.sizeof_ds)
+		return;
+
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
+		wrmsrl(MSR_IA32_DEBUGCTLMSR,
ptrace_bts_cfg.debugctrl_enabled);
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
+	if (!ptrace_bts_cfg.sizeof_ds)
+		return;
+
+	if (test_tsk_thread_flag(tsk, TIF_BTS_TRACE))
+		wrmsrl(MSR_IA32_DEBUGCTLMSR,
ptrace_bts_cfg.debugctrl_disabled);
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
+static const struct ptrace_bts_configuration ptrace_bts_cfg_netburst =
{
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
+	.debugctrl_mask = (1<<2)|(1<<3)
+};
+
+static const struct ptrace_bts_configuration ptrace_bts_cfg_pentium_m =
{
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
+	.debugctrl_mask = (1<<6)|(1<<7)
+};
+#endif /* _i386_ */
+
+static const struct ptrace_bts_configuration ptrace_bts_cfg_core2 = {
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
+	.debugctrl_mask = (1<<6)|(1<<7)|(1<<9)
+};
+
+static inline void
+ptrace_bts_configure(const struct ptrace_bts_configuration *cfg)
+{
+	unsigned long long debugctl_msr = 0;
+
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
+
+	ptrace_bts_cfg = *cfg;
+	ptrace_bts_cfg.debugctrl_enabled =
+		debugctl_msr | ptrace_bts_cfg.debugctrl_mask;
+	ptrace_bts_cfg.debugctrl_disabled =
+		debugctl_msr & ~ptrace_bts_cfg.debugctrl_mask;
+}
+
+/*
+ * Initialize last branch tracing.
+ * Detect hardware and initialize the operations function table.
+ */
+__cpuinit void ptrace_bts_init_intel(struct cpuinfo_x86 *c)
+{
+	switch (c->x86) {
+	case 0x6:
+		switch (c->x86_model) {
+#ifdef __i386__
+		case 0xD:
+		case 0xE: /* Pentium M */
+			ptrace_bts_configure(&ptrace_bts_cfg_pentium_m);
+			break;
+#endif /* _i386_ */
+		case 0xF: /* Core2 */
+			ptrace_bts_configure(&ptrace_bts_cfg_core2);
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
+			ptrace_bts_configure(&ptrace_bts_cfg_netburst);
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
Index: linux-2.6/include/asm-x86/ptrace_bts.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/asm-x86/ptrace_bts.h	2007-11-29 08:42:35.%N
+0100
@@ -0,0 +1,182 @@
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
+ * 64bit pointers even in 32bit mode.
+ *
+ *
+ * Branch Trace Store (BTS) records store information about control
+ * flow changes. They at least provide the following information:
+ * - source linear address
+ * - destination linear address
+ *
+ *
+ * In order to abstract from the actual DS and BTS layout, we describe
+ * the access to the relevant fields.
+ * Thanks to Andi Kleen for proposing this design.
+ *
+ * The implementation, however, is not as general as it might seem. In
+ * order to stay somewhat simple and efficient, we assume an
+ * underlying unsigned type and we expect the field to be at least as
+ * big as that type.
+ */
+
+/*
+ * A field access descriptor
+ */
+struct ptrace_access_desc {
+	unsigned char offset;
+	unsigned char size;
+};
+
+/*
+ * The configuration for a particular DS/BTS hardware implementation.
+ */
+struct ptrace_bts_configuration {
+	/* the DS configuration */
+	unsigned char  sizeof_ds;
+	struct ptrace_access_desc bts_buffer_base;
+	struct ptrace_access_desc bts_index;
+	struct ptrace_access_desc bts_absolute_maximum;
+	struct ptrace_access_desc bts_interrupt_threshold;
+	/* the BTS configuration */
+	unsigned char  sizeof_bts;
+	struct ptrace_access_desc from_ip;
+	struct ptrace_access_desc to_ip;
+	/* BTS variants used to store additional information like
+	   timestamps */
+	struct ptrace_access_desc info_type;
+	struct ptrace_access_desc info_data;
+	/* the cached DEBUGCTRL MSR */
+	unsigned long long debugctrl_mask;
+	unsigned long long debugctrl_enabled;
+	unsigned long long debugctrl_disabled;
+};
+
+extern struct ptrace_bts_configuration ptrace_bts_cfg;
+
+
+#define PTRACE_BTS_ESCAPE_ADDRESS ((void *)-1)
+
+static inline void *ptrace_bts_get_bts_buffer_base(char *base)
+{
+	return *(void **)(base + ptrace_bts_cfg.bts_buffer_base.offset);
+}
+static inline void ptrace_bts_set_bts_buffer_base(char *base, void
*value)
+{
+	(*(void **)(base + ptrace_bts_cfg.bts_buffer_base.offset)) =
value;
+}
+static inline void *ptrace_bts_get_bts_index(char *base)
+{
+	return *(void **)(base + ptrace_bts_cfg.bts_index.offset);
+}
+static inline void ptrace_bts_set_bts_index(char *base, void *value)
+{
+	(*(void **)(base + ptrace_bts_cfg.bts_index.offset)) = value;
+}
+static inline void *ptrace_bts_get_bts_absolute_maximum(char *base)
+{
+	return *(void **)(base +
ptrace_bts_cfg.bts_absolute_maximum.offset);
+}
+static inline void ptrace_bts_set_bts_absolute_maximum(char *base, void
*value)
+{
+	(*(void **)(base + ptrace_bts_cfg.bts_absolute_maximum.offset))
= value;
+}
+static inline void *ptrace_bts_get_bts_interrupt_threshold(char *base)
+{
+	return *(void **)(base +
ptrace_bts_cfg.bts_interrupt_threshold.offset);
+}
+static inline void ptrace_bts_set_bts_interrupt_threshold(char *base,
void *value)
+{
+	(*(void **)(base +
ptrace_bts_cfg.bts_interrupt_threshold.offset)) = value;
+}
+static inline void *ptrace_bts_get_from_ip(char *base)
+{
+	return *(void **)(base + ptrace_bts_cfg.from_ip.offset);
+}
+static inline void ptrace_bts_set_from_ip(char *base, void *value)
+{
+	(*(void **)(base + ptrace_bts_cfg.from_ip.offset)) = value;
+}
+static inline void *ptrace_bts_get_to_ip(char *base)
+{
+	return *(void **)(base + ptrace_bts_cfg.to_ip.offset);
+}
+static inline void ptrace_bts_set_to_ip(char *base, void *value)
+{
+	(*(void **)(base + ptrace_bts_cfg.to_ip.offset)) = value;
+}
+static inline unsigned char ptrace_bts_get_info_type(char *base)
+{
+	return *(unsigned char *)(base +
ptrace_bts_cfg.info_type.offset);
+}
+static inline void ptrace_bts_set_info_type(char *base, unsigned char
value)
+{
+	(*(unsigned char *)(base + ptrace_bts_cfg.info_type.offset)) =
value;
+}
+/*
+ * The info data might overlap with the info type on some
architectures.
+ * We therefore read and write the exact number of bytes.
+ */
+static inline unsigned long long ptrace_bts_get_info_data(char *base)
+{
+	unsigned long long value = 0;
+	memcpy(&value,
+	       base + ptrace_bts_cfg.info_data.offset,
+	       ptrace_bts_cfg.info_data.size);
+	return value;
+}
+static inline void ptrace_bts_set_info_data(char *base, unsigned long
long value)
+{
+	memcpy(base + ptrace_bts_cfg.info_data.offset,
+	       &value,
+	       ptrace_bts_cfg.info_data.size);
+}
+
+extern int ptrace_bts_allocate_bts(struct task_struct *child,
+				   long size_in_records);
+extern int ptrace_bts_get_buffer_size(struct task_struct *child);
+extern int ptrace_bts_get_index(struct task_struct *child);
+extern int ptrace_bts_read_record(struct task_struct *child,
+				  long index,
+				  struct ptrace_bts_record __user *out);
+extern int ptrace_bts_config(struct task_struct *child,
+			     unsigned long options);
+extern int ptrace_bts_status(struct task_struct *child);
+extern void ptrace_bts_task_detached(struct task_struct *tsk);
+
+#endif /* _ASM_X86_PTRACE_BTS_H */
Index: linux-2.6/arch/x86/kernel/Makefile_32
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile_32	2007-11-29 08:36:16.%N
+0100
+++ linux-2.6/arch/x86/kernel/Makefile_32	2007-11-29 08:42:35.%N
+0100
@@ -8,7 +8,8 @@
 obj-y	:= process_32.o signal_32.o entry_32.o traps_32.o irq_32.o \
 		ptrace_32.o time_32.o ioport_32.o ldt_32.o setup_32.o
i8259_32.o sys_i386_32.o \
 		pci-dma_32.o i386_ksyms_32.o i387_32.o bootflag.o
e820_32.o\
-		quirks.o i8237.o topology.o alternative.o i8253.o
tsc_32.o
+		quirks.o i8237.o topology.o alternative.o i8253.o
tsc_32.o\
+		ptrace_bts.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
Index: linux-2.6/include/asm-x86/thread_info_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/thread_info_32.h	2007-11-29
08:36:16.%N +0100
+++ linux-2.6/include/asm-x86/thread_info_32.h	2007-11-29 08:42:35.%N
+0100
@@ -137,6 +137,9 @@
 #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
 #define TIF_FREEZE		19	/* is freezing for suspend */
 #define TIF_NOTSC		20	/* TSC is not accessible in
userland */
+/* gap to use same numbers for _32 and _64 variants */
+#define TIF_BTS_TRACE           24      /* record branches for this
task */
+#define TIF_BTS_TRACE_TS        25      /* record scheduling event
timestamps */
 
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
@@ -160,8 +165,11 @@
 #define _TIF_ALLWORK_MASK	(0x0000FFFF & ~_TIF_SECCOMP)
 
 /* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW_NEXT (_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_DEBUG)
-#define _TIF_WORK_CTXSW_PREV (_TIF_IO_BITMAP | _TIF_NOTSC)
+#define _TIF_WORK_CTXSW_NEXT \
+  (_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_DEBUG | \
+   _TIF_BTS_TRACE | _TIF_BTS_TRACE_TS)
+#define _TIF_WORK_CTXSW_PREV \
+  (_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_BTS_TRACE | _TIF_BTS_TRACE_TS)
 
 /*
  * Thread-synchronous status.
Index: linux-2.6/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/processor_32.h	2007-11-29
08:36:16.%N +0100
+++ linux-2.6/include/asm-x86/processor_32.h	2007-11-29 08:42:35.%N
+0100
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
--- linux-2.6.orig/arch/x86/kernel/Makefile_64	2007-11-29 08:36:16.%N
+0100
+++ linux-2.6/arch/x86/kernel/Makefile_64	2007-11-29 08:42:35.%N
+0100
@@ -11,7 +11,7 @@
 		x8664_ksyms_64.o i387_64.o syscall_64.o vsyscall_64.o \
 		setup64.o bootflag.o e820_64.o reboot_64.o quirks.o
i8237.o \
 		pci-dma_64.o pci-nommu_64.o alternative.o hpet.o
tsc_64.o bugs_64.o \
-		i8253.o
+		i8253.o ptrace_bts.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
Index: linux-2.6/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process_64.c	2007-11-29 08:36:16.%N
+0100
+++ linux-2.6/arch/x86/kernel/process_64.c	2007-11-29 08:42:35.%N
+0100
@@ -570,6 +570,18 @@
 		 */
 		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
 	}
+
+	/*
+	 * Last branch recording recofiguration of trace hardware and
+	 * disentangling of trace data per task.
+	 */
+	if (test_tsk_thread_flag(prev_p, TIF_BTS_TRACE) ||
+	    test_tsk_thread_flag(prev_p, TIF_BTS_TRACE_TS))
+		ptrace_bts_task_departs(prev_p);
+
+	if (test_tsk_thread_flag(next_p, TIF_BTS_TRACE) ||
+	    test_tsk_thread_flag(next_p, TIF_BTS_TRACE_TS))
+		ptrace_bts_task_arrives(next_p);
 }
 
 /*
@@ -673,8 +685,8 @@
 	/*
 	 * Now maybe reload the debug registers and handle I/O bitmaps
 	 */
-	if (unlikely((task_thread_info(next_p)->flags &
_TIF_WORK_CTXSW))
-	    || test_tsk_thread_flag(prev_p, TIF_IO_BITMAP))
+	if (unlikely(task_thread_info(next_p)->flags &
_TIF_WORK_CTXSW_NEXT ||
+		     task_thread_info(prev_p)->flags &
_TIF_WORK_CTXSW_PREV))
 		__switch_to_xtra(prev_p, next_p, tss);
 
 	/* If the task has used fpu the last 5 timeslices, just do a
full
Index: linux-2.6/arch/x86/kernel/ptrace_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/ptrace_64.c	2007-11-29 08:36:16.%N
+0100
+++ linux-2.6/arch/x86/kernel/ptrace_64.c	2007-11-29 08:42:35.%N
+0100
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
@@ -555,6 +557,32 @@
 		break;
 	}
 
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
Index: linux-2.6/include/asm-x86/processor_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/processor_64.h	2007-11-29
08:36:16.%N +0100
+++ linux-2.6/include/asm-x86/processor_64.h	2007-11-29 08:42:35.%N
+0100
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
--- linux-2.6.orig/include/asm-x86/thread_info_64.h	2007-11-29
08:36:16.%N +0100
+++ linux-2.6/include/asm-x86/thread_info_64.h	2007-11-29 08:42:35.%N
+0100
@@ -123,6 +123,8 @@
 #define TIF_DEBUG		21	/* uses debug registers */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
 #define TIF_FREEZE		23	/* is freezing for suspend */
+#define TIF_BTS_TRACE           24      /* record branches for this
task */
+#define TIF_BTS_TRACE_TS        25      /* record scheduling event
timestamps */
 
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
@@ -147,7 +151,10 @@
 #define _TIF_ALLWORK_MASK (0x0000FFFF & ~_TIF_SECCOMP)
 
 /* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW (_TIF_DEBUG|_TIF_IO_BITMAP)
+#define _TIF_WORK_CTXSW_NEXT \
+  (_TIF_DEBUG|_TIF_IO_BITMAP|_TIF_BTS_TRACE|_TIF_BTS_TRACE_TS)
+#define _TIF_WORK_CTXSW_PREV \
+  (_TIF_IO_BITMAP|_TIF_BTS_TRACE|_TIF_BTS_TRACE_TS)
 
 #define PREEMPT_ACTIVE     0x10000000
 
Index: linux-2.6/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel.c	2007-11-29 08:36:16.%N
+0100
+++ linux-2.6/arch/x86/kernel/cpu/intel.c	2007-11-29 08:42:35.%N
+0100
@@ -11,6 +11,7 @@
 #include <asm/pgtable.h>
 #include <asm/msr.h>
 #include <asm/uaccess.h>
+#include <asm/ptrace.h>
 
 #include "cpu.h"
 
@@ -219,6 +220,9 @@
 		if (!(l1 & (1<<12)))
 			set_bit(X86_FEATURE_PEBS, c->x86_capability);
 	}
+
+	if (cpu_has_bts)
+		ptrace_bts_init_intel(c);
 }
 
 static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 * c,
unsigned int size)
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c	2007-11-29 08:36:16.%N
+0100
+++ linux-2.6/arch/x86/kernel/setup_64.c	2007-11-29 08:42:35.%N
+0100
@@ -59,6 +59,7 @@
 #include <asm/sections.h>
 #include <asm/dmi.h>
 #include <asm/cacheflush.h>
+#include <asm/ptrace_bts.h>
 
 /*
  * Machine setup..
@@ -795,6 +796,10 @@
 			set_bit(X86_FEATURE_PEBS, c->x86_capability);
 	}
 
+
+	if (cpu_has_bts)
+		ptrace_bts_init_intel(c);
+
 	n = c->extended_cpuid_level;
 	if (n >= 0x80000008) {
 		unsigned eax = cpuid_eax(0x80000008);
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
