Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbYLGRWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbYLGRWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 12:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbYLGRV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 12:21:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:38089 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYLGRVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 12:21:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=YyEQP848PgXdju348im69cbi2hDMKsQTX0SaWmJ0H5tr4M00Ct5reDwiLHx25eoZhV
         TqCbqpRpoQ3ygIoIe3OM143cQi8iuW5QDZ0YojLOUB9giUQHXhcDyFTl/grKhFIQLy7h
         XrwVD7f3I3dvdJuxWqvj+TnfY2H+n8mJUFU3k=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 4/4] ide: remove the last ide-scsi remnants
Date: Sun,  7 Dec 2008 18:21:11 +0100
Message-Id: <1228670471-3435-5-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1228670471-3435-1-git-send-email-petkovbb@gmail.com>
References: <1228670471-3435-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c  |    3 +--
 drivers/ide/ide-io.c     |    3 ---
 drivers/ide/ide-ioctls.c |    3 +--
 drivers/ide/ide-probe.c  |    2 --
 include/linux/ide.h      |   28 +++++++++++++---------------
 5 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 7a04509..d412bd2 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -17,8 +17,7 @@
 
 static inline int dev_is_idecd(ide_drive_t *drive)
 {
-	return (drive->media == ide_cdrom || drive->media == ide_optical) &&
-		!(drive->dev_flags & IDE_DFLAG_SCSI);
+	return drive->media == ide_cdrom || drive->media == ide_optical;
 }
 
 /*
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 7743b0f..4136164 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -426,9 +426,6 @@ void ide_map_sg(ide_drive_t *drive, struct request *rq)
 	ide_hwif_t *hwif = drive->hwif;
 	struct scatterlist *sg = hwif->sg_table;
 
-	if (hwif->sg_mapped)	/* needed by ide-scsi */
-		return;
-
 	if (rq->cmd_type != REQ_TYPE_ATA_TASKFILE) {
 		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
 	} else {
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index 28232c6..1be263e 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -95,8 +95,7 @@ static int ide_set_nice_ioctl(ide_drive_t *drive, unsigned long arg)
 		return -EPERM;
 
 	if (((arg >> IDE_NICE_DSC_OVERLAP) & 1) &&
-	    (drive->media != ide_tape ||
-	     (drive->dev_flags & IDE_DFLAG_SCSI)))
+	    (drive->media != ide_tape))
 		return -EPERM;
 
 	if ((arg >> IDE_NICE_DSC_OVERLAP) & 1)
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 966b74c..c5adb7b 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1141,8 +1141,6 @@ static struct kobject *ata_probe(dev_t dev, int *part, void *data)
 
 	if (drive->media == ide_disk)
 		request_module("ide-disk");
-	if (drive->dev_flags & IDE_DFLAG_SCSI)
-		request_module("ide-scsi");
 	if (drive->media == ide_cdrom || drive->media == ide_optical)
 		request_module("ide-cd");
 	if (drive->media == ide_tape)
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 257524e..ad57a44 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -559,28 +559,26 @@ enum {
 	IDE_DFLAG_NODMA			= (1 << 16),
 	/* powermanagment told us not to do anything, so sleep nicely */
 	IDE_DFLAG_BLOCKED		= (1 << 17),
-	/* ide-scsi emulation */
-	IDE_DFLAG_SCSI			= (1 << 18),
 	/* sleeping & sleep field valid */
-	IDE_DFLAG_SLEEPING		= (1 << 19),
-	IDE_DFLAG_POST_RESET		= (1 << 20),
-	IDE_DFLAG_UDMA33_WARNED		= (1 << 21),
-	IDE_DFLAG_LBA48			= (1 << 22),
+	IDE_DFLAG_SLEEPING		= (1 << 18),
+	IDE_DFLAG_POST_RESET		= (1 << 19),
+	IDE_DFLAG_UDMA33_WARNED		= (1 << 20),
+	IDE_DFLAG_LBA48			= (1 << 21),
 	/* status of write cache */
-	IDE_DFLAG_WCACHE		= (1 << 23),
+	IDE_DFLAG_WCACHE		= (1 << 22),
 	/* used for ignoring ATA_DF */
-	IDE_DFLAG_NOWERR		= (1 << 24),
+	IDE_DFLAG_NOWERR		= (1 << 23),
 	/* retrying in PIO */
-	IDE_DFLAG_DMA_PIO_RETRY		= (1 << 25),
-	IDE_DFLAG_LBA			= (1 << 26),
+	IDE_DFLAG_DMA_PIO_RETRY		= (1 << 24),
+	IDE_DFLAG_LBA			= (1 << 25),
 	/* don't unload heads */
-	IDE_DFLAG_NO_UNLOAD		= (1 << 27),
+	IDE_DFLAG_NO_UNLOAD		= (1 << 26),
 	/* heads unloaded, please don't reset port */
-	IDE_DFLAG_PARKED		= (1 << 28),
-	IDE_DFLAG_MEDIA_CHANGED		= (1 << 29),
+	IDE_DFLAG_PARKED		= (1 << 27),
+	IDE_DFLAG_MEDIA_CHANGED		= (1 << 28),
 	/* write protect */
-	IDE_DFLAG_WP			= (1 << 30),
-	IDE_DFLAG_FORMAT_IN_PROGRESS	= (1 << 31),
+	IDE_DFLAG_WP			= (1 << 29),
+	IDE_DFLAG_FORMAT_IN_PROGRESS	= (1 << 30),
 };
 
 struct ide_drive_s {
-- 
1.6.0.4

