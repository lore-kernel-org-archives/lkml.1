Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbZD1EIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbZD1EIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 00:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbZD1EHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 00:07:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:38755 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbZD1EHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 00:07:37 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, donari75@gmail.com,
       bzolnier@gmail.com, joerg@dorchain.net, geert@linux-m68k.org,
       davem@davemloft.net, jdike@linux.intel.com, benh@kernel.crashing.org,
       Laurent@lvivier.info
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/14] block: make blk_end_request_cur() return bool
Date: Tue, 28 Apr 2009 13:06:04 +0900
Message-Id: <1240891577-4813-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240891577-4813-1-git-send-email-tj@kernel.org>
References: <1240891577-4813-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 28 Apr 2009 04:06:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the process of mindlessly copying [__]blk_end_request_all(),
[__]blk_end_request_cur() ended up returning void even though they're
partial completion functions.  Fix it.

[ Impact: fix braindead API ]

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/blkdev.h |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 12c545e..3a5b1bd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -903,10 +903,14 @@ static inline void blk_end_request_all(struct request *rq, int error)
  *
  * Description:
  *     Complete the current consecutively mapped chunk from @rq.
+ *
+ * Return:
+ *     %false - we are done with this request
+ *     %true  - still buffers pending for this request
  */
-static inline void blk_end_request_cur(struct request *rq, int error)
+static inline bool blk_end_request_cur(struct request *rq, int error)
 {
-	blk_end_request(rq, error, rq->hard_cur_sectors << 9);
+	return blk_end_request(rq, error, rq->hard_cur_sectors << 9);
 }
 
 /**
@@ -952,10 +956,14 @@ static inline void __blk_end_request_all(struct request *rq, int error)
  * Description:
  *     Complete the current consecutively mapped chunk from @rq.  Must
  *     be called with queue lock held.
+ *
+ * Return:
+ *     %false - we are done with this request
+ *     %true  - still buffers pending for this request
  */
-static inline void __blk_end_request_cur(struct request *rq, int error)
+static inline bool __blk_end_request_cur(struct request *rq, int error)
 {
-	__blk_end_request(rq, error, rq->hard_cur_sectors << 9);
+	return __blk_end_request(rq, error, rq->hard_cur_sectors << 9);
 }
 
 extern void blk_complete_request(struct request *);
-- 
1.6.0.2

