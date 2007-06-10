Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbXFJNqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbXFJNqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 09:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbXFJNpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 09:45:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:29639 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbXFJNpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 09:45:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-disposition:message-id:cc:content-type:content-transfer-encoding;
        b=jDpm604dGngwfUJwPKT/2R5HMoJnVDOx0IIJB5Be40I6Nynuxfg+w1g6XJ68jafmy62nLqCCkcdP0s54e5C6CfugHrMAmn6M5TDfy/c3Ze1jysD012/N6zOmqhS/TX5BxJERw8rh33TuFmjAP5A7bPmOIRLZEWe75oB9kc1wSKo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/5] piix: backport short cables support from ata_piix.c
Date: Sun, 10 Jun 2007 15:58:14 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706101558.14511.bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Backport short cables support from ata_piix.c.

This patch should allow UDMA > 2 modes on:
- Acer 5602WLMi
- Acer 3682WLMi
- Asus W5F
- Acer Aspire 2023WLMi

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/piix.c |   37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/piix.c	Version 0.47	February 8, 2007
+ *  linux/drivers/ide/pci/piix.c	Version 0.50	Jun 10, 2007
  *
  *  Copyright (C) 1998-1999 Andrzej Krzysztofowicz, Author and Maintainer
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
@@ -394,12 +394,43 @@ static void piix_dma_clear_irq(ide_drive
 	hwif->OUTB(dma_stat, hwif->dma_status);
 }
 
+struct ich_laptop {
+	u16 device;
+	u16 subvendor;
+	u16 subdevice;
+};
+
+/*
+ *	List of laptops that use short cables rather than 80 wire
+ */
+
+static const struct ich_laptop ich_laptop[] = {
+	/* devid, subvendor, subdev */
+	{ 0x27DF, 0x0005, 0x0280 },	/* ICH7 on Acer 5602WLMi */
+	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
+	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
+	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on Acer Aspire 2023WLMi */
+	/* end marker */
+	{ 0, }
+};
+
 static u8 __devinit piix_cable_detect(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev = hwif->pci_dev;
+	struct pci_dev *pdev = hwif->pci_dev;
+	const struct ich_laptop *lap = &ich_laptop[0];
 	u8 reg54h = 0, mask = hwif->channel ? 0xc0 : 0x30;
 
-	pci_read_config_byte(dev, 0x54, &reg54h);
+	/* check for specials */
+	while (lap->device) {
+		if (lap->device == pdev->device &&
+		    lap->subvendor == pdev->subsystem_vendor &&
+		    lap->subdevice == pdev->subsystem_device) {
+			return ATA_CBL_PATA40_SHORT;
+		}
+		lap++;
+	}
+
+	pci_read_config_byte(pdev, 0x54, &reg54h);
 
 	return (reg54h & mask) ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
 }
