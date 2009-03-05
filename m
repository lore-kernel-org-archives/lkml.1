Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbZCEKpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbZCEKpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZCEKp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:45:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:42169 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbZCEKp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:45:26 -0500
Date: Thu, 5 Mar 2009 11:45:23 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Cc: ext-adrian.hunter@nokia.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error testing ext3 on brd ramdisk
Message-ID: <20090305104523.GC17815@wotan.suse.de>
References: <491D7C4C.3090907@nokia.com> <49A82C2E.4030903@dti2.net> <20090228055809.GC28496@wotan.suse.de> <49AC1A7A.1070108@dti2.net> <20090305065529.GB11916@wotan.suse.de> <49AF9932.2040301@dti2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AF9932.2040301@dti2.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 10:19:46AM +0100, Jorge Boncompte [DTI2] wrote:
> -----------
> umount /etc (/etc is what is mounted from /dev/ram0)
> dd if=/dev/zero of=/dev/ram0 bs=1k count=1000
> mount /dev/ram0 /etc -t minix -o rw
> -----------
> ...succeds and mounts a corrupted filesystem with the old content. Doing 
> the same with the all ramdisk driver fails on mount with "no filesystem 
> found".
> 
> If I do...
> -----------
> umount /etc (/etc is what is mounted from /dev/ram0)
> echo 3 > /proc/sys/vm/drop_caches
> dd if=/dev/zero of=/dev/ram0 bs=1k count=1000
> mount /dev/ram0 /etc -t minix -o rw
> ----------
> ... then the mount fails with no filesystem found as it should.

I can't reproduce this. Is the filesystem definitely being
unmounted and nothing else is holding the bdev inode open?

I can only imagine something like this happening if the fs
is still mounted, in which case it will write back some
superblock over the zeroed bdev, possibly allowing it to mount
again, or if the zeroed writes somehow get lost, which would
seem like a problem with the buffer cache.

Actually, the 2nd scenario is more likely, because you wouldn't
see it with the old rd driver because it never allows the buffer
cache to be freed.

Are you getting any errors in your dmesg or anything like that?

What happens when you run the following patch? Can you run the
test case then when you reproduce the problem, see if anything is
in dmesg?

Thanks,
Nick

---
 fs/block_dev.c |    3 +++
 fs/buffer.c    |    4 +++-
 mm/filemap.c   |   29 ++++++++++++-----------------
 3 files changed, 18 insertions(+), 18 deletions(-)

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -394,18 +394,14 @@ int filemap_write_and_wait(struct addres
 	int err = 0;
 
 	if (mapping->nrpages) {
+		int err2;
+
 		err = filemap_fdatawrite(mapping);
-		/*
-		 * Even if the above returned error, the pages may be
-		 * written partially (e.g. -ENOSPC), so we wait for it.
-		 * But the -EIO is special case, it may indicate the worst
-		 * thing (e.g. bug) happened, so we avoid waiting for it.
-		 */
-		if (err != -EIO) {
-			int err2 = filemap_fdatawait(mapping);
-			if (!err)
-				err = err2;
-		}
+		WARN_ON(err);
+		err2 = filemap_fdatawait(mapping);
+		WARN_ON(err2);
+		if (!err)
+			err = err2;
 	}
 	return err;
 }
@@ -428,16 +424,15 @@ int filemap_write_and_wait_range(struct
 	int err = 0;
 
 	if (mapping->nrpages) {
+		int err2;
+
 		err = __filemap_fdatawrite_range(mapping, lstart, lend,
 						 WB_SYNC_ALL);
-		/* See comment of filemap_write_and_wait() */
-		if (err != -EIO) {
-			int err2 = wait_on_page_writeback_range(mapping,
+		err2 = wait_on_page_writeback_range(mapping,
 						lstart >> PAGE_CACHE_SHIFT,
 						lend >> PAGE_CACHE_SHIFT);
-			if (!err)
-				err = err2;
-		}
+		if (!err)
+			err = err2;
 	}
 	return err;
 }
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c
+++ linux-2.6/fs/block_dev.c
@@ -66,6 +66,7 @@ static void kill_bdev(struct block_devic
 		return;
 	invalidate_bh_lrus();
 	truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
+	printk("truncated bdev\n");
 }	
 
 int set_blocksize(struct block_device *bdev, int size)
@@ -80,6 +81,7 @@ int set_blocksize(struct block_device *b
 
 	/* Don't change the size if it is same as current */
 	if (bdev->bd_block_size != size) {
+		printk("killing bdev\n");
 		sync_blockdev(bdev);
 		bdev->bd_block_size = size;
 		bdev->bd_inode->i_blkbits = blksize_bits(size);
@@ -1177,6 +1179,7 @@ static int __blkdev_put(struct block_dev
 		bdev->bd_part_count--;
 
 	if (!--bdev->bd_openers) {
+		printk("killing bdev\n");
 		sync_blockdev(bdev);
 		kill_bdev(bdev);
 	}
Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -173,8 +173,10 @@ int sync_blockdev(struct block_device *b
 {
 	int ret = 0;
 
-	if (bdev)
+	if (bdev) {
+		printk("syncing bdev\n");
 		ret = filemap_write_and_wait(bdev->bd_inode->i_mapping);
+	}
 	return ret;
 }
 EXPORT_SYMBOL(sync_blockdev);
