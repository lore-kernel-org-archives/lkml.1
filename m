Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbYHYFdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbYHYFdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 01:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbYHYFdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 01:33:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:46142 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbYHYFdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 01:33:15 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, nix@esperi.org.uk, adobriyan@gmail.com,
       fujita.tomonori@lab.ntt.co.jp, stable@kernel.org
Subject: [PATCH 2/2] bio: fix __bio_copy_iov() handling of bio->bv_len
Date: Mon, 25 Aug 2008 14:22:53 +0900
Message-Id: <1219641773-25856-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.5.GIT
In-Reply-To: <1219641773-25856-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <871w0eb9nx.fsf@hades.wkstn.nix>
 <1219641773-25856-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1219641773-25856-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit c5dec1c3034f1ae3503efbf641ff3b0273b64797 introduced
__bio_copy_iov() to add bounce support to blk_rq_map_user_iov.

__bio_copy_iov() uses bio->bv_len to copy data for READ commands after
the completion but it doesn't work with a request that partially
completed. SCSI always completes a PC request as a whole but seems
some don't.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stable@kernel.org
---
 fs/bio.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 8b1f5ee..3cba7ae 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -492,8 +492,8 @@ static struct bio_map_data *bio_alloc_map_data(int nr_segs, int iov_count,
 	return NULL;
 }
 
-static int __bio_copy_iov(struct bio *bio, struct sg_iovec *iov, int iov_count,
-			  int uncopy)
+static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
+			  struct sg_iovec *iov, int iov_count, int uncopy)
 {
 	int ret = 0, i;
 	struct bio_vec *bvec;
@@ -503,7 +503,7 @@ static int __bio_copy_iov(struct bio *bio, struct sg_iovec *iov, int iov_count,
 
 	__bio_for_each_segment(bvec, bio, i, 0) {
 		char *bv_addr = page_address(bvec->bv_page);
-		unsigned int bv_len = bvec->bv_len;
+		unsigned int bv_len = iovecs[i].bv_len;
 
 		while (bv_len && iov_idx < iov_count) {
 			unsigned int bytes;
@@ -555,7 +555,7 @@ int bio_uncopy_user(struct bio *bio)
 	struct bio_map_data *bmd = bio->bi_private;
 	int ret;
 
-	ret = __bio_copy_iov(bio, bmd->sgvecs, bmd->nr_sgvecs, 1);
+	ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs, bmd->nr_sgvecs, 1);
 
 	bio_free_map_data(bmd);
 	bio_put(bio);
@@ -634,7 +634,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q, struct sg_iovec *iov,
 	 * success
 	 */
 	if (!write_to_vm) {
-		ret = __bio_copy_iov(bio, iov, iov_count, 0);
+		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0);
 		if (ret)
 			goto cleanup;
 	}
-- 
1.5.5.GIT

