Return-Path: <linux-kernel-owner+w=401wt.eu-S1758237AbZD1ELb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237AbZD1ELb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 00:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbZD1EHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 00:07:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:38790 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbZD1EHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 00:07:48 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, donari75@gmail.com,
       bzolnier@gmail.com, joerg@dorchain.net, geert@linux-m68k.org,
       davem@davemloft.net, jdike@linux.intel.com, benh@kernel.crashing.org,
       Laurent@lvivier.info
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/14] mg_disk: fix dependency on libata
Date: Tue, 28 Apr 2009 13:06:16 +0900
Message-Id: <1240891577-4813-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240891577-4813-1-git-send-email-tj@kernel.org>
References: <1240891577-4813-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 28 Apr 2009 04:06:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Add local copies of ata_id_string() and ata_id_c_string() to mg_disk
so there is no need for the driver to depend on ATA and SCSI.

[ Impact: break dependency on libata by copying ata id string functions ]

Cc: unsik Kim <donari75@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/Kconfig   |    2 +-
 drivers/block/mg_disk.c |   44 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index ddea8e4..f42fa50 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -412,7 +412,7 @@ config ATA_OVER_ETH
 
 config MG_DISK
 	tristate "mGine mflash, gflash support"
-	depends on ARM && ATA && GPIOLIB
+	depends on ARM && GPIOLIB
 	help
 	  mGine mFlash(gFlash) block device driver
 
diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 1a4cc96..8e53cae 100644
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
@@ -357,6 +357,42 @@ static irqreturn_t mg_irq(int irq, void *dev_id)
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
@@ -403,9 +439,9 @@ static int mg_get_disk_id(struct mg_host *host)
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
-- 
1.6.0.2

