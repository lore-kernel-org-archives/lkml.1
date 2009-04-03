Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbZDCH7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbZDCH7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 03:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZDCH6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 03:58:49 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48645 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZDCH6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 03:58:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Sx6/Hr/W7eTag2jwMxb690LHPzAp9LipAxHi/gUgDFW9APOwALSHWFTC67y20upXdL
         qv3ZOr71TNo4Dapb3PmseD+f0JMt6XgQm/H2aLZZ2gcr0wHUQEegApoy4CbY6CUMvk2b
         RKxVlDMockgieR8augcZ/VNyFVCPMYJEvTx7A=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 1/3] ide-cd: carve out an ide_cd_breathe()-helper for fs write requests
Date: Fri,  3 Apr 2009 09:58:37 +0200
Message-Id: <1238745519-19389-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   65 +++++++++++++++++++++++++++++--------------------
 1 files changed, 38 insertions(+), 27 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index a4afd90..7bbdeb7 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -265,7 +265,43 @@ static void ide_cd_complete_failed_rq(ide_drive_t *drive, struct request *rq)
 		cdrom_analyze_sense_data(drive, NULL, sense);
 }
 
+
 /*
+ * Allow the drive 5 seconds to recover; some devices will return NOT_READY
+ * while flushing data from cache.
+ *
+ * returns: 0 failed (write timeout expired)
+ *	    1 success
+ */
+static int ide_cd_breathe(ide_drive_t *drive, struct request *rq)
+{
+
+	struct cdrom_info *info = drive->driver_data;
+
+	if (!rq->errors)
+		info->write_timeout = jiffies +	ATAPI_WAIT_WRITE_BUSY;
+
+	rq->errors = 1;
+
+	if (time_after(jiffies, info->write_timeout))
+		return 0;
+	else {
+		struct request_queue *q = drive->queue;
+		unsigned long flags;
+
+		/*
+		 * take a breather relying on the unplug timer to kick us again
+		 */
+
+		spin_lock_irqsave(q->queue_lock, flags);
+		blk_plug_device(q);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+
+		return 1;
+	}
+}
+
+/**
  * Returns:
  * 0: if the request should be continued.
  * 1: if the request will be going through error recovery.
@@ -348,36 +384,11 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
 				/* fail the request */
 				printk(KERN_ERR PFX "%s: tray open\n",
 						drive->name);
-				do_end_request = 1;
 			} else {
-				struct cdrom_info *info = drive->driver_data;
-
-				/*
-				 * Allow the drive 5 seconds to recover, some
-				 * devices will return this error while flushing
-				 * data from cache.
-				 */
-				if (!rq->errors)
-					info->write_timeout = jiffies +
-							ATAPI_WAIT_WRITE_BUSY;
-				rq->errors = 1;
-				if (time_after(jiffies, info->write_timeout))
-					do_end_request = 1;
-				else {
-					struct request_queue *q = drive->queue;
-					unsigned long flags;
-
-					/*
-					 * take a breather relying on the unplug
-					 * timer to kick us again
-					 */
-					spin_lock_irqsave(q->queue_lock, flags);
-					blk_plug_device(q);
-					spin_unlock_irqrestore(q->queue_lock, flags);
-
+				if (ide_cd_breathe(drive, rq))
 					return 1;
-				}
 			}
+			do_end_request = 1;
 		} else if (sense_key == UNIT_ATTENTION) {
 			/* media change */
 			cdrom_saw_media_change(drive);
-- 
1.6.2.1

