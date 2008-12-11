Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbYLKMub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbYLKMub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 07:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbYLKMuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 07:50:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:42365 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbYLKMuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 07:50:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,753,1220252400"; 
   d="scan'208";a="413535298"
Date: Thu, 11 Dec 2008 13:49:59 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, eranian@googlemail.com
Subject: [patch 2/3] x86, bts: provide in-kernel branch-trace interface
Message-ID: <20081211134959.A13599@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the BTS bits from ptrace.c into ds.c.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: gits/arch/x86/include/asm/ds.h
===================================================================
--- gits.orig/arch/x86/include/asm/ds.h	2008-12-11 10:44:35.000000000 +0100
+++ gits/arch/x86/include/asm/ds.h	2008-12-11 11:20:54.000000000 +0100
@@ -6,13 +6,13 @@
  * precise-event based sampling (PEBS).
  *
  * It manages:
- * - per-thread and per-cpu allocation of BTS and PEBS
+ * - DS and BTS hardware configuration
  * - buffer overflow handling (to be done)
  * - buffer access
  *
- * It assumes:
- * - get_task_struct on all traced tasks
- * - current is allowed to trace tasks
+ * It does not do:
+ * - security checking (is the caller allowed to trace the task)
+ * - buffer allocation (memory accounting)
  *
  *
  * Copyright (C) 2007-2008 Intel Corporation.
@@ -31,6 +31,7 @@
 #ifdef CONFIG_X86_DS
 
 struct task_struct;
+struct ds_context;
 struct ds_tracer;
 struct bts_tracer;
 struct pebs_tracer;
@@ -38,6 +39,38 @@
 typedef void (*bts_ovfl_callback_t)(struct bts_tracer *);
 typedef void (*pebs_ovfl_callback_t)(struct pebs_tracer *);
 
+
+/*
+ * A list of features plus corresponding macros to talk about them in
+ * the ds_request function's flags parameter.
+ *
+ * We use the enum to index an array of corresponding control bits;
+ * we use the macro to index a flags bit-vector.
+ */
+enum ds_feature {
+	dsf_bts = 0,
+	dsf_bts_kernel,
+#define BTS_KERNEL (1 << dsf_bts_kernel)
+	/* trace kernel-mode branches */
+
+	dsf_bts_user,
+#define BTS_USER (1 << dsf_bts_user)
+	/* trace user-mode branches */
+
+	dsf_bts_overflow,
+	dsf_bts_max,
+	dsf_pebs = dsf_bts_max,
+
+	dsf_pebs_max,
+	dsf_ctl_max = dsf_pebs_max,
+	dsf_bts_timestamps = dsf_ctl_max,
+#define BTS_TIMESTAMPS (1 << dsf_bts_timestamps)
+	/* add timestamps into BTS trace */
+
+#define BTS_USER_FLAGS (BTS_KERNEL | BTS_USER | BTS_TIMESTAMPS)
+};
+
+
 /*
  * Request BTS or PEBS
  *
@@ -58,92 +91,135 @@
  *       NULL if cyclic buffer requested
  * th: the interrupt threshold in records from the end of the buffer;
  *     -1 if no interrupt threshold is requested.
+ * flags: a bit-mask of the above flags
  */
 extern struct bts_tracer *ds_request_bts(struct task_struct *task,
 					 void *base, size_t size,
-					 bts_ovfl_callback_t ovfl, size_t th);
+					 bts_ovfl_callback_t ovfl,
+					 size_t th, unsigned int flags);
 extern struct pebs_tracer *ds_request_pebs(struct task_struct *task,
 					   void *base, size_t size,
 					   pebs_ovfl_callback_t ovfl,
-					   size_t th);
+					   size_t th, unsigned int flags);
 
 /*
  * Release BTS or PEBS resources
- *
- * Returns 0 on success; -Eerrno otherwise
+ * Suspend and resume BTS or PEBS tracing
  *
  * tracer: the tracer handle returned from ds_request_~()
  */
-extern int ds_release_bts(struct bts_tracer *tracer);
-extern int ds_release_pebs(struct pebs_tracer *tracer);
+extern void ds_release_bts(struct bts_tracer *tracer);
+extern void ds_suspend_bts(struct bts_tracer *tracer);
+extern void ds_resume_bts(struct bts_tracer *tracer);
+extern void ds_release_pebs(struct pebs_tracer *tracer);
+extern void ds_suspend_pebs(struct pebs_tracer *tracer);
+extern void ds_resume_pebs(struct pebs_tracer *tracer);
+
 
 /*
- * Get the (array) index of the write pointer.
- * (assuming an array of BTS/PEBS records)
- *
- * Returns 0 on success; -Eerrno on error
- *
- * tracer: the tracer handle returned from ds_request_~()
- * pos (out): will hold the result
+ * The raw DS buffer state as it is used for BTS and PEBS recording.
+ *
+ * This is the low-level, arch-dependent interface for working
+ * directly on the raw trace data.
+ */
+struct ds_trace {
+	/* the number of bts/pebs records */
+	size_t n;
+	/* the size of a bts/pebs record in bytes */
+	size_t size;
+	/* pointers into the raw buffer:
+	   - to the first entry */
+	void *begin;
+	/* - one beyond the last entry */
+	void *end;
+	/* - one beyond the newest entry */
+	void *top;
+	/* - the interrupt threshold */
+	void *ith;
+	/* flags given on ds_request() */
+	unsigned int flags;
+};
+
+/*
+ * An arch-independent view on branch trace data.
  */
-extern int ds_get_bts_index(struct bts_tracer *tracer, size_t *pos);
-extern int ds_get_pebs_index(struct pebs_tracer *tracer, size_t *pos);
+enum bts_qualifier {
+	bts_invalid,
+#define BTS_INVALID bts_invalid
+
+	bts_branch,
+#define BTS_BRANCH bts_branch
+
+	bts_task_arrives,
+#define BTS_TASK_ARRIVES bts_task_arrives
+
+	bts_task_departs,
+#define BTS_TASK_DEPARTS bts_task_departs
+
+	bts_qual_bit_size = 4,
+	bts_qual_max = (1 << bts_qual_bit_size),
+};
+
+struct bts_struct {
+	__u64 qualifier;
+	union {
+		/* BTS_BRANCH */
+		struct {
+			__u64 from;
+			__u64 to;
+		} lbr;
+		/* BTS_TASK_ARRIVES or BTS_TASK_DEPARTS */
+		struct {
+			__u64 jiffies;
+			pid_t pid;
+		} timestamp;
+	} variant;
+};
+
 
 /*
- * Get the (array) index one record beyond the end of the array.
- * (assuming an array of BTS/PEBS records)
- *
- * Returns 0 on success; -Eerrno on error
+ * The BTS state.
  *
- * tracer: the tracer handle returned from ds_request_~()
- * pos (out): will hold the result
+ * This gives access to the raw DS state and adds functions to provide
+ * an arch-independent view of the BTS data.
  */
-extern int ds_get_bts_end(struct bts_tracer *tracer, size_t *pos);
-extern int ds_get_pebs_end(struct pebs_tracer *tracer, size_t *pos);
+struct bts_trace {
+	struct ds_trace ds;
+
+	int (*read)(struct bts_tracer *tracer, const void *at,
+		    struct bts_struct *out);
+	int (*write)(struct bts_tracer *tracer, const struct bts_struct *in);
+};
+
 
 /*
- * Provide a pointer to the BTS/PEBS record at parameter index.
- * (assuming an array of BTS/PEBS records)
- *
- * The pointer points directly into the buffer. The user is
- * responsible for copying the record.
+ * The PEBS state.
  *
- * Returns the size of a single record on success; -Eerrno on error
- *
- * tracer: the tracer handle returned from ds_request_~()
- * index: the index of the requested record
- * record (out): pointer to the requested record
+ * This gives access to the raw DS state and the PEBS-specific counter
+ * reset value.
  */
-extern int ds_access_bts(struct bts_tracer *tracer,
-			 size_t index, const void **record);
-extern int ds_access_pebs(struct pebs_tracer *tracer,
-			  size_t index, const void **record);
+struct pebs_trace {
+	struct ds_trace ds;
+
+	/* the PEBS reset value */
+	unsigned long long reset_value;
+};
+
 
 /*
- * Write one or more BTS/PEBS records at the write pointer index and
- * advance the write pointer.
- *
- * If size is not a multiple of the record size, trailing bytes are
- * zeroed out.
+ * Read the BTS or PEBS trace.
  *
- * May result in one or more overflow notifications.
+ * Returns a view on the trace collected for the parameter tracer.
  *
- * If called during overflow handling, that is, with index >=
- * interrupt threshold, the write will wrap around.
- *
- * An overflow notification is given if and when the interrupt
- * threshold is reached during or after the write.
- *
- * Returns the number of bytes written or -Eerrno.
+ * The view remains valid as long as the traced task is not running or
+ * the tracer is suspended.
+ * Writes into the trace buffer are not reflected.
  *
  * tracer: the tracer handle returned from ds_request_~()
- * buffer: the buffer to write
- * size: the size of the buffer
  */
