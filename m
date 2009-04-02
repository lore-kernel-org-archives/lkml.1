Return-Path: <linux-kernel-owner+w=401wt.eu-S1761569AbZDBO5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761569AbZDBO5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760493AbZDBO5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:57:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:49002 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757345AbZDBO5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:57:09 -0400
Content-Type: multipart/mixed; boundary="===============1957286944=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,314,1235980800"; 
   d="scan'208";a="444385896"
Message-Id: <20090402145702.669790000@intel.com>
References: <20090402145455.597376000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 16:54:56 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 01/18] x86, bts: fix race when bts tracer is removed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============1957286944==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.ds.tracing_flags.patch

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


Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/ds.c |   48 	29 +	19 -	0 !
 1 file changed, 29 insertions(+), 19 deletions(-)

Index: b/arch/x86/kernel/ds.c
===================================================================
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
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
@@ -1037,6 +1044,23 @@ void __cpuinit ds_init_intel(struct cpui
 	}
 }
 
+static inline void ds_take_timestamp(struct ds_context *context,
+				     enum bts_qualifier qualifier,
+				     struct task_struct *task)
+{
+	struct bts_tracer *tracer = context->bts_master;
+	barrier();
+
+	if (tracer && (tracer->flags & BTS_TIMESTAMPS)) {
+		struct bts_struct ts = {
+			.qualifier = qualifier,
+			.variant.timestamp.jiffies = jiffies_64,
+			.variant.timestamp.pid = task->pid
+		};
+		bts_write(tracer, &ts);
+	}
+}
+
 /*
  * Change the DS configuration from tracing prev to tracing next.
  */
@@ -1044,36 +1068,22 @@ void ds_switch_to(struct task_struct *pr
 {
 	struct ds_context *prev_ctx = prev->thread.ds_ctx;
 	struct ds_context *next_ctx = next->thread.ds_ctx;
+	unsigned long debugctlmsr = next->thread.debugctlmsr;
+	barrier();
 
 	if (prev_ctx) {
 		update_debugctlmsr(0);
 
-		if (prev_ctx->bts_master &&
-		    (prev_ctx->bts_master->trace.ds.flags & BTS_TIMESTAMPS)) {
-			struct bts_struct ts = {
-				.qualifier = bts_task_departs,
-				.variant.timestamp.jiffies = jiffies_64,
-				.variant.timestamp.pid = prev->pid
-			};
-			bts_write(prev_ctx->bts_master, &ts);
-		}
+		ds_take_timestamp(prev_ctx, bts_task_departs, prev);
 	}
 
 	if (next_ctx) {
-		if (next_ctx->bts_master &&
-		    (next_ctx->bts_master->trace.ds.flags & BTS_TIMESTAMPS)) {
-			struct bts_struct ts = {
-				.qualifier = bts_task_arrives,
-				.variant.timestamp.jiffies = jiffies_64,
-				.variant.timestamp.pid = next->pid
-			};
-			bts_write(next_ctx->bts_master, &ts);
-		}
+		ds_take_timestamp(next_ctx, bts_task_arrives, next);
 
 		wrmsrl(MSR_IA32_DS_AREA, (unsigned long)next_ctx->ds);
 	}
 
-	update_debugctlmsr(next->thread.debugctlmsr);
+	update_debugctlmsr(debugctlmsr);
 }
 
 void ds_copy_thread(struct task_struct *tsk, struct task_struct *father)

-- 

--===============1957286944==
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

--===============1957286944==--
