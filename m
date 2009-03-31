Return-Path: <linux-kernel-owner+w=401wt.eu-S1762460AbZCaQn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762460AbZCaQn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759803AbZCaQnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:43:17 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33483 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758768AbZCaQnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:43:16 -0400
Date: Tue, 31 Mar 2009 18:43:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ric Wheeler <rwheeler@redhat.com>,
       Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
Message-ID: <20090331164312.GP5178@kernel.dk>
References: <20090330185414.GZ5178@kernel.dk> <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain> <20090330201732.GB5178@kernel.dk> <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain> <49D17CA2.5060105@redhat.com> <alpine.LFD.2.00.0903301931230.4093@localhost.localdomain> <49D1FB64.8000505@redhat.com> <alpine.LFD.2.00.0903310746460.4093@localhost.localdomain> <49D239A0.5080405@redhat.com> <alpine.LFD.2.00.0903310854570.4093@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903310854570.4093@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31 2009, Linus Torvalds wrote:
> 
> 
> On Tue, 31 Mar 2009, Ric Wheeler wrote:
> > 
> > The question is really what we do when you have a storage device in your box
> > with a volatile write cache that does support flush or fua or similar.
> 
> Ok. Then you are talking about a different case - not EOPNOTSUPP.

So here's a test patch that attempts to just ignore such a failure to
flush the caches. It will still flag the bio as BIO_EOPNOTSUPP, but
that's merely maintaining the information in case the caller does want
to see if that barrier failed or not. It may not actually be useful, in
which case we can just kill that flag.

But it'll return 0 for a write, getting rid of hard retry logic in the
file systems. It'll also ensure that blkdev_issue_flush() does not see
the -EOPNOTSUPP and pass it back.

The first time we see such a failed barrier, we'll log a warning in
dmesg about the block device. Subsequent failed barriers with
-EOPNOTSUPP will bit warn.

Now, there's a follow up to this. If the device doesn't support barriers
and the block layer fails them early, we should still do the ordering
inside the block layer. Then we will at least not reorder there, even if
the device may or may not order. I'll test this patch and provide a
follow up patch that does that as well, before asking for any of this to
be included. So that's a note to not apply this patch, it hasn't been
tested!

commit 78ab31910c8c7b8853c1fd4d78c5f4ce2aebb516
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Tue Mar 31 18:42:42 2009 +0200

    barrier: Don't return -EOPNOTSUPP to the caller if the device does not support barriers
    
    The caller cannot really do much about the situation anyway. Instead log
    a warning if this is the first such failed barrier we see, so that the
    admin can look into whether this poses a data integrity problem or not.
    
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index f7dae57..8660146 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -338,9 +338,7 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 		*error_sector = bio->bi_sector;
 
 	ret = 0;
-	if (bio_flagged(bio, BIO_EOPNOTSUPP))
-		ret = -EOPNOTSUPP;
-	else if (!bio_flagged(bio, BIO_UPTODATE))
+	if (!bio_flagged(bio, BIO_UPTODATE))
 		ret = -EIO;
 
 	bio_put(bio);
@@ -408,9 +406,7 @@ int blkdev_issue_discard(struct block_device *bdev,
 		submit_bio(DISCARD_BARRIER, bio);
 
 		/* Check if it failed immediately */
-		if (bio_flagged(bio, BIO_EOPNOTSUPP))
-			ret = -EOPNOTSUPP;
-		else if (!bio_flagged(bio, BIO_UPTODATE))
+		if (!bio_flagged(bio, BIO_UPTODATE))
 			ret = -EIO;
 		bio_put(bio);
 	}
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 59fd05d..0a81466 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -463,6 +463,19 @@ void blk_queue_update_dma_alignment(struct request_queue *q, int mask)
 }
 EXPORT_SYMBOL(blk_queue_update_dma_alignment);
 
+void blk_queue_set_noflush(struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	char b[BDEVNAME_SIZE];
+
+	if (test_and_set_bit(QUEUE_FLAG_NOFLUSH, &q->queue_flags))
+		return;
+
+	printk(KERN_ERR "Device %s does not appear to honor cache flushes. "	
+			"This may mean that file system ordering guarantees "
+			"are not met.", bdevname(bdev, b));
+}
+
 static int __init blk_settings_init(void)
 {
 	blk_max_low_pfn = max_low_pfn - 1;
diff --git a/block/ioctl.c b/block/ioctl.c
index 0f22e62..769f7be 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -166,9 +166,7 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 
 		wait_for_completion(&wait);
 
-		if (bio_flagged(bio, BIO_EOPNOTSUPP))
-			ret = -EOPNOTSUPP;
-		else if (!bio_flagged(bio, BIO_UPTODATE))
+		if (!bio_flagged(bio, BIO_UPTODATE))
 			ret = -EIO;
 		bio_put(bio);
 	}
