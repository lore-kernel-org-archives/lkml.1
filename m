Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab0BWBrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:47:52 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39662 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656Ab0BWBru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:47:50 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, jkacur@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC 1/2] rcu: fix deadlock in TREE_PREEMPT_RCU CPU stall detection
Date: Mon, 22 Feb 2010 17:47:45 -0800
Message-Id: <1266889666-3471-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100223014654.GA3404@linux.vnet.ibm.com>
References: <20100223014654.GA3404@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under TREE_PREEMPT_RCU, print_other_cpu_stall() invokes
rcu_print_task_stall() with the root rcu_node structure's ->lock held,
and rcu_print_task_stall() acquires that same lock for self-deadlock.
Fix this by removing the lock acquisition from rcu_print_task_stall(),
and making all callers acquire the lock instead.

Tested-by: John Kacur <jkacur@redhat.com>
Tested-by: Thomas Gleixner <tglx@linutronix.de>
Located-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |    2 ++
 kernel/rcutree_plugin.h |    3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 53ae959..6f652f1 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -458,7 +458,9 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 
 	printk(KERN_ERR "INFO: RCU detected CPU stalls:");
 	rcu_for_each_leaf_node(rsp, rnp) {
+		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rcu_print_task_stall(rnp);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		if (rnp->qsmask == 0)
 			continue;
 		for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 37fbccd..e31cda7 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -306,18 +306,15 @@ EXPORT_SYMBOL_GPL(__rcu_read_unlock);
  */
 static void rcu_print_task_stall(struct rcu_node *rnp)
 {
-	unsigned long flags;
 	struct list_head *lp;
 	int phase;
 	struct task_struct *t;
 
 	if (rcu_preempted_readers(rnp)) {
-		spin_lock_irqsave(&rnp->lock, flags);
 		phase = rnp->gpnum & 0x1;
 		lp = &rnp->blocked_tasks[phase];
 		list_for_each_entry(t, lp, rcu_node_entry)
 			printk(" P%d", t->pid);
-		spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 }
 
-- 
1.6.6

