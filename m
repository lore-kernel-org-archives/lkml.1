Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbZD1TGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbZD1TGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZD1TGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:06:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:59993 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbZD1TGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:06:36 -0400
Message-ID: <49F7532F.1010407@kernel.org>
Date: Tue, 28 Apr 2009 12:04:15 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH] use dev_set_name(,NULL) to prevent leaking
References: <20090418192314.GA22107@suse.de> <49F6B1E6.7050008@kernel.org> 	<49F6B350.9080703@kernel.org> <ac3eb2510904280125w11a58388u6a51997e28609009@mail.gmail.com> 	<49F71EF6.3050102@kernel.org> <49F72205.7030306@kernel.org> 	<20090428153906.GA8896@suse.de> <49F7260F.8030405@kernel.org> 	<ac3eb2510904280856m1fc07002pc4fb630fd2946b62@mail.gmail.com> 	<49F729F1.2020107@kernel.org> <ac3eb2510904280915m472e7e56w8c0331acfd9f083f@mail.gmail.com>
In-Reply-To: <ac3eb2510904280915m472e7e56w8c0331acfd9f083f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Tue, Apr 28, 2009 at 18:08, Yinghai Lu <yinghai@kernel.org> wrote:
>> Kay Sievers wrote:
>>> On Tue, Apr 28, 2009 at 17:51, Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>>> before device_register==>device_initialize is called, kobj->ref is still 0.
>>>>
>>>> will get warn from
>>>>                if (!kobj->state_initialized)
>>> Initialize the device before you do anything with it. And call _put()
>>> any time to get rid of ressources, which might have been allocated
>>> before registering.
> 
>> so you mean don't call dev_set_name before device_register and let device_register or device_add take name param?
> 
> No. I meant:
> 
>   device_initialize()
>     call put_device() any time you want to get rid of ressources of the device
>   device_set_name()
>     call put_device() any time you want to get rid of ressources of the device
>   device_register()
> ...
> 

that looks overkilling.

still hope to make dev_set_name(,NULL) work. aka if device_initialize/dev_register is called before, could only use device_set_name(,NULL) to clear the set name.

when dev_register failed, could not find corresponding kfree, calling put_device in that case looks scary.

diff --git a/arch/arm/common/locomo.c b/arch/arm/common/locomo.c
index 2293f0c..2cd7e16 100644
--- a/arch/arm/common/locomo.c
+++ b/arch/arm/common/locomo.c
@@ -560,6 +560,7 @@ locomo_init_one_child(struct locomo *lchip, struct locomo_dev_info *info)
 	ret = device_register(&dev->dev);
 	if (ret) {
  out:
+		put_device(&dev->dev);
 		kfree(dev);
 	}
 	return ret;
diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index ef12794..c52534c 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -550,6 +550,7 @@ sa1111_init_one_child(struct sa1111 *sachip, struct resource *parent,
 		goto out;
 	}
 
+	device_initialize(&dev->dev);
 	dev_set_name(&dev->dev, "%4.4lx", info->offset);
 	dev->devid	 = info->devid;
 	dev->dev.parent  = sachip->dev;
@@ -568,15 +569,16 @@ sa1111_init_one_child(struct sa1111 *sachip, struct resource *parent,
 	if (ret) {
 		printk("SA1111: failed to allocate resource for %s\n",
 			dev->res.name);
-		dev_set_name(&dev->dev, NULL);
+		put_device(&dev->dev);
 		kfree(dev);
 		goto out;
 	}
 
 
-	ret = device_register(&dev->dev);
+	ret = device_add(&dev->dev);
 	if (ret) {
 		release_resource(&dev->res);
+		put_device(&dev->dev);
 		kfree(dev);
 		goto out;
 	}
diff --git a/arch/arm/kernel/ecard.c b/arch/arm/kernel/ecard.c
index eed2f79..05789c5 100644
--- a/arch/arm/kernel/ecard.c
+++ b/arch/arm/kernel/ecard.c
@@ -795,6 +795,7 @@ static void __init ecard_free_card(struct expansion_card *ec)
 		if (ec->resource[i].flags)
 			release_resource(&ec->resource[i]);
 
+	put_device(&ec->dev);
 	kfree(ec);
 }
 
@@ -817,6 +818,7 @@ static struct expansion_card *__init ecard_alloc_card(int type, int slot)
 	ec->dma = NO_DMA;
 	ec->ops = &ecard_default_ops;
 
