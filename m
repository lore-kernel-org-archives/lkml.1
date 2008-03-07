Return-Path: <linux-kernel-owner+w=401wt.eu-S1760099AbYCGOhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099AbYCGOhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 09:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758389AbYCGOg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 09:36:58 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37091 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844AbYCGOgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 09:36:51 -0500
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: nickpiggin@yahoo.com.au
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH] Modify RAMDISK (brd) device to be able to manage partitions
Date: Fri,  7 Mar 2008 15:40:01 +0100
Message-Id: <120490080174-git-send-email-Laurent.Vivier@bull.net>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To keep in sync with loop device, this patch updates drivers/block/brd.c to 
manage partitions.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
---
 Documentation/kernel-parameters.txt |    2 +
 drivers/block/brd.c                 |   36 ++++++++++++++++++++++++++++++----
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9a5b665..43af1dd 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1602,6 +1602,8 @@ and is between 256 and 4096 characters. It is defined in the file
 	ramdisk_size=	[RAM] Sizes of RAM disks in kilobytes
 			See Documentation/ramdisk.txt.
 
+	ramdisk_max_part=	[RAM] Maximum number of partitions per RAM disk.
+
 	rcupdate.blimit=	[KNL,BOOT]
 			Set maximum number of finished RCU callbacks to process
 			in one batch.
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 8536480..55758f5 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -386,10 +386,14 @@ static struct block_device_operations brd_fops = {
  */
 static int rd_nr;
 int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
+static int rd_max_part;
+static int part_shift;
 module_param(rd_nr, int, 0);
 MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
 module_param(rd_size, int, 0);
 MODULE_PARM_DESC(rd_size, "Size of each RAM disk in kbytes.");
+module_param(rd_max_part, int, 0);
+MODULE_PARM_DESC(rd_max_part, "Maximum number of partition by RAM disk");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
 
@@ -404,8 +408,25 @@ static int __init ramdisk_size2(char *str)
 {
 	return ramdisk_size(str);
 }
+static int __init max_part_setup(char *str)
+{
+	rd_max_part = simple_strtol(str, NULL, 0);
+	if (rd_max_part < 1) {
+		/* there is at least one partition */
+		printk(KERN_ERR "nrd: max_part cannot be lesser than 1\n");
+		return 0;
+	}
+	if (rd_max_part > (1UL << (MINORBITS - 1)) {
+		/* we must keep at least one bit for nrd device number */
+		printk(KERN_ERR "nrd: max_part cannot be greater than %lu\n",
+		       1UL << (MINORBITS - 1));
+		return 0;
+	}
+	return 1;
+}
 __setup("ramdisk=", ramdisk_size);
 __setup("ramdisk_size=", ramdisk_size2);
+__setup("ramdisk_max_part=", max_part_setup);
 #endif
 
 /*
@@ -434,11 +455,11 @@ static struct brd_device *brd_alloc(int i)
 	blk_queue_max_sectors(brd->brd_queue, 1024);
 	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
 
-	disk = brd->brd_disk = alloc_disk(1);
+	disk = brd->brd_disk = alloc_disk(1 << part_shift);
 	if (!disk)
 		goto out_free_queue;
 	disk->major		= RAMDISK_MAJOR;
-	disk->first_minor	= i;
+	disk->first_minor	= i << part_shift;
 	disk->fops		= &brd_fops;
 	disk->private_data	= brd;
 	disk->queue		= brd->brd_queue;
@@ -522,7 +543,12 @@ static int __init brd_init(void)
 	 *     themselves and have kernel automatically instantiate actual
 	 *     device on-demand.
 	 */
-	if (rd_nr > 1UL << MINORBITS)
+
+	part_shift = 0;
+	if (rd_max_part > 0)
+		part_shift = fls(rd_max_part);
+
+	if (rd_nr > 1UL << (MINORBITS - part_shift))
 		return -EINVAL;
 
 	if (rd_nr) {
@@ -530,7 +556,7 @@ static int __init brd_init(void)
 		range = rd_nr;
 	} else {
 		nr = CONFIG_BLK_DEV_RAM_COUNT;
-		range = 1UL << MINORBITS;
+		range = 1UL << (MINORBITS - part_shift);
 	}
 
 	if (register_blkdev(RAMDISK_MAJOR, "ramdisk"))
@@ -569,7 +595,7 @@ static void __exit brd_exit(void)
 	unsigned long range;
 	struct brd_device *brd, *next;
 
-	range = rd_nr ? rd_nr :  1UL << MINORBITS;
+	range = rd_nr ? rd_nr :  1UL << (MINORBITS - part_shift);
 
 	list_for_each_entry_safe(brd, next, &brd_devices, brd_list)
 		brd_del_one(brd);
-- 
1.5.2.4

