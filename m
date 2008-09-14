Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYINLht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYINLht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 07:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbYINLgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 07:36:16 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:23162 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbYINLgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 07:36:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=s99yQRBhbdpPupNo2aPKTVsn+577nm8Ae5ux8FmcK/lyTx/q/Ubfd5y3O/balGd7Z8
         qMPd3YsacfOczVMdTiM+HlHavrKo08YtDd1wnAvT3fOz2Fk3rYZI3mZ3eksjpwHRr+mG
         E0RcMtoQusMe9KIIN7qi1Scufqm13CjNIzk0w=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 08/10] ide-atapi: accomodate to ide-cd-specific handlers
Date: Sun, 14 Sep 2008 13:35:56 +0200
Message-Id: <1221392158-3848-9-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
References: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.. for the next phase of ide command execution. Thus, export ide_transfer_pc for
the generic users.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c  |   10 ++++++----
 drivers/ide/ide-floppy.c |    2 +-
 drivers/ide/ide-tape.c   |    2 +-
 drivers/scsi/ide-scsi.c  |    2 +-
 include/linux/ide.h      |    4 +++-
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 480b9f3..733a75a 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -482,7 +482,7 @@ static int ide_delayed_transfer_pc(ide_drive_t *drive)
 #define DEV_IS_IDECD(drive)	\
 		(drive->media == ide_cdrom || drive->media == ide_optical)
 
-static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
+ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 {
 	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
@@ -549,9 +549,11 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 
 	return ide_started;
 }
+EXPORT_SYMBOL_GPL(ide_transfer_pc);
 
 ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
-			     ide_expiry_t *expiry, int xferlen)
+			     ide_expiry_t *expiry, int xferlen,
+			     ide_handler_t *handler)
 {
 	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
@@ -603,13 +605,13 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 		if (drive->dma)
 			drive->waiting_for_dma = 0;
 
-		ide_execute_command(drive, ATA_CMD_PACKET, ide_transfer_pc,
+		ide_execute_command(drive, ATA_CMD_PACKET, handler,
 				    timeout, expiry);
 
 		return ide_started;
 	} else {
 		ide_execute_pkt_cmd(drive);
-		return ide_transfer_pc(drive);
+		return (*handler)(drive);
 	}
 }
 EXPORT_SYMBOL_GPL(ide_issue_pc);
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 3a03e0c..4629e9a 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -246,7 +246,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 
 	pc->retries++;
 
-	return ide_issue_pc(drive, WAIT_FLOPPY_CMD, NULL, 0);
+	return ide_issue_pc(drive, WAIT_FLOPPY_CMD, NULL, 0, ide_transfer_pc);
 }
 
 void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 0ab3766..f327a1b 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -694,7 +694,7 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 
 	pc->retries++;
 
-	return ide_issue_pc(drive, WAIT_TAPE_CMD, NULL, 0);
+	return ide_issue_pc(drive, WAIT_TAPE_CMD, NULL, 0, ide_transfer_pc);
 }
 
 /* A mode sense command is used to "sense" tape parameters. */
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 825b890..737e369 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -316,7 +316,7 @@ static ide_startstop_t idescsi_issue_pc(ide_drive_t *drive,
 	drive->pc = pc;
 
 	return ide_issue_pc(drive, ide_scsi_get_timeout(pc),
-			    ide_scsi_expiry, 0);
+			    ide_scsi_expiry, 0, ide_transfer_pc);
 }
 
 /*
diff --git a/include/linux/ide.h b/include/linux/ide.h
index e431e33..e6e8833 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1233,7 +1233,9 @@ static inline unsigned long ide_scsi_get_timeout(struct ide_atapi_pc *pc)
 
 int ide_scsi_expiry(ide_drive_t *);
 
-ide_startstop_t ide_issue_pc(ide_drive_t *, unsigned int, ide_expiry_t *, int);
+ide_startstop_t ide_issue_pc(ide_drive_t *, unsigned int, ide_expiry_t *, int,
+			     ide_handler_t *);
+ide_startstop_t ide_transfer_pc(ide_drive_t *);
 
 ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
 
-- 
1.5.5.1

