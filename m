Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbYBRIlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbYBRIlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 03:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbYBRIlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 03:41:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:30576 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553AbYBRIl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 03:41:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,370,1199692800"; 
   d="scan'208";a="341577535"
Date: Mon, 18 Feb 2008 09:41:09 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com, eranian@googlemail.com
Subject: [patch 1/2] x86, ptrace: support pebs in ds.c
Message-ID: <20080218094109.A27713@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Polish the ds.h interface and add support for PEBS.

Ds.c is meant to be the resource allocator for per-thread and per-cpu
BTS and PEBS recording.
It is used by ptrace to provide execution tracing of debugged tasks.
It will be used by profilers (e.g. perfmon2).
It may be used by kernel debuggers to provide a kernel execution trace.

Changes in detail:
- separate DS and BTS more clearly
- simplify field accesses
- add functions to manage PEBS buffers
- add simple protection/allocation mechanism

I further did two tiny changes to the ptrace user API:
- remove support for cutting the requested buffer size down to the
  maximal available size. Users should check their resource limits.
- request (re)allocation of BTS buffers explicitly.
  This used to be implicit on a change of the requested buffer size.

The user API (ptrace extensions) is not public, yet.

Opens:
- buffer overflow handling
  Currently, only circular buffers are supported. This is all we need
  for debugging. Profilers would want an overflow notification.
  This is planned to be added when perfmon2 is made to use the ds.h
  interface. 


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: linux-2.6-x86/include/asm-x86/ds.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ds.h	2008-02-18 09:17:22.%N +0100
+++ linux-2.6-x86/include/asm-x86/ds.h	2008-02-18 09:17:59.%N +0100
@@ -2,19 +2,22 @@
  * Debug Store (DS) support
  *
  * This provides a low-level interface to the hardware's Debug Store
- * feature that is used for last branch recording (LBR) and
+ * feature that is used for branch trace store (BTS) and
  * precise-event based sampling (PEBS).
  *
- * Different architectures use a different DS layout/pointer size.
- * The below functions therefore work on a void*.
+ * It manages:
+ * - per-thread and per-cpu allocation of BTS and PEBS
+ * - buffer memory allocation (optional)
+ * - buffer overflow handling
+ * - buffer access
+ *
+ * It assumes:
+ * - get_task_struct on all parameter tasks
+ * - current is allowed to trace parameter tasks
  *
  *
- * Since there is no user for PEBS, yet, only LBR (or branch
- * trace store, BTS) is supported.
- *
- *
- * Copyright (C) 2007 Intel Corporation.
- * Markus Metzger <markus.t.metzger@intel.com>, Dec 2007
+ * Copyright (C) 2007-2008 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, 2007-2008
  */
 
 #ifndef _ASM_X86_DS_H
@@ -23,50 +26,206 @@
 #include <linux/types.h>
 #include <linux/init.h>
 
-struct cpuinfo_x86;
 
+struct task_struct;
 
-/* a branch trace record entry
+/*
+ * Request BTS or PEBS
  *
- * In order to unify the interface between various processor versions,
- * we use the below data structure for all processors.
+ * Due to alignement constraints, the actual buffer may be slightly
+ * smaller than the requested or provided buffer.
+ *
+ * Returns 0 on success; -Eerrno otherwise
+ *
+ * task: the task to request recording for;
+ *       NULL for per-cpu recording on the current cpu
+ * base: the base pointer for the (non-pageable) buffer;
+ *       NULL if buffer allocation requested
+ * size: the size of the requested or provided buffer
+ * ovfl: pointer to a function to be called on buffer overflow;
+ *       NULL if cyclic buffer requested
  */
-enum bts_qualifier {
-	BTS_INVALID = 0,
-	BTS_BRANCH,
-	BTS_TASK_ARRIVES,
-	BTS_TASK_DEPARTS
-};
+typedef void (*ds_ovfl_callback_t)(struct task_struct *);
+extern int ds_request_bts(struct task_struct *task, void *base, size_t size,
+			  ds_ovfl_callback_t ovfl);
+extern int ds_request_pebs(struct task_struct *task, void *base, size_t size,
+			   ds_ovfl_callback_t ovfl);
+
+/*
+ * Release BTS or PEBS resources
+ *
+ * Frees buffers allocated on ds_request.
+ *
+ * Returns 0 on success; -Eerrno otherwise
+ *
+ * task: the task to release resources for;
+ *       NULL to release resources for the current cpu
+ */
+extern int ds_release_bts(struct task_struct *task);
+extern int ds_release_pebs(struct task_struct *task);
+
+/*
+ * Return the (array) index of the write pointer.
+ * (assuming an array of BTS/PEBS records)
+ *
+ * Returns -Eerrno on error
+ *
+ * task: the task to access;
+ *       NULL to access the current cpu
+ * pos (out): if not NULL, will hold the result
+ */
+extern int ds_get_bts_index(struct task_struct *task, size_t *pos);
+extern int ds_get_pebs_index(struct task_struct *task, size_t *pos);
 
-struct bts_struct {
-	u64 qualifier;
-	union {
-		/* BTS_BRANCH */
-		struct {
-			u64 from_ip;
-			u64 to_ip;
-		} lbr;
-		/* BTS_TASK_ARRIVES or
-		   BTS_TASK_DEPARTS */
-		u64 jiffies;
-	} variant;
+/*
+ * Return the (array) index one record beyond the end of the array.
+ * (assuming an array of BTS/PEBS records)
+ *
+ * Returns -Eerrno on error
+ *
+ * task: the task to access;
+ *       NULL to access the current cpu
+ * pos (out): if not NULL, will hold the result
+ */
+extern int ds_get_bts_end(struct task_struct *task, size_t *pos);
+extern int ds_get_pebs_end(struct task_struct *task, size_t *pos);
+
+/*
+ * Provide a pointer to the BTS/PEBS record at parameter index.
+ * (assuming an array of BTS/PEBS records)
+ *
+ * The pointer points directly into the buffer. The user is
+ * responsible for copying the record.
+ *
+ * Returns the size of a single record on success; -Eerrno on error
+ *
+ * task: the task to access;
+ *       NULL to access the current cpu
+ * index: the index of the requested record
+ * record (out): pointer to the requested record
+ */
+extern int ds_access_bts(struct task_struct *task,
+			 size_t index, const void **record);
+extern int ds_access_pebs(struct task_struct *task,
+			  size_t index, const void **record);
+
+/*
+ * Write one or more BTS/PEBS records at the write pointer index and
+ * advance the write pointer.
+ *
+ * If size is not a multiple of the record size, trailing bytes are
+ * zeroed out.
+ *
+ * May result in one or more overflow notifications.
+ *
+ * If called during overflow handling, that is, with index >=
+ * interrupt threshold, the write will wrap around.
+ *
+ * An overflow notification is given if and when the interrupt
+ * threshold is reached during or after the write.
+ *
+ * Returns the number of bytes written or -Eerrno.
+ *
+ * task: the task to access;
+ *       NULL to access the current cpu
+ * buffer: the buffer to write
+ * size: the size of the buffer
+ */
+extern int ds_write_bts(struct task_struct *task,
+			const void *buffer, size_t size);
+extern int ds_write_pebs(struct task_struct *task,
+			 const void *buffer, size_t size);
+
+/*
+ * Same as ds_write_bts/pebs, but omit ownership checks.
+ *
+ * This is needed to have some other task than the owner of the
+ * BTS/PEBS buffer or the parameter task itself write into the
+ * respective buffer.
+ */
+extern int ds_unchecked_write_bts(struct task_struct *task,
+				  const void *buffer, size_t size);
+extern int ds_unchecked_write_pebs(struct task_struct *task,
+				   const void *buffer, size_t size);
+
+/*
+ * Reset the write pointer of the BTS/PEBS buffer.
+ *
+ * Returns 0 on success; -Eerrno on error
+ *
+ * task: the task to access;
+ *       NULL to access the current cpu
+ */
+extern int ds_reset_bts(struct task_struct *task);
+extern int ds_reset_pebs(struct task_struct *task);
+
+/*
+ * Clear the BTS/PEBS buffer and reset the write pointer.
+ * The entire buffer will be zeroed out.
+ *
+ * Returns 0 on success; -Eerrno on error
+ *
+ * task: the task to access;
+ *       NULL to access the current cpu
+ */
+extern int ds_clear_bts(struct task_struct *task);
+extern int ds_clear_pebs(struct task_struct *task);
+
+/*
+ * Provide the PEBS counter reset value.
+ *
+ * Returns 0 on success; -Eerrno on error
+ *
+ * task: the task to access;
+ *       NULL to access the current cpu
+ * value (out): the counter reset value
+ */
+extern int ds_get_pebs_reset(struct task_struct *task, u64 *value);
+
+/*
+ * Set the PEBS counter reset value.
+ *
+ * Returns 0 on success; -Eerrno on error
+ *
+ * task: the task to access;
+ *       NULL to access the current cpu
+ * value: the new counter reset value
+ */
+extern int ds_set_pebs_reset(struct task_struct *task, u64 value);
+
+/*
+ * Initialization
+ */
+struct cpuinfo_x86;
+extern void __cpuinit ds_init_intel(struct cpuinfo_x86 *);
+
+
+
+/*
+ * The DS context - part of struct thread_struct.
+ */
+struct ds_context {
+	/* pointer to the DS configuration; goes into MSR_IA32_DS_AREA */
+	unsigned char *ds;
+	/* the owner of the BTS and PEBS configuration, respectively */
+	struct task_struct *owner[2];
+	/* buffer overflow notification function for BTS and PEBS */
+	ds_ovfl_callback_t callback[2];
+	/* the original buffer address */
+	void *buffer[2];
+	/* the number of allocated pages for on-request allocated buffers */
+	unsigned int pages[2];
+	/* use count */
+	unsigned long count;
+	/* a pointer to the context location inside the thread_struct
+	 * or the per_cpu context array */
+	struct ds_context **this;
+	/* a pointer to the task owning this context, or NULL, if the
+	 * context is owned by a cpu */
+	struct task_struct *task;
 };
 
-/* Overflow handling mechanisms */
-#define DS_O_SIGNAL	1 /* send overflow signal */
-#define DS_O_WRAP	2 /* wrap around */
-
-extern int ds_allocate(void **, size_t);
-extern int ds_free(void **);
-extern int ds_get_bts_size(void *);
-extern int ds_get_bts_end(void *);
-extern int ds_get_bts_index(void *);
-extern int ds_set_overflow(void *, int);
-extern int ds_get_overflow(void *);
-extern int ds_clear(void *);
-extern int ds_read_bts(void *, int, struct bts_struct *);
-extern int ds_write_bts(void *, const struct bts_struct *);
-extern unsigned long ds_debugctl_mask(void);
-extern void __cpuinit ds_init_intel(struct cpuinfo_x86 *c);
+/* called by exit_thread() to free leftover contexts */
+extern void ds_free(struct ds_context *context);
 
 #endif /* _ASM_X86_DS_H */
Index: linux-2.6-x86/include/asm-x86/ptrace.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ptrace.h	2008-02-18 09:17:22.%N +0100
+++ linux-2.6-x86/include/asm-x86/ptrace.h	2008-02-18 09:17:59.%N +0100
@@ -125,13 +125,41 @@
 #endif /* __KERNEL__ */
 #endif /* !__i386__ */
 
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
+	u64 qualifier;
+	union {
+		/* BTS_BRANCH */
+		struct {
+			u64 from_ip;
+			u64 to_ip;
+		} lbr;
+		/* BTS_TASK_ARRIVES or
+		   BTS_TASK_DEPARTS */
+		u64 jiffies;
+	} variant;
+};
+
 #ifdef __KERNEL__
 
