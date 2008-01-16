Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbYAPXSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbYAPXSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbYAPXO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:14:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:10411 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822AbYAPXO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:14:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=B8hKoFN5YUGDKyLQtaW5hoxe1wIJc78utgL58TU2qwHz2lXr4SgBVTJxz3U25XX0CBQMu1qgMGadh1ujDqMwXvnu/nyiDa7vxqZ9Z6pTPGkrKjJ8uJH437ufjmhDhUsAx9IgS/g5b28Qy5nxQ2d2CMkQaDdA2ic+vkaEKnD/qXY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:27:36 +0100
Message-Id: <20080116232736.9166.99723.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 13/22] ide: merge init_gendisk() into hwif_register_devices()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   44 ++++++++++++++++----------------------------
 1 file changed, 16 insertions(+), 28 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1182,26 +1182,6 @@ static void drive_release_dev (struct de
 	complete(&drive->gendev_rel_comp);
 }
 
-static void init_gendisk (ide_hwif_t *hwif)
-{
-	unsigned int unit;
-
-	for (unit = 0; unit < MAX_DRIVES; ++unit) {
-		ide_drive_t * drive = &hwif->drives[unit];
-
-		if (!drive->present)
-			continue;
-
-		ide_add_generic_settings(drive);
-		snprintf(drive->gendev.bus_id,BUS_ID_SIZE,"%u.%u",
-			 hwif->index,unit);
-		drive->gendev.parent = &hwif->gendev;
-		drive->gendev.bus = &ide_bus_type;
-		drive->gendev.driver_data = drive;
-		drive->gendev.release = drive_release_dev;
-	}
-}
-
 static int hwif_init(ide_hwif_t *hwif)
 {
 	int old_irq;
@@ -1261,7 +1241,6 @@ done:
 	blk_register_region(MKDEV(hwif->major, 0), MAX_DRIVES << PARTN_BITS,
 			    THIS_MODULE, ata_probe, ata_lock, hwif);
 	ide_acpi_init(hwif);
-	init_gendisk(hwif);
 	return 1;
 
 out:
@@ -1275,15 +1254,24 @@ static void hwif_register_devices(ide_hw
 
 	for (i = 0; i < MAX_DRIVES; i++) {
 		ide_drive_t *drive = &hwif->drives[i];
+		struct device *dev = &drive->gendev;
+		int ret;
 
-		if (drive->present) {
-			int ret = device_register(&drive->gendev);
+		if (!drive->present)
+			continue;
 
-			if (ret < 0)
-				printk(KERN_WARNING "IDE: %s: "
-					"device_register error: %d\n",
-					__FUNCTION__, ret);
-		}
+		ide_add_generic_settings(drive);
+
+		snprintf(dev->bus_id, BUS_ID_SIZE, "%u.%u", hwif->index, i);
+		dev->parent = &hwif->gendev;
+		dev->bus = &ide_bus_type;
+		dev->driver_data = drive;
+		dev->release = drive_release_dev;
+
+		ret = device_register(dev);
+		if (ret < 0)
+			printk(KERN_WARNING "IDE: %s: device_register error: "
+					    "%d\n", __func__, ret);
 	}
 }
 
