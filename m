Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbYHXFs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbYHXFs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 01:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbYHXFss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 01:48:48 -0400
Received: from sh.osrg.net ([192.16.179.4]:59631 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbYHXFsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 01:48:47 -0400
Date: Sun, 24 Aug 2008 14:48:22 +0900
To: nix@esperi.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, adobriyan@gmail.com
Subject: Re: Writable packet CD-RW mounting broken in 2.6.26 by your commit
 68154e90c9d1492d570671ae181d9a8f8530da55
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <8763pr1jy0.fsf_-_@hades.wkstn.nix>
References: <20080808031437.GA14249@martell.zuzino.mipt.ru>
	<20080808053735.GA5274@martell.zuzino.mipt.ru>
	<8763pr1jy0.fsf_-_@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080824144827R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Aug 2008 22:48:55 +0100
Nix <nix@esperi.org.uk> wrote:

> On 8 Aug 2008, Alexey Dobriyan told this:
> 
> > On Fri, Aug 08, 2008 at 07:14:37AM +0400, Alexey Dobriyan wrote:
> >> On Wed, Aug 06, 2008 at 08:12:49PM +0100, Nix wrote:
> >> > It seems to be impossible to mount packet-written CD-RWs writably in
> >> > 2.6.26.x, even as root. Things worked in 2.6.25.x.
> 
> Bisected. The bug starts here:
> 
> commit 68154e90c9d1492d570671ae181d9a8f8530da55
> Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date:   Fri Apr 25 12:47:50 2008 +0200
> 
>     block: add dma alignment and padding support to blk_rq_map_kern
> 
>     This patch adds bio_copy_kern similar to
>     bio_copy_user. blk_rq_map_kern uses bio_copy_kern instead of
>     bio_map_kern if necessary.
> 
>     bio_copy_kern uses temporary pages and the bi_end_io callback frees
>     these pages. bio_copy_kern saves the original kernel buffer at
>     bio->bi_private it doesn't use something like struct bio_map_data to
>     store the information about the caller.
> 
>     Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>     Cc: Tejun Heo <htejun@gmail.com>
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Sorry about the bug and thanks for the investigation.


> So something in this patch seems to be corrupting the results of at
> least some ATAPI sg requests going to or from the block layer: and
> indeed blk_rq_map_kern(), called by pkt_generic_packet(), is changed by
> this patch.
> 
> Tomonori, Jens, can you see any immediate cause of this? It seems to me
> that the alignment check in blk_rq_map_kern() *must* be going wrong,
> somehow: this can't be an unaligned buffer or the code wouldn't have
> worked before the patch, yet if the buffer was aligned, we should be
> calling bio_map_kern(), which this patch hasn't changed. Perhaps the
> buffer length of 12 is leading it to believe that it should go via a
> bounce buffer and is calling the new code (and tripping some bug in it,
> since presumably even the new code isn't expected to corrupt the data in
> flight ;) )

Using bio_copy_kern() should be fine since it does the same thing that
bio_map_kern() does (the difference is that bio_copy_kern() does extra
memory copy).

Actually, pkt_probe_settings() should use bio_copy_kern because it
tries to do DMA with a buffer on the stack (it doesn't work on some
architectures). blk_rq_map_kern() in the latest git has the stack
checking too.

I think that I put a bug in bio_copy_kern(). Can you try this patch?

I think that bio_uncopy_user has the same bug. I'll send a patch after
fixing this bug.


diff --git a/fs/bio.c b/fs/bio.c
index 8000e2f..f58a7ba 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -942,19 +942,22 @@ static void bio_copy_kern_endio(struct bio *bio, int err)
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
 
@@ -978,11 +981,21 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 	const int nr_pages = end - start;
 	struct bio *bio;
 	struct bio_vec *bvec;
+	struct bio_map_data *bmd;
 	int i, ret;
+	struct sg_iovec iov;
+
+	iov.iov_base = data;
+	iov.iov_len = len;
+
+	bmd = bio_alloc_map_data(nr_pages, 1);
+	if (!bmd)
+		return ERR_PTR(-ENOMEM);
 
+	ret = -ENOMEM;
 	bio = bio_alloc(gfp_mask, nr_pages);
 	if (!bio)
-		return ERR_PTR(-ENOMEM);
+		goto out_bmd;
 
 	while (len) {
 		struct page *page;
@@ -1016,14 +1029,18 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
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



