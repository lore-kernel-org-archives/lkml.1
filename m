Return-Path: <linux-kernel-owner+w=401wt.eu-S935493AbYBHAfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935493AbYBHAfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbYBHAb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:31:28 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:45194 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbYBHAbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:31:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=n++vZ/hSHd0GapupzqvM7yhhmoceJw8KirS0hBumPpjjpuH3ke9yftWh3e4NUftU79UGTQhP7U5nudAY13dKhBE0sHDYu+xJ5oNXegbl9W0yKATU8GI3gFaH6kwtJsotASXaExdm9UHR2ZoCOFFZBubQxNDQoIQqtCbfc6nyrDA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2008 01:45:30 +0100
Message-Id: <20080208004530.17746.11984.sendpatchset@localhost.localdomain>
In-Reply-To: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/18] ide: add warm-plug support for IDE devices
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add 'struct class ide_port_class' ('ide_port' class) and embedd 'struct
  class_device classdev' ('ide_port' class device) in ide_hwif_t.

* Register 'ide_port' class in ide_init() and unregister it in
  cleanup_module().

* Add class_to_ide_port() macro and ide_port_class_release().

* Register ->classdev in ide_register_port () and unregister it in
  ide_unregister().

* Add "delete_devices" class device attribute for unregistering IDE devices
  on a port and "scan" one for probing+registering IDE devices on a port.

* Add ide_sysfs_register_port() helper for registering "delete_devices"
  and "scan" attributes with ->classdev.  Call it in ide_device_add_all().

* Document IDE warm-plug support in Documentation/ide/warm-plug-howto.txt.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
+540 bytes (x86-32)

After seeing some 'class device' conversion patches from Greg I tried to
recast this patch to just use 'device' but I couldn't figure out how to
use class_device_create() with *static* objects...

 Documentation/ide/warm-plug-howto.txt |   13 ++++++
 drivers/ide/ide-probe.c               |   70 +++++++++++++++++++++++++++++++++-
 drivers/ide/ide.c                     |   22 ++++++++++
 include/linux/ide.h                   |    7 ++-
 4 files changed, 109 insertions(+), 3 deletions(-)

Index: b/Documentation/ide/warm-plug-howto.txt
===================================================================
--- /dev/null
+++ b/Documentation/ide/warm-plug-howto.txt
@@ -0,0 +1,13 @@
+
+IDE warm-plug HOWTO
+===================
+
+To warm-plug devices on a port 'idex':
+
+# echo -n "1" > /sys/class/ide_port/idex/delete_devices
+
+unplug old device(s) and plug new device(s)
+
+# echo -n "1" > /sys/class/ide_port/idex/scan
+
+done
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -623,7 +623,7 @@ static void hwif_release_dev (struct dev
 	complete(&hwif->gendev_rel_comp);
 }
 
