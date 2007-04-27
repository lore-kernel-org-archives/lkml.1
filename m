Return-Path: <linux-kernel-owner+w=401wt.eu-S1757183AbXD0U37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbXD0U37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757206AbXD0U37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:29:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757183AbXD0U35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:29:57 -0400
Date: Fri, 27 Apr 2007 13:27:30 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/46] Driver core: udev triggered device-driver binding
Message-ID: <20070427202730.GB12281@suse.de>
References: <20070427185152.GA17121@kroah.com> <1177700040520-git-send-email-gregkh@suse.de> <11777000433552-git-send-email-gregkh@suse.de> <11777000471977-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11777000471977-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

We get two per-bus sysfs files:
  ls-l /sys/subsystem/usb
  drwxr-xr-x 2 root root    0 2007-02-16 16:42 devices
  drwxr-xr-x 7 root root    0 2007-02-16 14:55 drivers
  -rw-r--r-- 1 root root 4096 2007-02-16 16:42 drivers_autoprobe
  --w------- 1 root root 4096 2007-02-16 16:42 drivers_probe

The flag "drivers_autoprobe" controls the behavior of the bus to bind
devices by default, or just initialize the device and leave it alone.

The command "drivers_probe" accepts a bus_id and the bus tries to bind a
driver to this device.

Systems who want to control the driver binding with udev, switch off the
bus initiated probing:
  echo 0 > /sys/subsystem/usb/drivers_autoprobe
  echo 0 > /sys/subsystem/pcmcia/drivers_autoprobe
  ...

and initiate the probing with udev rules like:
  ACTION=="add", SUBSYSTEM=="usb", ATTR{subsystem/drivers_probe}="$kernel"
  ACTION=="add", SUBSYSTEM=="pcmcia", ATTR{subsystem/drivers_probe}="$kernel"
  ...

Custom driver binding can happen in earlier rules by something like:
  ACTION=="add", SUBSYSTEM=="usb", \
  ATTRS{idVendor}=="1234", ATTRS{idProduct}=="5678" \
  ATTR{subsystem/drivers/<custom-driver>/bind}="$kernel"

This is intended to solve the modprobe.conf mess with "install-rules", custom
bind/unbind-scripts and all the weird things people invented over the years.
It should also provide the functionality "libusual" was supposed to do.

With udev, one can just write a udev rule to drive all USB-disks at the
third port of USB-hub by the "ub" driver, and everything else by
usb-storage. One can also instruct udev to bind different wireless
drivers to identical cards - just selected by the pcmcia slot-number, and
whatever ...

To use the mentioned rules, it needs udev version 106, to be able to
write ATTR{}="$kernel" to sysfs files.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c     |   84 ++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/device.h |   34 +++++++++++--------
 2 files changed, 97 insertions(+), 21 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 253868e..9df2e6d 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -27,6 +27,9 @@
 #define to_driver(obj) container_of(obj, struct device_driver, kobj)
 
 
