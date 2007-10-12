Return-Path: <linux-kernel-owner+w=401wt.eu-S1762917AbXJLRXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762917AbXJLRXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762521AbXJLRVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:21:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761048AbXJLRVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:21:11 -0400
Date: Fri, 12 Oct 2007 18:20:58 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Milan Broz <mbroz@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [2.6.24 PATCH 18/25] dm crypt: tidy pending
Message-ID: <20071012172058.GD24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Milan Broz <mbroz@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milan Broz <mbroz@redhat.com>

Add crypt prefix to dec_pending to avoid confusing it in backtraces with
the dm core function of the same name.

No functional change here.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-crypt.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6.23/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-crypt.c	2007-10-12 14:52:45.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-crypt.c	2007-10-12 15:03:21.000000000 +0100
@@ -481,7 +481,7 @@ static void crypt_free_buffer_pages(stru
  * One of the bios was finished. Check for completion of
  * the whole request and correctly clean up the buffer.
  */
-static void dec_pending(struct dm_crypt_io *io, int error)
+static void crypt_dec_pending(struct dm_crypt_io *io, int error)
 {
 	struct crypt_config *cc = (struct crypt_config *) io->target->private;
 
@@ -554,7 +554,7 @@ static void crypt_endio(struct bio *clon
 
 out:
 	bio_put(clone);
-	dec_pending(io, error);
+	crypt_dec_pending(io, error);
 }
 
 static void clone_init(struct dm_crypt_io *io, struct bio *clone)
@@ -584,7 +584,7 @@ static void process_read(struct dm_crypt
 	 */
 	clone = bio_alloc_bioset(GFP_NOIO, bio_segments(base_bio), cc->bs);
 	if (unlikely(!clone)) {
-		dec_pending(io, -ENOMEM);
+		crypt_dec_pending(io, -ENOMEM);
 		return;
 	}
 
@@ -619,7 +619,7 @@ static void process_write(struct dm_cryp
 	while (remaining) {
 		clone = crypt_alloc_buffer(io, remaining);
 		if (unlikely(!clone)) {
-			dec_pending(io, -ENOMEM);
+			crypt_dec_pending(io, -ENOMEM);
 			return;
 		}
 
@@ -629,7 +629,7 @@ static void process_write(struct dm_cryp
 		if (unlikely(crypt_convert(cc, &ctx) < 0)) {
 			crypt_free_buffer_pages(cc, clone, clone->bi_size);
 			bio_put(clone);
-			dec_pending(io, -EIO);
+			crypt_dec_pending(io, -EIO);
 			return;
 		}
 
@@ -664,7 +664,7 @@ static void process_read_endio(struct dm
 	crypt_convert_init(cc, &ctx, io->base_bio, io->base_bio,
 			   io->base_bio->bi_sector - io->target->begin, 0);
 
-	dec_pending(io, crypt_convert(cc, &ctx));
+	crypt_dec_pending(io, crypt_convert(cc, &ctx));
 }
 
 static void kcryptd_do_work(struct work_struct *work)
