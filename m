Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab0AOAL2 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 19:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266Ab0AOAL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:11:28 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39228 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756720Ab0AOAL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 19:11:27 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/2] rcu: fix sparse warnings
Date: Thu, 14 Jan 2010 16:10:58 -0800
Message-Id: <12635142581560-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20100115001021.GA25878@linux.vnet.ibm.com>
References: <20100115001021.GA25878@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Rename local variable "i" in rcu_init() to avoid conflict with
RCU_INIT_FLAVOR(), restrict the scope of RCU_TREE_NONCORE, and
make __synchronize_srcu() static.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    6 +++---
 kernel/rcutree.h |    6 ++----
 kernel/srcu.c    |    2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3b13d64..099a255 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1888,7 +1888,7 @@ do { \
 
 void __init rcu_init(void)
 {
-	int i;
+	int cpu;
 
 	rcu_bootup_announce();
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
@@ -1908,8 +1908,8 @@ void __init rcu_init(void)
 	 * or the scheduler are operational.
 	 */
 	cpu_notifier(rcu_cpu_notify, 0);
-	for_each_online_cpu(i)
-		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)i);
+	for_each_online_cpu(cpu)
+		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
 }
 
 #include "rcutree_plugin.h"
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index bd5d78a..d9d032a 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -323,8 +323,6 @@ struct rcu_state {
 #define RCU_OFL_TASKS_EXP_GP	0x2		/* Tasks blocking expedited */
 						/*  GP were moved to root. */
 
-#ifdef RCU_TREE_NONCORE
-
 /*
  * RCU implementation internal declarations:
  */
@@ -339,7 +337,7 @@ extern struct rcu_state rcu_preempt_state;
 DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
-#else /* #ifdef RCU_TREE_NONCORE */
+#ifndef RCU_TREE_NONCORE
 
 /* Forward declarations for rcutree_plugin.h */
 static void rcu_bootup_announce(void);
@@ -372,4 +370,4 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
 static void rcu_preempt_send_cbs_to_orphanage(void);
 static void __init __rcu_init_preempt(void);
 
-#endif /* #else #ifdef RCU_TREE_NONCORE */
+#endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 818d7d9..31b275b 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -144,7 +144,7 @@ EXPORT_SYMBOL_GPL(srcu_read_unlock);
 /*
  * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
  */
-void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
+static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
 {
 	int idx;
 
-- 
1.5.2.5

