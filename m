Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZESVPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZESVPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 17:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbZESVOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 17:14:45 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:65010 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbZESVOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 17:14:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=E4pJmvF9Uyb83Ty8+JBFr9sbubloFJRvRShjPfGGtJPbSpJePA1zT/wBiSSFPvZPNU
         9YJ2sG2BU3LK8CuXzAUKp4s5ExHFV76xPhsFaoTvheRIiwbz/mhB5Z9pN9Fz2mpE/5ZQ
         ltFXccdIpWgOdM7GdXDY2Nk2O0TVFMksBCUjM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: improve failed opcode reporting
Date: Tue, 19 May 2009 23:18:43 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-next-20090518-05332-g0707b5a; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org,
       Martin Lottermoser <Martin.Lottermoser@t-online.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905192318.43760.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nowadays we (almost) always store the currently executing command
in hwif->cmd so we can use it for the failed opcode reporting.

Cc: Martin Lottermoser <Martin.Lottermoser@t-online.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-lib.c |   23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -31,24 +31,6 @@ void ide_toggle_bounce(ide_drive_t *driv
 		blk_queue_bounce_limit(drive->queue, addr);
 }
 
-static void ide_dump_opcode(ide_drive_t *drive)
-{
-	struct request *rq = drive->hwif->rq;
-	struct ide_cmd *cmd = NULL;
-
-	if (!rq)
-		return;
-
-	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
-		cmd = rq->special;
-
-	printk(KERN_ERR "ide: failed opcode was: ");
-	if (cmd == NULL)
-		printk(KERN_CONT "unknown\n");
-	else
-		printk(KERN_CONT "0x%02x\n", cmd->tf.command);
-}
-
 u64 ide_get_lba_addr(struct ide_cmd *cmd, int lba48)
 {
 	struct ide_taskfile *tf = &cmd->tf;
@@ -179,7 +161,10 @@ u8 ide_dump_status(ide_drive_t *drive, c
 		else
 			ide_dump_atapi_error(drive, err);
 	}
-	ide_dump_opcode(drive);
+
+	printk(KERN_ERR "%s: possibly failed opcode: 0x%02x\n",
+		drive->name, drive->hwif->cmd.tf.command);
+
 	return err;
 }
 EXPORT_SYMBOL(ide_dump_status);
