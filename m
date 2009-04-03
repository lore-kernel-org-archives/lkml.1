Return-Path: <linux-kernel-owner+w=401wt.eu-S933441AbZDCOur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441AbZDCOur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932761AbZDCOqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:46:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:14809 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932362AbZDCOqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:46:03 -0400
Content-Type: multipart/mixed; boundary="===============0698488333=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="503328336"
Message-Id: <20090403144555.658136000@intel.com>
References: <20090403144332.799740000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 16:43:40 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 08/20] x86, bts, hw-branch-tracer: add _noirq variants to the debug store interface
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0698488333==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.ds.request_cpu.patch

The hw-branch-tracer uses debug store functions from an on_each_cpu()
context, which is simply wrong since the functions may sleep.

Add _noirq variants for most functions, which  may be called with
interrupts disabled.

Separate per-cpu and per-task tracing and allow per-cpu tracing to be
controlled from any cpu.

Make the hw-branch-tracer use the new debug store interface, synchronize
with hotplug cpu event using get/put_online_cpus(), and remove the
unnecessary spinlock.

Make the ptrace bts and the ds selftest code use the new interface.

Defer the ds selftest.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/include/asm/ds.h        |   57 	45 +	12 -	0 !
 arch/x86/kernel/ds.c             |  474 	367 +	107 -	0 !
 arch/x86/kernel/ds_selftest.c    |    9 	5 +	4 -	0 !
 arch/x86/kernel/ptrace.c         |    5 	3 +	2 -	0 !
 kernel/trace/trace_hw_branches.c |  193 	72 +	121 -	0 !
 5 files changed, 492 insertions(+), 246 deletions(-)

Index: b/arch/x86/include/asm/ds.h
===================================================================
--- a/arch/x86/include/asm/ds.h
+++ b/arch/x86/include/asm/ds.h
@@ -15,8 +15,8 @@
  * - buffer allocation (memory accounting)
  *
  *
- * Copyright (C) 2007-2008 Intel Corporation.
- * Markus Metzger <markus.t.metzger@intel.com>, 2007-2008
+ * Copyright (C) 2007-2009 Intel Corporation.
+ * Markus Metzger <markus.t.metzger@intel.com>, 2007-2009
  */
 
 #ifndef _ASM_X86_DS_H
