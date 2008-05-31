Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYEaKjC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYEaKjC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 06:39:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYEaKiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 06:38:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:34248 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbYEaKiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 06:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=X2bJlg75BPT6zGyD8k7Btgnfy+GvYdmSlY30j/3lcetIEbMAuUkaxVgtI2IV91msqUCl/7cZo5x6yEPV6pP2wshj2310NOmsi13p3PH9DJ46YBb0G8yutrslcIbtkT1GNV1LSobzrSbiNxE8iqhBZlaQrOfTIA0p95se7csse0s=
From: Bryan Wu <cooloney@kernel.org>
To: linux@maxim.org.za, dbrownell@users.sourceforge.net
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] MTD DataFlash: fix bug - ATMEL AT45DF321D spi flash card fails to be copied to
Date: Sat, 31 May 2008 18:38:44 +0800
Message-Id: <1212230324-22201-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

 - Add support for binary page size DataFlashes.
 - The driver now prints out pagesize and erasesize.
   Printout valuable information for creating flash filesystems.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/devices/mtd_dataflash.c |   38 ++++++++++++++++++++++++++--------
 1 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/devices/mtd_dataflash.c b/drivers/mtd/devices/mtd_dataflash.c
index b35e481..a47fe58 100644
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
@@ -524,10 +526,13 @@ add_dataflash(struct spi_device *spi, char *name,
  *   AT45DB021B  2Mbit   (256K)  xx0101xx (0x14)   1025    264      9
  *   AT45DB041B  4Mbit   (512K)  xx0111xx (0x1c)   2048    264      9
  *   AT45DB081B  8Mbit   (1M)    xx1001xx (0x24)   4096    264      9
- *   AT45DB0161B 16Mbit  (2M)    xx1011xx (0x2c)   4096    528     10
- *   AT45DB0321B 32Mbit  (4M)    xx1101xx (0x34)   8192    528     10
- *   AT45DB0642  64Mbit  (8M)    xx111xxx (0x3c)   8192   1056     11
- *   AT45DB1282  128Mbit (16M)   xx0100xx (0x10)  16384   1056     11
+ *   AT45DB0161B 16Mbit  (2M)    xx1011x0 (0x2c)   4096    528     10
+ *   AT45DB0161B 16Mbit  (2M)    xx1011x1 (0x2d)   4096    512      9
+ *   AT45DB0321B 32Mbit  (4M)    xx1101x0 (0x34)   8192    528     10
+ *   AT45DB0321B 32Mbit  (4M)    xx1101x1 (0x35)   8192    512      9
+ *   AT45DB0642  64Mbit  (8M)    xx111xx0 (0x3c)   8192   1056     11
+ *   AT45DB0642  64Mbit  (8M)    xx111xx1 (0x3d)   8192   1024     10
+ *   AT45DB1282  128Mbit (16M)   xx0100x0 (0x10)  16384   1056     11
  */
 static int __devinit dataflash_probe(struct spi_device *spi)
 {
@@ -546,29 +551,44 @@ static int __devinit dataflash_probe(struct spi_device *spi)
 	 * board setup should have set spi->max_speed_max to
 	 * match f(car) for continuous reads, mode 0 or 3.
 	 */
-	switch (status & 0x3c) {
+	switch (status & 0x3d) {
 	case 0x0c:	/* 0 0 1 1 x x */
+	case 0x0d:
 		status = add_dataflash(spi, "AT45DB011B", 512, 264, 9);
 		break;
 	case 0x14:	/* 0 1 0 1 x x */
+	case 0x15:
 		status = add_dataflash(spi, "AT45DB021B", 1025, 264, 9);
 		break;
 	case 0x1c:	/* 0 1 1 1 x x */
+	case 0x1d:
 		status = add_dataflash(spi, "AT45DB041x", 2048, 264, 9);
 		break;
 	case 0x24:	/* 1 0 0 1 x x */
+	case 0x25:
 		status = add_dataflash(spi, "AT45DB081B", 4096, 264, 9);
 		break;
-	case 0x2c:	/* 1 0 1 1 x x */
+	case 0x2c:	/* 1 0 1 1 x 0 */
 		status = add_dataflash(spi, "AT45DB161x", 4096, 528, 10);
 		break;
-	case 0x34:	/* 1 1 0 1 x x */
+	case 0x34:	/* 1 1 0 1 x 0 */
 		status = add_dataflash(spi, "AT45DB321x", 8192, 528, 10);
 		break;
-	case 0x38:	/* 1 1 1 x x x */
+	case 0x38:	/* 1 1 1 x x 0 */
 	case 0x3c:
 		status = add_dataflash(spi, "AT45DB642x", 8192, 1056, 11);
 		break;
+	/* Binary page size factory preset / user set */
+	case 0x2d:	/* 1 0 1 1 x 1 */
+		status = add_dataflash(spi, "AT45DB161x", 4096, 512, 9);
+		break;
+	case 0x35:	/* 1 1 0 1 x 1 */
+		status = add_dataflash(spi, "AT45DB321x", 8192, 512, 9);
+		break;
+	case 0x39:	/* 1 1 1 x x 1 */
+	case 0x3d:
+		status = add_dataflash(spi, "AT45DB642x", 8192, 1024, 10);
+		break;
 	/* obsolete AT45DB1282 not (yet?) supported */
 	default:
 		DEBUG(MTD_DEBUG_LEVEL1, "%s: unsupported device (%x)\n",
-- 
1.5.5

