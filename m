Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753588AbYLRHm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbYLRHm6 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 02:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYLRHlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 02:41:14 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:53293 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbYLRHlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 02:41:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=SBSN9IjgKSIOoKnh3peHseukfgq+r/g0JvD2clXfE9TjX0X9HUeAgncLXP77ImofhH
         s84gL8EHpT2D/ws0Xw4suaDsXrD06isS/9QFtcLAef6vcjweor4ao8xBqhUtdgQCr3BT
         ZdAIVdx9jBh1fDdSTx2qshqTMrocxjFfMyKZ0=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 6/8] ide-atapi: remove timeout arg to ide_issue_pc
Date: Thu, 18 Dec 2008 08:40:50 +0100
Message-Id: <1229586052-3542-7-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229586052-3542-1-git-send-email-petkovbb@gmail.com>
References: <1229586052-3542-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c  |    7 ++++++-
 drivers/ide/ide-floppy.c |    2 +-
 drivers/ide/ide-tape.c   |    2 +-
 include/linux/ide.h      |    2 +-
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 2577782..dbed09c 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -563,11 +563,12 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	return ide_started;
 }
 
-ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout)
+ide_startstop_t ide_issue_pc(ide_drive_t *drive)
 {
 	struct ide_atapi_pc *pc;
 	ide_hwif_t *hwif = drive->hwif;
 	ide_expiry_t *expiry = NULL;
+	unsigned int timeout;
 	u32 tf_flags;
 	u16 bcount;
 
@@ -575,6 +576,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout)
 		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
 		bcount = ide_cd_get_xferlen(hwif->hwgroup->rq);
 		expiry = ide_cd_expiry;
+		timeout = ATAPI_WAIT_PC;
 
 		if (drive->dma)
 			drive->dma = !hwif->dma_ops->dma_setup(drive);
@@ -601,6 +603,9 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout)
 
 		if (!drive->dma)
 			pc->flags &= ~PC_FLAG_DMA_OK;
+
+		timeout = (drive->media == ide_floppy) ? WAIT_FLOPPY_CMD
+						       : WAIT_TAPE_CMD;
 	}
 
 	ide_pktcmd_tf_load(drive, tf_flags, bcount, drive->dma);
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index fdec729..0a48e2d 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -197,7 +197,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 
 	pc->retries++;
 
-	return ide_issue_pc(drive, WAIT_FLOPPY_CMD);
+	return ide_issue_pc(drive);
 }
 
 void ide_floppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index ac9e29a..5d2aa22 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -694,7 +694,7 @@ static ide_startstop_t idetape_issue_pc(ide_drive_t *drive,
 
 	pc->retries++;
 
-	return ide_issue_pc(drive, WAIT_TAPE_CMD);
+	return ide_issue_pc(drive);
 }
 
 /* A mode sense command is used to "sense" tape parameters. */
diff --git a/include/linux/ide.h b/include/linux/ide.h
index ad57a44..db5ef8a 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1250,7 +1250,7 @@ int ide_cd_expiry(ide_drive_t *);
 
 int ide_cd_get_xferlen(struct request *);
 
-ide_startstop_t ide_issue_pc(ide_drive_t *, unsigned int);
+ide_startstop_t ide_issue_pc(ide_drive_t *);
 
 ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
 
-- 
1.6.0.4

