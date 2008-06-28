Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbYF1NPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbYF1NPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 09:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYF1NOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 09:14:36 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:44592 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbYF1NOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 09:14:34 -0400
Date: Sat, 28 Jun 2008 17:17:18 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] coredump: turn core_state->nr_threads into atomic_t
Message-ID: <20080628131718.GA4418@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn core_state->nr_threads into atomic_t and kill now unneeded
down_write(&mm->mmap_sem) in exit_mm().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 include/linux/mm_types.h |    2 +-
 kernel/exit.c            |    5 ++---
 fs/exec.c                |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

--- 26-rc2/include/linux/mm_types.h~4_NR_ATOMIC	2008-06-15 15:26:29.000000000 +0400
+++ 26-rc2/include/linux/mm_types.h	2008-06-16 18:00:08.000000000 +0400
@@ -160,7 +160,7 @@ struct vm_area_struct {
 };
 
 struct core_state {
-	int nr_threads;
+	atomic_t nr_threads;
 	struct completion startup;
 };
 
--- 26-rc2/kernel/exit.c~4_NR_ATOMIC	2008-06-15 15:28:21.000000000 +0400
+++ 26-rc2/kernel/exit.c	2008-06-16 19:58:59.000000000 +0400
@@ -667,10 +667,9 @@ static void exit_mm(struct task_struct *
 	down_read(&mm->mmap_sem);
 	if (mm->core_state) {
 		up_read(&mm->mmap_sem);
-		down_write(&mm->mmap_sem);
-		if (!--mm->core_state->nr_threads)
+
+		if (atomic_dec_and_test(&mm->core_state->nr_threads))
 			complete(&mm->core_state->startup);
-		up_write(&mm->mmap_sem);
 
 		wait_for_completion(&mm->core_done);
 		down_read(&mm->mmap_sem);
--- 26-rc2/fs/exec.c~4_NR_ATOMIC	2008-06-16 17:23:59.000000000 +0400
+++ 26-rc2/fs/exec.c	2008-06-16 19:59:26.000000000 +0400
@@ -1585,7 +1585,7 @@ static inline int zap_threads(struct tas
 	}
 	rcu_read_unlock();
 done:
-	core_state->nr_threads = nr;
+	atomic_set(&core_state->nr_threads, nr);
 	mm->core_state = core_state;
 	return nr;
 }

