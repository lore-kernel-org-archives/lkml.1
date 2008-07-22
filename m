Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbYGVFjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbYGVFjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757252AbYGVFZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:25:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:43286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757455AbYGVFZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:25:19 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 54/79] driver core: fix a lot of printk usages of bus_id
Date: Mon, 21 Jul 2008 22:19:18 -0700
Message-Id: <1216703983-21448-54-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have the dev_printk() variants for this kind of thing, use them
instead of directly trying to access the bus_id field of struct device.

This is done in order to remove bus_id entirely.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/arm/common/dmabounce.c       |   22 +++++++++-------------
 arch/arm/common/sa1111.c          |    3 ++-
 arch/arm/kernel/ecard.c           |    3 +--
 arch/arm/mach-integrator/impd1.c  |    3 +--
 arch/powerpc/platforms/chrp/pci.c |    2 +-
 arch/x86/kernel/pci-dma.c         |    6 ++----
 arch/x86/kernel/pci-gart_64.c     |    4 +---
 drivers/acpi/fan.c                |   10 +++++-----
 drivers/acpi/glue.c               |    6 ++----
 drivers/acpi/processor_core.c     |    5 ++---
 drivers/acpi/scan.c               |    2 +-
 drivers/acpi/thermal.c            |    4 ++--
 drivers/acpi/video.c              |    5 ++---
 drivers/base/power/trace.c        |    2 +-
 14 files changed, 32 insertions(+), 45 deletions(-)

