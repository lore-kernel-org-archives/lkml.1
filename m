Return-Path: <linux-kernel-owner+w=401wt.eu-S1764943AbYAYIMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764943AbYAYIMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761414AbYAYIAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763983AbYAYH7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:44 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Roland Dreier <rdreier@cisco.com>,
       "Bryan O'Sullivan" <bryan.osullivan@qlogic.com>,
       Arthur Jones <arthur.jones@qlogic.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [PATCH 148/196] Infiniband: make ipath driver use default driver groups.
Date: Thu, 24 Jan 2008 23:32:57 -0800
Message-Id: <1201246425-5058-69-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the ipath driver use the new driver functions so that it does not
touch the sysfs portion of the driver structure.

We also remove the redundant symlink from the device back to the driver,
as it is already in the sysfs tree.  Any userspace tools should be using
the standard symlink, not some driver specific one.

Cc: Roland Dreier <rdreier@cisco.com>
Cc: Bryan O'Sullivan <bryan.osullivan@qlogic.com>
Cc: Arthur Jones <arthur.jones@qlogic.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/infiniband/hw/ehca/ehca_main.c     |   13 +++++++----
 drivers/infiniband/hw/ipath/ipath_driver.c |   17 +++------------
 drivers/infiniband/hw/ipath/ipath_kernel.h |    3 +-
 drivers/infiniband/hw/ipath/ipath_sysfs.c  |   30 ++++-----------------------
 4 files changed, 18 insertions(+), 45 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 6a56d86..c9e32b4 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -590,6 +590,11 @@ static struct attribute_group ehca_drv_attr_grp = {
 	.attrs = ehca_drv_attrs
 };
 
+static struct attribute_group *ehca_drv_attr_groups[] = {
+	&ehca_drv_attr_grp,
+	NULL,
+};
+
 #define EHCA_RESOURCE_ATTR(name)                                           \
 static ssize_t  ehca_show_##name(struct device *dev,                       \
 				 struct device_attribute *attr,            \
@@ -899,6 +904,9 @@ static struct of_platform_driver ehca_driver = {
 	.match_table = ehca_device_table,
 	.probe       = ehca_probe,
 	.remove      = ehca_remove,
+	.driver	     = {
+		.groups = ehca_drv_attr_groups,
+	},
 };
 
 void ehca_poll_eqs(unsigned long data)
@@ -957,10 +965,6 @@ int __init ehca_module_init(void)
 		goto module_init2;
 	}
 
-	ret = sysfs_create_group(&ehca_driver.driver.kobj, &ehca_drv_attr_grp);
-	if (ret) /* only complain; we can live without attributes */
-		ehca_gen_err("Cannot create driver attributes  ret=%d", ret);
-
 	if (ehca_poll_all_eqs != 1) {
 		ehca_gen_err("WARNING!!!");
 		ehca_gen_err("It is possible to lose interrupts.");
@@ -986,7 +990,6 @@ void __exit ehca_module_exit(void)
 	if (ehca_poll_all_eqs == 1)
 		del_timer_sync(&poll_eqs_timer);
 
-	sysfs_remove_group(&ehca_driver.driver.kobj, &ehca_drv_attr_grp);
 	ibmebus_unregister_driver(&ehca_driver);
 
 	ehca_destroy_slab_caches();
diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index 1f152de..fc35598 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -121,6 +121,9 @@ static struct pci_driver ipath_driver = {
 	.probe = ipath_init_one,
 	.remove = __devexit_p(ipath_remove_one),
 	.id_table = ipath_pci_tbl,
+	.driver = {
+		.groups = ipath_driver_attr_groups,
+	},
 };
 
 static void ipath_check_status(struct work_struct *work)
@@ -2217,25 +2220,15 @@ static int __init infinipath_init(void)
 		goto bail_unit;
 	}
 
-	ret = ipath_driver_create_group(&ipath_driver.driver);
-	if (ret < 0) {
-		printk(KERN_ERR IPATH_DRV_NAME ": Unable to create driver "
-		       "sysfs entries: error %d\n", -ret);
-		goto bail_pci;
-	}
-
 	ret = ipath_init_ipathfs();
 	if (ret < 0) {
 		printk(KERN_ERR IPATH_DRV_NAME ": Unable to create "
 		       "ipathfs: error %d\n", -ret);
-		goto bail_group;
+		goto bail_pci;
 	}
 
 	goto bail;
 
