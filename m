Return-Path: <linux-kernel-owner+w=401wt.eu-S932905AbZDCOqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbZDCOqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932591AbZDCOp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:45:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:46003 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765894AbZDCOp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:45:56 -0400
Content-Type: multipart/mixed; boundary="===============1405903643=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="503328276"
Message-Id: <20090403144549.794157000@intel.com>
References: <20090403144332.799740000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 16:43:34 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 02/20] sched: add wait_task_context_switch() fucntion to sched.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============1405903643==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.sched.task_running.patch

Add a function to wait until some other task has been switched out at least
once.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>

---
 include/linux/sched.h |    2 	2 +	0 -	0 !
 kernel/sched.c        |   43 	43 +	0 -	0 !
 2 files changed, 45 insertions(+)

Index: b/include/linux/sched.h
===================================================================
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1988,8 +1988,10 @@ extern void set_task_comm(struct task_st
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
+extern void wait_task_context_switch(struct task_struct *p);
 extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
 #else
+static inline void wait_task_context_switch(struct task_struct *p) {}
 static inline unsigned long wait_task_inactive(struct task_struct *p,
 					       long match_state)
 {
Index: b/kernel/sched.c
===================================================================
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1933,6 +1933,49 @@ migrate_task(struct task_struct *p, int 
 }
 
 /*
+ * wait_task_context_switch -	wait for a thread to complete at least one
+ *				context switch.
+ *
+ * @p must not be current.
+ */
+void wait_task_context_switch(struct task_struct *p)
+{
+	unsigned long nvcsw, nivcsw, flags;
+	int running;
+	struct rq *rq;
+
+	nvcsw	= p->nvcsw;
+	nivcsw	= p->nivcsw;
+	for (;;) {
+		/*
+		 * The runqueue is assigned before the actual context
+		 * switch. We need to take the runqueue lock.
+		 *
+		 * We could check initially without the lock but it is
+		 * very likely that we need to take the lock in every
+		 * iteration.
+		 */
+		rq = task_rq_lock(p, &flags);
+		running = task_running(rq, p);
+		task_rq_unlock(rq, &flags);
+
+		if (likely(!running))
+			break;
+		/*
+		 * The switch count is incremented before the actual
+		 * context switch. We thus wait for two switches to be
+		 * sure at least one completed.
+		 */
+		if ((p->nvcsw - nvcsw) > 1)
+			break;
+		if ((p->nivcsw - nivcsw) > 1)
+			break;
+
+		cpu_relax();
+	}
+}
+
+/*
  * wait_task_inactive - wait for a thread to unschedule.
  *
  * If @match_state is nonzero, it's the @p->state value just checked and

-- 

--===============1405903643==
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

--===============1405903643==--
