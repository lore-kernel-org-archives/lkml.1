Return-Path: <linux-kernel-owner+w=401wt.eu-S1762909AbYD3Lzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762909AbYD3Lzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759472AbYD3Ly4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:54:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:47981 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758172AbYD3Lyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:54:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,728,1199692800"; 
   d="scan'208";a="558859742"
Date: Wed, 30 Apr 2008 13:54:40 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: andi-suse@firstfloor.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com, eranian@googlemail.com, juan.villacis@intel.com
Subject: [patch] x86, ptrace: in-kernel BTS interface
Message-ID: <20080430135440.A359@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an in-kernel interface to Branch Trace Store and implement the
ptrace user interface on top of it.

Fix a few bugs that were detected during the perfmon2 adaptation to
the DS interface by Stephane Eranian.

The ptrace implementation becomes a rather thin layer that only
forwards requests.

The BTS interface may later be morphed into a utrace interface for
execution trace, or it may be used to implement such a utrace
interface on top of it.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: gits.x86/arch/x86/kernel/bts.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ gits.x86/arch/x86/kernel/bts.c	2008-04-30 11:30:18.%N +0200
@@ -0,0 +1,505 @@
+/*
+ * Branch Trace Store (BTS) support
+ *
+ * This provides a low-level interface to the hardware's Branch Trace Store
+ * feature that is used for execution tracing.
+ *
+ * It manages:
+ * - per-thread and per-cpu BTS configuration
+ * - buffer memory allocation and overflow handling
+ *
+ * It assumes:
+ * - get_task_struct on all parameter tasks
+ * - current is allowed to trace parameter tasks
+ *
+ *
+ * Copyright (C) 2008 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, 2008
+ */
+
+#ifdef CONFIG_X86_BTS
+
+#include <asm/bts.h>
+#include <asm/ds.h>
+
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+
+
+/*
+ * The configuration for a particular BTS hardware implementation.
+ */
+struct bts_configuration {
+	/* the size of a BTS record in bytes; at most BTS_MAX_RECORD_SIZE */
+	unsigned char  sizeof_bts;
+	/* the size of a field in the BTS record in bytes */
+	unsigned char  sizeof_field;
+	/* a bitmask to enable/disable various parts of BTS in DEBUGCTL MSR */
+	unsigned long debugctl_tr;
+	unsigned long debugctl_btint;
+	unsigned long debugctl_user_off;
+	unsigned long debugctl_kernel_off;
+	unsigned long debugctl_all;
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
+{
+	base += (bts_cfg.sizeof_field * field);
+	return *(unsigned long *)base;
+}
+
+static inline void bts_set(char *base, enum bts_field field, unsigned long val)
+{
+	base += (bts_cfg.sizeof_field * field);;
+	(*(unsigned long *)base) = val;
+}
+
+/*
+ * Check the parameter raw BTS record.
+ * Return 1 if it is invalid; 0, otherwise
+ *
+ * raw: the raw BTS record to check
+ */
+static int bts_invalid(const void *raw)
+{
+	if ((bts_get(raw, bts_from) == 0) &&
+	    (bts_get(raw, bts_to) == 0))
+		return 1;
+	return 0;
+}
+
+/*
+ * Translate a BTS record from the raw format into the bts_struct format
+ *
+ * out (out): bts_struct interpretation
+ * raw:       raw BTS record
+ */
+static void bts_translate_record(struct bts_struct *out, const void *raw)
+{
+	memset(out, 0, sizeof(*out));
+	if (bts_get(raw, bts_from) == bts_escape) {
+		out->qualifier       = bts_get(raw, bts_qual);
+		out->variant.jiffies = bts_get(raw, bts_jiffies);
+	} else if (bts_invalid(raw)) {
+		out->qualifier = BTS_INVALID;
+	} else {
+		out->qualifier = BTS_BRANCH;
+		out->variant.lbr.from = bts_get(raw, bts_from);
+		out->variant.lbr.to   = bts_get(raw, bts_to);
+	}
+}
+
+
+int bts_request(struct task_struct *task, void *base, size_t size,
+		bts_ovfl_callback_t ovfl)
+{
+	if (!bts_cfg.sizeof_bts)
+		return -EOPNOTSUPP;
+
+	return ds_request_bts(task, base, size, ovfl);
+}
+EXPORT_SYMBOL(bts_request);
+
+int bts_release(struct task_struct *task)
+{
+	int error;
+
+	/* We need to disable branch recording for the parameter task
+	 * (or current cpu) before we may release the DS resources.
+	 */
+	error = bts_configure(task, /* flags = */ 0);
+	if (error < 0)
+		return error;
+
+	return ds_release_bts(task);
+}
+EXPORT_SYMBOL(bts_release);
+
+int bts_configure(struct task_struct *task, unsigned int flags)
+{
+	unsigned long debugctl_mask = 0;
+	int error;
+
+	/* Before we touch the configuration, let's validate that we
+	 * are allowed to.
+	 */
+	error = ds_validate_bts(task);
+	if (error < 0)
+		return error;
+
+	if (flags & BTS_O_TRACE)
+		debugctl_mask |= bts_cfg.debugctl_tr;
+	if (flags & BTS_O_USER_OFF)
+		debugctl_mask |= bts_cfg.debugctl_user_off;
+	if (flags & BTS_O_KERNEL_OFF)
+		debugctl_mask |= bts_cfg.debugctl_kernel_off;
+
+	if (task) {
+		task->thread.debugctlmsr &= ~bts_cfg.debugctl_all;
+		task->thread.debugctlmsr |= debugctl_mask;
+
+		if (task == current)
+			update_debugctlmsr(task->thread.debugctlmsr);
+
+		if (flags & BTS_O_TIMESTAMP)
+			set_tsk_thread_flag(task, TIF_BTS_TRACE_TS);
+		else
+			clear_tsk_thread_flag(task, TIF_BTS_TRACE_TS);
+
+		if (task->thread.debugctlmsr)
+			set_tsk_thread_flag(task, TIF_DEBUGCTLMSR);
+		else
+			clear_tsk_thread_flag(task, TIF_DEBUGCTLMSR);
+	}
+
+	if (!task) {
+		update_debugctlmsr((get_debugctlmsr() & ~bts_cfg.debugctl_all)
+				   | debugctl_mask);
+	}
+
+	return error;
+}
+EXPORT_SYMBOL(bts_configure);
+
+int bts_status(struct task_struct *task, size_t *bsize)
+{
+	unsigned long debugctl = 0;
+	const void *base, *max;
+	size_t end;
+	int error, flags = 0;
+
+	error = ds_validate_bts(task);
+	if (error < 0)
+		return error;
+
+	if (task) {
+		if (test_tsk_thread_flag(task, TIF_BTS_TRACE_TS))
+			flags |= BTS_O_TIMESTAMP;
+		debugctl = task->thread.debugctlmsr;
+	} else
+		debugctl = get_debugctlmsr();
+
+	if (debugctl & bts_cfg.debugctl_tr)
+		flags |= BTS_O_TRACE;
+	if (debugctl & bts_cfg.debugctl_user_off)
+		flags |= BTS_O_USER_OFF;
+	if (debugctl & bts_cfg.debugctl_kernel_off)
+		flags |= BTS_O_KERNEL_OFF;
+
+	if (bsize) {
+		error = ds_get_bts_end(task, &end);
+		if (error < 0)
+			return error;
+
+		error = ds_access_bts(task, /* index = */ 0, &base);
+		if (error < 0)
+			return error;
+
+		error = ds_access_bts(task, /* index = */ end, &max);
+		if (error < 0)
+			return error;
+
+		*bsize = (max - base);
+	}
+
+	return flags;
+}
+EXPORT_SYMBOL(bts_status);
+
+int bts_size(struct task_struct *task, size_t *pos)
+{
+	const void *raw;
+	size_t bts_index;
+	int error;
+
+	/* Depending on the buffer overflow policy and whether an
+	 * overflow actually occured, the size is either the write
+	 * index or the total size of the array.
+	 * We try to read at the write index position. If we read a
+	 * valid record, this seems to be a cyclic buffer after the
+	 * first overflow and we return the total array size;
+	 * otherwise, we return the write index.
+	 */
+	error = ds_get_bts_index(task, &bts_index);
+	if (error < 0)
+		return error;
+
+	error = ds_access_bts(task, bts_index, &raw);
+	if ((error < 0) || bts_invalid(raw)) {
+		if (pos)
+			*pos = bts_index;
+		return bts_index;
+	}
+
+	return ds_get_bts_end(task, pos);
+}
+EXPORT_SYMBOL(bts_size);
+
+int bts_read(struct task_struct *task,
+	     size_t index, size_t count,
+	     struct bts_struct *kbuf,
+	     struct bts_struct __user *ubuf,
+	     unsigned int flags)
+{
+	struct bts_struct bts;
+	const unsigned char *raw, *bob, *eob;
+	size_t bts_index, bts_end, size;
+	int error, bytes, inc;
+
+	if (!count)
+		return 0;
+
+	error = ds_get_bts_end(task, &bts_end);
+	if (error < 0)
+		return error;
+
+	if (bts_end <= index)
+		return -EINVAL;
+
+	error = bts_size(task, &size);
+	if (error < 0)
+		return error;
+
+	if (size < (index + count))
+		return -EINVAL;
+
+	error = ds_get_bts_index(task, &bts_index);
+	if (error < 0)
+		return error;
+
+	error = ds_access_bts(task, 0, (const void **)&bob);
+	if (error < 0)
+		return error;
+
+	error = ds_access_bts(task, bts_end, (const void **)&eob);
+	if (error < 0)
+		return error;
+
+	/* translate the bts index into the ds bts index */
+	if (flags & BTS_READ_O_REVERSE) {
+		bts_index += bts_end - (index + count);
+		inc = bts_cfg.sizeof_bts;
+	} else {
+		bts_index += bts_end - (index + 1);
+		inc = -bts_cfg.sizeof_bts;
+	}
+	if (bts_end <= bts_index)
+		bts_index -= bts_end;
+
+	error = ds_access_bts(task, bts_index, (const void **)&raw);
+	if (error < 0)
+		return error;
+
+	bytes = 0;
+	while (count-- > 0) {
+		if (kbuf)
+			bts_translate_record(kbuf++, raw);
+
+		if (ubuf) {
+			bts_translate_record(&bts, raw);
+
+			if (copy_to_user(ubuf++, &bts, sizeof(bts)))
+				return -EFAULT;
+		}
+
+		raw += inc;
+		if (raw < bob)
+			raw = eob + inc;
+		if (raw >= eob)
+			raw = bob;
+		bytes += sizeof(bts);
+	}
+
+	return bytes;
+}
+EXPORT_SYMBOL(bts_read);
+
+int bts_reset(struct task_struct *task)
+{
+	return ds_reset_bts(task);
+}
+EXPORT_SYMBOL(bts_reset);
+
+int bts_clear(struct task_struct *task)
+{
+	return ds_clear_bts(task);
+}
+EXPORT_SYMBOL(bts_clear);
+
+/*
+ * Write a single branch trace record into the branch trace buffer of
+ * the parameter task or the current cpu at the current position.
+ *
+ * task: the eventing task (NULL for current cpu)
+ * in:   the record to write
+ */
+static int bts_write(struct task_struct *task,
+		     const struct bts_struct *in)
+{
+	unsigned char bts_record[BTS_MAX_RECORD_SIZE];
+
+	BUG_ON(BTS_MAX_RECORD_SIZE < bts_cfg.sizeof_bts);
+
+	memset(bts_record, 0, bts_cfg.sizeof_bts);
+	switch (in->qualifier) {
+	case BTS_INVALID:
+		break;
+
+	case BTS_BRANCH:
+		bts_set(bts_record, bts_from, in->variant.lbr.from);
+		bts_set(bts_record, bts_to,   in->variant.lbr.to);
+		break;
+
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
+
+	/* The writing task will be the switched-to task on a context
+	 * switch. It needs to write into the switched-from task's BTS
+	 * buffer. */
+	return ds_unchecked_write_bts(task, bts_record, bts_cfg.sizeof_bts);
+}
+
+/*
+ * Record a scheduling event and its timestamp in the parameter task's
+ * branch trace buffer.
+ *
+ * If the parameter task is NULL, the timestamp is recorded in the
+ * current cpu's branch trace buffer.
+ *
+ * task:      the eventing task (NULL for current cpu)
+ * qualifier: the type of scheduling event
+ */
+void bts_take_timestamp(struct task_struct *task,
+			enum bts_qualifier qualifier)
+{
+	struct bts_struct rec = {
+		.qualifier = qualifier,
+		.variant.jiffies = jiffies_64
+	};
+
+	bts_write(task, &rec);
+}
+EXPORT_SYMBOL(bts_take_timestamp);
+
+
+static const struct bts_configuration bts_cfg_netburst = {
+	.sizeof_bts    = sizeof(long) * 3,
+	.sizeof_field  = sizeof(long),
+	.debugctl_tr         = (1<<2)|(1<<3),
+	.debugctl_btint      = (1<<4),
+	.debugctl_user_off   = (1<<6),
+	.debugctl_kernel_off = (1<<5)
+};
+
+static const struct bts_configuration bts_cfg_pentium_m = {
+	.sizeof_bts    = sizeof(long) * 3,
+	.sizeof_field  = sizeof(long),
+	.debugctl_tr         = (1<<6)|(1<<7),
+	.debugctl_btint      = (1<<8),
+	.debugctl_user_off   = 0,
+	.debugctl_kernel_off = 0
+};
+
+static const struct bts_configuration bts_cfg_core2 = {
+	.sizeof_bts    = 8 * 3,
+	.sizeof_field  = 8,
+	.debugctl_tr         = (1<<6)|(1<<7),
+	.debugctl_btint      = (1<<8),
+	.debugctl_user_off   = (1<<10),
+	.debugctl_kernel_off = (1<<9)
+};
+
+static inline void bts_init(const struct bts_configuration *cfg)
+{
+	bts_cfg = *cfg;
+
+	bts_cfg.debugctl_all =
+		(bts_cfg.debugctl_tr |
+		 bts_cfg.debugctl_btint |
+		 bts_cfg.debugctl_user_off |
+		 bts_cfg.debugctl_kernel_off);
+}
+
+void __cpuinit bts_init_intel(struct cpuinfo_x86 *c)
+{
+	switch (c->x86) {
+	case 0x6:
+		switch (c->x86_model) {
+		case 0xD:
+		case 0xE: /* Pentium M */
+			bts_init(&bts_cfg_pentium_m);
+			break;
+		case 0xF: /* Core2 */
+		case 0x1C: /* Atom */
+			bts_init(&bts_cfg_core2);
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
+			bts_init(&bts_cfg_netburst);
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
+#endif /* CONFIG_X86_BTS */
Index: gits.x86/include/asm-x86/bts.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ gits.x86/include/asm-x86/bts.h	2008-04-30 11:30:36.%N +0200
@@ -0,0 +1,224 @@
+/*
+ * Branch Trace Store (BTS) support
+ *
+ * This provides a low-level interface to the hardware's Branch Trace Store
+ * feature that is used for execution tracing.
+ *
+ * The abstraction is an array of branch records viewed backwards in time.
+ * That is, the newest record is at index 0; bigger indices give older data.
+ *
+ *
+ * It manages:
+ * - per-thread and per-cpu BTS configuration
+ * - buffer memory allocation and overflow handling
+ *
+ * It assumes:
+ * - get_task_struct on all parameter tasks
+ * - current is allowed to trace parameter tasks
+ *
+ *
+ * Copyright (C) 2008 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, 2008
+ */
+
+#ifndef _ASM_X86_BTS_H
+#define _ASM_X86_BTS_H
+
+#ifdef CONFIG_X86_BTS
+
+#include <linux/types.h>
+#include <linux/init.h>
+
+struct task_struct;
+
+
+/* A branch trace record entry
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
+#ifdef __KERNEL__
+struct bts_struct {
+	u64 qualifier;
+	union {
+		/* BTS_BRANCH */
+		struct {
+			u64 from;
+			u64 to;
+		} lbr;
+		/* BTS_TASK_ARRIVES or
+		   BTS_TASK_DEPARTS */
+		u64 jiffies;
+	} variant;
+};
+#else /* !__KERNEL__ */
+struct bts_struct {
+	__u64 qualifier;
+	union {
+		/* BTS_BRANCH */
+		struct {
+			__u64 from;
+			__u64 to;
+		} lbr;
+		/* BTS_TASK_ARRIVES or
+		   BTS_TASK_DEPARTS */
+		__u64 jiffies;
+	} variant;
+#endif /* __KERNEL__ */
+
+/*
+ * Request branch tracing for the parameter task or for the current cpu.
+ *
+ * Due to alignement constraints, the actual buffer may be slightly
+ * smaller than the requested or provided buffer.
+ *
+ * Returns 0 on success; -Eerrno otherwise
+ *
+ * task:  the task to request recording for;
+ *        NULL for per-cpu recording on the current cpu
+ * base:  the base pointer for the (non-pageable) buffer;
+ *        NULL if buffer allocation requested
+ * size:  the size of the requested or provided buffer
+ * ovfl:  pointer to a function to be called on buffer overflow;
+ *        NULL if cyclic buffer requested
+ */
+
+typedef void (*bts_ovfl_callback_t)(struct task_struct *);
+extern int bts_request(struct task_struct *task, void *base, size_t size,
+		       bts_ovfl_callback_t ovfl);
+
+/*
+ * Release branch recording resources (and stop recording).
+ *
+ * Frees buffers allocated on bts_request.
+ *
+ * Returns 0 on success; -Eerrno otherwise
+ *
+ * task: the task to release resources for;
+ *       NULL to release resources for the current cpu
+ */
+extern int bts_release(struct task_struct *task);
+
+/*
+ * Configure branch recording.
+ *
+ * Not all processors support all variants.
+ * If a variant is not supported, the respective flag is ignored.
+ *
+ * Returns 0 on success; -Eerrno otherwise
+ *
+ * task:  the task to configure BTS for;
+ *        NULL to configure BTS for the current cpu
+ * flags: a bit-mask of the below configuration flags
+ */
+#define BTS_O_TRACE		(1<<0)	/* record branch trace */
+#define BTS_O_TIMESTAMP		(1<<1)	/* record scheduling timestamps */
+#define BTS_O_USER_OFF		(1<<2)	/* do not trace user mode */
+#define BTS_O_KERNEL_OFF	(1<<3)	/* do not trace kernel mode */
+
+extern int bts_configure(struct task_struct *task, unsigned int flags);
+
+/*
+ * Query the branch recording configuration.
+ *
+ * Returns a bit-mask of configuration flags on success; -Eerrno otherwise
+ * Optionally stores the actual buffer size in bytes at the location
+ * pointed to by bsize, if bsize is not NULL.
+ *
+ * task:  the task to query the configuration for;
+ *        NULL to query for the current cpu configuration
+ * bsize (out): optional pointer to the buffer size variable
+ */
+extern int bts_status(struct task_struct *task, size_t *bsize);
+
+/*
+ * Return the size of the recorded branch trace in number of trace
+ * records, i.e. returns the index one entry beyond the end of the
+ * branch trace array.
+ *
+ * Returns -Eerrno on error
+ *
+ * task: the task to access;
+ *       NULL to access the current cpu
+ * pos (out): if not NULL, will hold the result
+ */
+extern int bts_size(struct task_struct *task, size_t *pos);
+
+/*
+ * Copy count branch trace records starting from index into the
+ * non-NULL buffers.
+ *
+ * The output may be reversed to allow consecutive reads into a bigger
+ * buffer. Indices still follow the array abstraction, i.e. trace
+ * is read from index + count - 1 to index.
+ *
+ * Both buffers are optional. If the respective parameter is not NULL,
+ * it is expected to point to a caller-allocated buffer of sufficient size.
+ *
+ * Returns the number of bytes copied on success; -Eerrno on error
+ *
+ * task:  the task to access;
+ *        NULL to access the current cpu
+ * index: the index of the first requested record
+ * count: the number of requested records
+ * kbuf (out): pointer to the caller-allocated in-kernel bts_struct array
+ *             NULL to ignore this buffer
+ * ubuf (out): pointer to the caller-allocated user-space bts_struct array
+ *             NULL to ignore this buffer
+ * flags: a bit-mask of read flags
+ */
+#define BTS_READ_O_REVERSE	(1<<0) /* reverse output */
+
+extern int bts_read(struct task_struct *task,
+		    size_t index, size_t count,
+		    struct bts_struct *kbuf,
+		    struct bts_struct __user *ubuf,
+		    unsigned int flags);
+
+/*
+ * Reset the write pointer of the BTS buffer.
+ *
+ * Returns 0 on success; -Eerrno on error
+ *
+ * task: the task to access;
+ *       NULL to access the current cpu
+ */
+extern int bts_reset(struct task_struct *task);
+
+/*
+ * Clear the BTS buffer and reset the write pointer.
+ * The entire buffer will be zeroed out.
+ *
+ * Returns 0 on success; -Eerrno on error
+ *
+ * task: the task to access;
+ *       NULL to access the current cpu
+ */
+extern int bts_clear(struct task_struct *task);
+
+
+/*
+ * Initialization
+ */
+struct cpuinfo_x86;
+extern void __cpuinit bts_init_intel(struct cpuinfo_x86 *);
+
+/*
+ * Called by the scheduler to record a timestamp in the branch trace.
+ */
+extern void bts_take_timestamp(struct task_struct *, enum bts_qualifier);
+
+#else /* CONFIG_X86_BTS */
+
+#define bts_init_intel(config)			do {} while (0)
+#define bts_take_timestamp(task, qualifier)	do {} while (0)
+
+#endif /* CONFIG_X86_DS */
+#endif /* _ASM_X86_BTS_H */
Index: gits.x86/arch/x86/kernel/ptrace.c
===================================================================
--- gits.x86.orig/arch/x86/kernel/ptrace.c	2008-04-30 11:16:35.%N +0200
+++ gits.x86/arch/x86/kernel/ptrace.c	2008-04-30 11:35:10.%N +0200
@@ -32,6 +32,7 @@
 #include <asm/prctl.h>
 #include <asm/proto.h>
 #include <asm/ds.h>
+#include <asm/bts.h>
 
 #include "tls.h"
 
@@ -555,155 +556,6 @@
 }
 
 #ifdef CONFIG_X86_PTRACE_BTS
-/*
- * The configuration for a particular BTS hardware implementation.
- */
-struct bts_configuration {
-	/* the size of a BTS record in bytes; at most BTS_MAX_RECORD_SIZE */
-	unsigned char  sizeof_bts;
-	/* the size of a field in the BTS record in bytes */
-	unsigned char  sizeof_field;
-	/* a bitmask to enable/disable BTS in DEBUGCTL MSR */
-	unsigned long debugctl_mask;
-};
-static struct bts_configuration bts_cfg;
-
-#define BTS_MAX_RECORD_SIZE (8 * 3)
-
-
-/*
- * Branch Trace Store (BTS) uses the following format. Different
- * architectures vary in the size of those fields.
- * - source linear address
- * - destination linear address
- * - flags
- *
- * Later architectures use 64bit pointers throughout, whereas earlier
- * architectures use 32bit pointers in 32bit mode.
- *
- * We compute the base address for the first 8 fields based on:
- * - the field size stored in the DS configuration
- * - the relative field position
- *
- * In order to store additional information in the BTS buffer, we use
- * a special source address to indicate that the record requires
- * special interpretation.
- *
- * Netburst indicated via a bit in the flags field whether the branch
- * was predicted; this is ignored.
- */
-
-enum bts_field {
-	bts_from = 0,
-	bts_to,
-	bts_flags,
-
-	bts_escape = (unsigned long)-1,
-	bts_qual = bts_to,
-	bts_jiffies = bts_flags
-};
-
-static inline unsigned long bts_get(const char *base, enum bts_field field)
-{
-	base += (bts_cfg.sizeof_field * field);
-	return *(unsigned long *)base;
-}
-
-static inline void bts_set(char *base, enum bts_field field, unsigned long val)
-{
-	base += (bts_cfg.sizeof_field * field);;
-	(*(unsigned long *)base) = val;
-}
-
-/*
- * Translate a BTS record from the raw format into the bts_struct format
- *
- * out (out): bts_struct interpretation
- * raw: raw BTS record
- */
-static void ptrace_bts_translate_record(struct bts_struct *out, const void *raw)
-{
-	memset(out, 0, sizeof(*out));
-	if (bts_get(raw, bts_from) == bts_escape) {
-		out->qualifier       = bts_get(raw, bts_qual);
-		out->variant.jiffies = bts_get(raw, bts_jiffies);
-	} else {
-		out->qualifier = BTS_BRANCH;
-		out->variant.lbr.from_ip = bts_get(raw, bts_from);
-		out->variant.lbr.to_ip   = bts_get(raw, bts_to);
-	}
-}
-
-static int ptrace_bts_read_record(struct task_struct *child, size_t index,
-				  struct bts_struct __user *out)
-{
-	struct bts_struct ret;
-	const void *bts_record;
-	size_t bts_index, bts_end;
-	int error;
-
-	error = ds_get_bts_end(child, &bts_end);
-	if (error < 0)
-		return error;
-
-	if (bts_end <= index)
-		return -EINVAL;
-
-	error = ds_get_bts_index(child, &bts_index);
-	if (error < 0)
-		return error;
-
-	/* translate the ptrace bts index into the ds bts index */
-	bts_index += bts_end - (index + 1);
-	if (bts_end <= bts_index)
-		bts_index -= bts_end;
-
-	error = ds_access_bts(child, bts_index, &bts_record);
-	if (error < 0)
-		return error;
-
-	ptrace_bts_translate_record(&ret, bts_record);
-
-	if (copy_to_user(out, &ret, sizeof(ret)))
-		return -EFAULT;
-
-	return sizeof(ret);
-}
-
-static int ptrace_bts_drain(struct task_struct *child,
-			    long size,
-			    struct bts_struct __user *out)
-{
-	struct bts_struct ret;
-	const unsigned char *raw;
-	size_t end, i;
-	int error;
-
-	error = ds_get_bts_index(child, &end);
-	if (error < 0)
-		return error;
-
-	if (size < (end * sizeof(struct bts_struct)))
-		return -EIO;
-
-	error = ds_access_bts(child, 0, (const void **)&raw);
-	if (error < 0)
-		return error;
-
-	for (i = 0; i < end; i++, out++, raw += bts_cfg.sizeof_bts) {
-		ptrace_bts_translate_record(&ret, raw);
-
-		if (copy_to_user(out, &ret, sizeof(ret)))
-			return -EFAULT;
-	}
-
-	error = ds_clear_bts(child);
-	if (error < 0)
-		return error;
-
-	return end;
-}
-
 static void ptrace_bts_ovfl(struct task_struct *child)
 {
 	send_sig(child->thread.bts_ovfl_signal, child, 0);
@@ -714,75 +566,47 @@
 			     const struct ptrace_bts_config __user *ucfg)
 {
 	struct ptrace_bts_config cfg;
+	unsigned int flags = 0;
 	int error = 0;
 
-	error = -EOPNOTSUPP;
-	if (!bts_cfg.sizeof_bts)
-		goto errout;
-
-	error = -EIO;
 	if (cfg_size < sizeof(cfg))
-		goto errout;
+		return -EIO;
 
-	error = -EFAULT;
 	if (copy_from_user(&cfg, ucfg, sizeof(cfg)))
-		goto errout;
+		return -EFAULT;
 
-	error = -EINVAL;
 	if ((cfg.flags & PTRACE_BTS_O_SIGNAL) &&
 	    !(cfg.flags & PTRACE_BTS_O_ALLOC))
-		goto errout;
+		return -EINVAL;
 
 	if (cfg.flags & PTRACE_BTS_O_ALLOC) {
-		ds_ovfl_callback_t ovfl = 0;
+		ds_ovfl_callback_t ovfl = NULL;
 		unsigned int sig = 0;
 
 		/* we ignore the error in case we were not tracing child */
-		(void)ds_release_bts(child);
+		(void)bts_release(child);
 
 		if (cfg.flags & PTRACE_BTS_O_SIGNAL) {
 			if (!cfg.signal)
-				goto errout;
+				return -EINVAL;
 
 			sig  = cfg.signal;
 			ovfl = ptrace_bts_ovfl;
 		}
 
-		error = ds_request_bts(child, /* base = */ 0, cfg.size, ovfl);
+		error = bts_request(child, /* base = */ NULL, cfg.size, ovfl);
 		if (error < 0)
-			goto errout;
+			return error;
 
 		child->thread.bts_ovfl_signal = sig;
 	}
 
-	error = -EINVAL;
-	if (!child->thread.ds_ctx && cfg.flags)
-		goto errout;
-
 	if (cfg.flags & PTRACE_BTS_O_TRACE)
-		child->thread.debugctlmsr |= bts_cfg.debugctl_mask;
-	else
-		child->thread.debugctlmsr &= ~bts_cfg.debugctl_mask;
-
+		flags |= (BTS_O_TRACE | BTS_O_KERNEL_OFF);
 	if (cfg.flags & PTRACE_BTS_O_SCHED)
-		set_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
-	else
-		clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
+		flags |= BTS_O_TIMESTAMP;
 
-	error = sizeof(cfg);
-
-out:
-	if (child->thread.debugctlmsr)
-		set_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
-	else
-		clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
-
-	return error;
-
-errout:
-	child->thread.debugctlmsr &= ~bts_cfg.debugctl_mask;
-	clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
-	goto out;
+	return bts_configure(child, flags);
 }
 
 static int ptrace_bts_status(struct task_struct *child,
@@ -790,38 +614,28 @@
 			     struct ptrace_bts_config __user *ucfg)
 {
 	struct ptrace_bts_config cfg;
-	size_t end;
-	const void *base, *max;
-	int error;
+	size_t size;
+	int status;
 
 	if (cfg_size < sizeof(cfg))
 		return -EIO;
 
-	error = ds_get_bts_end(child, &end);
-	if (error < 0)
-		return error;
-
-	error = ds_access_bts(child, /* index = */ 0, &base);
-	if (error < 0)
-		return error;
-
-	error = ds_access_bts(child, /* index = */ end, &max);
-	if (error < 0)
-		return error;
+	status = bts_status(child, &size);
+	if (status < 0)
+		return status;
 
 	memset(&cfg, 0, sizeof(cfg));
-	cfg.size = (max - base);
+	cfg.size = size;
 	cfg.signal = child->thread.bts_ovfl_signal;
 	cfg.bts_size = sizeof(struct bts_struct);
 
 	if (cfg.signal)
 		cfg.flags |= PTRACE_BTS_O_SIGNAL;
 
-	if (test_tsk_thread_flag(child, TIF_DEBUGCTLMSR) &&
-	    child->thread.debugctlmsr & bts_cfg.debugctl_mask)
+	if (status & BTS_O_TRACE)
 		cfg.flags |= PTRACE_BTS_O_TRACE;
 
-	if (test_tsk_thread_flag(child, TIF_BTS_TRACE_TS))
+	if (status & BTS_O_TIMESTAMP)
 		cfg.flags |= PTRACE_BTS_O_SCHED;
 
 	if (copy_to_user(ucfg, &cfg, sizeof(cfg)))
@@ -830,108 +644,28 @@
 	return sizeof(cfg);
 }
 
-static int ptrace_bts_write_record(struct task_struct *child,
-				   const struct bts_struct *in)
-{
-	unsigned char bts_record[BTS_MAX_RECORD_SIZE];
-
-	BUG_ON(BTS_MAX_RECORD_SIZE < bts_cfg.sizeof_bts);
-
-	memset(bts_record, 0, bts_cfg.sizeof_bts);
-	switch (in->qualifier) {
-	case BTS_INVALID:
-		break;
-
-	case BTS_BRANCH:
-		bts_set(bts_record, bts_from, in->variant.lbr.from_ip);
-		bts_set(bts_record, bts_to,   in->variant.lbr.to_ip);
-		break;
-
-	case BTS_TASK_ARRIVES:
-	case BTS_TASK_DEPARTS:
-		bts_set(bts_record, bts_from,    bts_escape);
-		bts_set(bts_record, bts_qual,    in->qualifier);
-		bts_set(bts_record, bts_jiffies, in->variant.jiffies);
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	/* The writing task will be the switched-to task on a context
-	 * switch. It needs to write into the switched-from task's BTS
-	 * buffer. */
-	return ds_unchecked_write_bts(child, bts_record, bts_cfg.sizeof_bts);
-}
-
-void ptrace_bts_take_timestamp(struct task_struct *tsk,
-			       enum bts_qualifier qualifier)
+static int ptrace_bts_drain(struct task_struct *child,
+			    long size,
+			    struct bts_struct __user *out)
 {
-	struct bts_struct rec = {
-		.qualifier = qualifier,
-		.variant.jiffies = jiffies_64
-	};
+	size_t bsize;
+	int error;
 
-	ptrace_bts_write_record(tsk, &rec);
-}
+	error = bts_size(child, &bsize);
+	if (error < 0)
+		return error;
 
-static const struct bts_configuration bts_cfg_netburst = {
-	.sizeof_bts    = sizeof(long) * 3,
-	.sizeof_field  = sizeof(long),
-	.debugctl_mask = (1<<2)|(1<<3)|(1<<5)
-};
+	if (size < (bsize * sizeof(*out)))
+		return -EIO;
 
-static const struct bts_configuration bts_cfg_pentium_m = {
-	.sizeof_bts    = sizeof(long) * 3,
-	.sizeof_field  = sizeof(long),
-	.debugctl_mask = (1<<6)|(1<<7)
-};
+	error = bts_read(child, 0, bsize, /* kbuf = */ NULL, out,
+			 BTS_READ_O_REVERSE);
+	if (error < 0)
+		return error;
 
-static const struct bts_configuration bts_cfg_core2 = {
-	.sizeof_bts    = 8 * 3,
-	.sizeof_field  = 8,
-	.debugctl_mask = (1<<6)|(1<<7)|(1<<9)
-};
+	(void)bts_clear(child);
 
-static inline void bts_configure(const struct bts_configuration *cfg)
-{
-	bts_cfg = *cfg;
-}
-
-void __cpuinit ptrace_bts_init_intel(struct cpuinfo_x86 *c)
-{
-	switch (c->x86) {
-	case 0x6:
-		switch (c->x86_model) {
-		case 0xD:
-		case 0xE: /* Pentium M */
-			bts_configure(&bts_cfg_pentium_m);
-			break;
-		case 0xF: /* Core2 */
-        case 0x1C: /* Atom */
-			bts_configure(&bts_cfg_core2);
-			break;
-		default:
-			/* sorry, don't know about them */
-			break;
-		}
-		break;
-	case 0xF:
-		switch (c->x86_model) {
-		case 0x0:
-		case 0x1:
-		case 0x2: /* Netburst */
-			bts_configure(&bts_cfg_netburst);
-			break;
-		default:
-			/* sorry, don't know about them */
-			break;
-		}
-		break;
-	default:
-		/* sorry, don't know about them */
-		break;
-	}
+	return (error / sizeof(*out));
 }
 #endif /* CONFIG_X86_PTRACE_BTS */
 
@@ -947,13 +681,7 @@
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 #endif
 #ifdef CONFIG_X86_PTRACE_BTS
-	(void)ds_release_bts(child);
-
-	child->thread.debugctlmsr &= ~bts_cfg.debugctl_mask;
-	if (!child->thread.debugctlmsr)
-		clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
-
-	clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
+	(void)bts_release(child);
 #endif /* CONFIG_X86_PTRACE_BTS */
 }
 
@@ -1086,16 +814,16 @@
 		break;
 
 	case PTRACE_BTS_SIZE:
-		ret = ds_get_bts_index(child, /* pos = */ 0);
+		ret = bts_size(child, /* bsize = */ 0);
 		break;
 
 	case PTRACE_BTS_GET:
-		ret = ptrace_bts_read_record
-			(child, data, (struct bts_struct __user *) addr);
+		ret = bts_read(child, data, /* count = */ 1, /* kbuf = */ NULL,
+			(struct bts_struct __user *) addr, /* flags = */ 0);
 		break;
 
 	case PTRACE_BTS_CLEAR:
-		ret = ds_clear_bts(child);
+		ret = bts_clear(child);
 		break;
 
 	case PTRACE_BTS_DRAIN:
Index: gits.x86/arch/x86/Kconfig.cpu
===================================================================
--- gits.x86.orig/arch/x86/Kconfig.cpu	2008-04-30 11:16:32.%N +0200
+++ gits.x86/arch/x86/Kconfig.cpu	2008-04-30 11:36:52.%N +0200
@@ -428,12 +428,19 @@
 	  This allows the kernel to provide a memory buffer to the hardware
 	  to store various profiling and tracing events.
 
-config X86_PTRACE_BTS
-	bool "ptrace interface to Branch Trace Store"
+config X86_BTS
+	bool "Branch Trace Store support"
 	default y
 	depends on (X86_DS && X86_DEBUGCTLMSR)
 	help
-	  Add a ptrace interface to allow collecting an execution trace
-	  of the traced task.
-	  This collects control flow changes in a (cyclic) buffer and allows
-	  debuggers to fill in the gaps and show an execution trace of the debuggee.
+	  Add support for Branch Trace Store.
+	  This allows the kernel to collect branch trace information per
+	  task or per cpu.
+
+config X86_PTRACE_BTS
+	bool "A ptrace interface to Branch Trace Store support"
+	default y
+	depends on (X86_BTS)
+	help
+	  Add a ptrace interface to expose Branch Trace Store support to user space.
+	  This allows debuggers to show an execution trace of the debuggee.
Index: gits.x86/arch/x86/kernel/process_32.c
===================================================================
--- gits.x86.orig/arch/x86/kernel/process_32.c	2008-04-30 11:16:35.%N +0200
+++ gits.x86/arch/x86/kernel/process_32.c	2008-04-30 11:46:18.%N +0200
@@ -55,6 +55,8 @@
 #include <asm/tlbflush.h>
 #include <asm/cpu.h>
 #include <asm/kdebug.h>
+#include <asm/ds.h>
+#include <asm/bts.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -485,8 +487,9 @@
 }
 
 #ifdef CONFIG_X86_DS
-static int update_debugctl(struct thread_struct *prev,
-			struct thread_struct *next, unsigned long debugctl)
+static unsigned long update_debugctl(struct thread_struct *prev,
+				     struct thread_struct *next,
+				     unsigned long debugctl)
 {
 	unsigned long ds_prev = 0;
 	unsigned long ds_next = 0;
@@ -506,8 +509,9 @@
 	return debugctl;
 }
 #else
-static int update_debugctl(struct thread_struct *prev,
-			struct thread_struct *next, unsigned long debugctl)
+static unsigned long update_debugctl(struct thread_struct *prev,
+				     struct thread_struct *next,
+				     unsigned long debugctl)
 {
 	return debugctl;
 }
@@ -547,13 +551,13 @@
 			hard_enable_TSC();
 	}
 
-#ifdef CONFIG_X86_PTRACE_BTS
+#ifdef CONFIG_X86_BTS
 	if (test_tsk_thread_flag(prev_p, TIF_BTS_TRACE_TS))
-		ptrace_bts_take_timestamp(prev_p, BTS_TASK_DEPARTS);
+		bts_take_timestamp(prev_p, BTS_TASK_DEPARTS);
 
 	if (test_tsk_thread_flag(next_p, TIF_BTS_TRACE_TS))
-		ptrace_bts_take_timestamp(next_p, BTS_TASK_ARRIVES);
-#endif /* CONFIG_X86_PTRACE_BTS */
+		bts_take_timestamp(next_p, BTS_TASK_ARRIVES);
+#endif /* CONFIG_X86_BTS */
 
 
 	if (!test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
Index: gits.x86/arch/x86/kernel/process_64.c
===================================================================
--- gits.x86.orig/arch/x86/kernel/process_64.c	2008-04-30 11:16:35.%N +0200
+++ gits.x86/arch/x86/kernel/process_64.c	2008-04-30 11:45:12.%N +0200
@@ -52,6 +52,8 @@
 #include <asm/proto.h>
 #include <asm/ia32.h>
 #include <asm/idle.h>
+#include <asm/ds.h>
+#include <asm/bts.h>
 
 asmlinkage extern void ret_from_fork(void);
 
@@ -510,20 +512,14 @@
  */
 #define loaddebug(thread, r) set_debugreg(thread->debugreg ## r, r)
 
-static inline void __switch_to_xtra(struct task_struct *prev_p,
-				    struct task_struct *next_p,
-				    struct tss_struct *tss)
+#ifdef CONFIG_X86_DS
+static unsigned long update_debugctl(struct thread_struct *prev,
+				     struct thread_struct *next,
+				     unsigned long debugctl)
 {
-	struct thread_struct *prev, *next;
-	unsigned long debugctl;
-	unsigned long ds_prev = 0, ds_next = 0;
+	unsigned long ds_prev = 0;
+	unsigned long ds_next = 0;
 
-	prev = &prev_p->thread,
-	next = &next_p->thread;
-
-	debugctl = prev->debugctlmsr;
-
-#ifdef CONFIG_X86_DS
 	if (prev->ds_ctx)
 		ds_prev = (unsigned long)prev->ds_ctx->ds;
 	if (next->ds_ctx)
@@ -536,8 +532,29 @@
 		update_debugctlmsr(0);
 		wrmsrl(MSR_IA32_DS_AREA, ds_next);
 	}
+	return debugctl;
+}
+#else
+static unsigned long update_debugctl(struct thread_struct *prev,
+				     struct thread_struct *next,
+				     unsigned long debugctl)
+{
+	return debugctl;
+}
 #endif /* CONFIG_X86_DS */
 
+static inline void __switch_to_xtra(struct task_struct *prev_p,
+				    struct task_struct *next_p,
+				    struct tss_struct *tss)
+{
+	struct thread_struct *prev, *next;
+	unsigned long debugctl;
+
+	prev = &prev_p->thread,
+	next = &next_p->thread;
+
+	debugctl = update_debugctl(prev, next, prev->debugctlmsr);
+
 	if (next->debugctlmsr != debugctl)
 		update_debugctlmsr(next->debugctlmsr);
 
@@ -574,13 +591,13 @@
 		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
 	}
 
-#ifdef CONFIG_X86_PTRACE_BTS
+#ifdef CONFIG_X86_BTS
 	if (test_tsk_thread_flag(prev_p, TIF_BTS_TRACE_TS))
-		ptrace_bts_take_timestamp(prev_p, BTS_TASK_DEPARTS);
+		bts_take_timestamp(prev_p, BTS_TASK_DEPARTS);
 
 	if (test_tsk_thread_flag(next_p, TIF_BTS_TRACE_TS))
-		ptrace_bts_take_timestamp(next_p, BTS_TASK_ARRIVES);
-#endif /* CONFIG_X86_PTRACE_BTS */
+		bts_take_timestamp(next_p, BTS_TASK_ARRIVES);
+#endif /* CONFIG_X86_BTS */
 }
 
 /*
Index: gits.x86/arch/x86/kernel/Makefile
===================================================================
--- gits.x86.orig/arch/x86/kernel/Makefile	2008-04-30 11:16:33.%N +0200
+++ gits.x86/arch/x86/kernel/Makefile	2008-04-30 11:49:48.%N +0200
@@ -33,7 +33,8 @@
 obj-y				+= process.o
 obj-y				+= i387.o
 obj-y				+= ptrace.o
-obj-y				+= ds.o
+obj-$(CONFIG_X86_DS)		+= ds.o
+obj-$(CONFIG_X86_BTS)		+= bts.o
 obj-$(CONFIG_X86_32)		+= tls.o
 obj-$(CONFIG_IA32_EMULATION)	+= tls.o
 obj-y				+= step.o
Index: gits.x86/include/asm-x86/processor.h
===================================================================
--- gits.x86.orig/include/asm-x86/processor.h	2008-04-30 11:18:32.%N +0200
+++ gits.x86/include/asm-x86/processor.h	2008-04-30 11:48:25.%N +0200
@@ -750,6 +750,18 @@
 extern void cpu_init(void);
 extern void init_gdt(int cpu);
 
+static inline unsigned long get_debugctlmsr(void)
+{
+	unsigned long debugctlmsr;
+
+#ifndef CONFIG_X86_DEBUGCTLMSR
+	if (boot_cpu_data.x86 < 6)
+		return 0;
+#endif
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctlmsr);
+	return debugctlmsr;
+}
+
 static inline void update_debugctlmsr(unsigned long debugctlmsr)
 {
 #ifndef CONFIG_X86_DEBUGCTLMSR
Index: gits.x86/arch/x86/kernel/cpu/intel.c
===================================================================
--- gits.x86.orig/arch/x86/kernel/cpu/intel.c	2008-04-30 11:16:34.%N +0200
+++ gits.x86/arch/x86/kernel/cpu/intel.c	2008-04-30 11:51:21.%N +0200
@@ -13,6 +13,7 @@
 #include <asm/uaccess.h>
 #include <asm/ptrace.h>
 #include <asm/ds.h>
+#include <asm/bts.h>
 #include <asm/bugs.h>
 
 #include "cpu.h"
@@ -226,7 +227,7 @@
 	}
 
 	if (cpu_has_bts)
-		ptrace_bts_init_intel(c);
+		bts_init_intel(c);
 }
 
 static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
Index: gits.x86/arch/x86/kernel/setup_64.c
===================================================================
--- gits.x86.orig/arch/x86/kernel/setup_64.c	2008-04-30 11:16:35.%N +0200
+++ gits.x86/arch/x86/kernel/setup_64.c	2008-04-30 11:50:53.%N +0200
@@ -68,6 +68,7 @@
 #include <asm/cacheflush.h>
 #include <asm/mce.h>
 #include <asm/ds.h>
+#include <asm/bts.h>
 #include <asm/topology.h>
 #include <asm/trampoline.h>
 
@@ -924,7 +925,7 @@
 
 
 	if (cpu_has_bts)
-		ptrace_bts_init_intel(c);
+		bts_init_intel(c);
 
 	n = c->extended_cpuid_level;
 	if (n >= 0x80000008) {
Index: gits.x86/include/asm-x86/ptrace-abi.h
===================================================================
--- gits.x86.orig/include/asm-x86/ptrace-abi.h	2008-04-30 11:18:32.%N +0200
+++ gits.x86/include/asm-x86/ptrace-abi.h	2008-04-30 12:20:15.%N +0200
@@ -82,24 +82,6 @@
 
 #ifdef CONFIG_X86_PTRACE_BTS
 
-#ifndef __ASSEMBLY__
-#include <asm/types.h>
-
-/* configuration/status structure used in PTRACE_BTS_CONFIG and
-   PTRACE_BTS_STATUS commands.
-*/
-struct ptrace_bts_config {
-	/* requested or actual size of BTS buffer in bytes */
-	__u32 size;
-	/* bitmask of below flags */
-	__u32 flags;
-	/* buffer overflow signal */
-	__u32 signal;
-	/* actual size of bts_struct in bytes */
-	__u32 bts_size;
-};
-#endif /* __ASSEMBLY__ */
-
 #define PTRACE_BTS_O_TRACE	0x1 /* branch trace */
 #define PTRACE_BTS_O_SCHED	0x2 /* scheduling events w/ jiffies */
 #define PTRACE_BTS_O_SIGNAL     0x4 /* send SIG<signal> on buffer overflow
