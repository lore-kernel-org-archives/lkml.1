Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbYHYFdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbYHYFdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 01:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYHYFdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 01:33:17 -0400
Received: from sh.osrg.net ([192.16.179.4]:46144 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbYHYFdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 01:33:17 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, nix@esperi.org.uk, adobriyan@gmail.com,
       fujita.tomonori@lab.ntt.co.jp, stable@kernel.org
Subject: [PATCH 1/2] bio: fix bio_copy_kern() handling of bio->bv_len
Date: Mon, 25 Aug 2008 14:22:52 +0900
Message-Id: <1219641773-25856-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.5.GIT
In-Reply-To: <1219641773-25856-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <871w0eb9nx.fsf@hades.wkstn.nix>
 <1219641773-25856-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 68154e90c9d1492d570671ae181d9a8f8530da55 introduced
bio_copy_kern() to add bounce support to blk_rq_map_kern.

bio_copy_kern() uses bio->bv_len to copy data for READ commands after
the completion but it doesn't work with a request that partially
completed. SCSI always completes a PC request as a whole but seems
some don't.

This patch fixes bio_copy_kern to handle the above case. As
bio_copy_user does, bio_copy_kern uses struct bio_map_data to store
struct bio_vec.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reported-by: Nix <nix@esperi.org.uk>
Tested-by: Nix <nix@esperi.org.uk>
Cc: stable@kernel.org
---
 fs/bio.c |   38 ++++++++++++++++++++++++++++----------
 1 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 8000e2f..8b1f5ee 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -469,20 +469,21 @@ static void bio_free_map_data(struct bio_map_data *bmd)
 	kfree(bmd);
 }
 
-static struct bio_map_data *bio_alloc_map_data(int nr_segs, int iov_count)
+static struct bio_map_data *bio_alloc_map_data(int nr_segs, int iov_count,
+					       gfp_t gfp_mask)
 {
-	struct bio_map_data *bmd = kmalloc(sizeof(*bmd), GFP_KERNEL);
+	struct bio_map_data *bmd = kmalloc(sizeof(*bmd), gfp_mask);
 
 	if (!bmd)
 		return NULL;
 
-	bmd->iovecs = kmalloc(sizeof(struct bio_vec) * nr_segs, GFP_KERNEL);
+	bmd->iovecs = kmalloc(sizeof(struct bio_vec) * nr_segs, gfp_mask);
 	if (!bmd->iovecs) {
 		kfree(bmd);
 		return NULL;
 	}
 
-	bmd->sgvecs = kmalloc(sizeof(struct sg_iovec) * iov_count, GFP_KERNEL);
+	bmd->sgvecs = kmalloc(sizeof(struct sg_iovec) * iov_count, gfp_mask);
 	if (bmd->sgvecs)
 		return bmd;
 
@@ -596,7 +597,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q, struct sg_iovec *iov,
 		len += iov[i].iov_len;
 	}
 
-	bmd = bio_alloc_map_data(nr_pages, iov_count);
+	bmd = bio_alloc_map_data(nr_pages, iov_count, GFP_KERNEL);
 	if (!bmd)
 		return ERR_PTR(-ENOMEM);
 
@@ -942,19 +943,22 @@ static void bio_copy_kern_endio(struct bio *bio, int err)
 {
 	struct bio_vec *bvec;
 	const int read = bio_data_dir(bio) == READ;
-	char *p = bio->bi_private;
+	struct bio_map_data *bmd = bio->bi_private;
 	int i;
+	char *p = bmd->sgvecs[0].iov_base;
 
 	__bio_for_each_segment(bvec, bio, i, 0) {
 		char *addr = page_address(bvec->bv_page);
+		int len = bmd->iovecs[i].bv_len;
 
 		if (read && !err)
-			memcpy(p, addr, bvec->bv_len);
+			memcpy(p, addr, len);
 
 		__free_page(bvec->bv_page);
-		p += bvec->bv_len;
+		p += len;
 	}
 
+	bio_free_map_data(bmd);
 	bio_put(bio);
 }
 
@@ -978,11 +982,21 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 	const int nr_pages = end - start;
 	struct bio *bio;
 	struct bio_vec *bvec;
+	struct bio_map_data *bmd;
 	int i, ret;
+	struct sg_iovec iov;
+
+	iov.iov_base = data;
+	iov.iov_len = len;
+
+	bmd = bio_alloc_map_data(nr_pages, 1, gfp_mask);
+	if (!bmd)
+		return ERR_PTR(-ENOMEM);
 
+	ret = -ENOMEM;
 	bio = bio_alloc(gfp_mask, nr_pages);
 	if (!bio)
-		return ERR_PTR(-ENOMEM);
+		goto out_bmd;
 
 	while (len) {
 		struct page *page;
@@ -1016,14 +1030,18 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 		}
 	}
 
-	bio->bi_private = data;
+	bio->bi_private = bmd;
 	bio->bi_end_io = bio_copy_kern_endio;
+
+	bio_set_map_data(bmd, bio, &iov, 1);
 	return bio;
 cleanup:
 	bio_for_each_segment(bvec, bio, i)
 		__free_page(bvec->bv_page);
 
 	bio_put(bio);
+out_bmd:
+	bio_free_map_data(bmd);
 
 	return ERR_PTR(ret);
 }
-- 
1.5.5.GIT

