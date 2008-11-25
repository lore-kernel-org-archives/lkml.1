Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbYKYIBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbYKYIBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbYKYIBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:01:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:3921 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbYKYIBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:01:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,663,1220252400"; 
   d="scan'208";a="643314424"
Date: Tue, 25 Nov 2008 09:01:25 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: [patch 5/9] x86, bts: base in-kernel ds interface on handles
Message-ID: <20081125090125.A31137@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the in-kernel ds.h interface to identify the tracer via a
handle returned on ds_request_~().

Tracers used to be identified via their task_struct.

The changes are required to allow DS to be shared between different
tasks, which is needed for perfmon2 and for ftrace.

For ptrace, the handle is stored in the traced task's task_struct.
This should probably go into a (arch-specific) ptrace context some
time.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/arch/x86/include/asm/ds.h
===================================================================
--- ftrace.orig/arch/x86/include/asm/ds.h	2008-11-25 08:17:48.000000000 +0100
+++ ftrace/arch/x86/include/asm/ds.h	2008-11-25 08:18:01.000000000 +0100
@@ -26,11 +26,18 @@
 
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/err.h>
 
 
 #ifdef CONFIG_X86_DS
 
 struct task_struct;
+struct ds_tracer;
+struct bts_tracer;
+struct pebs_tracer;
+
+typedef void (*bts_ovfl_callback_t)(struct bts_tracer *);
+typedef void (*pebs_ovfl_callback_t)(struct pebs_tracer *);
 
 /*
  * Request BTS or PEBS
@@ -38,21 +45,29 @@
  * Due to alignement constraints, the actual buffer may be slightly
  * smaller than the requested or provided buffer.
  *
- * Returns 0 on success; -Eerrno otherwise
+ * Returns a pointer to a tracer structure on success, or
+ * ERR_PTR(errcode) on failure.
+ *
+ * The interrupt threshold is independent from the overflow callback
+ * to allow users to use their own overflow interrupt handling mechanism.
  *
  * task: the task to request recording for;
  *       NULL for per-cpu recording on the current cpu
  * base: the base pointer for the (non-pageable) buffer;
  *       NULL if buffer allocation requested
- * size: the size of the requested or provided buffer
+ * size: the size of the requested or provided buffer in bytes
  * ovfl: pointer to a function to be called on buffer overflow;
  *       NULL if cyclic buffer requested
+ * th: the interrupt threshold in records from the end of the buffer;
+ *     -1 if no interrupt threshold is requested.
  */
-typedef void (*ds_ovfl_callback_t)(struct task_struct *);
-extern int ds_request_bts(struct task_struct *task, void *base, size_t size,
-			  ds_ovfl_callback_t ovfl);
-extern int ds_request_pebs(struct task_struct *task, void *base, size_t size,
-			   ds_ovfl_callback_t ovfl);
+extern struct bts_tracer *ds_request_bts(struct task_struct *task,
+					 void *base, size_t size,
+					 bts_ovfl_callback_t ovfl, size_t th);
+extern struct pebs_tracer *ds_request_pebs(struct task_struct *task,
+					   void *base, size_t size,
+					   pebs_ovfl_callback_t ovfl,
+					   size_t th);
 
 /*
  * Release BTS or PEBS resources
@@ -61,37 +76,34 @@
  *
  * Returns 0 on success; -Eerrno otherwise
  *
- * task: the task to release resources for;
- *       NULL to release resources for the current cpu
+ * tracer: the tracer handle returned from ds_request_~()
  */
-extern int ds_release_bts(struct task_struct *task);
-extern int ds_release_pebs(struct task_struct *task);
+extern int ds_release_bts(struct bts_tracer *tracer);
+extern int ds_release_pebs(struct pebs_tracer *tracer);
 
 /*
- * Return the (array) index of the write pointer.
+ * Get the (array) index of the write pointer.
  * (assuming an array of BTS/PEBS records)
  *
- * Returns -Eerrno on error
+ * Returns 0 on success; -Eerrno on error
  *
- * task: the task to access;
- *       NULL to access the current cpu
- * pos (out): if not NULL, will hold the result
+ * tracer: the tracer handle returned from ds_request_~()
+ * pos (out): will hold the result
  */
-extern int ds_get_bts_index(struct task_struct *task, size_t *pos);
-extern int ds_get_pebs_index(struct task_struct *task, size_t *pos);
+extern int ds_get_bts_index(struct bts_tracer *tracer, size_t *pos);
+extern int ds_get_pebs_index(struct pebs_tracer *tracer, size_t *pos);
 
 /*
- * Return the (array) index one record beyond the end of the array.
+ * Get the (array) index one record beyond the end of the array.
  * (assuming an array of BTS/PEBS records)
  *
- * Returns -Eerrno on error
+ * Returns 0 on success; -Eerrno on error
  *
- * task: the task to access;
- *       NULL to access the current cpu
- * pos (out): if not NULL, will hold the result
+ * tracer: the tracer handle returned from ds_request_~()
+ * pos (out): will hold the result
  */
-extern int ds_get_bts_end(struct task_struct *task, size_t *pos);
-extern int ds_get_pebs_end(struct task_struct *task, size_t *pos);
+extern int ds_get_bts_end(struct bts_tracer *tracer, size_t *pos);
+extern int ds_get_pebs_end(struct pebs_tracer *tracer, size_t *pos);
 
 /*
  * Provide a pointer to the BTS/PEBS record at parameter index.
@@ -102,14 +114,13 @@
  *
  * Returns the size of a single record on success; -Eerrno on error
  *
- * task: the task to access;
- *       NULL to access the current cpu
+ * tracer: the tracer handle returned from ds_request_~()
  * index: the index of the requested record
  * record (out): pointer to the requested record
  */
