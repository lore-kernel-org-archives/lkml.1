Return-Path: <linux-kernel-owner+w=401wt.eu-S1761301AbZEGJXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301AbZEGJXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761164AbZEGJW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:22:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:40378 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761191AbZEGJWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:22:55 -0400
Date: Thu, 7 May 2009 09:22:21 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090403144552.856000000@intel.com>
References: <20090403144552.856000000@intel.com>
Subject: [tip:tracing/core] x86, bts: fix race between per-task and per-cpu branch tracing
Message-ID: <tip-38f801129ad07b9afa7f9bd3779f61b805416d8c@git.kernel.org>
Git-Commit-ID: 38f801129ad07b9afa7f9bd3779f61b805416d8c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:22:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38f801129ad07b9afa7f9bd3779f61b805416d8c
Gitweb:     http://git.kernel.org/tip/38f801129ad07b9afa7f9bd3779f61b805416d8c
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:16 +0200

x86, bts: fix race between per-task and per-cpu branch tracing

Per-task branch tracing installs a debug store context with the traced
task. This immediately results in the branch trace control bits to be
cleared for the next context switch of that task, if not set before.

Either per-cpu or per-task tracing are allowed at the same time.

An active per-cpu tracing would be disabled even if the per-task tracing
request is rejected and the task debug store context removed.

Check the tracing type (per-cpu or per-task) before installing a task
debug store context.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: oleg@redhat.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144552.856000000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds.c |   72 ++++++++++++++++++++++++++++---------------------
 1 files changed, 41 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 5cd137a..f03f117 100644
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
@@ -209,14 +225,6 @@ static inline void put_tracer(struct task_struct *task)
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
@@ -677,6 +685,10 @@ struct bts_tracer *ds_request_bts(struct task_struct *task,
 	if (ovfl)
 		goto out;
 
+	error = get_tracer(task);
+	if (error < 0)
+		goto out;
+
 	/*
 	 * Per-cpu tracing is typically requested using smp_call_function().
 	 * We must not sleep.
@@ -684,7 +696,7 @@ struct bts_tracer *ds_request_bts(struct task_struct *task,
 	error = -ENOMEM;
 	tracer = kzalloc(sizeof(*tracer), GFP_ATOMIC);
 	if (!tracer)
-		goto out;
+		goto out_put_tracer;
 	tracer->ovfl = ovfl;
 
 	error = ds_request(&tracer->ds, &tracer->trace.ds,
@@ -696,13 +708,8 @@ struct bts_tracer *ds_request_bts(struct task_struct *task,
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
@@ -716,13 +723,13 @@ struct bts_tracer *ds_request_bts(struct task_struct *task,
 
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
@@ -741,6 +748,10 @@ struct pebs_tracer *ds_request_pebs(struct task_struct *task,
 	if (ovfl)
 		goto out;
 
+	error = get_tracer(task);
+	if (error < 0)
+		goto out;
+
 	/*
 	 * Per-cpu tracing is typically requested using smp_call_function().
 	 * We must not sleep.
@@ -748,7 +759,7 @@ struct pebs_tracer *ds_request_pebs(struct task_struct *task,
 	error = -ENOMEM;
 	tracer = kzalloc(sizeof(*tracer), GFP_ATOMIC);
 	if (!tracer)
-		goto out;
+		goto out_put_tracer;
 	tracer->ovfl = ovfl;
 
 	error = ds_request(&tracer->ds, &tracer->trace.ds,
@@ -759,13 +770,8 @@ struct pebs_tracer *ds_request_pebs(struct task_struct *task,
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
@@ -775,13 +781,13 @@ struct pebs_tracer *ds_request_pebs(struct task_struct *task,
 
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
@@ -804,8 +810,8 @@ void ds_release_bts(struct bts_tracer *tracer)
 	if (task && (task != current))
 		wait_task_context_switch(task);
 
-	put_tracer(task);
 	ds_put_context(tracer->ds.context);
+	put_tracer(task);
 
 	kfree(tracer);
 }
@@ -861,16 +867,20 @@ void ds_resume_bts(struct bts_tracer *tracer)
 
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
