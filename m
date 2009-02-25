Return-Path: <linux-kernel-owner+w=401wt.eu-S932128AbZBYWZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbZBYWZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759338AbZBYWZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:25:06 -0500
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:40983 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756973AbZBYWZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:25:01 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 2/2] ata: Add support for Long Logical Sectors and Long Physical Sectors
Date: Wed, 25 Feb 2009 17:24:58 -0500
Message-Id: <1235600698-6446-3-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1235600698-6446-1-git-send-email-matthew@wil.cx>
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

ATA 8 permits devices that have sector sizes larger than 512 bytes.
We support this by recording the sector size in the ata_device and use
it instead of the ATA_SECT_SIZE when the data transfer is a multiple
of sectors.  Drivers must indicate their support for sector sizes other
than 512 by implementing the 'sector_size_supported' port operation.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/ata/Makefile       |   11 ++++
 drivers/ata/ata-commands.c |  132 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/bitops.c       |   77 +++++++++++++++++++++++++
 drivers/ata/bitops.h       |   12 ++++
 drivers/ata/libata-core.c  |   67 ++++++++++++++++++++++
 drivers/ata/libata-scsi.c  |   52 +++++++++++++-----
 include/linux/libata.h     |    3 +
 7 files changed, 340 insertions(+), 14 deletions(-)
 create mode 100644 drivers/ata/ata-commands.c
 create mode 100644 drivers/ata/bitops.c
 create mode 100644 drivers/ata/bitops.h

diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 7f1ecf9..a67d5dc 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -84,3 +84,14 @@ libata-objs	:= libata-core.o libata-scsi.o libata-eh.o
 libata-$(CONFIG_ATA_SFF)	+= libata-sff.o
 libata-$(CONFIG_SATA_PMP)	+= libata-pmp.o
 libata-$(CONFIG_ATA_ACPI)	+= libata-acpi.o