+	device_initialize(&ec->dev);
 	dev_set_name(&ec->dev, "ecard%d", slot);
 	ec->dev.parent = NULL;
 	ec->dev.bus = &ecard_bus_type;
@@ -1063,7 +1065,7 @@ ecard_probe(int slot, card_type_t type)
 	*ecp = ec;
 	slot_to_expcard[slot] = ec;
 
-	device_register(&ec->dev);
+	device_add(&ec->dev);
 
 	return 0;
 
diff --git a/arch/arm/mach-integrator/impd1.c b/arch/arm/mach-integrator/impd1.c
index 0058c93..919390f 100644
--- a/arch/arm/mach-integrator/impd1.c
+++ b/arch/arm/mach-integrator/impd1.c
@@ -399,6 +399,7 @@ static int impd1_probe(struct lm_device *dev)
 		if (!d)
 			continue;
 
+		device_initialize(&d->dev);
 		dev_set_name(&d->dev, "lm%x:%5.5lx", dev->id, idev->offset >> 12);
 		d->dev.parent	= &dev->dev;
 		d->res.start	= dev->resource.start + idev->offset;
diff --git a/arch/arm/mach-integrator/lm.c b/arch/arm/mach-integrator/lm.c
index f52c7af..af0363c 100644
--- a/arch/arm/mach-integrator/lm.c
+++ b/arch/arm/mach-integrator/lm.c
@@ -78,6 +78,7 @@ int lm_device_register(struct lm_device *dev)
 {
 	int ret;
 
+	device_initialize(&dev->dev);
 	dev->dev.release = lm_device_release;
 	dev->dev.bus = &lm_bustype;
 
@@ -88,10 +89,13 @@ int lm_device_register(struct lm_device *dev)
 
 	ret = request_resource(&iomem_resource, &dev->resource);
 	if (ret == 0) {
-		ret = device_register(&dev->dev);
+		ret = device_add(&dev->dev);
 		if (ret)
 			release_resource(&dev->resource);
 	}
+	if (ret)
+		put_device(&dev->dev);
+
 	return ret;
 }
 
diff --git a/arch/parisc/kernel/drivers.c b/arch/parisc/kernel/drivers.c
index 994bcd9..6eb2f00 100644
--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -427,6 +427,7 @@ struct parisc_device * create_tree_node(char id, struct device *parent)
 	dev->dev.dma_mask = &dev->dma_mask;
 	dev->dev.coherent_dma_mask = dev->dma_mask;
 	if (device_register(&dev->dev)) {
+		put_device(&dev->dev);
 		kfree(dev);
 		return NULL;
 	}
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 819e59f..d15e238 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -1246,6 +1246,7 @@ struct vio_dev *vio_register_device_node(struct device_node *of_node)
 		printk(KERN_ERR "%s: failed to register device %s\n",
 				__func__, dev_name(&viodev->dev));
 		/* XXX free TCE table */
+		put_device(&viodev->dev);
 		kfree(viodev);
 		return NULL;
 	}
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index 9a73d02..8cfdd39 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -738,6 +738,7 @@ int ps3_system_bus_device_register(struct ps3_system_bus_device *dev)
 	static unsigned int dev_vuart_count;
 	static unsigned int dev_lpm_count;
 
+	device_initialize(&dev->core);
 	if (!dev->core.parent)
 		dev->core.parent = &ps3_system_bus;
 	dev->core.bus = &ps3_system_bus_type;
@@ -768,7 +769,7 @@ int ps3_system_bus_device_register(struct ps3_system_bus_device *dev)
 
 	pr_debug("%s:%d add %s\n", __func__, __LINE__, dev_name(&dev->core));
 
-	result = device_register(&dev->core);
+	result = device_add(&dev->core);
 	return result;
 }
 
diff --git a/arch/sparc/kernel/of_device_32.c b/arch/sparc/kernel/of_device_32.c
index c8f14c1..50a50fb 100644
--- a/arch/sparc/kernel/of_device_32.c
+++ b/arch/sparc/kernel/of_device_32.c
@@ -587,6 +587,7 @@ build_resources:
 	if (of_device_register(op)) {
 		printk("%s: Could not register of device.\n",
 		       dp->full_name);
+		put_device(&op->dev);
 		kfree(op);
 		op = NULL;
 	}
