Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbZDBG7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbZDBG7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZDBG6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:58:48 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:58300 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbZDBG6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:58:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bOt0ur3jeiv5YVlgW0t+XaGlmywrH6TSot2Bnzb1JSiHKz98MjzDzbrVr7YRbsv3vL
         ++wgZ1QxdT+6bCaRy0+J4EcWgf9yG7N5DQzzxfcpJMJZ9zcKY45Udb4IZN+9yFOypcAh
         4Sa+lLOFP/uCO+dsqwj6sTDxiDxn+N9SXYOC8=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 1/3] ide-cd: move status checking into the IRQ handler
Date: Thu,  2 Apr 2009 08:58:37 +0200
Message-Id: <1238655519-10074-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   38 ++++++++++++++++----------------------
 1 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 35729a4..a4afd90 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -271,29 +271,18 @@ static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
  * 1: if the request will be going through error recovery.
  * 2: if the request should be ended.
  */
-static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
+static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
-	int stat, err, sense_key;
-
-	/* check for errors */
-	stat = hwif->tp_ops->read_status(hwif);
-
-	if (stat_ret)
-		*stat_ret = stat;
-
-	if (OK_STAT(stat, good_stat, BAD_R_STAT))
-		return 0;
+	int err, sense_key;
 
 	/* get the IDE error register */
 	err = ide_read_error(drive);
 	sense_key = err >> 4;
 
-	ide_debug_log(IDE_DBG_RQ, "stat: 0x%x, good_stat: 0x%x, cmd[0]: 0x%x, "
-				  "rq->cmd_type: 0x%x, err: 0x%x",
-				  stat, good_stat, rq->cmd[0], rq->cmd_type,
-				  err);
+	ide_debug_log(IDE_DBG_RQ, "cmd[0]: 0x%x, rq->cmd_type: 0x%x, err: 0x%x",
+				  rq->cmd[0], rq->cmd_type, err);
 
 	if (blk_sense_request(rq)) {
 		/*
@@ -624,12 +613,12 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	struct ide_cmd *cmd = &hwif->cmd;
 	struct request *rq = hwif->rq;
 	ide_expiry_t *expiry = NULL;
-	int dma_error = 0, dma, stat, thislen, uptodate = 0;
+	int dma_error = 0, dma, thislen, uptodate = 0;
 	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc, nsectors;
 	int sense = blk_sense_request(rq);
 	unsigned int timeout;
 	u16 len;
-	u8 ireason;
+	u8 ireason, stat;
 
 	ide_debug_log(IDE_DBG_PC, "cmd[0]: 0x%x, write: 0x%x",
 				  rq->cmd[0], write);
@@ -648,11 +637,16 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		}
 	}
 
-	rc = cdrom_decode_status(drive, 0, &stat);
-	if (rc) {
-		if (rc == 2)
-			goto out_end;
-		return ide_stopped;
+	/* check status */
+	stat = hwif->tp_ops->read_status(hwif);
+
+	if (!OK_STAT(stat, 0, BAD_R_STAT)) {
+		rc = cdrom_decode_status(drive, stat);
+		if (rc) {
+			if (rc == 2)
+				goto out_end;
+			return ide_stopped;
+		}
 	}
 
 	/* using dma, transfer is complete now */
-- 
1.6.2.1

