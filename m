Return-Path: <linux-kernel-owner+w=401wt.eu-S1751219AbXBVRKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbXBVRKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 12:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbXBVRKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 12:10:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44993 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbXBVRKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 12:10:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: freezer problems
Date: Thu, 22 Feb 2007 18:03:37 +0100
User-Agent: KMail/1.9.5
Cc: paulmck@linux.vnet.ibm.com, ego@in.ibm.com, akpm@osdl.org,
       paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <200702220010.54126.rjw@sisk.pl> <20070222104747.GA505@tv-sign.ru>
In-Reply-To: <20070222104747.GA505@tv-sign.ru>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_tzc3Fksr1nxJ2E+"
Message-Id: <200702221803.41549.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_tzc3Fksr1nxJ2E+
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday, 22 February 2007 11:47, Oleg Nesterov wrote:
> On 02/22, Rafael J. Wysocki wrote:
> >
> > Okay, below is what I have right now (compilation tested on x86_64):
> > 
> > This patch fixes the vfork problem by adding the PF_FREEZER_SKIP flag that
> > can be used by tasks to tell the freezer not to count them as freezeable and
> > making the vfork parents set this flag before they call wait_for_completion().
> > 
> > Secondly, it fixes the race which happens it a task with TIF_FREEZE set is
> > preempted right before calling frozen_process() in refrigerator() and stays
> > unforzen until after thaw_tasks() runs and checks its status.  For this purpose
> > task_lock() is used.
> 
> Great! But please be kind to those of us who read the source control history
> trying to understand the code. Could you make 2 separate patches?

Okay, attached.  The first one closes the race between thaw_tasks() and the
refrigerator that can occurs if the freezing fails.  The second one fixes the
vfork problem (should go on top of the first one).

> > @@ -207,7 +209,7 @@ static void thaw_tasks(int thaw_user_spa
> >  		if (is_user_space(p) == !thaw_user_space)
> >  			continue;
> >  
> > -		if (!thaw_process(p))
> > +		if (!thaw_process(p) && !freezer_should_skip(p))
> >  			printk(KERN_WARNING " Strange, %s not stopped\n",
> 
> This is racy, the warning could be false. We wake up the task, testing
> its ->flags is not reliable.
> 
> Damn. PF_FREEZER_SKIP task could be woken before, clear PF_FREEZER_SKIP,
> but not frozen.
> 
> We can change freezer_count() to clear PF_FREEZER_SKIP after try_to_freeze(),
> not before. Now thaw_process() can take PF_FREEZER_SKIP into account and
> return "true".
> 
> But this means the task may be PF_FREEZER_SKIP | PF_FROZEN. What if we we
> call try_to_freeze_tasks() soon after thaw_tasks()? We may hit the task which
> leaves the refrigerator, but didn't clear PF_FREEZER_SKIP yet. This means
> that thaw_process() should clear PF_FREEZER_SKIP as well. This is messy :(
> 
> Any other ideas? In any case we should imho avoid a separate loop for
> PF_FREEZER_SKIP tasks to just fix debug messages. In fact it can't help
> anyway.

Why don't we just drop the warning?  try_to_freeze_tasks() should give us a
warning if there's anything wrong anyway.

Greetings,
Rafael

--Boundary-00=_tzc3Fksr1nxJ2E+
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="freezer-fix-theoretical-race.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="freezer-fix-theoretical-race.patch"

 include/linux/freezer.h |    4 ++++
 kernel/power/process.c  |   14 +++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

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
 

--Boundary-00=_tzc3Fksr1nxJ2E+
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="freezer-fix-vfork-problem.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="freezer-fix-vfork-problem.patch"

 include/linux/freezer.h |   30 ++++++++++++++++++++++++++++--
 include/linux/sched.h   |    1 +
 kernel/fork.c           |    3 +++
 kernel/power/process.c  |   29 +++++++++--------------------
 4 files changed, 41 insertions(+), 22 deletions(-)

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
@@ -131,22 +131,12 @@ static unsigned int try_to_freeze_tasks(
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
@@ -171,8 +161,9 @@ static unsigned int try_to_freeze_tasks(
 			if (is_user_space(p) == !freeze_user_space)
 				continue;
 
-			if (freezeable(p) && !frozen(p))
-				printk(KERN_ERR " %s\n", p->comm);
+			if (freezeable(p) && !frozen(p) &&
+			    !freezer_should_skip(p))
+				printk(KERN_WARNING " %s\n", p->comm);
 
 			cancel_freezing(p);
 		} while_each_thread(g, p);
@@ -219,9 +210,7 @@ static void thaw_tasks(int thaw_user_spa
 		if (is_user_space(p) == !thaw_user_space)
 			continue;
 
-		if (!thaw_process(p))
-			printk(KERN_WARNING " Strange, %s not stopped\n",
-				p->comm );
+		thaw_process(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 }

--Boundary-00=_tzc3Fksr1nxJ2E+--