Index: gits.x86/include/asm-x86/ptrace.h
===================================================================
--- gits.x86.orig/include/asm-x86/ptrace.h	2008-04-30 11:18:32.%N +0200
+++ gits.x86/include/asm-x86/ptrace.h	2008-04-30 12:22:26.%N +0200
@@ -7,6 +7,25 @@
 
 #ifndef __ASSEMBLY__
 
+#ifdef CONFIG_X86_PTRACE_BTS
+#include <linux/types.h>
+#include <asm/bts.h>
+
+/* configuration/status structure used in PTRACE_BTS_CONFIG and
+   PTRACE_BTS_STATUS commands.
+*/
+struct ptrace_bts_config {
+	/* requested or actual size of BTS buffer in bytes */
+	__u32 size;
+	/* bitmask of below flags */
+	__u32 flags;
+	/* buffer overflow signal */
+	__u32 signal;
+	/* actual size of bts_struct in bytes */
+	__u32 bts_size;
+};
+#endif /* CONFIG_X86_PTRACE_BTS */
+
 #ifdef __i386__
 /* this struct defines the way the registers are stored on the
    stack during a system call. */
@@ -126,48 +145,12 @@
 #endif /* !__i386__ */
 
 
-#ifdef CONFIG_X86_PTRACE_BTS
-/* a branch trace record entry
- *
- * In order to unify the interface between various processor versions,
- * we use the below data structure for all processors.
- */
-enum bts_qualifier {
-	BTS_INVALID = 0,
-	BTS_BRANCH,
-	BTS_TASK_ARRIVES,
-	BTS_TASK_DEPARTS
-};
-
-struct bts_struct {
-	__u64 qualifier;
-	union {
-		/* BTS_BRANCH */
-		struct {
-			__u64 from_ip;
-			__u64 to_ip;
-		} lbr;
-		/* BTS_TASK_ARRIVES or
-		   BTS_TASK_DEPARTS */
-		__u64 jiffies;
-	} variant;
-};
-#endif /* CONFIG_X86_PTRACE_BTS */
-
 #ifdef __KERNEL__
 
 #include <linux/init.h>
 
