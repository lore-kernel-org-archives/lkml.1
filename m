Return-Path: <linux-kernel-owner+w=401wt.eu-S1761232AbZEGJYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761232AbZEGJYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761330AbZEGJXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:23:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:40414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760879AbZEGJXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:23:15 -0400
Date: Thu, 7 May 2009 09:21:59 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20090403144550.712401000@intel.com>
References: <20090403144550.712401000@intel.com>
Subject: [tip:tracing/core] mm, x86, ptrace, bts: defer branch trace stopping
Message-ID: <tip-e2b371f00a6f529f6362654239bdec8dcd510760@git.kernel.org>
Git-Commit-ID: e2b371f00a6f529f6362654239bdec8dcd510760
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:22:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2b371f00a6f529f6362654239bdec8dcd510760
Gitweb:     http://git.kernel.org/tip/e2b371f00a6f529f6362654239bdec8dcd510760
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:35 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:13 +0200

mm, x86, ptrace, bts: defer branch trace stopping

When a ptraced task is unlinked, we need to stop branch tracing for
that task.

Since the unlink is called with interrupts disabled, and we need
interrupts enabled to stop branch tracing, we defer the work.

Collect all branch tracing related stuff in a branch tracing context.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144550.712401000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/processor.h |    4 -
 arch/x86/kernel/ptrace.c         |  254 +++++++++++++++++++++++++-------------
 include/linux/mm.h               |    3 +-
 include/linux/sched.h            |    9 +-
 mm/mlock.c                       |   13 +-
 5 files changed, 179 insertions(+), 104 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 34c5237..2483807 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -458,10 +458,6 @@ struct thread_struct {
 /* Debug Store context; see include/asm-x86/ds.h; goes into MSR_IA32_DS_AREA */
 	struct ds_context	*ds_ctx;
 #endif /* CONFIG_X86_DS */
-#ifdef CONFIG_X86_PTRACE_BTS
-/* the signal to send on a bts buffer overflow */
-	unsigned int	bts_ovfl_signal;
-#endif /* CONFIG_X86_PTRACE_BTS */
 };
 
 static inline unsigned long native_get_debugreg(int regno)
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index fe9345c..7c21d1e 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -22,6 +22,7 @@
 #include <linux/seccomp.h>
 #include <linux/signal.h>
 #include <linux/ftrace.h>
+#include <linux/workqueue.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -577,17 +578,119 @@ static int ioperm_get(struct task_struct *target,
 }
 
 #ifdef CONFIG_X86_PTRACE_BTS
