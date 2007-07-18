Return-Path: <linux-kernel-owner+w=401wt.eu-S1760961AbXGRHed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760961AbXGRHed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbXGRHcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:32:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52607 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbXGRHcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:32:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 5/5] Freezer: Do not send signals to kernel threads
Date: Wed, 18 Jul 2007 09:39:10 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>
References: <200707180929.31511.rjw@sisk.pl>
In-Reply-To: <200707180929.31511.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707180939.11475.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The freezer should not send signals to kernel threads, since that may lead to
subtle problems.  In particular, commit b74d0deb968e1f85942f17080eace015ce3c332c
has changed recalc_sigpending_tsk() so that it doesn't clear TIF_SIGPENDING.
For this reason, if the freezer continues to send fake signals to kernel threads
and the freezing of kernel threads fails, some of them may be running with
TIF_SIGPENDING set forever.

Accordingly, recalc_sigpending_tsk() shouldn't set the task's TIF_SIGPENDING
flag if TIF_FREEZE is set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/freezing-of-tasks.txt |   31 +++++---
 kernel/power/process.c                    |  107 ++++++++++++++++++++----------
 kernel/signal.c                           |    1 
 3 files changed, 93 insertions(+), 46 deletions(-)

Index: linux-2.6.22-rc6-mm1/kernel/power/process.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/kernel/power/process.c	2007-07-11 20:50:28.000000000 +0200
+++ linux-2.6.22-rc6-mm1/kernel/power/process.c	2007-07-11 20:51:48.000000000 +0200
@@ -75,21 +75,79 @@ void refrigerator(void)
 	__set_current_state(save);
 }
 
