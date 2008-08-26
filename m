Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbYHZRiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbYHZRiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbYHZRhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:37:19 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:54171
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757700AbYHZRhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:37:18 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v2 3/6] sched: make double-lock-balance fair
To: mingo@elte.hu
Cc: srostedt@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, npiggin@suse.de,
       gregory.haskins@gmail.com
Date: Tue, 26 Aug 2008 13:35:00 -0400
Message-ID: <20080826173500.16413.40514.stgit@dev.haskins.net>
In-Reply-To: <20080826173131.16413.17862.stgit@dev.haskins.net>
References: <20080826173131.16413.17862.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

double_lock balance() currently favors logically lower cpus since they
often do not have to release their own lock to acquire a second lock.
The result is that logically higher cpus can get starved when there is
a lot of pressure on the RQs.  This can result in higher latencies on
higher cpu-ids.

This patch makes the algorithm more fair by forcing all paths to have
to release both locks before acquiring them again.  Since callsites to
double_lock_balance already consider it a potential preemption/reschedule
point, they have the proper logic to recheck for atomicity violations.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |   52 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index df6b447..850b454 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2782,21 +2782,43 @@ static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
 		__release(rq2->lock);
 }
 
+#ifdef CONFIG_PREEMPT
+
 /*
- * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
+ * fair double_lock_balance: Safely acquires both rq->locks in a fair
+ * way at the expense of forcing extra atomic operations in all
+ * invocations.  This assures that the double_lock is acquired using the
+ * same underlying policy as the spinlock_t on this architecture, which
+ * reduces latency compared to the unfair variant below.  However, it
+ * also adds more overhead and therefore may reduce throughput.
  */
-static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
+static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
+	__releases(this_rq->lock)
+	__acquires(busiest->lock)
+	__acquires(this_rq->lock)
+{
+	spin_unlock(&this_rq->lock);
+	double_rq_lock(this_rq, busiest);
+
+	return 1;
+}
+
+#else
+
+/*
+ * Unfair double_lock_balance: Optimizes throughput at the expense of
+ * latency by eliminating extra atomic operations when the locks are
+ * already in proper order on entry.  This favors lower cpu-ids and will
+ * grant the double lock to lower cpus over higher ids under contention,
+ * regardless of entry order into the function.
+ */
+static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
 	__releases(this_rq->lock)
 	__acquires(busiest->lock)
 	__acquires(this_rq->lock)
 {
 	int ret = 0;
 
-	if (unlikely(!irqs_disabled())) {
-		/* printk() doesn't work good under rq->lock */
-		spin_unlock(&this_rq->lock);
-		BUG_ON(1);
-	}
 	if (unlikely(!spin_trylock(&busiest->lock))) {
 		if (busiest < this_rq) {
 			spin_unlock(&this_rq->lock);
@@ -2809,6 +2831,22 @@ static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
 	return ret;
 }
 
+#endif /* CONFIG_PREEMPT */
+
+/*
+ * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
+ */
+static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
+{
+	if (unlikely(!irqs_disabled())) {
+		/* printk() doesn't work good under rq->lock */
+		spin_unlock(&this_rq->lock);
+		BUG_ON(1);
+	}
+
+	return _double_lock_balance(this_rq, busiest);
+}
+
 static void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
 	__releases(busiest->lock)
 {

