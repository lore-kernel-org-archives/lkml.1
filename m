Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908Ab0A3PGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab0A3PGu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 10:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973Ab0A3PGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 10:06:49 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:61471 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab0A3PDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 10:03:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZLQyqT+8Cbvnp1wdtAOtMs5MkztczigpakkImfP6I8iPIAGEZeFGDns0UgCWwEvqbA
         nnRdMPCqQwWjCUr49uBILOFQXIL8QhYNeyr2jfaWU7kuz8TA84Z4Mg/GCczO76csJazF
         PtYdsrSTvpePED/qaPnKVjyCTETj6VHri7ynw=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 03/17] blktrans: track open and close calls.
Date: Sat, 30 Jan 2010 17:02:34 +0200
Message-Id: <1264863768-27606-4-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1264863768-27606-1-git-send-email-maximlevitsky@gmail.com>
References: <1264863768-27606-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds tracking for open and close calls.
Now trans ->open and ->release are never called twise in a row
->release is also called once before mtd device disappers

Proper locking will be added in follow up patch

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtd_blkdevs.c    |   18 ++++++++++++++++++
 include/linux/mtd/blktrans.h |    1 +
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 93c87af..966398b 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -128,6 +128,9 @@ static int blktrans_open(struct block_device *bdev, fmode_t mode)
 	if (!get_mtd_device(NULL, dev->mtd->index))
 		goto out;
 
+	if (dev->open++)
+		goto out;
+
 	if (!try_module_get(tr->owner))
 		goto out_tr;
 
@@ -153,6 +156,10 @@ static int blktrans_release(struct gendisk *disk, fmode_t mode)
 	struct mtd_blktrans_ops *tr = dev->tr;
 	int ret = 0;
 
+	dev->open--;
+	if (dev->open)
+		return 0;
+
 	if (tr->release)
 		ret = tr->release(dev);
 
@@ -304,6 +311,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	if (new->readonly)
 		set_disk_ro(gd, 1);
 
+	new->open = 0;
 	add_disk(gd);
 
 	return 0;
@@ -333,6 +341,16 @@ int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 	/* Stop the thread */
 	kthread_stop(old->thread);
 
+	if (old->open) {
+		if (old->tr->release)
+			old->tr->release(old);
+		put_mtd_device(old->mtd);
+	}
+
+	/* From now on, no calls into trans can be made */
+	/* Mtd device will be gone real soon now */
+	old->mtd = NULL;
+ 
 	blk_cleanup_queue(old->rq);
 	return 0;
 }
diff --git a/include/linux/mtd/blktrans.h b/include/linux/mtd/blktrans.h
index a4b3928..507f7b2 100644
--- a/include/linux/mtd/blktrans.h
+++ b/include/linux/mtd/blktrans.h
@@ -24,6 +24,7 @@ struct mtd_blktrans_dev {
 	int devnum;
 	unsigned long size;
 	int readonly;
+	int open;
 	struct gendisk *disk;
 	struct task_struct *thread;
 	struct request_queue *rq;
-- 
1.6.3.3

