Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbYJPR2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbYJPR2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756461AbYJPRO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:56 -0400
Received: from kroah.org ([198.145.64.141]:47018 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756432AbYJPROy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:54 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Drew Moseley <dmoseley@mvista.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 35/46] PNP: create device attributes via default device attributes
Date: Thu, 16 Oct 2008 10:10:36 -0700
Message-Id: <1224177047-11859-35-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Drew Moseley <dmoseley@mvista.com>

This creates the attributes before the uevent is sent.

Signed-off-by: Drew Moseley <dmoseley@mvista.com>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pnp/base.h      |    2 +-
 drivers/pnp/core.c      |   10 +---------
 drivers/pnp/driver.c    |    1 +
 drivers/pnp/interface.c |   37 ++++++++-----------------------------
 4 files changed, 11 insertions(+), 39 deletions(-)

diff --git a/drivers/pnp/base.h b/drivers/pnp/base.h
index 9fd7bb9..3532984 100644
--- a/drivers/pnp/base.h
+++ b/drivers/pnp/base.h
@@ -4,6 +4,7 @@
  */
 
 extern spinlock_t pnp_lock;
+extern struct device_attribute pnp_interface_attrs[];
 void *pnp_alloc(long size);
 
 int pnp_register_protocol(struct pnp_protocol *protocol);
@@ -16,7 +17,6 @@ struct pnp_card *pnp_alloc_card(struct pnp_protocol *, int id, char *pnpid);
 
 int pnp_add_device(struct pnp_dev *dev);
 struct pnp_id *pnp_add_id(struct pnp_dev *dev, char *id);
-int pnp_interface_attach_device(struct pnp_dev *dev);
 
 int pnp_add_card(struct pnp_card *card);
 void pnp_remove_card(struct pnp_card *card);
diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
index a411582..7d65da8 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -159,21 +159,13 @@ struct pnp_dev *pnp_alloc_dev(struct pnp_protocol *protocol, int id, char *pnpid
 
 int __pnp_add_device(struct pnp_dev *dev)
 {
-	int ret;
-
 	pnp_fixup_device(dev);
 	dev->status = PNP_READY;
 	spin_lock(&pnp_lock);
 	list_add_tail(&dev->global_list, &pnp_global);
 	list_add_tail(&dev->protocol_list, &dev->protocol->devices);
 	spin_unlock(&pnp_lock);
-
-	ret = device_register(&dev->dev);
-	if (ret)
-		return ret;
-
-	pnp_interface_attach_device(dev);
-	return 0;
+	return device_register(&dev->dev);
 }
 
 /*
diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
index d3f869e..e3f7e89 100644
--- a/drivers/pnp/driver.c
+++ b/drivers/pnp/driver.c
@@ -206,6 +206,7 @@ struct bus_type pnp_bus_type = {
 	.remove  = pnp_device_remove,
 	.suspend = pnp_bus_suspend,
 	.resume  = pnp_bus_resume,
+	.dev_attrs = pnp_interface_attrs,
 };
 
 int pnp_register_driver(struct pnp_driver *drv)
diff --git a/drivers/pnp/interface.c b/drivers/pnp/interface.c
index a876ecf..478a4a7 100644
--- a/drivers/pnp/interface.c
+++ b/drivers/pnp/interface.c
@@ -243,8 +243,6 @@ static ssize_t pnp_show_options(struct device *dmdev,
 	return ret;
 }
 
-static DEVICE_ATTR(options, S_IRUGO, pnp_show_options, NULL);
-
 static ssize_t pnp_show_current_resources(struct device *dmdev,
 					  struct device_attribute *attr,
 					  char *buf)
@@ -420,9 +418,6 @@ done:
 	return count;
 }
 
-static DEVICE_ATTR(resources, S_IRUGO | S_IWUSR,
-		   pnp_show_current_resources, pnp_set_current_resources);
-
 static ssize_t pnp_show_current_ids(struct device *dmdev,
 				    struct device_attribute *attr, char *buf)
 {
@@ -437,27 +432,11 @@ static ssize_t pnp_show_current_ids(struct device *dmdev,
 	return (str - buf);
 }
 
-static DEVICE_ATTR(id, S_IRUGO, pnp_show_current_ids, NULL);
-
-int pnp_interface_attach_device(struct pnp_dev *dev)
-{
-	int rc = device_create_file(&dev->dev, &dev_attr_options);
-
-	if (rc)
-		goto err;
-	rc = device_create_file(&dev->dev, &dev_attr_resources);
-	if (rc)
-		goto err_opt;
-	rc = device_create_file(&dev->dev, &dev_attr_id);
-	if (rc)
-		goto err_res;
-
-	return 0;
-
-err_res:
-	device_remove_file(&dev->dev, &dev_attr_resources);
-err_opt:
-	device_remove_file(&dev->dev, &dev_attr_options);
-err:
-	return rc;
-}
+struct device_attribute pnp_interface_attrs[] = {
+	__ATTR(resources, S_IRUGO | S_IWUSR,
+		   pnp_show_current_resources,
+		   pnp_set_current_resources),
+	__ATTR(options, S_IRUGO, pnp_show_options, NULL),
+	__ATTR(id, S_IRUGO, pnp_show_current_ids, NULL),
+	__ATTR_NULL,
+};
-- 
1.6.0.2

