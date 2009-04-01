Return-Path: <linux-kernel-owner+w=401wt.eu-S1761396AbZDALHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761396AbZDALHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbZDALFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:05:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:35201 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110AbZDALFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:05:02 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/8] blk-map: let blk_rq_map_user_iov() support null mapping
Date: Wed,  1 Apr 2009 20:04:43 +0900
Message-Id: <1238583884-13517-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238583884-13517-1-git-send-email-tj@kernel.org>
References: <1238583884-13517-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 11:04:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: API expansion

Till now, only blk_rq_map() supported null mapping.  Add null mapping
support to blk_rq_map_user_iov() by moving BIO_NULL_MAPPED setting to
bio_copy_user_iov().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-map.c |    3 ---
 fs/bio.c        |    4 +++-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 6718021..ac1961d 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -63,9 +63,6 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	if (map_data && map_data->null_mapped)
-		bio->bi_flags |= (1 << BIO_NULL_MAPPED);
-
 	orig_bio = bio;
 	blk_queue_bounce(q, &bio);
 
diff --git a/fs/bio.c b/fs/bio.c
index 8ad9784..728bef9 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -869,7 +869,9 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	/*
 	 * success
 	 */
-	if (!write_to_vm && (!map_data || !map_data->null_mapped)) {
+	if (unlikely(map_data && map_data->null_mapped))
+		bio->bi_flags |= (1 << BIO_NULL_MAPPED);
+	else if (!write_to_vm) {
 		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0, 0);
 		if (ret)
 			goto cleanup;
-- 
1.6.0.2