-static void ide_register_port(ide_hwif_t *hwif)
+static int ide_register_port(ide_hwif_t *hwif)
 {
 	int ret;
 
@@ -639,9 +639,23 @@ static void ide_register_port(ide_hwif_t
 	}
 	hwif->gendev.release = hwif_release_dev;
 	ret = device_register(&hwif->gendev);
-	if (ret < 0)
+	if (ret < 0) {
 		printk(KERN_WARNING "IDE: %s: device_register error: %d\n",
 			__FUNCTION__, ret);
+		goto out;
+	}
+
+	get_device(&hwif->gendev);
+
+	strlcpy(hwif->classdev.class_id, hwif->name, BUS_ID_SIZE);
+	hwif->classdev.dev = &hwif->gendev;
+	hwif->classdev.class = &ide_port_class;
+
+	ret = class_device_register(&hwif->classdev);
+	if (ret < 0)
+		device_unregister(&hwif->gendev);
+out:
+	return ret;
 }
 
 /**
@@ -1374,6 +1388,57 @@ static void ide_port_cable_detect(ide_hw
 	}
 }
 
+static ssize_t store_delete_devices(struct class_device *class_dev,
+				    const char *buf, size_t n)
+{
+	ide_hwif_t *hwif = class_to_ide_port(class_dev);
+
+	if (strncmp(buf, "1", n))
+		return -EINVAL;
+
+	ide_port_unregister_devices(hwif);
+
+	return n;
+};
+
+static CLASS_DEVICE_ATTR(delete_devices, S_IWUSR, NULL, store_delete_devices);
+
+static ssize_t store_scan(struct class_device *class_dev, const char *buf,
+			  size_t n)
+{
+	ide_hwif_t *hwif = class_to_ide_port(class_dev);
+
+	if (strncmp(buf, "1", n))
+		return -EINVAL;
+
+	ide_port_unregister_devices(hwif);
+	ide_port_scan(hwif);
+
+	return n;
+};
+
+static CLASS_DEVICE_ATTR(scan, S_IWUSR, NULL, store_scan);
+
+static struct class_device_attribute *ide_port_attrs[] = {
+	&class_device_attr_delete_devices,
+	&class_device_attr_scan,
+	NULL
+};
+
+static int ide_sysfs_register_port(ide_hwif_t *hwif)
+{
+	int i, rc;
+
+	for (i = 0; ide_port_attrs[i]; i++) {
+		rc = class_device_create_file(&hwif->classdev,
+					      ide_port_attrs[i]);
+		if (rc)
+			break;
+	}
+
+	return rc;
+}
+
 int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
 {
 	ide_hwif_t *hwif, *mate = NULL;
@@ -1470,6 +1535,7 @@ int ide_device_add_all(u8 *idx, const st
 		hwif = &ide_hwifs[idx[i]];
 
 		if (hwif->present) {
+			ide_sysfs_register_port(hwif);
 			ide_proc_register_port(hwif);
 			ide_proc_port_register_devices(hwif);
 		}
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -596,6 +596,7 @@ void ide_unregister(unsigned int index, 
 
 	ide_remove_port_from_hwgroup(hwif);
 
+	class_device_unregister(&hwif->classdev);
 	device_unregister(&hwif->gendev);
 	wait_for_completion(&hwif->gendev_rel_comp);
 
@@ -1613,6 +1614,16 @@ struct bus_type ide_bus_type = {
 
 EXPORT_SYMBOL_GPL(ide_bus_type);
 
+static void ide_port_class_release(struct class_device *class_dev)
+{
+	put_device(&class_to_ide_port(class_dev)->gendev);
+}
+
+struct class ide_port_class = {
+	.name		= "ide_port",
+	.release	= ide_port_class_release,
+};
+
 /*
  * This is gets invoked once during initialization, to set *everything* up
  */
@@ -1633,11 +1644,20 @@ static int __init ide_init(void)
 		return ret;
 	}
 
+	ret = class_register(&ide_port_class);
+	if (ret)
+		goto out_port_class;
+
 	init_ide_data();
 
 	proc_ide_create();
 
 	return 0;
+
+out_port_class:
+	bus_unregister(&ide_bus_type);
+
+	return ret;
 }
 
 #ifdef MODULE
@@ -1674,6 +1694,8 @@ void __exit cleanup_module (void)
 
 	proc_ide_destroy();
 
+	class_unregister(&ide_port_class);
+
 	bus_unregister(&ide_bus_type);
 }
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -581,7 +581,9 @@ typedef struct hwif_s {
 	unsigned	mmio       : 1; /* host uses MMIO */
 	unsigned	straight8  : 1;	/* Alan's straight 8 check */
 
-	struct device	gendev;
+	struct device		gendev;
+	struct class_device	classdev;
+
 	struct completion gendev_rel_comp; /* To deal with device release() */
 
 	void		*hwif_data;	/* extra hwif data */
@@ -593,6 +595,8 @@ typedef struct hwif_s {
 #endif
 } ____cacheline_internodealigned_in_smp ide_hwif_t;
 
+#define class_to_ide_port(dev)	container_of(dev, ide_hwif_t, classdev)
+
 /*
  *  internal ide interrupt handler type
  */
@@ -1275,6 +1279,7 @@ extern struct mutex ide_cfg_mtx;
 #define local_irq_set(flags)	do { local_save_flags((flags)); local_irq_enable_in_hardirq(); } while (0)
 
 extern struct bus_type ide_bus_type;
+extern struct class ide_port_class;
 
 /* check if CACHE FLUSH (EXT) command is supported (bits defined in ATA-6) */
 #define ide_id_has_flush_cache(id)	((id)->cfs_enable_2 & 0x3000)
