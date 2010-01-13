Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499Ab0AMK1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0AMK1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333Ab0AMK1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:27:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:58696 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab0AMK1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:27:45 -0500
Date: Wed, 13 Jan 2010 10:26:56 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1262646550562-git-send-email->
References: <1262646550562-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Remove redundant grace-period check
Message-ID: <tip-45f014c52eef022873b19d6a20eb0ec9668f2b09@git.kernel.org>
Git-Commit-ID: 45f014c52eef022873b19d6a20eb0ec9668f2b09
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:26:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45f014c52eef022873b19d6a20eb0ec9668f2b09
Gitweb:     http://git.kernel.org/tip/45f014c52eef022873b19d6a20eb0ec9668f2b09
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 4 Jan 2010 15:09:08 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:06:04 +0100

rcu: Remove redundant grace-period check

The rcu_process_dyntick() function checks twice for the end of
the current grace period.  However, it holds the current
rcu_node structure's ->lock field throughout, and doesn't get to
the second call to rcu_gp_in_progress() unless there is at least
one CPU corresponding to this rcu_node structure that has not
yet checked in for the current grace period, which would prevent
the current grace period from ending. So the current grace
period cannot have ended, and the second check is redundant, so
remove it.

Also, given that this function is used even with !CONFIG_NO_HZ,
its name is quite misleading.  Change from rcu_process_dyntick()
to force_qs_rnp().

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
LKML-Reference: <1262646550562-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6268f37..d920285 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1146,8 +1146,7 @@ void rcu_check_callbacks(int cpu, int user)
  * have not yet encountered a quiescent state, using the function specified.
  * The caller must have suppressed start of new grace periods.
  */
-static void rcu_process_dyntick(struct rcu_state *rsp,
-				int (*f)(struct rcu_data *))
+static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 {
 	unsigned long bit;
 	int cpu;
@@ -1172,7 +1171,7 @@ static void rcu_process_dyntick(struct rcu_state *rsp,
 			if ((rnp->qsmask & bit) != 0 && f(rsp->rda[cpu]))
 				mask |= bit;
 		}
-		if (mask != 0 && rcu_gp_in_progress(rsp)) {
+		if (mask != 0) {
 
 			/* rcu_report_qs_rnp() releases rnp->lock. */
 			rcu_report_qs_rnp(mask, rsp, rnp, flags);
@@ -1222,7 +1221,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 			break; /* So gcc recognizes the dead code. */
 
 		/* Record dyntick-idle state. */
-		rcu_process_dyntick(rsp, dyntick_save_progress_counter);
+		force_qs_rnp(rsp, dyntick_save_progress_counter);
 		spin_lock(&rnp->lock);  /* irqs already disabled */
 		if (rcu_gp_in_progress(rsp))
 			rsp->signaled = RCU_FORCE_QS;
@@ -1232,7 +1231,7 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
 		spin_unlock(&rnp->lock);  /* irqs remain disabled */
-		rcu_process_dyntick(rsp, rcu_implicit_dynticks_qs);
+		force_qs_rnp(rsp, rcu_implicit_dynticks_qs);
 
 		/* Leave state in case more forcing is required. */
 
