Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111Ab0A2QTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0A2QTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556Ab0A2QEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:04:32 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab0A2QE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:04:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=AX7lyuVz0zHYOUQXnQfjhg7kZEyXuDz0J7DhvqeyWA9nekI9/jfYEQxset2gxNbfIP
         WKfQpDKgzTzRo8DRvTWhrbvcKT6ocrLnUEKwpVTqAw9Ei0/dNPtuqHR1pIeeT6KXtS8I
         bHy0xn2zr6A0gMLJKNCfN6nYK3AnNefWhDft8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:04:21 +0100
Message-Id: <20100129160421.21495.4199.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 11/68] piix: use ata_piix.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] piix: use ata_piix.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/piix.c |   41 +++--------------------------------------
 1 file changed, 3 insertions(+), 38 deletions(-)

Index: b/drivers/ide/piix.c
===================================================================
--- a/drivers/ide/piix.c
+++ b/drivers/ide/piix.c
@@ -241,51 +241,16 @@ static void ich_clear_irq(ide_drive_t *d
 	outb(dma_stat, hwif->dma_base + ATA_DMA_STATUS);
 }
 
-struct ich_laptop {
-	u16 device;
-	u16 subvendor;
-	u16 subdevice;
-};
-
-/*
- *	List of laptops that use short cables rather than 80 wire
- */
-
-static const struct ich_laptop ich_laptop[] = {
-	/* devid, subvendor, subdev */
-	{ 0x27DF, 0x1025, 0x0102 },	/* ICH7 on Acer 5602aWLMi */
-	{ 0x27DF, 0x0005, 0x0280 },	/* ICH7 on Acer 5602WLMi */
-	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
-	{ 0x27DF, 0x1028, 0x02b0 },	/* ICH7 on unknown Dell */
-	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
-	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
-	{ 0x27DF, 0x103C, 0x361a },	/* ICH7 on unkown HP  */
-	{ 0x27DF, 0x1071, 0xD221 },	/* ICH7 on Hercules EC-900 */
-	{ 0x27DF, 0x152D, 0x0778 },	/* ICH7 on unknown Intel */
-	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on Acer Aspire 2023WLMi */
-	{ 0x24CA, 0x1025, 0x003d },	/* ICH4 on ACER TM290 */
-	{ 0x266F, 0x1025, 0x0066 },	/* ICH6 on ACER Aspire 1694WLMi */
-	{ 0x2653, 0x1043, 0x82D8 },	/* ICH6M on Asus Eee 701 */
-	{ 0x27df, 0x104d, 0x900e },	/* ICH7 on Sony TZ-90 */
-	/* end marker */
-	{ 0, }
-};
+#include "../ata/ata_piix.h"
 
 static u8 piix_cable_detect(ide_hwif_t *hwif)
 {
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
-	const struct ich_laptop *lap = &ich_laptop[0];
 	u8 reg54h = 0, mask = hwif->channel ? 0xc0 : 0x30;
 
 	/* check for specials */
-	while (lap->device) {
-		if (lap->device == pdev->device &&
-		    lap->subvendor == pdev->subsystem_vendor &&
-		    lap->subdevice == pdev->subsystem_device) {
-			return ATA_CBL_PATA40_SHORT;
-		}
-		lap++;
-	}
+	if (ich_short_ata40(pdev))
+		return ATA_CBL_PATA40_SHORT;
 
 	pci_read_config_byte(pdev, 0x54, &reg54h);
 