+static int __must_check bus_rescan_devices_helper(struct device *dev,
+						void *data);
+
 static ssize_t
 drv_attr_show(struct kobject * kobj, struct attribute * attr, char * buf)
 {
@@ -133,7 +136,6 @@ static decl_subsys(bus, &ktype_bus, NULL);
 
 
 #ifdef CONFIG_HOTPLUG
-
 /* Manually detach a device from its associated driver. */
 static int driver_helper(struct device *dev, void *data)
 {
@@ -199,6 +201,33 @@ static ssize_t driver_bind(struct device_driver *drv,
 }
 static DRIVER_ATTR(bind, S_IWUSR, NULL, driver_bind);
 
+static ssize_t show_drivers_autoprobe(struct bus_type *bus, char *buf)
+{
+	return sprintf(buf, "%d\n", bus->drivers_autoprobe);
+}
+
+static ssize_t store_drivers_autoprobe(struct bus_type *bus,
+				       const char *buf, size_t count)
+{
+	if (buf[0] == '0')
+		bus->drivers_autoprobe = 0;
+	else
+		bus->drivers_autoprobe = 1;
+	return count;
+}
+
+static ssize_t store_drivers_probe(struct bus_type *bus,
+				   const char *buf, size_t count)
+{
+	struct device *dev;
+
+	dev = bus_find_device(bus, NULL, (void *)buf, driver_helper);
+	if (!dev)
+		return -ENODEV;
+	if (bus_rescan_devices_helper(dev, NULL) != 0)
+		return -EINVAL;
+	return count;
+}
 #endif
 
 static struct device * next_device(struct klist_iter * i)
@@ -425,7 +454,8 @@ int bus_attach_device(struct device * dev)
 
 	if (bus) {
 		dev->is_registered = 1;
-		ret = device_attach(dev);
+		if (bus->drivers_autoprobe)
+			ret = device_attach(dev);
 		if (ret >= 0) {
 			klist_add_tail(&dev->knode_bus, &bus->klist_devices);
 			ret = 0;
@@ -515,9 +545,41 @@ static void remove_bind_files(struct device_driver *drv)
 	driver_remove_file(drv, &driver_attr_bind);
 	driver_remove_file(drv, &driver_attr_unbind);
 }
+
+static int add_probe_files(struct bus_type *bus)
+{
+	int retval;
+
+	bus->drivers_probe_attr.attr.name = "drivers_probe";
+	bus->drivers_probe_attr.attr.mode = S_IWUSR;
+	bus->drivers_probe_attr.attr.owner = bus->owner;
+	bus->drivers_probe_attr.store = store_drivers_probe;
+	retval = bus_create_file(bus, &bus->drivers_probe_attr);
+	if (retval)
+		goto out;
+
+	bus->drivers_autoprobe_attr.attr.name = "drivers_autoprobe";
+	bus->drivers_autoprobe_attr.attr.mode = S_IWUSR | S_IRUGO;
+	bus->drivers_autoprobe_attr.attr.owner = bus->owner;
+	bus->drivers_autoprobe_attr.show = show_drivers_autoprobe;
+	bus->drivers_autoprobe_attr.store = store_drivers_autoprobe;
+	retval = bus_create_file(bus, &bus->drivers_autoprobe_attr);
+	if (retval)
+		bus_remove_file(bus, &bus->drivers_probe_attr);
+out:
+	return retval;
+}
+
+static void remove_probe_files(struct bus_type *bus)
+{
+	bus_remove_file(bus, &bus->drivers_autoprobe_attr);
+	bus_remove_file(bus, &bus->drivers_probe_attr);
+}
 #else
 static inline int add_bind_files(struct device_driver *drv) { return 0; }
 static inline void remove_bind_files(struct device_driver *drv) {}
+static inline int add_probe_files(struct bus_type *bus) { return 0; }
+static inline void remove_probe_files(struct bus_type *bus) {}
 #endif
 
 /**
@@ -541,9 +603,11 @@ int bus_add_driver(struct device_driver *drv)
 	if ((error = kobject_register(&drv->kobj)))
 		goto out_put_bus;
 
-	error = driver_attach(drv);
-	if (error)
-		goto out_unregister;
+	if (drv->bus->drivers_autoprobe) {
+		error = driver_attach(drv);
+		if (error)
+			goto out_unregister;
+	}
 	klist_add_tail(&drv->knode_bus, &bus->klist_drivers);
 	module_add_driver(drv->owner, drv);
 
@@ -762,6 +826,12 @@ int bus_register(struct bus_type * bus)
 
 	klist_init(&bus->klist_devices, klist_devices_get, klist_devices_put);
 	klist_init(&bus->klist_drivers, NULL, NULL);
+
+	bus->drivers_autoprobe = 1;
+	retval = add_probe_files(bus);
+	if (retval)
+		goto bus_probe_files_fail;
+
 	retval = bus_add_attrs(bus);
 	if (retval)
 		goto bus_attrs_fail;
@@ -770,6 +840,8 @@ int bus_register(struct bus_type * bus)
 	return 0;
 
 bus_attrs_fail:
+	remove_probe_files(bus);
+bus_probe_files_fail:
 	kset_unregister(&bus->drivers);
 bus_drivers_fail:
 	kset_unregister(&bus->devices);
@@ -779,7 +851,6 @@ out:
 	return retval;
 }
 
-
 /**
  *	bus_unregister - remove a bus from the system
  *	@bus:	bus.
@@ -791,6 +862,7 @@ void bus_unregister(struct bus_type * bus)
 {
 	pr_debug("bus %s: unregistering\n", bus->name);
 	bus_remove_attrs(bus);
+	remove_probe_files(bus);
 	kset_unregister(&bus->drivers);
 	kset_unregister(&bus->devices);
 	subsystem_unregister(&bus->subsys);
diff --git a/include/linux/device.h b/include/linux/device.h
index de0e73e..9d54fe1 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -34,9 +34,24 @@ struct device;
 struct device_driver;
 struct class;
 struct class_device;
+struct bus_type;
+
+struct bus_attribute {
+	struct attribute	attr;
+	ssize_t (*show)(struct bus_type *, char * buf);
+	ssize_t (*store)(struct bus_type *, const char * buf, size_t count);
+};
+
+#define BUS_ATTR(_name,_mode,_show,_store)	\
+struct bus_attribute bus_attr_##_name = __ATTR(_name,_mode,_show,_store)
+
+extern int __must_check bus_create_file(struct bus_type *,
+					struct bus_attribute *);
+extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
 
 struct bus_type {
 	const char		* name;
+	struct module		* owner;
 
 	struct subsystem	subsys;
 	struct kset		drivers;
@@ -49,6 +64,8 @@ struct bus_type {
 	struct bus_attribute	* bus_attrs;
 	struct device_attribute	* dev_attrs;
 	struct driver_attribute	* drv_attrs;
+	struct bus_attribute drivers_autoprobe_attr;
+	struct bus_attribute drivers_probe_attr;
 
 	int		(*match)(struct device * dev, struct device_driver * drv);
 	int		(*uevent)(struct device *dev, char **envp,
@@ -61,6 +78,8 @@ struct bus_type {
 	int (*suspend_late)(struct device * dev, pm_message_t state);
 	int (*resume_early)(struct device * dev);
 	int (*resume)(struct device * dev);
+
+	unsigned int drivers_autoprobe:1;
 };
 
 extern int __must_check bus_register(struct bus_type * bus);
@@ -102,21 +121,6 @@ extern int bus_unregister_notifier(struct bus_type *bus,
 #define BUS_NOTIFY_UNBIND_DRIVER	0x00000004 /* driver about to be
 						      unbound */
 
-/* sysfs interface for exporting bus attributes */
-
-struct bus_attribute {
-	struct attribute	attr;
-	ssize_t (*show)(struct bus_type *, char * buf);
-	ssize_t (*store)(struct bus_type *, const char * buf, size_t count);
-};
-
-#define BUS_ATTR(_name,_mode,_show,_store)	\
-struct bus_attribute bus_attr_##_name = __ATTR(_name,_mode,_show,_store)
-
-extern int __must_check bus_create_file(struct bus_type *,
-					struct bus_attribute *);
-extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
-
 struct device_driver {
 	const char		* name;
 	struct bus_type		* bus;
-- 
1.5.1.2
