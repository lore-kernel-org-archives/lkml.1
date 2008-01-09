Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbYAIIwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbYAIIwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 03:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYAIIwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 03:52:39 -0500
Received: from brick.kernel.dk ([87.55.233.238]:5020 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbYAIIwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 03:52:36 -0500
Date: Wed, 9 Jan 2008 09:52:32 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: chris.mason@oracle.com, linux-fsdevel@vger.kernel.org
Subject: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080109085231.GE6650@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

loop.c currently uses the page cache interface to do IO to file backed
devices. This works reasonably well for simple things, like mapping an
iso9660 file for direct mount and other read-only workloads. Writing is
somewhat problematic, as anyone who has really used this feature can
attest to - it tends to confuse the vm (hello kswapd) since it break
dirty accounting and behaves very erratically on writeout. Did I mention
that it's pretty slow as well, for both reads and writes?

It also behaves differently than a real drive. For writes, completions
are done once they hit page cache. Since loop queues bio's async and
hands them off to a thread, you can have a huge backlog of stuff to do.
It's hard to attempt to guarentee data safety for file systems on top of
loop without making it even slower than it currently is.

Back when loop was only used for iso9660 mounting and other simple
things, this didn't matter. Now it's often used in xen (and others)
setups where we do care about performance AND writing. So the below is a
attempt at speeding up loop and making it behave like a real device.
It's a somewhat quick hack and is still missing one piece to be
complete, but I'll throw it out there for people to play with and
comment on.

So how does it work? Instead of punting IO to a thread and passing it
through the page cache, we instead attempt to send the IO directly to the
filesystem block that it maps to. loop maintains a prio tree of known
extents in the file (populated lazily on demand, as needed). Advantages
of this approach:

- It's fast, loop will basically work at device speed.
- It's fast, loop it doesn't put a huge amount of system load on the
  system when busy. When I did comparison tests on my notebook with an
  external drive, running a simple tiobench on the current in-kernel
  loop with a sparse file backing rendered the notebook basically
  unusable while the test was ongoing. The remapper version had no more
  impact than it did when used directly on the external drive.
- It behaves like a real block device.
- It's easy to support IO barriers, which is needed to ensure safety
  especially in virtualized setups.

Disadvantages:

- The file block mappings must not change while loop is using the file.
  This means that we have to ensure exclusive access to the file and
  this is the bit that is currently missing in the implementation. It
  would be nice if we could just do this via open(), ideas welcome...
- It'll tie down a bit of memory for the prio tree. This is GREATLY
  offset by the reduced page cache foot print though.
- It cannot be used with the loop encryption stuff. dm-crypt should be
  used instead, on top of loop (which, I think, is even the recommended
  way to do this today, so not a big deal).

This patch will automatically enable the new operation mode (called
fastfs). I added an ioctl (LOOP_SET_FASTFS) that should be implemented
in losetup, then we can remove this hunk in the code:

+       /*
+        * This needs to be done after setup with another ioctl,
+        * not automatically like this.
+        */
+       loop_init_fastfs(lo);
+

from loop_set_fd().

Patch is against 2.6.23-rc7 ('ish, as of this morning), will probably
apply easily to 2.6.22 as well.


diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 56e2304..e49bfa8 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -481,16 +481,51 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 	return ret;
 }
 
+#define __lo_throttle(wq, lock, condition)				\
+do {									\
+	DEFINE_WAIT(__wait);						\
+	for (;;) {							\
+		prepare_to_wait((wq), &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		spin_unlock_irq((lock));				\
+		io_schedule();						\
+		spin_lock_irq((lock));					\
+	}								\
+	finish_wait((wq), &__wait);					\
+} while (0)								\
+
+#define lo_act_bio(bio)	((bio)->bi_bdev)
+#define LO_BIO_THROTTLE	128
+
 /*
- * Add bio to back of pending list
+ * A normal block device will throttle on request allocation. Do the same
+ * for loop to prevent millions of bio's queued internally.
+ */
+static void loop_bio_throttle(struct loop_device *lo, struct bio *bio)
+{
+	if (lo_act_bio(bio))
+		__lo_throttle(&lo->lo_bio_wait, &lo->lo_lock,
+				lo->lo_bio_cnt < LO_BIO_THROTTLE);
+}
+
+/*
+ * Add bio to back of pending list and wakeup thread
  */
 static void loop_add_bio(struct loop_device *lo, struct bio *bio)
 {
+	loop_bio_throttle(lo, bio);
+
 	if (lo->lo_biotail) {
 		lo->lo_biotail->bi_next = bio;
 		lo->lo_biotail = bio;
 	} else
 		lo->lo_bio = lo->lo_biotail = bio;
+
+	if (lo_act_bio(bio))
+		lo->lo_bio_cnt++;
+
+	wake_up(&lo->lo_event);
 }
 
 /*
@@ -505,11 +540,230 @@ static struct bio *loop_get_bio(struct loop_device *lo)
 			lo->lo_biotail = NULL;
 		lo->lo_bio = bio->bi_next;
 		bio->bi_next = NULL;
+
+		if (lo_act_bio(bio))
+			lo->lo_bio_cnt--;
+		if (lo->lo_bio_cnt < LO_BIO_THROTTLE || !lo->lo_bio)
+			wake_up(&lo->lo_bio_wait);
 	}
 
 	return bio;
 }
 
+struct loop_file_extent {
+	struct prio_tree_node prio_node;
+	sector_t disk_block;
+	sector_t file_block;
+	unsigned int nr_blocks;
+};
+
+#define node_to_lfe(n)	prio_tree_entry((n), struct loop_file_extent, prio_node)
+
+static void loop_prio_remove_node(struct loop_device *lo,
+				  struct loop_file_extent *lfe)
+{
+	if (lo->last_lookup == &lfe->prio_node)
+		lo->last_lookup = NULL;
+	if (lo->last_insert == &lfe->prio_node)
+		lo->last_insert = NULL;
+
+	prio_tree_remove(&lo->prio_root, &lfe->prio_node);
+}
+
+/*
+ * Drop and free all stored extents
+ */
+static void loop_drop_extents(struct loop_device *lo)
+{
+	struct prio_tree_node *node;
+	struct prio_tree_iter iter;
+	unsigned int nr_extents = 0;
+
+	/*
+	 * We may need a few iterations to prune all entries, since we are
+	 * removing nodes while iterating the tree.
+	 */
+	do {
+		struct loop_file_extent *lfe;
+
+		prio_tree_iter_init(&iter, &lo->prio_root, 0, (pgoff_t) -1);
+
+		while ((node = prio_tree_next(&iter)) != NULL) {
+			lfe = node_to_lfe(node);
+			loop_prio_remove_node(lo, lfe);
+			kfree(lfe);
+			nr_extents++;
+		}
+	} while (!prio_tree_empty(&lo->prio_root));
+
+	printk(KERN_INFO "loop%d: dropped %u extents\n", lo->lo_number, nr_extents);
+}
+
+/*
+ * Most lookups are for the same extent a number of times, before switching
+ * to a new one. This happens for bio page adds, for instance. So cache
+ * the last lookup to prevent doing a full prio_tree lookup if we are within
+ * the range of the current 'last_lookup'
+ */
+static inline int loop_check_last_node(struct loop_device *lo, sector_t block)
+{
+	struct prio_tree_node *n = lo->last_lookup;
+
+	if (n)
+		return (block >= n->start) && (block <= n->last);
+
+	return 0;
+}
+
+/*
+ * Find extent mapping this lo device block to the file block on the real
+ * device
+ */
+static struct loop_file_extent *loop_lookup_extent(struct loop_device *lo,
+						   sector_t block)
+{
+	if (!loop_check_last_node(lo, block)) {
+		struct prio_tree_iter iter;
+
+		prio_tree_iter_init(&iter, &lo->prio_root, block, block);
+		lo->last_lookup = prio_tree_next(&iter);
+	}
+
+	if (lo->last_lookup)
+		return node_to_lfe(lo->last_lookup);
+
+	return NULL;
+}
+
+static void loop_handle_extent_hole(struct loop_device *lo, struct bio *bio)
+{
+	/*
+	 * for a read, just zero the data and end the io
+	 */
+	if (bio_data_dir(bio) == READ) {
+		struct bio_vec *bvec;
+		unsigned long flags;
+		int i;
+
+		bio_for_each_segment(bvec, bio, i) {
+			char *dst = bvec_kmap_irq(bvec, &flags);
+
+			memset(dst, 0, bvec->bv_len);
+			bvec_kunmap_irq(dst, &flags);
+		}
+		bio_endio(bio, 0);
+	} else {
+		/*
+		 * let the page cache handling path do this bio, and then
+		 * lookup the mapped blocks after the io has been issued to
+		 * instantiate extents.
+		 */
+		loop_add_bio(lo, bio);
+	}
+}
+
+/*
+ * Alloc a hint bio to tell the loop thread to read file blocks for a given
+ * range
+ */
+#define LOOP_EXTENT_RW_MAGIC	0x19283746
+static void loop_schedule_extent_mapping(struct loop_device *lo,
+					 sector_t disk_block,
+					 unsigned int nr_blocks, int wait)
+{
+	struct bio *bio, stackbio;
+
+	might_sleep_if(wait);
+
+	/*
+	 * it's ok if we occasionally fail. if called with blocking set,
+	 * then use an on-stack bio since that must not fail.
+	 */
+	if (wait) {
+		bio = &stackbio;
+		bio_init(bio);
+	} else
+		bio = bio_alloc(GFP_ATOMIC, 0);
+
+	if (bio) {
+		DECLARE_COMPLETION_ONSTACK(comp);
+
+		bio->bi_rw = LOOP_EXTENT_RW_MAGIC;
+		bio->bi_sector = disk_block;
+		bio->bi_size = nr_blocks;
+
+		loop_add_bio(lo, bio);
+
+		if (wait) {
+			/*
+			 * ok to set here, loop_add_bio() doesn't drop lock
+			 * for this bio (!lo_act_bio(bio))
+			 */
+			bio->bi_private = &comp;
+
+			/*
+			 * never called with wait != 0 where it's not
+			 * allowed to use spin_unlock_irq() which
+			 * unconditionally enables interrupts.
+			 */
+			spin_unlock_irq(&lo->lo_lock);
+			wait_for_completion(&comp);
+			spin_lock_irq(&lo->lo_lock);
+		}
+	}
+}
+
+/*
+ * Change mapping of the bio, so that it points to the real bdev and offset
+ */
+static int loop_redirect_bio(struct loop_device *lo, struct bio *bio)
+{
+	struct loop_file_extent *lfe;
+	sector_t disk_block;
+	sector_t extent_off;
+
+	disk_block = bio->bi_sector >> (lo->blkbits - 9);
+
+	/*
+	 * if no extent exists yet, map this extent first and populate a few
+	 * ahead
+	 */
+	lfe = loop_lookup_extent(lo, disk_block);
+	if (!lfe) {
+		unsigned int nr_blocks = bio->bi_size >> (lo->blkbits - 9);
+
+		loop_schedule_extent_mapping(lo, disk_block, nr_blocks, 1);
+
+		lfe = loop_lookup_extent(lo, disk_block);
+		BUG_ON(!lfe);
+	}
+
+	/*
+	 * handle sparse io
+	 */
+	if (!lfe->file_block) {
+		loop_handle_extent_hole(lo, bio);
+		return 0;
+	}
+
+	/*
+	 * not a hole, redirect
+	 */
+	extent_off = bio->bi_sector - (lfe->disk_block << (lo->blkbits - 9));
+	bio->bi_bdev = lo->fs_bdev;
+	bio->bi_sector = lfe->file_block + extent_off;
+	return 1;
+}
+
+/*
+ * Wait on bio's on our list to complete before sending a barrier bio
+ * to the below device. Called with lo_lock held.
+ */
+static void loop_wait_on_bios(struct loop_device *lo)
+{
+	__lo_throttle(&lo->lo_bio_wait, &lo->lo_lock, !lo->lo_bio);
+}
+
 static int loop_make_request(struct request_queue *q, struct bio *old_bio)
 {
 	struct loop_device *lo = q->queuedata;
@@ -525,15 +779,33 @@ static int loop_make_request(struct request_queue *q, struct bio *old_bio)
 		goto out;
 	if (unlikely(rw == WRITE && (lo->lo_flags & LO_FLAGS_READ_ONLY)))
 		goto out;
+	if (lo->lo_flags & LO_FLAGS_FASTFS) {
+		/*
+		 * If we get a barrier bio, then we just need to wait for
+		 * existing bio's to be complete. This can only happen
+		 * on the 'new' extent mapped loop, since that is the only
+		 * one that supports barriers.
+		 */
+		if (bio_barrier(old_bio))
+			loop_wait_on_bios(lo);
+
+		if (loop_redirect_bio(lo, old_bio))
+			goto out_redir;
+
+		goto out_end;
+	}
 	loop_add_bio(lo, old_bio);
-	wake_up(&lo->lo_event);
 	spin_unlock_irq(&lo->lo_lock);
 	return 0;
 
 out:
-	spin_unlock_irq(&lo->lo_lock);
 	bio_io_error(old_bio);
+out_end:
+	spin_unlock_irq(&lo->lo_lock);
 	return 0;
+out_redir:
+	spin_unlock_irq(&lo->lo_lock);
+	return 1;
 }
 
 /*
@@ -547,20 +819,62 @@ static void loop_unplug(struct request_queue *q)
 	blk_run_address_space(lo->lo_backing_file->f_mapping);
 }
 
+static void loop_unplug_fastfs(struct request_queue *q)
+{
+	struct loop_device *lo = q->queuedata;
+	struct request_queue *rq = bdev_get_queue(lo->fs_bdev);
+
+	clear_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
+
+	if (rq->unplug_fn)
+		rq->unplug_fn(rq);
+}
+
 struct switch_request {
 	struct file *file;
 	struct completion wait;
 };
 
 static void do_loop_switch(struct loop_device *, struct switch_request *);
+static void loop_hole_filled(struct loop_device *, struct bio *);
+static int loop_init_fastfs(struct loop_device *);
+static int loop_read_bmap(struct loop_device *, struct inode *, sector_t,
+			  sector_t, unsigned int);
 
 static inline void loop_handle_bio(struct loop_device *lo, struct bio *bio)
 {
-	if (unlikely(!bio->bi_bdev)) {
+	if (!bio->bi_bdev && bio->bi_rw == LOOP_EXTENT_RW_MAGIC) {
+		struct inode *inode = lo->lo_backing_file->f_mapping->host;
+
+		loop_read_bmap(lo, inode, bio->bi_sector, (sector_t) -1, 8);
+
+		/*
+		 * completion bio is stack allocated (since it's sync)
+		 */
+		if (bio->bi_private)
+			complete(bio->bi_private);
+		else
+			bio_put(bio);
+	} else if (!bio->bi_bdev) {
 		do_loop_switch(lo, bio->bi_private);
 		bio_put(bio);
 	} else {
-		int ret = do_bio_filebacked(lo, bio);
+		int ret;
+
+		ret = do_bio_filebacked(lo, bio);
+
+		/*
+		 * must be filling a hole. kick off writeback of the pages
+		 * so that we know they have a disk mapping. lookup the new
+		 * disk blocks and update our prio tree, splitting the extent
+		 * covering the old hole and adding new extents for the new
+		 * blocks.
+		 */
+		if (lo->lo_flags & LO_FLAGS_FASTFS) {
+			filemap_fdatawrite(lo->lo_backing_file->f_mapping);
+			loop_hole_filled(lo, bio);
+		}
+
 		bio_endio(bio, ret);
 	}
 }
