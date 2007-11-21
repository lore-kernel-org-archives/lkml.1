Return-Path: <linux-kernel-owner+w=401wt.eu-S1761268AbXKULDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761268AbXKULDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 06:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbXKULC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 06:02:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:57170 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbXKULCx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 06:02:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,446,1188802800"; 
   d="scan'208";a="396057776"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch][v2] x86, ptrace: support for branch trace store(BTS)
Date: Wed, 21 Nov 2007 11:02:38 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF55444F718D9@swsmsx413.ger.corp.intel.com>
In-Reply-To: <200711201345.39580.ak@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch][v2] x86, ptrace: support for branch trace store(BTS)
thread-index: Acgrc92l4kML251TSC2GV2WEG/lkJwArVjWQ
References: <029E5BE7F699594398CA44E3DDF55444F3AEA7@swsmsx413.ger.corp.intel.com> <200711201345.39580.ak@suse.de>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <mingo@elte.hu>, <hpa@zytor.com>,
       <tglx@linutronix.de>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       <akpm@linux-foundation.org>
X-OriginalArrivalTime: 21 Nov 2007 11:02:37.0538 (UTC) FILETIME=[06DDDC20:01C82C2E]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> - the internal buffer interpretation as well as the corresponding
>>   operations are selected at run-time by hardware detection
>>   - different processors use different branch record formats
>
>I still think it would be far better if you would switch this 
>over to be table
>driven. e.g. define a record that contains offsetof()/sizeof() of the 
>different formats and use generic functions. That would decrease
>code size considerably.

Here's how this may look like.

I rewrote it for the DS access. Since DS is homogenous and only varies
in the address size, I made the address size a field in the
configuration 
struct and do the address computation in macros.

I could alternatively encode the offset and size for every field in the
configuration struct instead of computing it. I think that is what you
originally suggested.

The BTS record format is inhomogenous and thus would require storing the
offset and size of every field in the configuration struct. I did not
do those changes, yet, since I would first like to get feedback.

Regarding code size, the original version requires ~500 bytes for a new 
BTS architecture (for x86_64, measured by counting sizes obtained by 
readelf); this could be reduced to ~100 bytes.


It seems we're avoiding to declare a structured data type and instead 
prefer to describe the type indirectly.
We gain the flexibility to work with different data layouts.
We loose language support for working with structured types.

What we would really want here are templates.

I think that the absence of an explicit type declaration makes the code
harder to understand and makes it easier to get it wrong when adding a
new processor.

The code is not robust wrt small mistakes in the data layout spec. It
might check that the field we're writing to is at least as big as the
value we're writing; the same for reads. We would end up replacing
static
type checking with dynamic type checking.
This might not be strictly necessary, but I would argue that it's easier

to get a type declaration correct than to get the offsetof/sizeof pairs
correct for each field of the type.


I would prefer to work with explicit type declarations, even if this 
means a small increase in code size. It looks like the hardware settled
on 64bit pointers everywhere, so I would not expect much more variation
in DS. BTS has an unused field, which might go away some day.

What do you think?



