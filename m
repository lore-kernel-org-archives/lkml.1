Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbYHKLcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbYHKLcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 07:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbYHKLcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 07:32:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:50980 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751221AbYHKLcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 07:32:06 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX197fhZSozt7ymFJc5yHwYm2f47g9NDkLbyPUyQsy0
	bT0lCWhXAnc8rD
Subject: [revert] mysql+oltp regression
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gregory Haskins <ghaskins@novell.com>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 13:32:02 +0200
Message-Id: <1218454322.25098.24.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

During regression testing of tip/sched/clock fixes, a regression in low
client count throughput turned up, which I traced this back to the
commit below.  I don't see anything wrong with it, but suspect that it
is preventing client/server pairs from staying together on the same CPU
as buddies, which mysql definitely likes quite a lot.  (I suspect that
this is the case, because I've seen this same performance curve while
tinkering with wakeup affinity and breaking it all to pieces;)

Changelog and test results below in case nobody sees a problem with the
commit itself.

Revert commit 6d299f1b53b84e2665f402d9bcc494800aba6386

Testing of the tip/sched/clock tree revealed a mysql+oltp regression
which bisection eventually traced back to this commit in mainline.

Pertinent test results:  Three run sysbench averages, throughput units
in read/write requests/sec.

clients         1     2     4     8    16    32    64
6e0534f      9646 17876 34774 33868 32230 30767 29441
2.6.26.1     9112 17936 34652 33383 31929 30665 29232
6d299f1      9112 14637 28370 33339 32038 30762 29204

Note:  subsequent commits hide the majority of this regression until you
apply the clock fixes, at which time it reemerges at full magnitude.

Signed-off-by: Mike Galbraith <efault@gmx.de>

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 1fe4c65..08ae848 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1275,18 +1275,23 @@ __load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
 	struct task_struct *p = NULL;
 	struct sched_entity *se;
 
-	while (next != &cfs_rq->tasks) {
+	if (next == &cfs_rq->tasks)
+		return NULL;
+
+	/* Skip over entities that are not tasks */
+	do {
 		se = list_entry(next, struct sched_entity, group_node);
 		next = next->next;
+	} while (next != &cfs_rq->tasks && !entity_is_task(se));
 
-		/* Skip over entities that are not tasks */
-		if (entity_is_task(se)) {
-			p = task_of(se);
-			break;
-		}
-	}
+	if (next == &cfs_rq->tasks)
+		return NULL;
 
 	cfs_rq->balance_iterator = next;
+
+	if (entity_is_task(se))
+		p = task_of(se);
+
 	return p;
 }



