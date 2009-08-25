Return-Path: <linux-kernel-owner+w=401wt.eu-S1754215AbZHYHNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbZHYHNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbZHYHNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:13:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:40403 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089AbZHYHNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:13:45 -0400
Date: Tue, 25 Aug 2009 07:13:14 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12511321213336-git-send-email->
References: <12511321213336-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Add CPU-offline processing for single-node configurations
Message-ID: <tip-33f76148ced0e0618062e302d2a9614efdbd4a06@git.kernel.org>
Git-Commit-ID: 33f76148ced0e0618062e302d2a9614efdbd4a06
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 25 Aug 2009 07:13:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  33f76148ced0e0618062e302d2a9614efdbd4a06
Gitweb:     http://git.kernel.org/tip/33f76148ced0e0618062e302d2a9614efdbd4a06
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 24 Aug 2009 09:42:01 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 24 Aug 2009 20:37:04 +0200

rcu: Add CPU-offline processing for single-node configurations

Add preemptable-RCU plugin to handle the CPU-offline
processing.

An additional plugin is forthcoming to handle multinode RCU
trees, but this current plugin works for configurations up to
32 CPUs (64 CPUs for 64-bit kernels).

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josht@linux.vnet.ibm.com
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
LKML-Reference: <12511321213336-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
