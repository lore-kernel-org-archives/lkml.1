Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbZLCNWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbZLCNWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZLCNWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:22:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:32818 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbZLCNWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:22:32 -0500
Date: Thu, 3 Dec 2009 13:22:14 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, josh@joshtriplett.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, josh@joshtriplett.org,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <12597846161257-git-send-email->
References: <12597846161257-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Enable fourth level of TREE_RCU hierarchy
Message-ID: <tip-cf244dc01bf68e1ad338b82447f8686d24ea4435@git.kernel.org>
Git-Commit-ID: cf244dc01bf68e1ad338b82447f8686d24ea4435
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf244dc01bf68e1ad338b82447f8686d24ea4435
Gitweb:     http://git.kernel.org/tip/cf244dc01bf68e1ad338b82447f8686d24ea4435
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 2 Dec 2009 12:10:14 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Dec 2009 11:34:53 +0100

rcu: Enable fourth level of TREE_RCU hierarchy

Enable a fourth level of rcu_node hierarchy for TREE_RCU and
TREE_PREEMPT_RCU.  This is for stress-testing and experiemental
purposes only, although in theory this would enable 16,777,216
CPUs on 64-bit systems, though only 1,048,576 CPUs on 32-bit
systems. Normal experimental use of this fourth level will
normally set CONFIG_RCU_FANOUT=2, requiring a 16-CPU system,
though the more adventurous (and more fortunate) experimenters
may wish to chose CONFIG_RCU_FANOUT=3 for 81-CPU systems or even
CONFIG_RCU_FANOUT=4 for 256-CPU systems.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12597846161257-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
