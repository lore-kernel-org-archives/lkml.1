Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbYJQXPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbYJQXPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 19:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757668AbYJQXL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 19:11:57 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:45070 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757564AbYJQXL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 19:11:56 -0400
From: Andrey Mirkin <major@openvz.org>
To: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Pavel Emelyanov <xemul@openvz.org>, Andrey Mirkin <major@openvz.org>
Subject: [PATCH 10/10] Add support for multiple processes
Date: Sat, 18 Oct 2008 03:11:38 +0400
Message-Id: <1224285098-573-11-git-send-email-major@openvz.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1224285098-573-10-git-send-email-major@openvz.org>
References: <1224285098-573-1-git-send-email-major@openvz.org>
 <1224285098-573-2-git-send-email-major@openvz.org>
 <1224285098-573-3-git-send-email-major@openvz.org>
 <1224285098-573-4-git-send-email-major@openvz.org>
 <1224285098-573-5-git-send-email-major@openvz.org>
 <1224285098-573-6-git-send-email-major@openvz.org>
 <1224285098-573-7-git-send-email-major@openvz.org>
 <1224285098-573-8-git-send-email-major@openvz.org>
 <1224285098-573-9-git-send-email-major@openvz.org>
 <1224285098-573-10-git-send-email-major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The whole tree of processes can be checkpointed and restarted now.
Shared objects are not supported yet.

Signed-off-by: Andrey Mirkin <major@openvz.org>
---
 checkpoint/cpt_image.h   |    2 +
 checkpoint/cpt_process.c |   24 +++++++++++++
 checkpoint/rst_process.c |   85 +++++++++++++++++++++++++++-------------------
 3 files changed, 76 insertions(+), 35 deletions(-)

diff --git a/checkpoint/cpt_image.h b/checkpoint/cpt_image.h
index e1fb483..f370df2 100644
--- a/checkpoint/cpt_image.h
+++ b/checkpoint/cpt_image.h
@@ -128,6 +128,8 @@ struct cpt_task_image {
 	__u64	cpt_nivcsw;
 	__u64	cpt_min_flt;
 	__u64	cpt_maj_flt;
+	__u32	cpt_children_num;
+	__u32	cpt_pad;
 } __attribute__ ((aligned (8)));
 
 struct cpt_mm_image {
diff --git a/checkpoint/cpt_process.c b/checkpoint/cpt_process.c
index 1f7a54b..d73ec3c 100644
--- a/checkpoint/cpt_process.c
+++ b/checkpoint/cpt_process.c
@@ -40,6 +40,19 @@ static unsigned int encode_task_flags(unsigned int task_flags)
 		
 }
 
+static int cpt_count_children(struct task_struct *tsk, struct cpt_context *ctx)
+{
+	int num = 0;
+	struct task_struct *child;
+
+	list_for_each_entry(child, &tsk->children, sibling) {
+		if (child->parent != tsk)
+			continue;
+		num++;
+	}
+	return num;
+}
+
 int cpt_dump_task_struct(struct task_struct *tsk, struct cpt_context *ctx)
 {
 	struct cpt_task_image *t;
@@ -102,6 +115,7 @@ int cpt_dump_task_struct(struct task_struct *tsk, struct cpt_context *ctx)
 	t->cpt_egid = tsk->egid;
 	t->cpt_sgid = tsk->sgid;
 	t->cpt_fsgid = tsk->fsgid;
+	t->cpt_children_num = cpt_count_children(tsk, ctx);
 
 	err = ctx->write(t, sizeof(*t), ctx);
 
@@ -231,6 +245,16 @@ int cpt_dump_task(struct task_struct *tsk, struct cpt_context *ctx)
 		err = cpt_dump_fpustate(tsk, ctx);
 	if (!err)
 		err = cpt_dump_registers(tsk, ctx);
+	if (!err) {
+		struct task_struct *child;
+		list_for_each_entry(child, &tsk->children, sibling) {
+			if (child->parent != tsk)
+				continue;
+			err = cpt_dump_task(child, ctx);
+			if (err)
+				break;
+		}
+	}
 
 	return err;
 }
diff --git a/checkpoint/rst_process.c b/checkpoint/rst_process.c
index 9e448b2..c088833 100644
--- a/checkpoint/rst_process.c
+++ b/checkpoint/rst_process.c
@@ -25,7 +25,7 @@ struct thr_context {
 	struct completion complete;
 	int error;
 	struct cpt_context *ctx;
-	struct task_struct *tsk;
+	struct cpt_task_image *ti;
 };
 
 int local_kernel_thread(int (*fn)(void *), void * arg, unsigned long flags, pid_t pid)
