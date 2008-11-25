Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbYKYHxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbYKYHxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 02:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbYKYHxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 02:53:06 -0500
Received: from mga14.intel.com ([143.182.124.37]:65340 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbYKYHxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 02:53:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,663,1220252400"; 
   d="scan'208";a="82310675"
Date: Tue, 25 Nov 2008 08:52:56 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: [patch 4/9] x86, bts: fix wrmsr and spinlock over kmalloc
Message-ID: <20081125085256.A31105@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn a wrmsr to write the DS_AREA MSR into a wrmsrl.

Use irqsave variants of spinlocks.

Do not allocate memory while holding spinlocks.

Reported-by: Stephane Eranian <eranian@googlemail.com>
Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/arch/x86/kernel/ds.c
===================================================================
--- ftrace.orig/arch/x86/kernel/ds.c	2008-11-25 08:17:57.000000000 +0100
+++ ftrace/arch/x86/kernel/ds.c	2008-11-25 08:17:59.000000000 +0100
@@ -209,14 +209,15 @@
 static inline struct ds_context *ds_get_context(struct task_struct *task)
 {
 	struct ds_context *context;
+	unsigned long irq;
 
-	spin_lock(&ds_lock);
+	spin_lock_irqsave(&ds_lock, irq);
 
 	context = (task ? task->thread.ds_ctx : this_system_context);
 	if (context)
 		context->count++;
 
-	spin_unlock(&ds_lock);
+	spin_unlock_irqrestore(&ds_lock, irq);
 
 	return context;
 }
@@ -224,55 +225,46 @@
 /*
  * Same as ds_get_context, but allocates the context and it's DS
  * structure, if necessary; returns NULL; if out of memory.
- *
- * pre: requires ds_lock to be held
  */
 static inline struct ds_context *ds_alloc_context(struct task_struct *task)
 {
 	struct ds_context **p_context =
 		(task ? &task->thread.ds_ctx : &this_system_context);
 	struct ds_context *context = *p_context;
+	unsigned long irq;
 
 	if (!context) {
-		spin_unlock(&ds_lock);
-
 		context = kzalloc(sizeof(*context), GFP_KERNEL);
-
-		if (!context) {
-			spin_lock(&ds_lock);
+		if (!context)
 			return NULL;
-		}
 
 		context->ds = kzalloc(ds_cfg.sizeof_ds, GFP_KERNEL);
 		if (!context->ds) {
 			kfree(context);
-			spin_lock(&ds_lock);
 			return NULL;
 		}
 
-		spin_lock(&ds_lock);
-		/*
-		 * Check for race - another CPU could have allocated
-		 * it meanwhile:
-		 */
+		spin_lock_irqsave(&ds_lock, irq);
+
 		if (*p_context) {
 			kfree(context->ds);
 			kfree(context);
-			return *p_context;
-		}
-
-		*p_context = context;
-
-		context->this = p_context;
-		context->task = task;
-
-		if (task)
-			set_tsk_thread_flag(task, TIF_DS_AREA_MSR);
-
-		if (!task || (task == current))
-			wrmsr(MSR_IA32_DS_AREA, (unsigned long)context->ds, 0);
 
-		get_tracer(task);
+			context = *p_context;
+		} else {
+			*p_context = context;
+
+			context->this = p_context;
+			context->task = task;
+
+			if (task)
+				set_tsk_thread_flag(task, TIF_DS_AREA_MSR);
+
+			if (!task || (task == current))
+				wrmsrl(MSR_IA32_DS_AREA,
+				       (unsigned long)context->ds);
+		}
+		spin_unlock_irqrestore(&ds_lock, irq);
 	}
 
 	context->count++;
@@ -286,10 +278,12 @@
  */
 static inline void ds_put_context(struct ds_context *context)
 {
+	unsigned long irq;
+
 	if (!context)
 		return;
 
-	spin_lock(&ds_lock);
+	spin_lock_irqsave(&ds_lock, irq);
 
 	if (--context->count)
 		goto out;
@@ -311,7 +305,7 @@
 	kfree(context->ds);
 	kfree(context);
  out:
-	spin_unlock(&ds_lock);
+	spin_unlock_irqrestore(&ds_lock, irq);
 }
 
 
@@ -382,6 +376,7 @@
 	struct ds_context *context;
 	unsigned long buffer, adj;
 	const unsigned long alignment = (1 << 3);
+	unsigned long irq;
 	int error = 0;
 
 	if (!ds_cfg.sizeof_ds)
@@ -396,26 +391,27 @@
 		return -EOPNOTSUPP;
 
 
-	spin_lock(&ds_lock);
-
-	error = -ENOMEM;
 	context = ds_alloc_context(task);
 	if (!context)
-		goto out_unlock;
+		return -ENOMEM;
+
+	spin_lock_irqsave(&ds_lock, irq);
 
 	error = -EPERM;
 	if (!check_tracer(task))
 		goto out_unlock;
 
+	get_tracer(task);
+
 	error = -EALREADY;
 	if (context->owner[qual] == current)
-		goto out_unlock;
+		goto out_put_tracer;
 	error = -EPERM;
 	if (context->owner[qual] != NULL)
-		goto out_unlock;
+		goto out_put_tracer;
 	context->owner[qual] = current;
 
-	spin_unlock(&ds_lock);
+	spin_unlock_irqrestore(&ds_lock, irq);
 
 
 	error = -ENOMEM;
@@ -463,10 +459,17 @@
  out_release:
 	context->owner[qual] = NULL;
 	ds_put_context(context);
+	put_tracer(task);
+	return error;
+
+ out_put_tracer:
+	spin_unlock_irqrestore(&ds_lock, irq);
+	ds_put_context(context);
+	put_tracer(task);
 	return error;
 
  out_unlock:
-	spin_unlock(&ds_lock);
+	spin_unlock_irqrestore(&ds_lock, irq);
 	ds_put_context(context);
 	return error;
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

