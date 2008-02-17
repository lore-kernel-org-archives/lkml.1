Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbYBQIT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbYBQIT4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757889AbYBQISL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:18:11 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59628 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757860AbYBQISI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:18:08 -0500
Date: Sun, 17 Feb 2008 10:17:41 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ken Chen <kenneth.w.chen@intel.com>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, bcrl@kvack.org,
       linux-aio@kvack.org
Subject: [RFC: 2.6 patch] fs/block_dev.c: remove #if 0'ed code
Message-ID: <20080217081741.GH3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b2e895dbd80c420bfc0937c3729b4afe073b3848 #if 0'ed this code stating:

<--  snip  -->

    [PATCH] revert blockdev direct io back to 2.6.19 version
    
    Andrew Vasquez is reporting as-iosched oopses and a 65% throughput
    slowdown due to the recent special-casing of direct-io against
    blockdevs.  We don't know why either of these things are occurring.
    
    The patch minimally reverts us back to the 2.6.19 code for a 2.6.20
    release.

<--  snip  -->

It has since been dead code, and unless someone wants to revive it now 
it's time to remove it.

This patch also makes bio_release_pages() static again and removes the 
ki_bio_count member from struct kiocb, reverting changes that had been 
done for this dead code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/bio.c            |    2 
 fs/block_dev.c      |  197 --------------------------------------------
 include/linux/aio.h |    1 
 include/linux/bio.h |    1 
 4 files changed, 1 insertion(+), 200 deletions(-)

ba8404ffaa1d5a509f7e783f15dbf0d8c827fa85 diff --git a/fs/bio.c b/fs/bio.c
index 242e409..3312fcc 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -903,7 +903,7 @@ void bio_set_pages_dirty(struct bio *bio)
 	}
 }
 
-void bio_release_pages(struct bio *bio)
+static void bio_release_pages(struct bio *bio)
 {
 	struct bio_vec *bvec = bio->bi_io_vec;
 	int i;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 8335f0e..7d822fa 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -173,203 +173,6 @@ blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 				iov, offset, nr_segs, blkdev_get_blocks, NULL);
 }
 
