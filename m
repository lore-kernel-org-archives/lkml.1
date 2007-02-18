Return-Path: <linux-kernel-owner+w=401wt.eu-S1751875AbXBRTCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbXBRTCE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 14:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbXBRTCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 14:02:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49694 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbXBRTBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 14:01:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: freezer problems
Date: Sun, 18 Feb 2007 19:56:10 +0100
User-Agent: KMail/1.9.5
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <200702181314.29214.rjw@sisk.pl> <20070218145246.GA80@tv-sign.ru>
In-Reply-To: <20070218145246.GA80@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702181956.11273.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 February 2007 15:52, Oleg Nesterov wrote:
> On 02/18, Rafael J. Wysocki wrote:
> >
> > On Sunday, 18 February 2007 12:31, Oleg Nesterov wrote:
> > > > > 
> > > > > However, this means that sys_vfork() makes impossible to freeze processes
> > > > > until child exits/execs. Not good.
> > > > 
> > > I forgot to say that we have another problem: coredumping.
> > > 
> > > A thread which does do_coredump() send SIGKILL to ->mm users, and sleeps
> > > on ->mm->core_startup_done. Now it can't be frozen if sub-thread goes to
> > > refrigerator. I think this could be solved easily if we add a check to
> > > refrigerator() as you suggested for ->vfork_donw.
> > > 
> > > > I think the real solution would be to use an interruptible completion in the
> > > > vfork code.  It was discussed some time ago and, IIRC, Ingo had an experimental
> > > > patch that implemented it.  Still, for the suspend this really is not an issue
> > > > in practice, so it wasn't merged.
> > > 
> > > It is not (afaics) so trivial to do rightly, and with this change the parent
> > > will be seen as TASK_INTERRUPTIBLE even without freezer in progress.
> > > 
> > > A very vague idea: what if parent will do
> > > 
> > > 	current->flags |= PF_PLEASE_CONSIDER_ME_AS_FROZEN_BUT_SET_TIF_FREEZE
> > > 	wait_for_completion(&vfork);
> > > 	try_to_freeze();
> > > 
> > > ?
> > 
> > This should work,
> 
> Good. So try_to_freeze_tasks() can forget about "if (!p->vfork_done)" check.
> This needs more thinking, of course. For example, thaw_process() should be
> carefull to clear TIF_FREEZE if we have the new flag set, but not PF_FROZEN.
> frozen() should be changed to return true if PF_NEW_FLAG && TIF_FREEZE, but
> it also called by refrigerator.
> 
> But IF we really can do this, it will be a general solution.

Appended is a patch that does something along these lines.  The necessary
thread_info flags are defined for i386 and x86_64, for now.

Greetings,
Rafael


 include/asm-i386/thread_info.h   |    2 ++
 include/asm-x86_64/thread_info.h |    2 ++
 include/linux/freezer.h          |   24 ++++++++++++++++++++++++
 kernel/fork.c                    |    4 ++++
 kernel/power/process.c           |   24 +++++++++---------------
 5 files changed, 41 insertions(+), 15 deletions(-)

Index: linux-2.6.20-mm2/include/asm-i386/thread_info.h
===================================================================
--- linux-2.6.20-mm2.orig/include/asm-i386/thread_info.h	2007-02-18 19:49:34.000000000 +0100
+++ linux-2.6.20-mm2/include/asm-i386/thread_info.h	2007-02-18 19:50:37.000000000 +0100
@@ -135,6 +135,7 @@ static inline struct thread_info *curren
 #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
 #define TIF_FREEZE		19	/* is freezing for suspend */
 #define TIF_FORCED_TF		20	/* true if TF in eflags artificially */
+#define TIF_FREEZER_SKIP	21	/* task freezer should not count us */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
@@ -149,6 +150,7 @@ static inline struct thread_info *curren
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_FORCED_TF		(1<<TIF_FORCED_TF)
+#define _TIF_FREEZER_SKIP	(1<<TIF_FREEZER_SKIP)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
Index: linux-2.6.20-mm2/include/asm-x86_64/thread_info.h
===================================================================
--- linux-2.6.20-mm2.orig/include/asm-x86_64/thread_info.h	2007-02-18 19:49:34.000000000 +0100
+++ linux-2.6.20-mm2/include/asm-x86_64/thread_info.h	2007-02-18 19:50:37.000000000 +0100
@@ -123,6 +123,7 @@ static inline struct thread_info *stack_
 #define TIF_DEBUG		21	/* uses debug registers */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
 #define TIF_FREEZE		23	/* is freezing for suspend */
+#define TIF_FREEZER_SKIP	24	/* task freezer should not count us */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
@@ -140,6 +141,7 @@ static inline struct thread_info *stack_
 #define _TIF_DEBUG		(1<<TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_FREEZER_SKIP	(1<<TIF_FREEZER_SKIP)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
Index: linux-2.6.20-mm2/include/linux/freezer.h
===================================================================
--- linux-2.6.20-mm2.orig/include/linux/freezer.h	2007-02-18 19:49:34.000000000 +0100
+++ linux-2.6.20-mm2/include/linux/freezer.h	2007-02-18 19:50:37.000000000 +0100
@@ -36,6 +36,30 @@ static inline void do_not_freeze(struct 
 }
 
 /*
+ * Tell the freezer not to count this task as freezeable
+ */
+static inline void freezer_do_not_count(struct task_struct *p)
+{
+	set_tsk_thread_flag(p, TIF_FREEZER_SKIP);
+}
+
+/*
+ * Tell the freezer to count this task as freezeable
+ */
+static inline void freezer_count(struct task_struct *p)
+{
+	clear_tsk_thread_flag(p, TIF_FREEZER_SKIP);
+}
+
+/*
+ * Check if the task should be counted as freezeable by the freezer
+ */
+static inline int freezer_should_skip(struct task_struct *p)
+{
+	return test_tsk_thread_flag(p, TIF_FREEZER_SKIP);
+}
+
+/*
  * Wake up a frozen process
  */
 static inline int thaw_process(struct task_struct *p)
Index: linux-2.6.20-mm2/kernel/fork.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/fork.c	2007-02-18 19:49:34.000000000 +0100
+++ linux-2.6.20-mm2/kernel/fork.c	2007-02-18 19:50:37.000000000 +0100
@@ -50,6 +50,7 @@
 #include <linux/taskstats_kern.h>
 #include <linux/random.h>
 #include <linux/ptrace.h>
+#include <linux/freezer.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -1393,7 +1394,10 @@ long do_fork(unsigned long clone_flags,
 		tracehook_report_clone_complete(clone_flags, nr, p);
 
 		if (clone_flags & CLONE_VFORK) {
+			freezer_do_not_count(current);
 			wait_for_completion(&vfork);
+			try_to_freeze();
+			freezer_count(current);
 			tracehook_report_vfork_done(p, nr);
 		}
 	} else {
Index: linux-2.6.20-mm2/kernel/power/process.c
===================================================================
--- linux-2.6.20-mm2.orig/kernel/power/process.c	2007-02-18 19:49:34.000000000 +0100
+++ linux-2.6.20-mm2/kernel/power/process.c	2007-02-18 19:50:37.000000000 +0100
@@ -117,22 +117,12 @@ static unsigned int try_to_freeze_tasks(
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
@@ -199,6 +189,10 @@ static void thaw_tasks(int thaw_user_spa
 
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
+		if (freezer_should_skip(p))
+			cancel_freezing(p);
+	} while_each_thread(g, p);
+	do_each_thread(g, p) {
 		if (!freezeable(p))
 			continue;
 
