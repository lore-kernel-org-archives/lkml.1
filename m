Return-Path: <linux-kernel-owner+w=401wt.eu-S1762971AbYHERxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762971AbYHERxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759088AbYHERwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:52:33 -0400
Received: from ottawa-hs-64-26-148-84.d-ip.magma.ca ([64.26.148.84]:33990 "EHLO
	gonzo.int.wil.cx" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755105AbYHERw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:52:29 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: jgarzik@pobox.com, Matt_Domsch@dell.com,
       Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH] ata: Add support for Long Logical Sectors and Long Physical Sectors
Date: Tue,  5 Aug 2008 13:26:47 -0400
Message-Id: <1217957207-23116-3-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1217957207-23116-1-git-send-email-matthew@wil.cx>
References: <1217957207-23116-1-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

ATA 8 adds support for devices that have sector sizes larger than 512
bytes.  We record the sector size in the ata_device and use it instead
of the ATA_SECT_SIZE when the data transfer is a multiple of sectors.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/ata/libata-core.c |  127 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-scsi.c |   52 +++++++++++++-----
 include/linux/libata.h    |    4 +-
 3 files changed, 168 insertions(+), 15 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5ba96c5..8f38d0c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -446,6 +446,106 @@ void ata_tf_from_fis(const u8 *fis, struct ata_taskfile *tf)
 	tf->hob_nsect	= fis[13];
 }
 
+/**
+ * ata_sect_size - Returns the sector size to use for a command
+ * @command: The ATA command byte
+ * @dev_sect_size: The size of the drive's sectors
+ *
+ * Some commands are specified to transfer (a multiple of) 512 bytes of data
+ * while others transfer a multiple of the number of bytes in a sector.  This
+ * function knows which commands transfer how much data.
+ */
+unsigned ata_sect_size(u8 command, unsigned dev_sect_size)
+{
+	switch (command) {
+	case ATA_CMD_CFA_TRANSLATE_SECTOR:
+	case ATA_CMD_CFA_WRITE_MULTI_WITHOUT_ERASE:
+	case ATA_CMD_CFA_WRITE_SECTORS_WITHOUT_ERASE:
+	case ATA_CMD_READ:
+	case ATA_CMD_READ_EXT:
+	case ATA_CMD_READ_QUEUED:
+	case ATA_CMD_READ_QUEUED_EXT:
+	case ATA_CMD_FPDMA_READ:
+	case ATA_CMD_READ_MULTI:
+	case ATA_CMD_READ_MULTI_EXT:
+	case ATA_CMD_PIO_READ:
+	case ATA_CMD_PIO_READ_EXT:
+	case ATA_CMD_READ_STREAM_DMA_EXT:
+	case ATA_CMD_READ_STREAM_EXT:
+	case ATA_CMD_VERIFY:
+	case ATA_CMD_VERIFY_EXT: /* XXX: not listed in rev 5 */
+	case ATA_CMD_WRITE:
+	case ATA_CMD_WRITE_EXT:
+	case ATA_CMD_WRITE_FUA_EXT:
+	case ATA_CMD_WRITE_DMA_QUEUED:
+	case ATA_CMD_WRITE_DMA_QUEUED_EXT:
+	case ATA_CMD_WRITE_DMA_QUEUED_FUA_EXT:
+	case ATA_CMD_FPDMA_WRITE:
+	case ATA_CMD_WRITE_MULTI:
+	case ATA_CMD_WRITE_MULTI_EXT:
+	case ATA_CMD_WRITE_MULTI_FUA_EXT:
+	case ATA_CMD_PIO_WRITE:
+	case ATA_CMD_PIO_WRITE_EXT:
+	case ATA_CMD_WRITE_STREAM_DMA_EXT:
+	case ATA_CMD_WRITE_STREAM_EXT:
+		return dev_sect_size;
+
+	default:
+		if (printk_ratelimit())
+			printk("Unknown ata cmd %d, assuming 512 byte "
+				"sector size\n", command);
+	case ATA_CMD_CFA_ERASE_SECTORS:
+	case ATA_CMD_CFA_REQUEST_EXT_ERROR:
+	case ATA_CMD_CHK_MEDIA_CARD_TYPE:
+	case ATA_CMD_CHK_POWER:
+	case ATA_CMD_CONFIG_STREAM:
+	case ATA_CMD_CONF_OVERLAY:
+	case ATA_CMD_DEV_RESET:
+	case ATA_CMD_DLOAD_MCODE:
+	case ATA_CMD_EDD:
+	case ATA_CMD_FLUSH:
+	case ATA_CMD_FLUSH_EXT:
+	case ATA_CMD_ID_ATA:
+	case ATA_CMD_ID_ATAPI:
+	case ATA_CMD_IDLE:
+	case ATA_CMD_IDLEIMMEDIATE:
+	case ATA_CMD_NVCACHE:
+	case ATA_CMD_NOP:
+	case ATA_CMD_PACKET:
+	case ATA_CMD_PMP_READ:
+	case ATA_CMD_READ_LOG_EXT:
+	case ATA_CMD_READ_LOG_DMA_EXT:
+	case ATA_CMD_READ_NATIVE_MAX:
+	case ATA_CMD_READ_NATIVE_MAX_EXT:
+	case ATA_CMD_SEC_DISABLE_PASSWORD:
+	case ATA_CMD_SEC_ERASE_PREPARE:
+	case ATA_CMD_SEC_ERASE_UNIT:
+	case ATA_CMD_SEC_FREEZE_LOCK:
+	case ATA_CMD_SEC_SET_PASSWORD:
+	case ATA_CMD_SEC_UNLOCK:
+	case ATA_CMD_SERVICE:
+	case ATA_CMD_SET_FEATURES:
+	case ATA_CMD_SET_MAX:
+	case ATA_CMD_SET_MAX_EXT:
+	case ATA_CMD_SET_MULTI:
+	case ATA_CMD_SLEEP:
+	case ATA_CMD_SMART:
+	case ATA_CMD_STANDBY:
+	case ATA_CMD_STANDBYNOW1:
+	case ATA_CMD_TRUSTED_NON_DATA:
+	case ATA_CMD_TRUSTED_RECEIVE:
+	case ATA_CMD_TRUSTED_RECEIVE_DMA:
+	case ATA_CMD_TRUSTED_SEND:
+	case ATA_CMD_TRUSTED_SEND_DMA:
+	case ATA_CMD_PMP_WRITE:
+	case ATA_CMD_WRITE_LOG_EXT:
+	case ATA_CMD_WRITE_LOG_DMA_EXT:
+	case ATA_CMD_WRITE_UNCORRECTABLE_EXT:
+	case ATA_CMD_INIT_DEV_PARAMS:
+		return ATA_SECT_SIZE;
+	}
+}
+
 static const u8 ata_rw_cmds[] = {
 	/* pio multi */
 	ATA_CMD_READ_MULTI,
@@ -1190,6 +1290,25 @@ static u64 ata_id_n_sectors(const u16 *id)
 	}
 }
 
