Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbYK1Edk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbYK1Edk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 23:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYK1EcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 23:32:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:45256 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbYK1EcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 23:32:21 -0500
From: Tejun Heo <tj@kernel.org>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] block: fix empty barrier on write-through w/ ordered tag
Date: Fri, 28 Nov 2008 13:32:07 +0900
Message-Id: <1227846727-24980-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1227846727-24980-1-git-send-email-tj@kernel.org>
References: <1227846727-24980-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Nov 2008 04:32:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Empty barrier on write-through (or no cache) w/ ordered tag has no
command to execute and without any command to execute ordered tag is
never issued to the device and the ordering is never achieved.  Force
draining for such cases.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-barrier.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index c63044e..8eba4e4 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -166,9 +166,21 @@ static inline bool start_ordered(struct request_queue *q, struct request **rqp)
 	 * For an empty barrier, there's no actual BAR request, which
 	 * in turn makes POSTFLUSH unnecessary.  Mask them off.
 	 */
-	if (!rq->hard_nr_sectors)
+	if (!rq->hard_nr_sectors) {
 		q->ordered &= ~(QUEUE_ORDERED_DO_BAR |
 				QUEUE_ORDERED_DO_POSTFLUSH);
+		/*
+		 * Empty barrier on a write-through device w/ ordered
+		 * tag has no command to issue and without any command
+		 * to issue, ordering by tag can't be used.  Drain
+		 * instead.
+		 */
+		if ((q->ordered & QUEUE_ORDERED_BY_TAG) &&
+		    !(q->ordered & QUEUE_ORDERED_DO_PREFLUSH)) {
+			q->ordered &= ~QUEUE_ORDERED_BY_TAG;
+			q->ordered |= QUEUE_ORDERED_BY_DRAIN;
+		}
+	}
 
 	/* stash away the original request */
 	elv_dequeue_request(q, rq);
-- 
1.5.6

