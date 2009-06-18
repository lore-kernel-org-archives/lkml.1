Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbZFRTHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbZFRTHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZFRTHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:07:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752318AbZFRTHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:07:37 -0400
Date: Thu, 18 Jun 2009 12:07:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, jmorris@namei.org, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rework/fix is_single_threaded()
Message-Id: <20090618120716.fd1e4d92.akpm@linux-foundation.org>
In-Reply-To: <20090416145444.GA12884@redhat.com>
References: <20090413214513.GA1119@redhat.com>
	<14878.1239876272@redhat.com>
	<20090416133658.GA6532@redhat.com>
	<20090416145444.GA12884@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009 16:54:44 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 04/16, Oleg Nesterov wrote:
> >
> > Suppose we have a process P which shares ->mm with "task" (the argument), so
> > we should return "false".
> >
> > P does clone(CLONE_VM) and exits. rcu_read_lock() can't guarantee we will
> > see the new task with the same ->mm. And without ->mmap_sem P can call
> > exit_mm() and set P->mm = NULL.
> >
> > Hmm. But we can just add a barrier?
> >
> > 	bool is_single_threaded(struct task_struct *task)
> > 	{
> > 		struct mm_struct *mm = task->mm;
> > 		struct task_struct *p, *t;
> > 		bool ret;
> >
> > 		if (atomic_read(&task->signal->live) != 1)
> > 			return false;
> >
> > 		if (atomic_read(&mm->mm_users) == 1)
> > 			return true;
> >
> > 		ret = false;
> > 		rcu_read_lock();
> > 		for_each_process(p) {
> > 			if (unlikely(p->flags & PF_KTHREAD))
> > 				continue;
> > 			if (unlikely(p == task->group_leader))
> > 				continue;
> >
> > 			t = p;
> > 			do {
> > 				if (unlikely(t->mm == mm))
> > 					goto found;
> > 				if (likely(t->mm))
> > 					break;
> >
> > 				/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
> > 				   t->mm == NULL. Perhaps it had the same ->mm ?
> > 				   If t has forked CLONE_VM task and called exit_mm(),
> > 				   make sure next_thread() or for_each_process()->next_task()
> > 				   will see it.
> > 				   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
> > 				*/
> > 				smp_rmb();
> 
> Sorry, forgot to mention...
> 
> But what if P does clone(CLONE_VM), exits, and for_each_process/while_each_thread
> doesn't see it? IOW, what if we already see the result of list_del_rcu() ?
> 
> I think, in that case we must also see the result of clone()->list_add_tail_rcu()
> which has a barrier, so we are safe.
> 
> Hmm. I feel this all has a simpler explanation, or I missed something...
> 

It appears that this patch is rather stuck.  Should I drop it?


From: Oleg Nesterov <oleg@redhat.com>

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
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/is_single_threaded.c |   62 +++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff -puN lib/is_single_threaded.c~rework-fix-is_single_threaded lib/is_single_threaded.c
--- a/lib/is_single_threaded.c~rework-fix-is_single_threaded
+++ a/lib/is_single_threaded.c
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
-
-	if (atomic_read(&p->signal->count) != 1)
-		goto no;
-
-	if (atomic_read(&p->mm->mm_users) != 1) {
-		read_lock(&tasklist_lock);
-		do_each_thread(g, t) {
-			if (t->mm == mm && t != p)
-				goto no_unlock;
-		} while_each_thread(g, t);
-		read_unlock(&tasklist_lock);
+	struct mm_struct *mm = task->mm;
+	struct task_struct *p, *t;
+	bool ret;
+
+	might_sleep();
+
+	if (atomic_read(&task->signal->live) != 1)
+		return false;
+
+	if (atomic_read(&mm->mm_users) == 1)
+		return true;
+
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
 	}
+	ret = true;
+found:
+	rcu_read_unlock();
+	up_write(&mm->mmap_sem);
 
-	return true;
-
-no_unlock:
-	read_unlock(&tasklist_lock);
-no:
-	return false;
+	return ret;
 }
_