+
+hostprogs-y := ata-commands
+ata-commands-objs := ata-commands.o bitops.o
+HOSTCFLAGS_ata-commands.o       := -Iinclude
+clean-files := all-commands sector-commands
+quiet_cmd_ata-cmds = ATA-CMD 
+      cmd_ata-cmds = $(obj)/ata-commands || (rm -f all-commands sector-commands)
+
+$(obj)/all-commands: $(obj)/ata-commands
+	$(call if_changed,ata-cmds)
+$(obj)/libata-core.o: $(obj)/all-commands
diff --git a/drivers/ata/ata-commands.c b/drivers/ata/ata-commands.c
new file mode 100644
index 0000000..afb40c1
--- /dev/null
+++ b/drivers/ata/ata-commands.c
@@ -0,0 +1,132 @@
+/*
+ * ata-commands.c
+ *
+ * Copyright (c) 2008 Intel Corporation
+ * Author: Matthew Wilcox <willy@linux.intel.com>
+ *
+ * This file is part of the Linux kernel, and is made available under
+ * the terms of the GNU General Public License, version 2
+ */
+
+#include <stdio.h>
+
+#include "bitops.h"
+
+/* We have to define some types to include ata.h */
+
+typedef unsigned char u8;
+typedef unsigned short u16;
+typedef unsigned int u32;
+typedef unsigned long long u64;
+typedef int bool;
+#define false 0
+#define true 1
+#define _LINUX_SWAB_H
+#include "linux/ata.h"
+
+void set_sector_bits(void)
+{
+	set_bit(ATA_CMD_CFA_TRANSLATE_SECTOR);
+	set_bit(ATA_CMD_CFA_WRITE_MULTI_WITHOUT_ERASE);
+	set_bit(ATA_CMD_CFA_WRITE_SECTORS_WITHOUT_ERASE);
+	set_bit(ATA_CMD_READ);
+	set_bit(ATA_CMD_READ_EXT);
+	set_bit(ATA_CMD_READ_QUEUED);
+	set_bit(ATA_CMD_READ_QUEUED_EXT);
+	set_bit(ATA_CMD_FPDMA_READ);
+	set_bit(ATA_CMD_READ_MULTI);
+	set_bit(ATA_CMD_READ_MULTI_EXT);
+	set_bit(ATA_CMD_PIO_READ);
+	set_bit(ATA_CMD_PIO_READ_EXT);
+	set_bit(ATA_CMD_READ_STREAM_DMA_EXT);
+	set_bit(ATA_CMD_READ_STREAM_EXT);
+	set_bit(ATA_CMD_VERIFY);
+	set_bit(ATA_CMD_VERIFY_EXT);
+	set_bit(ATA_CMD_WRITE);
+	set_bit(ATA_CMD_WRITE_EXT);
+	set_bit(ATA_CMD_WRITE_FUA_EXT);
+	set_bit(ATA_CMD_WRITE_DMA_QUEUED);
+	set_bit(ATA_CMD_WRITE_DMA_QUEUED_EXT);
+	set_bit(ATA_CMD_WRITE_DMA_QUEUED_FUA_EXT);
+	set_bit(ATA_CMD_FPDMA_WRITE);
+	set_bit(ATA_CMD_WRITE_MULTI);
+	set_bit(ATA_CMD_WRITE_MULTI_EXT);
+	set_bit(ATA_CMD_WRITE_MULTI_FUA_EXT);
+	set_bit(ATA_CMD_PIO_WRITE);
+	set_bit(ATA_CMD_PIO_WRITE_EXT);
+	set_bit(ATA_CMD_WRITE_STREAM_DMA_EXT);
+	set_bit(ATA_CMD_WRITE_STREAM_EXT);
+}
+
+void set_512_bits(void)
+{
+	set_bit(ATA_CMD_CFA_ERASE_SECTORS);
+	set_bit(ATA_CMD_CFA_REQUEST_EXT_ERROR);
+	set_bit(ATA_CMD_CHK_MEDIA_CARD_TYPE);
+	set_bit(ATA_CMD_CHK_POWER);
+	set_bit(ATA_CMD_CONFIG_STREAM);
+	set_bit(ATA_CMD_CONF_OVERLAY);
+	set_bit(ATA_CMD_DEV_RESET);
+	set_bit(ATA_CMD_DLOAD_MCODE);
+	set_bit(ATA_CMD_EDD);
+	set_bit(ATA_CMD_FLUSH);
+	set_bit(ATA_CMD_FLUSH_EXT);
+	set_bit(ATA_CMD_ID_ATA);
+	set_bit(ATA_CMD_ID_ATAPI);
+	set_bit(ATA_CMD_IDLE);
+	set_bit(ATA_CMD_IDLEIMMEDIATE);
+	set_bit(ATA_CMD_MEDIA_LOCK);
+	set_bit(ATA_CMD_MEDIA_UNLOCK);
+	set_bit(ATA_CMD_NVCACHE);
+	set_bit(ATA_CMD_NOP);
+	set_bit(ATA_CMD_PACKET);
+	set_bit(ATA_CMD_PMP_READ);
+	set_bit(ATA_CMD_READ_LOG_EXT);
+	set_bit(ATA_CMD_READ_LOG_DMA_EXT);
+	set_bit(ATA_CMD_READ_NATIVE_MAX);
+	set_bit(ATA_CMD_READ_NATIVE_MAX_EXT);
+	set_bit(ATA_CMD_RESTORE);
+	set_bit(ATA_CMD_SEC_DISABLE_PASSWORD);
+	set_bit(ATA_CMD_SEC_ERASE_PREPARE);
+	set_bit(ATA_CMD_SEC_ERASE_UNIT);
+	set_bit(ATA_CMD_SEC_FREEZE_LOCK);
+	set_bit(ATA_CMD_SEC_SET_PASSWORD);
+	set_bit(ATA_CMD_SEC_UNLOCK);
+	set_bit(ATA_CMD_SERVICE);
+	set_bit(ATA_CMD_SET_FEATURES);
+	set_bit(ATA_CMD_SET_MAX);
+	set_bit(ATA_CMD_SET_MAX_EXT);
+	set_bit(ATA_CMD_SET_MULTI);
+	set_bit(ATA_CMD_SLEEP);
+	set_bit(ATA_CMD_SMART);
+	set_bit(ATA_CMD_STANDBY);
+	set_bit(ATA_CMD_STANDBYNOW1);
+	set_bit(ATA_CMD_TRUSTED_NON_DATA);
+	set_bit(ATA_CMD_TRUSTED_RECEIVE);
+	set_bit(ATA_CMD_TRUSTED_RECEIVE_DMA);
+	set_bit(ATA_CMD_TRUSTED_SEND);
+	set_bit(ATA_CMD_TRUSTED_SEND_DMA);
+	set_bit(ATA_CMD_PMP_WRITE);
+	set_bit(ATA_CMD_WRITE_LOG_EXT);
+	set_bit(ATA_CMD_WRITE_LOG_DMA_EXT);
+	set_bit(ATA_CMD_WRITE_UNCORRECTABLE_EXT);
+	set_bit(ATA_CMD_INIT_DEV_PARAMS);
+	set_bit(ATA_EXABYTE_ENABLE_NEST);
+}
+
+int main(int argc, char **argv)
+{
+	FILE *out;
+
+	set_sector_bits();
+	out = fopen("drivers/ata/sector-commands", "w");
+	output_array(out);
+	fclose(out);
+
+	set_512_bits();
+	out = fopen("drivers/ata/all-commands", "w");
+	output_array(out);
+	fclose(out);
+
+	return 0;
+}
diff --git a/drivers/ata/bitops.c b/drivers/ata/bitops.c
new file mode 100644
index 0000000..f6a6f06
--- /dev/null
+++ b/drivers/ata/bitops.c
@@ -0,0 +1,77 @@
+/*
+ * bitops.c
+ *
+ * Copyright 2008 Intel Corporation
+ * Author: Matthew Wilcox <willy@linux.intel.com>
+ *
+ * This file is part of the Linux kernel, and is made available under
+ * the terms of the GNU General Public License, version 2
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "bitops.h"
+
+static unsigned int *array;
+static unsigned maxbit, allocbit;
+
+static void expand_array(unsigned bit)
+{
+	unsigned size;
+	void *tmp;
+
+	if (bit > maxbit)
+		maxbit = bit;
+	if (bit < allocbit)
+		return;
+
+	size = ((bit + 63) / 64) * 8;
+	tmp = realloc(array, size);
+	if (!tmp) {
+		fprintf(stderr, "Memory allocation failure\n");
+		exit(1);
+	}
+	array = tmp;
+	memset(array + allocbit / 8, 0, size - allocbit / 8);
+	allocbit = size * 8;
+}
+
+void set_bit(unsigned bit)
+{
+	expand_array(bit);
+	array[bit / 32] |= 1 << (bit % 32);
+}
+
+static const char *sep(unsigned i, unsigned w)
+{
+	if (i >= w - 1)
+		return "\n";
+	if (i % 6 == 5)
+		return "\n\t";
+	return " ";
+}
+
+void output_array(FILE *file)
+{
+	unsigned i, words = (maxbit + 32) / 32;
+
+	fprintf(file, "{\n#ifdef CONFIG_64BIT\n\t");
+	for (i = 0; i < words; i += 2) {
+		fprintf(file, "0x%08x%08xULL,%s", array[i + 1], array[i],
+							sep(i + 1, words));
+	}
+	fprintf(file, "#else\n\t");
+	for (i = 0; i < words; i++) {
+		fprintf(file, "0x%08x,%s", array[i], sep(i, words));
+	}
+	fprintf(file, "#endif\n};\n");
+}
+
+void free_array(void)
+{
+	free(array);
+	array = NULL;
+	maxbit = allocbit = 0;
+}
diff --git a/drivers/ata/bitops.h b/drivers/ata/bitops.h
new file mode 100644
index 0000000..3da560c
--- /dev/null
+++ b/drivers/ata/bitops.h
@@ -0,0 +1,12 @@
+/*
+ * A library for creating statically initialised bit arrays
+ */
+
+/* Call this to set a bit. */
+extern void set_bit(unsigned bit);
+
+/* Call this to output the array. */
+extern void output_array(FILE *file);
+
+/* Remove all bits from the array. */
+extern void free_array(void);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9fbf059..61378d8 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -600,6 +600,32 @@ void ata_tf_from_fis(const u8 *fis, struct ata_taskfile *tf)
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
+	static const unsigned long sector_commands[] =
+#include "sector-commands"
+	static unsigned long known_commands[] =
+#include "all-commands"
+
+	if (test_bit(command, sector_commands))
+		return dev_sect_size;
+	if (!test_bit(command, known_commands)) {
+		printk(KERN_ERR "Unknown ata cmd %d, assuming "
+				"512 byte sector size\n", command);
+		set_bit(command, known_commands);
+	}
+	return 512;
+}
+
 static const u8 ata_rw_cmds[] = {
 	/* pio multi */
 	ATA_CMD_READ_MULTI,
@@ -1333,6 +1359,25 @@ static u64 ata_id_n_sectors(const u16 *id)
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
@@ -2301,6 +2346,20 @@ static void ata_dev_config_ncq(struct ata_device *dev,
 		snprintf(desc, desc_sz, "NCQ (depth %d/%d)", hdepth, ddepth);
 }
 
+static int ata_check_sect_size(struct ata_device *dev)
+{
+	/* Every host can handle 512 byte sectors */
+	if (dev->sect_size == 512)
+		return 0;
+	/* Linux doesn't handle sectors larger than 4GB.  This may be
+	 * a problem around 2050 or so.  Deal with it then.  */
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
@@ -2384,6 +2443,7 @@ int ata_dev_configure(struct ata_device *dev)
 	dev->max_sectors = 0;
 	dev->cdb_len = 0;
 	dev->n_sectors = 0;
+	dev->sect_size = ATA_SECT_SIZE;
 	dev->cylinders = 0;
 	dev->heads = 0;
 	dev->sectors = 0;
@@ -2423,6 +2483,13 @@ int ata_dev_configure(struct ata_device *dev)
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
index b9747fa..9e89601 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -50,7 +50,6 @@
 
 #include "libata.h"
 
-#define SECTOR_SIZE		512
 #define ATA_SCSI_RBUF_SIZE	4096
 
 static DEFINE_SPINLOCK(ata_scsi_rbuf_lock);
@@ -455,7 +454,7 @@ static int ata_get_identity(struct ata_port *ap, struct scsi_device *sdev,
 
 /**
  *	ata_cmd_ioctl - Handler for HDIO_DRIVE_CMD ioctl
- *	@scsidev: Device to which we are issuing command
+ *	@sdev: Device to which we are issuing command
  *	@arg: User provided data for issuing command
  *
  *	LOCKING:
@@ -464,7 +463,7 @@ static int ata_get_identity(struct ata_port *ap, struct scsi_device *sdev,
  *	RETURNS:
  *	Zero on success, negative errno on error.
  */
-int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
+int ata_cmd_ioctl(struct scsi_device *sdev, void __user *arg)
 {
 	int rc = 0;
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
@@ -486,7 +485,8 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	memset(scsi_cmd, 0, sizeof(scsi_cmd));
 
 	if (args[3]) {
-		argsize = SECTOR_SIZE * args[3];
+		unsigned sect_size = ata_sect_size(args[0], sdev->sector_size);
+		argsize = sect_size * args[3];
 		argbuf = kmalloc(argsize, GFP_KERNEL);
 		if (argbuf == NULL) {
 			rc = -ENOMEM;
@@ -518,7 +518,7 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
+	cmd_result = scsi_execute(sdev, scsi_cmd, data_dir, argbuf, argsize,
 				  sensebuf, (10*HZ), 5, 0, NULL);
 
 	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
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
+	qc->sect_size = ata_sect_size(tf->command, dev->sect_size);
 	switch (tf->command) {
 	case ATA_CMD_READ_LONG:
 	case ATA_CMD_READ_LONG_ONCE:
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 5d87bc0..e0d17ec 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -583,6 +583,7 @@ struct ata_device {
 #endif
 	/* n_sector is CLEAR_BEGIN, read comment above CLEAR_BEGIN */
 	u64			n_sectors;	/* size of device, if ATA */
+	u64			sect_size;	/* Logical, not physical */
 	unsigned int		class;		/* ATA_DEV_xxx */
 	unsigned long		unpark_deadline;
 
@@ -781,6 +782,7 @@ struct ata_port_operations {
 	unsigned int (*read_id)(struct ata_device *dev, struct ata_taskfile *tf, u16 *id);
 
 	void (*dev_config)(struct ata_device *dev);
+	bool (*sector_size_supported)(struct ata_device *dev);
 
 	void (*freeze)(struct ata_port *ap);
 	void (*thaw)(struct ata_port *ap);
@@ -988,6 +990,7 @@ extern unsigned int ata_do_dev_read_id(struct ata_device *dev,
 					struct ata_taskfile *tf, u16 *id);
 extern void ata_qc_complete(struct ata_queued_cmd *qc);
 extern int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active);
+extern unsigned ata_sect_size(u8 command, unsigned dev_sect_size);
 extern void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 			      void (*done)(struct scsi_cmnd *));
 extern int ata_std_bios_param(struct scsi_device *sdev,
-- 
1.5.6.5

