Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbYGBU1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbYGBU1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 16:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbYGBU0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 16:26:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbYGBU0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 16:26:41 -0400
Date: Wed, 2 Jul 2008 13:24:43 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       davem@davemloft.net
Subject: [patch 01/04] MTD: handle pci_name() being const
Message-ID: <20080702202443.GA14024@kroah.com>
References: <20080702200902.909349505@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mtd-handle-pci_name-being-const.patch"
In-Reply-To: <20080702202200.GA14021@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the MTD core to handle pci_name() now returning a constant
string.

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/devices/block2mtd.c |    8 +++++---
 include/linux/mtd/map.h         |    2 +-
 include/linux/mtd/mtd.h         |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -241,6 +241,7 @@ static struct block2mtd_dev *add_device(
 {
 	struct block_device *bdev;
 	struct block2mtd_dev *dev;
+	char *name;
 
 	if (!devname)
 		return NULL;
@@ -279,12 +280,13 @@ static struct block2mtd_dev *add_device(
 
 	/* Setup the MTD structure */
 	/* make the name contain the block device in */
-	dev->mtd.name = kmalloc(sizeof("block2mtd: ") + strlen(devname),
+	name = kmalloc(sizeof("block2mtd: ") + strlen(devname) + 1,
 			GFP_KERNEL);
-	if (!dev->mtd.name)
+	if (!name)
 		goto devinit_err;
 
-	sprintf(dev->mtd.name, "block2mtd: %s", devname);
+	sprintf(name, "block2mtd: %s", devname);
+	dev->mtd.name = name;
 
 	dev->mtd.size = dev->blkdev->bd_inode->i_size & PAGE_MASK;
 	dev->mtd.erasesize = erase_size;
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -189,7 +189,7 @@ typedef union {
 */
 
 struct map_info {
-	char *name;
+	const char *name;
 	unsigned long size;
 	resource_size_t phys;
 #define NO_XIP (-1UL)
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -121,7 +121,7 @@ struct mtd_info {
 	u_int32_t oobavail;  // Available OOB bytes per block
 
 	// Kernel-only stuff starts here.
-	char *name;
+	const char *name;
 	int index;
 
 	/* ecc layout structure pointer - read only ! */

-- 
