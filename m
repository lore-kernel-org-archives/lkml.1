Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442Ab0AMK01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab0AMK01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333Ab0AMK0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:26:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:38044 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab0AMK0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:26:23 -0500
Date: Wed, 13 Jan 2010 10:25:53 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12626465502985-git-send-email->
References: <12626465502985-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Eliminate local variable lastcomp from force_quiescent_state()
Message-ID: <tip-39c0bbfc07c6e28db7346d0e11106f2d045d3035@git.kernel.org>
Git-Commit-ID: 39c0bbfc07c6e28db7346d0e11106f2d045d3035
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:25:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39c0bbfc07c6e28db7346d0e11106f2d045d3035
Gitweb:     http://git.kernel.org/tip/39c0bbfc07c6e28db7346d0e11106f2d045d3035
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 4 Jan 2010 15:09:04 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:06:03 +0100

rcu: Eliminate local variable lastcomp from force_quiescent_state()

Because rsp->fqs_active is set to 1 across
force_quiescent_state()'s switch statement, rcu_start_gp() will
refrain from starting a new grace period during this time.
Therefore, rsp->gpnum is constant, and can be propagated to all
uses of lastcomp, eliminating this local variable.

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
LKML-Reference: <12626465502985-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |   10 +++-------
 kernel/rcutree.h |    2 --
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 1d8cfb1..62b6433 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1191,7 +1191,6 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 {
 	unsigned long flags;
-	long lastcomp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 	u8 forcenow;
 	u8 gpdone;
@@ -1207,7 +1206,6 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 		goto unlock_fqs_ret; /* no emergency and done recently. */
 	rsp->n_force_qs++;
 	spin_lock(&rnp->lock);  /* irqs already disabled */
-	lastcomp = rsp->gpnum - 1;
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	if(!rcu_gp_in_progress(rsp)) {
 		rsp->n_force_qs_ngp++;
@@ -1228,7 +1226,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 			break; /* So gcc recognizes the dead code. */
 
 		/* Record dyntick-idle state. */
-		gpdone = rcu_process_dyntick(rsp, lastcomp,
+		gpdone = rcu_process_dyntick(rsp, rsp->gpnum - 1,
 					     dyntick_save_progress_counter);
 		spin_lock(&rnp->lock);  /* irqs already disabled */
 		if (gpdone)
@@ -1239,11 +1237,9 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 
 		/* Update state, record completion counter. */
 		forcenow = 0;
-		if (lastcomp + 1 == rsp->gpnum &&
-		    lastcomp == rsp->completed) {
+		if (rsp->gpnum - 1 == rsp->completed) {
 			forcenow = rsp->signaled == RCU_SAVE_COMPLETED;
 			rsp->signaled = RCU_FORCE_QS;
-			rsp->completed_fqs = lastcomp;
 		}
 		if (!forcenow)
 			break;
@@ -1253,7 +1249,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
 		spin_unlock(&rnp->lock);  /* irqs remain disabled */
-		gpdone = rcu_process_dyntick(rsp, rsp->completed_fqs,
+		gpdone = rcu_process_dyntick(rsp, rsp->gpnum - 1,
 					     rcu_implicit_dynticks_qs);
 
 		/* Leave state in case more forcing is required. */
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index dc386a7..5348561 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -296,8 +296,6 @@ struct rcu_state {
 	long orphan_qlen;			/* Number of orphaned cbs. */
 	spinlock_t fqslock;			/* Only one task forcing */
 						/*  quiescent states. */
-	long	completed_fqs;			/* Value of completed @ snap. */
-						/*  Protected by fqslock. */
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
 						/*  force_quiescent_state(). */
 	unsigned long n_force_qs;		/* Number of calls to */
