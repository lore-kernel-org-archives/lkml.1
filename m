Return-Path: <linux-kernel-owner+w=401wt.eu-S968445AbXGaEeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968445AbXGaEeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967533AbXGaEb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:31:29 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34529 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966275AbXGaEbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:31:25 -0400
Date: Mon, 30 Jul 2007 21:32:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, agk@redhat.com,
       Olaf Kirch <olaf.kirch@oracle.com>, Chris Wright <chrisw@sous-sol.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 10/26] dm crypt: fix call to clone_init
Message-ID: <20070731043214.GK3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-crypt-fix-call-to-clone_init.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Olaf Kirch <olaf.kirch@oracle.com>

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
Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=027581f3515b5ec2218847dab578afa439a9d6b9

 drivers/md/dm-crypt.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- linux-2.6.21.6.orig/drivers/md/dm-crypt.c
+++ linux-2.6.21.6/drivers/md/dm-crypt.c
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

-- 
