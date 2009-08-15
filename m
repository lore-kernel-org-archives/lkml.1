Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZHORHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZHORHh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 13:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbZHORHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 13:07:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:33714 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527AbZHORHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 13:07:33 -0400
Date: Sat, 15 Aug 2009 17:07:05 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1250355231152-git-send-email->
References: <1250355231152-git-send-email->
Subject: [tip:core/rcu] rcu: Split hierarchical RCU initialization into boot-time and CPU-online pieces
Message-ID: <tip-27569620c748ec13f801b4683b448a2ac2adaae4@git.kernel.org>
Git-Commit-ID: 27569620c748ec13f801b4683b448a2ac2adaae4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 17:07:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27569620c748ec13f801b4683b448a2ac2adaae4
Gitweb:     http://git.kernel.org/tip/27569620c748ec13f801b4683b448a2ac2adaae4
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sat, 15 Aug 2009 09:53:46 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 15 Aug 2009 19:02:07 +0200

rcu: Split hierarchical RCU initialization into boot-time and CPU-online pieces

This patch divides the rcutree initialization into boot-time
and hotplug-time components, so that the tree data structures
are guaranteed to be fully linked at boot time regardless of
what might happen in CPU hotplug operations.

This makes RCU more resilient against CPU hotplug misbehavior
(and vice versa), but more importantly, does a better job of
compartmentalizing the code.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: josht@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: hugh.dickins@tiscali.co.uk
Cc: benh@kernel.crashing.org
LKML-Reference: <1250355231152-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcutree.c |   53 +++++++++++++++++++++++++++++++++--------------------
 1 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7717b95..f3e4327 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1325,22 +1325,40 @@ int rcu_needs_cpu(int cpu)
 }
 
 /*
- * Initialize a CPU's per-CPU RCU data.  We take this "scorched earth"
- * approach so that we don't have to worry about how long the CPU has
- * been gone, or whether it ever was online previously.  We do trust the
- * ->mynode field, as it is constant for a given struct rcu_data and
- * initialized during early boot.
- *
- * Note that only one online or offline event can be happening at a given
- * time.  Note also that we can accept some slop in the rsp->completed
- * access due to the fact that this CPU cannot possibly have any RCU
- * callbacks in flight yet.
+ * Do boot-time initialization of a CPU's per-CPU RCU data.
+ */
+static void __init
+rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
+{
+	unsigned long flags;
+	int i;
+	struct rcu_data *rdp = rsp->rda[cpu];
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	/* Set up local state, ensuring consistent view of global state. */
+	spin_lock_irqsave(&rnp->lock, flags);
+	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
+	rdp->nxtlist = NULL;
+	for (i = 0; i < RCU_NEXT_SIZE; i++)
+		rdp->nxttail[i] = &rdp->nxtlist;
+	rdp->qlen = 0;
+#ifdef CONFIG_NO_HZ
+	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
+#endif /* #ifdef CONFIG_NO_HZ */
+	rdp->cpu = cpu;
+	spin_unlock_irqrestore(&rnp->lock, flags);
+}
+
+/*
+ * Initialize a CPU's per-CPU RCU data.  Note that only one online or
+ * offline event can be happening at a given time.  Note also that we
+ * can accept some slop in the rsp->completed access due to the fact
+ * that this CPU cannot possibly have any RCU callbacks in flight yet.
  */
 static void __cpuinit
 rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
-	int i;
 	long lastcomp;
 	unsigned long mask;
 	struct rcu_data *rdp = rsp->rda[cpu];
@@ -1355,16 +1373,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
 	rdp->beenonline = 1;	 /* We have now been online. */
 	rdp->passed_quiesc_completed = lastcomp - 1;
-	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
-	rdp->nxtlist = NULL;
-	for (i = 0; i < RCU_NEXT_SIZE; i++)
-		rdp->nxttail[i] = &rdp->nxtlist;
-	rdp->qlen = 0;
 	rdp->blimit = blimit;
-#ifdef CONFIG_NO_HZ
-	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
-#endif /* #ifdef CONFIG_NO_HZ */
-	rdp->cpu = cpu;
 	spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 
 	/*
@@ -1539,8 +1548,12 @@ void __init __rcu_init(void)
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 	rcu_init_one(&rcu_state);
 	RCU_DATA_PTR_INIT(&rcu_state, rcu_data);
+	for_each_possible_cpu(i)
+		rcu_boot_init_percpu_data(i, &rcu_state);
 	rcu_init_one(&rcu_bh_state);
 	RCU_DATA_PTR_INIT(&rcu_bh_state, rcu_bh_data);
+	for_each_possible_cpu(i)
+		rcu_boot_init_percpu_data(i, &rcu_bh_state);
 
 	for_each_online_cpu(i)
 		rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE, (void *)(long)i);
