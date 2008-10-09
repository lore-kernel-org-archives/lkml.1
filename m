Return-Path: <linux-kernel-owner+w=401wt.eu-S1760566AbYJITET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760566AbYJITET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757955AbYJITEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:04:09 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43861 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757993AbYJITEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:04:08 -0400
Subject: [RFC][PATCH 1/2] Track in-kernel when we expect checkpoint/restart to work
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: arnd@arndb.de, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 09 Oct 2008 12:04:05 -0700
Message-Id: <20081009190405.13A253CB@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
---

 linux-2.6.git-dave/include/linux/checkpoint.h |   31 +++++++++++++++++++++++++-
 linux-2.6.git-dave/include/linux/sched.h      |    3 ++
 linux-2.6.git-dave/kernel/fork.c              |   10 ++++++++
 3 files changed, 43 insertions(+), 1 deletion(-)

diff -puN include/linux/checkpoint.h~flag include/linux/checkpoint.h
--- linux-2.6.git/include/linux/checkpoint.h~flag	2008-10-09 11:56:57.000000000 -0700
+++ linux-2.6.git-dave/include/linux/checkpoint.h	2008-10-09 11:56:57.000000000 -0700
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
 
@@ -94,4 +97,30 @@ extern void file_pos_write(struct file *
 #define cr_debug(fmt, args...)  \
 	pr_debug("[CR:%s] " fmt, __func__, ## args)
 
+static inline void __task_deny_checkpointing(struct task_struct *task,
+		char *file, int line)
+{
+	if(!atomic_dec_and_test(&task->may_checkpoint))
+		return;
+	printk(KERN_INFO "process performed an action that can not be "
+			"checkpointed at: %s:%d\n", file, line);
+	WARN_ON(1);
+}
+#define process_deny_checkpointing(p) __task_deny_checkpointing(p, __FILE__, __LINE__)
+
+/*
+ * For now, we're not going to have a distinction between
+ * tasks and processes for the purpose of c/r.  But, allow
+ * these two calls anyway to make new users at least think
+ * about it.
+ */
+#define task_deny_checkpointing(p) __task_deny_checkpointing(p, __FILE__, __LINE__)
+
+#else
+
+static inline void task_deny_checkpointing(struct task_struct *task) {}
+static inline void process_deny_checkpointing(struct task_struct *task) {}
+
+#endif
+
 #endif /* _CHECKPOINT_CKPT_H_ */
diff -puN include/linux/sched.h~flag include/linux/sched.h
--- linux-2.6.git/include/linux/sched.h~flag	2008-10-09 11:56:57.000000000 -0700
+++ linux-2.6.git-dave/include/linux/sched.h	2008-10-09 11:56:57.000000000 -0700
@@ -1301,6 +1301,9 @@ struct task_struct {
 	int latency_record_count;
 	struct latency_record latency_record[LT_SAVECOUNT];
 #endif
+#ifdef CONFIG_CHECKPOINT_RESTART
+	atomic_t may_checkpoint;
+#endif
 };
 
 /*
diff -puN kernel/fork.c~flag kernel/fork.c
--- linux-2.6.git/kernel/fork.c~flag	2008-10-09 11:56:57.000000000 -0700
+++ linux-2.6.git-dave/kernel/fork.c	2008-10-09 11:56:57.000000000 -0700
@@ -194,6 +194,13 @@ void __init fork_init(unsigned long memp
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
@@ -244,6 +251,9 @@ static struct task_struct *dup_task_stru
 	tsk->btrace_seq = 0;
 #endif
 	tsk->splice_pipe = NULL;
+#ifdef CONFIG_CHECKPOINT_RESTART
+	atomic_set(&tsk->may_checkpoint, atomic_read(&orig->may_checkpoint));
+#endif
 	return tsk;
 
 out:
_
