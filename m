Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbXB0VTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbXB0VTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 16:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbXB0VTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 16:19:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38249 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbXB0VTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 16:19:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Date: Tue, 27 Feb 2007 22:21:59 +0100
User-Agent: KMail/1.9.5
Cc: Aneesh Kumar <aneesh.kumar@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <200702261139.59130.rjw@sisk.pl> <cc723f590702262033k4fa6cbe0n8e327b8339c7a0e4@mail.gmail.com> <20070227083741.GA85@tv-sign.ru>
In-Reply-To: <20070227083741.GA85@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702272222.01289.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 27 February 2007 09:37, Oleg Nesterov wrote:
> On 02/27, Aneesh Kumar wrote:
> >
> > >+static inline void freezer_do_not_count(void)
> > >+{
> > >+       current->flags |= PF_FREEZER_SKIP;
> > >+}
> > >+
> > >+/*
> > >+ * Tell the freezer to count this task as freezeable again and if it's a 
> > >user
> > >+ * space one, try to freeze it
> > >+ */
> > >+static inline void freezer_count(void)
> > >+{
> > >+       current->flags &= ~PF_FREEZER_SKIP;
> > >+       if (current->mm)
> > >+               try_to_freeze();
> > >+}
> > >+
> > 
> > 
> > This means that we are not going to wait for the kernel thread
> > (Parent) to freeze. I guess what vatsa suggested in previous mail is
> > better.
> 
> Not only better, but correct. This is very simple: if we set PF_FREEZER_SKIP,
> we must call try_to_freeze(), otherwise we confuse the freezer.

Okay, patch updated, appended.

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
---
 include/linux/freezer.h |   34 ++++++++++++++++++++++++++++++++--
 include/linux/sched.h   |    1 +
 kernel/fork.c           |    3 +++
 kernel/power/process.c  |   27 ++++++++-------------------
 4 files changed, 44 insertions(+), 21 deletions(-)

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
@@ -75,7 +75,35 @@ static inline int try_to_freeze(void)
 		return 0;
 }
 
-extern void thaw_some_processes(int all);
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
@@ -90,5 +118,7 @@ static inline void thaw_processes(void) 
 
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
