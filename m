Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbYHBRQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbYHBRQx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 13:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYHBRQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 13:16:19 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:9344 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbYHBRQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 13:16:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=nwDS2m3whAd3M8d3+CPtz564Nz56yx4R+LIYhcrJwrCZIewvtR5VfdlB2/MQoa+E2U
         dxnMpid10cd/au0BUjadHqouyhFWP+ABiM4lVjGSF6QzqpGRb+4iInHHpjcb1ZXFvRhf
         BHCp86DrXS6M0meCo5qS18H9FpJneLyGp5b6g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] ide: lba_capacity_is_ok() -> ata_id_is_lba_capacity_ok()
Date: Sat, 2 Aug 2008 19:13:25 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808021913.25884.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename lba_capacity_is_ok() to ata_id_is_lba_capacity_ok()
and move it to <linux/ata.h> (remove needless parens while at it).

Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |   52 -------------------------------------------------
 include/linux/ata.h    |   50 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 51 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -80,56 +80,6 @@ static void ide_disk_put(struct ide_disk
 	mutex_unlock(&idedisk_ref_mutex);
 }
 
-/*
- * lba_capacity_is_ok() performs a sanity check on the claimed "lba_capacity"
- * value for this drive (from its reported identification information).
- *
- * Returns:	1 if lba_capacity looks sensible
- *		0 otherwise
- *
- * It is called only once for each drive.
- */
-static int lba_capacity_is_ok(u16 *id)
-{
-	unsigned long lba_sects, chs_sects, head, tail;
-
-	/* No non-LBA info .. so valid! */
-	if (id[ATA_ID_CYLS] == 0)
-		return 1;
-
-	lba_sects = ata_id_u32(id, ATA_ID_LBA_CAPACITY);
-
-	/*
-	 * The ATA spec tells large drives to return
-	 * C/H/S = 16383/16/63 independent of their size.
-	 * Some drives can be jumpered to use 15 heads instead of 16.
-	 * Some drives can be jumpered to use 4092 cyls instead of 16383.
-	 */
-	if ((id[ATA_ID_CYLS] == 16383 ||
-	     (id[ATA_ID_CYLS] == 4092 && id[ATA_ID_CUR_CYLS] == 16383)) &&
-	    id[ATA_ID_SECTORS] == 63 &&
-	    (id[ATA_ID_HEADS] == 15 || id[ATA_ID_HEADS] == 16) &&
-	    (lba_sects >= 16383 * 63 * id[ATA_ID_HEADS]))
-		return 1;
-
-	chs_sects = id[ATA_ID_CYLS] * id[ATA_ID_HEADS] * id[ATA_ID_SECTORS];
-
-	/* perform a rough sanity check on lba_sects:  within 10% is OK */
-	if ((lba_sects - chs_sects) < chs_sects/10)
-		return 1;
-
-	/* some drives have the word order reversed */
-	head = ((lba_sects >> 16) & 0xffff);
-	tail = (lba_sects & 0xffff);
-	lba_sects = (head | (tail << 16));
-	if ((lba_sects - chs_sects) < chs_sects/10) {
-		*(__le32 *)&id[ATA_ID_LBA_CAPACITY] = __cpu_to_le32(lba_sects);
-		return 1;	/* lba_capacity is (now) good */
-	}
-
-	return 0;	/* lba_capacity value may be bad */
-}
-
 static const u8 ide_rw_cmds[] = {
 	ATA_CMD_READ_MULTI,
 	ATA_CMD_WRITE_MULTI,
@@ -452,7 +402,7 @@ static void init_idedisk_capacity(ide_dr
 		drive->capacity64 = ata_id_u64(id, ATA_ID_LBA_CAPACITY_2);
 		if (hpa)
 			idedisk_check_hpa(drive);
-	} else if (ata_id_has_lba(id) && lba_capacity_is_ok(id)) {
+	} else if (ata_id_has_lba(id) && ata_id_is_lba_capacity_ok(id)) {
 		/* drive speaks 28-bit LBA */
 		drive->select.b.lba = 1;
 		drive->capacity64 = ata_id_u32(id, ATA_ID_LBA_CAPACITY);
Index: b/include/linux/ata.h
===================================================================
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -767,6 +767,56 @@ static inline int atapi_id_dmadir(const 
 	return ata_id_major_version(dev_id) >= 7 && (dev_id[62] & 0x8000);
 }
 
+/*
+ * ata_id_is_lba_capacity_ok() performs a sanity check on
+ * the claimed LBA capacity value for the device.
+ *
+ * Returns 1 if LBA capacity looks sensible, 0 otherwise.
+ *
+ * It is called only once for each device.
+ */
+static inline int ata_id_is_lba_capacity_ok(u16 *id)
+{
+	unsigned long lba_sects, chs_sects, head, tail;
+
+	/* No non-LBA info .. so valid! */
+	if (id[ATA_ID_CYLS] == 0)
+		return 1;
+
+	lba_sects = ata_id_u32(id, ATA_ID_LBA_CAPACITY);
+
+	/*
+	 * The ATA spec tells large drives to return
+	 * C/H/S = 16383/16/63 independent of their size.
+	 * Some drives can be jumpered to use 15 heads instead of 16.
+	 * Some drives can be jumpered to use 4092 cyls instead of 16383.
+	 */
+	if ((id[ATA_ID_CYLS] == 16383 ||
+	     (id[ATA_ID_CYLS] == 4092 && id[ATA_ID_CUR_CYLS] == 16383)) &&
+	    id[ATA_ID_SECTORS] == 63 &&
+	    (id[ATA_ID_HEADS] == 15 || id[ATA_ID_HEADS] == 16) &&
+	    (lba_sects >= 16383 * 63 * id[ATA_ID_HEADS]))
+		return 1;
+
+	chs_sects = id[ATA_ID_CYLS] * id[ATA_ID_HEADS] * id[ATA_ID_SECTORS];
+
+	/* perform a rough sanity check on lba_sects: within 10% is OK */
+	if (lba_sects - chs_sects < chs_sects/10)
+		return 1;
+
+	/* some drives have the word order reversed */
+	head = (lba_sects >> 16) & 0xffff;
+	tail = lba_sects & 0xffff;
+	lba_sects = head | (tail << 16);
+
+	if (lba_sects - chs_sects < chs_sects/10) {
+		*(__le32 *)&id[ATA_ID_LBA_CAPACITY] = __cpu_to_le32(lba_sects);
+		return 1;	/* LBA capacity is (now) good */
+	}
+
+	return 0;	/* LBA capacity value may be bad */
+}
+
 static inline void ata_id_to_hd_driveid(u16 *id)
 {
 #ifdef __BIG_ENDIAN
