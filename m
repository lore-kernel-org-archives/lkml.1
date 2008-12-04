Return-Path: <linux-kernel-owner+w=401wt.eu-S1758464AbYLDGqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbYLDGqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756571AbYLDGnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:43:50 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:58686 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbYLDGnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:43:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=lPpK8TxfA4Asxp/9f0DRADssnmDw7jdpBJHeAHWfqJ8TWUmnr9zmJTIYStUwL0OZCC
         K/LzznPzulgDRpMOImLX3J7yLZ0PjPZvEzNSqyREULDX1iTM5v9OTZ1tGXHyuP6/in+Q
         es420Tkmorf8w3KGA3r5j60dG0Xx8IV6hFh8U=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 5/6] ide-cd: move cdrom_timer_expiry to ide-atapi.c
Date: Thu,  4 Dec 2008 07:43:28 +0100
Message-Id: <1228373010-20249-6-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1228373010-20249-1-git-send-email-petkovbb@gmail.com>
References: <1228373010-20249-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- cdrom_timer_expiry -> ide_cd_expiry
- remove expiry-arg to ide_issue_pc as it is redundant now

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c  |   42 ++++++++++++++++++++++++++++++++++++++----
 drivers/ide/ide-cd.c     |   38 +++-----------------------------------
 drivers/ide/ide-cd.h     |    1 -
 drivers/ide/ide-floppy.c |    2 +-
 drivers/ide/ide-tape.c   |    2 +-
 drivers/scsi/ide-scsi.c  |    2 +-
 include/linux/ide.h      |    5 +++--
 7 files changed, 47 insertions(+), 45 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 8884877..bb867a0 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -3,6 +3,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/cdrom.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
 #include <scsi/scsi.h>
@@ -250,7 +251,38 @@ int ide_scsi_expiry(ide_drive_t *drive)
 
 	return 0; /* we do not want the IDE subsystem to retry */
 }
-EXPORT_SYMBOL_GPL(ide_scsi_expiry);
+
+int ide_cd_expiry(ide_drive_t *drive)
+{
+	struct request *rq = HWGROUP(drive)->rq;
+	unsigned long wait = 0;
+
+	debug_log("%s: rq->cmd[0]: 0x%x\n", __func__, rq->cmd[0]);
+
+	/*
+	 * Some commands are *slow* and normally take a long time to complete.
+	 * Usually we can use the ATAPI "disconnect" to bypass this, but not all
+	 * commands/drives support that. Let ide_timer_expiry keep polling us
+	 * for these.
+	 */
+	switch (rq->cmd[0]) {
+	case GPCMD_BLANK:
+	case GPCMD_FORMAT_UNIT:
+	case GPCMD_RESERVE_RZONE_TRACK:
+	case GPCMD_CLOSE_TRACK:
+	case GPCMD_FLUSH_CACHE:
+		wait = ATAPI_WAIT_PC;
+		break;
+	default:
+		if (!(rq->cmd_flags & REQ_QUIET))
+			printk(KERN_INFO "cmd 0x%x timed out\n",
+					 rq->cmd[0]);
+		wait = 0;
+		break;
+	}
+	return wait;
+}
+EXPORT_SYMBOL_GPL(ide_cd_expiry);
 
 int ide_cd_get_xferlen(struct request *rq)
 {
@@ -557,11 +589,11 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	return ide_started;
 }
 
-ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
-			     ide_expiry_t *expiry)
+ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout)
 {
 	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
+	ide_expiry_t *expiry = NULL;
 	u32 tf_flags;
 	u16 bcount;
 	u8 scsi = !!(drive->dev_flags & IDE_DFLAG_SCSI);
@@ -573,9 +605,11 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 	if (dev_is_idecd(drive)) {
 		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
 		bcount = ide_cd_get_xferlen(hwif->hwgroup->rq);
+		expiry = ide_cd_expiry;
 	} else if (scsi) {
 		tf_flags = 0;
 		bcount = min(pc->req_xfer, 63 * 1024);
+		expiry = ide_scsi_expiry;
 	} else {
 		tf_flags = IDE_TFLAG_OUT_DEVICE;
 		bcount = ((drive->media == ide_tape) ?
@@ -606,7 +640,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 	/* Issue the packet command */
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
 		ide_execute_command(drive, ATA_CMD_PACKET, ide_transfer_pc,
-				    timeout, NULL);
+				    timeout, expiry);
 		return ide_started;
 	} else {
 		ide_execute_pkt_cmd(drive);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 8d3c771..105e4d8 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -511,38 +511,6 @@ end_request:
 	return 1;
 }
 
-static int cdrom_timer_expiry(ide_drive_t *drive)
-{
-	struct request *rq = HWGROUP(drive)->rq;
-	unsigned long wait = 0;
-
-	ide_debug_log(IDE_DBG_RQ, "Call %s: rq->cmd[0]: 0x%x\n", __func__,
-		      rq->cmd[0]);
-
-	/*
-	 * Some commands are *slow* and normally take a long time to complete.
-	 * Usually we can use the ATAPI "disconnect" to bypass this, but not all
-	 * commands/drives support that. Let ide_timer_expiry keep polling us
-	 * for these.
-	 */
-	switch (rq->cmd[0]) {
-	case GPCMD_BLANK:
-	case GPCMD_FORMAT_UNIT:
-	case GPCMD_RESERVE_RZONE_TRACK:
-	case GPCMD_CLOSE_TRACK:
-	case GPCMD_FLUSH_CACHE:
-		wait = ATAPI_WAIT_PC;
-		break;
-	default:
-		if (!(rq->cmd_flags & REQ_QUIET))
-			printk(KERN_INFO PFX "cmd 0x%x timed out\n",
-					 rq->cmd[0]);
-		wait = 0;
-		break;
-	}
-	return wait;
-}
-
 /*
  * Set up the device registers for transferring a packet command on DEV,
  * expecting to later transfer XFERLEN bytes.  HANDLER is the routine
@@ -574,7 +542,7 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 
 		/* packet command */
 		ide_execute_command(drive, ATA_CMD_PACKET, handler,
-				    ATAPI_WAIT_PC, cdrom_timer_expiry);
+				    ATAPI_WAIT_PC, ide_cd_expiry);
 		return ide_started;
 	} else {
 		ide_execute_pkt_cmd(drive);
@@ -621,7 +589,7 @@ static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
 	}
 
 	/* arm the interrupt handler */
-	ide_set_handler(drive, handler, rq->timeout, cdrom_timer_expiry);
+	ide_set_handler(drive, handler, rq->timeout, ide_cd_expiry);
 
 	/* ATAPI commands get padded out to 12 bytes minimum */
 	cmd_len = COMMAND_SIZE(rq->cmd[0]);
@@ -1088,7 +1056,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	} else {
 		timeout = ATAPI_WAIT_PC;
 		if (!blk_fs_request(rq))
-			expiry = cdrom_timer_expiry;
+			expiry = ide_cd_expiry;
 	}
 
 	ide_set_handler(drive, cdrom_newpc_intr, timeout, expiry);
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index 389faa4..a7a4d00 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -19,7 +19,6 @@
 /*
  * typical timeout for packet command
  */
-#define ATAPI_WAIT_PC		(60 * HZ)
 #define ATAPI_WAIT_WRITE_BUSY	(10 * HZ)
 
 /************************************************************************/
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 1f07f38..fdec729 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -197,7 +197,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 
 	pc->retries++;
 
-	return ide_issue_pc(drive, WAIT_FLOPPY_CMD, NULL);
+	return ide_issue_pc(drive, WAIT_FLOPPY_CMD);
 }
 
 void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index a2d470e..ac9e29a 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -694,7 +694,7 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 
 	pc->retries++;
 
-	return ide_issue_pc(drive, WAIT_TAPE_CMD, NULL);
+	return ide_issue_pc(drive, WAIT_TAPE_CMD);
 }
 
 /* A mode sense command is used to "sense" tape parameters. */
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index c24140a..7890718 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -315,7 +315,7 @@ static ide_startstop_t idescsi_issue_pc(ide_drive_t *drive,
 	/* Set the current packet command */
 	drive->pc = pc;
 
-	return ide_issue_pc(drive, ide_scsi_get_timeout(pc), ide_scsi_expiry);
+	return ide_issue_pc(drive, ide_scsi_get_timeout(pc));
 }
 
 /*
diff --git a/include/linux/ide.h b/include/linux/ide.h
index e35ff68..7fce92a 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -396,6 +396,7 @@ enum {
  * This is used for several packet commands (not for READ/WRITE commands).
  */
 #define IDE_PC_BUFFER_SIZE	256
+#define ATAPI_WAIT_PC		(60 * HZ)
 
 struct ide_atapi_pc {
 	/* actual packet bytes */
@@ -1252,11 +1253,11 @@ static inline unsigned long ide_scsi_get_timeout(struct ide_atapi_pc *pc)
 	return max_t(unsigned long, WAIT_CMD, pc->timeout - jiffies);
 }
 
-int ide_scsi_expiry(ide_drive_t *);
+int ide_cd_expiry(ide_drive_t *);
 
 int ide_cd_get_xferlen(struct request *);
 
-ide_startstop_t ide_issue_pc(ide_drive_t *, unsigned int, ide_expiry_t *);
+ide_startstop_t ide_issue_pc(ide_drive_t *, unsigned int);
 
 ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
 
-- 
1.6.0.4

