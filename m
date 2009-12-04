Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbZLDNws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbZLDNws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 08:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbZLDNwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 08:52:44 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:43856 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160AbZLDNwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 08:52:41 -0500
From: Louis Rilling <louis.rilling@kerlabs.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Louis Rilling <louis.rilling@kerlabs.com>
Subject: [PATCH 2/2] block: Fix io_context leak after failure of clone with CLONE_IO
Date: Fri,  4 Dec 2009 14:52:42 +0100
Message-Id: <1259934762-16920-3-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1259934762-16920-1-git-send-email-louis.rilling@kerlabs.com>
References: <1259934762-16920-1-git-send-email-louis.rilling@kerlabs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CLONE_IO, parent's io_context->nr_tasks is incremented, but never
decremented whenever copy_process() fails afterwards, which prevents
exit_io_context() from calling IO schedulers exit functions.

Give a task_struct to exit_io_context(), and call exit_io_context() instead of
put_io_context() in copy_process() cleanup path.

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 block/blk-ioc.c           |   10 +++++-----
 include/linux/iocontext.h |    5 +++--
 kernel/exit.c             |    2 +-
 kernel/fork.c             |    3 ++-
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index dcd0412..cbdabb0 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -66,14 +66,14 @@ static void cfq_exit(struct io_context *ioc)
 }
 
 /* Called by the exitting task */
-void exit_io_context(void)
+void exit_io_context(struct task_struct *task)
 {
 	struct io_context *ioc;
 
-	task_lock(current);
-	ioc = current->io_context;
-	current->io_context = NULL;
-	task_unlock(current);
+	task_lock(task);
+	ioc = task->io_context;
+	task->io_context = NULL;
+	task_unlock(task);
 
 	if (atomic_dec_and_test(&ioc->nr_tasks)) {
 		if (ioc->aic && ioc->aic->exit)
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index 4da4a75..80a4b53 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -99,14 +99,15 @@ static inline struct io_context *ioc_task_link(struct io_context *ioc)
 	return NULL;
 }
 
+struct task_struct;
 #ifdef CONFIG_BLOCK
 int put_io_context(struct io_context *ioc);
-void exit_io_context(void);
+void exit_io_context(struct task_struct *task);
 struct io_context *get_io_context(gfp_t gfp_flags, int node);
 struct io_context *alloc_io_context(gfp_t gfp_flags, int node);
 void copy_io_context(struct io_context **pdst, struct io_context **psrc);
 #else
-static inline void exit_io_context(void)
+static inline void exit_io_context(struct task_struct *task)
 {
 }
 
diff --git a/kernel/exit.c b/kernel/exit.c
index f7864ac..2544000 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1004,7 +1004,7 @@ NORET_TYPE void do_exit(long code)
 	tsk->flags |= PF_EXITPIDONE;
 
 	if (tsk->io_context)
-		exit_io_context();
+		exit_io_context(tsk);
 
 	if (tsk->splice_pipe)
 		__free_pipe_info(tsk->splice_pipe);
diff --git a/kernel/fork.c b/kernel/fork.c
index 166b8c4..6073534 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1310,7 +1310,8 @@ bad_fork_free_pid:
 	if (pid != &init_struct_pid)
 		free_pid(pid);
 bad_fork_cleanup_io:
-	put_io_context(p->io_context);
+	if (p->io_context)
+		exit_io_context(p);
 bad_fork_cleanup_namespaces:
 	exit_task_namespaces(p);
 bad_fork_cleanup_mm:
-- 
1.5.6.5

