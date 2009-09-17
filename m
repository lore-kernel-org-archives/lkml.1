Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbZIQSrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbZIQSrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759612AbZIQSrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:47:42 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:20873 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbZIQSri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:47:38 -0400
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 08/20] cciss: Handle cases when cciss_add_disk fails.
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       andrew.patterson@hp.com, mikem@beardog.cce.hp.com,
       scameron@beardog.cce.hp.com
Date: Thu, 17 Sep 2009 13:47:29 -0500
Message-ID: <20090917184729.15105.88712.stgit@beardog.cce.hp.com>
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle cases when cciss_add_disk fails.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |   35 +++++++++++++++++++++++++----------
 1 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 60fe3c6..7043b3b 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -199,6 +199,7 @@ static int scan_thread(void *data);
 static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c);
 static void cciss_hba_release(struct device *dev);
 static void cciss_device_release(struct device *dev);
+static void cciss_free_gendisk(ctlr_info_t *h, int drv_index);
 
 #ifdef CONFIG_PROC_FS
 static void cciss_procinit(int i);
@@ -1855,8 +1856,14 @@ static void cciss_update_drive_info(int ctlr, int drv_index, int first_time)
 	 * (raid_leve == -1) then we want to update the
 	 * logical drive's information.
 	 */
-	if (drv_index || first_time)
-		cciss_add_disk(h, disk, drv_index);
+	if (drv_index || first_time) {
+		if (cciss_add_disk(h, disk, drv_index) != 0) {
+			cciss_free_gendisk(h, drv_index);
+			printk(KERN_WARNING "cciss:%d could not update "
+				"disk %d\n", h->ctlr, drv_index);
+			--h->num_luns;
+		}
+	}
 
 freeret:
 	kfree(inq_buff);
@@ -1890,6 +1897,12 @@ static int cciss_find_free_drive_index(int ctlr, int controller_node)
 	return -1;
 }
 
+static void cciss_free_gendisk(ctlr_info_t *h, int drv_index)
+{
+	put_disk(h->gendisk[drv_index]);
+	h->gendisk[drv_index] = NULL;
+}
+
 /* cciss_add_gendisk finds a free hba[]->drv structure
  * and allocates a gendisk if needed, and sets the lunid
  * in the drvinfo structure.   It returns the index into
@@ -1930,8 +1943,7 @@ static int cciss_add_gendisk(ctlr_info_t *h, __u32 lunid, int controller_node)
 	return drv_index;
 
 err_free_disk:
-	put_disk(h->gendisk[drv_index]);
-	h->gendisk[drv_index] = NULL;
+	cciss_free_gendisk(h, drv_index);
 	return -1;
 }
 
@@ -1949,11 +1961,8 @@ static void cciss_add_controller_node(ctlr_info_t *h)
 		return;
 
 	drv_index = cciss_add_gendisk(h, 0, 1);
-	if (drv_index == -1) {
-		printk(KERN_WARNING "cciss%d: could not "
-			"add disk 0.\n", h->ctlr);
-		return;
-	}
+	if (drv_index == -1)
+		goto error;
 	h->drv[drv_index].block_size = 512;
 	h->drv[drv_index].nr_blocks = 0;
 	h->drv[drv_index].heads = 0;
@@ -1962,7 +1971,13 @@ static void cciss_add_controller_node(ctlr_info_t *h)
 	h->drv[drv_index].raid_level = -1;
 	memset(h->drv[drv_index].serial_no, 0, 16);
 	disk = h->gendisk[drv_index];
-	cciss_add_disk(h, disk, drv_index);
+	if (cciss_add_disk(h, disk, drv_index) == 0)
+		return;
+	cciss_free_gendisk(h, drv_index);
+error:
+	printk(KERN_WARNING "cciss%d: could not "
+		"add disk 0.\n", h->ctlr);
+	return;
 }
 
 /* This function will add and remove logical drives from the Logical

