Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069Ab0BYKPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:15:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:41062 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758970Ab0BYKPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:15:21 -0500
Date: Thu, 25 Feb 2010 10:14:32 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, jkacur@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1266887105-1528-19-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1266887105-1528-19-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Fix deadlock in TREE_PREEMPT_RCU CPU stall detection
Message-ID: <tip-3acd9eb31c5f7eb97cb2009fa41472710fb4a10f@git.kernel.org>
Git-Commit-ID: 3acd9eb31c5f7eb97cb2009fa41472710fb4a10f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:14:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3acd9eb31c5f7eb97cb2009fa41472710fb4a10f
Gitweb:     http://git.kernel.org/tip/3acd9eb31c5f7eb97cb2009fa41472710fb4a10f
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 22 Feb 2010 17:05:03 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 10:34:59 +0100

rcu: Fix deadlock in TREE_PREEMPT_RCU CPU stall detection

Under TREE_PREEMPT_RCU, print_other_cpu_stall() invokes
rcu_print_task_stall() with the root rcu_node structure's ->lock
held, and rcu_print_task_stall() acquires that same lock for
self-deadlock. Fix this by removing the lock acquisition from
rcu_print_task_stall(), and making all callers acquire the lock
instead.

Tested-by: John Kacur <jkacur@redhat.com>
Tested-by: Thomas Gleixner <tglx@linutronix.de>
Located-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <1266887105-1528-19-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c        |    2 ++
 kernel/rcutree_plugin.h |    3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 65a807b..b07be37 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -476,7 +476,9 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 
 	printk(KERN_ERR "INFO: RCU detected CPU stalls:");
 	rcu_for_each_leaf_node(rsp, rnp) {
+		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rcu_print_task_stall(rnp);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		if (rnp->qsmask == 0)
 			continue;
 		for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index a8b2e83..aecfe37 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -318,18 +318,15 @@ EXPORT_SYMBOL_GPL(__rcu_read_unlock);
  */
 static void rcu_print_task_stall(struct rcu_node *rnp)
 {
-	unsigned long flags;
 	struct list_head *lp;
 	int phase;
 	struct task_struct *t;
 
 	if (rcu_preempted_readers(rnp)) {
-		raw_spin_lock_irqsave(&rnp->lock, flags);
 		phase = rnp->gpnum & 0x1;
 		lp = &rnp->blocked_tasks[phase];
 		list_for_each_entry(t, lp, rcu_node_entry)
 			printk(" P%d", t->pid);
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 }
 
