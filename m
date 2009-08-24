Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbZHXQmE (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 24 Aug 2009 12:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZHXQmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:42:03 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48126 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbZHXQmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:42:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
   akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
   josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
   tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
   "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH -tip 2/2] Add CPU-offline processing for single-node configurations
Date: Mon, 24 Aug 2009 09:42:01 -0700
Message-Id: <12511321213336-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090824164112.GA13693@linux.vnet.ibm.com>
References: <20090824164112.GA13693@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Add preemptable-RCU plugin to handle the CPU-offline processing.
An additional plugin is forthcoming to handle multinode RCU trees, but
this current plugin works for configurations up to 32 CPUs (64 CPUs for
64-bit kernels).

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |    2 ++
 kernel/rcutree_plugin.h |   24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index cc02557..000b076 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -84,6 +84,7 @@ extern long rcu_batches_completed_sched(void);
 static void cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp,
 			  struct rcu_node *rnp, unsigned long flags);
 static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags);
+static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp);
 static void __rcu_process_callbacks(struct rcu_state *rsp,
 				    struct rcu_data *rdp);
 static void __call_rcu(struct rcu_head *head,
@@ -920,6 +921,7 @@ static void rcu_offline_cpu(int cpu)
 {
 	__rcu_offline_cpu(cpu, &rcu_sched_state);
 	__rcu_offline_cpu(cpu, &rcu_bh_state);
+	rcu_preempt_offline_cpu(cpu);
 }
 
 #else /* #ifdef CONFIG_HOTPLUG_CPU */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index cd2ab67..201334c 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -259,6 +259,18 @@ static int rcu_preempted_readers(struct rcu_node *rnp)
 	return !list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Do CPU-offline processing for preemptable RCU.
+ */
+static void rcu_preempt_offline_cpu(int cpu)
+{
+	__rcu_offline_cpu(cpu, &rcu_preempt_state);
+}
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
 /*
  * Check for a quiescent state from the current CPU.  When a task blocks,
  * the task is recorded in the corresponding CPU's rcu_node structure,
@@ -395,6 +407,18 @@ static int rcu_preempted_readers(struct rcu_node *rnp)
 	return 0;
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Because preemptable RCU does not exist, it never needs CPU-offline
+ * processing.
+ */
+static void rcu_preempt_offline_cpu(int cpu)
+{
+}
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
 /*
  * Because preemptable RCU does not exist, it never has any callbacks
  * to check.
-- 
1.5.2.5

