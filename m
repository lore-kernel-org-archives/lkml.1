Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbYFHPzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbYFHPzQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 11:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbYFHPzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 11:55:04 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:36637 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbYFHPzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 11:55:01 -0400
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] fix bio_add_page for non trivial merge_bvec_fn case
From: Dmitri Monakhov <dmonakhov@openvz.org>
Date: Sun, 08 Jun 2008 19:45:08 +0400
Message-ID: <m3y75gszgb.fsf@dmon-lap.sw.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have to properly decrease all related bio's counters, especially bi_size
in order to merge_bvec_fn return right result. Usually this result in
false merge rejects for two absolutely valid bio_vecs. This may cause 
significant performance penalty for example Itanium: page_size == 16k,
fs_block_size == 1k and block device is raid with small chunk_size.

Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
---
 fs/bio.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 7856257..d713074 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -332,14 +332,21 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 
 		if (page == prev->bv_page &&
 		    offset == prev->bv_offset + prev->bv_len) {
+			/* Temprory detacth last bio_vec. */
+			bio->bi_size -= prev->bv_len;
+			bio->bi_vcnt--;
+			bio->bi_phys_segments--;
+			bio->bi_hw_segments--;
+
 			prev->bv_len += len;
 			if (q->merge_bvec_fn &&
 			    q->merge_bvec_fn(q, bio, prev) < len) {
 				prev->bv_len -= len;
-				return 0;
+				len = 0;
 			}
 
-			goto done;
+			bio->bi_size += prev->bv_len;
+			goto out_add_bvec;
 		}
 	}
 
@@ -394,11 +401,12 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	    BIOVEC_VIRT_MERGEABLE(bvec-1, bvec)))
 		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
 
+	bio->bi_size += len;
+out_add_bvec:
 	bio->bi_vcnt++;
 	bio->bi_phys_segments++;
 	bio->bi_hw_segments++;
- done:
-	bio->bi_size += len;
 	return len;
 }
 
-- 
1.5.4.rc4

