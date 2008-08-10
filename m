Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbYHJPp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbYHJPp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbYHJPkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:40:22 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:13212 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbYHJPkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:40:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dR39cYTyO0Zxoa3IcbqbwdxlpPGShorBNpNiNPE2zaPSKgOi/ALvPrdi8x+Qffu7lB
         kSdOKEwSsrr+N7kID46XFyolv2fzx1n2zDMBd68RhWvdItFm+SNEEcm8C9ZRXE8+NORg
         W/LST4eG5JsGQhI3dsYmwxkUmOgMCMAc/mLgU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:38:05 +0200
Message-Id: <20080810153805.16255.99641.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 22/22] ide: make ide_transfer_pc() static
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move ->ticks field from struct ide_floppy_obj to ide_drive_t.

* Move idefloppy_transfer_pc() to ide-atapi.c and make
  ide_transfer_pc() use it.

* Always use ide_transfer_pc as a handler in ide_issue_pc().

* Remove no longer used idefloppy_start_pc_transfer(),
  ide*_transfer_pc() and 'handler' argument from ide_issue_pc().

* Make ide_transfer_pc() static.

While at it:

* idefloppy_transfer_pc() -> ide_delayed_transfer_pc()

* IDEFLOPPY_TICKS_DELAY -> IDEFLOPPY_PC_DELAY

* ->ticks -> ->pc_delay

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c  |   41 ++++++++++++++++++++++----
 drivers/ide/ide-floppy.c |   72 +++++------------------------------------------
 drivers/ide/ide-floppy.h |    3 -
 drivers/ide/ide-tape.c   |    6 ---
 drivers/scsi/ide-scsi.c  |    9 -----
 include/linux/ide.h      |    7 ++--
 6 files changed, 49 insertions(+), 89 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -468,12 +468,22 @@ static u8 ide_wait_ireason(ide_drive_t *
 	return ireason;
 }
 
