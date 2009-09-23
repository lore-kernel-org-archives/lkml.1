Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbZIWQuw (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 23 Sep 2009 12:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZIWQuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:50:50 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45784 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZIWQuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:50:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/4] rcu: Apply Ingo's checkpatch feedback
Date: Wed, 23 Sep 2009 09:50:43 -0700
Message-Id: <12537246441701-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090923165012.GA13801@linux.vnet.ibm.com>
References: <20090923165012.GA13801@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Move declarations and update storage classes to make checkpatch happy.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcutree.h |    6 +++++-
 kernel/rcupdate.c       |    3 ---
 kernel/rcutorture.c     |    4 +---
 kernel/rcutree.c        |   23 -----------------------
 kernel/rcutree.h        |   26 +++++++++++++++++++++++++-
 kernel/rcutree_trace.c  |   12 ++++++------
 6 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 19a3b06..46e9ab3 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -30,10 +30,14 @@
 #ifndef __LINUX_RCUTREE_H
 #define __LINUX_RCUTREE_H
 
+struct notifier_block;
+
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
-
+extern int rcu_cpu_notify(struct notifier_block *self,
+			  unsigned long action, void *hcpu);
 extern int rcu_needs_cpu(int cpu);
+extern int rcu_expedited_torture_stats(char *page);
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 37ac454..8e79513 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -259,9 +259,6 @@ static void rcu_migrate_callback(struct rcu_head *notused)
 		wake_up(&rcu_migrate_wq);
 }
 
-extern int rcu_cpu_notify(struct notifier_block *self,
-			  unsigned long action, void *hcpu);
-
 static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
 		unsigned long action, void *hcpu)
 {
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index e4b9ce6..1c9f423 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -605,8 +605,6 @@ static struct rcu_torture_ops sched_ops_sync = {
 	.name		= "sched_sync"
 };
 
-extern int rcu_expedited_torture_stats(char *page);
-
 static struct rcu_torture_ops sched_expedited_ops = {
 	.init		= rcu_sync_torture_init,
 	.cleanup	= NULL,
@@ -648,7 +646,7 @@ rcu_torture_writer(void *arg)
 		old_rp = rcu_torture_current;
 		rp->rtort_mbtest = 1;
 		rcu_assign_pointer(rcu_torture_current, rp);
-		smp_wmb();
+		smp_wmb(); /* Mods to old_rp must follow rcu_assign_pointer() */
 		if (old_rp) {
 			i = old_rp->rtort_pipe_count;
 			if (i > RCU_TORTURE_PIPE_LEN)
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 61472bd..a074f13 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -80,29 +80,6 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
-/* Forward declarations for rcutree_plugin.h */
-static inline void rcu_bootup_announce(void);
-long rcu_batches_completed(void);
-static void rcu_preempt_note_context_switch(int cpu);
-static int rcu_preempted_readers(struct rcu_node *rnp);
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-static void rcu_print_task_stall(struct rcu_node *rnp);
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
-#ifdef CONFIG_HOTPLUG_CPU
-static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
-				      struct rcu_node *rnp,
-				      struct rcu_data *rdp);
-static void rcu_preempt_offline_cpu(int cpu);
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
-static void rcu_preempt_check_callbacks(int cpu);
-static void rcu_preempt_process_callbacks(void);
-void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
-static int rcu_preempt_pending(int cpu);
-static int rcu_preempt_needs_cpu(int cpu);
-static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
-static void __init __rcu_init_preempt(void);
-
 
 /*
  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index a48d11f..e6ab31c 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -270,5 +270,29 @@ extern struct rcu_state rcu_preempt_state;
 DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
-#endif /* #ifdef RCU_TREE_NONCORE */
+#else /* #ifdef RCU_TREE_NONCORE */
 
+/* Forward declarations for rcutree_plugin.h */
+static inline void rcu_bootup_announce(void);
+long rcu_batches_completed(void);
+static void rcu_preempt_note_context_switch(int cpu);
+static int rcu_preempted_readers(struct rcu_node *rnp);
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+static void rcu_print_task_stall(struct rcu_node *rnp);
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
+#ifdef CONFIG_HOTPLUG_CPU
+static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
+				      struct rcu_node *rnp,
+				      struct rcu_data *rdp);
+static void rcu_preempt_offline_cpu(int cpu);
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+static void rcu_preempt_check_callbacks(int cpu);
+static void rcu_preempt_process_callbacks(void);
+void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
+static int rcu_preempt_pending(int cpu);
+static int rcu_preempt_needs_cpu(int cpu);
+static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
+static void __init __rcu_init_preempt(void);
+
+#endif /* #else #ifdef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index c89f5e9..f09af28 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -93,7 +93,7 @@ static int rcudata_open(struct inode *inode, struct file *file)
 	return single_open(file, show_rcudata, NULL);
 }
 
-static struct file_operations rcudata_fops = {
+static const struct file_operations rcudata_fops = {
 	.owner = THIS_MODULE,
 	.open = rcudata_open,
 	.read = seq_read,
@@ -145,7 +145,7 @@ static int rcudata_csv_open(struct inode *inode, struct file *file)
 	return single_open(file, show_rcudata_csv, NULL);
 }
 
-static struct file_operations rcudata_csv_fops = {
+static const struct file_operations rcudata_csv_fops = {
 	.owner = THIS_MODULE,
 	.open = rcudata_csv_open,
 	.read = seq_read,
@@ -159,7 +159,7 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 	struct rcu_node *rnp;
 
 	seq_printf(m, "c=%ld g=%ld s=%d jfq=%ld j=%x "
-	              "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu\n",
+		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu\n",
 		   rsp->completed, rsp->gpnum, rsp->signaled,
 		   (long)(rsp->jiffies_force_qs - jiffies),
 		   (int)(jiffies & 0xffff),
@@ -196,7 +196,7 @@ static int rcuhier_open(struct inode *inode, struct file *file)
 	return single_open(file, show_rcuhier, NULL);
 }
 
-static struct file_operations rcuhier_fops = {
+static const struct file_operations rcuhier_fops = {
 	.owner = THIS_MODULE,
 	.open = rcuhier_open,
 	.read = seq_read,
@@ -222,7 +222,7 @@ static int rcugp_open(struct inode *inode, struct file *file)
 	return single_open(file, show_rcugp, NULL);
 }
 
-static struct file_operations rcugp_fops = {
+static const struct file_operations rcugp_fops = {
 	.owner = THIS_MODULE,
 	.open = rcugp_open,
 	.read = seq_read,
@@ -276,7 +276,7 @@ static int rcu_pending_open(struct inode *inode, struct file *file)
 	return single_open(file, show_rcu_pending, NULL);
 }
 
-static struct file_operations rcu_pending_fops = {
+static const struct file_operations rcu_pending_fops = {
 	.owner = THIS_MODULE,
 	.open = rcu_pending_open,
 	.read = seq_read,
-- 
1.5.2.5

