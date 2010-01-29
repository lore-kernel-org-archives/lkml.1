Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792Ab0A2Vqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0A2Vqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 16:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635Ab0A2VpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 16:45:25 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:8342 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab0A2VpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 16:45:20 -0500
Subject: [PATCH 3/7] IB/uverbs: use stack variable 'devnum' in
	ib_uverbs_add_one
To: rdreier@cisco.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 14:45:13 -0700
Message-ID: <20100129214512.17745.21978.stgit@bob.kio>
In-Reply-To: <20100129214039.17745.38679.stgit@bob.kio>
References: <20100129214039.17745.38679.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is not useful by itself, but it sets us up for a future
change that allows us to dynamically allocate device numbers in case
we have more than IB_UVERBS_MAX_DEVICES in the system.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/uverbs_main.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 3f11292..acae9ed 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -730,6 +730,7 @@ static CLASS_ATTR(abi_version, S_IRUGO, show_abi_version, NULL);
 
 static void ib_uverbs_add_one(struct ib_device *device)
 {
+	int devnum;
 	struct ib_uverbs_device *uverbs_dev;
 
 	if (!device->alloc_ucontext)
@@ -743,12 +744,13 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	init_completion(&uverbs_dev->comp);
 
 	spin_lock(&map_lock);
-	uverbs_dev->devnum = find_first_zero_bit(dev_map, IB_UVERBS_MAX_DEVICES);
-	if (uverbs_dev->devnum >= IB_UVERBS_MAX_DEVICES) {
+	devnum = find_first_zero_bit(dev_map, IB_UVERBS_MAX_DEVICES);
+	if (devnum >= IB_UVERBS_MAX_DEVICES) {
 		spin_unlock(&map_lock);
 		goto err;
 	}
-	set_bit(uverbs_dev->devnum, dev_map);
+	uverbs_dev->devnum = devnum;
+	set_bit(devnum, dev_map);
 	spin_unlock(&map_lock);
 
 	uverbs_dev->ib_dev           = device;
@@ -758,7 +760,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	uverbs_dev->cdev.owner = THIS_MODULE;
 	uverbs_dev->cdev.ops = device->mmap ? &uverbs_mmap_fops : &uverbs_fops;
 	kobject_set_name(&uverbs_dev->cdev.kobj, "uverbs%d", uverbs_dev->devnum);
-	if (cdev_add(&uverbs_dev->cdev, IB_UVERBS_BASE_DEV + uverbs_dev->devnum, 1))
+	if (cdev_add(&uverbs_dev->cdev, IB_UVERBS_BASE_DEV + devnum, 1))
 		goto err_cdev;
 
 	uverbs_dev->dev = device_create(uverbs_class, device->dma_device,
@@ -781,7 +783,7 @@ err_class:
 
 err_cdev:
 	cdev_del(&uverbs_dev->cdev);
-	clear_bit(uverbs_dev->devnum, dev_map);
+	clear_bit(devnum, dev_map);
 
 err:
 	kref_put(&uverbs_dev->ref, ib_uverbs_release_dev);

