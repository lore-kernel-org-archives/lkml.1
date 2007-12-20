Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbXLTBiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbXLTBiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:38:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbXLTBen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:34:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:11733 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629AbXLTBeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=FzOUWVFAZYY9QbWqwuxDRIf0dhMYO+wQod0R9/yGIiY2c6voS0d/MKKXfrPWoMKJSjDM9mIJqH9lFIn2tvhbp04yxutnFiIEewU12l6SGk48XJxSBIDHFIU1kx4M7ZnloqUYJgJWxINVlpx/Vb3FqOqoOdVRlJSqkDC17Yl0j9E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 10/63] ide-cd: use xfer_func_t in cdrom_pc_intr()
Date: Thu, 20 Dec 2007 01:59:49 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200159.49846.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Unify writing and reading handling in cdrom_pc_intr() using xfer_func_t.

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   47 +++++++++++++++++------------------------------
 1 file changed, 17 insertions(+), 30 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1005,6 +1005,8 @@ static ide_startstop_t cdrom_transfer_pa
  * Block read functions.
  */
 
+typedef void (xfer_func_t)(ide_drive_t *, void *, u32);
+
 /*
  * Buffer up to SECTORS_TO_TRANSFER sectors from the drive in our sector
  * buffer.  Once the first sector is added, any subsequent sectors are
@@ -1430,10 +1432,10 @@ static ide_startstop_t cdrom_start_read 
 /* Interrupt routine for packet command completion. */
 static ide_startstop_t cdrom_pc_intr (ide_drive_t *drive)
 {
-	int ireason, len, thislen;
 	struct request *rq = HWGROUP(drive)->rq;
+	xfer_func_t *xferfunc = NULL;
+	int stat, ireason, len, thislen, write;
 	u8 lowcyl = 0, highcyl = 0;
-	int stat;
 
 	/* Check for errors. */
 	if (cdrom_decode_status(drive, 0, &stat))
@@ -1478,44 +1480,31 @@ static ide_startstop_t cdrom_pc_intr (id
 
 	/* Figure out how much data to transfer. */
 	thislen = rq->data_len;
-	if (thislen > len) thislen = len;
+	if (thislen > len)
+		thislen = len;
 
-	/* The drive wants to be written to. */
 	if (ireason == 0) {
-		if (!rq->data) {
-			blk_dump_rq_flags(rq, "cdrom_pc_intr, write");
-			goto confused;
-		}
-		/* Transfer the data. */
-		HWIF(drive)->atapi_output_bytes(drive, rq->data, thislen);
-
-		/* If we haven't moved enough data to satisfy the drive,
-		   add some padding. */
-		while (len > thislen) {
-			int dum = 0;
-			HWIF(drive)->atapi_output_bytes(drive, &dum, sizeof(dum));
-			len -= sizeof(dum);
-		}
-
-		/* Keep count of how much data we've moved. */
-		rq->data += thislen;
-		rq->data_len -= thislen;
+		write = 1;
+		xferfunc = HWIF(drive)->atapi_output_bytes;
+	} else if (ireason == 2) {
+		write = 0;
+		xferfunc = HWIF(drive)->atapi_input_bytes;
 	}
 
-	/* Same drill for reading. */
-	else if (ireason == 2) {
+	if (xferfunc) {
 		if (!rq->data) {
-			blk_dump_rq_flags(rq, "cdrom_pc_intr, read");
+			blk_dump_rq_flags(rq, write ? "cdrom_pc_intr, write"
+						    : "cdrom_pc_intr, read");
 			goto confused;
 		}
 		/* Transfer the data. */
-		HWIF(drive)->atapi_input_bytes(drive, rq->data, thislen);
+		xferfunc(drive, rq->data, thislen);
 
 		/* If we haven't moved enough data to satisfy the drive,
 		   add some padding. */
 		while (len > thislen) {
 			int dum = 0;
-			HWIF(drive)->atapi_input_bytes(drive, &dum, sizeof(dum));
+			xferfunc(drive, &dum, sizeof(dum));
 			len -= sizeof(dum);
 		}
 
@@ -1523,7 +1512,7 @@ static ide_startstop_t cdrom_pc_intr (id
 		rq->data += thislen;
 		rq->data_len -= thislen;
 
-		if (blk_sense_request(rq))
+		if (write && blk_sense_request(rq))
 			rq->sense_len += thislen;
 	} else {
 confused:
@@ -1647,8 +1636,6 @@ static int cdrom_write_check_ireason(ide
 	return 1;
 }
 
-typedef void (xfer_func_t)(ide_drive_t *, void *, u32);
-
 /*
  * best way to deal with dma that is not sector aligned right now... note
  * that in this path we are not using ->data or ->buffer at all. this irs