-struct cpuinfo_x86;
 struct task_struct;
 
-#ifdef CONFIG_X86_PTRACE_BTS
-extern void __cpuinit ptrace_bts_init_intel(struct cpuinfo_x86 *);
-extern void ptrace_bts_take_timestamp(struct task_struct *, enum bts_qualifier);
-#else
-#define ptrace_bts_init_intel(config) do {} while (0)
-#endif /* CONFIG_X86_PTRACE_BTS */
-
 extern unsigned long profile_pc(struct pt_regs *regs);
 
 extern unsigned long
Index: gits.x86/arch/x86/kernel/ds.c
===================================================================
--- gits.x86.orig/arch/x86/kernel/ds.c	2008-04-30 11:16:34.%N +0200
+++ gits.x86/arch/x86/kernel/ds.c	2008-04-30 12:27:02.%N +0200
@@ -29,6 +29,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/module.h>
 
 
 /*
@@ -131,9 +132,14 @@
 	if (!context)
 		return -EPERM;
 
+	/* The one who did the ds_request() is OK */
 	if (context->owner[qual] == current)
 		return 0;
 
+	/* Every task may access its own configuration */
+	if (context->task == current)
+		return 0;
+
 	return -EPERM;
 }
 
@@ -333,24 +339,27 @@
  */
 static inline void *ds_allocate_buffer(size_t size, unsigned int *pages)
 {
+	struct mm_struct *mm = current->mm;
 	unsigned long rlim, vm, pgsz;
-	void *buffer;
+	void *buffer = NULL;
 
 	pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
+	down_write(&mm->mmap_sem);
+
 	rlim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
 	vm   = current->mm->total_vm  + pgsz;
 	if (rlim < vm)
-		return NULL;
+		goto out;
 
 	rlim = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
 	vm   = current->mm->locked_vm  + pgsz;
 	if (rlim < vm)
-		return NULL;
+		goto out;
 
 	buffer = kzalloc(size, GFP_KERNEL);
 	if (!buffer)
-		return NULL;
+		goto out;
 
 	current->mm->total_vm  += pgsz;
 	current->mm->locked_vm += pgsz;
@@ -358,16 +367,18 @@
 	if (pages)
 		*pages = pgsz;
 
+ out:
+	up_write(&mm->mmap_sem);
 	return buffer;
 }
 
 static int ds_request(struct task_struct *task, void *base, size_t size,
 		      ds_ovfl_callback_t ovfl, enum ds_qualifier qual)
 {
-	struct ds_context *context;
+	struct ds_context *context = NULL;
 	unsigned long buffer, adj;
 	const unsigned long alignment = (1 << 3);
-	int error = 0;
+	int error;
 
 	if (!ds_cfg.sizeof_ds)
 		return -EOPNOTSUPP;
@@ -383,8 +394,9 @@
 
 	spin_lock(&ds_lock);
 
+	error = -EPERM;
 	if (!check_tracer(task))
-		return -EPERM;
+		goto out_unlock;
 
 	error = -ENOMEM;
 	context = ds_alloc_context(task);
@@ -395,7 +407,7 @@
 	if (context->owner[qual] == current)
 		goto out_unlock;
 	error = -EPERM;
-	if (context->owner[qual] != NULL)
+	if (context->owner[qual] != 0)
 		goto out_unlock;
 	context->owner[qual] = current;
 
@@ -445,7 +457,7 @@
 	return error;
 
  out_release:
-	context->owner[qual] = NULL;
+	context->owner[qual] = 0;
 	ds_put_context(context);
 	return error;
 
@@ -460,15 +472,18 @@
 {
 	return ds_request(task, base, size, ovfl, ds_bts);
 }
+EXPORT_SYMBOL(ds_request_bts);
 
 int ds_request_pebs(struct task_struct *task, void *base, size_t size,
 		    ds_ovfl_callback_t ovfl)
 {
 	return ds_request(task, base, size, ovfl, ds_pebs);
 }
+EXPORT_SYMBOL(ds_request_pebs);
 
 static int ds_release(struct task_struct *task, enum ds_qualifier qual)
 {
+	struct mm_struct *mm = current->mm;
 	struct ds_context *context;
 	int error;
 
@@ -477,13 +492,20 @@
 	if (error < 0)
 		goto out;
 
-	kfree(context->buffer[qual]);
-	context->buffer[qual] = 0;
+	if (context->buffer[qual]) {
+		kfree(context->buffer[qual]);
+		context->buffer[qual] = NULL;
 
-	current->mm->total_vm  -= context->pages[qual];
-	current->mm->locked_vm -= context->pages[qual];
-	context->pages[qual] = 0;
-	context->owner[qual] = 0;
+		down_write(&mm->mmap_sem);
+
+		current->mm->total_vm  -= context->pages[qual];
+		current->mm->locked_vm -= context->pages[qual];
+
+		up_write(&mm->mmap_sem);
+
+		context->pages[qual] = 0;
+		context->owner[qual] = 0;
+	}
 
 	/*
 	 * we put the context twice:
@@ -500,11 +522,25 @@
 {
 	return ds_release(task, ds_bts);
 }
+EXPORT_SYMBOL(ds_release_bts);
 
 int ds_release_pebs(struct task_struct *task)
 {
 	return ds_release(task, ds_pebs);
 }
+EXPORT_SYMBOL(ds_release_pebs);
+
+int ds_validate_bts(struct task_struct *task)
+{
+	return ds_validate_access(ds_get_context(task), ds_bts);
+}
+EXPORT_SYMBOL(ds_validate_bts);
+
+int ds_validate_pebs(struct task_struct *task)
+{
+	return ds_validate_access(ds_get_context(task), ds_pebs);
+}
+EXPORT_SYMBOL(ds_validate_pebs);
 
 static int ds_get_index(struct task_struct *task, size_t *pos,
 			enum ds_qualifier qual)
@@ -533,11 +569,13 @@
 {
 	return ds_get_index(task, pos, ds_bts);
 }
+EXPORT_SYMBOL(ds_get_bts_index);
 
 int ds_get_pebs_index(struct task_struct *task, size_t *pos)
 {
 	return ds_get_index(task, pos, ds_pebs);
 }
+EXPORT_SYMBOL(ds_get_pebs_index);
 
 static int ds_get_end(struct task_struct *task, size_t *pos,
 		      enum ds_qualifier qual)
@@ -566,11 +604,13 @@
 {
 	return ds_get_end(task, pos, ds_bts);
 }
+EXPORT_SYMBOL(ds_get_bts_end);
 
 int ds_get_pebs_end(struct task_struct *task, size_t *pos)
 {
 	return ds_get_end(task, pos, ds_pebs);
 }
+EXPORT_SYMBOL(ds_get_pebs_end);
 
 static int ds_access(struct task_struct *task, size_t index,
 		     const void **record, enum ds_qualifier qual)
@@ -605,11 +645,13 @@
 {
 	return ds_access(task, index, record, ds_bts);
 }
+EXPORT_SYMBOL(ds_access_bts);
 
 int ds_access_pebs(struct task_struct *task, size_t index, const void **record)
 {
 	return ds_access(task, index, record, ds_pebs);
 }
+EXPORT_SYMBOL(ds_access_pebs);
 
 static int ds_write(struct task_struct *task, const void *record, size_t size,
 		    enum ds_qualifier qual, int force)
@@ -693,23 +735,27 @@
 {
 	return ds_write(task, record, size, ds_bts, /* force = */ 0);
 }
