Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042Ab0A3PFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab0A3PFi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 10:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063Ab0A3PDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 10:03:20 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:55839 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab0A3PDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 10:03:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=H2zhnTyUCSyKD284G/5mnInp9qD2AIuOMlqzBvb1+fxtvkGVfDX7TVRkOJ0joG7fqd
         zq8Jl5Yr7EfJijz9WHf8kV6p4lwMJNO4xKmTlgIzmITTkOidUMSRboHAE1OfFANjxhCD
         bCil0s04NuojF9j0detPhTMjBS0/Qdh5W4vEw=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 07/17] blktrans: allow FTL drivers to export sysfs attributes
Date: Sat, 30 Jan 2010 17:02:38 +0200
Message-Id: <1264863768-27606-8-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1264863768-27606-1-git-send-email-maximlevitsky@gmail.com>
References: <1264863768-27606-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add ability to export sysfs attributes below
block disk device.
This can be used to pass UDEV information about the FTL
and could include vendor, serial, version, etc...

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtd_blkdevs.c    |   11 ++++++++++-
 include/linux/mtd/blktrans.h |    2 ++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index a65eb07..1c4e615 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -317,7 +317,6 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 
 	set_capacity(gd, (new->size * tr->blksize) >> 9);
 
-
 	/* Create the request queue */
 	spin_lock_init(&new->queue_lock);
 	new->rq = blk_init_queue(mtd_blktrans_request, &new->queue_lock);
@@ -350,6 +349,11 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	new->open = 0;
 	add_disk(gd);
 
+	if (new->disk_attributes)
+		sysfs_create_group(&disk_to_dev(gd)->kobj,
+					new->disk_attributes);
+
+
 	return 0;
 error4:
 	blk_cleanup_queue(new->rq);
@@ -376,6 +380,11 @@ int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 	/* stop new requests to arrive */
 	del_gendisk(old->disk);
 
+
+	if (old->disk_attributes)
+		sysfs_remove_group(&disk_to_dev(old->disk)->kobj,
+						old->disk_attributes);
+
 	/* flush current requests */
 	spin_lock_irqsave(&old->queue_lock, flags);
 	old->deleted = 1;
diff --git a/include/linux/mtd/blktrans.h b/include/linux/mtd/blktrans.h
index e276aca..faf1e54 100644
--- a/include/linux/mtd/blktrans.h
+++ b/include/linux/mtd/blktrans.h
@@ -9,6 +9,7 @@
 #define __MTD_TRANS_H__
 
 #include <linux/mutex.h>
+#include <linux/sysfs.h>
 
 struct hd_geometry;
 struct mtd_info;
@@ -27,6 +28,7 @@ struct mtd_blktrans_dev {
 	int deleted;
 	int open;
 	struct gendisk *disk;
+	struct attribute_group *disk_attributes;
 	struct task_struct *thread;
 	struct request_queue *rq;
 	spinlock_t queue_lock;
-- 
1.6.3.3

