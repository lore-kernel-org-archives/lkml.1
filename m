Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYJ3Fj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYJ3Fj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 01:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYJ3FjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 01:39:17 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:24973 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752436AbYJ3FjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 01:39:16 -0400
X-YMail-OSG: iEmV_KIVM1mJyAxX4BcrtHjRCMjR1GRlbGDzu6K_VAhdjbtGRGuB_Cc7Ey04iEoxIyqZ64qKrFZWxIrtqT853QgLk5nfqb_Hm6rbmda4XVijH1DkjoIiuvvFsktG_RKO43es8xJL3RiDPgCKjbqM_7s560CUfS3hI8J31xn.4O1Iy7ghTnZUb2FPRbs-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH] [Target_Core_Mod]: Updates for v2.6.28-rc2
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 22:39:13 -0700
Message-Id: <1225345154.4387.228.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 92eaaa2d3fe569ec0654b44658504c8c75fa9a43 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Wed, 29 Oct 2008 22:30:00 -0700
Subject: [PATCH] [Target_Core_Mod]: Updates for v2.6.28-rc2

There are two updates to Target_Core_Mod code for v2.6.27 -> v2.6.28-rc2

*) blkdev_get() loses "unsigned flags" parameter
*) blkdev_put() gains "fmode_t mode" parameter

For the first two, updated linux_blockdevice_claim*() and linux_blockdevice_release()
in drivers/lio-core/target_core_device.c, Also updated READ-ONLY cases for
Target_Core_Mod/IBLOCK and Target_Core_Mod/FILEIO.

*) struct genhd->capacity goes away