-extern int ds_write_bts(struct bts_tracer *tracer,
-			const void *buffer, size_t size);
-extern int ds_write_pebs(struct pebs_tracer *tracer,
-			 const void *buffer, size_t size);
+extern const struct bts_trace *ds_read_bts(struct bts_tracer *tracer);
+extern const struct pebs_trace *ds_read_pebs(struct pebs_tracer *tracer);
+
 
 /*
  * Reset the write pointer of the BTS/PEBS buffer.
@@ -156,27 +232,6 @@
 extern int ds_reset_pebs(struct pebs_tracer *tracer);
 
 /*
- * Clear the BTS/PEBS buffer and reset the write pointer.
- * The entire buffer will be zeroed out.
- *
- * Returns 0 on success; -Eerrno on error
- *
- * tracer: the tracer handle returned from ds_request_~()
- */
-extern int ds_clear_bts(struct bts_tracer *tracer);
-extern int ds_clear_pebs(struct pebs_tracer *tracer);
-
-/*
- * Provide the PEBS counter reset value.
- *
- * Returns 0 on success; -Eerrno on error
- *
- * tracer: the tracer handle returned from ds_request_pebs()
- * value (out): the counter reset value
- */
-extern int ds_get_pebs_reset(struct pebs_tracer *tracer, u64 *value);
-
-/*
  * Set the PEBS counter reset value.
  *
  * Returns 0 on success; -Eerrno on error
@@ -192,35 +247,17 @@
 struct cpuinfo_x86;
 extern void __cpuinit ds_init_intel(struct cpuinfo_x86 *);
 
-
-
 /*
- * The DS context - part of struct thread_struct.
+ * Context switch work
  */
-#define MAX_SIZEOF_DS (12 * 8)
-
-struct ds_context {
-	/* pointer to the DS configuration; goes into MSR_IA32_DS_AREA */
-	unsigned char ds[MAX_SIZEOF_DS];
-	/* the owner of the BTS and PEBS configuration, respectively */
-	struct ds_tracer  *owner[2];
-	/* use count */
-	unsigned long count;
-	/* a pointer to the context location inside the thread_struct
-	 * or the per_cpu context array */
-	struct ds_context **this;
-	/* a pointer to the task owning this context, or NULL, if the
-	 * context is owned by a cpu */
-	struct task_struct *task;
-};
-
-/* called by exit_thread() to free leftover contexts */
-extern void ds_free(struct ds_context *context);
+extern void ds_switch_to(struct task_struct *prev, struct task_struct *next);
 
 #else /* CONFIG_X86_DS */
 
 struct cpuinfo_x86;
 static inline void __cpuinit ds_init_intel(struct cpuinfo_x86 *ignored) {}
+static inline void ds_switch_to(struct task_struct *prev,
+				struct task_struct *next) {}
 
 #endif /* CONFIG_X86_DS */
 #endif /* _ASM_X86_DS_H */
Index: gits/arch/x86/kernel/ds.c
===================================================================
--- gits.orig/arch/x86/kernel/ds.c	2008-12-11 11:20:53.000000000 +0100
+++ gits/arch/x86/kernel/ds.c	2008-12-11 11:20:54.000000000 +0100
@@ -6,13 +6,13 @@
  * precise-event based sampling (PEBS).
  *
  * It manages:
- * - per-thread and per-cpu allocation of BTS and PEBS
+ * - DS and BTS hardware configuration
  * - buffer overflow handling (to be done)
  * - buffer access
  *
- * It assumes:
- * - get_task_struct on all traced tasks
- * - current is allowed to trace tasks
+ * It does not do:
+ * - security checking (is the caller allowed to trace the task)
+ * - buffer allocation (memory accounting)
  *
  *
  * Copyright (C) 2007-2008 Intel Corporation.
@@ -34,15 +34,30 @@
  * The configuration for a particular DS hardware implementation.
  */
 struct ds_configuration {
-	/* the size of the DS structure in bytes */
-	unsigned char  sizeof_ds;
-	/* the size of one pointer-typed field in the DS structure in bytes;
-	   this covers the first 8 fields related to buffer management. */
+	/* the name of the configuration */
+	const char *name;
+	/* the size of one pointer-typed field in the DS structure and
+	   in the BTS and PEBS buffers in bytes;
+	   this covers the first 8 DS fields related to buffer management. */
 	unsigned char  sizeof_field;
 	/* the size of a BTS/PEBS record in bytes */
 	unsigned char  sizeof_rec[2];
+	/* a series of bit-masks to control various features indexed
+	 * by enum ds_feature */
+	unsigned long ctl[dsf_ctl_max];
 };
-static struct ds_configuration ds_cfg;
+static DEFINE_PER_CPU(struct ds_configuration, ds_cfg_array);
+
+#define ds_cfg per_cpu(ds_cfg_array, smp_processor_id())
+
+#define MAX_SIZEOF_DS (12 * 8)	/* maximal size of a DS configuration */
+#define MAX_SIZEOF_BTS (3 * 8)	/* maximal size of a BTS record */
+#define DS_ALIGNMENT (1 << 3)	/* BTS and PEBS buffer alignment */
+
+#define BTS_CONTROL \
+ (ds_cfg.ctl[dsf_bts] | ds_cfg.ctl[dsf_bts_kernel] | ds_cfg.ctl[dsf_bts_user] |\
+  ds_cfg.ctl[dsf_bts_overflow])
+
 
 /*
  * A BTS or PEBS tracer.
@@ -61,6 +76,8 @@
 struct bts_tracer {
 	/* the common DS part */
 	struct ds_tracer ds;
+	/* the trace including the DS configuration */
+	struct bts_trace trace;
 	/* buffer overflow notification function */
 	bts_ovfl_callback_t ovfl;
 };
@@ -68,6 +85,8 @@
 struct pebs_tracer {
 	/* the common DS part */
 	struct ds_tracer ds;
+	/* the trace including the DS configuration */
+	struct pebs_trace trace;
 	/* buffer overflow notification function */
 	pebs_ovfl_callback_t ovfl;
 };
@@ -134,13 +153,11 @@
 	(*(unsigned long *)base) = value;
 }
 
-#define DS_ALIGNMENT (1 << 3)	/* BTS and PEBS buffer alignment */
-
 
 /*
  * Locking is done only for allocating BTS or PEBS resources.
  */
-static spinlock_t ds_lock = __SPIN_LOCK_UNLOCKED(ds_lock);
+static DEFINE_SPINLOCK(ds_lock);
 
 
 /*
@@ -156,27 +173,32 @@
  *   >0  number of per-thread tracers
  *   <0  number of per-cpu tracers
  *
- * The below functions to get and put tracers and to check the
- * allocation type require the ds_lock to be held by the caller.
- *
  * Tracers essentially gives the number of ds contexts for a certain
  * type of allocation.
  */
-static long tracers;
+static atomic_t tracers = ATOMIC_INIT(0);
 
 static inline void get_tracer(struct task_struct *task)
 {
-	tracers += (task ? 1 : -1);
+	if (task)
+		atomic_inc(&tracers);
+	else
+		atomic_dec(&tracers);
 }
 
 static inline void put_tracer(struct task_struct *task)
 {
-	tracers -= (task ? 1 : -1);
+	if (task)
+		atomic_dec(&tracers);
+	else
+		atomic_inc(&tracers);
 }
 
 static inline int check_tracer(struct task_struct *task)
 {
-	return (task ? (tracers >= 0) : (tracers <= 0));
+	return (task ?
+		(atomic_read(&tracers) >= 0) :
+		(atomic_read(&tracers) <= 0));
 }
 
 
@@ -190,14 +212,30 @@
  * Contexts are use-counted. They are allocated on first access and
  * deallocated when the last user puts the context.
  */
-static DEFINE_PER_CPU(struct ds_context *, system_context);
+struct ds_context {
+	/* pointer to the DS configuration; goes into MSR_IA32_DS_AREA */
+	unsigned char ds[MAX_SIZEOF_DS];
+	/* the owner of the BTS and PEBS configuration, respectively */
+	struct bts_tracer *bts_master;
+	struct pebs_tracer *pebs_master;
+	/* use count */
+	unsigned long count;
+	/* a pointer to the context location inside the thread_struct
+	 * or the per_cpu context array */
+	struct ds_context **this;
+	/* a pointer to the task owning this context, or NULL, if the
+	 * context is owned by a cpu */
+	struct task_struct *task;
+};
+
+static DEFINE_PER_CPU(struct ds_context *, system_context_array);
 
-#define this_system_context per_cpu(system_context, smp_processor_id())
+#define system_context per_cpu(system_context_array, smp_processor_id())
 
 static inline struct ds_context *ds_get_context(struct task_struct *task)
 {
 	struct ds_context **p_context =
-		(task ? &task->thread.ds_ctx : &this_system_context);
+		(task ? &task->thread.ds_ctx : &system_context);
 	struct ds_context *context = *p_context;
 	unsigned long irq;
 
@@ -225,10 +263,22 @@
 				wrmsrl(MSR_IA32_DS_AREA,
 				       (unsigned long)context->ds);
 		}
+
+		context->count++;
+
+		spin_unlock_irqrestore(&ds_lock, irq);
+	} else {
+		spin_lock_irqsave(&ds_lock, irq);
+
+		context = *p_context;
+		if (context)
+			context->count++;
+
 		spin_unlock_irqrestore(&ds_lock, irq);
-	}
 
