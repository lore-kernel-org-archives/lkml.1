Return-Path: <linux-kernel-owner+w=401wt.eu-S1765846AbZDCOsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765846AbZDCOsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932707AbZDCOqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:46:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:17348 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482AbZDCOqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:46:00 -0400
Content-Type: multipart/mixed; boundary="===============0549536099=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="503328307"
Message-Id: <20090403144552.856000000@intel.com>
References: <20090403144332.799740000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 16:43:37 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 05/20] x86, bts: fix race between per-task and per-cpu branch tracing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0549536099==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.ds.get_tracer.patch

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
 arch/x86/kernel/ds.c |   72 	41 +	31 -	0 !
 1 file changed, 41 insertions(+), 31 deletions(-)

Index: b/arch/x86/kernel/ds.c
===================================================================
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
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
@@ -677,6 +685,10 @@ struct bts_tracer *ds_request_bts(struct
 	if (ovfl)
 		goto out;
 
+	error = get_tracer(task);
+	if (error < 0)
+		goto out;
+
 	/*
 	 * Per-cpu tracing is typically requested using smp_call_function().
 	 * We must not sleep.
@@ -684,7 +696,7 @@ struct bts_tracer *ds_request_bts(struct
 	error = -ENOMEM;
 	tracer = kzalloc(sizeof(*tracer), GFP_ATOMIC);
 	if (!tracer)
-		goto out;
+		goto out_put_tracer;
 	tracer->ovfl = ovfl;
 
 	error = ds_request(&tracer->ds, &tracer->trace.ds,
@@ -696,13 +708,8 @@ struct bts_tracer *ds_request_bts(struct
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
@@ -716,13 +723,13 @@ struct bts_tracer *ds_request_bts(struct
 
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
@@ -741,6 +748,10 @@ struct pebs_tracer *ds_request_pebs(stru
 	if (ovfl)
 		goto out;
 
+	error = get_tracer(task);
+	if (error < 0)
+		goto out;
+
 	/*
 	 * Per-cpu tracing is typically requested using smp_call_function().
 	 * We must not sleep.
@@ -748,7 +759,7 @@ struct pebs_tracer *ds_request_pebs(stru
 	error = -ENOMEM;
 	tracer = kzalloc(sizeof(*tracer), GFP_ATOMIC);
 	if (!tracer)
-		goto out;
+		goto out_put_tracer;
 	tracer->ovfl = ovfl;
 
 	error = ds_request(&tracer->ds, &tracer->trace.ds,
@@ -759,13 +770,8 @@ struct pebs_tracer *ds_request_pebs(stru
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
@@ -775,13 +781,13 @@ struct pebs_tracer *ds_request_pebs(stru
 
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
@@ -804,8 +810,8 @@ void ds_release_bts(struct bts_tracer *t
 	if (task && (task != current))
 		wait_task_context_switch(task);
 
-	put_tracer(task);
 	ds_put_context(tracer->ds.context);
+	put_tracer(task);
 
 	kfree(tracer);
 }
@@ -861,16 +867,20 @@ void ds_resume_bts(struct bts_tracer *tr
 
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

-- 

--===============0549536099==
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

--===============0549536099==--
