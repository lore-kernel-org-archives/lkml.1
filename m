Return-Path: <linux-kernel-owner+w=401wt.eu-S1031638AbXEHTql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031638AbXEHTql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031626AbXEHTq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:46:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031621AbXEHTqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:46:25 -0400
Date: Tue, 8 May 2007 20:45:17 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, olaf.kirch@oracle.com
Subject: [2.6.22 PATCH 07/26] dm crypt: use smaller bvecs in clones
Message-ID: <20070508194517.GN24114@agk.fab.redhat.com>
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

Allocate smaller clones

With the previous dm-crypt fixes, there is no need for the clone
bios to have the same bvec size as the original - we just
need to make them big enough for the remaining number of
pages. The only requirement is that we clear the "out" index
in convert_context, so that crypt_convert starts storing data
at the right position within the clone bio.

Signed-off-by: olaf.kirch@oracle.com
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-crypt.c |   29 ++++++++---------------------
 1 files changed, 8 insertions(+), 21 deletions(-)

Index: linux-2.6.21/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-crypt.c	2007-05-01 17:40:48.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-crypt.c	2007-05-01 17:40:49.000000000 +0100
@@ -379,8 +379,7 @@ static int crypt_convert(struct crypt_co
  * This should never violate the device limitations
  * May return a smaller bio when running out of pages
  */
-static struct bio *crypt_alloc_buffer(struct crypt_io *io, unsigned int size,
-				      unsigned int *bio_vec_idx)
+static struct bio *crypt_alloc_buffer(struct crypt_io *io, unsigned int size)
 {
 	struct crypt_config *cc = io->target->private;
 	struct bio *clone;
@@ -394,16 +393,7 @@ static struct bio *crypt_alloc_buffer(st
 
 	clone_init(io, clone);
 
-	/* if the last bio was not complete, continue where that one ended */
-	clone->bi_idx = *bio_vec_idx;
-	clone->bi_vcnt = *bio_vec_idx;
-	clone->bi_size = 0;
-	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
-
-	/* clone->bi_idx pages have already been allocated */
-	size -= clone->bi_idx * PAGE_SIZE;
-
-	for (i = clone->bi_idx; i < nr_iovecs; i++) {
+	for (i = 0; i < nr_iovecs; i++) {
 		struct bio_vec *bv = bio_iovec_idx(clone, i);
 
 		bv->bv_page = mempool_alloc(cc->page_pool, gfp_mask);
@@ -415,7 +405,7 @@ static struct bio *crypt_alloc_buffer(st
 		 * return a partially allocated bio, the caller will then try
 		 * to allocate additional bios while submitting this partial bio
 		 */
-		if ((i - clone->bi_idx) == (MIN_BIO_PAGES - 1))
+		if (i == (MIN_BIO_PAGES - 1))
 			gfp_mask = (gfp_mask | __GFP_NOWARN) & ~__GFP_WAIT;
 
 		bv->bv_offset = 0;
@@ -434,12 +424,6 @@ static struct bio *crypt_alloc_buffer(st
 		return NULL;
 	}
 
-	/*
-	 * Remember the last bio_vec allocated to be able
-	 * to correctly continue after the splitting.
-	 */
-	*bio_vec_idx = clone->bi_vcnt;
-
 	return clone;
 }
 
@@ -597,7 +581,6 @@ static void process_write(struct crypt_i
 	struct convert_context ctx;
 	unsigned remaining = base_bio->bi_size;
 	sector_t sector = base_bio->bi_sector - io->target->begin;
-	unsigned bvec_idx = 0;
 
 	atomic_inc(&io->pending);
 
@@ -608,13 +591,14 @@ static void process_write(struct crypt_i
 	 * so repeat the whole process until all the data can be handled.
 	 */
 	while (remaining) {
-		clone = crypt_alloc_buffer(io, base_bio->bi_size, &bvec_idx);
+		clone = crypt_alloc_buffer(io, remaining);
 		if (unlikely(!clone)) {
 			dec_pending(io, -ENOMEM);
 			return;
 		}
 
 		ctx.bio_out = clone;
+		ctx.idx_out = 0;
 
 		if (unlikely(crypt_convert(cc, &ctx) < 0)) {
 			crypt_free_buffer_pages(cc, clone, clone->bi_size);
@@ -623,6 +607,9 @@ static void process_write(struct crypt_i
 			return;
 		}
 
+		/* crypt_convert should have filled the clone bio */
+		BUG_ON(ctx.idx_out < clone->bi_vcnt);
+
 		clone->bi_sector = cc->start + sector;
 		remaining -= clone->bi_size;
 		sector += bio_sectors(clone);
