Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbYHRSPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbYHRSPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbYHRSPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:15:42 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42395 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbYHRSPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:15:40 -0400
Date: Mon, 18 Aug 2008 12:15:24 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Matt_Domsch@dell.com, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] ata: Add support for Long Logical Sectors and Long Physical Sectors
Message-ID: <20080818181523.GG677@parisc-linux.org>
References: <1217957207-23116-1-git-send-email-matthew@wil.cx> <1217957207-23116-3-git-send-email-matthew@wil.cx> <48A8B211.8030103@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A8B211.8030103@pobox.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 07:19:45PM -0400, Jeff Garzik wrote:
> Matthew Wilcox wrote:
> >From: Matthew Wilcox <willy@linux.intel.com>
> >
> >ATA 8 adds support for devices that have sector sizes larger than 512
> >bytes.  We record the sector size in the ata_device and use it instead
> >of the ATA_SECT_SIZE when the data transfer is a multiple of sectors.
> >
> >Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> >---
> > drivers/ata/libata-core.c |  127 
> > +++++++++++++++++++++++++++++++++++++++++++++
> > drivers/ata/libata-scsi.c |   52 +++++++++++++-----
> > include/linux/libata.h    |    4 +-
> > 3 files changed, 168 insertions(+), 15 deletions(-)
> 
> Was this ever updated regarding Alan's final comments?
> 
> I only have this patch (the one initiating the email sub-thread).

I didn't update it fully; I moved onto something else.  I didn't change
the first of the two patches, so I'll just include the new version of
the second one in this mail.  I think it addresses all of Alan's comments.
I'll have a git tree up soon for you to pull from.

