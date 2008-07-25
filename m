Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbYGYSL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbYGYSL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYGYSLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:11:19 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:13503 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbYGYSLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:11:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Wb3nZIYaWgiSa2YCSzbGERBNELxSj/hAb9IZweViz/fn4Vb0K63kuLrjzt7zUOIcpa
         cBy2oO2n8/z6s0c61a3oyHjv4O1D6PnNhYGz4xffwQj58BQmfA0P1iTcYYRS/j5MXvRn
         KCdrVDxZihGD2EuQBwxWpPG54gg/7Zy5zBzsw=
From: Denis ChengRq <crquan@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] bio: make use of bvec_nr_vecs
Date: Sat, 26 Jul 2008 02:11:13 +0800
Message-Id: <1217009473-25878-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since introduced in 7ba1ba12eee, it should be made use of.

Signed-off-by: Denis ChengRq <crquan@gmail.com>
---
Additionally, I think it maybe better if inlined in <linux/bio.h>

 fs/bio.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 88322b0..7ed91d3 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -77,11 +77,8 @@ struct bio_vec *bvec_alloc_bs(gfp_t gfp_mask, int nr, unsigned long *idx, struct
 	 */
 
 	bvl = mempool_alloc(bs->bvec_pools[*idx], gfp_mask);
-	if (bvl) {
-		struct biovec_slab *bp = bvec_slabs + *idx;
-
-		memset(bvl, 0, bp->nr_vecs * sizeof(struct bio_vec));
-	}
+	if (bvl)
+		memset(bvl, 0, bvec_nr_vecs(*idx) * sizeof(struct bio_vec));
 
 	return bvl;
 }
@@ -149,7 +146,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 				goto out;
 			}
 			bio->bi_flags |= idx << BIO_POOL_OFFSET;
-			bio->bi_max_vecs = bvec_slabs[idx].nr_vecs;
+			bio->bi_max_vecs = bvec_nr_vecs(idx);
 		}
 		bio->bi_io_vec = bvl;
 	}
-- 
1.5.6.3

