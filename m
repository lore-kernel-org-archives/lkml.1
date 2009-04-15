Return-Path: <linux-kernel-owner+w=401wt.eu-S1759880AbZDONLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880AbZDONLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 09:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759674AbZDONKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 09:10:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:34996 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759594AbZDONKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 09:10:45 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] bio: use bio_kmalloc() in copy/map functions
Date: Wed, 15 Apr 2009 22:10:27 +0900
Message-Id: <1239801027-9201-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239801027-9201-1-git-send-email-tj@kernel.org>
References: <1239801027-9201-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 15 Apr 2009 13:10:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: remove possible deadlock condition

There is no reason to use mempool backed allocation for map functions.
Also, because kern mapping is used inside LLDs (e.g. for EH), using
mempool backed allocation can lead to deadlock under extreme
conditions (mempool already consumed by the time a request reached EH
and requests are blocked on EH).

Switch copy/map functions to bio_kmalloc().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/bio.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 6c2aef6..eba1804 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -816,7 +816,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 		return ERR_PTR(-ENOMEM);
 
 	ret = -ENOMEM;
-	bio = bio_alloc(gfp_mask, nr_pages);
+	bio = bio_kmalloc(gfp_mask, nr_pages);
 	if (!bio)
 		goto out_bmd;
 
@@ -940,7 +940,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	if (!nr_pages)
 		return ERR_PTR(-EINVAL);
 
-	bio = bio_alloc(gfp_mask, nr_pages);
+	bio = bio_kmalloc(gfp_mask, nr_pages);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 
@@ -1124,7 +1124,7 @@ static struct bio *__bio_map_kern(struct request_queue *q, void *data,
 	int offset, i;
 	struct bio *bio;
 
-	bio = bio_alloc(gfp_mask, nr_pages);
+	bio = bio_kmalloc(gfp_mask, nr_pages);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 
-- 
1.6.0.2