-	context->count++;
+		if (!context)
+			context = ds_get_context(task);
+	}
 
 	return context;
 }
@@ -242,8 +292,10 @@
 
 	spin_lock_irqsave(&ds_lock, irq);
 
-	if (--context->count)
-		goto out;
+	if (--context->count) {
+		spin_unlock_irqrestore(&ds_lock, irq);
+		return;
+	}
 
 	*(context->this) = NULL;
 
@@ -253,14 +305,14 @@
 	if (!context->task || (context->task == current))
 		wrmsrl(MSR_IA32_DS_AREA, 0);
 
-	kfree(context);
- out:
 	spin_unlock_irqrestore(&ds_lock, irq);
+
+	kfree(context);
 }
 
 
 /*
- * Handle a buffer overflow
+ * Call the tracer's callback on a buffer overflow.
  *
  * context: the ds context
  * qual: the buffer type
@@ -268,30 +320,244 @@
 static void ds_overflow(struct ds_context *context, enum ds_qualifier qual)
 {
 	switch (qual) {
-	case ds_bts: {
-		struct bts_tracer *tracer =
-			container_of(context->owner[qual],
-				     struct bts_tracer, ds);
-		if (tracer->ovfl)
-			tracer->ovfl(tracer);
-	}
+	case ds_bts:
+		if (context->bts_master &&
+		    context->bts_master->ovfl)
+			context->bts_master->ovfl(context->bts_master);
+		break;
+	case ds_pebs:
+		if (context->pebs_master &&
+		    context->pebs_master->ovfl)
+			context->pebs_master->ovfl(context->pebs_master);
 		break;
-	case ds_pebs: {
-		struct pebs_tracer *tracer =
-			container_of(context->owner[qual],
-				     struct pebs_tracer, ds);
-		if (tracer->ovfl)
-			tracer->ovfl(tracer);
 	}
+}
+
+
+/*
+ * Write raw data into the BTS or PEBS buffer.
+ *
+ * The remainder of any partially written record is zeroed out.
+ *
+ * context: the DS context
+ * qual: the buffer type
+ * record: the data to write
+ * size: the size of the data
+ */
+static int ds_write(struct ds_context *context, enum ds_qualifier qual,
+		    const void *record, size_t size)
+{
+	int bytes_written = 0;
+
+	if (!record)
+		return -EINVAL;
+
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
+			break;
+
+		write_size = min((unsigned long) size, write_end - index);
+		memcpy((void *)index, record, write_size);
+
+		record = (const char *)record + write_size;
+		size -= write_size;
+		bytes_written += write_size;
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
+
+		if (index >= int_th)
+			ds_overflow(context, qual);
+	}
+
+	return bytes_written;
+}
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
+ *
+ * We use two levels of abstraction:
+ * - the raw data level defined here
+ * - an arch-independent level defined in ds.h
+ */
+
+enum bts_field {
+	bts_from,
+	bts_to,
+	bts_flags,
+
+	bts_qual = bts_from,
+	bts_jiffies = bts_to,
+	bts_pid = bts_flags,
+
+	bts_qual_mask = (bts_qual_max - 1),
+	bts_escape = ((unsigned long)-1 & ~bts_qual_mask)
+};
+
+static inline unsigned long bts_get(const char *base, enum bts_field field)
+{
+	base += (ds_cfg.sizeof_field * field);
+	return *(unsigned long *)base;
+}
+
+static inline void bts_set(char *base, enum bts_field field, unsigned long val)
+{
+	base += (ds_cfg.sizeof_field * field);;
+	(*(unsigned long *)base) = val;
+}
+
+
+/*
+ * The raw BTS data is architecture dependent.
+ *
+ * For higher-level users, we give an arch-independent view.
+ * - ds.h defines struct bts_struct
+ * - bts_read translates one raw bts record into a bts_struct
+ * - bts_write translates one bts_struct into the raw format and
+ *   writes it into the top of the parameter tracer's buffer.
+ *
+ * return: bytes read/written on success; -Eerrno, otherwise
+ */
+static int bts_read(struct bts_tracer *tracer, const void *at,
+		    struct bts_struct *out)
+{
+	if (!tracer)
+		return -EINVAL;
+
+	if (at < tracer->trace.ds.begin)
+		return -EINVAL;
+
+	if (tracer->trace.ds.end < (at + tracer->trace.ds.size))
+		return -EINVAL;
+
+	memset(out, 0, sizeof(*out));
+	if ((bts_get(at, bts_qual) & ~bts_qual_mask) == bts_escape) {
+		out->qualifier = (bts_get(at, bts_qual) & bts_qual_mask);
+		out->variant.timestamp.jiffies = bts_get(at, bts_jiffies);
+		out->variant.timestamp.pid = bts_get(at, bts_pid);
+	} else {
+		out->qualifier = bts_branch;
+		out->variant.lbr.from = bts_get(at, bts_from);
+		out->variant.lbr.to   = bts_get(at, bts_to);
+	}
+
+	return ds_cfg.sizeof_rec[ds_bts];
+}
+
+static int bts_write(struct bts_tracer *tracer, const struct bts_struct *in)
+{
+	unsigned char raw[MAX_SIZEOF_BTS];
+
+	if (!tracer)
+		return -EINVAL;
+
+	if (MAX_SIZEOF_BTS < ds_cfg.sizeof_rec[ds_bts])
+		return -EOVERFLOW;
+
+	switch (in->qualifier) {
+	case bts_invalid:
+		bts_set(raw, bts_from, 0);
+		bts_set(raw, bts_to, 0);
+		bts_set(raw, bts_flags, 0);
+		break;
+	case bts_branch:
+		bts_set(raw, bts_from, in->variant.lbr.from);
+		bts_set(raw, bts_to,   in->variant.lbr.to);
+		bts_set(raw, bts_flags, 0);
 		break;
+	case bts_task_arrives:
+	case bts_task_departs:
+		bts_set(raw, bts_qual, (bts_escape | in->qualifier));
+		bts_set(raw, bts_jiffies, in->variant.timestamp.jiffies);
+		bts_set(raw, bts_pid, in->variant.timestamp.pid);
+		break;
+	default:
+		return -EINVAL;
 	}
+
+	return ds_write(tracer->ds.context, ds_bts, raw,
+			ds_cfg.sizeof_rec[ds_bts]);
 }
 
 
-static void ds_install_ds_config(struct ds_context *context,
-				 enum ds_qualifier qual,
-				 void *base, size_t size, size_t ith)
+static void ds_write_config(struct ds_context *context,
+			    struct ds_trace *cfg, enum ds_qualifier qual)
 {
+	unsigned char *ds = context->ds;
+
+	ds_set(ds, qual, ds_buffer_base, (unsigned long)cfg->begin);
+	ds_set(ds, qual, ds_index, (unsigned long)cfg->top);
+	ds_set(ds, qual, ds_absolute_maximum, (unsigned long)cfg->end);
+	ds_set(ds, qual, ds_interrupt_threshold, (unsigned long)cfg->ith);
+}
+
+static void ds_read_config(struct ds_context *context,
+			   struct ds_trace *cfg, enum ds_qualifier qual)
+{
+	unsigned char *ds = context->ds;
+
+	cfg->begin = (void *)ds_get(ds, qual, ds_buffer_base);
+	cfg->top = (void *)ds_get(ds, qual, ds_index);
+	cfg->end = (void *)ds_get(ds, qual, ds_absolute_maximum);
+	cfg->ith = (void *)ds_get(ds, qual, ds_interrupt_threshold);
+}
+
+static void ds_init_ds_trace(struct ds_trace *trace, enum ds_qualifier qual,
+			     void *base, size_t size, size_t ith,
+			     unsigned int flags) {
 	unsigned long buffer, adj;
 
 	/* adjust the buffer address and size to meet alignment
@@ -308,32 +574,30 @@
 	buffer += adj;
 	size   -= adj;
 
-	size /= ds_cfg.sizeof_rec[qual];
-	size *= ds_cfg.sizeof_rec[qual];
+	trace->n = size / ds_cfg.sizeof_rec[qual];
+	trace->size = ds_cfg.sizeof_rec[qual];
 
-	ds_set(context->ds, qual, ds_buffer_base, buffer);
-	ds_set(context->ds, qual, ds_index, buffer);
-	ds_set(context->ds, qual, ds_absolute_maximum, buffer + size);
+	size = (trace->n * trace->size);
 
+	trace->begin = (void *)buffer;
+	trace->top = trace->begin;
+	trace->end = (void *)(buffer + size);
 	/* The value for 'no threshold' is -1, which will set the
 	 * threshold outside of the buffer, just like we want it.
 	 */
-	ds_set(context->ds, qual,
-	       ds_interrupt_threshold, buffer + size - ith);
+	trace->ith = (void *)(buffer + size - ith);
+
+	trace->flags = flags;
 }
 
