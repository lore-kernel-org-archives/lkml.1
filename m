Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbZHWJDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbZHWJDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 05:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbZHWJDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 05:03:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:36973 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914AbZHWJDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 05:03:08 -0400
Date: Sun, 23 Aug 2009 09:02:31 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12509746133916-git-send-email->
References: <12509746133916-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Merge per-RCU-flavor initialization into pre-existing macro
Message-ID: <tip-65cf8f866fc0fb40fa9daaded7e938a886d6f7c5@git.kernel.org>
Git-Commit-ID: 65cf8f866fc0fb40fa9daaded7e938a886d6f7c5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 23 Aug 2009 09:02:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  65cf8f866fc0fb40fa9daaded7e938a886d6f7c5
Gitweb:     http://git.kernel.org/tip/65cf8f866fc0fb40fa9daaded7e938a886d6f7c5
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sat, 22 Aug 2009 13:56:49 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 23 Aug 2009 10:32:38 +0200

rcu: Merge per-RCU-flavor initialization into pre-existing macro

Rename the RCU_DATA_PTR_INIT() macro to RCU_INIT_FLAVOR() and
make it do the rcu_init_one() and rcu_boot_init_percpu_data()
calls.  Merge the loop that was in the original macro with the
loops that were in __rcu_init().

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
LKML-Reference: <12509746133916-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
 
