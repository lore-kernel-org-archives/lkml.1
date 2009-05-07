Return-Path: <linux-kernel-owner+w=401wt.eu-S1761187AbZEGJWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761187AbZEGJWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760814AbZEGJWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:22:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:40354 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760350AbZEGJWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:22:36 -0400
Date: Thu, 7 May 2009 09:22:11 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20090403144551.919636000@intel.com>
References: <20090403144551.919636000@intel.com>
Subject: [tip:tracing/core] x86, bts: wait until traced task has been scheduled out
Message-ID: <tip-8d99b3ac2726e5edd97ad147fa5c1f2acb63a745@git.kernel.org>
Git-Commit-ID: 8d99b3ac2726e5edd97ad147fa5c1f2acb63a745
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:22:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d99b3ac2726e5edd97ad147fa5c1f2acb63a745
Gitweb:     http://git.kernel.org/tip/8d99b3ac2726e5edd97ad147fa5c1f2acb63a745
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:15 +0200

x86, bts: wait until traced task has been scheduled out

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
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144551.919636000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index c730155..5cd137a 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -299,6 +299,7 @@ static inline struct ds_context *ds_get_context(struct task_struct *task)
 
 static inline void ds_put_context(struct ds_context *context)
 {
+	struct task_struct *task;
 	unsigned long irq;
 
 	if (!context)
@@ -313,14 +314,20 @@ static inline void ds_put_context(struct ds_context *context)
 
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
 
@@ -781,15 +788,23 @@ struct pebs_tracer *ds_request_pebs(struct task_struct *task,
 
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
