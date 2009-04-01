Return-Path: <linux-kernel-owner+w=401wt.eu-S1764695AbZDANpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764695AbZDANpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577AbZDANoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:44:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:42373 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524AbZDANop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:44:45 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/17] blk-map: move blk_rq_map_user() below blk_rq_map_user_iov()
Date: Wed,  1 Apr 2009 22:44:16 +0900
Message-Id: <1238593472-30360-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238593472-30360-1-git-send-email-tj@kernel.org>
References: <1238593472-30360-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 13:44:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: code reorganization

blk_rq_map_user() is about to be reimplemented using
blk_rq_map_user_iov().  Move it below blk_rq_map_user_iov() so that
the actual conversion patch is easier to read.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-map.c |   70 +++++++++++++++++++++++++++---------------------------
 1 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index a43c93c..fdef591 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -41,41 +41,6 @@ static int __blk_rq_unmap_user(struct bio *bio)
 }
 
 /**
- * blk_rq_map_user - map user data to a request, for REQ_TYPE_BLOCK_PC usage
- * @q:		request queue where request should be inserted
- * @rq:		request structure to fill
- * @map_data:   pointer to the rq_map_data holding pages (if necessary)
- * @ubuf:	the user buffer
- * @len:	length of user data
- * @gfp_mask:	memory allocation flags
- *
- * Description:
- *    Data will be mapped directly for zero copy I/O, if possible. Otherwise
- *    a kernel bounce buffer is used.
- *
- *    A matching blk_rq_unmap_user() must be issued at the end of I/O, while
- *    still in process context.
- *
- *    Note: The mapped bio may need to be bounced through blk_queue_bounce()
- *    before being submitted to the device, as pages mapped may be out of
- *    reach. It's the callers responsibility to make sure this happens. The
- *    original bio must be passed back in to blk_rq_unmap_user() for proper
- *    unmapping.
- */
-int blk_rq_map_user(struct request_queue *q, struct request *rq,
-		    struct rq_map_data *map_data, void __user *ubuf,
-		    unsigned long len, gfp_t gfp_mask)
-{
-	struct sg_iovec iov;
-
-	iov.iov_base = ubuf;
-	iov.iov_len = len;
-
-	return blk_rq_map_user_iov(q, rq, map_data, &iov, 1, len, gfp_mask);
-}
-EXPORT_SYMBOL(blk_rq_map_user);
-
-/**
  * blk_rq_map_user_iov - map user data to a request, for REQ_TYPE_BLOCK_PC usage
  * @q:		request queue where request should be inserted
  * @rq:		request to map data to
@@ -151,6 +116,41 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 EXPORT_SYMBOL(blk_rq_map_user_iov);
 
 /**
+ * blk_rq_map_user - map user data to a request, for REQ_TYPE_BLOCK_PC usage
+ * @q:		request queue where request should be inserted
+ * @rq:		request structure to fill
+ * @map_data:   pointer to the rq_map_data holding pages (if necessary)
+ * @ubuf:	the user buffer
+ * @len:	length of user data
+ * @gfp_mask:	memory allocation flags
+ *
+ * Description:
+ *    Data will be mapped directly for zero copy I/O, if possible. Otherwise
+ *    a kernel bounce buffer is used.
+ *
+ *    A matching blk_rq_unmap_user() must be issued at the end of I/O, while
+ *    still in process context.
+ *
+ *    Note: The mapped bio may need to be bounced through blk_queue_bounce()
+ *    before being submitted to the device, as pages mapped may be out of
+ *    reach. It's the callers responsibility to make sure this happens. The
+ *    original bio must be passed back in to blk_rq_unmap_user() for proper
+ *    unmapping.
+ */
+int blk_rq_map_user(struct request_queue *q, struct request *rq,
+		    struct rq_map_data *map_data, void __user *ubuf,
+		    unsigned long len, gfp_t gfp_mask)
+{
+	struct sg_iovec iov;
+
+	iov.iov_base = ubuf;
+	iov.iov_len = len;
+
+	return blk_rq_map_user_iov(q, rq, map_data, &iov, 1, len, gfp_mask);
+}
+EXPORT_SYMBOL(blk_rq_map_user);
+
+/**
  * blk_rq_unmap_user - unmap a request with user data
  * @bio:	       start of bio list
  *
-- 
1.6.0.2

