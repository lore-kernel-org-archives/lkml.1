Return-Path: <linux-kernel-owner+w=401wt.eu-S1765647AbZDBUH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765647AbZDBUH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 16:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756218AbZDBUHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 16:07:11 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64832 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbZDBUHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 16:07:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=aKEhGuStf7g+aT7U3okFlAD048RNvVPYjyL514gmtxR+2MHViCLe5ShHS6SY6a8mVQ
         1us7xn+xZB9X0fHU+zqioxi8PGFcE0CNV5E5AAQxBPdXklrsjkYnRTdUpr3Cbk9gK/uF
         SYBDWeianptm5d/GAXsMM7VdTS/MeR1JrWQQs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] <linux/hdreg.h> cleanups
Date: Thu, 2 Apr 2009 22:09:31 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090401; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904022209.32603.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I still have some leftover (non-IDE & non-libata) patches from the last
summer converting all struct hd_driveid & co. users to use <linux/ata.h>
explicitly and cleaning <linux/hdreg.h> accordingly.

Original patches still apply just fine to the current Linus' tree (I also
made sure that there are no potential conflicts/breakages caused by new
users of <linux/hdreg.h>) and the whole patchset is now available in the
form of git tree here:

http://git.kernel.org/?p=linux/kernel/git/bart/linux-hdreg-h-cleanup.git

I haven't heard a single complaint about them so it seems like everybody
is happy with them and thus it would be nice to get them merged. :)

Linus, please consider pulling from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/linux-hdreg-h-cleanup.git/

to receive the following updates:

 arch/um/drivers/ubd_kern.c   |   12 +-
 drivers/block/aoe/aoecmd.c   |   23 ++--
 drivers/block/hd.c           |    2 +
 drivers/block/xsysace.c      |   30 +++---
 drivers/usb/storage/isd200.c |  239 ++++++++++++++----------------------------
 include/linux/hdreg.h        |   66 +-----------
 6 files changed, 117 insertions(+), 255 deletions(-)


Bartlomiej Zolnierkiewicz (10):
      isd200: make it 'struct hd_driveid'-free
      ubd_kern: make it 'struct hd_driveid'-free
      xsysace: make it 'struct hd_driveid'-free
      include/linux/hdreg.h: cover struct hd_driveid with #ifndef/#endif __KERNEL__
      isd200: WIN_* -> ATA_CMD_*
      aoe: WIN_* -> ATA_CMD_*
      include/linux/hdreg.h: cover WIN_* and friends with #ifndef/#endif __KERNEL__
      isd200: use ATA_* defines instead of *_STAT and *_ERR ones
      include/linux/hdreg.h: remove unused defines
      remove <linux/ata.h> include from <linux/hdreg.h>


diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index d42f826..f934225 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -22,6 +22,7 @@
 #include "linux/kernel.h"
 #include "linux/module.h"
 #include "linux/blkdev.h"
+#include "linux/ata.h"
 #include "linux/hdreg.h"
 #include "linux/init.h"
 #include "linux/cdrom.h"
