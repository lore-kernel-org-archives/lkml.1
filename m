Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbYICRgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbYICRgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbYICRfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:35:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:50637 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904AbYICRf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:35:29 -0400
Date: Wed, 3 Sep 2008 10:25:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 11/42] bio: fix __bio_copy_iov() handling of bio->bv_len
Message-ID: <20080903172538.GL7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bio-fix-__bio_copy_iov-handling-of-bio-bv_len.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit aefcc28a3a63ac33a298777aa50ba43641c75241 upstream

The commit c5dec1c3034f1ae3503efbf641ff3b0273b64797 introduced
__bio_copy_iov() to add bounce support to blk_rq_map_user_iov.

__bio_copy_iov() uses bio->bv_len to copy data for READ commands after
the completion but it doesn't work with a request that partially
completed. SCSI always completes a PC request as a whole but seems
some don't.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/bio.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/bio.c
+++ b/fs/bio.c
@@ -486,8 +486,8 @@ static struct bio_map_data *bio_alloc_ma
 	return NULL;
 }
 
-static int __bio_copy_iov(struct bio *bio, struct sg_iovec *iov, int iov_count,
-			  int uncopy)
+static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
+			  struct sg_iovec *iov, int iov_count, int uncopy)
 {
 	int ret = 0, i;
 	struct bio_vec *bvec;
@@ -497,7 +497,7 @@ static int __bio_copy_iov(struct bio *bi
 
 	__bio_for_each_segment(bvec, bio, i, 0) {
 		char *bv_addr = page_address(bvec->bv_page);
-		unsigned int bv_len = bvec->bv_len;
+		unsigned int bv_len = iovecs[i].bv_len;
 
 		while (bv_len && iov_idx < iov_count) {
 			unsigned int bytes;
@@ -549,7 +549,7 @@ int bio_uncopy_user(struct bio *bio)
 	struct bio_map_data *bmd = bio->bi_private;
 	int ret;
 
-	ret = __bio_copy_iov(bio, bmd->sgvecs, bmd->nr_sgvecs, 1);
+	ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs, bmd->nr_sgvecs, 1);
 
 	bio_free_map_data(bmd);
 	bio_put(bio);
@@ -628,7 +628,7 @@ struct bio *bio_copy_user_iov(struct req
 	 * success
 	 */
 	if (!write_to_vm) {
-		ret = __bio_copy_iov(bio, iov, iov_count, 0);
+		ret = __bio_copy_iov(bio, bio->bi_io_vec, iov, iov_count, 0);
 		if (ret)
 			goto cleanup;
 	}

-- 