-/* the DS BTS struct is used for ptrace as well */
-#include <asm/ds.h>
+#include <linux/init.h>
 
+struct cpuinfo_x86;
 struct task_struct;
 
+extern void __cpuinit ptrace_bts_init_intel(struct cpuinfo_x86 *);
 extern void ptrace_bts_take_timestamp(struct task_struct *, enum bts_qualifier);
 
 extern unsigned long profile_pc(struct pt_regs *regs);
Index: linux-2.6-x86/arch/x86/kernel/ptrace.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/ptrace.c	2008-02-18 09:16:37.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/ptrace.c	2008-02-18 09:17:59.%N +0100
@@ -544,43 +544,115 @@
 	return 0;
 }
 
-static int ptrace_bts_get_size(struct task_struct *child)
+
+/*
+ * The configuration for a particular BTS hardware implementation.
+ */
+struct bts_configuration {
+	/* the size of a BTS record in bytes; at most BTS_MAX_RECORD_SIZE */
+	unsigned char  sizeof_bts;
+	/* the size of a field in the BTS record in bytes */
+	unsigned char  sizeof_field;
+	/* a bitmask to enable/disable BTS in DEBUGCTL MSR */
+	unsigned long debugctl_mask;
+};
+static struct bts_configuration bts_cfg;
+
+#define BTS_MAX_RECORD_SIZE (8 * 3)
+
+
+/*
+ * Branch Trace Store (BTS) uses the following format. Different
+ * architectures vary in the size of those fields.
+ * - source linear address
+ * - destination linear address
+ * - flags
+ *
+ * Later architectures use 64bit pointers throughout, whereas earlier
+ * architectures use 32bit pointers in 32bit mode.
+ *
+ * We compute the base address for the first 8 fields based on:
+ * - the field size stored in the DS configuration
+ * - the relative field position
+ *
+ * In order to store additional information in the BTS buffer, we use
+ * a special source address to indicate that the record requires
+ * special interpretation.
+ *
+ * Netburst indicated via a bit in the flags field whether the branch
+ * was predicted; this is ignored.
+ */
+
+enum bts_field {
+	bts_from = 0,
+	bts_to,
+	bts_flags,
+
+	bts_escape = (unsigned long)-1,
+	bts_qual = bts_to,
+	bts_jiffies = bts_flags
+};
+
+static inline unsigned long bts_get(const char *base, enum bts_field field)
 {
-	if (!child->thread.ds_area_msr)
-		return -ENXIO;
+	base += (bts_cfg.sizeof_field * field);
+	return *(unsigned long *)base;
+}
 
-	return ds_get_bts_index((void *)child->thread.ds_area_msr);
+static inline void bts_set(char *base, enum bts_field field, unsigned long val)
+{
+	base += (bts_cfg.sizeof_field * field);;
+	(*(unsigned long *)base) = val;
 }
 
