Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbYGFPTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbYGFPTq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 11:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbYGFPTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 11:19:24 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:48089 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbYGFPTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 11:19:23 -0400
Date: Sun, 6 Jul 2008 19:22:22 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] coredump: simplify core_state->nr_threads calculation
Message-ID: <20080706152222.GA2822@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change zap_process() to return int instead of incrementing
mm->core_state->nr_threads directly. Change zap_threads() to set
mm->core_state only on success.

This patch restores the original size of .text, and more importantly now
->nr_threads is used in two places only.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 exec.c |   33 ++++++++++++++++-----------------
 1 files changed, 16 insertions(+), 17 deletions(-)

--- 26-rc2/fs/exec.c~3_NR_CLEANUP	2008-06-16 16:50:13.000000000 +0400
+++ 26-rc2/fs/exec.c	2008-07-06 17:43:14.000000000 +0400
@@ -1496,9 +1496,10 @@ out:
 	return ispipe;
 }
 
-static void zap_process(struct task_struct *start)
+static int zap_process(struct task_struct *start)
 {
 	struct task_struct *t;
+	int nr = 0;
 
 	start->signal->flags = SIGNAL_GROUP_EXIT;
 	start->signal->group_stop_count = 0;
@@ -1506,31 +1507,33 @@ static void zap_process(struct task_stru
 	t = start;
 	do {
 		if (t != current && t->mm) {
-			t->mm->core_state->nr_threads++;
 			sigaddset(&t->pending.signal, SIGKILL);
 			signal_wake_up(t, 1);
+			nr++;
 		}
 	} while_each_thread(start, t);
+
+	return nr;
 }
 
 static inline int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
-				int exit_code)
+				struct core_state *core_state, int exit_code)
 {
 	struct task_struct *g, *p;
 	unsigned long flags;
-	int err = -EAGAIN;
+	int nr = -EAGAIN;
 
 	spin_lock_irq(&tsk->sighand->siglock);
 	if (!signal_group_exit(tsk->signal)) {
+		mm->core_state = core_state;
 		tsk->signal->group_exit_code = exit_code;
-		zap_process(tsk);
-		err = 0;
+		nr = zap_process(tsk);
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
-	if (err)
-		return err;
+	if (unlikely(nr < 0))
+		return nr;
 
-	if (atomic_read(&mm->mm_users) == mm->core_state->nr_threads + 1)
+	if (atomic_read(&mm->mm_users) == nr + 1)
 		goto done;
 	/*
 	 * We should find and kill all tasks which use this mm, and we should
@@ -1574,7 +1577,7 @@ static inline int zap_threads(struct tas
 			if (p->mm) {
 				if (unlikely(p->mm == mm)) {
 					lock_task_sighand(p, &flags);
-					zap_process(p);
+					nr += zap_process(p);
 					unlock_task_sighand(p, &flags);
 				}
 				break;
@@ -1583,7 +1586,8 @@ static inline int zap_threads(struct tas
 	}
 	rcu_read_unlock();
 done:
-	return mm->core_state->nr_threads;
+	core_state->nr_threads = nr;
+	return nr;
 }
 
 static int coredump_wait(int exit_code)
@@ -1596,12 +1600,7 @@ static int coredump_wait(int exit_code)
 
 	init_completion(&mm->core_done);
 	init_completion(&core_state.startup);
-	core_state.nr_threads = 0;
-	mm->core_state = &core_state;
-
-	core_waiters = zap_threads(tsk, mm, exit_code);
-	if (core_waiters < 0)
-		mm->core_state = NULL;
+	core_waiters = zap_threads(tsk, mm, &core_state, exit_code);
 	up_write(&mm->mmap_sem);
 
 	if (unlikely(core_waiters < 0))

