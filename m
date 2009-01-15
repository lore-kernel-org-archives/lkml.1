Return-Path: <linux-kernel-owner+w=401wt.eu-S932946AbZAOUQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946AbZAOUQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765995AbZAOUAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:54 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:56109 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765939AbZAOUAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Xj3VtwcgUwexObxop95Wl7sqLt8Rd80lizLO0qNV3EL89+ghMEjUNIhDRtxkobmFdL
         vNR0GgRQCTv61Ci0R4EkvYwRGPlUlL9lzzVZ/qjSjQ3IqyDicz6iscLTnirheUEqtFQw
         CIxlryDqE+WOSzvISgAZqc+5X4caXolAkGW8g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2009 21:00:53 +0100
Message-Id: <20090115200053.17294.47740.sendpatchset@localhost.localdomain>
In-Reply-To: <20090115200032.17294.84745.sendpatchset@localhost.localdomain>
References: <20090115200032.17294.84745.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/9] ide: move drive_is_ready() to ide-io.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move drive_is_ready() to ide-io.c

Move drive_is_ready() to ide-io.c, then make it static.

Also make some minor CodingStyle fixups while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c   |   23 +++++++++++++++++++++++
 drivers/ide/ide-iops.c |   25 -------------------------
 include/linux/ide.h    |    2 --
 3 files changed, 23 insertions(+), 27 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -884,6 +884,29 @@ static void ide_plug_device(ide_drive_t 
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
+static int drive_is_ready(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 stat = 0;
+
+	if (drive->waiting_for_dma)
+		return hwif->dma_ops->dma_test_irq(drive);
+
+	if (hwif->io_ports.ctl_addr &&
+	    (hwif->host_flags & IDE_HFLAG_BROKEN_ALTSTATUS) == 0)
+		stat = hwif->tp_ops->read_altstatus(hwif);
+	else
+		/* Note: this may clear a pending IRQ!! */
+		stat = hwif->tp_ops->read_status(hwif);
+
+	if (stat & ATA_BUSY)
+		/* drive busy: definitely not interrupting */
+		return 0;
+
+	/* drive ready: *might* be interrupting */
+	return 1;
+}
+
 /**
  *	ide_timer_expiry	-	handle lack of an IDE interrupt
  *	@data: timer callback magic (hwif)
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -436,31 +436,6 @@ void ide_fixstring (u8 *s, const int byt
 
 EXPORT_SYMBOL(ide_fixstring);
 
-int drive_is_ready (ide_drive_t *drive)
-{
-	ide_hwif_t *hwif	= drive->hwif;
-	u8 stat			= 0;
-
-	if (drive->waiting_for_dma)
-		return hwif->dma_ops->dma_test_irq(drive);
-
-	if (hwif->io_ports.ctl_addr &&
-	    (hwif->host_flags & IDE_HFLAG_BROKEN_ALTSTATUS) == 0)
-		stat = hwif->tp_ops->read_altstatus(hwif);
-	else
-		/* Note: this may clear a pending IRQ!! */
-		stat = hwif->tp_ops->read_status(hwif);
-
-	if (stat & ATA_BUSY)
-		/* drive busy:  definitely not interrupting */
-		return 0;
-
-	/* drive ready: *might* be interrupting */
-	return 1;
-}
-
-EXPORT_SYMBOL(drive_is_ready);
-
 /*
  * This routine busy-waits for the drive status to be not "busy".
  * It then checks the status for all of the "good" bits and none
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1198,8 +1198,6 @@ void SELECT_MASK(ide_drive_t *, int);
 u8 ide_read_error(ide_drive_t *);
 void ide_read_bcount_and_ireason(ide_drive_t *, u16 *, u8 *);
 
-extern int drive_is_ready(ide_drive_t *);
-
 int ide_check_atapi_device(ide_drive_t *, const char *);
 
 void ide_init_pc(struct ide_atapi_pc *);