Target_Core_Mod/IBLOCK had been using this to emulate READ_CAPACITY.  Changed
iblock_emulate_read_cap() and iblock_emulate_read_cap16() to correctly use
include/linux/genhd.h:get_capacity() macro

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_device.c |   12 ++++++------
 drivers/lio-core/target_core_file.c   |    2 +-
 drivers/lio-core/target_core_iblock.c |    8 ++++----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 6891b54..11dc965 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -68,7 +68,7 @@ extern se_global_t *se_global;
 
 extern struct block_device *linux_blockdevice_claim_bd (struct block_device *bd, void *claim_ptr)
 {
-	if (blkdev_get(bd, FMODE_WRITE|FMODE_READ, O_RDWR) < 0)
+	if (blkdev_get(bd, FMODE_WRITE|FMODE_READ) < 0)
 		return(NULL);	
 	/*
 	 * If no claim pointer was passed from claimee, use struct block_device.
@@ -77,7 +77,7 @@ extern struct block_device *linux_blockdevice_claim_bd (struct block_device *bd,
 		claim_ptr = (void *)bd;
 
 	if (bd_claim(bd, claim_ptr) < 0) {
-		blkdev_put(bd);
+		blkdev_put(bd, FMODE_WRITE|FMODE_READ);
 		return(NULL);
 	}
 	
@@ -96,7 +96,7 @@ extern struct block_device *__linux_blockdevice_claim (int major, int minor, voi
 		return(NULL);
 	}
 
-	if (blkdev_get(bd, FMODE_WRITE, O_RDWR) < 0) {
+	if (blkdev_get(bd, FMODE_WRITE|FMODE_READ) < 0) {
 		*ret = -1;
 		return(NULL);
 	}
@@ -129,7 +129,7 @@ extern struct block_device *linux_blockdevice_claim (int major, int minor, void
 	if (!(bd = bdget(dev)))
 		return(NULL);
 
-	if (blkdev_get(bd, FMODE_WRITE, O_RDWR) < 0)
+	if (blkdev_get(bd, FMODE_WRITE|FMODE_READ) < 0)
 		return(NULL);
 	/*
 	 * If no claim pointer was passed from claimee, use struct block_device.
@@ -138,7 +138,7 @@ extern struct block_device *linux_blockdevice_claim (int major, int minor, void
 		claim_ptr = (void *)bd;
 
 	if (bd_claim(bd, claim_ptr) < 0) {
-		blkdev_put(bd);
+		blkdev_put(bd, FMODE_WRITE|FMODE_READ);
 		return(NULL);
 	}
 	
@@ -159,7 +159,7 @@ extern int linux_blockdevice_release (int major, int minor, struct block_device
 		bd = bd_p;
 
 	bd_release(bd);
-	blkdev_put(bd);
+	blkdev_put(bd, FMODE_WRITE|FMODE_READ);
 
 	return(0);
 }
diff --git a/drivers/lio-core/target_core_file.c b/drivers/lio-core/target_core_file.c
index 35c7665..1ea126f 100644
--- a/drivers/lio-core/target_core_file.c
+++ b/drivers/lio-core/target_core_file.c
@@ -159,7 +159,7 @@ extern int fd_release_phydevice (se_device_t *dev)
 	if (dev->dev_flags & DF_READ_ONLY) {
 		PYXPRINT("FILEIO: Calling blkdev_put() for Major:Minor - %d:%d\n",
 			fd_dev->fd_major, fd_dev->fd_minor);
-		blkdev_put((struct block_device *)fd_dev->fd_bd);
+		blkdev_put((struct block_device *)fd_dev->fd_bd, FMODE_READ);
 	} else {	
 		PYXPRINT("FILEIO: Releasing Major:Minor - %d:%d\n", fd_dev->fd_major,
 			fd_dev->fd_minor);
diff --git a/drivers/lio-core/target_core_iblock.c b/drivers/lio-core/target_core_iblock.c
index f5beb70..8f5a442 100644
--- a/drivers/lio-core/target_core_iblock.c
+++ b/drivers/lio-core/target_core_iblock.c
@@ -159,7 +159,7 @@ extern int iblock_release_phydevice (se_device_t *dev)
 	if (dev->dev_flags & DF_READ_ONLY) {
 		PYXPRINT("IBLOCK: Calling blkdev_put() for Major:Minor - %d:%d\n",
 			ib_dev->ibd_major, ib_dev->ibd_minor);
-		blkdev_put((struct block_device *)ib_dev->ibd_bd);
+		blkdev_put((struct block_device *)ib_dev->ibd_bd, FMODE_READ);
 	} else {
 		PYXPRINT("IBLOCK: Releasing Major:Minor - %d:%d\n",
 			ib_dev->ibd_major, ib_dev->ibd_minor);
@@ -415,9 +415,9 @@ static int iblock_emulate_read_cap (se_task_t *task)
 {
 	iblock_dev_t *ibd = (iblock_dev_t *) task->iscsi_dev->dev_ptr;
 	struct block_device *bd = ibd->ibd_bd;
-	u32 blocks = (bd->bd_disk->capacity - 1);
+	u32 blocks = (get_capacity(bd->bd_disk) - 1);
 
-	if ((bd->bd_disk->capacity - 1) >= 0x00000000ffffffff)
+	if ((get_capacity(bd->bd_disk) - 1) >= 0x00000000ffffffff)
 		blocks = 0xffffffff;
 
 	return(transport_generic_emulate_readcapacity(task->iscsi_cmd, blocks, IBLOCK_BLOCKSIZE));
@@ -427,7 +427,7 @@ static int iblock_emulate_read_cap16 (se_task_t *task)
 {
 	iblock_dev_t *ibd = (iblock_dev_t *) task->iscsi_dev->dev_ptr;
 	struct block_device *bd = ibd->ibd_bd;
-	unsigned long long blocks_long = (bd->bd_disk->capacity - 1);
+	unsigned long long blocks_long = (get_capacity(bd->bd_disk) - 1);
 
 	return(transport_generic_emulate_readcapacity_16(task->iscsi_cmd, blocks_long, IBLOCK_BLOCKSIZE));;
 }
-- 
1.5.4.1