-static int ds_request(struct ds_tracer *tracer, enum ds_qualifier qual,
-		      struct task_struct *task,
-		      void *base, size_t size, size_t th)
+
+static int ds_request(struct ds_tracer *tracer, struct ds_trace *trace,
+		      enum ds_qualifier qual, struct task_struct *task,
+		      void *base, size_t size, size_t th, unsigned int flags)
 {
 	struct ds_context *context;
-	unsigned long irq;
 	int error;
 
-	error = -EOPNOTSUPP;
-	if (!ds_cfg.sizeof_ds)
-		goto out;
-
 	error = -EINVAL;
 	if (!base)
 		goto out;
@@ -360,43 +624,26 @@
 		goto out;
 	tracer->context = context;
 
+	ds_init_ds_trace(trace, qual, base, size, th, flags);
 
-	spin_lock_irqsave(&ds_lock, irq);
-
-	error = -EPERM;
-	if (!check_tracer(task))
-		goto out_unlock;
-	get_tracer(task);
-
-	error = -EPERM;
-	if (context->owner[qual])
-		goto out_put_tracer;
-	context->owner[qual] = tracer;
-
-	spin_unlock_irqrestore(&ds_lock, irq);
-
-
-	ds_install_ds_config(context, qual, base, size, th);
-
-	return 0;
-
- out_put_tracer:
-	put_tracer(task);
- out_unlock:
-	spin_unlock_irqrestore(&ds_lock, irq);
-	ds_put_context(context);
-	tracer->context = NULL;
+	error = 0;
  out:
 	return error;
 }
 
 struct bts_tracer *ds_request_bts(struct task_struct *task,
 				  void *base, size_t size,
-				  bts_ovfl_callback_t ovfl, size_t th)
+				  bts_ovfl_callback_t ovfl, size_t th,
+				  unsigned int flags)
 {
 	struct bts_tracer *tracer;
+	unsigned long irq;
 	int error;
 
+	error = -EOPNOTSUPP;
+	if (!ds_cfg.ctl[dsf_bts])
+		goto out;
+
 	/* buffer overflow notification is not yet implemented */
 	error = -EOPNOTSUPP;
 	if (ovfl)
@@ -408,12 +655,40 @@
 		goto out;
 	tracer->ovfl = ovfl;
 
-	error = ds_request(&tracer->ds, ds_bts, task, base, size, th);
+	error = ds_request(&tracer->ds, &tracer->trace.ds,
+			   ds_bts, task, base, size, th, flags);
 	if (error < 0)
 		goto out_tracer;
 
+
+	spin_lock_irqsave(&ds_lock, irq);
+
+	error = -EPERM;
+	if (!check_tracer(task))
+		goto out_unlock;
+	get_tracer(task);
+
+	error = -EPERM;
+	if (tracer->ds.context->bts_master)
+		goto out_put_tracer;
+	tracer->ds.context->bts_master = tracer;
+
+	spin_unlock_irqrestore(&ds_lock, irq);
+
+
+	tracer->trace.read  = bts_read;
+	tracer->trace.write = bts_write;
+
+	ds_write_config(tracer->ds.context, &tracer->trace.ds, ds_bts);
+	ds_resume_bts(tracer);
+
 	return tracer;
 
+ out_put_tracer:
+	put_tracer(task);
+ out_unlock:
+	spin_unlock_irqrestore(&ds_lock, irq);
+	ds_put_context(tracer->ds.context);
  out_tracer:
 	kfree(tracer);
  out:
@@ -422,9 +697,11 @@
 
 struct pebs_tracer *ds_request_pebs(struct task_struct *task,
 				    void *base, size_t size,
-				    pebs_ovfl_callback_t ovfl, size_t th)
+				    pebs_ovfl_callback_t ovfl, size_t th,
+				    unsigned int flags)
 {
 	struct pebs_tracer *tracer;
+	unsigned long irq;
 	int error;
 
 	/* buffer overflow notification is not yet implemented */
@@ -438,249 +715,147 @@
 		goto out;
 	tracer->ovfl = ovfl;
 
-	error = ds_request(&tracer->ds, ds_pebs, task, base, size, th);
+	error = ds_request(&tracer->ds, &tracer->trace.ds,
+			   ds_pebs, task, base, size, th, flags);
 	if (error < 0)
 		goto out_tracer;
 
+	spin_lock_irqsave(&ds_lock, irq);
+
+	error = -EPERM;
+	if (!check_tracer(task))
+		goto out_unlock;
+	get_tracer(task);
+
+	error = -EPERM;
+	if (tracer->ds.context->pebs_master)
+		goto out_put_tracer;
+	tracer->ds.context->pebs_master = tracer;
+
+	spin_unlock_irqrestore(&ds_lock, irq);
+
+	ds_write_config(tracer->ds.context, &tracer->trace.ds, ds_bts);
+	ds_resume_pebs(tracer);
+
 	return tracer;
 
+ out_put_tracer:
+	put_tracer(task);
+ out_unlock:
+	spin_unlock_irqrestore(&ds_lock, irq);
+	ds_put_context(tracer->ds.context);
  out_tracer:
 	kfree(tracer);
  out:
 	return ERR_PTR(error);
 }
 
-static void ds_release(struct ds_tracer *tracer, enum ds_qualifier qual)
-{
-	WARN_ON_ONCE(tracer->context->owner[qual] != tracer);
-	tracer->context->owner[qual] = NULL;
-
-	put_tracer(tracer->context->task);
-	ds_put_context(tracer->context);
-}
-
-int ds_release_bts(struct bts_tracer *tracer)
+void ds_release_bts(struct bts_tracer *tracer)
 {
 	if (!tracer)
-		return -EINVAL;
+		return;
 
-	ds_release(&tracer->ds, ds_bts);
-	kfree(tracer);
+	ds_suspend_bts(tracer);
 
-	return 0;
-}
+	WARN_ON_ONCE(tracer->ds.context->bts_master != tracer);
+	tracer->ds.context->bts_master = NULL;
 
-int ds_release_pebs(struct pebs_tracer *tracer)
-{
-	if (!tracer)
-		return -EINVAL;
+	put_tracer(tracer->ds.context->task);
+	ds_put_context(tracer->ds.context);
 
-	ds_release(&tracer->ds, ds_pebs);
 	kfree(tracer);
-
-	return 0;
 }
 
-static size_t ds_get_index(struct ds_context *context, enum ds_qualifier qual)
+void ds_suspend_bts(struct bts_tracer *tracer)
 {
-	unsigned long base, index;
-
-	base  = ds_get(context->ds, qual, ds_buffer_base);
-	index = ds_get(context->ds, qual, ds_index);
-
-	return (index - base) / ds_cfg.sizeof_rec[qual];
-}
+	struct task_struct *task;
 
-int ds_get_bts_index(struct bts_tracer *tracer, size_t *pos)
-{
 	if (!tracer)
-		return -EINVAL;
-
-	if (!pos)
-		return -EINVAL;
-
-	*pos = ds_get_index(tracer->ds.context, ds_bts);
-
-	return 0;
-}
+		return;
 
-int ds_get_pebs_index(struct pebs_tracer *tracer, size_t *pos)
-{
-	if (!tracer)
-		return -EINVAL;
+	task = tracer->ds.context->task;
 
-	if (!pos)
-		return -EINVAL;
+	if (!task || (task == current))
+		update_debugctlmsr(get_debugctlmsr() & ~BTS_CONTROL);
 
-	*pos = ds_get_index(tracer->ds.context, ds_pebs);
+	if (task) {
+		task->thread.debugctlmsr &= ~BTS_CONTROL;
 
-	return 0;
+		if (!task->thread.debugctlmsr)
+			clear_tsk_thread_flag(task, TIF_DEBUGCTLMSR);
+	}
 }
 
-static size_t ds_get_end(struct ds_context *context, enum ds_qualifier qual)
+void ds_resume_bts(struct bts_tracer *tracer)
 {
-	unsigned long base, max;
-
-	base = ds_get(context->ds, qual, ds_buffer_base);
-	max  = ds_get(context->ds, qual, ds_absolute_maximum);
+	struct task_struct *task;
+	unsigned long control;
 
-	return (max - base) / ds_cfg.sizeof_rec[qual];
-}
-
-int ds_get_bts_end(struct bts_tracer *tracer, size_t *pos)
-{
 	if (!tracer)
-		return -EINVAL;
+		return;
 
-	if (!pos)
-		return -EINVAL;
+	task = tracer->ds.context->task;
 
-	*pos = ds_get_end(tracer->ds.context, ds_bts);
+	control = ds_cfg.ctl[dsf_bts];
+	if (!(tracer->trace.ds.flags & BTS_KERNEL))
+		control |= ds_cfg.ctl[dsf_bts_kernel];
+	if (!(tracer->trace.ds.flags & BTS_USER))
+		control |= ds_cfg.ctl[dsf_bts_user];
+
+	if (task) {
+		task->thread.debugctlmsr |= control;
+		set_tsk_thread_flag(task, TIF_DEBUGCTLMSR);
+	}
 
-	return 0;
+	if (!task || (task == current))
+		update_debugctlmsr(get_debugctlmsr() | control);
 }
 
-int ds_get_pebs_end(struct pebs_tracer *tracer, size_t *pos)
+void ds_release_pebs(struct pebs_tracer *tracer)
 {
 	if (!tracer)
-		return -EINVAL;
-
-	if (!pos)
-		return -EINVAL;
-
-	*pos = ds_get_end(tracer->ds.context, ds_pebs);
-
-	return 0;
-}
-
-static int ds_access(struct ds_context *context, enum ds_qualifier qual,
-		     size_t index, const void **record)
-{
-	unsigned long base, idx;
-
-	if (!record)
-		return -EINVAL;
-
-	base = ds_get(context->ds, qual, ds_buffer_base);
-	idx = base + (index * ds_cfg.sizeof_rec[qual]);
-
-	if (idx > ds_get(context->ds, qual, ds_absolute_maximum))
-		return -EINVAL;
+		return;
 
-	*record = (const void *)idx;
+	ds_suspend_pebs(tracer);
 
-	return ds_cfg.sizeof_rec[qual];
-}
+	WARN_ON_ONCE(tracer->ds.context->pebs_master != tracer);
+	tracer->ds.context->pebs_master = NULL;
 
