Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbYF1NP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbYF1NP6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 09:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbYF1NOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 09:14:37 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:44597 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbYF1NOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 09:14:35 -0400
Date: Sat, 28 Jun 2008 17:17:16 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] coredump: turn mm->core_startup_done into the pointer to struct core_state
Message-ID: <20080628131716.GA4409@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm->core_startup_done points to "struct completion startup_done" allocated on
the coredump_wait()'s stack. Introduce the new structure, core_state, which
holds this "struct completion". This way we can add more info visible to the
threads participating in coredump without enlarging mm_struct.

No changes in affected .o files.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/mm_types.h |    7 ++++++-
 kernel/exit.c            |    2 +-
 fs/exec.c                |    8 ++++----
 3 files changed, 11 insertions(+), 6 deletions(-)

--- 26-rc2/include/linux/mm_types.h~1_MM_COREDUMP	2008-06-14 16:38:07.000000000 +0400
+++ 26-rc2/include/linux/mm_types.h	2008-06-15 14:23:40.000000000 +0400
@@ -159,6 +159,10 @@ struct vm_area_struct {
 #endif
 };
 
+struct core_state {
+	struct completion startup;
+};
+
 struct mm_struct {
 	struct vm_area_struct * mmap;		/* list of VMAs */
 	struct rb_root mm_rb;
@@ -220,7 +224,8 @@ struct mm_struct {
 	unsigned long flags; /* Must use atomic bitops to access the bits */
 
 	/* coredumping support */
-	struct completion *core_startup_done, core_done;
+	struct core_state *core_state;
+	struct completion core_done;
 
 	/* aio bits */
 	rwlock_t		ioctx_list_lock;	/* aio lock */
--- 26-rc2/kernel/exit.c~1_MM_COREDUMP	2008-05-31 20:08:11.000000000 +0400
+++ 26-rc2/kernel/exit.c	2008-06-15 14:24:35.000000000 +0400
@@ -669,7 +669,7 @@ static void exit_mm(struct task_struct *
 		up_read(&mm->mmap_sem);
 		down_write(&mm->mmap_sem);
 		if (!--mm->core_waiters)
-			complete(mm->core_startup_done);
+			complete(&mm->core_state->startup);
 		up_write(&mm->mmap_sem);
 
 		wait_for_completion(&mm->core_done);
--- 26-rc2/fs/exec.c~1_MM_COREDUMP	2008-06-14 15:57:27.000000000 +0400
+++ 26-rc2/fs/exec.c	2008-06-15 14:25:44.000000000 +0400
@@ -1592,13 +1592,13 @@ static int coredump_wait(int exit_code)
 {
 	struct task_struct *tsk = current;
 	struct mm_struct *mm = tsk->mm;
-	struct completion startup_done;
+	struct core_state core_state;
 	struct completion *vfork_done;
 	int core_waiters;
 
 	init_completion(&mm->core_done);
-	init_completion(&startup_done);
-	mm->core_startup_done = &startup_done;
+	init_completion(&core_state.startup);
+	mm->core_state = &core_state;
 
 	core_waiters = zap_threads(tsk, mm, exit_code);
 	up_write(&mm->mmap_sem);
@@ -1617,7 +1617,7 @@ static int coredump_wait(int exit_code)
 	}
 
 	if (core_waiters)
-		wait_for_completion(&startup_done);
+		wait_for_completion(&core_state.startup);
 fail:
 	BUG_ON(mm->core_waiters);
 	return core_waiters;

