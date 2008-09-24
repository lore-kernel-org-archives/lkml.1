Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbYIXTht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbYIXTht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYIXThl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:37:41 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:21738 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYIXThl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:37:41 -0400
Message-ID: <48DA9702.4020106@mvista.com>
Date: Wed, 24 Sep 2008 12:37:38 -0700
From: Drew Moseley <dmoseley@mvista.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: ambx1@neo.rr.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Create PNP device attributes via dev_attrs field of struct
 device
References: <48D95EA2.9040804@mvista.com>	 <3ae72650809232159k20f19f2ele5acbc7ee77dfb65@mail.gmail.com>	 <48DA774A.9010206@mvista.com> <3ae72650809241203o41b62a10m31377887d44fd05e@mail.gmail.com>
In-Reply-To: <3ae72650809241203o41b62a10m31377887d44fd05e@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> Yeah, it looks weird to mangle the bus_type values from a device
> routine, and set the same value again and again with every device
> creation. Just declare the array non-static, if moving the code around
> between files does not allow a static declaration.

Updated patch.

Drew

Signed-off-by: Drew Moseley <dmoseley@mvista.com>
Index: linux-2.6.21/drivers/pnp/base.h
===================================================================
--- linux-2.6.21.orig/drivers/pnp/base.h
+++ linux-2.6.21/drivers/pnp/base.h
@@ -1,6 +1,5 @@
 extern spinlock_t pnp_lock;
 void *pnp_alloc(long size);
-int pnp_interface_attach_device(struct pnp_dev *dev);
 void pnp_fixup_device(struct pnp_dev *dev);
 void pnp_free_option(struct pnp_option *option);
 int __pnp_add_device(struct pnp_dev *dev);
Index: linux-2.6.21/drivers/pnp/core.c
===================================================================
--- linux-2.6.21.orig/drivers/pnp/core.c
+++ linux-2.6.21/drivers/pnp/core.c
@@ -111,7 +111,6 @@ static void pnp_release_device(struct de

 int __pnp_add_device(struct pnp_dev *dev)
 {
-	int ret;
 	pnp_fixup_device(dev);
 	dev->dev.bus = &pnp_bus_type;
 	dev->dev.release = &pnp_release_device;
@@ -120,11 +119,7 @@ int __pnp_add_device(struct pnp_dev *dev
 	list_add_tail(&dev->global_list, &pnp_global);
 	list_add_tail(&dev->protocol_list, &dev->protocol->devices);
 	spin_unlock(&pnp_lock);
-
-	ret = device_register(&dev->dev);
-	if (ret == 0)
-		pnp_interface_attach_device(dev);
-	return ret;
+	return device_register(&dev->dev);
 }

 /*
Index: linux-2.6.21/drivers/pnp/interface.c
===================================================================
--- linux-2.6.21.orig/drivers/pnp/interface.c
+++ linux-2.6.21/drivers/pnp/interface.c
@@ -233,9 +233,6 @@ static ssize_t pnp_show_options(struct d
 	return ret;
 }

-static DEVICE_ATTR(options,S_IRUGO,pnp_show_options,NULL);
-
-
 static ssize_t pnp_show_current_resources(struct device *dmdev, struct
device_attribute *attr, char *buf)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
@@ -441,9 +438,6 @@ pnp_set_current_resources(struct device
 	return count;
 }

-static DEVICE_ATTR(resources,S_IRUGO | S_IWUSR,
-		   pnp_show_current_resources,pnp_set_current_resources);
-
 static ssize_t pnp_show_current_ids(struct device *dmdev, struct
device_attribute *attr, char *buf)
 {
 	char *str = buf;
@@ -457,23 +451,11 @@ static ssize_t pnp_show_current_ids(stru
 	return (str - buf);
 }

-static DEVICE_ATTR(id,S_IRUGO,pnp_show_current_ids,NULL);
-
-int pnp_interface_attach_device(struct pnp_dev *dev)
-{
-	int rc = device_create_file(&dev->dev,&dev_attr_options);
-	if (rc) goto err;
-	rc = device_create_file(&dev->dev,&dev_attr_resources);
-	if (rc) goto err_opt;
-	rc = device_create_file(&dev->dev,&dev_attr_id);
-	if (rc) goto err_res;
-
-	return 0;
-
-err_res:
-	device_remove_file(&dev->dev,&dev_attr_resources);
-err_opt:
-	device_remove_file(&dev->dev,&dev_attr_options);
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
Index: linux-2.6.21/drivers/pnp/driver.c
===================================================================
--- linux-2.6.21.orig/drivers/pnp/driver.c
+++ linux-2.6.21/drivers/pnp/driver.c
@@ -191,6 +191,7 @@ static int pnp_bus_resume(struct device
 	return 0;
 }

+extern struct device_attribute pnp_interface_attrs[];
 struct bus_type pnp_bus_type = {
 	.name	= "pnp",
 	.match	= pnp_bus_match,
@@ -198,6 +199,7 @@ struct bus_type pnp_bus_type = {
 	.remove	= pnp_device_remove,
 	.suspend = pnp_bus_suspend,
 	.resume = pnp_bus_resume,
+	.dev_attrs = pnp_interface_attrs,
 };

 int pnp_register_driver(struct pnp_driver *drv)
