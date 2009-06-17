Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZFQBqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZFQBqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 21:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZFQBp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 21:45:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:36653 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZFQBpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 21:45:55 -0400
Subject: [PATCH] driver/core: Fix various warnings due to dev_set_name()
 usage
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Jun 2009 11:45:50 +1000
Message-Id: <1245203150.21602.10.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc is too smart, we get:

drivers/base/core.c: In function ‘device_add’:
drivers/base/core.c:877: warning: format not a string literal and no format arguments
drivers/base/core.c: In function ‘__root_device_register’:
drivers/base/core.c:1274: warning: format not a string literal and no format arguments

With 4.3.3 and later. This fixes a bunch of them in drivers/base

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

There's still more of these elsewhere in the tree and I may send
patches to fix them some day but for now, this takes care of the
driver core.

Index: linux-work/drivers/base/core.c
===================================================================
--- linux-work.orig/drivers/base/core.c	2009-06-17 11:40:09.000000000 +1000
+++ linux-work/drivers/base/core.c	2009-06-17 11:40:27.000000000 +1000
@@ -874,7 +874,7 @@ int device_add(struct device *dev)
 	 * the name, and force the use of dev_name()
 	 */
 	if (dev->init_name) {
-		dev_set_name(dev, dev->init_name);
+		dev_set_name(dev, "%s", dev->init_name);
 		dev->init_name = NULL;
 	}
 
@@ -1271,7 +1271,7 @@ struct device *__root_device_register(co
 	if (!root)
 		return ERR_PTR(err);
 
-	err = dev_set_name(&root->dev, name);
+	err = dev_set_name(&root->dev, "%s", name);
 	if (err) {
 		kfree(root);
 		return ERR_PTR(err);
Index: linux-work/drivers/base/sys.c
===================================================================
--- linux-work.orig/drivers/base/sys.c	2009-06-17 11:40:39.000000000 +1000
+++ linux-work/drivers/base/sys.c	2009-06-17 11:40:41.000000000 +1000
@@ -138,7 +138,7 @@ int sysdev_class_register(struct sysdev_
 	cls->kset.kobj.parent = &system_kset->kobj;
 	cls->kset.kobj.ktype = &ktype_sysdev_class;
 	cls->kset.kobj.kset = system_kset;
-	kobject_set_name(&cls->kset.kobj, cls->name);
+	kobject_set_name(&cls->kset.kobj, "%s", cls->name);
 	return kset_register(&cls->kset);
 }
 
Index: linux-work/drivers/base/attribute_container.c
===================================================================
--- linux-work.orig/drivers/base/attribute_container.c	2009-06-17 11:43:19.000000000 +1000
+++ linux-work/drivers/base/attribute_container.c	2009-06-17 11:43:22.000000000 +1000
@@ -167,7 +167,7 @@ attribute_container_add_device(struct de
 		ic->classdev.parent = get_device(dev);
 		ic->classdev.class = cont->class;
 		cont->class->dev_release = attribute_container_release;
-		dev_set_name(&ic->classdev, dev_name(dev));
+		dev_set_name(&ic->classdev, "%s", dev_name(dev));
 		if (fn)
 			fn(cont, dev, &ic->classdev);
 		else
Index: linux-work/drivers/base/firmware_class.c
===================================================================
--- linux-work.orig/drivers/base/firmware_class.c	2009-06-17 11:43:33.000000000 +1000
+++ linux-work/drivers/base/firmware_class.c	2009-06-17 11:43:38.000000000 +1000
@@ -392,7 +392,7 @@ static int fw_register_device(struct dev
 	fw_priv->timeout.data = (u_long) fw_priv;
 	init_timer(&fw_priv->timeout);
 
-	dev_set_name(f_dev, dev_name(device));
+	dev_set_name(f_dev, "%s", dev_name(device));
 	f_dev->parent = device;
 	f_dev->class = &firmware_class;
 	dev_set_drvdata(f_dev, fw_priv);
Index: linux-work/drivers/base/platform.c
===================================================================
--- linux-work.orig/drivers/base/platform.c	2009-06-17 11:43:00.000000000 +1000
+++ linux-work/drivers/base/platform.c	2009-06-17 11:43:02.000000000 +1000
@@ -244,7 +244,7 @@ int platform_device_add(struct platform_
 	if (pdev->id != -1)
 		dev_set_name(&pdev->dev, "%s.%d", pdev->name,  pdev->id);
 	else
-		dev_set_name(&pdev->dev, pdev->name);
+		dev_set_name(&pdev->dev, "%s", pdev->name);
 
 	for (i = 0; i < pdev->num_resources; i++) {
 		struct resource *p, *r = &pdev->resource[i];


