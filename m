Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZJNR2y (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 14 Oct 2009 13:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZJNR2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:28:52 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33641 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbZJNR2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:28:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, npiggin@suse.de,
        jens.axboe@oracle.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/6] rcu: stopgap fix for synchronize_rcu_expedited() for TREE_PREEMPT_RCU
Date: Wed, 14 Oct 2009 10:15:56 -0700
Message-Id: <12555405592331-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091014171517.GA13635@linux.vnet.ibm.com>
References: <20091014171517.GA13635@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

For the short term, map synchronize_rcu_expedited() to synchronize_rcu()
for TREE_PREEMPT_RCU and to synchronize_sched_expedited() for TREE_RCU.
Longer term, there needs to be a real expedited grace period for
TREE_PREEMPT_RCU, but candidate patches to date are considerably more
complex and intrusive.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcutree.h |    6 +-----
 kernel/rcutree_plugin.h |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 46e9ab3..9642c6b 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -76,11 +76,7 @@ static inline void __rcu_read_unlock_bh(void)
 
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));
-
-static inline void synchronize_rcu_expedited(void)
-{
-	synchronize_sched_expedited();
-}
+extern void synchronize_rcu_expedited(void);
 
 static inline void synchronize_rcu_bh_expedited(void)
 {
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c0cb783..acef871 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -393,6 +393,16 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 EXPORT_SYMBOL_GPL(call_rcu);
 
 /*
+ * Wait for an rcu-preempt grace period.  We are supposed to expedite the
+ * grace period, but this is the crude slow compatability hack, so just
+ * invoke synchronize_rcu().
+ */
+void synchronize_rcu_expedited(void)
+{
+	synchronize_rcu();
+}
+
+/*
  * Check to see if there is any immediate preemptable-RCU-related work
  * to be done.
  */
@@ -565,6 +575,15 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 EXPORT_SYMBOL_GPL(call_rcu);
 
 /*
+ * Wait for an rcu-preempt grace period, but make it happen quickly.
+ * But because preemptable RCU does not exist, map to rcu-sched.
+ */
+void synchronize_rcu_expedited(void)
+{
+	synchronize_sched_expedited();
+}
+
+/*
  * Because preemptable RCU does not exist, it never has any work to do.
  */
 static int rcu_preempt_pending(int cpu)
-- 
1.5.2.5

