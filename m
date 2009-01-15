Return-Path: <linux-kernel-owner+w=401wt.eu-S932935AbZAOUUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbZAOUUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932076AbZAOUBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:01:04 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:56109 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765858AbZAOUAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=W6gFZWBvjcVHWzbFZ8iWCKEYU7jO0iHVV7aBLnUcl3SRHWpZ3tw/4FbWbKNYP+YYwF
         KK7t4Lp1+ztYiyamkXOl+J9sSFzUWGmzHj8hkQl4BlQKfdalSJyPA2IDZt5UtfgB0dY7
         uwwZ8JfBA+RazTnmdRBnBJoqpjWianClHpqRI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2009 21:01:01 +0100
Message-Id: <20090115200101.17294.76431.sendpatchset@localhost.localdomain>
In-Reply-To: <20090115200032.17294.84745.sendpatchset@localhost.localdomain>
References: <20090115200032.17294.84745.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/9] ide: move ide_dma_timeout_retry() to ide-dma.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move ide_dma_timeout_retry() to ide-dma.c

Move ide_dma_timeout_retry() to ide-dma.c and add static inline
version for CONFIG_BLK_DEV_IDEDMA=n.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide-io.c  |   57 --------------------------------------------------
 include/linux/ide.h   |    2 +
 3 files changed, 59 insertions(+), 57 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -464,6 +464,63 @@ void ide_dma_timeout(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_dma_timeout);
 
+/*
+ * un-busy the port etc, and clear any pending DMA status. we want to
+ * retry the current request in pio mode instead of risking tossing it
+ * all away
+ */
+ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct request *rq;
+	ide_startstop_t ret = ide_stopped;
+
+	/*
+	 * end current dma transaction
+	 */
+
+	if (error < 0) {
+		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
+		(void)hwif->dma_ops->dma_end(drive);
+		ret = ide_error(drive, "dma timeout error",
+				hwif->tp_ops->read_status(hwif));
+	} else {
+		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
+		hwif->dma_ops->dma_timeout(drive);
+	}
+
+	/*
+	 * disable dma for now, but remember that we did so because of
+	 * a timeout -- we'll reenable after we finish this next request
+	 * (or rather the first chunk of it) in pio.
+	 */
+	drive->dev_flags |= IDE_DFLAG_DMA_PIO_RETRY;
+	drive->retry_pio++;
+	ide_dma_off_quietly(drive);
+
+	/*
+	 * un-busy drive etc and make sure request is sane
+	 */
+
+	rq = hwif->rq;
+	if (!rq)
+		goto out;
+
+	hwif->rq = NULL;
+
+	rq->errors = 0;
+
+	if (!rq->bio)
+		goto out;
+
+	rq->sector = rq->bio->bi_sector;
+	rq->current_nr_sectors = bio_iovec(rq->bio)->bv_len >> 9;
+	rq->hard_cur_sectors = rq->current_nr_sectors;
+	rq->buffer = bio_data(rq->bio);
+out:
+	return ret;
+}
+
 void ide_release_dma_engine(ide_hwif_t *hwif)
 {
 	if (hwif->dmatable_cpu) {
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -816,63 +816,6 @@ plug_device_2:
 		blk_plug_device(q);
 }
 
-/*
- * un-busy the port etc, and clear any pending DMA status. we want to
- * retry the current request in pio mode instead of risking tossing it
- * all away
- */
-static ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
-{
-	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq;
-	ide_startstop_t ret = ide_stopped;
-
-	/*
-	 * end current dma transaction
-	 */
-
-	if (error < 0) {
-		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
-		(void)hwif->dma_ops->dma_end(drive);
-		ret = ide_error(drive, "dma timeout error",
-				hwif->tp_ops->read_status(hwif));
-	} else {
-		printk(KERN_WARNING "%s: DMA timeout retry\n", drive->name);
-		hwif->dma_ops->dma_timeout(drive);
-	}
-
-	/*
-	 * disable dma for now, but remember that we did so because of
-	 * a timeout -- we'll reenable after we finish this next request
-	 * (or rather the first chunk of it) in pio.
-	 */
-	drive->dev_flags |= IDE_DFLAG_DMA_PIO_RETRY;
-	drive->retry_pio++;
-	ide_dma_off_quietly(drive);
-
-	/*
-	 * un-busy drive etc and make sure request is sane
-	 */
-
-	rq = hwif->rq;
-	if (!rq)
-		goto out;
-
-	hwif->rq = NULL;
-
-	rq->errors = 0;
-
-	if (!rq->bio)
-		goto out;
-
-	rq->sector = rq->bio->bi_sector;
-	rq->current_nr_sectors = bio_iovec(rq->bio)->bv_len >> 9;
-	rq->hard_cur_sectors = rq->current_nr_sectors;
-	rq->buffer = bio_data(rq->bio);
-out:
-	return ret;
-}
-
 static void ide_plug_device(ide_drive_t *drive)
 {
 	struct request_queue *q = drive->queue;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1465,6 +1465,7 @@ static inline int config_drive_for_dma(i
 
 void ide_dma_lost_irq(ide_drive_t *);
 void ide_dma_timeout(ide_drive_t *);
+ide_startstop_t ide_dma_timeout_retry(ide_drive_t *, int);
 
 #else
 static inline int ide_id_dma_bug(ide_drive_t *drive) { return 0; }
@@ -1476,6 +1477,7 @@ static inline void ide_dma_on(ide_drive_
 static inline void ide_dma_verbose(ide_drive_t *drive) { ; }
 static inline int ide_set_dma(ide_drive_t *drive) { return 1; }
 static inline void ide_check_dma_crc(ide_drive_t *drive) { ; }
+static inline ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error) { return ide_stopped; }
 static inline void ide_release_dma_engine(ide_hwif_t *hwif) { ; }
 #endif /* CONFIG_BLK_DEV_IDEDMA */
 
