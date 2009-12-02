Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbZLBUKa (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 2 Dec 2009 15:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbZLBUK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:10:27 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59077 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607AbZLBUKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:10:25 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/4] rcu: enable fourth level of TREE_RCU hierarchy
Date: Wed,  2 Dec 2009 12:10:14 -0800
Message-Id: <12597846161257-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091202200955.GA12950@linux.vnet.ibm.com>
References: <20091202200955.GA12950@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Enable a fourth level of rcu_node hierarchy for TREE_RCU and
TREE_PREEMPT_RCU.  This is for stress-testing and experiemental
purposes only, although in theory this would enable 16,777,216 CPUs
on 64-bit systems, though only 1,048,576 CPUs on 32-bit systems.
Normal experimental use of this fourth level will normally set
CONFIG_RCU_FANOUT=2, requiring a 16-CPU system, though the more
adventurous (and more fortunate) experimenters may wish to chose
CONFIG_RCU_FANOUT=3 for 81-CPU systems or even CONFIG_RCU_FANOUT=4 for
256-CPU systems.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    6 +++++-
 kernel/rcutree.h |   15 +++++++++++++--
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a9f5103..d47e03e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -60,7 +60,8 @@ static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
 		NUM_RCU_LVL_0,  /* root of hierarchy. */ \
 		NUM_RCU_LVL_1, \
 		NUM_RCU_LVL_2, \
-		NUM_RCU_LVL_3, /* == MAX_RCU_LVLS */ \
+		NUM_RCU_LVL_3, \
+		NUM_RCU_LVL_4, /* == MAX_RCU_LVLS */ \
 	}, \
 	.signaled = RCU_GP_IDLE, \
 	.gpnum = -300, \
@@ -1877,6 +1878,9 @@ void __init rcu_init(void)
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+#if NUM_RCU_LVL_4 != 0
+	printk(KERN_INFO "Experimental four-level hierarchy is enabled.\n");
+#endif /* #if NUM_RCU_LVL_4 != 0 */
 	RCU_INIT_FLAVOR(&rcu_sched_state, rcu_sched_data);
 	RCU_INIT_FLAVOR(&rcu_bh_state, rcu_bh_data);
 	__rcu_init_preempt();
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 8bb03cb..df2e0b6 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -34,10 +34,11 @@
  * In practice, this has not been tested, so there is probably some
  * bug somewhere.
  */
-#define MAX_RCU_LVLS 3
+#define MAX_RCU_LVLS 4
 #define RCU_FANOUT	      (CONFIG_RCU_FANOUT)
 #define RCU_FANOUT_SQ	      (RCU_FANOUT * RCU_FANOUT)
 #define RCU_FANOUT_CUBE	      (RCU_FANOUT_SQ * RCU_FANOUT)
+#define RCU_FANOUT_FOURTH     (RCU_FANOUT_CUBE * RCU_FANOUT)
 
 #if NR_CPUS <= RCU_FANOUT
 #  define NUM_RCU_LVLS	      1
@@ -45,23 +46,33 @@
 #  define NUM_RCU_LVL_1	      (NR_CPUS)
 #  define NUM_RCU_LVL_2	      0
 #  define NUM_RCU_LVL_3	      0
+#  define NUM_RCU_LVL_4	      0
 #elif NR_CPUS <= RCU_FANOUT_SQ
 #  define NUM_RCU_LVLS	      2
 #  define NUM_RCU_LVL_0	      1
 #  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT)
 #  define NUM_RCU_LVL_2	      (NR_CPUS)
 #  define NUM_RCU_LVL_3	      0
+#  define NUM_RCU_LVL_4	      0
 #elif NR_CPUS <= RCU_FANOUT_CUBE
 #  define NUM_RCU_LVLS	      3
 #  define NUM_RCU_LVL_0	      1
 #  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_SQ)
 #  define NUM_RCU_LVL_2	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT)
 #  define NUM_RCU_LVL_3	      NR_CPUS
+#  define NUM_RCU_LVL_4	      0
+#elif NR_CPUS <= RCU_FANOUT_FOURTH
+#  define NUM_RCU_LVLS	      4
+#  define NUM_RCU_LVL_0	      1
+#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_CUBE)
+#  define NUM_RCU_LVL_2	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_SQ)
+#  define NUM_RCU_LVL_3	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT)
+#  define NUM_RCU_LVL_4	      NR_CPUS
 #else
 # error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
 #endif /* #if (NR_CPUS) <= RCU_FANOUT */
 
-#define RCU_SUM (NUM_RCU_LVL_0 + NUM_RCU_LVL_1 + NUM_RCU_LVL_2 + NUM_RCU_LVL_3)
+#define RCU_SUM (NUM_RCU_LVL_0 + NUM_RCU_LVL_1 + NUM_RCU_LVL_2 + NUM_RCU_LVL_3 + NUM_RCU_LVL_4)
 #define NUM_RCU_NODES (RCU_SUM - NR_CPUS)
 
 /*
-- 
1.5.2.5

