Return-Path: <linux-kernel-owner+w=401wt.eu-S966638AbXEHK7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966638AbXEHK7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 06:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966461AbXEHK7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 06:59:43 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:33896 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966426AbXEHK7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 06:59:42 -0400
Subject: [PATCH] Cleanup libata HPA support
From: Ben Collins <ben.collins@ubuntu.com>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, Kyle McMartin <kyle@ubuntu.com>,
       linux-ide@vger.kernel.org
Content-Type: text/plain
Organization: Canonical
Date: Tue, 08 May 2007 12:59:38 +0200
Message-Id: <1178621978.6962.75.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The original HPA patch that Kyle worked on has gone into current git
without some fixes that we worked through late in the Ubuntu feisty
release. Here's the main copy of the notes I sent to Alan a few weeks
ago in regards to the original patch, and a repatch against current git
to fix things up. Note we have released feisty with the patch attached
(albeit we have HPA enabled by default), and we have not had any reports
directly attributed to it. However, in gutsy (devel for next release,
based on current stock linux-2.6.git), we are already seeing reports of
the same issues we already fixed. 

The issues we saw were mainly that some controllers didn't return the
correct size from the SET_MAX command (sata_nv is a good example). So I
added a re IDENTIFY after the SET_MAX, and compared all the numbers. If
re-id was correct, but return value from SET_MAX wasn't we print a
warning and use the IDENTIFY value regardless (since that's what the
device is going to use).

Because we re IDENTIFY, there was also no need to keep n_sectors_boot
around, so that was removed. The ata_hpa_resize() was changed to handle
everything in a single call (checks for HPA support of the device, and
whether ignore_hpa is set or not), and it also sets dev->n_sectors
before returning.

So far with this patch, we were able to fix all the problems we were
seeing with it (except the sata_nv issue where we had to revert to not
using adma for NO_DATA transactions, already reported to libata-dev).
We've not had any reports of further problems.

Signed-off-by: Ben Collins <bcollins@ubuntu.com>
CC: Kyle McMartin <kyle@ubuntu.com>
CC: linux-ide@vger.kernel.org
CC: alan@lxorguk.ukuu.org.uk

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ca67484..253b969 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -814,16 +814,19 @@ void ata_id_c_string(const u16 *id, unsigned char *s,
 
 static u64 ata_tf_to_lba48(struct ata_taskfile *tf)
 {
-	u64 sectors = 0;
+	u64 sectors;
+	u32 high, low;
 
-	sectors |= ((u64)(tf->hob_lbah & 0xff)) << 40;
-	sectors |= ((u64)(tf->hob_lbam & 0xff)) << 32;
-	sectors |= (tf->hob_lbal & 0xff) << 24;
-	sectors |= (tf->lbah & 0xff) << 16;
-	sectors |= (tf->lbam & 0xff) << 8;
-	sectors |= (tf->lbal & 0xff);
+	high = (tf->hob_lbah << 16) |
+	       (tf->hob_lbam <<  8) |
+		tf->hob_lbal;
+	low  = (tf->lbah << 16) |
+	       (tf->lbam <<  8) |
+		tf->lbal;
 
-	return ++sectors;
+	sectors = ((u64)high << 24) | low;
+
+	return sectors + 1;
 }
 
 static u64 ata_tf_to_lba(struct ata_taskfile *tf)
@@ -963,52 +966,101 @@ static u64 ata_set_native_max_address(struct ata_device *dev, u64 new_sectors)
 }
 
 /**
+ *	ata_hpa_get_native_size	-	Get the native size of a disk
+ *	@dev: Device to get the size for
+ *
+ *	Read the size of an LBA28 or LBA48 disk with HPA features and
+ *	return the native size. Caller must check that the drive has HPA
+ *	feature set enabled.
+ */
+static u64 ata_hpa_get_native_size(struct ata_device *dev)
+{
+	if (ata_id_has_lba48(dev->id))
+		return ata_read_native_max_address_ext(dev);
+	else
+		return ata_read_native_max_address(dev);
+}
+
+
+static u64 ata_hpa_set_native_size(struct ata_device *dev, u64 new_sectors)
+{
+	if (ata_id_has_lba48(dev->id))
+		return ata_set_native_max_address_ext(dev, new_sectors);
+	else
+		return ata_set_native_max_address(dev, new_sectors);
+}
+
+static unsigned long long sectors_to_MB(unsigned long long n)
+{
+	n <<= 9;		/* make it bytes */
+	do_div(n, 1000000);	/* make it MB */
+	return n;
+}
+
+static u64 ata_id_n_sectors(const u16 *id);
+
+/**
  *	ata_hpa_resize		-	Resize a device with an HPA set
  *	@dev: Device to resize
  *
  *	Read the size of an LBA28 or LBA48 disk with HPA features and resize
- *	it if required to the full size of the media. The caller must check
- *	the drive has the HPA feature set enabled.
+ *	it if required to the full size of the media.
  */
 
