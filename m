Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbZCTNds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbZCTNds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbZCTNdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:33:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52333 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbZCTNdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:33:38 -0400
Message-Id: <200903201333.n2KDXONh023780@dhcp-0-152.brq.redhat.com>
From: Jerome Marchand <jmarchan@redhat.com>
Date: Thu, 19 Mar 2009 11:36:50 +0100
Subject: [PATCH] block: forbid to re-enable I/O stat accounting
Cc: Jens Axboe <axboe@kernel.dk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we stop I/O stat accounting we stop to update the in-flight
requests counter and we need this counter to be reliable for
accounting I/O stats. Unfortunately updating in_flight field may
affect performance. So, until we have a better solution, just forbid
to re-enable I/O stat accounting after it has been disabled.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 block/blk-sysfs.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e29ddfc..2903874 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -208,12 +208,15 @@ static ssize_t queue_iostats_store(struct request_queue *q, const char *page,
 	unsigned long stats;
 	ssize_t ret = queue_var_store(&stats, page, count);
 
-	spin_lock_irq(q->queue_lock);
-	if (stats)
-		queue_flag_set(QUEUE_FLAG_IO_STAT, q);
-	else
+	/*
+	 * When we disable io stat accounting we stop tracking essential data,
+	 * so don't allow to reenable it as it would lead to inconsistency.
+	 */
+	if (!stats) {
+		spin_lock_irq(q->queue_lock);
 		queue_flag_clear(QUEUE_FLAG_IO_STAT, q);
-	spin_unlock_irq(q->queue_lock);
+		spin_unlock_irq(q->queue_lock);
+	}
 
 	return ret;
 }
-- 
1.5.5.1

