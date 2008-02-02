Return-Path: <linux-kernel-owner+w=401wt.eu-S1763063AbYBBAii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763063AbYBBAii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763588AbYBBAhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:37:07 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:35223 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762856AbYBBAg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:36:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=q06ous0+i6xEw+IDhATyGu7vcGCSt4hcLPihIHO47iLJs82ReWUBTtvYTjh4ptGtERTZj5tf96Yc5oFIMkSXuDWriN83GycgwUyWILSbSZFw+k9j0cyA4FPwnRLIgTvuijGYHUWG3akNCof7u0K6spAcajXcZQjkpl0ppUT8Zao=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 5/5] ide: add ide_read_error() inline helper
Date: Sat, 2 Feb 2008 01:49:49 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802020149.49969.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c       |    2 +-
 drivers/ide/ide-floppy.c   |    2 +-
 drivers/ide/ide-io.c       |    4 ++--
 drivers/ide/ide-iops.c     |    4 +++-
 drivers/ide/ide-lib.c      |    2 +-
 drivers/ide/ide-tape.c     |    2 +-
 drivers/ide/ide-taskfile.c |    5 ++---
 include/linux/ide.h        |    7 +++++++
 8 files changed, 18 insertions(+), 10 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -304,7 +304,7 @@ static int cdrom_decode_status(ide_drive
 		return 0;
 
 	/* Get the IDE error register. */
-	err = HWIF(drive)->INB(IDE_ERROR_REG);
+	err = ide_read_error(drive);
 	sense_key = err >> 4;
 
 	if (rq == NULL) {
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -465,7 +465,7 @@ static void idefloppy_retry_pc(ide_drive
 	idefloppy_pc_t *pc;
 	struct request *rq;
 
-	(void)drive->hwif->INB(IDE_ERROR_REG);
+	(void)ide_read_error(drive);
 	pc = idefloppy_next_pc_storage(drive);
 	rq = idefloppy_next_rq_storage(drive);
 	idefloppy_create_request_sense_cmd(pc);
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -821,8 +821,8 @@ static ide_startstop_t execute_drive_cmd
 #ifdef DEBUG
  	printk("%s: DRIVE_CMD (null)\n", drive->name);
 #endif
-	ide_end_drive_cmd(drive, ide_read_status(drive),
-			hwif->INB(IDE_ERROR_REG));
+	ide_end_drive_cmd(drive, ide_read_status(drive), ide_read_error(drive));
+
  	return ide_stopped;
 }
 
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -918,7 +918,9 @@ static ide_startstop_t reset_pollfunc (i
 		drive->failures++;
 	} else  {
 		printk("%s: reset: ", hwif->name);
-		if ((tmp = hwif->INB(IDE_ERROR_REG)) == 1) {
+		tmp = ide_read_error(drive);
+
+		if (tmp == 1) {
 			printk("success\n");
 			drive->failures = 0;
 		} else {
Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -578,7 +578,7 @@ u8 ide_dump_status(ide_drive_t *drive, c
 	}
 	printk("}\n");
 	if ((stat & (BUSY_STAT|ERR_STAT)) == ERR_STAT) {
-		err = drive->hwif->INB(IDE_ERROR_REG);
+		err = ide_read_error(drive);
 		printk("%s: %s: error=0x%02x ", drive->name, msg, err);
 		if (drive->media == ide_disk)
 			ide_dump_ata_error(drive, err);
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1125,7 +1125,7 @@ static ide_startstop_t idetape_retry_pc 
 	idetape_pc_t *pc;
 	struct request *rq;
 
-	(void)drive->hwif->INB(IDE_ERROR_REG);
+	(void)ide_read_error(drive);
 	pc = idetape_next_pc_storage(drive);
 	rq = idetape_next_rq_storage(drive);
 	idetape_create_request_sense_cmd(pc);
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -241,7 +241,6 @@ static ide_startstop_t recal_intr(ide_dr
 static ide_startstop_t task_no_data_intr(ide_drive_t *drive)
 {
 	ide_task_t *args	= HWGROUP(drive)->rq->special;
-	ide_hwif_t *hwif	= HWIF(drive);
 	u8 stat;
 
 	local_irq_enable_in_hardirq();
@@ -252,7 +251,7 @@ static ide_startstop_t task_no_data_intr
 		/* calls ide_end_drive_cmd */
 
 	if (args)
-		ide_end_drive_cmd(drive, stat, hwif->INB(IDE_ERROR_REG));
+		ide_end_drive_cmd(drive, stat, ide_read_error(drive));
 
 	return ide_stopped;
 }
@@ -408,7 +407,7 @@ static ide_startstop_t task_error(ide_dr
 void task_end_request(ide_drive_t *drive, struct request *rq, u8 stat)
 {
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
-		u8 err = drive->hwif->INB(IDE_ERROR_REG);
+		u8 err = ide_read_error(drive);
 
 		ide_end_drive_cmd(drive, stat, err);
 		return;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1325,4 +1325,11 @@ static inline u8 ide_read_altstatus(ide_
 	return hwif->INB(hwif->io_ports[IDE_CONTROL_OFFSET]);
 }
 
+static inline u8 ide_read_error(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	return hwif->INB(hwif->io_ports[IDE_ERROR_OFFSET]);
+}
+
 #endif /* _IDE_H */