-static u64 ata_hpa_resize(struct ata_device *dev)
+static void ata_hpa_resize(struct ata_device *dev)
 {
-	u64 sectors = dev->n_sectors;
 	u64 hpa_sectors;
-	
-	if (ata_id_has_lba48(dev->id))
-		hpa_sectors = ata_read_native_max_address_ext(dev);
-	else
-		hpa_sectors = ata_read_native_max_address(dev);
 
+	if (!ata_id_hpa_enabled(dev->id) || !ata_ignore_hpa)
+		return;
+
+	hpa_sectors = ata_hpa_get_native_size(dev);
+	
 	/* if no hpa, both should be equal */
-	ata_dev_printk(dev, KERN_INFO, "%s 1: sectors = %lld, "
-				"hpa_sectors = %lld\n",
-		__FUNCTION__, (long long)sectors, (long long)hpa_sectors);
+	ata_dev_printk(dev, KERN_INFO, "%s 1: sectors = %lld, hpa_sectors = %lld\n",
+		__FUNCTION__, dev->n_sectors, hpa_sectors);
+
+	if (hpa_sectors > dev->n_sectors) {
+		u64 ret_sectors;
 
-	if (hpa_sectors > sectors) {
 		ata_dev_printk(dev, KERN_INFO,
-			"Host Protected Area detected:\n"
-			"\tcurrent size: %lld sectors\n"
-			"\tnative size: %lld sectors\n",
-			(long long)sectors, (long long)hpa_sectors);
-
-		if (ata_ignore_hpa) {
-			if (ata_id_has_lba48(dev->id))
-				hpa_sectors = ata_set_native_max_address_ext(dev, hpa_sectors);
-			else
-				hpa_sectors = ata_set_native_max_address(dev,
-								hpa_sectors);
-
-			if (hpa_sectors) {
-				ata_dev_printk(dev, KERN_INFO, "native size "
-					"increased to %lld sectors\n",
-					(long long)hpa_sectors);
-				return hpa_sectors;
+			"Host Protected Area detected.\n"
+			"     current size : %llu sectors (%llu MB)\n"
+			"     native  size : %llu sectors (%llu MB)\n",
+			dev->n_sectors, sectors_to_MB(dev->n_sectors),
+			hpa_sectors, sectors_to_MB(hpa_sectors));
+
+		ret_sectors = ata_hpa_set_native_size(dev, hpa_sectors);
+		if (ret_sectors != hpa_sectors) {
+			ata_dev_printk(dev, KERN_ERR,
+				"SET of native returned %llu, expected %llu\n",
+				ret_sectors, hpa_sectors);
+		}
+
+		if (ret_sectors) {
+			u16 *id = (void *)dev->ap->sector_buf;
+			int rc;
+
+			/* Re read the IDENTITY to see if the set took */
+			rc = ata_dev_read_id(dev, &dev->class,
+					     ATA_READID_POSTRESET, id);
+
+			dev->n_sectors = ata_id_n_sectors(id);
+
+			if (dev->n_sectors == hpa_sectors) {
+				ata_dev_printk(dev, KERN_INFO,
+					"Native size increased to %llu sectors\n",
+					hpa_sectors);
+				memcpy(dev->id, id, sizeof(id[0]) * ATA_ID_WORDS);
+			} else {
+				ata_dev_printk(dev, KERN_ERR,
+					"Failed to set native size, "
+					"drive reports %llu sectors\n",
+					dev->n_sectors);
 			}
 		}
 	}
-	return sectors;
+	return;
 }
 
 static u64 ata_id_n_sectors(const u16 *id)
@@ -1891,7 +1943,6 @@ int ata_dev_configure(struct ata_device *dev)
 			snprintf(revbuf, 7, "ATA-%d",  ata_id_major_version(id));
 
 		dev->n_sectors = ata_id_n_sectors(id);
-		dev->n_sectors_boot = dev->n_sectors;
 
 		/* SCSI only uses 4-char revisions, dump full 8 chars from ATA */
 		ata_id_c_string(dev->id, fwrevbuf, ATA_ID_FW_REV,
@@ -1918,8 +1969,8 @@ int ata_dev_configure(struct ata_device *dev)
 					dev->flags |= ATA_DFLAG_FLUSH_EXT;
 			}
 
-			if (ata_id_hpa_enabled(dev->id))
-				dev->n_sectors = ata_hpa_resize(dev);
+			/* Check for HPA, and resize if requested */
+			ata_hpa_resize(dev);
 
 			/* config NCQ */
 			ata_dev_config_ncq(dev, ncq_desc, sizeof(ncq_desc));
@@ -3585,11 +3636,6 @@ static int ata_dev_same_device(struct ata_device *dev, unsigned int new_class,
 			       "%llu != %llu\n",
 			       (unsigned long long)dev->n_sectors,
 			       (unsigned long long)new_n_sectors);
-		/* Are we the boot time size - if so we appear to be the
-		   same disk at this point and our HPA got reapplied */
-		if (ata_ignore_hpa && dev->n_sectors_boot == new_n_sectors 
-		    && ata_id_hpa_enabled(new_id))
-			return 1;
 		return 0;
 	}
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index d8cfc72..3cffbf6 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -448,7 +448,6 @@ struct ata_device {
 	struct scsi_device	*sdev;		/* attached SCSI device */
 	/* n_sector is used as CLEAR_OFFSET, read comment above CLEAR_OFFSET */
 	u64			n_sectors;	/* size of device, if ATA */
-	u64			n_sectors_boot;	/* size of ATA device at startup */
 	unsigned int		class;		/* ATA_DEV_xxx */
 	u16			id[ATA_ID_WORDS]; /* IDENTIFY xxx DEVICE data */
 	u8			pio_mode;


-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

