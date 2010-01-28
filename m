Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577Ab0A1Pq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab0A1Pq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 10:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800Ab0A1Pq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 10:46:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:61828 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab0A1PqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 10:46:25 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] Return proper error code on device create failure
Date: Thu, 28 Jan 2010 21:13:40 +0530
Message-Id: <1264693423-2694-5-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1264693423-2694-1-git-send-email-ngupta@vflare.org>
References: <1264693423-2694-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we return 0 if create_device() fails and 1 otherwise.
Now, proper error code is returned from create_device() and the
same is propagated as module error code from ramzswap_init().

Also added some cleanups for ramzswap_init(), improving function
structure.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/ramzswap/ramzswap_drv.c |   44 +++++++++++++++++++-----------
 1 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/ramzswap/ramzswap_drv.c
index 2021ad6..3035add 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/ramzswap/ramzswap_drv.c
@@ -1300,6 +1300,8 @@ static struct block_device_operations ramzswap_devops = {
 
 static int create_device(struct ramzswap *rzs, int device_id)
 {
+	int ret = 0;
+
 	mutex_init(&rzs->lock);
 	spin_lock_init(&rzs->stat64_lock);
 	INIT_LIST_HEAD(&rzs->backing_swap_extent_list);
@@ -1308,7 +1310,8 @@ static int create_device(struct ramzswap *rzs, int device_id)
 	if (!rzs->queue) {
 		pr_err("Error allocating disk queue for device %d\n",
 			device_id);
-		return 0;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	blk_queue_make_request(rzs->queue, ramzswap_make_request);
@@ -1320,7 +1323,8 @@ static int create_device(struct ramzswap *rzs, int device_id)
 		blk_cleanup_queue(rzs->queue);
 		pr_warning("Error allocating disk structure for device %d\n",
 			device_id);
-		return 0;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	rzs->disk->major = ramzswap_major;
@@ -1342,7 +1346,9 @@ static int create_device(struct ramzswap *rzs, int device_id)
 	add_disk(rzs->disk);
 
 	rzs->init_done = 0;
-	return 1;
+
+out:
+	return ret;
 }
 
 static void destroy_device(struct ramzswap *rzs)
@@ -1358,18 +1364,20 @@ static void destroy_device(struct ramzswap *rzs)
 
 static int __init ramzswap_init(void)
 {
-	int i, ret;
+	int ret, dev_id;
 
 	if (num_devices > max_num_devices) {
 		pr_warning("Invalid value for num_devices: %u\n",
 				num_devices);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	ramzswap_major = register_blkdev(0, "ramzswap");
 	if (ramzswap_major <= 0) {
 		pr_warning("Unable to get major number\n");
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out;
 	}
 
 	if (!num_devices) {
@@ -1380,21 +1388,25 @@ static int __init ramzswap_init(void)
 	/* Allocate the device array and initialize each one */
 	pr_info("Creating %u devices ...\n", num_devices);
 	devices = kzalloc(num_devices * sizeof(struct ramzswap), GFP_KERNEL);
-	if (!devices)
-		goto out;
+	if (!devices) {
+		ret = -ENOMEM;
+		goto unregister;
+	}
 
-	for (i = 0; i < num_devices; i++)
-		if (!create_device(&devices[i], i)) {
-			ret = i;
+	for (dev_id = 0; dev_id < num_devices; dev_id++) {
+		ret = create_device(&devices[dev_id], dev_id);
+		if (ret)
 			goto free_devices;
-		}
+	}
+
 	return 0;
+
 free_devices:
-	for (i = 0; i < ret; i++)
-		destroy_device(&devices[i]);
-out:
-	ret = -ENOMEM;
+	while (dev_id)
+		destroy_device(&devices[--dev_id]);
+unregister:
 	unregister_blkdev(ramzswap_major, "ramzswap");
+out:
 	return ret;
 }
 
-- 
1.6.2.5