Index: linux-2.6/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process_32.c	2007-11-19 11:50:05.%N
+0100
+++ linux-2.6/arch/x86/kernel/process_32.c	2007-11-19 15:49:53.%N
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
--- linux-2.6.orig/arch/x86/kernel/ptrace_32.c	2007-11-19 11:50:05.%N
+0100
+++ linux-2.6/arch/x86/kernel/ptrace_32.c	2007-11-19 13:11:46.%N
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
@@ -610,6 +612,33 @@
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
--- linux-2.6.orig/include/asm-x86/ptrace-abi.h	2007-11-19 11:50:05.%N
+0100
+++ linux-2.6/include/asm-x86/ptrace-abi.h	2007-11-19 13:11:46.%N
+0100
@@ -78,4 +78,43 @@
 # define PTRACE_SYSEMU_SINGLESTEP 32
 #endif
 
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
--- linux-2.6.orig/include/asm-x86/ptrace.h	2007-11-19 11:50:05.%N
+0100
+++ linux-2.6/include/asm-x86/ptrace.h	2007-11-20 08:35:27.%N +0100
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
+++ linux-2.6/arch/x86/kernel/ptrace_bts.c	2007-11-21 09:33:07.%N
+0100
@@ -0,0 +1,565 @@
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
+/*
+ * Maximal BTS size in number of records
+ */
+#define PTRACE_BTS_MAX_BTS_SIZE 4000
+
+
+struct ptrace_bts_configuration ptrace_bts_cfg;
+
+/*
+ * Configure trace hardware to enable tracing
+ * Return 0, on success; -Eerrno, otherwise.
+ */
+static int ptrace_bts_enable(void)
+{
+	unsigned long long debugctl_msr = 0;
+
+	if (!ptrace_bts_cfg.debugctrl_mask)
+		return -EOPNOTSUPP;
+
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
+	debugctl_msr |= ptrace_bts_cfg.debugctrl_mask;
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
+
+	return 0;
+
+}
+
+/*
+ * Configure trace hardware to disable tracing
+ * Return 0, on success; -Eerrno, otherwise.
+ */
+static int ptrace_bts_disable(void)
+{
+	unsigned long long debugctl_msr = 0;
+
+	if (!ptrace_bts_cfg.debugctrl_mask)
+		return -EOPNOTSUPP;
+
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
+	debugctl_msr &= ~ptrace_bts_cfg.debugctrl_mask;
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
+	size_t size_in_bytes =
+		ptrace_bts_cfg.sizeof_addr * ptrace_bts_num_fields;
+
+	if (!ptrace_bts_cfg.sizeof_addr)
+		return -EOPNOTSUPP;
+
+	if (child->thread.ds_area)
+		return -EEXIST;
+
+	child->thread.ds_area =
+		(unsigned long)kzalloc(size_in_bytes, GFP_KERNEL);
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
+	size_t size_in_bytes =
+		size_in_records * ptrace_bts_cfg.sizeof_bts;
+	char *new_buffer = 0;
+
+	if (!ptrace_bts_cfg.sizeof_bts)
+		return -EOPNOTSUPP;
+
+	if (!ptrace_bts_cfg.sizeof_addr)
+		return -EOPNOTSUPP;
+
+	if (size_in_records < 0)
+		return -EINVAL;
+
+	if (size_in_records > PTRACE_BTS_MAX_BTS_SIZE)
+		return -EINVAL;
+
+	if (!child->thread.ds_area) {
+		int err = ptrace_bts_allocate_ds(child);
+		if (err < 0)
+			return err;
+	}
+
+	if (size_in_bytes) {
+		new_buffer = kzalloc(size_in_bytes, GFP_KERNEL);
+
+		if (!new_buffer)
+			return -ENOMEM;
+	}
+	kfree(get_bts_buffer_base(child->thread.ds_area));
+
+	set_bts_buffer_base(child->thread.ds_area, new_buffer);
+	set_bts_index(child->thread.ds_area, new_buffer);
+	set_bts_absolute_maximum(child->thread.ds_area,
+				 new_buffer + size_in_bytes);
+	set_bts_interrupt_threshold(child->thread.ds_area,
+				    new_buffer + size_in_bytes + 1);
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
+	size_t size_in_bytes;
+
+	if (!ptrace_bts_cfg.sizeof_addr)
+		return -EOPNOTSUPP;
+
+	if (!child->thread.ds_area)
+		return -ENXIO;
+
+	size_in_bytes =
+		get_bts_absolute_maximum(child->thread.ds_area) -
+		get_bts_buffer_base(child->thread.ds_area);
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
+	size_t index_offset_in_bytes;
+
+	if (!ptrace_bts_cfg.sizeof_addr)
+		return -EOPNOTSUPP;
+
+	if (!child->thread.ds_area)
+		return -ENXIO;
+
+	index_offset_in_bytes =
+		get_bts_index(child->thread.ds_area) -
+		get_bts_buffer_base(child->thread.ds_area);
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
+	if (!ptrace_bts_cfg.sizeof_addr)
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
+	if (!ptrace_bts_cfg.read_record)
+		return -EOPNOTSUPP;
+	return (*ptrace_bts_cfg.read_record)(child, index, out);
+}
+
+#ifdef __i386__
+static int ptrace_bts_read_record_32(struct task_struct *child,
+				     long index,
+				     struct ptrace_bts_record __user
*out)
+{
+	struct ptrace_bts_32 *bts =
+		get_bts_buffer_base(child->thread.ds_area);
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
+					     struct ptrace_bts_record
__user *out)
+{
+	struct ptrace_bts_64_noflags *bts =
+		get_bts_buffer_base(child->thread.ds_area);
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
+ * Returns the number of bytes copied, if successful; -Eerrno,
otherwise.
+ *
+ * pre: child is not running
+ */
+static int ptrace_bts_write_record(struct task_struct *child,
+				   const struct ptrace_bts_record *in)
+{
+	if (!ptrace_bts_cfg.sizeof_addr)
+		return -EOPNOTSUPP;
+
+	if (!child->thread.ds_area)
+		return -ENXIO;
+
+	if (ptrace_bts_get_buffer_size(child) <= 0)
+		return -ENXIO;
+
+	if (!ptrace_bts_cfg.write_record)
+		return -EOPNOTSUPP;
+	return (*ptrace_bts_cfg.write_record)(child, in);
+}
+
+#ifdef __i386__
+static int ptrace_bts_write_record_32(struct task_struct *child,
+				      const struct ptrace_bts_record
*in)
+{
+	struct ptrace_bts_32 *writep =
+		get_bts_index(child->thread.ds_area);
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
+		*writep++ = record;
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
+		*writep++ = *conv;
+
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	set_bts_index(child->thread.ds_area, writep);
+	if ((void *)writep >=
get_bts_absolute_maximum(child->thread.ds_area))
+		set_bts_index(child->thread.ds_area,
+
get_bts_buffer_base(child->thread.ds_area));
+
+	return 0;
+}
+#endif /* _i386_ */
+
+static int ptrace_bts_write_record_64_noflags(struct task_struct
*child,
+					      const struct
ptrace_bts_record *in)
+{
+	struct ptrace_bts_64_noflags *writep =
+		get_bts_index(child->thread.ds_area);
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
+		*writep++ = record;
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
+		*writep++ = *conv;
+
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	set_bts_index(child->thread.ds_area, writep);
+	if ((void *)writep >=
get_bts_absolute_maximum(child->thread.ds_area))
+		set_bts_index(child->thread.ds_area,
+
get_bts_buffer_base(child->thread.ds_area));
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
+static const struct ptrace_bts_configuration ptrace_bts_cfg_netburst =
{
+	.sizeof_addr = 4,
+	.sizeof_bts = sizeof(struct ptrace_bts_32),
+	.debugctrl_mask = (1<<2)|(1<<3),
+
+	.read_record = ptrace_bts_read_record_32,
+	.write_record = ptrace_bts_write_record_32
+};
+
+static const struct ptrace_bts_configuration ptrace_bts_cfg_pentium_m =
{
+	.sizeof_addr = 4,
+	.sizeof_bts = sizeof(struct ptrace_bts_32),
+	.debugctrl_mask = (1<<6)|(1<<7),
+
+	.read_record = ptrace_bts_read_record_32,
+	.write_record = ptrace_bts_write_record_32
+};
+#endif /* _i386_ */
+
+static const struct ptrace_bts_configuration ptrace_bts_cfg_core2 = {
+	.sizeof_addr = 8,
+	.sizeof_bts = sizeof(struct ptrace_bts_64_noflags),
+	.debugctrl_mask = (1<<6)|(1<<7)|(1<<9),
+
+	.read_record = ptrace_bts_read_record_64_noflags,
+	.write_record = ptrace_bts_write_record_64_noflags
+};
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
+			ptrace_bts_cfg = ptrace_bts_cfg_pentium_m;
+			break;
+#endif /* _i386_ */
+		case 0xF: /* Core2 */
+			ptrace_bts_cfg = ptrace_bts_cfg_core2;
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
+		case 0x2:
+		case 0x3: /* Netburst */
+			ptrace_bts_cfg = ptrace_bts_cfg_netburst;
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
+++ linux-2.6/include/asm-x86/ptrace_bts.h	2007-11-21 10:01:53.%N
+0100
@@ -0,0 +1,185 @@
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
+ * A function table holding operations related to last branch
recording.
+ * The table is used to abstract from different last branch recording
+ * hardware. It is initialized by ptrace_bts_init; most other
ptrace_bts
+ * functions basically forward the request to the function table.
+ * Each function table supports a specific DS/BTS combination.
+ */
+struct ptrace_bts_configuration {
+	/* size of an address in DS */
+	u32 sizeof_addr;
+	/* size of a BTS record */
+	u32 sizeof_bts;
+	/* bitmask to enable/disable BTS in debugctrl msr */
+	u64 debugctrl_mask;
+
+	int (*read_record)(struct task_struct *, long,
+			   struct ptrace_bts_record __user *);
+	int (*write_record)(struct task_struct *,
+			    const struct ptrace_bts_record*);
+};
+
+extern struct ptrace_bts_configuration ptrace_bts_cfg;
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
+ */
+
+enum ptrace_bts_field {
+	bts_buffer_base = 0,
+	bts_index,
+	bts_absolute_maximum,
+	bts_interrupt_threshold,
+	pebs_buffer_base,
+	pebs_index,
+	pebs_absolute_maximum,
+	pebs_interrupt_threshold,
+	pebs_counter_reset_value,
+
+	ptrace_bts_num_fields
+};
+
+#define addrof_bts_buffer_base(ds) \
+  (void **)((char *)ds + (ptrace_bts_cfg.sizeof_addr *
bts_buffer_base))
+#define addrof_bts_index(ds) \
+  (void **)((char *)ds + (ptrace_bts_cfg.sizeof_addr * bts_index))
+#define addrof_bts_absolute_maximum(ds) \
+  (void **)((char *)ds + (ptrace_bts_cfg.sizeof_addr *
bts_absolute_maximum))
+#define addrof_bts_interrupt_threshold(ds) \
+  (void **)((char *)ds + (ptrace_bts_cfg.sizeof_addr *
bts_interrupt_threshold))
+#define addrof_pebs_buffer_base(ds) \
+  (void **)((char *)ds + (ptrace_bts_cfg.sizeof_addr *
pebs_buffer_base))
+#define addrof_pebs_index(ds) \
+  (void **)((char *)ds + (ptrace_bts_cfg.sizeof_addr * pebs_index))
+#define addrof_pebs_absolute_maximum(ds) \
+  (void **)((char *)ds + (ptrace_bts_cfg.sizeof_addr *
pebs_absolute_maximum))
+#define addrof_pebs_interrupt_threshold(ds) \
+  (void **)((char *)ds + (ptrace_bts_cfg.sizeof_addr *
pebs_interrupt_threshold))
+#define addrof_pebs_counter_reset_value(ds) \
+  (void **)((char *)ds + (ptrace_bts_cfg.sizeof_addr *
pebs_counter_reset_value))
+
+#define get_bts_buffer_base(ds)
(*addrof_bts_buffer_base(ds))
+#define get_bts_index(ds)		 (*addrof_bts_index(ds))
+#define get_bts_absolute_maximum(ds)
(*addrof_bts_absolute_maximum(ds))
+#define get_bts_interrupt_threshold(ds)
(*addrof_bts_interrupt_threshold(ds))
+#define get_pebs_buffer_base(ds)	 (*addrof_pebs_buffer_base(ds))
+#define get_pebs_index(ds)		 (*addrof_pebs_index(ds))
+#define get_pebs_absolute_maximum(ds)
(*addrof_pebs_absolute_maximum(ds))
+#define get_pebs_interrupt_threshold(ds)
(*addrof_pebs_interrupt_threshold(ds))
+#define get_pebs_counter_reset_value(ds)
(*addrof_pebs_counter_reset_value(ds))
+
+#define set_bts_buffer_base(ds, value) \
+  ((*addrof_bts_buffer_base(ds)) = value)
+#define set_bts_index(ds, value) \
+  ((*addrof_bts_index(ds)) = value)
+#define set_bts_absolute_maximum(ds, value) \
+  ((*addrof_bts_absolute_maximum(ds)) = value)
+#define set_bts_interrupt_threshold(ds, value) \
+  ((*addrof_bts_interrupt_threshold(ds)) = value)
+#define set_pebs_buffer_base(ds, value) \
+  ((*addrof_pebs_buffer_base(ds)) = value)
+#define set_pebs_index(ds, value) \
+  ((*addrof_pebs_index(ds)) = value)
+#define set_pebs_absolute_maximum(ds, value) \
+  ((*addrof_pebs_absolute_maximum(ds)) = value)
+#define set_pebs_interrupt_threshold(ds, value) \
+  ((*addrof_pebs_interrupt_threshold(ds)) = value)
+#define set_pebs_counter_reset_value(ds, value) \
+  ((*addrof_pebs_counter_reset_value(ds)) = value)
+
+
+/*
+ * Branch Trace Store (BTS) records for various processor variants.
+ * To the user, we provide a single interface declared in
include/asm/ptrace.h.
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
+	enum ptrace_bts_qualifier qualifier :
PTRACE_BTS_QUALIFIER_BIT_SIZE;
+	u64 data : (64 - PTRACE_BTS_QUALIFIER_BIT_SIZE);
+} __attribute__((packed, aligned(4)));
+#endif /* _i386_ */
+
+struct ptrace_bts_info_64_noflags {
+	u64 escape;
+	enum ptrace_bts_qualifier qualifier :
PTRACE_BTS_QUALIFIER_BIT_SIZE;
+	u64 data : (64 - PTRACE_BTS_QUALIFIER_BIT_SIZE);
+	u64 : 64;
+} __attribute__((packed, aligned(8)));
+
+
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
--- linux-2.6.orig/arch/x86/kernel/Makefile_32	2007-11-19 11:50:05.%N
+0100
+++ linux-2.6/arch/x86/kernel/Makefile_32	2007-11-19 13:11:46.%N
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
--- linux-2.6.orig/include/asm-x86/thread_info_32.h	2007-11-19
11:50:05.%N +0100
+++ linux-2.6/include/asm-x86/thread_info_32.h	2007-11-19 13:11:46.%N
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
--- linux-2.6.orig/include/asm-x86/processor_32.h	2007-11-19
11:50:05.%N +0100
+++ linux-2.6/include/asm-x86/processor_32.h	2007-11-19 13:11:46.%N
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
--- linux-2.6.orig/arch/x86/kernel/Makefile_64	2007-11-19 11:50:05.%N
+0100
+++ linux-2.6/arch/x86/kernel/Makefile_64	2007-11-19 13:11:46.%N
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
--- linux-2.6.orig/arch/x86/kernel/process_64.c	2007-11-19 11:50:05.%N
+0100
+++ linux-2.6/arch/x86/kernel/process_64.c	2007-11-19 13:11:46.%N
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
--- linux-2.6.orig/arch/x86/kernel/ptrace_64.c	2007-11-19 11:50:05.%N
+0100
+++ linux-2.6/arch/x86/kernel/ptrace_64.c	2007-11-19 13:11:46.%N
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
@@ -555,6 +557,33 @@
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
--- linux-2.6.orig/include/asm-x86/processor_64.h	2007-11-19
11:50:05.%N +0100
+++ linux-2.6/include/asm-x86/processor_64.h	2007-11-19 13:11:46.%N
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
--- linux-2.6.orig/include/asm-x86/thread_info_64.h	2007-11-19
11:50:05.%N +0100
+++ linux-2.6/include/asm-x86/thread_info_64.h	2007-11-19 13:11:46.%N
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
--- linux-2.6.orig/arch/x86/kernel/cpu/intel.c	2007-11-19 11:50:05.%N
+0100
+++ linux-2.6/arch/x86/kernel/cpu/intel.c	2007-11-20 08:36:18.%N
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
--- linux-2.6.orig/arch/x86/kernel/setup_64.c	2007-11-19 11:50:05.%N
+0100
+++ linux-2.6/arch/x86/kernel/setup_64.c	2007-11-20 08:36:36.%N
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
