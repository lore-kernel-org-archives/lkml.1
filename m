Return-Path: <linux-kernel-owner+w=401wt.eu-S1761792AbXEKJJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761792AbXEKJJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 05:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758957AbXEKJHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 05:07:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58483 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110AbXEKJGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 05:06:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/7] Freezer: Fix vfork problem
Date: Fri, 11 May 2007 00:38:14 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200705110035.32229.rjw@sisk.pl>
In-Reply-To: <200705110035.32229.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705110038.15318.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Currently try_to_freeze_tasks() has to wait until all of the vforked processes
exit and for this reason every user can make it fail.  To fix this problem we
can introduce the additional process flag PF_FREEZER_SKIP to be used by tasks
that do not want to be counted as freezable by the freezer and want to have
TIF_FREEZE set nevertheless.  Then, this flag can be set by tasks using
sys_vfork() before they call wait_for_completion(&vfork) and cleared after
they have woken up.  After clearing it, the tasks should call try_to_freeze()
as soon as possible.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/freezer.h |   48 ++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/sched.h   |    1 +
 kernel/fork.c           |    3 +++
 kernel/power/process.c  |   27 ++++++++-------------------
 4 files changed, 58 insertions(+), 21 deletions(-)

Index: linux-2.6/include/linux/freezer.h
===================================================================
--- linux-2.6.orig/include/linux/freezer.h	2007-05-10 21:44:31.000000000 +0200
+++ linux-2.6/include/linux/freezer.h	2007-05-10 21:44:36.000000000 +0200
@@ -81,7 +81,49 @@ static inline int try_to_freeze(void)
 		return 0;
 }
 
-extern void thaw_some_processes(int all);
+/*
+ * The PF_FREEZER_SKIP flag should be set by a vfork parent right before it
+ * calls wait_for_completion(&vfork) and reset right after it returns from this
+ * function.  Next, the parent should call try_to_freeze() to freeze itself
+ * appropriately in case the child has exited before the freezing of tasks is
+ * complete.  However, we don't want kernel threads to be frozen in unexpected
+ * places, so we allow them to block freeze_processes() instead or to set
+ * PF_NOFREEZE if needed and PF_FREEZER_SKIP is only set for userland vfork
+ * parents.  Fortunately, in the ____call_usermodehelper() case the parent won't
+ * really block freeze_processes(), since ____call_usermodehelper() (the child)
+ * does a little before exec/exit and it can't be frozen before waking up the
+ * parent.
+ */
+
+/*
+ * If the current task is a user space one, tell the freezer not to count it as
+ * freezable.
+ */
+static inline void freezer_do_not_count(void)
+{
+	if (current->mm)
+		current->flags |= PF_FREEZER_SKIP;
+}
+
+/*
+ * If the current task is a user space one, tell the freezer to count it as
+ * freezable again and try to freeze it.
+ */
+static inline void freezer_count(void)
+{
+	if (current->mm) {
+		current->flags &= ~PF_FREEZER_SKIP;
+		try_to_freeze();
+	}
+}
+
+/*
+ * Check if the task should be counted as freezeable by the freezer
+ */
+static inline int freezer_should_skip(struct task_struct *p)
+{
+	return !!(p->flags & PF_FREEZER_SKIP);
+}
 
 #else
 static inline int frozen(struct task_struct *p) { return 0; }
@@ -96,5 +138,7 @@ static inline void thaw_processes(void) 
 
 static inline int try_to_freeze(void) { return 0; }
 
-
+static inline void freezer_do_not_count(void) {}
+static inline void freezer_count(void) {}
+static inline int freezer_should_skip(struct task_struct *p) { return 0; }
 #endif
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h	2007-05-10 21:44:23.000000000 +0200
+++ linux-2.6/include/linux/sched.h	2007-05-10 21:44:36.000000000 +0200
@@ -1176,6 +1176,7 @@ static inline void put_task_struct(struc
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
+#define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
 
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c	2007-05-10 21:44:23.000000000 +0200
+++ linux-2.6/kernel/fork.c	2007-05-10 21:44:36.000000000 +0200
@@ -45,6 +45,7 @@
 #include <linux/acct.h>
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
+#include <linux/freezer.h>
 #include <linux/delayacct.h>
 #include <linux/taskstats_kern.h>
 #include <linux/random.h>
@@ -1403,7 +1404,9 @@ long do_fork(unsigned long clone_flags,
 		}
 
 		if (clone_flags & CLONE_VFORK) {
+			freezer_do_not_count();
 			wait_for_completion(&vfork);
+			freezer_count();
 			if (unlikely (current->ptrace & PT_TRACE_VFORK_DONE)) {
 				current->ptrace_message = nr;
 				ptrace_notify ((PTRACE_EVENT_VFORK_DONE << 8) | SIGTRAP);
Index: linux-2.6/kernel/power/process.c
===================================================================
--- linux-2.6.orig/kernel/power/process.c	2007-05-10 21:44:31.000000000 +0200
+++ linux-2.6/kernel/power/process.c	2007-05-10 21:44:36.000000000 +0200
@@ -126,22 +126,12 @@ static unsigned int try_to_freeze_tasks(
 				cancel_freezing(p);
 				continue;
 			}
-			if (is_user_space(p)) {
-				if (!freeze_user_space)
-					continue;
-
-				/* Freeze the task unless there is a vfork
-				 * completion pending
-				 */
-				if (!p->vfork_done)
-					freeze_process(p);
-			} else {
-				if (freeze_user_space)
-					continue;
+			if (is_user_space(p) == !freeze_user_space)
+				continue;
 
-				freeze_process(p);
-			}
-			todo++;
+			freeze_process(p);
+			if (!freezer_should_skip(p))
+				todo++;
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 		yield();			/* Yield is okay here */
@@ -167,7 +157,8 @@ static unsigned int try_to_freeze_tasks(
 				continue;
 
 			task_lock(p);
-			if (freezeable(p) && !frozen(p))
+			if (freezeable(p) && !frozen(p) &&
+			    !freezer_should_skip(p))
 				printk(KERN_ERR " %s\n", p->comm);
 
 			cancel_freezing(p);
@@ -216,9 +207,7 @@ static void thaw_tasks(int thaw_user_spa
 		if (is_user_space(p) == !thaw_user_space)
 			continue;
 
-		if (!thaw_process(p))
-			printk(KERN_WARNING " Strange, %s not stopped\n",
-				p->comm );
+		thaw_process(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 }

