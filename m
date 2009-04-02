Return-Path: <linux-kernel-owner+w=401wt.eu-S1761478AbZDBO6C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761478AbZDBO6C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:58:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760330AbZDBO5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:57:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:37716 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760889AbZDBO5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:57:12 -0400
Content-Type: multipart/mixed; boundary="===============0929572262=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,314,1235980800"; 
   d="scan'208";a="678190767"
Message-Id: <20090402145704.465495000@intel.com>
References: <20090402145455.597376000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 16:54:57 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 02/18] sched: add task_is_running() fucntion to sched.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0929572262==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.sched.task_running.patch

Add a function to query whether a task is currently running on any cpu.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>

---
 include/linux/sched.h |    5 	5 +	0 -	0 !
 kernel/sched.c        |   16 	16 +	0 -	0 !
 2 files changed, 21 insertions(+)

Index: b/include/linux/sched.h
===================================================================
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1988,8 +1988,13 @@ extern void set_task_comm(struct task_st
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
+extern int task_is_running(struct task_struct *p);
 extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
 #else
+static inline int task_is_running(struct task_struct *p)
+{
+	return p == current;
+}
 static inline unsigned long wait_task_inactive(struct task_struct *p,
 					       long match_state)
 {
Index: b/kernel/sched.c
===================================================================
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1933,6 +1933,22 @@ migrate_task(struct task_struct *p, int 
 }
 
 /*
+ * Is the task currently running on any cpu?
+ */
+int task_is_running(struct task_struct *p)
+{
+	struct rq *rq;
+	unsigned long flags;
+	int running;
+
+	rq = task_rq_lock(p, &flags);
+	running = task_running(rq, p);
+	task_rq_unlock(rq, &flags);
+
+	return running;
+}
+
+/*
  * wait_task_inactive - wait for a thread to unschedule.
  *
  * If @match_state is nonzero, it's the @p->state value just checked and

-- 

--===============0929572262==
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

--===============0929572262==--
