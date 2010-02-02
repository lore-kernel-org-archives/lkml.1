Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab0BBTJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:09:05 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:43237 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226Ab0BBTI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:08:56 -0500
Subject: [PATCH v2 14/18] IB/ucm: use stack variable 'devnum' in ib_ucm_add_one
To: rdreier@cisco.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Feb 2010 12:08:55 -0700
Message-ID: <20100202190855.28217.68785.stgit@bob.kio>
In-Reply-To: <20100202185235.28217.64521.stgit@bob.kio>
References: <20100202185235.28217.64521.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is not useful by itself, but sets us up for a future
change that allows us to dynamically allocate device numbers in case
we have more than IB_UCM_MAX_DEVICES in the system.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/ucm.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index f504c9b..7ff3300 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1239,6 +1239,7 @@ static DEVICE_ATTR(ibdev, S_IRUGO, show_ibdev, NULL);
 
 static void ib_ucm_add_one(struct ib_device *device)
 {
+	int devnum;
 	struct ib_ucm_device *ucm_dev;
 
 	if (!device->alloc_ucontext ||
@@ -1251,16 +1252,17 @@ static void ib_ucm_add_one(struct ib_device *device)
 
 	ucm_dev->ib_dev = device;
 
-	ucm_dev->devnum = find_first_zero_bit(dev_map, IB_UCM_MAX_DEVICES);
-	if (ucm_dev->devnum >= IB_UCM_MAX_DEVICES)
+	devnum = find_first_zero_bit(dev_map, IB_UCM_MAX_DEVICES);
+	if (devnum >= IB_UCM_MAX_DEVICES)
 		goto err;
 
-	set_bit(ucm_dev->devnum, dev_map);
+	ucm_dev->devnum = devnum;
+	set_bit(devnum, dev_map);
 
 	cdev_init(&ucm_dev->cdev, &ucm_fops);
 	ucm_dev->cdev.owner = THIS_MODULE;
 	kobject_set_name(&ucm_dev->cdev.kobj, "ucm%d", ucm_dev->devnum);
-	if (cdev_add(&ucm_dev->cdev, IB_UCM_BASE_DEV + ucm_dev->devnum, 1))
+	if (cdev_add(&ucm_dev->cdev, IB_UCM_BASE_DEV + devnum, 1))
 		goto err;
 
 	ucm_dev->dev.class = &cm_class;
@@ -1281,7 +1283,7 @@ err_dev:
 	device_unregister(&ucm_dev->dev);
 err_cdev:
 	cdev_del(&ucm_dev->cdev);
-	clear_bit(ucm_dev->devnum, dev_map);
+	clear_bit(devnum, dev_map);
 err:
 	kfree(ucm_dev);
 	return;

