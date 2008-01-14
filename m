Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYANRyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYANRyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 12:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbYANRyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 12:54:07 -0500
Received: from brick.kernel.dk ([87.55.233.238]:17752 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbYANRyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 12:54:04 -0500
Date: Mon, 14 Jan 2008 18:54:00 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080114175359.GS6258@kernel.dk>
References: <20080109085231.GE6650@kernel.dk> <20080114121021.0d392102@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114121021.0d392102@think.oraclecorp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14 2008, Chris Mason wrote:
> Hello everyone,
> 
> Here is a modified version of Jens' patch.  The basic idea is to push
> the mapping maintenance out of loop and down into the filesystem (ext2
> in this case).
> 
> Two new address_space operations are added, one to map
> extents and the other to provide call backs into the FS as io is
> completed.
> 
> Still TODO for this patch:
> 
> * Add exclusion between filling holes and readers.  This is partly
> implemented, when a hole is filled by the FS, the extent is flagged as
> having a hole.  The idea is to check this flag before trying to read
> the blocks and just send back all zeros.
> 
> The flag would be cleared when the blocks filling the hole have been
> written.
> 
> * Exclude page cache readers and writers
> 
> * Add a way for the FS to request a commit before telling the higher
> layers the IO is complete.  This way we can make sure metadata related
> to holes is on disk before claiming the IO is really done.  COW based
> filesystems will also needed it.
> 
> * Change loop to use fast mapping only when the new address_space op is
> provided (whoops, forgot about this until just now)
> 
> * A few other bits for COW, not really relevant until there
> is...something COW using it.

Looks pretty good. Essentially the loop side is 100% the same, it just
offloads the extent ownership to the fs (where it belongs). So I like
it. Attaching a small cleanup/fixup patch for loop, don't think it needs
further explanations.

One suggestion - free_extent_map(), I would call that put_extent_map()
instead.

diff -u b/drivers/block/loop.c b/drivers/block/loop.c
--- b/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -677,13 +677,14 @@
 	if (IS_ERR(lfe))
 		return -EIO;
 
-	while(!lfe) {
+	while (!lfe) {
 		loop_schedule_extent_mapping(lo, bio->bi_sector,
 					     bio->bi_size, 1);
 		lfe = loop_lookup_extent(lo, start, GFP_ATOMIC);
 		if (IS_ERR(lfe))
 			return -EIO;
 	}
+
 	/*
 	 * handle sparse io
 	 */
@@ -802,13 +803,13 @@
 {
 	struct bio *orig_bio = bio->bi_private;
 	struct inode *inode = bio->bi_bdev->bd_inode;
+	struct address_space *mapping = inode->i_mapping;
 	u64 start = orig_bio->bi_sector << 9;
 	u64 len = bio->bi_size;
 
-	if (inode->i_mapping->a_ops->extent_io_complete) {
-		inode->i_mapping->a_ops->extent_io_complete(inode->i_mapping,
-							    start, len);
-	}
+	if (mapping->a_ops->extent_io_complete)
+		mapping->a_ops->extent_io_complete(mapping, start, len);
+
 	bio_put(bio);
 	bio_endio(orig_bio, err);
 }
@@ -829,6 +830,7 @@
 		err = -ENOMEM;
 		goto out;
 	}
+
 	/*
 	 * change the sector so we can find the correct file offset in our
 	 * endio
@@ -847,7 +849,6 @@
 		goto out;;
 	}
 
-
 	disk_block = em->block_start;
 	extent_off = start - em->start;
 	new_bio->bi_sector = (disk_block + extent_off) >> 9;
@@ -924,11 +925,8 @@
 		spin_unlock_irq(&lo->lo_lock);
 
 		BUG_ON(!bio);
-		if (lo_act_bio(bio))
-			bio_act = 1;
-		else
-			bio_act = 0;
 
+		bio_act = lo_act_bio(bio);
 		loop_handle_bio(lo, bio);
 
 		spin_lock_irq(&lo->lo_lock);
@@ -1103,11 +1101,9 @@
 		return -EINVAL;
 
 	/*
-	 * Need a working bmap. TODO: use the same optimization that
-	 * direct-io.c does for get_block() mapping more than one block
-	 * at the time.
+	 * Need a working extent_map
 	 */
-	if (inode->i_mapping->a_ops->bmap == NULL)
+	if (inode->i_mapping->a_ops->map_extent == NULL)
 		return -EINVAL;
 	/*
 	 * invalidate all page cache belonging to this file, it could become
diff -u b/include/linux/loop.h b/include/linux/loop.h
--- b/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -18,7 +18,6 @@
 #include <linux/blkdev.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
-#include <linux/rbtree.h>
 
 /* Possible states of device */
 enum {
@@ -72,9 +71,6 @@
 	struct gendisk		*lo_disk;
 	struct list_head	lo_list;
 
-	struct prio_tree_root	prio_root;
-	struct prio_tree_node	*last_insert;
-	struct prio_tree_node	*last_lookup;
 	unsigned int		blkbits;
 };
 

-- 
Jens Axboe

