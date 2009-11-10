Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbZKJVht (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 10 Nov 2009 16:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758285AbZKJVhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:37:11 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36875 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758283AbZKJVhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:37:08 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/4] rcu: rename dynticks_completed to completed_fqs
Date: Tue, 10 Nov 2009 13:37:21 -0800
Message-Id: <12578890423298-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091110213651.GA21411@linux.vnet.ibm.com>
References: <20091110213651.GA21411@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

This field is used whether or not CONFIG_NO_HZ is set, so the old name
of ->dynticks_completed is quite misleading.  Change to ->completed_fqs,
given that it the value that force_quiescent_state() is trying to drive
the ->completed field away from.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    4 ++--
 kernel/rcutree.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index af9ea09..4026560 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -187,7 +187,7 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
  */
 static void dyntick_record_completed(struct rcu_state *rsp, long comp)
 {
-	rsp->dynticks_completed = comp;
+	rsp->completed_fqs = comp;
 }
 
 #ifdef CONFIG_SMP
@@ -197,7 +197,7 @@ static void dyntick_record_completed(struct rcu_state *rsp, long comp)
  */
 static long dyntick_recall_completed(struct rcu_state *rsp)
 {
-	return rsp->dynticks_completed;
+	return rsp->completed_fqs;
 }
 
 /*
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index e2f07a2..f478503 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -264,6 +264,8 @@ struct rcu_state {
 	long orphan_qlen;			/* Number of orphaned cbs. */
 	spinlock_t fqslock;			/* Only one task forcing */
 						/*  quiescent states. */
+	long	completed_fqs;			/* Value of completed @ snap. */
+						/*  Protected by fqslock. */
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
 						/*  force_quiescent_state(). */
 	unsigned long n_force_qs;		/* Number of calls to */
@@ -278,8 +280,6 @@ struct rcu_state {
 	unsigned long jiffies_stall;		/* Time at which to check */
 						/*  for CPU stalls. */
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-	long dynticks_completed;		/* Value of completed @ snap. */
-						/*  Protected by fqslock. */
 };
 
 #ifdef RCU_TREE_NONCORE
-- 
1.5.2.5

