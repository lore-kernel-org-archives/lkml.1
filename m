Return-Path: <linux-kernel-owner+w=401wt.eu-S1031775AbXEHTsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031775AbXEHTsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031654AbXEHTsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:48:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031224AbXEHTsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:48:42 -0400
Date: Tue, 8 May 2007 20:44:22 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, olaf.kirch@oracle.com
Subject: [2.6.22 PATCH 04/26] dm crypt: fix call to clone_init
Message-ID: <20070508194422.GK24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	olaf.kirch@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: olaf.kirch@oracle.com

Call clone_init early

We need to call clone_init as early as possible - at least
before call bio_put(clone) in any error path. Otherwise,
the destructor will try to dereference bi_private, which
may still be NULL.

Signed-off-by: olaf.kirch@oracle.com
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-crypt.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6.21/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-crypt.c	2007-05-01 17:40:47.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-crypt.c	2007-05-01 17:40:48.000000000 +0100
@@ -107,6 +107,8 @@ struct crypt_config {
 
 static struct kmem_cache *_crypt_io_pool;
 
+static void clone_init(struct crypt_io *, struct bio *);
+
 /*
  * Different IV generation algorithms:
  *
@@ -379,9 +381,10 @@ static int crypt_convert(struct crypt_co
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
@@ -396,7 +399,7 @@ crypt_alloc_buffer(struct crypt_config *
 	if (!clone)
 		return NULL;
 
-	clone->bi_destructor = dm_crypt_bio_destructor;
+	clone_init(io, clone);
 
 	/* if the last bio was not complete, continue where that one ended */
 	clone->bi_idx = *bio_vec_idx;
@@ -562,6 +565,7 @@ static void clone_init(struct crypt_io *
 	clone->bi_end_io  = crypt_endio;
 	clone->bi_bdev    = cc->dev->bdev;
 	clone->bi_rw      = io->base_bio->bi_rw;
+	clone->bi_destructor = dm_crypt_bio_destructor;
 }
 
 static void process_read(struct crypt_io *io)
@@ -585,7 +589,6 @@ static void process_read(struct crypt_io
 	}
 
 	clone_init(io, clone);
-	clone->bi_destructor = dm_crypt_bio_destructor;
 	clone->bi_idx = 0;
 	clone->bi_vcnt = bio_segments(base_bio);
 	clone->bi_size = base_bio->bi_size;
@@ -615,7 +618,7 @@ static void process_write(struct crypt_i
 	 * so repeat the whole process until all the data can be handled.
 	 */
 	while (remaining) {
-		clone = crypt_alloc_buffer(cc, base_bio->bi_size,
+		clone = crypt_alloc_buffer(io, base_bio->bi_size,
 					   io->first_clone, &bvec_idx);
 		if (unlikely(!clone)) {
 			dec_pending(io, -ENOMEM);
@@ -631,7 +634,6 @@ static void process_write(struct crypt_i
 			return;
 		}
 
-		clone_init(io, clone);
 		clone->bi_sector = cc->start + sector;
 
 		if (!io->first_clone) {