commit dfde7a888bae3b36113b19f37e9edb29be9ae803
Author: Matthew Wilcox <willy@linux.intel.com>
Date:   Tue Aug 5 02:25:57 2008 -0400

    ata: Add support for Long Logical Sectors and Long Physical Sectors
    
    ATA 8 permits devices that have sector sizes larger than 512 bytes.
    We support this by recording the sector size in the ata_device and use
    it instead of the ATA_SECT_SIZE when the data transfer is a multiple
    of sectors.  Drivers must indicate their support for sector sizes other
    than 512 by implementing the 'sector_size_supported' port operation.
    
    Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5ba96c5..31e359e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -446,6 +446,113 @@ void ata_tf_from_fis(const u8 *fis, struct ata_taskfile *tf)
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
+	enum {
+		UNKNOWN = 0,
+		FIVE_TWELVE = 1,
+		DEVICE = 2,
+	};
+
+	static const char command_sect_size[256] = {
+		[ ATA_CMD_CFA_TRANSLATE_SECTOR ] = DEVICE,
+		[ ATA_CMD_CFA_WRITE_MULTI_WITHOUT_ERASE ] = DEVICE,
+		[ ATA_CMD_CFA_WRITE_SECTORS_WITHOUT_ERASE ] = DEVICE,
+		[ ATA_CMD_READ ] = DEVICE,
+		[ ATA_CMD_READ_EXT ] = DEVICE,
+		[ ATA_CMD_READ_QUEUED ] = DEVICE,
+		[ ATA_CMD_READ_QUEUED_EXT ] = DEVICE,
+		[ ATA_CMD_FPDMA_READ ] = DEVICE,
+		[ ATA_CMD_READ_MULTI ] = DEVICE,
+		[ ATA_CMD_READ_MULTI_EXT ] = DEVICE,
+		[ ATA_CMD_PIO_READ ] = DEVICE,
+		[ ATA_CMD_PIO_READ_EXT ] = DEVICE,
+		[ ATA_CMD_READ_STREAM_DMA_EXT ] = DEVICE,
+		[ ATA_CMD_READ_STREAM_EXT ] = DEVICE,
+		[ ATA_CMD_VERIFY ] = DEVICE,
+		[ ATA_CMD_VERIFY_EXT ] = DEVICE, /* XXX: not listed in rev 5 */
+		[ ATA_CMD_WRITE ] = DEVICE,
+		[ ATA_CMD_WRITE_EXT ] = DEVICE,
+		[ ATA_CMD_WRITE_FUA_EXT ] = DEVICE,
+		[ ATA_CMD_WRITE_DMA_QUEUED ] = DEVICE,
+		[ ATA_CMD_WRITE_DMA_QUEUED_EXT ] = DEVICE,
+		[ ATA_CMD_WRITE_DMA_QUEUED_FUA_EXT ] = DEVICE,
+		[ ATA_CMD_FPDMA_WRITE ] = DEVICE,
+		[ ATA_CMD_WRITE_MULTI ] = DEVICE,
+		[ ATA_CMD_WRITE_MULTI_EXT ] = DEVICE,
+		[ ATA_CMD_WRITE_MULTI_FUA_EXT ] = DEVICE,
+		[ ATA_CMD_PIO_WRITE ] = DEVICE,
+		[ ATA_CMD_PIO_WRITE_EXT ] = DEVICE,
+		[ ATA_CMD_WRITE_STREAM_DMA_EXT ] = DEVICE,
+		[ ATA_CMD_WRITE_STREAM_EXT ] = DEVICE,
+		[ ATA_CMD_CFA_ERASE_SECTORS ] = FIVE_TWELVE,
+		[ ATA_CMD_CFA_REQUEST_EXT_ERROR ] = FIVE_TWELVE,
+		[ ATA_CMD_CHK_MEDIA_CARD_TYPE ] = FIVE_TWELVE,
+		[ ATA_CMD_CHK_POWER ] = FIVE_TWELVE,
+		[ ATA_CMD_CONFIG_STREAM ] = FIVE_TWELVE,
+		[ ATA_CMD_CONF_OVERLAY ] = FIVE_TWELVE,
+		[ ATA_CMD_DEV_RESET ] = FIVE_TWELVE,
+		[ ATA_CMD_DLOAD_MCODE ] = FIVE_TWELVE,
+		[ ATA_CMD_EDD ] = FIVE_TWELVE,
+		[ ATA_CMD_FLUSH ] = FIVE_TWELVE,
+		[ ATA_CMD_FLUSH_EXT ] = FIVE_TWELVE,
+		[ ATA_CMD_ID_ATA ] = FIVE_TWELVE,
+		[ ATA_CMD_ID_ATAPI ] = FIVE_TWELVE,
+		[ ATA_CMD_IDLE ] = FIVE_TWELVE,
+		[ ATA_CMD_IDLEIMMEDIATE ] = FIVE_TWELVE,
+		[ ATA_CMD_NVCACHE ] = FIVE_TWELVE,
+		[ ATA_CMD_NOP ] = FIVE_TWELVE,
+		[ ATA_CMD_PACKET ] = FIVE_TWELVE,
+		[ ATA_CMD_PMP_READ ] = FIVE_TWELVE,
+		[ ATA_CMD_READ_LOG_EXT ] = FIVE_TWELVE,
+		[ ATA_CMD_READ_LOG_DMA_EXT ] = FIVE_TWELVE,
+		[ ATA_CMD_READ_NATIVE_MAX ] = FIVE_TWELVE,
+		[ ATA_CMD_READ_NATIVE_MAX_EXT ] = FIVE_TWELVE,
+		[ ATA_CMD_SEC_DISABLE_PASSWORD ] = FIVE_TWELVE,
+		[ ATA_CMD_SEC_ERASE_PREPARE ] = FIVE_TWELVE,
+		[ ATA_CMD_SEC_ERASE_UNIT ] = FIVE_TWELVE,
+		[ ATA_CMD_SEC_FREEZE_LOCK ] = FIVE_TWELVE,
+		[ ATA_CMD_SEC_SET_PASSWORD ] = FIVE_TWELVE,
+		[ ATA_CMD_SEC_UNLOCK ] = FIVE_TWELVE,
+		[ ATA_CMD_SERVICE ] = FIVE_TWELVE,
+		[ ATA_CMD_SET_FEATURES ] = FIVE_TWELVE,
+		[ ATA_CMD_SET_MAX ] = FIVE_TWELVE,
+		[ ATA_CMD_SET_MAX_EXT ] = FIVE_TWELVE,
+		[ ATA_CMD_SET_MULTI ] = FIVE_TWELVE,
+		[ ATA_CMD_SLEEP ] = FIVE_TWELVE,
+		[ ATA_CMD_SMART ] = FIVE_TWELVE,
+		[ ATA_CMD_STANDBY ] = FIVE_TWELVE,
+		[ ATA_CMD_STANDBYNOW1 ] = FIVE_TWELVE,
+		[ ATA_CMD_TRUSTED_NON_DATA ] = FIVE_TWELVE,
+		[ ATA_CMD_TRUSTED_RECEIVE ] = FIVE_TWELVE,
+		[ ATA_CMD_TRUSTED_RECEIVE_DMA ] = FIVE_TWELVE,
+		[ ATA_CMD_TRUSTED_SEND ] = FIVE_TWELVE,
+		[ ATA_CMD_TRUSTED_SEND_DMA ] = FIVE_TWELVE,
+		[ ATA_CMD_PMP_WRITE ] = FIVE_TWELVE,
+		[ ATA_CMD_WRITE_LOG_EXT ] = FIVE_TWELVE,
+		[ ATA_CMD_WRITE_LOG_DMA_EXT ] = FIVE_TWELVE,
+		[ ATA_CMD_WRITE_UNCORRECTABLE_EXT ] = FIVE_TWELVE,
+		[ ATA_CMD_INIT_DEV_PARAMS ] = FIVE_TWELVE,
+	};
+
+	char size = command_sect_size[command];
+	if (size == DEVICE)
+		return dev_sect_size;
+	if (size == UNKNOWN && printk_ratelimit())
+		printk("Unknown ata cmd %d, assuming 512 byte sector size\n",
+				command);
+	return 512;
+}
+
 static const u8 ata_rw_cmds[] = {
 	/* pio multi */
 	ATA_CMD_READ_MULTI,
@@ -1190,6 +1297,25 @@ static u64 ata_id_n_sectors(const u16 *id)
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
@@ -2117,6 +2243,20 @@ static void ata_dev_config_ncq(struct ata_device *dev,
 		snprintf(desc, desc_sz, "NCQ (depth %d/%d)", hdepth, ddepth);
 }
 
+static int ata_check_sect_size(struct ata_device *dev)
+{
+	/* Every device can handle 512 byte sectors */
+	if (dev->sect_size == 512)
+		return 0;
+	/* Linux doesn't handle sectors above 4GB.  This may be a problem
+	 * around 2050 or so.  Deal with it then.  */
+	if (dev->sect_size > 0xffffffffULL)
+		return -EINVAL;
+	if (!dev->link->ap->ops->sector_size_supported)
+		return -EINVAL;
+	return dev->link->ap->ops->sector_size_supported(dev) ? 0 : -EINVAL;
+}
+
 /**
  *	ata_dev_configure - Configure the specified ATA/ATAPI device
  *	@dev: Target device to configure
@@ -2196,6 +2336,7 @@ int ata_dev_configure(struct ata_device *dev)
 	dev->max_sectors = 0;
 	dev->cdb_len = 0;
 	dev->n_sectors = 0;
+	dev->sect_size = ATA_SECT_SIZE;
 	dev->cylinders = 0;
 	dev->heads = 0;
 	dev->sectors = 0;
@@ -2235,6 +2376,13 @@ int ata_dev_configure(struct ata_device *dev)
 		}
 
 		dev->n_sectors = ata_id_n_sectors(id);
+		dev->sect_size = ata_id_sect_size(id);
+		rc = ata_check_sect_size(dev);
+		if (rc) {
+			ata_dev_printk(dev, KERN_ERR, "sector size %lld not "
+					"supported.\n", dev->sect_size);
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
index 06b8033..16a2132 100644
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
@@ -753,6 +754,7 @@ struct ata_port_operations {
 	unsigned int (*read_id)(struct ata_device *dev, struct ata_taskfile *tf, u16 *id);
 
 	void (*dev_config)(struct ata_device *dev);
+	bool (*sector_size_supported)(struct ata_device *dev);
 
 	void (*freeze)(struct ata_port *ap);
 	void (*thaw)(struct ata_port *ap);
@@ -956,6 +958,7 @@ extern unsigned int ata_do_dev_read_id(struct ata_device *dev,
 					struct ata_taskfile *tf, u16 *id);
 extern void ata_qc_complete(struct ata_queued_cmd *qc);
 extern int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active);
+extern unsigned ata_sect_size(u8 command, unsigned dev_sect_size);
 extern void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 			      void (*done)(struct scsi_cmnd *));
 extern int ata_std_bios_param(struct scsi_device *sdev,

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
