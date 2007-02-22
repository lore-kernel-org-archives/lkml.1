Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbXBVWD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbXBVWD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 17:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbXBVWD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 17:03:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45978 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbXBVWD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 17:03:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: freezer problems
Date: Thu, 22 Feb 2007 22:56:18 +0100
User-Agent: KMail/1.9.5
Cc: paulmck@linux.vnet.ibm.com, ego@in.ibm.com, akpm@osdl.org,
       paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <200702221803.41549.rjw@sisk.pl> <20070222174439.GA236@tv-sign.ru>
In-Reply-To: <20070222174439.GA236@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702222256.19582.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 22 February 2007 18:44, Oleg Nesterov wrote:
> On 02/22, Rafael J. Wysocki wrote:
> > 
> > Okay, attached.  The first one closes the race between thaw_tasks() and the
> > refrigerator that can occurs if the freezing fails.  The second one fixes the
> > vfork problem (should go on top of the first one).
> 
> Looks good to me.
> 
> > > Any other ideas? In any case we should imho avoid a separate loop for
> > > PF_FREEZER_SKIP tasks to just fix debug messages. In fact it can't help
> > > anyway.
> > 
> > Why don't we just drop the warning?  try_to_freeze_tasks() should give us a
> > warning if there's anything wrong anyway.
> 
> Indeed :)

Still, there is a tiny race in the error path of try_to_freeze_tasks(), where
a vfork parent process can be preempted after clearing PF_FREEZER_SKIP and
before entering refrigerator(), so try_to_freeze_tasks() will mistakenly report
that this process has caused a problem.

I think this race can be closed by (1) clearing PF_FREEZER_SKIP after calling
try_to_freeze() in freezer_count(), (2) clearing PF_FREEZER_SKIP in
refrigerator() before calling frozen_process() and (3) taking task_lock()
around the warning check in the error path of try_to_freeze_tasks().

I have modified freezer-fix-vfork-problem.patch to implement this (appended;
it assumes that freezer-fix-theoretical-race.patch has already been applied).

If this is the right thing to do, I think there's a reason to additionally move
task_lock/unlock() from cancel_freezing() to the error path in
try_to_freeze_tasks().

Greetings,
Rafael


 include/linux/freezer.h |   30 ++++++++++++++++++++++++++++--
 include/linux/sched.h   |    1 +
 kernel/fork.c           |    3 +++
 kernel/power/process.c  |   32 +++++++++++++-------------------
 4 files changed, 45 insertions(+), 21 deletions(-)

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
+	try_to_freeze();
+	current->flags &= ~PF_FREEZER_SKIP;
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
@@ -42,6 +42,7 @@ void refrigerator(void)
 
 	task_lock(current);
 	if (freezing(current)) {
+		current->flags &= ~PF_FREEZER_SKIP;
 		frozen_process(current);
 		task_unlock(current);
 	} else {
@@ -131,22 +132,12 @@ static unsigned int try_to_freeze_tasks(
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
@@ -171,9 +162,14 @@ static unsigned int try_to_freeze_tasks(
 			if (is_user_space(p) == !freeze_user_space)
 				continue;
 
-			if (freezeable(p) && !frozen(p))
+			task_lock(p);
+
+			if (freezeable(p) && !frozen(p) &&
+			    !freezer_should_skip(p))
 				printk(KERN_ERR " %s\n", p->comm);
 
+			task_unlock(p);
+
 			cancel_freezing(p);
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
@@ -219,9 +215,7 @@ static void thaw_tasks(int thaw_user_spa
 		if (is_user_space(p) == !thaw_user_space)
 			continue;
 
-		if (!thaw_process(p))
-			printk(KERN_WARNING " Strange, %s not stopped\n",
-				p->comm );
+		thaw_process(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 }

