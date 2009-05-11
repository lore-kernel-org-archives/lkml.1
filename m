Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbZEKVyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbZEKVyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758726AbZEKVyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:54:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:39528 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759129AbZEKVyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:54:04 -0400
Date: Mon, 11 May 2009 21:51:33 GMT
From: tip-bot for Jeff Garzik <jeff@garzik.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jgarzik@redhat.com, hpa@zytor.com,
       mingo@redhat.com, akpm@linux-foundation.org, jeff@garzik.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, jgarzik@redhat.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jeff@garzik.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090511200213.GA8478@havoc.gtf.org>
References: <20090511200213.GA8478@havoc.gtf.org>
Subject: [tip:sched/urgent] kernel/{sched, smp}.c: fix static decl prior to struct declaration
Message-ID: <tip-c5e1b572f8ff5ed9cb3c0c6a1141de313dea5882@git.kernel.org>
Git-Commit-ID: c5e1b572f8ff5ed9cb3c0c6a1141de313dea5882
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 21:51:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5e1b572f8ff5ed9cb3c0c6a1141de313dea5882
Gitweb:     http://git.kernel.org/tip/c5e1b572f8ff5ed9cb3c0c6a1141de313dea5882
Author:     Jeff Garzik <jeff@garzik.org>
AuthorDate: Mon, 11 May 2009 16:02:13 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 22:53:50 +0200

kernel/{sched, smp}.c: fix static decl prior to struct declaration

According to C99 6.9.2p3, any declaration "static struct foo my_foo;"
must follow the definition of struct foo.

Apparently, gcc's lack of warning is a bug.

v3:
  - fix compile breakage WRT root_task_group.
v2:
  - fix ifdef imbalance, by moving entire USER_SCHED code block
  - indent cpp directives, to indicate nesting

[ Impact: cleanup, fix for Sparse ]

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: viro@zeniv.linux.org.uk
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: roland@redhat.com
LKML-Reference: <20090511200213.GA8478@havoc.gtf.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   74 ++++++++++++++++++++++++++++----------------------------
 kernel/smp.c   |    4 +-
 2 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 26efa47..7afa517 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -303,48 +303,11 @@ struct task_group {
 	struct list_head children;
 };
 
-#ifdef CONFIG_USER_SCHED
-
-/* Helper function to pass uid information to create_sched_user() */
-void set_tg_uid(struct user_struct *user)
-{
-	user->tg->uid = user->uid;
-}
-
-/*
- * Root task group.
- * 	Every UID task group (including init_task_group aka UID-0) will
- * 	be a child to this group.
- */
-struct task_group root_task_group;
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-/* Default task group's sched entity on each cpu */
-static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
-/* Default task group's cfs_rq on each cpu */
-static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
-#endif /* CONFIG_FAIR_GROUP_SCHED */
-
-#ifdef CONFIG_RT_GROUP_SCHED
-static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
-static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
-#endif /* CONFIG_RT_GROUP_SCHED */
-#else /* !CONFIG_USER_SCHED */
-#define root_task_group init_task_group
-#endif /* CONFIG_USER_SCHED */
-
 /* task_group_lock serializes add/remove of task groups and also changes to
  * a task group's cpu shares.
  */
 static DEFINE_SPINLOCK(task_group_lock);
 
-#ifdef CONFIG_SMP
-static int root_task_group_empty(void)
-{
-	return list_empty(&root_task_group.children);
-}
-#endif
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_USER_SCHED
 # define INIT_TASK_GROUP_LOAD	(2*NICE_0_LOAD)
@@ -663,6 +626,43 @@ struct rq {
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
+#ifdef CONFIG_USER_SCHED
+
+/* Helper function to pass uid information to create_sched_user() */
+void set_tg_uid(struct user_struct *user)
+{
+	user->tg->uid = user->uid;
+}
+
+/*
+ * Root task group.
+ * 	Every UID task group (including init_task_group aka UID-0) will
+ * 	be a child to this group.
+ */
+struct task_group root_task_group;
+
+# ifdef CONFIG_FAIR_GROUP_SCHED
+/* Default task group's sched entity on each cpu */
+static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
+/* Default task group's cfs_rq on each cpu */
+static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
+# endif /* CONFIG_FAIR_GROUP_SCHED */
+
+# ifdef CONFIG_RT_GROUP_SCHED
+static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
+static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
+# endif /* CONFIG_RT_GROUP_SCHED */
+#else /* !CONFIG_USER_SCHED */
+# define root_task_group init_task_group
+#endif /* CONFIG_USER_SCHED */
+
+#ifdef CONFIG_SMP
+static int root_task_group_empty(void)
+{
+	return list_empty(&root_task_group.children);
+}
+#endif
+
 static inline void check_preempt_curr(struct rq *rq, struct task_struct *p, int sync)
 {
 	rq->curr->sched_class->check_preempt_curr(rq, p, sync);
diff --git a/kernel/smp.c b/kernel/smp.c
index 858baac..aba7bda 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -12,8 +12,6 @@
 #include <linux/smp.h>
 #include <linux/cpu.h>
 
-static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
-
 static struct {
 	struct list_head	queue;
 	spinlock_t		lock;
@@ -39,6 +37,8 @@ struct call_single_queue {
 	spinlock_t		lock;
 };
 
+static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
+
 static DEFINE_PER_CPU(struct call_function_data, cfd_data) = {
 	.lock			= __SPIN_LOCK_UNLOCKED(cfd_data.lock),
 };