@@ -199,17 +199,14 @@ static int restart_thread(void *arg)
 	struct cpt_context *ctx;
 	struct cpt_task_image *ti;
 	int err;
+	int i;
 
 	current->state = TASK_UNINTERRUPTIBLE;
 
 	ctx = thr_ctx->ctx;
-	ti = kmalloc(sizeof(*ti), GFP_KERNEL);
-	if (!ti)
-		return -ENOMEM;
+	ti = thr_ctx->ti;
 
-	err = rst_get_object(CPT_OBJ_TASK, ti, sizeof(*ti), ctx);
-	if (!err)
-		err = rst_restore_task_struct(current, ti, ctx);
+	err = rst_restore_task_struct(current, ti, ctx);
 	if (!err)
 		err = rst_restore_mm(ctx);
 	if (!err)
@@ -217,6 +214,12 @@ static int restart_thread(void *arg)
 	if (!err)
 		err = rst_restore_registers(current, ctx);
 
+	for (i = 0; i < ti->cpt_children_num; i++) {
+		err = rst_restart_process(ctx);
+		if (err)
+			break;
+	}
+
 	thr_ctx->error = err;
 	complete(&thr_ctx->complete);
 
@@ -226,7 +229,6 @@ static int restart_thread(void *arg)
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 	}
 
-	kfree(ti);
 	schedule();
 
 	eprintk("leaked %d/%d %p\n", task_pid_nr(current), task_pid_vnr(current), current->mm);
@@ -235,44 +237,57 @@ static int restart_thread(void *arg)
 	complete_and_exit(NULL, 0);
 	return 0;
 }
-static int create_root_task(struct cpt_context *ctx,
-			    struct thr_context *thr_ctx)
+
+int rst_restart_process(struct cpt_context *ctx)
 {
+	struct thr_context thr_ctx;
 	struct task_struct *tsk;
+	struct cpt_task_image *ti;
 	int pid;
+	int err;
 
-	thr_ctx->ctx = ctx;
-	thr_ctx->error = 0;
-	init_completion(&thr_ctx->complete);
+	thr_ctx.ctx = ctx;
+	thr_ctx.error = 0;
+	init_completion(&thr_ctx.complete);
 
-	/* We should also create container here */ 
-	pid = local_kernel_thread(restart_thread, thr_ctx,
-			CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC | 
-			CLONE_NEWUSER | CLONE_NEWPID | CLONE_NEWNET, 0);
-	if (pid < 0)
-		return pid;
+	ti = kmalloc(sizeof(*ti), GFP_KERNEL);
+	if (!ti)
+		return -ENOMEM;
+
+	err = rst_get_object(CPT_OBJ_TASK, ti, sizeof(*ti), ctx);
+	if (err)
+		goto err_free;
+	thr_ctx.ti = ti;
+
+	if (ti->cpt_pid == 1) {
+		/* We should also create container here */ 
+		pid = local_kernel_thread(restart_thread, &thr_ctx,
+				CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC | 
+				CLONE_NEWUSER | CLONE_NEWPID | CLONE_NEWNET, 0);
+	} else {
+		/* We should fork here a child with the same pid and
+		   correct flags */
+		pid = local_kernel_thread(restart_thread, &thr_ctx, 0, 0); 
+	}
+	if (pid < 0) {
+		err = pid;
+		goto err_free;
+	}
 	read_lock(&tasklist_lock);
 	tsk = find_task_by_vpid(pid);
 	if (tsk)
 		get_task_struct(tsk);
 	read_unlock(&tasklist_lock);
-	if (tsk == NULL)
-		return -ESRCH;
-	thr_ctx->tsk = tsk;
-	return 0;
-}
-
-int rst_restart_process(struct cpt_context *ctx)
-{
-	struct thr_context thr_ctx_root;
-	int err;
-
-	err = create_root_task(ctx, &thr_ctx_root);
-	if (err)
-		return err;
+	if (tsk == NULL) {
+		err = -ESRCH;
+		goto err_free;
+	}
 
-	wait_for_completion(&thr_ctx_root.complete);
-	wait_task_inactive(thr_ctx_root.tsk, 0);
+	wait_for_completion(&thr_ctx.complete);
+	wait_task_inactive(tsk, 0);
+	err = thr_ctx.error;
 
+err_free:
+	kfree(ti);
 	return err;
 }
-- 
1.5.6

