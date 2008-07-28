Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbYG1VEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbYG1VEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbYG1VDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:03:25 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:20312 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYG1VDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:03:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=TDXf+yK9g5afANMSMh2HngtSPEJ6YMD/4l1BXo48uVqeZahOUlNbOYRWcfGYxEIGCV
         y1mbw9irT/r/Hw/rKxcYUCUo9fNZD+OLYSqRyReOVYyO/63UoCpeAtt1ESo06GBZ8L8w
         L8w2Jk8thNMdcBxV+Xqqsjz4JK0T9Mu710QEU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] ide: idedisk_supports_lba48() -> ata_id_lba48_enabled()
Date: Mon, 28 Jul 2008 23:00:23 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807282300.24005.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ata_id_lba48_enabled() inline helper to <linux/ata.h>.

* idedisk_supports_lba48() -> ata_id_lba48_enabled()

  The latter one also checks validity of words 83 & 86.

Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |   21 ++++++---------------
 include/linux/ata.h    |    9 +++++++++
 2 files changed, 15 insertions(+), 15 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -377,16 +377,6 @@ static unsigned long long sectors_to_MB(
 }
 
 /*
- * The same here.
- */
-static inline int idedisk_supports_lba48(const u16 *id)
-{
-	return (id[ATA_ID_COMMAND_SET_2] & 0x0400) &&
-	       (id[ATA_ID_CFS_ENABLE_2] & 0x0400) &&
-	       ata_id_u64(id, ATA_ID_LBA_CAPACITY_2);
-}
-
-/*
  * Some disks report total number of sectors instead of
  * maximum sector address.  We list them here.
  */
@@ -400,7 +390,7 @@ static const struct drive_list_entry hpa
 static void idedisk_check_hpa(ide_drive_t *drive)
 {
 	unsigned long long capacity, set_max;
-	int lba48 = idedisk_supports_lba48(drive->id);
+	int lba48 = ata_id_lba48_enabled(drive->id);
 
 	capacity = drive->capacity64;
 
@@ -457,7 +447,7 @@ static void init_idedisk_capacity(ide_dr
 	 */
 	int hpa = ata_id_hpa_enabled(id);
 
-	if (idedisk_supports_lba48(id)) {
+	if (ata_id_lba48_enabled(id)) {
 		/* drive speaks 48-bit LBA */
 		drive->select.b.lba = 1;
 		drive->capacity64 = ata_id_u64(id, ATA_ID_LBA_CAPACITY_2);
@@ -761,9 +751,11 @@ static int set_lba_addressing(ide_drive_
 	if (drive->hwif->host_flags & IDE_HFLAG_NO_LBA48)
 		return 0;
 
-	if (!idedisk_supports_lba48(drive->id))
+	if (ata_id_lba48_enabled(drive->id) == 0)
 		return -EIO;
+
 	drive->addressing = arg;
+
 	return 0;
 }
 
@@ -860,8 +852,7 @@ static void idedisk_setup(ide_drive_t *d
 	capacity = idedisk_capacity(drive);
 
 	if (!drive->forced_geom) {
-
-		if (idedisk_supports_lba48(drive->id)) {
+		if (ata_id_lba48_enabled(drive->id)) {
 			/* compatibility */
 			drive->bios_sect = 63;
 			drive->bios_head = 255;
Index: b/include/linux/ata.h
===================================================================
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -573,6 +573,15 @@ static inline int ata_id_has_lba48(const
 	return id[ATA_ID_COMMAND_SET_2] & (1 << 10);
 }
 
+static inline int ata_id_lba48_enabled(const u16 *id)
+{
+	if (ata_id_has_lba48(id) == 0)
+		return 0;
+	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
+		return 0;
+	return id[ATA_ID_CFS_ENABLE_2] & (1 << 10);
+}
+
 static inline int ata_id_hpa_enabled(const u16 *id)
 {
 	/* Yes children, word 83 valid bits cover word 82 data */
