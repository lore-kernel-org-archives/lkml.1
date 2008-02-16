Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbYBPP6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbYBPP6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 10:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbYBPP6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 10:58:15 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:50938 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYBPP6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 10:58:14 -0500
Message-ID: <47B70810.5030608@tiscali.nl>
Date: Sat, 16 Feb 2008 16:58:08 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: hpa@zytor.com
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] kernel/{exit.c, signal.c, power/process.c}: replace !likely(x)
 by likely(!x)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not entirely sure who to send this to
---
Replace !likely(x) by likely(!x)

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/kernel/exit.c b/kernel/exit.c
index 506a957..df207fc 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1497,7 +1497,7 @@ repeat:
 				/*
 				 * We don't reap group leaders with subthreads.
 				 */
-				if (!likely(options & WEXITED))
+				if (likely(!(options & WEXITED)))
 					continue;
 				retval = wait_task_zombie(p,
 						(options & WNOWAIT), infop,
@@ -1508,7 +1508,7 @@ repeat:
 				 * exit, stop, or stop and then continue.
 				 */
 				flag = 1;
-				if (!unlikely(options & WCONTINUED))
+				if (unlikely(!(options & WCONTINUED)))
 					continue;
 				retval = wait_task_continued(p,
 						(options & WNOWAIT), infop,
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 7c2118f..b42254b 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -36,7 +36,7 @@ static inline int freezeable(struct task_struct * p)
  */
 static inline void frozen_process(void)
 {
-	if (!unlikely(current->flags & PF_NOFREEZE)) {
+	if (unlikely(!(current->flags & PF_NOFREEZE))) {
 		current->flags |= PF_FROZEN;
 		wmb();
 	}
diff --git a/kernel/signal.c b/kernel/signal.c
index 84917fe..1155e16 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1308,7 +1308,7 @@ int send_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
 	 */
 	rcu_read_lock();
 
-	if (!likely(lock_task_sighand(p, &flags))) {
+	if (likely(!lock_task_sighand(p, &flags))) {
 		ret = -1;
 		goto out_err;
 	}
@@ -1548,7 +1548,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 
 static inline int may_ptrace_stop(void)
 {
-	if (!likely(current->ptrace & PT_PTRACED))
+	if (likely(!(current->ptrace & PT_PTRACED)))
 		return 0;
 	/*
 	 * Are we in the middle of do_coredump?
@@ -1574,7 +1574,7 @@ static int sigkill_pending(struct task_struct *tsk)
 {
 	return ((sigismember(&tsk->pending.signal, SIGKILL) ||
 		 sigismember(&tsk->signal->shared_pending.signal, SIGKILL)) &&
-		!unlikely(sigismember(&tsk->blocked, SIGKILL)));
+		 unlikely(!sigismember(&tsk->blocked, SIGKILL)));
 }
 
 /*
@@ -1625,7 +1625,7 @@ static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
 	spin_unlock_irq(&current->sighand->siglock);
 	try_to_freeze();
 	read_lock(&tasklist_lock);
-	if (!unlikely(killed) && may_ptrace_stop()) {
+	if (unlikely(!killed) && may_ptrace_stop()) {
 		do_notify_parent_cldstop(current, CLD_TRAPPED);
 		read_unlock(&tasklist_lock);
 		schedule();
@@ -1717,7 +1717,7 @@ static int do_signal_stop(int signr)
 	} else {
 		struct task_struct *t;
 
-		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
+		if (likely(!(sig->flags & SIGNAL_STOP_DEQUEUED)) ||
 		    unlikely(sig->group_exit_task))
 			return 0;
 		/*

