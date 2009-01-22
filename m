Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbZAVOTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbZAVOTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 09:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758480AbZAVOSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 09:18:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:6453 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758455AbZAVOR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:17:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=byLJtSQylxqi5nJRAQ7+ArDdrtwkYjBqspIlB94R3irK1rRsQhZ7bNz8yWknqFur6x
         y0zdHvBH6aLtM9jxNKM8mSk6oDzHWEcreoBtBKzFiLs6TlwnIymcwafJH8PbRFSVS+m6
         6TnU/UcP2r3zZ64viYptsSXiKdQPJfyAzOvXo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 22 Jan 2009 15:18:28 +0100
Message-Id: <20090122141828.25516.64456.sendpatchset@localhost.localdomain>
In-Reply-To: <20090122141801.25516.5620.sendpatchset@localhost.localdomain>
References: <20090122141801.25516.5620.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/8] ide: remove broken EXABYTENEST support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove broken EXABYTENEST support

do_identify() marks EXABYTENEST device as non-present and frees
drive->id so enable_nest() has absolutely no chance of working.

The code was like this since at least 2.6.12-rc2 and nobody
has noticed so just remove broken EXABYTENEST support.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   37 -------------------------------------
 include/linux/ata.h     |    2 --
 2 files changed, 39 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -465,37 +465,6 @@ static int do_probe (ide_drive_t *drive,
 	return rc;
 }
 
-/*
- *
- */
-static void enable_nest (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
-	u8 stat;
-
-	printk(KERN_INFO "%s: enabling %s -- ",
-		hwif->name, (char *)&drive->id[ATA_ID_PROD]);
-
-	SELECT_DRIVE(drive);
-	msleep(50);
-	tp_ops->exec_command(hwif, ATA_EXABYTE_ENABLE_NEST);
-
-	if (ide_busy_sleep(hwif, WAIT_WORSTCASE, 0)) {
-		printk(KERN_CONT "failed (timeout)\n");
-		return;
-	}
-
-	msleep(50);
-
-	stat = tp_ops->read_status(hwif);
-
-	if (!OK_STAT(stat, 0, BAD_STAT))
-		printk(KERN_CONT "failed (status = 0x%02x)\n", stat);
-	else
-		printk(KERN_CONT "success\n");
-}
-
 /**
  *	probe_for_drives	-	upper level drive probe
  *	@drive: drive to probe for
@@ -534,7 +503,6 @@ static u8 probe_for_drive(ide_drive_t *d
 
 	/* skip probing? */
 	if ((drive->dev_flags & IDE_DFLAG_NOPROBE) == 0) {
-retry:
 		/* if !(success||timed-out) */
 		if (do_probe(drive, ATA_CMD_ID_ATA) >= 2)
 			/* look for ATAPI device */
@@ -544,11 +512,6 @@ retry:
 			/* drive not found */
 			return 0;
 
-		if (strstr(m, "E X A B Y T E N E S T")) {
-			enable_nest(drive);
-			goto retry;
-		}
-
 		/* identification failed? */
 		if ((drive->dev_flags & IDE_DFLAG_ID_READ) == 0) {
 			if (drive->media == ide_disk) {
Index: b/include/linux/ata.h
===================================================================
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -242,8 +242,6 @@ enum {
 	ATA_CMD_MEDIA_UNLOCK	= 0xDF,
 	/* marked obsolete in the ATA/ATAPI-7 spec */
 	ATA_CMD_RESTORE		= 0x10,
-	/* EXABYTE specific */
-	ATA_EXABYTE_ENABLE_NEST	= 0xF0,
 
 	/* READ_LOG_EXT pages */
 	ATA_LOG_SATA_NCQ	= 0x10,
