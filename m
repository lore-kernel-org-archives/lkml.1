Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbXBTJdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbXBTJdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 04:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbXBTJdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 04:33:51 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48058 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404AbXBTJdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 04:33:50 -0500
Date: Tue, 20 Feb 2007 18:32:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: oleg@tv-sign.ru, mingo@elte.hu, akpm@linux-foundation.org
Subject: [PATCH] fix handling of SIGCHILD from reaped child
Message-Id: <20070220183220.41b3f1ca.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SUSv3 says
==
if SIGCHLD is blocked, if wait() or waitpid() return because the status of a
child process is available, any pending SIGCHLD signal shall be cleared unless
the status of another child process is available.
==

This patch tries to implement above functionality (clear SIGCHLD from reaped 
process.)
please review...

works well on 2.6.20/ia64/NUMA environment and passed my easy test.

Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Index: linux-2.6.20-devel/kernel/signal.c
===================================================================
--- linux-2.6.20-devel.orig/kernel/signal.c
+++ linux-2.6.20-devel/kernel/signal.c
@@ -382,7 +382,7 @@ unblock_all_signals(void)
 	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 }
 
-static int collect_signal(int sig, struct sigpending *list, siginfo_t *info)
+static int collect_signal(int sig, struct sigpending *list, siginfo_t *info, pid_t checkpid)
 {
 	struct sigqueue *q, *first = NULL;
 	int still_pending = 0;
@@ -394,13 +394,24 @@ static int collect_signal(int sig, struc
 	 * Collect the siginfo appropriate to this signal.  Check if
 	 * there is another siginfo for the same signal.
 	*/
-	list_for_each_entry(q, &list->list, list) {
-		if (q->info.si_signo == sig) {
-			if (first) {
-				still_pending = 1;
-				break;
+	if (unlikely(checkpid)) {
+		list_for_each_entry(q, &list->list, list) {
+			if (q->info.si_signo == sig) {
+			    if (q->info.si_pid == checkpid)
+					first = q;
+				else
+					still_pending = 1;
+			}
+		}
+	} else {
+		list_for_each_entry(q, &list->list, list) {
+			if (q->info.si_signo == sig) {
+				if (first) {
+					still_pending = 1;
+					break;
+				}
+				first = q;
 			}
-			first = q;
 		}
 	}
 	if (first) {
@@ -415,7 +426,8 @@ static int collect_signal(int sig, struc
 		   a fast-pathed signal or we must have been
 		   out of queue space.  So zero out the info.
 		 */
-		sigdelset(&list->signal, sig);
+		if (!still_pending)
+			sigdelset(&list->signal, sig);
 		info->si_signo = sig;
 		info->si_errno = 0;
 		info->si_code = 0;
@@ -440,7 +452,7 @@ static int __dequeue_signal(struct sigpe
 			}
 		}
 
-		if (!collect_signal(sig, pending, info))
+		if (!collect_signal(sig, pending, info, 0))
 			sig = 0;
 	}
 
@@ -493,6 +505,24 @@ int dequeue_signal(struct task_struct *t
 }
 
 /*
+ * only called by do_wait() when it reaps its child.
+ * This function clears pending SIGCHLD from the reaped child.
+ * rerely does real job...
+ * Becasue we only check SIGCHLD, just checks shared_pending.
+ */
+void clear_stale_sigchild(struct task_struct *tsk, pid_t child_id)
+{
+	siginfo_t info;
+	unsigned long flags;
+	spin_lock_irqsave(&tsk->sighand->siglock, flags);
+	collect_signal(SIGCHLD, &tsk->signal->shared_pending,  &info, child_id);
+	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
+	return;
+}
+
+
+
+/*
  * Tell a process that it has a new active signal..
  *
  * NOTE! we rely on the previous spin_lock to
Index: linux-2.6.20-devel/kernel/exit.c
===================================================================
--- linux-2.6.20-devel.orig/kernel/exit.c
+++ linux-2.6.20-devel/kernel/exit.c
@@ -1252,8 +1252,12 @@ static int wait_task_zombie(struct task_
 		}
 		write_unlock_irq(&tasklist_lock);
 	}
-	if (p != NULL)
+	if (p != NULL) {
 		release_task(p);
+		/* if we received sigchild from "p" and p is released,
+		   we remove sigchild from it. */
+		clear_stale_sigchild(current, retval);
+	}
 	BUG_ON(!retval);
 	return retval;
 }

