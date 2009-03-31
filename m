Return-Path: <linux-kernel-owner+w=401wt.eu-S1760509AbZCaNfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509AbZCaNfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760482AbZCaNdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:33:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:25809 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760447AbZCaNda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:33:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="677481212"
Date: Tue, 31 Mar 2009 14:50:51 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 1/21] x86, bts: fix race when bts tracer is removed
Message-ID: <20090331145051.A12111@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the bts tracer is removed while the traced task is running,
the write to clear the bts tracer pointer races with context switch code.

Read the tracer once during a context switch.


When a new tracer is installed, the bts tracer is set in the ds context
before the tracer is initialized in order to claim the context for that
tracer.
This may result in write accesses using an uninitialized trace configuration
when scheduling timestamps have been requested.

Store active tracing flags separately and only set active flags after
the tracing configuration has been initialized.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/kernel/ds.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds.c	2009-03-30 17:47:21.000000000 +0200
+++ git-tip/arch/x86/kernel/ds.c	2009-03-30 17:48:31.000000000 +0200
@@ -89,6 +89,9 @@ struct bts_tracer {
 
 	/* Buffer overflow notification function: */
 	bts_ovfl_callback_t	ovfl;
+
+	/* Active flags affecting trace collection. */
+	unsigned int		flags;
 };
 
 struct pebs_tracer {
@@ -799,6 +802,8 @@ void ds_suspend_bts(struct bts_tracer *t
 	if (!tracer)
 		return;
 
+	tracer->flags = 0;
+
 	task = tracer->ds.context->task;
 
 	if (!task || (task == current))
@@ -820,6 +825,8 @@ void ds_resume_bts(struct bts_tracer *tr
 	if (!tracer)
 		return;
 
+	tracer->flags = tracer->trace.ds.flags;
+
 	task = tracer->ds.context->task;
 
 	control = ds_cfg.ctl[dsf_bts];
@@ -1044,36 +1051,39 @@ void ds_switch_to(struct task_struct *pr
 {
 	struct ds_context *prev_ctx = prev->thread.ds_ctx;
 	struct ds_context *next_ctx = next->thread.ds_ctx;
+	unsigned long debugctlmsr = next->thread.debugctlmsr;
 
 	if (prev_ctx) {
+		struct bts_tracer *tracer = prev_ctx->bts_master;
+
 		update_debugctlmsr(0);
 
-		if (prev_ctx->bts_master &&
-		    (prev_ctx->bts_master->trace.ds.flags & BTS_TIMESTAMPS)) {
+		if (tracer && (tracer->flags & BTS_TIMESTAMPS)) {
 			struct bts_struct ts = {
 				.qualifier = bts_task_departs,
 				.variant.timestamp.jiffies = jiffies_64,
 				.variant.timestamp.pid = prev->pid
 			};
-			bts_write(prev_ctx->bts_master, &ts);
+			bts_write(tracer, &ts);
 		}
 	}
 
 	if (next_ctx) {
-		if (next_ctx->bts_master &&
-		    (next_ctx->bts_master->trace.ds.flags & BTS_TIMESTAMPS)) {
+		struct bts_tracer *tracer = next_ctx->bts_master;
+
+		if (tracer && (tracer->flags & BTS_TIMESTAMPS)) {
 			struct bts_struct ts = {
 				.qualifier = bts_task_arrives,
 				.variant.timestamp.jiffies = jiffies_64,
 				.variant.timestamp.pid = next->pid
 			};
-			bts_write(next_ctx->bts_master, &ts);
+			bts_write(tracer, &ts);
 		}
 
 		wrmsrl(MSR_IA32_DS_AREA, (unsigned long)next_ctx->ds);
 	}
 
-	update_debugctlmsr(next->thread.debugctlmsr);
+	update_debugctlmsr(debugctlmsr);
 }
 
 void ds_copy_thread(struct task_struct *tsk, struct task_struct *father)
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