-int ds_access_bts(struct bts_tracer *tracer, size_t index,
-		  const void **record)
-{
-	if (!tracer)
-		return -EINVAL;
+	put_tracer(tracer->ds.context->task);
+	ds_put_context(tracer->ds.context);
 
-	return ds_access(tracer->ds.context, ds_bts, index, record);
+	kfree(tracer);
 }
 
-int ds_access_pebs(struct pebs_tracer *tracer, size_t index,
-		   const void **record)
+void ds_suspend_pebs(struct pebs_tracer *tracer)
 {
-	if (!tracer)
-		return -EINVAL;
 
-	return ds_access(tracer->ds.context, ds_pebs, index, record);
 }
 
-static int ds_write(struct ds_context *context, enum ds_qualifier qual,
-		    const void *record, size_t size)
+void ds_resume_pebs(struct pebs_tracer *tracer)
 {
-	int bytes_written = 0;
-
-	if (!record)
-		return -EINVAL;
-
-	while (size) {
-		unsigned long base, index, end, write_end, int_th;
-		unsigned long write_size, adj_write_size;
-
-		/*
-		 * write as much as possible without producing an
-		 * overflow interrupt.
-		 *
-		 * interrupt_threshold must either be
-		 * - bigger than absolute_maximum or
-		 * - point to a record between buffer_base and absolute_maximum
-		 *
-		 * index points to a valid record.
-		 */
-		base   = ds_get(context->ds, qual, ds_buffer_base);
-		index  = ds_get(context->ds, qual, ds_index);
-		end    = ds_get(context->ds, qual, ds_absolute_maximum);
-		int_th = ds_get(context->ds, qual, ds_interrupt_threshold);
-
-		write_end = min(end, int_th);
-
-		/* if we are already beyond the interrupt threshold,
-		 * we fill the entire buffer */
-		if (write_end <= index)
-			write_end = end;
-
-		if (write_end <= index)
-			break;
-
-		write_size = min((unsigned long) size, write_end - index);
-		memcpy((void *)index, record, write_size);
-
-		record = (const char *)record + write_size;
-		size -= write_size;
-		bytes_written += write_size;
-
-		adj_write_size = write_size / ds_cfg.sizeof_rec[qual];
-		adj_write_size *= ds_cfg.sizeof_rec[qual];
-
-		/* zero out trailing bytes */
-		memset((char *)index + write_size, 0,
-		       adj_write_size - write_size);
-		index += adj_write_size;
-
-		if (index >= end)
-			index = base;
-		ds_set(context->ds, qual, ds_index, index);
-
-		if (index >= int_th)
-			ds_overflow(context, qual);
-	}
 
-	return bytes_written;
 }
 
-int ds_write_bts(struct bts_tracer *tracer, const void *record, size_t size)
+const struct bts_trace *ds_read_bts(struct bts_tracer *tracer)
 {
 	if (!tracer)
-		return -EINVAL;
+		return NULL;
 
-	return ds_write(tracer->ds.context, ds_bts, record, size);
+	ds_read_config(tracer->ds.context, &tracer->trace.ds, ds_bts);
+	return &tracer->trace;
 }
 
-int ds_write_pebs(struct pebs_tracer *tracer, const void *record, size_t size)
+const struct pebs_trace *ds_read_pebs(struct pebs_tracer *tracer)
 {
 	if (!tracer)
-		return -EINVAL;
-
-	return ds_write(tracer->ds.context, ds_pebs, record, size);
-}
-
-static void ds_reset_or_clear(struct ds_context *context,
-			      enum ds_qualifier qual, int clear)
-{
-	unsigned long base, end;
+		return NULL;
 
-	base = ds_get(context->ds, qual, ds_buffer_base);
-	end  = ds_get(context->ds, qual, ds_absolute_maximum);
+	ds_read_config(tracer->ds.context, &tracer->trace.ds, ds_pebs);
+	tracer->trace.reset_value =
+		*(u64 *)(tracer->ds.context->ds + (ds_cfg.sizeof_field * 8));
 
-	if (clear)
-		memset((void *)base, 0, end - base);
-
-	ds_set(context->ds, qual, ds_index, base);
+	return &tracer->trace;
 }
 
 int ds_reset_bts(struct bts_tracer *tracer)
@@ -688,50 +863,23 @@
 	if (!tracer)
 		return -EINVAL;
 
-	ds_reset_or_clear(tracer->ds.context, ds_bts, /* clear = */ 0);
+	tracer->trace.ds.top = tracer->trace.ds.begin;
 
-	return 0;
-}
-
-int ds_reset_pebs(struct pebs_tracer *tracer)
-{
-	if (!tracer)
-		return -EINVAL;
-
-	ds_reset_or_clear(tracer->ds.context, ds_pebs, /* clear = */ 0);
-
-	return 0;
-}
-
-int ds_clear_bts(struct bts_tracer *tracer)
-{
-	if (!tracer)
-		return -EINVAL;
-
-	ds_reset_or_clear(tracer->ds.context, ds_bts, /* clear = */ 1);
+	ds_set(tracer->ds.context->ds, ds_bts, ds_index,
+	       (unsigned long)tracer->trace.ds.top);
 
 	return 0;
 }
 
-int ds_clear_pebs(struct pebs_tracer *tracer)
-{
-	if (!tracer)
-		return -EINVAL;
-
-	ds_reset_or_clear(tracer->ds.context, ds_pebs, /* clear = */ 1);
-
-	return 0;
-}
-
-int ds_get_pebs_reset(struct pebs_tracer *tracer, u64 *value)
+int ds_reset_pebs(struct pebs_tracer *tracer)
 {
 	if (!tracer)
 		return -EINVAL;
 
-	if (!value)
-		return -EINVAL;
+	tracer->trace.ds.top = tracer->trace.ds.begin;
 
-	*value = *(u64 *)(tracer->ds.context->ds + (ds_cfg.sizeof_field * 8));
+	ds_set(tracer->ds.context->ds, ds_bts, ds_index,
+	       (unsigned long)tracer->trace.ds.top);
 
 	return 0;
 }
@@ -746,35 +894,59 @@
 	return 0;
 }
 
-static const struct ds_configuration ds_cfg_var = {
-	.sizeof_ds    = sizeof(long) * 12,
-	.sizeof_field = sizeof(long),
-	.sizeof_rec[ds_bts]   = sizeof(long) * 3,
+static const struct ds_configuration ds_cfg_netburst = {
+	.name = "netburst",
+	.ctl[dsf_bts]		= (1 << 2) | (1 << 3),
+	.ctl[dsf_bts_kernel]	= (1 << 5),
+	.ctl[dsf_bts_user]	= (1 << 6),
+
+	.sizeof_field		= sizeof(long),
+	.sizeof_rec[ds_bts]	= sizeof(long) * 3,
 #ifdef __i386__
-	.sizeof_rec[ds_pebs]  = sizeof(long) * 10
+	.sizeof_rec[ds_pebs]	= sizeof(long) * 10,
 #else
-	.sizeof_rec[ds_pebs]  = sizeof(long) * 18
+	.sizeof_rec[ds_pebs]	= sizeof(long) * 18,
 #endif
 };
-static const struct ds_configuration ds_cfg_64 = {
-	.sizeof_ds    = 8 * 12,
-	.sizeof_field = 8,
-	.sizeof_rec[ds_bts]   = 8 * 3,
+static const struct ds_configuration ds_cfg_pentium_m = {
+	.name = "pentium m",
+	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
+
+	.sizeof_field		= sizeof(long),
+	.sizeof_rec[ds_bts]	= sizeof(long) * 3,
 #ifdef __i386__
-	.sizeof_rec[ds_pebs]  = 8 * 10
+	.sizeof_rec[ds_pebs]	= sizeof(long) * 10,
 #else
-	.sizeof_rec[ds_pebs]  = 8 * 18
+	.sizeof_rec[ds_pebs]	= sizeof(long) * 18,
 #endif
 };
+static const struct ds_configuration ds_cfg_core2 = {
+	.name = "core 2",
+	.ctl[dsf_bts]		= (1 << 6) | (1 << 7),
+	.ctl[dsf_bts_kernel]	= (1 << 9),
+	.ctl[dsf_bts_user]	= (1 << 10),
+
+	.sizeof_field		= 8,
+	.sizeof_rec[ds_bts]	= 8 * 3,
+	.sizeof_rec[ds_pebs]	= 8 * 18,
+};
 
-static inline void
+static void
 ds_configure(const struct ds_configuration *cfg)
 {
+	memset(&ds_cfg, 0, sizeof(ds_cfg));
 	ds_cfg = *cfg;
 
-	printk(KERN_INFO "DS available\n");
+	printk(KERN_INFO "[ds] using %s configuration\n", ds_cfg.name);
 
-	WARN_ON_ONCE(MAX_SIZEOF_DS < ds_cfg.sizeof_ds);
+	if (!cpu_has_bts) {
+		ds_cfg.ctl[dsf_bts] = 0;
+		printk(KERN_INFO "[ds] bts not available\n");
+	}
+	if (!cpu_has_pebs)
+		printk(KERN_INFO "[ds] pebs not available\n");
+
+	WARN_ON_ONCE(MAX_SIZEOF_DS < (12 * ds_cfg.sizeof_field));
 }
 
 void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
@@ -787,10 +959,10 @@
 			break;
 		case 0xD:
 		case 0xE: /* Pentium M */
-			ds_configure(&ds_cfg_var);
+			ds_configure(&ds_cfg_pentium_m);
 			break;
 		default: /* Core2, Atom, ... */
-			ds_configure(&ds_cfg_64);
+			ds_configure(&ds_cfg_core2);
 			break;
 		}
 		break;
@@ -799,7 +971,7 @@
 		case 0x0:
 		case 0x1:
 		case 0x2: /* Netburst */
-			ds_configure(&ds_cfg_var);
+			ds_configure(&ds_cfg_netburst);
 			break;
 		default:
 			/* sorry, don't know about them */
@@ -812,14 +984,41 @@
 	}
 }
 
