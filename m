Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbZCaNSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbZCaNSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbZCaNSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:18:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:40011 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbZCaNSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:18:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="443609089"
Date: Tue, 31 Mar 2009 15:17:39 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 7/21] x86, bts: add _noirq variants to the debug store interface
Message-ID: <20090331151739.A12942@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hw-branch-tracer uses debug store functions from an on_each_cpu()
context, which is simply wrong since the functions may sleep.

Add _noirq variants for most functions that may be called with
interrupts disabled.

Separate per-cpu and per-task tracing and allow per-cpu tracing to be
controlled from any cpu.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/include/asm/ds.h
===================================================================
--- git-tip.orig/arch/x86/include/asm/ds.h	2009-03-30 13:31:09.000000000 +0200
+++ git-tip/arch/x86/include/asm/ds.h	2009-03-30 18:51:30.000000000 +0200
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
Index: git-tip/arch/x86/kernel/ds.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds.c	2009-03-30 17:49:38.000000000 +0200
+++ git-tip/arch/x86/kernel/ds.c	2009-03-30 18:52:24.000000000 +0200
@@ -244,18 +244,19 @@ struct ds_context {
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
 
 
 /*
@@ -294,40 +295,30 @@ static void wait_to_unschedule(struct ta
 	}
 }
 
-static inline struct ds_context *ds_get_context(struct task_struct *task)
+static struct ds_context *ds_get_context(struct task_struct *task, int cpu)
 {
 	struct ds_context **p_context =
-		(task ? &task->thread.ds_ctx : &system_context);
+		(task ? &task->thread.ds_ctx : &per_cpu(cpu_context, cpu));
 	struct ds_context *context = NULL;
 	struct ds_context *new_context = NULL;
 	unsigned long irq;
 
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
 
 	spin_lock_irqsave(&ds_lock, irq);
 
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
 
@@ -341,7 +332,7 @@ static inline struct ds_context *ds_get_
 	return context;
 }
 
-static inline void ds_put_context(struct ds_context *context)
+static void ds_put_context(struct ds_context *context)
 {
 	unsigned long irq;
 
@@ -360,8 +351,15 @@ static inline void ds_put_context(struct
 	if (context->task)
 		clear_tsk_thread_flag(context->task, TIF_DS_AREA_MSR);
 
-	if (!context->task || (context->task == current))
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
 
@@ -371,6 +369,31 @@ static inline void ds_put_context(struct
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
@@ -653,6 +676,7 @@ static void ds_init_ds_trace(struct ds_t
 	 * The value for 'no threshold' is -1, which will set the
 	 * threshold outside of the buffer, just like we want it.
 	 */
+	ith *= ds_cfg.sizeof_rec[qual];
 	trace->ith = (void *)(buffer + size - ith);
 
 	trace->flags = flags;
@@ -661,7 +685,7 @@ static void ds_init_ds_trace(struct ds_t
 
 static int ds_request(struct ds_tracer *tracer, struct ds_trace *trace,
 		      enum ds_qualifier qual, struct task_struct *task,
-		      void *base, size_t size, size_t th, unsigned int flags)
+		      int cpu, void *base, size_t size, size_t th)
 {
 	struct ds_context *context;
 	int error;
@@ -674,7 +698,7 @@ static int ds_request(struct ds_tracer *
 	if (!base)
 		goto out;
 
-	/* We require some space to do alignment adjustments below. */
+	/* We need space for alignment adjustments in ds_init_ds_trace(). */
 	error = -EINVAL;
 	if (size < (DS_ALIGNMENT + ds_cfg.sizeof_rec[qual]))
 		goto out;
@@ -691,25 +715,27 @@ static int ds_request(struct ds_tracer *
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
@@ -721,42 +747,46 @@ struct bts_tracer *ds_request_bts(struct
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
@@ -766,13 +796,27 @@ struct bts_tracer *ds_request_bts(struct
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
@@ -784,37 +828,43 @@ struct pebs_tracer *ds_request_pebs(stru
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
@@ -824,16 +874,26 @@ struct pebs_tracer *ds_request_pebs(stru
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
@@ -847,9 +907,69 @@ void ds_release_bts(struct bts_tracer *t
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
@@ -857,29 +977,60 @@ void ds_suspend_bts(struct bts_tracer *t
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
@@ -887,25 +1038,77 @@ void ds_resume_bts(struct bts_tracer *tr
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
@@ -916,16 +1119,68 @@ void ds_release_pebs(struct pebs_tracer 
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

