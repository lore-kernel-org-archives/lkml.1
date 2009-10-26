Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbZJZVpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbZJZVpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZJZVpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:45:07 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59957 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZJZVpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:45:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=MJ5t30Ym7ZcxNsej7yQMexKrlaRh1fVm9Lj2YmopbILczviO3NiTEEHhQKaJXBS5gU
         H35dUqvy+XPYNU+4+9whSqB7um2HZqohWZhftLeA8fgsN7J8nA12xR1IYQmgIWGGgBdH
         llEpnoX1lCjVnVBw+XU9b1cqupTu8TvCFhLFM=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 4/5] cfq-iosched: enable idling for last queue on priority class
Date: Mon, 26 Oct 2009 22:45:11 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910262245.11276.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfq can disable idling for queues in various circumstances.
When workloads of different priorities are competing, if the higher
priority queue has idling disabled, lower priority queues may steal
its disk share. For example, in a scenario with an RT process
performing seeky reads vs a BE process performing sequential reads,
on an NCQ enabled hardware, with low_latency unset,
the RT process will dispatch only the few pending requests every full
slice of service for the BE process.

The patch solves this issue by always performing idle on the last
queue at a given priority class > idle. If the same process, or one
that can pre-empt it (so at the same priority or higher), submits a
new request within the idle window, the lower priority queue won't
dispatch, saving the disk bandwidth for higher priority ones.

Note: this doesn't touch the non_rotational + NCQ case (no hardware
to test if this is a benefit in that case).

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   34 +++++++++++++++++++++++++++++++---
 1 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4da42cd..3fa65ea 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1158,6 +1158,34 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 	return cfqq;
 }
 
+/*
+ * Determine whether we should enforce idle window for this queue.
+ */
+
+static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+{
+	enum wl_prio_t prio = cfqq_prio(cfqq);
+	struct cfq_rb_root *service_tree;
+
+	/* We never do for idle class queues. */
+	if (prio == IDLE_WORKLOAD)
+		return false;
+
+	/* We do for queues that were marked with idle window flag. */
+	if (cfq_cfqq_idle_window(cfqq))
+		return true;
+
+	/*
+	 * Otherwise, we do only if they are the last ones
+	 * in their service tree.
+	 */
+	service_tree = service_tree_for(prio, cfqd);
+	if (service_tree->count == 0)
+		return true;
+
+	return (service_tree->count == 1 && cfq_rb_first(service_tree) == cfqq);
+}
+
 static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
@@ -1178,7 +1206,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	/*
 	 * idle is disabled, either manually or by past process history
 	 */
-	if (!cfqd->cfq_slice_idle || !cfq_cfqq_idle_window(cfqq))
+	if (!cfqd->cfq_slice_idle || !cfq_should_idle(cfqd, cfqq))
 		return;
 
 	/*
@@ -1360,7 +1388,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	 * conditions to happen (or time out) before selecting a new queue.
 	 */
 	if (timer_pending(&cfqd->idle_slice_timer) ||
-	    (cfqq->dispatched && cfq_cfqq_idle_window(cfqq))) {
+	    (cfqq->dispatched && cfq_should_idle(cfqd, cfqq))) {
 		cfqq = NULL;
 		goto keep_queue;
 	}
@@ -1425,7 +1453,7 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	/*
 	 * Drain async requests before we start sync IO
 	 */
-	if (cfq_cfqq_idle_window(cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
+	if (cfq_should_idle(cfqd, cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
 		return false;
 
 	/*
-- 
1.6.2.5