-static int ptrace_bts_read_record(struct task_struct *child,
-				  long index,
+/*
+ * Translate a BTS record from the raw format into the bts_struct format
+ *
+ * out (out): bts_struct interpretation
+ * raw: raw BTS record
+ */
+static void ptrace_bts_translate_record(struct bts_struct *out, const void *raw)
+{
+	memset(out, 0, sizeof(*out));
+	if (bts_get(raw, bts_from) == bts_escape) {
+		out->qualifier       = bts_get(raw, bts_qual);
+		out->variant.jiffies = bts_get(raw, bts_jiffies);
+	} else {
+		out->qualifier = BTS_BRANCH;
+		out->variant.lbr.from_ip = bts_get(raw, bts_from);
+		out->variant.lbr.to_ip   = bts_get(raw, bts_to);
+	}
+}
+
+static int ptrace_bts_read_record(struct task_struct *child, size_t index,
 				  struct bts_struct __user *out)
 {
 	struct bts_struct ret;
-	int retval;
-	int bts_end;
-	int bts_index;
+	const void *bts_record;
+	size_t bts_index, bts_end;
+	int error;
+
+	error = ds_get_bts_end(child, &bts_end);
+	if (error < 0)
+		return error;
 
-	if (!child->thread.ds_area_msr)
-		return -ENXIO;
-
-	if (index < 0)
-		return -EINVAL;
-
-	bts_end = ds_get_bts_end((void *)child->thread.ds_area_msr);
 	if (bts_end <= index)
 		return -EINVAL;
 
+	error = ds_get_bts_index(child, &bts_index);
+	if (error < 0)
+		return error;
+
 	/* translate the ptrace bts index into the ds bts index */
-	bts_index = ds_get_bts_index((void *)child->thread.ds_area_msr);
-	bts_index -= (index + 1);
-	if (bts_index < 0)
-		bts_index += bts_end;
-
-	retval = ds_read_bts((void *)child->thread.ds_area_msr,
-			     bts_index, &ret);
-	if (retval < 0)
-		return retval;
+	bts_index += bts_end - (index + 1);
+	if (bts_end <= bts_index)
+		bts_index -= bts_end;
+
+	error = ds_access_bts(child, bts_index, &bts_record);
+	if (error < 0)
+		return error;
+
+	ptrace_bts_translate_record(&ret, bts_record);
 
 	if (copy_to_user(out, &ret, sizeof(ret)))
 		return -EFAULT;
@@ -591,127 +663,74 @@
 static int ptrace_bts_write_record(struct task_struct *child,
 				   const struct bts_struct *in)
 {
-	int retval;
+	unsigned char bts_record[BTS_MAX_RECORD_SIZE];
 
-	if (!child->thread.ds_area_msr)
-		return -ENXIO;
+	BUG_ON(BTS_MAX_RECORD_SIZE < bts_cfg.sizeof_bts);
 
-	retval = ds_write_bts((void *)child->thread.ds_area_msr, in);
-	if (retval)
-		return retval;
+	memset(bts_record, 0, bts_cfg.sizeof_bts);
+	switch (in->qualifier) {
+	case BTS_INVALID:
+		break;
 
-	return sizeof(*in);
-}
+	case BTS_BRANCH:
+		bts_set(bts_record, bts_from, in->variant.lbr.from_ip);
+		bts_set(bts_record, bts_to,   in->variant.lbr.to_ip);
+		break;
 
-static int ptrace_bts_clear(struct task_struct *child)
-{
-	if (!child->thread.ds_area_msr)
-		return -ENXIO;
+	case BTS_TASK_ARRIVES:
+	case BTS_TASK_DEPARTS:
+		bts_set(bts_record, bts_from,    bts_escape);
+		bts_set(bts_record, bts_qual,    in->qualifier);
+		bts_set(bts_record, bts_jiffies, in->variant.jiffies);
+		break;
+
+	default:
+		return -EINVAL;
+	}
 
-	return ds_clear((void *)child->thread.ds_area_msr);
+	/* The writing task will be the switched-to task on a context
+	 * switch. It needs to write into the switched-from task's BTS
+	 * buffer. */
+	return ds_unchecked_write_bts(child, bts_record, bts_cfg.sizeof_bts);
 }
 
 static int ptrace_bts_drain(struct task_struct *child,
 			    long size,
 			    struct bts_struct __user *out)
 {
-	int end, i;
-	void *ds = (void *)child->thread.ds_area_msr;
-
-	if (!ds)
-		return -ENXIO;
-
-	end = ds_get_bts_index(ds);
-	if (end <= 0)
-		return end;
+	struct bts_struct ret;
+	const unsigned char *raw;
+	size_t end, i;
+	int error;
+
+	error = ds_get_bts_index(child, &end);
+	if (error < 0)
+		return error;
 
 	if (size < (end * sizeof(struct bts_struct)))
 		return -EIO;
 
-	for (i = 0; i < end; i++, out++) {
-		struct bts_struct ret;
-		int retval;
-
-		retval = ds_read_bts(ds, i, &ret);
-		if (retval < 0)
-			return retval;
+	error = ds_access_bts(child, 0, (const void **)&raw);
+	if (error < 0)
+		return error;
+
+	for (i = 0; i < end; i++, out++, raw += bts_cfg.sizeof_bts) {
+		ptrace_bts_translate_record(&ret, raw);
 
 		if (copy_to_user(out, &ret, sizeof(ret)))
 			return -EFAULT;
 	}
 
-	ds_clear(ds);
+	error = ds_clear_bts(child);
+	if (error < 0)
+		return error;
 
 	return end;
 }
 
-static int ptrace_bts_realloc(struct task_struct *child,
-			      int size, int reduce_size)
+static void ptrace_bts_ovfl(struct task_struct *child)
 {
-	unsigned long rlim, vm;
-	int ret, old_size;
-
-	if (size < 0)
-		return -EINVAL;
-
-	old_size = ds_get_bts_size((void *)child->thread.ds_area_msr);
-	if (old_size < 0)
-		return old_size;
-
-	ret = ds_free((void **)&child->thread.ds_area_msr);
-	if (ret < 0)
-		goto out;
-
-	size >>= PAGE_SHIFT;
-	old_size >>= PAGE_SHIFT;
-
-	current->mm->total_vm  -= old_size;
-	current->mm->locked_vm -= old_size;
-
-	if (size == 0)
-		goto out;
-
-	rlim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
-	vm = current->mm->total_vm  + size;
-	if (rlim < vm) {
-		ret = -ENOMEM;
-
-		if (!reduce_size)
-			goto out;
-
-		size = rlim - current->mm->total_vm;
-		if (size <= 0)
-			goto out;
-	}
-
-	rlim = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
-	vm = current->mm->locked_vm  + size;
-	if (rlim < vm) {
-		ret = -ENOMEM;
-
-		if (!reduce_size)
-			goto out;
-
-		size = rlim - current->mm->locked_vm;
-		if (size <= 0)
-			goto out;
-	}
-
-	ret = ds_allocate((void **)&child->thread.ds_area_msr,
-			  size << PAGE_SHIFT);
-	if (ret < 0)
-		goto out;
-
-	current->mm->total_vm  += size;
-	current->mm->locked_vm += size;
-
-out:
-	if (child->thread.ds_area_msr)
-		set_tsk_thread_flag(child, TIF_DS_AREA_MSR);
-	else
-		clear_tsk_thread_flag(child, TIF_DS_AREA_MSR);
-
-	return ret;
+	send_sig(child->thread.bts_ovfl_signal, child, 0);
 }
 
 static int ptrace_bts_config(struct task_struct *child,
@@ -719,54 +738,58 @@
 			     const struct ptrace_bts_config __user *ucfg)
 {
 	struct ptrace_bts_config cfg;
-	int bts_size, ret = 0;
-	void *ds;
+	int error = 0;
 
+	error = -EIO;
 	if (cfg_size < sizeof(cfg))
-		return -EIO;
+		goto errout;
 
+	error = -EFAULT;
 	if (copy_from_user(&cfg, ucfg, sizeof(cfg)))
-		return -EFAULT;
+		goto errout;
 
-	if ((int)cfg.size < 0)
-		return -EINVAL;
+	error = -EINVAL;
+	if ((cfg.flags & PTRACE_BTS_O_SIGNAL) &&
+	    !(cfg.flags & PTRACE_BTS_O_ALLOC))
+		goto errout;
+
+	if (cfg.flags & PTRACE_BTS_O_ALLOC) {
+		ds_ovfl_callback_t ovfl = 0;
+		unsigned int sig = 0;
+
+		/* we ignore the error in case we were not tracing child */
+		(void)ds_release_bts(child);
+
+		if (cfg.flags & PTRACE_BTS_O_SIGNAL) {
+			if (!cfg.signal)
+				goto errout;
 
-	bts_size = 0;
-	ds = (void *)child->thread.ds_area_msr;
-	if (ds) {
-		bts_size = ds_get_bts_size(ds);
-		if (bts_size < 0)
-			return bts_size;
-	}
-	cfg.size = PAGE_ALIGN(cfg.size);
-
-	if (bts_size != cfg.size) {
-		ret = ptrace_bts_realloc(child, cfg.size,
-					 cfg.flags & PTRACE_BTS_O_CUT_SIZE);
-		if (ret < 0)
+			sig  = cfg.signal;
+			ovfl = ptrace_bts_ovfl;
+		}
+
+		error = ds_request_bts(child, /* base = */ 0, cfg.size, ovfl);
+		if (error < 0)
 			goto errout;
 
-		ds = (void *)child->thread.ds_area_msr;
+		child->thread.bts_ovfl_signal = sig;
 	}
 
-	if (cfg.flags & PTRACE_BTS_O_SIGNAL)
-		ret = ds_set_overflow(ds, DS_O_SIGNAL);
-	else
-		ret = ds_set_overflow(ds, DS_O_WRAP);
-	if (ret < 0)
+	error = -EINVAL;
+	if (!child->thread.ds_ctx && cfg.flags)
 		goto errout;
 
 	if (cfg.flags & PTRACE_BTS_O_TRACE)
-		child->thread.debugctlmsr |= ds_debugctl_mask();
+		child->thread.debugctlmsr |= bts_cfg.debugctl_mask;
 	else
-		child->thread.debugctlmsr &= ~ds_debugctl_mask();
+		child->thread.debugctlmsr &= ~bts_cfg.debugctl_mask;
 
 	if (cfg.flags & PTRACE_BTS_O_SCHED)
 		set_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
 	else
 		clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
 
-	ret = sizeof(cfg);
+	error = sizeof(cfg);
 
 out:
 	if (child->thread.debugctlmsr)
@@ -774,10 +797,10 @@
 	else
 		clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
 
-	return ret;
+	return error;
 
 errout:
-	child->thread.debugctlmsr &= ~ds_debugctl_mask();
+	child->thread.debugctlmsr &= ~bts_cfg.debugctl_mask;
 	clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
 	goto out;
 }
@@ -786,29 +809,40 @@
 			     long cfg_size,
 			     struct ptrace_bts_config __user *ucfg)
 {
-	void *ds = (void *)child->thread.ds_area_msr;
 	struct ptrace_bts_config cfg;
+	size_t end;
+	const void *base, *max;
+	int error;
 
 	if (cfg_size < sizeof(cfg))
 		return -EIO;
 
-	memset(&cfg, 0, sizeof(cfg));
-
-	if (ds) {
-		cfg.size = ds_get_bts_size(ds);
+	error = ds_get_bts_end(child, &end);
+	if (error < 0)
+		return error;
+
+	error = ds_access_bts(child, /* index = */ 0, &base);
+	if (error < 0)
+		return error;
+
+	error = ds_access_bts(child, /* index = */ end, &max);
+	if (error < 0)
+		return error;
 
-		if (ds_get_overflow(ds) == DS_O_SIGNAL)
-			cfg.flags |= PTRACE_BTS_O_SIGNAL;
+	memset(&cfg, 0, sizeof(cfg));
+	cfg.size = (max - base);
+	cfg.signal = child->thread.bts_ovfl_signal;
+	cfg.bts_size = sizeof(struct bts_struct);
 
-		if (test_tsk_thread_flag(child, TIF_DEBUGCTLMSR) &&
-		    child->thread.debugctlmsr & ds_debugctl_mask())
-			cfg.flags |= PTRACE_BTS_O_TRACE;
+	if (cfg.signal)
+		cfg.flags |= PTRACE_BTS_O_SIGNAL;
 
-		if (test_tsk_thread_flag(child, TIF_BTS_TRACE_TS))
-			cfg.flags |= PTRACE_BTS_O_SCHED;
-	}
+	if (test_tsk_thread_flag(child, TIF_DEBUGCTLMSR) &&
+	    child->thread.debugctlmsr & bts_cfg.debugctl_mask)
+		cfg.flags |= PTRACE_BTS_O_TRACE;
 
-	cfg.bts_size = sizeof(struct bts_struct);
+	if (test_tsk_thread_flag(child, TIF_BTS_TRACE_TS))
+		cfg.flags |= PTRACE_BTS_O_SCHED;
 
 	if (copy_to_user(ucfg, &cfg, sizeof(cfg)))
 		return -EFAULT;
@@ -827,6 +861,64 @@
 	ptrace_bts_write_record(tsk, &rec);
 }
 
+static const struct bts_configuration bts_cfg_netburst = {
+	.sizeof_bts    = sizeof(long) * 3,
+	.sizeof_field  = sizeof(long),
+	.debugctl_mask = (1<<2)|(1<<3)|(1<<5)
+};
+
+static const struct bts_configuration bts_cfg_pentium_m = {
+	.sizeof_bts    = sizeof(long) * 3,
+	.sizeof_field  = sizeof(long),
+	.debugctl_mask = (1<<6)|(1<<7)
+};
+
+static const struct bts_configuration bts_cfg_core2 = {
+	.sizeof_bts    = 8 * 3,
+	.sizeof_field  = 8,
+	.debugctl_mask = (1<<6)|(1<<7)|(1<<9)
+};
+
+static inline void bts_configure(const struct bts_configuration *cfg)
+{
+	bts_cfg = *cfg;
+}
+
+void __cpuinit ptrace_bts_init_intel(struct cpuinfo_x86 *c)
+{
+	switch (c->x86) {
+	case 0x6:
+		switch (c->x86_model) {
+		case 0xD:
+		case 0xE: /* Pentium M */
+			bts_configure(&bts_cfg_pentium_m);
+			break;
+		case 0xF: /* Core2 */
+			bts_configure(&bts_cfg_core2);
+			break;
+		default:
+			/* sorry, don't know about them */
+			break;
+		}
+		break;
+	case 0xF:
+		switch (c->x86_model) {
+		case 0x0:
+		case 0x1:
+		case 0x2: /* Netburst */
+			bts_configure(&bts_cfg_netburst);
+			break;
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
+
 /*
  * Called by kernel/ptrace.c when detaching..
  *
@@ -838,13 +930,13 @@
 #ifdef TIF_SYSCALL_EMU
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 #endif
-	if (child->thread.ds_area_msr) {
-		ptrace_bts_realloc(child, 0, 0);
-		child->thread.debugctlmsr &= ~ds_debugctl_mask();
-		if (!child->thread.debugctlmsr)
-			clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
-		clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
-	}
+	(void)ds_release_bts(child);
+
+	child->thread.debugctlmsr &= ~bts_cfg.debugctl_mask;
+	if (!child->thread.debugctlmsr)
+		clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
+
+	clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
 }
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
@@ -972,7 +1064,7 @@
 		break;
 
 	case PTRACE_BTS_SIZE:
-		ret = ptrace_bts_get_size(child);
+		ret = ds_get_bts_index(child, /* pos = */ 0);
 		break;
 
 	case PTRACE_BTS_GET:
@@ -981,7 +1073,7 @@
 		break;
 
 	case PTRACE_BTS_CLEAR:
-		ret = ptrace_bts_clear(child);
+		ret = ds_clear_bts(child);
 		break;
 
 	case PTRACE_BTS_DRAIN:
Index: linux-2.6-x86/arch/x86/kernel/ds.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/ds.c	2008-02-18 09:16:37.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/ds.c	2008-02-18 09:28:46.%N +0100
@@ -2,19 +2,22 @@
  * Debug Store support
  *
  * This provides a low-level interface to the hardware's Debug Store
- * feature that is used for last branch recording (LBR) and
+ * feature that is used for branch trace store (BTS) and
  * precise-event based sampling (PEBS).
  *
- * Different architectures use a different DS layout/pointer size.
- * The below functions therefore work on a void*.
+ * It manages:
+ * - per-thread and per-cpu allocation of BTS and PEBS
+ * - buffer memory allocation (optional)
+ * - buffer overflow handling
+ * - buffer access
+ *
+ * It assumes:
+ * - get_task_struct on all parameter tasks
+ * - current is allowed to trace parameter tasks
  *
  *
- * Since there is no user for PEBS, yet, only LBR (or branch
- * trace store, BTS) is supported.
- *
- *
- * Copyright (C) 2007 Intel Corporation.
- * Markus Metzger <markus.t.metzger@intel.com>, Dec 2007
+ * Copyright (C) 2007-2008 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, 2007-2008
  */
 
 #include <asm/ds.h>
@@ -22,6 +25,22 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
+
+
+/*
+ * The configuration for a particular DS hardware implementation.
+ */
+struct ds_configuration {
+	/* the size of the DS structure in bytes */
+	unsigned char  sizeof_ds;
+	/* the size of one pointer-typed field in the DS structure in bytes;
+	   this covers the first 8 fields related to buffer management. */
+	unsigned char  sizeof_field;
+	/* the size of a BTS/PEBS record in bytes */
+	unsigned char  sizeof_rec[2];
+};
+static struct ds_configuration ds_cfg;
 
 
 /*
@@ -44,378 +63,747 @@
  *   (interrupt occurs when write pointer passes interrupt pointer)
  * - value to which counter is reset following counter overflow
  *
- * On later architectures, the last branch recording hardware uses
- * 64bit pointers even in 32bit mode.
+ * Later architectures use 64bit pointers throughout, whereas earlier
+ * architectures use 32bit pointers in 32bit mode.
  *
  *
- * Branch Trace Store (BTS) records store information about control
- * flow changes. They at least provide the following information:
- * - source linear address
- * - destination linear address
+ * We compute the base address for the first 8 fields based on:
+ * - the field size stored in the DS configuration
+ * - the relative field position
+ * - an offset giving the start of the respective region
  *
- * Netburst supported a predicated bit that had been dropped in later
- * architectures. We do not suppor it.
+ * This offset is further used to index various arrays holding
+ * information for BTS and PEBS at the respective index.
  *
- *
- * In order to abstract from the actual DS and BTS layout, we describe
- * the access to the relevant fields.
- * Thanks to Andi Kleen for proposing this design.
- *
- * The implementation, however, is not as general as it might seem. In
- * order to stay somewhat simple and efficient, we assume an
- * underlying unsigned type (mostly a pointer type) and we expect the
- * field to be at least as big as that type.
+ * On later 32bit processors, we only access the lower 32bit of the
+ * 64bit pointer fields. The upper halves will be zeroed out.
  */
 
-/*
- * A special from_ip address to indicate that the BTS record is an
- * info record that needs to be interpreted or skipped.
- */
-#define BTS_ESCAPE_ADDRESS (-1)
+enum ds_field {
+	ds_buffer_base = 0,
+	ds_index,
+	ds_absolute_maximum,
+	ds_interrupt_threshold,
+};
 
-/*
- * A field access descriptor
- */
-struct access_desc {
-	unsigned char offset;
-	unsigned char size;
+enum ds_qualifier {
+	ds_bts  = 0,
+	ds_pebs
 };
 
+static inline unsigned long ds_get(const unsigned char *base,
+				   enum ds_qualifier qual, enum ds_field field)
+{
+	base += (ds_cfg.sizeof_field * (field + (4 * qual)));
+	return *(unsigned long *)base;
+}
+
+static inline void ds_set(unsigned char *base, enum ds_qualifier qual,
+			  enum ds_field field, unsigned long value)
+{
+	base += (ds_cfg.sizeof_field * (field + (4 * qual)));
+	(*(unsigned long *)base) = value;
+}
+
+
 /*
- * The configuration for a particular DS/BTS hardware implementation.
+ * Locking is done only for allocating BTS or PEBS resources and for
+ * guarding context and buffer memory allocation.
+ *
+ * Most functions require the current task to own the ds context part
+ * they are going to access. All the locking is done when validating
+ * access to the context.
  */
-struct ds_configuration {
-	/* the DS configuration */
-	unsigned char  sizeof_ds;
-	struct access_desc bts_buffer_base;
-	struct access_desc bts_index;
-	struct access_desc bts_absolute_maximum;
-	struct access_desc bts_interrupt_threshold;
-	/* the BTS configuration */
-	unsigned char  sizeof_bts;
-	struct access_desc from_ip;
-	struct access_desc to_ip;
-	/* BTS variants used to store additional information like
-	   timestamps */
-	struct access_desc info_type;
-	struct access_desc info_data;
-	unsigned long debugctl_mask;
-};
+static spinlock_t ds_lock;
 
 /*
- * The global configuration used by the below accessor functions
+ * Validate that the current task is allowed to access the BTS/PEBS
+ * buffer of the parameter task.
+ *
+ * Returns 0, if access is granted; -Eerrno, otherwise.
  */
-static struct ds_configuration ds_cfg;
+static inline int ds_validate_access(struct ds_context *context,
+				     enum ds_qualifier qual)
+{
+	if (!context)
+		return -EPERM;
+
+	if (context->owner[qual] == current)
+		return 0;
+
+	return -EPERM;
+}
+
 
 /*
- * Accessor functions for some DS and BTS fields using the above
- * global ptrace_bts_cfg.
+ * We either support (system-wide) per-cpu or per-thread allocation.
+ * We distinguish the two based on the task_struct pointer, where a
+ * NULL pointer indicates per-cpu allocation for the current cpu.
+ *
+ * Allocations are use-counted. As soon as resources are allocated,
+ * further allocations must be of the same type (per-cpu or
+ * per-thread). We model this by counting allocations (i.e. the number
+ * of tracers of a certain type) for one type negatively:
+ *   =0  no tracers
+ *   >0  number of per-thread tracers
+ *   <0  number of per-cpu tracers
+ *
+ * The below functions to get and put tracers and to check the
+ * allocation type require the ds_lock to be held by the caller.
+ *
+ * Tracers essentially gives the number of ds contexts for a certain
+ * type of allocation.
  */
-static inline unsigned long get_bts_buffer_base(char *base)
+static long tracers;
+
+static inline void get_tracer(struct task_struct *task)
 {
-	return *(unsigned long *)(base + ds_cfg.bts_buffer_base.offset);
+	tracers += (task ? 1 : -1);
 }
-static inline void set_bts_buffer_base(char *base, unsigned long value)
+
+static inline void put_tracer(struct task_struct *task)
 {
-	(*(unsigned long *)(base + ds_cfg.bts_buffer_base.offset)) = value;
+	tracers -= (task ? 1 : -1);
 }
-static inline unsigned long get_bts_index(char *base)
+
+static inline int check_tracer(struct task_struct *task)
 {
-	return *(unsigned long *)(base + ds_cfg.bts_index.offset);
+	return (task ? (tracers >= 0) : (tracers <= 0));
 }
-static inline void set_bts_index(char *base, unsigned long value)
+
+
+/*
+ * The DS context is either attached to a thread or to a cpu:
+ * - in the former case, the thread_struct contains a pointer to the
+ *   attached context.
+ * - in the latter case, we use a static array of per-cpu context
+ *   pointers.
+ *
+ * Contexts are use-counted. They are allocated on first access and
+ * deallocated when the last user puts the context.
+ *
+ * We distinguish between an allocating and a non-allocating get of a
+ * context:
+ * - the allocating get is used for requesting BTS/PEBS resources. It
+ *   requires the caller to hold the global ds_lock.
+ * - the non-allocating get is used for all other cases. A
+ *   non-existing context indicates an error. It acquires and releases
+ *   the ds_lock itself for obtaining the context.
+ *
+ * A context and its DS configuration are allocated and deallocated
+ * together. A context always has a DS configuration of the
+ * appropriate size.
+ */
+static DEFINE_PER_CPU(struct ds_context *, system_context);
+
+#define this_system_context per_cpu(system_context, smp_processor_id())
+
+/*
+ * Returns the pointer to the parameter task's context or to the
+ * system-wide context, if task is NULL.
+ *
+ * Increases the use count of the returned context, if not NULL.
+ */
+static inline struct ds_context *ds_get_context(struct task_struct *task)
 {
-	(*(unsigned long *)(base + ds_cfg.bts_index.offset)) = value;
+	struct ds_context *context;
+
+	spin_lock(&ds_lock);
+
+	context = (task ? task->thread.ds_ctx : this_system_context);
+	if (context)
+		context->count++;
+
+	spin_unlock(&ds_lock);
+
+	return context;
 }
-static inline unsigned long get_bts_absolute_maximum(char *base)
+
+/*
+ * Same as ds_get_context, but allocates the context and it's DS
+ * structure, if necessary; returns NULL; if out of memory.
+ *
+ * pre: requires ds_lock to be held
+ */
+static inline struct ds_context *ds_alloc_context(struct task_struct *task)
 {
-	return *(unsigned long *)(base + ds_cfg.bts_absolute_maximum.offset);
+	struct ds_context **p_context =
+		(task ? &task->thread.ds_ctx : &this_system_context);
+	struct ds_context *context = *p_context;
+
+	if (!context) {
+		context = kzalloc(sizeof(*context), GFP_KERNEL);
+
+		if (!context)
+			return 0;
+
+		context->ds = kzalloc(ds_cfg.sizeof_ds, GFP_KERNEL);
+		if (!context->ds) {
+			kfree(context);
+			return 0;
+		}
+
+		*p_context = context;
+
+		context->this = p_context;
+		context->task = task;
+
+		if (task)
+			set_tsk_thread_flag(task, TIF_DS_AREA_MSR);
+
+		if (!task || (task == current))
+			wrmsr(MSR_IA32_DS_AREA, (unsigned long)context->ds, 0);
+
+		get_tracer(task);
+	}
+
+	context->count++;
+
+	return context;
 }
-static inline void set_bts_absolute_maximum(char *base, unsigned long value)
+
+/*
+ * Decreases the use count of the parameter context, if not NULL.
+ * Deallocates the context, if the use count reaches zero.
+ */
+static inline void ds_put_context(struct ds_context *context)
 {
-	(*(unsigned long *)(base + ds_cfg.bts_absolute_maximum.offset)) = value;
+	if (!context)
+		return;
+
+	spin_lock(&ds_lock);
+
+	if (--context->count)
+		goto out;
+
+	*(context->this) = 0;
+
+	if (context->task)
+		clear_tsk_thread_flag(context->task, TIF_DS_AREA_MSR);
+
+	if (!context->task || (context->task == current))
+		wrmsrl(MSR_IA32_DS_AREA, 0);
+
+	put_tracer(context->task);
+
+	/* free any leftover buffers from tracers that did not
+	 * deallocate them properly. */
+	kfree(context->buffer[ds_bts]);
+	kfree(context->buffer[ds_pebs]);
+	kfree(context->ds);
+	kfree(context);
+ out:
+	spin_unlock(&ds_lock);
 }
-static inline unsigned long get_bts_interrupt_threshold(char *base)
+
+
+/*
+ * Handle a buffer overflow
+ *
+ * task: the task whose buffers are overflowing;
+ *       NULL for a buffer overflow on the current cpu
+ * context: the ds context
+ * qual: the buffer type
+ */
+static void ds_overflow(struct task_struct *task, struct ds_context *context,
+			enum ds_qualifier qual)
 {
-	return *(unsigned long *)(base + ds_cfg.bts_interrupt_threshold.offset);
+	if (!context)
+		return;
+
+	if (context->callback[qual])
+		(*context->callback[qual])(task);
+
+	/* todo: do some more overflow handling */
 }
-static inline void set_bts_interrupt_threshold(char *base, unsigned long value)
+
+
+/*
+ * Allocate a non-pageable buffer of the parameter size.
+ * Checks the memory and the locked memory rlimit.
+ *
+ * Returns the buffer, if successful;
+ *         NULL, if out of memory or rlimit exceeded.
+ *
+ * size: the requested buffer size in bytes
+ * pages (out): if not NULL, contains the number of pages reserved
+ */
+static inline void *ds_allocate_buffer(size_t size, unsigned int *pages)
 {
-	(*(unsigned long *)(base + ds_cfg.bts_interrupt_threshold.offset)) = value;
+	unsigned long rlim, vm, pgsz;
+	void *buffer;
+
+	pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
+
+	rlim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
+	vm   = current->mm->total_vm  + pgsz;
+	if (rlim < vm)
+		return 0;
+
+	rlim = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
+	vm   = current->mm->locked_vm  + pgsz;
+	if (rlim < vm)
+		return 0;
+
+	buffer = kzalloc(size, GFP_KERNEL);
+	if (!buffer)
+		return 0;
+
+	current->mm->total_vm  += pgsz;
+	current->mm->locked_vm += pgsz;
+
+	if (pages)
+		*pages = pgsz;
+
+	return buffer;
 }
-static inline unsigned long get_from_ip(char *base)
+
+static int ds_request(struct task_struct *task, void *base, size_t size,
+		      ds_ovfl_callback_t ovfl, enum ds_qualifier qual)
 {
-	return *(unsigned long *)(base + ds_cfg.from_ip.offset);
+	struct ds_context *context;
+	unsigned long buffer, adj;
+	const unsigned long alignment = (1 << 3);
+	int error = 0;
+
+	if (!ds_cfg.sizeof_ds)
+		return -EOPNOTSUPP;
+
+	/* we require some space to do alignment adjustments below */
+	if (size < (alignment + ds_cfg.sizeof_rec[qual]))
+		return -EINVAL;
+
+	/* buffer overflow notification is not yet implemented */
+	if (ovfl)
+		return -EOPNOTSUPP;
+
+
+	spin_lock(&ds_lock);
+
+	if (!check_tracer(task))
+		return -EPERM;
+
+	error = -ENOMEM;
+	context = ds_alloc_context(task);
+	if (!context)
+		goto out_unlock;
+
+	error = -EALREADY;
+	if (context->owner[qual] == current)
+		goto out_unlock;
+	error = -EPERM;
+	if (context->owner[qual] != 0)
+		goto out_unlock;
+	context->owner[qual] = current;
+
+	spin_unlock(&ds_lock);
+
+
+	error = -ENOMEM;
+	if (!base) {
+		base = ds_allocate_buffer(size, &context->pages[qual]);
+		if (!base)
+			goto out_release;
+
+		context->buffer[qual]   = base;
+	}
+	error = 0;
+
+	context->callback[qual] = ovfl;
+
+	/* adjust the buffer address and size to meet alignment
+	 * constraints:
+	 * - buffer is double-word aligned
+	 * - size is multiple of record size
+	 *
+	 * We checked the size at the very beginning; we have enough
+	 * space to do the adjustment.
+	 */
+	buffer = (unsigned long)base;
+
+	adj = ALIGN(buffer, alignment) - buffer;
+	buffer += adj;
+	size   -= adj;
+
+	size /= ds_cfg.sizeof_rec[qual];
+	size *= ds_cfg.sizeof_rec[qual];
+
+	ds_set(context->ds, qual, ds_buffer_base, buffer);
+	ds_set(context->ds, qual, ds_index, buffer);
+	ds_set(context->ds, qual, ds_absolute_maximum, buffer + size);
+
+	if (ovfl) {
+		/* todo: select a suitable interrupt threshold */
+	} else
+		ds_set(context->ds, qual,
+		       ds_interrupt_threshold, buffer + size + 1);
+
+	/* we keep the context until ds_release */
+	return error;
+
+ out_release:
+	context->owner[qual] = 0;
+	ds_put_context(context);
+	return error;
+
+ out_unlock:
+	spin_unlock(&ds_lock);
+	ds_put_context(context);
+	return error;
 }
-static inline void set_from_ip(char *base, unsigned long value)
+
+int ds_request_bts(struct task_struct *task, void *base, size_t size,
+		   ds_ovfl_callback_t ovfl)
 {
-	(*(unsigned long *)(base + ds_cfg.from_ip.offset)) = value;
+	return ds_request(task, base, size, ovfl, ds_bts);
 }
-static inline unsigned long get_to_ip(char *base)
+
+int ds_request_pebs(struct task_struct *task, void *base, size_t size,
+		    ds_ovfl_callback_t ovfl)
 {
-	return *(unsigned long *)(base + ds_cfg.to_ip.offset);
+	return ds_request(task, base, size, ovfl, ds_pebs);
 }
-static inline void set_to_ip(char *base, unsigned long value)
+
+static int ds_release(struct task_struct *task, enum ds_qualifier qual)
 {
-	(*(unsigned long *)(base + ds_cfg.to_ip.offset)) = value;
+	struct ds_context *context;
+	int error;
+
+	context = ds_get_context(task);
+	error = ds_validate_access(context, qual);
+	if (error < 0)
+		goto out;
+
+	kfree(context->buffer[qual]);
+	context->buffer[qual] = 0;
+
+	current->mm->total_vm  -= context->pages[qual];
+	current->mm->locked_vm -= context->pages[qual];
+	context->pages[qual] = 0;
+	context->owner[qual] = 0;
+
+	/*
+	 * we put the context twice:
+	 *   once for the ds_get_context
+	 *   once for the corresponding ds_request
+	 */
+	ds_put_context(context);
+ out:
+	ds_put_context(context);
+	return error;
 }
-static inline unsigned char get_info_type(char *base)
+
+int ds_release_bts(struct task_struct *task)
 {
-	return *(unsigned char *)(base + ds_cfg.info_type.offset);
+	return ds_release(task, ds_bts);
 }
-static inline void set_info_type(char *base, unsigned char value)
+
+int ds_release_pebs(struct task_struct *task)
 {
-	(*(unsigned char *)(base + ds_cfg.info_type.offset)) = value;
+	return ds_release(task, ds_pebs);
 }
-static inline unsigned long get_info_data(char *base)
+
+static int ds_get_index(struct task_struct *task, size_t *pos,
+			enum ds_qualifier qual)
 {
-	return *(unsigned long *)(base + ds_cfg.info_data.offset);
+	struct ds_context *context;
+	unsigned long base, index;
+	int error;
+
+	context = ds_get_context(task);
+	error = ds_validate_access(context, qual);
+	if (error < 0)
+		goto out;
+
+	base  = ds_get(context->ds, qual, ds_buffer_base);
+	index = ds_get(context->ds, qual, ds_index);
+
+	error = ((index - base) / ds_cfg.sizeof_rec[qual]);
+	if (pos)
+		*pos = error;
+ out:
+	ds_put_context(context);
+	return error;
 }
-static inline void set_info_data(char *base, unsigned long value)
+
+int ds_get_bts_index(struct task_struct *task, size_t *pos)
 {
-	(*(unsigned long *)(base + ds_cfg.info_data.offset)) = value;
+	return ds_get_index(task, pos, ds_bts);
 }
 
+int ds_get_pebs_index(struct task_struct *task, size_t *pos)
+{
+	return ds_get_index(task, pos, ds_pebs);
+}
 
-int ds_allocate(void **dsp, size_t bts_size_in_bytes)
+static int ds_get_end(struct task_struct *task, size_t *pos,
+		      enum ds_qualifier qual)
 {
-	size_t bts_size_in_records;
-	unsigned long bts;
-	void *ds;
+	struct ds_context *context;
+	unsigned long base, end;
+	int error;
 
-	if (!ds_cfg.sizeof_ds || !ds_cfg.sizeof_bts)
-		return -EOPNOTSUPP;
+	context = ds_get_context(task);
+	error = ds_validate_access(context, qual);
+	if (error < 0)
+		goto out;
 
-	if (bts_size_in_bytes < 0)
-		return -EINVAL;
+	base = ds_get(context->ds, qual, ds_buffer_base);
+	end  = ds_get(context->ds, qual, ds_absolute_maximum);
 
-	bts_size_in_records =
-		bts_size_in_bytes / ds_cfg.sizeof_bts;
-	bts_size_in_bytes =
-		bts_size_in_records * ds_cfg.sizeof_bts;
+	error = ((end - base) / ds_cfg.sizeof_rec[qual]);
+	if (pos)
+		*pos = error;
+ out:
+	ds_put_context(context);
+	return error;
+}
 
-	if (bts_size_in_bytes <= 0)
-		return -EINVAL;
+int ds_get_bts_end(struct task_struct *task, size_t *pos)
+{
+	return ds_get_end(task, pos, ds_bts);
+}
+
+int ds_get_pebs_end(struct task_struct *task, size_t *pos)
+{
+	return ds_get_end(task, pos, ds_pebs);
+}
 
-	bts = (unsigned long)kzalloc(bts_size_in_bytes, GFP_KERNEL);
+static int ds_access(struct task_struct *task, size_t index,
+		     const void **record, enum ds_qualifier qual)
+{
+	struct ds_context *context;
+	unsigned long base, idx;
+	int error;
 
-	if (!bts)
-		return -ENOMEM;
+	if (!record)
+		return -EINVAL;
 
-	ds = kzalloc(ds_cfg.sizeof_ds, GFP_KERNEL);
+	context = ds_get_context(task);
+	error = ds_validate_access(context, qual);
+	if (error < 0)
+		goto out;
 
-	if (!ds) {
-		kfree((void *)bts);
-		return -ENOMEM;
-	}
+	base = ds_get(context->ds, qual, ds_buffer_base);
+	idx = base + (index * ds_cfg.sizeof_rec[qual]);
 
-	set_bts_buffer_base(ds, bts);
-	set_bts_index(ds, bts);
-	set_bts_absolute_maximum(ds, bts + bts_size_in_bytes);
-	set_bts_interrupt_threshold(ds, bts + bts_size_in_bytes + 1);
+	error = -EINVAL;
+	if (idx > ds_get(context->ds, qual, ds_absolute_maximum))
+		goto out;
 
-	*dsp = ds;
-	return 0;
+	*record = (const void *)idx;
+	error = ds_cfg.sizeof_rec[qual];
+ out:
+	ds_put_context(context);
+	return error;
 }
 
-int ds_free(void **dsp)
+int ds_access_bts(struct task_struct *task, size_t index, const void **record)
 {
-	if (*dsp)
-		kfree((void *)get_bts_buffer_base(*dsp));
-	kfree(*dsp);
-	*dsp = NULL;
-
-	return 0;
+	return ds_access(task, index, record, ds_bts);
 }
 
-int ds_get_bts_size(void *ds)
+int ds_access_pebs(struct task_struct *task, size_t index, const void **record)
 {
-	int size_in_bytes;
-
-	if (!ds_cfg.sizeof_ds || !ds_cfg.sizeof_bts)
-		return -EOPNOTSUPP;
-
-	if (!ds)
-		return 0;
-
-	size_in_bytes =
-		get_bts_absolute_maximum(ds) -
-		get_bts_buffer_base(ds);
-	return size_in_bytes;
+	return ds_access(task, index, record, ds_pebs);
 }
 
-int ds_get_bts_end(void *ds)
+static int ds_write(struct task_struct *task, const void *record, size_t size,
+		    enum ds_qualifier qual, int force)
 {
-	int size_in_bytes = ds_get_bts_size(ds);
+	struct ds_context *context;
+	int error;
 
-	if (size_in_bytes <= 0)
-		return size_in_bytes;
+	if (!record)
+		return -EINVAL;
 
-	return size_in_bytes / ds_cfg.sizeof_bts;
-}
+	error = -EPERM;
+	context = ds_get_context(task);
+	if (!context)
+		goto out;
+
+	if (!force) {
+		error = ds_validate_access(context, qual);
+		if (error < 0)
+			goto out;
+	}
 
-int ds_get_bts_index(void *ds)
-{
-	int index_offset_in_bytes;
+	error = 0;
+	while (size) {
+		unsigned long base, index, end, write_end, int_th;
+		unsigned long write_size, adj_write_size;
+
+		/*
+		 * write as much as possible without producing an
+		 * overflow interrupt.
+		 *
+		 * interrupt_threshold must either be
+		 * - bigger than absolute_maximum or
+		 * - point to a record between buffer_base and absolute_maximum
+		 *
+		 * index points to a valid record.
+		 */
+		base   = ds_get(context->ds, qual, ds_buffer_base);
+		index  = ds_get(context->ds, qual, ds_index);
+		end    = ds_get(context->ds, qual, ds_absolute_maximum);
+		int_th = ds_get(context->ds, qual, ds_interrupt_threshold);
+
+		write_end = min(end, int_th);
+
+		/* if we are already beyond the interrupt threshold,
+		 * we fill the entire buffer */
+		if (write_end <= index)
+			write_end = end;
+
+		if (write_end <= index)
+			goto out;
+
+		write_size = min((unsigned long) size, write_end - index);
+		memcpy((void *)index, record, write_size);
+
+		record = (const char *)record + write_size;
+		size  -= write_size;
+		error += write_size;
+
+		adj_write_size = write_size / ds_cfg.sizeof_rec[qual];
+		adj_write_size *= ds_cfg.sizeof_rec[qual];
+
+		/* zero out trailing bytes */
+		memset((char *)index + write_size, 0,
+		       adj_write_size - write_size);
+		index += adj_write_size;
+
+		if (index >= end)
+			index = base;
+		ds_set(context->ds, qual, ds_index, index);
 
-	if (!ds_cfg.sizeof_ds || !ds_cfg.sizeof_bts)
-		return -EOPNOTSUPP;
+		if (index >= int_th)
+			ds_overflow(task, context, qual);
+	}
 
-	index_offset_in_bytes =
-		get_bts_index(ds) -
-		get_bts_buffer_base(ds);
+ out:
+	ds_put_context(context);
+	return error;
+}
 
-	return index_offset_in_bytes / ds_cfg.sizeof_bts;
+int ds_write_bts(struct task_struct *task, const void *record, size_t size)
+{
+	return ds_write(task, record, size, ds_bts, /* force = */ 0);
 }
 
-int ds_set_overflow(void *ds, int method)
+int ds_write_pebs(struct task_struct *task, const void *record, size_t size)
 {
-	switch (method) {
-	case DS_O_SIGNAL:
-		return -EOPNOTSUPP;
-	case DS_O_WRAP:
-		return 0;
-	default:
-		return -EINVAL;
-	}
+	return ds_write(task, record, size, ds_pebs, /* force = */ 0);
 }
 
-int ds_get_overflow(void *ds)
+int ds_unchecked_write_bts(struct task_struct *task,
+			   const void *record, size_t size)
 {
-	return DS_O_WRAP;
+	return ds_write(task, record, size, ds_bts, /* force = */ 1);
 }
 
-int ds_clear(void *ds)
+int ds_unchecked_write_pebs(struct task_struct *task,
+			    const void *record, size_t size)
 {
-	int bts_size = ds_get_bts_size(ds);
-	unsigned long bts_base;
+	return ds_write(task, record, size, ds_pebs, /* force = */ 1);
+}
 
-	if (bts_size <= 0)
-		return bts_size;
+static int ds_reset_or_clear(struct task_struct *task,
+			     enum ds_qualifier qual, int clear)
+{
+	struct ds_context *context;
+	unsigned long base, end;
+	int error;
 
-	bts_base = get_bts_buffer_base(ds);
-	memset((void *)bts_base, 0, bts_size);
+	context = ds_get_context(task);
+	error = ds_validate_access(context, qual);
+	if (error < 0)
+		goto out;
 
-	set_bts_index(ds, bts_base);
-	return 0;
-}
+	base = ds_get(context->ds, qual, ds_buffer_base);
+	end  = ds_get(context->ds, qual, ds_absolute_maximum);
 
-int ds_read_bts(void *ds, int index, struct bts_struct *out)
-{
-	void *bts;
+	if (clear)
+		memset((void *)base, 0, end - base);
 
-	if (!ds_cfg.sizeof_ds || !ds_cfg.sizeof_bts)
-		return -EOPNOTSUPP;
+	ds_set(context->ds, qual, ds_index, base);
 
-	if (index < 0)
-		return -EINVAL;
+	error = 0;
+ out:
+	ds_put_context(context);
+	return error;
+}
 
-	if (index >= ds_get_bts_size(ds))
-		return -EINVAL;
+int ds_reset_bts(struct task_struct *task)
+{
+	return ds_reset_or_clear(task, ds_bts, /* clear = */ 0);
+}
 
-	bts = (void *)(get_bts_buffer_base(ds) + (index * ds_cfg.sizeof_bts));
+int ds_reset_pebs(struct task_struct *task)
+{
+	return ds_reset_or_clear(task, ds_pebs, /* clear = */ 0);
+}
 
-	memset(out, 0, sizeof(*out));
-	if (get_from_ip(bts) == BTS_ESCAPE_ADDRESS) {
-		out->qualifier       = get_info_type(bts);
-		out->variant.jiffies = get_info_data(bts);
-	} else {
-		out->qualifier = BTS_BRANCH;
-		out->variant.lbr.from_ip = get_from_ip(bts);
-		out->variant.lbr.to_ip   = get_to_ip(bts);
-	}
+int ds_clear_bts(struct task_struct *task)
+{
+	return ds_reset_or_clear(task, ds_bts, /* clear = */ 1);
+}
 
-	return sizeof(*out);;
+int ds_clear_pebs(struct task_struct *task)
+{
+	return ds_reset_or_clear(task, ds_pebs, /* clear = */ 1);
 }
 
-int ds_write_bts(void *ds, const struct bts_struct *in)
+int ds_get_pebs_reset(struct task_struct *task, u64 *value)
 {
-	unsigned long bts;
+	struct ds_context *context;
+	int error;
 
-	if (!ds_cfg.sizeof_ds || !ds_cfg.sizeof_bts)
-		return -EOPNOTSUPP;
+	if (!value)
+		return -EINVAL;
 
-	if (ds_get_bts_size(ds) <= 0)
-		return -ENXIO;
+	context = ds_get_context(task);
+	error = ds_validate_access(context, ds_pebs);
+	if (error < 0)
+		goto out;
 
-	bts = get_bts_index(ds);
+	*value = *(u64 *)(context->ds + (ds_cfg.sizeof_field * 8));
 
-	memset((void *)bts, 0, ds_cfg.sizeof_bts);
-	switch (in->qualifier) {
-	case BTS_INVALID:
-		break;
+	error = 0;
+ out:
+	ds_put_context(context);
+	return error;
+}
 
-	case BTS_BRANCH:
-		set_from_ip((void *)bts, in->variant.lbr.from_ip);
-		set_to_ip((void *)bts, in->variant.lbr.to_ip);
-		break;
+int ds_set_pebs_reset(struct task_struct *task, u64 value)
+{
+	struct ds_context *context;
+	int error;
 
-	case BTS_TASK_ARRIVES:
-	case BTS_TASK_DEPARTS:
-		set_from_ip((void *)bts, BTS_ESCAPE_ADDRESS);
-		set_info_type((void *)bts, in->qualifier);
-		set_info_data((void *)bts, in->variant.jiffies);
-		break;
+	context = ds_get_context(task);
+	error = ds_validate_access(context, ds_pebs);
+	if (error < 0)
+		goto out;
 
-	default:
-		return -EINVAL;
-	}
+	*(u64 *)(context->ds + (ds_cfg.sizeof_field * 8)) = value;
 
-	bts = bts + ds_cfg.sizeof_bts;
-	if (bts >= get_bts_absolute_maximum(ds))
-		bts = get_bts_buffer_base(ds);
-	set_bts_index(ds, bts);
-
-	return ds_cfg.sizeof_bts;
-}
-
-unsigned long ds_debugctl_mask(void)
-{
-	return ds_cfg.debugctl_mask;
-}
-
-#ifdef __i386__
-static const struct ds_configuration ds_cfg_netburst = {
-	.sizeof_ds = 9 * 4,
-	.bts_buffer_base = { 0, 4 },
-	.bts_index = { 4, 4 },
-	.bts_absolute_maximum = { 8, 4 },
-	.bts_interrupt_threshold = { 12, 4 },
-	.sizeof_bts = 3 * 4,
-	.from_ip = { 0, 4 },
-	.to_ip = { 4, 4 },
-	.info_type = { 4, 1 },
-	.info_data = { 8, 4 },
-	.debugctl_mask = (1<<2)|(1<<3)
-};
+	error = 0;
+ out:
+	ds_put_context(context);
+	return error;
+}
 
-static const struct ds_configuration ds_cfg_pentium_m = {
-	.sizeof_ds = 9 * 4,
-	.bts_buffer_base = { 0, 4 },

-	.bts_index = { 4, 4 },
-	.bts_absolute_maximum = { 8, 4 },
-	.bts_interrupt_threshold = { 12, 4 },
-	.sizeof_bts = 3 * 4,
-	.from_ip = { 0, 4 },
-	.to_ip = { 4, 4 },
-	.info_type = { 4, 1 },
-	.info_data = { 8, 4 },
-	.debugctl_mask = (1<<6)|(1<<7)
+static const struct ds_configuration ds_cfg_var = {
+	.sizeof_ds    = sizeof(long) * 12,
+	.sizeof_field = sizeof(long),
+	.sizeof_rec[ds_bts]   = sizeof(long) * 3,
+	.sizeof_rec[ds_pebs]  = sizeof(long) * 10
 };
-#endif /* _i386_ */
-
-static const struct ds_configuration ds_cfg_core2 = {
-	.sizeof_ds = 9 * 8,
-	.bts_buffer_base = { 0, 8 },
-	.bts_index = { 8, 8 },
-	.bts_absolute_maximum = { 16, 8 },
-	.bts_interrupt_threshold = { 24, 8 },
-	.sizeof_bts = 3 * 8,
-	.from_ip = { 0, 8 },
-	.to_ip = { 8, 8 },
-	.info_type = { 8, 1 },
-	.info_data = { 16, 8 },
-	.debugctl_mask = (1<<6)|(1<<7)|(1<<9)
+static const struct ds_configuration ds_cfg_64 = {
+	.sizeof_ds    = 8 * 12,
+	.sizeof_field = 8,
+	.sizeof_rec[ds_bts]   = 8 * 3,
+	.sizeof_rec[ds_pebs]  = 8 * 10
 };
 
 static inline void
@@ -426,17 +814,17 @@
 
 void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
 {
+	spin_lock_init(&ds_lock);
+
 	switch (c->x86) {
 	case 0x6:
 		switch (c->x86_model) {
-#ifdef __i386__
 		case 0xD:
 		case 0xE: /* Pentium M */
-			ds_configure(&ds_cfg_pentium_m);
+			ds_configure(&ds_cfg_var);
 			break;
-#endif /* _i386_ */
 		case 0xF: /* Core2 */
-			ds_configure(&ds_cfg_core2);
+			ds_configure(&ds_cfg_64);
 			break;
 		default:
 			/* sorry, don't know about them */
@@ -445,13 +833,11 @@
 		break;
 	case 0xF:
 		switch (c->x86_model) {
-#ifdef __i386__
 		case 0x0:
 		case 0x1:
 		case 0x2: /* Netburst */
-			ds_configure(&ds_cfg_netburst);
+			ds_configure(&ds_cfg_var);
 			break;
-#endif /* _i386_ */
 		default:
 			/* sorry, don't know about them */
 			break;
@@ -462,3 +848,13 @@
 		break;
 	}
 }
+
+void ds_free(struct ds_context *context)
+{
+	/* This is called when the task owning the parameter context
+	 * is dying. There should not be any user of that context left
+	 * to disturb us, anymore. */
+	unsigned long leftovers = context->count;
+	while (leftovers--)
+		ds_put_context(context);
+}
Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h	2008-02-18 09:17:22.%N +0100
+++ linux-2.6-x86/include/asm-x86/processor.h	2008-02-18 09:17:59.%N +0100
@@ -24,6 +24,7 @@
 #include <asm/msr.h>
 #include <asm/desc_defs.h>
 #include <asm/nops.h>
+#include <asm/ds.h>
 #include <linux/personality.h>
 #include <linux/cpumask.h>
 #include <linux/cache.h>
@@ -355,9 +356,10 @@
 	unsigned io_bitmap_max;
 /* MSR_IA32_DEBUGCTLMSR value to switch in if TIF_DEBUGCTLMSR is set.  */
 	unsigned long	debugctlmsr;
-/* Debug Store - if not 0 points to a DS Save Area configuration;
- *               goes into MSR_IA32_DS_AREA */
-	unsigned long	ds_area_msr;
+/* Debug Store context; see include/asm-x86/ds.h; goes into MSR_IA32_DS_AREA */
+	struct ds_context	*ds_ctx;
+/* the signal to send on a bts buffer overflow */
+	unsigned int	bts_ovfl_signal;
 };
 
 static inline unsigned long native_get_debugreg(int regno)
Index: linux-2.6-x86/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/process_32.c	2008-02-18 09:16:37.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/process_32.c	2008-02-18 09:17:59.%N +0100
@@ -455,6 +455,12 @@
 		tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
 		put_cpu();
 	}
+	/* Free any DS contexts that have not been properly released. */
+	if (unlikely(current->thread.ds_ctx)) {
+		/* we clear debugctl to make sure DS is not used. */
+		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0);
+		ds_free(current->thread.ds_ctx);
+	}
 }
 
 void flush_thread(void)
@@ -566,17 +572,23 @@
 {
 	struct thread_struct *prev, *next;
 	unsigned long debugctl;
+	unsigned long ds_prev = 0, ds_next = 0;
 
 	prev = &prev_p->thread;
 	next = &next_p->thread;
 
+	if (prev->ds_ctx)
+		ds_prev = (unsigned long)prev->ds_ctx->ds;
+	if (next->ds_ctx)
+		ds_next = (unsigned long)next->ds_ctx->ds;
+
 	debugctl = prev->debugctlmsr;
-	if (next->ds_area_msr != prev->ds_area_msr) {
+	if (ds_next != ds_prev) {
 		/* we clear debugctl to make sure DS
 		 * is not in use when we change it */
 		debugctl = 0;
 		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0);
-		wrmsr(MSR_IA32_DS_AREA, next->ds_area_msr, 0);
+		wrmsr(MSR_IA32_DS_AREA, ds_next, 0);
 	}
 
 	if (next->debugctlmsr != debugctl)
Index: linux-2.6-x86/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/process_64.c	2008-02-18 09:16:37.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/process_64.c	2008-02-18 09:17:59.%N +0100
@@ -416,6 +416,12 @@
 		t->io_bitmap_max = 0;
 		put_cpu();
 	}
+	/* Free any DS contexts that have not been properly released. */
+	if (unlikely(t->ds_ctx)) {
+		/* we clear debugctl to make sure DS is not used. */
+		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0);
+		ds_free(t->ds_ctx);
+	}
 }
 
 void flush_thread(void)
@@ -564,17 +570,23 @@
 {
 	struct thread_struct *prev, *next;
 	unsigned long debugctl;
+	unsigned long ds_prev = 0, ds_next = 0;
 
 	prev = &prev_p->thread,
 	next = &next_p->thread;
 
+	if (prev->ds_ctx)
+		ds_prev = (unsigned long)prev->ds_ctx->ds;
+	if (next->ds_ctx)
+		ds_next = (unsigned long)next->ds_ctx->ds;
+
 	debugctl = prev->debugctlmsr;
-	if (next->ds_area_msr != prev->ds_area_msr) {
+	if (ds_next != ds_prev) {
 		/* we clear debugctl to make sure DS
 		 * is not in use when we change it */
 		debugctl = 0;
 		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0);
-		wrmsrl(MSR_IA32_DS_AREA, next->ds_area_msr);
+		wrmsrl(MSR_IA32_DS_AREA, ds_next);
 	}
 
 	if (next->debugctlmsr != debugctl)
Index: linux-2.6-x86/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/cpu/intel.c	2008-02-18 09:16:37.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/cpu/intel.c	2008-02-18 09:17:59.%N +0100
@@ -220,10 +220,11 @@
 			set_bit(X86_FEATURE_BTS, c->x86_capability);
 		if (!(l1 & (1<<12)))
 			set_bit(X86_FEATURE_PEBS, c->x86_capability);
+		ds_init_intel(c);
 	}
 
 	if (cpu_has_bts)
-		ds_init_intel(c);
+		ptrace_bts_init_intel(c);
 }
 
 static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 * c, unsigned int size)
Index: linux-2.6-x86/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/setup_64.c	2008-02-18 09:16:37.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/setup_64.c	2008-02-18 09:17:59.%N +0100
@@ -836,11 +836,12 @@
 			set_cpu_cap(c, X86_FEATURE_BTS);
 		if (!(l1 & (1<<12)))
 			set_cpu_cap(c, X86_FEATURE_PEBS);
+		ds_init_intel(c);
 	}
 
 
 	if (cpu_has_bts)
