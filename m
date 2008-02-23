Return-Path: <linux-kernel-owner+w=401wt.eu-S1762623AbYBWS65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762623AbYBWS65 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760325AbYBWS61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:58:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:8664 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbYBWS6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:58:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ZQBLx4mFx1HmF1B5U+6Ee8nadVl7Oo9YXwx8R5fRlXesPdbrsTmEd05bQpwfaGiFyTzlZdssPQL6LU0Jkik8QAQfOPJqeygKOiXGBBlKvSn0kCb+6PZQvW3BT6D81Eee2iEbkyxSw2JIeWaNMvvkgOgjWqZMSYe5QEZeaf++kEU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/2] qd65xx: always use ->selectproc method
Date: Sat, 23 Feb 2008 20:11:49 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802232011.49403.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qd_select() checks itself whether timings should be reprogrammed so
remove superfluous qd_timing_ok() and always use ->selectproc method
(rename qd_select() to qd65xx_select() while at it).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/qd65xx.c |   37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -88,12 +88,12 @@
 static int timings[4]={-1,-1,-1,-1}; /* stores current timing for each timer */
 
 /*
- * qd_select:
+ * qd65xx_select:
  *
- * This routine is invoked from ide.c to prepare for access to a given drive.
+ * This routine is invoked to prepare for access to a given drive.
  */
 
-static void qd_select (ide_drive_t *drive)
+static void qd65xx_select(ide_drive_t *drive)
 {
 	u8 index = ((	(QD_TIMREG(drive)) & 0x80 ) >> 7) |
 			(QD_TIMREG(drive) & 0x02);
@@ -168,36 +168,15 @@ static int qd_find_disk_type (ide_drive_
 }
 
 /*
- * qd_timing_ok:
- *
- * check whether timings don't conflict
- */
-
-static int qd_timing_ok (ide_drive_t drives[])
-{
-	return (IDE_IMPLY(drives[0].present && drives[1].present,
-			IDE_IMPLY(QD_TIMREG(drives) == QD_TIMREG(drives+1),
-			          QD_TIMING(drives) == QD_TIMING(drives+1))));
-	/* if same timing register, must be same timing */
-}
-
-/*
  * qd_set_timing:
  *
- * records the timing, and enables selectproc as needed
+ * records the timing
  */
 
 static void qd_set_timing (ide_drive_t *drive, u8 timing)
 {
-	ide_hwif_t *hwif = HWIF(drive);
-
 	drive->drive_data &= 0xff00;
 	drive->drive_data |= timing;
-	if (qd_timing_ok(hwif->drives)) {
-		qd_select(drive); /* selects once */
-		hwif->selectproc = NULL;
-	} else
-		hwif->selectproc = &qd_select;
 
 	printk(KERN_DEBUG "%s: %#x\n", drive->name, timing);
 }
@@ -400,7 +379,8 @@ static int __init qd_probe(int base)
 		qd_setup(hwif, base, config);
 
 		hwif->port_init_devs = qd6500_port_init_devs;
-		hwif->set_pio_mode = &qd6500_set_pio_mode;
+		hwif->set_pio_mode   = qd6500_set_pio_mode;
+		hwif->selectproc     = qd65xx_select;
 
 		idx[unit] = unit;
 
@@ -441,7 +421,8 @@ static int __init qd_probe(int base)
 			qd_setup(hwif, base, config | (control << 8));
 
 			hwif->port_init_devs = qd6580_port_init_devs;
-			hwif->set_pio_mode = &qd6580_set_pio_mode;
+			hwif->set_pio_mode   = qd6580_set_pio_mode;
+			hwif->selectproc     = qd65xx_select;
 
 			idx[unit] = unit;
 
@@ -460,6 +441,7 @@ static int __init qd_probe(int base)
 				qd_setup(hwif, base, config | (control << 8));
 				hwif->port_init_devs = qd6580_port_init_devs;
 				hwif->set_pio_mode   = qd6580_set_pio_mode;
+				hwif->selectproc     = qd65xx_select;
 				idx[0] = 0;
 			}
 
@@ -469,6 +451,7 @@ static int __init qd_probe(int base)
 				qd_setup(mate, base, config | (control << 8));
 				mate->port_init_devs = qd6580_port_init_devs;
 				mate->set_pio_mode   = qd6580_set_pio_mode;
+				hwif->selectproc     = qd65xx_select;
 				idx[1] = 1;
 			}
 
