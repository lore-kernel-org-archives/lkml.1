Return-Path: <linux-kernel-owner+w=401wt.eu-S1764999AbXGROQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764999AbXGROQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760083AbXGROQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:16:00 -0400
Received: from brick.kernel.dk ([80.160.20.94]:11531 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbXGROQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:16:00 -0400
Date: Wed, 18 Jul 2007 16:15:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] Check for compound pages in set_page_dirty()
Message-ID: <20070718141533.GA11657@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have these checks scattered, makes sense to put them in
set_page_dirty() instead. This also fixes a bug where __bio_unmap_user()
does set_page_dirty_lock() without checking for a compound page, instead
of adding one more check we move it to set_page_dirty().

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/fs/bio.c b/fs/bio.c
index cd888f9..ff96cd9 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -902,7 +902,7 @@ void bio_set_pages_dirty(struct bio *bio)
 	for (i = 0; i < bio->bi_vcnt; i++) {
 		struct page *page = bvec[i].bv_page;
 
-		if (page && !PageCompound(page))
+		if (page)
 			set_page_dirty_lock(page);
 	}
 }
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 52bb263..72195bc 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -426,7 +426,7 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 		for (page_no = 0; page_no < bio->bi_vcnt; page_no++) {
 			struct page *page = bvec[page_no].bv_page;
 
-			if (dio->rw == READ && !PageCompound(page))
+			if (dio->rw == READ)
 				set_page_dirty_lock(page);
 			page_cache_release(page);
 		}
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 886ea0d..3c590b9 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -861,8 +861,12 @@ EXPORT_SYMBOL(redirty_page_for_writepage);
  */
 int fastcall set_page_dirty(struct page *page)
 {
-	struct address_space *mapping = page_mapping(page);
+	struct address_space *mapping;
+	
+	if (unlikely(PageCompound(page)))
+		return 0;
 
+	mapping = page_mapping(page);
 	if (likely(mapping)) {
 		int (*spd)(struct page *) = mapping->a_ops->set_page_dirty;
 #ifdef CONFIG_BLOCK

-- 
Jens Axboe

