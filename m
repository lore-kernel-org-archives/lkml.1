Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbXFIP5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbXFIP5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 11:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbXFIP50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 11:57:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:21988 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbXFIP5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 11:57:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,403,1175497200"; 
   d="scan'208";a="237368837"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] driver core: multithreaded device matching with dependency
Date: Sat, 9 Jun 2007 23:57:19 +0800
Message-ID: <9D7649D18729DE4BB2BD7B494F7FEDC2041319@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <466963D4.6010008@s5r6.in-berlin.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] driver core: multithreaded device matching with dependency
Thread-Index: Acep1xQ2oFzvRhsBRZCNroc3umrH6QA1zN7g
From: "Huang, Ying" <ying.huang@intel.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>
X-OriginalArrivalTime: 09 Jun 2007 15:57:20.0397 (UTC) FILETIME=[DC8343D0:01C7AAAE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Stefan,

I have worked out a new patch with single-threaded unit supported in
multithreaded device probing. A new flag as follow is added to struct
device,

unsigned singlethreaded_probe:1;

Which indicate that the device node and all its children node must be
probed single-threaded. During searching next device to probe, if a
device has singlethreaded_probe flag set, the devices under it will not
be searched. Instead, the device and all devices under it will be probed
serially.

Can this mechanism solve the demand of IEEE1394 subsystem effectively?

The patch is only for concept verification. It can work on my thinkpad
T42. More optimization can be done if necessary. Because I have only
"Outlook" as mail client, the format of patch may have some problem. If
the patch has any problem and you need the patch, I can resend it in
attach file.

Best Regards,
Huang Ying 

Index: linux-2.6.22-rc4/init/main.c
===================================================================
--- linux-2.6.22-rc4.orig/init/main.c	2007-06-08 18:26:11.000000000
+0800
+++ linux-2.6.22-rc4/init/main.c	2007-06-08 18:27:01.000000000
+0800
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
 	/* Make sure there is no pending stuff from the initcall
sequence */
 	flush_scheduled_work();
 }
Index: linux-2.6.22-rc4/drivers/base/dd.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/base/dd.c	2007-06-08
18:26:11.000000000 +0800
+++ linux-2.6.22-rc4/drivers/base/dd.c	2007-06-09 22:30:26.000000000
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
+		ret = bus_for_each_drv(dev->bus, NULL, dev,
__device_attach);
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
-		ret = bus_for_each_drv(dev->bus, NULL, dev,
__device_attach);
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
 
@@ -380,3 +394,186 @@
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
+#define FIND_DEVICE_FOUND  1
+#define FIND_DEVICE_WAIT   2
+
+struct find_device_data
+{
+	struct device **pdev;
+	int result;
+};
+
+static int find_next_device_to_check_in_tree(struct device *dev,
+					     void *data)
+{
+	struct find_device_data *pfind = data;
+
+	get_device(dev);
+	if (dev->is_checking)
+		pfind->result = FIND_DEVICE_WAIT;
+	else if (dev->is_matched || dev->is_checked) {
+		if (!dev->singlethreaded_probe &&
+		    !list_empty(&dev->klist_children.k_list))
+			device_for_each_child(dev, data,
+
find_next_device_to_check_in_tree);
+	} else {
+		struct device *depend;
+
+		depend = get_device(dev->depend);
+		if (!depend || depend->is_matched || depend->is_checked)
{
+			*pfind->pdev = dev;
+			pfind->result = FIND_DEVICE_FOUND;
+		} else
+			pfind->result = FIND_DEVICE_WAIT;
+		put_device(depend);
+	}
+	if (pfind->result != FIND_DEVICE_FOUND) {
+		put_device(dev);
+		return 1;
+	}
+	return 0;
+}
+
+static int find_next_device_to_check(struct device **pdev)
+{
+	struct kobject *kobj;
+	struct device *dev;
+	struct find_device_data find;
+
+	find.pdev = pdev;
+	find.result = 0;
+	spin_lock(&devices_subsys.list_lock);
+	list_for_each_entry(kobj, &(devices_subsys.list), entry) {
+		dev = to_dev(kobj);
+		dev = get_device(dev);
+		if (!dev->parent)
+			find_next_device_to_check_in_tree(dev, &find);
+		put_device(dev);
+		if (find.result == FIND_DEVICE_FOUND)
+			break;
+	}
+	spin_unlock(&devices_subsys.list_lock);
+	return find.result;
+}
+
+static int check_device(struct device *dev, void *data)
+{
+	int ret;
+
+	down(&dev->sem);
+	if (dev->is_checking || dev->is_checked) {
+		up(&dev->sem);
+		return 0;
+	}
+	dev->is_checking = 1;
+	//pr_debug("dev: %s - begin\n", dev->bus_id);
+	printk("dev: %s - begin\n", dev->bus_id);
+	ret = real_device_attach(dev);
+	//pr_debug("dev: %s - end\n", dev->bus_id);
+	printk("dev: %s - end\n", dev->bus_id);
+	dev->is_checking = 0;
+	dev->is_checked = 1;
+	dev->is_matched = (ret == 1);
+	up(&dev->sem);
+	if (data)
+		device_for_each_child(dev, data, check_device);
+	return 0;
+}
+
+static int devices_check_thread(void *data)
+{
+	struct device *dev = NULL;
+	int result;
+	struct completion *thread_complete = data;
+
+	while ((result = find_next_device_to_check(&dev))) {
+		if (result == FIND_DEVICE_FOUND) {
+			check_device(dev, (void
*)!!dev->singlethreaded_probe);
+			put_device(dev);
+		} else
+			yield();
+	}
+	complete_and_exit(thread_complete, 0);
+	return 0;
+}
+
+/**
+ *	device_match_freeze - disable device/driver matching.
+ *
+ *	All subsequent device or driver registering will not trigger
+ *	device/driver matching until device_match_thaw is called.
+ */
+void device_match_freeze(void)
+{
+	atomic_set(&device_match_freezed, 1);
+}
+
+static int dev_match_thread_default = 1;
+
+/**
+ *	device_match_thaw - renable device/driver matching and check all
+ *	pending device/driver matching.
+ *	@thread: number of threads to do device/driver matching.
+ *
+ *	All devices are checked for driver matching, multithreaded
matching
+ *	is used to accelerate matching process. The device/driver
matching
+ *	is reenabled afterwards.
+ */
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
+++ linux-2.6.22-rc4/include/linux/device.h	2007-06-09
19:41:03.000000000 +0800
@@ -413,12 +413,17 @@
 	struct klist_node	knode_driver;
 	struct klist_node	knode_bus;
 	struct device		*parent;
+	struct device		*depend;
 
 	struct kobject kobj;
 	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */
 	struct device_type	*type;
 	unsigned		is_registered:1;
 	unsigned		uevent_suppress:1;
+	unsigned		is_matched:1;
+	unsigned		is_checking:1;
+	unsigned		is_checked:1;
+	unsigned		singlethreaded_probe:1;
 	struct device_attribute uevent_attr;
 	struct device_attribute *devt_attr;
 
@@ -525,6 +530,8 @@
 extern int  __must_check device_attach(struct device * dev);
 extern int __must_check driver_attach(struct device_driver *drv);
 extern int __must_check device_reprobe(struct device *dev);
+extern void device_match_freeze(void);
+extern void device_match_thaw(int thread);
 
 /*
  * Easy functions for dynamically creating devices on the fly
