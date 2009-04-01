Return-Path: <linux-kernel-owner+w=401wt.eu-S1765530AbZDANpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765530AbZDANpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765225AbZDANos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:44:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:42385 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764363AbZDANor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:44:47 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/17] blk-map: improve alignment checking for blk_rq_map_user_iov()
Date: Wed,  1 Apr 2009 22:44:18 +0900
Message-Id: <1238593472-30360-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238593472-30360-1-git-send-email-tj@kernel.org>
References: <1238593472-30360-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 13:44:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: stricter more consistent alignment checking

Move all alignment checks in blk_rq_map_user_iov() to
__bio_map_user_iov() which has to walk the iov at the beginning
anyway.  Improve alignment check such that it checks for both the
start address and length of each segment.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-map.c |   21 +++++----------------
 fs/bio.c        |   20 +++++++++++++-------
 2 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index fdef591..b0b65ef 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -67,28 +67,17 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 			struct rq_map_data *map_data, struct sg_iovec *iov,
 			int iov_count, unsigned int len, gfp_t gfp_mask)
 {
-	struct bio *bio;
-	int i, read = rq_data_dir(rq) == READ;
-	int unaligned = 0;
+	struct bio *bio = ERR_PTR(-EINVAL);
+	int read = rq_data_dir(rq) == READ;
 
 	if (!iov || iov_count <= 0)
 		return -EINVAL;
 
-	for (i = 0; i < iov_count; i++) {
-		unsigned long uaddr = (unsigned long)iov[i].iov_base;
-
-		if (uaddr & queue_dma_alignment(q)) {
-			unaligned = 1;
-			break;
-		}
-	}
-
-	if (unaligned || (q->dma_pad_mask & len) || map_data)
+	if (!map_data)
+		bio = bio_map_user_iov(q, NULL, iov, iov_count, read, gfp_mask);
+	if (bio == ERR_PTR(-EINVAL))
 		bio = bio_copy_user_iov(q, map_data, iov, iov_count, read,
 					gfp_mask);
-	else
-		bio = bio_map_user_iov(q, NULL, iov, iov_count, read, gfp_mask);
-
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
diff --git a/fs/bio.c b/fs/bio.c
index 728bef9..80f61ed 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -26,6 +26,7 @@
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
 #include <linux/blktrace_api.h>
+#include <linux/pfn.h>
 #include <trace/block.h>
 #include <scsi/sg.h>		/* for struct sg_iovec */
 
@@ -921,6 +922,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 				      int write_to_vm, gfp_t gfp_mask)
 {
 	int i, j;
+	size_t tot_len = 0;
 	int nr_pages = 0;
 	struct page **pages;
 	struct bio *bio;
@@ -930,18 +932,22 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	for (i = 0; i < iov_count; i++) {
 		unsigned long uaddr = (unsigned long)iov[i].iov_base;
 		unsigned long len = iov[i].iov_len;
-		unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		unsigned long start = uaddr >> PAGE_SHIFT;
 
-		nr_pages += end - start;
+		nr_pages += PFN_UP(uaddr + len) - PFN_DOWN(uaddr);
+		tot_len += len;
+
 		/*
-		 * buffer must be aligned to at least hardsector size for now
+		 * Each segment must be aligned on DMA boundary.  The
+		 * last one may have unaligned length as long as the
+		 * total length is aligned to DMA padding alignment.
 		 */
-		if (uaddr & queue_dma_alignment(q))
+		if (i == count - 1)
+			len = 0;
+		if ((uaddr | len) & queue_dma_alignment(q))
 			return ERR_PTR(-EINVAL);
 	}
-
-	if (!nr_pages)
+	/* and total length on DMA padding alignment */
+	if (!nr_pages || tot_len & q->dma_pad_mask)
 		return ERR_PTR(-EINVAL);
 
 	bio = bio_kmalloc(gfp_mask, nr_pages);
-- 
1.6.0.2

