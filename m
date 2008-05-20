Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbYETSHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbYETSHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932356AbYETSGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:06:22 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:3977 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbYETSGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:06:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VVUtjG6V7Pi6qih2GdHVtYyY7fBTSfPnIokdbUE/IaSxw0Bl1j6CHfJvtK7dU03RTCgJjDEqZX2JpDzEdCNqf007S6T9VhrudKPW9pTZRzR1CvpBO3+GvDxEGPSpxh3qEQCB/Z1taP6HRMz7Pc+FitxOLKlMuHjHPr31UgyLly8=
Subject: [PATCH 19/21] drivers/block: use aligned-endian get/put helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:11 -0700
Message-Id: <1211306771.5915.171.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/block/cciss.c     |   11 +++++------
 drivers/block/paride/pd.c |    8 ++++----
 drivers/block/ub.c        |    4 ++--
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index e336b05..5e5d39a 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1513,8 +1513,7 @@ static int rebuild_lun_table(ctlr_info_t *h, struct gendisk *del_disk)
 					      0, 0, TYPE_CMD);
 
 		if (return_code == IO_OK) {
-			listlength =
-				be32_to_cpu(*(__be32 *) ld_buff->LUNListLength);
+			listlength = get_be32(ld_buff->LUNListLength);
 		} else {	/* reading number of logical volumes failed */
 			printk(KERN_WARNING "cciss: report logical volume"
 			       " command failed\n");
@@ -2036,8 +2035,8 @@ cciss_read_capacity(int ctlr, int logvol, int withirq, sector_t *total_size,
 				ctlr, buf, sizeof(ReadCapdata_struct),
 					1, logvol, 0, NULL, TYPE_CMD);
 	if (return_code == IO_OK) {
-		*total_size = be32_to_cpu(*(__be32 *) buf->total_size);
-		*block_size = be32_to_cpu(*(__be32 *) buf->block_size);
+		*total_size = get_be32(buf->total_size);
+		*block_size = get_be32(buf->block_size);
 	} else {		/* read capacity command failed */
 		printk(KERN_WARNING "cciss: read capacity failed\n");
 		*total_size = 0;
@@ -2072,8 +2071,8 @@ cciss_read_capacity_16(int ctlr, int logvol, int withirq, sector_t *total_size,
 				1, logvol, 0, NULL, TYPE_CMD);
 	}
 	if (return_code == IO_OK) {
-		*total_size = be64_to_cpu(*(__be64 *) buf->total_size);
-		*block_size = be32_to_cpu(*(__be32 *) buf->block_size);
+		*total_size = get_be64(buf->total_size);
+		*block_size = get_be32(buf->block_size);
 	} else {		/* read capacity command failed */
 		printk(KERN_WARNING "cciss: read capacity failed\n");
 		*total_size = 0;
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 570f3b7..a5f429f 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -663,11 +663,11 @@ static enum action pd_identify(struct pd_unit *disk)
 		return Fail;
 	pi_read_block(disk->pi, pd_scratch, 512);
 	disk->can_lba = pd_scratch[99] & 2;
-	disk->sectors = le16_to_cpu(*(__le16 *) (pd_scratch + 12));
-	disk->heads = le16_to_cpu(*(__le16 *) (pd_scratch + 6));
-	disk->cylinders = le16_to_cpu(*(__le16 *) (pd_scratch + 2));
+	disk->sectors = get_le16(pd_scratch + 12);
+	disk->heads = get_le16(pd_scratch + 6);
+	disk->cylinders = get_le16(pd_scratch + 2);
 	if (disk->can_lba)
-		disk->capacity = le32_to_cpu(*(__le32 *) (pd_scratch + 120));
+		disk->capacity = get_le32(pd_scratch + 120);
 	else
 		disk->capacity = disk->sectors * disk->heads * disk->cylinders;
 
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index 3a281ef..f86ab3c 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -1914,8 +1914,8 @@ static int ub_sync_read_cap(struct ub_dev *sc, struct ub_lun *lun,
 	}
 
 	/* sd.c special-cases sector size of 0 to mean 512. Needed? Safe? */
-	nsec = be32_to_cpu(*(__be32 *)p) + 1;
-	bsize = be32_to_cpu(*(__be32 *)(p + 4));
+	nsec = get_be32(p) + 1;
+	bsize = get_be32(p + 4);
 	switch (bsize) {
 	case 512:	shift = 0;	break;
 	case 1024:	shift = 1;	break;
-- 
1.5.5.1.570.g26b5e


