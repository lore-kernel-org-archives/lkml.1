Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbYICRg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbYICRg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379AbYICRfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:35:54 -0400
Received: from mx1.suse.de ([195.135.220.2]:50826 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755987AbYICRfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:35:53 -0400
Date: Wed, 3 Sep 2008 10:25:40 -0700
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
Subject: [patch 12/42] bio: fix bio_copy_kern() handling of bio->bv_len
Message-ID: <20080903172540.GM7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bio-fix-bio_copy_kern-handling-of-bio-bv_len.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit 76029ff37f31dad64641489c610d98955217bb68 upstream

The commit 68154e90c9d1492d570671ae181d9a8f8530da55 introduced
bio_copy_kern() to add bounce support to blk_rq_map_kern.

bio_copy_kern() uses bio->bv_len to copy data for READ commands after
the completion but it doesn't work with a request that partially
completed. SCSI always completes a PC request as a whole but seems
some don't.

This patch fixes bio_copy_kern to handle the above case. As
bio_copy_user does, bio_copy_kern uses struct bio_map_data to store
struct bio_vec.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reported-by: Nix <nix@esperi.org.uk>
Tested-by: Nix <nix@esperi.org.uk>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/bio.c |   38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

--- a/fs/bio.c
+++ b/fs/bio.c
@@ -464,20 +464,21 @@ static void bio_free_map_data(struct bio
 	kfree(bmd);
 }
 
-static struct bio_map_data *bio_alloc_map_data(int nr_segs, int iov_count)
+static struct bio_map_data *bio_alloc_map_data(int nr_segs, int iov_count,
+					       gfp_t gfp_mask)
 {
-	struct bio_map_data *bmd = kmalloc(sizeof(*bmd), GFP_KERNEL);
+	struct bio_map_data *bmd = kmalloc(sizeof(*bmd), gfp_mask);
 
 	if (!bmd)
 		return NULL;
 
-	bmd->iovecs = kmalloc(sizeof(struct bio_vec) * nr_segs, GFP_KERNEL);
+	bmd->iovecs = kmalloc(sizeof(struct bio_vec) * nr_segs, gfp_mask);
 	if (!bmd->iovecs) {
 		kfree(bmd);
 		return NULL;
 	}
 
-	bmd->sgvecs = kmalloc(sizeof(struct sg_iovec) * iov_count, GFP_KERNEL);
+	bmd->sgvecs = kmalloc(sizeof(struct sg_iovec) * iov_count, gfp_mask);
 	if (bmd->sgvecs)
 		return bmd;
 
@@ -591,7 +592,7 @@ struct bio *bio_copy_user_iov(struct req
 		len += iov[i].iov_len;
 	}
 
-	bmd = bio_alloc_map_data(nr_pages, iov_count);
+	bmd = bio_alloc_map_data(nr_pages, iov_count, GFP_KERNEL);
 	if (!bmd)
 		return ERR_PTR(-ENOMEM);
 
@@ -941,19 +942,22 @@ static void bio_copy_kern_endio(struct b
 {
 	struct bio_vec *bvec;
 	const int read = bio_data_dir(bio) == READ;
-	char *p = bio->bi_private;
+	struct bio_map_data *bmd = bio->bi_private;
 	int i;
+	char *p = bmd->sgvecs[0].iov_base;
 
 	__bio_for_each_segment(bvec, bio, i, 0) {
 		char *addr = page_address(bvec->bv_page);
+		int len = bmd->iovecs[i].bv_len;
 
 		if (read && !err)
-			memcpy(p, addr, bvec->bv_len);
+			memcpy(p, addr, len);
 
 		__free_page(bvec->bv_page);
-		p += bvec->bv_len;
+		p += len;
 	}
 
+	bio_free_map_data(bmd);
 	bio_put(bio);
 }
 
@@ -977,11 +981,21 @@ struct bio *bio_copy_kern(struct request
 	const int nr_pages = end - start;
 	struct bio *bio;
 	struct bio_vec *bvec;
+	struct bio_map_data *bmd;
 	int i, ret;
+	struct sg_iovec iov;
 
+	iov.iov_base = data;
+	iov.iov_len = len;
+
+	bmd = bio_alloc_map_data(nr_pages, 1, gfp_mask);
+	if (!bmd)
+		return ERR_PTR(-ENOMEM);
+
+	ret = -ENOMEM;
 	bio = bio_alloc(gfp_mask, nr_pages);
 	if (!bio)
-		return ERR_PTR(-ENOMEM);
+		goto out_bmd;
 
 	while (len) {
 		struct page *page;
@@ -1015,14 +1029,18 @@ struct bio *bio_copy_kern(struct request
 		}
 	}
 
-	bio->bi_private = data;
+	bio->bi_private = bmd;
 	bio->bi_end_io = bio_copy_kern_endio;
+
+	bio_set_map_data(bmd, bio, &iov, 1);
 	return bio;
 cleanup:
 	bio_for_each_segment(bvec, bio, i)
 		__free_page(bvec->bv_page);
 
 	bio_put(bio);
+out_bmd:
+	bio_free_map_data(bmd);
 
 	return ERR_PTR(ret);
 }

-- 
