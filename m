Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbZI2EuY (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 29 Sep 2009 00:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZI2EuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 00:50:23 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59712 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZI2EuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 00:50:21 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/3] rcu: replace the rcu_barrier enum with pointer to call_rcu*() function
Date: Mon, 28 Sep 2009 21:50:21 -0700
Message-Id: <12541998232366-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090929044955.GA12486@linux.vnet.ibm.com>
References: <20090929044955.GA12486@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rcu_barrier enum causes several problems: (1) you have to define
the enum somewhere, and there is no convenient place, (2) the difference
between TREE_RCU and TREE_PREEMPT_RCU causes problems when you need to
map from rcu_barrier enum to struct rcu_state, (3) the switch statement
are large, and (4) TINY_RCU really needs a different rcu_barrier()
than do the treercu implementations.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcupdate.c |   32 ++++++++++----------------------
 1 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 2480534..fd3ec49 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -53,12 +53,6 @@ struct lockdep_map rcu_lock_map =
 EXPORT_SYMBOL_GPL(rcu_lock_map);
 #endif
 
-enum rcu_barrier {
-	RCU_BARRIER_STD,
-	RCU_BARRIER_BH,
-	RCU_BARRIER_SCHED,
-};
-
 static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
 static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
@@ -188,19 +182,12 @@ static void rcu_barrier_func(void *type)
 {
 	int cpu = smp_processor_id();
 	struct rcu_head *head = &per_cpu(rcu_barrier_head, cpu);
+	void (*call_rcu_func)(struct rcu_head *head,
+			      void (*func)(struct rcu_head *head));
 
 	atomic_inc(&rcu_barrier_cpu_count);
-	switch ((enum rcu_barrier)type) {
-	case RCU_BARRIER_STD:
-		call_rcu(head, rcu_barrier_callback);
-		break;
-	case RCU_BARRIER_BH:
-		call_rcu_bh(head, rcu_barrier_callback);
-		break;
-	case RCU_BARRIER_SCHED:
-		call_rcu_sched(head, rcu_barrier_callback);
-		break;
-	}
+	call_rcu_func = type;
+	call_rcu_func(head, rcu_barrier_callback);
 }
 
 static inline void wait_migrated_callbacks(void)
@@ -213,7 +200,8 @@ static inline void wait_migrated_callbacks(void)
  * Orchestrate the specified type of RCU barrier, waiting for all
  * RCU callbacks of the specified type to complete.
  */
-static void _rcu_barrier(enum rcu_barrier type)
+static void _rcu_barrier(void (*call_rcu_func)(struct rcu_head *head,
+					       void (*func)(struct rcu_head *head)))
 {
 	BUG_ON(in_interrupt());
 	/* Take cpucontrol mutex to protect against CPU hotplug */
@@ -229,7 +217,7 @@ static void _rcu_barrier(enum rcu_barrier type)
 	 * early.
 	 */
 	atomic_set(&rcu_barrier_cpu_count, 1);
-	on_each_cpu(rcu_barrier_func, (void *)type, 1);
+	on_each_cpu(rcu_barrier_func, (void *)call_rcu_func, 1);
 	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
 		complete(&rcu_barrier_completion);
 	wait_for_completion(&rcu_barrier_completion);
@@ -242,7 +230,7 @@ static void _rcu_barrier(enum rcu_barrier type)
  */
 void rcu_barrier(void)
 {
-	_rcu_barrier(RCU_BARRIER_STD);
+	_rcu_barrier(call_rcu);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier);
 
@@ -251,7 +239,7 @@ EXPORT_SYMBOL_GPL(rcu_barrier);
  */
 void rcu_barrier_bh(void)
 {
-	_rcu_barrier(RCU_BARRIER_BH);
+	_rcu_barrier(call_rcu_bh);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_bh);
 
@@ -260,7 +248,7 @@ EXPORT_SYMBOL_GPL(rcu_barrier_bh);
  */
 void rcu_barrier_sched(void)
 {
-	_rcu_barrier(RCU_BARRIER_SCHED);
+	_rcu_barrier(call_rcu_sched);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_sched);
 
-- 
1.5.2.5

