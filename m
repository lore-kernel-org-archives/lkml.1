Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYH0MaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYH0MaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 08:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbYH0MaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 08:30:06 -0400
Received: from mx1.suse.de ([195.135.220.2]:49435 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbYH0MaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 08:30:04 -0400
Message-ID: <48B548CA.8040503@suse.de>
Date: Wed, 27 Aug 2008 14:30:02 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Disable partition scan
References: <48B52D0B.2090104@suse.de>
In-Reply-To: <48B52D0B.2090104@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------090205060400010001050901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090205060400010001050901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi all again,

Hannes Reinecke wrote:
> Hi all,
> 
> for some setups (eg dmraid or multipathing) the in-kernel partition scan
> is pointless; the (block) partitions won't be used anywhere. Instead the
> system will be using kpartx-generated device-mapper devices.
> Worse, on some setups (RAID0 dmraid or active/passive multipath devices)
> the in-kernel partition scan will generate plenty of I/O errors as the
> partitions table might not be accessible or invalid for this device.
> 
> This patch implements a new kernel command-line option 'no_partition_scan'
> which will switch off the partition scan globally. The partition scan can
> be re-enabled for individual devices by echoing any positive number smaller
> than the number of minors into
> /sys/class/block/XXX/range
> 
> and rescanning the device.
> 
> Please apply.
> 
Yeah, cool. One should take care not to mangle to patches.
Should teach me to use git properly. Oh well.

Corrected patch attached.

Cheers,

Hannes

-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------090205060400010001050901
Content-Type: text/plain;
 name="no-partition-scan"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="no-partition-scan"

Disable partition scan

For some setups (multipath or dmraid) the in-kernel partition scan
is pointless as the (block) partitions won't be used anywhere.
Worse, it might trigger I/O errors as the partition table might not
be accessible (eg for the passive path of a multipath device) or
even invalid (eg for RAID0 dmraid).
This patch allows to switch off the in-kernel partition scan by adding
'no_partition_scan' to the kernel commandline. Partitions scan can be
allowed for individual disk by echoing a positive number into
/sys/block/XXX/range and rescan the disk.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/block/genhd.c b/block/genhd.c
index 656c2c7..3d6a53b 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -173,6 +173,18 @@ static int exact_lock(dev_t devt, void *data)
 	return 0;
 }
 
+static int __read_mostly no_partition_scan;
+
+static int __init no_partition_scan_setup(char *str)
+{
+	no_partition_scan = 1;
+	printk(KERN_INFO "genhd: omit partition scan.\n");
+
+	return 1;
+}
+
+__setup("no_partition_scan", no_partition_scan_setup);
+
 /**
  * add_disk - add partitioning information to kernel list
  * @disk: per-device partitioning information
@@ -186,6 +198,8 @@ void add_disk(struct gendisk *disk)
 	int retval;
 
 	disk->flags |= GENHD_FL_UP;
+	if (no_partition_scan)
+		disk->flags |= GENHD_FL_NO_PARTITION_SCAN;
 	blk_register_region(MKDEV(disk->major, disk->first_minor),
 			    disk->minors, NULL, exact_match, exact_lock, disk);
 	register_disk(disk);
@@ -419,7 +433,27 @@ static ssize_t disk_range_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n", disk->minors);
+	return sprintf(buf, "%d\n",
+		       (disk->flags & GENHD_FL_NO_PARTITION_SCAN ? 0 : disk->minors));
+}
+
+static ssize_t disk_range_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	int i;
+
+	if (count > 0 && sscanf(buf, "%d", &i) > 0) {
+		if (i == 0)
+			disk->flags |= GENHD_FL_NO_PARTITION_SCAN;
+		else if (i <= disk->minors)
+			disk->flags &= ~GENHD_FL_NO_PARTITION_SCAN;
+		else
+			count = -EINVAL;
+	}
+
+	return count;
 }
 
 static ssize_t disk_removable_show(struct device *dev,
@@ -509,7 +543,7 @@ static ssize_t disk_fail_store(struct device *dev,
 
 #endif
 
-static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
+static DEVICE_ATTR(range, S_IRUGO|S_IWUSR, disk_range_show, disk_range_store);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
 static DEVICE_ATTR(ro, S_IRUGO, disk_ro_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, disk_size_show, NULL);
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 7d6b34e..a73f6dc 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -485,6 +485,8 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 		delete_partition(disk, p);
 	if (disk->fops->revalidate_disk)
 		disk->fops->revalidate_disk(disk);
+	if (disk->flags & GENHD_FL_NO_PARTITION_SCAN)
+		return 0;
 	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
 		return 0;
 	if (IS_ERR(state))	/* I/O error reading the partition table */
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 118216f..87c45ad 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -109,6 +109,7 @@ struct hd_struct {
 #define GENHD_FL_UP				16
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	32
 #define GENHD_FL_FAIL				64
+#define GENHD_FL_NO_PARTITION_SCAN		128
 
 #define BLK_SCSI_MAX_CMDS	(256)
 #define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h

--------------090205060400010001050901--
