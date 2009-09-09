Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZIIXnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZIIXnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbZIIXl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:41:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35971 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbZIIXlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:41:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/9] PM: Introduce PM links framework
Date: Thu, 10 Sep 2009 01:32:36 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
References: <200909100127.11252.rjw@sisk.pl>
In-Reply-To: <200909100127.11252.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909100132.36618.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce a framework for representing off-tree PM dependencies
between devices.

There are PM dependencies between devices that are not reflected by
the structure of the device tree.  In other words, as far as PM is
concerned, a device may depend on some other devices which are not
its children and none of which is its parent.

Every such dependency involves two devices, one of which is a
"master" and the other of which is a "slave", meaning that the
"slave" have to be suspended before the "master" and cannot be
woken up before it.  Thus every device can be given two lists of
"dependency objects", one for the dependencies where the device is
the "master" and the other for the dependencies where the device is
the "slave".  Then, each "dependency object" can be represented as

struct pm_link {
    struct device *master;
    struct list_head master_hook;
    struct device *slave;
    struct list_head slave_hook;
};

Add some synchronization, helpers for adding and removing
'struct pm_link' objects.

In addition to checking a device's parent, walk the list of its
"masters", in addition to walking the list of a device's children,
walk the list of its "slaves".

'struct pm_link' objects are created automatically for ACPI devices
and "regular" devices associated with them.  In the other cases such
objects will have to be added directly by platforms / bus types /
drivers etc.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/glue.c          |    3 
 drivers/base/core.c          |    4 
 drivers/base/power/Makefile  |    2 
 drivers/base/power/common.c  |  280 +++++++++++++++++++++++++++++++++++++++++++
 drivers/base/power/main.c    |   27 ----
 drivers/base/power/power.h   |   31 ++--
 drivers/base/power/runtime.c |    4 
 include/linux/pm.h           |    4 
 include/linux/pm_link.h      |   30 ++++
 9 files changed, 343 insertions(+), 42 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -408,6 +408,9 @@ enum rpm_request {
 };
 
 struct dev_pm_info {
+	spinlock_t		lock;
+	struct list_head	master_links;
+	struct list_head	slave_links;
 	pm_message_t		power_state;
 	unsigned int		can_wakeup:1;
 	unsigned int		should_wakeup:1;
@@ -420,7 +423,6 @@ struct dev_pm_info {
 	unsigned long		timer_expires;
 	struct work_struct	work;
 	wait_queue_head_t	wait_queue;
-	spinlock_t		lock;
 	atomic_t		usage_count;
 	atomic_t		child_count;
 	unsigned int		disable_depth:3;
Index: linux-2.6/drivers/base/power/power.h
===================================================================
--- linux-2.6.orig/drivers/base/power/power.h
+++ linux-2.6/drivers/base/power/power.h
@@ -1,3 +1,7 @@
+extern void device_pm_init(struct device *dev);
+extern void device_pm_add(struct device *dev);
+extern void device_pm_remove(struct device *dev);
+
 #ifdef CONFIG_PM_RUNTIME
 
 extern void pm_runtime_init(struct device *dev);
@@ -23,7 +27,8 @@ static inline struct device *to_device(s
 	return container_of(entry, struct device, power.entry);
 }
 
-extern void device_pm_init(struct device *dev);
+extern void device_pm_list_add(struct device *dev);
+extern void device_pm_list_remove(struct device *dev);
 extern void device_pm_add(struct device *);
 extern void device_pm_remove(struct device *);
 extern void device_pm_move_before(struct device *, struct device *);
@@ -32,17 +37,8 @@ extern void device_pm_move_last(struct d
 
 #else /* !CONFIG_PM_SLEEP */
 
-static inline void device_pm_init(struct device *dev)
-{
-	pm_runtime_init(dev);
-}
-
-static inline void device_pm_remove(struct device *dev)
-{
-	pm_runtime_remove(dev);
-}
-
-static inline void device_pm_add(struct device *dev) {}
+static inline void device_pm_list_add(struct device *dev) {}
+static inline void device_pm_list_remove(struct device *dev) {}
 static inline void device_pm_move_before(struct device *deva,
 					 struct device *devb) {}
 static inline void device_pm_move_after(struct device *deva,
@@ -60,7 +56,11 @@ static inline void device_pm_move_last(s
 extern int dpm_sysfs_add(struct device *);
 extern void dpm_sysfs_remove(struct device *);
 
-#else /* CONFIG_PM */
+/* drivers/base/power/link.c */
+extern int pm_link_init(void);
+extern void pm_link_remove_all(struct device *dev);
+
+#else /* !CONFIG_PM */
 
 static inline int dpm_sysfs_add(struct device *dev)
 {
@@ -71,4 +71,7 @@ static inline void dpm_sysfs_remove(stru
 {
 }
 
-#endif
+static inline int pm_link_init(void) { return 0; }
+static inline void pm_link_remove_all(struct device *dev) {}
+
+#endif  /* !CONFIG_PM */
Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -1252,9 +1252,13 @@ int __init devices_init(void)
 	sysfs_dev_char_kobj = kobject_create_and_add("char", dev_kobj);
 	if (!sysfs_dev_char_kobj)
 		goto char_kobj_err;
+	if (pm_link_init())
+		goto pm_link_err;
 
 	return 0;
 
+ pm_link_err:
+	kobject_put(sysfs_dev_char_kobj);
  char_kobj_err:
 	kobject_put(sysfs_dev_block_kobj);
  block_kobj_err:
Index: linux-2.6/include/linux/pm_link.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/pm_link.h
@@ -0,0 +1,30 @@
+/*
+ * include/linux/pm_link.h - PM links manipulation core.
+ *
+ * Copyright (c) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#ifndef _LINUX_PM_LINK_H
+#define _LINUX_PM_LINK_H
+
+#include <linux/list.h>
+
+struct device;
+
+struct pm_link {
+	struct device *master;
+	struct list_head master_hook;
+	struct device *slave;
+	struct list_head slave_hook;
+};
+
+extern int pm_link_add(struct device *slave, struct device *master);
+extern void pm_link_remove(struct device *dev, struct device *master);
+extern int device_for_each_master(struct device *slave, void *data,
+			   int (*fn)(struct device *dev, void *data));
+extern int device_for_each_slave(struct device *master, void *data,
+			  int (*fn)(struct device *dev, void *data));
+
+#endif
Index: linux-2.6/drivers/base/power/Makefile
===================================================================
--- linux-2.6.orig/drivers/base/power/Makefile
+++ linux-2.6/drivers/base/power/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_PM)	+= sysfs.o
+obj-$(CONFIG_PM)	+= sysfs.o common.o
 obj-$(CONFIG_PM_SLEEP)	+= main.o
 obj-$(CONFIG_PM_RUNTIME)	+= runtime.o
 obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
Index: linux-2.6/drivers/base/power/runtime.c
===================================================================
--- linux-2.6.orig/drivers/base/power/runtime.c
+++ linux-2.6/drivers/base/power/runtime.c
@@ -972,8 +972,6 @@ EXPORT_SYMBOL_GPL(pm_runtime_enable);
  */
 void pm_runtime_init(struct device *dev)
 {
-	spin_lock_init(&dev->power.lock);
-
 	dev->power.runtime_status = RPM_SUSPENDED;
 	dev->power.idle_notification = false;
 
@@ -993,8 +991,6 @@ void pm_runtime_init(struct device *dev)
 	dev->power.timer_expires = 0;
 	setup_timer(&dev->power.suspend_timer, pm_suspend_timer_fn,
 			(unsigned long)dev);
-
-	init_waitqueue_head(&dev->power.wait_queue);
 }
 
 /**
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -21,6 +21,7 @@
 #include <linux/kallsyms.h>
 #include <linux/mutex.h>
 #include <linux/pm.h>
+#include <linux/pm_link.h>
 #include <linux/pm_runtime.h>
 #include <linux/resume-trace.h>
 #include <linux/rwsem.h>
@@ -50,16 +51,6 @@ static DEFINE_MUTEX(dpm_list_mtx);
 static bool transition_started;
 
 /**
- * device_pm_init - Initialize the PM-related part of a device object.
- * @dev: Device object being initialized.
- */
-void device_pm_init(struct device *dev)
-{
-	dev->power.status = DPM_ON;
-	pm_runtime_init(dev);
-}
-
-/**
  * device_pm_lock - Lock the list of active devices used by the PM core.
  */
 void device_pm_lock(void)
@@ -76,14 +67,11 @@ void device_pm_unlock(void)
 }
 
 /**
- * device_pm_add - Add a device to the PM core's list of active devices.
+ * device_pm_list_add - Add a device to the PM core's list of active devices.
  * @dev: Device to add to the list.
  */
-void device_pm_add(struct device *dev)
+void device_pm_list_add(struct device *dev)
 {
-	pr_debug("PM: Adding info for %s:%s\n",
-		 dev->bus ? dev->bus->name : "No Bus",
-		 kobject_name(&dev->kobj));
 	mutex_lock(&dpm_list_mtx);
 	if (dev->parent) {
 		if (dev->parent->power.status >= DPM_SUSPENDING)
@@ -97,24 +85,19 @@ void device_pm_add(struct device *dev)
 		 */
 		dev_WARN(dev, "Parentless device registered during a PM transaction\n");
 	}
-
 	list_add_tail(&dev->power.entry, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
 }
 
 /**
- * device_pm_remove - Remove a device from the PM core's list of active devices.
+ * device_pm_list_remove - Remove a device from the PM core's list of devices.
  * @dev: Device to be removed from the list.
  */
-void device_pm_remove(struct device *dev)
+void device_pm_list_remove(struct device *dev)
 {
-	pr_debug("PM: Removing info for %s:%s\n",
-		 dev->bus ? dev->bus->name : "No Bus",
-		 kobject_name(&dev->kobj));
 	mutex_lock(&dpm_list_mtx);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
-	pm_runtime_remove(dev);
 }
 
 /**
Index: linux-2.6/drivers/base/power/common.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/base/power/common.c
@@ -0,0 +1,280 @@
+/*
+ * drivers/base/power/common.c - device PM common functions.
+ *
+ * Copyright (c) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/rculist.h>
+#include <linux/device.h>
+#include <linux/srcu.h>
+#include <linux/pm_link.h>
+
+#include "power.h"
+
+/**
+ * device_pm_init - Initialize the PM part of a device object.
+ * @dev: Device object being initialized.
+ */
+void device_pm_init(struct device *dev)
+{
+	dev->power.status = DPM_ON;
+	spin_lock_init(&dev->power.lock);
+	INIT_LIST_HEAD(&dev->power.master_links);
+	INIT_LIST_HEAD(&dev->power.slave_links);
+	pm_runtime_init(dev);
+}
+
+/**
+ * device_pm_add - Handle the PM part of a device added to device tree.
+ * @dev: Device object being added to device tree.
+ */
+void device_pm_add(struct device *dev)
+{
+	pr_debug("PM: Adding info for %s:%s\n",
+		 dev->bus ? dev->bus->name : "No Bus",
+		 kobject_name(&dev->kobj));
+	device_pm_list_add(dev);
+}
+
+/**
+ * device_pm_remove - Handle the PM part of a device removed from device tree.
+ * @dev: Device object being removed from device tree.
+ */
+void device_pm_remove(struct device *dev)
+{
+	pr_debug("PM: Removing info for %s:%s\n",
+		 dev->bus ? dev->bus->name : "No Bus",
+		 kobject_name(&dev->kobj));
+	device_pm_list_remove(dev);
+	pm_runtime_remove(dev);
+	pm_link_remove_all(dev);
+}
+
+/*
+ * PM links framework.
+ *
+ * There are PM dependencies between devices that are not reflected by the
+ * structure of the device tree.  In other words, as far as PM is concerned, a
+ * device may depend on some other devices which are not its children and none
+ * of which is its parent.
+ *
+ * Every such dependency involves two devices, one of which is a "master" and
+ * the other of which is a "slave", meaning that the "slave" have to be
+ * suspended before the "master" and cannot be woken up before it.  Thus every
+ * device can be given two lists of "dependency objects", one for the
+ * dependencies where the device is the "master" and the other for the
+ * dependencies where the device is the "slave".  Then, each "dependency object"
+ * can be represented as 'struct pm_link' as defined in include/linux/pm_link.h.
+ *
+ * The PM links of a device can help decide when the device should be suspended
+ * or resumed.  Namely, In addition to checking the device's parent, the PM core
+ * can walk the list of its "masters" and check their PM status.  Similarly, in
+ * addition to walking the list of a device's children, the PM core can walk the
+ * list of its "slaves".
+ */
+
+static struct srcu_struct pm_link_ss;
+static DEFINE_MUTEX(pm_link_mtx);
+
+/**
+ * pm_link_add - Create a PM link object connecting two devices.
+ * @slave: Device to be the slave in this link.
+ * @master: Device to be the master in this link.
+ */
+int pm_link_add(struct device *slave, struct device *master)
+{
+	struct pm_link *link;
+	int error = -ENODEV;
+
+	if (!get_device(master))
+		return error;
+
+	if (!get_device(slave))
+		goto err_slave;
+
+	link = kzalloc(sizeof(*link), GFP_KERNEL);
+	if (!link)
+		goto err_link;
+
+	dev_dbg(slave, "PM: Creating PM link to (master) %s %s\n",
+		dev_driver_string(master), dev_name(master));
+
+	link->master = master;
+	INIT_LIST_HEAD(&link->master_hook);
+	link->slave = slave;
+	INIT_LIST_HEAD(&link->slave_hook);
+
+	spin_lock_irq(&master->power.lock);
+	list_add_tail_rcu(&link->master_hook, &master->power.master_links);
+	spin_unlock_irq(&master->power.lock);
+
+	spin_lock_irq(&slave->power.lock);
+	list_add_tail_rcu(&link->slave_hook, &slave->power.slave_links);
+	spin_unlock_irq(&slave->power.lock);
+
+	return 0;
+
+ err_link:
+	error = -ENOMEM;
+	put_device(slave);
+
+ err_slave:
+	put_device(master);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(pm_link_add);
+
+/**
+ * __pm_link_remove - Remove a PM link object.
+ * @link: PM link object to remove
+ */
+static void __pm_link_remove(struct pm_link *link)
+{
+	struct device *master = link->master;
+	struct device *slave = link->slave;
+
+	dev_dbg(slave, "PM: Removing PM link to (master) %s %s\n",
+		dev_driver_string(master), dev_name(master));
+
+	spin_lock_irq(&master->power.lock);
+	list_del_rcu(&link->master_hook);
+	spin_unlock_irq(&master->power.lock);
+
+	spin_lock_irq(&slave->power.lock);
+	list_del_rcu(&link->slave_hook);
+	spin_unlock_irq(&slave->power.lock);
+
+	synchronize_srcu(&pm_link_ss);
+
+	kfree(link);
+
+	put_device(master);
+	put_device(slave);
+}
+
+/**
+ * pm_link_remove_all - Remove all PM link objects for given device.
+ * @dev: Device to handle.
+ */
+void pm_link_remove_all(struct device *dev)
+{
+	struct pm_link *link, *n;
+
+	mutex_lock(&pm_link_mtx);
+
+	list_for_each_entry_safe(link, n, &dev->power.master_links, master_hook)
+		__pm_link_remove(link);
+
+	list_for_each_entry_safe(link, n, &dev->power.slave_links, slave_hook)
+		__pm_link_remove(link);
+
+	mutex_unlock(&pm_link_mtx);
+}
+
+/**
+ * pm_link_remove - Remove a PM link object connecting two devices.
+ * @dev: Slave device of the PM link to remove.
+ * @master: Master device of the PM link to remove.
+ */
+void pm_link_remove(struct device *dev, struct device *master)
+{
+	struct pm_link *link, *n;
+
+	mutex_lock(&pm_link_mtx);
+
+	list_for_each_entry_safe(link, n, &dev->power.slave_links, slave_hook) {
+		if (link->master != master)
+			continue;
+
+		__pm_link_remove(link);
+		break;
+	}
+
+	mutex_unlock(&pm_link_mtx);
+}
+EXPORT_SYMBOL_GPL(pm_link_remove);
+
+/**
+ * device_for_each_master - Execute given function for each master of a device.
+ * @slave: Device whose masters to execute the function for.
+ * @data: Data pointer to pass to the function.
+ * @fn: Function to execute for each master of @slave.
+ *
+ * The function is executed for the parent of the device, if there is one, and
+ * for each device connected to it via a pm_link object where @slave is the
+ * "slave".
+ */
+int device_for_each_master(struct device *slave, void *data,
+			   int (*fn)(struct device *dev, void *data))
+{
+	struct pm_link *link;
+	int idx;
+	int error = 0;
+
+	if (slave->parent) {
+		error = fn(slave->parent, data);
+		if (error)
+			return error;
+	}
+
+	idx = srcu_read_lock(&pm_link_ss);
+
+	list_for_each_entry_rcu(link, &slave->power.slave_links, slave_hook) {
+		struct device *master = link->master;
+
+		error = fn(master, data);
+		if (error)
+			break;
+	}
+
+	srcu_read_unlock(&pm_link_ss, idx);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(device_for_each_master);
+
+/**
+ * device_for_each_slave - Execute given function for each slave of a device.
+ * @master: Device whose slaves to execute the function for.
+ * @data: Data pointer to pass to the function.
+ * @fn: Function to execute for each slave of @master.
+ *
+ * The function is executed for all children of the device, if there are any,
+ * and for each device connected to it via a pm_link object where @master is the
+ * "master".
+ */
+int device_for_each_slave(struct device *master, void *data,
+			  int (*fn)(struct device *dev, void *data))
+{
+	struct pm_link *link;
+	int idx;
+	int error;
+
+	error = device_for_each_child(master, data, fn);
+	if (error)
+		return error;
+
+	idx = srcu_read_lock(&pm_link_ss);
+
+	list_for_each_entry_rcu(link, &master->power.master_links,
+				master_hook) {
+		struct device *slave = link->slave;
+
+		error = fn(slave, data);
+		if (error)
+			break;
+	}
+
+	srcu_read_unlock(&pm_link_ss, idx);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(device_for_each_slave);
+
+int __init pm_link_init(void)
+{
+	return init_srcu_struct(&pm_link_ss);
+}
Index: linux-2.6/drivers/acpi/glue.c
===================================================================
--- linux-2.6.orig/drivers/acpi/glue.c
+++ linux-2.6/drivers/acpi/glue.c
@@ -11,6 +11,7 @@
 #include <linux/device.h>
 #include <linux/rwsem.h>
 #include <linux/acpi.h>
+#include <linux/pm_link.h>
 
 #define ACPI_GLUE_DEBUG	0
 #if ACPI_GLUE_DEBUG
@@ -170,6 +171,7 @@ static int acpi_bind_one(struct device *
 			device_set_wakeup_enable(dev,
 						acpi_dev->wakeup.state.enabled);
 		}
+		pm_link_add(dev, &acpi_dev->dev);
 	}
 
 	return 0;
@@ -189,6 +191,7 @@ static int acpi_unbind_one(struct device
 					&acpi_dev)) {
 			sysfs_remove_link(&dev->kobj, "firmware_node");
 			sysfs_remove_link(&acpi_dev->dev.kobj, "physical_node");
+			pm_link_remove(dev, &acpi_dev->dev);
 		}
 
 		acpi_detach_data(dev->archdata.acpi_handle,