@@ -83,8 +83,10 @@ enum ds_feature {
  * The interrupt threshold is independent from the overflow callback
  * to allow users to use their own overflow interrupt handling mechanism.
  *
- * task: the task to request recording for;
- *       NULL for per-cpu recording on the current cpu
+ * The function might sleep.
+ *
+ * task: the task to request recording for
+ * cpu:  the cpu to request recording for
  * base: the base pointer for the (non-pageable) buffer;
  * size: the size of the provided buffer in bytes
  * ovfl: pointer to a function to be called on buffer overflow;
@@ -93,19 +95,28 @@ enum ds_feature {
  *     -1 if no interrupt threshold is requested.
  * flags: a bit-mask of the above flags
  */
-extern struct bts_tracer *ds_request_bts(struct task_struct *task,
-					 void *base, size_t size,
-					 bts_ovfl_callback_t ovfl,
-					 size_t th, unsigned int flags);
-extern struct pebs_tracer *ds_request_pebs(struct task_struct *task,
-					   void *base, size_t size,
-					   pebs_ovfl_callback_t ovfl,
-					   size_t th, unsigned int flags);
+extern struct bts_tracer *ds_request_bts_task(struct task_struct *task,
+					      void *base, size_t size,
+					      bts_ovfl_callback_t ovfl,
+					      size_t th, unsigned int flags);
+extern struct bts_tracer *ds_request_bts_cpu(int cpu, void *base, size_t size,
+					     bts_ovfl_callback_t ovfl,
+					     size_t th, unsigned int flags);
+extern struct pebs_tracer *ds_request_pebs_task(struct task_struct *task,
+						void *base, size_t size,
+						pebs_ovfl_callback_t ovfl,
+						size_t th, unsigned int flags);
+extern struct pebs_tracer *ds_request_pebs_cpu(int cpu,
+					       void *base, size_t size,
+					       pebs_ovfl_callback_t ovfl,
+					       size_t th, unsigned int flags);
 
 /*
  * Release BTS or PEBS resources
  * Suspend and resume BTS or PEBS tracing
  *
+ * Must be called with irq's enabled.
+ *
  * tracer: the tracer handle returned from ds_request_~()
  */
 extern void ds_release_bts(struct bts_tracer *tracer);
@@ -115,6 +126,28 @@ extern void ds_release_pebs(struct pebs_
 extern void ds_suspend_pebs(struct pebs_tracer *tracer);
 extern void ds_resume_pebs(struct pebs_tracer *tracer);
 
+/*
+ * Release BTS or PEBS resources
+ * Suspend and resume BTS or PEBS tracing
+ *
+ * Cpu tracers must call this on the traced cpu.
+ * Task tracers must call ds_release_~_noirq() for themselves.
+ *
+ * May be called with irq's disabled.
+ *
+ * Returns 0 if successful;
+ * -EPERM if the cpu tracer does not trace the current cpu.
+ * -EPERM if the task tracer does not trace itself.
+ *
+ * tracer: the tracer handle returned from ds_request_~()
+ */
+extern int ds_release_bts_noirq(struct bts_tracer *tracer);
+extern int ds_suspend_bts_noirq(struct bts_tracer *tracer);
+extern int ds_resume_bts_noirq(struct bts_tracer *tracer);
+extern int ds_release_pebs_noirq(struct pebs_tracer *tracer);
+extern int ds_suspend_pebs_noirq(struct pebs_tracer *tracer);
+extern int ds_resume_pebs_noirq(struct pebs_tracer *tracer);
+
 
 /*
  * The raw DS buffer state as it is used for BTS and PEBS recording.
Index: b/arch/x86/kernel/ds.c
===================================================================
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -245,60 +245,50 @@ struct ds_context {
 	struct pebs_tracer	*pebs_master;
 
 	/* Use count: */
-	unsigned long count;
+	unsigned long		count;
 
 	/* Pointer to the context pointer field: */
 	struct ds_context	**this;
 
-	/* The traced task; NULL for current cpu: */
+	/* The traced task; NULL for cpu tracing: */
 	struct task_struct	*task;
-};
 
-static DEFINE_PER_CPU(struct ds_context *, system_context_array);
+	/* The traced cpu; only valid if task is NULL: */
+	int			cpu;
+};
 
-#define system_context per_cpu(system_context_array, smp_processor_id())
+static DEFINE_PER_CPU(struct ds_context *, cpu_context);
 
 
-static inline struct ds_context *ds_get_context(struct task_struct *task)
+static struct ds_context *ds_get_context(struct task_struct *task, int cpu)
 {
 	struct ds_context **p_context =
-		(task ? &task->thread.ds_ctx : &system_context);
+		(task ? &task->thread.ds_ctx : &per_cpu(cpu_context, cpu));
 	struct ds_context *context = NULL;
 	struct ds_context *new_context = NULL;
-	unsigned long irq;
 
-	/*
-	 * Chances are small that we already have a context.
-	 *
-	 * Contexts for per-cpu tracing are allocated using
-	 * smp_call_function(). We must not sleep.
-	 */
-	new_context = kzalloc(sizeof(*new_context), GFP_ATOMIC);
+	/* Chances are small that we already have a context. */
+	new_context = kzalloc(sizeof(*new_context), GFP_KERNEL);
 	if (!new_context)
 		return NULL;
 
-	spin_lock_irqsave(&ds_lock, irq);
+	spin_lock_irq(&ds_lock);
 
 	context = *p_context;
-	if (!context) {
+	if (likely(!context)) {
 		context = new_context;
 
 		context->this = p_context;
 		context->task = task;
+		context->cpu = cpu;
 		context->count = 0;
 
-		if (task)
-			set_tsk_thread_flag(task, TIF_DS_AREA_MSR);
-
-		if (!task || (task == current))
-			wrmsrl(MSR_IA32_DS_AREA, (unsigned long)context->ds);
-
 		*p_context = context;
 	}
 
 	context->count++;
 
-	spin_unlock_irqrestore(&ds_lock, irq);
+	spin_unlock_irq(&ds_lock);
 
 	if (context != new_context)
 		kfree(new_context);
@@ -306,7 +296,7 @@ static inline struct ds_context *ds_get_
 	return context;
 }
 
-static inline void ds_put_context(struct ds_context *context)
+static void ds_put_context(struct ds_context *context)
 {
 	struct task_struct *task;
 	unsigned long irq;
@@ -328,8 +318,15 @@ static inline void ds_put_context(struct
 	if (task)
 		clear_tsk_thread_flag(task, TIF_DS_AREA_MSR);
 
-	if (!task || (task == current))
-		wrmsrl(MSR_IA32_DS_AREA, 0);
+	/*
+	 * We leave the (now dangling) pointer to the DS configuration in
+	 * the DS_AREA msr. This is as good or as bad as replacing it with
+	 * NULL - the hardware would crash if we enabled tracing.
+	 *
+	 * This saves us some problems with having to write an msr on a
+	 * different cpu while preventing others from doing the same for the
+	 * next context for that same cpu.
+	 */
 
 	spin_unlock_irqrestore(&ds_lock, irq);
 
@@ -340,6 +337,31 @@ static inline void ds_put_context(struct
 	kfree(context);
 }
 
+static void ds_install_ds_area(struct ds_context *context)
+{
+	unsigned long ds;
+
+	ds = (unsigned long)context->ds;
+
+	/*
+	 * There is a race between the bts master and the pebs master.
+	 *
+	 * The thread/cpu access is synchronized via get/put_cpu() for
+	 * task tracing and via wrmsr_on_cpu for cpu tracing.
+	 *
+	 * If bts and pebs are collected for the same task or same cpu,
+	 * the same confiuration is written twice.
+	 */
+	if (context->task) {
+		get_cpu();
+		if (context->task == current)
+			wrmsrl(MSR_IA32_DS_AREA, ds);
+		set_tsk_thread_flag(context->task, TIF_DS_AREA_MSR);
+		put_cpu();
+	} else
+		wrmsr_on_cpu(context->cpu, MSR_IA32_DS_AREA,
+			     (u32)((u64)ds), (u32)((u64)ds >> 32));
+}
 
 /*
  * Call the tracer's callback on a buffer overflow.
@@ -622,6 +644,7 @@ static void ds_init_ds_trace(struct ds_t
 	 * The value for 'no threshold' is -1, which will set the
 	 * threshold outside of the buffer, just like we want it.
 	 */
+	ith *= ds_cfg.sizeof_rec[qual];
 	trace->ith = (void *)(buffer + size - ith);
 
 	trace->flags = flags;
@@ -630,7 +653,7 @@ static void ds_init_ds_trace(struct ds_t
 
 static int ds_request(struct ds_tracer *tracer, struct ds_trace *trace,
 		      enum ds_qualifier qual, struct task_struct *task,
-		      void *base, size_t size, size_t th, unsigned int flags)
+		      int cpu, void *base, size_t size, size_t th)
 {
 	struct ds_context *context;
 	int error;
@@ -643,7 +666,7 @@ static int ds_request(struct ds_tracer *
 	if (!base)
 		goto out;
 
-	/* We require some space to do alignment adjustments below. */
+	/* We need space for alignment adjustments in ds_init_ds_trace(). */
 	error = -EINVAL;
 	if (size < (DS_ALIGNMENT + ds_cfg.sizeof_rec[qual]))
 		goto out;
@@ -660,25 +683,27 @@ static int ds_request(struct ds_tracer *
 	tracer->size = size;
 
 	error = -ENOMEM;
-	context = ds_get_context(task);
+	context = ds_get_context(task, cpu);
 	if (!context)
 		goto out;
 	tracer->context = context;
 
-	ds_init_ds_trace(trace, qual, base, size, th, flags);
+	/*
+	 * Defer any tracer-specific initialization work for the context until
+	 * context ownership has been clarified.
+	 */
 
 	error = 0;
  out:
 	return error;
 }
 
-struct bts_tracer *ds_request_bts(struct task_struct *task,
-				  void *base, size_t size,
-				  bts_ovfl_callback_t ovfl, size_t th,
-				  unsigned int flags)
+static struct bts_tracer *ds_request_bts(struct task_struct *task, int cpu,
+					 void *base, size_t size,
+					 bts_ovfl_callback_t ovfl, size_t th,
+					 unsigned int flags)
 {
 	struct bts_tracer *tracer;
-	unsigned long irq;
 	int error;
 
 	/* Buffer overflow notification is not yet implemented. */
@@ -690,42 +715,46 @@ struct bts_tracer *ds_request_bts(struct
 	if (error < 0)
 		goto out;
 
-	/*
-	 * Per-cpu tracing is typically requested using smp_call_function().
-	 * We must not sleep.
-	 */
 	error = -ENOMEM;
-	tracer = kzalloc(sizeof(*tracer), GFP_ATOMIC);
+	tracer = kzalloc(sizeof(*tracer), GFP_KERNEL);
 	if (!tracer)
 		goto out_put_tracer;
 	tracer->ovfl = ovfl;
 
+	/* Do some more error checking and acquire a tracing context. */
 	error = ds_request(&tracer->ds, &tracer->trace.ds,
-			   ds_bts, task, base, size, th, flags);
+			   ds_bts, task, cpu, base, size, th);
 	if (error < 0)
 		goto out_tracer;
 
-
-	spin_lock_irqsave(&ds_lock, irq);
+	/* Claim the bts part of the tracing context we acquired above. */
+	spin_lock_irq(&ds_lock);
 
 	error = -EPERM;
 	if (tracer->ds.context->bts_master)
 		goto out_unlock;
 	tracer->ds.context->bts_master = tracer;
 
-	spin_unlock_irqrestore(&ds_lock, irq);
+	spin_unlock_irq(&ds_lock);
 
+	/*
+	 * Now that we own the bts part of the context, let's complete the
+	 * initialization for that part.
+	 */
+	ds_init_ds_trace(&tracer->trace.ds, ds_bts, base, size, th, flags);
+	ds_write_config(tracer->ds.context, &tracer->trace.ds, ds_bts);
+	ds_install_ds_area(tracer->ds.context);
 
 	tracer->trace.read  = bts_read;
 	tracer->trace.write = bts_write;
 
-	ds_write_config(tracer->ds.context, &tracer->trace.ds, ds_bts);
+	/* Start tracing. */
 	ds_resume_bts(tracer);
 
 	return tracer;
 
  out_unlock:
-	spin_unlock_irqrestore(&ds_lock, irq);
+	spin_unlock_irq(&ds_lock);
 	ds_put_context(tracer->ds.context);
  out_tracer:
 	kfree(tracer);
@@ -735,13 +764,27 @@ struct bts_tracer *ds_request_bts(struct
 	return ERR_PTR(error);
 }
 
-struct pebs_tracer *ds_request_pebs(struct task_struct *task,
-				    void *base, size_t size,
-				    pebs_ovfl_callback_t ovfl, size_t th,
-				    unsigned int flags)
+struct bts_tracer *ds_request_bts_task(struct task_struct *task,
+				       void *base, size_t size,
+				       bts_ovfl_callback_t ovfl,
+				       size_t th, unsigned int flags)
+{
+	return ds_request_bts(task, 0, base, size, ovfl, th, flags);
+}
+
+struct bts_tracer *ds_request_bts_cpu(int cpu, void *base, size_t size,
+				      bts_ovfl_callback_t ovfl,
+				      size_t th, unsigned int flags)
+{
+	return ds_request_bts(NULL, cpu, base, size, ovfl, th, flags);
+}
+
+static struct pebs_tracer *ds_request_pebs(struct task_struct *task, int cpu,
+					   void *base, size_t size,
+					   pebs_ovfl_callback_t ovfl, size_t th,
+					   unsigned int flags)
 {
 	struct pebs_tracer *tracer;
-	unsigned long irq;
 	int error;
 
 	/* Buffer overflow notification is not yet implemented. */
@@ -753,37 +796,43 @@ struct pebs_tracer *ds_request_pebs(stru
 	if (error < 0)
 		goto out;
 
-	/*
-	 * Per-cpu tracing is typically requested using smp_call_function().
-	 * We must not sleep.
-	 */
 	error = -ENOMEM;
-	tracer = kzalloc(sizeof(*tracer), GFP_ATOMIC);
+	tracer = kzalloc(sizeof(*tracer), GFP_KERNEL);
 	if (!tracer)
 		goto out_put_tracer;
 	tracer->ovfl = ovfl;
 
+	/* Do some more error checking and acquire a tracing context. */
 	error = ds_request(&tracer->ds, &tracer->trace.ds,
-			   ds_pebs, task, base, size, th, flags);
+			   ds_pebs, task, cpu, base, size, th);
 	if (error < 0)
 		goto out_tracer;
 
-	spin_lock_irqsave(&ds_lock, irq);
+	/* Claim the pebs part of the tracing context we acquired above. */
+	spin_lock_irq(&ds_lock);
 
 	error = -EPERM;
 	if (tracer->ds.context->pebs_master)
 		goto out_unlock;
 	tracer->ds.context->pebs_master = tracer;
 
-	spin_unlock_irqrestore(&ds_lock, irq);
+	spin_unlock_irq(&ds_lock);
 
+	/*
+	 * Now that we own the pebs part of the context, let's complete the
+	 * initialization for that part.
+	 */
+	ds_init_ds_trace(&tracer->trace.ds, ds_pebs, base, size, th, flags);
 	ds_write_config(tracer->ds.context, &tracer->trace.ds, ds_pebs);
+	ds_install_ds_area(tracer->ds.context);
+
+	/* Start tracing. */
 	ds_resume_pebs(tracer);
 
 	return tracer;
 
  out_unlock:
-	spin_unlock_irqrestore(&ds_lock, irq);
+	spin_unlock_irq(&ds_lock);
 	ds_put_context(tracer->ds.context);
  out_tracer:
 	kfree(tracer);
@@ -793,16 +842,26 @@ struct pebs_tracer *ds_request_pebs(stru
 	return ERR_PTR(error);
 }
 
-void ds_release_bts(struct bts_tracer *tracer)
+struct pebs_tracer *ds_request_pebs_task(struct task_struct *task,
+					 void *base, size_t size,
+					 pebs_ovfl_callback_t ovfl,
+					 size_t th, unsigned int flags)
 {
-	struct task_struct *task;
+	return ds_request_pebs(task, 0, base, size, ovfl, th, flags);
+}
 
-	if (!tracer)
-		return;
+struct pebs_tracer *ds_request_pebs_cpu(int cpu, void *base, size_t size,
+					pebs_ovfl_callback_t ovfl,
+					size_t th, unsigned int flags)
+{
+	return ds_request_pebs(NULL, cpu, base, size, ovfl, th, flags);
+}
 
-	task = tracer->ds.context->task;
+static void ds_free_bts(struct bts_tracer *tracer)
+{
+	struct task_struct *task;
 
-	ds_suspend_bts(tracer);
+	task = tracer->ds.context->task;
 
 	WARN_ON_ONCE(tracer->ds.context->bts_master != tracer);
 	tracer->ds.context->bts_master = NULL;
@@ -817,9 +876,69 @@ void ds_release_bts(struct bts_tracer *t
 	kfree(tracer);
 }
 
+void ds_release_bts(struct bts_tracer *tracer)
+{
+	might_sleep();
+
+	if (!tracer)
+		return;
+
+	ds_suspend_bts(tracer);
+	ds_free_bts(tracer);
+}
+
+int ds_release_bts_noirq(struct bts_tracer *tracer)
+{
+	struct task_struct *task;
+	unsigned long irq;
+	int error;
+
+	if (!tracer)
+		return 0;
+
+	task = tracer->ds.context->task;
+
+	local_irq_save(irq);
+
+	error = -EPERM;
+	if (!task &&
+	    (tracer->ds.context->cpu != smp_processor_id()))
+		goto out;
+
+	error = -EPERM;
+	if (task && (task != current))
+		goto out;
+
+	ds_suspend_bts_noirq(tracer);
+	ds_free_bts(tracer);
+
+	error = 0;
+ out:
+	local_irq_restore(irq);
+	return error;
+}
+
+static void update_task_debugctlmsr(struct task_struct *task,
+				    unsigned long debugctlmsr)
+{
+	task->thread.debugctlmsr = debugctlmsr;
+
+	get_cpu();
+	if (task == current)
+		update_debugctlmsr(debugctlmsr);
+
+	if (task->thread.debugctlmsr)
+		set_tsk_thread_flag(task, TIF_DEBUGCTLMSR);
+	else
+		clear_tsk_thread_flag(task, TIF_DEBUGCTLMSR);
+	put_cpu();
+}
+
 void ds_suspend_bts(struct bts_tracer *tracer)
 {
 	struct task_struct *task;
+	unsigned long debugctlmsr;
+	int cpu;
 
 	if (!tracer)
 		return;
@@ -827,29 +946,60 @@ void ds_suspend_bts(struct bts_tracer *t
 	tracer->flags = 0;
 
 	task = tracer->ds.context->task;
+	cpu  = tracer->ds.context->cpu;
 
-	if (!task || (task == current))
-		update_debugctlmsr(get_debugctlmsr() & ~BTS_CONTROL);
+	WARN_ON(!task && irqs_disabled());
 
-	if (task) {
-		task->thread.debugctlmsr &= ~BTS_CONTROL;
+	debugctlmsr = (task ?
+		       task->thread.debugctlmsr :
+		       get_debugctlmsr_on_cpu(cpu));
+	debugctlmsr &= ~BTS_CONTROL;
 
-		if (!task->thread.debugctlmsr)
-			clear_tsk_thread_flag(task, TIF_DEBUGCTLMSR);
-	}
+	if (task)
+		update_task_debugctlmsr(task, debugctlmsr);
+	else
+		update_debugctlmsr_on_cpu(cpu, debugctlmsr);
 }
 
-void ds_resume_bts(struct bts_tracer *tracer)
+int ds_suspend_bts_noirq(struct bts_tracer *tracer)
 {
 	struct task_struct *task;
-	unsigned long control;
+	unsigned long debugctlmsr, irq;
+	int cpu, error = 0;
 
 	if (!tracer)
-		return;
+		return 0;
 
-	tracer->flags = tracer->trace.ds.flags;
+	tracer->flags = 0;
 
 	task = tracer->ds.context->task;
+	cpu  = tracer->ds.context->cpu;
+
+	local_irq_save(irq);
+
+	error = -EPERM;
+	if (!task && (cpu != smp_processor_id()))
+		goto out;
+
+	debugctlmsr = (task ?
+		       task->thread.debugctlmsr :
+		       get_debugctlmsr());
+	debugctlmsr &= ~BTS_CONTROL;
+
+	if (task)
+		update_task_debugctlmsr(task, debugctlmsr);
+	else
+		update_debugctlmsr(debugctlmsr);
+
+	error = 0;
+ out:
+	local_irq_restore(irq);
+	return error;
+}
+
+static unsigned long ds_bts_control(struct bts_tracer *tracer)
+{
+	unsigned long control;
 
 	control = ds_cfg.ctl[dsf_bts];
 	if (!(tracer->trace.ds.flags & BTS_KERNEL))
@@ -857,25 +1007,77 @@ void ds_resume_bts(struct bts_tracer *tr
 	if (!(tracer->trace.ds.flags & BTS_USER))
 		control |= ds_cfg.ctl[dsf_bts_user];
 
-	if (task) {
-		task->thread.debugctlmsr |= control;
-		set_tsk_thread_flag(task, TIF_DEBUGCTLMSR);
-	}
-
-	if (!task || (task == current))
-		update_debugctlmsr(get_debugctlmsr() | control);
+	return control;
 }
 
-void ds_release_pebs(struct pebs_tracer *tracer)
+void ds_resume_bts(struct bts_tracer *tracer)
 {
 	struct task_struct *task;
+	unsigned long debugctlmsr;
+	int cpu;
 
 	if (!tracer)
 		return;
 
+	tracer->flags = tracer->trace.ds.flags;
+
 	task = tracer->ds.context->task;
+	cpu  = tracer->ds.context->cpu;
 
-	ds_suspend_pebs(tracer);
+	WARN_ON(!task && irqs_disabled());
+
+	debugctlmsr = (task ?
+		       task->thread.debugctlmsr :
+		       get_debugctlmsr_on_cpu(cpu));
+	debugctlmsr |= ds_bts_control(tracer);
+
+	if (task)
+		update_task_debugctlmsr(task, debugctlmsr);
+	else
+		update_debugctlmsr_on_cpu(cpu, debugctlmsr);
+}
+
+int ds_resume_bts_noirq(struct bts_tracer *tracer)
+{
+	struct task_struct *task;
+	unsigned long debugctlmsr, irq;
+	int cpu, error = 0;
+
+	if (!tracer)
+		return 0;
+
+	tracer->flags = tracer->trace.ds.flags;
+
+	task = tracer->ds.context->task;
+	cpu  = tracer->ds.context->cpu;
+
+	local_irq_save(irq);
+
+	error = -EPERM;
+	if (!task && (cpu != smp_processor_id()))
+		goto out;
+
+	debugctlmsr = (task ?
+		       task->thread.debugctlmsr :
+		       get_debugctlmsr());
+	debugctlmsr |= ds_bts_control(tracer);
+
+	if (task)
+		update_task_debugctlmsr(task, debugctlmsr);
+	else
+		update_debugctlmsr(debugctlmsr);
+
+	error = 0;
+ out:
+	local_irq_restore(irq);
+	return error;
+}
+
+static void ds_free_pebs(struct pebs_tracer *tracer)
+{
+	struct task_struct *task;
+
+	task = tracer->ds.context->task;
 
 	WARN_ON_ONCE(tracer->ds.context->pebs_master != tracer);
 	tracer->ds.context->pebs_master = NULL;
@@ -886,16 +1088,68 @@ void ds_release_pebs(struct pebs_tracer 
 	kfree(tracer);
 }
 
+void ds_release_pebs(struct pebs_tracer *tracer)
+{
+	might_sleep();
+
+	if (!tracer)
+		return;
+
+	ds_suspend_pebs(tracer);
+	ds_free_pebs(tracer);
+}
+
+int ds_release_pebs_noirq(struct pebs_tracer *tracer)
+{
+	struct task_struct *task;
+	unsigned long irq;
+	int error;
+
+	if (!tracer)
+		return 0;
+
+	task = tracer->ds.context->task;
+
+	local_irq_save(irq);
+
+	error = -EPERM;
+	if (!task &&
+	    (tracer->ds.context->cpu != smp_processor_id()))
+		goto out;
+
+	error = -EPERM;
+	if (task && (task != current))
+		goto out;
+
+	ds_suspend_pebs_noirq(tracer);
+	ds_free_pebs(tracer);
+
+	error = 0;
+ out:
+	local_irq_restore(irq);
+	return error;
+}
+
 void ds_suspend_pebs(struct pebs_tracer *tracer)
 {
 
 }
 
+int ds_suspend_pebs_noirq(struct pebs_tracer *tracer)
+{
+	return 0;
+}
+
 void ds_resume_pebs(struct pebs_tracer *tracer)
 {
 
 }
 
+int ds_resume_pebs_noirq(struct pebs_tracer *tracer)
+{
+	return 0;
+}
+
 const struct bts_trace *ds_read_bts(struct bts_tracer *tracer)
 {
 	if (!tracer)
@@ -1004,26 +1258,6 @@ ds_configure(const struct ds_configurati
 		printk(KERN_INFO "[ds] pebs not available\n");
 	}
 
-	if (ds_cfg.sizeof_rec[ds_bts]) {
-		int error;
-
-		error = ds_selftest_bts();
-		if (error) {
-			WARN(1, "[ds] selftest failed. disabling bts.\n");
-			ds_cfg.sizeof_rec[ds_bts] = 0;
-		}
-	}
-
-	if (ds_cfg.sizeof_rec[ds_pebs]) {
-		int error;
-
-		error = ds_selftest_pebs();
-		if (error) {
-			WARN(1, "[ds] selftest failed. disabling pebs.\n");
-			ds_cfg.sizeof_rec[ds_pebs] = 0;
-		}
-	}
-
 	printk(KERN_INFO "[ds] sizes: address: %u bit, ",
 	       8 * ds_cfg.sizeof_ptr_field);
 	printk("bts/pebs record: %u/%u bytes\n",
@@ -1127,3 +1361,29 @@ void ds_copy_thread(struct task_struct *
 void ds_exit_thread(struct task_struct *tsk)
 {
 }
+
+static __init int ds_selftest(void)
+{
+	if (ds_cfg.sizeof_rec[ds_bts]) {
+		int error;
+
+		error = ds_selftest_bts();
+		if (error) {
+			WARN(1, "[ds] selftest failed. disabling bts.\n");
+			ds_cfg.sizeof_rec[ds_bts] = 0;
+		}
+	}
+
+	if (ds_cfg.sizeof_rec[ds_pebs]) {
+		int error;
+
+		error = ds_selftest_pebs();
+		if (error) {
+			WARN(1, "[ds] selftest failed. disabling pebs.\n");
+			ds_cfg.sizeof_rec[ds_pebs] = 0;
+		}
+	}
+
+	return 0;
+}
+device_initcall(ds_selftest);
Index: b/kernel/trace/trace_hw_branches.c
===================================================================
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -4,7 +4,6 @@
  * Copyright (C) 2008-2009 Intel Corporation.
  * Markus Metzger <markus.t.metzger@gmail.com>, 2008-2009
  */
-#include <linux/spinlock.h>
 #include <linux/kallsyms.h>
 #include <linux/debugfs.h>
 #include <linux/ftrace.h>
@@ -21,168 +20,113 @@
 
 #define BTS_BUFFER_SIZE (1 << 13)
 
-/*
- * The tracer lock protects the below per-cpu tracer array.
- * It needs to be held to:
- * - start tracing on all cpus
- * - stop tracing on all cpus
- * - start tracing on a single hotplug cpu
- * - stop tracing on a single hotplug cpu
- * - read the trace from all cpus
- * - read the trace from a single cpu
- */
-static DEFINE_SPINLOCK(bts_tracer_lock);
 static DEFINE_PER_CPU(struct bts_tracer *, tracer);
 static DEFINE_PER_CPU(unsigned char[BTS_BUFFER_SIZE], buffer);
 
 #define this_tracer per_cpu(tracer, smp_processor_id())
-#define this_buffer per_cpu(buffer, smp_processor_id())
 
 static int trace_hw_branches_enabled __read_mostly;
 static int trace_hw_branches_suspended __read_mostly;
 static struct trace_array *hw_branch_trace __read_mostly;
 
 
-/*
- * Initialize the tracer for the current cpu.
- * The argument is ignored.
- *
- * pre: bts_tracer_lock must be locked.
- */
-static void bts_trace_init_cpu(void *arg)
+static void bts_trace_init_cpu(int cpu)
 {
-	if (this_tracer)
-		ds_release_bts(this_tracer);
+	per_cpu(tracer, cpu) =
+		ds_request_bts_cpu(cpu, per_cpu(buffer, cpu), BTS_BUFFER_SIZE,
+				   NULL, (size_t)-1, BTS_KERNEL);
 
-	this_tracer = ds_request_bts(NULL, this_buffer, BTS_BUFFER_SIZE,
-				     NULL, (size_t)-1, BTS_KERNEL);
-	if (IS_ERR(this_tracer)) {
-		this_tracer = NULL;
-		return;
-	}
+	if (IS_ERR(per_cpu(tracer, cpu)))
+		per_cpu(tracer, cpu) = NULL;
 }
 
 static int bts_trace_init(struct trace_array *tr)
 {
-	int cpu, avail;
-
-	spin_lock(&bts_tracer_lock);
+	int cpu;
 
 	hw_branch_trace = tr;
+	trace_hw_branches_enabled = 0;
 
-	on_each_cpu(bts_trace_init_cpu, NULL, 1);
-
-	/* Check on how many cpus we could enable tracing */
-	avail = 0;
-	for_each_online_cpu(cpu)
-		if (per_cpu(tracer, cpu))
-			avail++;
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		bts_trace_init_cpu(cpu);
 
-	trace_hw_branches_enabled = (avail ? 1 : 0);
+		if (likely(per_cpu(tracer, cpu)))
+			trace_hw_branches_enabled = 1;
+	}
 	trace_hw_branches_suspended = 0;
-
-	spin_unlock(&bts_tracer_lock);
-
+	put_online_cpus();
 
 	/* If we could not enable tracing on a single cpu, we fail. */
-	return avail ? 0 : -EOPNOTSUPP;
-}
-
-/*
- * Release the tracer for the current cpu.
- * The argument is ignored.
- *
- * pre: bts_tracer_lock must be locked.
- */
-static void bts_trace_release_cpu(void *arg)
-{
-	if (this_tracer) {
-		ds_release_bts(this_tracer);
-		this_tracer = NULL;
-	}
+	return trace_hw_branches_enabled ? 0 : -EOPNOTSUPP;
 }
 
 static void bts_trace_reset(struct trace_array *tr)
 {
-	spin_lock(&bts_tracer_lock);
+	int cpu;
 
-	on_each_cpu(bts_trace_release_cpu, NULL, 1);
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		if (likely(per_cpu(tracer, cpu))) {
+			ds_release_bts(per_cpu(tracer, cpu));
+			per_cpu(tracer, cpu) = NULL;
+		}
+	}
 	trace_hw_branches_enabled = 0;
 	trace_hw_branches_suspended = 0;
-
-	spin_unlock(&bts_tracer_lock);
-}
-
-/*
- * Resume tracing on the current cpu.
- * The argument is ignored.
- *
- * pre: bts_tracer_lock must be locked.
- */
-static void bts_trace_resume_cpu(void *arg)
-{
-	if (this_tracer)
-		ds_resume_bts(this_tracer);
+	put_online_cpus();
 }
 
 static void bts_trace_start(struct trace_array *tr)
 {
-	spin_lock(&bts_tracer_lock);
+	int cpu;
 
-	on_each_cpu(bts_trace_resume_cpu, NULL, 1);
+	get_online_cpus();
+	for_each_online_cpu(cpu)
+		if (likely(per_cpu(tracer, cpu)))
+			ds_resume_bts(per_cpu(tracer, cpu));
 	trace_hw_branches_suspended = 0;
-
-	spin_unlock(&bts_tracer_lock);
-}
-
-/*
- * Suspend tracing on the current cpu.
- * The argument is ignored.
- *
- * pre: bts_tracer_lock must be locked.
- */
-static void bts_trace_suspend_cpu(void *arg)
-{
-	if (this_tracer)
-		ds_suspend_bts(this_tracer);
+	put_online_cpus();
 }
 
 static void bts_trace_stop(struct trace_array *tr)
 {
-	spin_lock(&bts_tracer_lock);
+	int cpu;
 
-	on_each_cpu(bts_trace_suspend_cpu, NULL, 1);
+	get_online_cpus();
+	for_each_online_cpu(cpu)
+		if (likely(per_cpu(tracer, cpu)))
+			ds_suspend_bts(per_cpu(tracer, cpu));
 	trace_hw_branches_suspended = 1;
-
-	spin_unlock(&bts_tracer_lock);
+	put_online_cpus();
 }
 
 static int __cpuinit bts_hotcpu_handler(struct notifier_block *nfb,
 				     unsigned long action, void *hcpu)
 {
-	unsigned int cpu = (unsigned long)hcpu;
-
-	spin_lock(&bts_tracer_lock);
-
-	if (!trace_hw_branches_enabled)
-		goto out;
+	int cpu = (long)hcpu;
 
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
-		smp_call_function_single(cpu, bts_trace_init_cpu, NULL, 1);
-
-		if (trace_hw_branches_suspended)
-			smp_call_function_single(cpu, bts_trace_suspend_cpu,
-						 NULL, 1);
+		/* The notification is sent with interrupts enabled. */
+		if (trace_hw_branches_enabled) {
+			bts_trace_init_cpu(cpu);
+
+			if (trace_hw_branches_suspended &&
+			    likely(per_cpu(tracer, cpu)))
+				ds_suspend_bts(per_cpu(tracer, cpu));
+		}
 		break;
+
 	case CPU_DOWN_PREPARE:
-		smp_call_function_single(cpu, bts_trace_release_cpu, NULL, 1);
-		break;
+		/* The notification is sent with interrupts enabled. */
+		if (likely(per_cpu(tracer, cpu))) {
+			ds_release_bts(per_cpu(tracer, cpu));
+			per_cpu(tracer, cpu) = NULL;
+		}
 	}
 
- out:
-	spin_unlock(&bts_tracer_lock);
 	return NOTIFY_DONE;
 }
 
@@ -274,7 +218,7 @@ static void trace_bts_at(const struct bt
 /*
  * Collect the trace on the current cpu and write it into the ftrace buffer.
  *
- * pre: bts_tracer_lock must be locked
+ * pre: tracing must be suspended on the current cpu
  */
 static void trace_bts_cpu(void *arg)
 {
@@ -291,10 +235,9 @@ static void trace_bts_cpu(void *arg)
 	if (unlikely(!this_tracer))
 		return;
 
-	ds_suspend_bts(this_tracer);
 	trace = ds_read_bts(this_tracer);
 	if (!trace)
-		goto out;
+		return;
 
 	for (at = trace->ds.top; (void *)at < trace->ds.end;
 	     at += trace->ds.size)
@@ -303,18 +246,27 @@ static void trace_bts_cpu(void *arg)
 	for (at = trace->ds.begin; (void *)at < trace->ds.top;
 	     at += trace->ds.size)
 		trace_bts_at(trace, at);
-
-out:
-	ds_resume_bts(this_tracer);
 }
 
 static void trace_bts_prepare(struct trace_iterator *iter)
 {
-	spin_lock(&bts_tracer_lock);
+	int cpu;
 
+	get_online_cpus();
+	for_each_online_cpu(cpu)
+		if (likely(per_cpu(tracer, cpu)))
+			ds_suspend_bts(per_cpu(tracer, cpu));
+	/*
+	 * We need to collect the trace on the respective cpu since ftrace
+	 * implicitly adds the record for the current cpu.
+	 * Once that is more flexible, we could collect the data from any cpu.
+	 */
 	on_each_cpu(trace_bts_cpu, iter->tr, 1);
 
-	spin_unlock(&bts_tracer_lock);
+	for_each_online_cpu(cpu)
+		if (likely(per_cpu(tracer, cpu)))
+			ds_resume_bts(per_cpu(tracer, cpu));
+	put_online_cpus();
 }
 
 static void trace_bts_close(struct trace_iterator *iter)
@@ -324,12 +276,11 @@ static void trace_bts_close(struct trace
 
 void trace_hw_branch_oops(void)
 {
-	spin_lock(&bts_tracer_lock);
-
-	if (trace_hw_branches_enabled)
+	if (this_tracer) {
+		ds_suspend_bts_noirq(this_tracer);
 		trace_bts_cpu(hw_branch_trace);
-
-	spin_unlock(&bts_tracer_lock);
+		ds_resume_bts_noirq(this_tracer);
+	}
 }
 
 struct tracer bts_tracer __read_mostly =
Index: b/arch/x86/kernel/ptrace.c
===================================================================
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -801,8 +801,9 @@ static int ptrace_bts_config(struct task
 	if (cfg.flags & PTRACE_BTS_O_SCHED)
 		flags |= BTS_TIMESTAMPS;
 
-	context->tracer = ds_request_bts(child, context->buffer, context->size,
-					 NULL, (size_t)-1, flags);
+	context->tracer =
+		ds_request_bts_task(child, context->buffer, context->size,
+				    NULL, (size_t)-1, flags);
 	if (unlikely(IS_ERR(context->tracer))) {
 		int error = PTR_ERR(context->tracer);
 
Index: b/arch/x86/kernel/ds_selftest.c
===================================================================
--- a/arch/x86/kernel/ds_selftest.c
+++ b/arch/x86/kernel/ds_selftest.c
@@ -10,11 +10,12 @@
 
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <linux/smp.h>
 
 #include <asm/ds.h>
 
 
-#define DS_SELFTEST_BUFFER_SIZE 1021 /* Intentionally chose an odd size. */
+#define BUFFER_SIZE 1021 /* Intentionally chose an odd size. */
 
 
 static int ds_selftest_bts_consistency(const struct bts_trace *trace)
@@ -125,12 +126,12 @@ int ds_selftest_bts(void)
 	struct bts_tracer *tracer;
 	int error = 0;
 	void *top;
-	unsigned char buffer[DS_SELFTEST_BUFFER_SIZE];
+	unsigned char buffer[BUFFER_SIZE];
 
 	printk(KERN_INFO "[ds] bts selftest...");
 
-	tracer = ds_request_bts(NULL, buffer, DS_SELFTEST_BUFFER_SIZE,
-				NULL, (size_t)-1, BTS_KERNEL);
+	tracer = ds_request_bts_cpu(smp_processor_id(), buffer, BUFFER_SIZE,
+				    NULL, (size_t)-1, BTS_KERNEL);
 	if (IS_ERR(tracer)) {
 		error = PTR_ERR(tracer);
 		tracer = NULL;

-- 

--===============0698488333==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

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

--===============0698488333==--
