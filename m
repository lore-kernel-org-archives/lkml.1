Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438Ab0AMKZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab0AMKZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420Ab0AMKZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:25:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:37979 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333Ab0AMKZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:25:27 -0500
Date: Wed, 13 Jan 2010 10:24:45 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12626465501455-git-send-email->
References: <12626465501455-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Adjust force_quiescent_state() locking, step 1
Message-ID: <tip-f96e9232e04856c781d4f71923a46dd3f7b429fa@git.kernel.org>
Git-Commit-ID: f96e9232e04856c781d4f71923a46dd3f7b429fa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:24:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f96e9232e04856c781d4f71923a46dd3f7b429fa
Gitweb:     http://git.kernel.org/tip/f96e9232e04856c781d4f71923a46dd3f7b429fa
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 4 Jan 2010 15:09:00 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:06:01 +0100

rcu: Adjust force_quiescent_state() locking, step 1

This causes rnp->lock to be held on entry to
force_quiescent_state()'s switch statement.  This is a first
step towards prohibiting starting grace periods while
force_quiescent_state() is executing, which will reduce the
number and complexity of races that force_quiescent_state() is
involved in.

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
LKML-Reference: <12626465501455-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 53ae959..eae331d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1204,7 +1204,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	}
 	if (relaxed &&
 	    (long)(rsp->jiffies_force_qs - jiffies) >= 0)
-		goto unlock_ret; /* no emergency and done recently. */
+		goto unlock_fqs_ret; /* no emergency and done recently. */
 	rsp->n_force_qs++;
 	spin_lock(&rnp->lock);
 	lastcomp = rsp->gpnum - 1;
@@ -1213,31 +1213,32 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	if(!rcu_gp_in_progress(rsp)) {
 		rsp->n_force_qs_ngp++;
 		spin_unlock(&rnp->lock);
-		goto unlock_ret;  /* no GP in progress, time updated. */
+		goto unlock_fqs_ret;  /* no GP in progress, time updated. */
 	}
-	spin_unlock(&rnp->lock);
 	switch (signaled) {
 	case RCU_GP_IDLE:
 	case RCU_GP_INIT:
 
+		spin_unlock(&rnp->lock);
 		break; /* grace period idle or initializing, ignore. */
 
 	case RCU_SAVE_DYNTICK:
 
+		spin_unlock(&rnp->lock);
 		if (RCU_SIGNAL_INIT != RCU_SAVE_DYNTICK)
 			break; /* So gcc recognizes the dead code. */
 
 		/* Record dyntick-idle state. */
 		if (rcu_process_dyntick(rsp, lastcomp,
 					dyntick_save_progress_counter))
-			goto unlock_ret;
+			goto unlock_fqs_ret;
+		spin_lock(&rnp->lock);
 		/* fall into next case. */
 
 	case RCU_SAVE_COMPLETED:
 
 		/* Update state, record completion counter. */
 		forcenow = 0;
-		spin_lock(&rnp->lock);
 		if (lastcomp + 1 == rsp->gpnum &&
 		    lastcomp == rsp->completed &&
 		    rsp->signaled == signaled) {
@@ -1245,23 +1246,31 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 			rsp->completed_fqs = lastcomp;
 			forcenow = signaled == RCU_SAVE_COMPLETED;
 		}
-		spin_unlock(&rnp->lock);
-		if (!forcenow)
+		if (!forcenow) {
+			spin_unlock(&rnp->lock);
 			break;
+		}
 		/* fall into next case. */
 
 	case RCU_FORCE_QS:
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
+		spin_unlock(&rnp->lock);
 		if (rcu_process_dyntick(rsp, rsp->completed_fqs,
 					rcu_implicit_dynticks_qs))
-			goto unlock_ret;
+			goto unlock_fqs_ret;
 
 		/* Leave state in case more forcing is required. */
 
 		break;
+
+	default:
+
+		spin_unlock(&rnp->lock);
+		WARN_ON_ONCE(1);
+		break;
 	}
-unlock_ret:
+unlock_fqs_ret:
 	spin_unlock_irqrestore(&rsp->fqslock, flags);
 }
 
