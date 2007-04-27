Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbXD0TOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbXD0TOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbXD0S5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:57:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:35206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034AbXD0S4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:56:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/46] driver core: per-subsystem multithreaded probing
Date: Fri, 27 Apr 2007 11:53:22 -0700
Message-Id: <11777000663361-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777000632194-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Make multithreaded probing work per subsystem instead of per driver.

It doesn't make much sense to probe the same device for multiple drivers in
parallel (after all, only one driver can bind to the device).  Instead, create
a probing thread for each device that probes the drivers one after another.
Also make the decision to use multi-threaded probe per bus instead of per
device and adapt the pci code.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/dd.c        |   62 +++++++++++++++++++++++-----------------------
 drivers/pci/pci-driver.c |    6 +---
 include/linux/device.h   |    3 +-
 include/linux/pci.h      |    2 -
 4 files changed, 33 insertions(+), 40 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 6a48824..616b4bb 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -94,19 +94,11 @@ int device_bind_driver(struct device *dev)
 	return ret;
 }
 
-struct stupid_thread_structure {
-	struct device_driver *drv;
-	struct device *dev;
-};
-
 static atomic_t probe_count = ATOMIC_INIT(0);
 static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
 
-static int really_probe(void *void_data)
+static int really_probe(struct device *dev, struct device_driver *drv)
 {
-	struct stupid_thread_structure *data = void_data;
-	struct device_driver *drv = data->drv;
-	struct device *dev = data->dev;
 	int ret = 0;
 
 	atomic_inc(&probe_count);
@@ -154,7 +146,6 @@ probe_failed:
 	 */
 	ret = 0;
 done:
-	kfree(data);
 	atomic_dec(&probe_count);
 	wake_up(&probe_waitqueue);
 	return ret;
@@ -186,16 +177,14 @@ int driver_probe_done(void)
  * format of the ID structures, nor what is to be considered a match and
  * what is not.
  *
- * This function returns 1 if a match is found, an error if one occurs
- * (that is not -ENODEV or -ENXIO), and 0 otherwise.
+ * This function returns 1 if a match is found, -ENODEV if the device is
+ * not registered, and 0 otherwise.
  *
  * This function must be called with @dev->sem held.  When called for a
  * USB interface, @dev->parent->sem must be held as well.
  */
 int driver_probe_device(struct device_driver * drv, struct device * dev)
 {
-	struct stupid_thread_structure *data;
-	struct task_struct *probe_task;
 	int ret = 0;
 
 	if (!device_is_registered(dev))
@@ -206,19 +195,7 @@ int driver_probe_device(struct device_driver * drv, struct device * dev)
 	pr_debug("%s: Matched Device %s with Driver %s\n",
 		 drv->bus->name, dev->bus_id, drv->name);
 
-	data = kmalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-	data->drv = drv;
-	data->dev = dev;
-
-	if (drv->multithread_probe) {
-		probe_task = kthread_run(really_probe, data,
-					 "probe-%s", dev->bus_id);
-		if (IS_ERR(probe_task))
-			ret = really_probe(data);
-	} else
-		ret = really_probe(data);
+	ret = really_probe(dev, drv);
 
 done:
 	return ret;
@@ -230,30 +207,53 @@ static int __device_attach(struct device_driver * drv, void * data)
 	return driver_probe_device(drv, dev);
 }
 
+static int device_probe_drivers(void *data)
+{
+	struct device *dev = data;
+	int ret = 0;
+
+	if (dev->bus) {
+		down(&dev->sem);
+		ret = bus_for_each_drv(dev->bus, NULL, dev, __device_attach);
+		up(&dev->sem);
+	}
+	return ret;
+}
+
 /**
  *	device_attach - try to attach device to a driver.
  *	@dev:	device.
  *
  *	Walk the list of drivers that the bus has and call
  *	driver_probe_device() for each pair. If a compatible
- *	pair is found, break out and return.
+ *	pair is found, break out and return. If the bus specifies
+ *	multithreaded probing, walking the list of drivers is done
+ *	on a probing thread.
  *
  *	Returns 1 if the device was bound to a driver;
- *	0 if no matching device was found; error code otherwise.
+ *	0 if no matching device was found or multithreaded probing is done;
+ *	error code otherwise.
  *
  *	When called for a USB interface, @dev->parent->sem must be held.
  */
 int device_attach(struct device * dev)
 {
 	int ret = 0;
+	struct task_struct *probe_task = ERR_PTR(-ENOMEM);
 
 	down(&dev->sem);
 	if (dev->driver) {
 		ret = device_bind_driver(dev);
 		if (ret == 0)
 			ret = 1;
-	} else
-		ret = bus_for_each_drv(dev->bus, NULL, dev, __device_attach);
+	} else {
+		if (dev->bus->multithread_probe)
+			probe_task = kthread_run(device_probe_drivers, dev,
+						 "probe-%s", dev->bus_id);
+		if(IS_ERR(probe_task))
+			ret = bus_for_each_drv(dev->bus, NULL, dev,
+					       __device_attach);
+	}
 	up(&dev->sem);
 	return ret;
 }
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index a3c1755..39e80fc 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -434,11 +434,6 @@ int __pci_register_driver(struct pci_driver *drv, struct module *owner,
 	drv->driver.mod_name = mod_name;
 	drv->driver.kobj.ktype = &pci_driver_kobj_type;
 
-	if (pci_multithread_probe)
-		drv->driver.multithread_probe = pci_multithread_probe;
-	else
-		drv->driver.multithread_probe = drv->multithread_probe;
-
 	spin_lock_init(&drv->dynids.lock);
 	INIT_LIST_HEAD(&drv->dynids.list);
 
@@ -574,6 +569,7 @@ struct bus_type pci_bus_type = {
 
 static int __init pci_driver_init(void)
 {
+	pci_bus_type.multithread_probe = pci_multithread_probe;
 	return bus_register(&pci_bus_type);
 }
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 7f63d4d..eb1fff0 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -80,6 +80,7 @@ struct bus_type {
 	int (*resume)(struct device * dev);
 
 	unsigned int drivers_autoprobe:1;
+	unsigned int multithread_probe:1;
 };
 
 extern int __must_check bus_register(struct bus_type * bus);
@@ -139,8 +140,6 @@ struct device_driver {
 	void	(*shutdown)	(struct device * dev);
 	int	(*suspend)	(struct device * dev, pm_message_t state);
 	int	(*resume)	(struct device * dev);
-
-	unsigned int multithread_probe:1;
 };
 
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 481ea06..a3ad762 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -361,8 +361,6 @@ struct pci_driver {
 	struct pci_error_handlers *err_handler;
 	struct device_driver	driver;
 	struct pci_dynids dynids;
-
-	int multithread_probe;
 };
 
 #define	to_pci_driver(drv) container_of(drv,struct pci_driver, driver)
-- 
1.5.1.2

