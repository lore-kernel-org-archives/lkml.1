Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbZAFWcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbZAFWcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbZAFWOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:16 -0500
Received: from kroah.org ([198.145.64.141]:51335 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755573AbZAFWOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:11 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jens Axboe <jens.axboe@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 52/60] block: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:12:11 -0800
Message-Id: <1231279939-32728-52-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/bsg.c           |    6 +++---
 block/genhd.c         |    2 +-
 fs/partitions/check.c |   11 +++--------
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index e73e50d..d414bb5 100644
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
@@ -781,7 +781,7 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
 	mutex_lock(&bsg_mutex);
 	hlist_add_head(&bd->dev_list, bsg_dev_idx_hash(iminor(inode)));
 
-	strncpy(bd->name, rq->bsg_dev.class_dev->bus_id, sizeof(bd->name) - 1);
+	strncpy(bd->name, dev_name(rq->bsg_dev.class_dev), sizeof(bd->name) - 1);
 	dprintk("bound to <%s>, max queue %d\n",
 		format_dev_t(buf, inode->i_rdev), bd->max_queue);
 
@@ -992,7 +992,7 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
 	if (name)
 		devname = name;
 	else
-		devname = parent->bus_id;
+		devname = dev_name(parent);
 
 	/*
 	 * we need a proper transport to send commands, not a stacked device
diff --git a/block/genhd.c b/block/genhd.c
index d84a7df..397960c 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1084,7 +1084,7 @@ dev_t blk_lookup_devt(const char *name, int partno)
 		struct gendisk *disk = dev_to_disk(dev);
 		struct hd_struct *part;
 
-		if (strcmp(dev->bus_id, name))
+		if (strcmp(dev_name(dev), name))
 			continue;
 
 		part = disk_get_part(disk, partno);
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 6d5b213..5198ada 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -384,9 +384,9 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 
 	dname = dev_name(ddev);
 	if (isdigit(dname[strlen(dname) - 1]))
-		snprintf(pdev->bus_id, BUS_ID_SIZE, "%sp%d", dname, partno);
+		dev_set_name(pdev, "%sp%d", dname, partno);
 	else
-		snprintf(pdev->bus_id, BUS_ID_SIZE, "%s%d", dname, partno);
+		dev_set_name(pdev, "%s%d", dname, partno);
 
 	device_initialize(pdev);
 	pdev->class = &block_class;
@@ -447,16 +447,11 @@ void register_disk(struct gendisk *disk)
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
-- 
1.6.0.4

