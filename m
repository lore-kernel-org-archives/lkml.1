Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbYFCE0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbYFCE0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 00:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbYFCE0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 00:26:08 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:6934 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbYFCE0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 00:26:07 -0400
X-IronPort-AV: E=Sophos;i="4.27,581,1204520400"; 
   d="scan'208";a="69431591"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       David Brownell <david-b@pacbell.net>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] MTD DataFlash: fix bug - ATMEL AT45DF321D spi flash card fails to be copied to (v2)
Date: Tue,  3 Jun 2008 12:26:05 +0800
Message-Id: <1212467165-26379-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

 - Add support for binary page size DataFlashes.
 - The driver now prints out pagesize and erasesize.
   Printout valuable information for creating flash filesystems.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/devices/mtd_dataflash.c |  117 +++++++++++++++++++++++++++++++++--
 1 files changed, 112 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/devices/mtd_dataflash.c b/drivers/mtd/devices/mtd_dataflash.c
index b35e481..acc3728 100644
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -487,7 +487,9 @@ add_dataflash(struct spi_device *spi, char *name,
 	device->write = dataflash_write;
 	device->priv = priv;
 
-	dev_info(&spi->dev, "%s (%d KBytes)\n", name, device->size/1024);
+	dev_info(&spi->dev, "%s (%d KBytes) pagesize %d bytes, "
+		"erasesize %d bytes\n", name, device->size/1024,
+		 pagesize, pagesize * 8);	/* 8 pages = 1 block */
 	dev_set_drvdata(&spi->dev, priv);
 
 	if (mtd_has_partitions()) {
@@ -521,7 +523,7 @@ add_dataflash(struct spi_device *spi, char *name,
  *
  *   Device      Density         ID code          #Pages PageSize  Offset
  *   AT45DB011B  1Mbit   (128K)  xx0011xx (0x0c)    512    264      9
- *   AT45DB021B  2Mbit   (256K)  xx0101xx (0x14)   1025    264      9
+ *   AT45DB021B  2Mbit   (256K)  xx0101xx (0x14)   1024    264      9
  *   AT45DB041B  4Mbit   (512K)  xx0111xx (0x1c)   2048    264      9
  *   AT45DB081B  8Mbit   (1M)    xx1001xx (0x24)   4096    264      9
  *   AT45DB0161B 16Mbit  (2M)    xx1011xx (0x2c)   4096    528     10
@@ -529,9 +531,114 @@ add_dataflash(struct spi_device *spi, char *name,
  *   AT45DB0642  64Mbit  (8M)    xx111xxx (0x3c)   8192   1056     11
  *   AT45DB1282  128Mbit (16M)   xx0100xx (0x10)  16384   1056     11
  */
+
+struct flash_info {
+	char		*name;
+
+	/* JEDEC id zero means "no ID" (most older chips); otherwise it has
+	 * a high byte of zero plus three data bytes: the manufacturer id,
+	 * then a two byte device id.
+	 */
+	u32		jedec_id;
+
+	/* The size listed here is what works with OPCODE_SE, which isn't
+	 * necessarily called a "sector" by the vendor.
+	 */
+	unsigned	nr_pages;
+	u16		pagesize;
+	u16		pageoffset;
+
+	u16		flags;
+#define	SUP_POW2PS	0x02
+#define	IS_POW2PS	0x01
+};
+
+static struct flash_info __devinitdata dataflash_data [] = {
+
+	{ "at45db011d",  0x1f2200, 512, 264, 9, SUP_POW2PS},
+	{ "at45db011d",  0x1f2200, 512, 256, 8, SUP_POW2PS | IS_POW2PS},
+
+	{ "at45db021d",  0x1f2300, 1024, 264, 9, SUP_POW2PS},
+	{ "at45db021d",  0x1f2300, 1024, 256, 8, SUP_POW2PS | IS_POW2PS},
+
+	{ "at45db041d",  0x1f2400, 2048, 264, 9, SUP_POW2PS},
+	{ "at45db041d",  0x1f2400, 2048, 256, 8, SUP_POW2PS | IS_POW2PS},
+
+	{ "at45db081d",  0x1f2500, 4096, 264, 9, SUP_POW2PS},
+	{ "at45db081d",  0x1f2500, 4096, 256, 8, SUP_POW2PS | IS_POW2PS},
+
+	{ "at45db161d",  0x1f2600, 4096, 528, 10, SUP_POW2PS},
+	{ "at45db161d",  0x1f2600, 4096, 512, 9, SUP_POW2PS | IS_POW2PS},
+
+	{ "at45db321c",  0x1f2700, 8192, 528, 10, },
+
+	{ "at45db321d",  0x1f2701, 8192, 528, 10, SUP_POW2PS},
+	{ "at45db321d",  0x1f2701, 8192, 512, 9, SUP_POW2PS | IS_POW2PS},
+
+	{ "at45db641d",  0x1f2800, 8192, 1056, 11, SUP_POW2PS},
+	{ "at45db641d",  0x1f2800, 8192, 1024, 10, SUP_POW2PS | IS_POW2PS},
+};
+
+static struct flash_info *__devinit jedec_probe(struct spi_device *spi)
+{
+	int			tmp;
+	u8			code = OP_READ_ID;
+	u8			id[3];
+	u32			jedec;
+	struct flash_info	*info;
+	int status;
+
+
+	/* JEDEC also defines an optional "extended device information"
+	 * string for after vendor-specific data, after the three bytes
+	 * we use here.  Supporting some chips might require using it.
+	 */
+	tmp = spi_write_then_read(spi, &code, 1, id, 3);
+	if (tmp < 0) {
+		DEBUG(MTD_DEBUG_LEVEL0, "%s: error %d reading JEDEC ID\n",
+			spi->dev.bus_id, tmp);
+		return NULL;
+	}
+	jedec = id[0];
+	jedec = jedec << 8;
+	jedec |= id[1];
+	jedec = jedec << 8;
+	jedec |= id[2];
+
+	for (tmp = 0, info = dataflash_data;
+			tmp < ARRAY_SIZE(dataflash_data);
+			tmp++, info++) {
+		if (info->jedec_id == jedec) {
+			if (info->flags & SUP_POW2PS) {
+				status = dataflash_status(spi);
+				if (status & 0x1)
+					/* return power of 2 pagesize */
+					return ++info;
+				else
+					return info;
+			}
+		}
+	}
+	return NULL;
+}
+
 static int __devinit dataflash_probe(struct spi_device *spi)
 {
 	int status;
+	struct flash_info	*info;
+
+	/*
+	 * Try to detect dataflash by JEDEC ID.
+	 * If it succeeds we know we have either a C or D part.
+	 * D will support power of 2 pagesize option.
+	 */
+
+	info = jedec_probe(spi);
+
+	if (info != NULL)
+		return add_dataflash(spi, info->name, info->nr_pages,
+				 info->pagesize, info->pageoffset);
+
 
 	status = dataflash_status(spi);
 	if (status <= 0 || status == 0xff) {
@@ -551,16 +658,16 @@ static int __devinit dataflash_probe(struct spi_device *spi)
 		status = add_dataflash(spi, "AT45DB011B", 512, 264, 9);
 		break;
 	case 0x14:	/* 0 1 0 1 x x */
-		status = add_dataflash(spi, "AT45DB021B", 1025, 264, 9);
+		status = add_dataflash(spi, "AT45DB021B", 1024, 264, 9);
 		break;
 	case 0x1c:	/* 0 1 1 1 x x */
-		status = add_dataflash(spi, "AT45DB041x", 2048, 264, 9);
+		status = add_dataflash(spi, "AT45DB041B", 2048, 264, 9);
 		break;
 	case 0x24:	/* 1 0 0 1 x x */
 		status = add_dataflash(spi, "AT45DB081B", 4096, 264, 9);
 		break;
 	case 0x2c:	/* 1 0 1 1 x x */
-		status = add_dataflash(spi, "AT45DB161x", 4096, 528, 10);
+		status = add_dataflash(spi, "AT45DB161B", 4096, 528, 10);
 		break;
 	case 0x34:	/* 1 1 0 1 x x */
 		status = add_dataflash(spi, "AT45DB321x", 8192, 528, 10);
-- 
1.5.5