diff --git a/arch/sparc/kernel/of_device_64.c b/arch/sparc/kernel/of_device_64.c
index 5ac287a..8ebce84 100644
--- a/arch/sparc/kernel/of_device_64.c
+++ b/arch/sparc/kernel/of_device_64.c
@@ -855,6 +855,7 @@ static struct of_device * __init scan_one_device(struct device_node *dp,
 	if (of_device_register(op)) {
 		printk("%s: Could not register of device.\n",
 		       dp->full_name);
+		put_device(&op->dev);
 		kfree(op);
 		op = NULL;
 	}
diff --git a/arch/sparc/kernel/vio.c b/arch/sparc/kernel/vio.c
index 753d128..5bb557b 100644
--- a/arch/sparc/kernel/vio.c
+++ b/arch/sparc/kernel/vio.c
@@ -296,6 +296,7 @@ static struct vio_dev *vio_create_one(struct mdesc_handle *hp, u64 mp,
 	if (err) {
 		printk(KERN_ERR "VIO: Could not register device %s, err=%d\n",
 		       dev_name(&vdev->dev), err);
+		put_device(&dev->dev);
 		kfree(vdev);
 		return NULL;
 	}
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 8ff510b..bd28e8b 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -535,6 +535,7 @@ static int acpi_device_register(struct acpi_device *device,
 	result = device_add(&device->dev);
 	if(result) {
 		dev_err(&device->dev, "Error adding device\n");
+		put_device(&device->dev);
 		goto end;
 	}
 
diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 3d763fd..cabb645 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -207,6 +207,7 @@ int amba_device_register(struct amba_device *dev, struct resource *parent)
 	void __iomem *tmp;
 	int i, ret;
 
+	/* we already called device_initialize and dev_set_name */
 	dev->dev.release = amba_device_release;
 	dev->dev.bus = &amba_bustype;
 	dev->dev.dma_mask = &dev->dma_mask;
@@ -240,7 +241,7 @@ int amba_device_register(struct amba_device *dev, struct resource *parent)
 		goto err_release;
 	}
 
-	ret = device_register(&dev->dev);
+	ret = device_add(&dev->dev);
 	if (ret)
 		goto err_release;
 
@@ -251,11 +252,11 @@ int amba_device_register(struct amba_device *dev, struct resource *parent)
 	if (ret == 0)
 		return ret;
 
-	device_unregister(&dev->dev);
-
+	device_del(&dev->dev);
  err_release:
 	release_resource(&dev->res);
  err_out:
+	put_device(&dev->dev);
 	return ret;
 }
 
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d3a59c6..980e80f 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -330,6 +330,7 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 
 error_kfree:
 	kfree(fw_priv);
+	put_device(f_dev);
 	kfree(f_dev);
 	return retval;
 }
diff --git a/drivers/dio/dio.c b/drivers/dio/dio.c
index 55dd88d..d2ede72 100644
--- a/drivers/dio/dio.c
+++ b/drivers/dio/dio.c
@@ -186,6 +186,7 @@ static int __init dio_init(void)
 	error = device_register(&dio_bus.dev);
 	if (error) {
 		pr_err("DIO: Error registering dio_bus\n");
+		put_device(&dio_bus.dev);
 		return error;
 	}
 
@@ -261,6 +262,7 @@ static int __init dio_init(void)
 		if (error) {
 			pr_err("DIO: Error registering device %s\n",
 			       dev->name);
+			put_device(&dev->dev);
 			continue;
 		}
 		error = dio_create_sysfs_dev_files(dev);
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 92438e9..e67dab0 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -699,6 +699,7 @@ int dma_async_device_register(struct dma_device *device)
 		if (rc) {
 			free_percpu(chan->local);
 			chan->local = NULL;
+			put_device(&chan->dev->device);
 			kfree(chan->dev);
 			atomic_dec(idr_ref);
 			goto err_out;
diff --git a/drivers/firewire/fw-device.c b/drivers/firewire/fw-device.c
index a47e212..3613654 100644
--- a/drivers/firewire/fw-device.c
+++ b/drivers/firewire/fw-device.c
@@ -579,6 +579,7 @@ static void create_units(struct fw_device *device)
 		continue;
 
 	skip_unit:
+		put_device(&unit->device);
 		kfree(unit);
 	}
 }
diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 022876a..47fd51a 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -401,9 +401,10 @@ err_out_files:
 		for (j = 0; j < i; j++)
 			device_remove_file(&connector->kdev,
 					   &connector_attrs[i]);
-	device_unregister(&connector->kdev);
+	device_del(&connector->kdev);
 
 out:
