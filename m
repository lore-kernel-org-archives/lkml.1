Return-Path: <linux-kernel-owner+w=401wt.eu-S1751068AbXB1Tfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068AbXB1Tfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbXB1Tfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:35:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44128 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbXB1Tfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:35:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Date: Wed, 28 Feb 2007 20:36:34 +0100
User-Agent: KMail/1.9.5
Cc: vatsa@in.ibm.com, Aneesh Kumar <aneesh.kumar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <200702261139.59130.rjw@sisk.pl> <200702281157.28381.rjw@sisk.pl> <20070228110048.GA263@tv-sign.ru>
In-Reply-To: <20070228110048.GA263@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702282036.36875.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 February 2007 12:00, Oleg Nesterov wrote:
> On 02/28, Rafael J. Wysocki wrote:
> >
> > On Wednesday, 28 February 2007 02:23, Srivatsa Vaddagiri wrote:
> > > On Wed, Feb 28, 2007 at 12:53:14AM +0300, Oleg Nesterov wrote:
> > > > I think it is good. Srivatsa?
> > > 
> > > Maybe additional comments on why we don't skip vfork kernel tasks may be good. 
> > 
> > Which is because we don't want the kernel threads to be frozen in unexpected
> > places, so we allow them to block freeze_processes() instead or to set
> > PF_NOFREEZE?
> 
> ... and because in fact it won't block freeze_processes(), ____call_usermodehelper
> (the child) does a minimum before exec/exit, and it can't be frozen until it wakes
> up the parent.

Okay, I have added a comment to freezer.h.  Please have a look.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Currently try_to_freeze_tasks() has to wait until all of the vforked processes
exit and for this reason every user can make it fail.  To fix this problem
we can introduce the additional process flag PF_FREEZER_SKIP to be used by tasks
that do not want to be counted as freezable by the freezer and want to have
TIF_FREEZE set nevertheless.  Then, this flag can be set by tasks using
sys_vfork() before they call wait_for_completion() and cleared after they have
woken up.  After clearing it, the tasks should call try_to_freeze() as soon as
possible.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
 include/linux/freezer.h |   48 ++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/sched.h   |    1 +
 kernel/fork.c           |    3 +++
 kernel/power/process.c  |   27 ++++++++-------------------
 4 files changed, 58 insertions(+), 21 deletions(-)

Index: linux-2.6.20-mm2/include/linux/sched.h
===================================================================
--- linux-2.6.20-mm2.orig/include/linux/sched.h
+++ linux-2.6.20-mm2/include/linux/sched.h
@@ -1189,6 +1189,7 @@ static inline void put_task_struct(struc
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
+#define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
 
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
Index: linux-2.6.20-mm2/include/linux/freezer.h
===================================================================
--- linux-2.6.20-mm2.orig/include/linux/freezer.h
+++ linux-2.6.20-mm2/include/linux/freezer.h
@@ -75,7 +75,49 @@ static inline int try_to_freeze(void)
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
@@ -90,5 +132,7 @@ static inline void thaw_processes(void) 
 
 static inline int try_to_freeze(void) { return 0; }
 
-
+static inline void freezer_do_not_count(void) {}
+static inline void freezer_count(void) {}
+static inline int freezer_should_skip(struct task_struct *p) { return 0; }
 #endif
Index: linux-2.6.20-mm2/kernel/fork.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/fork.c
+++ linux-2.6.20-mm2/kernel/fork.c
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
--- linux-2.6.20-mm2.orig/kernel/power/process.c
+++ linux-2.6.20-mm2/kernel/power/process.c
@@ -127,22 +127,12 @@ static unsigned int try_to_freeze_tasks(
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
@@ -168,7 +158,8 @@ static unsigned int try_to_freeze_tasks(
 				continue;
 
 			task_lock(p);
-			if (freezeable(p) && !frozen(p))
+			if (freezeable(p) && !frozen(p) &&
+			    !freezer_should_skip(p))
 				printk(KERN_ERR " %s\n", p->comm);
 
 			cancel_freezing(p);
@@ -217,9 +208,7 @@ static void thaw_tasks(int thaw_user_spa
 		if (is_user_space(p) == !thaw_user_space)
 			continue;
 
-		if (!thaw_process(p))
-			printk(KERN_WARNING " Strange, %s not stopped\n",
-				p->comm );
+		thaw_process(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 }
