Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbYHQT6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbYHQT6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbYHQT4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:56:40 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:50284 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388AbYHQT4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:56:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=VpBGUSs6ceAQZo6ug4PE088wNEOUliFIx++tfCbc/xKzEK9s14daM0m2us8pd2DABg
         celXabeqeerUfVG5LBlDsUYBSCoz9LaeW/4hJyt1Jv5u85aU1uwO0IpYKQaI9NwYzqee
         +gGYBNB3sEKBYM++A7du3mgZLlvuh4KB/TKtg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Aug 2008 21:54:18 +0200
Message-Id: <20080817195418.13393.61579.sendpatchset@localhost.localdomain>
In-Reply-To: <20080817195336.13393.86030.sendpatchset@localhost.localdomain>
References: <20080817195336.13393.86030.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/9] ide: convert 'pio_mode' device setting to use DS_SYNC flag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Convert 'pio_mode' device setting to use DS_SYNC flag.

* Remove unused special_t.b.{set_tune,serviced} and ide_drive_t.tune_req.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |   68 +++------------------------------------------------
 drivers/ide/ide.c    |   58 +++++++++++++++++++++++++++++++++----------
 include/linux/ide.h  |    7 -----
 3 files changed, 51 insertions(+), 82 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -543,30 +543,6 @@ static ide_startstop_t ide_disk_special(
 	return ide_started;
 }
 
-/*
- * handle HDIO_SET_PIO_MODE ioctl abusers here, eventually it will go away
- */
-static int set_pio_mode_abuse(ide_hwif_t *hwif, u8 req_pio)
-{
-	switch (req_pio) {
-	case 202:
-	case 201:
-	case 200:
-	case 102:
-	case 101:
-	case 100:
-		return (hwif->host_flags & IDE_HFLAG_ABUSE_DMA_MODES) ? 1 : 0;
-	case 9:
-	case 8:
-		return (hwif->host_flags & IDE_HFLAG_ABUSE_PREFETCH) ? 1 : 0;
-	case 7:
-	case 6:
-		return (hwif->host_flags & IDE_HFLAG_ABUSE_FAST_DEVSEL) ? 1 : 0;
-	default:
-		return 0;
-	}
-}
-
 /**
  *	do_special		-	issue some special commands
  *	@drive: drive the command is for
@@ -584,46 +560,12 @@ static ide_startstop_t do_special (ide_d
 #ifdef DEBUG
 	printk("%s: do_special: 0x%02x\n", drive->name, s->all);
 #endif
-	if (s->b.set_tune) {
-		ide_hwif_t *hwif = drive->hwif;
-		const struct ide_port_ops *port_ops = hwif->port_ops;
-		u8 req_pio = drive->tune_req;
-
-		s->b.set_tune = 0;
-
-		if (set_pio_mode_abuse(drive->hwif, req_pio)) {
-			/*
-			 * take ide_lock for IDE_DFLAG_[NO_]UNMASK/[NO_]IO_32BIT
-			 */
-			if (req_pio == 8 || req_pio == 9) {
-				unsigned long flags;
+	if (drive->media == ide_disk)
+		return ide_disk_special(drive);
 
-				spin_lock_irqsave(&ide_lock, flags);
-				port_ops->set_pio_mode(drive, req_pio);
-				spin_unlock_irqrestore(&ide_lock, flags);
-			} else
-				port_ops->set_pio_mode(drive, req_pio);
-		} else {
-			int keep_dma =
-				!!(drive->dev_flags & IDE_DFLAG_USING_DMA);
-
-			ide_set_pio(drive, req_pio);
-
-			if (hwif->host_flags & IDE_HFLAG_SET_PIO_MODE_KEEP_DMA) {
-				if (keep_dma)
-					ide_dma_on(drive);
-			}
-		}
-
-		return ide_stopped;
-	} else {
-		if (drive->media == ide_disk)
-			return ide_disk_special(drive);
-
-		s->all = 0;
-		drive->mult_req = 0;
-		return ide_stopped;
-	}
+	s->all = 0;
+	drive->mult_req = 0;
+	return ide_stopped;
 }
 
 void ide_map_sg(ide_drive_t *drive, struct request *rq)
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -314,9 +314,32 @@ out:
 #endif
 }
 
