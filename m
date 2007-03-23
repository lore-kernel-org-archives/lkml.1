Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbXCWSJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbXCWSJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 14:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbXCWSJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 14:09:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49632 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753262AbXCWSJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 14:09:46 -0400
Date: Fri, 23 Mar 2007 19:13:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       kyle@canonical.com
Subject: HPA patches
Message-ID: <20070323191321.5d00887a@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For reference this is what I am currently using with 2.6.21-rc4-mm1 and
it is working for all my test cases so far: Its basically Kyle's patch
with a libata switch to turn it on/off and some minor fixups from
the original patch as posted

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc4-mm1/drivers/ata/libata-core.c linux-2.6.21-rc4-mm1/drivers/ata/libata-core.c
--- linux.vanilla-2.6.21-rc4-mm1/drivers/ata/libata-core.c	2007-03-23 11:49:49.000000000 +0000
+++ linux-2.6.21-rc4-mm1/drivers/ata/libata-core.c	2007-03-23 13:05:15.000000000 +0000
@@ -89,6 +89,10 @@
 module_param_named(fua, libata_fua, int, 0444);
 MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on)");
 
+static int ata_ignore_hpa = 0;
+module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
+MODULE_PARM_DESC(ignore_hpa, "Ignore HPA (0=off 1=on)");
+
 static int ata_probe_timeout = ATA_TMOUT_INTERNAL / HZ;
 module_param(ata_probe_timeout, int, 0444);
 MODULE_PARM_DESC(ata_probe_timeout, "Set ATA probing timeout (seconds)");
@@ -808,6 +812,202 @@
 	*p = '\0';
 }
 
