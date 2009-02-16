Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbZBPAO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbZBPAO6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbZBPAMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:12:37 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:51372 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbZBPAMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:12:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=CnJviKYb91dy+Vw4z3amC9mGXOLhRUtx3kxRznLKwvdP6GTQNlRMd4qI/vC3wWJmgy
         FzMux/0JHT+xLRF5Rl6Bv6YyRbCpBnNrCUG9YybqM4HvLfRNXd8qrZKRQMXlB/40EFo+
         15I3UkoCrj3rFcLYmTWOC9Qy2YSKAznhxGOGk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 01:14:02 +0100
Message-Id: <20090216001402.27491.60643.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/20] ide-cd: factor out failed request completion from cdrom_end_request()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: factor out failed request completion from cdrom_end_request()

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   47 +++++++++++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -237,6 +237,29 @@ static void cdrom_queue_request_sense(id
 	elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 0);
 }
 
+static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
+{
+	/*
+	 * For REQ_TYPE_SENSE, "rq->buffer" points to the original
+	 * failed request
+	 */
+	struct request *failed = (struct request *)rq->buffer;
+	struct cdrom_info *info = drive->driver_data;
+	void *sense = &info->sense_data;
+
+	if (failed) {
+		if (failed->sense) {
+			sense = failed->sense;
+			failed->sense_len = rq->sense_len;
+		}
+		cdrom_analyze_sense_data(drive, failed, sense);
+
+		if (ide_end_rq(drive, failed, -EIO, blk_rq_bytes(failed)))
+			BUG();
+	} else
+		cdrom_analyze_sense_data(drive, NULL, sense);
+}
+
 static void cdrom_end_request(ide_drive_t *drive, int uptodate)
 {
 	struct request *rq = drive->hwif->rq;
@@ -245,28 +268,8 @@ static void cdrom_end_request(ide_drive_
 	ide_debug_log(IDE_DBG_FUNC, "cmd: 0x%x, uptodate: 0x%x, nsectors: %d",
 				    rq->cmd[0], uptodate, nsectors);
 
-	if (blk_sense_request(rq) && uptodate) {
-		/*
-		 * For REQ_TYPE_SENSE, "rq->buffer" points to the original
-		 * failed request
-		 */
-		struct request *failed = (struct request *) rq->buffer;
-		struct cdrom_info *info = drive->driver_data;
-		void *sense = &info->sense_data;
-
-		if (failed) {
-			if (failed->sense) {
-				sense = failed->sense;
-				failed->sense_len = rq->sense_len;
-			}
-			cdrom_analyze_sense_data(drive, failed, sense);
-
-			if (ide_end_rq(drive, failed, -EIO,
-				       blk_rq_bytes(failed)))
-				BUG();
-		} else
-			cdrom_analyze_sense_data(drive, NULL, sense);
-	}
+	if (blk_sense_request(rq) && uptodate)
+		ide_cd_complete_failed_rq(drive, rq);
 
 	if (!rq->current_nr_sectors && blk_fs_request(rq))
 		uptodate = 1;
