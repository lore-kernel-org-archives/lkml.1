Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbZA2Ec0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbZA2Ec0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbZA2Ebg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:31:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33320 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758610AbZA2Ebf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:31:35 -0500
Date: Thu, 29 Jan 2009 05:29:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Roland McGrath <roland@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] ptrace: simplify ptrace_exit()->ignoring_children()
	path
Message-ID: <20090129042917.GA5108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ignoring_children() takes parent->sighand->siglock and checks
k_sigaction[SIGCHLD] atomically. But this buys nothing, we can't get
the "really" wrong result even if we race with sigaction(SIGCHLD).
If we read the "stale" sa_handler/sa_flags we can pretend it was
changed right after the check.

Remove spin_lock(->siglock), and kill "int ign" which caches the result
of ignoring_children() which becomes rather trivial.

Perhaps it makes sense to export this helper, do_notify_parent() can
use it too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/exit.c~2_IGN_SIGCHLD	2009-01-19 10:44:33.000000000 +0100
+++ 6.29-rc3/kernel/exit.c	2009-01-29 02:46:42.000000000 +0100
@@ -729,20 +729,12 @@ static void exit_mm(struct task_struct *
 }
 
 /*
- * Return nonzero if @parent's children should reap themselves.
- *
- * Called with write_lock_irq(&tasklist_lock) held.
+ * Return nonzero if childs should reap themselves.
  */
-static int ignoring_children(struct task_struct *parent)
+static int ignoring_children(struct sighand_struct *sigh)
 {
-	int ret;
-	struct sighand_struct *psig = parent->sighand;
-	unsigned long flags;
-	spin_lock_irqsave(&psig->siglock, flags);
-	ret = (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
-	       (psig->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT));
-	spin_unlock_irqrestore(&psig->siglock, flags);
-	return ret;
+	return	sigh->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
+		sigh->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT;
 }
 
 /*
@@ -754,7 +746,6 @@ static int ignoring_children(struct task
 static void ptrace_exit(struct task_struct *parent, struct list_head *dead)
 {
 	struct task_struct *p, *n;
-	int ign = -1;
 
 	list_for_each_entry_safe(p, n, &parent->ptraced, ptrace_entry) {
 		__ptrace_unlink(p);
@@ -776,12 +767,8 @@ static void ptrace_exit(struct task_stru
 		if (!task_detached(p) && thread_group_empty(p)) {
 			if (!same_thread_group(p->real_parent, parent))
 				do_notify_parent(p, p->exit_signal);
-			else {
-				if (ign < 0)
-					ign = ignoring_children(parent);
-				if (ign)
-					p->exit_signal = -1;
-			}
+			else if (ignoring_children(parent->sighand))
+				p->exit_signal = -1;
 		}
 
 		if (task_detached(p)) {

