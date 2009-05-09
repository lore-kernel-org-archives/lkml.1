Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbZEIOn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbZEIOn6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbZEIOm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:42:56 -0400
Received: from kroah.org ([198.145.64.141]:54176 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbZEIOmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:42:55 -0400
X-Mailbox-Line: From greg@blue.kroah.org Sat May  9 07:36:33 2009
Message-Id: <20090509143632.640934233@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Sat, 09 May 2009 07:26:05 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>
Subject: [patch 04/13] Driver Core: block: add nodename support for block drivers.
References: <20090509142601.874865281@blue.kroah.org>
Content-Disposition: inline; filename=driver-core-block-add-nodename-support-for-block-drivers.patch
In-Reply-To: <20090509143742.GA27663@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds support for block drivers to report their requested nodename
to userspace.  It also updates a number of block drivers to provide the
needed subdirectory and device name to be used for them.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/genhd.c           |   10 ++++++++++
 drivers/block/pktcdvd.c |    7 +++++++
 include/linux/genhd.h   |    2 +-
 3 files changed, 18 insertions(+), 1 deletion(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -985,10 +985,20 @@ struct class block_class = {
 	.name		= "block",
 };
 
+static char *block_nodename(struct device *dev)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	if (disk->nodename)
+		return disk->nodename(disk);
+	return NULL;
+}
+
 static struct device_type disk_type = {
 	.name		= "disk",
 	.groups		= disk_attr_groups,
 	.release	= disk_release,
+	.nodename	= block_nodename,
 };
 
 #ifdef CONFIG_PROC_FS
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2853,6 +2853,11 @@ static struct block_device_operations pk
 	.media_changed =	pkt_media_changed,
 };
 
+static char *pktcdvd_nodename(struct gendisk *gd)
+{
+	return kasprintf(GFP_KERNEL, "pktcdvd/%s", gd->disk_name);
+}
+
 /*
  * Set up mapping from pktcdvd device to CD-ROM device.
  */
@@ -2905,6 +2910,7 @@ static int pkt_setup_dev(dev_t dev, dev_
 	disk->fops = &pktcdvd_ops;
 	disk->flags = GENHD_FL_REMOVABLE;
 	strcpy(disk->disk_name, pd->name);
+	disk->nodename = pktcdvd_nodename;
 	disk->private_data = pd;
 	disk->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!disk->queue)
@@ -3060,6 +3066,7 @@ static const struct file_operations pkt_
 static struct miscdevice pkt_misc = {
 	.minor 		= MISC_DYNAMIC_MINOR,
 	.name  		= DRIVER_NAME,
+	.name  		= "pktcdvd/control",
 	.fops  		= &pkt_ctl_fops
 };
 
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -140,7 +140,7 @@ struct gendisk {
                                          * disks that can't be partitioned. */
 
 	char disk_name[DISK_NAME_LEN];	/* name of major driver */
-
+	char *(*nodename)(struct gendisk *gd);
 	/* Array of pointers to partitions indexed by partno.
 	 * Protected with matching bdev lock but stat and other
 	 * non-critical accesses use RCU.  Always access through


