Return-Path: <linux-kernel-owner+w=401wt.eu-S1759539AbYAFQv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539AbYAFQv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818AbYAFQum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:50:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:19805 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550AbYAFQul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:50:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=PhVEA+EfhZIaJYswWjM7tY+ln+z7TLlTVrxYCpoGEAQmHex0C4LDvNMM++9tTxYnK0JkYW5Sz5L5h5Fotwcix13w54dADuz5MMl/13zM6S54JSCLGrkcP9MbBe1ibEjELDY4y7nf6PoNpwoQdN519CzvR34hmzvF0OSjzQSDs/M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 06 Jan 2008 18:02:27 +0100
Message-Id: <20080106170227.6861.71421.sendpatchset@localhost.localdomain>
In-Reply-To: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
References: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/8] dtc2278: fix ->io_32bit handling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On DTC2278 32-bit I/O has to be enabled for both devices on the port
so always enable it during init time and disallow further changes.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c            |    4 ----
 drivers/ide/legacy/dtc2278.c |   12 ++++++------
 2 files changed, 6 insertions(+), 10 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -791,10 +791,6 @@ int set_io_32bit(ide_drive_t *drive, int
 		return -EBUSY;
 
 	drive->io_32bit = arg;
-#ifdef CONFIG_BLK_DEV_DTC2278
-	if (HWIF(drive)->chipset == ide_dtc2278)
-		HWIF(drive)->drives[!drive->select.b.unit].io_32bit = arg;
-#endif /* CONFIG_BLK_DEV_DTC2278 */
 
 	spin_unlock_irq(&ide_lock);
 
Index: b/drivers/ide/legacy/dtc2278.c
===================================================================
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -84,12 +84,6 @@ static void dtc2278_set_pio_mode(ide_dri
 		/* Actually we do - there is a data sheet available for the
 		   Winbond but does anyone actually care */
 	}
-
-	/*
-	 * 32bit I/O has to be enabled for *both* drives at the same time.
-	 */
-	drive->io_32bit = 1;
-	HWIF(drive)->drives[!drive->select.b.unit].io_32bit = 1;
 }
 
 static int __init dtc2278_probe(void)
@@ -123,18 +117,24 @@ static int __init dtc2278_probe(void)
 	local_irq_restore(flags);
 
 	hwif->serialized = 1;
+	hwif->no_io_32bit = 1;	/* disallow ->io_32bit changes */
 	hwif->chipset = ide_dtc2278;
 	hwif->pio_mask = ATA_PIO4;
 	hwif->set_pio_mode = &dtc2278_set_pio_mode;
 	hwif->drives[0].no_unmask = 1;
 	hwif->drives[1].no_unmask = 1;
+	hwif->drives[0].io_32bit = 1;
+	hwif->drives[1].io_32bit = 1;
 	hwif->mate = mate;
 
 	mate->serialized = 1;
+	mate->no_io_32bit = 1;
 	mate->chipset = ide_dtc2278;
 	mate->pio_mask = ATA_PIO4;
 	mate->drives[0].no_unmask = 1;
 	mate->drives[1].no_unmask = 1;
+	mate->drives[0].io_32bit = 1;
+	mate->drives[1].io_32bit = 1;
 	mate->mate = hwif;
 	mate->channel = 1;
 
