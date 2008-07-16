Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbYGPRMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbYGPRMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 13:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYGPRM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 13:12:26 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:56187 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbYGPRM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 13:12:26 -0400
Date: Wed, 16 Jul 2008 21:15:38 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: PATCH? exit_mm: update the comments, move atomic_inc(mm_count) outside of mmap_sem
Message-ID: <20080716171538.GA3056@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(textually depends on
 "[PATCH 2/2] coredump: exit_mm: clear ->mm first, then play with ->core_state")

More the "is my understanding correct" than a patch. Assuming it is correct:

	- explain the subtle atomic_inc(&mm->mm_count).

	- move it outside of mm->mmap_sem, otherwise it is not clear why
	  do we need this lock to bump ->mm_count.

	- "fix" the comment above task_lock(). This lock is really needed
	  for get_task_mm/etc. Yes, we can change the code to use smp_mb()
	  + spin_unlock_wait() but I guess we also have another reason.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/kernel/exit.c~EXIT_MM	2008-07-15 20:24:50.000000000 +0400
+++ 26-rc2/kernel/exit.c	2008-07-16 20:59:34.000000000 +0400
@@ -680,6 +680,14 @@ static void exit_mm(struct task_struct *
 	mm_release(tsk, mm);
 	if (!mm)
 		return;
+
+	/*
+	 * We are going to clear ->mm. The next schedule() after that
+	 * will assume we did context_switch()->atomic_inc(mm_count).
+	 * finish_task_switch()->mmdrop() will "fix" the counter.
+	 */
+	atomic_inc(&mm->mm_count);
+	BUG_ON(mm != tsk->active_mm);
 	/*
 	 * Serialize with any possible pending coredump.
 	 * We must hold mmap_sem around checking core_state
@@ -689,9 +697,7 @@ static void exit_mm(struct task_struct *
 	 */
 	down_read(&mm->mmap_sem);
 	core_state = mm->core_state;
-	atomic_inc(&mm->mm_count);
-	BUG_ON(mm != tsk->active_mm);
-	/* more a memory barrier than a real lock */
+	/* disables preemption, we must not schedule before enter_lazy_tlb() */
 	task_lock(tsk);
 	tsk->mm = NULL;
 	up_read(&mm->mmap_sem);

