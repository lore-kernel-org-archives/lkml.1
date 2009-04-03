Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbZDCOrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbZDCOrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765684AbZDCOqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:46:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:17417 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717AbZDCOqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:46:00 -0400
Content-Type: multipart/mixed; boundary="===============0328690642=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="503328302"
Message-Id: <20090403144551.919636000@intel.com>
References: <20090403144332.799740000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 16:43:36 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 04/20] x86, bts: wait until traced task has been scheduled out
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0328690642==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.ds.wait_task_inactive.patch

In order to stop branch tracing for a running task, we need to first
clear the branch tracing control bits before we may free the tracing
buffer.
If the traced task is running, the cpu might still trace that task
after the branch trace control bits have cleared.

Wait until the traced task has been scheduled out before proceeding.


A similar problem affects the task debug store context. We first remove
the context, then we need to wait until the task has been scheduled
out before we can free the context memory.


Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/ds.c |   23 	19 +	4 -	0 !
 1 file changed, 19 insertions(+), 4 deletions(-)

Index: b/arch/x86/kernel/ds.c
===================================================================
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -299,6 +299,7 @@ static inline struct ds_context *ds_get_
 
 static inline void ds_put_context(struct ds_context *context)
 {
+	struct task_struct *task;
 	unsigned long irq;
 
 	if (!context)
@@ -313,14 +314,20 @@ static inline void ds_put_context(struct
 
 	*(context->this) = NULL;
 
-	if (context->task)
-		clear_tsk_thread_flag(context->task, TIF_DS_AREA_MSR);
+	task = context->task;
+
+	if (task)
+		clear_tsk_thread_flag(task, TIF_DS_AREA_MSR);
 
-	if (!context->task || (context->task == current))
+	if (!task || (task == current))
 		wrmsrl(MSR_IA32_DS_AREA, 0);
 
 	spin_unlock_irqrestore(&ds_lock, irq);
 
+	/* The context might still be in use for context switching. */
+	if (task && (task != current))
+		wait_task_context_switch(task);
+
 	kfree(context);
 }
 
@@ -781,15 +788,23 @@ struct pebs_tracer *ds_request_pebs(stru
 
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
 
-	put_tracer(tracer->ds.context->task);
+	/* Make sure tracing stopped and the tracer is not in use. */
+	if (task && (task != current))
+		wait_task_context_switch(task);
+
+	put_tracer(task);
 	ds_put_context(tracer->ds.context);
 
 	kfree(tracer);

-- 

--===============0328690642==
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

--===============0328690642==--