-#if 0
-static void blk_end_aio(struct bio *bio, int error)
-{
-	struct kiocb *iocb = bio->bi_private;
-	atomic_t *bio_count = &iocb->ki_bio_count;
-
-	if (bio_data_dir(bio) == READ)
-		bio_check_pages_dirty(bio);
-	else {
-		bio_release_pages(bio);
-		bio_put(bio);
-	}
-
-	/* iocb->ki_nbytes stores error code from LLDD */
-	if (error)
-		iocb->ki_nbytes = -EIO;
-
-	if (atomic_dec_and_test(bio_count)) {
-		if ((long)iocb->ki_nbytes < 0)
-			aio_complete(iocb, iocb->ki_nbytes, 0);
-		else
-			aio_complete(iocb, iocb->ki_left, 0);
-	}
-
-	return 0;
-}
-
-#define VEC_SIZE	16
-struct pvec {
-	unsigned short nr;
-	unsigned short idx;
-	struct page *page[VEC_SIZE];
-};
-
-#define PAGES_SPANNED(addr, len)	\
-	(DIV_ROUND_UP((addr) + (len), PAGE_SIZE) - (addr) / PAGE_SIZE);
-
-/*
- * get page pointer for user addr, we internally cache struct page array for
- * (addr, count) range in pvec to avoid frequent call to get_user_pages.  If
- * internal page list is exhausted, a batch count of up to VEC_SIZE is used
- * to get next set of page struct.
- */
-static struct page *blk_get_page(unsigned long addr, size_t count, int rw,
-				 struct pvec *pvec)
-{
-	int ret, nr_pages;
-	if (pvec->idx == pvec->nr) {
-		nr_pages = PAGES_SPANNED(addr, count);
-		nr_pages = min(nr_pages, VEC_SIZE);
-		down_read(&current->mm->mmap_sem);
-		ret = get_user_pages(current, current->mm, addr, nr_pages,
-				     rw == READ, 0, pvec->page, NULL);
-		up_read(&current->mm->mmap_sem);
-		if (ret < 0)
-			return ERR_PTR(ret);
-		pvec->nr = ret;
-		pvec->idx = 0;
-	}
-	return pvec->page[pvec->idx++];
-}
-
-/* return a page back to pvec array */
-static void blk_unget_page(struct page *page, struct pvec *pvec)
-{
-	pvec->page[--pvec->idx] = page;
-}
-
-static ssize_t
-blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-		 loff_t pos, unsigned long nr_segs)
-{
-	struct inode *inode = iocb->ki_filp->f_mapping->host;
-	unsigned blkbits = blksize_bits(bdev_hardsect_size(I_BDEV(inode)));
-	unsigned blocksize_mask = (1 << blkbits) - 1;
-	unsigned long seg = 0;	/* iov segment iterator */
-	unsigned long nvec;	/* number of bio vec needed */
-	unsigned long cur_off;	/* offset into current page */
-	unsigned long cur_len;	/* I/O len of current page, up to PAGE_SIZE */
-
-	unsigned long addr;	/* user iovec address */
-	size_t count;		/* user iovec len */
-	size_t nbytes = iocb->ki_nbytes = iocb->ki_left; /* total xfer size */
-	loff_t size;		/* size of block device */
-	struct bio *bio;
-	atomic_t *bio_count = &iocb->ki_bio_count;
-	struct page *page;
-	struct pvec pvec;
-
-	pvec.nr = 0;
-	pvec.idx = 0;
-
-	if (pos & blocksize_mask)
-		return -EINVAL;
-
-	size = i_size_read(inode);
-	if (pos + nbytes > size) {
-		nbytes = size - pos;
-		iocb->ki_left = nbytes;
-	}
-
-	/*
-	 * check first non-zero iov alignment, the remaining
-	 * iov alignment is checked inside bio loop below.
-	 */
-	do {
-		addr = (unsigned long) iov[seg].iov_base;
-		count = min(iov[seg].iov_len, nbytes);
-		if (addr & blocksize_mask || count & blocksize_mask)
-			return -EINVAL;
-	} while (!count && ++seg < nr_segs);
-	atomic_set(bio_count, 1);
-
-	while (nbytes) {
-		/* roughly estimate number of bio vec needed */
-		nvec = (nbytes + PAGE_SIZE - 1) / PAGE_SIZE;
-		nvec = max(nvec, nr_segs - seg);
-		nvec = min(nvec, (unsigned long) BIO_MAX_PAGES);
-
-		/* bio_alloc should not fail with GFP_KERNEL flag */
-		bio = bio_alloc(GFP_KERNEL, nvec);
-		bio->bi_bdev = I_BDEV(inode);
-		bio->bi_end_io = blk_end_aio;
-		bio->bi_private = iocb;
-		bio->bi_sector = pos >> blkbits;
-same_bio:
-		cur_off = addr & ~PAGE_MASK;
-		cur_len = PAGE_SIZE - cur_off;
-		if (count < cur_len)
-			cur_len = count;
-
-		page = blk_get_page(addr, count, rw, &pvec);
-		if (unlikely(IS_ERR(page)))
-			goto backout;
-
-		if (bio_add_page(bio, page, cur_len, cur_off)) {
-			pos += cur_len;
-			addr += cur_len;
-			count -= cur_len;
-			nbytes -= cur_len;
-
-			if (count)
-				goto same_bio;
-			while (++seg < nr_segs) {
-				addr = (unsigned long) iov[seg].iov_base;
-				count = iov[seg].iov_len;
-				if (!count)
-					continue;
-				if (unlikely(addr & blocksize_mask ||
-					     count & blocksize_mask)) {
-					page = ERR_PTR(-EINVAL);
-					goto backout;
-				}
-				count = min(count, nbytes);
-				goto same_bio;
-			}
-		} else {
-			blk_unget_page(page, &pvec);
-		}
-
-		/* bio is ready, submit it */
-		if (rw == READ)
-			bio_set_pages_dirty(bio);
-		atomic_inc(bio_count);
-		submit_bio(rw, bio);
-	}
-
-completion:
-	iocb->ki_left -= nbytes;
-	nbytes = iocb->ki_left;
-	iocb->ki_pos += nbytes;
-
-	blk_run_address_space(inode->i_mapping);
-	if (atomic_dec_and_test(bio_count))
-		aio_complete(iocb, nbytes, 0);
-
-	return -EIOCBQUEUED;
-
-backout:
-	/*
-	 * back out nbytes count constructed so far for this bio,
-	 * we will throw away current bio.
-	 */
-	nbytes += bio->bi_size;
-	bio_release_pages(bio);
-	bio_put(bio);
-
-	/*
-	 * if no bio was submmitted, return the error code.
-	 * otherwise, proceed with pending I/O completion.
-	 */
-	if (atomic_read(bio_count) == 1)
-		return PTR_ERR(page);
-	goto completion;
-}
-#endif
-
 static int blkdev_writepage(struct page *page, struct writeback_control *wbc)
 {
 	return block_write_full_page(page, blkdev_get_block, wbc);
diff --git a/include/linux/aio.h b/include/linux/aio.h
index cf0f82b..b51ddd2 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -105,7 +105,6 @@ struct kiocb {
 	wait_queue_t		ki_wait;
 	loff_t			ki_pos;
 
-	atomic_t		ki_bio_count;	/* num bio used for this iocb */
 	void			*private;
 	/* State that we remember to be able to restart/retry  */
 	unsigned short		ki_opcode;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4da4413..4c59bdc 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -326,7 +326,6 @@ extern struct bio *bio_map_kern(struct request_queue *, void *, unsigned int,
 				gfp_t);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
-extern void bio_release_pages(struct bio *bio);
 extern struct bio *bio_copy_user(struct request_queue *, unsigned long, unsigned int, int);
 extern int bio_uncopy_user(struct bio *);
 void zero_fill_bio(struct bio *bio);

