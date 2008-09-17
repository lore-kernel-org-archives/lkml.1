Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbYIQIQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbYIQIQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYIQIQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:16:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52339 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbYIQIQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:16:13 -0400
Message-ID: <48D0BA0A.1070709@redhat.com>
Date: Wed, 17 Sep 2008 10:04:26 +0200
From: Chris Lalancette <clalance@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH RESEND]: Expand Xen blkfront for > 16 xvd
Content-Type: multipart/mixed;
 boundary="------------040603060701010301030801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040603060701010301030801
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Until recently, the maximum number of xvd block devices you could attach to
a Xen domU was 16.  This limitation turned out to be problematic for some users,
so it was expanded to handle a much larger number of disks.  However, this
requires a couple of changes in the way that blkfront scans for disks.  This
functionality is already present in the Xen linux-2.6.18-xen.hg tree; the
attached patch adds this functionality to the mainline xen-blkfront
implementation.  I successfully tested it on a 2.6.25 tree, and build tested it
on 2.6.27-rc3.

Signed-off-by: Chris Lalancette <clalance@redhat.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>

--------------040603060701010301030801
Content-Type: text/x-patch;
 name="lkml-blkfront-expand-xvd.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lkml-blkfront-expand-xvd.patch"

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 3ca643c..bff602c 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -105,15 +105,17 @@ static DEFINE_SPINLOCK(blkif_io_lock);
 #define GRANT_INVALID_REF	0
 
 #define PARTS_PER_DISK		16
+#define PARTS_PER_EXT_DISK      256
 
 #define BLKIF_MAJOR(dev) ((dev)>>8)
 #define BLKIF_MINOR(dev) ((dev) & 0xff)
 
-#define DEV_NAME	"xvd"	/* name in /dev */
+#define EXT_SHIFT 28
+#define EXTENDED (1<<EXT_SHIFT)
+#define VDEV_IS_EXTENDED(dev) ((dev)&(EXTENDED))
+#define BLKIF_MINOR_EXT(dev) ((dev)&(~EXTENDED))
 
-/* Information about our VBDs. */
-#define MAX_VBDS 64
-static LIST_HEAD(vbds_list);
+#define DEV_NAME	"xvd"	/* name in /dev */
 
 static int get_id_from_freelist(struct blkfront_info *info)
 {
@@ -386,31 +388,60 @@ static int xlvbd_barrier(struct blkfront_info *info)
 }
 
 
-static int xlvbd_alloc_gendisk(int minor, blkif_sector_t capacity,
-			       int vdevice, u16 vdisk_info, u16 sector_size,
-			       struct blkfront_info *info)
+static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
+			       struct blkfront_info *info,
+			       u16 vdisk_info, u16 sector_size)
 {
 	struct gendisk *gd;
 	int nr_minors = 1;
 	int err = -ENODEV;
+	unsigned int offset;
+	int minor;
+	int nr_parts;
 
 	BUG_ON(info->gd != NULL);
 	BUG_ON(info->rq != NULL);
 
-	if ((minor % PARTS_PER_DISK) == 0)
-		nr_minors = PARTS_PER_DISK;
+	if ((info->vdevice>>EXT_SHIFT) > 1) {
+		/* this is above the extended range; something is wrong */
+		printk(KERN_WARNING "blkfront: vdevice 0x%x is above the extended range; ignoring\n", info->vdevice);
+		return -ENODEV;
+	}
+
+	if (!VDEV_IS_EXTENDED(info->vdevice)) {
+		minor = BLKIF_MINOR(info->vdevice);
+		nr_parts = PARTS_PER_DISK;
+	} else {
+		minor = BLKIF_MINOR_EXT(info->vdevice);
+		nr_parts = PARTS_PER_EXT_DISK;
+	}
+
+	if ((minor % nr_parts) == 0)
+		nr_minors = nr_parts;
 
 	gd = alloc_disk(nr_minors);
 	if (gd == NULL)
 		goto out;
 
-	if (nr_minors > 1)
-		sprintf(gd->disk_name, "%s%c", DEV_NAME,
-			'a' + minor / PARTS_PER_DISK);
-	else
-		sprintf(gd->disk_name, "%s%c%d", DEV_NAME,
-			'a' + minor / PARTS_PER_DISK,
-			minor % PARTS_PER_DISK);
+	offset = minor / nr_parts;
+
+	if (nr_minors > 1) {
+		if (offset < 26)
+			sprintf(gd->disk_name, "%s%c", DEV_NAME, 'a' + offset);
+		else
+			sprintf(gd->disk_name, "%s%c%c", DEV_NAME,
+				'a' + ((offset / 26)-1), 'a' + (offset % 26));
+	} else {
+		if (offset < 26)
+			sprintf(gd->disk_name, "%s%c%d", DEV_NAME,
+				'a' + offset,
+				minor & (nr_parts - 1));
+		else
+			sprintf(gd->disk_name, "%s%c%c%d", DEV_NAME,
+				'a' + ((offset / 26) - 1),
+				'a' + (offset % 26),
+				minor & (nr_parts - 1));
+	}
 
 	gd->major = XENVBD_MAJOR;
 	gd->first_minor = minor;
@@ -699,8 +730,13 @@ static int blkfront_probe(struct xenbus_device *dev,
 	err = xenbus_scanf(XBT_NIL, dev->nodename,
 			   "virtual-device", "%i", &vdevice);
 	if (err != 1) {
-		xenbus_dev_fatal(dev, err, "reading virtual-device");
-		return err;
+		/* go looking in the extended area instead */
+		err = xenbus_scanf(XBT_NIL, dev->nodename, "virtual-device-ext",
+				   "%i", &vdevice);
+		if (err != 1) {
+			xenbus_dev_fatal(dev, err, "reading virtual-device");
+			return err;
+		}
 	}
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
@@ -861,9 +897,7 @@ static void blkfront_connect(struct blkfront_info *info)
 	if (err)
 		info->feature_barrier = 0;
 
-	err = xlvbd_alloc_gendisk(BLKIF_MINOR(info->vdevice),
-				  sectors, info->vdevice,
-				  binfo, sector_size, info);
+	err = xlvbd_alloc_gendisk(sectors, info, binfo, sector_size);
 	if (err) {
 		xenbus_dev_fatal(info->xbdev, err, "xlvbd_add at %s",
 				 info->xbdev->otherend);

--------------040603060701010301030801--