+static u64 ata_tf_to_lba48(struct ata_taskfile *tf)
+{
+	u64 sectors = 0;
+
+	sectors |= ((u64)(tf->hob_lbah & 0xff)) << 40;
+	sectors |= ((u64)(tf->hob_lbam & 0xff)) << 32;
+	sectors |= (tf->hob_lbal & 0xff) << 24;
+	sectors |= (tf->lbah & 0xff) << 16;
+	sectors |= (tf->lbam & 0xff) << 8;
+	sectors |= (tf->lbal & 0xff);
+
+	return ++sectors;
+}
+
+static u64 ata_tf_to_lba(struct ata_taskfile *tf)
+{
+	u64 sectors = 0;
+
+	sectors |= (tf->device & 0x0f) << 24;
+	sectors |= (tf->lbah & 0xff) << 16;
+	sectors |= (tf->lbam & 0xff) << 8;
+	sectors |= (tf->lbal & 0xff);
+
+	return ++sectors;
+}
+
+/**
+ *	ata_read_native_max_address_ext	-	LBA48 native max query
+ *	@dev: Device to query
+ *
+ *	Performa an LBA48 size query upon the device in question. Return the
+ *	actual LBA48 size or zero if the command fails.
+ */
+
+static u64 ata_read_native_max_address_ext(struct ata_device *dev)
+{
+	unsigned int err;
+	struct ata_taskfile tf;
+
+	ata_tf_init(dev, &tf);
+
+	tf.command = ATA_CMD_READ_NATIVE_MAX_EXT;
+	tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48 | ATA_TFLAG_ISADDR;
+	tf.protocol |= ATA_PROT_NODATA;
+	tf.device = 0x40;
+
+	err = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
+	if (err)
+		return 0;
+
+	return ata_tf_to_lba48(&tf);
+}
+
+/**
+ *	ata_read_native_max_address	-	LBA28 native max query
+ *	@dev: Device to query
+ *
+ *	Performa an LBA28 size query upon the device in question. Return the
+ *	actual LBA28 size or zero if the command fails.
+ */
+
+static u64 ata_read_native_max_address(struct ata_device *dev)
+{
+	unsigned int err;
+	struct ata_taskfile tf;
+
+	ata_tf_init(dev, &tf);
+
+	tf.command = ATA_CMD_READ_NATIVE_MAX;
+	tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+	tf.protocol |= ATA_PROT_NODATA;
+	tf.device = 0x40;
+
+	err = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
+	if (err)
+		return 0;
+
+	return ata_tf_to_lba(&tf);
+}
+
+/**
+ *	ata_set_native_max_address_ext	-	LBA48 native max set
+ *	@dev: Device to query
+ *
+ *	Perform an LBA48 size set max upon the device in question. Return the
+ *	actual LBA48 size or zero if the command fails.
+ */
+
+static u64 ata_set_native_max_address_ext(struct ata_device *dev, u64 new_sectors)
+{
+	unsigned int err;
+	struct ata_taskfile tf;
+
+	new_sectors--;
+
+	ata_tf_init(dev, &tf);
+
+	tf.command = ATA_CMD_SET_MAX_EXT;
+	tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48 | ATA_TFLAG_ISADDR;
+	tf.protocol |= ATA_PROT_NODATA;
+	tf.device = 0x40;
+
+	tf.lbal = (new_sectors >> 0) & 0xff;
+	tf.lbam = (new_sectors >> 8) & 0xff;
+	tf.lbah = (new_sectors >> 16) & 0xff;
+
+	tf.hob_lbal = (new_sectors >> 24) & 0xff;
+	tf.hob_lbam = (new_sectors >> 32) & 0xff;
+	tf.hob_lbah = (new_sectors >> 40) & 0xff;
+
+	err = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
+	if (err)
+		return 0;
+
+	return ata_tf_to_lba48(&tf);
+}
+
+/**
+ *	ata_set_native_max_address	-	LBA28 native max set
+ *	@dev: Device to query
+ *
+ *	Perform an LBA28 size set max upon the device in question. Return the
+ *	actual LBA28 size or zero if the command fails.
+ */
+
+static u64 ata_set_native_max_address(struct ata_device *dev, u64 new_sectors)
+{
+	unsigned int err;
+	struct ata_taskfile tf;
+
+	new_sectors--;
+
+	ata_tf_init(dev, &tf);
+
+	tf.command = ATA_CMD_SET_MAX;
+	tf.flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+	tf.protocol |= ATA_PROT_NODATA;
+
+	tf.lbal = (new_sectors >> 0) & 0xff;
+	tf.lbam = (new_sectors >> 8) & 0xff;
+	tf.lbah = (new_sectors >> 16) & 0xff;
+	tf.device = ((new_sectors >> 24) & 0xff) | 0x40;
+
+	err = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
+	if (err)
+		return 0;
+
+	return ata_tf_to_lba(&tf);
+}
+
+/**
+ *	ata_hpa_resize		-	Resize a device with an HPA set
+ *	@dev: Device to resize
+ *
+ *	Read the size of an LBA28 or LBA48 disk with HPA features and resize
+ *	it if required to the full size of the media. The caller must check
+ *	the drive has the HPA feature set enabled.
+ */
+
+static u64 ata_hpa_resize(struct ata_device *dev)
+{
+	u64 sectors = dev->n_sectors;
+	u64 hpa_sectors;
+	
+	if (ata_id_has_lba48(dev->id))
+		hpa_sectors = ata_read_native_max_address_ext(dev);
+	else
+		hpa_sectors = ata_read_native_max_address(dev);
+
+	/* if no hpa, both should be equal */
+	ata_dev_printk(dev, KERN_INFO, "%s 1: sectors = %lld, hpa_sectors = %lld\n",
+		__FUNCTION__, sectors, hpa_sectors);
+
+	if (hpa_sectors > sectors) {
+		ata_dev_printk(dev, KERN_INFO,
+			"Host Protected Area detected:\n"
+			"\tcurrent size: %lld sectors\n"
+			"\tnative size: %lld sectors\n",
+			sectors, hpa_sectors);
+
+		if (ata_ignore_hpa) {
+			if (ata_id_has_lba48(dev->id))
+				hpa_sectors = ata_set_native_max_address_ext(dev, hpa_sectors);
+			else
+				hpa_sectors = ata_set_native_max_address(dev, hpa_sectors);
+
+			if (hpa_sectors) {
+				ata_dev_printk(dev, KERN_INFO,
+					"native size increased to %lld sectors\n", hpa_sectors);
+				return hpa_sectors;
+			}
+		}
+	}
+	return sectors;
+}
+
 static u64 ata_id_n_sectors(const u16 *id)
 {
 	if (ata_id_has_lba(id)) {
@@ -1658,6 +1858,7 @@
 			snprintf(revbuf, 7, "ATA-%d",  ata_id_major_version(id));
 
 		dev->n_sectors = ata_id_n_sectors(id);
+		dev->n_sectors_boot = dev->n_sectors;
 
 		/* SCSI only uses 4-char revisions, dump full 8 chars from ATA */
 		ata_id_c_string(dev->id, fwrevbuf, ATA_ID_FW_REV,
@@ -1684,6 +1885,9 @@
 					dev->flags |= ATA_DFLAG_FLUSH_EXT;
 			}
 
+			if (ata_id_hpa_enabled(dev->id))
+				dev->n_sectors = ata_hpa_resize(dev);
+
 			/* config NCQ */
 			ata_dev_config_ncq(dev, ncq_desc, sizeof(ncq_desc));
 
@@ -3384,6 +3595,11 @@
 			       "%llu != %llu\n",
 			       (unsigned long long)dev->n_sectors,
 			       (unsigned long long)new_n_sectors);
+		/* Are we the boot time size - if so we appear to be the
+		   same disk at this point and our HPA got reapplied */
+		if (ata_ignore_hpa && dev->n_sectors_boot == new_n_sectors 
+		    && ata_id_hpa_enabled(new_id))
+			return 1;
 		return 0;
 	}
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc4-mm1/include/linux/ata.h linux-2.6.21-rc4-mm1/include/linux/ata.h
--- linux.vanilla-2.6.21-rc4-mm1/include/linux/ata.h	2007-03-23 11:49:09.000000000 +0000
+++ linux-2.6.21-rc4-mm1/include/linux/ata.h	2007-03-23 12:53:43.000000000 +0000
@@ -158,6 +158,8 @@
 	ATA_CMD_INIT_DEV_PARAMS	= 0x91,
 	ATA_CMD_READ_NATIVE_MAX	= 0xF8,
 	ATA_CMD_READ_NATIVE_MAX_EXT = 0x27,
+	ATA_CMD_SET_MAX		= 0xF9,
+	ATA_CMD_SET_MAX_EXT	= 0x37,
 	ATA_CMD_READ_LOG_EXT	= 0x2f,
 
 	/* READ_LOG_EXT pages */
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc4-mm1/include/linux/libata.h linux-2.6.21-rc4-mm1/include/linux/libata.h
--- linux.vanilla-2.6.21-rc4-mm1/include/linux/libata.h	2007-03-23 11:49:51.000000000 +0000
+++ linux-2.6.21-rc4-mm1/include/linux/libata.h	2007-03-23 13:01:27.000000000 +0000
@@ -461,6 +461,7 @@
 	struct scsi_device	*sdev;		/* attached SCSI device */
 	/* n_sector is used as CLEAR_OFFSET, read comment above CLEAR_OFFSET */
 	u64			n_sectors;	/* size of device, if ATA */
+	u64			n_sectors_boot;	/* size of ATA device at startup */
 	unsigned int		class;		/* ATA_DEV_xxx */
 	u16			id[ATA_ID_WORDS]; /* IDENTIFY xxx DEVICE data */
 	u8			pio_mode;
