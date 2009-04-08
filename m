Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbZDHHAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbZDHHAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbZDHG77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:59:59 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42491 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbZDHG75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:59:57 -0400
Date: Wed, 8 Apr 2009 02:59:55 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, matthew@wil.cx
Subject: [PATCH] libata: Prepare for hard drives w/ non-512 sector sizes
Message-ID: <20090408065955.GA29845@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I checked this into libata-dev.git#sectsize and #NEXT...  comments
welcome.  It's willy's patch, cut down such that it introduces no
major behavior changes [READ CAPACITY improves slightly].




commit 6644d0c1ced895087c176db8a4bfbdb3982c2848
Author: Jeff Garzik <jeff@garzik.org>
Date:   Wed Apr 8 02:52:58 2009 -0400

    [libata] Prepare for hard drives with non-512 sector sizes
    
    This converts libata to use variables for storing sector size, in
    several places.  Sector size is now only hardcoded in one place.
    
    Much of this content originated in a patch by Matthew Wilcox.
    I mainly removed content from his patch, to arrive at this.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index e7ea77c..c0c27b4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2387,6 +2387,7 @@ int ata_dev_configure(struct ata_device *dev)
 	dev->max_sectors = 0;
 	dev->cdb_len = 0;
 	dev->n_sectors = 0;
+	dev->sect_size = ATA_SECT_SIZE;
 	dev->cylinders = 0;
 	dev->heads = 0;
 	dev->sectors = 0;
@@ -2428,6 +2429,16 @@ int ata_dev_configure(struct ata_device *dev)
 
 		dev->n_sectors = ata_id_n_sectors(id);
 
