Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbZISH7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbZISH7l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 03:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbZISH7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 03:59:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:42878 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbZISH7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 03:59:37 -0400
Date: Sat, 19 Sep 2009 07:59:05 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <125329262011-git-send-email->
References: <125329262011-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Fix thinko, actually initialize full tree
Message-ID: <tip-49e291266d0920264471d9d64268fb030e33a99a@git.kernel.org>
Git-Commit-ID: 49e291266d0920264471d9d64268fb030e33a99a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 07:59:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49e291266d0920264471d9d64268fb030e33a99a
Gitweb:     http://git.kernel.org/tip/49e291266d0920264471d9d64268fb030e33a99a
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Fri, 18 Sep 2009 09:50:19 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 08:53:21 +0200

rcu: Fix thinko, actually initialize full tree

Commit de078d8 ("rcu: Need to update rnp->gpnum if preemptable RCU
is to be reliable") repeatedly and incorrectly initializes the root
rcu_node structure's ->gpnum field rather than initializing the
->gpnum field of each node in the tree.  Fix this.  Also add an
additional consistency check to catch this in the future.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
LKML-Reference: <125329262011-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcutree.c        |   11 ++++-------
 kernel/rcutree_plugin.h |    4 +++-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ae4a553..1b32cdd 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -601,8 +601,6 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 {
 	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
 	struct rcu_node *rnp = rcu_get_root(rsp);
-	struct rcu_node *rnp_cur;
-	struct rcu_node *rnp_end;
 
 	if (!cpu_needs_another_gp(rsp, rdp)) {
 		spin_unlock_irqrestore(&rnp->lock, flags);
@@ -659,13 +657,12 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	 * one corresponding to this CPU, due to the fact that we have
 	 * irqs disabled.
 	 */
-	rnp_end = &rsp->node[NUM_RCU_NODES];
-	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++) {
-		spin_lock(&rnp_cur->lock);	/* irqs already disabled. */
+	for (rnp = &rsp->node[0]; rnp < &rsp->node[NUM_RCU_NODES]; rnp++) {
+		spin_lock(&rnp->lock);	/* irqs already disabled. */
 		rcu_preempt_check_blocked_tasks(rnp);
-		rnp_cur->qsmask = rnp_cur->qsmaskinit;
+		rnp->qsmask = rnp->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
-		spin_unlock(&rnp_cur->lock);	/* irqs already disabled. */
+		spin_unlock(&rnp->lock);	/* irqs already disabled. */
 	}
 
 	rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state now OK. */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index cd6047c..09b7325 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -476,10 +476,12 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
 
 /*
  * Because there is no preemptable RCU, there can be no readers blocked,
- * so there is no need to check for blocked tasks.
+ * so there is no need to check for blocked tasks.  So check only for
+ * bogus qsmask values.
  */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 {
+	WARN_ON_ONCE(rnp->qsmask);
 }
 
 /*