diff --git a/arch/arm/common/dmabounce.c b/arch/arm/common/dmabounce.c
index 2744673..dd29473 100644
--- a/arch/arm/common/dmabounce.c
+++ b/arch/arm/common/dmabounce.c
@@ -554,9 +554,8 @@ dmabounce_register_dev(struct device *dev, unsigned long small_buffer_size,
 
 	device_info = kmalloc(sizeof(struct dmabounce_device_info), GFP_ATOMIC);
 	if (!device_info) {
-		printk(KERN_ERR
-			"Could not allocated dmabounce_device_info for %s",
-			dev->bus_id);
+		dev_err(dev,
+			"Could not allocated dmabounce_device_info\n");
 		return -ENOMEM;
 	}
 
@@ -594,8 +593,7 @@ dmabounce_register_dev(struct device *dev, unsigned long small_buffer_size,
 
 	dev->archdata.dmabounce = device_info;
 
-	printk(KERN_INFO "dmabounce: registered device %s on %s bus\n",
-		dev->bus_id, dev->bus->name);
+	dev_info(dev, "dmabounce: registered device\n");
 
 	return 0;
 
@@ -614,16 +612,15 @@ dmabounce_unregister_dev(struct device *dev)
 	dev->archdata.dmabounce = NULL;
 
 	if (!device_info) {
-		printk(KERN_WARNING
-			"%s: Never registered with dmabounce but attempting" \
-			"to unregister!\n", dev->bus_id);
+		dev_warn(dev,
+			 "Never registered with dmabounce but attempting"
+			 "to unregister!\n");
 		return;
 	}
 
 	if (!list_empty(&device_info->safe_buffers)) {
-		printk(KERN_ERR
-			"%s: Removing from dmabounce with pending buffers!\n",
-			dev->bus_id);
+		dev_err(dev,
+			"Removing from dmabounce with pending buffers!\n");
 		BUG();
 	}
 
@@ -639,8 +636,7 @@ dmabounce_unregister_dev(struct device *dev)
 
 	kfree(device_info);
 
-	printk(KERN_INFO "dmabounce: device %s on %s bus unregistered\n",
-		dev->bus_id, dev->bus->name);
+	dev_info(dev, "dmabounce: device unregistered\n");
 }
 
 
diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index eb06d0b..2048ae0 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -593,7 +593,8 @@ sa1111_init_one_child(struct sa1111 *sachip, struct resource *parent,
 		if (dev->dma_mask != 0xffffffffUL) {
 			ret = dmabounce_register_dev(&dev->dev, 1024, 4096);
 			if (ret) {
-				printk("SA1111: Failed to register %s with dmabounce", dev->dev.bus_id);
+				dev_err(&dev->dev, "SA1111: Failed to register"
+					" with dmabounce\n");
 				device_unregister(&dev->dev);
 			}
 		}
diff --git a/arch/arm/kernel/ecard.c b/arch/arm/kernel/ecard.c
index 8bfd299..2de425f 100644
--- a/arch/arm/kernel/ecard.c
+++ b/arch/arm/kernel/ecard.c
@@ -853,8 +853,7 @@ static struct expansion_card *__init ecard_alloc_card(int type, int slot)
 	for (i = 0; i < ECARD_NUM_RESOURCES; i++) {
 		if (ec->resource[i].flags &&
 		    request_resource(&iomem_resource, &ec->resource[i])) {
-			printk(KERN_ERR "%s: resource(s) not available\n",
-				ec->dev.bus_id);
+			dev_err(&ec->dev, "resource(s) not available\n");
 			ec->resource[i].end -= ec->resource[i].start;
 			ec->resource[i].start = 0;
 			ec->resource[i].flags = 0;
diff --git a/arch/arm/mach-integrator/impd1.c b/arch/arm/mach-integrator/impd1.c
index 62e653a..619d05e 100644
--- a/arch/arm/mach-integrator/impd1.c
+++ b/arch/arm/mach-integrator/impd1.c
@@ -407,8 +407,7 @@ static int impd1_probe(struct lm_device *dev)
 
 		ret = amba_device_register(d, &dev->resource);
 		if (ret) {
-			printk("unable to register device %s: %d\n",
-				d->dev.bus_id, ret);
+			dev_err(&d->dev, "unable to register device: %d\n");
 			kfree(d);
 		}
 	}
diff --git a/arch/powerpc/platforms/chrp/pci.c b/arch/powerpc/platforms/chrp/pci.c
index 609c46d..768c262 100644
--- a/arch/powerpc/platforms/chrp/pci.c
+++ b/arch/powerpc/platforms/chrp/pci.c
@@ -367,7 +367,7 @@ static void chrp_pci_fixup_vt8231_ata(struct pci_dev *viaide)
 	viaisa = pci_get_device(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8231, NULL);
 	if (!viaisa)
 		return;
-	printk("Fixing VIA IDE, force legacy mode on '%s'\n", viaide->dev.bus_id);
+	dev_info(&viaide->dev, "Fixing VIA IDE, force legacy mode on\n");
 
 	pci_read_config_byte(viaide, PCI_CLASS_PROG, &progif);
 	pci_write_config_byte(viaide, PCI_CLASS_PROG, progif & ~0x5);
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index a4213c0..cbecb05 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -314,8 +314,7 @@ int dma_supported(struct device *dev, u64 mask)
 {
 #ifdef CONFIG_PCI
 	if (mask > 0xffffffff && forbid_dac > 0) {
-		printk(KERN_INFO "PCI: Disallowing DAC for device %s\n",
-				 dev->bus_id);
+		dev_info(dev, "PCI: Disallowing DAC for device\n");
 		return 0;
 	}
 #endif
@@ -342,8 +341,7 @@ int dma_supported(struct device *dev, u64 mask)
 	   type. Normally this doesn't make any difference, but gives
 	   more gentle handling of IOMMU overflow. */
 	if (iommu_sac_force && (mask >= DMA_40BIT_MASK)) {
-		printk(KERN_INFO "%s: Force SAC with mask %Lx\n",
-				 dev->bus_id, mask);
+		dev_info(dev, "Force SAC with mask %Lx\n", mask);
 		return 0;
 	}
 
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index be60961..df5f142 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -198,9 +198,7 @@ static void iommu_full(struct device *dev, size_t size, int dir)
 	 * out. Hopefully no network devices use single mappings that big.
 	 */
 
-	printk(KERN_ERR
-		"PCI-DMA: Out of IOMMU space for %lu bytes at device %s\n",
-		size, dev->bus_id);
+	dev_err(dev, "PCI-DMA: Out of IOMMU space for %lu bytes\n", size);
 
 	if (size > PAGE_SIZE*EMERGENCY_PAGES) {
 		if (dir == PCI_DMA_FROMDEVICE || dir == PCI_DMA_BIDIRECTIONAL)
diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 55c17af..2655bc1 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -263,22 +263,22 @@ static int acpi_fan_add(struct acpi_device *device)
 		goto end;
 	}
 
-	printk(KERN_INFO PREFIX
-		"%s is registered as cooling_device%d\n",
-		device->dev.bus_id, cdev->id);
+	dev_info(&device->dev, "registered as cooling_device%d\n", cdev->id);
 
 	acpi_driver_data(device) = cdev;
 	result = sysfs_create_link(&device->dev.kobj,
 				   &cdev->device.kobj,
 				   "thermal_cooling");
 	if (result)
-		printk(KERN_ERR PREFIX "Create sysfs link\n");
+		dev_err(&device->dev, "Failed to create sysfs link "
+			"'thermal_cooling'\n");
 
 	result = sysfs_create_link(&cdev->device.kobj,
 				   &device->dev.kobj,
 				   "device");
 	if (result)
-		printk(KERN_ERR PREFIX "Create sysfs link\n");
+		dev_err(&device->dev, "Failed to create sysfs link "
+			"'device'\n");
 
 	result = acpi_fan_add_fs(device);
 	if (result)
diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 2f173e8..0841095 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -146,8 +146,7 @@ static int acpi_bind_one(struct device *dev, acpi_handle handle)
 	acpi_status status;
 
 	if (dev->archdata.acpi_handle) {
-		printk(KERN_WARNING PREFIX
-		       "Drivers changed 'acpi_handle' for %s\n", dev->bus_id);
+		dev_warn(dev, "Drivers changed 'acpi_handle'\n");
 		return -EINVAL;
 	}
 	get_device(dev);
@@ -195,8 +194,7 @@ static int acpi_unbind_one(struct device *dev)
 		/* acpi_bind_one increase refcnt by one */
 		put_device(dev);
 	} else {
-		printk(KERN_ERR PREFIX
-		       "Oops, 'acpi_handle' corrupt for %s\n", dev->bus_id);
+		dev_err(dev, "Oops, 'acpi_handle' corrupt\n");
 	}
 	return 0;
 }
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index ec0f2d5..e36422a 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -714,9 +714,8 @@ static int __cpuinit acpi_processor_start(struct acpi_device *device)
 		goto end;
 	}
 
-	printk(KERN_INFO PREFIX
-		"%s is registered as cooling_device%d\n",
-		device->dev.bus_id, pr->cdev->id);
+	dev_info(&device->dev, "registered as cooling_device%d\n",
+		 pr->cdev->id);
 
 	result = sysfs_create_link(&device->dev.kobj,
 				   &pr->cdev->device.kobj,
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index f3132aa..f6f52c1 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -471,7 +471,7 @@ static int acpi_device_register(struct acpi_device *device,
 	device->dev.release = &acpi_device_release;
 	result = device_add(&device->dev);
 	if(result) {
-		printk(KERN_ERR PREFIX "Error adding device %s", device->dev.bus_id);
+		dev_err(&device->dev, "Error adding device\n");
 		goto end;
 	}
 
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 84c795f..30a3413 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -1179,8 +1179,8 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
 
 	tz->tz_enabled = 1;
 
-	printk(KERN_INFO PREFIX "%s is registered as thermal_zone%d\n",
-			tz->device->dev.bus_id, tz->thermal_zone->id);
+	dev_info(&tz->device->dev, "registered as thermal_zone%d\n",
+		 tz->thermal_zone->id);
 	return 0;
 }
 
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 64c8893..37b9e16 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -762,9 +762,8 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 		if (IS_ERR(device->cdev))
 			return;
 
-		printk(KERN_INFO PREFIX
-			"%s is registered as cooling_device%d\n",
-			device->dev->dev.bus_id, device->cdev->id);
+		dev_info(&device->dev->dev, "registered as cooling_device%d\n",
+			 device->cdev->id);
 		result = sysfs_create_link(&device->dev->dev.kobj,
 				&device->cdev->device.kobj,
 				"thermal_cooling");
diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
index 9b1b20b..2aa6e8f 100644
--- a/drivers/base/power/trace.c
+++ b/drivers/base/power/trace.c
@@ -194,7 +194,7 @@ static int show_dev_hash(unsigned int value)
 		struct device * dev = to_device(entry);
 		unsigned int hash = hash_string(DEVSEED, dev->bus_id, DEVHASH);
 		if (hash == value) {
-			printk("  hash matches device %s\n", dev->bus_id);
+			dev_info(dev, "hash matches\n");
 			match++;
 		}
 		entry = entry->prev;
-- 
1.5.6.3

