Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbXFLCNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbXFLCNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 22:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756467AbXFLCNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 22:13:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:41095 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260AbXFLCNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 22:13:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,409,1175497200"; 
   d="scan'208";a="238055057"
Subject: Re: [PATCH] driver core: multithreaded device matching with
	dependency
From: "Huang, Ying" <ying.huang@intel.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
In-Reply-To: <466AD638.9030409@s5r6.in-berlin.de>
References: <9D7649D18729DE4BB2BD7B494F7FEDC2041319@pdsmsx415.ccr.corp.intel.com>
	 <466AD638.9030409@s5r6.in-berlin.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 12 Jun 2007 10:12:37 +0000
Message-Id: <1181643157.2779.23.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
X-OriginalArrivalTime: 12 Jun 2007 02:13:34.0579 (UTC) FILETIME=[47AB3430:01C7AC97]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Index: linux-2.6.22-rc4/include/linux/device.h
> > ===================================================================
> > --- linux-2.6.22-rc4.orig/include/linux/device.h	2007-06-08
> > 18:26:11.000000000 +0800
> > +++ linux-2.6.22-rc4/include/linux/device.h	2007-06-09
> > 19:41:03.000000000 +0800
> > @@ -413,12 +413,17 @@
> >  	struct klist_node	knode_driver;
> >  	struct klist_node	knode_bus;
> >  	struct device		*parent;
> > +	struct device		*depend;
> 
> Is this core-internal now?  If not, add a comment what it does and how
> it has to be written and read.
> 
> I'm curious how this has to be used; perhaps it will turn out that the
> whole thing is over-engineered this way.  I.e. there might be easier
> options like:
>   - Let subsystems which don't want multithreaded probing at all
>     disable multithreaded probing globally by a susbsystem flag.
>     (Or rather, let subsystems which want multithreaded probing
>     enable it globally by a subsystem flag. IOW make singlethreaded
>     probing the default.  Multithreaded probing has to be tested
>     thoroughly for each subsystem.)
>   - Let subsystems which want only partially multithreaded probing
>     serialize the necessary regions on their own by subsystem-internal
>     mutexes.
> 
> However, this really depends on what the actual cost of dev->depend is.

Maybe it is a little over-engineered. I think it may be used for some
random dependency between devices. Such as in some embedded system, the
power of USB controller may be controlled by some GPIO, so the USB
controller driver should access the GPIO driver.

Now, I made the signalthreaded probing the default. But the probing of
different subsystems are still parallelized.

Thanks for your comments. There are many problems in my patch. But for
now, the feasibility may be the biggest problem. The patch can be seen
as the helper for my description.

The summary of dependency rule is as follow:

1. A flag as follow is added to struct device.
     unsigned multithreaded_probe:1;
If it is set, the devices sub-tree with this device as root will be
probed parallelized with other devices sub-tree. If it is clear, the
device belongs to the devices sub-tree of the parent of the device, and
should be probed serially with other devices in the devices sub-tree.
The root devices (without parent) is assumed to have this flag set (in
spite of the actual value). With this flag, the PCI subsystem can be
probed serially, while IEEE 1394 subsystem can be probed parallelized
among different device node, but serially among different unit in a
node.

2. A field as follow is added to struct device.
     struct device *depend;
The device will not start probing unless the probing of the device
pointed by depend has been finished. This is used to control some random
dependency between devices.

3. The probing of the device will not be started, unless the probing of
the parent of the device has been finished.

I revised my patch to reflect the rule above, so resend it.

 drivers/base/base.h    |    5 +
 drivers/base/core.c    |   35 +++++--
 drivers/base/dd.c      |  230 ++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/device.h |    7 +
 init/main.c            |    3 
 5 files changed, 259 insertions(+), 21 deletions(-)
Index: linux-2.6.22-rc4/init/main.c
===================================================================
--- linux-2.6.22-rc4.orig/init/main.c	2007-06-11 11:24:27.000000000 +0800
+++ linux-2.6.22-rc4/init/main.c	2007-06-11 11:25:07.000000000 +0800
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
--- linux-2.6.22-rc4.orig/drivers/base/dd.c	2007-06-11 11:24:27.000000000 +0800
+++ linux-2.6.22-rc4/drivers/base/dd.c	2007-06-11 21:51:06.000000000 +0800
@@ -25,6 +25,7 @@
 
 #define to_drv(node) container_of(node, struct device_driver, kobj.entry)
 
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
 
