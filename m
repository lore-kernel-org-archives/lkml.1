Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbZDBO6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbZDBO6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761276AbZDBO5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:57:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:52235 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760989AbZDBO5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:57:17 -0400
Content-Type: multipart/mixed; boundary="===============0508950418=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,314,1235980800"; 
   d="scan'208";a="127093752"
Message-Id: <20090402145709.422226000@intel.com>
References: <20090402145455.597376000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 16:54:59 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 04/18] x86, bts: wait until traced task has been scheduled out
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0508950418==
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
 arch/x86/kernel/ds.c |   40 	40 +	0 -	0 !
 1 file changed, 40 insertions(+)

Index: b/arch/x86/kernel/ds.c
===================================================================
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -250,6 +250,40 @@ static DEFINE_PER_CPU(struct ds_context 
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
+	}
+}
+
 static inline struct ds_context *ds_get_context(struct task_struct *task)
 {
 	struct ds_context **p_context =
@@ -321,6 +355,9 @@ static inline void ds_put_context(struct
 
 	spin_unlock_irqrestore(&ds_lock, irq);
 
+	/* The context might still be in use for context switching. */
+	wait_to_unschedule(context->task);
+
 	kfree(context);
 }
 
@@ -789,6 +826,9 @@ void ds_release_bts(struct bts_tracer *t
 	WARN_ON_ONCE(tracer->ds.context->bts_master != tracer);
 	tracer->ds.context->bts_master = NULL;
 
+	/* Make sure tracing stopped and the tracer is not in use. */
+	wait_to_unschedule(tracer->ds.context->task);
+
 	put_tracer(tracer->ds.context->task);
 	ds_put_context(tracer->ds.context);
 

-- 

--===============0508950418==
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

--===============0508950418==--