+/*
+ * ATA supports sector sizes up to 2^33 - 1.  The reported sector size may
+ * not be a power of two.  The extra bytes are used for user-visible data
+ * integrity calculations.  Note this is not the same as the ECC which is
+ * accessed through the SCT Command Transport or READ / WRITE LONG.
+ */
+static u64 ata_id_sect_size(const u16 *id)
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
 u64 ata_tf_to_lba48(const struct ata_taskfile *tf)
 {
 	u64 sectors = 0;
@@ -2196,6 +2315,7 @@ int ata_dev_configure(struct ata_device *dev)
 	dev->max_sectors = 0;
 	dev->cdb_len = 0;
 	dev->n_sectors = 0;
+	dev->sect_size = ATA_SECT_SIZE;
 	dev->cylinders = 0;
 	dev->heads = 0;
 	dev->sectors = 0;
@@ -2235,6 +2355,13 @@ int ata_dev_configure(struct ata_device *dev)
 		}
 
 		dev->n_sectors = ata_id_n_sectors(id);
+		dev->sect_size = ata_id_sect_size(id);
+		if (dev->sect_size > 0xffffffffULL) {
+			ata_dev_printk(dev, KERN_ERR, "sector size larger than "
+						"4GB not supported.\n");
+			rc = -EINVAL;
+			goto err_out_nosup;
+		}
 
 		if (dev->id[59] & 0x100)
 			dev->multi_count = dev->id[59] & 0xff;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b9d3ba4..145ea08 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -49,7 +49,6 @@
 
 #include "libata.h"
 
-#define SECTOR_SIZE		512
 #define ATA_SCSI_RBUF_SIZE	4096
 
 static DEFINE_SPINLOCK(ata_scsi_rbuf_lock);