+/*
+ * A branch trace store context.
+ *
+ * Contexts may only be installed by ptrace_bts_config() and only for
+ * ptraced tasks.
+ *
+ * Contexts are destroyed when the tracee is detached from the tracer.
+ * The actual destruction work requires interrupts enabled, so the
+ * work is deferred and will be scheduled during __ptrace_unlink().
+ *
+ * Contexts hold an additional task_struct reference on the traced
+ * task, as well as a reference on the tracer's mm.
+ *
+ * Ptrace already holds a task_struct for the duration of ptrace operations,
+ * but since destruction is deferred, it may be executed after both
+ * tracer and tracee exited.
+ */
+struct bts_context {
+	/* The branch trace handle. */
+	struct bts_tracer	*tracer;
+
+	/* The buffer used to store the branch trace and its size. */
+	void			*buffer;
+	unsigned int		size;
+
+	/* The mm that paid for the above buffer. */
+	struct mm_struct	*mm;
+
+	/* The task this context belongs to. */
+	struct task_struct	*task;
+
+	/* The signal to send on a bts buffer overflow. */
+	unsigned int		bts_ovfl_signal;
+
+	/* The work struct to destroy a context. */
+	struct work_struct	work;
+};
+
+static inline void alloc_bts_buffer(struct bts_context *context,
+				    unsigned int size)
+{
+	void *buffer;
+
+	buffer = alloc_locked_buffer(size);
+	if (buffer) {
+		context->buffer = buffer;
+		context->size = size;
+		context->mm = get_task_mm(current);
+	}
+}
+
+static inline void free_bts_buffer(struct bts_context *context)
+{
+	if (!context->buffer)
+		return;
+
+	kfree(context->buffer);
+	context->buffer = NULL;
+
+	refund_locked_buffer_memory(context->mm, context->size);
+	context->size = 0;
+
+	mmput(context->mm);
+	context->mm = NULL;
+}
+
+static void free_bts_context_work(struct work_struct *w)
+{
+	struct bts_context *context;
+
+	context = container_of(w, struct bts_context, work);
+
+	ds_release_bts(context->tracer);
+	put_task_struct(context->task);
+	free_bts_buffer(context);
+	kfree(context);
+}
+
+static inline void free_bts_context(struct bts_context *context)
+{
+	INIT_WORK(&context->work, free_bts_context_work);
+	schedule_work(&context->work);
+}
+
+static inline struct bts_context *alloc_bts_context(struct task_struct *task)
+{
+	struct bts_context *context = kzalloc(sizeof(*context), GFP_KERNEL);
+	if (context) {
+		context->task = task;
+		task->bts = context;
+
+		get_task_struct(task);
+	}
+
+	return context;
+}
+
 static int ptrace_bts_read_record(struct task_struct *child, size_t index,
 				  struct bts_struct __user *out)
 {
+	struct bts_context *context;
 	const struct bts_trace *trace;
 	struct bts_struct bts;
 	const unsigned char *at;
 	int error;
 
-	trace = ds_read_bts(child->bts);
+	context = child->bts;
+	if (!context)
+		return -ESRCH;
+
+	trace = ds_read_bts(context->tracer);
 	if (!trace)
-		return -EPERM;
+		return -ESRCH;
 
 	at = trace->ds.top - ((index + 1) * trace->ds.size);
 	if ((void *)at < trace->ds.begin)
@@ -596,7 +699,7 @@ static int ptrace_bts_read_record(struct task_struct *child, size_t index,
 	if (!trace->read)
 		return -EOPNOTSUPP;
 
-	error = trace->read(child->bts, at, &bts);
+	error = trace->read(context->tracer, at, &bts);
 	if (error < 0)
 		return error;
 
@@ -610,13 +713,18 @@ static int ptrace_bts_drain(struct task_struct *child,
 			    long size,
 			    struct bts_struct __user *out)
 {
+	struct bts_context *context;
 	const struct bts_trace *trace;
 	const unsigned char *at;
 	int error, drained = 0;
 
-	trace = ds_read_bts(child->bts);
+	context = child->bts;
+	if (!context)
+		return -ESRCH;
+
+	trace = ds_read_bts(context->tracer);
 	if (!trace)
-		return -EPERM;
+		return -ESRCH;
 
 	if (!trace->read)
 		return -EOPNOTSUPP;
@@ -627,9 +735,8 @@ static int ptrace_bts_drain(struct task_struct *child,
 	for (at = trace->ds.begin; (void *)at < trace->ds.top;
 	     out++, drained++, at += trace->ds.size) {
 		struct bts_struct bts;
-		int error;
 
-		error = trace->read(child->bts, at, &bts);
+		error = trace->read(context->tracer, at, &bts);
 		if (error < 0)
 			return error;
 
@@ -639,35 +746,18 @@ static int ptrace_bts_drain(struct task_struct *child,
 
 	memset(trace->ds.begin, 0, trace->ds.n * trace->ds.size);
 
-	error = ds_reset_bts(child->bts);
+	error = ds_reset_bts(context->tracer);
 	if (error < 0)
 		return error;
 
 	return drained;
 }
 
-static int ptrace_bts_allocate_buffer(struct task_struct *child, size_t size)
-{
-	child->bts_buffer = alloc_locked_buffer(size);
-	if (!child->bts_buffer)
-		return -ENOMEM;
-
-	child->bts_size = size;
-
-	return 0;
-}
-
-static void ptrace_bts_free_buffer(struct task_struct *child)
-{
-	free_locked_buffer(child->bts_buffer, child->bts_size);
-	child->bts_buffer = NULL;
-	child->bts_size = 0;
-}
-
 static int ptrace_bts_config(struct task_struct *child,
 			     long cfg_size,
 			     const struct ptrace_bts_config __user *ucfg)
 {
+	struct bts_context *context;
 	struct ptrace_bts_config cfg;
 	unsigned int flags = 0;
 
@@ -677,28 +767,31 @@ static int ptrace_bts_config(struct task_struct *child,
 	if (copy_from_user(&cfg, ucfg, sizeof(cfg)))
 		return -EFAULT;
 
-	if (child->bts) {
-		ds_release_bts(child->bts);
-		child->bts = NULL;
-	}
+	context = child->bts;
+	if (!context)
+		context = alloc_bts_context(child);
+	if (!context)
+		return -ENOMEM;
 
 	if (cfg.flags & PTRACE_BTS_O_SIGNAL) {
 		if (!cfg.signal)
 			return -EINVAL;
 
-		child->thread.bts_ovfl_signal = cfg.signal;
 		return -EOPNOTSUPP;
+		context->bts_ovfl_signal = cfg.signal;
 	}
 
-	if ((cfg.flags & PTRACE_BTS_O_ALLOC) &&
-	    (cfg.size != child->bts_size)) {
-		int error;
+	ds_release_bts(context->tracer);
+	context->tracer = NULL;
 
-		ptrace_bts_free_buffer(child);
+	if ((cfg.flags & PTRACE_BTS_O_ALLOC) && (cfg.size != context->size)) {
+		free_bts_buffer(context);
+		if (!cfg.size)
+			return 0;
 
-		error = ptrace_bts_allocate_buffer(child, cfg.size);
-		if (error < 0)
-			return error;
+		alloc_bts_buffer(context, cfg.size);
+		if (!context->buffer)
+			return -ENOMEM;
 	}
 
 	if (cfg.flags & PTRACE_BTS_O_TRACE)
@@ -707,15 +800,13 @@ static int ptrace_bts_config(struct task_struct *child,
 	if (cfg.flags & PTRACE_BTS_O_SCHED)
 		flags |= BTS_TIMESTAMPS;
 
-	child->bts = ds_request_bts(child, child->bts_buffer, child->bts_size,
-				    /* ovfl = */ NULL, /* th = */ (size_t)-1,
-				    flags);
-	if (IS_ERR(child->bts)) {
-		int error = PTR_ERR(child->bts);
-
-		ptrace_bts_free_buffer(child);
-		child->bts = NULL;
+	context->tracer = ds_request_bts(child, context->buffer, context->size,
+					 NULL, (size_t)-1, flags);
+	if (unlikely(IS_ERR(context->tracer))) {
+		int error = PTR_ERR(context->tracer);
 
+		free_bts_buffer(context);
+		context->tracer = NULL;
 		return error;
 	}
 
@@ -726,20 +817,25 @@ static int ptrace_bts_status(struct task_struct *child,
 			     long cfg_size,
 			     struct ptrace_bts_config __user *ucfg)
 {
+	struct bts_context *context;
 	const struct bts_trace *trace;
 	struct ptrace_bts_config cfg;
 
+	context = child->bts;
+	if (!context)
+		return -ESRCH;
+
 	if (cfg_size < sizeof(cfg))
 		return -EIO;
 
-	trace = ds_read_bts(child->bts);
+	trace = ds_read_bts(context->tracer);
 	if (!trace)
-		return -EPERM;
+		return -ESRCH;
 
 	memset(&cfg, 0, sizeof(cfg));
-	cfg.size = trace->ds.end - trace->ds.begin;
-	cfg.signal = child->thread.bts_ovfl_signal;
-	cfg.bts_size = sizeof(struct bts_struct);
+	cfg.size	= trace->ds.end - trace->ds.begin;
+	cfg.signal	= context->bts_ovfl_signal;
+	cfg.bts_size	= sizeof(struct bts_struct);
 
 	if (cfg.signal)
 		cfg.flags |= PTRACE_BTS_O_SIGNAL;
@@ -758,67 +854,56 @@ static int ptrace_bts_status(struct task_struct *child,
 
 static int ptrace_bts_clear(struct task_struct *child)
 {
+	struct bts_context *context;
 	const struct bts_trace *trace;
 
-	trace = ds_read_bts(child->bts);
+	context = child->bts;
+	if (!context)
+		return -ESRCH;
+
+	trace = ds_read_bts(context->tracer);
 	if (!trace)
-		return -EPERM;
+		return -ESRCH;
 
 	memset(trace->ds.begin, 0, trace->ds.n * trace->ds.size);
 
-	return ds_reset_bts(child->bts);
+	return ds_reset_bts(context->tracer);
 }
 
 static int ptrace_bts_size(struct task_struct *child)
 {
+	struct bts_context *context;
 	const struct bts_trace *trace;
 
-	trace = ds_read_bts(child->bts);
+	context = child->bts;
+	if (!context)
+		return -ESRCH;
+
+	trace = ds_read_bts(context->tracer);
 	if (!trace)
-		return -EPERM;
+		return -ESRCH;
 
 	return (trace->ds.top - trace->ds.begin) / trace->ds.size;
 }
 
-static void ptrace_bts_fork(struct task_struct *tsk)
+static inline void ptrace_bts_fork(struct task_struct *tsk)
 {
 	tsk->bts = NULL;
-	tsk->bts_buffer = NULL;
-	tsk->bts_size = 0;
-	tsk->thread.bts_ovfl_signal = 0;
 }
 
-static void ptrace_bts_untrace(struct task_struct *child)
+/*
+ * Called from __ptrace_unlink() after the child has been moved back
+ * to its original parent.
+ */
+static inline void ptrace_bts_untrace(struct task_struct *child)
 {
 	if (unlikely(child->bts)) {
-		ds_release_bts(child->bts);
+		free_bts_context(child->bts);
 		child->bts = NULL;
-
-		/* We cannot update total_vm and locked_vm since
-		   child's mm is already gone. But we can reclaim the
-		   memory. */
-		kfree(child->bts_buffer);
-		child->bts_buffer = NULL;
-		child->bts_size = 0;
 	}
 }
-
-static void ptrace_bts_detach(struct task_struct *child)
-{
-	/*
-	 * Ptrace_detach() races with ptrace_untrace() in case
-	 * the child dies and is reaped by another thread.
-	 *
-	 * We only do the memory accounting at this point and
-	 * leave the buffer deallocation and the bts tracer
-	 * release to ptrace_bts_untrace() which will be called
-	 * later on with tasklist_lock held.
-	 */
-	release_locked_buffer(child->bts_buffer, child->bts_size);
-}
 #else
 static inline void ptrace_bts_fork(struct task_struct *tsk) {}
-static inline void ptrace_bts_detach(struct task_struct *child) {}
 static inline void ptrace_bts_untrace(struct task_struct *child) {}
 #endif /* CONFIG_X86_PTRACE_BTS */
 
@@ -843,7 +928,6 @@ void ptrace_disable(struct task_struct *child)
 #ifdef TIF_SYSCALL_EMU
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 #endif
-	ptrace_bts_detach(child);
 }
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
diff --git a/include/linux/mm.h b/include/linux/mm.h
index bff1f0d..64d8ed2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -13,6 +13,7 @@
 #include <linux/prio_tree.h>
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
+#include <linux/sched.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -1321,6 +1322,6 @@ void vmemmap_populate_print_last(void);
 
 extern void *alloc_locked_buffer(size_t size);
 extern void free_locked_buffer(void *buffer, size_t size);
-extern void release_locked_buffer(void *buffer, size_t size);
+extern void refund_locked_buffer_memory(struct mm_struct *mm, size_t size);
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a5b9a83..52b8cd0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -96,8 +96,8 @@ struct exec_domain;
 struct futex_pi_state;
 struct robust_list_head;
 struct bio;
-struct bts_tracer;
 struct fs_struct;
+struct bts_context;
 
 /*
  * List of flags we want to share for kernel threads,
@@ -1210,12 +1210,7 @@ struct task_struct {
 	 * This is the tracer handle for the ptrace BTS extension.
 	 * This field actually belongs to the ptracer task.
 	 */
-	struct bts_tracer *bts;
-	/*
-	 * The buffer to hold the BTS data.
-	 */
-	void *bts_buffer;
-	size_t bts_size;
+	struct bts_context *bts;
 #endif /* CONFIG_X86_PTRACE_BTS */
 
 	/* PID/PID hash table linkage. */
diff --git a/mm/mlock.c b/mm/mlock.c
index cbe9e05..749383b 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -660,21 +660,20 @@ void *alloc_locked_buffer(size_t size)
 	return buffer;
 }
 
-void release_locked_buffer(void *buffer, size_t size)
+void refund_locked_buffer_memory(struct mm_struct *mm, size_t size)
 {
 	unsigned long pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
-	down_write(&current->mm->mmap_sem);
+	down_write(&mm->mmap_sem);
 
-	current->mm->total_vm  -= pgsz;
-	current->mm->locked_vm -= pgsz;
+	mm->total_vm  -= pgsz;
+	mm->locked_vm -= pgsz;
 
-	up_write(&current->mm->mmap_sem);
+	up_write(&mm->mmap_sem);
 }
 
 void free_locked_buffer(void *buffer, size_t size)
 {
-	release_locked_buffer(buffer, size);
-
+	refund_locked_buffer_memory(current->mm, size);
 	kfree(buffer);
 }
