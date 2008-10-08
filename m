Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbYJHUcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbYJHUcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 16:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbYJHUbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 16:31:46 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:26067 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbYJHUbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 16:31:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=hwsbugyz77kEPPDnz6kI4wsl66Wa2gB4FE4yu2igjGUg6l8aqvIDAgfGglA2ItXHzR
         FANBqmbafwHbzHX/KXutmZyrNQjgoK2MM13tNozy0NUsmhMgtTBr9PDuvCQp/57J4xsP
         X89z+AOh1Kwg+20U1QKcKnWzuS3dwcAy8Kww8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 08 Oct 2008 22:30:10 +0200
Message-Id: <20081008203010.19112.41726.sendpatchset@localhost.localdomain>
In-Reply-To: <20081008202930.19112.90371.sendpatchset@localhost.localdomain>
References: <20081008202930.19112.90371.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/7] ide: push ide_lock to __ide_end_request()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: push ide_lock to __ide_end_request()

__ide_end_request() needs ide_lock only for __blk_end_request()
call so push ide_lock taking inside __ide_end_requests().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -58,6 +58,7 @@
 static int __ide_end_request(ide_drive_t *drive, struct request *rq,
 			     int uptodate, unsigned int nr_bytes, int dequeue)
 {
+	unsigned long flags;
 	int ret = 1;
 	int error = 0;
 
@@ -84,11 +85,13 @@ static int __ide_end_request(ide_drive_t
 		ide_dma_on(drive);
 	}
 
-	if (!__blk_end_request(rq, error, nr_bytes)) {
-		if (dequeue)
-			HWGROUP(drive)->rq = NULL;
+	spin_lock_irqsave(&ide_lock, flags);
+	if (!__blk_end_request(rq, error, nr_bytes))
 		ret = 0;
-	}
+	spin_unlock_irqrestore(&ide_lock, flags);
+
+	if (ret == 0 && dequeue)
+		drive->hwif->hwgroup->rq = NULL;
 
 	return ret;
 }
@@ -108,8 +111,6 @@ int ide_end_request (ide_drive_t *drive,
 {
 	unsigned int nr_bytes = nr_sectors << 9;
 	struct request *rq = drive->hwif->hwgroup->rq;
-	unsigned long flags;
-	int ret = 1;
 
 	if (!nr_bytes) {
 		if (blk_pc_request(rq))
@@ -118,11 +119,7 @@ int ide_end_request (ide_drive_t *drive,
 			nr_bytes = rq->hard_cur_sectors << 9;
 	}
 
-	spin_lock_irqsave(&ide_lock, flags);
-	ret = __ide_end_request(drive, rq, uptodate, nr_bytes, 1);
-	spin_unlock_irqrestore(&ide_lock, flags);
-
-	return ret;
+	return __ide_end_request(drive, rq, uptodate, nr_bytes, 1);
 }
 EXPORT_SYMBOL(ide_end_request);
 
@@ -232,16 +229,9 @@ out_do_tf:
 int ide_end_dequeued_request(ide_drive_t *drive, struct request *rq,
 			     int uptodate, int nr_sectors)
 {
-	unsigned long flags;
-	int ret;
-
 	BUG_ON(!blk_rq_started(rq));
 
-	spin_lock_irqsave(&ide_lock, flags);
-	ret = __ide_end_request(drive, rq, uptodate, nr_sectors << 9, 0);
-	spin_unlock_irqrestore(&ide_lock, flags);
-
-	return ret;
+	return __ide_end_request(drive, rq, uptodate, nr_sectors << 9, 0);
 }
 EXPORT_SYMBOL_GPL(ide_end_dequeued_request);
 
