Return-Path: <linux-kernel-owner+w=401wt.eu-S933198AbXJPLpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198AbXJPLpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 07:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759835AbXJPLpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 07:45:19 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17091 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759325AbXJPLpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 07:45:17 -0400
Date: Tue, 16 Oct 2007 13:44:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Kristof Provost <Kristof@provost-engineering.be>
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>
Subject: Re: [BUG] memory leak in dm
Message-ID: <20071016114458.GD5263@kernel.dk>
References: <20071016113800.GA4631@luggage>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016113800.GA4631@luggage>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16 2007, Kristof Provost wrote:
> 
> Hi,
> 
> I'm seeing a serious memory leak whenever I use my /home partition.
> It's an encrypted partition using dm-crypt. Simply running 
> 'stress -d 5' is enough to exhaust the memory in a few minutes.
> 
> When I stop 'stress' the memory isn't returned.
> This doesn't seem to happen when I run stress on a normal (no dm and 
> no encryption) partition.
> 
> Here's the output of 'free -m' before and after 'stress -d 1 -t 5'
> Before:
>              total       used       free     shared    buffers     cached
> Mem:           751        584        167          0         14        235
> -/+ buffers/cache:        334        416
> Swap:          980          0        980
> 
> After:
>              total       used       free     shared    buffers     cached
> Mem:           751        619        131          0         12        169
> -/+ buffers/cache:        437        313
> Swap:          980          0        980
> 
> That's 100Mb of RAM gone in 5 seconds.  
> 
> I'm using a standard x86 centrino laptop.
> The log files don't reveal anything suspicious.
> 
> git bisect tells me it started in one of these commits:
> d24517d793f21edab1a411da95f2c45cb88a84aa, 
> 5bb23a688b2de23d7765a1dd439d89c038378978 and 
> 9cc54d40b8ca01fcefc9151044b6996565061d90. 
> 
> The bug is still present in the last version of Linus' tree
> (65a6ec0d72a07f16719e9b7a96e1c4bae044b591)
> 
> Let me know if I can provide more information.

Please try with this patch from Neil.

diff .prev/drivers/md/dm-crypt.c ./drivers/md/dm-crypt.c
--- .prev/drivers/md/dm-crypt.c	2007-10-15 17:18:20.000000000 +1000
+++ ./drivers/md/dm-crypt.c	2007-10-15 17:21:43.000000000 +1000
@@ -444,32 +444,12 @@ static struct bio *crypt_alloc_buffer(st
 }
 
 static void crypt_free_buffer_pages(struct crypt_config *cc,
-				    struct bio *clone, unsigned int bytes)
+				    struct bio *clone)
 {
-	unsigned int i, start, end;
+	unsigned int i;
 	struct bio_vec *bv;
 
-	/*
-	 * This is ugly, but Jens Axboe thinks that using bi_idx in the
-	 * endio function is too dangerous at the moment, so I calculate the
-	 * correct position using bi_vcnt and bi_size.
-	 * The bv_offset and bv_len fields might already be modified but we
-	 * know that we always allocated whole pages.
-	 * A fix to the bi_idx issue in the kernel is in the works, so
-	 * we will hopefully be able to revert to the cleaner solution soon.
-	 */
-	i = clone->bi_vcnt - 1;
-	bv = bio_iovec_idx(clone, i);
-	end = (i << PAGE_SHIFT) + (bv->bv_offset + bv->bv_len) - clone->bi_size;
-	start = end - bytes;
-
-	start >>= PAGE_SHIFT;
-	if (!clone->bi_size)
-		end = clone->bi_vcnt;
-	else
-		end >>= PAGE_SHIFT;
-
-	for (i = start; i < end; i++) {
+	for (i = 0; i < clone->bi_vcnt; i++) {
 		bv = bio_iovec_idx(clone, i);
 		BUG_ON(!bv->bv_page);
 		mempool_free(bv->bv_page, cc->page_pool);
@@ -539,7 +519,7 @@ static void crypt_endio(struct bio *clon
 	 * free the processed pages
 	 */
 	if (!read_io) {
-		crypt_free_buffer_pages(cc, clone, clone->bi_size);
+		crypt_free_buffer_pages(cc, clone);
 		goto out;
 	}
 
@@ -628,7 +608,7 @@ static void process_write(struct dm_cryp
 		ctx.idx_out = 0;
 
 		if (unlikely(crypt_convert(cc, &ctx) < 0)) {
-			crypt_free_buffer_pages(cc, clone, clone->bi_size);
+			crypt_free_buffer_pages(cc, clone);
 			bio_put(clone);
 			crypt_dec_pending(io, -EIO);
 			return;

-- 
Jens Axboe

