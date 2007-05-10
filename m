Return-Path: <linux-kernel-owner+w=401wt.eu-S1761432AbXEKJHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761432AbXEKJHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 05:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550AbXEKJG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 05:06:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58479 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453AbXEKJGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 05:06:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/7] Freezer: Close potential race between refrigerator and thaw_tasks
Date: Fri, 11 May 2007 00:37:22 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200705110035.32229.rjw@sisk.pl>
In-Reply-To: <200705110035.32229.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705110037.23268.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If the freezing of tasks fails and a task is preempted in refrigerator()
before calling frozen_process(), then thaw_tasks() may run before this task is
frozen.  In that case the task will freeze and no one will thaw it.

To fix this race we can call freezing(current) in refrigerator() along with
frozen_process(current) under the task_lock() which also should be taken in
the error path of try_to_freeze_tasks() as well as in thaw_process(). 
Moreover, if thaw_process() additionally clears TIF_FREEZE for tasks that are
not frozen, we can be sure that all tasks are thawed and there are no pending
"freeze" requests after thaw_tasks() has run.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 include/linux/freezer.h |   10 ++++++++++
 kernel/power/process.c  |   12 +++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/freezer.h
===================================================================
--- linux-2.6.orig/include/linux/freezer.h	2007-05-10 21:44:23.000000000 +0200
+++ linux-2.6/include/linux/freezer.h	2007-05-10 21:44:31.000000000 +0200
@@ -37,14 +37,24 @@ static inline void do_not_freeze(struct 
 
 /*
  * Wake up a frozen process
+ *
+ * task_lock() is taken to prevent the race with refrigerator() which may
+ * occur if the freezing of tasks fails.  Namely, without the lock, if the
+ * freezing of tasks failed, thaw_tasks() might have run before a task in
+ * refrigerator() could call frozen_process(), in which case the task would be
+ * frozen and no one would thaw it.
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
 
Index: linux-2.6/kernel/power/process.c
===================================================================
--- linux-2.6.orig/kernel/power/process.c	2007-05-10 21:44:28.000000000 +0200
+++ linux-2.6/kernel/power/process.c	2007-05-10 21:44:31.000000000 +0200
@@ -38,10 +38,18 @@ void refrigerator(void)
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
@@ -158,10 +166,12 @@ static unsigned int try_to_freeze_tasks(
 			if (is_user_space(p) == !freeze_user_space)
 				continue;
 
+			task_lock(p);
 			if (freezeable(p) && !frozen(p))
 				printk(KERN_ERR " %s\n", p->comm);
 
 			cancel_freezing(p);
+			task_unlock(p);
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 	}

