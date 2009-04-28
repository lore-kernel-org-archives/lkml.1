Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbZD1HoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbZD1HoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 03:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbZD1Hnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 03:43:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:42434 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbZD1Hnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:43:51 -0400
Message-ID: <49F6B350.9080703@kernel.org>
Date: Tue, 28 Apr 2009 00:42:08 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [RFC PATCH] use dev_set_name(,NULL) to prevent leaking
References: <20090416235452.GE21405@elte.hu> <alpine.LFD.2.00.0904161716270.4042@localhost.localdomain> <20090417131633.GA30578@elte.hu> <49E8FD0B.2050308@zytor.com> <49E96731.1000501@kernel.org> <alpine.LFD.2.00.0904181141100.4042@localhost.localdomain> <49EA27B9.3030004@kernel.org> <20090418192314.GA22107@suse.de> <ac3eb2510904181300v2593c36dua6c2420828860706@mail.gmail.com> <1240086446.2411.9.camel@poy> <20090418203718.GD30144@elte.hu> <49EA4EB9.2030307@kernel.org> <49F6B1E6.7050008@kernel.org>
In-Reply-To: <49F6B1E6.7050008@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


those about 1/3 dev_set_name() etc.

wonder if there is better way to do that


Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/arm/common/locomo.c                |    1 +
 arch/arm/common/sa1111.c                |    1 +
 arch/arm/kernel/ecard.c                 |    1 +
 arch/arm/mach-integrator/impd1.c        |    1 +
 arch/arm/mach-integrator/lm.c           |    4 ++++
 arch/ia64/sn/kernel/tiocx.c             |    1 +
 arch/mips/kernel/vpe.c                  |    1 +
 arch/parisc/kernel/drivers.c            |    1 +
 arch/powerpc/kernel/vio.c               |    1 +
 arch/powerpc/platforms/ps3/system-bus.c |    4 ++++
 arch/sparc/kernel/of_device_32.c        |    1 +
 arch/sparc/kernel/of_device_64.c        |    1 +
 arch/sparc/kernel/vio.c                 |    1 +
 drivers/acpi/scan.c                     |    1 +
 drivers/base/firmware_class.c           |    1 +
 drivers/base/platform.c                 |    1 +
 drivers/dio/dio.c                       |    3 +++
 drivers/dma/dmaengine.c                 |    1 +
 drivers/eisa/eisa-bus.c                 |    1 +
 drivers/firewire/fw-device.c            |    3 +++
 drivers/firmware/dmi-id.c               |    8 +++++++-
 21 files changed, 37 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/arm/common/locomo.c
