Return-Path: <linux-kernel-owner+w=401wt.eu-S1759668AbYGOOEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668AbYGOOEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbYGOOED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:04:03 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:47987 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbYGOOEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:04:01 -0400
Date: Tue, 15 Jul 2008 18:07:15 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] coredump: kill mm->core_done
Message-ID: <20080715140715.GA25824@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have core_state->dumper list we can use it to wake up the
sub-threads waiting for the coredump completion.

This uglifies the code and .text grows by 47 bytes, but otoh mm_struct
lessens by sizeof(struct completion). Also, with this change we can
decouple exit_mm() from the coredumping code.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/mm_types.h |    4 +---
 kernel/exit.c            |    8 +++++++-
 fs/exec.c                |   25 ++++++++++++++++++++++---
 3 files changed, 30 insertions(+), 7 deletions(-)

--- 26-rc2/include/linux/mm_types.h~5_KILL_CORE_DONE	2008-07-13 18:28:36.000000000 +0400
+++ 26-rc2/include/linux/mm_types.h	2008-07-15 17:06:58.000000000 +0400
@@ -229,9 +229,7 @@ struct mm_struct {
 
 	unsigned long flags; /* Must use atomic bitops to access the bits */
 
-	/* coredumping support */
-	struct core_state *core_state;
-	struct completion core_done;
+	struct core_state *core_state; /* coredumping support */
 
 	/* aio bits */
 	rwlock_t		ioctx_list_lock;	/* aio lock */
--- 26-rc2/kernel/exit.c~5_KILL_CORE_DONE	2008-07-13 19:58:19.000000000 +0400
+++ 26-rc2/kernel/exit.c	2008-07-15 17:06:58.000000000 +0400
@@ -680,7 +680,13 @@ static void exit_mm(struct task_struct *
 		if (atomic_dec_and_test(&core_state->nr_threads))
 			complete(&core_state->startup);
 
-		wait_for_completion(&mm->core_done);
+		for (;;) {
+			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+			if (!self.task) /* see coredump_finish() */
+				break;
+			schedule();
+		}
+		__set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 		down_read(&mm->mmap_sem);
 	}
 	atomic_inc(&mm->mm_count);
--- 26-rc2/fs/exec.c~5_KILL_CORE_DONE	2008-07-13 18:43:39.000000000 +0400
+++ 26-rc2/fs/exec.c	2008-07-15 17:54:45.000000000 +0400
@@ -1597,7 +1597,6 @@ static int coredump_wait(int exit_code, 
 	struct completion *vfork_done;
 	int core_waiters;
 
-	init_completion(&mm->core_done);
 	init_completion(&core_state->startup);
 	core_state->dumper.task = tsk;
 	core_state->dumper.next = NULL;
@@ -1623,6 +1622,27 @@ fail:
 	return core_waiters;
 }
 
+static void coredump_finish(struct mm_struct *mm)
+{
+	struct core_thread *curr, *next;
+	struct task_struct *task;
+
+	next = mm->core_state->dumper.next;
+	while ((curr = next) != NULL) {
+		next = curr->next;
+		task = curr->task;
+		/*
+		 * see exit_mm(), curr->task must not see
+		 * ->task == NULL before we read ->next.
+		 */
+		smp_mb();
+		curr->task = NULL;
+		wake_up_process(task);
+	}
+
+	mm->core_state = NULL;
+}
+
 /*
  * set_dumpable converts traditional three-value dumpable to two flags and
  * stores them into mm->flags.  It modifies lower two bits of mm->flags, but
@@ -1807,8 +1827,7 @@ fail_unlock:
 		argv_free(helper_argv);
 
 	current->fsuid = fsuid;
-	complete_all(&mm->core_done);
-	mm->core_state = NULL;
+	coredump_finish(mm);
 fail:
 	return retval;
 }

