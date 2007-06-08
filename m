Return-Path: <linux-kernel-owner+w=401wt.eu-S967506AbXFHDJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967506AbXFHDJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 23:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966901AbXFHDJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 23:09:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:44361 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966834AbXFHDJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 23:09:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,397,1175497200"; 
   d="scan'208";a="252132712"
Subject: [PATCH] driver core: multithreaded device matching with dependency
From: "Huang, Ying" <ying.huang@intel.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 08 Jun 2007 11:07:59 +0000
Message-Id: <1181300879.8064.25.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
X-OriginalArrivalTime: 08 Jun 2007 03:08:52.0535 (UTC) FILETIME=[57AC1C70:01C7A97A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

This is another solution to implement multithreaded device matching
(probing). The device matching is delayed until all drivers are
registered. The driver registering is executed one by one, this
eliminates the potential of interdependency between driver. All devices
are matched to drivers afterwards, multithreaded. The parent <->
children relationship between devices is used as the dependency between
devices, that is, the children devices matching will not begin until
parent device matching finishes.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
The patch has been tested on a thinkpad T42. The system boot-up time can
be reduced effectively. To take advantage of the multithreaded matching
with the patch, following option must be added to kernel command line:

dev_match_thread=<thread number>

For many distributions, the drivers are not compiled in kernel directly,
instead, they are compiled as modules and inserted into kernel by a
initramfs. To take advanage of multithreaded matching in this situation,
the device_match_freeze and device_match_thaw can be encapsulated into
two syscall, and the device probing sequence of initramfs should be:

1. device_match_freeze
2. modprobe <driver1>
3. modprobe <driver2>
...
<n>. device_match_thaw.

 drivers/base/dd.c      |  168 ++++++++++++++++++++++++++++++++++++---
 include/linux/device.h |    5 +
 init/main.c            |    3
 3 files changed, 165 insertions(+), 11 deletions(-)
Index: linux-2.6.22-rc4/init/main.c
===================================================================
--- linux-2.6.22-rc4.orig/init/main.c	2007-06-08 18:26:11.000000000
+0800
+++ linux-2.6.22-rc4/init/main.c	2007-06-08 18:27:01.000000000 +0800
@@ -652,6 +652,7 @@
 	initcall_t *call;
 	int count = preempt_count();
 
+	device_match_freeze();
 	for (call = __initcall_start; call < __initcall_end; call++) {
 		ktime_t t0, t1, delta;
 		char *msg = NULL;
@@ -703,6 +704,8 @@
 		}
 	}
 
+	device_match_thaw(0);
+
 	/* Make sure there is no pending stuff from the initcall sequence */
 	flush_scheduled_work();
 }
Index: linux-2.6.22-rc4/drivers/base/dd.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/base/dd.c	2007-06-08
18:26:11.000000000 +0800
+++ linux-2.6.22-rc4/drivers/base/dd.c	2007-06-08 10:41:18.000000000
+0800
@@ -25,6 +25,7 @@
 
 #define to_drv(node) container_of(node, struct device_driver,
kobj.entry)
 
+static atomic_t device_match_freezed = ATOMIC_INIT(0);
 
 static void driver_bound(struct device *dev)
 {
@@ -220,6 +221,25 @@
 	return ret;
 }
 
+/* This function must be called with dev->sem held. */
+static inline int real_device_attach(struct device * dev)
+{
+	int ret = 0;
+
+	if (dev->driver) {
+		ret = device_bind_driver(dev);
+		if (ret == 0)
+			ret = 1;
+		else {
+			dev->driver = NULL;
+			ret = 0;
+		}
+	} else {
+		ret = bus_for_each_drv(dev->bus, NULL, dev, __device_attach);
+	}
+	return ret;
+}
+
 /**
  *	device_attach - try to attach device to a driver.
  *	@dev:	device.
@@ -238,18 +258,10 @@
 {
 	int ret = 0;
 
+	if (atomic_read(&device_match_freezed))
+		return 0;
 	down(&dev->sem);
-	if (dev->driver) {
-		ret = device_bind_driver(dev);
-		if (ret == 0)
-			ret = 1;
-		else {
-			dev->driver = NULL;
-			ret = 0;
-		}
-	} else {
-		ret = bus_for_each_drv(dev->bus, NULL, dev, __device_attach);
-	}
+	ret = real_device_attach(dev);
 	up(&dev->sem);
 	return ret;
 }
@@ -291,6 +303,8 @@
  */
 int driver_attach(struct device_driver * drv)
 {
+	if (atomic_read(&device_match_freezed))
+		return 0;
 	return bus_for_each_dev(drv->bus, NULL, drv, __driver_attach);
 }
 
@@ -380,3 +394,135 @@
 EXPORT_SYMBOL_GPL(device_attach);
 EXPORT_SYMBOL_GPL(driver_attach);
 
