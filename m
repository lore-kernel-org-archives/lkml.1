Return-Path: <linux-kernel-owner+w=401wt.eu-S1751435AbXB0A32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbXB0A32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbXB0A32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:29:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33808 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbXB0A31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:29:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Date: Tue, 27 Feb 2007 01:31:21 +0100
User-Agent: KMail/1.9.5
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Pavel Machek <pavel@ucw.cz>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <200702261139.59130.rjw@sisk.pl> <200702261928.19274.rjw@sisk.pl> <20070226212554.GA93@tv-sign.ru>
In-Reply-To: <20070226212554.GA93@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702270131.25656.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 26 February 2007 22:25, Oleg Nesterov wrote:
> On 02/26, Rafael J. Wysocki wrote:
> >
> > On Monday, 26 February 2007 17:11, Oleg Nesterov wrote:
> > > On 02/26, Srivatsa Vaddagiri wrote:
> > > >
> > > > On Mon, Feb 26, 2007 at 03:00:43PM +0300, Oleg Nesterov wrote:
> > > > > In that case we should also modify ____call_usermodehelper(), otherwise we have
> > > > > the same "deadlock" if it is frozen. But this is not so easy to do as I thought
> > > > > before.
> > > > 
> > > > Before ____call_usermodehelper can freeze, it should have entered userspace 
> > > > right? By that time, its vfork parent should have definitely woken up,
> > > > which should avoid the deadlock you point out?
> > > 
> > > Ah, yes, thanks for correcting me.
> > > 
> > > We are doing flush_old_exec() a way before entering userspace of course.
> > 
> > Well, does it mean the patch is acceptable or should I modify it somehow?
> 
> Oh, don't ask me, I don't have a time to study these patches currently :)
> 
> _Perhaps_ we can do something better than add explicit checks in freezer_...count,
> but I can't suggest anything. Btw, we don't need task_lock() to test current->mm,
> and I believe we don't need to check PF_BORROWED_MM there.

OK, I have updated the patch accordingly (appended).

> "[PATCH 2/3] Freezer: Take kernel_execve into consideration" looks a bit incomplete
> to me... I agree, this is a good change for now. But, assuming that we can spawn
> an "arbitrary" user-space process from kernel space, we may freeze some kernel
> thread which is needed for that user-space task to proceed and notice a signal.

Well, yes, at least theoretically.

> I am starting to suspect that call_usermodehelper() needs a special attention
> from freezer, but again, I can't suggest anything, at least right now.
> 
> "[PATCH 3/3] Freezer: Prevent ___call_usermodehelper from missing freezing requests"
> looks unneeded to me, we should imho drop flush_signals() instead. At least, please
> don't call do_not_freeze() under sighand->siglock. This looks as if we have a subtle
> reason for this lock, but we don't ? Oh, wait ...  ____call_usermodehelper() does
> recalc_sigpending() after flush_signals()! This means we can't lost a "fake" signal
> from freezer, so we don't need this patch. Agreed?

Yup.  I'm dropping this one.

> Apart from "[PATCH 3/3]", I have nothing against these patches, they fix real problems.

Thanks for your comments.

Greetings,
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
 include/linux/freezer.h |   31 +++++++++++++++++++++++++++++--
 include/linux/sched.h   |    1 +
 kernel/fork.c           |    3 +++
 kernel/power/process.c  |   27 ++++++++-------------------
 4 files changed, 41 insertions(+), 21 deletions(-)

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
+++ linux-2.6.20-mm2/include/linux/freezer.h	2007-02-27 00:51:44.000000000 +0100
@@ -75,7 +75,32 @@ static inline int try_to_freeze(void)
 		return 0;
 }
 
-extern void thaw_some_processes(int all);
+/*
+ * Tell the freezer not to count current task as freezeable
+ */
+static inline void freezer_do_not_count(void)
+{
+	current->flags |= PF_FREEZER_SKIP;
+}
+
+/*
+ * Tell the freezer to count this task as freezeable again and if it's a user
+ * space one, try to freeze it
+ */
+static inline void freezer_count(void)
+{
+	current->flags &= ~PF_FREEZER_SKIP;
+	if (current->mm)
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
@@ -90,5 +115,7 @@ static inline void thaw_processes(void) 
 
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
+++ linux-2.6.20-mm2/kernel/power/process.c	2007-02-27 00:47:49.000000000 +0100
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
