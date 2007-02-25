Return-Path: <linux-kernel-owner+w=401wt.eu-S964916AbXBYNGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964916AbXBYNGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 08:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964936AbXBYNGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 08:06:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55393 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964916AbXBYNGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 08:06:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 4/7] Freezer: Fix vfork problem
Date: Sun, 25 Feb 2007 13:59:52 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
       ego@in.ibm.com, akpm@osdl.org, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       Aneesh Kumar <aneesh.kumar@gmail.com>
References: <200702231116.23607.rjw@sisk.pl> <20070225104612.GM2045@elf.ucw.cz> <200702251145.39595.rjw@sisk.pl>
In-Reply-To: <200702251145.39595.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702251359.53411.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 February 2007 11:45, Rafael J. Wysocki wrote:
> Hi,
> 
> On Sunday, 25 February 2007 11:46, Pavel Machek wrote:
> > Hi!
> > 
> > > Currently try_to_freeze_tasks() has to wait until all of the vforked processes
> > > exit and for this reason every user can make it fail.  To fix this problem
> > > we can introduce the additional process flag PF_FREEZER_SKIP to be used by tasks
> > > that do not want to be counted as freezable by the freezer and want to have
> > > TIF_FREEZE set nevertheless.  Then, this flag can be set by tasks using
> > > sys_vfork() before they call wait_for_completion() and cleared after they have
> > > woken up and called try_to_freeze().  In case such a task freezes with
> > > PF_FREEZER_SKIP set, refrigerator() clears this flag for the current task before
> > > calling frozen_process(current) to avoid having both PF_FREEZER_SKIP and
> > > PF_FROZEN set at the same time.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > > @@ -1393,7 +1394,9 @@ long do_fork(unsigned long clone_flags,
> > >  		tracehook_report_clone_complete(clone_flags, nr, p);
> > >  
> > >  		if (clone_flags & CLONE_VFORK) {
> > > +			freezer_do_not_count();
> > >  			wait_for_completion(&vfork);
> > > +			freezer_count();
> > >  			tracehook_report_vfork_done(p, nr);
> > >  		}
> > >  	} else {
> > 
> > All the infrastructure for this...Would it be easier to introduce
> > 
> > void fastcall __sched wait_for_completion_freezeable(struct completion *x)
> > {
> >         might_sleep();
> > 
> >         spin_lock_irq(&x->wait.lock);
> >         if (!x->done) {
> >                 DECLARE_WAITQUEUE(wait, current);
> > 
> >                 wait.flags |= WQ_FLAG_EXCLUSIVE;
> >                 __add_wait_queue_tail(&x->wait, &wait);
> >                 do {
> >                         __set_current_state(TASK_UNINTERRUPTIBLE);
> >                         spin_unlock_irq(&x->wait.lock);
> >                         schedule();
> > try_to_freeze(); /* HERE */
> >                         spin_lock_irq(&x->wait.lock);
> >                 } while (!x->done);
> >                 __remove_wait_queue(&x->wait, &wait);
> >         }
> >         x->done--;
> >         spin_unlock_irq(&x->wait.lock);
> > }
> > 
> > ...and be done with that, in a very obvious way? (Ok, you probably do
> > not want to duplicate the function, but you get the idea).
> 
> Yes, I though about that too, but I was thinking of sticking try_to_freeze()
> in wait wait_for_completion() itself, which was obviously wrong.
> 
> Still, the above might work.  I'll try to prepare a patch.

No, it won't work, because we have to tell the freezer not to count the
vfork parent as a freezable task.  For this reason the additional process
flag is required and in that case try_to_freeze() has to be called after
we clear the flag.

Appended is the latest version of the patch (Oleg thinks it's correct).

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
woken up.  After clearing it, they have to call try_to_freeze().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/freezer.h |   30 ++++++++++++++++++++++++++++--
 include/linux/sched.h   |    1 +
 kernel/fork.c           |    3 +++
 kernel/power/process.c  |   27 ++++++++-------------------
 4 files changed, 40 insertions(+), 21 deletions(-)

Index: linux-2.6.20-mm2/include/linux/sched.h
===================================================================
--- linux-2.6.20-mm2.orig/include/linux/sched.h	2007-02-22 23:43:51.000000000 +0100
+++ linux-2.6.20-mm2/include/linux/sched.h	2007-02-22 23:44:04.000000000 +0100
@@ -1189,6 +1189,7 @@ static inline void put_task_struct(struc
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
+#define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
 
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
Index: linux-2.6.20-mm2/include/linux/freezer.h
===================================================================
--- linux-2.6.20-mm2.orig/include/linux/freezer.h	2007-02-22 23:44:04.000000000 +0100
+++ linux-2.6.20-mm2/include/linux/freezer.h	2007-02-23 22:32:22.000000000 +0100
@@ -75,7 +75,31 @@ static inline int try_to_freeze(void)
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
+ * Try to freeze the current task and tell the freezer to count it as freezeable
+ * again
+ */
+static inline void freezer_count(void)
+{
+	current->flags &= ~PF_FREEZER_SKIP;
+	try_to_freeze();
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
@@ -90,5 +114,7 @@ static inline void thaw_processes(void) 
 
 static inline int try_to_freeze(void) { return 0; }
 
-
+static inline void freezer_do_not_count(void) {}
+static inline void freezer_count(void) {}
+static inline int freezer_should_skip(struct task_struct *p) { return 0; }
 #endif
Index: linux-2.6.20-mm2/kernel/fork.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/fork.c	2007-02-22 23:43:51.000000000 +0100
+++ linux-2.6.20-mm2/kernel/fork.c	2007-02-22 23:44:04.000000000 +0100
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
--- linux-2.6.20-mm2.orig/kernel/power/process.c	2007-02-22 23:44:04.000000000 +0100
+++ linux-2.6.20-mm2/kernel/power/process.c	2007-02-23 22:33:11.000000000 +0100
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
