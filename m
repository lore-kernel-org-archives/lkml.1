Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbZCXQH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbZCXQH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761580AbZCXQGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:06:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:41792 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760464AbZCXQG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:06:29 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/14] block: reorganize [__]bio_map_kern()
Date: Wed, 25 Mar 2009 01:06:04 +0900
Message-Id: <1237910776-10983-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237910776-10983-1-git-send-email-tj@kernel.org>
References: <1237910776-10983-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 16:06:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: code reorganization, cleanup

Reorganize [__]bio_map_kern() such that __bio_map_kern() only maps the
pages while bio_map_kern() handles allocation.  Also, if not all pages
can be mapped, __bio_map_kern() fails directly instead of doing
partial mapping and letting bio_map_kern() detect it and fail.

While at it, convert to PFN_*() macros for page number calculations.

The reorganized __bio_map_kern() will be used in the next patch for
bio_map_kern_prealloc().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 fs/bio.c |   56 +++++++++++++++++++++++---------------------------------
 1 files changed, 23 insertions(+), 33 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index d4f0632..746b566 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -26,6 +26,7 @@
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
 #include <linux/blktrace_api.h>
+#include <linux/pfn.h>
 #include <trace/block.h>
 #include <scsi/sg.h>		/* for struct sg_iovec */
 
@@ -1109,41 +1110,27 @@ static void bio_map_kern_endio(struct bio *bio, int err)
 }
 
 
-static struct bio *__bio_map_kern(struct request_queue *q, void *data,
-				  unsigned int len, gfp_t gfp_mask)
+static int __bio_map_kern(struct request_queue *q, struct bio *bio,
+			  void *data, unsigned int len)
 {
-	unsigned long kaddr = (unsigned long)data;
-	unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	unsigned long start = kaddr >> PAGE_SHIFT;
-	const int nr_pages = end - start;
 	int offset, i;
-	struct bio *bio;
-
-	bio = bio_alloc(gfp_mask, nr_pages);
-	if (!bio)
-		return ERR_PTR(-ENOMEM);
-
-	offset = offset_in_page(kaddr);
-	for (i = 0; i < nr_pages; i++) {
-		unsigned int bytes = PAGE_SIZE - offset;
 
-		if (len <= 0)
-			break;
-
-		if (bytes > len)
-			bytes = len;
+	offset = offset_in_page(data);
+	for (i = 0; len; i++) {
+		unsigned int bytes = min_t(unsigned int,
+					   len, PAGE_SIZE - offset);
 
+		/* don't support partial mapping */
 		if (bio_add_pc_page(q, bio, virt_to_page(data), bytes,
 				    offset) < bytes)
-			break;
+			return -EINVAL;
 
 		data += bytes;
 		len -= bytes;
 		offset = 0;
 	}
 
-	bio->bi_end_io = bio_map_kern_endio;
-	return bio;
+	return 0;
 }
 
 /**
@@ -1159,20 +1146,23 @@ static struct bio *__bio_map_kern(struct request_queue *q, void *data,
 struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
 			 gfp_t gfp_mask)
 {
+	const unsigned long kaddr = (unsigned long)data;
+	const int nr_pages = PFN_UP(kaddr + len) - PFN_DOWN(kaddr);
 	struct bio *bio;
+	int error;
 
-	bio = __bio_map_kern(q, data, len, gfp_mask);
-	if (IS_ERR(bio))
-		return bio;
+	bio = bio_alloc(gfp_mask, nr_pages);
+	if (unlikely(!bio))
+		return ERR_PTR(-ENOMEM);
+	bio->bi_end_io = bio_map_kern_endio;
 
-	if (bio->bi_size == len)
-		return bio;
+	error = __bio_map_kern(q, bio, data, len);
+	if (unlikely(error)) {
+		bio_put(bio);
+		return ERR_PTR(error);
+	}
 
-	/*
-	 * Don't support partial mappings.
-	 */
-	bio_put(bio);
-	return ERR_PTR(-EINVAL);
+	return bio;
 }
 
 static void bio_copy_kern_endio(struct bio *bio, int err)
-- 
1.6.0.2

