Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbZBOMJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbZBOMJy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 07:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbZBOMI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 07:08:28 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:48397 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbZBOMIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:08:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N8GNtTPfUpGuWOWGg+Ma7Z12EA+7qjlQmfwe2eVhknfsJS+CjEwCo6kjW8bRjQuVmG
         qeB4O3sNtIa2S7UTE5C6UzNRC4MpGF8RQtwNHmVxG9QnHPqm3rhOtPl65I5TJwDgZ7GT
         7TQ1u6iujrmEjVDi8gs0p+0muKZY2uAhLDpX0=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 09/10] ide-probe: use flags query macros
Date: Sun, 15 Feb 2009 13:08:11 +0100
Message-Id: <1234699692-9452-10-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
References: <1234699692-9452-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shorten some >80 lines while at it.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-probe.c |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 203224c..5e8c6be 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -488,7 +488,7 @@ static u8 probe_for_drive(ide_drive_t *drive)
 	strcpy(m, "UNKNOWN");
 
 	/* skip probing? */
-	if ((drive->dev_flags & IDE_DFLAG_NOPROBE) == 0) {
+	if (!ide_drv_noprobe(drive)) {
 		/* if !(success||timed-out) */
 		cmd = ATA_CMD_ID_ATA;
 		rc = do_probe(drive, cmd);
@@ -498,20 +498,22 @@ static u8 probe_for_drive(ide_drive_t *drive)
 			rc = do_probe(drive, cmd);
 		}
 
-		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
+		if (!ide_drv_present(drive))
 			goto out_free;
 
 		/* identification failed? */
-		if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
+		if (!ide_drv_id_read(drive)) {
 			if (drive->media == ide_disk) {
-				printk(KERN_INFO "%s: non-IDE drive, CHS=%d/%d/%d\n",
+				pr_info("%s: non-IDE drive, CHS=%d/%d/%d\n",
 					drive->name, drive->cyl,
 					drive->head, drive->sect);
 			} else if (drive->media == ide_cdrom) {
-				printk(KERN_INFO "%s: ATAPI cdrom (?)\n", drive->name);
+				pr_info("%s: ATAPI cdrom (?)\n", drive->name);
 			} else {
 				/* nuke it */
-				printk(KERN_WARNING "%s: Unknown device on bus refused identification. Ignoring.\n", drive->name);
+				pr_warning("%s: Unknown device on bus refused "
+					   "identification, ignoring.\n",
+					   drive->name);
 				drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 			}
 		} else {
@@ -522,11 +524,11 @@ static u8 probe_for_drive(ide_drive_t *drive)
 		}
 	}
 
-	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
+	if (!ide_drv_present(drive))
 		goto out_free;
 
 	/* The drive wasn't being helpful. Add generic info only */
-	if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
+	if (!ide_drv_id_read(drive)) {
 		generic_id(drive);
 		return 1;
 	}
@@ -625,8 +627,7 @@ static int ide_port_wait_ready(ide_hwif_t *hwif)
 	/* Now make sure both master & slave are ready */
 	ide_port_for_each_dev(i, drive, hwif) {
 		/* Ignore disks that we will not probe for later. */
-		if ((drive->dev_flags & IDE_DFLAG_NOPROBE) == 0 ||
-		    (drive->dev_flags & IDE_DFLAG_PRESENT)) {
+		if (!ide_drv_noprobe(drive) || ide_drv_present(drive)) {
 			SELECT_DRIVE(drive);
 			hwif->tp_ops->set_irq(hwif, 1);
 			mdelay(2);
@@ -658,7 +659,7 @@ void ide_undecoded_slave(ide_drive_t *dev1)
 {
 	ide_drive_t *dev0 = dev1->hwif->devices[0];
 
-	if ((dev1->dn & 1) == 0 || (dev0->dev_flags & IDE_DFLAG_PRESENT) == 0)
+	if ((dev1->dn & 1) == 0 || !ide_drv_present(dev0))
 		return;
 
 	/* If the models don't match they are not the same product */
@@ -691,8 +692,8 @@ static int ide_probe_port(ide_hwif_t *hwif)
 
 	BUG_ON(hwif->present);
 
-	if ((hwif->devices[0]->dev_flags & IDE_DFLAG_NOPROBE) &&
-	    (hwif->devices[1]->dev_flags & IDE_DFLAG_NOPROBE))
+	if (ide_drv_noprobe(hwif->devices[0]) &&
+	    ide_drv_noprobe(hwif->devices[1]))
 		return -EACCES;
 
 	/*
@@ -704,7 +705,8 @@ static int ide_probe_port(ide_hwif_t *hwif)
 		disable_irq(hwif->irq);
 
 	if (ide_port_wait_ready(hwif) == -EBUSY)
-		printk(KERN_DEBUG "%s: Wait for ready failed before probe !\n", hwif->name);
+		pr_debug("%s: Wait for ready failed before probe!\n",
+			 hwif->name);
 
 	/*
 	 * Second drive should only exist if first drive was found,
@@ -712,7 +714,7 @@ static int ide_probe_port(ide_hwif_t *hwif)
 	 */
 	ide_port_for_each_dev(i, drive, hwif) {
 		(void) probe_for_drive(drive);
-		if (drive->dev_flags & IDE_DFLAG_PRESENT)
+		if (ide_drv_present(drive))
 			rc = 0;
 	}
 
@@ -874,7 +876,7 @@ static struct kobject *ata_probe(dev_t dev, int *part, void *data)
 	int unit = *part >> PARTN_BITS;
 	ide_drive_t *drive = hwif->devices[unit];
 
-	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
+	if (!ide_drv_present(drive))
 		return NULL;
 
 	if (drive->media == ide_disk)
-- 
1.6.0.4

