Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbZDALGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbZDALGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbZDALE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:04:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:35191 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbZDALE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:04:57 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/8] bio: actually inline inline bvecs into bio
Date: Wed,  1 Apr 2009 20:04:40 +0900
Message-Id: <1238583884-13517-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1238583884-13517-1-git-send-email-tj@kernel.org>
References: <1238583884-13517-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 11:04:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

BIO_INLINE_VECS bvecs are inlined into bio to avoid bvec allocation
for small transfers.  This was achieved by declaring zero sized bvec
array at the end of bio and allocating bio with extra bytes at the
end.  As BIO_INLINE_VECS is constant, there is no reason to do this
allocation trick.  This patch simply defines BIO_INLINE_VECS sized
bvec array at the end.  This will help fixing bio_kmalloc().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/bio.c            |    9 +--------
 include/linux/bio.h |    9 +++++----
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index a040cde..7574839 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -31,12 +31,6 @@
 
 DEFINE_TRACE(block_split);
 
-/*
- * Test patch to inline a certain number of bi_io_vec's inside the bio
- * itself, to shrink a bio data allocation from two mempool calls to one
- */
-#define BIO_INLINE_VECS		4
-
 static mempool_t *bio_split_pool __read_mostly;
 
 /*
@@ -1550,7 +1544,6 @@ void bioset_free(struct bio_set *bs)
  */
 struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 {
-	unsigned int back_pad = BIO_INLINE_VECS * sizeof(struct bio_vec);
 	struct bio_set *bs;
 
 	bs = kzalloc(sizeof(*bs), GFP_KERNEL);
@@ -1559,7 +1552,7 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 
 	bs->front_pad = front_pad;
 
-	bs->bio_slab = bio_find_or_create_slab(front_pad + back_pad);
+	bs->bio_slab = bio_find_or_create_slab(front_pad);
 	if (!bs->bio_slab) {
 		kfree(bs);
 		return NULL;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b05b1d4..14e5f42 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -40,6 +40,8 @@
 #define BIO_MAX_SIZE		(BIO_MAX_PAGES << PAGE_CACHE_SHIFT)
 #define BIO_MAX_SECTORS		(BIO_MAX_SIZE >> 9)
 
+#define BIO_INLINE_VECS		4
+
 /*
  * was unsigned short, but we might as well be ready for > 64kB I/O pages
  */
@@ -104,11 +106,10 @@ struct bio {
 	bio_destructor_t	*bi_destructor;	/* destructor */
 
 	/*
-	 * We can inline a number of vecs at the end of the bio, to avoid
-	 * double allocations for a small number of bio_vecs. This member
-	 * MUST obviously be kept at the very end of the bio.
+	 * Inline small number of vecs in the bio to avoid double
+	 * allocations for a small number of bio_vecs.
 	 */
-	struct bio_vec		bi_inline_vecs[0];
+	struct bio_vec		bi_inline_vecs[BIO_INLINE_VECS];
 };
 
 /*
-- 
1.6.0.2

