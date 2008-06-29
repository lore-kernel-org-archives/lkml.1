Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbYF2GWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbYF2GWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 02:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYF2GWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 02:22:06 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:22797 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751244AbYF2GWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 02:22:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YtPc38NrVOSJhCzWjaBWMADWLpJo5kZ5LwjrsD8VgM0+REwN7RW+CrasYGxzR6MIbjLkhp78SDKopRMmTKnaLhbU8QLAcJ8v9L3F1q+NTuVRgRpJFLn2pvx2KDH3uLJV3eWZPbkMjaykK6YKLXclIOm+MKMxTdvHDelgA0yyjuA=  ;
X-YMail-OSG: 6BBZB5EVM1miZ9pgjJvMKPJDFZUIGioR4mBH0jAC_cGMGvrBfqcF.keh2A8RYZpC48l10pInpmG2nTTyRM5ve04q1KhUnXwHBlsYZLhLPxD1mX6Lx5YXWhz3ZbNnuhTppKg-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 2.6.26-rc8] MTD DataFlash: bugfix, binary page sizes now handled (v3)
Date: Sat, 28 Jun 2008 23:21:34 -0700
User-Agent: KMail/1.9.9
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1212467165-26379-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1212467165-26379-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806282321.34275.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

This fixes a bug in handling certain newer DataFlash chips (at45db321d
and at45db642d have current Linux users) when they were configured to
use binary page sizes (possibly at the factory).

 - Use JEDEC probing (borrowed from m25p80 driver) to tell if the chip
   supports binary page sizes ... if so, then query the chip to tell
   whether it's currently using them.

 - Print that pagesize during probe; erasesize is still listed in 
   the /proc/mtd file, useful for making filesystems.

