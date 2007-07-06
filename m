Return-Path: <linux-kernel-owner+w=401wt.eu-S1763038AbXGFIFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763038AbXGFIFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 04:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbXGFIFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 04:05:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57184 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756498AbXGFIFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 04:05:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH -mm] Freezer: Handle uninterruptible tasks
Date: Fri, 6 Jul 2007 10:12:47 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oliver Neukum <oliver@neukum.org>, Pavel Machek <pavel@ucw.cz>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707061012.48998.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The main limitation of the freezer is that it cannot handle uninterruptible
tasks.  Namely, if there are uninterruptible tasks in the system, the freezer
returns an error, which makes it impossible to suspend the system.

This mechanism is used to prevent the situations in which the suspend process
can deadlock with a task holding a lock needed by it from happening.  However,
AFAICS, the probability of that happening is very small and if the freezer is
removed from the suspend code patch, then the suspend process will be exposed to
deadlocking in this manner anyway.

Unfortunately, this mechanism also leads to severe limitations, such as that it
makes the freezer unable to handle systems using FUSE in a reliable way.

This patch makes the freezer skip uninterruptible user space tasks (ie. such
that have an mm of their own) when counting the tasks to be frozen.  As a
result, these tasks have the TIF_FREEZE and TIF_SIGPENDING flags set, but the
freezer doesn't wait for them to enter the refrigerator.  Nevertheless, they
will enter the refrigerator as soon as they change their state.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/freezer.h |   44 --------------------------------------------
 include/linux/sched.h   |    1 -
 kernel/fork.c           |    2 --
 kernel/power/process.c  |   18 +++++++++++++++++-
 4 files changed, 17 insertions(+), 48 deletions(-)

Index: linux-2.6.22-rc6-mm1/kernel/power/process.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/kernel/power/process.c
+++ linux-2.6.22-rc6-mm1/kernel/power/process.c
@@ -105,6 +105,16 @@ static void cancel_freezing(struct task_
 	}
 }
 
+static int has_mm(struct task_struct *p)
+{
+	return (p->mm && !(p->flags & PF_BORROWED_MM));
+}
+
+static int freezer_should_skip(struct task_struct *p)
+{
+	return (has_mm(p) && (p->state | TASK_UNINTERRUPTIBLE));
+}
+
 static int try_to_freeze_tasks(int freeze_user_space)
 {
 	struct task_struct *g, *p;
@@ -135,7 +145,7 @@ static int try_to_freeze_tasks(int freez
 				 * occuring.
 				 */
 				task_lock(p);
-				if (!p->mm || (p->flags & PF_BORROWED_MM)) {
+				if (!has_mm(p)) {
 					task_unlock(p);
 					continue;
 				}
@@ -144,8 +154,14 @@ static int try_to_freeze_tasks(int freez
 			} else {
 				freeze_task(p);
 			}
+			/*
+			 * task_lock() is necessary to prevent races with
+			 * use_mm()/unuse_mm() from occuring.
+			 */
+			task_lock(p);
 			if (!freezer_should_skip(p))
 				todo++;
+			task_unlock(p);
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 		yield();			/* Yield is okay here */
Index: linux-2.6.22-rc6-mm1/include/linux/freezer.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/linux/freezer.h
+++ linux-2.6.22-rc6-mm1/include/linux/freezer.h
@@ -75,50 +75,6 @@ static inline int try_to_freeze(void)
 }
 
 /*
- * The PF_FREEZER_SKIP flag should be set by a vfork parent right before it
- * calls wait_for_completion(&vfork) and reset right after it returns from this
- * function.  Next, the parent should call try_to_freeze() to freeze itself
- * appropriately in case the child has exited before the freezing of tasks is
- * complete.  However, we don't want kernel threads to be frozen in unexpected
- * places, so we allow them to block freeze_processes() instead or to set
- * PF_NOFREEZE if needed and PF_FREEZER_SKIP is only set for userland vfork
- * parents.  Fortunately, in the ____call_usermodehelper() case the parent won't
- * really block freeze_processes(), since ____call_usermodehelper() (the child)
- * does a little before exec/exit and it can't be frozen before waking up the
- * parent.
- */
-
-/*
- * If the current task is a user space one, tell the freezer not to count it as
- * freezable.
- */
-static inline void freezer_do_not_count(void)
-{
-	if (current->mm)
-		current->flags |= PF_FREEZER_SKIP;
-}
-
-/*
- * If the current task is a user space one, tell the freezer to count it as
- * freezable again and try to freeze it.
- */
-static inline void freezer_count(void)
-{
-	if (current->mm) {
-		current->flags &= ~PF_FREEZER_SKIP;
-		try_to_freeze();
-	}
-}
-
-/*
- * Check if the task should be counted as freezeable by the freezer
- */
-static inline int freezer_should_skip(struct task_struct *p)
-{
-	return !!(p->flags & PF_FREEZER_SKIP);
-}
-
-/*
  * Tell the freezer that the current task should be frozen by it
  */
 static inline void set_freezable(void)
Index: linux-2.6.22-rc6-mm1/include/linux/sched.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/linux/sched.h
+++ linux-2.6.22-rc6-mm1/include/linux/sched.h
@@ -1275,7 +1275,6 @@ static inline void put_task_struct(struc
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
-#define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
 
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
Index: linux-2.6.22-rc6-mm1/kernel/fork.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/kernel/fork.c
+++ linux-2.6.22-rc6-mm1/kernel/fork.c
@@ -1424,9 +1424,7 @@ long do_fork(unsigned long clone_flags,
 		}
 
 		if (clone_flags & CLONE_VFORK) {
-			freezer_do_not_count();
 			wait_for_completion(&vfork);
-			freezer_count();
 			if (unlikely (current->ptrace & PT_TRACE_VFORK_DONE)) {
 				current->ptrace_message = nr;
 				ptrace_notify ((PTRACE_EVENT_VFORK_DONE << 8) | SIGTRAP);
