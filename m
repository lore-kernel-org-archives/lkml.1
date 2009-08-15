Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbZHOQx5 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 15 Aug 2009 12:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932154AbZHOQxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 12:53:55 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48200 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351AbZHOQxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 12:53:51 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
   josht@linux.vnet.ibm.com, akpm@linux-foundation.org,
   mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
   tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
   hugh.dickins@tiscali.co.uk, benh@kernel.crashing.org,
   "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH -tip/core/rcu 1/6] Split hierarchical RCU initialization into boot-time and CPU-online pieces
Date: Sat, 15 Aug 2009 09:53:46 -0700
Message-Id: <1250355231152-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090815165153.GA8886@linux.vnet.ibm.com>
References: <20090815165153.GA8886@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch divides the rcutree initialization into boot-time and
hotplug-time components, so that the tree data structures are guaranteed
to be fully linked at boot time regardless of what might happen in CPU
hotplug operations.  This makes RCU more resilient against CPU hotplug
misbehavior (and vice versa), but more importantly, does a better job
of compartmentalizing the code.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
LKML-Reference: http://lkml.org/lkml/2009/8/2/127
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
-- 
1.5.2.5

