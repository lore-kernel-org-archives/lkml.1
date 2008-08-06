Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbYHFRRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbYHFRRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 13:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756681AbYHFRRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 13:17:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:25370 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261AbYHFRR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 13:17:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=spU0hx/gEF2tLbdLxvwMsIv1zyQl6hvsSuySjE2Ha4EyoIVZZMZSbKge6jVoIrkMnp
         zlMEDvadXZPksvgGvsp/9r2vSy5zYqoH7ad5d88XVSSv5WazDJ5DyRHiDUHCyB/Cw5Xz
         psS7lHkC1/UZqQIKhJhnATHSTCKV+oTl8UcpY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/2] ide-tape: remove idetape_init_rq()
Date: Wed, 6 Aug 2008 19:13:20 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808061913.21467.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idetape_init_rq() is only used in idetape_queue_pc_head()
so inline it there.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -689,13 +689,6 @@ static void idetape_create_request_sense
 	pc->req_xfer = 20;
 }
 
-static void idetape_init_rq(struct request *rq, u8 cmd)
-{
-	blk_rq_init(NULL, rq);
-	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd[13] = cmd;
-}
-
 /*
  * Generate a new packet command request in front of the request queue, before
  * the current request, so that it will be processed immediately, on the next
@@ -716,11 +709,13 @@ static void idetape_queue_pc_head(ide_dr
 {
 	struct ide_tape_obj *tape = drive->driver_data;
 
-	idetape_init_rq(rq, REQ_IDETAPE_PC1);
+	blk_rq_init(NULL, rq);
+	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd_flags |= REQ_PREEMPT;
 	rq->buffer = (char *) pc;
 	rq->rq_disk = tape->disk;
 	memcpy(rq->cmd, pc->c, 12);
+	rq->cmd[13] = REQ_IDETAPE_PC1;
 	ide_do_drive_cmd(drive, rq);
 }
 