-static void freeze_task(struct task_struct *p)
+static void fake_signal_wake_up(struct task_struct *p, int resume)
 {
 	unsigned long flags;
 
-	if (!freezing(p)) {
+	spin_lock_irqsave(&p->sighand->siglock, flags);
+	signal_wake_up(p, resume);
+	spin_unlock_irqrestore(&p->sighand->siglock, flags);
+}
+
+static void send_fake_signal(struct task_struct *p)
+{
+	if (p->state == TASK_STOPPED)
+		force_sig_specific(SIGSTOP, p);
+	fake_signal_wake_up(p, p->state == TASK_STOPPED);
+}
+
+static int has_mm(struct task_struct *p)
+{
+	return (p->mm && !(p->flags & PF_BORROWED_MM));
+}
+
+/**
+ *	freeze_task - send a freeze request to given task
+ *	@p: task to send the request to
+ *	@with_mm_only: if set, the request will only be sent if the task has its
+ *		own mm
+ *	Return value: 0, if @with_mm_only is set and the task has no mm of its
+ *		own or the task is frozen, 1, otherwise
+ *
+ *	The freeze request is sent by seting the tasks's TIF_FREEZE flag and
+ *	either sending a fake signal to it or waking it up, depending on whether
+ *	or not it has its own mm (ie. it is a user land task).  If @with_mm_only
+ *	is set and the task has no mm of its own (ie. it is a kernel thread),
+ *	its TIF_FREEZE flag should not be set.
+ *
+ *	The task_lock() is necessary to prevent races with exit_mm() or
+ *	use_mm()/unuse_mm() from occuring.
+ */
+static int freeze_task(struct task_struct *p, int with_mm_only)
+{
+	int ret = 1;
+
+	task_lock(p);
+	if (freezing(p)) {
+		if (has_mm(p)) {
+			if (!signal_pending(p))
+				fake_signal_wake_up(p, 0);
+		} else {
+			if (with_mm_only)
+				ret = 0;
+			else
+				wake_up_state(p, TASK_INTERRUPTIBLE);
+		}
+	} else {
 		rmb();
-		if (!frozen(p)) {
-			set_freeze_flag(p);
-			if (p->state == TASK_STOPPED)
-				force_sig_specific(SIGSTOP, p);
-			spin_lock_irqsave(&p->sighand->siglock, flags);
-			signal_wake_up(p, p->state == TASK_STOPPED);
-			spin_unlock_irqrestore(&p->sighand->siglock, flags);
+		if (frozen(p)) {
+			ret = 0;
+		} else {
+			if (has_mm(p)) {
+				set_freeze_flag(p);
+				send_fake_signal(p);
+			} else {
+				if (with_mm_only) {
+					ret = 0;
+				} else {
+					set_freeze_flag(p);
+					wake_up_state(p, TASK_INTERRUPTIBLE);
+				}
+			}
 		}
 	}
+	task_unlock(p);
+	return ret;
 }
 
 static void cancel_freezing(struct task_struct *p)
@@ -119,31 +177,14 @@ static int try_to_freeze_tasks(int freez
 			if (frozen(p) || !freezeable(p))
 				continue;
 
-			if (freeze_user_space) {
-				if (p->state == TASK_TRACED &&
-				    frozen(p->parent)) {
-					cancel_freezing(p);
-					continue;
-				}
-				/*
-				 * Kernel threads should not have TIF_FREEZE set
-				 * at this point, so we must ensure that either
-				 * p->mm is not NULL *and* PF_BORROWED_MM is
-				 * unset, or TIF_FRREZE is left unset.
-				 * The task_lock() is necessary to prevent races
-				 * with exit_mm() or use_mm()/unuse_mm() from
-				 * occuring.
-				 */
-				task_lock(p);
-				if (!p->mm || (p->flags & PF_BORROWED_MM)) {
-					task_unlock(p);
-					continue;
-				}
-				freeze_task(p);
-				task_unlock(p);
-			} else {
-				freeze_task(p);
+			if (p->state == TASK_TRACED && frozen(p->parent)) {
+				cancel_freezing(p);
+				continue;
 			}
+
+			if (!freeze_task(p, freeze_user_space))
+				continue;
+
 			if (!freezer_should_skip(p))
 				todo++;
 		} while_each_thread(g, p);
Index: linux-2.6.22-rc6-mm1/kernel/signal.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/kernel/signal.c	2007-07-11 20:48:04.000000000 +0200
+++ linux-2.6.22-rc6-mm1/kernel/signal.c	2007-07-11 20:51:48.000000000 +0200
@@ -99,7 +99,6 @@ static inline int has_pending_signals(si
 static int recalc_sigpending_tsk(struct task_struct *t)
 {
 	if (t->signal->group_stop_count > 0 ||
-	    (freezing(t)) ||
 	    PENDING(&t->pending, &t->blocked) ||
 	    PENDING(&t->signal->shared_pending, &t->blocked)) {
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
Index: linux-2.6.22-rc6-mm1/Documentation/power/freezing-of-tasks.txt
===================================================================
--- linux-2.6.22-rc6-mm1.orig/Documentation/power/freezing-of-tasks.txt	2007-07-11 20:50:24.000000000 +0200
+++ linux-2.6.22-rc6-mm1/Documentation/power/freezing-of-tasks.txt	2007-07-11 20:51:48.000000000 +0200
@@ -19,12 +19,13 @@ we only consider hibernation, but the de
 Namely, as the first step of the hibernation procedure the function
 freeze_processes() (defined in kernel/power/process.c) is called.  It executes
 try_to_freeze_tasks() that sets TIF_FREEZE for all of the freezable tasks and
-sends a fake signal to each of them.  A task that receives such a signal and has
-TIF_FREEZE set, should react to it by calling the refrigerator() function
-(defined in kernel/power/process.c), which sets the task's PF_FROZEN flag,
-changes its state to TASK_UNINTERRUPTIBLE and makes it loop until PF_FROZEN is
-cleared for it.  Then, we say that the task is 'frozen' and therefore the set of
-functions handling this mechanism is called 'the freezer' (these functions are
+either wakes them up, if they are kernel threads, or sends fake signals to them,
+if they are user space processes.  A task that has TIF_FREEZE set, should react
+to it by calling the function called refrigerator() (defined in
+kernel/power/process.c), which sets the task's PF_FROZEN flag, changes its state
+to TASK_UNINTERRUPTIBLE and makes it loop until PF_FROZEN is cleared for it.
+Then, we say that the task is 'frozen' and therefore the set of functions
+handling this mechanism is referred to as 'the freezer' (these functions are
 defined in kernel/power/process.c and include/linux/freezer.h).  User space
 processes are generally frozen before kernel threads.
 
@@ -35,21 +36,27 @@ task enter refrigerator() if the flag is
 
 For user space processes try_to_freeze() is called automatically from the
 signal-handling code, but the freezable kernel threads need to call it
-explicitly in suitable places.  The code to do this may look like the following:
+explicitly in suitable places or use the wait_event_freezable() or
+wait_event_freezable_timeout() macros (defined in include/linux/freezer.h)
+that combine interruptible sleep with checking if TIF_FREEZE is set and calling
+try_to_freeze().  The main loop of a freezable kernel thread may look like the
+following one:
 
+	set_freezable();
 	do {
 		hub_events();
-		wait_event_interruptible(khubd_wait,
-					!list_empty(&hub_event_list));
-		try_to_freeze();
-	} while (!signal_pending(current));
+		wait_event_freezable(khubd_wait,
+				!list_empty(&hub_event_list) ||
+				kthread_should_stop());
+	} while (!kthread_should_stop() || !list_empty(&hub_event_list));
 
 (from drivers/usb/core/hub.c::hub_thread()).
 
 If a freezable kernel thread fails to call try_to_freeze() after the freezer has
 set TIF_FREEZE for it, the freezing of tasks will fail and the entire
 hibernation operation will be cancelled.  For this reason, freezable kernel
-threads must call try_to_freeze() somewhere.
+threads must call try_to_freeze() somewhere or use one of the
+wait_event_freezable() and wait_event_freezable_timeout() macros.
 
 After the system memory state has been restored from a hibernation image and
 devices have been reinitialized, the function thaw_processes() is called in
