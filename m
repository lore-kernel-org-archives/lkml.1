Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbZCaNN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbZCaNN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbZCaNNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:13:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:47429 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbZCaNNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:13:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="126093526"
Date: Tue, 31 Mar 2009 15:13:31 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 6/21] x86, bts: fix race between per-task and per-cpu branch tracing
Message-ID: <20090331151331.A12892@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per-task branch tracing installs a debug store context with the traced
task. This immediately results in the branch trace control bits to be
cleared for the next context switch of that task, if not set before.

Either per-cpu or per-task tracing are allowed at the same time.

An active per-cpu tracing would be disabled even if the per-task tracing
request is rejected and the task debug store context removed.


Check the tracing type (per-cpu or per-task) before installing a task
debug store context.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/kernel/ds.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds.c	2009-03-30 17:20:11.000000000 +0200
+++ git-tip/arch/x86/kernel/ds.c	2009-03-30 17:42:34.000000000 +0200
@@ -193,12 +193,28 @@ static DEFINE_SPINLOCK(ds_lock);
  */
 static atomic_t tracers = ATOMIC_INIT(0);
 
-static inline void get_tracer(struct task_struct *task)
+static inline int get_tracer(struct task_struct *task)
 {
-	if (task)
+	int error;
+
+	spin_lock_irq(&ds_lock);
+
+	if (task) {
+		error = -EPERM;
+		if (atomic_read(&tracers) < 0)
+			goto out;
 		atomic_inc(&tracers);
-	else
+	} else {
+		error = -EPERM;
+		if (atomic_read(&tracers) > 0)
+			goto out;
 		atomic_dec(&tracers);
+	}
+
+	error = 0;
+out:
+	spin_unlock_irq(&ds_lock);
+	return error;
 }
 
 static inline void put_tracer(struct task_struct *task)
@@ -209,14 +225,6 @@ static inline void put_tracer(struct tas
 		atomic_inc(&tracers);
 }
 
-static inline int check_tracer(struct task_struct *task)
-{
-	return task ?
-		(atomic_read(&tracers) >= 0) :
-		(atomic_read(&tracers) <= 0);
-}
-
-
 /*
  * The DS context is either attached to a thread or to a cpu:
  * - in the former case, the thread_struct contains a pointer to the
@@ -709,6 +717,10 @@ struct bts_tracer *ds_request_bts(struct
 	if (ovfl)
 		goto out;
 
+	error = get_tracer(task);
+	if (error < 0)
+		goto out;
+
 	/*
 	 * Per-cpu tracing is typically requested using smp_call_function().
 	 * We must not sleep.
@@ -716,7 +728,7 @@ struct bts_tracer *ds_request_bts(struct
 	error = -ENOMEM;
 	tracer = kzalloc(sizeof(*tracer), GFP_ATOMIC);
 	if (!tracer)
-		goto out;
+		goto out_put_tracer;
 	tracer->ovfl = ovfl;
 
 	error = ds_request(&tracer->ds, &tracer->trace.ds,
@@ -728,13 +740,8 @@ struct bts_tracer *ds_request_bts(struct
 	spin_lock_irqsave(&ds_lock, irq);
 
 	error = -EPERM;
-	if (!check_tracer(task))
-		goto out_unlock;
-	get_tracer(task);
-
-	error = -EPERM;
 	if (tracer->ds.context->bts_master)
-		goto out_put_tracer;
+		goto out_unlock;
 	tracer->ds.context->bts_master = tracer;
 
 	spin_unlock_irqrestore(&ds_lock, irq);
@@ -748,13 +755,13 @@ struct bts_tracer *ds_request_bts(struct
 
 	return tracer;
 
- out_put_tracer:
-	put_tracer(task);
  out_unlock:
 	spin_unlock_irqrestore(&ds_lock, irq);
 	ds_put_context(tracer->ds.context);
  out_tracer:
 	kfree(tracer);
+ out_put_tracer:
+	put_tracer(task);
  out:
 	return ERR_PTR(error);
 }
@@ -773,6 +780,10 @@ struct pebs_tracer *ds_request_pebs(stru
 	if (ovfl)
 		goto out;
 
+	error = get_tracer(task);
+	if (error < 0)
+		goto out;
+
 	/*
 	 * Per-cpu tracing is typically requested using smp_call_function().
 	 * We must not sleep.
@@ -780,7 +791,7 @@ struct pebs_tracer *ds_request_pebs(stru
 	error = -ENOMEM;
 	tracer = kzalloc(sizeof(*tracer), GFP_ATOMIC);
 	if (!tracer)
-		goto out;
+		goto out_put_tracer;
 	tracer->ovfl = ovfl;
 
 	error = ds_request(&tracer->ds, &tracer->trace.ds,
@@ -791,13 +802,8 @@ struct pebs_tracer *ds_request_pebs(stru
 	spin_lock_irqsave(&ds_lock, irq);
 
 	error = -EPERM;
-	if (!check_tracer(task))
-		goto out_unlock;
-	get_tracer(task);
-
-	error = -EPERM;
 	if (tracer->ds.context->pebs_master)
-		goto out_put_tracer;
+		goto out_unlock;
 	tracer->ds.context->pebs_master = tracer;
 
 	spin_unlock_irqrestore(&ds_lock, irq);
@@ -807,32 +813,36 @@ struct pebs_tracer *ds_request_pebs(stru
 
 	return tracer;
 
- out_put_tracer:
-	put_tracer(task);
  out_unlock:
 	spin_unlock_irqrestore(&ds_lock, irq);
 	ds_put_context(tracer->ds.context);
  out_tracer:
 	kfree(tracer);
+ out_put_tracer:
+	put_tracer(task);
  out:
 	return ERR_PTR(error);
 }
 
 void ds_release_bts(struct bts_tracer *tracer)
 {
+	struct task_struct *task;
+
 	if (!tracer)
 		return;
 
+	task = tracer->ds.context->task;
+
 	ds_suspend_bts(tracer);
 
 	WARN_ON_ONCE(tracer->ds.context->bts_master != tracer);
 	tracer->ds.context->bts_master = NULL;
 
 	/* Make sure tracing stopped and the tracer is not in use. */
-	wait_to_unschedule(tracer->ds.context->task);
+	wait_to_unschedule(task);
 
-	put_tracer(tracer->ds.context->task);
 	ds_put_context(tracer->ds.context);
+	put_tracer(task);
 
 	kfree(tracer);
 }
@@ -888,16 +898,20 @@ void ds_resume_bts(struct bts_tracer *tr
 
 void ds_release_pebs(struct pebs_tracer *tracer)
 {
+	struct task_struct *task;
+
 	if (!tracer)
 		return;
 
+	task = tracer->ds.context->task;
+
 	ds_suspend_pebs(tracer);
 
 	WARN_ON_ONCE(tracer->ds.context->pebs_master != tracer);
 	tracer->ds.context->pebs_master = NULL;
 
-	put_tracer(tracer->ds.context->task);
 	ds_put_context(tracer->ds.context);
+	put_tracer(task);
 
 	kfree(tracer);
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

