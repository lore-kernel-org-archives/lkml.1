Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbZDMVun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbZDMVun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZDMVu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:50:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56317 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133AbZDMVu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:50:26 -0400
Date: Mon, 13 Apr 2009 23:45:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] rework/fix is_single_threaded()
Message-ID: <20090413214513.GA1119@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Fix the comment, is_single_threaded(p) actually means that nobody shares
  ->mm with p.

  I think this helper should be renamed, and it should not have arguments.
  With or without this patch it must not be used unless p == current,
  otherwise we can't safely use p->signal or p->mm.

- "if (atomic_read(&p->signal->count) != 1)" is not right when we have a
  zombie group leader, use signal->live instead.

- Add PF_KTHREAD check to skip kernel threads which may borrow p->mm,
  otherwise we can return the wrong "false".

- Use for_each_process() instead of do_each_thread(), all threads must use
  the same ->mm.

- Use down_write(mm->mmap_sem) + rcu_read_lock() instead of tasklist_lock
  to iterate over the process list. If there is another CLONE_VM process
  it can't pass exit_mm() which takes the same mm->mmap_sem. We can miss
  a freshly forked CLONE_VM task, but this doesn't matter because we must
  see its parent and return false.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.30/lib/is_single_threaded.c~ISS	2009-04-06 00:03:42.000000000 +0200
+++ 6.30/lib/is_single_threaded.c	2009-04-13 23:39:56.000000000 +0200
@@ -12,34 +12,44 @@
 
 #include <linux/sched.h>
 
-/**
- * is_single_threaded - Determine if a thread group is single-threaded or not
- * @p: A task in the thread group in question
- *
- * This returns true if the thread group to which a task belongs is single
- * threaded, false if it is not.
+/*
+ * Returns true if the task does not share ->mm with another thread/process.
  */
-bool is_single_threaded(struct task_struct *p)
+bool is_single_threaded(struct task_struct *task)
 {
-	struct task_struct *g, *t;
-	struct mm_struct *mm = p->mm;
+	struct mm_struct *mm = task->mm;
+	struct task_struct *p, *t;
+	bool ret;
 
-	if (atomic_read(&p->signal->count) != 1)
-		goto no;
+	might_sleep();
 
-	if (atomic_read(&p->mm->mm_users) != 1) {
-		read_lock(&tasklist_lock);
-		do_each_thread(g, t) {
-			if (t->mm == mm && t != p)
-				goto no_unlock;
-		} while_each_thread(g, t);
-		read_unlock(&tasklist_lock);
-	}
+	if (atomic_read(&task->signal->live) != 1)
+		return false;
 
-	return true;
+	if (atomic_read(&mm->mm_users) == 1)
+		return true;
 
-no_unlock:
-	read_unlock(&tasklist_lock);
-no:
-	return false;
+	ret = false;
+	down_write(&mm->mmap_sem);
+	rcu_read_lock();
+	for_each_process(p) {
+		if (unlikely(p->flags & PF_KTHREAD))
+			continue;
+		if (unlikely(p == task->group_leader))
+			continue;
+
+		t = p;
+		do {
+			if (unlikely(t->mm == mm))
+				goto found;
+			if (likely(t->mm))
+				break;
+		} while_each_thread(p, t);
+	}
+	ret = true;
+found:
+	rcu_read_unlock();
+	up_write(&mm->mmap_sem);
+
+	return ret;
 }