+#define to_dev(obj) container_of(obj, struct device, kobj)
+
+static void init_devices_check(void)
+{
+	struct kobject *kobj;
+	struct device *dev;
+
+	spin_lock(&devices_subsys.list_lock);
+	list_for_each_entry(kobj, &(devices_subsys.list), entry) {
+		dev = to_dev(kobj);
+		dev = get_device(dev);
+		/* class device and root device need not be checked */
+		if (dev->class || !dev->parent) {
+			dev->is_checked = 1;
+			dev->is_matched = 1;
+		} else
+			dev->is_checked = 0;
+		dev->is_checking = 0;
+		put_device(dev);
+	}
+	spin_unlock(&devices_subsys.list_lock);
+}
+
+#define CONTINUE_FOUND  1
+#define CONTINUE_WAIT   2
+
+static int find_next_device_to_check(struct device **pdev)
+{
+	struct kobject *kobj;
+	struct device *dev, *parent;
+	int cont = 0;
+
+	spin_lock(&devices_subsys.list_lock);
+	list_for_each_entry(kobj, &(devices_subsys.list), entry) {
+		dev = to_dev(kobj);
+		dev = get_device(dev);
+		parent = get_device(dev->parent);
+		if (dev->is_checking)
+			cont = CONTINUE_WAIT;
+		else if (!dev->is_matched && !dev->is_checked) {
+			if (parent->is_matched || parent->is_checked) {
+				*pdev = dev;
+				cont = CONTINUE_FOUND;
+			} else
+				cont = CONTINUE_WAIT;
+		}
+		put_device(parent);
+		if (cont == CONTINUE_FOUND)
+			break;
+		put_device(dev);
+	}
+	spin_unlock(&devices_subsys.list_lock);
+	return cont;
+}
+
+static void check_device(struct device *dev)
+{
+	int ret;
+
+	down(&dev->sem);
+	if (dev->is_checking || dev->is_checked)
+		goto out;
+	dev->is_checking = 1;
+	pr_debug("dev: %s - begin\n", dev->bus_id);
+	ret = real_device_attach(dev);
+	pr_debug("dev: %s - end\n", dev->bus_id);
+	dev->is_checking = 0;
+	dev->is_checked = 1;
+	dev->is_matched = (ret == 1);
+out:
+	up(&dev->sem);
+}
+
+static int devices_check_thread(void *data)
+{
+	struct device *dev = NULL;
+	int cont;
+	struct completion *thread_complete = data;
+
+	while ((cont = find_next_device_to_check(&dev))) {
+		if (cont == CONTINUE_FOUND) {
+			check_device(dev);
+			put_device(dev);
+		} else
+			yield();
+	}
+	complete_and_exit(thread_complete, 0);
+	return 0;
+}
+
+void device_match_freeze(void)
+{
+	atomic_set(&device_match_freezed, 1);
+}dev_match_thread
+
+static int dev_match_thread_default = 1;
+
+void device_match_thaw(int thread)
+{
+	struct completion *threads_complete;
+	int i;
+	static DECLARE_MUTEX(sem_thaw);
+
+	down(&sem_thaw);
+	if (thread <= 0)
+		thread = dev_match_thread_default > 0 ? \
+			dev_match_thread_default : 1;
+	threads_complete = kmalloc(sizeof(struct completion) * thread,
+				   GFP_KERNEL);
+	init_devices_check();
+	for (i = 0; i < thread; i++) {
+		init_completion(&threads_complete[i]);
+		kernel_thread(devices_check_thread,
+			      &threads_complete[i],
+			      CLONE_KERNEL);
+	}
+	for (i = 0; i < thread; i++)
+		wait_for_completion(&threads_complete[i]);
+	atomic_set(&device_match_freezed, 0);
+	up(&sem_thaw);
+}
+
+static int __init dev_match_thread(char *str)
+{
+	get_option(&str, &dev_match_thread_default);
+	return 1;
+}
+
+__setup("dev_match_thread=", dev_match_thread);
+
+EXPORT_SYMBOL_GPL(device_match_freeze);
+EXPORT_SYMBOL_GPL(device_match_thaw);
Index: linux-2.6.22-rc4/include/linux/device.h
===================================================================
--- linux-2.6.22-rc4.orig/include/linux/device.h	2007-06-08
18:26:11.000000000 +0800
+++ linux-2.6.22-rc4/include/linux/device.h	2007-06-08
10:35:21.000000000 +0800
@@ -419,6 +419,9 @@
 	struct device_type	*type;
 	unsigned		is_registered:1;
 	unsigned		uevent_suppress:1;
+ 	unsigned		is_matched:1;
+ 	unsigned		is_checking:1;
+ 	unsigned		is_checked:1;
 	struct device_attribute uevent_attr;
 	struct device_attribute *devt_attr;
 
@@ -525,6 +528,8 @@
 extern int  __must_check device_attach(struct device * dev);
 extern int __must_check driver_attach(struct device_driver *drv);
 extern int __must_check device_reprobe(struct device *dev);
+extern void device_match_freeze(void);
+extern void device_match_thaw(int thread);
 
 /*
  * Easy functions for dynamically creating devices on the fly
