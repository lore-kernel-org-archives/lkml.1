Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbYLMXm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbYLMXm1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYLMXk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:40:28 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:43312 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbYLMXkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:40:21 -0500
X-Greylist: delayed 1261 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Dec 2008 18:39:41 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pzqMYfFc+GbnMKdycVpobmBMscWDIweAy29GE2zplB/frUOGnqk7YQMUEUkOws8mht
         CJRiM55D/cLIG3/jOwYBOuWpkxRI+ECWerYDsHYOYsLdz6Xs7p2nbXLLJR5PO0g9GURp
         gZZ/oonaxf17ZCjn6JsVJMu2ZiitoS1O1Xo/c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 14 Dec 2008 00:40:05 +0100
Message-Id: <20081213234005.4653.60772.sendpatchset@localhost.localdomain>
In-Reply-To: <20081213233925.4653.58008.sendpatchset@localhost.localdomain>
References: <20081213233925.4653.58008.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/6] ide: merge ide_hwgroup_t with ide_hwif_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: merge ide_hwgroup_t with ide_hwif_t

* Merge ide_hwgroup_t with ide_hwif_t.

* Cleanup init_irq() accordingly, then remove no longer needed
  ide_remove_port_from_hwgroup() and ide_ports[].

* Remove now unused HWGROUP() macro.

While at it:

