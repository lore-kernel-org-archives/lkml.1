Return-Path: <linux-kernel-owner+w=401wt.eu-S933109AbXIBCrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109AbXIBCrx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 22:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbXIBCrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 22:47:00 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:52197 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbXIBCq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 22:46:58 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: akpm@osdl.org, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 3/5] Add TASK_WAKEKILL
Date: Sat,  1 Sep 2007 22:46:52 -0400
Message-Id: <11887012141524-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <20070902024348.GJ14130@parisc-linux.org>
References: <20070902024348.GJ14130@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Set TASK_WAKEKILL for TASK_STOPPED and TASK_TRACED, add TASK_KILLABLE and
use TASK_WAKEKILL in signal_wake_up()

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 include/linux/sched.h |   22 ++++++++++++++--------
 kernel/signal.c       |    8 ++++----
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ea509e9..6769179 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -167,28 +167,34 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
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
 #define TASK_NONINTERACTIVE	64
 #define TASK_DEAD		128
+#define TASK_WAKEKILL		256
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
index 53cbac4..986ba10 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -459,15 +459,15 @@ void signal_wake_up(struct task_struct *t, int resume)
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
@@ -623,7 +623,7 @@ static void handle_stop_signal(int sig, struct task_struct *p)
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

