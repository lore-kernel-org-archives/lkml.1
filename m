Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZHTPUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZHTPUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 11:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZHTPUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 11:20:39 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:49035 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbZHTPS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:18:26 -0400
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [cciss: PATCH 09/17] Handle special case for sysfs attributes of the
	first logical drive.
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, axboe@kernel.dk,
       andrew.patterson@hp.com, mikem@c18-ss-1-lb.cnet.com,
       scameron@beardog.cce.hp.com
Date: Thu, 20 Aug 2009 10:18:28 -0500
Message-ID: <20090820151828.22833.68284.stgit@beardog.cce.hp.com>
In-Reply-To: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
References: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For c0dx where x is not 0, we handle deletion and addition simply,
but for c0d0, there is the special case that even when there's no
disk, the device node exists so that the controller may be accessed.
So, for c0d0, we only create the sysfs entries once, when a controller
is added, and only remove them once, when a controller is being
taken down.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 7043b3b..98d8efe 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -681,6 +681,10 @@ static long cciss_create_ld_sysfs_entry(struct ctlr_info *h,
 {
 	struct device *dev;
 
+	/* Special case for c*d0, we only create it once. */
+	if (drv_index == 0 && h->drv[drv_index].dev != NULL)
+		return 0;
+
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
@@ -697,9 +701,15 @@ static long cciss_create_ld_sysfs_entry(struct ctlr_info *h,
 /*
  * Remove sysfs entries for a logical drive.
  */
-static void cciss_destroy_ld_sysfs_entry(struct ctlr_info *h, int drv_index)
+static void cciss_destroy_ld_sysfs_entry(struct ctlr_info *h, int drv_index,
+	int ctlr_exiting)
 {
 	struct device *dev = h->drv[drv_index].dev;
+
+	/* special case for c*d0, we only destroy it on controller exit */
+	if (drv_index == 0 && !ctlr_exiting)
+		return;
+
 	device_del(dev);
 	put_device(dev); /* the "final" put. */
 	h->drv[drv_index].dev = NULL;
@@ -1919,6 +1929,7 @@ static int cciss_add_gendisk(ctlr_info_t *h, __u32 lunid, int controller_node)
 	drv_index = cciss_find_free_drive_index(h->ctlr, controller_node);
 	if (drv_index == -1)
 		return -1;
+
 	/*Check if the gendisk needs to be allocated */
 	if (!h->gendisk[drv_index]) {
 		h->gendisk[drv_index] =
@@ -2164,7 +2175,7 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 	if (h->gendisk[0] != disk) {
 		struct request_queue *q = disk->queue;
 		if (disk->flags & GENHD_FL_UP) {
-			cciss_destroy_ld_sysfs_entry(h, drv_index);
+			cciss_destroy_ld_sysfs_entry(h, drv_index, 0);
 			del_gendisk(disk);
 		}
 		if (q) {
@@ -2210,7 +2221,6 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 				 * indicate that this element of the drive
 				 * array is free.
 				 */
-
 	if (clear_all) {
 		/* check to see if it was the last disk */
 		if (drv == h->drv + h->highest_lun) {
@@ -4328,7 +4338,7 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 			struct request_queue *q = disk->queue;
 
 			if (disk->flags & GENHD_FL_UP) {
-				cciss_destroy_ld_sysfs_entry(hba[i], j);
+				cciss_destroy_ld_sysfs_entry(hba[i], j, 1);
 				del_gendisk(disk);
 			}
 			if (q)