+	put_device(&connector->kdev);
 	return ret;
 }
 EXPORT_SYMBOL(drm_sysfs_connector_add);
@@ -489,8 +490,8 @@ int drm_sysfs_device_add(struct drm_minor *minor)
 
 	return 0;
 
-	device_unregister(&minor->kdev);
 err_out:
+	put_device(&minor->kdev);
 
 	return err;
 }
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 3d4e099..836a48e 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1847,6 +1847,7 @@ static int ide_cd_probe(ide_drive_t *drive)
 out_free_disk:
 	put_disk(g);
 out_free_cd:
+	put_device(&info->dev);
 	kfree(info);
 failed:
 	return -ENODEV;
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 4b6b71e..f94a563 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -391,6 +391,7 @@ static int ide_gd_probe(ide_drive_t *drive)
 out_free_disk:
 	put_disk(g);
 out_free_idkp:
+	put_device(&idkp->dev);
 	kfree(idkp);
 failed:
 	return -ENODEV;
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 7f264ed..755b27c 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -566,9 +566,10 @@ static int ide_register_port(ide_hwif_t *hwif)
 				      MKDEV(0, 0), hwif, hwif->name);
 	if (IS_ERR(hwif->portdev)) {
 		ret = PTR_ERR(hwif->portdev);
-		device_unregister(&hwif->gendev);
+		device_del(&hwif->gendev);
 	}
 out:
+	put_device(&hwif->gendev);
 	return ret;
 }
 
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index cb942a9..5ec390f 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2419,6 +2419,7 @@ static int ide_tape_probe(ide_drive_t *drive)
 out_free_disk:
 	put_disk(g);
 out_free_tape:
+	put_device(&tape->dev);
 	kfree(tape);
 failed:
 	return -ENODEV;
