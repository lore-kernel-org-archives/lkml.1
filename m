Return-Path: <linux-kernel-owner+w=401wt.eu-S1752208AbZIQWKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbZIQWKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 18:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZIQWKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 18:10:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:34243 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbZIQWK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 18:10:29 -0400
Date: Thu, 17 Sep 2009 22:10:01 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <12524504771622-git-send-email->
References: <12524504771622-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Need to update rnp->gpnum if preemptable RCU is to be reliable
Message-ID: <tip-de078d875cc7fc709f7818f26d38389c04369826@git.kernel.org>
Git-Commit-ID: de078d875cc7fc709f7818f26d38389c04369826
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 22:10:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de078d875cc7fc709f7818f26d38389c04369826
Gitweb:     http://git.kernel.org/tip/de078d875cc7fc709f7818f26d38389c04369826
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Tue, 8 Sep 2009 15:54:36 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Sep 2009 00:04:54 +0200

rcu: Need to update rnp->gpnum if preemptable RCU is to be reliable

Without this patch, tasks preempted in RCU read-side critical
sections can fail to block the grace period, given that
rnp->gpnum is used to determine which rnp->blocked_tasks[]
element the preempted task is enqueued on.

Before the patch, rnp->gpnum is always zero, so preempted tasks
are always enqueued on rnp->blocked_tasks[0], which is correct
only when the current CPU has not checked into the current
grace period and the grace-period number is even, or,
similarly, if the current CPU -has- checked into the current
grace period and the grace-period number is odd.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josht@linux.vnet.ibm.com
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
LKML-Reference: <12524504771622-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcutree.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6b11b07..c634a92 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -632,6 +632,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {
 		rnp->qsmask = rnp->qsmaskinit;
+		rnp->gpnum = rsp->gpnum;
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
@@ -657,8 +658,10 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	 */
 
 	rnp_end = rsp->level[NUM_RCU_LVLS - 1];
-	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++)
+	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++) {
 		rnp_cur->qsmask = rnp_cur->qsmaskinit;
+		rnp->gpnum = rsp->gpnum;
+	}
 
 	/*
 	 * Now set up the leaf nodes.  Here we must be careful.  First,
@@ -679,6 +682,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	for (; rnp_cur < rnp_end; rnp_cur++) {
 		spin_lock(&rnp_cur->lock);	/* irqs already disabled. */
 		rnp_cur->qsmask = rnp_cur->qsmaskinit;
+		rnp->gpnum = rsp->gpnum;
 		spin_unlock(&rnp_cur->lock);	/* irqs already disabled. */
 	}
 