-		ds_init_intel(c);
+		ptrace_bts_init_intel(c);
 
 	n = c->extended_cpuid_level;
 	if (n >= 0x80000008) {
Index: linux-2.6-x86/include/asm-x86/ptrace-abi.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ptrace-abi.h	2008-02-18 09:17:22.%N +0100
+++ linux-2.6-x86/include/asm-x86/ptrace-abi.h	2008-02-18 09:17:59.%N +0100
@@ -103,14 +103,14 @@
 #define PTRACE_BTS_O_SCHED	0x2 /* scheduling events w/ jiffies */
 #define PTRACE_BTS_O_SIGNAL     0x4 /* send SIG<signal> on buffer overflow
 				       instead of wrapping around */
-#define PTRACE_BTS_O_CUT_SIZE	0x8 /* cut requested size to max available
-				       instead of failing */
+#define PTRACE_BTS_O_ALLOC	0x8 /* (re)allocate buffer */
 
 #define PTRACE_BTS_CONFIG	40
 /* Configure branch trace recording.
    ADDR points to a struct ptrace_bts_config.
    DATA gives the size of that buffer.
-   A new buffer is allocated, iff the size changes.
+   A new buffer is allocated, if requested in the flags.
+   An overflow signal may only be requested for new buffers.
    Returns the number of bytes read.
 */
 #define PTRACE_BTS_STATUS	41
@@ -119,7 +119,7 @@
    Returns the number of bytes written.
 */
 #define PTRACE_BTS_SIZE		42
-/* Return the number of available BTS records.
+/* Return the number of available BTS records for draining.
    DATA and ADDR are ignored.
 */
 #define PTRACE_BTS_GET		43
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

