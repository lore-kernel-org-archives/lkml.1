Return-Path: <linux-kernel-owner+w=401wt.eu-S1031629AbXEHTqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031629AbXEHTqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031623AbXEHTq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:46:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031605AbXEHTqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:46:24 -0400
Date: Tue, 8 May 2007 20:45:03 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, olaf.kirch@oracle.com
Subject: [2.6.22 PATCH 06/26] dm crypt: fix remove first_clone
Message-ID: <20070508194503.GM24114@agk.fab.redhat.com>
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

Get rid of first_clone in dm-crypt

This gets rid of first_clone, which is not really needed.  Apparently,
cloned bios used to share their bvec some time way in the past - this is
no longer the case. Contrarily, this even hurts us if we try to create
a clone off first_clone after it has completed, and crypt_endio has
destroyed its bvec.

Signed-off-by: olaf.kirch@oracle.com
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-crypt.c |   34 ++++++----------------------------
 1 files changed, 6 insertions(+), 28 deletions(-)

Index: linux-2.6.21/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-crypt.c	2007-05-01 17:40:48.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-crypt.c	2007-05-01 17:40:48.000000000 +0100
@@ -33,7 +33,6 @@
 struct crypt_io {
 	struct dm_target *target;
 	struct bio *base_bio;
-	struct bio *first_clone;
 	struct work_struct work;
 	atomic_t pending;
 	int error;
@@ -380,9 +379,8 @@ static int crypt_convert(struct crypt_co
  * This should never violate the device limitations
  * May return a smaller bio when running out of pages
  */
-static struct bio *
-crypt_alloc_buffer(struct crypt_io *io, unsigned int size,
-                   struct bio *base_bio, unsigned int *bio_vec_idx)
+static struct bio *crypt_alloc_buffer(struct crypt_io *io, unsigned int size,
+				      unsigned int *bio_vec_idx)
 {
 	struct crypt_config *cc = io->target->private;
 	struct bio *clone;
@@ -390,12 +388,7 @@ crypt_alloc_buffer(struct crypt_io *io, 
 	gfp_t gfp_mask = GFP_NOIO | __GFP_HIGHMEM;
 	unsigned int i;
 
-	if (base_bio) {
-		clone = bio_alloc_bioset(GFP_NOIO, base_bio->bi_max_vecs, cc->bs);
-		__bio_clone(clone, base_bio);
-	} else
-		clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, cc->bs);
-
+	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, cc->bs);
 	if (!clone)
 		return NULL;
 
@@ -498,9 +491,6 @@ static void dec_pending(struct crypt_io 
 	if (!atomic_dec_and_test(&io->pending))
 		return;
 
-	if (io->first_clone)
-		bio_put(io->first_clone);
-
 	bio_endio(io->base_bio, io->base_bio->bi_size, io->error);
 
 	mempool_free(io, cc->io_pool);
@@ -618,8 +608,7 @@ static void process_write(struct crypt_i
 	 * so repeat the whole process until all the data can be handled.
 	 */
 	while (remaining) {
-		clone = crypt_alloc_buffer(io, base_bio->bi_size,
-					   io->first_clone, &bvec_idx);
+		clone = crypt_alloc_buffer(io, base_bio->bi_size, &bvec_idx);
 		if (unlikely(!clone)) {
 			dec_pending(io, -ENOMEM);
 			return;
@@ -635,21 +624,11 @@ static void process_write(struct crypt_i
 		}
 
 		clone->bi_sector = cc->start + sector;
-
-		if (!io->first_clone) {
-			/*
-			 * hold a reference to the first clone, because it
-			 * holds the bio_vec array and that can't be freed
-			 * before all other clones are released
-			 */
-			bio_get(clone);
-			io->first_clone = clone;
-		}
-
 		remaining -= clone->bi_size;
 		sector += bio_sectors(clone);
 
-		/* prevent bio_put of first_clone */
+		/* Grab another reference to the io struct
+		 * before we kick off the request */
 		if (remaining)
 			atomic_inc(&io->pending);
 
@@ -965,7 +944,6 @@ static int crypt_map(struct dm_target *t
 	io = mempool_alloc(cc->io_pool, GFP_NOIO);
 	io->target = ti;
 	io->base_bio = bio;
-	io->first_clone = NULL;
 	io->error = io->post_process = 0;
 	atomic_set(&io->pending, 0);
 	kcryptd_queue_io(io);
