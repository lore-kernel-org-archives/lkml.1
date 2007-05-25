Return-Path: <linux-kernel-owner+w=401wt.eu-S1762751AbXEYMzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762751AbXEYMzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759337AbXEYMzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:55:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45965 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759020AbXEYMzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:55:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] Freezer: Avoid freezing kernel threads prematurely
Date: Fri, 25 May 2007 15:01:09 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251501.09941.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Kernel threads should not have TIF_FREEZE set when user space processes are
being frozen, since otherwise some of them might be frozen prematurely.
To prevent this from happening we can (1) make exit_mm() unset TIF_FREEZE
unconditionally just after clearing tsk->mm and (2) make try_to_freeze_tasks() 
check if p->mm is different from zero and PF_BORROWED_MM is unset in p->flags 
when user space processes are to be frozen.

Namely, when user space processes are being frozen, we only should set
TIF_FREEZE for tasks that have p->mm different from NULL and don't have
PF_BORROWED_MM set in p->flags.  For this reason task_lock() must be used to
prevent try_to_freeze_tasks() from racing with use_mm()/unuse_mm(), in which
p->mm and p->flags.PF_BORROWED_MM are changed under task_lock(p).  Also, we
need to prevent the following scenario from happening:

* daemonize() is called by a task spawned from a user space code path
* freezer checks if the task has p->mm set and the result is positive
* task enters exit_mm() and clears its TIF_FREEZE
* freezer sets TIF_FREEZE for the task
* task calls try_to_freeze() and goes to the refrigerator, which is wrong at
  that point

This requires us to acquire task_lock(p) before p->flags.PF_BORROWED_MM and
p->mm are examined and release it after TIF_FREEZE is set for p (or it turns
out that TIF_FREEZE should not be set).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/freezer.h |    9 +++---
 kernel/exit.c           |    3 ++
 kernel/power/process.c  |   64 ++++++++++++++++++++++++------------------------
 3 files changed, 41 insertions(+), 35 deletions(-)

Index: linux-2.6.22-rc2/include/linux/freezer.h
===================================================================
--- linux-2.6.22-rc2.orig/include/linux/freezer.h	2007-05-19 11:25:56.000000000 +0200
+++ linux-2.6.22-rc2/include/linux/freezer.h	2007-05-19 21:00:41.000000000 +0200
@@ -22,7 +22,7 @@ static inline int freezing(struct task_s
 /*
  * Request that a process be frozen
  */
-static inline void freeze(struct task_struct *p)
+static inline void set_freeze_flag(struct task_struct *p)
 {
 	set_tsk_thread_flag(p, TIF_FREEZE);
 }
@@ -30,7 +30,7 @@ static inline void freeze(struct task_st
 /*
  * Sometimes we may need to cancel the previous 'freeze' request
  */
-static inline void do_not_freeze(struct task_struct *p)
+static inline void clear_freeze_flag(struct task_struct *p)
 {
 	clear_tsk_thread_flag(p, TIF_FREEZE);
 }
@@ -53,7 +53,7 @@ static inline int thaw_process(struct ta
 		wake_up_process(p);
 		return 1;
 	}
-	clear_tsk_thread_flag(p, TIF_FREEZE);
+	clear_freeze_flag(p);
 	task_unlock(p);
 	return 0;
 }
@@ -118,7 +118,8 @@ static inline int freezer_should_skip(st
 #else
 static inline int frozen(struct task_struct *p) { return 0; }
 static inline int freezing(struct task_struct *p) { return 0; }
-static inline void freeze(struct task_struct *p) { BUG(); }
+static inline void set_freeze_flag(struct task_struct *p) {}
+static inline void clear_freeze_flag(struct task_struct *p) {}
 static inline int thaw_process(struct task_struct *p) { return 1; }
 
 static inline void refrigerator(void) {}
Index: linux-2.6.22-rc2/kernel/power/process.c
===================================================================
--- linux-2.6.22-rc2.orig/kernel/power/process.c	2007-05-19 11:25:56.000000000 +0200
+++ linux-2.6.22-rc2/kernel/power/process.c	2007-05-20 00:29:27.000000000 +0200
@@ -40,7 +40,7 @@ static inline void frozen_process(void)
 		current->flags |= PF_FROZEN;
 		wmb();
 	}
-	clear_tsk_thread_flag(current, TIF_FREEZE);
+	clear_freeze_flag(current);
 }
 
 /* Refrigerator is place where frozen processes are stored :-). */
@@ -75,17 +75,16 @@ void refrigerator(void)
 	current->state = save;
 }
 
