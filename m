Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbZA2IJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbZA2IJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbZA2IIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:08:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45856 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbZA2IIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:08:34 -0500
Date: Thu, 29 Jan 2009 09:06:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] forget_original_parent: cleanup ptrace pathes
Message-ID: <20090129080603.GA26882@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.

- Fold ptrace_exit() into forget_original_parent(), it is trivial
  now. More importantly, this makes the code more symmetrical with
  reparent_thread().

- The same for ptrace_exit_finish(), and "ptrace_" is not correct
  any longer.

- "ptrace_dead" doesn't match the reality, rename to "dead_list".

- swap the reparent_thread()'s arguments, just to make it more
  symmetrical with __ptrace_detach().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/exit.c~8_CLEANUP	2009-01-29 08:03:18.000000000 +0100
+++ 6.29-rc3/kernel/exit.c	2009-01-29 08:54:14.000000000 +0100
@@ -770,42 +770,8 @@ int __ptrace_detach(struct task_struct *
 	return 1;
 }
 
-/*
- * Detach all tasks we were using ptrace on.
- * Any that need to be release_task'd are put on the @dead list.
- *
- * Called with write_lock(&tasklist_lock) held.
- */
-static void ptrace_exit(struct task_struct *parent, struct list_head *dead)
-{
-	struct task_struct *p, *n;
-
-	list_for_each_entry_safe(p, n, &parent->ptraced, ptrace_entry) {
-		if (__ptrace_detach(parent, p))
-			list_add(&p->ptrace_entry, dead);
-	}
-}
-
-/*
- * Finish up exit-time ptrace cleanup.
- *
- * Called without locks.
- */
-static void ptrace_exit_finish(struct task_struct *parent,
-			       struct list_head *dead)
-{
-	struct task_struct *p, *n;
-
-	BUG_ON(!list_empty(&parent->ptraced));
-
-	list_for_each_entry_safe(p, n, dead, ptrace_entry) {
-		list_del_init(&p->ptrace_entry);
-		release_task(p);
-	}
-}
-
 /* Returns nonzero if the child should be released. */
-static int reparent_thread(struct task_struct *p, struct task_struct *father)
+static int reparent_thread(struct task_struct *father, struct task_struct *p)
 {
 	int dead;
 
@@ -886,14 +852,17 @@ static struct task_struct *find_new_reap
 static void forget_original_parent(struct task_struct *father)
 {
 	struct task_struct *p, *n, *reaper;
-	LIST_HEAD(ptrace_dead);
+	LIST_HEAD(dead_list);
 
 	write_lock_irq(&tasklist_lock);
 	reaper = find_new_reaper(father);
 	/*
 	 * First clean up ptrace if we were using it.
 	 */
-	ptrace_exit(father, &ptrace_dead);
+	list_for_each_entry_safe(p, n, &father->ptraced, ptrace_entry) {
+		if (__ptrace_detach(father, p))
+			list_add(&p->ptrace_entry, &dead_list);
+	}
 
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
 		p->real_parent = reaper;
@@ -901,14 +870,18 @@ static void forget_original_parent(struc
 			BUG_ON(p->ptrace);
 			p->parent = p->real_parent;
 		}
-		if (reparent_thread(p, father))
-			list_add(&p->ptrace_entry, &ptrace_dead);;
+		if (reparent_thread(father, p))
+			list_add(&p->ptrace_entry, &dead_list);;
 	}
-
 	write_unlock_irq(&tasklist_lock);
+
 	BUG_ON(!list_empty(&father->children));
+	BUG_ON(!list_empty(&father->ptraced));
 
-	ptrace_exit_finish(father, &ptrace_dead);
+	list_for_each_entry_safe(p, n, &dead_list, ptrace_entry) {
+		list_del_init(&p->ptrace_entry);
+		release_task(p);
+	}
 }
 
 /*