diff --git a/fs/bio.c b/fs/bio.c
index a040cde..79e3cec 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1380,7 +1380,17 @@ void bio_check_pages_dirty(struct bio *bio)
  **/
 void bio_endio(struct bio *bio, int error)
 {
-	if (error)
+	/*
+	 * Special case here - hide the -EOPNOTSUPP from the driver or
+	 * block layer, dump a warning the first time this happens so that
+	 * the admin knows that we may not provide the ordering guarantees
+	 * that are needed. Don't clear the uptodate bit.
+	 */
+	if (error == -EOPNOTSUPP && bio_barrier(bio)) {
+		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
+		blk_queue_set_noflush(bio->bi_bdev);
+		error = 0;
+	} else if (error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ebe6b29..d696d26 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1834,7 +1834,6 @@ extent_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
 static int submit_one_bio(int rw, struct bio *bio, int mirror_num,
 			  unsigned long bio_flags)
 {
-	int ret = 0;
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct page *page = bvec->bv_page;
 	struct extent_io_tree *tree = bio->bi_private;
@@ -1846,17 +1845,13 @@ static int submit_one_bio(int rw, struct bio *bio, int mirror_num,
 
 	bio->bi_private = NULL;
 
-	bio_get(bio);
-
 	if (tree->ops && tree->ops->submit_bio_hook)
 		tree->ops->submit_bio_hook(page->mapping->host, rw, bio,
 					   mirror_num, bio_flags);
 	else
 		submit_bio(rw, bio);
-	if (bio_flagged(bio, BIO_EOPNOTSUPP))
-		ret = -EOPNOTSUPP;
-	bio_put(bio);
-	return ret;
+
+	return 0;
 }
 
 static int submit_extent_page(int rw, struct extent_io_tree *tree,
diff --git a/fs/buffer.c b/fs/buffer.c
index a2fd743..6f50e08 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -147,17 +147,9 @@ void end_buffer_read_sync(struct buffer_head *bh, int uptodate)
 
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 {
-	char b[BDEVNAME_SIZE];
-
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
-		if (!buffer_eopnotsupp(bh) && !quiet_error(bh)) {
-			buffer_io_error(bh);
-			printk(KERN_WARNING "lost page write due to "
-					"I/O error on %s\n",
-				       bdevname(bh->b_bdev, b));
-		}
 		set_buffer_write_io_error(bh);
 		clear_buffer_uptodate(bh);
 	}
@@ -2828,7 +2820,7 @@ static void end_bio_bh_io_sync(struct bio *bio, int err)
 
 	if (err == -EOPNOTSUPP) {
 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
-		set_bit(BH_Eopnotsupp, &bh->b_state);
+		err = 0;
 	}
 
 	if (unlikely (test_bit(BIO_QUIET,&bio->bi_flags)))
@@ -2841,7 +2833,6 @@ static void end_bio_bh_io_sync(struct bio *bio, int err)
 int submit_bh(int rw, struct buffer_head * bh)
 {
 	struct bio *bio;
-	int ret = 0;
 
 	BUG_ON(!buffer_locked(bh));
 	BUG_ON(!buffer_mapped(bh));
@@ -2879,14 +2870,8 @@ int submit_bh(int rw, struct buffer_head * bh)
 	bio->bi_end_io = end_bio_bh_io_sync;
 	bio->bi_private = bh;
 
-	bio_get(bio);
 	submit_bio(rw, bio);
-
-	if (bio_flagged(bio, BIO_EOPNOTSUPP))
-		ret = -EOPNOTSUPP;
-
-	bio_put(bio);
-	return ret;
+	return 0;
 }
 
 /**
@@ -2965,10 +2950,6 @@ int sync_dirty_buffer(struct buffer_head *bh)
 		bh->b_end_io = end_buffer_write_sync;
 		ret = submit_bh(WRITE, bh);
 		wait_on_buffer(bh);
-		if (buffer_eopnotsupp(bh)) {
-			clear_buffer_eopnotsupp(bh);
-			ret = -EOPNOTSUPP;
-		}
 		if (!ret && !buffer_uptodate(bh))
 			ret = -EIO;
 	} else {
diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index de3a198..c0cacb2 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -406,7 +406,6 @@ xfs_submit_ioend_bio(
 	bio->bi_end_io = xfs_end_bio;
 
 	submit_bio(WRITE, bio);
-	ASSERT(!bio_flagged(bio, BIO_EOPNOTSUPP));
 	bio_put(bio);
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 465d6ba..ea2e15a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -452,6 +452,7 @@ struct request_queue
 #define QUEUE_FLAG_NONROT      14	/* non-rotational device (SSD) */
 #define QUEUE_FLAG_VIRT        QUEUE_FLAG_NONROT /* paravirt device */
 #define QUEUE_FLAG_IO_STAT     15	/* do IO stats */
+#define QUEUE_FLAG_NOFLUSH     16	/* device doesn't do flushes */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_CLUSTER) |		\
@@ -789,6 +790,7 @@ extern int blk_execute_rq(struct request_queue *, struct gendisk *,
 extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
 				  struct request *, int, rq_end_io_fn *);
 extern void blk_unplug(struct request_queue *q);
+extern void blk_queue_set_noflush(struct block_device *bdev);
 
 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 {
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index f19fd90..8adcaa4 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -33,7 +33,6 @@ enum bh_state_bits {
 	BH_Boundary,	/* Block is followed by a discontiguity */
 	BH_Write_EIO,	/* I/O error on write */
 	BH_Ordered,	/* ordered write */
-	BH_Eopnotsupp,	/* operation not supported (barrier) */
 	BH_Unwritten,	/* Buffer is allocated on disk but not written */
 	BH_Quiet,	/* Buffer Error Prinks to be quiet */
 
@@ -126,7 +125,6 @@ BUFFER_FNS(Delay, delay)
 BUFFER_FNS(Boundary, boundary)
 BUFFER_FNS(Write_EIO, write_io_error)
 BUFFER_FNS(Ordered, ordered)
-BUFFER_FNS(Eopnotsupp, eopnotsupp)
 BUFFER_FNS(Unwritten, unwritten)
 
 #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)

-- 
Jens Axboe

