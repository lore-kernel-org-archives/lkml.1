Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbZA2IJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbZA2IJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZA2IIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:08:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45855 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbZA2IIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:08:34 -0500
Date: Thu, 29 Jan 2009 09:06:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] reparent_thread: fix a zombie leak if /sbin/init
	ignores SIGCHLD
Message-ID: <20090129080600.GA26878@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If /sbin/init ignores SIGCHLD and we re-parent a zombie, it is leaked.
reparent_thread() does do_notify_parent() which sets ->exit_signal = -1
in this case. This means that nobody except us can reap it, the detached
task is not visible to do_wait().

Change reparent_thread() to return a boolean (like __pthread_detach) to
indicate that the thread is dead and must be released. Also change
forget_original_parent() to add the child to ptrace_dead list in this
case.

The naming becomes insane, the next patch does the cleanup.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/exit.c~7_FIX_INIT_IGN_CHLD	2009-01-29 06:57:09.000000000 +0100
+++ 6.29-rc3/kernel/exit.c	2009-01-29 08:03:18.000000000 +0100
@@ -804,8 +804,11 @@ static void ptrace_exit_finish(struct ta
 	}
 }
 
-static void reparent_thread(struct task_struct *p, struct task_struct *father)
+/* Returns nonzero if the child should be released. */
+static int reparent_thread(struct task_struct *p, struct task_struct *father)
 {
+	int dead;
+
 	if (p->pdeath_signal)
 		/* We already hold the tasklist_lock here.  */
 		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
@@ -813,12 +816,12 @@ static void reparent_thread(struct task_
 	list_move_tail(&p->sibling, &p->real_parent->children);
 
 	if (task_detached(p))
-		return;
+		return 0;
 	/* If this is a threaded reparent there is no need to
 	 * notify anyone anything has happened.
 	 */
 	if (same_thread_group(p->real_parent, father))
-		return;
+		return 0;
 
 	/* We don't want people slaying init.  */
 	p->exit_signal = SIGCHLD;
@@ -826,11 +829,19 @@ static void reparent_thread(struct task_
 	/* If we'd notified the old parent about this child's death,
 	 * also notify the new parent.
 	 */
+	dead = 0;
 	if (!p->ptrace &&
-	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p))
+	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
 		do_notify_parent(p, p->exit_signal);
+		if (task_detached(p)) {
+			p->exit_state = EXIT_DEAD;
+			dead = 1;
+		}
+	}
 
 	kill_orphaned_pgrp(p, father);
+
+	return dead;
 }
 
 /*
@@ -890,7 +901,8 @@ static void forget_original_parent(struc
 			BUG_ON(p->ptrace);
 			p->parent = p->real_parent;
 		}
-		reparent_thread(p, father);
+		if (reparent_thread(p, father))
+			list_add(&p->ptrace_entry, &ptrace_dead);;
 	}
 
 	write_unlock_irq(&tasklist_lock);

