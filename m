Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbZBKVQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbZBKVQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758107AbZBKVPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:15:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36175 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757176AbZBKVOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:14:54 -0500
Date: Wed, 11 Feb 2009 22:12:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] forget_original_parent: do not abuse
	child->ptrace_entry
Message-ID: <20090211211218.GA16850@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By discussion with Roland.

- Use ->sibling instead of ->ptrace_entry to chain the need to be
  release_task'd childs. Nobody else can use ->sibling, this task
  is EXIT_DEAD and nobody can find it on its own list.

- rename ptrace_dead to dead_childs.

- Now that we don't have the "parallel" untrace code, change back
  reparent_thread() to return void, pass dead_childs as an argument.

Actually, I don't understand why do we notify /sbin/init when we
reparent a zombie, probably it is better to reap it unconditionally.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/exit.c~2_REPARENT	2009-02-11 03:01:46.000000000 +0100
+++ 6.29-rc3/kernel/exit.c	2009-02-11 06:37:36.000000000 +0100
@@ -723,46 +723,6 @@ static void exit_mm(struct task_struct *
 	mmput(mm);
 }
 
-/* Returns nonzero if the child should be released. */
-static int reparent_thread(struct task_struct *p, struct task_struct *father)
-{
-	int dead;
-
-	if (p->pdeath_signal)
-		/* We already hold the tasklist_lock here.  */
-		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
-
-	list_move_tail(&p->sibling, &p->real_parent->children);
-
-	if (task_detached(p))
-		return 0;
-	/* If this is a threaded reparent there is no need to
-	 * notify anyone anything has happened.
-	 */
-	if (same_thread_group(p->real_parent, father))
-		return 0;
-
-	/* We don't want people slaying init.  */
-	p->exit_signal = SIGCHLD;
-
-	/* If we'd notified the old parent about this child's death,
-	 * also notify the new parent.
-	 */
-	dead = 0;
-	if (!p->ptrace &&
-	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
-		do_notify_parent(p, p->exit_signal);
-		if (task_detached(p)) {
-			p->exit_state = EXIT_DEAD;
-			dead = 1;
-		}
-	}
-
-	kill_orphaned_pgrp(p, father);
-
-	return dead;
-}
-
 /*
  * When we die, we re-parent all our children.
  * Try to give them to another thread in our thread
@@ -802,10 +762,46 @@ static struct task_struct *find_new_reap
 	return pid_ns->child_reaper;
 }
 
+/*
+* Any that need to be release_task'd are put on the @dead list.
+ */
+static void reparent_thread(struct task_struct *father, struct task_struct *p,
+				struct list_head *dead)
+{
+	if (p->pdeath_signal)
+		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
+
+	list_move_tail(&p->sibling, &p->real_parent->children);
+
+	if (task_detached(p))
+		return;
+	/*
+	 * If this is a threaded reparent there is no need to
+	 * notify anyone anything has happened.
+	 */
+	if (same_thread_group(p->real_parent, father))
+		return;
+
+	/* We don't want people slaying init.  */
+	p->exit_signal = SIGCHLD;
+
+	/* If it has exited notify the new parent about this child's death. */
+	if (!p->ptrace &&
+	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
+		do_notify_parent(p, p->exit_signal);
+		if (task_detached(p)) {
+			p->exit_state = EXIT_DEAD;
+			list_move_tail(&p->sibling, dead);
+		}
+	}
+
+	kill_orphaned_pgrp(p, father);
+}
+
 static void forget_original_parent(struct task_struct *father)
 {
 	struct task_struct *p, *n, *reaper;
-	LIST_HEAD(ptrace_dead);
+	LIST_HEAD(dead_childs);
 
 	exit_ptrace(father);
 
@@ -818,15 +814,14 @@ static void forget_original_parent(struc
 			BUG_ON(p->ptrace);
 			p->parent = p->real_parent;
 		}
-		if (reparent_thread(p, father))
-			list_add(&p->ptrace_entry, &ptrace_dead);;
+		reparent_thread(father, p, &dead_childs);
 	}
-
 	write_unlock_irq(&tasklist_lock);
+
 	BUG_ON(!list_empty(&father->children));
 
-	list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_entry) {
-		list_del_init(&p->ptrace_entry);
+	list_for_each_entry_safe(p, n, &dead_childs, sibling) {
+		list_del_init(&p->sibling);
 		release_task(p);
 	}
 }

