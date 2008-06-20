Return-Path: <linux-kernel-owner+w=401wt.eu-S1763539AbYFTViN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763539AbYFTViN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 17:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761930AbYFTVdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 17:33:24 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:5898 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761905AbYFTVdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 17:33:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=CR6tlQx0C4nvUj+Hz914GfWKuvVumdxe25FwmcA5tT/csV9p7qbjdCdAjHsDQI7pHo
         Qpls4+dXREaBFhS1Pnw9+XM854TkGDYlRzRUqZyM9CR2Cquvm1Pm8xVIyRRM+RMv2YJm
         YaP1v13+3psGjkyX0UHXnyQ19K4I4x4Gf8Ujo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 23:35:18 +0200
Message-Id: <20080620213518.13202.56985.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain>
Subject: [PATCH 17/18] ide: add ide_read_bcount_and_ireason() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ide_read_bcount_and_ireason() helper and use it instead of ->INB
in {cdrom_newpc,ide_pc}_intr().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c |    6 ++----
 drivers/ide/ide-cd.c    |   12 ++++--------
 drivers/ide/ide-iops.c  |   15 +++++++++++++++
 include/linux/ide.h     |    1 +
 4 files changed, 22 insertions(+), 12 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -107,11 +107,9 @@ cmd_finished:
 		ide_dma_off(drive);
 		return ide_do_reset(drive);
 	}
-	/* Get the number of bytes to transfer on this interrupt. */
-	bcount = (hwif->INB(hwif->io_ports.lbah_addr) << 8) |
-		  hwif->INB(hwif->io_ports.lbam_addr);
 
-	ireason = hwif->INB(hwif->io_ports.nsect_addr);
+	/* Get the number of bytes to transfer on this interrupt. */
+	ide_read_bcount_and_ireason(drive, &bcount, &ireason);
 
 	if (ireason & CD) {
 		printk(KERN_ERR "%s: CoD != 0 in %s\n", drive->name, __func__);
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -923,10 +923,11 @@ static ide_startstop_t cdrom_newpc_intr(
 	struct request *rq = HWGROUP(drive)->rq;
 	xfer_func_t *xferfunc;
 	ide_expiry_t *expiry = NULL;
-	int dma_error = 0, dma, stat, ireason, len, thislen, uptodate = 0;
+	int dma_error = 0, dma, stat, thislen, uptodate = 0;
 	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0;
 	unsigned int timeout;
-	u8 lowcyl, highcyl;
+	u16 len;
+	u8 ireason;
 
 	/* check for errors */
 	dma = info->dma;
@@ -954,12 +955,7 @@ static ide_startstop_t cdrom_newpc_intr(
 		goto end_request;
 	}
 
-	/* ok we fall to pio :/ */
-	ireason = hwif->INB(hwif->io_ports.nsect_addr) & 0x3;
-	lowcyl  = hwif->INB(hwif->io_ports.lbam_addr);
-	highcyl = hwif->INB(hwif->io_ports.lbah_addr);
-
-	len = lowcyl + (256 * highcyl);
+	ide_read_bcount_and_ireason(drive, &len, &ireason);
 
 	thislen = blk_fs_request(rq) ? len : rq->data_len;
 	if (thislen > len)
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -405,6 +405,21 @@ u8 ide_read_error(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_read_error);
 
+void ide_read_bcount_and_ireason(ide_drive_t *drive, u16 *bcount, u8 *ireason)
+{
+	ide_task_t task;
+
+	memset(&task, 0, sizeof(task));
+	task.tf_flags = IDE_TFLAG_IN_LBAH | IDE_TFLAG_IN_LBAM |
+			IDE_TFLAG_IN_NSECT;
+
+	drive->hwif->tf_read(drive, &task);
+
+	*bcount = (task.tf.lbah << 8) | task.tf.lbam;
+	*ireason = task.tf.nsect & 3;
+}
+EXPORT_SYMBOL_GPL(ide_read_bcount_and_ireason);
+
 void ide_fix_driveid (struct hd_driveid *id)
 {
 #ifndef __LITTLE_ENDIAN
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -944,6 +944,7 @@ extern void SELECT_DRIVE(ide_drive_t *);
 void SELECT_MASK(ide_drive_t *, int);
 
 u8 ide_read_error(ide_drive_t *);
+void ide_read_bcount_and_ireason(ide_drive_t *, u16 *, u8 *);
 
 extern int drive_is_ready(ide_drive_t *);
 
