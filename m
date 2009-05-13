Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbZEMUsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbZEMUsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 16:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761557AbZEMUri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 16:47:38 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57965 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761559AbZEMUrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 16:47:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=FXFFJKNy9hNMOkqzKU4g2XcrkvV5Dwlwxvol99IwCiBWvM9tGzWQim86kwZv3LYD6L
         FAhjUvPM56gknS2QveYMCgfCZYRtkf/MAWpCiTjeOXj1geroLYe03xScIzfLpsKCTYFK
         KV3hBEIisr9dRuikxa6MjEKZQcTE1AaPFn/n0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 13 May 2009 22:52:07 +0200
Message-Id: <20090513205207.28638.44663.sendpatchset@localhost.localdomain>
In-Reply-To: <20090513205139.28638.87226.sendpatchset@localhost.localdomain>
References: <20090513205139.28638.87226.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/7] ide: replace special_t typedef by IDE_SFLAG_* flags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace:
- special_t typedef by IDE_SFLAG_* flags
- 'special_t special' ide_drive_t's field by 'u8 special_flags' one

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c     |    4 ++--
 drivers/ide/ide-eh.c       |    9 ++++-----
 drivers/ide/ide-io.c       |   21 +++++++++++----------
 drivers/ide/ide-probe.c    |    6 +++---
 drivers/ide/ide-taskfile.c |    2 +-
 drivers/ide/siimage.c      |    4 ++--
 include/linux/ide.h        |   21 ++++++---------------
 7 files changed, 29 insertions(+), 38 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -421,14 +421,14 @@ static int set_multcount(ide_drive_t *dr
 	if (arg < 0 || arg > (drive->id[ATA_ID_MAX_MULTSECT] & 0xff))
 		return -EINVAL;
 
-	if (drive->special.b.set_multmode)
+	if (drive->special_flags & IDE_SFLAG_SET_MULTMODE)
 		return -EBUSY;
 
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 
 	drive->mult_req = arg;
-	drive->special.b.set_multmode = 1;
+	drive->special_flags |= IDE_SFLAG_SET_MULTMODE;
 	error = blk_execute_rq(drive->queue, NULL, rq, 0);
 	blk_put_request(rq);
 
Index: b/drivers/ide/ide-eh.c
===================================================================
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -52,7 +52,7 @@ static ide_startstop_t ide_ata_error(ide
 	}
 
 	if ((rq->errors & ERROR_RECAL) == ERROR_RECAL)
-		drive->special.b.recalibrate = 1;
+		drive->special_flags |= IDE_SFLAG_RECALIBRATE;
 
 	++rq->errors;
 
@@ -268,9 +268,8 @@ static void ide_disk_pre_reset(ide_drive
 {
 	int legacy = (drive->id[ATA_ID_CFS_ENABLE_2] & 0x0400) ? 0 : 1;
 
-	drive->special.all = 0;
-	drive->special.b.set_geometry = legacy;
-	drive->special.b.recalibrate  = legacy;
+	drive->special_flags =
+		legacy ? (IDE_SFLAG_SET_GEOMETRY | IDE_SFLAG_RECALIBRATE) : 0;
 
 	drive->mult_count = 0;
 	drive->dev_flags &= ~IDE_DFLAG_PARKED;
@@ -280,7 +279,7 @@ static void ide_disk_pre_reset(ide_drive
 		drive->mult_req = 0;
 
 	if (drive->mult_req != drive->mult_count)
-		drive->special.b.set_multmode = 1;
+		drive->special_flags |= IDE_SFLAG_SET_MULTMODE;
 }
 
 static void pre_reset(ide_drive_t *drive)
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -194,14 +194,14 @@ static void ide_tf_set_setmult_cmd(ide_d
 
 static ide_startstop_t do_special(ide_drive_t *drive)
 {
-	special_t *s = &drive->special;
 	struct ide_cmd cmd;
 
 #ifdef DEBUG
-	printk(KERN_DEBUG "%s: %s: 0x%02x\n", drive->name, s->all);
+	printk(KERN_DEBUG "%s: %s: 0x%02x\n", drive->name,
+		drive->special_flags);
 #endif
 	if (drive->media != ide_disk) {
-		s->all = 0;
+		drive->special_flags = 0;
 		drive->mult_req = 0;
 		return ide_stopped;
 	}
@@ -209,14 +209,14 @@ static ide_startstop_t do_special(ide_dr
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.protocol = ATA_PROT_NODATA;
 
-	if (s->b.set_geometry) {
-		s->b.set_geometry = 0;
+	if (drive->special_flags & IDE_SFLAG_SET_GEOMETRY) {
+		drive->special_flags &= ~IDE_SFLAG_SET_GEOMETRY;
 		ide_tf_set_specify_cmd(drive, &cmd.tf);
-	} else if (s->b.recalibrate) {
-		s->b.recalibrate = 0;
+	} else if (drive->special_flags & IDE_SFLAG_RECALIBRATE) {
+		drive->special_flags &= ~IDE_SFLAG_RECALIBRATE;
 		ide_tf_set_restore_cmd(drive, &cmd.tf);
-	} else if (s->b.set_multmode) {
-		s->b.set_multmode = 0;
+	} else if (drive->special_flags & IDE_SFLAG_SET_MULTMODE) {
+		drive->special_flags &= ~IDE_SFLAG_SET_MULTMODE;
 		ide_tf_set_setmult_cmd(drive, &cmd.tf);
 	} else
 		BUG();
@@ -339,7 +339,8 @@ static ide_startstop_t start_request (id
 		printk(KERN_ERR "%s: drive not ready for command\n", drive->name);
 		return startstop;
 	}
-	if (!drive->special.all) {
+
+	if (drive->special_flags == 0) {
 		struct ide_driver *drv;
 
 		/*
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -97,7 +97,7 @@ static void ide_disk_init_mult_count(ide
 		drive->mult_req = id[ATA_ID_MULTSECT] & 0xff;
 
 		if (drive->mult_req)
-			drive->special.b.set_multmode = 1;
+			drive->special_flags |= IDE_SFLAG_SET_MULTMODE;
 	}
 }
 
@@ -1129,8 +1129,8 @@ static void ide_port_init_devices_data(i
 		drive->hwif			= hwif;
 		drive->ready_stat		= ATA_DRDY;
 		drive->bad_wstat		= BAD_W_STAT;
-		drive->special.b.recalibrate	= 1;
-		drive->special.b.set_geometry	= 1;
+		drive->special_flags		= IDE_SFLAG_RECALIBRATE |
+						  IDE_SFLAG_SET_GEOMETRY;
 		drive->name[0]			= 'h';
 		drive->name[1]			= 'd';
 		drive->name[2]			= 'a' + j;
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -166,7 +166,7 @@ static ide_startstop_t task_no_data_intr
 	if (!OK_STAT(stat, ATA_DRDY, BAD_STAT)) {
 		if (custom && tf->command == ATA_CMD_SET_MULTI) {
 			drive->mult_req = drive->mult_count = 0;
-			drive->special.b.recalibrate = 1;
+			drive->special_flags |= IDE_SFLAG_RECALIBRATE;
 			(void)ide_dump_status(drive, __func__, stat);
 			return ide_stopped;
 		} else if (custom && tf->command == ATA_CMD_INIT_DEV_PARAMS) {
Index: b/drivers/ide/siimage.c
===================================================================
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -451,8 +451,8 @@ static int sil_sata_reset_poll(ide_drive
 static void sil_sata_pre_reset(ide_drive_t *drive)
 {
 	if (drive->media == ide_disk) {
-		drive->special.b.set_geometry = 0;
-		drive->special.b.recalibrate = 0;
+		drive->special_flags &=
+			~(IDE_SFLAG_SET_GEOMETRY | IDE_SFLAG_RECALIBRATE);
 	}
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -218,21 +218,12 @@ static inline void ide_std_init_ports(hw
 
 /*
  * Special Driver Flags
- *
- * set_geometry	: respecify drive geometry
- * recalibrate	: seek to cyl 0
- * set_multmode	: set multmode count
- * reserved	: unused
  */
-typedef union {
-	unsigned all			: 8;
-	struct {
-		unsigned set_geometry	: 1;
-		unsigned recalibrate	: 1;
-		unsigned set_multmode	: 1;
-		unsigned reserved	: 5;
-	} b;
-} special_t;
+enum {
+	IDE_SFLAG_SET_GEOMETRY		= (1 << 0),
+	IDE_SFLAG_RECALIBRATE		= (1 << 1),
+	IDE_SFLAG_SET_MULTMODE		= (1 << 2),
+};
 
 /*
  * Status returned from various ide_ functions
@@ -530,7 +521,7 @@ struct ide_drive_s {
 	unsigned long sleep;		/* sleep until this time */
 	unsigned long timeout;		/* max time to wait for irq */
 
-	special_t	special;	/* special action flags */
+	u8	special_flags;		/* special action flags */
 
 	u8	select;			/* basic drive/head select reg value */
 	u8	retry_pio;		/* retrying dma capable host in pio */
