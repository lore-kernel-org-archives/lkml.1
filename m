Return-Path: <linux-kernel-owner+w=401wt.eu-S1030198AbXBZKvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030198AbXBZKvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 05:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030199AbXBZKvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 05:51:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59251 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030198AbXBZKvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 05:51:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Date: Mon, 26 Feb 2007 11:47:11 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <200702261139.59130.rjw@sisk.pl>
In-Reply-To: <200702261139.59130.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702261147.12274.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The changelog explains it pretty well, I hope, but I have one more comment to
start with.  Namely, in this version of the patch I've added

+	if (is_user_space(current))
+		try_to_freeze();

to freezer_count() instead of just try_to_freeze().  This way kernel threads
can avoid being frozen where they don't want to.

Well, vatsa seems to think that calling try_to_freeze() in freezer_count() is
not a good idea anyway, but I don't see anything wrong in freezing the user
space processes here.

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Currently try_to_freeze_tasks() has to wait until all of the vforked processes
exit and for this reason every user can make it fail.  To fix this problem
we can introduce the additional process flag PF_FREEZER_SKIP to be used by tasks
that do not want to be counted as freezable by the freezer and want to have
TIF_FREEZE set nevertheless.  Then, this flag can be set by tasks using
sys_vfork() before they call wait_for_completion() and cleared after they have
woken up.  After clearing it, kernel threads should call try_to_freeze() in an
appropriate place.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/freezer.h |   41 +++++++++++++++++++++++++++++++++++++++--
 include/linux/sched.h   |    1 +
 kernel/fork.c           |    3 +++
 kernel/power/process.c  |   37 ++++++++-----------------------------
 4 files changed, 51 insertions(+), 31 deletions(-)

Index: linux-2.6.20-mm2/include/linux/sched.h
===================================================================
--- linux-2.6.20-mm2.orig/include/linux/sched.h	2007-02-26 08:40:22.000000000 +0100
+++ linux-2.6.20-mm2/include/linux/sched.h	2007-02-26 08:40:56.000000000 +0100
@@ -1189,6 +1189,7 @@ static inline void put_task_struct(struc
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
+#define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
 
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
Index: linux-2.6.20-mm2/include/linux/freezer.h
===================================================================
--- linux-2.6.20-mm2.orig/include/linux/freezer.h	2007-02-26 08:40:22.000000000 +0100
+++ linux-2.6.20-mm2/include/linux/freezer.h	2007-02-26 08:41:49.000000000 +0100
@@ -75,7 +75,42 @@ static inline int try_to_freeze(void)
 		return 0;
 }
 
-extern void thaw_some_processes(int all);
+static inline int is_user_space(struct task_struct *p)
+{
+	int ret;
+
+	task_lock(p);
+	ret = p->mm && !(p->flags & PF_BORROWED_MM);
+	task_unlock(p);
+	return ret;
+}
+
+/*
+ * Tell the freezer not to count current task as freezeable
+ */
+static inline void freezer_do_not_count(void)
+{
+	current->flags |= PF_FREEZER_SKIP;
+}
+
+/*
+ * Try to freeze the current task and tell the freezer to count it as freezeable
+ * again
+ */
+static inline void freezer_count(void)
+{
+	current->flags &= ~PF_FREEZER_SKIP;
+	if (is_user_space(current))
+		try_to_freeze();
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
@@ -90,5 +125,7 @@ static inline void thaw_processes(void) 
 
 static inline int try_to_freeze(void) { return 0; }
 
-
+static inline void freezer_do_not_count(void) {}
+static inline void freezer_count(void) {}
+static inline int freezer_should_skip(struct task_struct *p) { return 0; }
 #endif
Index: linux-2.6.20-mm2/kernel/fork.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/fork.c	2007-02-26 08:40:22.000000000 +0100
+++ linux-2.6.20-mm2/kernel/fork.c	2007-02-26 08:40:56.000000000 +0100
@@ -50,6 +50,7 @@
 #include <linux/taskstats_kern.h>
 #include <linux/random.h>
 #include <linux/ptrace.h>
+#include <linux/freezer.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -1393,7 +1394,9 @@ long do_fork(unsigned long clone_flags,
 		tracehook_report_clone_complete(clone_flags, nr, p);
 
 		if (clone_flags & CLONE_VFORK) {
+			freezer_do_not_count();
 			wait_for_completion(&vfork);
+			freezer_count();
 			tracehook_report_vfork_done(p, nr);
 		}
 	} else {
Index: linux-2.6.20-mm2/kernel/power/process.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/power/process.c	2007-02-26 08:40:22.000000000 +0100
+++ linux-2.6.20-mm2/kernel/power/process.c	2007-02-26 08:41:18.000000000 +0100
@@ -96,16 +96,6 @@ static void cancel_freezing(struct task_
 	}
 }
 
-static inline int is_user_space(struct task_struct *p)
-{
-	int ret;
-
-	task_lock(p);
-	ret = p->mm && !(p->flags & PF_BORROWED_MM);
-	task_unlock(p);
-	return ret;
-}
-
 static unsigned int try_to_freeze_tasks(int freeze_user_space)
 {
 	struct task_struct *g, *p;
@@ -127,22 +117,12 @@ static unsigned int try_to_freeze_tasks(
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
@@ -168,7 +148,8 @@ static unsigned int try_to_freeze_tasks(
 				continue;
 
 			task_lock(p);
-			if (freezeable(p) && !frozen(p))
+			if (freezeable(p) && !frozen(p) &&
+			    !freezer_should_skip(p))
 				printk(KERN_ERR " %s\n", p->comm);
 
 			cancel_freezing(p);
@@ -217,9 +198,7 @@ static void thaw_tasks(int thaw_user_spa
 		if (is_user_space(p) == !thaw_user_space)
 			continue;
 
-		if (!thaw_process(p))
-			printk(KERN_WARNING " Strange, %s not stopped\n",
-				p->comm );
+		thaw_process(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 }

