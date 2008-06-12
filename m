Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbYFLGr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbYFLGr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759447AbYFLGrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:47:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:21650 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759427AbYFLGri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:47:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=aFJx4FWI/hGoGKgQUU2KnhgvT+zmrtzr3vhijwMUDT9BzRan9UfE1sp45NbzyNJyQX
         VZv326jqLyjXfgDpVhrH5CfRdJ6iSliuBQ6zjh67LvEpz4/Zmek57p8GX8atd1ZeEhfQ
         /dNVVGcSf7Z3g+ShEoiDpPg2y65qH8pqd9Jus=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 12/18] ide-cd: move request prep chunk from cdrom_do_newpc_cont to rq issue path
Date: Thu, 12 Jun 2008 08:41:04 +0200
Message-Id: <1213252870-20474-13-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart: As a nice side effect, this minimizes the IRQ handler execution time.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index a5715b1..0cd23d4 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1167,9 +1167,6 @@ static ide_startstop_t cdrom_do_newpc_cont(ide_drive_t *drive)
 {
 	struct request *rq = HWGROUP(drive)->rq;
 
-	if (!rq->timeout)
-		rq->timeout = ATAPI_WAIT_PC;
-
 	return cdrom_transfer_packet_command(drive, rq, cdrom_newpc_intr);
 }
 
@@ -1253,11 +1250,18 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		}
 		info->last_block = block;
 
-	} else if (blk_sense_request(rq) || blk_pc_request(rq) ||
+	} else if (blk_sense_request(rq) ||
+		   blk_pc_request(rq) ||
 		   rq->cmd_type == REQ_TYPE_ATA_PC) {
+
 		xferlen = rq->data_len;
 		fn = cdrom_do_newpc_cont;
+
+		if (!rq->timeout)
+			rq->timeout = ATAPI_WAIT_PC;
+
 		cdrom_do_block_pc(drive, rq);
+
 	} else if (blk_special_request(rq)) {
 		/* right now this can only be a reset... */
 		cdrom_end_request(drive, 1);
@@ -1271,8 +1275,6 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 	return cdrom_start_packet_command(drive, xferlen, fn);
 }
 
-
-
 /*
  * Ioctl handling.
  *
-- 
1.5.5.1

