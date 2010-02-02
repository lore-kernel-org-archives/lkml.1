Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab0BBTKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:10:33 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:16855 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226Ab0BBTJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:09:07 -0500
Subject: [PATCH v2 16/18] IB/ucm: increase maximum devices supported
To: rdreier@cisco.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Feb 2010 12:09:06 -0700
Message-ID: <20100202190905.28217.97347.stgit@bob.kio>
In-Reply-To: <20100202185235.28217.64521.stgit@bob.kio>
References: <20100202185235.28217.64521.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some large systems may support more than IB_UCM_MAX_DEVICES
(currently 32).

This change allows us to support more devices in a backwards-compatible
manner. the first IB_UCM_MAX_DEVICES keep the same major/minor device
numbers they've always had.

If there are more than IB_UCM_MAX_DEVICES, then we dynamically request
a new major device number (new minors start at 0).

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/ucm.c |   53 +++++++++++++++++++++++++++++++++++------
 1 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 06c50d8..1203ca4 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1215,7 +1215,10 @@ static void ib_ucm_release_dev(struct device *dev)
 
 	ucm_dev = container_of(dev, struct ib_ucm_device, dev);
 	cdev_del(&ucm_dev->cdev);
-	clear_bit(ucm_dev->devnum, dev_map);
+	if (ucm_dev->devnum < IB_UCM_MAX_DEVICES)
+		clear_bit(ucm_dev->devnum, dev_map);
+	else
+		clear_bit(ucm_dev->devnum - IB_UCM_MAX_DEVICES, dev_map);
 	kfree(ucm_dev);
 }
 
@@ -1237,6 +1240,28 @@ static ssize_t show_ibdev(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR(ibdev, S_IRUGO, show_ibdev, NULL);
 
+static dev_t oflo_maj;
+static DECLARE_BITMAP(oflo_map, IB_UCM_MAX_DEVICES);
+static int find_oflo_devnum(void)
+{
+	int ret;
+
+	if (!oflo_maj) {
+		ret = alloc_chrdev_region(&oflo_maj, 0, IB_UCM_MAX_DEVICES,
+					  "infiniband_cm");
+		if (ret) {
+			printk(KERN_ERR "ucm: couldn't register dynamic device number\n");
+			return ret;
+		}
+	}
+
+	ret = find_first_zero_bit(oflo_map, IB_UCM_MAX_DEVICES);
+	if (ret >= IB_UCM_MAX_DEVICES)
+		return -1;
+
+	return ret;
+}
+
 static void ib_ucm_add_one(struct ib_device *device)
 {
 	int devnum;
@@ -1254,12 +1279,19 @@ static void ib_ucm_add_one(struct ib_device *device)
 	ucm_dev->ib_dev = device;
 
 	devnum = find_first_zero_bit(dev_map, IB_UCM_MAX_DEVICES);
-	if (devnum >= IB_UCM_MAX_DEVICES)
-		goto err;
-
-	ucm_dev->devnum = devnum;
-	base = devnum + IB_UCM_BASE_DEV;
-	set_bit(devnum, dev_map);
+	if (devnum >= IB_UCM_MAX_DEVICES) {
+		devnum = find_oflo_devnum();
+		if (devnum < 0)
+			goto err;
+
+		ucm_dev->devnum = devnum + IB_UCM_MAX_DEVICES;
+		base = devnum + oflo_maj;
+		set_bit(devnum, oflo_map);
+	} else {
+		ucm_dev->devnum = devnum;
+		base = devnum + IB_UCM_BASE_DEV;
+		set_bit(devnum, dev_map);
+	}
 
 	cdev_init(&ucm_dev->cdev, &ucm_fops);
 	ucm_dev->cdev.owner = THIS_MODULE;
@@ -1285,7 +1317,10 @@ err_dev:
 	device_unregister(&ucm_dev->dev);
 err_cdev:
 	cdev_del(&ucm_dev->cdev);
-	clear_bit(devnum, dev_map);
+	if (ucm_dev->devnum < IB_UCM_MAX_DEVICES)
+		clear_bit(devnum, dev_map);
+	else
+		clear_bit(devnum, oflo_map);
 err:
 	kfree(ucm_dev);
 	return;
@@ -1344,6 +1379,8 @@ static void __exit ib_ucm_cleanup(void)
 	ib_unregister_client(&ucm_client);
 	class_remove_file(&cm_class, &class_attr_abi_version);
 	unregister_chrdev_region(IB_UCM_BASE_DEV, IB_UCM_MAX_DEVICES);
+	if (oflo_maj)
+		unregister_chrdev_region(oflo_maj, IB_UCM_MAX_DEVICES);
 	idr_destroy(&ctx_id_table);
 }
 