+/*
+ * handle HDIO_SET_PIO_MODE ioctl abusers here, eventually it will go away
+ */
+static int set_pio_mode_abuse(ide_hwif_t *hwif, u8 req_pio)
+{
+	switch (req_pio) {
+	case 202:
+	case 201:
+	case 200:
+	case 102:
+	case 101:
+	case 100:
+		return (hwif->host_flags & IDE_HFLAG_ABUSE_DMA_MODES) ? 1 : 0;
+	case 9:
+	case 8:
+		return (hwif->host_flags & IDE_HFLAG_ABUSE_PREFETCH) ? 1 : 0;
+	case 7:
+	case 6:
+		return (hwif->host_flags & IDE_HFLAG_ABUSE_FAST_DEVSEL) ? 1 : 0;
+	default:
+		return 0;
+	}
+}
+
 static int set_pio_mode(ide_drive_t *drive, int arg)
 {
-	struct request *rq;
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_port_ops *port_ops = hwif->port_ops;
 
@@ -327,17 +350,26 @@ static int set_pio_mode(ide_drive_t *dri
 	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
 		return -ENOSYS;
 
-	if (drive->special.b.set_tune)
-		return -EBUSY;
-
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
-	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
-
-	drive->tune_req = (u8) arg;
-	drive->special.b.set_tune = 1;
-
-	blk_execute_rq(drive->queue, NULL, rq, 0);
-	blk_put_request(rq);
+	if (set_pio_mode_abuse(drive->hwif, arg)) {
+		if (arg == 8 || arg == 9) {
+			unsigned long flags;
+
+			/* take lock for IDE_DFLAG_[NO_]UNMASK/[NO_]IO_32BIT */
+			spin_lock_irqsave(&ide_lock, flags);
+			port_ops->set_pio_mode(drive, arg);
+			spin_unlock_irqrestore(&ide_lock, flags);
+		} else
+			port_ops->set_pio_mode(drive, arg);
+	} else {
+		int keep_dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
+
+		ide_set_pio(drive, arg);
+
+		if (hwif->host_flags & IDE_HFLAG_SET_PIO_MODE_KEEP_DMA) {
+			if (keep_dma)
+				ide_dma_on(drive);
+		}
+	}
 
 	return 0;
 }
@@ -367,7 +399,7 @@ ide_gen_devset_rw(io_32bit, io_32bit);
 ide_gen_devset_rw(keepsettings, ksettings);
 ide_gen_devset_rw(unmaskirq, unmaskirq);
 ide_gen_devset_rw(using_dma, using_dma);
-__IDE_DEVSET(pio_mode, 0, NULL, set_pio_mode);
+__IDE_DEVSET(pio_mode, DS_SYNC, NULL, set_pio_mode);
 
 static int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 {
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -262,8 +262,6 @@ static inline int __ide_default_irq(unsi
  * set_geometry	: respecify drive geometry
  * recalibrate	: seek to cyl 0
  * set_multmode	: set multmode count
- * set_tune	: tune interface for drive
- * serviced	: service command
  * reserved	: unused
  */
 typedef union {
@@ -272,9 +270,7 @@ typedef union {
 		unsigned set_geometry	: 1;
 		unsigned recalibrate	: 1;
 		unsigned set_multmode	: 1;
-		unsigned set_tune	: 1;
-		unsigned serviced	: 1;
-		unsigned reserved	: 3;
+		unsigned reserved	: 5;
 	} b;
 } special_t;
 
@@ -512,7 +508,6 @@ struct ide_drive_s {
 	u8	ready_stat;	/* min status value for drive ready */
 	u8	mult_count;	/* current multiple sector setting */
 	u8	mult_req;	/* requested multiple sector setting */
-	u8	tune_req;	/* requested drive tuning setting */
 	u8	io_32bit;	/* 0=16-bit, 1=32-bit, 2/3=32bit+sync */
 	u8	bad_wstat;	/* used for ignoring ATA_DF */
 	u8	head;		/* "real" number of heads */
