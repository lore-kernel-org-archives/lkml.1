Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbYGFJ0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbYGFJ0G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 05:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYGFJZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 05:25:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59576 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbYGFJZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 05:25:54 -0400
Message-ID: <48708F2B.9030803@cn.fujitsu.com>
Date: Sun, 06 Jul 2008 17:23:55 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Gautham Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 1/2] rcu classic: simplify the next pending batch
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use a batch number(rcp->pending) instead of a flag(rcp->next_pending)

rcu_start_batch() need to change this flag, so mb()s is needed
for memory-access safe.

but(after this patch applied) rcu_start_batch() do not change
this batch number(rcp->pending), rcp->pending is managed by
__rcu_process_callbacks only, and troublesome mb()s are eliminated.

And codes look simpler and clearer.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index b3aa05b..5efd734 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -45,7 +45,7 @@
 struct rcu_ctrlblk {
 	long	cur;		/* Current batch number.                      */
 	long	completed;	/* Number of the last completed batch         */
-	int	next_pending;	/* Is the next batch already waiting?         */
+	long	pending;	/* Number of the last pending batch           */
 
 	int	signaled;
 
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index a38895a..9ac3b94 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -60,12 +60,14 @@ EXPORT_SYMBOL_GPL(rcu_lock_map);
 static struct rcu_ctrlblk rcu_ctrlblk = {
 	.cur = -300,
 	.completed = -300,
+	.pending = -300,
 	.lock = __SPIN_LOCK_UNLOCKED(&rcu_ctrlblk.lock),
 	.cpumask = CPU_MASK_NONE,
 };
 static struct rcu_ctrlblk rcu_bh_ctrlblk = {
 	.cur = -300,
 	.completed = -300,
+	.pending = -300,
 	.lock = __SPIN_LOCK_UNLOCKED(&rcu_bh_ctrlblk.lock),
 	.cpumask = CPU_MASK_NONE,
 };
@@ -276,14 +278,8 @@ static void rcu_do_batch(struct rcu_data *rdp)
  */
 static void rcu_start_batch(struct rcu_ctrlblk *rcp)
 {
-	if (rcp->next_pending &&
+	if (rcp->cur != rcp->pending &&
 			rcp->completed == rcp->cur) {
-		rcp->next_pending = 0;
-		/*
-		 * next_pending == 0 must be visible in
-		 * __rcu_process_callbacks() before it can see new value of cur.
-		 */
-		smp_wmb();
 		rcp->cur++;
 
 		/*
@@ -437,16 +433,14 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
 
 		/* determine batch number */
 		rdp->batch = rcp->cur + 1;
-		/* see the comment and corresponding wmb() in
-		 * the rcu_start_batch()
-		 */
-		smp_rmb();
 
-		if (!rcp->next_pending) {
+		if (rcu_batch_after(rdp->batch, rcp->pending)) {
 			/* and start it/schedule start if it's a new batch */
 			spin_lock(&rcp->lock);
-			rcp->next_pending = 1;
-			rcu_start_batch(rcp);
+			if (rcu_batch_after(rdp->batch, rcp->pending)) {
+				rcp->pending = rdp->batch;
+				rcu_start_batch(rcp);
+			}
 			spin_unlock(&rcp->lock);
 		}
 	}













