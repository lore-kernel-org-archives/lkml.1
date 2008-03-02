Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbYCBSlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbYCBSlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 13:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbYCBSlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 13:41:09 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:44218 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbYCBSlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 13:41:07 -0500
Date: Sun, 2 Mar 2008 21:44:40 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@redhat.com>, Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] introduce kill_orphaned_pgrp() helper
Message-ID: <20080302184440.GA16365@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out the common code in reparent_thread() and exit_notify().

No functional changes.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/exit.c~1_MK_HOG	2008-03-02 18:08:22.000000000 +0300
+++ 25/kernel/exit.c	2008-03-02 19:18:58.000000000 +0300
@@ -255,6 +255,37 @@ static int has_stopped_jobs(struct pid *
 	return retval;
 }
 
+/*
+ * Check to see if any process groups have become orphaned as
+ * a result of our exiting, and if they have any stopped jobs,
+ * send them a SIGHUP and then a SIGCONT. (POSIX 3.2.2.2)
+ */
+static void
+kill_orphaned_pgrp(struct task_struct *tsk, struct task_struct *parent)
+{
+	struct pid *pgrp = task_pgrp(tsk);
+	struct task_struct *ignored_task = tsk;
+
+	if (!parent)
+		 /* exit: our father is in a different pgrp than
+		  * we are and we were the only connection outside.
+		  */
+		parent = tsk->real_parent;
+	else
+		/* reparent: our child is in a different pgrp than
+		 * we are, and it was the only connection outside.
+		 */
+		ignored_task = NULL;
+
+	if (task_pgrp(parent) != pgrp &&
+	    task_session(parent) == task_session(tsk) &&
+	    will_become_orphaned_pgrp(pgrp, ignored_task) &&
+	    has_stopped_jobs(pgrp)) {
+		__kill_pgrp_info(SIGHUP, SEND_SIG_PRIV, pgrp);
+		__kill_pgrp_info(SIGCONT, SEND_SIG_PRIV, pgrp);
+	}
+}
+
 /**
  * reparent_to_kthreadd - Reparent the calling kernel thread to kthreadd
  *
@@ -639,22 +670,7 @@ reparent_thread(struct task_struct *p, s
 	    p->exit_signal != -1 && thread_group_empty(p))
 		do_notify_parent(p, p->exit_signal);
 
-	/*
-	 * process group orphan check
-	 * Case ii: Our child is in a different pgrp
-	 * than we are, and it was the only connection
-	 * outside, so the child pgrp is now orphaned.
-	 */
-	if ((task_pgrp(p) != task_pgrp(father)) &&
-	    (task_session(p) == task_session(father))) {
-		struct pid *pgrp = task_pgrp(p);
-
-		if (will_become_orphaned_pgrp(pgrp, NULL) &&
-		    has_stopped_jobs(pgrp)) {
-			__kill_pgrp_info(SIGHUP, SEND_SIG_PRIV, pgrp);
-			__kill_pgrp_info(SIGCONT, SEND_SIG_PRIV, pgrp);
-		}
-	}
+	kill_orphaned_pgrp(p, father);
 }
 
 /*
@@ -742,8 +758,6 @@ static void forget_original_parent(struc
 static void exit_notify(struct task_struct *tsk)
 {
 	int state;
-	struct task_struct *t;
-	struct pid *pgrp;
 
 	/*
 	 * This does two things:
@@ -757,25 +771,7 @@ static void exit_notify(struct task_stru
 	exit_task_namespaces(tsk);
 
 	write_lock_irq(&tasklist_lock);
-	/*
-	 * Check to see if any process groups have become orphaned
-	 * as a result of our exiting, and if they have any stopped
-	 * jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
-	 *
-	 * Case i: Our father is in a different pgrp than we are
-	 * and we were the only connection outside, so our pgrp
-	 * is about to become orphaned.
-	 */
-	t = tsk->real_parent;
-
-	pgrp = task_pgrp(tsk);
-	if ((task_pgrp(t) != pgrp) &&
-	    (task_session(t) == task_session(tsk)) &&
-	    will_become_orphaned_pgrp(pgrp, tsk) &&
-	    has_stopped_jobs(pgrp)) {
-		__kill_pgrp_info(SIGHUP, SEND_SIG_PRIV, pgrp);
-		__kill_pgrp_info(SIGCONT, SEND_SIG_PRIV, pgrp);
-	}
+	kill_orphaned_pgrp(tsk, NULL);
 
 	/* Let father know we died
 	 *
@@ -792,8 +788,8 @@ static void exit_notify(struct task_stru
 	 * the same after a fork.
 	 */
 	if (tsk->exit_signal != SIGCHLD && tsk->exit_signal != -1 &&
-	    ( tsk->parent_exec_id != t->self_exec_id  ||
-	      tsk->self_exec_id != tsk->parent_exec_id)
+	    (tsk->parent_exec_id != tsk->real_parent->self_exec_id ||
+	     tsk->self_exec_id != tsk->parent_exec_id)
 	    && !capable(CAP_KILL))
 		tsk->exit_signal = SIGCHLD;
 

