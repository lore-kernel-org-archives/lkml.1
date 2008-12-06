Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbYLFUDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbYLFUDc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 15:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYLFUDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 15:03:20 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:33691 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbYLFUDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 15:03:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=d5S6Argq7v2+owvGddpwzw4Ap210HInRGMQAgwW4q+veAIIleKR4YFBeRYxPaIAnbH
         0oMvy6RbxuUbtAhe6L7BmIbqZ/RGG2J/ooxFSCQAlCsQVDIhg4zpBOWhT4dNL+Vx1ghb
         D/5DjQqIM43II+/OM02svwPisNJteBA4Mr5Xc=
Date: Sat, 6 Dec 2008 21:03:16 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 5/6] ide-cd: move cdrom_timer_expiry to ide-atapi.c
Message-ID: <20081206200316.GB13838@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
References: <1228373010-20249-1-git-send-email-petkovbb@gmail.com> <1228373010-20249-6-git-send-email-petkovbb@gmail.com> <200812061551.24745.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812061551.24745.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This seems to remove the symbol accidentally and although I've
> just applied patch doing scheduled ide-scsi removal it would be
> much better to take care of the core code's ide-scsi remnants
> in separate patch(es).

... patches coming up...

> > @@ -19,7 +19,6 @@
> >  /*
> >   * typical timeout for packet command
> >   */
> > -#define ATAPI_WAIT_PC		(60 * HZ)
> >  #define ATAPI_WAIT_WRITE_BUSY	(10 * HZ)
> 
> The comment should be moved together with ATAPI_WAIT_PC define
> (or removed).
> 
> The rest of the patch is fine.

here is a v2:
---
From: Borislav Petkov <petkovbb@gmail.com>
Date: Sat, 6 Dec 2008 20:08:35 +0100
Subject: [PATCH] ide-cd: move cdrom_timer_expiry to ide-atapi.c

- cdrom_timer_expiry -> ide_cd_expiry
- remove expiry-arg to ide_issue_pc as it is redundant now
- ide_debug_log -> debug_log

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c  |   41 ++++++++++++++++++++++++++++++++++++++---
 drivers/ide/ide-cd.c     |   38 +++-----------------------------------
 drivers/ide/ide-cd.h     |    4 ----
 drivers/ide/ide-floppy.c |    2 +-
 drivers/ide/ide-tape.c   |    2 +-
 include/linux/ide.h      |    4 +++-
 6 files changed, 46 insertions(+), 45 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 8c5cf68..c110329 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -3,6 +3,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/cdrom.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
 #include <scsi/scsi.h>
@@ -252,6 +253,38 @@ int ide_scsi_expiry(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_scsi_expiry);
 
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
+
 int ide_cd_get_xferlen(struct request *rq)
 {
 	if (blk_fs_request(rq))
@@ -562,11 +595,11 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
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
@@ -578,9 +611,11 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
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
@@ -613,7 +648,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 		if (drive->dma)
 			drive->waiting_for_dma = 0;
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
index 389faa4..bf676b2 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -16,10 +16,6 @@
 #define ide_debug_log(lvl, fmt, args...) do {} while (0)
 #endif
 
-/*
- * typical timeout for packet command
- */
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
diff --git a/include/linux/ide.h b/include/linux/ide.h
index e35ff68..e20e0b5 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -396,6 +396,7 @@ enum {
  * This is used for several packet commands (not for READ/WRITE commands).
  */
 #define IDE_PC_BUFFER_SIZE	256
+#define ATAPI_WAIT_PC		(60 * HZ)
 
 struct ide_atapi_pc {
 	/* actual packet bytes */
@@ -1253,10 +1254,11 @@ static inline unsigned long ide_scsi_get_timeout(struct ide_atapi_pc *pc)
 }
 
 int ide_scsi_expiry(ide_drive_t *);
+int ide_cd_expiry(ide_drive_t *);
 
 int ide_cd_get_xferlen(struct request *);
 
-ide_startstop_t ide_issue_pc(ide_drive_t *, unsigned int, ide_expiry_t *);
+ide_startstop_t ide_issue_pc(ide_drive_t *, unsigned int);
 
 ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
 
-- 
1.6.0.4

-- 
Regards/Gruss,
    Boris.
