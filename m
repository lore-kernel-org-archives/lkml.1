Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463Ab0AMK0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab0AMK0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452Ab0AMK0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:26:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:38053 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352Ab0AMK03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:26:29 -0500
Date: Wed, 13 Jan 2010 10:25:36 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1262646550602-git-send-email->
References: <1262646550602-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Eliminate local variable signaled from force_quiescent_state()
Message-ID: <tip-f3a8b5c6aa543bd87764418d63632eb65b80e2f6@git.kernel.org>
Git-Commit-ID: f3a8b5c6aa543bd87764418d63632eb65b80e2f6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:25:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3a8b5c6aa543bd87764418d63632eb65b80e2f6
Gitweb:     http://git.kernel.org/tip/f3a8b5c6aa543bd87764418d63632eb65b80e2f6
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 4 Jan 2010 15:09:03 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:06:02 +0100

rcu: Eliminate local variable signaled from force_quiescent_state()

Because the root rcu_node lock is held across entry to the
switch statement in force_quiescent_state(), it is no longer
necessary to snapshot rsp->signaled to a local variable.
Eliminate both the snapshotting and the local variable.

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
LKML-Reference: <1262646550602-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 41688ff..1d8cfb1 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1193,7 +1193,6 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	unsigned long flags;
 	long lastcomp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
-	u8 signaled;
 	u8 forcenow;
 	u8 gpdone;
 
@@ -1209,7 +1208,6 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	rsp->n_force_qs++;
 	spin_lock(&rnp->lock);  /* irqs already disabled */
 	lastcomp = rsp->gpnum - 1;
-	signaled = rsp->signaled;
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	if(!rcu_gp_in_progress(rsp)) {
 		rsp->n_force_qs_ngp++;
@@ -1217,7 +1215,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		goto unlock_fqs_ret;  /* no GP in progress, time updated. */
 	}
 	rsp->fqs_active = 1;
-	switch (signaled) {
+	switch (rsp->signaled) {
 	case RCU_GP_IDLE:
 	case RCU_GP_INIT:
 
@@ -1242,11 +1240,10 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		/* Update state, record completion counter. */
 		forcenow = 0;
 		if (lastcomp + 1 == rsp->gpnum &&
-		    lastcomp == rsp->completed &&
-		    rsp->signaled == signaled) {
+		    lastcomp == rsp->completed) {
+			forcenow = rsp->signaled == RCU_SAVE_COMPLETED;
 			rsp->signaled = RCU_FORCE_QS;
 			rsp->completed_fqs = lastcomp;
-			forcenow = signaled == RCU_SAVE_COMPLETED;
 		}
 		if (!forcenow)
 			break;
