Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYADVN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYADVN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbYADVNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:13:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:37216 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbYADVNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:13:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=TMjbevhzx0cPweixsPehTqPtxQa+702+v7aVG/0LmDXV4H7X2c8TZyBqzfkTGge+QbCgKt025tvtyURbMnKiGPmIcfSbb1YqiqhkNQvsapivInPHvAoZyNEqT4E2Zu7yQOSf/3CWKg8UpURfTRu06pF+ADqtapDTi9jeA4CFv5M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 04 Jan 2008 22:24:46 +0100
Message-Id: <20080104212446.6978.63773.sendpatchset@localhost.localdomain>
In-Reply-To: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
References: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/15] ide: remove hwif->present manipulations from hwif_init()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Call hwif_init() only if hwif->present is set.

* If hwif_init() fails clear hwif->present.

* Remove hwif->present manipulations from hwif_init().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-24 bytes
 drivers/ide/ide-probe.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1245,28 +1245,21 @@ static int hwif_init(ide_hwif_t *hwif)
 {
 	int old_irq;
 
-	/* Return success if no device is connected */
-	if (!hwif->present)
-		return 1;
-
 	if (!hwif->irq) {
 		if (!(hwif->irq = ide_default_irq(hwif->io_ports[IDE_DATA_OFFSET])))
 		{
 			printk("%s: DISABLED, NO IRQ\n", hwif->name);
-			return (hwif->present = 0);
+			return 0;
 		}
 	}
 #ifdef CONFIG_BLK_DEV_HD
 	if (hwif->irq == HD_IRQ && hwif->io_ports[IDE_DATA_OFFSET] != HD_DATA) {
 		printk("%s: CANNOT SHARE IRQ WITH OLD "
 			"HARDDISK DRIVER (hd.c)\n", hwif->name);
-		return (hwif->present = 0);
+		return 0;
 	}
 #endif /* CONFIG_BLK_DEV_HD */
 
-	/* we set it back to 1 if all is ok below */	
-	hwif->present = 0;
-
 	if (register_blkdev(hwif->major, hwif->name))
 		return 0;
 
@@ -1305,10 +1298,7 @@ static int hwif_init(ide_hwif_t *hwif)
 
 done:
 	init_gendisk(hwif);
-
 	ide_acpi_init(hwif);
-
-	hwif->present = 1;	/* success */
 	return 1;
 
 out:
@@ -1352,9 +1342,13 @@ int ide_device_add_all(u8 *idx)
 
 		hwif = &ide_hwifs[idx[i]];
 
+		if (!hwif->present)
+			continue;
+
 		if (hwif_init(hwif) == 0) {
 			printk(KERN_INFO "%s: failed to initialize IDE "
 					 "interface\n", hwif->name);
+			hwif->present = 0;
 			rc = -1;
 			continue;
 		}
