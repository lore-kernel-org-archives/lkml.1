Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbZDEIjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbZDEIjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 04:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZDEIjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 04:39:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:37753 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbZDEIjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 04:39:09 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] xsysace: Fix dereferencing of cf_id after hd_driveid removal
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Sun, 05 Apr 2009 02:39:03 -0600
Message-ID: <20090405083649.1640.31018.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Commit 4aaf2fec718f6fbf38668edf733a0ab09a49cab1 (xsysace: make it
'struct hd_driveid'-free) converted the cf_id member of 'struct
ace_device' from a 'struct hd_driveid' to a u16 array.  However,
references to the base of the structure were still using the '&'
operator.  When the address was used with the ata_id_u32() macro, the
compiler used the size of the entire array instead of sizeof(u16) to
calculate the offset from the base address.

This patch removes the use of the '&' operator from all references of
cf_id to fix the bug and remove future confusion.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---

 drivers/block/xsysace.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 6cccdc3..4aecf5d 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -563,7 +563,7 @@ static void ace_fsm_dostate(struct ace_device *ace)
 	case ACE_FSM_STATE_IDENTIFY_PREPARE:
 		/* Send identify command */
 		ace->fsm_task = ACE_TASK_IDENTIFY;
-		ace->data_ptr = &ace->cf_id;
+		ace->data_ptr = ace->cf_id;
 		ace->data_count = ACE_BUF_PER_SECTOR;
 		ace_out(ace, ACE_SECCNTCMD, ACE_SECCNTCMD_IDENTIFY);
 
@@ -608,8 +608,8 @@ static void ace_fsm_dostate(struct ace_device *ace)
 		break;
 
 	case ACE_FSM_STATE_IDENTIFY_COMPLETE:
-		ace_fix_driveid(&ace->cf_id[0]);
-		ace_dump_mem(&ace->cf_id, 512);	/* Debug: Dump out disk ID */
+		ace_fix_driveid(ace->cf_id);
+		ace_dump_mem(ace->cf_id, 512);	/* Debug: Dump out disk ID */
 
 		if (ace->data_result) {
 			/* Error occured, disable the disk */
@@ -622,9 +622,9 @@ static void ace_fsm_dostate(struct ace_device *ace)
 
 			/* Record disk parameters */
 			set_capacity(ace->gd,
-				ata_id_u32(&ace->cf_id, ATA_ID_LBA_CAPACITY));
+				ata_id_u32(ace->cf_id, ATA_ID_LBA_CAPACITY));
 			dev_info(ace->dev, "capacity: %i sectors\n",
-				ata_id_u32(&ace->cf_id, ATA_ID_LBA_CAPACITY));
+				ata_id_u32(ace->cf_id, ATA_ID_LBA_CAPACITY));
 		}
 
 		/* We're done, drop to IDLE state and notify waiters */
@@ -923,7 +923,7 @@ static int ace_release(struct gendisk *disk, fmode_t mode)
 static int ace_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
 	struct ace_device *ace = bdev->bd_disk->private_data;
-	u16 *cf_id = &ace->cf_id[0];
+	u16 *cf_id = ace->cf_id;
 
 	dev_dbg(ace->dev, "ace_getgeo()\n");
 

