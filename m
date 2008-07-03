Return-Path: <linux-kernel-owner+w=401wt.eu-S1761544AbYGCNGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544AbYGCNGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbYGCNGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:06:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:33992 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbYGCNGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:06:05 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, linux-ide@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, bharrosh@panasas.com,
       greg.freemyer@gmail.com, linux-scsi@vger.kernel.org,
       brking@linux.vnet.ibm.com, liml@rtr.ca, jens.axboe@oracle.com,
       viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org, device@lanana.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] block: misc updates
Date: Thu,  3 Jul 2008 17:33:01 +0900
Message-Id: <1215073986-4709-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1215073986-4709-1-git-send-email-tj@kernel.org>
References: <1215073986-4709-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (hera.kernel.org [127.0.0.1]); Thu, 03 Jul 2008 08:33:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following misc updates in preparation for
extended block devt support.

* make add_partition report on failrues
* add hd_struct->disk which points to the containing gendisk
* fix comment for gendisk->part

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/partitions/check.c |   11 ++++++++++-
 include/linux/genhd.h |    3 ++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 6149e4b..b915ac2 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -346,19 +346,28 @@ static DEVICE_ATTR(whole_disk, S_IRUSR | S_IRGRP | S_IROTH,
 
 void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
 {
+	char name[BDEVNAME_SIZE];
 	struct hd_struct *p;
 	int err;
 
+	disk_name(disk, part, name);
+
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
-	if (!p)
+	if (!p) {
+		printk(KERN_WARNING "%s: failed to allocate partition "
+		       "structure (part=%d)\n", name, part);
 		return;
+	}
 
 	if (!init_part_stats(p)) {
+		printk(KERN_WARNING "%s: failed to initialize partition stats "
+		       "structure (part=%d)\n", name, part);
 		kfree(p);
 		return;
 	}
 	p->start_sect = start;
 	p->nr_sects = len;
+	p->disk = disk;
 	p->partno = part;
 	p->policy = disk->policy;
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index ae7aec3..1f06681 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -88,6 +88,7 @@ struct hd_struct {
 	sector_t start_sect;
 	sector_t nr_sects;
 	struct device dev;
+	struct gendisk *disk;
 	struct kobject *holder_dir;
 	int policy, partno;
 #ifdef CONFIG_FAIL_MAKE_REQUEST
@@ -117,7 +118,7 @@ struct gendisk {
 	int minors;                     /* maximum number of minors, =1 for
                                          * disks that can't be partitioned. */
 	char disk_name[32];		/* name of major driver */
-	struct hd_struct **part;	/* [indexed by minor] */
+	struct hd_struct **part;	/* [indexed by minor - 1] */
 	struct block_device_operations *fops;
 	struct request_queue *queue;
 	void *private_data;
-- 
1.5.4.5

