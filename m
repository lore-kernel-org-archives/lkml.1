Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbXIMM1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbXIMM1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 08:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbXIMM1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 08:27:10 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11396 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbXIMM1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 08:27:08 -0400
Date: Thu, 13 Sep 2007 14:26:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: orgis@agnld.uni-potsdam.de, arekm@maven.pl, ed.lin@promise.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James.Bottomley@SteelEye.com
Subject: [PATCH] Fix race with shared tag queue maps
Message-ID: <20070913122652.GK25592@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There's a race condition in blk_queue_end_tag() for shared tag maps,
users include stex (promise supertrak thingy) and qla2xxx. The former at
least has reported bugs in this area, not sure why we haven't seen any
for the latter. It could be because the window is narrow and that other
conditions in the qla2xxx code hide this. It's a real bug, though, as
the stex smp users can attest.

We need to ensure two things - the tag bit clearing needs to happen
AFTER we cleared the tag pointer, as the tag bit clearing/setting is
what protects this map. Secondly, we need to ensure that the visibility
of the tag pointer and tag bit clear are ordered properly.

This is for 2.6.23-rc6-current, but it needs to go into -stable as well
once Linus has committed it. I'm cc'ing users that reported stex
problems, hopefully they can test this patch and report back.

Also see http://bugzilla.kernel.org/show_bug.cgi?id=7842

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index a15845c..3d9e6a1 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1075,12 +1075,6 @@ void blk_queue_end_tag(struct request_queue *q, struct request *rq)
 		 */
 		return;
 
-	if (unlikely(!__test_and_clear_bit(tag, bqt->tag_map))) {
-		printk(KERN_ERR "%s: attempt to clear non-busy tag (%d)\n",
-		       __FUNCTION__, tag);
-		return;
-	}
-
 	list_del_init(&rq->queuelist);
 	rq->cmd_flags &= ~REQ_QUEUED;
 	rq->tag = -1;
@@ -1090,6 +1084,23 @@ void blk_queue_end_tag(struct request_queue *q, struct request *rq)
 		       __FUNCTION__, tag);
 
 	bqt->tag_index[tag] = NULL;
+
+	/*
+	 * Ensure ordering with tag section
+	 */
+	smp_mb__before_clear_bit();
+
+	if (unlikely(!test_and_clear_bit(tag, bqt->tag_map))) {
+		printk(KERN_ERR "%s: attempt to clear non-busy tag (%d)\n",
+		       __FUNCTION__, tag);
+		return;
+	}
+
+	/*
+	 * Ensure ordering between ->tag_index[tag] clear and tag clear
+	 */
+	smp_mb__after_clear_bit();
+
 	bqt->busy--;
 }
 

-- 
Jens Axboe