===================================================================
--- linux-2.6.orig/arch/arm/common/locomo.c
+++ linux-2.6/arch/arm/common/locomo.c
@@ -559,6 +559,7 @@ locomo_init_one_child(struct locomo *lch
 
 	ret = device_register(&dev->dev);
 	if (ret) {
+		dev_set_name(&dev->dev, NULL);
  out:
 		kfree(dev);
 	}
Index: linux-2.6/arch/arm/common/sa1111.c
===================================================================
--- linux-2.6.orig/arch/arm/common/sa1111.c
+++ linux-2.6/arch/arm/common/sa1111.c
@@ -577,6 +577,7 @@ sa1111_init_one_child(struct sa1111 *sac
 	ret = device_register(&dev->dev);
 	if (ret) {
 		release_resource(&dev->res);
+		dev_set_name(&dev->dev, NULL);
 		kfree(dev);
 		goto out;
 	}
Index: linux-2.6/arch/arm/kernel/ecard.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/ecard.c
+++ linux-2.6/arch/arm/kernel/ecard.c
@@ -795,6 +795,7 @@ static void __init ecard_free_card(struc
 		if (ec->resource[i].flags)
 			release_resource(&ec->resource[i]);
 
+	dev_set_name(&ec->dev, NULL);
 	kfree(ec);
 }
 
Index: linux-2.6/arch/arm/mach-integrator/impd1.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-integrator/impd1.c
+++ linux-2.6/arch/arm/mach-integrator/impd1.c
@@ -412,6 +412,7 @@ static int impd1_probe(struct lm_device
 		ret = amba_device_register(d, &dev->resource);
 		if (ret) {
 			dev_err(&d->dev, "unable to register device: %d\n", ret);
+			dev_set_name(&d->dev, NULL);
 			kfree(d);
 		}
 	}
Index: linux-2.6/arch/arm/mach-integrator/lm.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-integrator/lm.c
+++ linux-2.6/arch/arm/mach-integrator/lm.c
@@ -71,6 +71,7 @@ static void lm_device_release(struct dev
 {
 	struct lm_device *d = to_lm_device(dev);
 
+	dev_set_name(&dev, NULL);
 	kfree(d);
 }
 
@@ -92,6 +93,9 @@ int lm_device_register(struct lm_device
 		if (ret)
 			release_resource(&dev->resource);
 	}
+	if (ret)
+		dev_set_name(&dev->dev, NULL);
+
 	return ret;
 }
 
Index: linux-2.6/arch/ia64/sn/kernel/tiocx.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/tiocx.c
+++ linux-2.6/arch/ia64/sn/kernel/tiocx.c
@@ -73,6 +73,7 @@ static int tiocx_uevent(struct device *d
 
 static void tiocx_bus_release(struct device *dev)
 {
+	dev_set_name(dev, NULL);
 	kfree(to_cx_dev(dev));
 }
 
Index: linux-2.6/arch/mips/kernel/vpe.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/vpe.c
+++ linux-2.6/arch/mips/kernel/vpe.c
@@ -1585,6 +1585,7 @@ out_reenable:
 	return 0;
 
 out_class:
+	dev_set_name(&vpe_device, NULL);
 	class_unregister(&vpe_class);
 out_chrdev:
 	unregister_chrdev(major, module_name);
Index: linux-2.6/arch/parisc/kernel/drivers.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/drivers.c
+++ linux-2.6/arch/parisc/kernel/drivers.c
@@ -427,6 +427,7 @@ struct parisc_device * create_tree_node(
 	dev->dev.dma_mask = &dev->dma_mask;
 	dev->dev.coherent_dma_mask = dev->dma_mask;
 	if (device_register(&dev->dev)) {
+		dev_set_name(&dev->dev, NULL);
 		kfree(dev);
 		return NULL;
 	}
Index: linux-2.6/arch/powerpc/kernel/vio.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/vio.c
+++ linux-2.6/arch/powerpc/kernel/vio.c
@@ -1246,6 +1246,7 @@ struct vio_dev *vio_register_device_node
 		printk(KERN_ERR "%s: failed to register device %s\n",
 				__func__, dev_name(&viodev->dev));
 		/* XXX free TCE table */
+		dev_set_name(&viodev->dev, NULL);
 		kfree(viodev);
 		return NULL;
 	}
Index: linux-2.6/arch/powerpc/platforms/ps3/system-bus.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/ps3/system-bus.c
+++ linux-2.6/arch/powerpc/platforms/ps3/system-bus.c
@@ -769,6 +769,10 @@ int ps3_system_bus_device_register(struc
 	pr_debug("%s:%d add %s\n", __func__, __LINE__, dev_name(&dev->core));
 
 	result = device_register(&dev->core);
+
+	if (result)
+		dev_set_name(&dev->core, NULL);
+
 	return result;
 }
 
Index: linux-2.6/arch/sparc/kernel/of_device_32.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/of_device_32.c
+++ linux-2.6/arch/sparc/kernel/of_device_32.c
@@ -587,6 +587,7 @@ build_resources:
 	if (of_device_register(op)) {
 		printk("%s: Could not register of device.\n",
 		       dp->full_name);
+		dev_set_name(&op->dev, NULL);
 		kfree(op);
 		op = NULL;
 	}
Index: linux-2.6/arch/sparc/kernel/of_device_64.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/of_device_64.c
+++ linux-2.6/arch/sparc/kernel/of_device_64.c
@@ -855,6 +855,7 @@ static struct of_device * __init scan_on
 	if (of_device_register(op)) {
 		printk("%s: Could not register of device.\n",
 		       dp->full_name);
+		dev_set_name(&op->dev, NULL);
 		kfree(op);
 		op = NULL;
 	}
Index: linux-2.6/arch/sparc/kernel/vio.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/vio.c
+++ linux-2.6/arch/sparc/kernel/vio.c
@@ -296,6 +296,7 @@ static struct vio_dev *vio_create_one(st
 	if (err) {
 		printk(KERN_ERR "VIO: Could not register device %s, err=%d\n",
 		       dev_name(&vdev->dev), err);
+		dev_set_name(&vdev->dev, NULL);
 		kfree(vdev);
 		return NULL;
 	}
Index: linux-2.6/drivers/acpi/scan.c
===================================================================
--- linux-2.6.orig/drivers/acpi/scan.c
+++ linux-2.6/drivers/acpi/scan.c
@@ -1325,6 +1325,7 @@ acpi_add_single_object(struct acpi_devic
 		*child = device;
 	else {
 		kfree(device->pnp.cid_list);
+		dev_set_name(&device->dev, NULL);
 		kfree(device);
 	}
 
Index: linux-2.6/drivers/base/firmware_class.c
===================================================================
--- linux-2.6.orig/drivers/base/firmware_class.c
+++ linux-2.6/drivers/base/firmware_class.c
@@ -330,6 +330,7 @@ static int fw_register_device(struct dev
 
 error_kfree:
 	kfree(fw_priv);
+	dev_set_name(f_dev, NULL);
 	kfree(f_dev);
 	return retval;
 }
Index: linux-2.6/drivers/base/platform.c
===================================================================
--- linux-2.6.orig/drivers/base/platform.c
+++ linux-2.6/drivers/base/platform.c
@@ -293,6 +293,7 @@ int platform_device_add(struct platform_
 		return ret;
 
  failed:
+	dev_set_name(&pdev->dev, NULL);
 	while (--i >= 0) {
 		struct resource *r = &pdev->resource[i];
 		unsigned long type = resource_type(r);
Index: linux-2.6/drivers/dio/dio.c
===================================================================
--- linux-2.6.orig/drivers/dio/dio.c
+++ linux-2.6/drivers/dio/dio.c
@@ -186,6 +186,7 @@ static int __init dio_init(void)
 	error = device_register(&dio_bus.dev);
 	if (error) {
 		pr_err("DIO: Error registering dio_bus\n");
+		dev_set_name(&dio_bus.dev, NULL);
 		return error;
 	}
 
@@ -261,6 +262,8 @@ static int __init dio_init(void)
 		if (error) {
 			pr_err("DIO: Error registering device %s\n",
 			       dev->name);
+			dev_set_name(&dev->dev, NULL);
+			kfree(dev);
 			continue;
 		}
 		error = dio_create_sysfs_dev_files(dev);
Index: linux-2.6/drivers/dma/dmaengine.c
===================================================================
--- linux-2.6.orig/drivers/dma/dmaengine.c
+++ linux-2.6/drivers/dma/dmaengine.c
@@ -699,6 +699,7 @@ int dma_async_device_register(struct dma
 		if (rc) {
 			free_percpu(chan->local);
 			chan->local = NULL;
+			dev_set_name(&chan->dev->device, NULL);
 			kfree(chan->dev);
 			atomic_dec(idr_ref);
 			goto err_out;
Index: linux-2.6/drivers/eisa/eisa-bus.c
===================================================================
--- linux-2.6.orig/drivers/eisa/eisa-bus.c
+++ linux-2.6/drivers/eisa/eisa-bus.c
@@ -322,6 +322,7 @@ static int __init eisa_probe (struct eis
 
 	if (eisa_init_device (root, edev, 0)) {
 		eisa_release_resources (edev);
+		dev_set_name(&edev->dev, NULL);
 		kfree (edev);
 		if (!root->force_probe)
 			return -ENODEV;
Index: linux-2.6/drivers/firewire/fw-device.c
===================================================================
--- linux-2.6.orig/drivers/firewire/fw-device.c
+++ linux-2.6/drivers/firewire/fw-device.c
@@ -529,6 +529,7 @@ static void fw_unit_release(struct devic
 {
 	struct fw_unit *unit = fw_unit(dev);
 
+	dev_set_name(dev, NULL);
 	kfree(unit);
 }
 
@@ -579,6 +580,7 @@ static void create_units(struct fw_devic
 		continue;
 
 	skip_unit:
+		dev_set_name(&unit->device, NULL);
 		kfree(unit);
 	}
 }
@@ -675,6 +677,7 @@ static void fw_device_release(struct dev
 
 	fw_node_put(device->node);
 	kfree(device->config_rom);
+	dev_set_name(dev, NULL);
 	kfree(device);
 	fw_card_put(card);
 }
Index: linux-2.6/drivers/firmware/dmi-id.c
===================================================================
--- linux-2.6.orig/drivers/firmware/dmi-id.c
+++ linux-2.6/drivers/firmware/dmi-id.c
@@ -158,9 +158,15 @@ static int dmi_dev_uevent(struct device
 	return 0;
 }
 
+static void dmi_dev_release(struct device *dev)
+{
+	dev_set_name(dev, NULL);
+	kfree(dev);
+}
+
 static struct class dmi_class = {
 	.name = "dmi",
-	.dev_release = (void(*)(struct device *)) kfree,
+	.dev_release = dmi_dev_release,
 	.dev_uevent = dmi_dev_uevent,
 };
 