* ide_dump_ata_error() fixups

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/alim15x3.c     |    2 
 drivers/ide/au1xxx-ide.c   |    6 +-
 drivers/ide/icside.c       |    2 
 drivers/ide/ide-atapi.c    |    8 +--
 drivers/ide/ide-cd.c       |   16 ++----
 drivers/ide/ide-dma-sff.c  |    4 -
 drivers/ide/ide-dma.c      |    2 
 drivers/ide/ide-floppy.c   |    2 
 drivers/ide/ide-io.c       |  117 ++++++++++++++++++++++-----------------------
 drivers/ide/ide-iops.c     |   67 +++++++++++--------------
 drivers/ide/ide-lib.c      |    9 ++-
 drivers/ide/ide-park.c     |   16 +++---
 drivers/ide/ide-pm.c       |    2 
 drivers/ide/ide-probe.c    |   87 +++++----------------------------
 drivers/ide/ide-tape.c     |    9 +--
 drivers/ide/ide-taskfile.c |    4 -
 drivers/ide/ide.c          |    7 --
 drivers/ide/pdc202xx_old.c |    2 
 drivers/ide/pmac.c         |    2 
 drivers/ide/scc_pata.c     |    4 -
 drivers/ide/sgiioc4.c      |    2 
 drivers/ide/tc86c001.c     |   10 +--
 drivers/ide/trm290.c       |    2 
 drivers/ide/tx4939ide.c    |    2 
 drivers/ide/umc8672.c      |   13 ++---
 include/linux/ide.h        |   55 +++++++++------------
 26 files changed, 187 insertions(+), 265 deletions(-)

Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -198,7 +198,7 @@ static void ali_set_dma_mode(ide_drive_t
 static int ali15x3_dma_setup(ide_drive_t *drive)
 {
 	if (m5229_revision < 0xC2 && drive->media != ide_disk) {
-		if (rq_data_dir(drive->hwif->hwgroup->rq))
+		if (rq_data_dir(drive->hwif->rq))
 			return 1;	/* try PIO instead of DMA */
 	}
 	return ide_dma_setup(drive);
Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -213,7 +213,7 @@ static int auide_build_dmatable(ide_driv
 {
 	int i, iswrite, count = 0;
 	ide_hwif_t *hwif = HWIF(drive);
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = hwif->rq;
 	_auide_hwif *ahwif = &auide_hwif;
 	struct scatterlist *sg;
 
@@ -309,8 +309,8 @@ static void auide_dma_exec_cmd(ide_drive
 }
 
 static int auide_dma_setup(ide_drive_t *drive)
-{       	
-	struct request *rq = HWGROUP(drive)->rq;
+{
+	struct request *rq = drive->hwif->rq;
 
 	if (!auide_build_dmatable(drive)) {
 		ide_map_sg(drive, rq);
Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -312,7 +312,7 @@ static int icside_dma_setup(ide_drive_t 
 	ide_hwif_t *hwif = HWIF(drive);
 	struct expansion_card *ec = ECARD_DEV(hwif->dev);
 	struct icside_state *state = ecard_get_drvdata(ec);
-	struct request *rq = hwif->hwgroup->rq;
+	struct request *rq = hwif->rq;
 	unsigned int dma_mode;
 
 	if (rq_data_dir(rq))
Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -241,7 +241,7 @@ EXPORT_SYMBOL_GPL(ide_retry_pc);
 
 int ide_cd_expiry(ide_drive_t *drive)
 {
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = drive->hwif->rq;
 	unsigned long wait = 0;
 
 	debug_log("%s: rq->cmd[0]: 0x%x\n", __func__, rq->cmd[0]);
@@ -292,7 +292,7 @@ static ide_startstop_t ide_pc_intr(ide_d
 {
 	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->hwgroup->rq;
+	struct request *rq = hwif->rq;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	xfer_func_t *xferfunc;
 	unsigned int timeout, temp;
@@ -489,7 +489,7 @@ static ide_startstop_t ide_transfer_pc(i
 {
 	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->hwgroup->rq;
+	struct request *rq = hwif->rq;
 	ide_expiry_t *expiry;
 	unsigned int timeout;
 	ide_startstop_t startstop;
@@ -560,7 +560,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 
 	if (dev_is_idecd(drive)) {
 		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
-		bcount = ide_cd_get_xferlen(hwif->hwgroup->rq);
+		bcount = ide_cd_get_xferlen(hwif->rq);
 		expiry = ide_cd_expiry;
 	} else {
 		tf_flags = IDE_TFLAG_OUT_DEVICE;
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -239,7 +239,7 @@ static void cdrom_queue_request_sense(id
 
 static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 {
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = drive->hwif->rq;
 	int nsectors = rq->hard_cur_sectors;
 
 	ide_debug_log(IDE_DBG_FUNC, "Call %s, cmd: 0x%x, uptodate: 0x%x, "
@@ -306,8 +306,7 @@ static void ide_dump_status_no_sense(ide
 static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
-	struct request *rq = hwgroup->rq;
+	struct request *rq = hwif->rq;
 	int stat, err, sense_key;
 
 	/* check for errors */
@@ -502,7 +501,7 @@ end_request:
 		blkdev_dequeue_request(rq);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 
-		hwgroup->rq = NULL;
+		hwif->rq = NULL;
 
 		cdrom_queue_request_sense(drive, rq->sense, rq);
 	} else
@@ -728,7 +727,7 @@ static ide_startstop_t ide_cd_prepare_rw
  */
 static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
 {
-	struct request *rq = drive->hwif->hwgroup->rq;
+	struct request *rq = drive->hwif->rq;
 
 	/* send the command to the drive and return */
 	return cdrom_transfer_packet_command(drive, rq, cdrom_newpc_intr);
@@ -865,8 +864,7 @@ static int cdrom_newpc_intr_dummy_cb(str
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
-	struct request *rq = hwgroup->rq;
+	struct request *rq = hwif->rq;
 	xfer_func_t *xferfunc;
 	ide_expiry_t *expiry = NULL;
 	int dma_error = 0, dma, stat, thislen, uptodate = 0;
@@ -1072,7 +1070,7 @@ end_request:
 		if (blk_end_request(rq, 0, dlen))
 			BUG();
 
-		hwgroup->rq = NULL;
+		hwif->rq = NULL;
 	} else {
 		if (!uptodate)
 			rq->cmd_flags |= REQ_FAILED;
@@ -1125,7 +1123,7 @@ static ide_startstop_t cdrom_start_rw(id
 
 static ide_startstop_t cdrom_do_newpc_cont(ide_drive_t *drive)
 {
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = drive->hwif->rq;
 
 	return cdrom_transfer_packet_command(drive, rq, cdrom_newpc_intr);
 }
Index: b/drivers/ide/ide-dma-sff.c
===================================================================
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -175,7 +175,7 @@ EXPORT_SYMBOL_GPL(ide_build_dmatable);
 int ide_dma_setup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->hwgroup->rq;
+	struct request *rq = hwif->rq;
 	unsigned int reading = rq_data_dir(rq) ? 0 : ATA_DMA_WR;
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 	u8 dma_stat;
@@ -240,7 +240,7 @@ static int dma_timer_expiry(ide_drive_t 
 	if ((dma_stat & 0x18) == 0x18)	/* BUSY Stupid Early Timer !! */
 		return WAIT_CMD;
 
-	hwif->hwgroup->expiry = NULL;	/* one free ride for now */
+	hwif->expiry = NULL;	/* one free ride for now */
 
 	if (dma_stat & ATA_DMA_ERR)	/* ERROR */
 		return -1;
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -96,7 +96,7 @@ ide_startstop_t ide_dma_intr(ide_drive_t
 
 	if (OK_STAT(stat, DRIVE_READY, drive->bad_wstat | ATA_DRQ)) {
 		if (!dma_stat) {
-			struct request *rq = hwif->hwgroup->rq;
+			struct request *rq = hwif->rq;
 
 			task_end_request(drive, rq, stat);
 			return ide_stopped;
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -71,7 +71,7 @@
 static int ide_floppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = drive->hwif->rq;
 	int error;
 
 	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -88,7 +88,7 @@ static int __ide_end_request(ide_drive_t
 		ret = 0;
 
 	if (ret == 0 && dequeue)
-		drive->hwif->hwgroup->rq = NULL;
+		drive->hwif->rq = NULL;
 
 	return ret;
 }
@@ -107,7 +107,7 @@ static int __ide_end_request(ide_drive_t
 int ide_end_request (ide_drive_t *drive, int uptodate, int nr_sectors)
 {
 	unsigned int nr_bytes = nr_sectors << 9;
-	struct request *rq = drive->hwif->hwgroup->rq;
+	struct request *rq = drive->hwif->rq;
 
 	if (!nr_bytes) {
 		if (blk_pc_request(rq))
@@ -160,8 +160,8 @@ EXPORT_SYMBOL_GPL(ide_end_dequeued_reque
  
 void ide_end_drive_cmd (ide_drive_t *drive, u8 stat, u8 err)
 {
-	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
-	struct request *rq = hwgroup->rq;
+	ide_hwif_t *hwif = drive->hwif;
+	struct request *rq = hwif->rq;
 
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		ide_task_t *task = (ide_task_t *)rq->special;
@@ -186,7 +186,7 @@ void ide_end_drive_cmd (ide_drive_t *dri
 		return;
 	}
 
-	hwgroup->rq = NULL;
+	hwif->rq = NULL;
 
 	rq->errors = err;
 
@@ -321,7 +321,8 @@ ide_startstop_t ide_error (ide_drive_t *
 
 	err = ide_dump_status(drive, msg, stat);
 
-	if ((rq = HWGROUP(drive)->rq) == NULL)
+	rq = drive->hwif->rq;
+	if (rq == NULL)
 		return ide_stopped;
 
 	/* retry only "normal" I/O: */
@@ -654,7 +655,7 @@ kill_rq:
  *	@timeout: time to stall for (jiffies)
  *
  *	ide_stall_queue() can be used by a drive to give excess bandwidth back
- *	to the hwgroup by sleeping for timeout jiffies.
+ *	to the port by sleeping for timeout jiffies.
  */
  
 void ide_stall_queue (ide_drive_t *drive, unsigned long timeout)
@@ -689,14 +690,13 @@ static inline void ide_unlock_host(struc
 }
 
 /*
- * Issue a new request to a drive from hwgroup
+ * Issue a new request to a device.
  */
 void do_ide_request(struct request_queue *q)
 {
 	ide_drive_t	*drive = q->queuedata;
 	ide_hwif_t	*hwif = drive->hwif;
 	struct ide_host *host = hwif->host;
-	ide_hwgroup_t	*hwgroup = hwif->hwgroup;
 	struct request	*rq;
 	ide_startstop_t	startstop;
 
@@ -718,13 +718,13 @@ void do_ide_request(struct request_queue
 	if (ide_lock_host(host, hwif))
 		goto plug_device_2;
 
-	spin_lock_irq(&hwgroup->lock);
+	spin_lock_irq(&hwif->lock);
 
 	if (1) {
 		ide_hwif_t *prev_port;
 repeat:
 		prev_port = hwif->host->cur_port;
-		hwgroup->rq = NULL;
+		hwif->rq = NULL;
 
 		if (drive->dev_flags & IDE_DFLAG_SLEEPING) {
 			if (time_before(drive->sleep, jiffies)) {
@@ -739,15 +739,15 @@ repeat:
 			 * set nIEN for previous port, drives in the
 			 * quirk_list may not like intr setups/cleanups
 			 */
-			if (prev_port && hwgroup->cur_dev->quirk_list == 0)
+			if (prev_port && hwif->cur_dev->quirk_list == 0)
 				prev_port->tp_ops->set_irq(prev_port, 0);
 
 			hwif->host->cur_port = hwif;
 		}
-		hwgroup->cur_dev = drive;
+		hwif->cur_dev = drive;
 		drive->dev_flags &= ~(IDE_DFLAG_SLEEPING | IDE_DFLAG_PARKED);
 
-		spin_unlock_irq(&hwgroup->lock);
+		spin_unlock_irq(&hwif->lock);
 		spin_lock_irq(q->queue_lock);
 		/*
 		 * we know that the queue isn't empty, but this can happen
@@ -755,7 +755,7 @@ repeat:
 		 */
 		rq = elv_next_request(drive->queue);
 		spin_unlock_irq(q->queue_lock);
-		spin_lock_irq(&hwgroup->lock);
+		spin_lock_irq(&hwif->lock);
 
 		if (!rq) {
 			ide_unlock_host(host);
@@ -783,22 +783,22 @@ repeat:
 			goto plug_device;
 		}
 
-		hwgroup->rq = rq;
+		hwif->rq = rq;
 
-		spin_unlock_irq(&hwgroup->lock);
+		spin_unlock_irq(&hwif->lock);
 		startstop = start_request(drive, rq);
-		spin_lock_irq(&hwgroup->lock);
+		spin_lock_irq(&hwif->lock);
 
 		if (startstop == ide_stopped)
 			goto repeat;
 	}
 out:
-	spin_unlock_irq(&hwgroup->lock);
+	spin_unlock_irq(&hwif->lock);
 	spin_lock_irq(q->queue_lock);
 	return;
 
 plug_device:
-	spin_unlock_irq(&hwgroup->lock);
+	spin_unlock_irq(&hwif->lock);
 plug_device_2:
 	spin_lock_irq(q->queue_lock);
 
@@ -807,7 +807,7 @@ plug_device_2:
 }
 
 /*
- * un-busy the hwgroup etc, and clear any pending DMA status. we want to
+ * un-busy the port etc, and clear any pending DMA status. we want to
  * retry the current request in pio mode instead of risking tossing it
  * all away
  */
@@ -844,12 +844,11 @@ static ide_startstop_t ide_dma_timeout_r
 	 * un-busy drive etc and make sure request is sane
 	 */
 
-	rq = HWGROUP(drive)->rq;
-
+	rq = hwif->rq;
 	if (!rq)
 		goto out;
 
-	HWGROUP(drive)->rq = NULL;
+	hwif->rq = NULL;
 
 	rq->errors = 0;
 
@@ -877,7 +876,7 @@ static void ide_plug_device(ide_drive_t 
 
 /**
  *	ide_timer_expiry	-	handle lack of an IDE interrupt
- *	@data: timer callback magic (hwgroup)
+ *	@data: timer callback magic (hwif)
  *
  *	An IDE command has timed out before the expected drive return
  *	occurred. At this point we attempt to clean up the current
@@ -891,18 +890,18 @@ static void ide_plug_device(ide_drive_t 
  
 void ide_timer_expiry (unsigned long data)
 {
-	ide_hwgroup_t	*hwgroup = (ide_hwgroup_t *) data;
+	ide_hwif_t	*hwif = (ide_hwif_t *)data;
 	ide_drive_t	*uninitialized_var(drive);
 	ide_handler_t	*handler;
-	ide_expiry_t	*expiry;
 	unsigned long	flags;
 	unsigned long	wait = -1;
 	int		plug_device = 0;
 
-	spin_lock_irqsave(&hwgroup->lock, flags);
+	spin_lock_irqsave(&hwif->lock, flags);
+
+	handler = hwif->handler;
 
-	if (((handler = hwgroup->handler) == NULL) ||
-	    (hwgroup->req_gen != hwgroup->req_gen_timer)) {
+	if (handler == NULL || hwif->req_gen != hwif->req_gen_timer) {
 		/*
 		 * Either a marginal timeout occurred
 		 * (got the interrupt just as timer expired),
@@ -910,39 +909,39 @@ void ide_timer_expiry (unsigned long dat
 		 * Either way, we don't really want to complain about anything.
 		 */
 	} else {
-		drive = hwgroup->cur_dev;
+		drive = hwif->cur_dev;
 		if (!drive) {
 			printk(KERN_ERR "%s: ->cur_dev was NULL\n", __func__);
-			hwgroup->handler = NULL;
+			hwif->handler = NULL;
 		} else {
-			ide_hwif_t *hwif;
+			ide_expiry_t *expiry = hwif->expiry;
 			ide_startstop_t startstop = ide_stopped;
 
-			if ((expiry = hwgroup->expiry) != NULL) {
+			if (expiry) {
 				/* continue */
 				if ((wait = expiry(drive)) > 0) {
 					/* reset timer */
-					hwgroup->timer.expires  = jiffies + wait;
-					hwgroup->req_gen_timer = hwgroup->req_gen;
-					add_timer(&hwgroup->timer);
-					spin_unlock_irqrestore(&hwgroup->lock, flags);
+					hwif->timer.expires  = jiffies + wait;
+					hwif->req_gen_timer = hwif->req_gen;
+					add_timer(&hwif->timer);
+					spin_unlock_irqrestore(&hwif->lock, flags);
 					return;
 				}
 			}
-			hwgroup->handler = NULL;
+			hwif->handler = NULL;
 			/*
 			 * We need to simulate a real interrupt when invoking
 			 * the handler() function, which means we need to
 			 * globally mask the specific IRQ:
 			 */
-			spin_unlock(&hwgroup->lock);
+			spin_unlock(&hwif->lock);
 			hwif  = HWIF(drive);
 			/* disable_irq_nosync ?? */
 			disable_irq(hwif->irq);
 			/* local CPU only,
 			 * as if we were handling an interrupt */
 			local_irq_disable();
-			if (hwgroup->polling) {
+			if (hwif->polling) {
 				startstop = handler(drive);
 			} else if (drive_is_ready(drive)) {
 				if (drive->waiting_for_dma)
@@ -958,7 +957,7 @@ void ide_timer_expiry (unsigned long dat
 					ide_error(drive, "irq timeout",
 						  hwif->tp_ops->read_status(hwif));
 			}
-			spin_lock_irq(&hwgroup->lock);
+			spin_lock_irq(&hwif->lock);
 			enable_irq(hwif->irq);
 			if (startstop == ide_stopped) {
 				ide_unlock_host(hwif->host);
@@ -966,7 +965,7 @@ void ide_timer_expiry (unsigned long dat
 			}
 		}
 	}
-	spin_unlock_irqrestore(&hwgroup->lock, flags);
+	spin_unlock_irqrestore(&hwif->lock, flags);
 
 	if (plug_device)
 		ide_plug_device(drive);
@@ -1030,7 +1029,7 @@ static void unexpected_intr(int irq, ide
  *	places
  *
  *	hwif is the interface in the group currently performing
- *	a command. hwgroup->cur_dev is the drive and hwgroup->handler is
+ *	a command. hwif->cur_dev is the drive and hwif->handler is
  *	the IRQ handler to call. As we issue a command the handlers
  *	step through multiple states, reassigning the handler to the
  *	next step in the process. Unlike a smart SCSI controller IDE
@@ -1041,13 +1040,12 @@ static void unexpected_intr(int irq, ide
  *
  *	The handler eventually returns ide_stopped to indicate the
  *	request completed. At this point we issue the next request
- *	on the hwgroup and the process begins again.
+ *	on the port and the process begins again.
  */
- 
+
 irqreturn_t ide_intr (int irq, void *dev_id)
 {
 	ide_hwif_t *hwif = (ide_hwif_t *)dev_id;
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 	ide_drive_t *uninitialized_var(drive);
 	ide_handler_t *handler;
 	unsigned long flags;
@@ -1060,12 +1058,14 @@ irqreturn_t ide_intr (int irq, void *dev
 			goto out_early;
 	}
 
-	spin_lock_irqsave(&hwgroup->lock, flags);
+	spin_lock_irqsave(&hwif->lock, flags);
 
 	if (!ide_ack_intr(hwif))
 		goto out;
 
-	if ((handler = hwgroup->handler) == NULL || hwgroup->polling) {
+	handler = hwif->handler;
+
+	if (handler == NULL || hwif->polling) {
 		/*
 		 * Not expecting an interrupt from this drive.
 		 * That means this could be:
@@ -1102,7 +1102,7 @@ irqreturn_t ide_intr (int irq, void *dev
 		goto out;
 	}
 
-	drive = hwgroup->cur_dev;
+	drive = hwif->cur_dev;
 	if (!drive) {
 		/*
 		 * This should NEVER happen, and there isn't much
@@ -1123,10 +1123,10 @@ irqreturn_t ide_intr (int irq, void *dev
 		 */
 		goto out;
 
-	hwgroup->handler = NULL;
-	hwgroup->req_gen++;
-	del_timer(&hwgroup->timer);
-	spin_unlock(&hwgroup->lock);
+	hwif->handler = NULL;
+	hwif->req_gen++;
+	del_timer(&hwif->timer);
+	spin_unlock(&hwif->lock);
 
 	if (hwif->port_ops && hwif->port_ops->clear_irq)
 		hwif->port_ops->clear_irq(drive);
@@ -1137,7 +1137,7 @@ irqreturn_t ide_intr (int irq, void *dev
 	/* service this interrupt, may set handler for next interrupt */
 	startstop = handler(drive);
 
-	spin_lock_irq(&hwgroup->lock);
+	spin_lock_irq(&hwif->lock);
 	/*
 	 * Note that handler() may have set things up for another
 	 * interrupt to occur soon, but it cannot happen until
@@ -1146,7 +1146,7 @@ irqreturn_t ide_intr (int irq, void *dev
 	 * won't allow another of the same (on any CPU) until we return.
 	 */
 	if (startstop == ide_stopped) {
-		if (hwgroup->handler == NULL) {	/* paranoia */
+		if (hwif->handler == NULL) {	/* paranoia */
 			ide_unlock_host(hwif->host);
 			plug_device = 1;
 		} else
@@ -1156,7 +1156,7 @@ irqreturn_t ide_intr (int irq, void *dev
 out_handled:
 	irq_ret = IRQ_HANDLED;
 out:
-	spin_unlock_irqrestore(&hwgroup->lock, flags);
+	spin_unlock_irqrestore(&hwif->lock, flags);
 out_early:
 	if (plug_device)
 		ide_plug_device(drive);
@@ -1181,11 +1181,10 @@ out_early:
 
 void ide_do_drive_cmd(ide_drive_t *drive, struct request *rq)
 {
-	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
 	struct request_queue *q = drive->queue;
 	unsigned long flags;
 
-	hwgroup->rq = NULL;
+	drive->hwif->rq = NULL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	__elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 0);
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -822,25 +822,25 @@ int ide_config_drive_speed(ide_drive_t *
 static void __ide_set_handler (ide_drive_t *drive, ide_handler_t *handler,
 		      unsigned int timeout, ide_expiry_t *expiry)
 {
-	ide_hwgroup_t *hwgroup = HWGROUP(drive);
+	ide_hwif_t *hwif = drive->hwif;
 
-	BUG_ON(hwgroup->handler);
-	hwgroup->handler	= handler;
-	hwgroup->expiry		= expiry;
-	hwgroup->timer.expires	= jiffies + timeout;
-	hwgroup->req_gen_timer	= hwgroup->req_gen;
-	add_timer(&hwgroup->timer);
+	BUG_ON(hwif->handler);
+	hwif->handler		= handler;
+	hwif->expiry		= expiry;
+	hwif->timer.expires	= jiffies + timeout;
+	hwif->req_gen_timer	= hwif->req_gen;
+	add_timer(&hwif->timer);
 }
 
 void ide_set_handler (ide_drive_t *drive, ide_handler_t *handler,
 		      unsigned int timeout, ide_expiry_t *expiry)
 {
-	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned long flags;
 
-	spin_lock_irqsave(&hwgroup->lock, flags);
+	spin_lock_irqsave(&hwif->lock, flags);
 	__ide_set_handler(drive, handler, timeout, expiry);
-	spin_unlock_irqrestore(&hwgroup->lock, flags);
+	spin_unlock_irqrestore(&hwif->lock, flags);
 }
 
 EXPORT_SYMBOL(ide_set_handler);
@@ -863,10 +863,9 @@ void ide_execute_command(ide_drive_t *dr
 			 unsigned timeout, ide_expiry_t *expiry)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 	unsigned long flags;
 
-	spin_lock_irqsave(&hwgroup->lock, flags);
+	spin_lock_irqsave(&hwif->lock, flags);
 	__ide_set_handler(drive, handler, timeout, expiry);
 	hwif->tp_ops->exec_command(hwif, cmd);
 	/*
@@ -876,26 +875,25 @@ void ide_execute_command(ide_drive_t *dr
 	 * FIXME: we could skip this delay with care on non shared devices
 	 */
 	ndelay(400);
-	spin_unlock_irqrestore(&hwgroup->lock, flags);
+	spin_unlock_irqrestore(&hwif->lock, flags);
 }
 EXPORT_SYMBOL(ide_execute_command);
 
 void ide_execute_pkt_cmd(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 	unsigned long flags;
 
-	spin_lock_irqsave(&hwgroup->lock, flags);
+	spin_lock_irqsave(&hwif->lock, flags);
 	hwif->tp_ops->exec_command(hwif, ATA_CMD_PACKET);
 	ndelay(400);
-	spin_unlock_irqrestore(&hwgroup->lock, flags);
+	spin_unlock_irqrestore(&hwif->lock, flags);
 }
 EXPORT_SYMBOL_GPL(ide_execute_pkt_cmd);
 
 static inline void ide_complete_drive_reset(ide_drive_t *drive, int err)
 {
-	struct request *rq = drive->hwif->hwgroup->rq;
+	struct request *rq = drive->hwif->rq;
 
 	if (rq && blk_special_request(rq) && rq->cmd[0] == REQ_DRIVE_RESET)
 		ide_end_request(drive, err ? err : 1, 0);
@@ -913,7 +911,6 @@ static ide_startstop_t do_reset1 (ide_dr
 static ide_startstop_t atapi_reset_pollfunc (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 	u8 stat;
 
 	SELECT_DRIVE(drive);
@@ -923,20 +920,20 @@ static ide_startstop_t atapi_reset_pollf
 	if (OK_STAT(stat, 0, ATA_BUSY))
 		printk("%s: ATAPI reset complete\n", drive->name);
 	else {
-		if (time_before(jiffies, hwgroup->poll_timeout)) {
+		if (time_before(jiffies, hwif->poll_timeout)) {
 			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20, NULL);
 			/* continue polling */
 			return ide_started;
 		}
 		/* end of polling */
-		hwgroup->polling = 0;
+		hwif->polling = 0;
 		printk("%s: ATAPI reset timed-out, status=0x%02x\n",
 				drive->name, stat);
 		/* do it the old fashioned way */
 		return do_reset1(drive, 1);
 	}
 	/* done polling */
-	hwgroup->polling = 0;
+	hwif->polling = 0;
 	ide_complete_drive_reset(drive, 0);
 	return ide_stopped;
 }
@@ -968,7 +965,6 @@ static void ide_reset_report_error(ide_h
  */
 static ide_startstop_t reset_pollfunc (ide_drive_t *drive)
 {
-	ide_hwgroup_t *hwgroup	= HWGROUP(drive);
 	ide_hwif_t *hwif	= HWIF(drive);
 	const struct ide_port_ops *port_ops = hwif->port_ops;
 	u8 tmp;
@@ -986,7 +982,7 @@ static ide_startstop_t reset_pollfunc (i
 	tmp = hwif->tp_ops->read_status(hwif);
 
 	if (!OK_STAT(tmp, 0, ATA_BUSY)) {
-		if (time_before(jiffies, hwgroup->poll_timeout)) {
+		if (time_before(jiffies, hwif->poll_timeout)) {
 			ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
 			/* continue polling */
 			return ide_started;
@@ -1007,7 +1003,7 @@ static ide_startstop_t reset_pollfunc (i
 		}
 	}
 out:
-	hwgroup->polling = 0;	/* done polling */
+	hwif->polling = 0;	/* done polling */
 	ide_complete_drive_reset(drive, err);
 	return ide_stopped;
 }
@@ -1081,7 +1077,6 @@ static void pre_reset(ide_drive_t *drive
 static ide_startstop_t do_reset1 (ide_drive_t *drive, int do_not_try_atapi)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	const struct ide_port_ops *port_ops;
@@ -1089,10 +1084,10 @@ static ide_startstop_t do_reset1 (ide_dr
 	unsigned int unit;
 	DEFINE_WAIT(wait);
 
-	spin_lock_irqsave(&hwgroup->lock, flags);
+	spin_lock_irqsave(&hwif->lock, flags);
 
 	/* We must not reset with running handlers */
-	BUG_ON(hwgroup->handler != NULL);
+	BUG_ON(hwif->handler != NULL);
 
 	/* For an ATAPI device, first try an ATAPI SRST. */
 	if (drive->media != ide_disk && !do_not_try_atapi) {
@@ -1101,10 +1096,10 @@ static ide_startstop_t do_reset1 (ide_dr
 		udelay (20);
 		tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
 		ndelay(400);
-		hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
-		hwgroup->polling = 1;
+		hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
+		hwif->polling = 1;
 		__ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20, NULL);
-		spin_unlock_irqrestore(&hwgroup->lock, flags);
+		spin_unlock_irqrestore(&hwif->lock, flags);
 		return ide_started;
 	}
 
@@ -1127,9 +1122,9 @@ static ide_startstop_t do_reset1 (ide_dr
 		if (time_before_eq(timeout, now))
 			break;
 
-		spin_unlock_irqrestore(&hwgroup->lock, flags);
+		spin_unlock_irqrestore(&hwif->lock, flags);
 		timeout = schedule_timeout_uninterruptible(timeout - now);
-		spin_lock_irqsave(&hwgroup->lock, flags);
+		spin_lock_irqsave(&hwif->lock, flags);
 	} while (timeout);
 	finish_wait(&ide_park_wq, &wait);
 
@@ -1141,7 +1136,7 @@ static ide_startstop_t do_reset1 (ide_dr
 		pre_reset(&hwif->drives[unit]);
 
 	if (io_ports->ctl_addr == 0) {
-		spin_unlock_irqrestore(&hwgroup->lock, flags);
+		spin_unlock_irqrestore(&hwif->lock, flags);
 		ide_complete_drive_reset(drive, -ENXIO);
 		return ide_stopped;
 	}
@@ -1164,8 +1159,8 @@ static ide_startstop_t do_reset1 (ide_dr
 	tp_ops->set_irq(hwif, drive->quirk_list == 2);
 	/* more than enough time */
 	udelay(10);
-	hwgroup->poll_timeout = jiffies + WAIT_WORSTCASE;
-	hwgroup->polling = 1;
+	hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
+	hwif->polling = 1;
 	__ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
 
 	/*
@@ -1177,7 +1172,7 @@ static ide_startstop_t do_reset1 (ide_dr
 	if (port_ops && port_ops->resetproc)
 		port_ops->resetproc(drive);
 
-	spin_unlock_irqrestore(&hwgroup->lock, flags);
+	spin_unlock_irqrestore(&hwif->lock, flags);
 	return ide_started;
 }
 
Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -273,7 +273,7 @@ int ide_set_xfer_rate(ide_drive_t *drive
 
 static void ide_dump_opcode(ide_drive_t *drive)
 {
-	struct request *rq = drive->hwif->hwgroup->rq;
+	struct request *rq = drive->hwif->rq;
 	ide_task_t *task = NULL;
 
 	if (!rq)
@@ -346,10 +346,13 @@ static void ide_dump_ata_error(ide_drive
 	printk(KERN_CONT "}");
 	if ((err & (ATA_BBK | ATA_ABORTED)) == ATA_BBK ||
 	    (err & (ATA_UNC | ATA_IDNF | ATA_AMNF))) {
+		struct request *rq = drive->hwif->rq;
+
 		ide_dump_sector(drive);
-		if (HWGROUP(drive) && HWGROUP(drive)->rq)
+
+		if (rq)
 			printk(KERN_CONT ", sector=%llu",
-			       (unsigned long long)HWGROUP(drive)->rq->sector);
+			       (unsigned long long)rq->sector);
 	}
 	printk(KERN_CONT "\n");
 }
Index: b/drivers/ide/ide-park.c
===================================================================
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -7,22 +7,22 @@ DECLARE_WAIT_QUEUE_HEAD(ide_park_wq);
 
 static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 {
-	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
+	ide_hwif_t *hwif = drive->hwif;
 	struct request_queue *q = drive->queue;
 	struct request *rq;
 	int rc;
 
 	timeout += jiffies;
-	spin_lock_irq(&hwgroup->lock);
+	spin_lock_irq(&hwif->lock);
 	if (drive->dev_flags & IDE_DFLAG_PARKED) {
 		int reset_timer = time_before(timeout, drive->sleep);
 		int start_queue = 0;
 
 		drive->sleep = timeout;
 		wake_up_all(&ide_park_wq);
-		if (reset_timer && del_timer(&hwgroup->timer))
+		if (reset_timer && del_timer(&hwif->timer))
 			start_queue = 1;
-		spin_unlock_irq(&hwgroup->lock);
+		spin_unlock_irq(&hwif->lock);
 
 		if (start_queue) {
 			spin_lock_irq(q->queue_lock);
@@ -31,7 +31,7 @@ static void issue_park_cmd(ide_drive_t *
 		}
 		return;
 	}
-	spin_unlock_irq(&hwgroup->lock);
+	spin_unlock_irq(&hwif->lock);
 
 	rq = blk_get_request(q, READ, __GFP_WAIT);
 	rq->cmd[0] = REQ_PARK_HEADS;
@@ -64,21 +64,21 @@ ssize_t ide_park_show(struct device *dev
 		      char *buf)
 {
 	ide_drive_t *drive = to_ide_device(dev);
-	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
+	ide_hwif_t *hwif = drive->hwif;
 	unsigned long now;
 	unsigned int msecs;
 
 	if (drive->dev_flags & IDE_DFLAG_NO_UNLOAD)
 		return -EOPNOTSUPP;
 
-	spin_lock_irq(&hwgroup->lock);
+	spin_lock_irq(&hwif->lock);
 	now = jiffies;
 	if (drive->dev_flags & IDE_DFLAG_PARKED &&
 	    time_after(drive->sleep, now))
 		msecs = jiffies_to_msecs(drive->sleep - now);
 	else
 		msecs = 0;
-	spin_unlock_irq(&hwgroup->lock);
+	spin_unlock_irq(&hwif->lock);
 
 	return snprintf(buf, 20, "%u\n", msecs);
 }
Index: b/drivers/ide/ide-pm.c
===================================================================
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -194,7 +194,7 @@ void ide_complete_pm_request(ide_drive_t
 	}
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	drive->hwif->hwgroup->rq = NULL;
+	drive->hwif->rq = NULL;
 
 	if (blk_end_request(rq, 0, 0))
 		BUG();
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -949,79 +949,20 @@ static int ide_port_setup_devices(ide_hw
 	return j;
 }
 
-static ide_hwif_t *ide_ports[MAX_HWIFS];
-
-void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
-{
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
-
-	ide_ports[hwif->index] = NULL;
-
-	spin_lock_irq(&hwgroup->lock);
-	/* Free the hwgroup if we were the only member. */
-	if (--hwgroup->port_count == 0)
-		kfree(hwgroup);
-	spin_unlock_irq(&hwgroup->lock);
-}
-
 /*
- * This routine sets up the irq for an ide interface, and creates a new
- * hwgroup for the irq/hwif if none was previously assigned.
- *
- * Much of the code is for correctly detecting/handling irq sharing
- * and irq serialization situations.  This is somewhat complex because
- * it handles static as well as dynamic (PCMCIA) IDE interfaces.
+ * This routine sets up the IRQ for an IDE interface.
  */
 static int init_irq (ide_hwif_t *hwif)
 {
 	struct ide_io_ports *io_ports = &hwif->io_ports;
-	unsigned int index;
-	ide_hwgroup_t *hwgroup;
-	ide_hwif_t *match = NULL;
 	int sa = 0;
 
 	mutex_lock(&ide_cfg_mtx);
-	hwif->hwgroup = NULL;
-
-	for (index = 0; index < MAX_HWIFS; index++) {
-		ide_hwif_t *h = ide_ports[index];
-
-		if (h && h->hwgroup) {  /* scan only initialized ports */
-			if (hwif->host->host_flags & IDE_HFLAG_SERIALIZE) {
-				if (hwif->host == h->host)
-					match = h;
-			}
-		}
-	}
-
-	/*
-	 * If we are still without a hwgroup, then form a new one
-	 */
-	if (match) {
-		hwgroup = match->hwgroup;
-		hwif->hwgroup = hwgroup;
-
-		spin_lock_irq(&hwgroup->lock);
-		hwgroup->port_count++;
-		spin_unlock_irq(&hwgroup->lock);
-	} else {
-		hwgroup = kmalloc_node(sizeof(*hwgroup), GFP_KERNEL|__GFP_ZERO,
-				       hwif_to_node(hwif));
-		if (hwgroup == NULL)
-			goto out_up;
-
-		spin_lock_init(&hwgroup->lock);
+	spin_lock_init(&hwif->lock);
 
-		hwif->hwgroup = hwgroup;
-
-		hwgroup->port_count = 1;
-
-		init_timer(&hwgroup->timer);
-		hwgroup->timer.function = &ide_timer_expiry;
-		hwgroup->timer.data = (unsigned long) hwgroup;
-	}
-
-	ide_ports[hwif->index] = hwif;
+	init_timer(&hwif->timer);
+	hwif->timer.function = &ide_timer_expiry;
+	hwif->timer.data = (unsigned long)hwif;
 
 #if defined(__mc68000__)
 	sa = IRQF_SHARED;
@@ -1034,7 +975,7 @@ static int init_irq (ide_hwif_t *hwif)
 		hwif->tp_ops->set_irq(hwif, 1);
 
 	if (request_irq(hwif->irq, &ide_intr, sa, hwif->name, hwif))
-		goto out_unlink;
+		goto out_up;
 
 	if (!hwif->rqsize) {
 		if ((hwif->host_flags & IDE_HFLAG_NO_LBA48) ||
@@ -1052,14 +993,12 @@ static int init_irq (ide_hwif_t *hwif)
 	printk(KERN_INFO "%s at 0x%08lx on irq %d", hwif->name,
 		io_ports->data_addr, hwif->irq);
 #endif /* __mc68000__ */
-	if (match)
-		printk(KERN_CONT " (serialized with %s)", match->name);
+	if (hwif->host->host_flags & IDE_HFLAG_SERIALIZE)
+		printk(KERN_CONT " (serialized)");
 	printk(KERN_CONT "\n");
 
 	mutex_unlock(&ide_cfg_mtx);
 	return 0;
-out_unlink:
-	ide_remove_port_from_hwgroup(hwif);
 out_up:
 	mutex_unlock(&ide_cfg_mtx);
 	return 1;
@@ -1140,20 +1079,20 @@ EXPORT_SYMBOL_GPL(ide_init_disk);
 static void drive_release_dev (struct device *dev)
 {
 	ide_drive_t *drive = container_of(dev, ide_drive_t, gendev);
-	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
+	ide_hwif_t *hwif = drive->hwif;
 
 	ide_proc_unregister_device(drive);
 
-	spin_lock_irq(&hwgroup->lock);
+	spin_lock_irq(&hwif->lock);
 	kfree(drive->id);
 	drive->id = NULL;
 	drive->dev_flags &= ~IDE_DFLAG_PRESENT;
 	/* Messed up locking ... */
-	spin_unlock_irq(&hwgroup->lock);
+	spin_unlock_irq(&hwif->lock);
 	blk_cleanup_queue(drive->queue);
-	spin_lock_irq(&hwgroup->lock);
+	spin_lock_irq(&hwif->lock);
 	drive->queue = NULL;
-	spin_unlock_irq(&hwgroup->lock);
+	spin_unlock_irq(&hwif->lock);
 
 	complete(&drive->gendev_rel_comp);
 }
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -479,7 +479,7 @@ static void ide_tape_kfree_buffer(idetap
 
 static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 {
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = drive->hwif->rq;
 	idetape_tape_t *tape = drive->driver_data;
 	unsigned long flags;
 	int error;
@@ -531,7 +531,7 @@ static void ide_tape_callback(ide_drive_
 			printk(KERN_ERR "ide-tape: Error in REQUEST SENSE "
 					"itself - Aborting request!\n");
 	} else if (pc->c[0] == READ_6 || pc->c[0] == WRITE_6) {
-		struct request *rq = drive->hwif->hwgroup->rq;
+		struct request *rq = drive->hwif->rq;
 		int blocks = pc->xferred / tape->blk_size;
 
 		tape->avg_size += blocks * tape->blk_size;
@@ -576,7 +576,7 @@ static void ide_tape_callback(ide_drive_
 
 /*
  * Postpone the current request so that ide.c will be able to service requests
- * from another device on the same hwgroup while we are polling for DSC.
+ * from another device on the same port while we are polling for DSC.
  */
 static void idetape_postpone_request(ide_drive_t *drive)
 {
@@ -584,7 +584,8 @@ static void idetape_postpone_request(ide
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
-	tape->postponed_rq = HWGROUP(drive)->rq;
+	tape->postponed_rq = drive->hwif->rq;
+
 	ide_stall_queue(drive, tape->dsc_poll_freq);
 }
 
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -361,7 +361,7 @@ static ide_startstop_t task_in_unexpecte
 static ide_startstop_t task_in_intr(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->hwgroup->rq;
+	struct request *rq = hwif->rq;
 	u8 stat = hwif->tp_ops->read_status(hwif);
 
 	/* Error? */
@@ -395,7 +395,7 @@ static ide_startstop_t task_in_intr(ide_
 static ide_startstop_t task_out_intr (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = hwif->rq;
 	u8 stat = hwif->tp_ops->read_status(hwif);
 
 	if (!OK_STAT(stat, DRIVE_READY, drive->bad_wstat))
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -189,8 +189,6 @@ void ide_unregister(ide_hwif_t *hwif)
 
 	free_irq(hwif->irq, hwif);
 
-	ide_remove_port_from_hwgroup(hwif);
-
 	device_unregister(hwif->portdev);
 	device_unregister(&hwif->gendev);
 	wait_for_completion(&hwif->gendev_rel_comp);
@@ -315,7 +313,6 @@ static int set_pio_mode_abuse(ide_hwif_t
 static int set_pio_mode(ide_drive_t *drive, int arg)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	ide_hwgroup_t *hwgroup = hwif->hwgroup;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
 
 	if (arg < 0 || arg > 255)
@@ -330,9 +327,9 @@ static int set_pio_mode(ide_drive_t *dri
 			unsigned long flags;
 
 			/* take lock for IDE_DFLAG_[NO_]UNMASK/[NO_]IO_32BIT */
-			spin_lock_irqsave(&hwgroup->lock, flags);
+			spin_lock_irqsave(&hwif->lock, flags);
 			port_ops->set_pio_mode(drive, arg);
-			spin_unlock_irqrestore(&hwgroup->lock, flags);
+			spin_unlock_irqrestore(&hwif->lock, flags);
 		} else
 			port_ops->set_pio_mode(drive, arg);
 	} else {
Index: b/drivers/ide/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -169,8 +169,8 @@ static void pdc202xx_dma_start(ide_drive
 	if (drive->current_speed > XFER_UDMA_2)
 		pdc_old_enable_66MHz_clock(drive->hwif);
 	if (drive->media != ide_disk || (drive->dev_flags & IDE_DFLAG_LBA48)) {
-		struct request *rq	= HWGROUP(drive)->rq;
 		ide_hwif_t *hwif	= HWIF(drive);
+		struct request *rq	= hwif->rq;
 		unsigned long high_16	= hwif->extra_base - 16;
 		unsigned long atapi_reg	= high_16 + (hwif->channel ? 0x24 : 0x20);
 		u32 word_count	= 0;
Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1516,7 +1516,7 @@ pmac_ide_dma_setup(ide_drive_t *drive)
 	ide_hwif_t *hwif = HWIF(drive);
 	pmac_ide_hwif_t *pmif =
 		(pmac_ide_hwif_t *)dev_get_drvdata(hwif->gendev.parent);
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = hwif->rq;
 	u8 unit = drive->dn & 1, ata4 = (pmif->kind == controller_kl_ata4);
 
 	if (!pmac_ide_build_dmatable(drive, rq)) {
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -316,7 +316,7 @@ static void scc_dma_host_set(ide_drive_t
 static int scc_dma_setup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = hwif->rq;
 	unsigned int reading;
 	u8 dma_stat;
 
@@ -405,7 +405,7 @@ static int scc_dma_end(ide_drive_t *driv
 			       drive->name);
 			data_loss = 1;
 			if (retry++) {
-				struct request *rq = HWGROUP(drive)->rq;
+				struct request *rq = hwif->rq;
 				int unit;
 				/* ERROR_RESET and drive->crc_count are needed
 				 * to reduce DMA transfer mode in retry process.
Index: b/drivers/ide/sgiioc4.c
===================================================================
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -492,7 +492,7 @@ use_pio_instead:
 
 static int sgiioc4_dma_setup(ide_drive_t *drive)
 {
-	struct request *rq = HWGROUP(drive)->rq;
+	struct request *rq = drive->hwif->rq;
 	unsigned int count = 0;
 	int ddir;
 
Index: b/drivers/ide/tc86c001.c
===================================================================
--- a/drivers/ide/tc86c001.c
+++ b/drivers/ide/tc86c001.c
@@ -64,11 +64,10 @@ static int tc86c001_timer_expiry(ide_dri
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	ide_expiry_t *expiry	= ide_get_hwifdata(hwif);
-	ide_hwgroup_t *hwgroup	= HWGROUP(drive);
 	u8 dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 
 	/* Restore a higher level driver's expiry handler first. */
-	hwgroup->expiry	= expiry;
+	hwif->expiry = expiry;
 
 	if ((dma_stat & 5) == 1) {	/* DMA active and no interrupt */
 		unsigned long sc_base	= hwif->config_data;
@@ -111,10 +110,9 @@ static int tc86c001_timer_expiry(ide_dri
 static void tc86c001_dma_start(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
-	ide_hwgroup_t *hwgroup	= HWGROUP(drive);
 	unsigned long sc_base	= hwif->config_data;
 	unsigned long twcr_port	= sc_base + (drive->dn ? 0x06 : 0x04);
-	unsigned long nsectors	= hwgroup->rq->nr_sectors;
+	unsigned long nsectors	= hwif->rq->nr_sectors;
 
 	/*
 	 * We have to manually load the sector count and size into
@@ -125,8 +123,8 @@ static void tc86c001_dma_start(ide_drive
 	outw(SECTOR_SIZE / 2, twcr_port); /* Transfer Word Count 1/2 */
 
 	/* Install our timeout expiry hook, saving the current handler... */
-	ide_set_hwifdata(hwif, hwgroup->expiry);
-	hwgroup->expiry = &tc86c001_timer_expiry;
+	ide_set_hwifdata(hwif, hwif->expiry);
+	hwif->expiry = &tc86c001_timer_expiry;
 
 	ide_dma_start(drive);
 }
Index: b/drivers/ide/trm290.c
===================================================================
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -184,7 +184,7 @@ static void trm290_dma_exec_cmd(ide_driv
 static int trm290_dma_setup(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	struct request *rq = hwif->hwgroup->rq;
+	struct request *rq = hwif->rq;
 	unsigned int count, rw;
 
 	if (rq_data_dir(rq)) {
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -287,7 +287,7 @@ static int tx4939ide_dma_setup(ide_drive
 {
 	ide_hwif_t *hwif = drive->hwif;
 	void __iomem *base = TX4939IDE_BASE(hwif);
-	struct request *rq = hwif->hwgroup->rq;
+	struct request *rq = hwif->rq;
 	u8 reading;
 	int nent;
 
Index: b/drivers/ide/umc8672.c
===================================================================
--- a/drivers/ide/umc8672.c
+++ b/drivers/ide/umc8672.c
@@ -106,22 +106,21 @@ static void umc_set_speeds(u8 speeds[])
 
 static void umc_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
-	ide_hwif_t *hwif = drive->hwif;
-	ide_hwgroup_t *mate_hwgroup = hwif->mate ? hwif->mate->hwgroup : NULL;
+	ide_hwif_t *hwif = drive->hwif, *mate = hwif->mate;
 	unsigned long uninitialized_var(flags);
 
 	printk("%s: setting umc8672 to PIO mode%d (speed %d)\n",
 		drive->name, pio, pio_to_umc[pio]);
-	if (mate_hwgroup)
-		spin_lock_irqsave(&mate_hwgroup->lock, flags);
-	if (mate_hwgroup && mate_hwgroup->handler) {
+	if (mate)
+		spin_lock_irqsave(&mate->lock, flags);
+	if (mate && mate->handler) {
 		printk(KERN_ERR "umc8672: other interface is busy: exiting tune_umc()\n");
 	} else {
 		current_speeds[drive->name[2] - 'a'] = pio_to_umc[pio];
 		umc_set_speeds(current_speeds);
 	}
-	if (mate_hwgroup)
-		spin_unlock_irqrestore(&mate_hwgroup->lock, flags);
+	if (mate)
+		spin_unlock_irqrestore(&mate->lock, flags);
 }
 
 static const struct ide_port_ops umc8672_port_ops = {
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -42,7 +42,6 @@ typedef unsigned char	byte;	/* used ever
 #define ERROR_RECAL	1	/* Recalibrate every 2nd retry */
 
 #define HWIF(drive)		((ide_hwif_t *)((drive)->hwif))
-#define HWGROUP(drive)		((ide_hwgroup_t *)(HWIF(drive)->hwgroup))
 
 /*
  * Definitions for accessing IDE controller registers
@@ -750,7 +749,6 @@ struct ide_host;
 
 typedef struct hwif_s {
 	struct hwif_s *mate;		/* other hwif from same PCI chip */
-	struct hwgroup_s *hwgroup;	/* actually (ide_hwgroup_t *) */
 	struct proc_dir_entry *proc;	/* /proc/ide/ directory entry */
 
 	struct ide_host *host;
@@ -839,6 +837,30 @@ typedef struct hwif_s {
 #ifdef CONFIG_BLK_DEV_IDEACPI
 	struct ide_acpi_hwif_link *acpidata;
 #endif
+
+	/* IRQ handler, if active */
+	ide_startstop_t	(*handler)(ide_drive_t *);
+
+	/* BOOL: polling active & poll_timeout field valid */
+	unsigned int polling : 1;
+
+	/* current drive */
+	ide_drive_t *cur_dev;
+
+	/* current request */
+	struct request *rq;
+
+	/* failsafe timer */
+	struct timer_list timer;
+	/* timeout value during long polls */
+	unsigned long poll_timeout;
+	/* queried upon timeouts */
+	int (*expiry)(ide_drive_t *);
+
+	int req_gen;
+	int req_gen_timer;
+
+	spinlock_t lock;
 } ____cacheline_internodealigned_in_smp ide_hwif_t;
 
 #define MAX_HOST_PORTS 4
@@ -867,34 +889,6 @@ typedef int (ide_expiry_t)(ide_drive_t *
 /* used by ide-cd, ide-floppy, etc. */
 typedef void (xfer_func_t)(ide_drive_t *, struct request *rq, void *, unsigned);
 
-typedef struct hwgroup_s {
-		/* irq handler, if active */
-	ide_startstop_t	(*handler)(ide_drive_t *);
-
-		/* BOOL: polling active & poll_timeout field valid */
-	unsigned int polling	: 1;
-
-		/* current drive */
-	ide_drive_t *cur_dev;
-
-		/* current request */
-	struct request *rq;
-
-		/* failsafe timer */
-	struct timer_list timer;
-		/* timeout value during long polls */
-	unsigned long poll_timeout;
-		/* queried upon timeouts */
-	int (*expiry)(ide_drive_t *);
-
-	int req_gen;
-	int req_gen_timer;
-
-	spinlock_t lock;
-
-	int port_count;
-} ide_hwgroup_t;
-
 typedef struct ide_driver_s ide_driver_t;
 
 extern struct mutex ide_setting_mtx;
@@ -1511,7 +1505,6 @@ static inline void ide_acpi_port_init_de
 static inline void ide_acpi_set_state(ide_hwif_t *hwif, int on) {}
 #endif
 
-void ide_remove_port_from_hwgroup(ide_hwif_t *);
 void ide_unregister(ide_hwif_t *);
 
 void ide_register_region(struct gendisk *);