-extern int ds_access_bts(struct task_struct *task,
+extern int ds_access_bts(struct bts_tracer *tracer,
 			 size_t index, const void **record);
-extern int ds_access_pebs(struct task_struct *task,
+extern int ds_access_pebs(struct pebs_tracer *tracer,
 			  size_t index, const void **record);
 
 /*
@@ -129,38 +140,24 @@
  *
  * Returns the number of bytes written or -Eerrno.
  *
- * task: the task to access;
- *       NULL to access the current cpu
+ * tracer: the tracer handle returned from ds_request_~()
  * buffer: the buffer to write
  * size: the size of the buffer
  */
-extern int ds_write_bts(struct task_struct *task,
+extern int ds_write_bts(struct bts_tracer *tracer,
 			const void *buffer, size_t size);
-extern int ds_write_pebs(struct task_struct *task,
+extern int ds_write_pebs(struct pebs_tracer *tracer,
 			 const void *buffer, size_t size);
 
 /*
- * Same as ds_write_bts/pebs, but omit ownership checks.
- *
- * This is needed to have some other task than the owner of the
- * BTS/PEBS buffer or the parameter task itself write into the
- * respective buffer.
- */
-extern int ds_unchecked_write_bts(struct task_struct *task,
-				  const void *buffer, size_t size);
-extern int ds_unchecked_write_pebs(struct task_struct *task,
-				   const void *buffer, size_t size);
-
-/*
  * Reset the write pointer of the BTS/PEBS buffer.
  *
  * Returns 0 on success; -Eerrno on error
  *
- * task: the task to access;
- *       NULL to access the current cpu
+ * tracer: the tracer handle returned from ds_request_~()
  */
-extern int ds_reset_bts(struct task_struct *task);
-extern int ds_reset_pebs(struct task_struct *task);
+extern int ds_reset_bts(struct bts_tracer *tracer);
+extern int ds_reset_pebs(struct pebs_tracer *tracer);
 
 /*
  * Clear the BTS/PEBS buffer and reset the write pointer.
@@ -168,33 +165,30 @@
  *
  * Returns 0 on success; -Eerrno on error
  *
- * task: the task to access;
- *       NULL to access the current cpu
+ * tracer: the tracer handle returned from ds_request_~()
  */
-extern int ds_clear_bts(struct task_struct *task);
-extern int ds_clear_pebs(struct task_struct *task);
+extern int ds_clear_bts(struct bts_tracer *tracer);
+extern int ds_clear_pebs(struct pebs_tracer *tracer);
 
 /*
  * Provide the PEBS counter reset value.
  *
  * Returns 0 on success; -Eerrno on error
  *
- * task: the task to access;
- *       NULL to access the current cpu
+ * tracer: the tracer handle returned from ds_request_pebs()
  * value (out): the counter reset value
  */
-extern int ds_get_pebs_reset(struct task_struct *task, u64 *value);
+extern int ds_get_pebs_reset(struct pebs_tracer *tracer, u64 *value);
 
 /*
  * Set the PEBS counter reset value.
  *
  * Returns 0 on success; -Eerrno on error
  *
- * task: the task to access;
- *       NULL to access the current cpu
+ * tracer: the tracer handle returned from ds_request_pebs()
  * value: the new counter reset value
  */
-extern int ds_set_pebs_reset(struct task_struct *task, u64 value);
+extern int ds_set_pebs_reset(struct pebs_tracer *tracer, u64 value);
 
 /*
  * Initialization
@@ -207,17 +201,13 @@
 /*
  * The DS context - part of struct thread_struct.
  */
+#define MAX_SIZEOF_DS (12 * 8)
+
 struct ds_context {
 	/* pointer to the DS configuration; goes into MSR_IA32_DS_AREA */
-	unsigned char *ds;
+	unsigned char ds[MAX_SIZEOF_DS];
 	/* the owner of the BTS and PEBS configuration, respectively */
-	struct task_struct *owner[2];
-	/* buffer overflow notification function for BTS and PEBS */
-	ds_ovfl_callback_t callback[2];
-	/* the original buffer address */
-	void *buffer[2];
-	/* the number of allocated pages for on-request allocated buffers */
-	unsigned int pages[2];
+	struct ds_tracer  *owner[2];
 	/* use count */
 	unsigned long count;
 	/* a pointer to the context location inside the thread_struct
Index: ftrace/include/linux/sched.h
===================================================================
--- ftrace.orig/include/linux/sched.h	2008-11-25 08:17:07.000000000 +0100
+++ ftrace/include/linux/sched.h	2008-11-25 08:18:01.000000000 +0100
@@ -96,6 +96,7 @@
 struct futex_pi_state;
 struct robust_list_head;
 struct bio;
+struct bts_tracer;
 
 /*
  * List of flags we want to share for kernel threads,
@@ -1158,6 +1159,14 @@
 	struct list_head ptraced;
 	struct list_head ptrace_entry;
 
+#ifdef CONFIG_X86_PTRACE_BTS
+	/*
+	 * This is the tracer handle for the ptrace BTS extension.
+	 * This field actually belongs to the ptracer task.
+	 */
+	struct bts_tracer *bts;
+#endif /* CONFIG_X86_PTRACE_BTS */
+
 	/* PID/PID hash table linkage. */
 	struct pid_link pids[PIDTYPE_MAX];
 	struct list_head thread_group;
Index: ftrace/arch/x86/kernel/ptrace.c
===================================================================
--- ftrace.orig/arch/x86/kernel/ptrace.c	2008-11-25 08:17:07.000000000 +0100
+++ ftrace/arch/x86/kernel/ptrace.c	2008-11-25 08:18:01.000000000 +0100
@@ -668,14 +668,14 @@
 	size_t bts_index, bts_end;
 	int error;
 
-	error = ds_get_bts_end(child, &bts_end);
+	error = ds_get_bts_end(child->bts, &bts_end);
 	if (error < 0)
 		return error;
 
 	if (bts_end <= index)
 		return -EINVAL;
 
-	error = ds_get_bts_index(child, &bts_index);
+	error = ds_get_bts_index(child->bts, &bts_index);
 	if (error < 0)
 		return error;
 
@@ -684,7 +684,7 @@
 	if (bts_end <= bts_index)
 		bts_index -= bts_end;
 
-	error = ds_access_bts(child, bts_index, &bts_record);
+	error = ds_access_bts(child->bts, bts_index, &bts_record);
 	if (error < 0)
 		return error;
 
@@ -705,14 +705,14 @@
 	size_t end, i;
 	int error;
 
-	error = ds_get_bts_index(child, &end);
+	error = ds_get_bts_index(child->bts, &end);
 	if (error < 0)
 		return error;
 
 	if (size < (end * sizeof(struct bts_struct)))
 		return -EIO;
 
-	error = ds_access_bts(child, 0, (const void **)&raw);
+	error = ds_access_bts(child->bts, 0, (const void **)&raw);
 	if (error < 0)
 		return error;
 
@@ -723,18 +723,13 @@
 			return -EFAULT;
 	}
 
-	error = ds_clear_bts(child);
+	error = ds_clear_bts(child->bts);
 	if (error < 0)
 		return error;
 
 	return end;
 }
 
-static void ptrace_bts_ovfl(struct task_struct *child)
-{
-	send_sig(child->thread.bts_ovfl_signal, child, 0);
-}
-
 static int ptrace_bts_config(struct task_struct *child,
 			     long cfg_size,
 			     const struct ptrace_bts_config __user *ucfg)
@@ -760,23 +755,29 @@
 		goto errout;
 
 	if (cfg.flags & PTRACE_BTS_O_ALLOC) {
-		ds_ovfl_callback_t ovfl = NULL;
+		bts_ovfl_callback_t ovfl = NULL;
 		unsigned int sig = 0;
 
-		/* we ignore the error in case we were not tracing child */
-		(void)ds_release_bts(child);
-
 		if (cfg.flags & PTRACE_BTS_O_SIGNAL) {
 			if (!cfg.signal)
 				goto errout;
 
+			error = -EOPNOTSUPP;
+			goto errout;
+
 			sig  = cfg.signal;
-			ovfl = ptrace_bts_ovfl;
 		}
 
-		error = ds_request_bts(child, /* base = */ NULL, cfg.size, ovfl);
-		if (error < 0)
+		if (child->bts)
+			(void)ds_release_bts(child->bts);
+
+		child->bts = ds_request_bts(child, /* base = */ NULL, cfg.size,
+					    ovfl, /* th = */ (size_t)-1);
+		if (IS_ERR(child->bts)) {
+			error = PTR_ERR(child->bts);
+			child->bts = NULL;
 			goto errout;
+		}
 
 		child->thread.bts_ovfl_signal = sig;
 	}
@@ -823,15 +824,15 @@
 	if (cfg_size < sizeof(cfg))
 		return -EIO;
 
-	error = ds_get_bts_end(child, &end);
+	error = ds_get_bts_end(child->bts, &end);
 	if (error < 0)
 		return error;
 
-	error = ds_access_bts(child, /* index = */ 0, &base);
+	error = ds_access_bts(child->bts, /* index = */ 0, &base);
 	if (error < 0)
 		return error;
 
-	error = ds_access_bts(child, /* index = */ end, &max);
+	error = ds_access_bts(child->bts, /* index = */ end, &max);
 	if (error < 0)
 		return error;
 
@@ -884,10 +885,7 @@
 		return -EINVAL;
 	}
 
-	/* The writing task will be the switched-to task on a context
-	 * switch. It needs to write into the switched-from task's BTS
-	 * buffer. */
-	return ds_unchecked_write_bts(child, bts_record, bts_cfg.sizeof_bts);
+	return ds_write_bts(child->bts, bts_record, bts_cfg.sizeof_bts);
 }
 
 void ptrace_bts_take_timestamp(struct task_struct *tsk,
@@ -972,13 +970,15 @@
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 #endif
 #ifdef CONFIG_X86_PTRACE_BTS
-	(void)ds_release_bts(child);
+	if (child->bts) {
+		(void)ds_release_bts(child->bts);
 
-	child->thread.debugctlmsr &= ~bts_cfg.debugctl_mask;
-	if (!child->thread.debugctlmsr)
-		clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
+		child->thread.debugctlmsr &= ~bts_cfg.debugctl_mask;
+		if (!child->thread.debugctlmsr)
+			clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
 
-	clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
+		clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
+	}
 #endif /* CONFIG_X86_PTRACE_BTS */
 }
 
@@ -1110,9 +1110,16 @@
 			(child, data, (struct ptrace_bts_config __user *)addr);
 		break;
 
-	case PTRACE_BTS_SIZE:
-		ret = ds_get_bts_index(child, /* pos = */ NULL);
+	case PTRACE_BTS_SIZE: {
+		size_t size;
+
+		ret = ds_get_bts_index(child->bts, &size);
+		if (ret == 0) {
+			BUG_ON(size != (int) size);
+			ret = (int) size;
+		}
 		break;
+	}
 
 	case PTRACE_BTS_GET:
 		ret = ptrace_bts_read_record
@@ -1120,7 +1127,7 @@
 		break;
 
 	case PTRACE_BTS_CLEAR:
-		ret = ds_clear_bts(child);
+		ret = ds_clear_bts(child->bts);
 		break;
 
 	case PTRACE_BTS_DRAIN:
Index: ftrace/arch/x86/kernel/ds.c
===================================================================
--- ftrace.orig/arch/x86/kernel/ds.c	2008-11-25 08:17:59.000000000 +0100
+++ ftrace/arch/x86/kernel/ds.c	2008-11-25 08:18:01.000000000 +0100
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/kernel.h>
 
 
 /*
@@ -44,6 +45,35 @@
 };
 static struct ds_configuration ds_cfg;
 
+/*
+ * A BTS or PEBS tracer.
+ *
+ * This holds the configuration of the tracer and serves as a handle
+ * to identify tracers.
+ */
+struct ds_tracer {
+	/* the DS context (partially) owned by this tracer */
+	struct ds_context *context;
+	/* the buffer provided on ds_request() and its size in bytes */
+	void *buffer;
+	size_t size;
+	/* the number of allocated pages for on-request allocated buffers */
+	unsigned int pages;
+};
+
+struct bts_tracer {
+	/* the common DS part */
+	struct ds_tracer ds;
+	/* buffer overflow notification function */
+	bts_ovfl_callback_t ovfl;
+};
+
+struct pebs_tracer {
+	/* the common DS part */
+	struct ds_tracer ds;
+	/* buffer overflow notification function */
+	pebs_ovfl_callback_t ovfl;
+};
 
 /*
  * Debug Store (DS) save area configuration (see Intel64 and IA32
@@ -107,35 +137,15 @@
 	(*(unsigned long *)base) = value;
 }
 
+#define DS_ALIGNMENT (1 << 3)	/* BTS and PEBS buffer alignment */
+
 
 /*
  * Locking is done only for allocating BTS or PEBS resources and for
  * guarding context and buffer memory allocation.
- *
- * Most functions require the current task to own the ds context part
- * they are going to access. All the locking is done when validating
- * access to the context.
  */
 static spinlock_t ds_lock = __SPIN_LOCK_UNLOCKED(ds_lock);
 
-/*
- * Validate that the current task is allowed to access the BTS/PEBS
- * buffer of the parameter task.
- *
- * Returns 0, if access is granted; -Eerrno, otherwise.
- */
-static inline int ds_validate_access(struct ds_context *context,
-				     enum ds_qualifier qual)
-{
-	if (!context)
-		return -EPERM;
-
-	if (context->owner[qual] == current)
-		return 0;
-
-	return -EPERM;
-}
-
 
 /*
  * We either support (system-wide) per-cpu or per-thread allocation.
@@ -183,51 +193,13 @@
  *
  * Contexts are use-counted. They are allocated on first access and
  * deallocated when the last user puts the context.
- *
- * We distinguish between an allocating and a non-allocating get of a
- * context:
- * - the allocating get is used for requesting BTS/PEBS resources. It
- *   requires the caller to hold the global ds_lock.
- * - the non-allocating get is used for all other cases. A
- *   non-existing context indicates an error. It acquires and releases
- *   the ds_lock itself for obtaining the context.
- *
- * A context and its DS configuration are allocated and deallocated
- * together. A context always has a DS configuration of the
- * appropriate size.
  */
 static DEFINE_PER_CPU(struct ds_context *, system_context);
 
 #define this_system_context per_cpu(system_context, smp_processor_id())
 
-/*
- * Returns the pointer to the parameter task's context or to the
- * system-wide context, if task is NULL.
- *
- * Increases the use count of the returned context, if not NULL.
- */
 static inline struct ds_context *ds_get_context(struct task_struct *task)
 {
-	struct ds_context *context;
-	unsigned long irq;
-
-	spin_lock_irqsave(&ds_lock, irq);
-
-	context = (task ? task->thread.ds_ctx : this_system_context);
-	if (context)
-		context->count++;
-
-	spin_unlock_irqrestore(&ds_lock, irq);
-
-	return context;
-}
-
-/*
- * Same as ds_get_context, but allocates the context and it's DS
- * structure, if necessary; returns NULL; if out of memory.
- */
-static inline struct ds_context *ds_alloc_context(struct task_struct *task)
-{
 	struct ds_context **p_context =
 		(task ? &task->thread.ds_ctx : &this_system_context);
 	struct ds_context *context = *p_context;
@@ -238,16 +210,9 @@
 		if (!context)
 			return NULL;
 
-		context->ds = kzalloc(ds_cfg.sizeof_ds, GFP_KERNEL);
-		if (!context->ds) {
-			kfree(context);
-			return NULL;
-		}
-
 		spin_lock_irqsave(&ds_lock, irq);
 
 		if (*p_context) {
-			kfree(context->ds);
 			kfree(context);
 
 			context = *p_context;
@@ -272,10 +237,6 @@
 	return context;
 }
 
-/*
- * Decreases the use count of the parameter context, if not NULL.
- * Deallocates the context, if the use count reaches zero.
- */
 static inline void ds_put_context(struct ds_context *context)
 {
 	unsigned long irq;
@@ -296,13 +257,6 @@
 	if (!context->task || (context->task == current))
 		wrmsrl(MSR_IA32_DS_AREA, 0);
 
-	put_tracer(context->task);
-
-	/* free any leftover buffers from tracers that did not
-	 * deallocate them properly. */
-	kfree(context->buffer[ds_bts]);
-	kfree(context->buffer[ds_pebs]);
-	kfree(context->ds);
 	kfree(context);
  out:
 	spin_unlock_irqrestore(&ds_lock, irq);
@@ -312,21 +266,29 @@
 /*
  * Handle a buffer overflow
  *
- * task: the task whose buffers are overflowing;
- *       NULL for a buffer overflow on the current cpu
  * context: the ds context
  * qual: the buffer type
  */
-static void ds_overflow(struct task_struct *task, struct ds_context *context,
-			enum ds_qualifier qual)
+static void ds_overflow(struct ds_context *context, enum ds_qualifier qual)
 {
-	if (!context)
-		return;
-
-	if (context->callback[qual])
-		(*context->callback[qual])(task);
-
-	/* todo: do some more overflow handling */
+	switch (qual) {
+	case ds_bts: {
+		struct bts_tracer *tracer =
+			container_of(context->owner[qual],
+				     struct bts_tracer, ds);
+		if (tracer->ovfl)
+			tracer->ovfl(tracer);
+	}
+		break;
+	case ds_pebs: {
+		struct pebs_tracer *tracer =
+			container_of(context->owner[qual],
+				     struct pebs_tracer, ds);
+		if (tracer->ovfl)
+			tracer->ovfl(tracer);
+	}
+		break;
+	}
 }
 
 
@@ -343,23 +305,25 @@
 static inline void *ds_allocate_buffer(size_t size, unsigned int *pages)
 {
 	unsigned long rlim, vm, pgsz;
-	void *buffer;
+	void *buffer = NULL;
 
 	pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
+	down_write(&current->mm->mmap_sem);
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
@@ -367,290 +331,337 @@
 	if (pages)
 		*pages = pgsz;
 
+ out:
+	up_write(&current->mm->mmap_sem);
 	return buffer;
 }
 
-static int ds_request(struct task_struct *task, void *base, size_t size,
-		      ds_ovfl_callback_t ovfl, enum ds_qualifier qual)
+static void ds_install_ds_config(struct ds_context *context,
+				 enum ds_qualifier qual,
+				 void *base, size_t size, size_t ith)
 {
-	struct ds_context *context;
 	unsigned long buffer, adj;
-	const unsigned long alignment = (1 << 3);
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
+	adj = ALIGN(buffer, DS_ALIGNMENT) - buffer;
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
+	/* The value for 'no threshold' is -1, which will set the
+	 * threshold outside of the buffer, just like we want it.
+	 */
+	ds_set(context->ds, qual,
+	       ds_interrupt_threshold, buffer + size - ith);
+}
+
+static int ds_request(struct ds_tracer *tracer, enum ds_qualifier qual,
+		      struct task_struct *task,
+		      void *base, size_t size, size_t th)
+{
+	struct ds_context *context;
 	unsigned long irq;
-	int error = 0;
+	int error;
 
+	error = -EOPNOTSUPP;
 	if (!ds_cfg.sizeof_ds)
-		return -EOPNOTSUPP;
+		goto out;
 
 	/* we require some space to do alignment adjustments below */
-	if (size < (alignment + ds_cfg.sizeof_rec[qual]))
-		return -EINVAL;
+	error = -EINVAL;
+	if (size < (DS_ALIGNMENT + ds_cfg.sizeof_rec[qual]))
+		goto out;
 
-	/* buffer overflow notification is not yet implemented */
-	if (ovfl)
-		return -EOPNOTSUPP;
+	if (th != (size_t)-1) {
+		th *= ds_cfg.sizeof_rec[qual];
 
+		error = -EINVAL;
+		if (size <= th)
+			goto out;
+	}
 
-	context = ds_alloc_context(task);
+	error = -ENOMEM;
+	if (!base) {
+		base = ds_allocate_buffer(size, &tracer->pages);
+		if (!base)
+			goto out;
+	}
+
+	tracer->buffer = base;
+	tracer->size = size;
+
+	error = -ENOMEM;
+	context = ds_get_context(task);
 	if (!context)
-		return -ENOMEM;
+		goto out;
+	tracer->context = context;
+
 
 	spin_lock_irqsave(&ds_lock, irq);
 
 	error = -EPERM;
 	if (!check_tracer(task))
 		goto out_unlock;
-
 	get_tracer(task);
 
-	error = -EALREADY;
-	if (context->owner[qual] == current)
-		goto out_put_tracer;
 	error = -EPERM;
-	if (context->owner[qual] != NULL)
+	if (context->owner[qual])
 		goto out_put_tracer;
-	context->owner[qual] = current;
+	context->owner[qual] = tracer;
 
 	spin_unlock_irqrestore(&ds_lock, irq);
 
 
-	error = -ENOMEM;
-	if (!base) {
-		base = ds_allocate_buffer(size, &context->pages[qual]);
-		if (!base)
-			goto out_release;
-
-		context->buffer[qual]   = base;
-	}
-	error = 0;
-
-	context->callback[qual] = ovfl;
-
-	/* adjust the buffer address and size to meet alignment
-	 * constraints:
-	 * - buffer is double-word aligned
-	 * - size is multiple of record size
-	 *
-	 * We checked the size at the very beginning; we have enough
-	 * space to do the adjustment.
-	 */
-	buffer = (unsigned long)base;
-
-	adj = ALIGN(buffer, alignment) - buffer;
-	buffer += adj;
-	size   -= adj;
-
-	size /= ds_cfg.sizeof_rec[qual];
-	size *= ds_cfg.sizeof_rec[qual];
-
-	ds_set(context->ds, qual, ds_buffer_base, buffer);
-	ds_set(context->ds, qual, ds_index, buffer);
-	ds_set(context->ds, qual, ds_absolute_maximum, buffer + size);
+	ds_install_ds_config(context, qual, base, size, th);
 
-	if (ovfl) {
-		/* todo: select a suitable interrupt threshold */
-	} else
-		ds_set(context->ds, qual,
-		       ds_interrupt_threshold, buffer + size + 1);
-
-	/* we keep the context until ds_release */
-	return error;
-
- out_release:
-	context->owner[qual] = NULL;
-	ds_put_context(context);
-	put_tracer(task);
-	return error;
+	return 0;
 
  out_put_tracer:
-	spin_unlock_irqrestore(&ds_lock, irq);
-	ds_put_context(context);
 	put_tracer(task);
-	return error;
-
  out_unlock:
 	spin_unlock_irqrestore(&ds_lock, irq);
 	ds_put_context(context);
+	tracer->context = NULL;
+ out:
 	return error;
 }
 
-int ds_request_bts(struct task_struct *task, void *base, size_t size,
-		   ds_ovfl_callback_t ovfl)
+struct bts_tracer *ds_request_bts(struct task_struct *task,
+				  void *base, size_t size,
+				  bts_ovfl_callback_t ovfl, size_t th)
 {
-	return ds_request(task, base, size, ovfl, ds_bts);
-}
+	struct bts_tracer *tracer;
+	int error;
 
-int ds_request_pebs(struct task_struct *task, void *base, size_t size,
-		    ds_ovfl_callback_t ovfl)
-{
-	return ds_request(task, base, size, ovfl, ds_pebs);
+	/* buffer overflow notification is not yet implemented */
+	error = -EOPNOTSUPP;
+	if (ovfl)
+		goto out;
+
+	error = -ENOMEM;
+	tracer = kzalloc(sizeof(*tracer), GFP_KERNEL);
+	if (!tracer)
+		goto out;
+	tracer->ovfl = ovfl;
+
+	error = ds_request(&tracer->ds, ds_bts, task, base, size, th);
+	if (error < 0)
+		goto out_tracer;
+
+	return tracer;
+
+ out_tracer:
+	(void)ds_release_bts(tracer);
+ out:
+	return ERR_PTR(error);
 }
 
-static int ds_release(struct task_struct *task, enum ds_qualifier qual)
+struct pebs_tracer *ds_request_pebs(struct task_struct *task,
+				    void *base, size_t size,
+				    pebs_ovfl_callback_t ovfl, size_t th)
 {
-	struct ds_context *context;
+	struct pebs_tracer *tracer;
 	int error;
 
-	context = ds_get_context(task);
-	error = ds_validate_access(context, qual);
-	if (error < 0)
+	/* buffer overflow notification is not yet implemented */
+	error = -EOPNOTSUPP;
+	if (ovfl)
+		goto out;
+
+	error = -ENOMEM;
+	tracer = kzalloc(sizeof(*tracer), GFP_KERNEL);
+	if (!tracer)
 		goto out;
+	tracer->ovfl = ovfl;
 
-	kfree(context->buffer[qual]);
-	context->buffer[qual] = NULL;
+	error = ds_request(&tracer->ds, ds_pebs, task, base, size, th);
+	if (error < 0)
+		goto out_tracer;
 
-	current->mm->total_vm  -= context->pages[qual];
-	current->mm->locked_vm -= context->pages[qual];
-	context->pages[qual] = 0;
-	context->owner[qual] = NULL;
-
-	/*
-	 * we put the context twice:
-	 *   once for the ds_get_context
-	 *   once for the corresponding ds_request
-	 */
-	ds_put_context(context);
+	return tracer;
+
+ out_tracer:
+	(void)ds_release_pebs(tracer);
  out:
-	ds_put_context(context);
-	return error;
+	return ERR_PTR(error);
+}
+
+static void ds_release(struct ds_tracer *tracer, enum ds_qualifier qual)
+{
+	if (tracer->context) {
+		BUG_ON(tracer->context->owner[qual] != tracer);
+		tracer->context->owner[qual] = NULL;
+
+		put_tracer(tracer->context->task);
+		ds_put_context(tracer->context);
+	}
+
+	if (tracer->pages) {
+		kfree(tracer->buffer);
+
+		down_write(&current->mm->mmap_sem);
+
+		current->mm->total_vm  -= tracer->pages;
+		current->mm->locked_vm -= tracer->pages;
+
+		up_write(&current->mm->mmap_sem);
+	}
 }
 
-int ds_release_bts(struct task_struct *task)
+int ds_release_bts(struct bts_tracer *tracer)
 {
-	return ds_release(task, ds_bts);
+	if (!tracer)
+		return -EINVAL;
+
+	ds_release(&tracer->ds, ds_bts);
+	kfree(tracer);
+
+	return 0;
 }
 
-int ds_release_pebs(struct task_struct *task)
+int ds_release_pebs(struct pebs_tracer *tracer)
 {
-	return ds_release(task, ds_pebs);
+	if (!tracer)
+		return -EINVAL;
+
+	ds_release(&tracer->ds, ds_pebs);
+	kfree(tracer);
+
+	return 0;
 }
 
-static int ds_get_index(struct task_struct *task, size_t *pos,
-			enum ds_qualifier qual)
+static size_t ds_get_index(struct ds_context *context, enum ds_qualifier qual)
 {
-	struct ds_context *context;
 	unsigned long base, index;
-	int error;
-
-	context = ds_get_context(task);
-	error = ds_validate_access(context, qual);
-	if (error < 0)
-		goto out;
 
 	base  = ds_get(context->ds, qual, ds_buffer_base);
 	index = ds_get(context->ds, qual, ds_index);
 
-	error = ((index - base) / ds_cfg.sizeof_rec[qual]);
-	if (pos)
-		*pos = error;
- out:
-	ds_put_context(context);
-	return error;
+	return (index - base) / ds_cfg.sizeof_rec[qual];
 }
 
-int ds_get_bts_index(struct task_struct *task, size_t *pos)
+int ds_get_bts_index(struct bts_tracer *tracer, size_t *pos)
 {
-	return ds_get_index(task, pos, ds_bts);
+	if (!tracer)
+		return -EINVAL;
+
+	if (!pos)
+		return -EINVAL;
+
+	*pos = ds_get_index(tracer->ds.context, ds_bts);
+
+	return 0;
 }
 
-int ds_get_pebs_index(struct task_struct *task, size_t *pos)
+int ds_get_pebs_index(struct pebs_tracer *tracer, size_t *pos)
 {
-	return ds_get_index(task, pos, ds_pebs);
+	if (!tracer)
+		return -EINVAL;
+
+	if (!pos)
+		return -EINVAL;
+
+	*pos = ds_get_index(tracer->ds.context, ds_pebs);
+
+	return 0;
 }
 
-static int ds_get_end(struct task_struct *task, size_t *pos,
-		      enum ds_qualifier qual)
+static size_t ds_get_end(struct ds_context *context, enum ds_qualifier qual)
 {
-	struct ds_context *context;
-	unsigned long base, end;
-	int error;
-
-	context = ds_get_context(task);
-	error = ds_validate_access(context, qual);
-	if (error < 0)
-		goto out;
+	unsigned long base, max;
 
 	base = ds_get(context->ds, qual, ds_buffer_base);
-	end  = ds_get(context->ds, qual, ds_absolute_maximum);
+	max  = ds_get(context->ds, qual, ds_absolute_maximum);
 
-	error = ((end - base) / ds_cfg.sizeof_rec[qual]);
-	if (pos)
-		*pos = error;
- out:
-	ds_put_context(context);
-	return error;
+	return (max - base) / ds_cfg.sizeof_rec[qual];
 }
 
-int ds_get_bts_end(struct task_struct *task, size_t *pos)
+int ds_get_bts_end(struct bts_tracer *tracer, size_t *pos)
 {
-	return ds_get_end(task, pos, ds_bts);
+	if (!tracer)
+		return -EINVAL;
+
+	if (!pos)
+		return -EINVAL;
+
+	*pos = ds_get_end(tracer->ds.context, ds_bts);
+
+	return 0;
 }
 
-int ds_get_pebs_end(struct task_struct *task, size_t *pos)
+int ds_get_pebs_end(struct pebs_tracer *tracer, size_t *pos)
 {
-	return ds_get_end(task, pos, ds_pebs);
+	if (!tracer)
+		return -EINVAL;
+
+	if (!pos)
+		return -EINVAL;
+
+	*pos = ds_get_end(tracer->ds.context, ds_pebs);
+
+	return 0;
 }
 
-static int ds_access(struct task_struct *task, size_t index,
-		     const void **record, enum ds_qualifier qual)
+static int ds_access(struct ds_context *context, enum ds_qualifier qual,
+		     size_t index, const void **record)
 {
-	struct ds_context *context;
 	unsigned long base, idx;
-	int error;
 
 	if (!record)
 		return -EINVAL;
 
-	context = ds_get_context(task);
-	error = ds_validate_access(context, qual);
-	if (error < 0)
-		goto out;
-
 	base = ds_get(context->ds, qual, ds_buffer_base);
 	idx = base + (index * ds_cfg.sizeof_rec[qual]);
 
-	error = -EINVAL;
 	if (idx > ds_get(context->ds, qual, ds_absolute_maximum))
-		goto out;
+		return -EINVAL;
 
 	*record = (const void *)idx;
-	error = ds_cfg.sizeof_rec[qual];
- out:
-	ds_put_context(context);
-	return error;
+
+	return ds_cfg.sizeof_rec[qual];
 }
 
-int ds_access_bts(struct task_struct *task, size_t index, const void **record)
+int ds_access_bts(struct bts_tracer *tracer, size_t index,
+		  const void **record)
 {
-	return ds_access(task, index, record, ds_bts);
+	if (!tracer)
+		return -EINVAL;
+
+	return ds_access(tracer->ds.context, ds_bts, index, record);
 }
 
-int ds_access_pebs(struct task_struct *task, size_t index, const void **record)
+int ds_access_pebs(struct pebs_tracer *tracer, size_t index,
+		   const void **record)
 {
-	return ds_access(task, index, record, ds_pebs);
+	if (!tracer)
+		return -EINVAL;
+
+	return ds_access(tracer->ds.context, ds_pebs, index, record);
 }
 
-static int ds_write(struct task_struct *task, const void *record, size_t size,
-		    enum ds_qualifier qual, int force)
+static int ds_write(struct ds_context *context, enum ds_qualifier qual,
+		    const void *record, size_t size)
 {
-	struct ds_context *context;
-	int error;
+	int bytes_written = 0;
 
 	if (!record)
 		return -EINVAL;
 
-	error = -EPERM;
-	context = ds_get_context(task);
-	if (!context)
-		goto out;
-
-	if (!force) {
-		error = ds_validate_access(context, qual);
-		if (error < 0)
-			goto out;
-	}
-
-	error = 0;
 	while (size) {
 		unsigned long base, index, end, write_end, int_th;
 		unsigned long write_size, adj_write_size;
@@ -678,14 +689,14 @@
 			write_end = end;
 
 		if (write_end <= index)
-			goto out;
+			break;
 
 		write_size = min((unsigned long) size, write_end - index);
 		memcpy((void *)index, record, write_size);
 
 		record = (const char *)record + write_size;
-		size  -= write_size;
-		error += write_size;
+		size -= write_size;
+		bytes_written += write_size;
 
 		adj_write_size = write_size / ds_cfg.sizeof_rec[qual];
 		adj_write_size *= ds_cfg.sizeof_rec[qual];
@@ -700,47 +711,32 @@
 		ds_set(context->ds, qual, ds_index, index);
 
 		if (index >= int_th)
-			ds_overflow(task, context, qual);
+			ds_overflow(context, qual);
 	}
 
- out:
-	ds_put_context(context);
-	return error;
+	return bytes_written;
 }
 
-int ds_write_bts(struct task_struct *task, const void *record, size_t size)
+int ds_write_bts(struct bts_tracer *tracer, const void *record, size_t size)
 {
-	return ds_write(task, record, size, ds_bts, /* force = */ 0);
-}
+	if (!tracer)
+		return -EINVAL;
 
-int ds_write_pebs(struct task_struct *task, const void *record, size_t size)
-{
-	return ds_write(task, record, size, ds_pebs, /* force = */ 0);
+	return ds_write(tracer->ds.context, ds_bts, record, size);
 }
 
-int ds_unchecked_write_bts(struct task_struct *task,
-			   const void *record, size_t size)
+int ds_write_pebs(struct pebs_tracer *tracer, const void *record, size_t size)
 {
-	return ds_write(task, record, size, ds_bts, /* force = */ 1);
-}
+	if (!tracer)
+		return -EINVAL;
 
-int ds_unchecked_write_pebs(struct task_struct *task,
-			    const void *record, size_t size)
-{
-	return ds_write(task, record, size, ds_pebs, /* force = */ 1);
+	return ds_write(tracer->ds.context, ds_pebs, record, size);
 }
 
-static int ds_reset_or_clear(struct task_struct *task,
-			     enum ds_qualifier qual, int clear)
+static void ds_reset_or_clear(struct ds_context *context,
+			      enum ds_qualifier qual, int clear)
 {
-	struct ds_context *context;
 	unsigned long base, end;
-	int error;
-
-	context = ds_get_context(task);
-	error = ds_validate_access(context, qual);
-	if (error < 0)
-		goto out;
 
 	base = ds_get(context->ds, qual, ds_buffer_base);
 	end  = ds_get(context->ds, qual, ds_absolute_maximum);
@@ -749,70 +745,69 @@
 		memset((void *)base, 0, end - base);
 
 	ds_set(context->ds, qual, ds_index, base);
-
-	error = 0;
- out:
-	ds_put_context(context);
-	return error;
 }
 
-int ds_reset_bts(struct task_struct *task)
+int ds_reset_bts(struct bts_tracer *tracer)
 {
-	return ds_reset_or_clear(task, ds_bts, /* clear = */ 0);
+	if (!tracer)
+		return -EINVAL;
+
+	ds_reset_or_clear(tracer->ds.context, ds_bts, /* clear = */ 0);
+
+	return 0;
 }
 
-int ds_reset_pebs(struct task_struct *task)
+int ds_reset_pebs(struct pebs_tracer *tracer)
 {
-	return ds_reset_or_clear(task, ds_pebs, /* clear = */ 0);
+	if (!tracer)
+		return -EINVAL;
+
+	ds_reset_or_clear(tracer->ds.context, ds_pebs, /* clear = */ 0);
+
+	return 0;
 }
 
-int ds_clear_bts(struct task_struct *task)
+int ds_clear_bts(struct bts_tracer *tracer)
 {
-	return ds_reset_or_clear(task, ds_bts, /* clear = */ 1);
+	if (!tracer)
+		return -EINVAL;
+
+	ds_reset_or_clear(tracer->ds.context, ds_bts, /* clear = */ 1);
+
+	return 0;
 }
 
-int ds_clear_pebs(struct task_struct *task)
+int ds_clear_pebs(struct pebs_tracer *tracer)
 {
-	return ds_reset_or_clear(task, ds_pebs, /* clear = */ 1);
+	if (!tracer)
+		return -EINVAL;
+
+	ds_reset_or_clear(tracer->ds.context, ds_pebs, /* clear = */ 1);
+
+	return 0;
 }
 
-int ds_get_pebs_reset(struct task_struct *task, u64 *value)
+int ds_get_pebs_reset(struct pebs_tracer *tracer, u64 *value)
 {
-	struct ds_context *context;
-	int error;
+	if (!tracer)
+		return -EINVAL;
 
 	if (!value)
 		return -EINVAL;
 
-	context = ds_get_context(task);
-	error = ds_validate_access(context, ds_pebs);
-	if (error < 0)
-		goto out;
-
-	*value = *(u64 *)(context->ds + (ds_cfg.sizeof_field * 8));
+	*value = *(u64 *)(tracer->ds.context->ds + (ds_cfg.sizeof_field * 8));
 
-	error = 0;
- out:
-	ds_put_context(context);
-	return error;
+	return 0;
 }
 
-int ds_set_pebs_reset(struct task_struct *task, u64 value)
+int ds_set_pebs_reset(struct pebs_tracer *tracer, u64 value)
 {
-	struct ds_context *context;
-	int error;
-
-	context = ds_get_context(task);
-	error = ds_validate_access(context, ds_pebs);
-	if (error < 0)
-		goto out;
+	if (!tracer)
+		return -EINVAL;
 
-	*(u64 *)(context->ds + (ds_cfg.sizeof_field * 8)) = value;
+	*(u64 *)(tracer->ds.context->ds + (ds_cfg.sizeof_field * 8)) = value;
 
-	error = 0;
- out:
-	ds_put_context(context);
-	return error;
+	return 0;
 }
 
 static const struct ds_configuration ds_cfg_var = {
@@ -840,6 +835,10 @@
 ds_configure(const struct ds_configuration *cfg)
 {
 	ds_cfg = *cfg;
+
+	printk(KERN_INFO "DS available\n");
+
+	BUG_ON(MAX_SIZEOF_DS < ds_cfg.sizeof_ds);
 }
 
 void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
@@ -883,6 +882,8 @@
 	 * is dying. There should not be any user of that context left
 	 * to disturb us, anymore. */
 	unsigned long leftovers = context->count;
-	while (leftovers--)
+	while (leftovers--) {
+		put_tracer(context->task);
 		ds_put_context(context);
+	}
 }
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