+EXPORT_SYMBOL(ds_write_bts);
 
 int ds_write_pebs(struct task_struct *task, const void *record, size_t size)
 {
 	return ds_write(task, record, size, ds_pebs, /* force = */ 0);
 }
+EXPORT_SYMBOL(ds_write_pebs);
 
 int ds_unchecked_write_bts(struct task_struct *task,
 			   const void *record, size_t size)
 {
 	return ds_write(task, record, size, ds_bts, /* force = */ 1);
 }
+EXPORT_SYMBOL(ds_unchecked_write_bts);
 
 int ds_unchecked_write_pebs(struct task_struct *task,
 			    const void *record, size_t size)
 {
 	return ds_write(task, record, size, ds_pebs, /* force = */ 1);
 }
+EXPORT_SYMBOL(ds_unchecked_write_pebs);
 
 static int ds_reset_or_clear(struct task_struct *task,
 			     enum ds_qualifier qual, int clear)
@@ -741,21 +787,25 @@
 {
 	return ds_reset_or_clear(task, ds_bts, /* clear = */ 0);
 }
+EXPORT_SYMBOL(ds_reset_bts);
 
 int ds_reset_pebs(struct task_struct *task)
 {
 	return ds_reset_or_clear(task, ds_pebs, /* clear = */ 0);
 }
