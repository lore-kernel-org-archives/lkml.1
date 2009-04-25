Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbZDYNIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbZDYNIE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 09:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZDYNHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 09:07:38 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56322 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbZDYNHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 09:07:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=bubcEfkZR+TERejEwM2uKnrtzLD4YTNzTlzg7eyH3hFlGHsoGeKnPN/9jKjjbifzfA
         2eq6+E+9NlgIYLYmacU2r3pL9xQF90qUCsMzZusKbG+Q+aPVaighkq3i6oLjMmZMosPW
         HsVR7GsLc8lz6vFGifFUelFvnLHEx/ewVtZ2Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: unsik Kim <donari75@gmail.com>
Subject: [PATCH 2/3] mg_disk: fix dependency on libata
Date: Sat, 25 Apr 2009 15:09:09 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904251509.11912.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add local copies of ata_id_string() and ata_id_c_string() to mg_disk
so there is no need for the driver to depend on ATA and SCSI.

Cc: unsik Kim <donari75@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/block/Kconfig   |    2 +-
 drivers/block/mg_disk.c |   44 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 41 insertions(+), 5 deletions(-)

Index: b/drivers/block/Kconfig
===================================================================
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -412,7 +412,7 @@ config ATA_OVER_ETH
 
 config MG_DISK
 	tristate "mGine mflash, gflash support"
-	depends on ARM && ATA && GPIOLIB
+	depends on ARM && GPIOLIB
 	help
 	  mGine mFlash(gFlash) block device driver
 
Index: b/drivers/block/mg_disk.c
===================================================================
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -17,7 +17,7 @@
 #include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
-#include <linux/libata.h>
+#include <linux/ata.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
@@ -356,6 +356,42 @@ static irqreturn_t mg_irq(int irq, void 
 	return IRQ_HANDLED;
 }
 
+/* local copy of ata_id_string() */
+static void mg_id_string(const u16 *id, unsigned char *s,
+			 unsigned int ofs, unsigned int len)
+{
+	unsigned int c;
+
+	BUG_ON(len & 1);
+
+	while (len > 0) {
+		c = id[ofs] >> 8;
+		*s = c;
+		s++;
+
+		c = id[ofs] & 0xff;
+		*s = c;
+		s++;
+
+		ofs++;
+		len -= 2;
+	}
+}
+
+/* local copy of ata_id_c_string() */
+static void mg_id_c_string(const u16 *id, unsigned char *s,
+			   unsigned int ofs, unsigned int len)
+{
+	unsigned char *p;
+
+	mg_id_string(id, s, ofs, len - 1);
+
+	p = s + strnlen(s, len - 1);
+	while (p > s && p[-1] == ' ')
+		p--;
+	*p = '\0';
+}
+
 static int mg_get_disk_id(struct mg_host *host)
 {
 	u32 i;
@@ -402,9 +438,9 @@ static int mg_get_disk_id(struct mg_host
 		host->n_sectors -= host->nres_sectors;
 	}
 
-	ata_id_c_string(id, fwrev, ATA_ID_FW_REV, sizeof(fwrev));
-	ata_id_c_string(id, model, ATA_ID_PROD, sizeof(model));
-	ata_id_c_string(id, serial, ATA_ID_SERNO, sizeof(serial));
+	mg_id_c_string(id, fwrev, ATA_ID_FW_REV, sizeof(fwrev));
+	mg_id_c_string(id, model, ATA_ID_PROD, sizeof(model));
+	mg_id_c_string(id, serial, ATA_ID_SERNO, sizeof(serial));
 	printk(KERN_INFO "mg_disk: model: %s\n", model);
 	printk(KERN_INFO "mg_disk: firm: %.8s\n", fwrev);
 	printk(KERN_INFO "mg_disk: serial: %s\n", serial);