@@ -610,7 +924,7 @@ static int loop_thread(void *data)
 static int loop_switch(struct loop_device *lo, struct file *file)
 {
 	struct switch_request w;
-	struct bio *bio = bio_alloc(GFP_KERNEL, 1);
+	struct bio *bio = bio_alloc(GFP_KERNEL, 0);
 	if (!bio)
 		return -ENOMEM;
 	init_completion(&w.wait);
@@ -637,6 +951,21 @@ static void do_loop_switch(struct loop_device *lo, struct switch_request *p)
 		mapping->host->i_bdev->bd_block_size : PAGE_SIZE;
 	lo->old_gfp_mask = mapping_gfp_mask(mapping);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
+
+	if (lo->lo_flags & LO_FLAGS_FASTFS) {
+		unsigned long flags;
+
+		/*
+		 * teardown existing extent mappings and init for a new file
+		 */
+		lo->lo_flags &= ~LO_FLAGS_FASTFS;
+
+		spin_lock_irqsave(&lo->lo_lock, flags);
+		loop_drop_extents(lo);
+		loop_init_fastfs(lo);
+		spin_unlock_irqrestore(&lo->lo_lock, flags);
+	}
+
 	complete(&p->wait);
 }
 
@@ -700,6 +1029,321 @@ static int loop_change_fd(struct loop_device *lo, struct file *lo_file,
 	return error;
 }
 
