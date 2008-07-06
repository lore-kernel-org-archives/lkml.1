Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbYGFPUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbYGFPUv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 11:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbYGFPTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 11:19:53 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:48120 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758234AbYGFPTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 11:19:51 -0400
Date: Sun, 6 Jul 2008 19:22:22 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] coredump: move mm->core_waiters into struct core_state
Message-ID: <20080706152222.GA2819@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move mm->core_waiters into "struct core_state" allocated on stack. This
shrinks mm_struct a little bit and allows further changes.

This patch mostly does s/core_waiters/core_state. The only essential
change is that coredump_wait() must clear mm->core_state before return.

The coredump_wait()'s path is uglified and .text grows by 30 bytes, this
is fixed by the next patch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/mm_types.h |    2 +-
 kernel/fork.c            |    2 +-
 kernel/signal.c          |    4 ++--
 kernel/exit.c            |    8 ++++----
 fs/exec.c                |   21 +++++++++++----------
 5 files changed, 19 insertions(+), 18 deletions(-)

--- 26-rc2/include/linux/mm_types.h~2_CORE_WAITERS	2008-06-15 14:23:40.000000000 +0400
+++ 26-rc2/include/linux/mm_types.h	2008-06-15 15:26:29.000000000 +0400
@@ -160,6 +160,7 @@ struct vm_area_struct {
 };
 
 struct core_state {
+	int nr_threads;
 	struct completion startup;
 };
 
@@ -179,7 +180,6 @@ struct mm_struct {
 	atomic_t mm_users;			/* How many users with user space? */
 	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
 	int map_count;				/* number of VMAs */
-	int core_waiters;
 	struct rw_semaphore mmap_sem;
 	spinlock_t page_table_lock;		/* Protects page tables and some counters */
 
--- 26-rc2/kernel/fork.c~2_CORE_WAITERS	2008-06-01 16:44:39.000000000 +0400
+++ 26-rc2/kernel/fork.c	2008-06-15 15:32:10.000000000 +0400
@@ -373,7 +373,7 @@ static struct mm_struct * mm_init(struct
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->flags = (current->mm) ? current->mm->flags
 				  : MMF_DUMP_FILTER_DEFAULT;
-	mm->core_waiters = 0;
+	mm->core_state = NULL;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);
 	set_mm_counter(mm, anon_rss, 0);
--- 26-rc2/kernel/signal.c~	2008-06-28 16:06:07.000000000 +0400
+++ 26-rc2/kernel/signal.c	2008-06-28 17:06:58.000000000 +0400
@@ -1482,10 +1482,10 @@ static inline int may_ptrace_stop(void)
 	 * is a deadlock situation, and pointless because our tracer
 	 * is dead so don't allow us to stop.
 	 * If SIGKILL was already sent before the caller unlocked
-	 * ->siglock we must see ->core_waiters != 0. Otherwise it
+	 * ->siglock we must see ->core_state != NULL. Otherwise it
 	 * is safe to enter schedule().
 	 */
-	if (unlikely(current->mm->core_waiters) &&
+	if (unlikely(current->mm->core_state) &&
 	    unlikely(current->mm == current->parent->mm))
 		return 0;
 
--- 26-rc2/kernel/exit.c~2_CORE_WAITERS	2008-06-15 14:24:35.000000000 +0400
+++ 26-rc2/kernel/exit.c	2008-06-15 15:28:21.000000000 +0400
@@ -659,16 +659,16 @@ static void exit_mm(struct task_struct *
 		return;
 	/*
 	 * Serialize with any possible pending coredump.
-	 * We must hold mmap_sem around checking core_waiters
+	 * We must hold mmap_sem around checking core_state
 	 * and clearing tsk->mm.  The core-inducing thread
-	 * will increment core_waiters for each thread in the
+	 * will increment ->nr_threads for each thread in the
 	 * group with ->mm != NULL.
 	 */
 	down_read(&mm->mmap_sem);
-	if (mm->core_waiters) {
+	if (mm->core_state) {
 		up_read(&mm->mmap_sem);
 		down_write(&mm->mmap_sem);
-		if (!--mm->core_waiters)
+		if (!--mm->core_state->nr_threads)
 			complete(&mm->core_state->startup);
 		up_write(&mm->mmap_sem);
 
--- 26-rc2/fs/exec.c~2_CORE_WAITERS	2008-06-15 14:25:44.000000000 +0400
+++ 26-rc2/fs/exec.c	2008-06-16 16:50:13.000000000 +0400
@@ -720,12 +720,10 @@ static int exec_mmap(struct mm_struct *m
 		 * Make sure that if there is a core dump in progress
 		 * for the old mm, we get out and die instead of going
 		 * through with the exec.  We must hold mmap_sem around
-		 * checking core_waiters and changing tsk->mm.  The
-		 * core-inducing thread will increment core_waiters for
-		 * each thread whose ->mm == old_mm.
+		 * checking core_state and changing tsk->mm.
 		 */
 		down_read(&old_mm->mmap_sem);
-		if (unlikely(old_mm->core_waiters)) {
+		if (unlikely(old_mm->core_state)) {
 			up_read(&old_mm->mmap_sem);
 			return -EINTR;
 		}
@@ -1508,7 +1506,7 @@ static void zap_process(struct task_stru
 	t = start;
 	do {
 		if (t != current && t->mm) {
-			t->mm->core_waiters++;
+			t->mm->core_state->nr_threads++;
 			sigaddset(&t->pending.signal, SIGKILL);
 			signal_wake_up(t, 1);
 		}
@@ -1532,11 +1530,11 @@ static inline int zap_threads(struct tas
 	if (err)
 		return err;
 
-	if (atomic_read(&mm->mm_users) == mm->core_waiters + 1)
+	if (atomic_read(&mm->mm_users) == mm->core_state->nr_threads + 1)
 		goto done;
 	/*
 	 * We should find and kill all tasks which use this mm, and we should
-	 * count them correctly into mm->core_waiters. We don't take tasklist
+	 * count them correctly into ->nr_threads. We don't take tasklist
 	 * lock, but this is safe wrt:
 	 *
 	 * fork:
@@ -1585,7 +1583,7 @@ static inline int zap_threads(struct tas
 	}
 	rcu_read_unlock();
 done:
-	return mm->core_waiters;
+	return mm->core_state->nr_threads;
 }
 
 static int coredump_wait(int exit_code)
@@ -1598,9 +1596,12 @@ static int coredump_wait(int exit_code)
 
 	init_completion(&mm->core_done);
 	init_completion(&core_state.startup);
+	core_state.nr_threads = 0;
 	mm->core_state = &core_state;
 
 	core_waiters = zap_threads(tsk, mm, exit_code);
+	if (core_waiters < 0)
+		mm->core_state = NULL;
 	up_write(&mm->mmap_sem);
 
 	if (unlikely(core_waiters < 0))
@@ -1618,8 +1619,8 @@ static int coredump_wait(int exit_code)
 
 	if (core_waiters)
 		wait_for_completion(&core_state.startup);
+	mm->core_state = NULL;
 fail:
-	BUG_ON(mm->core_waiters);
 	return core_waiters;
 }
 
@@ -1697,7 +1698,7 @@ int do_coredump(long signr, int exit_cod
 	/*
 	 * If another thread got here first, or we are not dumpable, bail out.
 	 */
-	if (mm->core_waiters || !get_dumpable(mm)) {
+	if (mm->core_state || !get_dumpable(mm)) {
 		up_write(&mm->mmap_sem);
 		goto fail;
 	}

