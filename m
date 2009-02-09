Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbZBIUAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbZBIUAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 15:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756908AbZBIT7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:59:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:43279 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325AbZBIT7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:59:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=F4KRWmgMWvSDEGETtTMHqiWZePoBdk2ZnWsWphkxKt8E1NjvwA7YJFmLJWvKVyItjw
         IzM3juNDdgde0mEXbAl8jCrsUd7c9395ogPmf+zzZQXuQMPL0xoam8Aj5LmibXI4A2Cs
         icxHj/RRPtK935kMCs1TGOXSLuZLsGCDAMxIA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 09 Feb 2009 21:00:57 +0100
Message-Id: <20090209200057.7985.71084.sendpatchset@localhost.localdomain>
In-Reply-To: <20090209200042.7985.94247.sendpatchset@localhost.localdomain>
References: <20090209200042.7985.94247.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/9] ide: add ide_end_rq()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add ide_end_rq()

* Move request dequeuing from __ide_end_request() to ide_end_request().

* Rename __ide_end_request() to ide_end_rq() and export it.

* Fix ide_end_rq() to pass original blk_end_request() return value.

* ide_end_dequeued_request() is used only in cdrom_end_request()
  so inline it there and then remove the function.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    6 ++++--
 drivers/ide/ide-io.c |   45 ++++++++++-----------------------------------
 include/linux/ide.h  |    2 +-
 3 files changed, 15 insertions(+), 38 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -264,8 +264,10 @@ static void cdrom_end_request(ide_drive_
 			 * now end the failed request
 			 */
 			if (blk_fs_request(failed)) {
-				if (ide_end_dequeued_request(drive, failed, 0,
-						failed->hard_nr_sectors))
+				BUG_ON(!blk_rq_started(rq));
+
+				if (ide_end_rq(drive, failed, 0,
+						failed->hard_nr_sectors << 9))
 					BUG();
 			} else {
 				if (blk_end_request(failed, -EIO,
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -54,10 +54,9 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-static int __ide_end_request(ide_drive_t *drive, struct request *rq,
-			     int uptodate, unsigned int nr_bytes, int dequeue)
+int ide_end_rq(ide_drive_t *drive, struct request *rq, int uptodate,
+	       unsigned int nr_bytes)
 {
-	int ret = 1;
 	int error = 0;
 
 	if (uptodate <= 0)
@@ -83,14 +82,9 @@ static int __ide_end_request(ide_drive_t
 		ide_dma_on(drive);
 	}
 
-	if (!blk_end_request(rq, error, nr_bytes))
-		ret = 0;
-
-	if (ret == 0 && dequeue)
-		drive->hwif->rq = NULL;
-
-	return ret;
+	return blk_end_request(rq, error, nr_bytes);
 }
+EXPORT_SYMBOL_GPL(ide_end_rq);
 
 /**
  *	ide_end_request		-	complete an IDE I/O
@@ -107,6 +101,7 @@ int ide_end_request (ide_drive_t *drive,
 {
 	unsigned int nr_bytes = nr_sectors << 9;
 	struct request *rq = drive->hwif->rq;
+	int rc;
 
 	if (!nr_bytes) {
 		if (blk_pc_request(rq))
@@ -115,33 +110,13 @@ int ide_end_request (ide_drive_t *drive,
 			nr_bytes = rq->hard_cur_sectors << 9;
 	}
 
-	return __ide_end_request(drive, rq, uptodate, nr_bytes, 1);
-}
-EXPORT_SYMBOL(ide_end_request);
-
-/**
- *	ide_end_dequeued_request	-	complete an IDE I/O
- *	@drive: IDE device for the I/O
- *	@uptodate:
- *	@nr_sectors: number of sectors completed
- *
- *	Complete an I/O that is no longer on the request queue. This
- *	typically occurs when we pull the request and issue a REQUEST_SENSE.
- *	We must still finish the old request but we must not tamper with the
- *	queue in the meantime.
- *
- *	NOTE: This path does not handle barrier, but barrier is not supported
- *	on ide-cd anyway.
- */
-
-int ide_end_dequeued_request(ide_drive_t *drive, struct request *rq,
-			     int uptodate, int nr_sectors)
-{
-	BUG_ON(!blk_rq_started(rq));
+	rc = ide_end_rq(drive, rq, uptodate, nr_bytes);
+	if (rc == 0)
+		drive->hwif->rq = NULL;
 
-	return __ide_end_request(drive, rq, uptodate, nr_sectors << 9, 0);
+	return rc;
 }
-EXPORT_SYMBOL_GPL(ide_end_dequeued_request);
+EXPORT_SYMBOL(ide_end_request);
 
 void ide_complete_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat, u8 err)
 {
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1128,8 +1128,8 @@ int generic_ide_ioctl(ide_drive_t *, str
 extern int ide_vlb_clk;
 extern int ide_pci_clk;
 
+int ide_end_rq(ide_drive_t *, struct request *, int, unsigned int);
 int ide_end_request(ide_drive_t *, int, int);
-int ide_end_dequeued_request(ide_drive_t *, struct request *, int, int);
 void ide_kill_rq(ide_drive_t *, struct request *);
 
 void __ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int,