+static struct loop_file_extent *
+loop_merge_last_node(struct loop_device *lo, sector_t disk_block,
+		     sector_t file_block, unsigned int nr_blocks)
+{
+	unsigned int file_blocks, lfe_file_blocks;
+	struct loop_file_extent *lfe;
+	struct prio_tree_node *node;
+
+	node = lo->last_insert;
+	if (unlikely(!node))
+		return NULL;
+
+	lfe = node_to_lfe(node);
+	file_blocks = nr_blocks << (lo->blkbits - 9);
+	lfe_file_blocks = lfe->nr_blocks << (lo->blkbits - 9);
+
+	/*
+	 * See if we can add to front or back of this node
+	 */
+	if ((lfe->disk_block + lfe->nr_blocks == disk_block) &&
+	    (lfe->file_block + lfe_file_blocks == file_block)) {
+		/*
+		 * back merge
+		 */
+		return lfe;
+	} else if ((disk_block + nr_blocks == lfe->disk_block) &&
+		   (file_block + file_blocks == lfe->file_block)) {
+		/*
+		 * front merge
+		 */
+		lfe->disk_block = disk_block;
+		return lfe;
+	}
+
+	return NULL;
+}
+
+static int __loop_add_extent(struct loop_device *lo,
+			     struct loop_file_extent *lfe)
+{
+	struct prio_tree_node *ret;
+
+	INIT_PRIO_TREE_NODE(&lfe->prio_node);
+	lfe->prio_node.start = lfe->disk_block;
+	lfe->prio_node.last = lfe->disk_block + lfe->nr_blocks - 1;
+
+	ret = prio_tree_insert(&lo->prio_root, &lfe->prio_node);
+	if (ret == &lfe->prio_node) {
+		if (lfe->file_block)
+			lo->last_insert = &lfe->prio_node;
+		return 0;
+	}
+
+	return -EEXIST;
+}
+
+/*
+ * Add an extent starting at 'disk_block' loop block and 'file_block'
+ * fs block, spanning 'nr_blocks'. file_block may be 0, in which case
+ * this extent describes a hole in the file.
+ */
+static int loop_add_extent(struct loop_device *lo, sector_t disk_block,
+			   sector_t file_block, unsigned int nr_blocks)
+{
+	struct loop_file_extent *lfe;
+	int ret;
+
+	file_block = file_block << (lo->blkbits - 9);
+	spin_lock_irq(&lo->lo_lock);
+
+	/*
+	 * See if we can merge with the last inserted node
+	 */
+	lfe = loop_merge_last_node(lo, disk_block, file_block, nr_blocks);
+	if (lfe) {
+		lfe->nr_blocks += nr_blocks;
+		loop_prio_remove_node(lo, lfe);
+	} else {
+		/*
+		 * no merge, allocate and add a new node
+		 */
+		lfe = kzalloc(sizeof(*lfe), GFP_ATOMIC);
+		if (!lfe) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		lfe->disk_block = disk_block;
+		lfe->file_block = file_block;
+		lfe->nr_blocks = nr_blocks;
+	}
+
+	ret = __loop_add_extent(lo, lfe);
+	if (ret) {
+		/*
+		 * Most likely we raced with someone else in setting up this
+		 * extent, so just drop this one
+		 */
+		kfree(lfe);
+	}
+
+out:
+	spin_unlock_irq(&lo->lo_lock);
+	return ret;
+}
+
+/*
+ * See if adding this bvec would cause us to spill into a new extent. If so,
+ * disallow the add to start a new bio. This ensures that the bio we receive
+ * in loop_make_request() never spans two extents or more.
+ */
+static int loop_merge_bvec(struct request_queue *q, struct bio *bio,
+			   struct bio_vec *bvec)
+{
+	struct loop_device *lo = q->queuedata;
+	struct loop_file_extent *lfe;
+	unsigned int nr_blocks, ret;
+	unsigned long flags;
+	sector_t disk_block;
+
+	disk_block = bio->bi_sector >> (lo->blkbits - 9);
+	nr_blocks = (bio->bi_size + bvec->bv_len) >> lo->blkbits;
+	ret = bvec->bv_len;
+
+	spin_lock_irqsave(&lo->lo_lock, flags);
+	lfe = loop_lookup_extent(lo, disk_block);
+	if (lfe) {
+		/*
+		 * have extent, disallow if outside that extent
+		 */
+		if (disk_block + nr_blocks > lfe->disk_block + lfe->nr_blocks)
+			ret = 0;
+	} else {
+		/*
+		 * no extent yet, disallow if we already added to the bio and
+		 * schedule read of blocks for this extent
+		 */
+		loop_schedule_extent_mapping(lo, disk_block, nr_blocks, 0);
+		if (bio->bi_size)
+			ret = 0;
+	}
+
+	spin_unlock_irqrestore(&lo->lo_lock, flags);
+	return ret;
+}
+
+/*
+ * Read and populate the prio tree starting from 'block' disk block
+ * and to 'end', unless we hit 'max_ext' first.
+ */
+static int loop_read_bmap(struct loop_device *lo, struct inode *inode,
+			  sector_t block, sector_t end, unsigned int max_ext)
+{
+	sector_t expected_block, disk_start, file_start;
+	unsigned int extent_blocks, nr_extents;
+
+	if (end == (sector_t) -1) {
+		struct inode *inode = lo->lo_backing_file->f_mapping->host;
+
+		end = i_size_read(inode) >> inode->i_blkbits;
+	}
+
+	nr_extents = 0;
+	expected_block = block + 1;
+	file_start = disk_start = -1;
+	extent_blocks = 0;
+
+	while (block <= end && nr_extents < max_ext) {
+		sector_t file_block = bmap(inode, block);
+
+		if (disk_start == -1) {
+start_extent:
+			disk_start = block;
+			file_start = file_block;
+			extent_blocks = 1;
+		} else if (expected_block == file_block)
+			extent_blocks++;
+		else {
+			if (loop_add_extent(lo, disk_start, file_start, extent_blocks)) {
+				disk_start = -1;
+				break;
+			}
+			nr_extents++;
+			goto start_extent;
+		}
+
+		if (file_block)
+			expected_block = file_block + 1;
+		else
+			expected_block = 0;
+
+		block++;
+	}
+
+	if (disk_start != -1) {
+		if (!loop_add_extent(lo, disk_start, file_start, extent_blocks))
+			nr_extents++;
+	}
+
+	return nr_extents;
+}
+
+/*
+ * Initialize the members pertaining to extent mapping. We will populate
+ * the tree lazily on demand, as a full scan of a big file can take some
+ * time.
+ */
+static int loop_init_fastfs(struct loop_device *lo)
+{
+	struct file *file = lo->lo_backing_file;
+	struct inode *inode = file->f_mapping->host;
+	struct request_queue *fs_q;
+
+	if (!S_ISREG(inode->i_mode))
+		return -EINVAL;
+
+	/*
+	 * Need a working bmap. TODO: use the same optimization that
+	 * direct-io.c does for get_block() mapping more than one block
+	 * at the time.
+	 */
+	if (inode->i_mapping->a_ops->bmap == NULL)
+		return -EINVAL;
+
+	INIT_PRIO_TREE_ROOT(&lo->prio_root);
+	lo->blkbits = inode->i_blkbits;
+	lo->fs_bdev = file->f_mapping->host->i_sb->s_bdev;
+	lo->lo_flags |= LO_FLAGS_FASTFS;
+	lo->lo_queue->unplug_fn = loop_unplug_fastfs;
+
+	blk_queue_merge_bvec(lo->lo_queue, loop_merge_bvec);
+	blk_queue_ordered(lo->lo_queue, QUEUE_ORDERED_DRAIN, NULL);
+
+	fs_q = bdev_get_queue(lo->fs_bdev);
+	blk_queue_stack_limits(lo->lo_queue, fs_q);
+
+	printk(KERN_INFO "loop%d: fast redirect\n", lo->lo_number);
+	return 0;
+}
+
+/*
+ * We filled the hole at the location specified by bio. Lookup the extent
+ * covering this hole, and either split it into two or shorten it depending
+ * on what part the bio covers. After that we need to lookup the new blocks
+ * and add extents for those.
+ */
+static void loop_hole_filled(struct loop_device *lo, struct bio *bio)
+{
+	struct inode *inode = lo->lo_backing_file->f_mapping->host;
+	struct loop_file_extent *lfe, *lfe_e;
+	unsigned int nr_blocks;
+	sector_t disk_block;
+
+	disk_block = bio->bi_sector >> (lo->blkbits - 9);
+	lfe_e = NULL;
+
+	spin_lock_irq(&lo->lo_lock);
+	lfe = loop_lookup_extent(lo, disk_block);
+	BUG_ON(!lfe);
+
+	/*
+	 * Remove extent from tree and trim or split it
+	 */
+	loop_prio_remove_node(lo, lfe);
+	spin_unlock_irq(&lo->lo_lock);
+
+	nr_blocks = bio->bi_size >> lo->blkbits;
+
+	/*
+	 * Either we need to trim at the front, at the end, or split
+	 * it into two if the write is in the middle
+	 */
+	if (disk_block == lfe->disk_block) {
+		/*
+		 * Trim front
+		 */
+		lfe->disk_block += nr_blocks;
+		lfe->nr_blocks -= nr_blocks;
+	} else if (disk_block + nr_blocks == lfe->disk_block + lfe->nr_blocks) {
+		/*
+		 * Trim end
+		 */
+		lfe->nr_blocks -= nr_blocks;
+	} else {
+		unsigned int total_blocks = lfe->nr_blocks;
+
+		/*
+		 * Split extent in two
+		 */
+		lfe->nr_blocks = disk_block - lfe->disk_block;
+
+		lfe_e = kzalloc(sizeof(*lfe_e), GFP_NOIO | __GFP_NOFAIL);
+		lfe_e->disk_block = disk_block + nr_blocks;
+		lfe_e->nr_blocks = total_blocks - nr_blocks - lfe->nr_blocks;
+	}
+
+	if (!lfe->nr_blocks) {
+		kfree(lfe);
+		lfe = NULL;
+	}
+
+	spin_lock_irq(&lo->lo_lock);
+
+	/*
+	 * Re-add hole extent(s)
+	 */
+	if (lfe)
+		__loop_add_extent(lo, lfe);
+	if (lfe_e)
+		__loop_add_extent(lo, lfe_e);
+
+	spin_unlock_irq(&lo->lo_lock);
+
+	loop_read_bmap(lo, inode, disk_block, disk_block + nr_blocks - 1, -1);
+}
+
 static inline int is_loop_device(struct file *file)
 {
 	struct inode *i = file->f_mapping->host;
@@ -748,6 +1392,7 @@ static int loop_set_fd(struct loop_device *lo, struct file *lo_file,
 
 	mapping = file->f_mapping;
 	inode = mapping->host;
+	lo->lo_flags = 0;
 
 	if (!(file->f_mode & FMODE_WRITE))
 		lo_flags |= LO_FLAGS_READ_ONLY;
@@ -811,6 +1456,12 @@ static int loop_set_fd(struct loop_device *lo, struct file *lo_file,
 
 	set_blocksize(bdev, lo_blocksize);
 
+	/*
+	 * This needs to be done after setup with another ioctl,
+	 * not automatically like this.
+	 */
+	loop_init_fastfs(lo);
+
 	lo->lo_thread = kthread_create(loop_thread, lo, "loop%d",
 						lo->lo_number);
 	if (IS_ERR(lo->lo_thread)) {
@@ -896,6 +1547,9 @@ static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
 
 	kthread_stop(lo->lo_thread);
 
+	if (lo->lo_flags & LO_FLAGS_FASTFS)
+		loop_drop_extents(lo);
+
 	lo->lo_backing_file = NULL;
 
 	loop_release_xfer(lo);
@@ -943,6 +1597,9 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	if (info->lo_encrypt_type) {
 		unsigned int type = info->lo_encrypt_type;
 
+		if (lo->lo_flags & LO_FLAGS_FASTFS)
+			return -EINVAL;
+
 		if (type >= MAX_LO_CRYPT)
 			return -EINVAL;
 		xfer = xfer_funcs[type];
@@ -1153,6 +1810,9 @@ static int lo_ioctl(struct inode * inode, struct file * file,
 	case LOOP_GET_STATUS64:
 		err = loop_get_status64(lo, (struct loop_info64 __user *) arg);
 		break;
+	case LOOP_SET_FASTFS:
+		err = loop_init_fastfs(lo);
+		break;
 	default:
 		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
 	}
@@ -1412,6 +2072,7 @@ static struct loop_device *loop_alloc(int i)
 	lo->lo_number		= i;
 	lo->lo_thread		= NULL;
 	init_waitqueue_head(&lo->lo_event);
+	init_waitqueue_head(&lo->lo_bio_wait);
 	spin_lock_init(&lo->lo_lock);
 	disk->major		= LOOP_MAJOR;
 	disk->first_minor	= i;
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 26a0a10..e3c6ce0 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -18,6 +18,7 @@
 #include <linux/blkdev.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
+#include <linux/prio_tree.h>
 
 /* Possible states of device */
 enum {
@@ -50,6 +51,7 @@ struct loop_device {
 
 	struct file *	lo_backing_file;
 	struct block_device *lo_device;
+	struct block_device *fs_bdev;
 	unsigned	lo_blocksize;
 	void		*key_data; 
 
@@ -58,14 +60,21 @@ struct loop_device {
 	spinlock_t		lo_lock;
 	struct bio 		*lo_bio;
 	struct bio		*lo_biotail;
+	unsigned int		lo_bio_cnt;
 	int			lo_state;
 	struct mutex		lo_ctl_mutex;
 	struct task_struct	*lo_thread;
 	wait_queue_head_t	lo_event;
+	wait_queue_head_t	lo_bio_wait;
 
 	struct request_queue	*lo_queue;
 	struct gendisk		*lo_disk;
 	struct list_head	lo_list;
+
+	struct prio_tree_root	prio_root;
+	struct prio_tree_node	*last_insert;
+	struct prio_tree_node	*last_lookup;
+	unsigned int		blkbits;
 };
 
 #endif /* __KERNEL__ */
@@ -76,6 +85,7 @@ struct loop_device {
 enum {
 	LO_FLAGS_READ_ONLY	= 1,
 	LO_FLAGS_USE_AOPS	= 2,
+	LO_FLAGS_FASTFS		= 4,
 };
 
 #include <asm/posix_types.h>	/* for __kernel_old_dev_t */
@@ -159,5 +169,6 @@ int loop_unregister_transfer(int number);
 #define LOOP_SET_STATUS64	0x4C04
 #define LOOP_GET_STATUS64	0x4C05
 #define LOOP_CHANGE_FD		0x4C06
+#define LOOP_SET_FASTFS		0x4C07
 
 #endif
diff --git a/lib/prio_tree.c b/lib/prio_tree.c
index ccfd850..0f550f7 100644
--- a/lib/prio_tree.c
+++ b/lib/prio_tree.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/prio_tree.h>
+#include <linux/module.h>
 
 /*
  * A clever mix of heap and radix trees forms a radix priority search tree (PST)
@@ -255,6 +256,7 @@ struct prio_tree_node *prio_tree_insert(struct prio_tree_root *root,
 	BUG();
 	return NULL;
 }
+EXPORT_SYMBOL(prio_tree_insert);
 
 /*
  * Remove a prio_tree_node @node from a radix priority search tree @root. The
@@ -304,6 +306,7 @@ void prio_tree_remove(struct prio_tree_root *root, struct prio_tree_node *node)
 	while (cur != node)
 		cur = prio_tree_replace(root, cur->parent, cur);
 }
+EXPORT_SYMBOL(prio_tree_remove);
 
 /*
  * Following functions help to enumerate all prio_tree_nodes in the tree that
@@ -482,3 +485,4 @@ repeat:
 
 	goto repeat;
 }
+EXPORT_SYMBOL(prio_tree_next);

-- 
Jens Axboe