Also fix a pre-existing bug with 2 MBit parts using the wrong pagesize;
these are a bit smaller than Linux would normally use (even shared with
a small FPGA's configuration bitstream).

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>

Fix regression (so cmdlinepart works again), update error handling
and comments.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/mtd/devices/mtd_dataflash.c |  154 ++++++++++++++++++++++++++++++++++--
 1 file changed, 149 insertions(+), 5 deletions(-)

--- a/drivers/mtd/devices/mtd_dataflash.c	2008-06-28 22:21:41.000000000 -0700
+++ b/drivers/mtd/devices/mtd_dataflash.c	2008-06-28 22:53:23.000000000 -0700
@@ -15,6 +15,8 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
+#include <linux/err.h>
+
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 
@@ -487,7 +489,8 @@ add_dataflash(struct spi_device *spi, ch
 	device->write = dataflash_write;
 	device->priv = priv;
 
-	dev_info(&spi->dev, "%s (%d KBytes)\n", name, device->size/1024);
+	dev_info(&spi->dev, "%s (%d KBytes) pagesize %d bytes\n",
+			name, DIV_ROUND_UP(device->size, 1024), pagesize);
 	dev_set_drvdata(&spi->dev, priv);
 
 	if (mtd_has_partitions()) {
@@ -516,12 +519,137 @@ add_dataflash(struct spi_device *spi, ch
 	return add_mtd_device(device) == 1 ? -ENODEV : 0;
 }
 
+struct flash_info {
+	char		*name;
+
+	/* JEDEC id zero means "no ID" (most older chips); otherwise it has
+	 * a high byte of zero plus three data bytes: the manufacturer id,
+	 * then a two byte device id.
+	 */
+	u32		jedec_id;
+
+	/* The size listed here is what works with OP_ERASE_PAGE. */
+	unsigned	nr_pages;
+	u16		pagesize;
+	u16		pageoffset;
+
+	u16		flags;
+#define SUP_POW2PS	0x0001		/* supports 2^N byte pages */
+#define IS_POW2PS	0x0002		/* uses 2^N byte pages */
+};
+
+static struct flash_info __devinitdata dataflash_data [] = {
+
+	/*
+	 * NOTE:  chips with SUP_POW2PS (rev D and up) need two entries,
+	 * one with IS_POW2PS and the other without.  The entry with the
+	 * non-2^N byte page size can't name exact chip revisions without
+	 * losing backwards compatibility for cmdlinepart.
+	 *
+	 * These newer chips also support 128-byte security registers (with
+	 * 64 bytes one-time-programmable) and software write-protection.
+	 */
+	{ "AT45DB011B",  0x1f2200, 512, 264, 9, SUP_POW2PS, },
+	{ "at45db011d",  0x1f2200, 512, 256, 8, SUP_POW2PS | IS_POW2PS, },
+
+	{ "AT45DB021B",  0x1f2300, 1024, 264, 9, SUP_POW2PS, },
+	{ "at45db021d",  0x1f2300, 1024, 256, 8, SUP_POW2PS | IS_POW2PS, },
+
+	{ "AT45DB041x",  0x1f2400, 2048, 264, 9, SUP_POW2PS, },
+	{ "at45db041d",  0x1f2400, 2048, 256, 8, SUP_POW2PS | IS_POW2PS, },
+
+	{ "AT45DB081B",  0x1f2500, 4096, 264, 9, SUP_POW2PS, },
+	{ "at45db081d",  0x1f2500, 4096, 256, 8, SUP_POW2PS | IS_POW2PS, },
+
+	{ "AT45DB161x",  0x1f2600, 4096, 528, 10, SUP_POW2PS, },
+	{ "at45db161d",  0x1f2600, 4096, 512, 9, SUP_POW2PS | IS_POW2PS, },
+
+	{ "AT45DB321x",  0x1f2700, 8192, 528, 10, 0, },		/* rev C */
+	{ "AT45DB321x",  0x1f2701, 8192, 528, 10, SUP_POW2PS, },
+	{ "at45db321d",  0x1f2701, 8192, 512, 9, SUP_POW2PS | IS_POW2PS, },
+
+	{ "AT45DB642x",  0x1f2800, 8192, 1056, 11, SUP_POW2PS, },
+	{ "at45db642d",  0x1f2800, 8192, 1024, 10, SUP_POW2PS | IS_POW2PS, },
+};
+
+static struct flash_info *__devinit jedec_probe(struct spi_device *spi)
+{
+	int			tmp;
+	u8			code = OP_READ_ID;
+	u8			id[3];
+	u32			jedec;
+	struct flash_info	*info;
+	int			status;
+
+	/*
+	 * JEDEC also defines an optional "extended device information"
+	 * string for after vendor-specific data, after the three bytes
+	 * we use here.  Supporting some chips might require using it.
+	 *
+	 * If the vendor ID isn't Atmel's (0x1f), assume this call failed.
+	 * That's not an error; only rev C and newer chips handle it, and
+	 * only Atmel sells these chips.
+	 */
+	tmp = spi_write_then_read(spi, &code, 1, id, 3);
+	if (tmp < 0) {
+		DEBUG(MTD_DEBUG_LEVEL1, "%s: read ID error %d\n",
+			spi->dev.bus_id, status);
+		return ERR_PTR(tmp);
+	}
+	if (id[0] != 0x1f)
+		return NULL;
+
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
+			DEBUG(MTD_DEBUG_LEVEL1, "%s: security register"
+					", sector protect%s\n",
+				spi->dev.bus_id,
+				(info->flags & SUP_POW2PS)
+					? ", binary pagesize" : ""
+				);
+			if (info->flags & SUP_POW2PS) {
+				status = dataflash_status(spi);
+				if (status < 0) {
+					DEBUG(MTD_DEBUG_LEVEL1,
+						"%s: status error %d\n",
+						spi->dev.bus_id, status);
+					return ERR_PTR(status);
+				}
+				if (status & 0x1) {
+					if (info->flags & IS_POW2PS)
+						return info;
+				} else {
+					if (!(info->flags & IS_POW2PS))
+						return info;
+				}
+			}
+		}
+	}
+
+	/*
+	 * Treat unrecognized chips as errors ... we won't know the
+	 * right page size (it might be binary) even when we can tell
+	 * which density class is involved
+	 */
+	dev_warn(&spi->dev, "unrecognized JEDEC id %06x\n", jedec);
+	return ERR_PTR(-ENODEV);
+}
+
 /*
- * Detect and initialize DataFlash device:
+ * Detect and initialize DataFlash device, using JEDEC IDs on newer chips
+ * or else the ID code embedded in the status bits:
  *
  *   Device      Density         ID code          #Pages PageSize  Offset
  *   AT45DB011B  1Mbit   (128K)  xx0011xx (0x0c)    512    264      9
- *   AT45DB021B  2Mbit   (256K)  xx0101xx (0x14)   1025    264      9
+ *   AT45DB021B  2Mbit   (256K)  xx0101xx (0x14)   1024    264      9
  *   AT45DB041B  4Mbit   (512K)  xx0111xx (0x1c)   2048    264      9
  *   AT45DB081B  8Mbit   (1M)    xx1001xx (0x24)   4096    264      9
  *   AT45DB0161B 16Mbit  (2M)    xx1011xx (0x2c)   4096    528     10
@@ -531,8 +659,24 @@ add_dataflash(struct spi_device *spi, ch
  */
 static int __devinit dataflash_probe(struct spi_device *spi)
 {
-	int status;
+	int			status;
+	struct flash_info	*info;
 
+	/*
+	 * Try to detect dataflash by JEDEC ID.  If it succeeds, we
+	 * have either a C or D part.  D supports pagesize options.
+	 */
+	info = jedec_probe(spi);
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+	if (info != NULL)
+		return add_dataflash(spi, info->name, info->nr_pages,
+				 info->pagesize, info->pageoffset);
+
+	/*
+	 * Older chips support only legacy commands, identifing
+	 * capacity using bits in the status byte.
+	 */
 	status = dataflash_status(spi);
 	if (status <= 0 || status == 0xff) {
 		DEBUG(MTD_DEBUG_LEVEL1, "%s: status error %d\n",
@@ -551,7 +695,7 @@ static int __devinit dataflash_probe(str
 		status = add_dataflash(spi, "AT45DB011B", 512, 264, 9);
 		break;
 	case 0x14:	/* 0 1 0 1 x x */
-		status = add_dataflash(spi, "AT45DB021B", 1025, 264, 9);
+		status = add_dataflash(spi, "AT45DB021B", 1024, 264, 9);
 		break;
 	case 0x1c:	/* 0 1 1 1 x x */
 		status = add_dataflash(spi, "AT45DB041x", 2048, 264, 9);
