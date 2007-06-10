Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbXFJNrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbXFJNrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 09:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbXFJNps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 09:45:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:29288 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbXFJNpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 09:45:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-disposition:message-id:cc:content-type:content-transfer-encoding;
        b=c9x1Saxkp/6ITMZxw+xf+hbbWXuVRRqeSdSP4YTVN6jsuykRwdR/BBkcrnaUu0iDIs2OtJfPCtIvY1pOTpctHJDUDvGhH2cmmY8cIcIhZyJP/Czo6/Z0vY2q5c99bajiXevVA0RKylL3oMYTCASBbrFitGx+snjzibkRzUfuEyU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/5] sis5513: backport short cables support from pata_sis.c
Date: Sun, 10 Jun 2007 15:58:33 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706101558.33636.bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Backport short cables support from pata_sis.c.

This patch should allow UDMA > 2 modes on ASUS A6K.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/sis5513.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/sis5513.c	Version 0.20	Mar 4, 2007
+ * linux/drivers/ide/pci/sis5513.c	Version 0.25	Jun 10, 2007
  *
  * Copyright (C) 1999-2000	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2002		Lionel Bouton <Lionel.Bouton@inet6.fr>, Maintainer
@@ -796,10 +796,33 @@ static unsigned int __devinit init_chips
 	return 0;
 }
 
+struct sis_laptop {
+	u16 device;
+	u16 subvendor;
+	u16 subdevice;
+};
+
+static const struct sis_laptop sis_laptop[] = {
+	/* devid, subvendor, subdev */
+	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
+	/* end marker */
+	{ 0, }
+};
+
 static u8 __devinit ata66_sis5513(ide_hwif_t *hwif)
 {
+	struct pci_dev *pdev = hwif->pci_dev;
+	const struct sis_laptop *lap = &sis_laptop[0];
 	u8 ata66 = 0;
 
+	while (lap->device) {
+		if (lap->device == pdev->device &&
+		    lap->subvendor == pdev->subsystem_vendor &&
+		    lap->subdevice == pdev->subsystem_device)
+			return ATA_CBL_PATA40_SHORT;
+		lap++;
+	}
+
 	if (chipset_family >= ATA_133) {
 		u16 regw = 0;
 		u16 reg_addr = hwif->channel ? 0x52: 0x50;
