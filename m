Return-Path: <linux-kernel-owner+w=401wt.eu-S1757678AbZBIUBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbZBIUBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 15:01:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbZBIT7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:59:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:43279 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936AbZBIT7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:59:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=o8pQDvRUc73cqH6rKc2/XKbGMfqiXsSHtGMvdLZRk4r+Vnq4zBNNvw+RDXfpoQEbCH
         q+ImXPKGCShB0s+pMYrSVhTHOvqbx2ShLv7pFf1v3+8fJ114CDAIfytHcGaedutlGzyB
         qJrbZAI5qhG/r9V+2UvOOzwkDUwQlPfyrrxgo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 09 Feb 2009 21:01:05 +0100
Message-Id: <20090209200105.7985.54457.sendpatchset@localhost.localdomain>
In-Reply-To: <20090209200042.7985.94247.sendpatchset@localhost.localdomain>
References: <20090209200042.7985.94247.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/9] ide: sanitize ide_end_rq()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: sanitize ide_end_rq()

* Move 'uptodate' quirk from ide_end_rq() to its users.

* Move quirks for blk_noretry_request() and !blk_fs_request()
  requests from ide_end_rq() to ide_end_request().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    2 +-
 drivers/ide/ide-io.c |   34 ++++++++++++++++------------------
 2 files changed, 17 insertions(+), 19 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -266,7 +266,7 @@ static void cdrom_end_request(ide_drive_
 			if (blk_fs_request(failed)) {
 				BUG_ON(!blk_rq_started(rq));
 
-				if (ide_end_rq(drive, failed, 0,
+				if (ide_end_rq(drive, failed, -EIO,
 						failed->hard_nr_sectors << 9))
 					BUG();
 			} else {
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -54,24 +54,9 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-int ide_end_rq(ide_drive_t *drive, struct request *rq, int uptodate,
+int ide_end_rq(ide_drive_t *drive, struct request *rq, int error,
 	       unsigned int nr_bytes)
 {
-	int error = 0;
-
-	if (uptodate <= 0)
-		error = uptodate ? uptodate : -EIO;
-
-	/*
-	 * if failfast is set on a request, override number of sectors and
-	 * complete the whole request right now
-	 */
-	if (blk_noretry_request(rq) && error)
-		nr_bytes = rq->hard_nr_sectors << 9;
-
-	if (!blk_fs_request(rq) && error && !rq->errors)
-		rq->errors = -EIO;
-
 	/*
 	 * decide whether to reenable DMA -- 3 is a random magic for now,
 	 * if we DMA timeout more than 3 times, just stay in PIO
@@ -101,7 +86,7 @@ int ide_end_request (ide_drive_t *drive,
 {
 	unsigned int nr_bytes = nr_sectors << 9;
 	struct request *rq = drive->hwif->rq;
-	int rc;
+	int rc, error = 0;
 
 	if (!nr_bytes) {
 		if (blk_pc_request(rq))
@@ -110,7 +95,20 @@ int ide_end_request (ide_drive_t *drive,
 			nr_bytes = rq->hard_cur_sectors << 9;
 	}
 
-	rc = ide_end_rq(drive, rq, uptodate, nr_bytes);
+	/*
+	 * if failfast is set on a request, override number of sectors
+	 * and complete the whole request right now
+	 */
+	if (blk_noretry_request(rq) && uptodate <= 0)
+		nr_bytes = rq->hard_nr_sectors << 9;
+
+	if (blk_fs_request(rq) == 0 && uptodate <= 0 && rq->errors == 0)
+		rq->errors = -EIO;
+
+	if (uptodate <= 0)
+		error = uptodate ? uptodate : -EIO;
+
+	rc = ide_end_rq(drive, rq, error, nr_bytes);
 	if (rc == 0)
 		drive->hwif->rq = NULL;
 
