Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0BMNGh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 08:06:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:23345 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab0BMNDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 08:03:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AZaK59UznQgw8OWmu5d3lFyV/en8Grpc36eTMtBbdCfBh2iuWWuAuU+8jF1GA7tWDj
         Dfoc8gu4iwLbv8dscXxuH2XB1qLrjxd/5v2lCkIdZeK0E4THCYPanIf1p2p47sv/N4dD
         aH3sVs6HPoD+nzm0oP6qKaFNeEktadMhtgbL0=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 05/14] blktrans: allow FTL drivers to export sysfs attributes
Date: Sat, 13 Feb 2010 15:03:04 +0200
Message-Id: <1266066193-17625-6-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266066193-17625-1-git-send-email-maximlevitsky@gmail.com>
References: <1266066193-17625-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an ability to export sysfs attributes below
the block disk device.

This can be used to pass the udev an information about the FTL
and could include the vendor, serial, version, etc...

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtd_blkdevs.c    |    9 +++++++++
 include/linux/mtd/blktrans.h |    2 ++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 1bc9c76..6850091 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -359,6 +359,11 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 
 	add_disk(gd);
 
+	if (new->disk_attributes)
+		sysfs_create_group(&disk_to_dev(gd)->kobj,
+					new->disk_attributes);
+
+
 	return 0;
 error4:
 	module_put(tr->owner);
@@ -387,6 +392,10 @@ int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
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