-void ds_free(struct ds_context *context)
+/*
+ * Change the DS configuration from tracing prev to tracing next.
+ */
+void ds_switch_to(struct task_struct *prev, struct task_struct *next)
 {
-	/* This is called when the task owning the parameter context
-	 * is dying. There should not be any user of that context left
-	 * to disturb us, anymore. */
-	unsigned long leftovers = context->count;
-	while (leftovers--) {
-		put_tracer(context->task);
-		ds_put_context(context);
+	struct ds_context *prev_ctx = prev->thread.ds_ctx;
+	struct ds_context *next_ctx = next->thread.ds_ctx;
+
+	if (prev_ctx) {
+		update_debugctlmsr(0);
+
+		if (prev_ctx->bts_master &&
+		    (prev_ctx->bts_master->trace.ds.flags & BTS_TIMESTAMPS)) {
+			struct bts_struct ts = {
+				.qualifier = bts_task_departs,
+				.variant.timestamp.jiffies = jiffies_64,
+				.variant.timestamp.pid = prev->pid
+			};
+			bts_write(prev_ctx->bts_master, &ts);
+		}
+	}
+
+	if (next_ctx) {
+		if (next_ctx->bts_master &&
+		    (next_ctx->bts_master->trace.ds.flags & BTS_TIMESTAMPS)) {
+			struct bts_struct ts = {
+				.qualifier = bts_task_arrives,
+				.variant.timestamp.jiffies = jiffies_64,
+				.variant.timestamp.pid = next->pid
+			};
+			bts_write(next_ctx->bts_master, &ts);
+		}
+
+		wrmsrl(MSR_IA32_DS_AREA, (unsigned long)next_ctx->ds);
 	}
+
+	update_debugctlmsr(next->thread.debugctlmsr);
 }
Index: gits/arch/x86/kernel/process_32.c
===================================================================
--- gits.orig/arch/x86/kernel/process_32.c	2008-12-11 10:44:36.000000000 +0100
+++ gits/arch/x86/kernel/process_32.c	2008-12-11 11:20:54.000000000 +0100
@@ -252,11 +252,14 @@
 		put_cpu();
 	}
 #ifdef CONFIG_X86_DS
-	/* Free any DS contexts that have not been properly released. */
-	if (unlikely(current->thread.ds_ctx)) {
-		/* we clear debugctl to make sure DS is not used. */
-		update_debugctlmsr(0);
-		ds_free(current->thread.ds_ctx);
+	/* Free any BTS tracers that have not been properly released. */
+	if (unlikely(current->bts)) {
+		ds_release_bts(current->bts);
+		current->bts = NULL;
+
+		kfree(current->bts_buffer);
+		current->bts_buffer = NULL;
+		current->bts_size = 0;
 	}
 #endif /* CONFIG_X86_DS */
 }
@@ -420,48 +423,19 @@
 	return 0;
 }
 
-#ifdef CONFIG_X86_DS
-static int update_debugctl(struct thread_struct *prev,
-			struct thread_struct *next, unsigned long debugctl)
-{
-	unsigned long ds_prev = 0;
-	unsigned long ds_next = 0;
-
-	if (prev->ds_ctx)
-		ds_prev = (unsigned long)prev->ds_ctx->ds;
-	if (next->ds_ctx)
-		ds_next = (unsigned long)next->ds_ctx->ds;
-
-	if (ds_next != ds_prev) {
-		/* we clear debugctl to make sure DS
-		 * is not in use when we change it */
-		debugctl = 0;
-		update_debugctlmsr(0);
-		wrmsr(MSR_IA32_DS_AREA, ds_next, 0);
-	}
-	return debugctl;
-}
-#else
-static int update_debugctl(struct thread_struct *prev,
-			struct thread_struct *next, unsigned long debugctl)
-{
-	return debugctl;
-}
-#endif /* CONFIG_X86_DS */
-
 static noinline void
 __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		 struct tss_struct *tss)
 {
 	struct thread_struct *prev, *next;
-	unsigned long debugctl;
 
 	prev = &prev_p->thread;
 	next = &next_p->thread;
 
-	debugctl = update_debugctl(prev, next, prev->debugctlmsr);
-
-	if (next->debugctlmsr != debugctl)
+	if (test_tsk_thread_flag(next_p, TIF_DS_AREA_MSR) ||
+	    test_tsk_thread_flag(prev_p, TIF_DS_AREA_MSR))
+		ds_switch_to(prev_p, next_p);
+	else if (next->debugctlmsr != prev->debugctlmsr)
 		update_debugctlmsr(next->debugctlmsr);
 
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
@@ -483,15 +457,6 @@
 			hard_enable_TSC();
 	}
 
-#ifdef CONFIG_X86_PTRACE_BTS
-	if (test_tsk_thread_flag(prev_p, TIF_BTS_TRACE_TS))
-		ptrace_bts_take_timestamp(prev_p, BTS_TASK_DEPARTS);
-
-	if (test_tsk_thread_flag(next_p, TIF_BTS_TRACE_TS))
-		ptrace_bts_take_timestamp(next_p, BTS_TASK_ARRIVES);
-#endif /* CONFIG_X86_PTRACE_BTS */
-
-
 	if (!test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
 		/*
 		 * Disable the bitmap via an invalid offset. We still cache
Index: gits/arch/x86/kernel/process_64.c
===================================================================
--- gits.orig/arch/x86/kernel/process_64.c	2008-12-11 10:44:36.000000000 +0100
+++ gits/arch/x86/kernel/process_64.c	2008-12-11 11:20:54.000000000 +0100
@@ -249,11 +249,14 @@
 		put_cpu();
 	}
 #ifdef CONFIG_X86_DS
-	/* Free any DS contexts that have not been properly released. */
-	if (unlikely(t->ds_ctx)) {
-		/* we clear debugctl to make sure DS is not used. */
-		update_debugctlmsr(0);
-		ds_free(t->ds_ctx);
+	/* Free any BTS tracers that have not been properly released. */
+	if (unlikely(current->bts)) {
+		ds_release_bts(current->bts);
+		current->bts = NULL;
+
+		kfree(current->bts_buffer);
+		current->bts_buffer = NULL;
+		current->bts_size = 0;
 	}
 #endif /* CONFIG_X86_DS */
 }
@@ -483,35 +486,14 @@
 				    struct tss_struct *tss)
 {
 	struct thread_struct *prev, *next;
-	unsigned long debugctl;
 
 	prev = &prev_p->thread,
 	next = &next_p->thread;
 
-	debugctl = prev->debugctlmsr;
-
-#ifdef CONFIG_X86_DS
-	{
-		unsigned long ds_prev = 0, ds_next = 0;
-
-		if (prev->ds_ctx)
-			ds_prev = (unsigned long)prev->ds_ctx->ds;
-		if (next->ds_ctx)
-			ds_next = (unsigned long)next->ds_ctx->ds;
-
-		if (ds_next != ds_prev) {
-			/*
-			 * We clear debugctl to make sure DS
-			 * is not in use when we change it:
-			 */
-			debugctl = 0;
-			update_debugctlmsr(0);
-			wrmsrl(MSR_IA32_DS_AREA, ds_next);
-		}
-	}
-#endif /* CONFIG_X86_DS */
-
-	if (next->debugctlmsr != debugctl)
+	if (test_tsk_thread_flag(next_p, TIF_DS_AREA_MSR) ||
+	    test_tsk_thread_flag(prev_p, TIF_DS_AREA_MSR))
+		ds_switch_to(prev_p, next_p);
+	else if (next->debugctlmsr != prev->debugctlmsr)
 		update_debugctlmsr(next->debugctlmsr);
 
 	if (test_tsk_thread_flag(next_p, TIF_DEBUG)) {
@@ -546,14 +528,6 @@
 		 */
 		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
 	}
-
-#ifdef CONFIG_X86_PTRACE_BTS
-	if (test_tsk_thread_flag(prev_p, TIF_BTS_TRACE_TS))
-		ptrace_bts_take_timestamp(prev_p, BTS_TASK_DEPARTS);
-
-	if (test_tsk_thread_flag(next_p, TIF_BTS_TRACE_TS))
-		ptrace_bts_take_timestamp(next_p, BTS_TASK_ARRIVES);
-#endif /* CONFIG_X86_PTRACE_BTS */
 }
 
 /*
Index: gits/arch/x86/kernel/ptrace.c
===================================================================
--- gits.orig/arch/x86/kernel/ptrace.c	2008-12-11 11:20:53.000000000 +0100
+++ gits/arch/x86/kernel/ptrace.c	2008-12-11 11:20:54.000000000 +0100
@@ -581,153 +581,73 @@
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
 static int ptrace_bts_read_record(struct task_struct *child, size_t index,
 				  struct bts_struct __user *out)
 {
-	struct bts_struct ret;
-	const void *bts_record;
-	size_t bts_index, bts_end;
+	const struct bts_trace *trace;
+	struct bts_struct bts;
+	const unsigned char *at;
 	int error;
 
-	error = ds_get_bts_end(child->bts, &bts_end);
-	if (error < 0)
-		return error;
-
-	if (bts_end <= index)
-		return -EINVAL;
-
-	error = ds_get_bts_index(child->bts, &bts_index);
-	if (error < 0)
-		return error;
+	trace = ds_read_bts(child->bts);
+	if (!trace)
+		return -EPERM;
+
+	at = trace->ds.top - ((index + 1) * trace->ds.size);
+	if ((void *)at < trace->ds.begin)
+		at += (trace->ds.n * trace->ds.size);
 
-	/* translate the ptrace bts index into the ds bts index */
-	bts_index += bts_end - (index + 1);
-	if (bts_end <= bts_index)
-		bts_index -= bts_end;
+	if (!trace->read)
+		return -EOPNOTSUPP;
 
