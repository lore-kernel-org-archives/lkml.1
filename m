Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbZEHTiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbZEHTiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbZEHTim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:38:42 -0400
Received: from havoc.gtf.org ([69.61.125.42]:35684 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbZEHTil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:38:41 -0400
Date: Fri, 8 May 2009 15:38:41 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: viro@zeniv.linux.org.uk, mingo@elte.hu,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com
Subject: [PATCH 1/2 v2] kernel/{sched,smp}.c: fix static decl prior to struct declaration
Message-ID: <20090508193841.GA13831@havoc.gtf.org>
References: <20090508184838.GA11157@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508184838.GA11157@havoc.gtf.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to C99 6.9.2p3, any declaration "static struct foo my_foo;"
must follow the definition of struct foo.

Apparently, gcc's lack of warning is a bug.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
Patch v2 changes:
- fix ifdef imbalance, by moving entire USER_SCHED code block
- indent cpp directives, to indicate nesting

 kernel/sched.c |   60 ++++++++++++++++++++++++++++-----------------------------
 kernel/smp.c   |    4 +--
 2 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 26efa47..61a54c7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -303,36 +303,6 @@ struct task_group {
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
@@ -663,6 +633,36 @@ struct rq {
 
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
