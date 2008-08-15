Return-Path: <linux-kernel-owner+w=401wt.eu-S1761342AbYHOUbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761342AbYHOUbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760537AbYHOUas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:30:48 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:36016
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760117AbYHOUap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:30:45 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH RT RFC v4 3/8] sched: rework task reference counting to work
	with the pi infrastructure
To: mingo@elte.hu, paulmck@linux.vnet.ibm.com, peterz@infradead.org,
       tglx@linutronix.de, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com, David.Holmes@sun.com, jkacur@gmail.com
Date: Fri, 15 Aug 2008 16:28:34 -0400
Message-ID: <20080815202834.668.13834.stgit@dev.haskins.net>
In-Reply-To: <20080815202408.668.23736.stgit@dev.haskins.net>
References: <20080815202408.668.23736.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/sched.h |    7 +++++--
 kernel/fork.c         |   32 +++++++++++++++-----------------
 kernel/sched.c        |   21 +++++++++++++++++++++
 3 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5521a64..7ae8eca 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1305,6 +1305,8 @@ struct task_struct {
 		struct pi_node node;
 		struct pi_sink sink;  /* registered to 'this' to get updates */
 		int prio;
+		struct rcu_head rcu; /* for destruction cleanup */
+
 	} pi;
 
 #ifdef CONFIG_RT_MUTEXES
@@ -1633,12 +1635,11 @@ static inline void put_task_struct(struct task_struct *t)
 		call_rcu(&t->rcu, __put_task_struct_cb);
 }
 #else
-extern void __put_task_struct(struct task_struct *t);
 
 static inline void put_task_struct(struct task_struct *t)
 {
 	if (atomic_dec_and_test(&t->usage))
-		__put_task_struct(t);
+		pi_put(&t->pi.node, 0);
 }
 #endif
 
@@ -2469,6 +2470,8 @@ static inline int task_is_current(struct task_struct *task)
 }
 #endif
 
+extern void prepare_free_task(struct task_struct *tsk);
+
 #define TASK_STATE_TO_CHAR_STR "RMSDTtZX"
 
 #endif /* __KERNEL__ */
diff --git a/kernel/fork.c b/kernel/fork.c
index 399a0d0..4d4fba3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -130,39 +130,37 @@ void free_task(struct task_struct *tsk)
 }
 EXPORT_SYMBOL(free_task);
 
-#ifdef CONFIG_PREEMPT_RT
-void __put_task_struct_cb(struct rcu_head *rhp)
+void prepare_free_task(struct task_struct *tsk)
 {
-	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
-
 	BUG_ON(atomic_read(&tsk->usage));
-	WARN_ON(!tsk->exit_state);
 	WARN_ON(tsk == current);
 
+#ifdef CONFIG_PREEMPT_RT
+	WARN_ON(!tsk->exit_state);
+#else
+	WARN_ON(!(tsk->exit_state & (EXIT_DEAD | EXIT_ZOMBIE)));
+#endif
+
 	security_task_free(tsk);
 	free_uid(tsk->user);
 	put_group_info(tsk->group_info);
+
+#ifdef CONFIG_PREEMPT_RT
 	delayacct_tsk_free(tsk);
+#endif
 
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
 }
 
-#else
-
-void __put_task_struct(struct task_struct *tsk)
+#ifdef CONFIG_PREEMPT_RT
+void __put_task_struct_cb(struct rcu_head *rhp)
 {
-	WARN_ON(!(tsk->exit_state & (EXIT_DEAD | EXIT_ZOMBIE)));
-	BUG_ON(atomic_read(&tsk->usage));
-	WARN_ON(tsk == current);
-
-	security_task_free(tsk);
-	free_uid(tsk->user);
-	put_group_info(tsk->group_info);
+	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
 
-	if (!profile_handoff_task(tsk))
-		free_task(tsk);
+	pi_put(&tsk->pi.node, 0);
 }
+
 #endif
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index 0732a9b..eb14b9f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2370,11 +2370,32 @@ task_pi_boost_cb(struct pi_sink *sink, struct pi_source *src,
 	return 0;
 }
 
+static void task_pi_free_rcu(struct rcu_head *rhp)
+{
+	struct task_struct *tsk = container_of(rhp, struct task_struct, pi.rcu);
+
+	prepare_free_task(tsk);
+}
+
+/*
+ * This function is invoked whenever the last references to a task have
+ * been dropped, and we should free the memory on the next rcu grace period
+ */
+static int task_pi_free_cb(struct pi_sink *sink, unsigned int flags)
+{
+	struct task_struct *p = container_of(sink, struct task_struct, pi.sink);
+
+	call_rcu(&p->pi.rcu, task_pi_free_rcu);
+
+	return 0;
+}
+
 static int task_pi_update_cb(struct pi_sink *sink, unsigned int flags);
 
 static struct pi_sink_ops task_pi_sink = {
     .boost = task_pi_boost_cb,
     .update = task_pi_update_cb,
+    .free = task_pi_free_cb,
 };
 
 static inline void

