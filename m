Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYI3XTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYI3XTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYI3XTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:19:11 -0400
Received: from nebensachen.de ([195.34.83.29]:45524 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbYI3XTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:19:10 -0400
X-Hashcash: 1:20:080930:jens.axboe@oracle.com::W4WI7vDEc3Y+K9kx:00000000000000000000000000000000000000007Nta
X-Hashcash: 1:20:080930:linux-kernel@vger.kernel.org::5lpUa7+RcZdixgeU:0000000000000000000000000000000001564
From: Elias Oltmanns <eo@nebensachen.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Block: Fix blk_start_queueing() so as not to process a stopped queue
Date: Wed, 01 Oct 2008 01:19:01 +0200
Message-ID: <87wsgtb4t6.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Especially since blk_start_queueing() is used as the unplug_fn() callback
by the cfq scheduler, we'd better make it behave like a proper unplug
function. That is to say, return immediately if the queue is stopped.

Cc: stable <stable@kernel.org>
Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---
This is not a recent regression, so it might not be accepted as an rc
fix. However, it most definitely is a bug and should go into a stable
release. Applies to 2.6.27-rc8.

 block/blk-core.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2cba5ef..f9a0bfb 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -888,9 +888,11 @@ EXPORT_SYMBOL(blk_get_request);
  */
 void blk_start_queueing(struct request_queue *q)
 {
-	if (!blk_queue_plugged(q))
+	if (!blk_queue_plugged(q)) {
+		if (unlikely(blk_queue_stopped(q)))
+			return;
 		q->request_fn(q);
-	else
+	} else
 		__generic_unplug_device(q);
 }
 EXPORT_SYMBOL(blk_start_queueing);
