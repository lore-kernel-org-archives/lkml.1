Return-Path: <linux-kernel-owner+w=401wt.eu-S1751242AbXAXLZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242AbXAXLZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 06:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXAXLZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 06:25:41 -0500
Received: from ipmail03.adl2.internode.on.net ([203.16.214.135]:53752 "EHLO
	ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242AbXAXLZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 06:25:39 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jan 2007 06:25:36 EST
X-IronPort-AV: i="4.13,231,1167571800"; 
   d="scan'208"; a="39454201:sNHT26133639"
From: airlied@linux.ie
To: linux-kernel@vger.kernel.org
Cc: Dave Airlie <airlied@linux.ie>
Subject: [PATCH] gpu: Initial gpu layer addition.
Date: Wed, 24 Jan 2007 22:20:19 +1100
Message-Id: <11696376332395-git-send-email-airlied@linux.ie>
X-Mailer: git-send-email 1.4.1.ga3e6
In-Reply-To: <1169637623985-git-send-email-airlied@linux.ie>
References: <1169637623985-git-send-email-airlied@linux.ie>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@linux.ie>

This is the new Linux GPU driver layer generic portion. It registers a bus
at system init time, and this bus can be used by lowlevel drivers to
create subdevices on the GPU bus. The other GPU drivers can be registered
via the lowlevel driver on the other subdevices.

Signed-off-by: Dave Airlie <airlied@linux.ie>
---
 drivers/video/Kconfig     |    4 
 drivers/video/Makefile    |    1 
 drivers/video/gpu_layer.c |  410 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/gpu_layer.h |  118 +++++++++++++
 4 files changed, 533 insertions(+), 0 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 4e83f01..acf2df0 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -4,6 +4,10 @@ #
 
 menu "Graphics support"
 
+config GPU
+	bool
+	default y
+
 config FIRMWARE_EDID
        bool "Enable firmware EDID"
        default y
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 309a26d..49c5d86 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -5,6 +5,7 @@ # Rewritten to use lists instead of if-s
 # Each configuration option enables a list of files.
 
 obj-y                             += fb_notify.o
+obj-$(CONFIG_GPU)                 += gpu_layer.o
 obj-$(CONFIG_FB)                  += fb.o
 fb-y                              := fbmem.o fbmon.o fbcmap.o fbsysfs.o \
                                      modedb.o fbcvt.o
diff --git a/drivers/video/gpu_layer.c b/drivers/video/gpu_layer.c
new file mode 100644
index 0000000..55bab96
--- /dev/null
+++ b/drivers/video/gpu_layer.c
@@ -0,0 +1,410 @@
+/*
+ * drivers/video/gpu_layer.c
+ *
+ * (C) Copyright Dave Airlie 2006
+ *
+ */
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/gpu_layer.h>
+
+/* GPUs we manage */
+static LIST_HEAD(gpu_bus_list);
+
+/* used when allocating bus numbers */
+#define GPU_MAXBUS		64
+struct gpu_busmap {
+	unsigned long busmap [GPU_MAXBUS / (8*sizeof (unsigned long))];
+};
+static struct gpu_busmap busmap;
+
+/* used when updating list of gpus */
+static DEFINE_MUTEX(gpu_bus_list_lock);
+
+
+/**
+ * gpu_bus_pci_match - Match a device using a PCI GPU
+ *
+ * Call the PCI match function using the generic identifier pointer to a PCI ID list.
+ */
+void *gpu_bus_pci_match(struct gpu_device *dev, struct gpu_driver *drv)
+{
+	struct pci_dev *pdev = to_pci_dev(dev->bus->gpu);
+	const struct pci_device_id *ids = (const struct pci_device_id *)drv->id_table, *match;
+
+	match = pci_match_id(ids, pdev);
+	return (void *)match;
+}
+EXPORT_SYMBOL(gpu_bus_pci_match);
+
+/**
+ * gpu_bus_match - Match a sub driver against a sub device
+ *
+ * If the driver type matches the device, call the bus match function.
+ */
+int gpu_bus_match(struct device *dev, struct device_driver *drv)
+{
+	struct gpu_device *gdev = to_gpu_device(dev);
+	struct gpu_driver *gdrv = to_gpu_driver(drv);
+
+	if (gdrv->drv_type == gdev->devnum) {
+		if (gdev->bus->match)
+			if (gdev->bus->match(gdev, gdrv))
+				return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(gpu_bus_match);
+
+/**
+ * gpu_uevent - empty so far
+ */
+static int gpu_uevent(struct device *dev, char **envp, int num_envp,
+		      char *buffer, int buffer_size)
+{
+	if (!dev)
+		return -ENODEV;
+
+	return 0;
+
+}
+
+/* Forward references */
+#ifdef CONFIG_PM
+static int gpu_suspend(struct device *dev, pm_message_t message);
+static int gpu_resume(struct device *dev);
+#endif
+
+/* GPU bus structure */
+struct bus_type gpu_bus_type = {
+	.name = "gpu",
+	.match = gpu_bus_match,
+	.uevent = gpu_uevent,
+#ifdef CONFIG_PM
+	.suspend = gpu_suspend,
+	.resume = gpu_resume,
+#endif
+};
+EXPORT_SYMBOL(gpu_bus_type);
+
+/**
+ * gpu_init - GPU subsystem initialise
+ *
+ * Register the GPU bus type
+ */
+static int __init gpu_init(void)
+{
+	return bus_register(&gpu_bus_type);
+}
+
+/**
+ * gpu_exit - GPU subsystem cleanup
+ *
+ * Unregister the bus
+ */
+static void __exit gpu_exit(void)
+{
+	bus_unregister(&gpu_bus_type);
+}
+
+/**
+ * gpu_bus_get - Reference count bus driver
+ */
+struct gpu_bus *gpu_bus_get(struct gpu_bus *bus)
+{
+	kref_get(&bus->kref);
+	return bus;
+}
+
+/**
+ * gpu_bus_release - Call bus release method
+ */
+static void gpu_bus_release(struct kref *kref)
+{
+	struct gpu_bus *bus = container_of(kref, struct gpu_bus, kref);
+
+	if (bus->release)
+		bus->release(bus);
+}
+
+/*
+ * gpu_bus_put - dereference count bus driver
+ */
+void gpu_bus_put(struct gpu_bus *bus)
+{
+	if (bus)
+		kref_put(&bus->kref, gpu_bus_release);
+}
+
+/**
+ * gpu_bus_init - init a bus structure
+ */
+void gpu_bus_init(struct gpu_bus *bus)
+{
+	bus->busnum = -1;
+	INIT_LIST_HEAD(&bus->bus_list);
+
+	kref_init(&bus->kref);
+}
+EXPORT_SYMBOL(gpu_bus_init);
+
+/**
+ * gpu_register_bus
+ *
+ * This registers a GPU bus with the GPU layer,
+ * it fills in a default bus match function, and adds the device to the list
+ */
+int gpu_register_bus(struct gpu_bus *bus)
+{
+	int busnum;
+
+	mutex_lock(&gpu_bus_list_lock);
+
+	busnum = find_next_zero_bit(busmap.busmap, GPU_MAXBUS, 1);
+	if (busnum < GPU_MAXBUS) {
+		set_bit(busnum, busmap.busmap);
+		bus->busnum = busnum;
+	} else {
+		printk(KERN_ERR "%s: too many buses\n", "gpu");
+		mutex_unlock(&gpu_bus_list_lock);
+		return -ENOSPC;
+	}
+
+	if (!bus->match)
+		if (bus->card_type==GPU_PCI)
+			bus->match = gpu_bus_pci_match;
+
+	list_add(&bus->bus_list, &gpu_bus_list);
+	mutex_unlock(&gpu_bus_list_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(gpu_register_bus);
+
+/**
+ * gpu_unregister_bus
+ *
+ * Unregister the bus driver from GPU list
+ */
+void gpu_unregister_bus(struct gpu_bus *bus)
+{
+	mutex_lock(&gpu_bus_list_lock);
+	list_del(&bus->bus_list);
+	clear_bit(bus->busnum, busmap.busmap);
+	mutex_unlock(&gpu_bus_list_lock);
+}
+EXPORT_SYMBOL(gpu_unregister_bus);
+
+/**
+ * gpu_alloc_devices
+ *
+ * Allocate and initialise the GPU sub-devices.
+ */
+int gpu_alloc_devices(struct gpu_bus *bus)
+{
+	struct gpu_device *dev;
+	int i;
+	int retval = 0;
+
+	for (i=0; i<bus->num_subdev; i++) {
+		dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+		if (!dev) {
+			retval = -ENOMEM;
+			goto cleanup;
+		}
+
+		bus = gpu_bus_get(bus);
+		if (!bus) {
+			kfree(dev);
+			retval = -ENOMEM;
+			goto cleanup;
+		}
+
+		device_initialize(&dev->dev);
+		dev->dev.bus = &gpu_bus_type;
+		dev->dev.parent = bus->gpu;
+		dev->card_type = bus->card_type;
+		sprintf(&dev->dev.bus_id[0], "%s:%d", bus->bus_name, i);
+		dev->bus = bus;
+		dev->devnum = i;
+
+		bus->devices[i] = dev;
+
+	}
+	return 0;
+cleanup:
+	for (i = 0; i < bus->num_subdev; i++) {
+		if (bus->devices[i]) {
+			kfree(bus->devices[i]);
+			bus->devices[i]= NULL;
+		}
+	}
+	return retval;
+}
+EXPORT_SYMBOL(gpu_alloc_devices);
+
+/**
+ * gpu_register_devices
+ *
+ * Add the gpu sub-devices to the device tree
+ */
+int gpu_register_devices(struct gpu_bus *bus)
+{
+	int retval;
+	int i;
+
+	for (i = 0; i < bus->num_subdev; i++) {
+		struct gpu_device *gpu_dev = bus->devices[i];
+
+		retval = device_add(&gpu_dev->dev);
+		if (retval) {
+			dev_err(&gpu_dev->dev, "can't device_add, error %d\n", retval);
+			goto fail;
+		}
+
+	}
+	return 0;
+
+fail:
+	for (i = 0; i < bus->num_subdev; i++) {
+		struct gpu_device *gpu_dev = bus->devices[i];
+
+		device_del(&gpu_dev->dev);
+	}
+	return retval;
+}
+EXPORT_SYMBOL(gpu_register_devices);
+
+/**
+ * gpu_unregister_devices
+ */
+int gpu_unregister_devices(struct gpu_bus *bus)
+{
+	int i;
+
+	for (i = 0; i < bus->num_subdev; i++) {
+		struct gpu_device *gpu_dev = bus->devices[i];
+
+		device_del(&gpu_dev->dev);
+
+		kfree(gpu_dev);
+		bus->devices[i] = NULL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(gpu_unregister_devices);
+
+/**
+ * gpu_probe
+ *
+ * Do a gpu bus probe - probe for GPU sub devices
+ */
+static int gpu_probe(struct device *dev)
+{
+	struct gpu_device *gdev = to_gpu_device(dev);
+	struct gpu_driver *gdrv;
+	int retval;
+	void *driver_id;
+
+	gdrv = to_gpu_driver(dev->driver);
+
+	/* call the bus matching function to get an identifier */
+	driver_id = gdev->bus->match(gdev, gdrv);
+	if (driver_id == NULL)
+		return -EINVAL;
+
+	/* call the driver probe function */
+
+	retval = gdrv->probe(gdev, driver_id);
+
+	printk("gpu probe called %d - %d\n", gdev->devnum, retval);
+	return retval;
+}
+
+/**
+ * gpu_remove
+ *
+ * Call the GPU remove sub device
+ */
+static int gpu_remove(struct device *dev)
+{
+	struct gpu_device *gdev = to_gpu_device(dev);
+	struct gpu_driver *gdrv;
+
+	gdrv = to_gpu_driver(dev->driver);
+
+	if (gdrv && gdrv->remove)
+		gdrv->remove(gdev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+/**
+ * gpu_suspend
+ *
+ * Suspend the devices on the GPU bus
+ */
+static int gpu_suspend(struct device *dev, pm_message_t state)
+{
+	struct gpu_driver *gdrv = to_gpu_driver(dev->driver);
+
+	if (gdrv && gdrv->driver.suspend)
+		return gdrv->driver.suspend(dev, state);
+
+	return 0;
+}
+
+/**
+ * gpu_resume
+ *
+ * Resume the devices on the GPU bus
+ */
+static int gpu_resume(struct device *dev)
+{
+	struct gpu_driver *gdrv = to_gpu_driver(dev->driver);
+
+	if (gdrv && gdrv->driver.resume)
+		return gdrv->driver.resume(dev);
+
+	return 0;
+}
+#endif
+
+/**
+ * gpu_register_driver
+ *
+ * Register a GPU driver and fill in its common structure members
+ */
+int gpu_register_driver(struct gpu_driver *new_driver, struct module *owner)
+{
+	int retval;
+
+	new_driver->driver.bus = &gpu_bus_type;
+	new_driver->driver.name = (char *)new_driver->name;
+	new_driver->driver.probe = gpu_probe;
+	new_driver->driver.remove = gpu_remove;
+	new_driver->driver.owner = owner;
+
+	retval = driver_register(&new_driver->driver);
+
+	return retval;
+}
+EXPORT_SYMBOL(gpu_register_driver);
+
+/**
+ * gpu_unregister_driver
+ *
+ * Call the driver unregister
+ */
+void gpu_unregister_driver(struct gpu_driver *driver)
+{
+	driver_unregister(&driver->driver);
+}
+EXPORT_SYMBOL(gpu_unregister_driver);
+
+subsys_initcall(gpu_init);
+module_exit(gpu_exit);
+
diff --git a/include/linux/gpu_layer.h b/include/linux/gpu_layer.h
new file mode 100644
index 0000000..ac0c003
--- /dev/null
+++ b/include/linux/gpu_layer.h
@@ -0,0 +1,118 @@
+/*
+ * include/linux/gpu_layer.h
+ *
+ * Author : Dave Airlie <airlied@linux.ie>
+ * Copyright (C) 2006 David Airlie
+ *
+ */
+
+#ifndef _LINUX_GPU_LAYER_H
+#define _LINUX_GPU_LAYER_H
+
+/* GPU subdevices - 0 is the root hub equivalent */
+#define GPU_LL 0
+#define GPU_FB 1
+#define GPU_DRM 2
+#define GPU_LAST (GPU_DRM+1)
+
+/* GPU device type - PCI only supported so far */
+#define GPU_PCI 1
+#define GPU_USB 2
+
+struct gpu_bus;
+struct gpu_driver;
+
+/*
+ * The gpu_device structure is used to describe GPU devices
+ */
+struct gpu_device {
+	int devnum;                     /* subdevice number */
+	int card_type;                  /* type of card - PCI, USB etc. */
+	struct device dev;		/* Generic device interface */
+	struct gpu_bus *bus;            /* pointer to gpu bus this driver is on */
+};
+#define	to_gpu_device(d) container_of(d, struct gpu_device, dev)
+
+/*
+ * This structure stores the GPU virtual bus description.
+ */
+struct gpu_bus {
+	struct device *gpu; /* pointer to the GPU itself device */
+	int num_subdev;     /* number of subdevices on this bus */
+
+	int card_type;      /* type of card this bus is running on */
+
+	int busnum;         /* GPU bus number */
+	char *bus_name;     /* bus name */
+
+	void *gpu_priv;       /* gpu private data */
+	struct list_head bus_list;	/* list of busses */
+
+	struct kref kref;   /* kobject reference */
+
+	struct gpu_device *devices[GPU_LAST]; /* array of GPU subdevices */
+
+	void *(*match)(struct gpu_device *dev, struct gpu_driver *drv); /* match function */
+
+	void (*release)(struct gpu_bus *bus); /* bus release function */
+};
+
+/*
+ * This structure stores the GPU driver information
+ */
+struct gpu_driver {
+	struct device_driver driver;     /* embedded driver structure */
+
+	/* use a full PCI device table */
+	const void *id_table;            /* generic pointer to an ID table - PCI or USB */
+
+	int drv_type;                    /* driver sub-driver type - LL/DRM/FB */
+	int card_type;                   /* card type PCI/USB */
+	char *name;                      /* driver name */
+
+	/* match function */
+	int (*probe)(struct gpu_device *dev, void *driver_id); /* probe function */
+	void (*remove)(struct gpu_device *dev);                /* remove function */
+
+};
+#define to_gpu_driver(d) container_of(d, struct gpu_driver, driver)
+
+/*
+ * GPU Information
+ */
+struct gpu_info {
+
+	struct gpu_bus self;	/* pointer to the bus on this device */
+
+	struct device *device; /* pointer to device */
+};
+
+/*
+ * driver-specific data.  They are really just a wrapper around
+ * the generic device structure functions of these calls.
+ */
+static inline void *gpu_get_drvdata(struct gpu_device *gdev)
+{
+	return dev_get_drvdata(&gdev->dev);
+}
+
+static inline void gpu_set_drvdata(struct gpu_device *gdev, void *data)
+{
+	dev_set_drvdata(&gdev->dev, data);
+}
+
+extern void gpu_bus_init(struct gpu_bus *bus);
+extern int gpu_register_bus(struct gpu_bus *bus);
+extern void gpu_unregister_bus(struct gpu_bus *bus);
+extern int gpu_alloc_devices(struct gpu_bus *bus);
+extern int gpu_register_devices(struct gpu_bus *bus);
+extern int gpu_register_driver(struct gpu_driver *new_driver, struct module *owner);
+extern void gpu_unregister_driver(struct gpu_driver *driver);
+extern int gpu_unregister_devices(struct gpu_bus *bus);
+
+static inline int gpu_register(struct gpu_driver *driver)
+{
+	return gpu_register_driver(driver, THIS_MODULE);
+}
+
+#endif
-- 
1.4.1.ga3e6
