Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbZDPFxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbZDPFxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZDPFxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:53:41 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63248 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZDPFxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=fucPP7qz6xfd/QdfG+Ub9uHXA0GcijRCPp9WhkA/gyFgQgt+uJHjSG8YQRpBEhw0RV
         awxU/bd74dCfhCIkZZucFZbwWHDaja2oUkPi/D8J4hPO2rZnYP6zwgZ/MCKrY7+KIoLt
         Yg6BN2cIj1lE567zALMdIgQej9ViUH+J9B3io=
Date: Thu, 16 Apr 2009 07:53:34 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ide: add helpers for preparing sense requests
Message-ID: <20090416055334.GA21767@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, linux-kernel@vger.kernel.org
References: <49E6A0B5.2090704@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <49E6A0B5.2090704@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation of removing the queueing of a sense request out
of the IRQ handler path.

Use struct request_sense as a general sense buffer for all ATAPI devices
ide-{floppy,tape,cd}.

CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Tejun Heo <tj@kernel.org>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   34 ++++++++++++++++++++++++++++++++++
 include/linux/ide.h     |   10 ++++++++++
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 8054974..1f4d20f 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -200,6 +200,40 @@ void ide_create_request_sense_cmd(ide_drive_t *drive, struct ide_atapi_pc *pc)
 }
 EXPORT_SYMBOL_GPL(ide_create_request_sense_cmd);
 
+struct request *ide_prep_sense(ide_drive_t *drive, struct gendisk *disk)
+{
+	void *sense = &drive->sense_data;
+	unsigned sense_len = sizeof(struct request_sense);
+	struct request *rq;
+
+	debug_log("%s: enter\n", __func__);
+
+	memset(sense, 0, sense_len);
+
+	rq = blk_get_request(drive->queue, 0, __GFP_WAIT);
+
+	if (blk_rq_map_kern(drive->queue, rq, sense, sense_len, __GFP_WAIT))
+		return NULL;
+
+	rq->rq_disk = disk;
+
+	rq->cmd[0] = GPCMD_REQUEST_SENSE;
+	rq->cmd[4] = sense_len;
+
+	rq->cmd_type = REQ_TYPE_SENSE;
+	rq->cmd_flags |= REQ_PREEMPT;
+
+	return rq;
+}
+EXPORT_SYMBOL_GPL(ide_prep_sense);
+
+void ide_queue_sense_rq(ide_drive_t *drive)
+{
+	BUG_ON(!drive->sense_rq);
+	elv_add_request(drive->queue, drive->sense_rq, ELEVATOR_INSERT_FRONT, 0);
+}
+EXPORT_SYMBOL_GPL(ide_queue_sense_rq);
+
 /*
  * Called when an error was detected during the last packet command.
  * We queue a request sense packet command in the head of the request list.
diff --git a/include/linux/ide.h b/include/linux/ide.h
index c942533..095cda2 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -26,6 +26,9 @@
 #include <asm/io.h>
 #include <asm/mutex.h>
 
+/* for request_sense */
+#include <linux/cdrom.h>
+
 #if defined(CONFIG_CRIS) || defined(CONFIG_FRV) || defined(CONFIG_MN10300)
 # define SUPPORT_VLB_SYNC 0
 #else
@@ -605,6 +608,10 @@ struct ide_drive_s {
 	struct request request_sense_rq;
 	struct bio request_sense_bio;
 	struct bio_vec request_sense_bvec[2];
+
+	/* current sense rq and buffer */
+	struct request *sense_rq;
+	struct request_sense sense_data;
 };
 
 typedef struct ide_drive_s ide_drive_t;
@@ -1178,6 +1185,9 @@ int ide_set_media_lock(ide_drive_t *, struct gendisk *, int);
 void ide_create_request_sense_cmd(ide_drive_t *, struct ide_atapi_pc *);
 void ide_retry_pc(ide_drive_t *, struct gendisk *);
 
+struct request *ide_prep_sense(ide_drive_t *, struct gendisk *);
+void ide_queue_sense_rq(ide_drive_t *);
+
 int ide_cd_expiry(ide_drive_t *);
 
 int ide_cd_get_xferlen(struct request *);
-- 
1.6.2.2


-- 
Regards/Gruss,
    Boris.
