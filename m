Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbXFJNqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbXFJNqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 09:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbXFJNpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 09:45:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:30561 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbXFJNpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 09:45:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-disposition:message-id:cc:content-type:content-transfer-encoding;
        b=pQW+IwEkzjbqy1C/tpsYsC9gPJBo1EJ6HmDaPRCCLW7ZPPqbNB6z89Rs4eDp9m9O6lA9jB+n6/bXZfotPAOCi2SG50LrWGFJwFe3GjU3OKg5T1IJR3BMwTsckh+WgveLMH6D4Qfc4sD2NCv1MXmAwgoM3kYzv79QAUhDJU3dCUI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/5] alim15x3: backport short cables support from pata_ali.c
Date: Sun, 10 Jun 2007 15:58:28 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706101558.28262.bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Backport short cables support from pata_ali.c and while at it cleanup
existing cable detection code.

This patch should allow UDMA > 2 modes on HP Pavilion N5430 and Fujitsu P2000.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/alim15x3.c |   73 ++++++++++++++++++++++++++++++---------------
 1 file changed, 49 insertions(+), 24 deletions(-)

Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/alim15x3.c		Version 0.21	2007/02/03
+ * linux/drivers/ide/pci/alim15x3.c		Version 0.25	Jun 9 2007
  *
  *  Copyright (C) 1998-2000 Michel Aubry, Maintainer
  *  Copyright (C) 1998-2000 Andrzej Krzysztofowicz, Maintainer
@@ -10,6 +10,7 @@
  *  Copyright (C) 2002 Alan Cox <alan@redhat.com>
  *  ALi (now ULi M5228) support by Clear Zhang <Clear.Zhang@ali.com.tw>
  *  Copyright (C) 2007 MontaVista Software, Inc. <source@mvista.com>
+ *  Copyright (C) 2007 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
  *
  *  (U)DMA capable version of ali 1533/1543(C), 1535(D)
  *
@@ -36,6 +37,7 @@
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/init.h>
+#include <linux/dmi.h>
 
 #include <asm/io.h>
 
@@ -583,6 +585,35 @@ out:
 	return 0;
 }
 
+/*
+ *	Cable special cases
+ */
+
+static struct dmi_system_id cable_dmi_table[] = {
+	{
+		.ident = "HP Pavilion N5430",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_BOARD_NAME, "OmniBook N32N-736"),
+		},
+	},
+	{ }
+};
+
+static int ali_cable_override(struct pci_dev *pdev)
+{
+	/* Fujitsu P2000 */
+	if (pdev->subsystem_vendor == 0x10CF &&
+	    pdev->subsystem_device == 0x10AF)
+		return 1;
+
+	/* Systems by DMI */
+	if (dmi_check_system(cable_dmi_table))
+		return 1;
+
+	return 0;
+}
+
 /**
  *	ata66_ali15x3	-	check for UDMA 66 support
  *	@hwif: IDE interface
@@ -597,34 +628,28 @@ out:
 static u8 __devinit ata66_ali15x3(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev	= hwif->pci_dev;
-	unsigned int ata66	= 0;
-	u8 cable_80_pin[2]	= { 0, 0 };
-
 	unsigned long flags;
-	u8 tmpbyte;
+	u8 cbl = ATA_CBL_PATA40, tmpbyte;
 
 	local_irq_save(flags);
 
 	if (m5229_revision >= 0xC2) {
 		/*
-		 * Ultra66 cable detection (from Host View)
-		 * m5229, 0x4a, bit0: primary, bit1: secondary 80 pin
-		 */
-		pci_read_config_byte(dev, 0x4a, &tmpbyte);
-		/*
-		 * 0x4a, bit0 is 0 => primary channel
-		 * has 80-pin (from host view)
-		 */
-		if (!(tmpbyte & 0x01)) cable_80_pin[0] = 1;
-		/*
-		 * 0x4a, bit1 is 0 => secondary channel
-		 * has 80-pin (from host view)
-		 */
-		if (!(tmpbyte & 0x02)) cable_80_pin[1] = 1;
-		/*
-		 * Allow ata66 if cable of current channel has 80 pins
-		 */
-		ata66 = (hwif->channel)?cable_80_pin[1]:cable_80_pin[0];
+		 * m5229 80-pin cable detection (from Host View)
+		 *
+		 * 0x4a bit0 is 0 => primary channel has 80-pin
+		 * 0x4a bit1 is 0 => secondary channel has 80-pin
+		 *
+		 * Certain laptops use short but suitable cables
+		 * and don't implement the detect logic.
+		 */
+		if (ali_cable_override(dev))
+			cbl = ATA_CBL_PATA40_SHORT;
+		else {
+			pci_read_config_byte(dev, 0x4a, &tmpbyte);
+			if ((tmpbyte & (1 << hwif->channel)) == 0)
+				cbl = ATA_CBL_PATA80;
+		}
 	} else {
 		/*
 		 * check m1533, 0x5e, bit 1~4 == 1001 => & 00011110 = 00010010
@@ -657,7 +682,7 @@ static u8 __devinit ata66_ali15x3(ide_hw
 
 	local_irq_restore(flags);
 
-	return ata66 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
+	return cbl;
 }
 
 /**
