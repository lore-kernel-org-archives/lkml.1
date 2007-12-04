Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbXLDLVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbXLDLVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 06:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbXLDLVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 06:21:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbXLDLVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 06:21:03 -0500
Date: Tue, 4 Dec 2007 12:21:00 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>
Subject: [patch] rd: support XIP
Message-ID: <20071204112100.GA20420@wotan.suse.de>
References: <20071204042628.GA26636@wotan.suse.de> <200712041054.51599.borntraeger@de.ibm.com> <20071204101009.GB9618@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204101009.GB9618@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 11:10:09AM +0100, Nick Piggin wrote:
> > 
> > This is just an idea, I dont know if it is worth the trouble, but have you
> > though about implementing direct_access for brd? That would allow 
> > execute-in-place (xip) on brd eliminating the extra copy.
> 
> Actually that's a pretty good idea. It would allow xip to be tested
> without special hardware as well...
> 
> I'll see what the patch looks like. Thanks

This seems to work, although I needed another patch for ext2 too.
Never run XIP before, but I'm able to execute files out of the -oxip
mount, so I'm guessing it's working ;)

---

Support direct_access XIP method with brd.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/drivers/block/Kconfig
===================================================================
--- linux-2.6.orig/drivers/block/Kconfig
+++ linux-2.6/drivers/block/Kconfig
@@ -346,6 +346,16 @@ config BLK_DEV_RAM_SIZE
 	  The default value is 4096 kilobytes. Only change this if you know
 	  what you are doing.
 
+config BLK_DEV_XIP
+	bool "Support XIP filesystems on RAM block device"
+	depends on BLK_DEV_RAM
+	default n
+	help
+	  Support XIP filesystems (such as ext2 with XIP support on) on
+	  top of block ram device. This will slightly enlarge the kernel, and
+	  will prevent RAM block device backing store memory from being
+	  allocated from highmem (only a problem for highmem systems).
+
 config CDROM_PKTCDVD
 	tristate "Packet writing on CD/DVD media"
 	depends on !UML
Index: linux-2.6/drivers/block/brd.c
===================================================================
--- linux-2.6.orig/drivers/block/brd.c
+++ linux-2.6/drivers/block/brd.c
@@ -89,6 +89,7 @@ static struct page *brd_insert_page(stru
 {
 	pgoff_t idx;
 	struct page *page;
+	gfp_t gfp_flags;
 
 	page = brd_lookup_page(brd, sector);
 	if (page)
@@ -97,7 +98,16 @@ static struct page *brd_insert_page(stru
 	/*
 	 * Must use NOIO because we don't want to recurse back into the
 	 * block or filesystem layers from page reclaim.
+	 *
+	 * Cannot support XIP and highmem, because our ->direct_access
+	 * routine for XIP must return memory that is always addressable.
+	 * If XIP was reworked to use pfns and kmap throughout, this
+	 * restriction might be able to be lifted.
 	 */
+	gfp_flags = GFP_NOIO | __GFP_ZERO;
+#ifndef CONFIG_BLK_DEV_XIP
+	gfp_flags |= __GFP_HIGHMEM;
+#endif
 	page = alloc_page(GFP_NOIO | __GFP_HIGHMEM | __GFP_ZERO);
 	if (!page)
 		return NULL;
@@ -307,6 +317,28 @@ out:
 	return 0;
 }
 
+#ifdef CONFIG_BLK_DEV_XIP
+static int brd_direct_access (struct block_device *bdev, sector_t sector,
+			unsigned long *data)
+{
+	struct brd_device *brd = bdev->bd_disk->private_data;
+	struct page *page;
+
+	if (!brd)
+		return -ENODEV;
+	if (sector & (PAGE_SECTORS-1))
+		return -EINVAL;
+	if (sector + PAGE_SECTORS > get_capacity(bdev->bd_disk))
+		return -ERANGE;
+	page = brd_insert_page(brd, sector);
+	if (!page)
+		return -ENOMEM;
+	*data = (unsigned long)page_address(page);
+
+	return 0;
+}
+#endif
+
 static int brd_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
@@ -342,8 +374,11 @@ static int brd_ioctl(struct inode *inode
 }
 
 static struct block_device_operations brd_fops = {
-	.owner =	THIS_MODULE,
-	.ioctl =	brd_ioctl,
+	.owner =		THIS_MODULE,
+	.ioctl =		brd_ioctl,
+#ifdef CONFIG_BLK_DEV_XIP
+	.direct_access =	brd_direct_access,
+#endif
 };
 
 /*
