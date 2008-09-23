Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYIWVZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYIWVZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYIWVYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:24:52 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:11565 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbYIWVYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:24:51 -0400
Message-ID: <48D95EA2.9040804@mvista.com>
Date: Tue, 23 Sep 2008 14:24:50 -0700
From: Drew Moseley <dmoseley@mvista.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: ambx1@neo.rr.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Create PNP device attributes via dev_attrs field of struct
 device
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have seen an issue where the sysfs entries for a PNP device are
created nonatomically resulting in a race condition with freedesktop
HAL.  The patch below is my first attempt at addressing this by creating
the device attributes as default bus attributes and allowing the
device_register() call to create them.  Any nasty side effects I am not
addressing?  Comments?

Regards,
Drew Moseley


Signed-off-by: Drew Moseley <dmoseley@mvista.com>
diff --git a/drivers/pnp/base.h b/drivers/pnp/base.h
index 9fd7bb9..b07787f 100644
--- a/drivers/pnp/base.h
+++ b/drivers/pnp/base.h
@@ -16,7 +16,7 @@ struct pnp_card *pnp_alloc_card(struct pnp_protocol *,
int id, char *pnpid);

 int pnp_add_device(struct pnp_dev *dev);
 struct pnp_id *pnp_add_id(struct pnp_dev *dev, char *id);
-int pnp_interface_attach_device(struct pnp_dev *dev);
+void pnp_interface_attach_device(struct pnp_dev *dev);

 int pnp_add_card(struct pnp_card *card);
 void pnp_remove_card(struct pnp_card *card);
diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
index a411582..bcd49ba 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -159,8 +159,6 @@ struct pnp_dev *pnp_alloc_dev(struct pnp_protocol
*protocol, int id, char *pnpid

 int __pnp_add_device(struct pnp_dev *dev)
 {
-	int ret;
-
 	pnp_fixup_device(dev);
 	dev->status = PNP_READY;
 	spin_lock(&pnp_lock);
@@ -168,12 +166,8 @@ int __pnp_add_device(struct pnp_dev *dev)
 	list_add_tail(&dev->protocol_list, &dev->protocol->devices);
 	spin_unlock(&pnp_lock);

-	ret = device_register(&dev->dev);
-	if (ret)
-		return ret;
-
 	pnp_interface_attach_device(dev);
-	return 0;
+	return device_register(&dev->dev);
 }

 /*
diff --git a/drivers/pnp/interface.c b/drivers/pnp/interface.c
index a876ecf..442684d 100644
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
@@ -437,27 +432,16 @@ static ssize_t pnp_show_current_ids(struct device
*dmdev,
 	return (str - buf);
 }

-static DEVICE_ATTR(id, S_IRUGO, pnp_show_current_ids, NULL);
+static struct device_attribute pnp_interface_attrs[] = {
+	__ATTR(resources, S_IRUGO | S_IWUSR,
+		   pnp_show_current_resources,
+		   pnp_set_current_resources),
+	__ATTR(options, S_IRUGO, pnp_show_options, NULL),
+	__ATTR(id, S_IRUGO, pnp_show_current_ids, NULL),
+	__ATTR_NULL,
+};

-int pnp_interface_attach_device(struct pnp_dev *dev)
+void pnp_interface_attach_device(struct pnp_dev *dev)
 {
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
+	dev->dev.bus->dev_attrs = pnp_interface_attrs;
 }
