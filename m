Return-Path: <linux-kernel-owner+w=401wt.eu-S1756976AbZBRTWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbZBRTWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:22:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbZBRTVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:21:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:15421 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbZBRTVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:21:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=E486A/MSmWDICxAVuFB1hXpmf+6wBiEcAizwShThkvr3O0UumUE4Tyriw25BVvtI/9
         FHLIRHfb7amuBIitpMamLEgLIoW/XwXml2IZzSCodzQgKWhb3fg9hGsh2KUWK7IEMyac
         GlY9gxD8Z3x0p/nLwEPkTg6Aajkz1+AEv3Qmg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide-cd: minor ide_cdrom_setup() cleanup
Date: Wed, 18 Feb 2009 20:19:33 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-next-20090218; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902182019.33997.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: minor ide_cdrom_setup() cleanup

Cache drive->queue in local variable and use max().

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1579,18 +1579,18 @@ static int ide_cdrom_setup(ide_drive_t *
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct cdrom_device_info *cdi = &cd->devinfo;
+	struct request_queue *q = drive->queue;
 	u16 *id = drive->id;
 	char *fw_rev = (char *)&id[ATA_ID_FW_REV];
 	int nslots;
 
 	ide_debug_log(IDE_DBG_PROBE, "enter");
 
-	blk_queue_prep_rq(drive->queue, ide_cdrom_prep_fn);
-	blk_queue_dma_alignment(drive->queue, 31);
-	blk_queue_update_dma_pad(drive->queue, 15);
-	drive->queue->unplug_delay = (1 * HZ) / 1000;
-	if (!drive->queue->unplug_delay)
-		drive->queue->unplug_delay = 1;
+	blk_queue_prep_rq(q, ide_cdrom_prep_fn);
+	blk_queue_dma_alignment(q, 31);
+	blk_queue_update_dma_pad(q, 15);
+
+	q->unplug_delay = max((1 * HZ) / 1000, 1);
 
 	drive->dev_flags |= IDE_DFLAG_MEDIA_CHANGED;
 	drive->atapi_flags = IDE_AFLAG_NO_EJECT | ide_cd_flags(id);
@@ -1608,8 +1608,7 @@ static int ide_cdrom_setup(ide_drive_t *
 
 	nslots = ide_cdrom_probe_capabilities(drive);
 
-	/* set correct block size */
-	blk_queue_hardsect_size(drive->queue, CD_FRAMESIZE);
+	blk_queue_hardsect_size(q, CD_FRAMESIZE);
 
 	if (ide_cdrom_register(drive, nslots)) {
 		printk(KERN_ERR PFX "%s: %s failed to register device with the"
