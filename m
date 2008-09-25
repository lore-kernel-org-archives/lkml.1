Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbYIYQmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbYIYQmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbYIYQmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:42:24 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:11083 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbYIYQmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:42:23 -0400
Message-ID: <48DBBF6C.5070703@mvista.com>
Date: Thu, 25 Sep 2008 09:42:20 -0700
From: Drew Moseley <dmoseley@mvista.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: ambx1@neo.rr.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Create PNP device attributes via dev_attrs field of struct
 device
References: <48D95EA2.9040804@mvista.com>	 <3ae72650809232159k20f19f2ele5acbc7ee77dfb65@mail.gmail.com>	 <48DA774A.9010206@mvista.com>	 <3ae72650809241203o41b62a10m31377887d44fd05e@mail.gmail.com>	 <48DA9702.4020106@mvista.com> <3ae72650809250313h66b35a73u8c73ffce5b74921e@mail.gmail.com>
In-Reply-To: <3ae72650809250313h66b35a73u8c73ffce5b74921e@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> This seems not to apply. Oh, you are patching a 1.5 years old kernel?
> :) Care to redo this for a recent one?

Ack.  Sorry about that.  Wrong tree.  Here's the right one. ;-)

Signed-off-by: Drew Moseley <dmoseley@mvista.com>
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
@@ -16,7 +17,6 @@ struct pnp_card *pnp_alloc_card(struct pnp_protocol *,
int id, char *pnpid);

 int pnp_add_device(struct pnp_dev *dev);
 struct pnp_id *pnp_add_id(struct pnp_dev *dev, char *id);
-int pnp_interface_attach_device(struct pnp_dev *dev);

 int pnp_add_card(struct pnp_card *card);
 void pnp_remove_card(struct pnp_card *card);
diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
index a411582..7d65da8 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -159,21 +159,13 @@ struct pnp_dev *pnp_alloc_dev(struct pnp_protocol
*protocol, int id, char *pnpid

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
@@ -437,27 +432,11 @@ static ssize_t pnp_show_current_ids(struct device
*dmdev,
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