diff --git a/drivers/ieee1394/hosts.c b/drivers/ieee1394/hosts.c
index e947d8f..f44acaa 100644
--- a/drivers/ieee1394/hosts.c
+++ b/drivers/ieee1394/hosts.c
@@ -157,14 +157,16 @@ struct hpsb_host *hpsb_alloc_host(struct hpsb_host_driver *drv, size_t extra,
 	set_dev_node(&h->device, dev_to_node(dev));
 	dev_set_name(&h->device, "fw-host%d", h->id);
 
+	device_initialize(&h->host_dev);
 	h->host_dev.parent = &h->device;
 	h->host_dev.class = &hpsb_host_class;
 	dev_set_name(&h->host_dev, "fw-host%d", h->id);
 
 	if (device_register(&h->device))
 		goto fail;
-	if (device_register(&h->host_dev)) {
-		device_unregister(&h->device);
+
+	if (device_add(&h->host_dev)) {
+		device_del(&h->device);
 		goto fail;
 	}
 	get_device(&h->device);
@@ -172,6 +174,8 @@ struct hpsb_host *hpsb_alloc_host(struct hpsb_host_driver *drv, size_t extra,
 	return h;
 
 fail:
+	put_device(&h->device);
+	put_device(&h->host_dev);
 	kfree(h);
 	return NULL;
 }
diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 065f249..86fe12c 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -826,13 +826,14 @@ static struct node_entry *nodemgr_create_node(octlet_t guid,
 	ne->device.parent = &host->device;
 	dev_set_name(&ne->device, "%016Lx", (unsigned long long)(ne->guid));
 
+	device_initialize(&ne->node_dev);
 	ne->node_dev.parent = &ne->device;
 	ne->node_dev.class = &nodemgr_ne_class;
 	dev_set_name(&ne->node_dev, "%016Lx", (unsigned long long)(ne->guid));
 
 	if (device_register(&ne->device))
 		goto fail_devreg;
-	if (device_register(&ne->node_dev))
+	if (device_add(&ne->node_dev))
 		goto fail_classdevreg;
 	get_device(&ne->device);
 
@@ -847,8 +848,10 @@ static struct node_entry *nodemgr_create_node(octlet_t guid,
 	return ne;
 
 fail_classdevreg:
-	device_unregister(&ne->device);
+	device_del(&ne->device);
 fail_devreg:
+	put_device(&ne->device);
+	put_device(&ne->node_dev);
 	kfree(ne);
 fail_alloc:
 	HPSB_ERR("Failed to create node ID:BUS[" NODE_BUS_FMT "]  GUID[%016Lx]",
@@ -930,13 +933,14 @@ static void nodemgr_register_device(struct node_entry *ne,
 
 	dev_set_name(&ud->device, "%s-%u", dev_name(&ne->device), ud->id);
 
+	device_initialize(&ud->unit_dev);
 	ud->unit_dev.parent = &ud->device;
 	ud->unit_dev.class = &nodemgr_ud_class;
 	dev_set_name(&ud->unit_dev, "%s-%u", dev_name(&ne->device), ud->id);
 
 	if (device_register(&ud->device))
 		goto fail_devreg;
-	if (device_register(&ud->unit_dev))
+	if (device_add(&ud->unit_dev))
 		goto fail_classdevreg;
 	get_device(&ud->device);
 
@@ -945,9 +949,11 @@ static void nodemgr_register_device(struct node_entry *ne,
 	return;
 
 fail_classdevreg:
-	device_unregister(&ud->device);
+	device_del(&ud->device);
 fail_devreg:
 	HPSB_ERR("Failed to create unit %s", dev_name(&ud->device));
+	put_device(&ud->device);
+	put_device(&ud->unit_dev);
 }	
 
 
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 5c04cfb..e4cc434 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -821,9 +821,10 @@ err_put:
 	kobject_put(&class_dev->kobj);
 
 err_unregister:
-	device_unregister(class_dev);
+	device_del(class_dev);
 
 err:
+	put_device(class_dev);
 	return ret;
 }
 
diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 51bd966..0ce368a 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1277,8 +1277,9 @@ static void ib_ucm_add_one(struct ib_device *device)
 	return;
 
 err_dev:
-	device_unregister(&ucm_dev->dev);
+	device_del(&ucm_dev->dev);
 err_cdev:
+	put_device(&ucm_dev->dev);
 	cdev_del(&ucm_dev->cdev);
 	clear_bit(ucm_dev->devnum, dev_map);
 err:
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 54c8fe2..bcb4c05 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1963,9 +1963,10 @@ static struct srp_host *srp_add_port(struct srp_device *device, u8 port)
 	return host;
 
 err_class:
-	device_unregister(&host->dev);
+	device_del(&host->dev);
 
 free_host:
+	put_device(&host->dev);
 	kfree(host);
 
 	return NULL;
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 935a183..5c13a1a 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1398,8 +1398,10 @@ int input_register_device(struct input_dev *dev)
 		     (unsigned long) atomic_inc_return(&input_no) - 1);
 
 	error = device_add(&dev->dev);
-	if (error)
+	if (error) {
+		put_device(&dev->dev);
 		return error;
+	}
 
 	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
 	printk(KERN_INFO "input: %s as %s\n",
@@ -1409,6 +1411,7 @@ int input_register_device(struct input_dev *dev)
 	error = mutex_lock_interruptible(&input_mutex);
 	if (error) {
 		device_del(&dev->dev);
+		put_device(&dev->dev);
 		return error;
 	}
 
diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
index 9426c98..9ee0b2e 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -253,6 +253,7 @@ mISDN_register_device(struct mISDNdevice *dev,
 
 error3:
 	delete_stack(dev);
+	put_device(&dev->dev);
 	return err;
 error1:
 	return err;
diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index 18cf87c..28ee4e2 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -127,9 +127,9 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 	return 0;
 
 err2:
-	device_unregister(&entry->dev);
-	return ret;
+	device_del(&entry->dev);
 err1:
+	put_device(&entry->dev);
 	kfree(entry);
 	return ret;
 }
diff --git a/drivers/macintosh/macio_asic.c b/drivers/macintosh/macio_asic.c
index 6e149f4..8b5b79c 100644
--- a/drivers/macintosh/macio_asic.c
+++ b/drivers/macintosh/macio_asic.c
@@ -409,6 +409,7 @@ static struct macio_dev * macio_add_one_device(struct macio_chip *chip,
 	if (of_device_register(&dev->ofdev) != 0) {
 		printk(KERN_DEBUG"macio: device registration error for %s!\n",
 		       dev_name(&dev->ofdev.dev));
+		put_dev(&dev->ofdev);
 		kfree(dev);
 		return NULL;
 	}
diff --git a/drivers/mca/mca-bus.c b/drivers/mca/mca-bus.c
index ada5ebb..70c8de9 100644
--- a/drivers/mca/mca-bus.c
+++ b/drivers/mca/mca-bus.c
@@ -129,8 +129,9 @@ int __init mca_register_device(int bus, struct mca_device *mca_dev)
 err_out_id:
 	device_remove_file(&mca_dev->dev, &dev_attr_id);
 err_out_devreg:
-	device_unregister(&mca_dev->dev);
+	device_del(&mca_dev->dev);
 err_out:
+	put_device(&mca_dev->dev);
 	return 0;
 }
 
@@ -154,6 +155,7 @@ struct mca_bus * __devinit mca_attach_bus(int bus)
 	dev_set_name(&mca_bus->dev, "mca%d", bus);
 	sprintf(mca_bus->name,"Host %s MCA Bridge", bus ? "Secondary" : "Primary");
 	if (device_register(&mca_bus->dev)) {
+		put_device(&mca_bus->dev);
 		kfree(mca_bus);
 		return NULL;
 	}
diff --git a/drivers/media/video/bt8xx/bttv-gpio.c b/drivers/media/video/bt8xx/bttv-gpio.c
index 74c325e..a886d80 100644
--- a/drivers/media/video/bt8xx/bttv-gpio.c
+++ b/drivers/media/video/bt8xx/bttv-gpio.c
@@ -95,6 +95,7 @@ int bttv_sub_add_device(struct bttv_core *core, char *name)
 
 	err = device_register(&sub->dev);
 	if (0 != err) {
+		put_device(&sub->dev);
 		kfree(sub);
 		return err;
 	}
diff --git a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
index 299c1cb..4764e24 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
@@ -640,6 +640,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 	if (ret) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "device_register failed");
+		put_device(class_dev);
 		kfree(class_dev);
 		return;
 	}
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 31eac66..d6d1132 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -522,6 +522,7 @@ int video_register_device_index(struct video_device *vdev, int type, int nr,
 	ret = device_register(&vdev->dev);
 	if (ret < 0) {
 		printk(KERN_ERR "%s: device_register failed\n", __func__);
+		put_device(&vdev->dev);
 		goto cleanup;
 	}
 	/* Register the release callback that will be called when the last
diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index a5b448e..7400d2c 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -413,6 +413,7 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
 	return card;
 err_out:
 	host->card = old_card;
+	put_device(&card->dev);
 	kfree(card);
 	return NULL;
 }
diff --git a/drivers/message/i2o/device.c b/drivers/message/i2o/device.c
index 0ee4264..b22214c 100644
--- a/drivers/message/i2o/device.c
+++ b/drivers/message/i2o/device.c
@@ -300,8 +300,9 @@ rmlink1:
 	sysfs_remove_link(&i2o_dev->device.kobj, "user");
 unreg_dev:
 	list_del(&i2o_dev->list);
-	device_unregister(&i2o_dev->device);
+	device_del(&i2o_dev->device);
 err:
+	put_device(&i2o_dev->device);
 	kfree(i2o_dev);
 	return rc;
 }
diff --git a/drivers/mfd/mcp-core.c b/drivers/mfd/mcp-core.c
index 57271cb..1944ccf 100644
--- a/drivers/mfd/mcp-core.c
+++ b/drivers/mfd/mcp-core.c
@@ -214,8 +214,14 @@ EXPORT_SYMBOL(mcp_host_alloc);
 
 int mcp_host_register(struct mcp *mcp)
 {
+	int ret;
+
 	dev_set_name(&mcp->attached_device, "mcp0");
-	return device_register(&mcp->attached_device);
+	ret = device_register(&mcp->attached_device);
+	if (ret)
+		put_device(&mcp->addtached_device);
+
+	return ret;
 }
 EXPORT_SYMBOL(mcp_host_register);
 
diff --git a/drivers/mfd/ucb1x00-core.c b/drivers/mfd/ucb1x00-core.c
index fea9085..e9acaa6 100644
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -532,6 +532,7 @@ static int ucb1x00_probe(struct mcp *mcp)
 
  err_irq:
 	free_irq(ucb->irq, ucb);
+	put_device(&ucb->dev);
  err_free:
 	kfree(ucb);
  err_disable:
diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 3cf61ec..ac579aa 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -135,6 +135,7 @@ enclosure_register(struct device *dev, const char *name, int components,
 
  err:
 	put_device(edev->edev.parent);
+	put_device(&edev->edev);
 	kfree(edev);
 	return ERR_PTR(err);
 }
@@ -264,8 +265,10 @@ enclosure_component_register(struct enclosure_device *edev,
 	cdev->groups = enclosure_groups;
 
 	err = device_register(cdev);
-	if (err)
+	if (err) {
 		ERR_PTR(err);
+		put_device(cdev);
+	}
 
 	return ecomp;
 }

