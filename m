Return-Path: <linux-kernel-owner+w=401wt.eu-S1764753AbXHKTCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764753AbXHKTCm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762542AbXHKS6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:24 -0400
Received: from 1wt.eu ([62.212.114.60]:1554 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757958AbXHKS6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:21 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184844.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:08 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Olaf Kirch <olaf.kirch@oracle.com>, Alasdair G Kergon <agk@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 16/28] dm crypt: fix call to clone_init
Content-Disposition: inline; filename=0016-dm-crypt-fix-call-to-clone_init.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Call clone_init early

We need to call clone_init as early as possible - at least before call
bio_put(clone) in any error path.  Otherwise, the destructor will try to
dereference bi_private, which may still be NULL.

Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/md/dm-crypt.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index f68677d..bffaf1c 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -107,6 +107,8 @@ struct crypt_config {
 
 static struct kmem_cache *_crypt_io_pool;
 
+static void clone_init(struct crypt_io *, struct bio *);
+
 /*
  * Different IV generation algorithms:
  *
@@ -379,9 +381,10 @@ static int crypt_convert(struct crypt_config *cc,
  * May return a smaller bio when running out of pages
  */
 static struct bio *
-crypt_alloc_buffer(struct crypt_config *cc, unsigned int size,
+crypt_alloc_buffer(struct crypt_io *io, unsigned int size,
                    struct bio *base_bio, unsigned int *bio_vec_idx)
 {
+	struct crypt_config *cc = io->target->private;
 	struct bio *clone;
 	unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	gfp_t gfp_mask = GFP_NOIO | __GFP_HIGHMEM;
@@ -396,7 +399,7 @@ crypt_alloc_buffer(struct crypt_config *cc, unsigned int size,
 	if (!clone)
 		return NULL;
 
-	clone->bi_destructor = dm_crypt_bio_destructor;
+	clone_init(io, clone);
 
 	/* if the last bio was not complete, continue where that one ended */
 	clone->bi_idx = *bio_vec_idx;
@@ -562,6 +565,7 @@ static void clone_init(struct crypt_io *io, struct bio *clone)
 	clone->bi_end_io  = crypt_endio;
 	clone->bi_bdev    = cc->dev->bdev;
 	clone->bi_rw      = io->base_bio->bi_rw;
+	clone->bi_destructor = dm_crypt_bio_destructor;
 }
 
 static void process_read(struct crypt_io *io)
@@ -585,7 +589,6 @@ static void process_read(struct crypt_io *io)
 	}
 
 	clone_init(io, clone);
-	clone->bi_destructor = dm_crypt_bio_destructor;
 	clone->bi_idx = 0;
 	clone->bi_vcnt = bio_segments(base_bio);
 	clone->bi_size = base_bio->bi_size;
@@ -615,7 +618,7 @@ static void process_write(struct crypt_io *io)
 	 * so repeat the whole process until all the data can be handled.
 	 */
 	while (remaining) {
-		clone = crypt_alloc_buffer(cc, base_bio->bi_size,
+		clone = crypt_alloc_buffer(io, base_bio->bi_size,
 					   io->first_clone, &bvec_idx);
 		if (unlikely(!clone)) {
 			dec_pending(io, -ENOMEM);
@@ -631,7 +634,6 @@ static void process_write(struct crypt_io *io)
 			return;
 		}
 
-		clone_init(io, clone);
 		clone->bi_sector = cc->start + sector;
 
 		if (!io->first_clone) {
-- 
1.5.2.4

-- 
