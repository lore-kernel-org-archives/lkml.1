Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab0BDXba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 18:31:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:32260 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145Ab0BDXbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 18:31:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xqlhsseQlEET+z2rP2hc68k26t4fbrULAL4NH2dixrJteO5zf0fael9zyytQD9gw0x
         sN2vh1dECykbTAglbTEiaS1NK2SqpC8vOqJ0mz6c7YSsVz+Rf+mniGQqhvhJskQX3KCd
         /YtsTdj5F2tIRbOtUuKSZtwn2acROyjQVd6Aw=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 04/17] blktrans: don't free mtd_blktrans_dev, core will do that for you
Date: Fri,  5 Feb 2010 01:30:44 +0200
Message-Id: <1265326257-4446-5-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265326257-4446-1-git-send-email-maximlevitsky@gmail.com>
References: <1265326257-4446-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need that structure till last user exits, and that might be years after
mtd device disappered.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/ftl.c            |    1 -
 drivers/mtd/inftlcore.c      |    1 -
 drivers/mtd/mtd_blkdevs.c    |   13 +++++++++++++
 drivers/mtd/mtdblock.c       |    1 -
 drivers/mtd/mtdblock_ro.c    |    1 -
 drivers/mtd/nftlcore.c       |    1 -
 drivers/mtd/rfd_ftl.c        |    1 -
 drivers/mtd/ssfdc.c          |    1 -
 include/linux/mtd/blktrans.h |    1 +
 9 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/ftl.c b/drivers/mtd/ftl.c
index e56d6b4..62da9eb 100644
--- a/drivers/mtd/ftl.c
+++ b/drivers/mtd/ftl.c
@@ -1082,7 +1082,6 @@ static void ftl_remove_dev(struct mtd_blktrans_dev *dev)
 {
 	del_mtd_blktrans_dev(dev);
 	ftl_freepart((partition_t *)dev);
-	kfree(dev);
 }
 
 static struct mtd_blktrans_ops ftl_tr = {
diff --git a/drivers/mtd/inftlcore.c b/drivers/mtd/inftlcore.c
index 8aca552..015a7fe 100755
--- a/drivers/mtd/inftlcore.c
+++ b/drivers/mtd/inftlcore.c
@@ -139,7 +139,6 @@ static void inftl_remove_dev(struct mtd_blktrans_dev *dev)
 
 	kfree(inftl->PUtable);
 	kfree(inftl->VUtable);
-	kfree(inftl);
 }
 
 /*
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 9ac8f22..1b89e59 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -131,6 +131,9 @@ static int blktrans_open(struct block_device *bdev, fmode_t mode)
 	if (dev->open++)
 		goto out;
 
+	if (dev->deleted)
+		goto out;
+
 	if (!try_module_get(tr->owner))
 		goto out_tr;
 
@@ -168,6 +171,14 @@ static int blktrans_release(struct gendisk *disk, fmode_t mode)
 		module_put(tr->owner);
 	}
 
+	/* Free the private data */
+	if (dev->deleted) {
+		module_put(tr->owner);
+		mutex_unlock(&dev->lock);
+		kfree(dev);
+		return 0;
+	}
+
 	return ret;
 }
 
@@ -337,6 +348,8 @@ int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 	/* stop new requests to arrive */
 	del_gendisk(old->disk);
 
+	old->deleted = 1;
+
 	/* Stop the thread */
 	kthread_stop(old->thread);
 
diff --git a/drivers/mtd/mtdblock.c b/drivers/mtd/mtdblock.c
index 9f41b1a..d8322cc 100644
--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -368,7 +368,6 @@ static void mtdblock_add_mtd(struct mtd_blktrans_ops *tr, struct mtd_info *mtd)
 static void mtdblock_remove_dev(struct mtd_blktrans_dev *dev)
 {
 	del_mtd_blktrans_dev(dev);
-	kfree(dev);
 }
 
 static struct mtd_blktrans_ops mtdblock_tr = {
diff --git a/drivers/mtd/mtdblock_ro.c b/drivers/mtd/mtdblock_ro.c
index 852165f..54ff288 100644
--- a/drivers/mtd/mtdblock_ro.c
+++ b/drivers/mtd/mtdblock_ro.c
@@ -49,7 +49,6 @@ static void mtdblock_add_mtd(struct mtd_blktrans_ops *tr, struct mtd_info *mtd)
 static void mtdblock_remove_dev(struct mtd_blktrans_dev *dev)
 {
 	del_mtd_blktrans_dev(dev);
-	kfree(dev);
 }
 
 static struct mtd_blktrans_ops mtdblock_tr = {
diff --git a/drivers/mtd/nftlcore.c b/drivers/mtd/nftlcore.c
index 1002e18..a4578bf 100644
--- a/drivers/mtd/nftlcore.c
+++ b/drivers/mtd/nftlcore.c
@@ -126,7 +126,6 @@ static void nftl_remove_dev(struct mtd_blktrans_dev *dev)
 	del_mtd_blktrans_dev(dev);
 	kfree(nftl->ReplUnitTable);
 	kfree(nftl->EUNtable);
-	kfree(nftl);
 }
 
 /*
diff --git a/drivers/mtd/rfd_ftl.c b/drivers/mtd/rfd_ftl.c
index d2aa9c4..63b83c0 100644
--- a/drivers/mtd/rfd_ftl.c
+++ b/drivers/mtd/rfd_ftl.c
@@ -817,7 +817,6 @@ static void rfd_ftl_remove_dev(struct mtd_blktrans_dev *dev)
 	vfree(part->sector_map);
 	kfree(part->header_cache);
 	kfree(part->blocks);
-	kfree(part);
 }
 
 static struct mtd_blktrans_ops rfd_ftl_tr = {
diff --git a/drivers/mtd/ssfdc.c b/drivers/mtd/ssfdc.c
index 3f67e00..81c4ecd 100644
--- a/drivers/mtd/ssfdc.c
+++ b/drivers/mtd/ssfdc.c
@@ -375,7 +375,6 @@ static void ssfdcr_remove_dev(struct mtd_blktrans_dev *dev)
 
 	del_mtd_blktrans_dev(dev);
 	kfree(ssfdc->logic_block_map);
-	kfree(ssfdc);
 }
 
 static int ssfdcr_readsect(struct mtd_blktrans_dev *dev,
diff --git a/include/linux/mtd/blktrans.h b/include/linux/mtd/blktrans.h
index 507f7b2..e276aca 100644
--- a/include/linux/mtd/blktrans.h
+++ b/include/linux/mtd/blktrans.h
@@ -24,6 +24,7 @@ struct mtd_blktrans_dev {
 	int devnum;
 	unsigned long size;
 	int readonly;
+	int deleted;
 	int open;
 	struct gendisk *disk;
 	struct task_struct *thread;
-- 
1.6.3.3

