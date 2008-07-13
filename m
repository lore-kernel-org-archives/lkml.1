Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbYGMRT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbYGMRT4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 13:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYGMRTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 13:19:47 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51478 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbYGMRTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 13:19:46 -0400
Date: Sun, 13 Jul 2008 21:22:56 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] coredump: make mm->core_state visible to ->core_dump()
Message-ID: <20080713172256.GA28764@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the "struct core_state core_state" from coredump_wait() to do_coredump(),
this makes mm->core_state visible to binfmt->core_dump().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 exec.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

--- 26-rc2/fs/exec.c~1_CS_MOVE	2008-07-06 18:12:33.000000000 +0400
+++ 26-rc2/fs/exec.c	2008-07-13 17:47:28.000000000 +0400
@@ -1590,17 +1590,16 @@ done:
 	return nr;
 }
 
-static int coredump_wait(int exit_code)
+static int coredump_wait(int exit_code, struct core_state *core_state)
 {
 	struct task_struct *tsk = current;
 	struct mm_struct *mm = tsk->mm;
-	struct core_state core_state;
 	struct completion *vfork_done;
 	int core_waiters;
 
 	init_completion(&mm->core_done);
-	init_completion(&core_state.startup);
-	core_waiters = zap_threads(tsk, mm, &core_state, exit_code);
+	init_completion(&core_state->startup);
+	core_waiters = zap_threads(tsk, mm, core_state, exit_code);
 	up_write(&mm->mmap_sem);
 
 	if (unlikely(core_waiters < 0))
@@ -1617,8 +1616,7 @@ static int coredump_wait(int exit_code)
 	}
 
 	if (core_waiters)
-		wait_for_completion(&core_state.startup);
-	mm->core_state = NULL;
+		wait_for_completion(&core_state->startup);
 fail:
 	return core_waiters;
 }
@@ -1674,6 +1672,7 @@ int get_dumpable(struct mm_struct *mm)
 
 int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 {
+	struct core_state core_state;
 	char corename[CORENAME_MAX_SIZE + 1];
 	struct mm_struct *mm = current->mm;
 	struct linux_binfmt * binfmt;
@@ -1712,7 +1711,7 @@ int do_coredump(long signr, int exit_cod
 		current->fsuid = 0;	/* Dump root private */
 	}
 
-	retval = coredump_wait(exit_code);
+	retval = coredump_wait(exit_code, &core_state);
 	if (retval < 0)
 		goto fail;
 
@@ -1807,6 +1806,7 @@ fail_unlock:
 
 	current->fsuid = fsuid;
 	complete_all(&mm->core_done);
+	mm->core_state = NULL;
 fail:
 	return retval;
 }

