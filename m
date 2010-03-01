Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab0CAQAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:00:39 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61735 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab0CAQAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:00:35 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5907"; a="35172069"
Message-ID: <4B8BE489.7020402@codeaurora.org>
Date: Mon, 01 Mar 2010 09:00:09 -0700
From: Jordan Crouse <jcrouse@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: dri-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH] drm: Allow platform devices to register as DRM devices
References: <4B8BE42C.1090401@codeaurora.org>
In-Reply-To: <4B8BE42C.1090401@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Allow platform devices without PCI resources to be DRM devices.

Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
---

  drivers/gpu/drm/Kconfig             |    4 -
  drivers/gpu/drm/Makefile            |    2
  drivers/gpu/drm/drm_bufs.c          |   27 ++++++-
  drivers/gpu/drm/drm_drv.c           |   38 +--------
  drivers/gpu/drm/drm_edid.c          |    3 +
  drivers/gpu/drm/drm_info.c          |   23 ++++--
  drivers/gpu/drm/drm_ioctl.c         |   70 ++++++++++++-----
  drivers/gpu/drm/drm_irq.c           |   16 ++--
  drivers/gpu/drm/drm_pci.c           |  142 
+++++++++++++++++++++++++++++++++++
  drivers/gpu/drm/drm_platform.c      |  121 ++++++++++++++++++++++++++++++
  drivers/gpu/drm/drm_stub.c          |   90 +---------------------
  drivers/gpu/drm/drm_sysfs.c         |    7 +-
  drivers/gpu/drm/drm_vm.c            |   14 +++
  drivers/gpu/drm/i915/i915_drv.c     |    2
  drivers/gpu/drm/radeon/radeon_drv.c |    2
  include/drm/drmP.h                  |   52 +++++++++++--
  16 files changed, 444 insertions(+), 169 deletions(-)
  create mode 100644 drivers/gpu/drm/drm_platform.c

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 305c590..c2f43cc 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -6,7 +6,7 @@
  #
  menuconfig DRM
  	tristate "Direct Rendering Manager (XFree86 4.1.0 and higher DRI 
support)"
-	depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG && MMU
+	depends on !EMULATED_CMPXCHG && MMU
  	select I2C
  	select I2C_ALGOBIT
  	help
@@ -16,7 +16,7 @@ menuconfig DRM
  	  These modules provide support for synchronization, security, and
  	  DMA transfers. Please see <http://dri.sourceforge.net/> for more
  	  details.  You should also select and configure AGP
-	  (/dev/agpgart) support.
+	  (/dev/agpgart) support if it is available for your platform.

  config DRM_KMS_HELPER
  	tristate
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 39c5aa7..a3ea7c6 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -9,7 +9,7 @@ drm-y       :=	drm_auth.o drm_bufs.o drm_cache.o \
  		drm_drv.o drm_fops.o drm_gem.o drm_ioctl.o drm_irq.o \
  		drm_lock.o drm_memory.o drm_proc.o drm_stub.o drm_vm.o \
  		drm_agpsupport.o drm_scatter.o ati_pcigart.o drm_pci.o \
-		drm_sysfs.o drm_hashtab.o drm_sman.o drm_mm.o \
+		drm_platform.o drm_sysfs.o drm_hashtab.o drm_sman.o drm_mm.o \
  		drm_crtc.o drm_modes.o drm_edid.o \
  		drm_info.o drm_debugfs.o drm_encoder_slave.o

diff --git a/drivers/gpu/drm/drm_bufs.c b/drivers/gpu/drm/drm_bufs.c
index 8417cc4..4177f60 100644
--- a/drivers/gpu/drm/drm_bufs.c
+++ b/drivers/gpu/drm/drm_bufs.c
@@ -11,6 +11,7 @@
   *
   * Copyright 1999, 2000 Precision Insight, Inc., Cedar Park, Texas.
   * Copyright 2000 VA Linux Systems, Inc., Sunnyvale, California.
+ * Copyright (c) 2009, Code Aurora Forum.
   * All Rights Reserved.
   *
   * Permission is hereby granted, free of charge, to any person obtaining a
@@ -40,13 +41,37 @@

  resource_size_t drm_get_resource_start(struct drm_device *dev, 
unsigned int resource)
  {
+	if (drm_core_check_feature(dev, DRIVER_USE_PLATFORM_DEVICE)) {
+		struct resource *r;
+		r = platform_get_resource(dev->platformdev, IORESOURCE_MEM,
+					     resource);
+
+		return r ? r->start : 0;
+	}
+
+#ifdef CONFIG_PCI
  	return pci_resource_start(dev->pdev, resource);
+#endif
+
+	return 0;
  }
  EXPORT_SYMBOL(drm_get_resource_start);

  resource_size_t drm_get_resource_len(struct drm_device *dev, unsigned 
int resource)
  {
+	if (drm_core_check_feature(dev, DRIVER_USE_PLATFORM_DEVICE)) {
+		struct resource *r;
+		r = platform_get_resource(dev->platformdev, IORESOURCE_MEM,
+			resource);
+
+		return r ? (r->end - r->start) : 0;
+	}
+
+#ifdef CONFIG_PCI
  	return pci_resource_len(dev->pdev, resource);
+#endif
+
+	return 0;
  }

  EXPORT_SYMBOL(drm_get_resource_len);
