Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbYDLSwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbYDLSwA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbYDLSvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:51:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:18134 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbYDLSvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:51:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=reaRr8A0onS3XGMFAIIc499tfyBcM5glSBoIyVmoq7MSKWDexf2Q9EERtj6QxLLjSdhNiamcAuSU94jLhFCsWiKqgCbli/6QxK9SgnkynZud66bg1KnSNnI07U56bP52iouxQNNi0PknwjdV6GQ2q4z6XSamhOTcNLZ0RzjHicE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/5] ide: add ide_pad_transfer() helper
Date: Sat, 12 Apr 2008 21:03:15 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804122103.15491.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ide_pad_transfer() helper (which uses ->{in,out}put_data methods
  internally so the transfer is also padded to drive+host requirements)
  and use it instead of ide_atapi_{write_zeros,discard_data}().

* Remove no longer needed ide_atapi_{write_zeros,discard_data}().

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |    7 ++-----
 drivers/ide/ide-io.c     |   15 +++++++++++++++
 drivers/ide/ide-tape.c   |    4 ++--
 drivers/scsi/ide-scsi.c  |    6 +++---
 include/linux/ide.h      |   25 ++-----------------------
 5 files changed, 24 insertions(+), 33 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -262,10 +262,7 @@ static void ide_floppy_io_buffers(ide_dr
 	if (bcount) {
 		printk(KERN_ERR "%s: leftover data in %s, bcount == %d\n",
 				drive->name, __func__, bcount);
-		if (direction)
-			ide_atapi_write_zeros(drive, bcount);
-		else
-			ide_atapi_discard_data(drive, bcount);
+		ide_pad_transfer(drive, direction, bcount);
 	}
 }
 
@@ -491,7 +488,7 @@ static ide_startstop_t idefloppy_pc_intr
 				printk(KERN_ERR "ide-floppy: The floppy wants "
 					"to send us more data than expected "
 					"- discarding data\n");
-				ide_atapi_discard_data(drive, bcount);
+				ide_pad_transfer(drive, 0, bcount);
 
 				ide_set_handler(drive,
 						&idefloppy_pc_intr,
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -1642,3 +1642,18 @@ void ide_pktcmd_tf_load(ide_drive_t *dri
 }
 
 EXPORT_SYMBOL_GPL(ide_pktcmd_tf_load);
+
+void ide_pad_transfer(ide_drive_t *drive, int write, int len)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 buf[4] = { 0 };
+
+	while (len > 0) {
+		if (write)
+			hwif->output_data(drive, NULL, buf, min(4, len));
+		else
+			hwif->input_data(drive, NULL, buf, min(4, len));
+		len -= 4;
+	}
+}
+EXPORT_SYMBOL_GPL(ide_pad_transfer);
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -395,7 +395,7 @@ static void idetape_input_buffers(ide_dr
 		if (bh == NULL) {
 			printk(KERN_ERR "ide-tape: bh == NULL in "
 				"idetape_input_buffers\n");
-			ide_atapi_discard_data(drive, bcount);
+			ide_pad_transfer(drive, 0, bcount);
 			return;
 		}
 		count = min(
@@ -871,7 +871,7 @@ static ide_startstop_t idetape_pc_intr(i
 				printk(KERN_ERR "ide-tape: The tape wants to "
 					"send us more data than expected "
 					"- discarding data\n");
-				ide_atapi_discard_data(drive, bcount);
+				ide_pad_transfer(drive, 0, bcount);
 				ide_set_handler(drive, &idetape_pc_intr,
 						IDETAPE_WAIT_CMD, NULL);
 				return ide_started;
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -164,7 +164,7 @@ static void idescsi_input_buffers(ide_dr
 
 	if (bcount) {
 		printk (KERN_ERR "ide-scsi: scatter gather table too small, discarding data\n");
-		ide_atapi_discard_data(drive, bcount);
+		ide_pad_transfer(drive, 0, bcount);
 	}
 }
 
@@ -201,7 +201,7 @@ static void idescsi_output_buffers(ide_d
 
 	if (bcount) {
 		printk (KERN_ERR "ide-scsi: scatter gather table too small, padding with zeros\n");
-		ide_atapi_write_zeros(drive, bcount);
+		ide_pad_transfer(drive, 1, bcount);
 	}
 }
 
@@ -438,7 +438,7 @@ static ide_startstop_t idescsi_pc_intr (
 				}
 				pc->xferred += temp;
 				pc->cur_pos += temp;
-				ide_atapi_discard_data(drive, bcount - temp);
+				ide_pad_transfer(drive, 0, bcount - temp);
 				ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
 				return ide_started;
 			}
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -816,6 +816,8 @@ void ide_execute_command(ide_drive_t *, 
 
 void ide_execute_pkt_cmd(ide_drive_t *);
 
+void ide_pad_transfer(ide_drive_t *, int, int);
+
 ide_startstop_t __ide_error(ide_drive_t *, struct request *, u8, u8);
 
 ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, byte stat);
@@ -1346,27 +1348,4 @@ static inline u8 ide_read_error(ide_driv
 
 	return hwif->INB(hwif->io_ports.error_addr);
 }
-
-/*
- * Too bad. The drive wants to send us data which we are not ready to accept.
- * Just throw it away.
- */
-static inline void ide_atapi_discard_data(ide_drive_t *drive, unsigned bcount)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	/* FIXME: use ->input_data */
-	while (bcount--)
-		(void)hwif->INB(hwif->io_ports.data_addr);
-}
-
-static inline void ide_atapi_write_zeros(ide_drive_t *drive, unsigned bcount)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	/* FIXME: use ->output_data */
-	while (bcount--)
-		hwif->OUTB(0, hwif->io_ports.data_addr);
-}
-
 #endif /* _IDE_H */