+EXPORT_SYMBOL(ds_reset_pebs);
 
 int ds_clear_bts(struct task_struct *task)
 {
 	return ds_reset_or_clear(task, ds_bts, /* clear = */ 1);
 }
+EXPORT_SYMBOL(ds_clear_bts);
 
 int ds_clear_pebs(struct task_struct *task)
 {
 	return ds_reset_or_clear(task, ds_pebs, /* clear = */ 1);
 }
+EXPORT_SYMBOL(ds_clear_pebs);
 
 int ds_get_pebs_reset(struct task_struct *task, u64 *value)
 {
@@ -777,6 +827,7 @@
 	ds_put_context(context);
 	return error;
 }
+EXPORT_SYMBOL(ds_get_pebs_reset);
 
 int ds_set_pebs_reset(struct task_struct *task, u64 value)
 {
@@ -795,22 +846,27 @@
 	ds_put_context(context);
 	return error;
 }
+EXPORT_SYMBOL(ds_set_pebs_reset);
 
 static const struct ds_configuration ds_cfg_var = {
 	.sizeof_ds    = sizeof(long) * 12,
 	.sizeof_field = sizeof(long),
 	.sizeof_rec[ds_bts]   = sizeof(long) * 3,
+#ifdef __i386__
 	.sizeof_rec[ds_pebs]  = sizeof(long) * 10
+#else
+	.sizeof_rec[ds_pebs]  = sizeof(long) * 18
+#endif
 };
 static const struct ds_configuration ds_cfg_64 = {
 	.sizeof_ds    = 8 * 12,
 	.sizeof_field = 8,
 	.sizeof_rec[ds_bts]   = 8 * 3,
-	.sizeof_rec[ds_pebs]  = 8 * 10
+	.sizeof_rec[ds_pebs]  = 8 * 18
 };
 
 static inline void
