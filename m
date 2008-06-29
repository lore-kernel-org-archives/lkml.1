Return-Path: <linux-kernel-owner+w=401wt.eu-S1760913AbYF2LCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760913AbYF2LCt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 07:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbYF2K7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 06:59:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:56595 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbYF2K7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 06:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=XC0Pto54RFb0NLX2PtEhWbNtcHcx9E+zt5YZS65f5EIHtGyouxxgcNGot4wEP/HUaZ
         BqSkkmnF2ApWE/Foy7qBTpXgku5UIxhtvvKEy87kRjGL/loHEYynd5Sa6ljVTV8ik6m9
         ++RAfJWY/AQ3cdq/3yDO4zTITs348wU6CgLqI=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 06/16] ide-floppy: pass packet command in rq->cmd
Date: Sun, 29 Jun 2008 12:59:09 +0200
Message-Id: <1214737159-1078-7-git-send-email-petkovbb@gmail.com>
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
 drivers/ide/ide-floppy.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index b5b3191..37146d3 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -291,6 +291,7 @@ static void idefloppy_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd_flags |= REQ_PREEMPT;
 	rq->rq_disk = floppy->disk;
+	memcpy(rq->cmd, pc->c, 12);
 	ide_do_drive_cmd(drive, rq);
 }
 
@@ -573,6 +574,8 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
 	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
 
+	memcpy(rq->cmd, pc->c, 12);
+
 	pc->rq = rq;
 	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
 	if (rq->cmd_flags & REQ_RW)
@@ -670,6 +673,7 @@ static int idefloppy_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
 	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
 	rq->buffer = (char *) pc;
 	rq->cmd_type = REQ_TYPE_SPECIAL;
+	memcpy(rq->cmd, pc->c, 12);
 	error = blk_execute_rq(drive->queue, floppy->disk, rq, 0);
 	blk_put_request(rq);
 
-- 
1.5.5.4

