Return-Path: <linux-kernel-owner+w=401wt.eu-S1761658AbZEMUsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658AbZEMUsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 16:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761491AbZEMUra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 16:47:30 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:40473 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959AbZEMUr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 16:47:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=nKu9tgLIkVO/km5CrNoCw9xnjUMFhV445fu+wpfJpv5mwrMLE7AtendXWb8jcUC5Cf
         tVx3bMaJO8gg19rxkqgmFyQPHGLGLjQdikLoDrubKrpeqcKeNKKzmqHeLqcj3Zs375yS
         /2RMvsW8cNS2qXjW+/digSg0U+0eTRSjJ/g04=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 13 May 2009 22:52:00 +0200
Message-Id: <20090513205200.28638.90827.sendpatchset@localhost.localdomain>
In-Reply-To: <20090513205139.28638.87226.sendpatchset@localhost.localdomain>
References: <20090513205139.28638.87226.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/7] ide: merge ide_disk_special() into do_special()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:
- change debug printk() level to KERN_DEBUG
- update documentation

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |   44 ++++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -184,11 +184,28 @@ static void ide_tf_set_setmult_cmd(ide_d
 	tf->command = ATA_CMD_SET_MULTI;
 }
 
-static ide_startstop_t ide_disk_special(ide_drive_t *drive)
+/**
+ *	do_special		-	issue some special commands
+ *	@drive: drive the command is for
+ *
+ *	do_special() is used to issue ATA_CMD_INIT_DEV_PARAMS,
+ *	ATA_CMD_RESTORE and ATA_CMD_SET_MULTI commands to a drive.
+ */
+
+static ide_startstop_t do_special(ide_drive_t *drive)
 {
 	special_t *s = &drive->special;
 	struct ide_cmd cmd;
 
+#ifdef DEBUG
+	printk(KERN_DEBUG "%s: %s: 0x%02x\n", drive->name, s->all);
+#endif
+	if (drive->media != ide_disk) {
+		s->all = 0;
+		drive->mult_req = 0;
+		return ide_stopped;
+	}
+
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.protocol = ATA_PROT_NODATA;
 
@@ -213,31 +230,6 @@ static ide_startstop_t ide_disk_special(
 	return ide_started;
 }
 
-/**
- *	do_special		-	issue some special commands
- *	@drive: drive the command is for
- *
- *	do_special() is used to issue ATA_CMD_INIT_DEV_PARAMS,
- *	ATA_CMD_RESTORE and ATA_CMD_SET_MULTI commands to a drive.
- *
- *	It used to do much more, but has been scaled back.
- */
-
-static ide_startstop_t do_special (ide_drive_t *drive)
-{
-	special_t *s = &drive->special;
-
-#ifdef DEBUG
-	printk("%s: do_special: 0x%02x\n", drive->name, s->all);
-#endif
-	if (drive->media == ide_disk)
-		return ide_disk_special(drive);
-
-	s->all = 0;
-	drive->mult_req = 0;
-	return ide_stopped;
-}
-
 void ide_map_sg(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
