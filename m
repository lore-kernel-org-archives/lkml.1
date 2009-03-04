Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbZCDJSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbZCDJSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbZCDJRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:17:13 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:49789 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZCDJRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:17:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Qv4/SmyKde9H8sZxs1jmk04lvGht93jfnpiKn3WJJ+QTIHs+obaIAZhh8A0pChfr8y
         giJKz3sqeCwzf3Ws5atp8lh6APXFCqvwmvpS4aEEcIHoPme01D12DckKYGHQzU3QPwkZ
         Vw1k4hQRRgbnWrX+8cYRgG8Ry4fUpIoJBPYRM=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 3/3] ide-{cd,floppy}: do not map all cmds to an sg
Date: Wed,  4 Mar 2009 10:16:56 +0100
Message-Id: <1236158216-23052-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236158216-23052-1-git-send-email-petkovbb@gmail.com>
References: <1236158216-23052-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... since some do not transfer any data from the drive and
rq->buffer is unset leading to an OOPS when checking VM translations
(CONFIG_DEBUG_VIRTUAL).

Tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c  |    9 ++++++++-
 drivers/ide/ide-cd.c     |    4 ----
 drivers/ide/ide-floppy.c |    4 ----
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index a5596a6..ef78cbf 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -570,7 +570,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 
 ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 {
-	struct ide_atapi_pc *pc;
+	struct ide_atapi_pc *uninitialized_var(pc);
 	ide_hwif_t *hwif = drive->hwif;
 	ide_expiry_t *expiry = NULL;
 	struct request *rq = hwif->rq;
@@ -587,6 +587,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 
 		if (drive->dma)
 			drive->dma = !ide_dma_prepare(drive, cmd);
+
 	} else {
 		pc = drive->pc;
 
@@ -614,6 +615,12 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, struct ide_cmd *cmd)
 						       : WAIT_TAPE_CMD;
 	}
 
+	if (drive->media != ide_tape &&
+	      !drive->dma && (blk_fs_request(rq) || rq->data_len)) {
+		ide_init_sg_cmd(cmd, blk_rq_bytes(rq));
+		ide_map_sg(drive, cmd);
+	}
+
 	ide_init_packet_cmd(cmd, tf_flags, bcount, drive->dma);
 
 	(void)do_rw_taskfile(drive, cmd);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 091d414..106cacb 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -916,10 +916,6 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 
 	cmd.rq = rq;
 
-	ide_init_sg_cmd(&cmd,
-		blk_fs_request(rq) ? (rq->nr_sectors << 9) : rq->data_len);
-	ide_map_sg(drive, &cmd);
-
 	return ide_issue_pc(drive, &cmd);
 out_end:
 	nsectors = rq->hard_nr_sectors;
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 2f8f453..b91deef 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -281,10 +281,6 @@ static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 		cmd.tf_flags |= IDE_TFLAG_WRITE;
 
 	cmd.rq = rq;
-
-	ide_init_sg_cmd(&cmd, pc->req_xfer);
-	ide_map_sg(drive, &cmd);
-
 	pc->rq = rq;
 
 	return ide_floppy_issue_pc(drive, &cmd, pc);
-- 
1.6.1.3

