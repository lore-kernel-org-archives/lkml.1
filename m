Return-Path: <linux-kernel-owner+w=401wt.eu-S1759112AbXFJNqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112AbXFJNqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 09:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757445AbXFJNpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 09:45:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:30548 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbXFJNpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 09:45:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-disposition:message-id:cc:content-type:content-transfer-encoding;
        b=DeB03IDxVHSyudkINZrSTIOecYGonSVEmsuB2nr/kx56fUGnMKm4Y4+IFmsngcWDWKTQtiTiVTBL8H5qhalfDUwihpg4Pqeu/3B4MAoTBwupbnvkxX8aPhg5XnmoCdvVodJBSVvSZywTyoGZogqd5h/7+IV5rU1ORu/bcLSI7Vw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 5/5] via82cxxx: backport short cables support from pata_via.c
Date: Sun, 10 Jun 2007 15:58:39 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706101558.39306.bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Backport short cables support from pata_via.c.

This patch should allow UDMA > 2 modes on Acer Ferrari 3400.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/via82cxxx.c |   48 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 41 insertions(+), 7 deletions(-)

Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -1,6 +1,6 @@
 /*
  *
- * Version 3.40
+ * Version 3.45
  *
  * VIA IDE driver for Linux. Supported southbridges:
  *
@@ -34,6 +34,8 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ide.h>
+#include <linux/dmi.h>
+
 #include <asm/io.h>
 
 #ifdef CONFIG_PPC_CHRP
@@ -415,6 +417,42 @@ static unsigned int __devinit init_chips
 	return 0;
 }
 
+/*
+ *	Cable special cases
+ */
+
+static struct dmi_system_id cable_dmi_table[] = {
+	{
+		.ident = "Acer Ferrari 3400",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Acer,Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "Ferrari 3400"),
+		},
+	},
+	{ }
+};
+
+static int via_cable_override(void)
+{
+	/* Systems by DMI */
+	if (dmi_check_system(cable_dmi_table))
+		return 1;
+	return 0;
+}
+
+static u8 __devinit via82cxxx_cable_detect(ide_hwif_t *hwif)
+{
+	struct via82cxxx_dev *vdev = pci_get_drvdata(hwif->pci_dev);
+
+	if (via_cable_override())
+		return ATA_CBL_PATA40_SHORT;
+
+	if ((vdev->via_80w >> hwif->channel) & 1)
+		return ATA_CBL_PATA80;
+	else
+		return ATA_CBL_PATA40;
+}
+
 static void __devinit init_hwif_via82cxxx(ide_hwif_t *hwif)
 {
 	struct via82cxxx_dev *vdev = pci_get_drvdata(hwif->pci_dev);
@@ -448,12 +486,8 @@ static void __devinit init_hwif_via82cxx
 	hwif->mwdma_mask = 0x07;
 	hwif->swdma_mask = 0x07;
 
-	if (hwif->cbl != ATA_CBL_PATA40_SHORT) {
-		if ((vdev->via_80w >> hwif->channel) & 1)
-			hwif->cbl = ATA_CBL_PATA80;
-		else
-			hwif->cbl = ATA_CBL_PATA40;
-	}
+	if (hwif->cbl != ATA_CBL_PATA40_SHORT)
+		hwif->cbl = via82cxxx_cable_detect(hwif);
 
 	hwif->ide_dma_check = &via82cxxx_ide_dma_check;
 	if (!noautodma)