-	error = ds_access_bts(child->bts, bts_index, &bts_record);
+	error = trace->read(child->bts, at, &bts);
 	if (error < 0)
 		return error;
 
-	ptrace_bts_translate_record(&ret, bts_record);
-
-	if (copy_to_user(out, &ret, sizeof(ret)))
+	if (copy_to_user(out, &bts, sizeof(bts)))
 		return -EFAULT;
 
-	return sizeof(ret);
+	return sizeof(bts);
 }
 
 static int ptrace_bts_drain(struct task_struct *child,
 			    long size,
 			    struct bts_struct __user *out)
 {
-	struct bts_struct ret;
-	const unsigned char *raw;
-	size_t end, i;
-	int error;
+	const struct bts_trace *trace;
+	const unsigned char *at;
+	int error, drained = 0;
+
+	trace = ds_read_bts(child->bts);
+	if (!trace)
+		return -EPERM;
 
-	error = ds_get_bts_index(child->bts, &end);
-	if (error < 0)
-		return error;
+	if (!trace->read)
+		return -EOPNOTSUPP;
 
-	if (size < (end * sizeof(struct bts_struct)))
+	if (size < (trace->ds.top - trace->ds.begin))
 		return -EIO;
 
-	error = ds_access_bts(child->bts, 0, (const void **)&raw);
-	if (error < 0)
-		return error;
-
-	for (i = 0; i < end; i++, out++, raw += bts_cfg.sizeof_bts) {
-		ptrace_bts_translate_record(&ret, raw);
+	for (at = trace->ds.begin; (void *)at < trace->ds.top;
+	     out++, drained++, at += trace->ds.size) {
+		struct bts_struct bts;
+		int error;
+
+		error = trace->read(child->bts, at, &bts);
+		if (error < 0)
+			return error;
 
-		if (copy_to_user(out, &ret, sizeof(ret)))
+		if (copy_to_user(out, &bts, sizeof(bts)))
 			return -EFAULT;
 	}
 
-	error = ds_clear_bts(child->bts);
+	memset(trace->ds.begin, 0, trace->ds.n * trace->ds.size);
+
+	error = ds_reset_bts(child->bts);
 	if (error < 0)
 		return error;
 
-	return end;
+	return drained;
 }
 
 static int ptrace_bts_config(struct task_struct *child,
@@ -735,136 +655,89 @@
 			     const struct ptrace_bts_config __user *ucfg)
 {
 	struct ptrace_bts_config cfg;
-	int error = 0;
-
-	error = -EOPNOTSUPP;
-	if (!bts_cfg.sizeof_bts)
-		goto errout;
+	unsigned int flags = 0;
 
-	error = -EIO;
 	if (cfg_size < sizeof(cfg))
-		goto errout;
+		return -EIO;
 
-	error = -EFAULT;
 	if (copy_from_user(&cfg, ucfg, sizeof(cfg)))
-		goto errout;
+		return -EFAULT;
 
-	error = -EINVAL;
-	if ((cfg.flags & PTRACE_BTS_O_SIGNAL) &&
-	    !(cfg.flags & PTRACE_BTS_O_ALLOC))
-		goto errout;
+	if (child->bts) {
+		ds_release_bts(child->bts);
+		child->bts = NULL;
+	}
 
-	if (cfg.flags & PTRACE_BTS_O_ALLOC) {
-		bts_ovfl_callback_t ovfl = NULL;
-		unsigned int sig = 0;
+	if (cfg.flags & PTRACE_BTS_O_SIGNAL) {
+		if (!cfg.signal)
+			return -EINVAL;
 
-		error = -EINVAL;
-		if (cfg.size < (10 * bts_cfg.sizeof_bts))
-			goto errout;
+		return -EOPNOTSUPP;
 
-		if (cfg.flags & PTRACE_BTS_O_SIGNAL) {
-			if (!cfg.signal)
-				goto errout;
+		child->thread.bts_ovfl_signal = cfg.signal;
+	}
 
-			error = -EOPNOTSUPP;
-			goto errout;
+	if ((cfg.flags & PTRACE_BTS_O_ALLOC) &&
+	    (cfg.size != child->bts_size)) {
+		kfree(child->bts_buffer);
 
-			sig  = cfg.signal;
+		child->bts_size = cfg.size;
+		child->bts_buffer = kzalloc(cfg.size, GFP_KERNEL);
+		if (!child->bts_buffer) {
+			child->bts_size = 0;
+			return -ENOMEM;
 		}
+	}
 
-		if (child->bts) {
-			(void)ds_release_bts(child->bts);
-			kfree(child->bts_buffer);
+	if (cfg.flags & PTRACE_BTS_O_TRACE)
+		flags |= BTS_USER;
 
-			child->bts = NULL;
-			child->bts_buffer = NULL;
-		}
+	if (cfg.flags & PTRACE_BTS_O_SCHED)
+		flags |= BTS_TIMESTAMPS;
 
-		error = -ENOMEM;
-		child->bts_buffer = kzalloc(cfg.size, GFP_KERNEL);
-		if (!child->bts_buffer)
-			goto errout;
+	child->bts = ds_request_bts(child, child->bts_buffer, child->bts_size,
+				    /* ovfl = */ NULL, /* th = */ (size_t)-1,
+				    flags);
+	if (IS_ERR(child->bts)) {
+		int error = PTR_ERR(child->bts);
 
-		child->bts = ds_request_bts(child, child->bts_buffer, cfg.size,
-					    ovfl, /* th = */ (size_t)-1);
-		if (IS_ERR(child->bts)) {
-			error = PTR_ERR(child->bts);
-			kfree(child->bts_buffer);
-			child->bts = NULL;
-			child->bts_buffer = NULL;
-			goto errout;
-		}
+		kfree(child->bts_buffer);
+		child->bts = NULL;
+		child->bts_buffer = NULL;
+		child->bts_size = 0;
 
-		child->thread.bts_ovfl_signal = sig;
+		return error;
 	}
 
-	error = -EINVAL;
-	if (!child->thread.ds_ctx && cfg.flags)
-		goto errout;
-
-	if (cfg.flags & PTRACE_BTS_O_TRACE)
-		child->thread.debugctlmsr |= bts_cfg.debugctl_mask;
-	else
-		child->thread.debugctlmsr &= ~bts_cfg.debugctl_mask;
-
-	if (cfg.flags & PTRACE_BTS_O_SCHED)
-		set_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
-	else
-		clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
-
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
+	return sizeof(cfg);
 }
 
 static int ptrace_bts_status(struct task_struct *child,
 			     long cfg_size,
 			     struct ptrace_bts_config __user *ucfg)
 {
+	const struct bts_trace *trace;
 	struct ptrace_bts_config cfg;
-	size_t end;
-	const void *base, *max;
-	int error;
 
 	if (cfg_size < sizeof(cfg))
 		return -EIO;
 
-	error = ds_get_bts_end(child->bts, &end);
-	if (error < 0)
-		return error;
-
-	error = ds_access_bts(child->bts, /* index = */ 0, &base);
-	if (error < 0)
-		return error;
-
-	error = ds_access_bts(child->bts, /* index = */ end, &max);
-	if (error < 0)
-		return error;
+	trace = ds_read_bts(child->bts);
+	if (!trace)
+		return -EPERM;
 
 	memset(&cfg, 0, sizeof(cfg));
-	cfg.size = (max - base);
+	cfg.size = trace->ds.end - trace->ds.begin;
 	cfg.signal = child->thread.bts_ovfl_signal;
 	cfg.bts_size = sizeof(struct bts_struct);
 
 	if (cfg.signal)
 		cfg.flags |= PTRACE_BTS_O_SIGNAL;
 
-	if (test_tsk_thread_flag(child, TIF_DEBUGCTLMSR) &&
-	    child->thread.debugctlmsr & bts_cfg.debugctl_mask)
+	if (trace->ds.flags & BTS_USER)
 		cfg.flags |= PTRACE_BTS_O_TRACE;
 
-	if (test_tsk_thread_flag(child, TIF_BTS_TRACE_TS))
+	if (trace->ds.flags & BTS_TIMESTAMPS)
 		cfg.flags |= PTRACE_BTS_O_SCHED;
 
 	if (copy_to_user(ucfg, &cfg, sizeof(cfg)))
@@ -873,105 +746,28 @@
 	return sizeof(cfg);
 }
 
-static int ptrace_bts_write_record(struct task_struct *child,
-				   const struct bts_struct *in)
+static int ptrace_bts_clear(struct task_struct *child)
 {
-	unsigned char bts_record[BTS_MAX_RECORD_SIZE];
+	const struct bts_trace *trace;
 
-	if (BTS_MAX_RECORD_SIZE < bts_cfg.sizeof_bts)
-		return -EOVERFLOW;
+	trace = ds_read_bts(child->bts);
+	if (!trace)
+		return -EPERM;
 
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
+	memset(trace->ds.begin, 0, trace->ds.n * trace->ds.size);
 
-	return ds_write_bts(child->bts, bts_record, bts_cfg.sizeof_bts);
+	return ds_reset_bts(child->bts);
 }
 
-void ptrace_bts_take_timestamp(struct task_struct *tsk,
-			       enum bts_qualifier qualifier)
+static int ptrace_bts_size(struct task_struct *child)
 {
-	struct bts_struct rec = {
-		.qualifier = qualifier,
-		.variant.jiffies = jiffies_64
-	};
+	const struct bts_trace *trace;
 
-	ptrace_bts_write_record(tsk, &rec);
-}
-
-static const struct bts_configuration bts_cfg_netburst = {
-	.sizeof_bts    = sizeof(long) * 3,
-	.sizeof_field  = sizeof(long),
-	.debugctl_mask = (1<<2)|(1<<3)|(1<<5)
-};
-
-static const struct bts_configuration bts_cfg_pentium_m = {
-	.sizeof_bts    = sizeof(long) * 3,
-	.sizeof_field  = sizeof(long),
-	.debugctl_mask = (1<<6)|(1<<7)
-};
-
-static const struct bts_configuration bts_cfg_core2 = {
-	.sizeof_bts    = 8 * 3,
-	.sizeof_field  = 8,
-	.debugctl_mask = (1<<6)|(1<<7)|(1<<9)
-};
+	trace = ds_read_bts(child->bts);
+	if (!trace)
+		return -EPERM;
 
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
-		case 0 ... 0xC:
-			/* sorry, don't know about them */
-			break;
-		case 0xD:
-		case 0xE: /* Pentium M */
-			bts_configure(&bts_cfg_pentium_m);
-			break;
-		default: /* Core2, Atom, ... */
-			bts_configure(&bts_cfg_core2);
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
+	return (trace->ds.top - trace->ds.begin) / trace->ds.size;
 }
 #endif /* CONFIG_X86_PTRACE_BTS */
 
@@ -988,15 +784,12 @@
 #endif
 #ifdef CONFIG_X86_PTRACE_BTS
 	if (child->bts) {
-		(void)ds_release_bts(child->bts);
+		ds_release_bts(child->bts);
+		child->bts = NULL;
+
 		kfree(child->bts_buffer);
 		child->bts_buffer = NULL;
-
-		child->thread.debugctlmsr &= ~bts_cfg.debugctl_mask;
-		if (!child->thread.debugctlmsr)
-			clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
-
-		clear_tsk_thread_flag(child, TIF_BTS_TRACE_TS);
+		child->bts_size = 0;
 	}
 #endif /* CONFIG_X86_PTRACE_BTS */
 }
@@ -1129,16 +922,9 @@
 			(child, data, (struct ptrace_bts_config __user *)addr);
 		break;
 
-	case PTRACE_BTS_SIZE: {
-		size_t size;
-
-		ret = ds_get_bts_index(child->bts, &size);
-		if (ret == 0) {
-			WARN_ON_ONCE(size != (int) size);
-			ret = (int) size;
-		}
+	case PTRACE_BTS_SIZE:
+		ret = ptrace_bts_size(child);
 		break;
-	}
 
 	case PTRACE_BTS_GET:
 		ret = ptrace_bts_read_record
@@ -1146,7 +932,7 @@
 		break;
 
 	case PTRACE_BTS_CLEAR:
-		ret = ds_clear_bts(child->bts);
+		ret = ptrace_bts_clear(child);
 		break;
 
 	case PTRACE_BTS_DRAIN:
@@ -1409,6 +1195,14 @@
 
 	case PTRACE_GET_THREAD_AREA:
 	case PTRACE_SET_THREAD_AREA:
+#ifdef CONFIG_X86_PTRACE_BTS
+	case PTRACE_BTS_CONFIG:
+	case PTRACE_BTS_STATUS:
+	case PTRACE_BTS_SIZE:
+	case PTRACE_BTS_GET:
+	case PTRACE_BTS_CLEAR:
+	case PTRACE_BTS_DRAIN:
+#endif /* CONFIG_X86_PTRACE_BTS */
 		return arch_ptrace(child, request, addr, data);
 
 	default:
Index: gits/include/linux/sched.h
===================================================================
--- gits.orig/include/linux/sched.h	2008-12-11 10:45:10.000000000 +0100
+++ gits/include/linux/sched.h	2008-12-11 11:20:54.000000000 +0100
@@ -1187,6 +1187,7 @@
 	 * The buffer to hold the BTS data.
 	 */
 	void *bts_buffer;
+    size_t bts_size;
 #endif /* CONFIG_X86_PTRACE_BTS */
 
 	/* PID/PID hash table linkage. */
Index: gits/arch/x86/include/asm/thread_info.h
===================================================================
--- gits.orig/arch/x86/include/asm/thread_info.h	2008-12-11 10:44:36.000000000 +0100
+++ gits/arch/x86/include/asm/thread_info.h	2008-12-11 11:20:54.000000000 +0100
@@ -94,7 +94,6 @@
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
 #define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
 #define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
-#define TIF_BTS_TRACE_TS	27      /* record scheduling event timestamps */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -117,7 +116,6 @@
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
 #define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
 #define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
-#define _TIF_BTS_TRACE_TS	(1 << TIF_BTS_TRACE_TS)
 
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
@@ -143,8 +141,7 @@
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
-	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_BTS_TRACE_TS| \
-								_TIF_NOTSC)
+	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_NOTSC)
 
 #define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)
