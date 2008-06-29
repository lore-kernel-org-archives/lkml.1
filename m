Return-Path: <linux-kernel-owner+w=401wt.eu-S1760384AbYF2LBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760384AbYF2LBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 07:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbYF2K7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:59:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:56648 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbYF2K7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=cSzUbCTF7fkGnRdLFcAcxRcy6cq4U0CLKpp/6YIDR2MQt/MtZsWQJqhC+QgTw1MaMk
         QCMAuttPOJ18MJNX27eevNNdUglQ+YNX5BgusyvHi/HcwaDf1xmLy/f4iBSWbL2XE9kL
         1vwwvq5VD59mRYczmNdLxgnvRwwRmtp0FcQqE=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 09/16] ide-scsi: pass packet command in rq->cmd
Date: Sun, 29 Jun 2008 12:59:12 +0200
Message-Id: <1214737159-1078-10-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
References: <1214737159-1078-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make a redundant copy of the packet command bits into rq->cmd.
Later, after all drivers have been converted, it'll be
switched to use that in the common code instead of pc->c.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/scsi/ide-scsi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index a6c2c5f..c637520 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -236,6 +236,7 @@ static int idescsi_check_condition(ide_drive_t *drive,
 		ide_scsi_hex_dump(pc->c, 6);
 	}
 	rq->rq_disk = scsi->disk;
+	memcpy(rq->cmd, pc->c, 12);
 	ide_do_drive_cmd(drive, rq);
 	return 0;
 }
@@ -646,6 +647,7 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	rq->special = (char *) pc;
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	spin_unlock_irq(host->host_lock);
+	memcpy(rq->cmd, pc->c, 12);
 	blk_execute_rq_nowait(drive->queue, scsi->disk, rq, 0, NULL);
 	spin_lock_irq(host->host_lock);
 	return 0;
-- 
1.5.5.4