-bail_group:
-	ipath_driver_remove_group(&ipath_driver.driver);
-
 bail_pci:
 	pci_unregister_driver(&ipath_driver);
 
@@ -2250,8 +2243,6 @@ static void __exit infinipath_cleanup(void)
 {
 	ipath_exit_ipathfs();
 
-	ipath_driver_remove_group(&ipath_driver.driver);
-
 	ipath_cdbg(VERBOSE, "Unregistering pci driver\n");
 	pci_unregister_driver(&ipath_driver);
 
diff --git a/drivers/infiniband/hw/ipath/ipath_kernel.h b/drivers/infiniband/hw/ipath/ipath_kernel.h
index 8786dd7..bb1dc07 100644
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h
@@ -938,8 +938,7 @@ struct device_driver;
 
 extern const char ib_ipath_version[];
 
-int ipath_driver_create_group(struct device_driver *);
-void ipath_driver_remove_group(struct device_driver *);
+extern struct attribute_group *ipath_driver_attr_groups[];
 
 int ipath_device_create_group(struct device *, struct ipath_devdata *);
 void ipath_device_remove_group(struct device *, struct ipath_devdata *);
diff --git a/drivers/infiniband/hw/ipath/ipath_sysfs.c b/drivers/infiniband/hw/ipath/ipath_sysfs.c
index e1ad7cf..aa27ca9 100644
--- a/drivers/infiniband/hw/ipath/ipath_sysfs.c
+++ b/drivers/infiniband/hw/ipath/ipath_sysfs.c
@@ -683,6 +683,11 @@ static struct attribute_group driver_attr_group = {
 	.attrs = driver_attributes
 };
 
+struct attribute_group *ipath_driver_attr_groups[] = {
+	&driver_attr_group,
+	NULL,
+};
+
 static DEVICE_ATTR(guid, S_IWUSR | S_IRUGO, show_guid, store_guid);
 static DEVICE_ATTR(lmc, S_IWUSR | S_IRUGO, show_lmc, store_lmc);
 static DEVICE_ATTR(lid, S_IWUSR | S_IRUGO, show_lid, store_lid);
@@ -753,24 +758,9 @@ int ipath_expose_reset(struct device *dev)
 	return ret;
 }
 
-int ipath_driver_create_group(struct device_driver *drv)
-{
-	int ret;
-
-	ret = sysfs_create_group(&drv->kobj, &driver_attr_group);
-
-	return ret;
-}
-
-void ipath_driver_remove_group(struct device_driver *drv)
-{
-	sysfs_remove_group(&drv->kobj, &driver_attr_group);
-}
-
 int ipath_device_create_group(struct device *dev, struct ipath_devdata *dd)
 {
 	int ret;
-	char unit[5];
 
 	ret = sysfs_create_group(&dev->kobj, &dev_attr_group);
 	if (ret)
@@ -780,11 +770,6 @@ int ipath_device_create_group(struct device *dev, struct ipath_devdata *dd)
 	if (ret)
 		goto bail_attrs;
 
-	snprintf(unit, sizeof(unit), "%02d", dd->ipath_unit);
-	ret = sysfs_create_link(&dev->driver->kobj, &dev->kobj, unit);
-	if (ret == 0)
-		goto bail;
-
 	sysfs_remove_group(&dev->kobj, &dev_counter_attr_group);
 bail_attrs:
 	sysfs_remove_group(&dev->kobj, &dev_attr_group);
@@ -794,11 +779,6 @@ bail:
 
 void ipath_device_remove_group(struct device *dev, struct ipath_devdata *dd)
 {
-	char unit[5];
-
-	snprintf(unit, sizeof(unit), "%02d", dd->ipath_unit);
-	sysfs_remove_link(&dev->driver->kobj, unit);
-
 	sysfs_remove_group(&dev->kobj, &dev_counter_attr_group);
 	sysfs_remove_group(&dev->kobj, &dev_attr_group);
 
-- 
1.5.3.8