-static inline void freeze_process(struct task_struct *p)
+static void freeze_task(struct task_struct *p)
 {
 	unsigned long flags;
 
 	if (!freezing(p)) {
 		rmb();
 		if (!frozen(p)) {
+			set_freeze_flag(p);
 			if (p->state == TASK_STOPPED)
 				force_sig_specific(SIGSTOP, p);
-
-			freeze(p);
 			spin_lock_irqsave(&p->sighand->siglock, flags);
 			signal_wake_up(p, p->state == TASK_STOPPED);
 			spin_unlock_irqrestore(&p->sighand->siglock, flags);
@@ -99,18 +98,13 @@ static void cancel_freezing(struct task_
 
 	if (freezing(p)) {
 		pr_debug("  clean up: %s\n", p->comm);
-		do_not_freeze(p);
+		clear_freeze_flag(p);
 		spin_lock_irqsave(&p->sighand->siglock, flags);
 		recalc_sigpending_tsk(p);
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
 	}
 }
 
-static inline int is_user_space(struct task_struct *p)
-{
-	return p->mm && !(p->flags & PF_BORROWED_MM);
-}
-
 static unsigned int try_to_freeze_tasks(int freeze_user_space)
 {
 	struct task_struct *g, *p;
@@ -122,20 +116,34 @@ static unsigned int try_to_freeze_tasks(
 		todo = 0;
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
-			if (!freezeable(p))
-				continue;
-
-			if (frozen(p))
+			if (frozen(p) || !freezeable(p))
 				continue;
 
-			if (p->state == TASK_TRACED && frozen(p->parent)) {
-				cancel_freezing(p);
-				continue;
+			if (freeze_user_space) {
+				if (p->state == TASK_TRACED &&
+				    frozen(p->parent)) {
+					cancel_freezing(p);
+					continue;
+				}
+				/*
+				 * Kernel threads should not have TIF_FREEZE set
+				 * at this point, so we must ensure that either
+				 * p->mm is not NULL *and* PF_BORROWED_MM is
+				 * unset, or TIF_FRREZE is left unset.
+				 * The task_lock() is necessary to prevent races
+				 * with exit_mm() or use_mm()/unuse_mm() from
+				 * occuring.
+				 */
+				task_lock(p);
+				if (!p->mm || (p->flags & PF_BORROWED_MM)) {
+					task_unlock(p);
+					continue;
+				}
+				freeze_task(p);
+				task_unlock(p);
+			} else {
+				freeze_task(p);
 			}
-			if (freeze_user_space && !is_user_space(p))
-				continue;
-
-			freeze_process(p);
 			if (!freezer_should_skip(p))
 				todo++;
 		} while_each_thread(g, p);
@@ -152,21 +160,15 @@ static unsigned int try_to_freeze_tasks(
 		 * but it cleans up leftover PF_FREEZE requests.
 		 */
 		printk("\n");
-		printk(KERN_ERR "Stopping %s timed out after %d seconds "
+		printk(KERN_ERR "Freezing of %s timed out after %d seconds "
 				"(%d tasks refusing to freeze):\n",
-				freeze_user_space ? "user space processes" :
-					"kernel threads",
+				freeze_user_space ? "user space " : "tasks ",
 				TIMEOUT / HZ, todo);
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
-			if (freeze_user_space && !is_user_space(p))
-				continue;
-
 			task_lock(p);
-			if (freezeable(p) && !frozen(p) &&
-			    !freezer_should_skip(p))
+			if (freezing(p) && !freezer_should_skip(p))
 				printk(KERN_ERR " %s\n", p->comm);
-
 			cancel_freezing(p);
 			task_unlock(p);
 		} while_each_thread(g, p);
@@ -210,7 +212,7 @@ static void thaw_tasks(int thaw_user_spa
 		if (!freezeable(p))
 			continue;
 
-		if (is_user_space(p) == !thaw_user_space)
+		if (!p->mm == thaw_user_space)
 			continue;
 
 		thaw_process(p);
Index: linux-2.6.22-rc2/kernel/exit.c
===================================================================
--- linux-2.6.22-rc2.orig/kernel/exit.c	2007-05-19 11:18:32.000000000 +0200
+++ linux-2.6.22-rc2/kernel/exit.c	2007-05-19 22:21:43.000000000 +0200
@@ -44,6 +44,7 @@
 #include <linux/resource.h>
 #include <linux/blkdev.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -589,6 +590,8 @@ static void exit_mm(struct task_struct *
 	tsk->mm = NULL;
 	up_read(&mm->mmap_sem);
 	enter_lazy_tlb(mm, current);
+	/* We don't want this task to be frozen prematurely */
+	clear_freeze_flag(tsk);
 	task_unlock(tsk);
 	mmput(mm);
 }
