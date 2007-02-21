Return-Path: <linux-kernel-owner+w=401wt.eu-S1423246AbXBUXQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423246AbXBUXQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423248AbXBUXQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:16:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40564 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423246AbXBUXQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:16:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: paulmck@linux.vnet.ibm.com
Subject: Re: freezer problems
Date: Thu, 22 Feb 2007 00:10:52 +0100
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, ego@in.ibm.com, akpm@osdl.org,
       paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <20070221200314.GA91@tv-sign.ru> <20070221210606.GH7063@linux.vnet.ibm.com>
In-Reply-To: <20070221210606.GH7063@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702220010.54126.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 21 February 2007 22:06, Paul E. McKenney wrote:
> On Wed, Feb 21, 2007 at 11:03:14PM +0300, Oleg Nesterov wrote:
> > On 02/21, Rafael J. Wysocki wrote:
> > >
> > > On Wednesday, 21 February 2007 19:14, Paul E. McKenney wrote:
> > > > On Tue, Feb 20, 2007 at 07:29:01PM +0100, Rafael J. Wysocki wrote:
> > > > > On Tuesday, 20 February 2007 01:32, Rafael J. Wysocki wrote:
> > > > > > On Tuesday, 20 February 2007 01:12, Oleg Nesterov wrote:
> > > > > > Hm.  In the case discussed above we have a task that's right before calling
> > > > > > frozen_process(), so we can't thaw it, because it's not frozen.  It will be
> > > > > > frozen just in a while, but try_to_freeze_tasks() and thaw_tasks() have no
> > > > > > way to check this.
> > > > > > 
> > > > > > I think to close this race the refrigerator should check TIF_FREEZE and set
> > > > > > PF_FROZEN _and_ reset TIF_FREEZE under a lock
> > 
> > I personally think this is good. Not only this allows us to close the race,
> > I think we can do more.
> > 
> > >                                                      that would also have to be
> > > > > > taken by try_to_freeze_tasks() in the beginning of the error path.  This will
> > > > > > ensure that all tasks either freeze themselves before the error path in
> > > > > > try_to_freeze_tasks() is executed, or remain unfrozen.
> > 
> > How about take this lock in thaw_tasks() instead/too ?
> > 
> > Currently we need a separate loop in thaw_tasks() to handle PF_FREEZER_SKIP. This
> > means that PF_FREEZER_SKIP is not so generic: thaw_tasks() can't tolerate if such
> > a task was woken in between. What if we change thaw_process() to clear TIF_FREEZE ?
> > 
> > Note also that we can use task_lock() instead of global refrigerator_lock. This
> > means that thaw_process() should take it too, probably this is slowdown, but I
> > think not too much because thaw_process() is going to write to p->flags anyway.
> > In this case thaw_process() works perfectly as cancel_freezing_and_thaw() and
> > can be used to fix exec/coredump in future.
> 
> This sounds much better than a a global lock to me!  ;-)

Okay, below is what I have right now (compilation tested on x86_64):

This patch fixes the vfork problem by adding the PF_FREEZER_SKIP flag that
can be used by tasks to tell the freezer not to count them as freezeable and
making the vfork parents set this flag before they call wait_for_completion().

Secondly, it fixes the race which happens it a task with TIF_FREEZE set is
preempted right before calling frozen_process() in refrigerator() and stays
unforzen until after thaw_tasks() runs and checks its status.  For this purpose
task_lock() is used.

 include/linux/freezer.h |   34 ++++++++++++++++++++++++++++++++--
 include/linux/sched.h   |    1 +
 kernel/fork.c           |    3 +++
 kernel/power/process.c  |   36 +++++++++++++++++++-----------------
 4 files changed, 55 insertions(+), 19 deletions(-)

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
@@ -40,11 +40,15 @@ static inline void do_not_freeze(struct 
  */
 static inline int thaw_process(struct task_struct *p)
 {
+	task_lock(p);
 	if (frozen(p)) {
 		p->flags &= ~PF_FROZEN;
+		task_unlock(p);
 		wake_up_process(p);
 		return 1;
 	}
+	clear_tsk_thread_flag(p, TIF_FREEZE);
+	task_unlock(p);
 	return 0;
 }
 
@@ -71,7 +75,31 @@ static inline int try_to_freeze(void)
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
@@ -86,5 +114,7 @@ static inline void thaw_processes(void) 
 
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
@@ -39,10 +39,18 @@ void refrigerator(void)
 	/* Hmm, should we be allowed to suspend when there are realtime
 	   processes around? */
 	long save;
+
+	task_lock(current);
+	if (freezing(current)) {
+		frozen_process(current);
+		task_unlock(current);
+	} else {
+		task_unlock(current);
+		return;
+	}
 	save = current->state;
 	pr_debug("%s entered refrigerator\n", current->comm);
 
-	frozen_process(current);
 	spin_lock_irq(&current->sighand->siglock);
 	recalc_sigpending(); /* We sent fake signal, clean it up */
 	spin_unlock_irq(&current->sighand->siglock);
@@ -79,12 +87,16 @@ static void cancel_freezing(struct task_
 {
 	unsigned long flags;
 
+	task_lock(p);
 	if (freezing(p)) {
 		pr_debug("  clean up: %s\n", p->comm);
 		do_not_freeze(p);
+		task_unlock(p);
 		spin_lock_irqsave(&p->sighand->siglock, flags);
 		recalc_sigpending_tsk(p);
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
+	} else {
+		task_unlock(p);
 	}
 }
 
@@ -119,22 +131,12 @@ static unsigned int try_to_freeze_tasks(
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
@@ -207,7 +209,7 @@ static void thaw_tasks(int thaw_user_spa
 		if (is_user_space(p) == !thaw_user_space)
 			continue;
 
-		if (!thaw_process(p))
+		if (!thaw_process(p) && !freezer_should_skip(p))
 			printk(KERN_WARNING " Strange, %s not stopped\n",
 				p->comm );
 	} while_each_thread(g, p);


