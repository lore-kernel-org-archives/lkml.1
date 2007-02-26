Return-Path: <linux-kernel-owner+w=401wt.eu-S933785AbXBZHWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785AbXBZHWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 02:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964841AbXBZHVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 02:21:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57887 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933787AbXBZHVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 02:21:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@osdl.org>
Subject: [PATCH -mm 3/6] Freezer: Close theoretical race between refrigerator and thaw_tasks
Date: Mon, 26 Feb 2007 08:06:54 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
References: <200702260800.49603.rjw@sisk.pl>
In-Reply-To: <200702260800.49603.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702260806.55223.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If the freezing of tasks fails and a task is preempted in refrigerator() before
calling frozen_process(), then thaw_tasks() may run before this task is frozen.
In that case the task will freeze and no one will thaw it.

To fix this race we can call freezing(current) in refrigerator() along with
frozen_process(current) under the task_lock() which also should be taken in
the error path of try_to_freeze_tasks() as well as in thaw_process().  Moreover,
if thaw_process() additionally clears TIF_FREEZE for tasks that are not frozen,
we can be sure that all tasks are thawed and there are no pending "freeze"
requests after thaw_tasks() has run.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/freezer.h |    4 ++++
 kernel/power/process.c  |   12 +++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

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
@@ -159,10 +167,12 @@ static unsigned int try_to_freeze_tasks(
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