@@ -1308,16 +1309,15 @@ static int ubd_ioctl(struct block_device *bdev, fmode_t mode,
 		     unsigned int cmd, unsigned long arg)
 {
 	struct ubd *ubd_dev = bdev->bd_disk->private_data;
-	struct hd_driveid ubd_id = {
-		.cyls		= 0,
-		.heads		= 128,
-		.sectors	= 32,
-	};
+	u16 ubd_id[ATA_ID_WORDS];
 
 	switch (cmd) {
 		struct cdrom_volctrl volume;
 	case HDIO_GET_IDENTITY:
-		ubd_id.cyls = ubd_dev->size / (128 * 32 * 512);
+		memset(&ubd_id, 0, ATA_ID_WORDS * 2);
+		ubd_id[ATA_ID_CYLS]	= ubd_dev->size / (128 * 32 * 512);
+		ubd_id[ATA_ID_HEADS]	= 128;
+		ubd_id[ATA_ID_SECTORS]	= 32;
 		if(copy_to_user((char __user *) arg, (char *) &ubd_id,
 				 sizeof(ubd_id)))
 			return -EFAULT;
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 45c5a33..31693bc 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -4,6 +4,7 @@
  * Filesystem request handling methods
  */
 
+#include <linux/ata.h>
 #include <linux/hdreg.h>
 #include <linux/blkdev.h>
 #include <linux/skbuff.h>
@@ -267,7 +268,7 @@ aoecmd_ata_rw(struct aoedev *d)
 		writebit = 0;
 	}
 
-	ah->cmdstat = WIN_READ | writebit | extbit;
+	ah->cmdstat = ATA_CMD_PIO_READ | writebit | extbit;
 
 	/* mark all tracking fields and load out */
 	buf->nframesout += 1;
@@ -362,10 +363,10 @@ resend(struct aoedev *d, struct aoetgt *t, struct frame *f)
 	switch (ah->cmdstat) {
 	default:
 		break;
-	case WIN_READ:
-	case WIN_READ_EXT:
-	case WIN_WRITE:
-	case WIN_WRITE_EXT:
+	case ATA_CMD_PIO_READ:
+	case ATA_CMD_PIO_READ_EXT:
+	case ATA_CMD_PIO_WRITE:
+	case ATA_CMD_PIO_WRITE_EXT:
 		put_lba(ah, f->lba);
 
 		n = f->bcnt;
@@ -812,8 +813,8 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 			d->htgt = NULL;
 		n = ahout->scnt << 9;
 		switch (ahout->cmdstat) {
-		case WIN_READ:
-		case WIN_READ_EXT:
+		case ATA_CMD_PIO_READ:
+		case ATA_CMD_PIO_READ_EXT:
 			if (skb->len - sizeof *hin - sizeof *ahin < n) {
 				printk(KERN_ERR
 					"aoe: %s.  skb->len=%d need=%ld\n",
@@ -823,8 +824,8 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 				return;
 			}
 			memcpy(f->bufaddr, ahin+1, n);
-		case WIN_WRITE:
-		case WIN_WRITE_EXT:
+		case ATA_CMD_PIO_WRITE:
+		case ATA_CMD_PIO_WRITE_EXT:
 			ifp = getif(t, skb->dev);
 			if (ifp) {
 				ifp->lost = 0;
@@ -838,7 +839,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 				goto xmit;
 			}
 			break;
-		case WIN_IDENTIFY:
+		case ATA_CMD_ID_ATA:
 			if (skb->len - sizeof *hin - sizeof *ahin < 512) {
 				printk(KERN_INFO
 					"aoe: runt data size in ataid.  skb->len=%d\n",
@@ -914,7 +915,7 @@ aoecmd_ata_id(struct aoedev *d)
 
 	/* set up ata header */
 	ah->scnt = 1;
-	ah->cmdstat = WIN_IDENTIFY;
+	ah->cmdstat = ATA_CMD_ID_ATA;
 	ah->lba3 = 0xa0;
 
 	skb->dev = t->ifp->nd;
diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index 482c0c4..3c11f06 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -42,6 +42,8 @@
 #include <linux/ata.h>
 #include <linux/hdreg.h>
 
+#define HD_IRQ 14
+
 #define REALLY_SLOW_IO
 #include <asm/system.h>
 #include <asm/io.h>
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 119be34..6cccdc3 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -89,6 +89,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
+#include <linux/ata.h>
 #include <linux/hdreg.h>
 #include <linux/platform_device.h>
 #if defined(CONFIG_OF)
@@ -208,7 +209,7 @@ struct ace_device {
 	struct gendisk *gd;
 
 	/* Inserted CF card parameters */
-	struct hd_driveid cf_id;
+	u16 cf_id[ATA_ID_WORDS];
 };
 
 static int ace_major;
@@ -402,21 +403,14 @@ static void ace_dump_regs(struct ace_device *ace)
 		 ace_in32(ace, ACE_CFGLBA), ace_in(ace, ACE_FATSTAT));
 }
 
-void ace_fix_driveid(struct hd_driveid *id)
+void ace_fix_driveid(u16 *id)
 {
 #if defined(__BIG_ENDIAN)
-	u16 *buf = (void *)id;
 	int i;
 
 	/* All half words have wrong byte order; swap the bytes */
-	for (i = 0; i < sizeof(struct hd_driveid); i += 2, buf++)
-		*buf = le16_to_cpu(*buf);
-
-	/* Some of the data values are 32bit; swap the half words  */
-	id->lba_capacity = ((id->lba_capacity >> 16) & 0x0000FFFF) |
-	    ((id->lba_capacity << 16) & 0xFFFF0000);
-	id->spg = ((id->spg >> 16) & 0x0000FFFF) |
-	    ((id->spg << 16) & 0xFFFF0000);
+	for (i = 0; i < ATA_ID_WORDS; i++, id++)
+		*id = le16_to_cpu(*id);
 #endif
 }
 
@@ -614,7 +608,7 @@ static void ace_fsm_dostate(struct ace_device *ace)
 		break;
 
 	case ACE_FSM_STATE_IDENTIFY_COMPLETE:
-		ace_fix_driveid(&ace->cf_id);
+		ace_fix_driveid(&ace->cf_id[0]);
 		ace_dump_mem(&ace->cf_id, 512);	/* Debug: Dump out disk ID */
 
 		if (ace->data_result) {
@@ -627,9 +621,10 @@ static void ace_fsm_dostate(struct ace_device *ace)
 			ace->media_change = 0;
 
 			/* Record disk parameters */
-			set_capacity(ace->gd, ace->cf_id.lba_capacity);
+			set_capacity(ace->gd,
+				ata_id_u32(&ace->cf_id, ATA_ID_LBA_CAPACITY));
 			dev_info(ace->dev, "capacity: %i sectors\n",
-				 ace->cf_id.lba_capacity);
+				ata_id_u32(&ace->cf_id, ATA_ID_LBA_CAPACITY));
 		}
 
 		/* We're done, drop to IDLE state and notify waiters */
@@ -928,12 +923,13 @@ static int ace_release(struct gendisk *disk, fmode_t mode)
 static int ace_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
 	struct ace_device *ace = bdev->bd_disk->private_data;
+	u16 *cf_id = &ace->cf_id[0];
 
 	dev_dbg(ace->dev, "ace_getgeo()\n");
 
-	geo->heads = ace->cf_id.heads;
-	geo->sectors = ace->cf_id.sectors;
-	geo->cylinders = ace->cf_id.cyls;
+	geo->heads	= cf_id[ATA_ID_HEADS];
+	geo->sectors	= cf_id[ATA_ID_SECTORS];
+	geo->cylinders	= cf_id[ATA_ID_CYLS];
 
 	return 0;
 }
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 882c57b..fdba2f6 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -46,6 +46,7 @@
 #include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/ata.h>
 #include <linux/hdreg.h>
 #include <linux/scatterlist.h>
 
@@ -328,7 +329,7 @@ struct isd200_config {
 
 struct isd200_info {
 	struct inquiry_data InquiryData;
-	struct hd_driveid *id;
+	u16 *id;
 	struct isd200_config ConfigData;
 	unsigned char *RegsBuf;
 	unsigned char ATARegs[8];
@@ -419,19 +420,19 @@ static void isd200_build_sense(struct us_data *us, struct scsi_cmnd *srb)
 		buf->Flags = UNIT_ATTENTION;
 		buf->AdditionalSenseCode = 0;
 		buf->AdditionalSenseCodeQualifier = 0;
-	} else if(error & MCR_ERR) {
+	} else if (error & ATA_MCR) {
 		buf->ErrorCode = 0x70 | SENSE_ERRCODE_VALID;
 		buf->AdditionalSenseLength = 0xb;
 		buf->Flags =  UNIT_ATTENTION;
 		buf->AdditionalSenseCode = 0;
 		buf->AdditionalSenseCodeQualifier = 0;
-	} else if(error & TRK0_ERR) {
+	} else if (error & ATA_TRK0NF) {
 		buf->ErrorCode = 0x70 | SENSE_ERRCODE_VALID;
 		buf->AdditionalSenseLength = 0xb;
 		buf->Flags =  NOT_READY;
 		buf->AdditionalSenseCode = 0;
 		buf->AdditionalSenseCodeQualifier = 0;
-	} else if(error & ECC_ERR) {
+	} else if (error & ATA_UNC) {
 		buf->ErrorCode = 0x70 | SENSE_ERRCODE_VALID;
 		buf->AdditionalSenseLength = 0xb;
 		buf->Flags =  DATA_PROTECT;
@@ -547,16 +548,16 @@ static int isd200_action( struct us_data *us, int action,
 		ata.generic.ActionSelect = ACTION_SELECT_1|ACTION_SELECT_5;
 		ata.generic.RegisterSelect = REG_DEVICE_HEAD | REG_COMMAND;
 		ata.write.DeviceHeadByte = info->DeviceHead;
-		ata.write.CommandByte = WIN_SRST;
+		ata.write.CommandByte = ATA_CMD_DEV_RESET;
 		isd200_set_srb(info, DMA_NONE, NULL, 0);
 		break;
 
 	case ACTION_IDENTIFY:
 		US_DEBUGP("   isd200_action(IDENTIFY)\n");
 		ata.generic.RegisterSelect = REG_COMMAND;
-		ata.write.CommandByte = WIN_IDENTIFY;
+		ata.write.CommandByte = ATA_CMD_ID_ATA;
 		isd200_set_srb(info, DMA_FROM_DEVICE, info->id,
-		                                sizeof(struct hd_driveid));
+				ATA_ID_WORDS * 2);
 		break;
 
 	default:
@@ -944,22 +945,22 @@ static int isd200_try_enum(struct us_data *us, unsigned char master_slave,
 			break;
 
 		if (!detect) {
-			if (regs[ATA_REG_STATUS_OFFSET] & BUSY_STAT) {
+			if (regs[ATA_REG_STATUS_OFFSET] & ATA_BUSY) {
 				US_DEBUGP("   %s status is still BSY, try again...\n",mstr);
 			} else {
 				US_DEBUGP("   %s status !BSY, continue with next operation\n",mstr);
 				break;
 			}
 		}
-		/* check for BUSY_STAT and */
-		/* WRERR_STAT (workaround ATA Zip drive) and */ 
-		/* ERR_STAT (workaround for Archos CD-ROM) */
+		/* check for ATA_BUSY and */
+		/* ATA_DF (workaround ATA Zip drive) and */
+		/* ATA_ERR (workaround for Archos CD-ROM) */
 		else if (regs[ATA_REG_STATUS_OFFSET] &
-			 (BUSY_STAT | WRERR_STAT | ERR_STAT )) {
+			 (ATA_BUSY | ATA_DF | ATA_ERR)) {
 			US_DEBUGP("   Status indicates it is not ready, try again...\n");
 		}
 		/* check for DRDY, ATA devices set DRDY after SRST */
-		else if (regs[ATA_REG_STATUS_OFFSET] & READY_STAT) {
+		else if (regs[ATA_REG_STATUS_OFFSET] & ATA_DRDY) {
 			US_DEBUGP("   Identified ATA device\n");
 			info->DeviceFlags |= DF_ATA_DEVICE;
 			info->DeviceHead = master_slave;
@@ -1053,103 +1054,50 @@ static int isd200_manual_enum(struct us_data *us)
 	return(retStatus);
 }
 
-static void isd200_fix_driveid (struct hd_driveid *id)
+static void isd200_fix_driveid(u16 *id)
 {
 #ifndef __LITTLE_ENDIAN
 # ifdef __BIG_ENDIAN
 	int i;
-	u16 *stringcast;
-
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
+
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
@@ -1163,7 +1111,7 @@ static int isd200_get_inquiry_data( struct us_data *us )
 {
 	struct isd200_info *info = (struct isd200_info *)us->extra;
 	int retStatus = ISD200_GOOD;
-	struct hd_driveid *id = info->id;
+	u16 *id = info->id;
 
 	US_DEBUGP("Entering isd200_get_inquiry_data\n");
 
@@ -1180,8 +1128,7 @@ static int isd200_get_inquiry_data( struct us_data *us )
 			/* this must be an ATA device */
 			/* perform an ATA Command Identify */
 			transferStatus = isd200_action( us, ACTION_IDENTIFY,
-							id, 
-							sizeof(struct hd_driveid) );
+							id, ATA_ID_WORDS * 2);
 			if (transferStatus != ISD200_TRANSPORT_GOOD) {
 				/* Error issuing ATA Command Identify */
 				US_DEBUGP("   Error issuing ATA Command Identify\n");
@@ -1191,35 +1138,9 @@ static int isd200_get_inquiry_data( struct us_data *us )
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
 
@@ -1229,30 +1150,30 @@ static int isd200_get_inquiry_data( struct us_data *us )
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
@@ -1301,7 +1222,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 			      union ata_cdb * ataCdb)
 {
 	struct isd200_info *info = (struct isd200_info *)us->extra;
-	struct hd_driveid *id = info->id;
+	u16 *id = info->id;
 	int sendToTransport = 1;
 	unsigned char sectnum, head;
 	unsigned short cylinder;
@@ -1369,13 +1290,12 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 
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
 
@@ -1392,16 +1312,16 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
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
@@ -1415,7 +1335,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 		ataCdb->write.CylinderHighByte = (unsigned char)(cylinder>>8);
 		ataCdb->write.CylinderLowByte = (unsigned char)cylinder;
 		ataCdb->write.DeviceHeadByte = (head | ATA_ADDRESS_DEVHEAD_STD);
-		ataCdb->write.CommandByte = WIN_READ;
+		ataCdb->write.CommandByte = ATA_CMD_PIO_READ;
 		break;
 
 	case WRITE_10:
@@ -1424,14 +1344,16 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
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
@@ -1445,7 +1367,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 		ataCdb->write.CylinderHighByte = (unsigned char)(cylinder>>8);
 		ataCdb->write.CylinderLowByte = (unsigned char)cylinder;
 		ataCdb->write.DeviceHeadByte = (head | ATA_ADDRESS_DEVHEAD_STD);
-		ataCdb->write.CommandByte = WIN_WRITE;
+		ataCdb->write.CommandByte = ATA_CMD_PIO_WRITE;
 		break;
 
 	case ALLOW_MEDIUM_REMOVAL:
@@ -1459,7 +1381,7 @@ static int isd200_scsi_to_ata(struct scsi_cmnd *srb, struct us_data *us,
 			ataCdb->generic.TransferBlockSize = 1;
 			ataCdb->generic.RegisterSelect = REG_COMMAND;
 			ataCdb->write.CommandByte = (srb->cmnd[4] & 0x1) ?
-				WIN_DOORLOCK : WIN_DOORUNLOCK;
+				ATA_CMD_MEDIA_LOCK : ATA_CMD_MEDIA_UNLOCK;
 			isd200_srb_set_bufflen(srb, 0);
 		} else {
 			US_DEBUGP("   Not removeable media, just report okay\n");
@@ -1539,8 +1461,7 @@ static int isd200_init_info(struct us_data *us)
 	if (!info)
 		retStatus = ISD200_ERROR;
 	else {
-		info->id = (struct hd_driveid *)
-				kzalloc(sizeof(struct hd_driveid), GFP_KERNEL);
+		info->id = kzalloc(ATA_ID_WORDS * 2, GFP_KERNEL);
 		info->RegsBuf = (unsigned char *)
 				kmalloc(sizeof(info->ATARegs), GFP_KERNEL);
 		info->srb.sense_buffer =
diff --git a/include/linux/hdreg.h b/include/linux/hdreg.h
index ed21bd3..29ee287 100644
--- a/include/linux/hdreg.h
+++ b/include/linux/hdreg.h
@@ -1,68 +1,6 @@
 #ifndef _LINUX_HDREG_H
 #define _LINUX_HDREG_H
 
-#ifdef __KERNEL__
-#include <linux/ata.h>
-
-/*
- * This file contains some defines for the AT-hd-controller.
- * Various sources.
- */
-
-/* ide.c has its own port definitions in "ide.h" */
-
-#define HD_IRQ		14
-
-/* Hd controller regs. Ref: IBM AT Bios-listing */
-#define HD_DATA		0x1f0		/* _CTL when writing */
-#define HD_ERROR	0x1f1		/* see err-bits */
-#define HD_NSECTOR	0x1f2		/* nr of sectors to read/write */
-#define HD_SECTOR	0x1f3		/* starting sector */
-#define HD_LCYL		0x1f4		/* starting cylinder */
-#define HD_HCYL		0x1f5		/* high byte of starting cyl */
-#define HD_CURRENT	0x1f6		/* 101dhhhh , d=drive, hhhh=head */
-#define HD_STATUS	0x1f7		/* see status-bits */
-#define HD_FEATURE	HD_ERROR	/* same io address, read=error, write=feature */
-#define HD_PRECOMP	HD_FEATURE	/* obsolete use of this port - predates IDE */
-#define HD_COMMAND	HD_STATUS	/* same io address, read=status, write=cmd */
-
-#define HD_CMD		0x3f6		/* used for resets */
-#define HD_ALTSTATUS	0x3f6		/* same as HD_STATUS but doesn't clear irq */
-
-/* remainder is shared between hd.c, ide.c, ide-cd.c, and the hdparm utility */
-
-/* Bits of HD_STATUS */
-#define ERR_STAT		0x01
-#define INDEX_STAT		0x02
-#define ECC_STAT		0x04	/* Corrected error */
-#define DRQ_STAT		0x08
-#define SEEK_STAT		0x10
-#define SRV_STAT		0x10
-#define WRERR_STAT		0x20
-#define READY_STAT		0x40
-#define BUSY_STAT		0x80
-
-/* Bits for HD_ERROR */
-#define MARK_ERR		0x01	/* Bad address mark */
-#define ILI_ERR			0x01	/* Illegal Length Indication (ATAPI) */
-#define TRK0_ERR		0x02	/* couldn't find track 0 */
-#define EOM_ERR			0x02	/* End Of Media (ATAPI) */
-#define ABRT_ERR		0x04	/* Command aborted */
-#define MCR_ERR			0x08	/* media change request */
-#define ID_ERR			0x10	/* ID field not found */
-#define MC_ERR			0x20	/* media changed */
-#define ECC_ERR			0x40	/* Uncorrectable ECC error */
-#define BBD_ERR			0x80	/* pre-EIDE meaning:  block marked bad */
-#define ICRC_ERR		0x80	/* new meaning:  CRC error during transfer */
-#define LFS_ERR			0xf0	/* Last Failed Sense (ATAPI) */
-
-/* Bits of HD_NSECTOR */
-#define CD			0x01
-#define IO			0x02
-#define REL			0x04
-#define TAG_MASK		0xf8
-#endif /* __KERNEL__ */
-
 #include <linux/types.h>
 
 /*
@@ -191,6 +129,7 @@ typedef struct hd_drive_hob_hdr {
 #define TASKFILE_INVALID		0x7fff
 #endif
 
+#ifndef __KERNEL__
 /* ATA/ATAPI Commands pre T13 Spec */
 #define WIN_NOP				0x00
 /*
@@ -379,6 +318,7 @@ typedef struct hd_drive_hob_hdr {
 #define SECURITY_ERASE_UNIT		0xBD
 #define SECURITY_FREEZE_LOCK		0xBE
 #define SECURITY_DISABLE_PASSWORD	0xBF
+#endif /* __KERNEL__ */
 
 struct hd_geometry {
       unsigned char heads;
@@ -448,6 +388,7 @@ enum {
 
 #define __NEW_HD_DRIVE_ID
 
+#ifndef __KERNEL__
 /*
  * Structure returned by HDIO_GET_IDENTITY, as per ANSI NCITS ATA6 rev.1b spec.
  *
@@ -699,6 +640,7 @@ struct hd_driveid {
 					 *  7:0 Signature
 					 */
 };
+#endif /* __KERNEL__ */
 
 /*
  * IDE "nice" flags. These are used on a per drive basis to determine
