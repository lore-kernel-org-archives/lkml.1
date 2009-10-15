Return-Path: <linux-kernel-owner+w=401wt.eu-S932668AbZJOJ0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668AbZJOJ0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762563AbZJOJ0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:26:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:45697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760650AbZJOJ0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:26:13 -0400
Date: Thu, 15 Oct 2009 09:24:52 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, paulmck@linux.vnet.ibm.com,
       hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       npiggin@suse.de, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <12555405592133-git-send-email->
References: <12555405592133-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Prevent RCU IPI storms in presence of high call_rcu() load
Message-ID: <tip-37c72e56f6b234ea7387ba530434a80abf2658d8@git.kernel.org>
Git-Commit-ID: 37c72e56f6b234ea7387ba530434a80abf2658d8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 09:24:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37c72e56f6b234ea7387ba530434a80abf2658d8
Gitweb:     http://git.kernel.org/tip/37c72e56f6b234ea7387ba530434a80abf2658d8
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 14 Oct 2009 10:15:55 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 11:17:16 +0200

rcu: Prevent RCU IPI storms in presence of high call_rcu() load

As the number of callbacks on a given CPU rises, invoke
force_quiescent_state() only every blimit number of callbacks
(defaults to 10,000), and even then only if no other CPU has
invoked force_quiescent_state() in the meantime.

This should fix the performance regression reported by Nick.

Reported-by: Nick Piggin <npiggin@suse.de>
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
Cc: jens.axboe@oracle.com
LKML-Reference: <12555405592133-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |   29 ++++++++++++++++++++++++-----
 kernel/rcutree.h |    4 ++++
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 705f02a..ddbf111 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -958,7 +958,7 @@ static void rcu_offline_cpu(int cpu)
  * Invoke any RCU callbacks that have made it to the end of their grace
  * period.  Thottle as specified by rdp->blimit.
  */
-static void rcu_do_batch(struct rcu_data *rdp)
+static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list, **tail;
@@ -1011,6 +1011,13 @@ static void rcu_do_batch(struct rcu_data *rdp)
 	if (rdp->blimit == LONG_MAX && rdp->qlen <= qlowmark)
 		rdp->blimit = blimit;
 
+	/* Reset ->qlen_last_fqs_check trigger if enough CBs have drained. */
+	if (rdp->qlen == 0 && rdp->qlen_last_fqs_check != 0) {
+		rdp->qlen_last_fqs_check = 0;
+		rdp->n_force_qs_snap = rsp->n_force_qs;
+	} else if (rdp->qlen < rdp->qlen_last_fqs_check - qhimark)
+		rdp->qlen_last_fqs_check = rdp->qlen;
+
 	local_irq_restore(flags);
 
 	/* Re-raise the RCU softirq if there are callbacks remaining. */
@@ -1224,7 +1231,7 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 
 	/* If there are callbacks ready, invoke them. */
-	rcu_do_batch(rdp);
+	rcu_do_batch(rsp, rdp);
 }
 
 /*
@@ -1288,10 +1295,20 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 		rcu_start_gp(rsp, nestflag);  /* releases rnp_root->lock. */
 	}
 
-	/* Force the grace period if too many callbacks or too long waiting. */
-	if (unlikely(++rdp->qlen > qhimark)) {
+	/*
+	 * Force the grace period if too many callbacks or too long waiting.
+	 * Enforce hysteresis, and don't invoke force_quiescent_state()
+	 * if some other CPU has recently done so.  Also, don't bother
+	 * invoking force_quiescent_state() if the newly enqueued callback
+	 * is the only one waiting for a grace period to complete.
+	 */
+	if (unlikely(++rdp->qlen > rdp->qlen_last_fqs_check + qhimark)) {
 		rdp->blimit = LONG_MAX;
-		force_quiescent_state(rsp, 0);
+		if (rsp->n_force_qs == rdp->n_force_qs_snap &&
+		    *rdp->nxttail[RCU_DONE_TAIL] != head)
+			force_quiescent_state(rsp, 0);
+		rdp->n_force_qs_snap = rsp->n_force_qs;
+		rdp->qlen_last_fqs_check = rdp->qlen;
 	} else if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)
 		force_quiescent_state(rsp, 1);
 	local_irq_restore(flags);
@@ -1523,6 +1540,8 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
 	rdp->beenonline = 1;	 /* We have now been online. */
 	rdp->preemptable = preemptable;
 	rdp->passed_quiesc_completed = lastcomp - 1;
+	rdp->qlen_last_fqs_check = 0;
+	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
 	spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index b40ac57..599161f 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -167,6 +167,10 @@ struct rcu_data {
 	struct rcu_head *nxtlist;
 	struct rcu_head **nxttail[RCU_NEXT_SIZE];
 	long		qlen;		/* # of queued callbacks */
+	long		qlen_last_fqs_check;
+					/* qlen at last check for QS forcing */
+	unsigned long	n_force_qs_snap;
+					/* did other CPU force QS recently? */
 	long		blimit;		/* Upper limit on a processed batch */
 
 #ifdef CONFIG_NO_HZ
