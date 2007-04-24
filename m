Return-Path: <linux-kernel-owner+w=401wt.eu-S1423186AbXDXW1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423186AbXDXW1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423170AbXDXW1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:27:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56818 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423182AbXDXWXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:23:08 -0400
Message-Id: <20070424222307.468624462@sgi.com>
References: <20070424222105.883597089@sgi.com>
User-Agent: quilt/0.45-1
Date: Tue, 24 Apr 2007 15:21:18 -0700
From: clameter@sgi.com
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [13/17] set_blocksize: Allow to set a larger block size than PAGE_SIZE
Content-Disposition: inline; filename=var_pc_buffer_head
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

set_blocksize is changed to allow to specify a blocksize larger than a
page. If that occurs then we switch the device to use compound pages.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/block_dev.c |   22 +++++++++++++++-------
 fs/buffer.c    |    2 +-
 fs/inode.c     |    5 +++++
 3 files changed, 21 insertions(+), 8 deletions(-)

Index: linux-2.6.21-rc7/fs/block_dev.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/block_dev.c	2007-04-23 23:13:16.000000000 -0700
+++ linux-2.6.21-rc7/fs/block_dev.c	2007-04-23 23:13:19.000000000 -0700
@@ -60,12 +60,12 @@ static void kill_bdev(struct block_devic
 {
 	invalidate_bdev(bdev, 1);
 	truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
-}	
+}
 
 int set_blocksize(struct block_device *bdev, int size)
 {
-	/* Size must be a power of two, and between 512 and PAGE_SIZE */
-	if (size > PAGE_SIZE || size < 512 || (size & (size-1)))
+	/* Size must be a power of two, and greater than 512 */
+	if (size < 512 || (size & (size-1)))
 		return -EINVAL;
 
 	/* Size cannot be smaller than the size supported by the device */
@@ -74,10 +74,16 @@ int set_blocksize(struct block_device *b
 
 	/* Don't change the size if it is same as current */
 	if (bdev->bd_block_size != size) {
+		int bits = blksize_bits(size);
+		struct address_space *mapping =
+			bdev->bd_inode->i_mapping;
+
 		sync_blockdev(bdev);
-		bdev->bd_block_size = size;
-		bdev->bd_inode->i_blkbits = blksize_bits(size);
 		kill_bdev(bdev);
+		bdev->bd_block_size = size;
+		bdev->bd_inode->i_blkbits = bits;
+		set_mapping_order(mapping,
+			bits < PAGE_SHIFT ? 0 : bits - PAGE_SHIFT);
 	}
 	return 0;
 }
@@ -88,8 +94,10 @@ int sb_set_blocksize(struct super_block 
 {
 	if (set_blocksize(sb->s_bdev, size))
 		return 0;
-	/* If we get here, we know size is power of two
-	 * and it's value is between 512 and PAGE_SIZE */
+	/*
+	 * If we get here, we know size is power of two
+	 * and it's value is larger than 512
+	 */
 	sb->s_blocksize = size;
 	sb->s_blocksize_bits = blksize_bits(size);
 	return sb->s_blocksize;
Index: linux-2.6.21-rc7/fs/buffer.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/buffer.c	2007-04-23 23:13:16.000000000 -0700
+++ linux-2.6.21-rc7/fs/buffer.c	2007-04-23 23:13:19.000000000 -0700
@@ -1084,7 +1084,7 @@ __getblk_slow(struct block_device *bdev,
 {
 	/* Size must be multiple of hard sectorsize */
 	if (unlikely(size & (bdev_hardsect_size(bdev)-1) ||
-			(size < 512 || size > PAGE_SIZE))) {
+			size < 512)) {
 		printk(KERN_ERR "getblk(): invalid block size %d requested\n",
 					size);
 		printk(KERN_ERR "hardsect size: %d\n",
Index: linux-2.6.21-rc7/fs/inode.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/inode.c	2007-04-23 23:14:36.000000000 -0700
+++ linux-2.6.21-rc7/fs/inode.c	2007-04-23 23:17:26.000000000 -0700
@@ -146,6 +146,11 @@ static struct inode *alloc_inode(struct 
  		mapping->host = inode;
 		mapping->flags = 0;
 		mapping_set_gfp_mask(mapping, GFP_HIGHUSER);
+		if (inode->i_blkbits > PAGE_SHIFT)
+			set_mapping_order(mapping,
+				inode->i_blkbits - PAGE_SHIFT);
+		else
+			set_mapping_order(mapping, 0);
 		mapping->assoc_mapping = NULL;
 		mapping->backing_dev_info = &default_backing_dev_info;
 

--
