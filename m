Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbYKKKw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbYKKKw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbYKKKwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:52:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35318 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbYKKKwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:52:49 -0500
Subject: [PATCH] sched: release buddies on yield
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Mike Galbraith <efault@gmx.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Miao Xie <miaox@cn.fujitsu.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1226397807.30025.79.camel@minggr.sh.intel.com>
References: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera>
	 <4B0Eqx89uNG.A.w2E.Ee1FJB@chimera>
	 <1226343293.5498.5.camel@marge.simson.net>
	 <1226366822.2866.19.camel@ymzhang>
	 <1226394669.30025.72.camel@minggr.sh.intel.com>
	 <1226395210.7685.1324.camel@twins>  <1226395937.7685.1340.camel@twins>
	 <1226397807.30025.79.camel@minggr.sh.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Nov 2008 11:52:33 +0100
Message-Id: <1226400753.7685.1506.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear buddies on yield, so that the buddy rules don't schedule them
despite them being placed right-most.

This fixed a performance regression with yield-happy binary JVMs.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Lin Ming <ming.m.lin@intel.com>
---
 kernel/sched_fair.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 51aa3e1..98345e4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -716,6 +716,15 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
 		__enqueue_entity(cfs_rq, se);
 }
 
+static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	if (cfs_rq->last == se)
+		cfs_rq->last = NULL;
+
+	if (cfs_rq->next == se)
+		cfs_rq->next = NULL;
+}
+
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 {
@@ -738,11 +747,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 #endif
 	}
 
-	if (cfs_rq->last == se)
-		cfs_rq->last = NULL;
-
-	if (cfs_rq->next == se)
-		cfs_rq->next = NULL;
+	clear_buddies(cfs_rq, se);
 
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
@@ -977,6 +982,8 @@ static void yield_task_fair(struct rq *rq)
 	if (unlikely(cfs_rq->nr_running == 1))
 		return;
 
+	clear_buddies(cfs_rq, se);
+
 	if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) {
 		update_rq_clock(rq);
 		/*

