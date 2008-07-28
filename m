Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbYG1VDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbYG1VDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbYG1VDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:03:23 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:19365 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbYG1VDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:03:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=eZQzIInaVJ353PG0dHEYAKaDC9wc4mP/Lx5aIIApT/C7ImgqaZk+cO+/tSIQRaLgx1
         caoJzSr8Yem7IBt5D602jqcih6b4+wyBCtd34LiIGSXtGqR/DfBG4buRYiAUIdWG14ew
         SCw7k9PBu65KhJB57fJ5ec+DUImBEmJpIkjfU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/3] ide: ide_dev_is_sata() -> ata_id_is_sata()
Date: Mon, 28 Jul 2008 22:59:36 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807282259.36742.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use optimized ATA version check from Sergei in ata_id_is_sata().

* ide_dev_is_sata() -> ata_id_is_sata()

Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c   |    2 +-
 drivers/ide/pci/hpt366.c |    4 ++--
 include/linux/ata.h      |   10 +++++++++-
 include/linux/ide.h      |   13 -------------
 4 files changed, 12 insertions(+), 17 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -630,7 +630,7 @@ u8 eighty_ninty_three (ide_drive_t *driv
 		printk(KERN_DEBUG "%s: skipping word 93 validity check\n",
 				  drive->name);
 
-	if (ide_dev_is_sata(id) && !ivb)
+	if (ata_id_is_sata(id) && !ivb)
 		return 1;
 
 	if (hwif->cbl != ATA_CBL_PATA80 && !ivb)
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -648,7 +648,7 @@ static u8 hpt3xx_udma_filter(ide_drive_t
 	case HPT372A:
 	case HPT372N:
 	case HPT374 :
-		if (ide_dev_is_sata(drive->id))
+		if (ata_id_is_sata(drive->id))
 			mask &= ~0x0e;
 		/* Fall thru */
 	default:
@@ -670,7 +670,7 @@ static u8 hpt3xx_mdma_filter(ide_drive_t
 	case HPT372A:
 	case HPT372N:
 	case HPT374 :
-		if (ide_dev_is_sata(drive->id))
+		if (ata_id_is_sata(drive->id))
 			return 0x00;
 		/* Fall thru */
 	default:
Index: b/include/linux/ata.h
===================================================================
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -644,7 +644,15 @@ static inline unsigned int ata_id_major_
 
 static inline int ata_id_is_sata(const u16 *id)
 {
-	return ata_id_major_version(id) >= 5 && id[ATA_ID_HW_CONFIG] == 0;
+	/*
+	 * See if word 93 is 0 AND drive is at least ATA-5 compatible
+	 * verifying that word 80 by casting it to a signed type --
+	 * this trick allows us to filter out the reserved values of
+	 * 0x0000 and 0xffff along with the earlier ATA revisions...
+	 */
+	if (id[ATA_ID_HW_CONFIG] == 0 && (short)id[ATA_ID_MAJOR_VER] >= 0x0020)
+		return 1;
+	return 0;
 }
 
 static inline int ata_id_has_tpm(const u16 *id)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1391,19 +1391,6 @@ const char *ide_xfer_verbose(u8 mode);
 extern void ide_toggle_bounce(ide_drive_t *drive, int on);
 extern int ide_set_xfer_rate(ide_drive_t *drive, u8 rate);
 
-static inline int ide_dev_is_sata(u16 *id)
-{
-	/*
-	 * See if word 93 is 0 AND drive is at least ATA-5 compatible
-	 * verifying that word 80 by casting it to a signed type --
-	 * this trick allows us to filter out the reserved values of
-	 * 0x0000 and 0xffff along with the earlier ATA revisions...
-	 */
-	if (id[ATA_ID_HW_CONFIG] == 0 && (short)id[ATA_ID_MAJOR_VER] >= 0x0020)
-		return 1;
-	return 0;
-}
-
 u64 ide_get_lba_addr(struct ide_taskfile *, int);
 u8 ide_dump_status(ide_drive_t *, const char *, u8);
 
