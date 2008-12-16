Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYLPOvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYLPOvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 09:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbYLPOvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 09:51:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:47843 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbYLPOvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 09:51:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,231,1228118400"; 
   d="scan'208";a="474432201"
Date: Tue, 16 Dec 2008 15:51:03 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com
Subject: [patch 2/3] x86, bts: remove recursion from get_context
Message-ID: <20081216155103.A30039@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimistically allocate a DS context. It is extremely unlikely that
one already existed. This simplifies the code a lot.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Reported-by: Ingo Molnar <mingo@elte.hu>
---

Index: ftrace/arch/x86/kernel/ds.c
===================================================================
--- ftrace.orig/arch/x86/kernel/ds.c	2008-12-12 14:02:24.000000000 +0100
+++ ftrace/arch/x86/kernel/ds.c	2008-12-12 16:25:22.000000000 +0100
@@ -232,53 +232,45 @@
 
 #define system_context per_cpu(system_context_array, smp_processor_id())
 
-static struct ds_context *ds_get_context(struct task_struct *task)
+
+static inline struct ds_context *ds_get_context(struct task_struct *task)
 {
 	struct ds_context **p_context =
 		(task ? &task->thread.ds_ctx : &system_context);
-	struct ds_context *context = *p_context;
+	struct ds_context *context = NULL;
+	struct ds_context *new_context = NULL;
 	unsigned long irq;
 
-	if (!context) {
-		context = kzalloc(sizeof(*context), GFP_KERNEL);
-		if (!context)
-			return NULL;
-
-		spin_lock_irqsave(&ds_lock, irq);
-
-		if (*p_context) {
-			kfree(context);
+	/* Chances are small that we already have a context. */
+	new_context = kzalloc(sizeof(*new_context), GFP_KERNEL);
+	if (!new_context)
+		return NULL;
 
-			context = *p_context;
-		} else {
-			*p_context = context;
+	spin_lock_irqsave(&ds_lock, irq);
 
-			context->this = p_context;
-			context->task = task;
+	context = *p_context;
+	if (!context) {
+		context = new_context;
 
-			if (task)
-				set_tsk_thread_flag(task, TIF_DS_AREA_MSR);
+		context->this = p_context;
+		context->task = task;
+		context->count = 0;
 
-			if (!task || (task == current))
-				wrmsrl(MSR_IA32_DS_AREA,
-				       (unsigned long)context->ds);
-		}
+		if (task)
+			set_tsk_thread_flag(task, TIF_DS_AREA_MSR);
 
-		context->count++;
+		if (!task || (task == current))
+			wrmsrl(MSR_IA32_DS_AREA, (unsigned long)context->ds);
 
-		spin_unlock_irqrestore(&ds_lock, irq);
-	} else {
-		spin_lock_irqsave(&ds_lock, irq);
+		*p_context = context;
+	}
 
-		context = *p_context;
-		if (context)
-			context->count++;
+	context->count++;
 
-		spin_unlock_irqrestore(&ds_lock, irq);
+	spin_unlock_irqrestore(&ds_lock, irq);
 
-		if (!context)
-			context = ds_get_context(task);
-	}
+	if (context != new_context)
+		kfree(new_context);
 
 	return context;
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

