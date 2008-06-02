Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbYFBHis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbYFBHis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYFBHij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:38:39 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:8580 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbYFBHii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:38:38 -0400
X-IronPort-AV: E=Sophos;i="4.27,576,1204520400"; 
   d="scan'208";a="69360081"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/1] MTD DataFlash: fix bug - ATMEL AT45DF321D spi flash card fails to be copied to
Date: Mon, 2 Jun 2008 08:39:04 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D01E046F0@limkexm3.ad.analog.com>
In-Reply-To: <1212230324-22201-1-git-send-email-cooloney@kernel.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] MTD DataFlash: fix bug - ATMEL AT45DF321D spi flash card fails to be copied to
Thread-Index: AcjDCogqiS6mkDL0S2qPGDzGCmEpUABd47Ow
References: <1212230324-22201-1-git-send-email-cooloney@kernel.org>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Bryan Wu" <cooloney@kernel.org>, <linux@maxim.org.za>,
       <dbrownell@users.sourceforge.net>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>
X-OriginalArrivalTime: 02 Jun 2008 07:38:36.0345 (UTC) FILETIME=[AAAF8A90:01C8C483]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Please disregard this patch.

According to the ATMEL DataFlash datasheets, it's not a 100% correct.

I contacted ATMEL to get some commitment that BIT 0 of the DataFlash
Status Register reads always 0 for all DataFlash Devices NOT in binary
page size.

This was not acknowledged.

For the AT45DBXXXB devices bit 0 of the status register is a don't care
(0 or 1). The '"B" version of the part does not support the binary page
size.

For the AT45DBXXXD devices bit 0 of the status register is a 0 in the
non-binary page mode.

We need use the Manufacturer and Device ID read command (opcode 9Fh) to
distinguish between the "B" (parts which do not support the binary page
size) and the "D" (parts which support the binary page size) version
parts.

On the "B" version parts the Manufacturer and Device ID read command is
ignored and output is tristated. Using this same opcode on the "D"
version parts outputs 1Fh as the first byte and device ID (value depends
on the density) as the second byte.

Bryan is going to send an updated path soon.

Best regards,
Michael