@@ -380,3 +394,197 @@
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
+		dev->is_checked = 0;
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
+	if (dev->class)
+		;
+	else if (dev->is_checking)
+		pfind->result = FIND_DEVICE_WAIT;
+	else if (dev->is_matched || dev->is_checked)
+		device_for_each_child(dev, data,
+				      find_next_device_to_check_in_tree);
+	else if (dev->multithreaded_probe || !dev->parent) {
+		struct device *depend;
+
+		depend = get_device(dev->depend);
+		if (!depend || depend->is_matched || depend->is_checked) {
+			*pfind->pdev = dev;
+			get_device(dev);
+			pfind->result = FIND_DEVICE_FOUND;
+		} else
+			pfind->result = FIND_DEVICE_WAIT;
+		put_device(depend);
+	} else {
+		struct device *probe_root = dev;
+		while (probe_root->parent && !probe_root->multithreaded_probe)
+			probe_root = probe_root->parent;
+		if (probe_root->is_checking)
+			pfind->result = FIND_DEVICE_WAIT;
+		else {
+			pfind->result = FIND_DEVICE_FOUND;
+			get_device(probe_root);
+			*pfind->pdev = probe_root;
+		}
+	}
+	put_device(dev);
+	return pfind->result == FIND_DEVICE_FOUND;
+}
+
+static int find_next_device_to_check(struct device **pdev)
+{
+	struct find_device_data find;
+
+	find.pdev = pdev;
+	find.result = 0;
+	klist_for_each_child_device(&klist_root_devices, &find,
+				    find_next_device_to_check_in_tree);
+	return find.result;
+}
+
+static int check_device(struct device *dev, void *data)
+{
+	int ret;
+	int is_probe_root = !!data;
+
+	get_device(dev);
+	/* The dev is another probing root device */
+	if (!is_probe_root && dev->multithreaded_probe) {
+		put_device(dev);
+		return 0;
+	}
+	down(&dev->sem);
+	if (dev->is_checking) {
+		up(&dev->sem);
+		put_device(dev);
+		return 0;
+	}
+	if (is_probe_root)
+		dev->is_checking = 1;
+	if (!dev->is_checked && !dev->is_matched) {
+		dev->is_checking = 1;
+		pr_debug("dev: %s - begin\n", dev->bus_id);
+		ret = real_device_attach(dev);
+		pr_debug("dev: %s - end\n", dev->bus_id);
+		if (!is_probe_root)
+			dev->is_checking = 0;
+		dev->is_checked = 1;
+		dev->is_matched = (ret == 1);
+	}
+	up(&dev->sem);
+	device_for_each_child(dev, NULL, check_device);
+	if (is_probe_root)
+		dev->is_checking = 0;
+	put_device(dev);
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
+		pr_debug("find %d, %s\n", result, dev ? dev->bus_id : NULL);
+		if (result == FIND_DEVICE_FOUND) {
+			check_device(dev, (void *)1);
+			put_device(dev);
+		} else
+			yield();
+	}
+	complete(thread_complete);
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
+ *	device_match_thaw - renable device/driver matching.
+ *	@thread: number of threads to do device/driver matching.
+ *
+ *	All devices are checked for driver matching, multithreaded matching
+ *	is used to accelerate matching process. The device/driver matching
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
+	/* check again because drivers may be inserted during probing. */
+	init_devices_check();
+	init_completion(&threads_complete[0]);
+	devices_check_thread(&threads_complete[0]);
+	kfree(threads_complete);
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
--- linux-2.6.22-rc4.orig/include/linux/device.h	2007-06-11 11:24:27.000000000 +0800
+++ linux-2.6.22-rc4/include/linux/device.h	2007-06-11 11:25:07.000000000 +0800
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
+	unsigned		multithreaded_probe:1;
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
Index: linux-2.6.22-rc4/drivers/base/core.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/base/core.c	2007-06-07 17:17:37.000000000 +0800
+++ linux-2.6.22-rc4/drivers/base/core.c	2007-06-11 11:25:07.000000000 +0800
@@ -635,6 +635,8 @@
 	return 0;
 }
 
+struct klist klist_root_devices;
+
 /**
  *	device_add - add device to device hierarchy.
  *	@dev:	device.
@@ -741,6 +743,8 @@
 	bus_attach_device(dev);
 	if (parent)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
+	else
+		klist_add_tail(&dev->knode_parent, &klist_root_devices);
 
 	if (dev->class) {
 		down(&dev->class->sem);
@@ -975,6 +979,19 @@
 	return n ? container_of(n, struct device, knode_parent) : NULL;
 }
 
+int klist_for_each_child_device(struct klist * klist, void * data,
+				int (*fn)(struct device *, void *))
+{
+	struct klist_iter i;
+	struct device * child;
+	int error = 0;
+
+	klist_iter_init(klist, &i);
+	while ((child = next_device(&i)) && !error)
+		error = fn(child, data);
+	klist_iter_exit(&i);
+	return error;
+}
 /**
  *	device_for_each_child - device child iterator.
  *	@parent: parent struct device.
@@ -990,15 +1007,8 @@
 int device_for_each_child(struct device * parent, void * data,
 		     int (*fn)(struct device *, void *))
 {
-	struct klist_iter i;
-	struct device * child;
-	int error = 0;
-
-	klist_iter_init(&parent->klist_children, &i);
-	while ((child = next_device(&i)) && !error)
-		error = fn(child, data);
-	klist_iter_exit(&i);
-	return error;
+	return klist_for_each_child_device(&parent->klist_children,
+					   data, fn);
 }
 
 /**
@@ -1035,7 +1045,12 @@
 
 int __init devices_init(void)
 {
-	return subsystem_register(&devices_subsys);
+	int ret;
+
+	ret = subsystem_register(&devices_subsys);
+	klist_init(&klist_root_devices, klist_children_get,
+		   klist_children_put);
+	return ret;
 }
 
 EXPORT_SYMBOL_GPL(device_for_each_child);
Index: linux-2.6.22-rc4/drivers/base/base.h
===================================================================
--- linux-2.6.22-rc4.orig/drivers/base/base.h	2007-06-07 17:17:37.000000000 +0800
+++ linux-2.6.22-rc4/drivers/base/base.h	2007-06-11 11:25:07.000000000 +0800
@@ -47,3 +47,8 @@
 extern void devres_release_all(struct device *dev);
 
 extern struct kset devices_subsys;
+
+extern struct klist klist_root_devices;
+
+int klist_for_each_child_device(struct klist * klist, void * data,
+				int (*fn)(struct device *, void *));
