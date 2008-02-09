Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbYBIQTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbYBIQTe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 11:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbYBIQSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 11:18:43 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:3771 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbYBIQSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 11:18:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Ytd7xjSuicdYx6vSVptscMd6qw4hY+KaZWvx9dbL7jiam7nmVFDfmc/w3fPK1IMuItWUtIyCtodZXrllLLGHX2LrW4vVOyR31M6IJ1HSZbd4KKAlS4CNSugv8VwBvCyNUYGWB6RutCTg/6oH9CL26r3somZhlWPra6rDp0gGEJo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ide: add ide_atapi_{discard_data,write_zeros} inline helpers
Date: Sat, 9 Feb 2008 16:23:52 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802091623.52674.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add ide_atapi_{discard_data,write_zeros} inline helpers to <linux/ide.h>
and use them instead of home-brewn helpers in ide-{floppy,tape,scsi}.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |   24 +++---------------------
 drivers/ide/ide-tape.c   |   14 ++------------
 drivers/scsi/ide-scsi.c  |   18 +++---------------
 include/linux/ide.h      |   22 ++++++++++++++++++++++
 4 files changed, 30 insertions(+), 48 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -230,23 +230,6 @@ static void ide_floppy_put(struct ide_fl
 }
 
 /*
- * Too bad. The drive wants to send us data which we are not ready to accept.
- * Just throw it away.
- */
-static void idefloppy_discard_data(ide_drive_t *drive, unsigned int bcount)
-{
-	while (bcount--)
-		(void) HWIF(drive)->INB(IDE_DATA_REG);
-}
-
-static void idefloppy_write_zeros(ide_drive_t *drive, unsigned int bcount)
-{
-	while (bcount--)
-		HWIF(drive)->OUTB(0, IDE_DATA_REG);
-}
-
-
-/*
  * Used to finish servicing a request. For read/write requests, we will call
  * ide_end_request to pass to the next buffer.
  */
@@ -313,10 +296,9 @@ static void ide_floppy_io_buffers(ide_dr
 		printk(KERN_ERR "%s: leftover data in %s, bcount == %d\n",
 				drive->name, __func__, bcount);
 		if (direction)
-			idefloppy_write_zeros(drive, bcount);
+			ide_atapi_write_zeros(drive, bcount);
 		else
-			idefloppy_discard_data(drive, bcount);
-
+			ide_atapi_discard_data(drive, bcount);
 	}
 }
 
@@ -541,7 +523,7 @@ static ide_startstop_t idefloppy_pc_intr
 				printk(KERN_ERR "ide-floppy: The floppy wants "
 					"to send us more data than expected "
 					"- discarding data\n");
-				idefloppy_discard_data(drive, bcount);
+				ide_atapi_discard_data(drive, bcount);
 
 				ide_set_handler(drive,
 						&idefloppy_pc_intr,
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -518,16 +518,6 @@ static struct ide_tape_obj *ide_tape_chr
 	return tape;
 }
 
-/*
- * Too bad. The drive wants to send us data which we are not ready to accept.
- * Just throw it away.
- */
-static void idetape_discard_data(ide_drive_t *drive, unsigned int bcount)
-{
-	while (bcount--)
-		(void) HWIF(drive)->INB(IDE_DATA_REG);
-}
-
 static void idetape_input_buffers(ide_drive_t *drive, idetape_pc_t *pc,
 				  unsigned int bcount)
 {
@@ -538,7 +528,7 @@ static void idetape_input_buffers(ide_dr
 		if (bh == NULL) {
 			printk(KERN_ERR "ide-tape: bh == NULL in "
 				"idetape_input_buffers\n");
-			idetape_discard_data(drive, bcount);
+			ide_atapi_discard_data(drive, bcount);
 			return;
 		}
 		count = min(
@@ -1152,7 +1142,7 @@ static ide_startstop_t idetape_pc_intr(i
 				printk(KERN_ERR "ide-tape: The tape wants to "
 					"send us more data than expected "
 					"- discarding data\n");
-				idetape_discard_data(drive, bcount);
+				ide_atapi_discard_data(drive, bcount);
 				ide_set_handler(drive, &idetape_pc_intr,
 						IDETAPE_WAIT_CMD, NULL);
 				return ide_started;
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -152,18 +152,6 @@ static inline idescsi_scsi_t *drive_to_i
  */
 #define IDESCSI_PC_RQ			90
 
-static void idescsi_discard_data (ide_drive_t *drive, unsigned int bcount)
-{
-	while (bcount--)
-		(void) HWIF(drive)->INB(IDE_DATA_REG);
-}
-
-static void idescsi_output_zeros (ide_drive_t *drive, unsigned int bcount)
-{
-	while (bcount--)
-		HWIF(drive)->OUTB(0, IDE_DATA_REG);
-}
-
 /*
  *	PIO data transfer routines using the scatter gather table.
  */
@@ -200,7 +188,7 @@ static void idescsi_input_buffers (ide_d
 
 	if (bcount) {
 		printk (KERN_ERR "ide-scsi: scatter gather table too small, discarding data\n");
-		idescsi_discard_data (drive, bcount);
+		ide_atapi_discard_data(drive, bcount);
 	}
 }
 
@@ -237,7 +225,7 @@ static void idescsi_output_buffers (ide_
 
 	if (bcount) {
 		printk (KERN_ERR "ide-scsi: scatter gather table too small, padding with zeros\n");
-		idescsi_output_zeros (drive, bcount);
+		ide_atapi_write_zeros(drive, bcount);
 	}
 }
 
@@ -463,7 +451,7 @@ static ide_startstop_t idescsi_pc_intr (
 				}
 				pc->actually_transferred += temp;
 				pc->current_position += temp;
-				idescsi_discard_data(drive, bcount - temp);
+				ide_atapi_discard_data(drive, bcount - temp);
 				ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
 				return ide_started;
 			}
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1299,4 +1299,26 @@ static inline u8 ide_read_error(ide_driv
 	return hwif->INB(hwif->io_ports[IDE_ERROR_OFFSET]);
 }
 
+/*
+ * Too bad. The drive wants to send us data which we are not ready to accept.
+ * Just throw it away.
+ */
+static inline void ide_atapi_discard_data(ide_drive_t *drive, unsigned bcount)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	/* FIXME: use ->atapi_input_bytes */
+	while (bcount--)
+		(void)hwif->INB(hwif->io_ports[IDE_DATA_OFFSET]);
+}
+
+static inline void ide_atapi_write_zeros(ide_drive_t *drive, unsigned bcount)
+{
+	ide_hwif_t *hwif = drive->hwif;
+
+	/* FIXME: use ->atapi_output_bytes */
+	while (bcount--)
+		hwif->OUTB(0, hwif->io_ports[IDE_DATA_OFFSET]);
+}
+
 #endif /* _IDE_H */
