Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZG1X5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZG1X5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbZG1X5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:57:36 -0400
Received: from kroah.org ([198.145.64.141]:35821 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbZG1XuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:08 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:57 2009
Message-Id: <20090728234157.365935237@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 40/71] sched: fix nr_uninterruptible accounting of frozen tasks really
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=sched-fix-nr_uninterruptible-accounting-of-frozen-tasks-really.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 6301cb95c119ebf324bb96ee226fa9ddffad80a7 upstream.

commit e3c8ca8336 (sched: do not count frozen tasks toward load) broke
the nr_uninterruptible accounting on freeze/thaw. On freeze the task
is excluded from accounting with a check for (task->flags &
PF_FROZEN), but that flag is cleared before the task is thawed. So
while we prevent that the task with state TASK_UNINTERRUPTIBLE
is accounted to nr_uninterruptible on freeze we decrement
nr_uninterruptible on thaw.

Use a separate flag which is handled by the freezing task itself. Set
it before calling the scheduler with TASK_UNINTERRUPTIBLE state and
clear it after we return from frozen state.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/sched.h |    3 ++-
 kernel/freezer.c      |    7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -206,7 +206,7 @@ extern unsigned long long time_sync_thre
 			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
 #define task_contributes_to_load(task)	\
 				((task->state & TASK_UNINTERRUPTIBLE) != 0 && \
-				 (task->flags & PF_FROZEN) == 0)
+				 (task->flags & PF_FREEZING) == 0)
 
 #define __set_task_state(tsk, state_value)		\
 	do { (tsk)->state = (state_value); } while (0)
@@ -1630,6 +1630,7 @@ extern cputime_t task_gtime(struct task_
 #define PF_MEMALLOC	0x00000800	/* Allocating memory */
 #define PF_FLUSHER	0x00001000	/* responsible for disk writeback */
 #define PF_USED_MATH	0x00002000	/* if unset the fpu must be initialized before use */
+#define PF_FREEZING	0x00004000	/* freeze in progress. do not account to load */
 #define PF_NOFREEZE	0x00008000	/* this thread should not be frozen */
 #define PF_FROZEN	0x00010000	/* frozen for system suspend */
 #define PF_FSTRANS	0x00020000	/* inside a filesystem transaction */
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -44,12 +44,19 @@ void refrigerator(void)
 	recalc_sigpending(); /* We sent fake signal, clean it up */
 	spin_unlock_irq(&current->sighand->siglock);
 
+	/* prevent accounting of that task to load */
+	current->flags |= PF_FREEZING;
+
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (!frozen(current))
 			break;
 		schedule();
 	}
+
+	/* Remove the accounting blocker */
+	current->flags &= ~PF_FREEZING;
+
 	pr_debug("%s left refrigerator\n", current->comm);
 	__set_current_state(save);
 }


