Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbXDXITP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbXDXITP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbXDXISd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:18:33 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41284 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031049AbXDXIQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:16:44 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 12/15] cfq-iosched: get rid of ->dispatch_slice
Date: Tue, 24 Apr 2007 10:15:40 +0200
Message-Id: <11774025433560-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.1.1.190.g74474
In-Reply-To: <11774025432481-git-send-email-jens.axboe@oracle.com>
References: <11774025432481-git-send-email-jens.axboe@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We can track it fairly accurately locally, let the slice handling
take care of the rest.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b680002..8f76aed 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -106,7 +106,6 @@ struct cfq_data {
 
 	struct cfq_queue *active_queue;
 	struct cfq_io_context *active_cic;
-	unsigned int dispatch_slice;
 
 	struct timer_list idle_class_timer;
 
@@ -769,8 +768,6 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		put_io_context(cfqd->active_cic->ioc);
 		cfqd->active_cic = NULL;
 	}
-
-	cfqd->dispatch_slice = 0;
 }
 
 static inline void cfq_slice_expired(struct cfq_data *cfqd, int timed_out)
@@ -1020,7 +1017,6 @@ __cfq_dispatch_requests(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		 */
 		cfq_dispatch_insert(cfqd->queue, rq);
 
-		cfqd->dispatch_slice++;
 		dispatched++;
 
 		if (!cfqd->active_cic) {
@@ -1038,7 +1034,7 @@ __cfq_dispatch_requests(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	 * queue always expire after 1 dispatch round.
 	 */
 	if (cfqd->busy_queues > 1 && ((!cfq_cfqq_sync(cfqq) &&
-	    cfqd->dispatch_slice >= cfq_prio_to_maxrq(cfqd, cfqq)) ||
+	    dispatched >= cfq_prio_to_maxrq(cfqd, cfqq)) ||
 	    cfq_class_idle(cfqq))) {
 		cfqq->slice_end = jiffies + 1;
 		cfq_slice_expired(cfqd, 0);
-- 
1.5.1.1.190.g74474

