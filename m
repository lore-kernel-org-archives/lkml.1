Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbYKYIFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbYKYIFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYKYIFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:05:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:38367 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbYKYIFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:05:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,663,1220252400"; 
   d="scan'208";a="407756232"
Date: Tue, 25 Nov 2008 09:05:27 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: [patch 6/9] x86, bts, ptrace: move BTS buffer allocation from ds.c into ptrace.c
Message-ID: <20081125090527.A31252@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Require pre-allocated buffers in ds.h.

Move the BTS buffer allocation for ptrace into ptrace.c.
The pointer to the allocated buffer is stored in the traced task's
task_struct together with the handle returned by ds_request_bts().

Removes memory accounting code.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/arch/x86/kernel/ds.c
===================================================================
--- ftrace.orig/arch/x86/kernel/ds.c	2008-11-25 08:18:01.000000000 +0100
+++ ftrace/arch/x86/kernel/ds.c	2008-11-25 08:18:03.000000000 +0100
@@ -7,13 +7,12 @@
  *
  * It manages:
  * - per-thread and per-cpu allocation of BTS and PEBS
- * - buffer memory allocation (optional)
- * - buffer overflow handling
+ * - buffer overflow handling (to be done)
  * - buffer access
  *
  * It assumes:
- * - get_task_struct on all parameter tasks
- * - current is allowed to trace parameter tasks
+ * - get_task_struct on all traced tasks
+ * - current is allowed to trace tasks
  *
  *
  * Copyright (C) 2007-2008 Intel Corporation.
@@ -57,8 +56,6 @@
 	/* the buffer provided on ds_request() and its size in bytes */
 	void *buffer;
 	size_t size;
-	/* the number of allocated pages for on-request allocated buffers */
-	unsigned int pages;
 };
 
 struct bts_tracer {
@@ -141,8 +138,7 @@
 
 
 /*
- * Locking is done only for allocating BTS or PEBS resources and for
- * guarding context and buffer memory allocation.
+ * Locking is done only for allocating BTS or PEBS resources.
  */
 static spinlock_t ds_lock = __SPIN_LOCK_UNLOCKED(ds_lock);
 
@@ -292,50 +288,6 @@
 }
 
 
-/*
- * Allocate a non-pageable buffer of the parameter size.
- * Checks the memory and the locked memory rlimit.
- *
- * Returns the buffer, if successful;
- *         NULL, if out of memory or rlimit exceeded.
- *
- * size: the requested buffer size in bytes
- * pages (out): if not NULL, contains the number of pages reserved
- */
-static inline void *ds_allocate_buffer(size_t size, unsigned int *pages)
-{
-	unsigned long rlim, vm, pgsz;
-	void *buffer = NULL;
-
-	pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
-
-	down_write(&current->mm->mmap_sem);
-
-	rlim = current->signal->rlim[RLIMIT_AS].rlim_cur >> PAGE_SHIFT;
-	vm   = current->mm->total_vm  + pgsz;
-	if (rlim < vm)
-		goto out;
-
-	rlim = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
-	vm   = current->mm->locked_vm  + pgsz;
-	if (rlim < vm)
-		goto out;
-
-	buffer = kzalloc(size, GFP_KERNEL);
-	if (!buffer)
-		goto out;
-
-	current->mm->total_vm  += pgsz;
-	current->mm->locked_vm += pgsz;
-
-	if (pages)
-		*pages = pgsz;
-
- out:
-	up_write(&current->mm->mmap_sem);
-	return buffer;
-}
-
 static void ds_install_ds_config(struct ds_context *context,
 				 enum ds_qualifier qual,
 				 void *base, size_t size, size_t ith)
@@ -382,6 +334,10 @@
 	if (!ds_cfg.sizeof_ds)
 		goto out;
 
+	error = -EINVAL;
+	if (!base)
+		goto out;
+
 	/* we require some space to do alignment adjustments below */
 	error = -EINVAL;
 	if (size < (DS_ALIGNMENT + ds_cfg.sizeof_rec[qual]))
@@ -395,13 +351,6 @@
 			goto out;
 	}
 
-	error = -ENOMEM;
-	if (!base) {
-		base = ds_allocate_buffer(size, &tracer->pages);
-		if (!base)
-			goto out;
-	}
-
 	tracer->buffer = base;
 	tracer->size = size;
 
@@ -466,7 +415,7 @@
 	return tracer;
 
  out_tracer:
-	(void)ds_release_bts(tracer);
+	kfree(tracer);
  out:
 	return ERR_PTR(error);
 }
@@ -496,31 +445,18 @@
 	return tracer;
 
  out_tracer:
