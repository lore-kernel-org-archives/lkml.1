Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbYJ3A00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbYJ3A00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 20:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYJ3A0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 20:26:19 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:11302 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbYJ3A0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 20:26:18 -0400
Subject: block: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 01:26:19 +0100
Message-Id: <1225326379.5970.23.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: block: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Jens Axboe <jens.axboe@oracle.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/block/bsg.c b/block/bsg.c
index e8bd247..f8b4c3d 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -42,7 +42,7 @@ struct bsg_device {
 	int done_cmds;
 	wait_queue_head_t wq_done;
 	wait_queue_head_t wq_free;
-	char name[BUS_ID_SIZE];
+	char name[20];
 	int max_queue;
 	unsigned long flags;
 };
@@ -779,7 +779,7 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
 	mutex_lock(&bsg_mutex);
 	hlist_add_head(&bd->dev_list, bsg_dev_idx_hash(iminor(inode)));
 
-	strncpy(bd->name, rq->bsg_dev.class_dev->bus_id, sizeof(bd->name) - 1);
+	strncpy(bd->name, dev_name(rq->bsg_dev.class_dev), sizeof(bd->name) - 1);
 	dprintk("bound to <%s>, max queue %d\n",
 		format_dev_t(buf, inode->i_rdev), bd->max_queue);
 
@@ -990,7 +990,7 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
 	if (name)
 		devname = name;
 	else
-		devname = parent->bus_id;
+		devname = dev_name(parent);
 
 	/*
 	 * we need a proper transport to send commands, not a stacked device
diff --git a/block/genhd.c b/block/genhd.c
index 4e5e749..7fb2b6f 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1067,7 +1067,7 @@ dev_t blk_lookup_devt(const char *name, int partno)
 		struct gendisk *disk = dev_to_disk(dev);
 		struct hd_struct *part;
 
-		if (strcmp(dev->bus_id, name))
+		if (strcmp(dev_name(dev), name))
 			continue;
 
 		part = disk_get_part(disk, partno);
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 633f7a0..8cd966a 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -384,9 +384,9 @@ int add_partition(struct gendisk *disk, int partno,
 
 	dname = dev_name(ddev);
 	if (isdigit(dname[strlen(dname) - 1]))
-		snprintf(pdev->bus_id, BUS_ID_SIZE, "%sp%d", dname, partno);
+		dev_set_name(pdev, "%sp%d", dname, partno);
 	else
-		snprintf(pdev->bus_id, BUS_ID_SIZE, "%s%d", dname, partno);
+		dev_set_name(pdev, "%s%d", dname, partno);
 
 	device_initialize(pdev);
 	pdev->class = &block_class;
@@ -445,16 +445,11 @@ void register_disk(struct gendisk *disk)
 	struct block_device *bdev;
 	struct disk_part_iter piter;
 	struct hd_struct *part;
-	char *s;
 	int err;
 
 	ddev->parent = disk->driverfs_dev;
 
-	strlcpy(ddev->bus_id, disk->disk_name, BUS_ID_SIZE);
-	/* ewww... some of these buggers have / in the name... */
-	s = strchr(ddev->bus_id, '/');
-	if (s)
-		*s = '!';
+	dev_set_name(ddev, disk->disk_name);
 
 	/* delay uevents, until we scanned partition table */
 	ddev->uevent_suppress = 1;