>-----Original Message-----
>From: Bryan Wu [mailto:cooloney.lkml@gmail.com] On Behalf Of Bryan Wu
>Sent: Samstag, 31. Mai 2008 12:39
>To: linux@maxim.org.za; dbrownell@users.sourceforge.net
>Cc: linux-mtd@lists.infradead.org; linux-kernel@vger.kernel.org;
Michael
>Hennerich; Bryan Wu
>Subject: [PATCH 1/1] MTD DataFlash: fix bug - ATMEL AT45DF321D spi
flash
>card fails to be copied to
>
>From: Michael Hennerich <michael.hennerich@analog.com>
>
> - Add support for binary page size DataFlashes.
> - The driver now prints out pagesize and erasesize.
>   Printout valuable information for creating flash filesystems.
>
>Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>Signed-off-by: Bryan Wu <cooloney@kernel.org>
>---
> drivers/mtd/devices/mtd_dataflash.c |   38
++++++++++++++++++++++++++-----
>---
> 1 files changed, 29 insertions(+), 9 deletions(-)
>
>diff --git a/drivers/mtd/devices/mtd_dataflash.c
>b/drivers/mtd/devices/mtd_dataflash.c
>index b35e481..a47fe58 100644
>--- a/drivers/mtd/devices/mtd_dataflash.c
>+++ b/drivers/mtd/devices/mtd_dataflash.c
>@@ -487,7 +487,9 @@ add_dataflash(struct spi_device *spi, char *name,
> 	device->write = dataflash_write;
> 	device->priv = priv;
>
>-	dev_info(&spi->dev, "%s (%d KBytes)\n", name,
device->size/1024);
>+	dev_info(&spi->dev, "%s (%d KBytes) pagesize %d bytes, "
>+		"erasesize %d bytes\n", name, device->size/1024,
>+		 pagesize, pagesize * 8);	/* 8 pages = 1 block */
> 	dev_set_drvdata(&spi->dev, priv);
>
> 	if (mtd_has_partitions()) {
>@@ -524,10 +526,13 @@ add_dataflash(struct spi_device *spi, char *name,
>  *   AT45DB021B  2Mbit   (256K)  xx0101xx (0x14)   1025    264      9
>  *   AT45DB041B  4Mbit   (512K)  xx0111xx (0x1c)   2048    264      9
>  *   AT45DB081B  8Mbit   (1M)    xx1001xx (0x24)   4096    264      9
>- *   AT45DB0161B 16Mbit  (2M)    xx1011xx (0x2c)   4096    528     10
>- *   AT45DB0321B 32Mbit  (4M)    xx1101xx (0x34)   8192    528     10
>- *   AT45DB0642  64Mbit  (8M)    xx111xxx (0x3c)   8192   1056     11
>- *   AT45DB1282  128Mbit (16M)   xx0100xx (0x10)  16384   1056     11
>+ *   AT45DB0161B 16Mbit  (2M)    xx1011x0 (0x2c)   4096    528     10
>+ *   AT45DB0161B 16Mbit  (2M)    xx1011x1 (0x2d)   4096    512      9
>+ *   AT45DB0321B 32Mbit  (4M)    xx1101x0 (0x34)   8192    528     10
>+ *   AT45DB0321B 32Mbit  (4M)    xx1101x1 (0x35)   8192    512      9
>+ *   AT45DB0642  64Mbit  (8M)    xx111xx0 (0x3c)   8192   1056     11
>+ *   AT45DB0642  64Mbit  (8M)    xx111xx1 (0x3d)   8192   1024     10
>+ *   AT45DB1282  128Mbit (16M)   xx0100x0 (0x10)  16384   1056     11
>  */
> static int __devinit dataflash_probe(struct spi_device *spi)
> {
>@@ -546,29 +551,44 @@ static int __devinit dataflash_probe(struct
>spi_device *spi)
> 	 * board setup should have set spi->max_speed_max to
> 	 * match f(car) for continuous reads, mode 0 or 3.
> 	 */
>-	switch (status & 0x3c) {
>+	switch (status & 0x3d) {
> 	case 0x0c:	/* 0 0 1 1 x x */
>+	case 0x0d:
> 		status = add_dataflash(spi, "AT45DB011B", 512, 264, 9);
> 		break;
> 	case 0x14:	/* 0 1 0 1 x x */
>+	case 0x15:
> 		status = add_dataflash(spi, "AT45DB021B", 1025, 264, 9);
> 		break;
> 	case 0x1c:	/* 0 1 1 1 x x */
>+	case 0x1d:
> 		status = add_dataflash(spi, "AT45DB041x", 2048, 264, 9);
> 		break;
> 	case 0x24:	/* 1 0 0 1 x x */
>+	case 0x25:
> 		status = add_dataflash(spi, "AT45DB081B", 4096, 264, 9);
> 		break;
>-	case 0x2c:	/* 1 0 1 1 x x */
>+	case 0x2c:	/* 1 0 1 1 x 0 */
> 		status = add_dataflash(spi, "AT45DB161x", 4096, 528,
10);
> 		break;
>-	case 0x34:	/* 1 1 0 1 x x */
>+	case 0x34:	/* 1 1 0 1 x 0 */
> 		status = add_dataflash(spi, "AT45DB321x", 8192, 528,
10);
> 		break;
>-	case 0x38:	/* 1 1 1 x x x */
>+	case 0x38:	/* 1 1 1 x x 0 */
> 	case 0x3c:
> 		status = add_dataflash(spi, "AT45DB642x", 8192, 1056,
11);
> 		break;
>+	/* Binary page size factory preset / user set */
>+	case 0x2d:	/* 1 0 1 1 x 1 */
>+		status = add_dataflash(spi, "AT45DB161x", 4096, 512, 9);
>+		break;
>+	case 0x35:	/* 1 1 0 1 x 1 */
>+		status = add_dataflash(spi, "AT45DB321x", 8192, 512, 9);
>+		break;
>+	case 0x39:	/* 1 1 1 x x 1 */
>+	case 0x3d:
>+		status = add_dataflash(spi, "AT45DB642x", 8192, 1024,
10);
>+		break;
> 	/* obsolete AT45DB1282 not (yet?) supported */
> 	default:
> 		DEBUG(MTD_DEBUG_LEVEL1, "%s: unsupported device (%x)\n",
>--
>1.5.5
