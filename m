Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453Ab0AMK1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab0AMK1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333Ab0AMK07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:26:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:58634 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab0AMK06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:26:58 -0500
Date: Wed, 13 Jan 2010 10:26:09 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12626465503786-git-send-email->
References: <12626465503786-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Eliminate second argument of rcu_process_dyntick()
Message-ID: <tip-eb1ba45f1e7f6e626fefc063b340c7cbec9bd8c7@git.kernel.org>
Git-Commit-ID: eb1ba45f1e7f6e626fefc063b340c7cbec9bd8c7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:26:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb1ba45f1e7f6e626fefc063b340c7cbec9bd8c7
Gitweb:     http://git.kernel.org/tip/eb1ba45f1e7f6e626fefc063b340c7cbec9bd8c7
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 4 Jan 2010 15:09:05 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:06:03 +0100

rcu: Eliminate second argument of rcu_process_dyntick()

At this point, the second argument to all calls to
rcu_process_dyntick() is a function of the same field of the
structure passed in as the first argument, namely, rsp->gpnum-1.
 So propagate rsp->gpnum-1 to all uses of the second argument
within rcu_process_dyntick() and then eliminate the second
argument.

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
LKML-Reference: <12626465503786-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 62b6433..c7d0070 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1147,7 +1147,7 @@ void rcu_check_callbacks(int cpu, int user)
  * Returns 1 if the current grace period ends while scanning (possibly
  * because we made it end).
  */
-static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
+static int rcu_process_dyntick(struct rcu_state *rsp,
 			       int (*f)(struct rcu_data *))
 {
 	unsigned long bit;
@@ -1159,7 +1159,7 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 	rcu_for_each_leaf_node(rsp, rnp) {
 		mask = 0;
 		spin_lock_irqsave(&rnp->lock, flags);
-		if (rnp->completed != lastcomp) {
+		if (rnp->completed != rsp->gpnum - 1) {
 			spin_unlock_irqrestore(&rnp->lock, flags);
 			return 1;
 		}
@@ -1173,7 +1173,7 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 			if ((rnp->qsmask & bit) != 0 && f(rsp->rda[cpu]))
 				mask |= bit;
 		}
-		if (mask != 0 && rnp->completed == lastcomp) {
+		if (mask != 0 && rnp->completed == rsp->gpnum - 1) {
 
 			/* rcu_report_qs_rnp() releases rnp->lock. */
 			rcu_report_qs_rnp(mask, rsp, rnp, flags);
@@ -1226,7 +1226,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 			break; /* So gcc recognizes the dead code. */
 
 		/* Record dyntick-idle state. */
-		gpdone = rcu_process_dyntick(rsp, rsp->gpnum - 1,
+		gpdone = rcu_process_dyntick(rsp,
 					     dyntick_save_progress_counter);
 		spin_lock(&rnp->lock);  /* irqs already disabled */
 		if (gpdone)
@@ -1249,8 +1249,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
 		spin_unlock(&rnp->lock);  /* irqs remain disabled */
-		gpdone = rcu_process_dyntick(rsp, rsp->gpnum - 1,
-					     rcu_implicit_dynticks_qs);
+		gpdone = rcu_process_dyntick(rsp, rcu_implicit_dynticks_qs);
 
 		/* Leave state in case more forcing is required. */
 
