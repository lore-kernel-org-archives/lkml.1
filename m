Return-Path: <linux-kernel-owner+w=401wt.eu-S1761522AbXJMJad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761522AbXJMJad (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 05:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760047AbXJMJaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 05:30:00 -0400
Received: from smtp8-g19.free.fr ([212.27.42.65]:44333 "EHLO smtp8-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758095AbXJMJ35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 05:29:57 -0400
X-Greylist: delayed 46291 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Oct 2007 05:29:57 EDT
Message-ID: <47109016.8000403@free.fr>
Date: Sat, 13 Oct 2007 11:29:58 +0200
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
       Edward Shishkin <edward@namesys.com>
CC: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] Reiser4: Drop 'size' argument from bio_endio and bi_end_io
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>	<470FDB41.2000102@free.fr> <20071012140023.30e5b30e.akpm@linux-foundation.org>
In-Reply-To: <20071012140023.30e5b30e.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reiser4: Drop 'size' argument from bio_endio and bi_end_io

This patch pushes into Reiser4 the changes introduced by 
commit 6712ecf8f648118c3363c142196418f89a510b90:

	As bi_end_io is only called once when the request is complete,
	the 'size' argument is now redundant.  Remove it.

	Now there is no need for bio_endio to subtract the size completed
	from bi_size.  So don't do that either.

	While we are at it, change bi_end_io to return void.

Please review.

Signed-Off-By: Laurent Riffard <laurent.riffard@free.fr>
---
 fs/reiser4/flush_queue.c  |   10 ++--------
 fs/reiser4/page_cache.c   |   24 ++++--------------------
 fs/reiser4/status_flags.c |    7 +------
 3 files changed, 7 insertions(+), 34 deletions(-)

Index: linux-2.6-mm/fs/reiser4/flush_queue.c
===================================================================
--- linux-2.6-mm.orig/fs/reiser4/flush_queue.c
+++ linux-2.6-mm/fs/reiser4/flush_queue.c
@@ -391,9 +391,8 @@ int atom_fq_parts_are_clean(txn_atom * a
 }
 #endif
 /* Bio i/o completion routine for reiser4 write operations. */
-static int
-end_io_handler(struct bio *bio, unsigned int bytes_done UNUSED_ARG,
-	       int err)
+static void
+end_io_handler(struct bio *bio, int err)
 {
 	int i;
 	int nr_errors = 0;
@@ -401,10 +400,6 @@ end_io_handler(struct bio *bio, unsigned
 
 	assert("zam-958", bio->bi_rw & WRITE);
 
-	/* i/o op. is not fully completed */
-	if (bio->bi_size != 0)
-		return 1;
-
 	if (err == -EOPNOTSUPP)
 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
 
@@ -447,7 +442,6 @@ end_io_handler(struct bio *bio, unsigned
 	}
 
 	bio_put(bio);
-	return 0;
 }
 
 /* Count I/O requests which will be submitted by @bio in given flush queues
Index: linux-2.6-mm/fs/reiser4/page_cache.c
===================================================================
--- linux-2.6-mm.orig/fs/reiser4/page_cache.c
+++ linux-2.6-mm/fs/reiser4/page_cache.c
@@ -320,18 +320,11 @@ reiser4_tree *reiser4_tree_by_page(const
    mpage_end_io_read() would also do. But it's static.
 
 */
-static int
-end_bio_single_page_read(struct bio *bio, unsigned int bytes_done UNUSED_ARG,
-			 int err UNUSED_ARG)
+static void
+end_bio_single_page_read(struct bio *bio, int err UNUSED_ARG)
 {
 	struct page *page;
 
-	if (bio->bi_size != 0) {
-		warning("nikita-3332", "Truncated single page read: %i",
-			bio->bi_size);
-		return 1;
-	}
-
 	page = bio->bi_io_vec[0].bv_page;
 
 	if (test_bit(BIO_UPTODATE, &bio->bi_flags)) {
@@ -342,7 +335,6 @@ end_bio_single_page_read(struct bio *bio
 	}
 	unlock_page(page);
 	bio_put(bio);
-	return 0;
 }
 
 /* completion handler for single page bio-based write.
@@ -350,25 +342,17 @@ end_bio_single_page_read(struct bio *bio
    mpage_end_io_write() would also do. But it's static.
 
 */
-static int
-end_bio_single_page_write(struct bio *bio, unsigned int bytes_done UNUSED_ARG,
-			  int err UNUSED_ARG)
+static void
+end_bio_single_page_write(struct bio *bio, int err UNUSED_ARG)
 {
 	struct page *page;
 
-	if (bio->bi_size != 0) {
-		warning("nikita-3333", "Truncated single page write: %i",
-			bio->bi_size);
-		return 1;
-	}
-
 	page = bio->bi_io_vec[0].bv_page;
 
 	if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		SetPageError(page);
 	end_page_writeback(page);
 	bio_put(bio);
-	return 0;
 }
 
 /* ->readpage() method for formatted nodes */
Index: linux-2.6-mm/fs/reiser4/status_flags.c
===================================================================
--- linux-2.6-mm.orig/fs/reiser4/status_flags.c
+++ linux-2.6-mm/fs/reiser4/status_flags.c
@@ -15,12 +15,8 @@
 /* This is our end I/O handler that marks page uptodate if IO was successful. It also
    unconditionally unlocks the page, so we can see that io was done.
    We do not free bio, because we hope to reuse that. */
-static int reiser4_status_endio(struct bio *bio, unsigned int bytes_done,
-				int err)
+static void reiser4_status_endio(struct bio *bio, int err)
 {
-	if (bio->bi_size)
-		return 1;
-
 	if (test_bit(BIO_UPTODATE, &bio->bi_flags)) {
 		SetPageUptodate(bio->bi_io_vec->bv_page);
 	} else {
@@ -28,7 +24,6 @@ static int reiser4_status_endio(struct b
 		SetPageError(bio->bi_io_vec->bv_page);
 	}
 	unlock_page(bio->bi_io_vec->bv_page);
-	return 0;
 }
 
 /* Initialise status code. This is expected to be called from the disk format


