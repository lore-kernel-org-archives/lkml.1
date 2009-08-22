Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155AbZHVU6E (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 22 Aug 2009 16:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbZHVU4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 16:56:54 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41787 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943AbZHVU4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 16:56:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
   akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
   josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
   tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
   "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH -tip] v3 Merge per-RCU-flavor initialization into pre-existing macro.
Date: Sat, 22 Aug 2009 13:56:49 -0700
Message-Id: <12509746133916-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090727181401.GA14120@linux.vnet.ibm.com>
References: <20090727181401.GA14120@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Rename the RCU_DATA_PTR_INIT() macro to RCU_INIT_FLAVOR() and make it
do the rcu_init_one() and rcu_boot_init_percpu_data() calls.  Merge
the loop that was in the original macro with the loops that were in
__rcu_init().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 4d71d4e..7c51508 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1543,8 +1543,9 @@ static void __init rcu_init_one(struct rcu_state *rsp)
  * Helper macro for __rcu_init().  To be used nowhere else!
  * Assigns leaf node pointers into each CPU's rcu_data structure.
  */
-#define RCU_DATA_PTR_INIT(rsp, rcu_data) \
+#define RCU_INIT_FLAVOR(rsp, rcu_data) \
 do { \
+	rcu_init_one(rsp); \
 	rnp = (rsp)->level[NUM_RCU_LVLS - 1]; \
 	j = 0; \
 	for_each_possible_cpu(i) { \
@@ -1552,6 +1553,7 @@ do { \
 			j++; \
 		per_cpu(rcu_data, i).mynode = &rnp[j]; \
 		(rsp)->rda[i] = &per_cpu(rcu_data, i); \
+		rcu_boot_init_percpu_data(i, rsp); \
 	} \
 } while (0)
 
@@ -1565,14 +1567,8 @@ void __init __rcu_init(void)
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-	rcu_init_one(&rcu_sched_state);
-	RCU_DATA_PTR_INIT(&rcu_sched_state, rcu_sched_data);
-	for_each_possible_cpu(i)
-		rcu_boot_init_percpu_data(i, &rcu_sched_state);
-	rcu_init_one(&rcu_bh_state);
-	RCU_DATA_PTR_INIT(&rcu_bh_state, rcu_bh_data);
-	for_each_possible_cpu(i)
-		rcu_boot_init_percpu_data(i, &rcu_bh_state);
+	RCU_INIT_FLAVOR(&rcu_sched_state, rcu_sched_data);
+	RCU_INIT_FLAVOR(&rcu_bh_state, rcu_bh_data);
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
-- 
1.5.2.5

