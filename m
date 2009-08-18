Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbZHRHHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbZHRHHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 03:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbZHRHH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 03:07:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59759 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbZHRHHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 03:07:25 -0400
From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
To: linux-mtd@lists.infradead.org
Cc: davinci-linux-open-source@linux.davincidsp.com, david-b@pacbell.net,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Subject: [PATCH] [MTD] mtdpart: memory accessor interface for MTD layer
Date: Tue, 18 Aug 2009 12:34:27 -0400
Message-Id: <1250613267-25485-1-git-send-email-sudhakar.raj@ti.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements memory accessor interface in the MTD
layer which enables the kernel to access flash data.

This patch adds two new members to the mtd_partition structure,
a function handler which will be called during setup of the
partition and an argument to be passed to this setup function.

Example:
+static struct mtd_partition spi_flash_partitions[] = {
+       [0] = {
+               .name       = "U-Boot",
+               .offset     = 0,
+               .size       = SZ_256K,
+               .mask_flags = MTD_WRITEABLE,
+       },
+       [1] = {
+               .name       = "U-Boot Environment",
+               .offset     = MTDPART_OFS_NXTBLK,
+               .size       = SZ_64K,
+               .mask_flags = MTD_WRITEABLE,
+       },
+       [2] = {
+               .name       = "Linux",
+               .offset     = MTDPART_OFS_NXTBLK,
+               .size       = SZ_7M,
+               .mask_flags = 0,
+       },
+       [3] = {
+               .name       = "MAC Address",
+               .offset     = MTDPART_OFS_NXTBLK,
+               .size       = SZ_64K,
+               .mask_flags = 0,
+               .setup      = davinci_get_mac_addr,
+               .context    = (void *)0,
+       },
+};

The davinci_get_mac_addr function reads the MAC address from
offset ZERO of last MTD partition.

Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
---
 drivers/mtd/mtdpart.c          |   40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mtd/partitions.h |    3 +++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 349fcbe..8f14653 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -26,6 +26,7 @@ static LIST_HEAD(mtd_partitions);
 struct mtd_part {
 	struct mtd_info mtd;
 	struct mtd_info *master;
+	struct memory_accessor macc;
 	uint64_t offset;
 	struct list_head list;
 };
@@ -327,6 +328,39 @@ int del_mtd_partitions(struct mtd_info *master)
 }
 EXPORT_SYMBOL(del_mtd_partitions);
 
+/*
+ * This lets other kernel code access the flash data. For example, it
+ * might hold a board's Ethernet address, or board-specific calibration
+ * data generated on the manufacturing floor.
+ */
+static ssize_t mtd_macc_read(struct memory_accessor *macc, char *buf,
+			off_t offset, size_t count)
+{
+	struct mtd_part *part = container_of(macc, struct mtd_part, macc);
+	ssize_t ret = -EIO;
+	size_t retlen;
+
+	if (part_read((struct mtd_info *)part, offset, count,
+			&retlen, buf) == 0)
+		ret = retlen;
+
+	return ret;
+}
+
+static ssize_t mtd_macc_write(struct memory_accessor *macc, const char *buf,
+			off_t offset, size_t count)
+{
+	struct mtd_part *part = container_of(macc, struct mtd_part, macc);
+	ssize_t ret = -EIO;
+	size_t retlen;
+
+	if (part_write((struct mtd_info *)part, offset, count,
+			&retlen, buf) == 0)
+		ret = retlen;
+
+	return ret;
+}
+
 static struct mtd_part *add_one_partition(struct mtd_info *master,
 		const struct mtd_partition *part, int partno,
 		uint64_t cur_offset)
@@ -364,6 +398,9 @@ static struct mtd_part *add_one_partition(struct mtd_info *master,
 	slave->mtd.read = part_read;
 	slave->mtd.write = part_write;
 
+	slave->macc.read = mtd_macc_read;
+	slave->macc.write = mtd_macc_write;
+
 	if (master->panic_write)
 		slave->mtd.panic_write = part_panic_write;
 
@@ -428,6 +465,9 @@ static struct mtd_part *add_one_partition(struct mtd_info *master,
 	printk(KERN_NOTICE "0x%012llx-0x%012llx : \"%s\"\n", (unsigned long long)slave->offset,
 		(unsigned long long)(slave->offset + slave->mtd.size), slave->mtd.name);
 
+	if (part->setup)
+		part->setup(&slave->macc, (void *)part->context);
+
 	/* let's do some sanity checks */
 	if (slave->offset >= master->size) {
 		/* let's register it anyway to preserve ordering */
diff --git a/include/linux/mtd/partitions.h b/include/linux/mtd/partitions.h
index af6dcb9..cc76779 100644
--- a/include/linux/mtd/partitions.h
+++ b/include/linux/mtd/partitions.h
@@ -10,6 +10,7 @@
 #define MTD_PARTITIONS_H
 
 #include <linux/types.h>
+#include <linux/memory.h>
 
 
 /*
@@ -40,6 +41,8 @@ struct mtd_partition {
 	uint64_t offset;		/* offset within the master MTD space */
 	uint32_t mask_flags;		/* master MTD flags to mask out for this partition */
 	struct nand_ecclayout *ecclayout;	/* out of band layout for this partition (NAND only)*/
+	void (*setup)(struct memory_accessor *, void *context);
+	void *context;
 };
 
 #define MTDPART_OFS_NXTBLK	(-2)
-- 
1.5.6

