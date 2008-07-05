Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYGEORH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYGEORH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 10:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbYGEOQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 10:16:56 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:21169 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbYGEOQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 10:16:55 -0400
To: linux-kernel@vger.kernel.org
CC: Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH] block: fix bio_add_page for non trivial merge_bvec_fn case(v2)
From: Dmitri Monakhov <dmonakhov@openvz.org>
Date: Sat, 05 Jul 2008 18:16:04 +0400
Message-ID: <m3lk0gh0wr.fsf@dmon-lap.sw.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have to properly decrease bi_size in order to merge_bvec_fn return
right result.  Otherwise this result in false merge rejects for two
absolutely valid bio_vecs.  This may cause significant performance penalty
for example Itanium: page_size ==16k, fs_block_size == 1k and block device
is raid with small chunk_size.

Changes against v1:
 According to axboe@ and agk@ we don't have to decrease bi_vcnt and segments
 counters, so patch now looks like one line fix.

Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
---
 fs/bio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 25f1af0..0e6ed2a 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -330,7 +330,8 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 				struct bvec_merge_data bvm = {
 					.bi_bdev = bio->bi_bdev,
 					.bi_sector = bio->bi_sector,
-					.bi_size = bio->bi_size,
+					.bi_size = bio->bi_size -
+							(prev->bv_len - len),
 					.bi_rw = bio->bi_rw,
 				};
 
-- 
1.5.4.rc4

