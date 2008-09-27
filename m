Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYI0XcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYI0XcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 19:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYI0XcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 19:32:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50832 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbYI0XcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 19:32:07 -0400
Subject: Re: [PATCH] Create PNP device attributes via dev_attrs field of
	struct device
From: Kay Sievers <kay.sievers@vrfy.org>
To: Drew Moseley <dmoseley@mvista.com>
Cc: ambx1@neo.rr.com, linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
In-Reply-To: <48DBBF6C.5070703@mvista.com>
References: <48D95EA2.9040804@mvista.com>
	 <3ae72650809232159k20f19f2ele5acbc7ee77dfb65@mail.gmail.com>
	 <48DA774A.9010206@mvista.com>
	 <3ae72650809241203o41b62a10m31377887d44fd05e@mail.gmail.com>
	 <48DA9702.4020106@mvista.com>
	 <3ae72650809250313h66b35a73u8c73ffce5b74921e@mail.gmail.com>
	 <48DBBF6C.5070703@mvista.com>
Content-Type: text/plain
Date: Sun, 28 Sep 2008 01:31:35 +0200
Message-Id: <1222558295.2696.4.camel@lgn.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18JKXc7DTudbO9f5nr7nD9OYYbw2bvAD9AeNmq
 E1GBXc+v3mWkl6nKyTEDhlHb4PcA78ngIFAYLRQPKwMPpoLF9P
 WShCCl0VA702EL+EnbnJQucb2lhxDxC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-25 at 09:42 -0700, Drew Moseley wrote:
> Kay Sievers wrote:
> > This seems not to apply. Oh, you are patching a 1.5 years old kernel?
> > :) Care to redo this for a recent one?
> 
> Ack.  Sorry about that.  Wrong tree.  Here's the right one. ;-)

Looks good to me, and seems to work fine here. Thanks for the patch.

Greg, can you pick up the patch below?

Thanks,
Kay


From: Drew Moseley <dmoseley@mvista.com>
Subject: PNP: create device attributes via default device attributes

This creates the attributes before the uevent is sent.

Signed-off-by: Drew Moseley <dmoseley@mvista.com>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
---

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


