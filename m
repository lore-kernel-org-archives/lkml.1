Return-Path: <linux-kernel-owner+w=401wt.eu-S1760688AbZCaNek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760688AbZCaNek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759330AbZCaNdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:33:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:25809 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760439AbZCaNda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:33:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="677481206"
Date: Tue, 31 Mar 2009 14:59:47 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 3/21] x86, bts: wait until traced task has been scheduled out
Message-ID: <20090331145947.A12565@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to stop branch tracing for a running task, we need to first
clear the branch tracing control bits before we may free the tracing
buffer.
If the traced task is running, the cpu might still trace that task
after the branch trace control bits have cleared.

Wait until the traced task has been scheduled out before proceeding.


A similar problem affects the task debug store context. We first remove
the context, then we need to wait until the task has been scheduled
out before we can free the context memory.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/kernel/ds.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds.c	2009-03-30 17:19:14.000000000 +0200
+++ git-tip/arch/x86/kernel/ds.c	2009-03-30 17:20:11.000000000 +0200
@@ -250,6 +250,42 @@ static DEFINE_PER_CPU(struct ds_context 
 #define system_context per_cpu(system_context_array, smp_processor_id())
 
 
+/*
+ * Wait for the traced task to unschedule.
+ *
+ * This guarantees that the bts trace configuration has been
+ * synchronized with the cpu executing the task.
+ */
+static void wait_to_unschedule(struct task_struct *task)
+{
+	unsigned long nvcsw;
+	unsigned long nivcsw;
+
+	if (!task)
+		return;
+
+	if (task == current)
+		return;
+
+	nvcsw  = task->nvcsw;
+	nivcsw = task->nivcsw;
+	for (;;) {
+		if (!task_is_running(task))
+			break;
+		/*
+		 * The switch count is incremented before the actual
+		 * context switch. We thus wait for two switches to be
+		 * sure at least one completed.
+		 */
+		if ((task->nvcsw - nvcsw) > 1)
+			break;
+		if ((task->nivcsw - nivcsw) > 1)
+			break;
+
+		schedule();
+	}
+}
+
 static inline struct ds_context *ds_get_context(struct task_struct *task)
 {
 	struct ds_context **p_context =
@@ -321,6 +357,9 @@ static inline void ds_put_context(struct
 
 	spin_unlock_irqrestore(&ds_lock, irq);
 
+	/* The context might still be in use for context switching. */
+	wait_to_unschedule(context->task);
+
 	kfree(context);
 }
 
@@ -789,6 +828,9 @@ void ds_release_bts(struct bts_tracer *t
 	WARN_ON_ONCE(tracer->ds.context->bts_master != tracer);
 	tracer->ds.context->bts_master = NULL;
 
+	/* Make sure tracing stopped and the tracer is not in use. */
+	wait_to_unschedule(tracer->ds.context->task);
+
 	put_tracer(tracer->ds.context->task);
 	ds_put_context(tracer->ds.context);
 
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

