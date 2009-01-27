Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbZA0RJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbZA0RJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 12:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZA0RJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 12:09:14 -0500
Received: from serrano.cc.columbia.edu ([128.59.29.6]:57602 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZA0RJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 12:09:13 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Serge Hallyn <serue@us.ibm.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: [RFC v13][PATCH 11/14] External checkpoint of a task other than ourself
Date: Tue, 27 Jan 2009 12:08:09 -0500
Message-Id: <1233076092-8660-12-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we can do "external" checkpoint, i.e. act on another task.

sys_checkpoint() now looks up the target pid (in our namespace) and
checkpoints that corresponding task. That task should be the root of
a container.

sys_restart() remains the same, as the restart is always done in the
context of the restarting task.

Changelog[v12]:
  - Replace obsolete cr_debug() with pr_debug()

Changelog[v11]:
  - Copy contents of 'init->fs->root' instead of pointing to them

Changelog[v10]:
  - Grab vfs root of container init, rather than current process

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 checkpoint/checkpoint.c    |   72 ++++++++++++++++++++++++++++++++++++++++++-
 checkpoint/restart.c       |    4 +-
 checkpoint/sys.c           |    6 ++++
 include/linux/checkpoint.h |    2 +
 4 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/checkpoint/checkpoint.c b/checkpoint/checkpoint.c
index dd0f527..e0af8a2 100644
--- a/checkpoint/checkpoint.c
+++ b/checkpoint/checkpoint.c
@@ -10,6 +10,7 @@
 
 #include <linux/version.h>
 #include <linux/sched.h>
+#include <linux/ptrace.h>
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/file.h>
@@ -225,6 +226,13 @@ static int cr_write_task(struct cr_ctx *ctx, struct task_struct *t)
 {
 	int ret;
 
+	/* TODO: verity that the task is frozen (unless self) */
+
+	if (t->state == TASK_DEAD) {
+		pr_warning("c/r: task may not be in state TASK_DEAD\n");
+		return -EAGAIN;
+	}
+
 	ret = cr_write_task_struct(ctx, t);
 	pr_debug("task_struct: ret %d\n", ret);
 	if (ret < 0)
@@ -247,22 +255,82 @@ static int cr_write_task(struct cr_ctx *ctx, struct task_struct *t)
 	return ret;
 }
 
+static int cr_get_container(struct cr_ctx *ctx, pid_t pid)
+{
+	struct task_struct *task = NULL;
+	struct nsproxy *nsproxy = NULL;
+	int err = -ESRCH;
+
+	ctx->root_pid = pid;
+
+	read_lock(&tasklist_lock);
+	task = find_task_by_vpid(pid);
+	if (task)
+		get_task_struct(task);
+	read_unlock(&tasklist_lock);
+
+	if (!task)
+		goto out;
+
+#if 0	/* enable to use containers */
+	if (!is_container_init(task)) {
+		err = -EINVAL;
+		goto out;
+	}
+#endif
+
+	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
+		err = -EPERM;
+		goto out;
+	}
+
+	rcu_read_lock();
+	if (task_nsproxy(task)) {
+		nsproxy = task_nsproxy(task);
+		get_nsproxy(nsproxy);
+	}
+	rcu_read_unlock();
+
+	if (!nsproxy)
+		goto out;
+
+	/* TODO: verify that the container is frozen */
+
+	ctx->root_task = task;
+	ctx->root_nsproxy = nsproxy;
+
+	return 0;
+
+ out:
+	if (task)
+		put_task_struct(task);
+	return err;
+}
+
+/* setup checkpoint-specific parts of ctx */
 static int cr_ctx_checkpoint(struct cr_ctx *ctx, pid_t pid)
 {
 	struct fs_struct *fs;
+	int ret;
 
 	ctx->root_pid = pid;
 
+	ret = cr_get_container(ctx, pid);
+	if (ret < 0)
+		return ret;
+
 	/*
 	 * assume checkpointer is in container's root vfs
 	 * FIXME: this works for now, but will change with real containers
 	 */
 
-	fs = current->fs;
+	task_lock(ctx->root_task);
+	fs = ctx->root_task->fs;
 	read_lock(&fs->lock);
 	ctx->fs_mnt = fs->root;
 	path_get(&ctx->fs_mnt);
 	read_unlock(&fs->lock);
+	task_unlock(ctx->root_task);
 
 	return 0;
 }
@@ -277,7 +345,7 @@ int do_checkpoint(struct cr_ctx *ctx, pid_t pid)
 	ret = cr_write_head(ctx);
 	if (ret < 0)
 		goto out;
-	ret = cr_write_task(ctx, current);
+	ret = cr_write_task(ctx, ctx->root_task);
 	if (ret < 0)
 		goto out;
 	ret = cr_write_tail(ctx);
diff --git a/checkpoint/restart.c b/checkpoint/restart.c
index ece05b7..0c46abf 100644
--- a/checkpoint/restart.c
+++ b/checkpoint/restart.c
@@ -277,7 +277,7 @@ static int cr_read_task(struct cr_ctx *ctx)
 }
 
 /* setup restart-specific parts of ctx */
-static int cr_ctx_restart(struct cr_ctx *ctx)
+static int cr_ctx_restart(struct cr_ctx *ctx, pid_t pid)
 {
 	return 0;
 }
@@ -286,7 +286,7 @@ int do_restart(struct cr_ctx *ctx, pid_t pid)
 {
 	int ret;
 
-	ret = cr_ctx_restart(ctx);
+	ret = cr_ctx_restart(ctx, pid);
 	if (ret < 0)
 		goto out;
 	ret = cr_read_head(ctx);
diff --git a/checkpoint/sys.c b/checkpoint/sys.c
index a506b3a..4a51ed3 100644
--- a/checkpoint/sys.c
+++ b/checkpoint/sys.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/nsproxy.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/file.h>
@@ -163,6 +164,11 @@ static void cr_ctx_free(struct cr_ctx *ctx)
 	cr_pgarr_free(ctx);
 	cr_objhash_free(ctx);
 
+	if (ctx->root_nsproxy)
+		put_nsproxy(ctx->root_nsproxy);
+	if (ctx->root_task)
+		put_task_struct(ctx->root_task);
+
 	kfree(ctx);
 }
 
diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
index ea9ab4c..cf54f47 100644
--- a/include/linux/checkpoint.h
+++ b/include/linux/checkpoint.h
@@ -19,6 +19,8 @@ struct cr_ctx {
 	int crid;		/* unique checkpoint id */
 
 	pid_t root_pid;		/* container identifier */
+	struct task_struct *root_task;	/* container root task */
+	struct nsproxy *root_nsproxy;	/* container root nsproxy */
 
 	unsigned long flags;
 	unsigned long oflags;	/* restart: old flags */
-- 
1.5.4.3

