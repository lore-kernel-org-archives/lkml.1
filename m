Return-Path: <linux-kernel-owner+w=401wt.eu-S1760968AbXLTBo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968AbXLTBo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759145AbXLTBfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:35:48 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11731 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758978AbXLTBfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:35:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=cNUZrZuxNMcXzOE5d99omSQkM0R8YDLxoCaszAWi7m8lzRbFpYp777bNX5Wu3zvbu4iCW9UYJD86953mn2d+/BvYxl9cVdBx4DVnF7gakCXUrSK8viWde4/dJ3uDeKdhtuuhbStpGn0Y0TDvyapmTPh/PSkhf5A+CTpcaKI9owg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 62/63] ide-cd: unify request end exit path in cdrom_decode_status()
Date: Thu, 20 Dec 2007 02:39:39 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200239.39261.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-59 bytes
 drivers/ide/ide-cd.c |   50 ++++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -332,7 +332,6 @@ static int cdrom_decode_status(ide_drive
 
 	} else if (blk_pc_request(rq) || rq->cmd_type == REQ_TYPE_ATA_PC) {
 		/* All other functions, except for READ. */
-		unsigned long flags;
 
 		/*
 		 * if we have an error, pass back CHECK_CONDITION as the
@@ -370,15 +369,7 @@ static int cdrom_decode_status(ide_drive
 		 * remove failed request completely and end it when the
 		 * request sense has completed
 		 */
-		if (stat & ERR_STAT) {
-			spin_lock_irqsave(&ide_lock, flags);
-			blkdev_dequeue_request(rq);
-			HWGROUP(drive)->rq = NULL;
-			spin_unlock_irqrestore(&ide_lock, flags);
-
-			cdrom_queue_request_sense(drive, rq->sense, rq);
-		} else
-			cdrom_end_request(drive, 0);
+		goto end_request;
 
 	} else if (blk_fs_request(rq)) {
 		int do_end_request = 0;
@@ -458,23 +449,15 @@ static int cdrom_decode_status(ide_drive
 		   sense data. We need this in order to perform end of media
 		   processing */
 
-		if (do_end_request) {
-			if (stat & ERR_STAT) {
-				unsigned long flags;
-				spin_lock_irqsave(&ide_lock, flags);
-				blkdev_dequeue_request(rq);
-				HWGROUP(drive)->rq = NULL;
-				spin_unlock_irqrestore(&ide_lock, flags);
+		if (do_end_request)
+			goto end_request;
 
-				cdrom_queue_request_sense(drive, rq->sense, rq);
-			} else
-				cdrom_end_request(drive, 0);
-		} else {
-			/* If we got a CHECK_CONDITION status,
-			   queue a request sense command. */
-			if (stat & ERR_STAT)
-				cdrom_queue_request_sense(drive, NULL, NULL);
-		}
+		/*
+		 * If we got a CHECK_CONDITION status,
+		 * queue a request sense command.
+		 */
+		if (stat & ERR_STAT)
+			cdrom_queue_request_sense(drive, NULL, NULL);
 	} else {
 		blk_dump_rq_flags(rq, "ide-cd: bad rq");
 		cdrom_end_request(drive, 0);
@@ -482,6 +465,21 @@ static int cdrom_decode_status(ide_drive
 
 	/* Retry, or handle the next request. */
 	return 1;
+
+end_request:
+	if (stat & ERR_STAT) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&ide_lock, flags);
+		blkdev_dequeue_request(rq);
+		HWGROUP(drive)->rq = NULL;
+		spin_unlock_irqrestore(&ide_lock, flags);
+
+		cdrom_queue_request_sense(drive, rq->sense, rq);
+	} else
+		cdrom_end_request(drive, 0);
+
+	return 1;
 }
 
 static int cdrom_timer_expiry(ide_drive_t *drive)
