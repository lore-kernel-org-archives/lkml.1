Return-Path: <linux-kernel-owner+w=401wt.eu-S1756455AbYHBRQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbYHBRQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 13:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbYHBRQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 13:16:17 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:9342 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbYHBRQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 13:16:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=IQqL9TbwzpphR17B8s801qqxFbTPqu6PtQ4CaJuX2G/0WIoNF5GkYsjoqaz5+8+S4F
         HavrWXJQl466HBF1+HVEryxtARwoXlXMI8eX+Xr8d4J1wEbKXY3wmLgTm/m4WZmKtHWB
         eoQb0rY5Y4XBchIYiF5WjsQ1uDkdvHHi6P0VY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/3] ide: ide_id_to_hd_driveid() -> ata_id_to_hd_driveid()
Date: Sat, 2 Aug 2008 19:13:03 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808021913.03883.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename ide_id_to_hd_driveid() to ata_id_to_hd_driveid()
and move it to <linux/ata.h>.

Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
I just thought that somebody may want to fix libata's
HDIO_GET_IDENTITY implementation

 drivers/ide/ide.c   |   22 +---------------------
 include/linux/ata.h |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 21 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -509,26 +509,6 @@ static int generic_drive_reset(ide_drive
 	return ret;
 }
 
-static inline void ide_id_to_hd_driveid(u16 *id)
-{
-#ifdef __BIG_ENDIAN
-	/* accessed in struct hd_driveid as 8-bit values */
-	id[ATA_ID_MAX_MULTSECT]	 = __cpu_to_le16(id[ATA_ID_MAX_MULTSECT]);
-	id[ATA_ID_CAPABILITY]	 = __cpu_to_le16(id[ATA_ID_CAPABILITY]);
-	id[ATA_ID_OLD_PIO_MODES] = __cpu_to_le16(id[ATA_ID_OLD_PIO_MODES]);
-	id[ATA_ID_OLD_DMA_MODES] = __cpu_to_le16(id[ATA_ID_OLD_DMA_MODES]);
-	id[ATA_ID_MULTSECT]	 = __cpu_to_le16(id[ATA_ID_MULTSECT]);
-
-	/* as 32-bit values */
-	*(u32 *)&id[ATA_ID_LBA_CAPACITY] = ata_id_u32(id, ATA_ID_LBA_CAPACITY);
-	*(u32 *)&id[ATA_ID_SPG]		 = ata_id_u32(id, ATA_ID_SPG);
-
-	/* as 64-bit value */
-	*(u64 *)&id[ATA_ID_LBA_CAPACITY_2] =
-		ata_id_u64(id, ATA_ID_LBA_CAPACITY_2);
-#endif
-}
-
 static int ide_get_identity_ioctl(ide_drive_t *drive, unsigned int cmd,
 				  unsigned long arg)
 {
@@ -548,7 +528,7 @@ static int ide_get_identity_ioctl(ide_dr
 	}
 
 	memcpy(id, drive->id, size);
-	ide_id_to_hd_driveid(id);
+	ata_id_to_hd_driveid(id);
 
 	if (copy_to_user((void __user *)arg, id, size))
 		rc = -EFAULT;
Index: b/include/linux/ata.h
===================================================================
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -30,6 +30,7 @@
 #define __LINUX_ATA_H__
 
 #include <linux/types.h>
+#include <asm/byteorder.h>
 
 /* defines only for the constants which don't work well as enums */
 #define ATA_DMA_BOUNDARY	0xffffUL
@@ -766,6 +767,26 @@ static inline int atapi_id_dmadir(const 
 	return ata_id_major_version(dev_id) >= 7 && (dev_id[62] & 0x8000);
 }
 
+static inline void ata_id_to_hd_driveid(u16 *id)
+{
+#ifdef __BIG_ENDIAN
+	/* accessed in struct hd_driveid as 8-bit values */
+	id[ATA_ID_MAX_MULTSECT]	 = __cpu_to_le16(id[ATA_ID_MAX_MULTSECT]);
+	id[ATA_ID_CAPABILITY]	 = __cpu_to_le16(id[ATA_ID_CAPABILITY]);
+	id[ATA_ID_OLD_PIO_MODES] = __cpu_to_le16(id[ATA_ID_OLD_PIO_MODES]);
+	id[ATA_ID_OLD_DMA_MODES] = __cpu_to_le16(id[ATA_ID_OLD_DMA_MODES]);
+	id[ATA_ID_MULTSECT]	 = __cpu_to_le16(id[ATA_ID_MULTSECT]);
+
+	/* as 32-bit values */
+	*(u32 *)&id[ATA_ID_LBA_CAPACITY] = ata_id_u32(id, ATA_ID_LBA_CAPACITY);
+	*(u32 *)&id[ATA_ID_SPG]		 = ata_id_u32(id, ATA_ID_SPG);
+
+	/* as 64-bit value */
+	*(u64 *)&id[ATA_ID_LBA_CAPACITY_2] =
+		ata_id_u64(id, ATA_ID_LBA_CAPACITY_2);
+#endif
+}
+
 static inline int is_multi_taskfile(struct ata_taskfile *tf)
 {
 	return (tf->command == ATA_CMD_READ_MULTI) ||
