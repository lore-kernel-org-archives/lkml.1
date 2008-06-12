Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbYFLGrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbYFLGrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbYFLGrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:47:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:21650 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbYFLGrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:47:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=RcO5RzkQzFSEOaXXnCBNWB/qEPKVbcdRlVRdeKTliGmViv/IKqs0f3O1y4BCUx2M0D
         aG9WrqPxATJ89Vg/Fiy4//vHBAp7FHFqsxQLKR+daOP093G5hLUlprSwIFONCXmb5kPB
         NjORz71EWfD8mNkAgTufjUtI7nbVaesIP+Cjk=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 11/18] ide-cd: move request prep from cdrom_start_rw_cont to rq issue path
Date: Thu, 12 Jun 2008 08:41:03 +0200
Message-Id: <1213252870-20474-12-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... by factoring out the rq preparation code into a separate
function called in the request routine. Bart: As a nice
side effect, this minimizes the IRQ handler execution time.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   29 ++++++++++++++++++++---------
 1 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index da0f28c..a5715b1 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -691,16 +691,9 @@ static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *);
 
-/*
- * Routine to send a read/write packet command to the drive. This is usually
- * called directly from cdrom_start_{read,write}(). However, for drq_interrupt
- * devices, it is called from an interrupt when the drive is ready to accept
- * the command.
- */
-static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
+static ide_startstop_t ide_cd_prepare_rw_request(ide_drive_t *drive,
+						 struct request *rq)
 {
-	struct request *rq = HWGROUP(drive)->rq;
-
 	if (rq_data_dir(rq) == READ) {
 		unsigned short sectors_per_frame =
 			queue_hardsect_size(drive->queue) >> SECTOR_BITS;
@@ -737,6 +730,19 @@ static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
 	/* set up the command */
 	rq->timeout = ATAPI_WAIT_PC;
 
+	return ide_started;
+}
+
+/*
+ * Routine to send a read/write packet command to the drive. This is usually
+ * called directly from cdrom_start_{read,write}(). However, for drq_interrupt
+ * devices, it is called from an interrupt when the drive is ready to accept
+ * the command.
+ */
+static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
+{
+	struct request *rq = HWGROUP(drive)->rq;
+
 	/* send the command to the drive and return */
 	return cdrom_transfer_packet_command(drive, rq, cdrom_newpc_intr);
 }
@@ -1238,10 +1244,15 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		} else {
 			xferlen = 32768;
 			fn = cdrom_start_rw_cont;
+
 			if (cdrom_start_rw(drive, rq) == ide_stopped)
 				return ide_stopped;
+
+			if (ide_cd_prepare_rw_request(drive, rq) == ide_stopped)
+				return ide_stopped;
 		}
 		info->last_block = block;
+
 	} else if (blk_sense_request(rq) || blk_pc_request(rq) ||
 		   rq->cmd_type == REQ_TYPE_ATA_PC) {
 		xferlen = rq->data_len;
-- 
1.5.5.1