+		if (dev->sect_size != ata_id_sect_size(id)) {
+			ata_dev_printk(dev, KERN_ERR,
+				       "internal sector size %lld does not "
+				       "match drive-supplied size %lld\n",
+				       dev->sect_size,
+				       ata_id_sect_size(id));
+			rc = -EINVAL;
+			goto err_out_nosup;
+		}
+
 		/* get current R/W Multiple count setting */
 		if ((dev->id[47] >> 8) == 0x80 && (dev->id[59] & 0x100)) {
 			unsigned int max = dev->id[47] & 0xff;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b9747fa..dd71352 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -50,7 +50,6 @@
 
 #include "libata.h"
 
-#define SECTOR_SIZE		512
 #define ATA_SCSI_RBUF_SIZE	4096
 
 static DEFINE_SPINLOCK(ata_scsi_rbuf_lock);
@@ -486,7 +485,8 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	memset(scsi_cmd, 0, sizeof(scsi_cmd));
 
 	if (args[3]) {
-		argsize = SECTOR_SIZE * args[3];
+		unsigned sect_size = scsidev->sector_size;
+		argsize = sect_size * args[3];
 		argbuf = kmalloc(argsize, GFP_KERNEL);
 		if (argbuf == NULL) {
 			rc = -ENOMEM;
@@ -1630,6 +1630,7 @@ nothing_to_do:
 static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 {
 	struct scsi_cmnd *scmd = qc->scsicmd;
+	struct ata_device *dev = qc->dev;
 	const u8 *cdb = scmd->cmnd;
 	unsigned int tf_flags = 0;
 	u64 block;
@@ -1686,9 +1687,9 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 		goto nothing_to_do;
 
 	qc->flags |= ATA_QCFLAG_IO;
-	qc->nbytes = n_block * ATA_SECT_SIZE;
+	qc->nbytes = n_block * dev->sect_size;
 
-	rc = ata_build_rw_tf(&qc->tf, qc->dev, block, n_block, tf_flags,
+	rc = ata_build_rw_tf(&qc->tf, dev, block, n_block, tf_flags,
 			     qc->tag);
 	if (likely(rc == 0))
 		return 0;
@@ -2354,10 +2355,25 @@ saving_not_supp:
  */
 static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 {
-	u64 last_lba = args->dev->n_sectors - 1; /* LBA of the last block */
+	struct ata_device *dev = args->dev;
+	u64 last_lba = dev->n_sectors - 1; /* LBA of the last block */
+	u32 sector_size;
+	u8 log_per_phys = 1;
+	u16 first_sector_offset = 0;
+	u16 word_106 = dev->id[106];
 
 	VPRINTK("ENTER\n");
 
+	if ((word_106 & 0xc000) == 0x4000) {
+		/* Number and offset of logical sectors per physical sector */
+		if (word_106 & (1 << 13))
+			log_per_phys = word_106 & 0xf;
+		if ((dev->id[209] & 0xc000) == 0x4000)
+			first_sector_offset = dev->id[209] & 0x3fff;
+	}
+
+	sector_size = dev->sect_size;
+
 	if (args->cmd->cmnd[0] == READ_CAPACITY) {
 		if (last_lba >= 0xffffffffULL)
 			last_lba = 0xffffffff;
@@ -2368,9 +2384,10 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 		rbuf[2] = last_lba >> (8 * 1);
 		rbuf[3] = last_lba;
 
-		/* sector size */
-		rbuf[6] = ATA_SECT_SIZE >> 8;
-		rbuf[7] = ATA_SECT_SIZE & 0xff;
+		rbuf[4] = sector_size >> (8 * 3);
+		rbuf[5] = sector_size >> (8 * 2);
+		rbuf[6] = sector_size >> (8 * 1);
+		rbuf[7] = sector_size;
 	} else {
 		/* sector count, 64-bit */
 		rbuf[0] = last_lba >> (8 * 7);
@@ -2383,8 +2400,15 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 		rbuf[7] = last_lba;
 
 		/* sector size */
-		rbuf[10] = ATA_SECT_SIZE >> 8;
-		rbuf[11] = ATA_SECT_SIZE & 0xff;
+		rbuf[8] = sector_size >> (8 * 3);
+		rbuf[9] = sector_size >> (8 * 2);
+		rbuf[10] = sector_size >> (8 * 1);
+		rbuf[11] = sector_size;
+
+		rbuf[12] = 0;
+		rbuf[13] = log_per_phys;
+		rbuf[14] = first_sector_offset >> 8;
+		rbuf[15] = first_sector_offset;
 	}
 
 	return 0;
@@ -2858,7 +2882,7 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	}
 
 	/* READ/WRITE LONG use a non-standard sect_size */
-	qc->sect_size = ATA_SECT_SIZE;
+	qc->sect_size = dev->sect_size;
 	switch (tf->command) {
 	case ATA_CMD_READ_LONG:
 	case ATA_CMD_READ_LONG_ONCE:
diff --git a/include/linux/ata.h b/include/linux/ata.h
index cb79b7a..fdefc01 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -788,6 +788,25 @@ static inline int ata_drive_40wire_relaxed(const u16 *dev_id)
 	return 1;
 }
 
+/*
+ * ATA supports sector sizes up to 2^33 - 1.  The reported sector size may
+ * not be a power of two.  The extra bytes are used for user-visible data
+ * integrity calculations.  Note this is not the same as the ECC which is
+ * accessed through the SCT Command Transport or READ / WRITE LONG.
+ */
+static inline u64 ata_id_sect_size(const u16 *id)
+{
+	u16 word_106 = id[106];
+	u64 sz;
+
+	if ((word_106 & 0xc000) != 0x4000)
+		return ATA_SECT_SIZE;
+	if (!(word_106 & (1 << 12)))
+		return ATA_SECT_SIZE;
+	sz = (id[117] | ((u64)id[118] << 16)) * 2;
+	return sz;
+}
+
 static inline int atapi_cdb_len(const u16 *dev_id)
 {
 	u16 tmp = dev_id[ATA_ID_CONFIG] & 0x3;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index b450a26..08a5ae4 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -584,6 +584,7 @@ struct ata_device {
 #endif
 	/* n_sector is CLEAR_BEGIN, read comment above CLEAR_BEGIN */
 	u64			n_sectors;	/* size of device, if ATA */
+	u64			sect_size;	/* Logical, not physical */
 	unsigned int		class;		/* ATA_DEV_xxx */
 	unsigned long		unpark_deadline;
 
