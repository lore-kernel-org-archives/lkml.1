Return-Path: <linux-kernel-owner+w=401wt.eu-S1759792AbYGVFrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792AbYGVFrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757411AbYGVF07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:26:59 -0400
Received: from mx1.suse.de ([195.135.220.2]:54193 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400AbYGVF06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:26:58 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 76/79] MTD: handle pci_name() being const
Date: Mon, 21 Jul 2008 22:19:40 -0700
Message-Id: <1216703983-21448-76-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
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

diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index 519d942..7b72a1b 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -241,6 +241,7 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 {
 	struct block_device *bdev;
 	struct block2mtd_dev *dev;
+	char *name;
 
 	if (!devname)
 		return NULL;
@@ -279,12 +280,13 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 
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
diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index a9fae03..9c1d954 100644
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
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 245f909..8b5d491 100644
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
1.5.6.3

