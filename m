Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbZIWTON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbZIWTON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 15:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZIWTOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 15:14:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:53549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbZIWTOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 15:14:06 -0400
Date: Wed, 23 Sep 2009 19:13:41 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12537246441701-git-send-email->
References: <12537246441701-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Clean up code to address Ingo's checkpatch feedback
Message-ID: <tip-9b2619aff0332e95ea5eb7a0d75b0208818d871c@git.kernel.org>
Git-Commit-ID: 9b2619aff0332e95ea5eb7a0d75b0208818d871c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 23 Sep 2009 19:13:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b2619aff0332e95ea5eb7a0d75b0208818d871c
Gitweb:     http://git.kernel.org/tip/9b2619aff0332e95ea5eb7a0d75b0208818d871c
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 23 Sep 2009 09:50:43 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Sep 2009 19:46:30 +0200

rcu: Clean up code to address Ingo's checkpatch feedback

Move declarations and update storage classes to make checkpatch happy.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12537246441701-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
index 233768f..697c0a0 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -606,8 +606,6 @@ static struct rcu_torture_ops sched_ops_sync = {
 	.name		= "sched_sync"
 };
 
-extern int rcu_expedited_torture_stats(char *page);
-
 static struct rcu_torture_ops sched_expedited_ops = {
 	.init		= rcu_sync_torture_init,
 	.cleanup	= NULL,
@@ -650,7 +648,7 @@ rcu_torture_writer(void *arg)
 		old_rp = rcu_torture_current;
 		rp->rtort_mbtest = 1;
 		rcu_assign_pointer(rcu_torture_current, rp);
-		smp_wmb();
+		smp_wmb(); /* Mods to old_rp must follow rcu_assign_pointer() */
 		if (old_rp) {
 			i = old_rp->rtort_pipe_count;
 			if (i > RCU_TORTURE_PIPE_LEN)
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 53a5ef0..8e52cde 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -81,29 +81,6 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
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
