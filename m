Return-Path: <linux-kernel-owner+w=401wt.eu-S1762605AbXERQGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762605AbXERQGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 12:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbXERQGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 12:06:38 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:50083 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbXERQGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 12:06:36 -0400
Subject: Re: [PATCH/REDIFF] Cleanup libata HPA support
From: Ben Collins <ben.collins@ubuntu.com>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, Kyle McMartin <kyle@ubuntu.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
In-Reply-To: <1179500783.6510.226.camel@cunning>
References: <1179500783.6510.226.camel@cunning>
Content-Type: text/plain
Organization: Canonical
Date: Fri, 18 May 2007 12:06:43 -0400
Message-Id: <1179504403.6510.235.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 11:06 -0400, Ben Collins wrote:
> (Rediffed against latest git)

Added error check for ata_dev_read_id (Thanks tj)

Also, since hpa is disabled by default, print the native size, even when
HPA isn't asked for (so users and developers can know that it may need
to be used).

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d3ea7f5..3c8eb77 100644
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
@@ -965,52 +968,107 @@ static u64 ata_set_native_max_address(struct ata_device *dev, u64 new_sectors)
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
+static int ata_hpa_resize(struct ata_device *dev)
 {
-	u64 sectors = dev->n_sectors;
 	u64 hpa_sectors;
+
+	if (!ata_id_hpa_enabled(dev->id))
+		return 0;
+
+	hpa_sectors = ata_hpa_get_native_size(dev);
 	
-	if (ata_id_has_lba48(dev->id))
-		hpa_sectors = ata_read_native_max_address_ext(dev);
-	else
-		hpa_sectors = ata_read_native_max_address(dev);
+	ata_dev_printk(dev, KERN_INFO, "%s: sectors = %lld, hpa_sectors = %lld\n",
+		__FUNCTION__, dev->n_sectors, hpa_sectors);
 
-	/* if no hpa, both should be equal */
-	ata_dev_printk(dev, KERN_INFO, "%s 1: sectors = %lld, "
-				"hpa_sectors = %lld\n",
-		__FUNCTION__, (long long)sectors, (long long)hpa_sectors);
+	if (ata_ignore_hpa && hpa_sectors > dev->n_sectors) {
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
+			if (rc) {
+				ata_dev_printk(dev, KERN_ERR,
+					"Failed to reread ID after SET_MAX (%d)\n",
+					rc);
+				return -EIO;
+			}
+
+			memcpy(dev->id, id, sizeof(id[0]) * ATA_ID_WORDS);
+			dev->n_sectors = ata_id_n_sectors(dev->id);
+
+			if (dev->n_sectors == hpa_sectors) {
+				ata_dev_printk(dev, KERN_INFO,
+					"Native size increased to %llu sectors\n",
+					hpa_sectors);
+			} else {
+				ata_dev_printk(dev, KERN_ERR,
+					"Failed to set native size, "
+					"drive reports %llu sectors\n",
+					dev->n_sectors);
 			}
 		}
 	}
-	return sectors;
+	return 0;
 }
 
 static u64 ata_id_n_sectors(const u16 *id)
@@ -1939,8 +1997,10 @@ int ata_dev_configure(struct ata_device *dev)
 					dev->flags |= ATA_DFLAG_FLUSH_EXT;
 			}
 
-			if (ata_id_hpa_enabled(dev->id))
-				dev->n_sectors = ata_hpa_resize(dev);
+			/* Check for HPA, and resize if requested */
+			rc = ata_hpa_resize(dev);
+			if (rc)
+				goto err_out_nosup;
 
 			/* config NCQ */
 			ata_dev_config_ncq(dev, ncq_desc, sizeof(ncq_desc));


-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