-ide_startstop_t ide_transfer_pc(ide_drive_t *drive, unsigned int timeout,
-				ide_expiry_t *expiry)
+static int ide_delayed_transfer_pc(ide_drive_t *drive)
+{
+	/* Send the actual packet */
+	drive->hwif->tp_ops->output_data(drive, NULL, drive->pc->c, 12);
+
+	/* Timeout for the packet command */
+	return WAIT_FLOPPY_CMD;
+}
+
+static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 {
 	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->hwgroup->rq;
+	ide_expiry_t *expiry;
+	unsigned int timeout;
 	ide_startstop_t startstop;
 	u8 ireason;
 
@@ -493,6 +503,25 @@ ide_startstop_t ide_transfer_pc(ide_driv
 		return ide_do_reset(drive);
 	}
 
+	/*
+	 * If necessary schedule the packet transfer to occur 'timeout'
+	 * miliseconds later in ide_delayed_transfer_pc() after the device
+	 * says it's ready for a packet.
+	 */
+	if (drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) {
+		timeout = drive->pc_delay;
+		expiry = &ide_delayed_transfer_pc;
+	} else {
+		if (drive->scsi) {
+			timeout = ide_scsi_get_timeout(pc);
+			expiry = ide_scsi_expiry;
+		} else {
+			timeout = (drive->media == ide_floppy) ? WAIT_FLOPPY_CMD
+							       : WAIT_TAPE_CMD;
+			expiry = NULL;
+		}
+	}
+
 	/* Set the interrupt routine */
 	ide_set_handler(drive, ide_pc_intr, timeout, expiry);
 
@@ -508,10 +537,8 @@ ide_startstop_t ide_transfer_pc(ide_driv
 
 	return ide_started;
 }
-EXPORT_SYMBOL_GPL(ide_transfer_pc);
 
-ide_startstop_t ide_issue_pc(ide_drive_t *drive,
-			     ide_handler_t *handler, unsigned int timeout,
+ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 			     ide_expiry_t *expiry)
 {
 	struct ide_atapi_pc *pc = drive->pc;
@@ -550,12 +577,12 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 
 	/* Issue the packet command */
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
-		ide_execute_command(drive, ATA_CMD_PACKET, handler,
+		ide_execute_command(drive, ATA_CMD_PACKET, ide_transfer_pc,
 				    timeout, NULL);
 		return ide_started;
 	} else {
 		ide_execute_pkt_cmd(drive);
-		return (*handler)(drive);
+		return ide_transfer_pc(drive);
 	}
 }
 EXPORT_SYMBOL_GPL(ide_issue_pc);
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -72,7 +72,11 @@
 #define CAPACITY_CURRENT	0x02
 #define CAPACITY_NO_CARTRIDGE	0x03
 
-#define IDEFLOPPY_TICKS_DELAY	HZ/20	/* default delay for ZIP 100 (50ms) */
+/*
+ * The following delay solves a problem with ATAPI Zip 100 drive where BSY bit
+ * was apparently being deasserted before the unit was ready to receive data.
+ */
+#define IDEFLOPPY_PC_DELAY	(HZ/20)	/* default delay for ZIP 100 (50ms) */
 
 /* Error code returned in rq->errors to the higher part of the driver. */
 #define	IDEFLOPPY_ERROR_GENERAL		101
@@ -192,51 +196,6 @@ static void ide_floppy_callback(ide_driv
 	idefloppy_end_request(drive, uptodate, 0);
 }
 
-/*
- * What we have here is a classic case of a top half / bottom half interrupt
- * service routine. In interrupt mode, the device sends an interrupt to signal
- * that it is ready to receive a packet. However, we need to delay about 2-3
- * ticks before issuing the packet or we gets in trouble.
- */
-static int idefloppy_transfer_pc(ide_drive_t *drive)
-{
-	/* Send the actual packet */
-	drive->hwif->tp_ops->output_data(drive, NULL, drive->pc->c, 12);
-
-	/* Timeout for the packet command */
-	return WAIT_FLOPPY_CMD;
-}
-
-/*
- * Called as an interrupt (or directly). When the device says it's ready for a
- * packet, we schedule the packet transfer to occur about 2-3 ticks later in
- * transfer_pc.
- */
-static ide_startstop_t idefloppy_start_pc_transfer(ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	ide_expiry_t *expiry;
-	unsigned int timeout;
-
-	/*
-	 * The following delay solves a problem with ATAPI Zip 100 drives
-	 * where the Busy flag was apparently being deasserted before the
-	 * unit was ready to receive data. This was happening on a
-	 * 1200 MHz Athlon system. 10/26/01 25msec is too short,
-	 * 40 and 50msec work well. ide_pc_intr will not be actually
-	 * used until after the packet is moved in about 50 msec.
-	 */
-	if (drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) {
-		timeout = floppy->ticks;
-		expiry = &idefloppy_transfer_pc;
-	} else {
-		timeout = WAIT_FLOPPY_CMD;
-		expiry = NULL;
-	}
-
-	return ide_transfer_pc(drive, timeout, expiry);
-}
-
 static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
 				    struct ide_atapi_pc *pc)
 {
@@ -280,8 +239,7 @@ static ide_startstop_t idefloppy_issue_p
 
 	pc->retries++;
 
-	return ide_issue_pc(drive, idefloppy_start_pc_transfer,
-			    WAIT_FLOPPY_CMD, NULL);
+	return ide_issue_pc(drive, WAIT_FLOPPY_CMD, NULL);
 }
 
 void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
