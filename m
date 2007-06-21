Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbXFUCSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbXFUCSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 22:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbXFUCSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 22:18:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:41175 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbXFUCSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 22:18:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,445,1175497200"; 
   d="scan'208";a="257018963"
Subject: [PATCH] driver core: multithreaded probing - more parallelism
	control
From: "Huang, Ying" <ying.huang@intel.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 21 Jun 2007 10:17:32 +0000
Message-Id: <1182421052.14562.3.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
X-OriginalArrivalTime: 21 Jun 2007 02:18:24.0660 (UTC) FILETIME=[7249CD40:01C7B3AA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a new version of multithreaded probing patch, with more
parallelism control added.

There are more control over which devices and drivers will be probed
parallelized or serially. For example, in IEEE1394 subsystem, the
different "units" in one "node" can be probed serially while the
different "nodes" can be probed parallelized.

The number of threads can be controlled through a kernel command line
parameters.

The patch is against 2.6.22-rc5. The "wait_for_probes" function in the
patch comes from the original multithreaded probing patch. If I need do
anything because of it, please let me know.

Any comment is welcome.

Best Regards,
Huang Ying

---

This patch add multithreaded probing with more parallelism control.

The device/driver probing is done on a probing queue, which is a
customized version of work queue, where the thread of probing queue will
come and go on demand. There is a queue No. for each probing queue. The
queue No. ranges from 0 to (unsigned short) ~0U, any queue No. can be
used by probing independent of the underlying thread number.

The device/driver probing is submitted to a probing queue though
"schedule_probe" function with probing queue No, a probing function and
corresponding parameter specified. The probing with same probing queue
No. will be done serially, while the probing with different probing
queue No. may be done parallelized.

"schedule_probe" is a general interface of multithreaded probing. While
convenient interfaces are as follow.

A field named "probe_queue_no" is added to "struct device", which
indicates probing queue No. on which the probing of the device will be
done. The subsystem can control the parallelism through this field. For
example, in IEEE1394 subsystems, the same probe_queue_no can be assigned
for different "units" in same "node" while different probe_queue_no can
be assigned to different "nodes".

Fields named "has_probe_queue" and "probe_queue_no" are added to "struct
device_driver". This let the probing queue can be controlled through
driver side too. If "has_probe_queue" is set, the "probe_queue_no" of
"struct device_driver" is used, otherwise that of "struct device" is
used.

There are other rules to control the parallelism.

1. The child device will not start probing until the probing of its
parent has been done.
2. The different drivers of same device will be probed serially.

If it is intended to separate the probing process of the device/driver
into synchronous part and asynchronous part, the ".probe" of "struct
device_driver" is used as the synchronous interface of device probing,
while the asynchronous part of probing can be submitted through
"schedule_probe" in ".probe" function. All the synchronous part will be
submitted with same probing queue number.

More strict serialization can be gotten through this mechanism if
needed. For example, if two USB driver is inserted into kernel
simultaneously, in original driver probing code, two USB device may be
probed simultaneously, while they will be probed serially if two device
has same probing queue No. in probing queue based probing code.

There is a problem of this multithreaded probing mechanism. There are
some code in kernel doing hardware access but not in the driver ".probe"
function, which may conflict with the multithreaded probiMore strict
serialization can be gotten through this mechanism if
needed. For example, if two USB driver is inserted into kernel
simultaneously, in original driver probing code, two USB device may be
probed simultaneously, while they will be probed serially if two device
has same probing queue No. in probing queue based probing code.

There is a problem of this multithreaded probing mechanism. There are
some code in kernel doing hardware access but not in the driver ".probe"
function, which may conflict with the multithreaded probing driver code.
A possible mechanism is executing those hardware access code in a
probing queue through "schedule_probe".ng driver code. A possible
mechanism is executing those hardware access code in a probing queue
through "schedule_probe".

Signed-off-by: Huang Ying <ying.huang@intel.com>

---

 drivers/base/dd.c      |  182 ++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/device.h |   27 ++++++-
 2 files changed, 199 insertions(+), 10 deletions(-)
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index b0088b0..a5cd629 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -23,6 +23,162 @@
 #include "base.h"
 #include "power/power.h"
 
+struct probe_queue {
+	spinlock_t lock;
+	struct list_head probe_list;
+	unsigned has_thread : 1;
+};
+
+struct simple_probe {
+	struct probe probe;
+	struct device *dev;
+	struct device_driver *drv;
+};
+
+static struct probe_queue *probe_queues;
+static atomic_t probe_count = ATOMIC_INIT(0);
+static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
+
+static int probe_thread_num = 1;
+
+static int __init set_probe_thread_num(char *str)
+{
+	get_option(&str, &probe_thread_num);
+	if (probe_thread_num <= 0 || probe_thread_num > (unsigned short) ~0U)
+		probe_thread_num = 1;
+	return 1;
+}
+
+__setup("probe_thread_num=", set_probe_thread_num);
+
+static int really_probe(struct probe *probe);
+
+static void init_probe_queue(struct probe_queue *probe_queue)
+{
+	spin_lock_init(&probe_queue->lock);
+	INIT_LIST_HEAD(&probe_queue->probe_list);
+	probe_queue->has_thread = 0;
+}
+
+static int probe_thread(void *data)
+{
+	struct probe_queue *probe_queue = data;
+	struct probe *probe;
+	int ret = 0;
+
+	while (1) {
+		spin_lock(&probe_queue->lock);
+		if (list_empty(&probe_queue->probe_list)) {
+			probe_queue->has_thread = 0;
+			spin_unlock(&probe_queue->lock);
+			break;
+		}
+		probe = list_entry(probe_queue->probe_list.next,
+				   struct probe, entry);
+		list_del_init(probe_queue->probe_list.next);
+		spin_unlock(&probe_queue->lock);
+		ret = probe->probe_func(probe);
+		atomic_dec(&probe_count);
+		wake_up(&probe_waitqueue);
+	}
+	return ret;
+}
+
+/**
+ * schedule_probe - schedule a probing to be done later
+ * @probe_queue_no: probing queue No. on which the probing will be done
+ * @probe: probing information include probing function and parameter
+ *
+ * Schedule a probing to be done later on specified probing queue. The
+ * probing with same probing queue No. will be probed serially while
+ * the probing with different probing queue No. may be probed
+ * simultaneously.
+ */
+
+int schedule_probe(unsigned short probe_queue_no, struct probe *probe)
+{
+	int ret = 0;
+	struct task_struct *thread;
+	struct probe_queue *probe_queue =
+		&probe_queues[probe_queue_no%probe_thread_num];
+
+	atomic_inc(&probe_count);
+	probe->probe_queue_no = probe_queue_no;
+	spin_lock(&probe_queue->lock);
+	list_add_tail(&probe->entry, &probe_queue->probe_list);
+	if (probe_queue->has_thread) {
+		spin_unlock(&probe_queue->lock);
+		return ret;
+	}
+	probe_queue->has_thread = 1;
+	spin_unlock(&probe_queue->lock);
+	thread = kthread_run(probe_thread, probe_queue,
+			     "probe-%u", probe_queue_no);
+	if (!thread)
+		ret = probe_thread(probe_queue);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(schedule_probe);
+
+static int simple_schedule_probe(struct device *dev,
+				 struct device_driver *drv)
+{
+	struct simple_probe *simple_probe;
+	unsigned short probe_queue_no;
+
+	pr_debug("simple_schedule:%s,%s\n", dev->bus_id, drv->name);
+	simple_probe = kmalloc(sizeof(struct simple_probe), GFP_KERNEL);
+	if (!simple_probe)
+		return -ENOMEM;
+	INIT_PROBE(&simple_probe->probe, really_probe);
+	simple_probe->dev = get_device(dev);
+	simple_probe->drv = get_driver(drv);
+	dev->is_probing = 1;
+	if (drv->has_probe_queue)
+		probe_queue_no = drv->probe_queue_no;
+	else
+		probe_queue_no = dev->probe_queue_no;
+	return schedule_probe(probe_queue_no, &simple_probe->probe);
+}
+
+static int __init init_probe_queues(void)
+{
+	int i;
+
+	probe_queues = kmalloc(probe_thread_num * sizeof(struct probe_queue),
+			       GFP_KERNEL);
+	if (!probe_queues)
+		return -ENOMEM;
+	for (i = 0; i < probe_thread_num; i++)
+		init_probe_queue(&probe_queues[i]);
+	return 0;
+}
+
+core_initcall_sync(init_probe_queues);
+
+static int __init wait_for_probes(void)
+{
+	DEFINE_WAIT(wait);
+
+	if (!atomic_read(&probe_count))
+		return 0;
+	while (atomic_read(&probe_count)) {
+		prepare_to_wait(&probe_waitqueue, &wait, TASK_UNINTERRUPTIBLE);
+		if (atomic_read(&probe_count))
+			schedule();
+	}
+	finish_wait(&probe_waitqueue, &wait);
+	return 0;
+}
+
+core_initcall_sync(wait_for_probes);
+postcore_initcall_sync(wait_for_probes);
+arch_initcall_sync(wait_for_probes);
+subsys_initcall_sync(wait_for_probes);
+fs_initcall_sync(wait_for_probes);
+device_initcall_sync(wait_for_probes);
+late_initcall_sync(wait_for_probes);
+
 #define to_drv(node) container_of(node, struct device_driver, kobj.entry)
 
 
@@ -94,18 +250,25 @@ int device_bind_driver(struct device *dev)
 	return ret;
 }
 
-static atomic_t probe_count = ATOMIC_INIT(0);
-static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
-
-static int really_probe(struct device *dev, struct device_driver *drv)
+static int really_probe(struct probe *probe)
 {
+	struct device *dev, *parent;
+	struct device_driver *drv;
+	struct simple_probe *simple_probe;
 	int ret = 0;
 
-	atomic_inc(&probe_count);
+	simple_probe = container_of(probe, struct simple_probe, probe);
+	dev = simple_probe->dev;
+	drv = simple_probe->drv;
+	parent = get_device(dev->parent);
+	while (parent && parent->is_probing)
+		yield();
+	put_device(parent);
 	pr_debug("%s: Probing driver %s with device %s\n",
 		 drv->bus->name, drv->name, dev->bus_id);
 	WARN_ON(!list_empty(&dev->devres_head));
 
+	down(&dev->sem);
 	dev->driver = drv;
 	if (driver_sysfs_add(dev)) {
 		printk(KERN_ERR "%s: driver_sysfs_add(%s) failed\n",
@@ -146,8 +309,11 @@ probe_failed:
 	 */
 	ret = 0;
 done:
-	atomic_dec(&probe_count);
-	wake_up(&probe_waitqueue);
+	dev->is_probing = 0;
+	up(&dev->sem);
+	put_device(dev);
+	put_driver(drv);
+	kfree(simple_probe);
 	return ret;
 }
 
@@ -195,7 +361,7 @@ int driver_probe_device(struct device_driver * drv, struct device * dev)
 	pr_debug("%s: Matched Device %s with Driver %s\n",
 		 drv->bus->name, dev->bus_id, drv->name);
 
-	ret = really_probe(dev, drv);
+	ret = simple_schedule_probe(dev, drv);
 
 done:
 	return ret;
diff --git a/include/linux/device.h b/include/linux/device.h
index 2e1a298..9e63602 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -133,6 +133,9 @@ struct device_driver {
 	const char 		* mod_name;	/* used for built-in modules */
 	struct module_kobject	* mkobj;
 
+	unsigned short		has_probe_queue:1;
+	unsigned short		probe_queue_no;
+
 	int	(*probe)	(struct device * dev);
 	int	(*remove)	(struct device * dev);
 	void	(*shutdown)	(struct device * dev);
@@ -417,8 +420,10 @@ struct device {
 	struct kobject kobj;
 	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */
 	struct device_type	*type;
-	unsigned		is_registered:1;
-	unsigned		uevent_suppress:1;
+	unsigned short		is_registered:1;
+	unsigned short		uevent_suppress:1;
+	unsigned short		is_probing:1;
+	unsigned short		probe_queue_no;
 	struct device_attribute uevent_attr;
 	struct device_attribute *devt_attr;
 
@@ -526,6 +531,24 @@ extern int  __must_check device_attach(struct device * dev);
 extern int __must_check driver_attach(struct device_driver *drv);
 extern int __must_check device_reprobe(struct device *dev);
 
+struct probe {
+	struct list_head entry;
+	int ( * probe_func)(struct probe *probe);
+	unsigned short probe_queue_no;
+};
+
+/**
+ * initialize the probing item
+ */
+#define INIT_PROBE(_probe, _probe_func)				\
+	do {							\
+		INIT_LIST_HEAD(&(_probe)->entry);		\
+		(_probe)->probe_func = (_probe_func);		\
+		(_probe)->probe_queue_no = 0;			\
+	 } while (0);
+
+int schedule_probe(unsigned short probe_queue_no, struct probe *probe);
+
 /*
  * Easy functions for dynamically creating devices on the fly
  */
