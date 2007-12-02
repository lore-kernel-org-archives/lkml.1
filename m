Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbXLBPPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbXLBPPI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 10:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXLBPOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 10:14:44 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:37475 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbXLBPOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 10:14:43 -0500
Date: Sun, 2 Dec 2007 18:14:57 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] exec: rework the group exit and fix the race with kill
Message-ID: <20071202151457.GA13186@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Roland pointed out, we have the very old problem with exec. de_thread() sets
SIGNAL_GROUP_EXIT, kills other threads, changes ->group_leader and then clears
signal->flags. All signals (even fatal ones) sent in this window (which is not
too small) will be lost.

With this patch exec doesn't abuse SIGNAL_GROUP_EXIT. signal_group_exit(), the
new helper, should be used to detect exit_group() or exec() in progress. It can
have more users, but this patch does only strictly necessary changes.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/sched.h |    7 +++++++
 fs/exec.c             |   13 ++++---------
 kernel/signal.c       |    4 ++--
 kernel/exit.c         |    3 ++-
 4 files changed, 15 insertions(+), 12 deletions(-)

--- PT/include/linux/sched.h~2_EXIT_KILL	2007-11-26 16:47:35.000000000 +0300
+++ PT/include/linux/sched.h	2007-12-02 14:53:29.000000000 +0300
@@ -540,6 +540,13 @@ struct signal_struct {
 #define SIGNAL_STOP_CONTINUED	0x00000004 /* SIGCONT since WCONTINUED reap */
 #define SIGNAL_GROUP_EXIT	0x00000008 /* group exit in progress */
 
+/* If true, all threads except ->group_exit_task have pending SIGKILL */
+static inline int signal_group_exit(const struct signal_struct *sig)
+{
+	return	(sig->flags & SIGNAL_GROUP_EXIT) ||
+		(sig->group_exit_task != NULL);
+}
+
 /*
  * Some day this will be a full-fledged user tracking system..
  */
--- PT/fs/exec.c~2_EXIT_KILL	2007-11-20 17:16:09.000000000 +0300
+++ PT/fs/exec.c	2007-12-02 16:07:22.000000000 +0300
@@ -759,7 +759,7 @@ static int de_thread(struct task_struct 
 	 */
 	read_lock(&tasklist_lock);
 	spin_lock_irq(lock);
-	if (sig->flags & SIGNAL_GROUP_EXIT) {
+	if (signal_group_exit(sig)) {
 		/*
 		 * Another group action in progress, just
 		 * return so that the signal is processed.
@@ -777,6 +777,7 @@ static int de_thread(struct task_struct 
 	if (unlikely(tsk->group_leader == task_child_reaper(tsk)))
 		task_active_pid_ns(tsk)->child_reaper = tsk;
 
+	sig->group_exit_task = tsk;
 	zap_other_threads(tsk);
 	read_unlock(&tasklist_lock);
 
@@ -801,7 +802,6 @@ static int de_thread(struct task_struct 
 	}
 
 	sig->notify_count = count;
-	sig->group_exit_task = tsk;
 	while (atomic_read(&sig->count) > count) {
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 		spin_unlock_irq(lock);
@@ -870,15 +870,10 @@ static int de_thread(struct task_struct 
 		leader->exit_state = EXIT_DEAD;
 
 		write_unlock_irq(&tasklist_lock);
-        }
+	}
 
 	sig->group_exit_task = NULL;
 	sig->notify_count = 0;
-	/*
-	 * There may be one thread left which is just exiting,
-	 * but it's safe to stop telling the group to kill themselves.
-	 */
-	sig->flags = 0;
 
 no_thread_group:
 	exit_itimers(sig);
@@ -1548,7 +1543,7 @@ static inline int zap_threads(struct tas
 	int err = -EAGAIN;
 
 	spin_lock_irq(&tsk->sighand->siglock);
-	if (!(tsk->signal->flags & SIGNAL_GROUP_EXIT)) {
+	if (!signal_group_exit(tsk->signal)) {
 		tsk->signal->group_exit_code = exit_code;
 		zap_process(tsk);
 		err = 0;
--- PT/kernel/signal.c~2_EXIT_KILL	2007-12-02 16:56:16.000000000 +0300
+++ PT/kernel/signal.c	2007-12-02 17:05:15.000000000 +0300
@@ -957,7 +957,6 @@ void zap_other_threads(struct task_struc
 {
 	struct task_struct *t;
 
-	p->signal->flags = SIGNAL_GROUP_EXIT;
 	p->signal->group_stop_count = 0;
 
 	for (t = next_thread(p); t != p; t = next_thread(t)) {
@@ -1692,7 +1691,8 @@ static int do_signal_stop(int signr)
 	} else {
 		struct task_struct *t;
 
-		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED))
+		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
+		    unlikely(sig->group_exit_task))
 			return 0;
 		/*
 		 * There is no group stop already in progress.
--- PT/kernel/exit.c~2_EXIT_KILL	2007-12-02 14:36:22.000000000 +0300
+++ PT/kernel/exit.c	2007-12-02 15:53:35.000000000 +0300
@@ -1081,11 +1081,12 @@ do_group_exit(int exit_code)
 		struct signal_struct *const sig = current->signal;
 		struct sighand_struct *const sighand = current->sighand;
 		spin_lock_irq(&sighand->siglock);
-		if (sig->flags & SIGNAL_GROUP_EXIT)
+		if (signal_group_exit(sig))
 			/* Another thread got here before we took the lock.  */
 			exit_code = sig->group_exit_code;
 		else {
 			sig->group_exit_code = exit_code;
+			sig->flags = SIGNAL_GROUP_EXIT;
 			zap_other_threads(current);
 		}
 		spin_unlock_irq(&sighand->siglock);

