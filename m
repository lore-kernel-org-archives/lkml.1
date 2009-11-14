Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbZKNKTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbZKNKTx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 05:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbZKNKTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 05:19:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:37667 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552AbZKNKTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 05:19:51 -0500
Date: Sat, 14 Nov 2009 10:19:11 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12581706991966-git-send-email->
References: <12581706991966-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Eliminate __rcu_pending() false positives
Message-ID: <tip-2f51f9884f6a36b0fe9636d5a1937e5cbd25723b@git.kernel.org>
Git-Commit-ID: 2f51f9884f6a36b0fe9636d5a1937e5cbd25723b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f51f9884f6a36b0fe9636d5a1937e5cbd25723b
Gitweb:     http://git.kernel.org/tip/2f51f9884f6a36b0fe9636d5a1937e5cbd25723b
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Fri, 13 Nov 2009 19:51:39 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 14 Nov 2009 10:31:42 +0100

rcu: Eliminate __rcu_pending() false positives

Now that there are both ->gpnum and ->completed fields in the
rcu_node structure, __rcu_pending() should check rdp->gpnum and
rdp->completed against rnp->gpnum and rdp->completed, respectively,
instead of the prior comparison against the rcu_state fields
rsp->gpnum and rsp->completed.

Given the old comparison, __rcu_pending() could return 1, resulting
in a needless raise_softirq(RCU_SOFTIRQ).  This useless work would
happen if RCU responded to a scheduling-clock interrupt after the
rcu_state fields had been updated, but before the rcu_node fields
had been updated.

Changing the comparison from the rcu_state fields to the rcu_node
fields prevents this useless work from happening.

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
LKML-Reference: <12581706991966-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 24bbf2c..9b36d6d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1403,6 +1403,8 @@ EXPORT_SYMBOL_GPL(call_rcu_bh);
  */
 static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 {
+	struct rcu_node *rnp = rdp->mynode;
+
 	rdp->n_rcu_pending++;
 
 	/* Check for CPU stalls, if enabled. */
@@ -1427,13 +1429,13 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 
 	/* Has another RCU grace period completed?  */
-	if (ACCESS_ONCE(rsp->completed) != rdp->completed) { /* outside lock */
+	if (ACCESS_ONCE(rnp->completed) != rdp->completed) { /* outside lock */
 		rdp->n_rp_gp_completed++;
 		return 1;
 	}
 
 	/* Has a new RCU grace period started? */
-	if (ACCESS_ONCE(rsp->gpnum) != rdp->gpnum) { /* outside lock */
+	if (ACCESS_ONCE(rnp->gpnum) != rdp->gpnum) { /* outside lock */
 		rdp->n_rp_gp_started++;
 		return 1;
 	}
