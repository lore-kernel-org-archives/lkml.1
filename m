Return-Path: <linux-kernel-owner+w=401wt.eu-S1760915AbXLTBp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915AbXLTBp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759224AbXLTBfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:35:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:12071 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758976AbXLTBfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:35:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=qS1Xh4Nl8w++8ow7VSVZpyB4A10Q4jwR7wRAm10Ch5GOFr1ylDQaBgIhD0AfneRkVleVGjRfdpH23iTXzPHI/N7z1+wqRfMvtUskSHgSCiZ8gt/P6/DHf0XFQjocS6sn+N1hu/HXzhbeeK/iBJLTmlw/bozctHsLw+M4mGyw54g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 61/63] ide-cd: merge cdrom_write_check_ireason() and cdrom_read_check_ireason()
Date: Thu, 20 Dec 2007 02:38:57 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200238.57933.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add 'rw' parameter to cdrom_read_check_ireason(), make it handle
both read and write checking, rename it to ide_cd_check_ireason(),
finally remove no longer needed cdrom_write_check_ireason().

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-61 bytes
 drivers/ide/ide-cd.c |   64 +++++++++++----------------------------------------
 1 file changed, 15 insertions(+), 49 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -683,21 +683,25 @@ static void cdrom_buffer_sectors (ide_dr
  * ok; nonzero if the request has been terminated.
  */
 static
-int cdrom_read_check_ireason (ide_drive_t *drive, int len, int ireason)
+int ide_cd_check_ireason(ide_drive_t *drive, int len, int ireason, int rw)
 {
-	if (ireason == 2)
+	/*
+	 * ireason == 0: the drive wants to receive data from us
+	 * ireason == 2: the drive is expecting to transfer data to us
+	 */
+	if (ireason == (!rw << 1))
 		return 0;
-	else if (ireason == 0) {
+	else if (ireason == (rw << 1)) {
 		ide_hwif_t *hwif = drive->hwif;
+		xfer_func_t *xf;
 
-		/* Whoops... The drive is expecting to receive data from us! */
+		/* Whoops... */
 		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
 				drive->name, __FUNCTION__);
 
-		/* Throw some data at the drive so it doesn't hang
-		   and quit this request. */
-		ide_cd_pad_transfer(drive, hwif->atapi_output_bytes, len);
-	} else  if (ireason == 1) {
+		xf = rw ? hwif->atapi_output_bytes : hwif->atapi_input_bytes;
+		ide_cd_pad_transfer(drive, xf, len);
+	} else  if (rw == 0 && ireason == 1) {
 		/* Some drives (ASUS) seem to tell us that status
 		 * info is available. just get it and ignore.
 		 */
@@ -984,35 +988,6 @@ int ide_cd_queue_pc(ide_drive_t *drive, 
 	return (rq->cmd_flags & REQ_FAILED) ? -EIO : 0;
 }
 
-/*
- * Write handling
- */
-static int cdrom_write_check_ireason(ide_drive_t *drive, int len, int ireason)
-{
-	/* Two notes about IDE interrupt reason here - 0 means that
-	 * the drive wants to receive data from us, 2 means that
-	 * the drive is expecting to transfer data to us.
-	 */
-	if (ireason == 0)
-		return 0;
-	else if (ireason == 2) {
-		ide_hwif_t *hwif = drive->hwif;
-
-		/* Whoops... The drive wants to send data. */
-		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
-				drive->name, __FUNCTION__);
-
-		ide_cd_pad_transfer(drive, hwif->atapi_input_bytes, len);
-	} else {
-		/* Drive wants a command packet, or invalid ireason... */
-		printk(KERN_ERR "%s: %s: bad interrupt reason 0x%02x\n",
-				drive->name, __FUNCTION__, ireason);
-	}
-
-	cdrom_end_request(drive, 0);
-	return 1;
-}
-
 static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 {
 	struct cdrom_info *info = drive->driver_data;
@@ -1100,20 +1075,11 @@ static ide_startstop_t cdrom_newpc_intr(
 	/*
 	 * check which way to transfer data
 	 */
-	if ((blk_fs_request(rq) || blk_pc_request(rq)) && write) {
-		/*
-		 * write to drive
-		 */
-		if (cdrom_write_check_ireason(drive, len, ireason))
-			return ide_stopped;
-	} else if (blk_fs_request(rq) || blk_pc_request(rq)) {
-		/*
-		 * read from drive
-		 */
-		if (cdrom_read_check_ireason(drive, len, ireason))
+	if (blk_fs_request(rq) || blk_pc_request(rq)) {
+		if (ide_cd_check_ireason(drive, len, ireason, write))
 			return ide_stopped;
 
-		if (blk_fs_request(rq)) {
+		if (blk_fs_request(rq) && write == 0) {
 			int nskip;
 
 			if (ide_cd_check_transfer_size(drive, len)) {
