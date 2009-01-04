Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbZADIXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbZADIXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 03:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZADIWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 03:22:45 -0500
Received: from jaguar.mkp.net ([192.139.46.146]:52477 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbZADIWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 03:22:41 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 3] block: Don't verify integrity metadata on read error
X-Mercurial-Node: 0a8342947f4930162f384dc1d73df1c0f8367507
Message-Id: <0a8342947f4930162f38.1231055018@sermon.lab.mkp.net>
In-Reply-To: <patchbomb.1231055017@sermon.lab.mkp.net>
Date: Sun, 04 Jan 2009 02:43:38 -0500
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we get an I/O error on a read request there is no point in doing a
verify pass on the integrity buffer.  Adjust the completion path
accordingly.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
2 files changed, 15 insertions(+), 11 deletions(-)
fs/bio-integrity.c  |   25 +++++++++++++++----------
include/linux/bio.h |    1 -



diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -465,7 +465,7 @@ static int bio_integrity_verify(struct b
 
 		if (ret) {
 			kunmap_atomic(kaddr, KM_USER0);
-			break;
+			return ret;
 		}
 
 		sectors = bv->bv_len / bi->sector_size;
@@ -493,18 +493,13 @@ static void bio_integrity_verify_fn(stru
 	struct bio_integrity_payload *bip =
 		container_of(work, struct bio_integrity_payload, bip_work);
 	struct bio *bio = bip->bip_bio;
-	int error = bip->bip_error;
+	int error;
 
-	if (bio_integrity_verify(bio)) {
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
-		error = -EIO;
-	}
+	error = bio_integrity_verify(bio);
 
 	/* Restore original bio completion handler */
 	bio->bi_end_io = bip->bip_end_io;
-
-	if (bio->bi_end_io)
-		bio->bi_end_io(bio, error);
+	bio_endio(bio, error);
 }
 
 /**
@@ -525,7 +520,17 @@ void bio_integrity_endio(struct bio *bio
 
 	BUG_ON(bip->bip_bio != bio);
 
-	bip->bip_error = error;
+	/* In case of an I/O error there is no point in verifying the
+	 * integrity metadata.  Restore original bio end_io handler
+	 * and run it.
+	 */
+	if (error) {
+		bio->bi_end_io = bip->bip_end_io;
+		bio_endio(bio, error);
+
+		return;
+	}
+
 	INIT_WORK(&bip->bip_work, bio_integrity_verify_fn);
 	queue_work(kintegrityd_wq, &bip->bip_work);
 }
diff --git a/include/linux/bio.h b/include/linux/bio.h
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -312,7 +312,6 @@ struct bio_integrity_payload {
 	void			*bip_buf;	/* generated integrity data */
 	bio_end_io_t		*bip_end_io;	/* saved I/O completion fn */
 
-	int			bip_error;	/* saved I/O error */
 	unsigned int		bip_size;
 
 	unsigned short		bip_pool;	/* pool the ivec came from */


