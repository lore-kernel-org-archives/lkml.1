Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbZHCLDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbZHCLDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 07:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZHCLDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 07:03:48 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:43666 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbZHCLDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 07:03:47 -0400
Date: Mon, 3 Aug 2009 13:03:42 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [patch] Make block2mtd work with devices >=4GB
Message-ID: <20090803110342.GA7489@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block2mtd uses PAGE_MASK to mask the size and offset values, but
this a 32bit mask and so devices >=4GB wrap around to <4GB.
This adds a define MTD_PAGE_MASK, which casts PAGE_SIZE to loff_t
before inverting it.

Without the patch:

|# echo /dev/sdb3,$((1024 * 1024)) > /sys/module/block2mtd/parameters/block2mtd
|# cat /proc/mtd
|dev:    size   erasesize  name
|mtd0: c0200000 00100000 "block2mtd: /dev/sdb2"
|mtd1: 08e00000 00100000 "block2mtd: /dev/sdb3"

With this patch:

|# echo /dev/sdb3,$((1024 * 1024)) > /sys/module/block2mtd/parameters/block2mtd
|# cat /proc/mtd
|dev:    size   erasesize  name
|mtd0: c0200000 00100000 "block2mtd: /dev/sdb2"
|mtd1: 308e00000 00100000 "block2mtd: /dev/sdb3"

Creating an ubi volume works (but ubinfo seems to use 32bit math to
calculate the size in bytes and MiB):
|# ubinfo /dev/ubi1
|ubi1
|Volumes count:                           1
|Logical eraseblock size:                 1048448 bytes, 1023.9 KiB
|Total amount of logical eraseblocks:     12430 (147306752 bytes, 140.5 MiB)
|Amount of available logical eraseblocks: 0 (0 bytes)
|Maximum count of volumes                 128
|Count of bad physical eraseblocks:       0
|Count of reserved physical eraseblocks:  0
|Current maximum erase counter value:     2
|Minimum input/output unit size:          1 byte
|Character device major/minor:            250:0
|Present volumes:                         0
|# ubinfo /dev/ubi1_0
|Volume ID:   0 (on ubi1)
|Type:        dynamic
|Alignment:   1
|Size:        12426 LEBs (143112960 bytes, 136.5 MiB)
|State:       OK
|Name:        home
|Character device major/minor: 250:1

mkfs.ubifs also claims to succeed, but the ubifs cannot be mounted:
[10423.520009] UBIFS error (pid 7239): ubifs_scanned_corruption: corruption at LEB 1:512
[10423.520009] 00000000: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 ................................
[...]
[10423.520009] 00001fe0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 ................................
[10423.520009] UBIFS error (pid 7239): ubifs_scan: LEB 1 scanning failed
[10423.520009] UBIFS error (pid 7239): ubifs_recover_master_node: failed to recover master node


Signed-off-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>

Index: linux-2.6.31-rc5/drivers/mtd/devices/block2mtd.c
===================================================================
--- linux-2.6.31-rc5.orig/drivers/mtd/devices/block2mtd.c	2009-08-03 16:33:55.846298216 +0900
+++ linux-2.6.31-rc5/drivers/mtd/devices/block2mtd.c	2009-08-03 16:34:29.986318468 +0900
@@ -24,6 +24,7 @@
 #define ERROR(fmt, args...) printk(KERN_ERR "block2mtd: " fmt "\n" , ## args)
 #define INFO(fmt, args...) printk(KERN_INFO "block2mtd: " fmt "\n" , ## args)
 
+#define MTD_PAGE_MASK (~((loff_t)(PAGE_SIZE-1)))
 
 /* Info for the block device */
 struct block2mtd_dev {
@@ -149,7 +150,7 @@
 	struct page *page;
 	struct address_space *mapping = dev->blkdev->bd_inode->i_mapping;
 	int index = to >> PAGE_SHIFT;	// page index
-	int offset = to & ~PAGE_MASK;	// page offset
+	int offset = to & ~MTD_PAGE_MASK;	// page offset
 	int cpylen;
 
 	if (retlen)
@@ -286,7 +287,7 @@
 	sprintf(name, "block2mtd: %s", devname);
 	dev->mtd.name = name;
 
-	dev->mtd.size = dev->blkdev->bd_inode->i_size & PAGE_MASK;
+	dev->mtd.size = dev->blkdev->bd_inode->i_size & MTD_PAGE_MASK;
 	dev->mtd.erasesize = erase_size;
 	dev->mtd.writesize = 1;
 	dev->mtd.type = MTD_RAM;

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
