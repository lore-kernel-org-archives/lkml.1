Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYLDGo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYLDGo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbYLDGnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:43:45 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:58832 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbYLDGnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:43:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=jOP+Cg01c99GGoUVdCn/W02Bit77CrVIujU4a+lBLZ/zvxtSgJlWeR6VupyKS12Agm
         jwbxXVCxkkPtNohiJRsJSHtT0ggeNsGSn6sT5QCA/9cQe5NwAH7DLkIdeDgz4Hr4BOen
         SaM2YDKU22OUmqm6sGempEtpIpnKIojKoHjrc=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 3/6] ide-atapi: accomodate transfer length calculation for ide-cd
Date: Thu,  4 Dec 2008 07:43:26 +0100
Message-Id: <1228373010-20249-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1228373010-20249-1-git-send-email-petkovbb@gmail.com>
References: <1228373010-20249-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... by factoring it out of ide_cd_do_request() into a helper, as suggested by
Bart.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   15 ++++++++++++++-
 drivers/ide/ide-cd.c    |    4 ++--
 include/linux/ide.h     |    2 ++
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index b6e0aac..7162317 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -252,6 +252,18 @@ int ide_scsi_expiry(ide_drive_t *drive)
 }
 EXPORT_SYMBOL_GPL(ide_scsi_expiry);
 
+int ide_cd_get_xferlen(struct request *rq)
+{
+	if (blk_fs_request(rq))
+		return 32768;
+	else if (blk_sense_request(rq) || blk_pc_request(rq) ||
+			 rq->cmd_type == REQ_TYPE_ATA_PC)
+		return rq->data_len;
+	else
+		return 0;
+}
+EXPORT_SYMBOL_GPL(ide_cd_get_xferlen);
+
 /*
  * This is the usual interrupt handler which will be called during a packet
  * command.  We will transfer some of the data (as requested by the drive)
@@ -551,7 +563,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 	struct ide_atapi_pc *pc = drive->pc;
 	ide_hwif_t *hwif = drive->hwif;
 	u32 tf_flags;
-	u16 bcount = 0;
+	u16 bcount;
 	u8 scsi = !!(drive->dev_flags & IDE_DFLAG_SCSI);
 
 	/* We haven't transferred any data yet */
@@ -560,6 +572,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 
 	if (dev_is_idecd(drive)) {
 		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
+		bcount = ide_cd_get_xferlen(hwif->hwgroup->rq);
 	} else if (scsi) {
 		tf_flags = 0;
 		bcount = min(pc->req_xfer, 63 * 1024);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 65e5513..8d3c771 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1214,8 +1214,9 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		      __func__, rq->cmd[0], rq->cmd_type,
 		      (unsigned long long)block);
 
+	xferlen = ide_cd_get_xferlen(rq);
+
 	if (blk_fs_request(rq)) {
-		xferlen = 32768;
 		fn = cdrom_start_rw_cont;
 
 		if (cdrom_start_rw(drive, rq) == ide_stopped)
@@ -1225,7 +1226,6 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 			return ide_stopped;
 	} else if (blk_sense_request(rq) || blk_pc_request(rq) ||
 		   rq->cmd_type == REQ_TYPE_ATA_PC) {
-		xferlen = rq->data_len;
 		fn = cdrom_do_newpc_cont;
 
 		if (!rq->timeout)
diff --git a/include/linux/ide.h b/include/linux/ide.h
index eb4c01f..e35ff68 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1254,6 +1254,8 @@ static inline unsigned long ide_scsi_get_timeout(struct ide_atapi_pc *pc)
 
 int ide_scsi_expiry(ide_drive_t *);
 
+int ide_cd_get_xferlen(struct request *);
+
 ide_startstop_t ide_issue_pc(ide_drive_t *, unsigned int, ide_expiry_t *);
 
 ide_startstop_t do_rw_taskfile(ide_drive_t *, ide_task_t *);
-- 
1.6.0.4