@@ -596,21 +554,7 @@ static sector_t idefloppy_capacity(ide_d
 ide_devset_rw(bios_cyl,  0, 1023, bios_cyl);
 ide_devset_rw(bios_head, 0,  255, bios_head);
 ide_devset_rw(bios_sect, 0,   63, bios_sect);
-
-static int get_ticks(ide_drive_t *drive)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	return floppy->ticks;
-}
-
-static int set_ticks(ide_drive_t *drive, int arg)
-{
-	idefloppy_floppy_t *floppy = drive->driver_data;
-	floppy->ticks = arg;
-	return 0;
-}
-
-IDE_DEVSET(ticks, S_RW, 0, 255, get_ticks, set_ticks);
+ide_devset_rw(ticks,     0,  255, pc_delay);
 
 static const struct ide_devset *idefloppy_settings[] = {
 	&ide_devset_bios_cyl,
@@ -646,7 +590,7 @@ static void idefloppy_setup(ide_drive_t 
 	if (!strncmp((char *)&id[ATA_ID_PROD], "IOMEGA ZIP 100 ATAPI", 20)) {
 		drive->atapi_flags |= IDE_AFLAG_ZIP_DRIVE;
 		/* This value will be visible in the /proc/ide/hdx/settings */
-		floppy->ticks = IDEFLOPPY_TICKS_DELAY;
+		drive->pc_delay = IDEFLOPPY_PC_DELAY;
 		blk_queue_max_sectors(drive->queue, 64);
 	}
 
Index: b/drivers/ide/ide-floppy.h
===================================================================
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -20,8 +20,7 @@ typedef struct ide_floppy_obj {
 
 	/* Last error information */
 	u8 sense_key, asc, ascq;
-	/* delay this long before sending packet command */
-	u8 ticks;
+
 	int progress_indication;
 
 	/* Device information */
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -654,10 +654,6 @@ static int ide_tape_io_buffers(ide_drive
  * again, the callback function will be called and then we will handle the next
  * request.
  */
-static ide_startstop_t idetape_transfer_pc(ide_drive_t *drive)
-{
-	return ide_transfer_pc(drive, WAIT_TAPE_CMD, NULL);
-}
 
 static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 		struct ide_atapi_pc *pc)
@@ -705,7 +701,7 @@ static ide_startstop_t idetape_issue_pc(
 
 	pc->retries++;
 
-	return ide_issue_pc(drive, idetape_transfer_pc, WAIT_TAPE_CMD, NULL);
+	return ide_issue_pc(drive, WAIT_TAPE_CMD, NULL);
 }
 
 /* A mode sense command is used to "sense" tape parameters. */
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -270,12 +270,6 @@ static int idescsi_end_request (ide_driv
 	return 0;
 }
 
-static ide_startstop_t idescsi_transfer_pc(ide_drive_t *drive)
-{
-	return ide_transfer_pc(drive, ide_scsi_get_timeout(drive->pc),
-			       ide_scsi_expiry);
-}
-
 static inline int idescsi_set_direction(struct ide_atapi_pc *pc)
 {
 	switch (pc->c[0]) {
@@ -321,8 +315,7 @@ static ide_startstop_t idescsi_issue_pc(
 	/* Set the current packet command */
 	drive->pc = pc;
 
-	return ide_issue_pc(drive, idescsi_transfer_pc,
-			    ide_scsi_get_timeout(pc), ide_scsi_expiry);
+	return ide_issue_pc(drive, ide_scsi_get_timeout(pc), ide_scsi_expiry);
 }
 
 /*
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -528,6 +528,9 @@ struct ide_drive_s {
 	u8	bios_head;	/* BIOS/fdisk/LILO number of heads */
 	u8	bios_sect;	/* BIOS/fdisk/LILO sectors per track */
 
+	/* delay this long before sending packet command */
+	u8 pc_delay;
+
 	unsigned int	bios_cyl;	/* BIOS/fdisk/LILO number of cyls */
 	unsigned int	cyl;		/* "real" number of cyls */
 	unsigned int	drive_data;	/* used by set_pio_mode/selectproc */
@@ -1177,9 +1180,7 @@ static inline unsigned long ide_scsi_get
 
 int ide_scsi_expiry(ide_drive_t *);
 
-ide_startstop_t ide_transfer_pc(ide_drive_t *, unsigned int, ide_expiry_t *);
-ide_startstop_t ide_issue_pc(ide_drive_t *,
-			     ide_handler_t *, unsigned int, ide_expiry_t *);
+ide_startstop_t ide_issue_pc(ide_drive_t *, unsigned int, ide_expiry_t *);
 
 ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
 
