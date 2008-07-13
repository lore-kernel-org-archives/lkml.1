Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYGMRUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYGMRUv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 13:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbYGMRTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 13:19:49 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51480 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbYGMRTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 13:19:47 -0400
Date: Sun, 13 Jul 2008 21:22:57 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] coredump: construct the list of coredumping threads at startup time
Message-ID: <20080713172257.GA28767@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

binfmt->core_dump() has to iterate over the all threads in system in order
to find the coredumping threads and construct the list using the GFP_ATOMIC
allocations.

With this patch each thread allocates the list node on exit_mm()'s stack and
adds itself to the list.

This allows us to do further changes:

	- simplify ->core_dump()

	- change exit_mm() to clear ->mm first, then wait for ->core_done.
	  this makes the coredumping process visible to oom_kill

	- kill mm->core_done

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/mm_types.h |    6 ++++++
 fs/exec.c                |    2 ++
 kernel/exit.c            |   15 ++++++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

--- 26-rc2/include/linux/mm_types.h~2_CORE_THREAD	2008-06-16 18:00:08.000000000 +0400
+++ 26-rc2/include/linux/mm_types.h	2008-07-13 18:28:36.000000000 +0400
@@ -159,8 +159,14 @@ struct vm_area_struct {
 #endif
 };
 
+struct core_thread {
+	struct task_struct *task;
+	struct core_thread *next;
+};
+
 struct core_state {
 	atomic_t nr_threads;
+	struct core_thread dumper;
 	struct completion startup;
 };
 
--- 26-rc2/fs/exec.c~2_CORE_THREAD	2008-07-13 17:47:28.000000000 +0400
+++ 26-rc2/fs/exec.c	2008-07-13 18:43:39.000000000 +0400
@@ -1599,6 +1599,8 @@ static int coredump_wait(int exit_code, 
 
 	init_completion(&mm->core_done);
 	init_completion(&core_state->startup);
+	core_state->dumper.task = tsk;
+	core_state->dumper.next = NULL;
 	core_waiters = zap_threads(tsk, mm, core_state, exit_code);
 	up_write(&mm->mmap_sem);
 
--- 26-rc2/kernel/exit.c~2_CORE_THREAD	2008-07-06 18:10:12.000000000 +0400
+++ 26-rc2/kernel/exit.c	2008-07-13 19:58:19.000000000 +0400
@@ -653,6 +653,7 @@ assign_new_owner:
 static void exit_mm(struct task_struct * tsk)
 {
 	struct mm_struct *mm = tsk->mm;
+	struct core_state *core_state;
 
 	mm_release(tsk, mm);
 	if (!mm)
@@ -665,11 +666,19 @@ static void exit_mm(struct task_struct *
 	 * group with ->mm != NULL.
 	 */
 	down_read(&mm->mmap_sem);
-	if (mm->core_state) {
+	core_state = mm->core_state;
+	if (core_state) {
+		struct core_thread self;
 		up_read(&mm->mmap_sem);
 
-		if (atomic_dec_and_test(&mm->core_state->nr_threads))
-			complete(&mm->core_state->startup);
+		self.task = tsk;
+		self.next = xchg(&core_state->dumper.next, &self);
+		/*
+		 * Implies mb(), the result of xchg() must be visible
+		 * to core_state->dumper.
+		 */
+		if (atomic_dec_and_test(&core_state->nr_threads))
+			complete(&core_state->startup);
 
 		wait_for_completion(&mm->core_done);
 		down_read(&mm->mmap_sem);