Index: gits/arch/x86/include/asm/ptrace.h
===================================================================
--- gits.orig/arch/x86/include/asm/ptrace.h	2008-12-11 10:44:35.000000000 +0100
+++ gits/arch/x86/include/asm/ptrace.h	2008-12-11 11:20:54.000000000 +0100
@@ -6,7 +6,6 @@
 #include <asm/processor-flags.h>
 
 #ifdef __KERNEL__
-#include <asm/ds.h>		/* the DS BTS struct is used for ptrace too */
 #include <asm/segment.h>
 #endif
 
@@ -128,34 +127,6 @@
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
@@ -163,13 +134,6 @@
 struct cpuinfo_x86;
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
Index: gits/arch/x86/kernel/cpu/intel.c
===================================================================
--- gits.orig/arch/x86/kernel/cpu/intel.c	2008-12-11 10:44:36.000000000 +0100
+++ gits/arch/x86/kernel/cpu/intel.c	2008-12-11 11:20:54.000000000 +0100
@@ -11,7 +11,6 @@
 #include <asm/pgtable.h>
 #include <asm/msr.h>
 #include <asm/uaccess.h>
-#include <asm/ptrace.h>
 #include <asm/ds.h>
 #include <asm/bugs.h>
 
@@ -309,9 +308,6 @@
 		set_cpu_cap(c, X86_FEATURE_P3);
 #endif
 
-	if (cpu_has_bts)
-		ptrace_bts_init_intel(c);
-
 	detect_extended_topology(c);
 	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
 		/*
Index: gits/arch/x86/include/asm/processor.h
===================================================================
--- gits.orig/arch/x86/include/asm/processor.h	2008-12-11 10:44:35.000000000 +0100
+++ gits/arch/x86/include/asm/processor.h	2008-12-11 11:20:54.000000000 +0100
@@ -756,6 +756,19 @@
 extern void cpu_init(void);
 extern void init_gdt(int cpu);
 
+static inline unsigned long get_debugctlmsr(void)
+{
+    unsigned long debugctlmsr = 0;
+
+#ifndef CONFIG_X86_DEBUGCTLMSR
+	if (boot_cpu_data.x86 < 6)
+		return 0;
+#endif
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctlmsr);
+
+    return debugctlmsr;
+}
+
 static inline void update_debugctlmsr(unsigned long debugctlmsr)
 {
 #ifndef CONFIG_X86_DEBUGCTLMSR
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

