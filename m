Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbYDNNER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbYDNNER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbYDNNEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:04:06 -0400
Received: from mr1.bfh.ch ([147.87.250.50]:55528 "EHLO mr1.bfh.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbYDNNEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:04:04 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2008 09:04:04 EDT
Message-ID: <480354C9.1050600@bfh.ch>
Date: Mon, 14 Apr 2008 14:57:45 +0200
From: Seewer Philippe <philippe.seewer@bfh.ch>
Organization: BFH
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Disk geometry from /sys
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
In-Reply-To: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Apr 2008 12:57:44.0996 (UTC) FILETIME=[21EE0E40:01C89E2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Francis, 

Francis Moreau wrote:
> Hi,
> 
> I'm trying to know the geometry of my hard disk from a bash script
> and that's the reason I'm looking in /sys. The reason is that I'd like
> to figure out the size of a cylinder without doing a
> ioctl(bdev, HDIO_GETGEO, &geo)
> 
> Unfortunately I can't find anything useful and this is certainly a sign
> that I'm doing something wrong.
> 
> Or maybe can I simply assume from my script that the geometry
> is always heads=255 and the number of sectors per track is 63 for all
> disks.
> 
> Looking at parted(8) source code, I  can find this:
> 
> /* The GETGEO ioctl is no longer useful (as of linux 2.6.x).  We could
>  * still use it in 2.4.x, but this is contentious.  Perhaps we should
>  * move to EDD. */
> 
> Could anybody give me some advices ?

As you've problably seen from the other answers, disk geometry is (except for a few older devices) unneeded inside the Linux kernel. I'd say thats the reason why there's no sysfs export and I'd further guess disk geometry is an artifact most would like to get rid of (or pushed into userspace).

Anyway, if you really need it, try the patch below. Should apply cleanly to version 2.6.23.1 and gives you a geometry/ directory for each block device providing the getgeo function. It adds a setgeo counterpart for some subsystems as well, allowing 'echo something > ...' so please be careful.

---
diff -uprN -X linux-2.6.23.1-vanilla/Documentation/dontdiff linux-2.6.23.1-vanilla/block/Makefile linux-2.6.23.1/block/Makefile
--- linux-2.6.23.1-vanilla/block/Makefile	2007-10-12 18:43:44.000000000 +0200
+++ linux-2.6.23.1/block/Makefile	2007-10-19 11:51:54.000000000 +0200
@@ -2,7 +2,7 @@
 # Makefile for the kernel block layer
 #
 
-obj-$(CONFIG_BLOCK) := elevator.o ll_rw_blk.o ioctl.o genhd.o scsi_ioctl.o
+obj-$(CONFIG_BLOCK) := elevator.o ll_rw_blk.o ioctl.o genhd.o gengeo.o scsi_ioctl.o
 
 obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
 obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
diff -uprN -X linux-2.6.23.1-vanilla/Documentation/dontdiff linux-2.6.23.1-vanilla/block/gengeo.c linux-2.6.23.1/block/gengeo.c
--- linux-2.6.23.1-vanilla/block/gengeo.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.23.1/block/gengeo.c	2007-10-19 11:51:54.000000000 +0200
@@ -0,0 +1,153 @@
+/**
+ *  generic geometry handling. utility for gendisk.c
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/genhd.h>
+#include <linux/kernel.h>
+#include <linux/blkdev.h>
+#include <linux/kmod.h>
+#include <linux/hdreg.h>
+
+/*
+ * General show method invoked by attribute->show.
+ *
+ * Gets the "real" block device, invokes getgeo and delegates output
+ * to the corresponding format function.
+ */
+static ssize_t disk_geom_attr_show(struct gendisk *disk, char *buf,
+				   ssize_t(*format) (const struct hd_geometry *
+						     geo, char *buf))
+{
+	ssize_t ret = -EIO;
+
+	struct hd_geometry geo;
+	struct block_device *bdev = bdget_disk(disk, 0);
+	blkdev_get(bdev, FMODE_READ, 0);
+
+	if (bdev) {
+		geo.start = get_start_sect(bdev);
+		disk->fops->getgeo(bdev, &geo);
+		ret = (*format) (&geo, buf);
+	} else {
+		ret = -ENODEV;
+	}
+	return ret;
+}
+
+/*
+ * General store method invoked by attribute->store.
+ *
+ * Gets the "real" block device, invokes getgeo, delegates input to
+ * the corresponding set function and invokes setgeo.
+ */
+static ssize_t disk_geom_attr_store(struct gendisk *disk, const char *buf,
+				    size_t count,
+				    int (*set) (struct hd_geometry * geo,
+						unsigned long value))
+{
+	ssize_t ret = 0;
+	char *endp;
+	unsigned long value;
+	struct hd_geometry geo;
+	struct block_device *bdev = bdget_disk(disk, 0);
+	blkdev_get(bdev, FMODE_READ, 0);
+
+	value = simple_strtoul(buf, &endp, 0);
+	if (endp == buf)
+		return -EINVAL;
+
+	if (bdev) {
+		geo.start = get_start_sect(bdev);
+		disk->fops->getgeo(bdev, &geo);
+		if ((ret = (*set) (&geo, value)) == 0) {
+			disk->fops->setgeo(bdev, &geo);
+			ret = count;
+		}
+	} else {
+		ret = -ENODEV;
+	}
+	return ret;
+}
+
+/* Generate a show function for field */
+#define DISKGEOM_SHOW(field, format_string) \
+static ssize_t disk_geom_format_##field(const struct hd_geometry *geo, char *buf) \
+{ \
+  return sprintf(buf, format_string, geo->field); \
+} \
+static ssize_t disk_geom_show_##field(struct gendisk * disk, char *buf) \
+{ \
+  return disk_geom_attr_show(disk, buf, disk_geom_format_##field); \
+} \
+static struct disk_attribute disk_geom_attr_ro_##field = __ATTR(field, S_IRUGO, disk_geom_show_##field, NULL);
+
+/* Generate a store function for field */
+#define DISKGEOM_STORE(field, max) \
+static int disk_geom_set_##field(struct hd_geometry *geo, unsigned long value) \
+{ \
+  if (value > max) \
+    return -EINVAL; \
+  geo->field = value; \
+  return 0; \
+} \
+static ssize_t disk_geom_store_##field(struct gendisk *disk, const char *buf, size_t count) \
+{ \
+  return disk_geom_attr_store(disk, buf, count, disk_geom_set_##field); \
+} \
+static struct disk_attribute disk_geom_attr_rw_##field = __ATTR(field, S_IRUGO | S_IWUSR, disk_geom_show_##field, disk_geom_store_##field);
+
+DISKGEOM_SHOW(heads, "%d\n");
+DISKGEOM_SHOW(sectors, "%d\n");
+DISKGEOM_SHOW(cylinders, "%d\n");
+DISKGEOM_SHOW(start, "%ld\n");
+
+DISKGEOM_STORE(heads, 255);
+DISKGEOM_STORE(sectors, 63);
+DISKGEOM_STORE(cylinders, 65535);
+
+static struct attribute *disk_geom_attrs_ro[] = {
+	&disk_geom_attr_ro_heads.attr,
+	&disk_geom_attr_ro_sectors.attr,
+	&disk_geom_attr_ro_cylinders.attr,
+	&disk_geom_attr_ro_start.attr,
+	NULL
+};
+
+static struct attribute *disk_geom_attrs_rw[] = {
+	&disk_geom_attr_rw_heads.attr,
+	&disk_geom_attr_rw_sectors.attr,
+	&disk_geom_attr_rw_cylinders.attr,
+	&disk_geom_attr_ro_start.attr,
+	NULL
+};
+
+static struct attribute_group disk_geom_ro_attrgroup = {
+	.name = "geometry",
+	.attrs = disk_geom_attrs_ro,
+};
+
+static struct attribute_group disk_geom_rw_attrgroup = {
+	.name = "geometry",
+	.attrs = disk_geom_attrs_rw,
+};
+
+/* function called from add_disk in genhd */
+int add_geometry(struct gendisk *disk)
+{
+	if (disk->fops->setgeo) {
+		return sysfs_create_group(&disk->kobj, &disk_geom_rw_attrgroup);
+	} else {
+		return sysfs_create_group(&disk->kobj, &disk_geom_ro_attrgroup);
+	}
+}
+
+/* function called from disk_release in genhd */
+void remove_geometry(struct gendisk *disk)
+{
+	if (disk->fops->setgeo)
+		sysfs_remove_group(&disk->kobj, &disk_geom_rw_attrgroup);
+	else
+		sysfs_remove_group(&disk->kobj, &disk_geom_ro_attrgroup);
+}
diff -uprN -X linux-2.6.23.1-vanilla/Documentation/dontdiff linux-2.6.23.1-vanilla/block/genhd.c linux-2.6.23.1/block/genhd.c
--- linux-2.6.23.1-vanilla/block/genhd.c	2007-10-12 18:43:44.000000000 +0200
+++ linux-2.6.23.1/block/genhd.c	2007-10-19 11:51:54.000000000 +0200
@@ -168,6 +168,10 @@ static int exact_lock(dev_t dev, void *d
 	return 0;
 }
 
+/* Extern in gengeo.c */
+extern int add_geometry(struct gendisk *disk);
+extern void remove_geometry(struct gendisk *disk);
+
 /**
  * add_disk - add partitioning information to kernel list
  * @disk: per-device partitioning information
@@ -181,6 +185,8 @@ void add_disk(struct gendisk *disk)
 	blk_register_region(MKDEV(disk->major, disk->first_minor),
 			    disk->minors, NULL, exact_match, exact_lock, disk);
 	register_disk(disk);
+	if (disk->fops->getgeo)
+	        add_geometry(disk);
 	blk_register_queue(disk);
 }
 
@@ -521,6 +527,7 @@ static void disk_release(struct kobject 
 	struct gendisk *disk = to_disk(kobj);
 	kfree(disk->random);
 	kfree(disk->part);
+	remove_geometry(disk);
 	free_disk_stats(disk);
 	kfree(disk);
 }
diff -uprN -X linux-2.6.23.1-vanilla/Documentation/dontdiff linux-2.6.23.1-vanilla/drivers/ide/ide-disk.c linux-2.6.23.1/drivers/ide/ide-disk.c
--- linux-2.6.23.1-vanilla/drivers/ide/ide-disk.c	2007-10-12 18:43:44.000000000 +0200
+++ linux-2.6.23.1/drivers/ide/ide-disk.c	2007-10-19 11:51:54.000000000 +0200
@@ -1183,6 +1183,17 @@ static int idedisk_getgeo(struct block_d
 	return 0;
 }
 
+static int idedisk_setgeo(struct block_device *bdev, struct hd_geometry *geo)
+{
+	struct ide_disk_obj *idkp = ide_disk_g(bdev->bd_disk);
+	ide_drive_t *drive = idkp->drive;
+
+	drive->bios_head = geo->heads;
+	drive->bios_sect = geo->sectors;
+	drive->bios_cyl  = geo->cylinders;
+	return 0;
+}
+
 static int idedisk_ioctl(struct inode *inode, struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
@@ -1258,6 +1269,7 @@ static struct block_device_operations id
 	.release	= idedisk_release,
 	.ioctl		= idedisk_ioctl,
 	.getgeo		= idedisk_getgeo,
+	.setgeo		= idedisk_setgeo,
 	.media_changed	= idedisk_media_changed,
 	.revalidate_disk= idedisk_revalidate_disk
 };
diff -uprN -X linux-2.6.23.1-vanilla/Documentation/dontdiff linux-2.6.23.1-vanilla/drivers/scsi/sd.c linux-2.6.23.1/drivers/scsi/sd.c
--- linux-2.6.23.1-vanilla/drivers/scsi/sd.c	2007-10-12 18:43:44.000000000 +0200
+++ linux-2.6.23.1/drivers/scsi/sd.c	2007-10-19 11:51:54.000000000 +0200
@@ -620,20 +620,38 @@ static int sd_getgeo(struct block_device
 	struct Scsi_Host *host = sdp->host;
 	int diskinfo[4];
 
-	/* default to most commonly used values */
-        diskinfo[0] = 0x40;	/* 1 << 6 */
-       	diskinfo[1] = 0x20;	/* 1 << 5 */
-       	diskinfo[2] = sdkp->capacity >> 11;
-	
-	/* override with calculated, extended default, or driver values */
-	if (host->hostt->bios_param)
-		host->hostt->bios_param(sdp, bdev, sdkp->capacity, diskinfo);
-	else
-		scsicam_bios_param(bdev, sdkp->capacity, diskinfo);
+	if (sdkp->heads && sdkp->sectors && sdkp->cylinders) {
+		geo->heads     = sdkp->heads;
+		geo->sectors   = sdkp->sectors;
+		geo->cylinders = sdkp->cylinders;
+	} else {
+		/* default to most commonly used values */
+		diskinfo[0] = 0x40;	/* 1 << 6 */
+		diskinfo[1] = 0x20;	/* 1 << 5 */
+		diskinfo[2] = sdkp->capacity >> 11;
+
+		/* override with calculated, extended default, or driver values */
+		if (host->hostt->bios_param)
+			host->hostt->bios_param(sdp, bdev, sdkp->capacity,
+						diskinfo);
+		else
+			scsicam_bios_param(bdev, sdkp->capacity, diskinfo);
+
+		geo->heads = diskinfo[0];
+		geo->sectors = diskinfo[1];
+		geo->cylinders = diskinfo[2];
+	}
+	return 0;
+}
+
+static int sd_setgeo(struct block_device *bdev, struct hd_geometry *geo)
+{
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+
+	sdkp->heads     = geo->heads;
+	sdkp->sectors   = geo->sectors;
+	sdkp->cylinders = geo->cylinders;
 
-	geo->heads = diskinfo[0];
-	geo->sectors = diskinfo[1];
-	geo->cylinders = diskinfo[2];
 	return 0;
 }
 
@@ -881,6 +899,7 @@ static struct block_device_operations sd
 	.release		= sd_release,
 	.ioctl			= sd_ioctl,
 	.getgeo			= sd_getgeo,
+	.setgeo			= sd_setgeo,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= sd_compat_ioctl,
 #endif
diff -uprN -X linux-2.6.23.1-vanilla/Documentation/dontdiff linux-2.6.23.1-vanilla/include/linux/fs.h linux-2.6.23.1/include/linux/fs.h
--- linux-2.6.23.1-vanilla/include/linux/fs.h	2007-10-12 18:43:44.000000000 +0200
+++ linux-2.6.23.1/include/linux/fs.h	2007-10-19 11:51:54.000000000 +0200
@@ -1067,6 +1067,7 @@ struct block_device_operations {
 	int (*media_changed) (struct gendisk *);
 	int (*revalidate_disk) (struct gendisk *);
 	int (*getgeo)(struct block_device *, struct hd_geometry *);
+	int (*setgeo)(struct block_device *, struct hd_geometry *);
 	struct module *owner;
 };
 
diff -uprN -X linux-2.6.23.1-vanilla/Documentation/dontdiff linux-2.6.23.1-vanilla/include/scsi/sd.h linux-2.6.23.1/include/scsi/sd.h
--- linux-2.6.23.1-vanilla/include/scsi/sd.h	2007-10-12 18:43:44.000000000 +0200
+++ linux-2.6.23.1/include/scsi/sd.h	2007-10-19 12:01:58.000000000 +0200
@@ -44,6 +44,12 @@ struct scsi_disk {
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
+
+
+	/* Disk geometry for overwrite */
+	unsigned char   heads;
+	unsigned char   sectors;
+	unsigned short  cylinders;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,cdev)
 
