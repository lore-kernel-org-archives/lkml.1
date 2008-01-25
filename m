Return-Path: <linux-kernel-owner+w=401wt.eu-S1765794AbYAYIUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765794AbYAYIUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763471AbYAYIAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:53 -0500
Received: from ns2.suse.de ([195.135.220.15]:53689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759085AbYAYH7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:53 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 144/196] PCI: remove foolish code from pci-driver.c
Date: Thu, 24 Jan 2008 23:32:53 -0800
Message-Id: <1201246425-5058-65-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI bus should not be trying to declare its own attribute type.
Especially as this code could never ever be called because the driver
core overwrites the driver kobject type to be its own internal type.
Delete all of this code as it was never being used and is not correct.

Also update my copyright on the file while I'm touching things there.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/pci-driver.c |   50 ++++-----------------------------------------
 1 files changed, 5 insertions(+), 45 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 73e3629..c4fa35d 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1,6 +1,11 @@
 /*
  * drivers/pci/pci-driver.c
  *
+ * (C) Copyright 2002-2004, 2007 Greg Kroah-Hartman <greg@kroah.com>
+ * (C) Copyright 2007 Novell Inc.
+ *
+ * Released under the GPL v2 only.
+ *
  */
 
 #include <linux/pci.h>
@@ -356,50 +361,6 @@ static void pci_device_shutdown(struct device *dev)
 		drv->shutdown(pci_dev);
 }
 
-#define kobj_to_pci_driver(obj) container_of(obj, struct device_driver, kobj)
-#define attr_to_driver_attribute(obj) container_of(obj, struct driver_attribute, attr)
-
-static ssize_t
-pci_driver_attr_show(struct kobject * kobj, struct attribute *attr, char *buf)
-{
-	struct device_driver *driver = kobj_to_pci_driver(kobj);
-	struct driver_attribute *dattr = attr_to_driver_attribute(attr);
-	ssize_t ret;
-
-	if (!get_driver(driver))
-		return -ENODEV;
-
-	ret = dattr->show ? dattr->show(driver, buf) : -EIO;
-
-	put_driver(driver);
-	return ret;
-}
-
-static ssize_t
-pci_driver_attr_store(struct kobject * kobj, struct attribute *attr,
-		      const char *buf, size_t count)
-{
-	struct device_driver *driver = kobj_to_pci_driver(kobj);
-	struct driver_attribute *dattr = attr_to_driver_attribute(attr);
-	ssize_t ret;
-
-	if (!get_driver(driver))
-		return -ENODEV;
-
-	ret = dattr->store ? dattr->store(driver, buf, count) : -EIO;
-
-	put_driver(driver);
-	return ret;
-}
-
-static struct sysfs_ops pci_driver_sysfs_ops = {
-	.show = pci_driver_attr_show,
-	.store = pci_driver_attr_store,
-};
-static struct kobj_type pci_driver_kobj_type = {
-	.sysfs_ops = &pci_driver_sysfs_ops,
-};
-
 /**
  * __pci_register_driver - register a new pci driver
  * @drv: the driver structure to register
@@ -421,7 +382,6 @@ int __pci_register_driver(struct pci_driver *drv, struct module *owner,
 	drv->driver.bus = &pci_bus_type;
 	drv->driver.owner = owner;
 	drv->driver.mod_name = mod_name;
-	drv->driver.kobj.ktype = &pci_driver_kobj_type;
 
 	spin_lock_init(&drv->dynids.lock);
 	INIT_LIST_HEAD(&drv->dynids.list);
-- 
1.5.3.8

