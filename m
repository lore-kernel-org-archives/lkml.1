Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab0BVSkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:40:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:9830 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab0BVSkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:40:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FysgMDuQg4ig+5ZIhoVHm9qS87RTJYe+rpgeuxrnTx8Adr26aFbAZDbm6w5uWW+xmo
         5c8SYPnnJJdyG0juBcJpakrru5ZUDyynJYxgzPOF4sCpI6XM0PSIB7Qa+5LXdnyBI0Ka
         8II5++9aaEDYYRqxA+oYOujZSmnXQ/aOWdxNg=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>, <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 06/15] blktrans: allow FTL drivers to export sysfs attributes
Date: Mon, 22 Feb 2010 20:39:33 +0200
Message-Id: <1266863982-5258-7-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com>
References: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an ability to export sysfs attributes below
the block disk device.

This can be used to pass the udev an information about the FTL
and could include the vendor, serial, version, etc...

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtd_blkdevs.c    |    8 ++++++++
 include/linux/mtd/blktrans.h |    2 ++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 646cc84..9dd23d6 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -379,6 +379,10 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 		set_disk_ro(gd, 1);
 
 	add_disk(gd);
+
+	if (new->disk_attributes)
+		sysfs_create_group(&disk_to_dev(gd)->kobj,
+					new->disk_attributes);
 	return 0;
 error4:
 	module_put(tr->owner);
@@ -405,6 +409,10 @@ int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 	/* Stop new requests to arrive */
 	del_gendisk(old->disk);
 
+	if (old->disk_attributes)
+		sysfs_remove_group(&disk_to_dev(old->disk)->kobj,
+						old->disk_attributes);
+
 	/* Stop the thread */
 	kthread_stop(old->thread);
 
diff --git a/include/linux/mtd/blktrans.h b/include/linux/mtd/blktrans.h
index d89b8fb..b481ccd 100644
--- a/include/linux/mtd/blktrans.h
+++ b/include/linux/mtd/blktrans.h
@@ -10,6 +10,7 @@
 
 #include <linux/mutex.h>
 #include <linux/kref.h>
+#include <linux/sysfs.h>
 
 struct hd_geometry;
 struct mtd_info;
@@ -28,6 +29,7 @@ struct mtd_blktrans_dev {
 	int open;
 	struct kref ref;
 	struct gendisk *disk;
+	struct attribute_group *disk_attributes;
 	struct task_struct *thread;
 	struct request_queue *rq;
 	spinlock_t queue_lock;
-- 
1.6.3.3

