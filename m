Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488Ab0AMK1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab0AMK1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462Ab0AMK1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:27:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:58658 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333Ab0AMK1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:27:13 -0500
Date: Wed, 13 Jan 2010 10:26:25 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12626465501857-git-send-email->
References: <12626465501857-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Eliminate rcu_process_dyntick() return value
Message-ID: <tip-0f10dc826646134dce3e5751512b87d30f3903e4@git.kernel.org>
Git-Commit-ID: 0f10dc826646134dce3e5751512b87d30f3903e4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:26:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f10dc826646134dce3e5751512b87d30f3903e4
Gitweb:     http://git.kernel.org/tip/0f10dc826646134dce3e5751512b87d30f3903e4
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 4 Jan 2010 15:09:06 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:06:03 +0100

rcu: Eliminate rcu_process_dyntick() return value

Because a new grace period cannot start while we are executing
within the force_quiescent_state() function's switch statement,
if any test within that switch statement or within any function
called from that switch statement shows that the current grace
period has ended, we can safely re-do that test any time before
we leave the switch statement.  This means that we no longer
need a return value from rcu_process_dyntick(), as we can simply
invoke rcu_gp_in_progress() to check whether the old grace
period has finished -- there is no longer any need to worry
about whether or not a new grace period has been started.

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
LKML-Reference: <12626465501857-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index c7d0070..e497119 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1144,11 +1144,9 @@ void rcu_check_callbacks(int cpu, int user)
 /*
  * Scan the leaf rcu_node structures, processing dyntick state for any that
  * have not yet encountered a quiescent state, using the function specified.
- * Returns 1 if the current grace period ends while scanning (possibly
- * because we made it end).
  */
-static int rcu_process_dyntick(struct rcu_state *rsp,
-			       int (*f)(struct rcu_data *))
+static void rcu_process_dyntick(struct rcu_state *rsp,
+				int (*f)(struct rcu_data *))
 {
 	unsigned long bit;
 	int cpu;
@@ -1161,7 +1159,7 @@ static int rcu_process_dyntick(struct rcu_state *rsp,
 		spin_lock_irqsave(&rnp->lock, flags);
 		if (rnp->completed != rsp->gpnum - 1) {
 			spin_unlock_irqrestore(&rnp->lock, flags);
-			return 1;
+			return;
 		}
 		if (rnp->qsmask == 0) {
 			spin_unlock_irqrestore(&rnp->lock, flags);
@@ -1181,7 +1179,6 @@ static int rcu_process_dyntick(struct rcu_state *rsp,
 		}
 		spin_unlock_irqrestore(&rnp->lock, flags);
 	}
-	return 0;
 }
 
 /*
@@ -1193,7 +1190,6 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 	u8 forcenow;
-	u8 gpdone;
 
 	if (!rcu_gp_in_progress(rsp))
 		return;  /* No grace period in progress, nothing to force. */
@@ -1226,10 +1222,9 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 			break; /* So gcc recognizes the dead code. */
 
 		/* Record dyntick-idle state. */
-		gpdone = rcu_process_dyntick(rsp,
-					     dyntick_save_progress_counter);
+		rcu_process_dyntick(rsp, dyntick_save_progress_counter);
 		spin_lock(&rnp->lock);  /* irqs already disabled */
-		if (gpdone)
+		if (!rcu_gp_in_progress(rsp))
 			break;
 		/* fall into next case. */
 
@@ -1249,7 +1244,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
 		spin_unlock(&rnp->lock);  /* irqs remain disabled */
-		gpdone = rcu_process_dyntick(rsp, rcu_implicit_dynticks_qs);
+		rcu_process_dyntick(rsp, rcu_implicit_dynticks_qs);
 
 		/* Leave state in case more forcing is required. */
 
