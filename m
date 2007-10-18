Return-Path: <linux-kernel-owner+w=401wt.eu-S934610AbXJRW1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934610AbXJRW1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765351AbXJRWZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:25:48 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:59426 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761750AbXJRWZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:25:44 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 3/5] Add TASK_WAKEKILL
Date: Thu, 18 Oct 2007 18:26:00 -0400
Message-Id: <11927463621633-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11927463623428-git-send-email-matthew@wil.cx>
References: <11927463623428-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Set TASK_WAKEKILL for TASK_STOPPED and TASK_TRACED, add TASK_KILLABLE and
use TASK_WAKEKILL in signal_wake_up()

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 include/linux/sched.h |   22 ++++++++++++++--------
 kernel/signal.c       |    8 ++++----
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5ef5253..f02ade4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -169,27 +169,33 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 #define TASK_RUNNING		0
 #define TASK_INTERRUPTIBLE	1
 #define TASK_UNINTERRUPTIBLE	2
-#define TASK_STOPPED		4
-#define TASK_TRACED		8
+#define __TASK_STOPPED		4
+#define __TASK_TRACED		8
 /* in tsk->exit_state */
 #define EXIT_ZOMBIE		16
 #define EXIT_DEAD		32
 /* in tsk->state again */
 #define TASK_DEAD		64
+#define TASK_WAKEKILL		128
+
+/* Convenience macros for the sake of set_task_state */
+#define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
+#define TASK_STOPPED		(TASK_WAKEKILL | __TASK_STOPPED)
+#define TASK_TRACED		(TASK_WAKEKILL | __TASK_TRACED)
 
 /* Convenience macros for the sake of wake_up */
 #define TASK_NORMAL		(TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE)
-#define TASK_ALL		(TASK_NORMAL | TASK_STOPPED | TASK_TRACED)
+#define TASK_ALL		(TASK_NORMAL | __TASK_STOPPED | __TASK_TRACED)
 
 /* get_task_state() */
 #define TASK_REPORT		(TASK_RUNNING | TASK_INTERRUPTIBLE | \
-				 TASK_UNINTERRUPTIBLE | TASK_STOPPED | \
-				 TASK_TRACED)
+				 TASK_UNINTERRUPTIBLE | __TASK_STOPPED | \
+				 __TASK_TRACED)
 
-#define is_task_traced(task)	((task->state & TASK_TRACED) != 0)
-#define is_task_stopped(task)	((task->state & TASK_STOPPED) != 0)
+#define is_task_traced(task)	((task->state & __TASK_TRACED) != 0)
+#define is_task_stopped(task)	((task->state & __TASK_STOPPED) != 0)
 #define is_task_stopped_or_traced(task)	\
-			((task->state & (TASK_STOPPED | TASK_TRACED)) != 0)
+			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
 #define is_task_loadavg(task)	((task->state & TASK_UNINTERRUPTIBLE) != 0)
 
 #define __set_task_state(tsk, state_value)		\
diff --git a/kernel/signal.c b/kernel/signal.c
index 16c16a3..3f28990 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -457,15 +457,15 @@ void signal_wake_up(struct task_struct *t, int resume)
 	set_tsk_thread_flag(t, TIF_SIGPENDING);
 
 	/*
-	 * For SIGKILL, we want to wake it up in the stopped/traced case.
-	 * We don't check t->state here because there is a race with it
+	 * For SIGKILL, we want to wake it up in the stopped/traced/killable
+	 * case. We don't check t->state here because there is a race with it
 	 * executing another processor and just now entering stopped state.
 	 * By using wake_up_state, we ensure the process will wake up and
 	 * handle its death signal.
 	 */
 	mask = TASK_INTERRUPTIBLE;
 	if (resume)
-		mask |= TASK_STOPPED | TASK_TRACED;
+		mask |= TASK_WAKEKILL;
 	if (!wake_up_state(t, mask))
 		kick_process(t);
 }
@@ -621,7 +621,7 @@ static void handle_stop_signal(int sig, struct task_struct *p)
 			 * Wake up the stopped thread _after_ setting
 			 * TIF_SIGPENDING
 			 */
-			state = TASK_STOPPED;
+			state = __TASK_STOPPED;
 			if (sig_user_defined(t, SIGCONT) && !sigismember(&t->blocked, SIGCONT)) {
 				set_tsk_thread_flag(t, TIF_SIGPENDING);
 				state |= TASK_INTERRUPTIBLE;
-- 
1.4.4.2

