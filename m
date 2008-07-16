Return-Path: <linux-kernel-owner+w=401wt.eu-S1759064AbYGPNva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064AbYGPNva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758668AbYGPNul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:50:41 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58689 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758552AbYGPNui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:50:38 -0400
Date: Wed, 16 Jul 2008 17:53:59 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] coredump: exit_mm: clear ->mm first, then play with ->core_state
Message-ID: <20080716135359.GA1219@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the previous changes the sub-threads which participate in coredump do
not need to have the valid ->mm when the coredump is in progress, now we
can decouple exit_mm() from coredumping code.

Change exit_mm() to clear ->mm first, then play with mm->core_state. This
simplifies the code because we can avoid unlock/lock games with ->mmap_sem,
and more importantly this makes the coredumping process visible to oom_kill.
Currently the PF_EXITING task can sleep with ->mm != NULL "unpredictably"
long.

The patch moves the coredumping code to the new function for the readability.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 kernel/exit.c |   47 +++++++++++++++++++++++++----------------------
 fs/exec.c     |    4 ++--
 2 files changed, 27 insertions(+), 24 deletions(-)

--- 26-rc2/kernel/exit.c~7_CLEAR_MM_FIRST	2008-07-15 20:25:48.000000000 +0400
+++ 26-rc2/kernel/exit.c	2008-07-15 20:24:50.000000000 +0400
@@ -646,6 +646,28 @@ assign_new_owner:
 }
 #endif /* CONFIG_MM_OWNER */
 
+static void exit_coredump(struct task_struct * tsk,
+				struct core_state *core_state)
+{
+	struct core_thread self;
+
+	self.task = tsk;
+	self.next = xchg(&core_state->dumper.next, &self);
+	/*
+	 * Implies mb(), the result of xchg() must be visible
+	 * to core_state->dumper.
+	 */
+	if (atomic_dec_and_test(&core_state->nr_threads))
+		complete(&core_state->startup);
+
+	for (;;) {
+		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		if (!self.task) /* see coredump_finish() */
+			break;
+		schedule();
+	}
+	__set_task_state(tsk, TASK_RUNNING);
+}
 /*
  * Turn us into a lazy TLB process if we
  * aren't already..
@@ -667,28 +689,6 @@ static void exit_mm(struct task_struct *
 	 */
 	down_read(&mm->mmap_sem);
 	core_state = mm->core_state;
-	if (core_state) {
-		struct core_thread self;
-		up_read(&mm->mmap_sem);
-
-		self.task = tsk;
-		self.next = xchg(&core_state->dumper.next, &self);
-		/*
-		 * Implies mb(), the result of xchg() must be visible
-		 * to core_state->dumper.
-		 */
-		if (atomic_dec_and_test(&core_state->nr_threads))
-			complete(&core_state->startup);
-
-		for (;;) {
-			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-			if (!self.task) /* see coredump_finish() */
-				break;
-			schedule();
-		}
-		__set_task_state(tsk, TASK_RUNNING);
-		down_read(&mm->mmap_sem);
-	}
 	atomic_inc(&mm->mm_count);
 	BUG_ON(mm != tsk->active_mm);
 	/* more a memory barrier than a real lock */
@@ -701,6 +701,9 @@ static void exit_mm(struct task_struct *
 	task_unlock(tsk);
 	mm_update_next_owner(mm);
 	mmput(mm);
+
+	if (core_state)
+		exit_coredump(tsk, core_state);
 }
 
 static void
--- 26-rc2/fs/exec.c~7_CLEAR_MM_FIRST	2008-07-15 17:54:45.000000000 +0400
+++ 26-rc2/fs/exec.c	2008-07-15 20:24:50.000000000 +0400
@@ -1632,8 +1632,8 @@ static void coredump_finish(struct mm_st
 		next = curr->next;
 		task = curr->task;
 		/*
-		 * see exit_mm(), curr->task must not see
-		 * ->task == NULL before we read ->next.
+		 * see exit_coredump(), curr->task must not
+		 * see ->task == NULL before we read ->next.
 		 */
 		smp_mb();
 		curr->task = NULL;