-ds_configure(const struct ds_configuration *cfg)
+ds_init(const struct ds_configuration *cfg)
 {
 	ds_cfg = *cfg;
 }
@@ -822,11 +878,11 @@
 		switch (c->x86_model) {
 		case 0xD:
 		case 0xE: /* Pentium M */
-			ds_configure(&ds_cfg_var);
+			ds_init(&ds_cfg_var);
 			break;
 		case 0xF: /* Core2 */
 		case 0x1C: /* Atom */
-			ds_configure(&ds_cfg_64);
+			ds_init(&ds_cfg_64);
 			break;
 		default:
 			/* sorry, don't know about them */
@@ -838,7 +894,7 @@
 		case 0x0:
 		case 0x1:
 		case 0x2: /* Netburst */
-			ds_configure(&ds_cfg_var);
+			ds_init(&ds_cfg_var);
 			break;
 		default:
 			/* sorry, don't know about them */
@@ -860,4 +916,6 @@
 	while (leftovers--)
 		ds_put_context(context);
 }
+EXPORT_SYMBOL(ds_free);
+
 #endif /* CONFIG_X86_DS */
Index: gits.x86/include/asm-x86/ds.h
===================================================================
--- gits.x86.orig/include/asm-x86/ds.h	2008-04-30 11:18:31.%N +0200
+++ gits.x86/include/asm-x86/ds.h	2008-04-30 12:24:17.%N +0200
@@ -67,6 +67,18 @@
 extern int ds_release_pebs(struct task_struct *task);
 
 /*
+ * Validate that the current task is allowed to access the BTS or PEBS
+ * resources.
+ *
+ * Returns 0 on success; -Eerrno otherwise
+ *
+ * task: the task to validate ownership for;
+ *       NULL to validate for the current cpu
+ */
+extern int ds_validate_bts(struct task_struct *task);
+extern int ds_validate_pebs(struct task_struct *task);
+
+/*
  * Return the (array) index of the write pointer.
  * (assuming an array of BTS/PEBS records)
  *
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