@@ -347,7 +346,7 @@ static int ata_get_identity(struct scsi_device *sdev, void __user *arg)
 
 /**
  *	ata_cmd_ioctl - Handler for HDIO_DRIVE_CMD ioctl
- *	@scsidev: Device to which we are issuing command
+ *	@sdev: Device to which we are issuing command
  *	@arg: User provided data for issuing command
  *
  *	LOCKING:
@@ -356,7 +355,7 @@ static int ata_get_identity(struct scsi_device *sdev, void __user *arg)
  *	RETURNS:
  *	Zero on success, negative errno on error.
  */
-int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
+int ata_cmd_ioctl(struct scsi_device *sdev, void __user *arg)
 {
 	int rc = 0;
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
@@ -378,7 +377,8 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	memset(scsi_cmd, 0, sizeof(scsi_cmd));
 
 	if (args[3]) {
-		argsize = SECTOR_SIZE * args[3];
+		unsigned sect_size = ata_sect_size(args[0], sdev->sector_size);
+		argsize = sect_size * args[3];
 		argbuf = kmalloc(argsize, GFP_KERNEL);
 		if (argbuf == NULL) {
 			rc = -ENOMEM;
@@ -410,7 +410,7 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
+	cmd_result = scsi_execute(sdev, scsi_cmd, data_dir, argbuf, argsize,
 				  sensebuf, (10*HZ), 5, 0);
 
 	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
@@ -1493,6 +1493,7 @@ nothing_to_do:
 static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 {
 	struct scsi_cmnd *scmd = qc->scsicmd;
+	struct ata_device *dev = qc->dev;
 	const u8 *cdb = scmd->cmnd;
 	unsigned int tf_flags = 0;
 	u64 block;
@@ -1549,9 +1550,9 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 		goto nothing_to_do;
 
 	qc->flags |= ATA_QCFLAG_IO;
-	qc->nbytes = n_block * ATA_SECT_SIZE;
+	qc->nbytes = n_block * dev->sect_size;
 
-	rc = ata_build_rw_tf(&qc->tf, qc->dev, block, n_block, tf_flags,
+	rc = ata_build_rw_tf(&qc->tf, dev, block, n_block, tf_flags,
 			     qc->tag);
 	if (likely(rc == 0))
 		return 0;
@@ -2217,10 +2218,25 @@ saving_not_supp:
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
@@ -2231,9 +2247,10 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
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
@@ -2246,8 +2263,15 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
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
@@ -2721,7 +2745,7 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	}
 
 	/* READ/WRITE LONG use a non-standard sect_size */
-	qc->sect_size = ATA_SECT_SIZE;
+	qc->sect_size = ata_sect_size(tf->command, dev->sect_size);
 	switch (tf->command) {
 	case ATA_CMD_READ_LONG:
 	case ATA_CMD_READ_LONG_ONCE:
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 06b8033..fcf84d1 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -553,8 +553,8 @@ struct ata_ering {
 struct ata_device {
 	struct ata_link		*link;
 	unsigned int		devno;		/* 0 or 1 */
-	unsigned long		flags;		/* ATA_DFLAG_xxx */
 	unsigned int		horkage;	/* List of broken features */
+	unsigned long		flags;		/* ATA_DFLAG_xxx */
 	struct scsi_device	*sdev;		/* attached SCSI device */
 #ifdef CONFIG_ATA_ACPI
 	acpi_handle		acpi_handle;
@@ -562,6 +562,7 @@ struct ata_device {
 #endif
 	/* n_sector is used as CLEAR_OFFSET, read comment above CLEAR_OFFSET */
 	u64			n_sectors;	/* size of device, if ATA */
+	u64			sect_size;	/* Logical, not physical */
 	unsigned int		class;		/* ATA_DEV_xxx */
 
 	u8			pio_mode;
@@ -956,6 +957,7 @@ extern unsigned int ata_do_dev_read_id(struct ata_device *dev,
 					struct ata_taskfile *tf, u16 *id);
 extern void ata_qc_complete(struct ata_queued_cmd *qc);
 extern int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active);
+extern unsigned ata_sect_size(u8 command, unsigned dev_sect_size);
 extern void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 			      void (*done)(struct scsi_cmnd *));
 extern int ata_std_bios_param(struct scsi_device *sdev,
-- 
1.5.6.3