@@ -188,7 +213,7 @@ static int drm_addmap_core(struct drm_device * dev, 
resource_size_t offset,
  	switch (map->type) {
  	case _DRM_REGISTERS:
  	case _DRM_FRAME_BUFFER:
-#if !defined(__sparc__) && !defined(__alpha__) && !defined(__ia64__) && 
!defined(__powerpc64__) && !defined(__x86_64__)
+#if !defined(__sparc__) && !defined(__alpha__) && !defined(__ia64__) && 
!defined(__powerpc64__) && !defined(__x86_64__) && !defined(__arm__)
  		if (map->offset + (map->size-1) < map->offset ||
  		    map->offset < virt_to_phys(high_memory)) {
  			kfree(map);
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 766c468..b5171ed 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -24,6 +24,7 @@
   *
   * Copyright 1999, 2000 Precision Insight, Inc., Cedar Park, Texas.
   * Copyright 2000 VA Linux Systems, Inc., Sunnyvale, California.
+ * Copyright (c) 2009, Code Aurora Forum.
   * All Rights Reserved.
   *
   * Permission is hereby granted, free of charge, to any person obtaining a
@@ -242,47 +243,20 @@ int drm_lastclose(struct drm_device * dev)
   *
   * Initializes an array of drm_device structures, and attempts to
   * initialize all available devices, using consecutive minors, 
registering the
- * stubs and initializing the AGP device.
+ * stubs and initializing the device.
   *
   * Expands the \c DRIVER_PREINIT and \c DRIVER_POST_INIT macros before and
   * after the initialization for driver customization.
   */
  int drm_init(struct drm_driver *driver)
  {
-	struct pci_dev *pdev = NULL;
-	const struct pci_device_id *pid;
-	int i;
-
  	DRM_DEBUG("\n");
-
  	INIT_LIST_HEAD(&driver->device_list);

-	if (driver->driver_features & DRIVER_MODESET)
-		return pci_register_driver(&driver->pci_driver);
-
-	/* If not using KMS, fall back to stealth mode manual scanning. */
-	for (i = 0; driver->pci_driver.id_table[i].vendor != 0; i++) {
-		pid = &driver->pci_driver.id_table[i];
-
-		/* Loop around setting up a DRM device for each PCI device
-		 * matching our ID and device class.  If we had the internal
-		 * function that pci_get_subsys and pci_get_class used, we'd
-		 * be able to just pass pid in instead of doing a two-stage
-		 * thing.
-		 */
-		pdev = NULL;
-		while ((pdev =
-			pci_get_subsys(pid->vendor, pid->device, pid->subvendor,
-				       pid->subdevice, pdev)) != NULL) {
-			if ((pdev->class & pid->class_mask) != pid->class)
-				continue;
-
-			/* stealth mode requires a manual probe */
-			pci_dev_get(pdev);
-			drm_get_dev(pdev, pid, driver);
-		}
-	}
-	return 0;
+	if (driver->driver_features & DRIVER_USE_PLATFORM_DEVICE)
+		return drm_platform_init(driver);
+	else
+		return drm_pci_init(driver);
  }

  EXPORT_SYMBOL(drm_init);
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index ab6c973..48a14a0 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -1220,6 +1220,9 @@ struct edid *drm_get_edid(struct drm_connector 
*connector,
  	int ret;
  	struct edid *edid;

+	if (drm_core_check_feature(connector->dev, DRIVER_USE_PLATFORM_DEVICE))
+		return NULL;
+
  	edid = kmalloc(EDID_LENGTH * (MAX_EDID_EXT_NUM + 1),
  		       GFP_KERNEL);
  	if (edid == NULL) {
diff --git a/drivers/gpu/drm/drm_info.c b/drivers/gpu/drm/drm_info.c
index f0f6c6b..5ed9abd 100644
--- a/drivers/gpu/drm/drm_info.c
+++ b/drivers/gpu/drm/drm_info.c
@@ -51,13 +51,24 @@ int drm_name_info(struct seq_file *m, void *data)
  	if (!master)
  		return 0;

-	if (master->unique) {
-		seq_printf(m, "%s %s %s\n",
-			   dev->driver->pci_driver.name,
-			   pci_name(dev->pdev), master->unique);
+	if (drm_core_check_feature(dev, DRIVER_USE_PLATFORM_DEVICE)) {
+		if (master->unique) {
+			seq_printf(m, "%s %s\n",
+					dev->driver->platform_device->name,
+					master->unique);
+		} else {
+			seq_printf(m, "%s\n",
+				dev->driver->platform_device->name);
+		}
  	} else {
-		seq_printf(m, "%s %s\n", dev->driver->pci_driver.name,
-			   pci_name(dev->pdev));
+		if (master->unique) {
+			seq_printf(m, "%s %s %s\n",
+				dev->driver->pci_driver.name,
+				pci_name(dev->pdev), master->unique);
+		} else {
+			seq_printf(m, "%s %s\n", dev->driver->pci_driver.name,
+				pci_name(dev->pdev));
+		}
  	}

  	return 0;
diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index 9b9ff46..66f563a 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -11,6 +11,7 @@
   *
   * Copyright 1999 Precision Insight, Inc., Cedar Park, Texas.
   * Copyright 2000 VA Linux Systems, Inc., Sunnyvale, California.
+ * Copyright (c) 2009, Code Aurora Forum.
   * All Rights Reserved.
   *
   * Permission is hereby granted, free of charge, to any person obtaining a
@@ -132,32 +133,57 @@ static int drm_set_busid(struct drm_device *dev, 
struct drm_file *file_priv)
  	struct drm_master *master = file_priv->master;
  	int len;

-	if (master->unique != NULL)
-		return -EBUSY;
+	if (drm_core_check_feature(dev, DRIVER_USE_PLATFORM_DEVICE)) {
+		master->unique_len = 10 + strlen(dev->platformdev->name);
+		master->unique = kmalloc(master->unique_len + 1, GFP_KERNEL);

-	master->unique_len = 40;
-	master->unique_size = master->unique_len;
-	master->unique = kmalloc(master->unique_size, GFP_KERNEL);
-	if (master->unique == NULL)
-		return -ENOMEM;
+		if (master->unique == NULL)
+			return -ENOMEM;

-	len = snprintf(master->unique, master->unique_len, 
"pci:%04x:%02x:%02x.%d",
-		       drm_get_pci_domain(dev),
-		       dev->pdev->bus->number,
-		       PCI_SLOT(dev->pdev->devfn),
-		       PCI_FUNC(dev->pdev->devfn));
-	if (len >= master->unique_len)
-		DRM_ERROR("buffer overflow");
-	else
-		master->unique_len = len;
+		len = snprintf(master->unique, master->unique_len,
+			"platform:%s", dev->platformdev->name);

-	dev->devname = kmalloc(strlen(dev->driver->pci_driver.name) +
-			       master->unique_len + 2, GFP_KERNEL);
-	if (dev->devname == NULL)
-		return -ENOMEM;
+		if (len > master->unique_len)
+			DRM_ERROR("Unique buffer overflowed\n");

-	sprintf(dev->devname, "%s@%s", dev->driver->pci_driver.name,
-		master->unique);
+		dev->devname =
+			kmalloc(strlen(dev->platformdev->name) +
+				master->unique_len + 2, GFP_KERNEL);
+
+		if (dev->devname == NULL)
+			return -ENOMEM;
+
+		sprintf(dev->devname, "%s@%s", dev->platformdev->name,
+			master->unique);
+
+	} else {
+		master->unique_len = 40;
+		master->unique_size = master->unique_len;
+		master->unique = kmalloc(master->unique_size, GFP_KERNEL);
+		if (master->unique == NULL)
+			return -ENOMEM;
+
+		len = snprintf(master->unique, master->unique_len,
+			"pci:%04x:%02x:%02x.%d",
+			drm_get_pci_domain(dev),
+			dev->pdev->bus->number,
+			PCI_SLOT(dev->pdev->devfn),
+			PCI_FUNC(dev->pdev->devfn));
+		if (len >= master->unique_len)
+			DRM_ERROR("buffer overflow");
+		else
+			master->unique_len = len;
+
+		dev->devname =
+			kmalloc(strlen(dev->driver->pci_driver.name) +
+				master->unique_len + 2, GFP_KERNEL);
+
+		if (dev->devname == NULL)
+			return -ENOMEM;
+
+		sprintf(dev->devname, "%s@%s", dev->driver->pci_driver.name,
+			master->unique);
+	}

  	return 0;
  }
diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index b98384d..94a9792 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -11,6 +11,7 @@
   *
   * Copyright 1999, 2000 Precision Insight, Inc., Cedar Park, Texas.
   * Copyright 2000 VA Linux Systems, Inc., Sunnyvale, California.
+ * Copyright (c) 2009, Code Aurora Forum.
   * All Rights Reserved.
   *
   * Permission is hereby granted, free of charge, to any person obtaining a
@@ -56,6 +57,9 @@ int drm_irq_by_busid(struct drm_device *dev, void *data,
  {
  	struct drm_irq_busid *p = data;

+	if (drm_core_check_feature(dev, DRIVER_USE_PLATFORM_DEVICE))
+		return -EINVAL;
+
  	if (!drm_core_check_feature(dev, DRIVER_HAVE_IRQ))
  		return -EINVAL;

@@ -210,7 +214,7 @@ int drm_irq_install(struct drm_device *dev)
  	if (!drm_core_check_feature(dev, DRIVER_HAVE_IRQ))
  		return -EINVAL;

-	if (dev->pdev->irq == 0)
+	if (drm_dev_to_irq(dev) == 0)
  		return -EINVAL;

  	mutex_lock(&dev->struct_mutex);
@@ -228,7 +232,7 @@ int drm_irq_install(struct drm_device *dev)
  	dev->irq_enabled = 1;
  	mutex_unlock(&dev->struct_mutex);

-	DRM_DEBUG("irq=%d\n", dev->pdev->irq);
+	DRM_DEBUG("irq=%d\n", drm_dev_to_irq(dev));

  	/* Before installing handler */
  	dev->driver->irq_preinstall(dev);
@@ -301,14 +305,14 @@ int drm_irq_uninstall(struct drm_device * dev)
  	if (!irq_enabled)
  		return -EINVAL;

-	DRM_DEBUG("irq=%d\n", dev->pdev->irq);
+	DRM_DEBUG("irq=%d\n", drm_dev_to_irq(dev));

  	if (!drm_core_check_feature(dev, DRIVER_MODESET))
  		vga_client_register(dev->pdev, NULL, NULL, NULL);

  	dev->driver->irq_uninstall(dev);

-	free_irq(dev->pdev->irq, dev);
+	free_irq(drm_dev_to_irq(dev), dev);

  	return 0;
  }
@@ -340,7 +344,7 @@ int drm_control(struct drm_device *dev, void *data,
  		if (drm_core_check_feature(dev, DRIVER_MODESET))
  			return 0;
  		if (dev->if_version < DRM_IF_VERSION(1, 2) &&
-		    ctl->irq != dev->pdev->irq)
+		    ctl->irq != drm_dev_to_irq(dev))
  			return -EINVAL;
  		return drm_irq_install(dev);
  	case DRM_UNINST_HANDLER:
@@ -649,7 +653,7 @@ int drm_wait_vblank(struct drm_device *dev, void *data,
  	int ret = 0;
  	unsigned int flags, seq, crtc;

-	if ((!dev->pdev->irq) || (!dev->irq_enabled))
+	if ((!drm_dev_to_irq(dev)) || (!dev->irq_enabled))
  		return -EINVAL;

  	if (vblwait->request.type & _DRM_VBLANK_SIGNAL)
diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index e68ebf9..bd5f77d 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -15,6 +15,7 @@
  /*
   * Copyright 2003 José Fonseca.
   * Copyright 2003 Leif Delgass.
+ * Copyright (c) 2009, Code Aurora Forum.
   * All Rights Reserved.
   *
   * Permission is hereby granted, free of charge, to any person obtaining a
@@ -123,4 +124,145 @@ void drm_pci_free(struct drm_device * dev, 
drm_dma_handle_t * dmah)

  EXPORT_SYMBOL(drm_pci_free);

+#ifdef CONFIG_PCI
+/**
+ * Register.
+ *
+ * \param pdev - PCI device structure
+ * \param ent entry from the PCI ID table with device type flags
+ * \return zero on success or a negative number on failure.
+ *
+ * Attempt to gets inter module "drm" information. If we are first
+ * then register the character device and inter module information.
+ * Try and register, if we fail to register, backout previous work.
+ */
+int drm_get_pci_dev(struct pci_dev *pdev, const struct pci_device_id *ent,
+		    struct drm_driver *driver)
+{
+	struct drm_device *dev;
+	int ret;
+
+	DRM_DEBUG("\n");
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		goto err_g1;
+
+	pci_set_master(pdev);
+
+	dev->pdev = pdev;
+	dev->pci_device = pdev->device;
+	dev->pci_vendor = pdev->vendor;
+
+#ifdef __alpha__
+	dev->hose = pdev->sysdata;
+#endif
+
+	if ((ret = drm_fill_in_dev(dev, ent, driver))) {
+		printk(KERN_ERR "DRM: Fill_in_dev failed.\n");
+		goto err_g2;
+	}
+
+	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
+		pci_set_drvdata(pdev, dev);
+		ret = drm_get_minor(dev, &dev->control, DRM_MINOR_CONTROL);
+		if (ret)
+			goto err_g2;
+	}
+
+	if ((ret = drm_get_minor(dev, &dev->primary, DRM_MINOR_LEGACY)))
+		goto err_g3;
+
+	if (dev->driver->load) {
+		ret = dev->driver->load(dev, ent->driver_data);
+		if (ret)
+			goto err_g4;
+	}
+
+	/* setup the grouping for the legacy output */
+	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
+		ret = drm_mode_group_init_legacy_group(dev,
+						&dev->primary->mode_group);
+		if (ret)
+			goto err_g4;
+	}
+
+	list_add_tail(&dev->driver_item, &driver->device_list);
+
+	DRM_INFO("Initialized %s %d.%d.%d %s for %s on minor %d\n",
+		 driver->name, driver->major, driver->minor, driver->patchlevel,
+		 driver->date, pci_name(pdev), dev->primary->index);
+
+	return 0;
+
+err_g4:
+	drm_put_minor(&dev->primary);
+err_g3:
+	if (drm_core_check_feature(dev, DRIVER_MODESET))
+		drm_put_minor(&dev->control);
+err_g2:
+	pci_disable_device(pdev);
+err_g1:
+	kfree(dev);
+	return ret;
+}
+EXPORT_SYMBOL(drm_get_pci_dev);
+
+/**
+ * PCI device initialization. Called via drm_init at module load time,
+ *
+ * \return zero on success or a negative number on failure.
+ *
+ * Initializes a drm_device structures,registering the
+ * stubs and initializing the AGP device.
+ *
+ * Expands the \c DRIVER_PREINIT and \c DRIVER_POST_INIT macros before and
+ * after the initialization for driver customization.
+ */
+int drm_pci_init(struct drm_driver *driver)
+{
+	struct pci_dev *pdev = NULL;
+	const struct pci_device_id *pid;
+	int i;
+
+	if (driver->driver_features & DRIVER_MODESET)
+		return pci_register_driver(&driver->pci_driver);
+
+	/* If not using KMS, fall back to stealth mode manual scanning. */
+	for (i = 0; driver->pci_driver.id_table[i].vendor != 0; i++) {
+		pid = &driver->pci_driver.id_table[i];
+
+		/* Loop around setting up a DRM device for each PCI device
+		 * matching our ID and device class.  If we had the internal
+		 * function that pci_get_subsys and pci_get_class used, we'd
+		 * be able to just pass pid in instead of doing a two-stage
+		 * thing.
+		 */
+		pdev = NULL;
+		while ((pdev =
+			pci_get_subsys(pid->vendor, pid->device, pid->subvendor,
+				       pid->subdevice, pdev)) != NULL) {
+			if ((pdev->class & pid->class_mask) != pid->class)
+				continue;
+
+			/* stealth mode requires a manual probe */
+			pci_dev_get(pdev);
+			drm_get_pci_dev(pdev, pid, driver);
+		}
+	}
+	return 0;
+}
+
+#else
+
+int drm_pci_init(struct drm_driver *driver)
+{
+	return -1;
+}
+
+#endif
  /*@}*/
diff --git a/drivers/gpu/drm/drm_platform.c b/drivers/gpu/drm/drm_platform.c
new file mode 100644
index 0000000..af76a15
--- /dev/null
+++ b/drivers/gpu/drm/drm_platform.c
@@ -0,0 +1,121 @@
+/*
+ * Derived from drm_pci.c
+ *
+ * Copyright 2003 José Fonseca.
+ * Copyright 2003 Leif Delgass.
+ * Copyright (c) 2009, Code Aurora Forum.
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the 
"Software"),
+ * to deal in the Software without restriction, including without 
limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the 
next
+ * paragraph) shall be included in all copies or substantial portions 
of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT 
SHALL THE
+ * AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
CONNECTION
+ * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include "drmP.h"
+
+/**
+ * Register.
+ *
+ * \param platdev - Platform device struture
+ * \return zero on success or a negative number on failure.
+ *
+ * Attempt to gets inter module "drm" information. If we are first
+ * then register the character device and inter module information.
+ * Try and register, if we fail to register, backout previous work.
+ */
+
+int drm_get_platform_dev(struct platform_device *platdev,
+			 struct drm_driver *driver)
+{
+	struct drm_device *dev;
+	int ret;
+
+	DRM_DEBUG("\n");
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->platformdev = platdev;
+
+	ret = drm_fill_in_dev(dev, NULL, driver);
+
+	if (ret) {
+		printk(KERN_ERR "DRM: Fill_in_dev failed.\n");
+		goto err_g1;
+	}
+
+	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
+		dev_set_drvdata(&platdev->dev, dev);
+		ret = drm_get_minor(dev, &dev->control, DRM_MINOR_CONTROL);
+		if (ret)
+			goto err_g1;
+	}
+
+	ret = drm_get_minor(dev, &dev->primary, DRM_MINOR_LEGACY);
+	if (ret)
+		goto err_g2;
+
+	if (dev->driver->load) {
+		ret = dev->driver->load(dev, 0);
+		if (ret)
+			goto err_g3;
+	}
+
+	/* setup the grouping for the legacy output */
+	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
+		ret = drm_mode_group_init_legacy_group(dev,
+				&dev->primary->mode_group);
+		if (ret)
+			goto err_g3;
+	}
+
+	list_add_tail(&dev->driver_item, &driver->device_list);
+
+	DRM_INFO("Initialized %s %d.%d.%d %s on minor %d\n",
+		 driver->name, driver->major, driver->minor, driver->patchlevel,
+		 driver->date, dev->primary->index);
+
+	return 0;
+
+err_g3:
+	drm_put_minor(&dev->primary);
+err_g2:
+	if (drm_core_check_feature(dev, DRIVER_MODESET))
+		drm_put_minor(&dev->control);
+err_g1:
+	kfree(dev);
+	return ret;
+}
+EXPORT_SYMBOL(drm_get_platform_dev);
+
+/**
+ * Platform device initialization. Called via drm_init at module load time,
+ *
+ * \return zero on success or a negative number on failure.
+ *
+ * Initializes a drm_device structures,registering the
+ * stubs
+ *
+ * Expands the \c DRIVER_PREINIT and \c DRIVER_POST_INIT macros before and
+ * after the initialization for driver customization.
+ */
+
+int drm_platform_init(struct drm_driver *driver)
+{
+	return drm_get_platform_dev(driver->platform_device, driver);
+}
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index ad73e14..18294dd 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -9,6 +9,7 @@
   * Created: Fri Jan 19 10:48:35 2001 by faith@acm.org
   *
   * Copyright 2001 VA Linux Systems, Inc., Sunnyvale, California.
+ * Copyright (c) 2009, Code Aurora Forum.
   * All Rights Reserved.
   *
   * Permission is hereby granted, free of charge, to any person obtaining a
@@ -223,7 +224,7 @@ int drm_dropmaster_ioctl(struct drm_device *dev, 
void *data,
  	return 0;
  }

-static int drm_fill_in_dev(struct drm_device * dev, struct pci_dev *pdev,
+int drm_fill_in_dev(struct drm_device *dev,
  			   const struct pci_device_id *ent,
  			   struct drm_driver *driver)
  {
@@ -244,14 +245,6 @@ static int drm_fill_in_dev(struct drm_device * dev, 
struct pci_dev *pdev,

  	idr_init(&dev->drw_idr);

-	dev->pdev = pdev;
-	dev->pci_device = pdev->device;
-	dev->pci_vendor = pdev->vendor;
-
-#ifdef __alpha__
-	dev->hose = pdev->sysdata;
-#endif
-
  	if (drm_ht_create(&dev->map_hash, 12)) {
  		return -ENOMEM;
  	}
@@ -320,7 +313,7 @@ static int drm_fill_in_dev(struct drm_device * dev, 
struct pci_dev *pdev,
   * create the proc init entry via proc_init(). This routines assigns
   * minor numbers to secondary heads of multi-headed cards
   */
-static int drm_get_minor(struct drm_device *dev, struct drm_minor 
**minor, int type)
+int drm_get_minor(struct drm_device *dev, struct drm_minor **minor, int 
type)
  {
  	struct drm_minor *new_minor;
  	int ret;
@@ -387,83 +380,6 @@ err_idr:
  }

  /**
- * Register.
- *
- * \param pdev - PCI device structure
- * \param ent entry from the PCI ID table with device type flags
- * \return zero on success or a negative number on failure.
- *
- * Attempt to gets inter module "drm" information. If we are first
- * then register the character device and inter module information.
- * Try and register, if we fail to register, backout previous work.
- */
-int drm_get_dev(struct pci_dev *pdev, const struct pci_device_id *ent,
-		struct drm_driver *driver)
-{
-	struct drm_device *dev;
-	int ret;
-
-	DRM_DEBUG("\n");
-
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev)
-		return -ENOMEM;
-
-	ret = pci_enable_device(pdev);
-	if (ret)
-		goto err_g1;
-
-	pci_set_master(pdev);
-	if ((ret = drm_fill_in_dev(dev, pdev, ent, driver))) {
-		printk(KERN_ERR "DRM: Fill_in_dev failed.\n");
-		goto err_g2;
-	}
-
-	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
-		pci_set_drvdata(pdev, dev);
-		ret = drm_get_minor(dev, &dev->control, DRM_MINOR_CONTROL);
-		if (ret)
-			goto err_g2;
-	}
-
-	if ((ret = drm_get_minor(dev, &dev->primary, DRM_MINOR_LEGACY)))
-		goto err_g3;
-
-	if (dev->driver->load) {
-		ret = dev->driver->load(dev, ent->driver_data);
-		if (ret)
-			goto err_g4;
-	}
-
-        /* setup the grouping for the legacy output */
-	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
-		ret = drm_mode_group_init_legacy_group(dev, &dev->primary->mode_group);
-		if (ret)
-			goto err_g4;
-	}
-
-	list_add_tail(&dev->driver_item, &driver->device_list);
-
-	DRM_INFO("Initialized %s %d.%d.%d %s for %s on minor %d\n",
-		 driver->name, driver->major, driver->minor, driver->patchlevel,
-		 driver->date, pci_name(pdev), dev->primary->index);
-
-	return 0;
-
-err_g4:
-	drm_put_minor(&dev->primary);
-err_g3:
-	if (drm_core_check_feature(dev, DRIVER_MODESET))
-		drm_put_minor(&dev->control);
-err_g2:
-	pci_disable_device(pdev);
-err_g1:
-	kfree(dev);
-	return ret;
-}
-EXPORT_SYMBOL(drm_get_dev);
-
-/**
   * Put a secondary minor number.
   *
   * \param sec_minor - structure to be released
diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 7e42b7e..f795b31 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -7,6 +7,7 @@
   * Copyright (c) 2004 Jon Smirl <jonsmirl@gmail.com>
   * Copyright (c) 2003-2004 Greg Kroah-Hartman <greg@kroah.com>
   * Copyright (c) 2003-2004 IBM Corp.
+ * Copyright (c) 2009, Code Aurora Forum. All rights reserved.
   *
   * This file is released under the GPLv2
   *
@@ -486,7 +487,11 @@ int drm_sysfs_device_add(struct drm_minor *minor)
  	int err;
  	char *minor_str;

-	minor->kdev.parent = &minor->dev->pdev->dev;
+	if (minor->dev->platformdev != NULL)
+		minor->kdev.parent = &minor->dev->platformdev->dev;
+	else
+		minor->kdev.parent = &minor->dev->pdev->dev;
+
  	minor->kdev.class = drm_class;
  	minor->kdev.release = drm_sysfs_device_release;
  	minor->kdev.devt = minor->device;
diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index 4ac900f..22aaaae 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -60,7 +60,7 @@ static pgprot_t drm_io_prot(uint32_t map_type, struct 
vm_area_struct *vma)
  		tmp = pgprot_writecombine(tmp);
  	else
  		tmp = pgprot_noncached(tmp);
-#elif defined(__sparc__)
+#elif defined(__sparc__) || defined(__arm__)
  	tmp = pgprot_noncached(tmp);
  #endif
  	return tmp;
@@ -600,6 +600,7 @@ int drm_mmap_locked(struct file *filp, struct 
vm_area_struct *vma)
  	}

  	switch (map->type) {
+#if !defined(__arm__)
  	case _DRM_AGP:
  		if (drm_core_has_AGP(dev) && dev->agp->cant_use_aperture) {
  			/*
@@ -614,20 +615,31 @@ int drm_mmap_locked(struct file *filp, struct 
vm_area_struct *vma)
  			break;
  		}
  		/* fall through to _DRM_FRAME_BUFFER... */
+#endif
  	case _DRM_FRAME_BUFFER:
  	case _DRM_REGISTERS:
  		offset = dev->driver->get_reg_ofs(dev);
  		vma->vm_flags |= VM_IO;	/* not in core dump */
  		vma->vm_page_prot = drm_io_prot(map->type, vma);
+#if !defined(__arm__)
  		if (io_remap_pfn_range(vma, vma->vm_start,
  				       (map->offset + offset) >> PAGE_SHIFT,
  				       vma->vm_end - vma->vm_start,
  				       vma->vm_page_prot))
  			return -EAGAIN;
+#else
+		if (remap_pfn_range(vma, vma->vm_start,
+					(map->offset + offset) >> PAGE_SHIFT,
+					vma->vm_end - vma->vm_start,
+					vma->vm_page_prot))
+			return -EAGAIN;
+#endif
+
  		DRM_DEBUG("   Type = %d; start = 0x%lx, end = 0x%lx,"
  			  " offset = 0x%llx\n",
  			  map->type,
  			  vma->vm_start, vma->vm_end, (unsigned long long)(map->offset + 
offset));
+
  		vma->vm_ops = &drm_vm_ops;
  		break;
  	case _DRM_CONSISTENT:
diff --git a/drivers/gpu/drm/i915/i915_drv.c 
b/drivers/gpu/drm/i915/i915_drv.c
index cf4cb3e..29d26c2 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -392,7 +392,7 @@ int i965_reset(struct drm_device *dev, u8 flags)
  static int __devinit
  i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
  {
-	return drm_get_dev(pdev, ent, &driver);
+	return drm_get_pci_dev(pdev, ent, &driver);
  }

  static void
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c 
b/drivers/gpu/drm/radeon/radeon_drv.c
index 8ba3de7..6586f6a 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -223,7 +223,7 @@ static struct drm_driver kms_driver;
  static int __devinit
  radeon_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
  {
-	return drm_get_dev(pdev, ent, &kms_driver);
+	return drm_get_pci_dev(pdev, ent, &kms_driver);
  }

  static void
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index ffac157..2ef3701 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -9,6 +9,7 @@
  /*
   * Copyright 1999 Precision Insight, Inc., Cedar Park, Texas.
   * Copyright 2000 VA Linux Systems, Inc., Sunnyvale, California.
+ * Copyright (c) 2009, Code Aurora Forum.
   * All rights reserved.
   *
   * Permission is hereby granted, free of charge, to any person obtaining a
@@ -48,6 +49,7 @@
  #include <linux/proc_fs.h>
  #include <linux/init.h>
  #include <linux/file.h>
+#include <linux/platform_device.h>
  #include <linux/pci.h>
  #include <linux/jiffies.h>
  #include <linux/smp_lock.h>	/* For (un)lock_kernel */
@@ -143,6 +145,7 @@ extern void drm_ut_debug_printk(unsigned int 
request_level,
  #define DRIVER_IRQ_VBL2    0x800
  #define DRIVER_GEM         0x1000
  #define DRIVER_MODESET     0x2000
+#define DRIVER_USE_PLATFORM_DEVICE  0x4000

  /***********************************************************************/
  /** \name Begin the DRM... */
@@ -821,6 +824,7 @@ struct drm_driver {
  	int num_ioctls;
  	struct file_operations fops;
  	struct pci_driver pci_driver;
+	struct platform_device *platform_device;
  	/* List of devices hanging off this driver */
  	struct list_head device_list;
  };
@@ -1019,6 +1023,9 @@ struct drm_device {
  #ifdef __alpha__
  	struct pci_controller *hose;
  #endif
+
+	struct platform_device *platformdev;
+
  	struct drm_sg_mem *sg;	/**< Scatter gather memory */
  	int num_crtcs;                  /**< Number of CRTCs on this device */
  	void *dev_private;		/**< device private data */
@@ -1058,17 +1065,21 @@ struct drm_device {

  };

-static inline int drm_dev_to_irq(struct drm_device *dev)
-{
-	return dev->pdev->irq;
-}
-
  static __inline__ int drm_core_check_feature(struct drm_device *dev,
  					     int feature)
  {
  	return ((dev->driver->driver_features & feature) ? 1 : 0);
  }

+
+static inline int drm_dev_to_irq(struct drm_device *dev)
+{
+	if (drm_core_check_feature(dev, DRIVER_USE_PLATFORM_DEVICE))
+		return platform_get_irq(dev->platformdev, 0);
+	else
+		return dev->pdev->irq;
+}
+
  #ifdef __alpha__
  #define drm_get_pci_domain(dev) dev->hose->index
  #else
@@ -1349,8 +1360,11 @@ extern int drm_dropmaster_ioctl(struct drm_device 
*dev, void *data,
  struct drm_master *drm_master_create(struct drm_minor *minor);
  extern struct drm_master *drm_master_get(struct drm_master *master);
  extern void drm_master_put(struct drm_master **master);
-extern int drm_get_dev(struct pci_dev *pdev, const struct pci_device_id 
*ent,
-		       struct drm_driver *driver);
+extern int drm_get_pci_dev(struct pci_dev *pdev,
+			   const struct pci_device_id *ent,
+			   struct drm_driver *driver);
+extern int drm_get_platform_dev(struct platform_device *pdev,
+				struct drm_driver *driver);
  extern void drm_put_dev(struct drm_device *dev);
  extern int drm_put_minor(struct drm_minor **minor);
  extern unsigned int drm_debug;
@@ -1503,6 +1517,9 @@ static __inline__ struct drm_local_map 
*drm_core_findmap(struct drm_device *dev,

  static __inline__ int drm_device_is_agp(struct drm_device *dev)
  {
+	if (drm_core_check_feature(dev, DRIVER_USE_PLATFORM_DEVICE))
+		return 0;
+
  	if (dev->driver->device_is_agp != NULL) {
  		int err = (*dev->driver->device_is_agp) (dev);

@@ -1516,7 +1533,10 @@ static __inline__ int drm_device_is_agp(struct 
drm_device *dev)

  static __inline__ int drm_device_is_pcie(struct drm_device *dev)
  {
-	return pci_find_capability(dev->pdev, PCI_CAP_ID_EXP);
+	if (drm_core_check_feature(dev, DRIVER_USE_PLATFORM_DEVICE))
+		return 0;
+	else
+		return pci_find_capability(dev->pdev, PCI_CAP_ID_EXP);
  }

  static __inline__ void drm_core_dropmap(struct drm_local_map *map)
@@ -1556,6 +1576,22 @@ static __inline void drm_free_large(void *ptr)

  	vfree(ptr);
  }
+
+static inline void *drm_get_device(struct drm_device *dev)
+{
+	if (drm_core_check_feature(dev, DRIVER_USE_PLATFORM_DEVICE))
+		return dev->platformdev;
+	else
+		return dev->pdev;
+}
+
+extern int drm_platform_init(struct drm_driver *driver);
+extern int drm_pci_init(struct drm_driver *driver);
+extern int drm_fill_in_dev(struct drm_device *dev,
+			   const struct pci_device_id *ent,
+			   struct drm_driver *driver);
+int drm_get_minor(struct drm_device *dev, struct drm_minor **minor, int 
type);
+
  /*@}*/

  #endif				/* __KERNEL__ */
