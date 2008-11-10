Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYKJQlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYKJQlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 11:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbYKJQjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 11:39:16 -0500
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:63490 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbYKJQjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:39:11 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Serge Hallyn <serue@us.ibm.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: [RFC v9][PATCH 11/13] Track in-kernel when we expect checkpoint/restart to work
Date: Mon, 10 Nov 2008 11:37:38 -0500
Message-Id: <1226335060-7061-12-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1226335060-7061-1-git-send-email-orenl@cs.columbia.edu>
References: <1226335060-7061-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave@linux.vnet.ibm.com>

Suggested by Ingo.

Checkpoint/restart is going to be a long effort to get things working.
We're going to have a lot of things that we know just don't work for
a long time.  That doesn't mean that it will be useless, it just means
that there's some complicated features that we are going to have to
work incrementally to fix.

This patch introduces a new mechanism to help the checkpoint/restart
developers.  A new function pair: task/process_deny_checkpoint() is
created.  When called, these tell the kernel that we *know* that the
process has performed some activity that will keep it from being
properly checkpointed.

The 'flag' is an atomic_t for now so that we can have some level
of atomicity and make sure to only warn once.

For now, this is a one-way trip.  Once a process is no longer
'may_checkpoint' capable, neither it nor its children ever will be.
This can, of course, be fixed up in the future.  We might want to
reset the flag when a new pid namespace is created, for instance.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
---
 checkpoint/checkpoint.c    |    6 ++++++
 include/linux/checkpoint.h |   33 ++++++++++++++++++++++++++++++++-
 include/linux/sched.h      |    3 +++
 kernel/fork.c              |   10 ++++++++++
 4 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/checkpoint/checkpoint.c b/checkpoint/checkpoint.c
index a20f961..dd9f325 100644
--- a/checkpoint/checkpoint.c
+++ b/checkpoint/checkpoint.c
@@ -213,6 +213,12 @@ static int cr_write_task(struct cr_ctx *ctx, struct task_struct *t)
 		return -EAGAIN;
 	}
 
+	if (!atomic_read(&task->may_checkpoint)) {
+		pr_warning("c/r: task %d may not checkpoint\n",
+			   task_pid_vnr(task));
+		return -BUSY;
+	}
+
 	ret = cr_write_task_struct(ctx, t);
 	cr_debug("task_struct: ret %d\n", ret);
 	if (ret < 0)
diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
index b807e85..74a8597 100644
--- a/include/linux/checkpoint.h
+++ b/include/linux/checkpoint.h
@@ -10,8 +10,11 @@
  *  distribution for more details.
  */
 
-#include <linux/path.h>
 #include <linux/fs.h>
+#include <linux/path.h>
+#include <linux/sched.h>
+
+#ifdef CONFIG_CHECKPOINT_RESTART
 
 #define CR_VERSION  2
 
@@ -91,4 +94,32 @@ extern int cr_read_files(struct cr_ctx *ctx);
 #define cr_debug(fmt, args...)  \
 	pr_debug("[%d:c/r:%s] " fmt, task_pid_vnr(current), __func__, ## args)
 
+static inline void __task_deny_checkpointing(struct task_struct *task,
+		char *file, int line)
+{
+	if (!atomic_dec_and_test(&task->may_checkpoint))
+		return;
+	printk(KERN_INFO "process performed an action that can not be "
+			"checkpointed at: %s:%d\n", file, line);
+	WARN_ON(1);
+}
+#define process_deny_checkpointing(p)  \
+	__task_deny_checkpointing(p, __FILE__, __LINE__)
+
+/*
+ * For now, we're not going to have a distinction between
+ * tasks and processes for the purpose of c/r.  But, allow
+ * these two calls anyway to make new users at least think
+ * about it.
+ */
+#define task_deny_checkpointing(p)  \
+	__task_deny_checkpointing(p, __FILE__, __LINE__)
+
+#else
+
+static inline void task_deny_checkpointing(struct task_struct *task) {}
+static inline void process_deny_checkpointing(struct task_struct *task) {}
+
+#endif
+
 #endif /* _CHECKPOINT_CKPT_H_ */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b483f39..0c8d02d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1349,6 +1349,9 @@ struct task_struct {
 	 */
 	unsigned long timer_slack_ns;
 	unsigned long default_timer_slack_ns;
+#ifdef CONFIG_CHECKPOINT_RESTART
+	atomic_t may_checkpoint;
+#endif
 };
 
 /*
diff --git a/kernel/fork.c b/kernel/fork.c
index f608356..693b0cb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -195,6 +195,13 @@ void __init fork_init(unsigned long mempages)
 	init_task.signal->rlim[RLIMIT_NPROC].rlim_max = max_threads/2;
 	init_task.signal->rlim[RLIMIT_SIGPENDING] =
 		init_task.signal->rlim[RLIMIT_NPROC];
+
+#ifdef CONFIG_CHECKPOINT_RESTART
+	/*
+	 * This probably won't stay set for long...
+	 */
+	atomic_set(&init_task.may_checkpoint, 1);
+#endif
 }
 
 int __attribute__((weak)) arch_dup_task_struct(struct task_struct *dst,
@@ -245,6 +252,9 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	tsk->btrace_seq = 0;
 #endif
 	tsk->splice_pipe = NULL;
+#ifdef CONFIG_CHECKPOINT_RESTART
+	atomic_set(&tsk->may_checkpoint, atomic_read(&orig->may_checkpoint));
+#endif
 	return tsk;
 
 out:
-- 
1.5.4.3

