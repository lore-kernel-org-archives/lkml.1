Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbXEILtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbXEILtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756304AbXEILsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:48:32 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:19859 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbXEILsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:48:30 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 5/6] IB/ehca: beautify sysfs attribute code, fix compiler warnings
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Christoph Raisch" <raisch@de.ibm.com>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 6092
Date: Wed, 9 May 2007 13:48:25 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705091348.26426.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

eHCA's sysfs attributes are now being created via sysfs_create_group(),
making the process neatly table-driven. The return value is checked, thus
fixing a few compiler warnings.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_main.c |   86 ++++++++++++++------------------
 1 files changed, 37 insertions(+), 49 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 2e27e68..dc736e8 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -454,15 +454,14 @@ static ssize_t ehca_store_debug_level(st
 DRIVER_ATTR(debug_level, S_IRUSR | S_IWUSR,
 	    ehca_show_debug_level, ehca_store_debug_level);
 
-void ehca_create_driver_sysfs(struct ibmebus_driver *drv)
-{
-	driver_create_file(&drv->driver, &driver_attr_debug_level);
-}
+static struct attribute *ehca_drv_attrs[] = {
+	&driver_attr_debug_level.attr,
+	NULL
+};
 
-void ehca_remove_driver_sysfs(struct ibmebus_driver *drv)
-{
-	driver_remove_file(&drv->driver, &driver_attr_debug_level);
-}
+static struct attribute_group ehca_drv_attr_grp = {
+	.attrs = ehca_drv_attrs
+};
 
 #define EHCA_RESOURCE_ATTR(name)                                           \
 static ssize_t  ehca_show_##name(struct device *dev,                       \
@@ -524,44 +523,28 @@ static ssize_t ehca_show_adapter_handle(
 }
 static DEVICE_ATTR(adapter_handle, S_IRUGO, ehca_show_adapter_handle, NULL);
 
+static struct attribute *ehca_dev_attrs[] = {
+	&dev_attr_adapter_handle.attr,
+	&dev_attr_num_ports.attr,
+	&dev_attr_hw_ver.attr,
+	&dev_attr_max_eq.attr,
+	&dev_attr_cur_eq.attr,
+	&dev_attr_max_cq.attr,
+	&dev_attr_cur_cq.attr,
+	&dev_attr_max_qp.attr,
+	&dev_attr_cur_qp.attr,
+	&dev_attr_max_mr.attr,
+	&dev_attr_cur_mr.attr,
+	&dev_attr_max_mw.attr,
+	&dev_attr_cur_mw.attr,
+	&dev_attr_max_pd.attr,
+	&dev_attr_max_ah.attr,
+	NULL
+};
 
-void ehca_create_device_sysfs(struct ibmebus_dev *dev)
-{
-	device_create_file(&dev->ofdev.dev, &dev_attr_adapter_handle);
-	device_create_file(&dev->ofdev.dev, &dev_attr_num_ports);
-	device_create_file(&dev->ofdev.dev, &dev_attr_hw_ver);
-	device_create_file(&dev->ofdev.dev, &dev_attr_max_eq);
-	device_create_file(&dev->ofdev.dev, &dev_attr_cur_eq);
-	device_create_file(&dev->ofdev.dev, &dev_attr_max_cq);
-	device_create_file(&dev->ofdev.dev, &dev_attr_cur_cq);
-	device_create_file(&dev->ofdev.dev, &dev_attr_max_qp);
-	device_create_file(&dev->ofdev.dev, &dev_attr_cur_qp);
-	device_create_file(&dev->ofdev.dev, &dev_attr_max_mr);
-	device_create_file(&dev->ofdev.dev, &dev_attr_cur_mr);
-	device_create_file(&dev->ofdev.dev, &dev_attr_max_mw);
-	device_create_file(&dev->ofdev.dev, &dev_attr_cur_mw);
-	device_create_file(&dev->ofdev.dev, &dev_attr_max_pd);
-	device_create_file(&dev->ofdev.dev, &dev_attr_max_ah);
-}
-
-void ehca_remove_device_sysfs(struct ibmebus_dev *dev)
-{
-	device_remove_file(&dev->ofdev.dev, &dev_attr_adapter_handle);
-	device_remove_file(&dev->ofdev.dev, &dev_attr_num_ports);
-	device_remove_file(&dev->ofdev.dev, &dev_attr_hw_ver);
-	device_remove_file(&dev->ofdev.dev, &dev_attr_max_eq);
-	device_remove_file(&dev->ofdev.dev, &dev_attr_cur_eq);
-	device_remove_file(&dev->ofdev.dev, &dev_attr_max_cq);
-	device_remove_file(&dev->ofdev.dev, &dev_attr_cur_cq);
-	device_remove_file(&dev->ofdev.dev, &dev_attr_max_qp);
-	device_remove_file(&dev->ofdev.dev, &dev_attr_cur_qp);
-	device_remove_file(&dev->ofdev.dev, &dev_attr_max_mr);
-	device_remove_file(&dev->ofdev.dev, &dev_attr_cur_mr);
-	device_remove_file(&dev->ofdev.dev, &dev_attr_max_mw);
-	device_remove_file(&dev->ofdev.dev, &dev_attr_cur_mw);
-	device_remove_file(&dev->ofdev.dev, &dev_attr_max_pd);
-	device_remove_file(&dev->ofdev.dev, &dev_attr_max_ah);
-}
+static struct attribute_group ehca_dev_attr_grp = {
+	.attrs = ehca_dev_attrs
+};
 
 static int __devinit ehca_probe(struct ibmebus_dev *dev,
 				const struct of_device_id *id)
@@ -669,7 +652,10 @@ static int __devinit ehca_probe(struct i
 		}
 	}
 
-	ehca_create_device_sysfs(dev);
+	ret = sysfs_create_group(&dev->ofdev.dev.kobj, &ehca_dev_attr_grp);
+	if (ret) /* only complain; we can live without attributes */
+		ehca_err(&shca->ib_device,
+			 "Cannot create device attributes  ret=%d", ret);
 
 	spin_lock(&shca_list_lock);
 	list_add(&shca->shca_list, &shca_list);
@@ -721,7 +707,7 @@ static int __devexit ehca_remove(struct 
 	struct ehca_shca *shca = dev->ofdev.dev.driver_data;
 	int ret;
 
-	ehca_remove_device_sysfs(dev);
+	sysfs_remove_group(&dev->ofdev.dev.kobj, &ehca_dev_attr_grp);
 
 	if (ehca_open_aqp1 == 1) {
 		int i;
@@ -840,7 +826,9 @@ int __init ehca_module_init(void)
 		goto module_init2;
 	}
 
-	ehca_create_driver_sysfs(&ehca_driver);
+	ret = sysfs_create_group(&ehca_driver.driver.kobj, &ehca_drv_attr_grp);
+	if (ret) /* only complain; we can live without attributes */
+		ehca_gen_err("Cannot create driver attributes  ret=%d", ret);
 
 	if (ehca_poll_all_eqs != 1) {
 		ehca_gen_err("WARNING!!!");
@@ -867,7 +855,7 @@ void __exit ehca_module_exit(void)
 	if (ehca_poll_all_eqs == 1)
 		del_timer_sync(&poll_eqs_timer);
 
-	ehca_remove_driver_sysfs(&ehca_driver);
+	sysfs_remove_group(&ehca_driver.driver.kobj, &ehca_drv_attr_grp);
 	ibmebus_unregister_driver(&ehca_driver);
 
 	ehca_destroy_slab_caches();
-- 
1.4.2.1


