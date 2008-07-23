Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYGWShi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYGWShi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbYGWSgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:36:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:4653 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbYGWSgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:36:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=FuWoio0zvZoDOTRo1VVLNyMT7LGorwpBycsqIshsijuMM9x8VocOHPD79uz6v7BTp9
         FhxiohRGK3ZMhVb5ygkO5Aarj/HspqevjpO67RZdlGxtVrQh+TmWuwRMOWbX+bxMv8do
         fidsjwqXT1bnAD5tvQMpFODGe42vQx2EjhQuE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] isd200: make it 'struct hd_driveid'-free
Date: Wed, 23 Jul 2008 20:32:25 +0200
User-Agent: KMail/1.9.9
Cc: Greg Kroah-Hartman <gregkh@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807232032.25718.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Factor out debug dump of id from isd200_get_inquiry_data()
  to isd200_dump_driveid().

* Change id field in struct isd200_info from 'struct hd_driveid *id'
  to 'u16 *id' and update driver accordingly.

* Include <linux/ata.h> directly instead of through <linux/hdreg.h>.

While at it:

* Use ata_id_u32() and ata_id_has_lba() macros.

There should be no functional changes caused by this patch.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
depends on 'ata: add missing ATA_ID_* defines (take 2)' patch
posted earlier (http://lkml.org/lkml/2008/7/22/469)

 drivers/usb/storage/isd200.c |  209 +++++++++++++------------------------------
 1 file changed, 65 insertions(+), 144 deletions(-)

Index: b/drivers/usb/storage/isd200.c
===================================================================
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -45,6 +45,7 @@
 #include <linux/jiffies.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <linux/ata.h>
 #include <linux/hdreg.h>
 #include <linux/scatterlist.h>
 
@@ -281,7 +282,7 @@ struct isd200_config {
 
 struct isd200_info {
 	struct inquiry_data InquiryData;
-	struct hd_driveid *id;
+	u16 *id;
 	struct isd200_config ConfigData;
 	unsigned char *RegsBuf;
 	unsigned char ATARegs[8];
@@ -509,7 +510,7 @@ static int isd200_action( struct us_data
 		ata.generic.RegisterSelect = REG_COMMAND;
 		ata.write.CommandByte = WIN_IDENTIFY;
 		isd200_set_srb(info, DMA_FROM_DEVICE, info->id,
-		                                sizeof(struct hd_driveid));
+				ATA_ID_WORDS * 2);
 		break;
 
 	default:
@@ -1006,103 +1007,50 @@ static int isd200_manual_enum(struct us_
 	return(retStatus);
 }
 
-static void isd200_fix_driveid (struct hd_driveid *id)
+static void isd200_fix_driveid(u16 *id)
 {
 #ifndef __LITTLE_ENDIAN
 # ifdef __BIG_ENDIAN
 	int i;
-	u16 *stringcast;
 
-	id->config         = __le16_to_cpu(id->config);
-	id->cyls           = __le16_to_cpu(id->cyls);
-	id->reserved2      = __le16_to_cpu(id->reserved2);
-	id->heads          = __le16_to_cpu(id->heads);
-	id->track_bytes    = __le16_to_cpu(id->track_bytes);
-	id->sector_bytes   = __le16_to_cpu(id->sector_bytes);
-	id->sectors        = __le16_to_cpu(id->sectors);
-	id->vendor0        = __le16_to_cpu(id->vendor0);
-	id->vendor1        = __le16_to_cpu(id->vendor1);
-	id->vendor2        = __le16_to_cpu(id->vendor2);
-	stringcast = (u16 *)&id->serial_no[0];
-	for (i = 0; i < (20/2); i++)
-		stringcast[i] = __le16_to_cpu(stringcast[i]);
-	id->buf_type       = __le16_to_cpu(id->buf_type);
-	id->buf_size       = __le16_to_cpu(id->buf_size);
-	id->ecc_bytes      = __le16_to_cpu(id->ecc_bytes);
-	stringcast = (u16 *)&id->fw_rev[0];
-	for (i = 0; i < (8/2); i++)
-		stringcast[i] = __le16_to_cpu(stringcast[i]);
-	stringcast = (u16 *)&id->model[0];
-	for (i = 0; i < (40/2); i++)
-		stringcast[i] = __le16_to_cpu(stringcast[i]);
-	id->dword_io       = __le16_to_cpu(id->dword_io);
-	id->reserved50     = __le16_to_cpu(id->reserved50);
-	id->field_valid    = __le16_to_cpu(id->field_valid);
-	id->cur_cyls       = __le16_to_cpu(id->cur_cyls);
-	id->cur_heads      = __le16_to_cpu(id->cur_heads);
-	id->cur_sectors    = __le16_to_cpu(id->cur_sectors);
-	id->cur_capacity0  = __le16_to_cpu(id->cur_capacity0);
-	id->cur_capacity1  = __le16_to_cpu(id->cur_capacity1);
-	id->lba_capacity   = __le32_to_cpu(id->lba_capacity);
-	id->dma_1word      = __le16_to_cpu(id->dma_1word);
-	id->dma_mword      = __le16_to_cpu(id->dma_mword);
-	id->eide_pio_modes = __le16_to_cpu(id->eide_pio_modes);
-	id->eide_dma_min   = __le16_to_cpu(id->eide_dma_min);
-	id->eide_dma_time  = __le16_to_cpu(id->eide_dma_time);
-	id->eide_pio       = __le16_to_cpu(id->eide_pio);
-	id->eide_pio_iordy = __le16_to_cpu(id->eide_pio_iordy);
-	for (i = 0; i < 2; ++i)
-		id->words69_70[i] = __le16_to_cpu(id->words69_70[i]);
-	for (i = 0; i < 4; ++i)
-		id->words71_74[i] = __le16_to_cpu(id->words71_74[i]);
-	id->queue_depth    = __le16_to_cpu(id->queue_depth);
-	for (i = 0; i < 4; ++i)
-		id->words76_79[i] = __le16_to_cpu(id->words76_79[i]);
-	id->major_rev_num  = __le16_to_cpu(id->major_rev_num);
-	id->minor_rev_num  = __le16_to_cpu(id->minor_rev_num);
-	id->command_set_1  = __le16_to_cpu(id->command_set_1);
-	id->command_set_2  = __le16_to_cpu(id->command_set_2);
-	id->cfsse          = __le16_to_cpu(id->cfsse);
-	id->cfs_enable_1   = __le16_to_cpu(id->cfs_enable_1);
-	id->cfs_enable_2   = __le16_to_cpu(id->cfs_enable_2);
-	id->csf_default    = __le16_to_cpu(id->csf_default);
-	id->dma_ultra      = __le16_to_cpu(id->dma_ultra);
-	id->trseuc         = __le16_to_cpu(id->trseuc);
-	id->trsEuc         = __le16_to_cpu(id->trsEuc);
-	id->CurAPMvalues   = __le16_to_cpu(id->CurAPMvalues);
-	id->mprc           = __le16_to_cpu(id->mprc);
-	id->hw_config      = __le16_to_cpu(id->hw_config);
-	id->acoustic       = __le16_to_cpu(id->acoustic);
-	id->msrqs          = __le16_to_cpu(id->msrqs);
-	id->sxfert         = __le16_to_cpu(id->sxfert);
-	id->sal            = __le16_to_cpu(id->sal);
-	id->spg            = __le32_to_cpu(id->spg);
-	id->lba_capacity_2 = __le64_to_cpu(id->lba_capacity_2);
-	for (i = 0; i < 22; i++)
-		id->words104_125[i]   = __le16_to_cpu(id->words104_125[i]);
-	id->last_lun       = __le16_to_cpu(id->last_lun);
-	id->word127        = __le16_to_cpu(id->word127);
-	id->dlf            = __le16_to_cpu(id->dlf);
-	id->csfo           = __le16_to_cpu(id->csfo);
-	for (i = 0; i < 26; i++)
-		id->words130_155[i] = __le16_to_cpu(id->words130_155[i]);
-	id->word156        = __le16_to_cpu(id->word156);
-	for (i = 0; i < 3; i++)
-		id->words157_159[i] = __le16_to_cpu(id->words157_159[i]);
-	id->cfa_power      = __le16_to_cpu(id->cfa_power);
-	for (i = 0; i < 14; i++)
-		id->words161_175[i] = __le16_to_cpu(id->words161_175[i]);
-	for (i = 0; i < 31; i++)
-		id->words176_205[i] = __le16_to_cpu(id->words176_205[i]);
-	for (i = 0; i < 48; i++)
-		id->words206_254[i] = __le16_to_cpu(id->words206_254[i]);
-	id->integrity_word  = __le16_to_cpu(id->integrity_word);
+	for (i = 0; i < ATA_ID_WORDS; i++)
+		id[i] = __le16_to_cpu(id[i]);
 # else
 #  error "Please fix <asm/byteorder.h>"
 # endif
 #endif
 }
 
+static void isd200_dump_driveid(u16 *id)
+{
+	US_DEBUGP("   Identify Data Structure:\n");
+	US_DEBUGP("      config = 0x%x\n",	  id[ATA_ID_CONFIG]);
+	US_DEBUGP("      cyls = 0x%x\n",	  id[ATA_ID_CYLS]);
+	US_DEBUGP("      heads = 0x%x\n",	  id[ATA_ID_HEADS]);
+	US_DEBUGP("      track_bytes = 0x%x\n",	  id[4]);
+	US_DEBUGP("      sector_bytes = 0x%x\n",  id[5]);
+	US_DEBUGP("      sectors = 0x%x\n",	  id[ATA_ID_SECTORS]);
+	US_DEBUGP("      serial_no[0] = 0x%x\n",  *(char *)&id[ATA_ID_SERNO]);
+	US_DEBUGP("      buf_type = 0x%x\n",	  id[20]);
+	US_DEBUGP("      buf_size = 0x%x\n",	  id[ATA_ID_BUF_SIZE]);
+	US_DEBUGP("      ecc_bytes = 0x%x\n",	  id[22]);
+	US_DEBUGP("      fw_rev[0] = 0x%x\n",	  *(char *)&id[ATA_ID_FW_REV]);
+	US_DEBUGP("      model[0] = 0x%x\n",	  *(char *)&id[ATA_ID_PROD]);
+	US_DEBUGP("      max_multsect = 0x%x\n",  id[ATA_ID_MAX_MULTSECT] & 0xff);
+	US_DEBUGP("      dword_io = 0x%x\n",	  id[ATA_ID_DWORD_IO]);
+	US_DEBUGP("      capability = 0x%x\n",	  id[ATA_ID_CAPABILITY] >> 8);
+	US_DEBUGP("      tPIO = 0x%x\n",	  id[ATA_ID_OLD_PIO_MODES] >> 8);
+	US_DEBUGP("      tDMA = 0x%x\n",	  id[ATA_ID_OLD_DMA_MODES] >> 8);
+	US_DEBUGP("      field_valid = 0x%x\n",	  id[ATA_ID_FIELD_VALID]);
+	US_DEBUGP("      cur_cyls = 0x%x\n",	  id[ATA_ID_CUR_CYLS]);
+	US_DEBUGP("      cur_heads = 0x%x\n",	  id[ATA_ID_CUR_HEADS]);
+	US_DEBUGP("      cur_sectors = 0x%x\n",	  id[ATA_ID_CUR_SECTORS]);
+	US_DEBUGP("      cur_capacity = 0x%x\n",  ata_id_u32(id, 57));
+	US_DEBUGP("      multsect = 0x%x\n",	  id[ATA_ID_MULTSECT] & 0xff);
+	US_DEBUGP("      lba_capacity = 0x%x\n",  ata_id_u32(id, ATA_ID_LBA_CAPACITY));
+	US_DEBUGP("      command_set_1 = 0x%x\n", id[ATA_ID_COMMAND_SET_1]);
+	US_DEBUGP("      command_set_2 = 0x%x\n", id[ATA_ID_COMMAND_SET_2]);
+}
 
 /**************************************************************************
  * isd200_get_inquiry_data
@@ -1116,7 +1064,7 @@ static int isd200_get_inquiry_data( stru
 {
 	struct isd200_info *info = (struct isd200_info *)us->extra;
 	int retStatus = ISD200_GOOD;
-	struct hd_driveid *id = info->id;
+	u16 *id = info->id;
 
 	US_DEBUGP("Entering isd200_get_inquiry_data\n");
 
@@ -1133,8 +1081,7 @@ static int isd200_get_inquiry_data( stru
 			/* this must be an ATA device */
 			/* perform an ATA Command Identify */
 			transferStatus = isd200_action( us, ACTION_IDENTIFY,
-							id, 
-							sizeof(struct hd_driveid) );
+							id, ATA_ID_WORDS * 2);
 			if (transferStatus != ISD200_TRANSPORT_GOOD) {
 				/* Error issuing ATA Command Identify */
 				US_DEBUGP("   Error issuing ATA Command Identify\n");
@@ -1144,35 +1091,9 @@ static int isd200_get_inquiry_data( stru
 				int i;
 				__be16 *src;
 				__u16 *dest;
-				isd200_fix_driveid(id);
 
-				US_DEBUGP("   Identify Data Structure:\n");
-				US_DEBUGP("      config = 0x%x\n", id->config);
-				US_DEBUGP("      cyls = 0x%x\n", id->cyls);
-				US_DEBUGP("      heads = 0x%x\n", id->heads);
-				US_DEBUGP("      track_bytes = 0x%x\n", id->track_bytes);
-				US_DEBUGP("      sector_bytes = 0x%x\n", id->sector_bytes);
-				US_DEBUGP("      sectors = 0x%x\n", id->sectors);
-				US_DEBUGP("      serial_no[0] = 0x%x\n", id->serial_no[0]);
-				US_DEBUGP("      buf_type = 0x%x\n", id->buf_type);
-				US_DEBUGP("      buf_size = 0x%x\n", id->buf_size);
-				US_DEBUGP("      ecc_bytes = 0x%x\n", id->ecc_bytes);
-				US_DEBUGP("      fw_rev[0] = 0x%x\n", id->fw_rev[0]);
-				US_DEBUGP("      model[0] = 0x%x\n", id->model[0]);
-				US_DEBUGP("      max_multsect = 0x%x\n", id->max_multsect);
-				US_DEBUGP("      dword_io = 0x%x\n", id->dword_io);
-				US_DEBUGP("      capability = 0x%x\n", id->capability);
-				US_DEBUGP("      tPIO = 0x%x\n", id->tPIO);
-				US_DEBUGP("      tDMA = 0x%x\n", id->tDMA);
-				US_DEBUGP("      field_valid = 0x%x\n", id->field_valid);
-				US_DEBUGP("      cur_cyls = 0x%x\n", id->cur_cyls);
-				US_DEBUGP("      cur_heads = 0x%x\n", id->cur_heads);
-				US_DEBUGP("      cur_sectors = 0x%x\n", id->cur_sectors);
-				US_DEBUGP("      cur_capacity = 0x%x\n", (id->cur_capacity1 << 16) + id->cur_capacity0 );
-				US_DEBUGP("      multsect = 0x%x\n", id->multsect);
-				US_DEBUGP("      lba_capacity = 0x%x\n", id->lba_capacity);
-				US_DEBUGP("      command_set_1 = 0x%x\n", id->command_set_1);
-				US_DEBUGP("      command_set_2 = 0x%x\n", id->command_set_2);
+				isd200_fix_driveid(id);
+				isd200_dump_driveid(id);
 
 				memset(&info->InquiryData, 0, sizeof(info->InquiryData));
 
@@ -1182,30 +1103,30 @@ static int isd200_get_inquiry_data( stru
 				/* The length must be at least 36 (5 + 31) */
 				info->InquiryData.AdditionalLength = 0x1F;
 
-				if (id->command_set_1 & COMMANDSET_MEDIA_STATUS) {
+				if (id[ATA_ID_COMMAND_SET_1] & COMMANDSET_MEDIA_STATUS) {
 					/* set the removable bit */
 					info->InquiryData.DeviceTypeModifier = DEVICE_REMOVABLE;
 					info->DeviceFlags |= DF_REMOVABLE_MEDIA;
 				}
 
 				/* Fill in vendor identification fields */
-				src = (__be16*)id->model;
+				src = (__be16 *)&id[ATA_ID_PROD];
 				dest = (__u16*)info->InquiryData.VendorId;
 				for (i=0;i<4;i++)
 					dest[i] = be16_to_cpu(src[i]);
 
-				src = (__be16*)(id->model+8);
+				src = (__be16 *)&id[ATA_ID_PROD + 8/2];
 				dest = (__u16*)info->InquiryData.ProductId;
 				for (i=0;i<8;i++)
 					dest[i] = be16_to_cpu(src[i]);
 
-				src = (__be16*)id->fw_rev;
+				src = (__be16 *)&id[ATA_ID_FW_REV];
 				dest = (__u16*)info->InquiryData.ProductRevisionLevel;
 				for (i=0;i<2;i++)
 					dest[i] = be16_to_cpu(src[i]);
 
 				/* determine if it supports Media Status Notification */
-				if (id->command_set_2 & COMMANDSET_MEDIA_STATUS) {
+				if (id[ATA_ID_COMMAND_SET_2] & COMMANDSET_MEDIA_STATUS) {
 					US_DEBUGP("   Device supports Media Status Notification\n");
 
 					/* Indicate that it is enabled, even though it is not
@@ -1254,7 +1175,7 @@ static int isd200_scsi_to_ata(struct scs
 			      union ata_cdb * ataCdb)
 {
 	struct isd200_info *info = (struct isd200_info *)us->extra;
-	struct hd_driveid *id = info->id;
+	u16 *id = info->id;
 	int sendToTransport = 1;
 	unsigned char sectnum, head;
 	unsigned short cylinder;
@@ -1322,13 +1243,12 @@ static int isd200_scsi_to_ata(struct scs
 
 		US_DEBUGP("   ATA OUT - SCSIOP_READ_CAPACITY\n");
 
-		if (id->capability & CAPABILITY_LBA ) {
-			capacity = id->lba_capacity - 1;
-		} else {
-			capacity = (id->heads *
-				    id->cyls *
-				    id->sectors) - 1;
-		}
+		if (ata_id_has_lba(id))
+			capacity = ata_id_u32(id, ATA_ID_LBA_CAPACITY) - 1;
+		else
+			capacity = (id[ATA_ID_HEADS] * id[ATA_ID_CYLS] *
+				    id[ATA_ID_SECTORS]) - 1;
+
 		readCapacityData.LogicalBlockAddress = cpu_to_be32(capacity);
 		readCapacityData.BytesPerBlock = cpu_to_be32(0x200);
 
@@ -1345,16 +1265,16 @@ static int isd200_scsi_to_ata(struct scs
 		lba = be32_to_cpu(*(__be32 *)&srb->cmnd[2]);
 		blockCount = (unsigned long)srb->cmnd[7]<<8 | (unsigned long)srb->cmnd[8];
 
-		if (id->capability & CAPABILITY_LBA) {
+		if (ata_id_has_lba(id)) {
 			sectnum = (unsigned char)(lba);
 			cylinder = (unsigned short)(lba>>8);
 			head = ATA_ADDRESS_DEVHEAD_LBA_MODE | (unsigned char)(lba>>24 & 0x0F);
 		} else {
-			sectnum = (unsigned char)((lba % id->sectors) + 1);
-			cylinder = (unsigned short)(lba / (id->sectors *
-							   id->heads));
-			head = (unsigned char)((lba / id->sectors) %
-					       id->heads);
+			sectnum = (u8)((lba % id[ATA_ID_SECTORS]) + 1);
+			cylinder = (u16)(lba / (id[ATA_ID_SECTORS] *
+					id[ATA_ID_HEADS]));
+			head = (u8)((lba / id[ATA_ID_SECTORS]) %
+					id[ATA_ID_HEADS]);
 		}
 		ataCdb->generic.SignatureByte0 = info->ConfigData.ATAMajorCommand;
 		ataCdb->generic.SignatureByte1 = info->ConfigData.ATAMinorCommand;
@@ -1377,14 +1297,16 @@ static int isd200_scsi_to_ata(struct scs
 		lba = be32_to_cpu(*(__be32 *)&srb->cmnd[2]);
 		blockCount = (unsigned long)srb->cmnd[7]<<8 | (unsigned long)srb->cmnd[8];
 
-		if (id->capability & CAPABILITY_LBA) {
+		if (ata_id_has_lba(id)) {
 			sectnum = (unsigned char)(lba);
 			cylinder = (unsigned short)(lba>>8);
 			head = ATA_ADDRESS_DEVHEAD_LBA_MODE | (unsigned char)(lba>>24 & 0x0F);
 		} else {
-			sectnum = (unsigned char)((lba % id->sectors) + 1);
-			cylinder = (unsigned short)(lba / (id->sectors * id->heads));
-			head = (unsigned char)((lba / id->sectors) % id->heads);
+			sectnum = (u8)((lba % id[ATA_ID_SECTORS]) + 1);
+			cylinder = (u16)(lba / (id[ATA_ID_SECTORS] *
+					id[ATA_ID_HEADS]));
+			head = (u8)((lba / id[ATA_ID_SECTORS]) %
+					id[ATA_ID_HEADS]);
 		}
 		ataCdb->generic.SignatureByte0 = info->ConfigData.ATAMajorCommand;
 		ataCdb->generic.SignatureByte1 = info->ConfigData.ATAMinorCommand;
@@ -1492,8 +1414,7 @@ static int isd200_init_info(struct us_da
 	if (!info)
 		retStatus = ISD200_ERROR;
 	else {
-		info->id = (struct hd_driveid *)
-				kzalloc(sizeof(struct hd_driveid), GFP_KERNEL);
+		info->id = kzalloc(ATA_ID_WORDS * 2, GFP_KERNEL);
 		info->RegsBuf = (unsigned char *)
 				kmalloc(sizeof(info->ATARegs), GFP_KERNEL);
 		info->srb.sense_buffer =
