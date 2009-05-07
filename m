Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbZEGJ0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbZEGJ0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761533AbZEGJX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:23:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:40469 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761211AbZEGJXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:23:47 -0400
Date: Thu, 7 May 2009 09:21:38 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20090403144548.881338000@intel.com>
References: <20090403144548.881338000@intel.com>
Subject: [tip:tracing/core] x86, bts: fix race when bts tracer is removed
Message-ID: <tip-cac94f979326212831c0ea44ed9ea1622b4f4e93@git.kernel.org>
Git-Commit-ID: cac94f979326212831c0ea44ed9ea1622b4f4e93
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:21:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cac94f979326212831c0ea44ed9ea1622b4f4e93
Gitweb:     http://git.kernel.org/tip/cac94f979326212831c0ea44ed9ea1622b4f4e93
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:10 +0200

x86, bts: fix race when bts tracer is removed

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
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144548.881338000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds.c |   58 +++++++++++++++++++++++++++++++------------------
 1 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index b1d6e1f..c730155 100644
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
@@ -799,6 +802,8 @@ void ds_suspend_bts(struct bts_tracer *tracer)
 	if (!tracer)
 		return;
 
+	tracer->flags = 0;
+
 	task = tracer->ds.context->task;
 
 	if (!task || (task == current))
@@ -820,6 +825,8 @@ void ds_resume_bts(struct bts_tracer *tracer)
 	if (!tracer)
 		return;
 
+	tracer->flags = tracer->trace.ds.flags;
+
 	task = tracer->ds.context->task;
 
 	control = ds_cfg.ctl[dsf_bts];
@@ -1037,43 +1044,52 @@ void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
 	}
 }
 
+static inline void ds_take_timestamp(struct ds_context *context,
+				     enum bts_qualifier qualifier,
+				     struct task_struct *task)
+{
+	struct bts_tracer *tracer = context->bts_master;
+	struct bts_struct ts;
+
+	/* Prevent compilers from reading the tracer pointer twice. */
+	barrier();
+
+	if (!tracer || !(tracer->flags & BTS_TIMESTAMPS))
+		return;
+
+	memset(&ts, 0, sizeof(ts));
+	ts.qualifier			= qualifier;
+	ts.variant.timestamp.jiffies	= jiffies_64;
+	ts.variant.timestamp.pid	= task->pid;
+
+	bts_write(tracer, &ts);
+}
+
 /*
  * Change the DS configuration from tracing prev to tracing next.
  */
 void ds_switch_to(struct task_struct *prev, struct task_struct *next)
 {
-	struct ds_context *prev_ctx = prev->thread.ds_ctx;
-	struct ds_context *next_ctx = next->thread.ds_ctx;
+	struct ds_context *prev_ctx	= prev->thread.ds_ctx;
+	struct ds_context *next_ctx	= next->thread.ds_ctx;
+	unsigned long debugctlmsr	= next->thread.debugctlmsr;
+
+	/* Make sure all data is read before we start. */
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
