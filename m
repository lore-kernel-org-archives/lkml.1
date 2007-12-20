Return-Path: <linux-kernel-owner+w=401wt.eu-S1759665AbXLTBi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759665AbXLTBi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758818AbXLTBeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:34:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:12147 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986AbXLTBeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ZLQbWXDRKVYAhppldscL3YYcYYeYv4VQoBIUfzDHk9V9WLMWIErDcPqqguZrJSL501EO+LE7JFOw7cm436/8ozsArR/iqqtdXLGCUBnzIopBedAu3jWkY/5J6Hrx+H4oMHqd6yN3/QQRZuGcIdi/TmUpdozGbCSZBbB3z5fXTHU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 11/63] ide-cd: add ide_cd_pad_transfer() helper
Date: Thu, 20 Dec 2007 02:00:38 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200200.38615.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add ide_cd_pad_transfer() helper and use it in cdrom_[new]pc_intr()
and cdrom_{read,write}_check_ireason().

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-39 bytes
 drivers/ide/ide-cd.c |   51 +++++++++++++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1007,6 +1007,15 @@ static ide_startstop_t cdrom_transfer_pa
 
 typedef void (xfer_func_t)(ide_drive_t *, void *, u32);
 
+static void ide_cd_pad_transfer(ide_drive_t *drive, xfer_func_t *xf, int len)
+{
+	while (len > 0) {
+		int dum = 0;
+		xf(drive, &dum, sizeof(dum));
+		len -= sizeof(dum);
+	}
+}
+
 /*
  * Buffer up to SECTORS_TO_TRANSFER sectors from the drive in our sector
  * buffer.  Once the first sector is added, any subsequent sectors are
@@ -1063,17 +1072,15 @@ int cdrom_read_check_ireason (ide_drive_
 	if (ireason == 2)
 		return 0;
 	else if (ireason == 0) {
+		ide_hwif_t *hwif = drive->hwif;
+
 		/* Whoops... The drive is expecting to receive data from us! */
 		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
 				drive->name, __FUNCTION__);
 
 		/* Throw some data at the drive so it doesn't hang
 		   and quit this request. */
-		while (len > 0) {
-			int dum = 0;
-			HWIF(drive)->atapi_output_bytes(drive, &dum, sizeof (dum));
-			len -= sizeof (dum);
-		}
+		ide_cd_pad_transfer(drive, hwif->atapi_output_bytes, len);
 	} else  if (ireason == 1) {
 		/* Some drives (ASUS) seem to tell us that status
 		 * info is available. just get it and ignore.
@@ -1500,15 +1507,8 @@ static ide_startstop_t cdrom_pc_intr (id
 		/* Transfer the data. */
 		xferfunc(drive, rq->data, thislen);
 
-		/* If we haven't moved enough data to satisfy the drive,
-		   add some padding. */
-		while (len > thislen) {
-			int dum = 0;
-			xferfunc(drive, &dum, sizeof(dum));
-			len -= sizeof(dum);
-		}
-
 		/* Keep count of how much data we've moved. */
+		len -= thislen;
 		rq->data += thislen;
 		rq->data_len -= thislen;
 
@@ -1525,6 +1525,13 @@ confused:
 		return ide_stopped;
 	}
 
+	/*
+	 * If we haven't moved enough data to satisfy the drive,
+	 * add some padding.
+	 */
+	if (len > 0)
+		ide_cd_pad_transfer(drive, xferfunc, len);
+
 	/* Now we wait for another interrupt. */
 	ide_set_handler(drive, &cdrom_pc_intr, ATAPI_WAIT_PC, cdrom_timer_expiry);
 	return ide_started;
@@ -1617,15 +1624,13 @@ static int cdrom_write_check_ireason(ide
 	if (ireason == 0)
 		return 0;
 	else if (ireason == 2) {
+		ide_hwif_t *hwif = drive->hwif;
+
 		/* Whoops... The drive wants to send data. */
 		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
 				drive->name, __FUNCTION__);
 
-		while (len > 0) {
-			int dum = 0;
-			HWIF(drive)->atapi_input_bytes(drive, &dum, sizeof(dum));
-			len -= sizeof(dum);
-		}
+		ide_cd_pad_transfer(drive, hwif->atapi_input_bytes, len);
 	} else {
 		/* Drive wants a command packet, or invalid ireason... */
 		printk(KERN_ERR "%s: %s: bad interrupt reason 0x02%x\n",
@@ -1754,14 +1759,8 @@ static ide_startstop_t cdrom_newpc_intr(
 	/*
 	 * pad, if necessary
 	 */
-	if (len > 0) {
-		while (len > 0) {
-			int pad = 0;
-
-			xferfunc(drive, &pad, sizeof(pad));
-			len -= sizeof(pad);
-		}
-	}
+	if (len > 0)
+		ide_cd_pad_transfer(drive, xferfunc, len);
 
 	BUG_ON(HWGROUP(drive)->handler != NULL);
 