-	(void)ds_release_pebs(tracer);
+	kfree(tracer);
  out:
 	return ERR_PTR(error);
 }
 
 static void ds_release(struct ds_tracer *tracer, enum ds_qualifier qual)
 {
-	if (tracer->context) {
-		BUG_ON(tracer->context->owner[qual] != tracer);
-		tracer->context->owner[qual] = NULL;
-
-		put_tracer(tracer->context->task);
-		ds_put_context(tracer->context);
-	}
+	BUG_ON(tracer->context->owner[qual] != tracer);
+	tracer->context->owner[qual] = NULL;
 
-	if (tracer->pages) {
-		kfree(tracer->buffer);
-
-		down_write(&current->mm->mmap_sem);
-
-		current->mm->total_vm  -= tracer->pages;
-		current->mm->locked_vm -= tracer->pages;
-
-		up_write(&current->mm->mmap_sem);
-	}
+	put_tracer(tracer->context->task);
+	ds_put_context(tracer->context);
 }
 
 int ds_release_bts(struct bts_tracer *tracer)
Index: ftrace/arch/x86/kernel/ptrace.c
===================================================================
--- ftrace.orig/arch/x86/kernel/ptrace.c	2008-11-25 08:18:01.000000000 +0100
+++ ftrace/arch/x86/kernel/ptrace.c	2008-11-25 08:18:03.000000000 +0100
@@ -758,6 +758,10 @@
 		bts_ovfl_callback_t ovfl = NULL;
 		unsigned int sig = 0;
 
+		error = -EINVAL;
+		if (cfg.size < (10 * bts_cfg.sizeof_bts))
+			goto errout;
+
 		if (cfg.flags & PTRACE_BTS_O_SIGNAL) {
 			if (!cfg.signal)
 				goto errout;
@@ -768,14 +772,26 @@
 			sig  = cfg.signal;
 		}
 
-		if (child->bts)
+		if (child->bts) {
 			(void)ds_release_bts(child->bts);
+			kfree(child->bts_buffer);
+
+			child->bts = NULL;
+			child->bts_buffer = NULL;
+		}
+
+		error = -ENOMEM;
+		child->bts_buffer = kzalloc(cfg.size, GFP_KERNEL);
+		if (!child->bts_buffer)
+			goto errout;
 
-		child->bts = ds_request_bts(child, /* base = */ NULL, cfg.size,
+		child->bts = ds_request_bts(child, child->bts_buffer, cfg.size,
 					    ovfl, /* th = */ (size_t)-1);
 		if (IS_ERR(child->bts)) {
 			error = PTR_ERR(child->bts);
+			kfree(child->bts_buffer);
 			child->bts = NULL;
+			child->bts_buffer = NULL;
 			goto errout;
 		}
 
@@ -972,6 +988,8 @@
 #ifdef CONFIG_X86_PTRACE_BTS
 	if (child->bts) {
 		(void)ds_release_bts(child->bts);
+		kfree(child->bts_buffer);
+		child->bts_buffer = NULL;
 
 		child->thread.debugctlmsr &= ~bts_cfg.debugctl_mask;
 		if (!child->thread.debugctlmsr)
Index: ftrace/arch/x86/include/asm/ds.h
===================================================================
--- ftrace.orig/arch/x86/include/asm/ds.h	2008-11-25 08:18:01.000000000 +0100
+++ ftrace/arch/x86/include/asm/ds.h	2008-11-25 08:18:03.000000000 +0100
@@ -7,13 +7,12 @@
  *
  * It manages:
  * - per-thread and per-cpu allocation of BTS and PEBS
- * - buffer memory allocation (optional)
- * - buffer overflow handling
+ * - buffer overflow handling (to be done)
  * - buffer access
  *
  * It assumes:
- * - get_task_struct on all parameter tasks
- * - current is allowed to trace parameter tasks
+ * - get_task_struct on all traced tasks
+ * - current is allowed to trace tasks
  *
  *
  * Copyright (C) 2007-2008 Intel Corporation.
@@ -54,8 +53,7 @@
  * task: the task to request recording for;
  *       NULL for per-cpu recording on the current cpu
  * base: the base pointer for the (non-pageable) buffer;
- *       NULL if buffer allocation requested
- * size: the size of the requested or provided buffer in bytes
+ * size: the size of the provided buffer in bytes
  * ovfl: pointer to a function to be called on buffer overflow;
  *       NULL if cyclic buffer requested
  * th: the interrupt threshold in records from the end of the buffer;
@@ -72,8 +70,6 @@
 /*
  * Release BTS or PEBS resources
  *
- * Frees buffers allocated on ds_request.
- *
  * Returns 0 on success; -Eerrno otherwise
  *
  * tracer: the tracer handle returned from ds_request_~()
Index: ftrace/include/linux/sched.h
===================================================================
--- ftrace.orig/include/linux/sched.h	2008-11-25 08:18:01.000000000 +0100
+++ ftrace/include/linux/sched.h	2008-11-25 08:18:03.000000000 +0100
@@ -1165,6 +1165,10 @@
 	 * This field actually belongs to the ptracer task.
 	 */
 	struct bts_tracer *bts;
+	/*
+	 * The buffer to hold the BTS data.
+	 */
+	void *bts_buffer;
 #endif /* CONFIG_X86_PTRACE_BTS */
 
 	/* PID/PID hash table linkage. */
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

