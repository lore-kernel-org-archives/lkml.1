Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbXKCAAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbXKCAAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756437AbXKCAAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:00:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:34769 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbXKCAAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:00:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 02/54] KOBJECT: remove struct kobj_type from struct kset
Date: Fri,  2 Nov 2007 16:58:40 -0700
Message-Id: <1194047972-9850-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need a "default" ktype for a kset.  We should set this
explicitly every time for each kset.  This change is needed so that we
can make ksets dynamic, and cleans up one of the odd, undocumented
assumption that the kset/kobject/ktype model has.

This patch is based on a lot of help from Kay Sievers.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/platforms/pseries/power.c |    2 +-
 arch/s390/hypfs/inode.c                |    4 ++--
 arch/s390/kernel/ipl.c                 |    8 ++++----
 block/genhd.c                          |    5 +++--
 drivers/acpi/bus.c                     |    2 +-
 drivers/base/bus.c                     |    5 +++--
 drivers/base/class.c                   |    8 +++++---
 drivers/base/core.c                    |    5 +++--
 drivers/base/firmware.c                |    5 +++--
 drivers/base/hypervisor.c              |    2 +-
 drivers/base/sys.c                     |    3 ++-
 drivers/edac/edac_mc_sysfs.c           |    2 +-
 drivers/firmware/edd.c                 |    5 +++--
 drivers/firmware/efivars.c             |    9 +++++----
 drivers/parisc/pdc_stable.c            |    9 +++++----
 drivers/pci/hotplug/pci_hotplug_core.c |    7 ++++---
 drivers/uio/uio.c                      |    2 +-
 fs/configfs/mount.c                    |    4 ++--
 fs/debugfs/inode.c                     |    4 ++--
 fs/dlm/lockspace.c                     |    6 ++----
 fs/ecryptfs/main.c                     |    4 ++--
 fs/fuse/inode.c                        |    8 ++++----
 fs/gfs2/locking/dlm/sysfs.c            |    6 ++----
 fs/gfs2/sys.c                          |    6 ++----
 fs/namespace.c                         |    2 +-
 fs/ocfs2/cluster/masklog.c             |    2 +-
 fs/ocfs2/cluster/sys.c                 |    2 +-
 fs/sysfs/file.c                        |    4 +---
 include/linux/kobject.h                |   15 ++++-----------
 kernel/ksysfs.c                        |    2 +-
 kernel/module.c                        |    2 +-
 kernel/params.c                        |    9 +++++----
 kernel/power/main.c                    |    2 +-
 mm/slub.c                              |    5 +++--
 security/inode.c                       |    4 ++--
 35 files changed, 84 insertions(+), 86 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/power.c b/arch/powerpc/platforms/pseries/power.c
index 73e6902..08d7a50 100644
--- a/arch/powerpc/platforms/pseries/power.c
+++ b/arch/powerpc/platforms/pseries/power.c
@@ -57,7 +57,7 @@ static struct subsys_attribute auto_poweron_attr = {
 };
 
 #ifndef CONFIG_PM
-decl_subsys(power,NULL,NULL);
+decl_subsys(power, NULL);
 
 static struct attribute *g[] = {
         &auto_poweron_attr.attr,
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 5245717..c022ccc 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -490,7 +490,7 @@ static struct super_operations hypfs_s_ops = {
 	.show_options	= hypfs_show_options,
 };
 
-static decl_subsys(s390, NULL, NULL);
+static decl_subsys(s390, NULL);
 
 static int __init hypfs_init(void)
 {
@@ -506,7 +506,7 @@ static int __init hypfs_init(void)
 			goto fail_diag;
 		}
 	}
-	kobj_set_kset_s(&s390_subsys, hypervisor_subsys);
+	s390_subsys.kobj.kset = &hypervisor_subsys;
 	rc = subsystem_register(&s390_subsys);
 	if (rc)
 		goto fail_sysfs;
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index ce0856d..cae793a 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -418,7 +418,7 @@ static struct attribute_group ipl_unknown_attr_group = {
 	.attrs = ipl_unknown_attrs,
 };
 
-static decl_subsys(ipl, NULL, NULL);
+static decl_subsys(ipl, NULL);
 
 /*
  * reipl section
@@ -590,7 +590,7 @@ static ssize_t reipl_type_store(struct kset *kset, const char *buf,
 static struct subsys_attribute reipl_type_attr =
 		__ATTR(reipl_type, 0644, reipl_type_show, reipl_type_store);
 
-static decl_subsys(reipl, NULL, NULL);
+static decl_subsys(reipl, NULL);
 
 /*
  * dump section
@@ -685,13 +685,13 @@ static ssize_t dump_type_store(struct kset *kset, const char *buf,
 static struct subsys_attribute dump_type_attr =
 		__ATTR(dump_type, 0644, dump_type_show, dump_type_store);
 
-static decl_subsys(dump, NULL, NULL);
+static decl_subsys(dump, NULL);
 
 /*
  * Shutdown actions section
  */
 
-static decl_subsys(shutdown_actions, NULL, NULL);
+static decl_subsys(shutdown_actions, NULL);
 
 /* on panic */
 
diff --git a/block/genhd.c b/block/genhd.c
index e609996..164db96 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -584,7 +584,7 @@ static struct kset_uevent_ops block_uevent_ops = {
 	.uevent		= block_uevent,
 };
 
-decl_subsys(block, &ktype_block, &block_uevent_ops);
+decl_subsys(block, &block_uevent_ops);
 
 /*
  * aggregate disk stat collector.  Uses the same stats that the sysfs
@@ -720,8 +720,9 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 			}
 		}
 		disk->minors = minors;
-		kobj_set_kset_s(disk,block_subsys);
 		kobject_init(&disk->kobj);
+		disk->kobj.kset = &block_subsys;
+		disk->kobj.ktype = &ktype_block;
 		rand_initialize_disk(disk);
 		INIT_WORK(&disk->async_notify,
 			media_change_notify_thread);
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 49d432d..fe90513 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -744,7 +744,7 @@ static int __init acpi_bus_init(void)
 	return -ENODEV;
 }
 
-decl_subsys(acpi, NULL, NULL);
+decl_subsys(acpi, NULL);
 
 static int __init acpi_init(void)
 {
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 9a19b07..6309560 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -166,7 +166,7 @@ static struct kset_uevent_ops bus_uevent_ops = {
 	.filter = bus_uevent_filter,
 };
 
-static decl_subsys(bus, &bus_ktype, &bus_uevent_ops);
+static decl_subsys(bus, &bus_uevent_ops);
 
 
 #ifdef CONFIG_HOTPLUG
@@ -639,6 +639,7 @@ int bus_add_driver(struct device_driver *drv)
 	if (error)
 		goto out_put_bus;
 	drv->kobj.kset = &bus->drivers;
+	drv->kobj.ktype = &driver_ktype;
 	error = kobject_register(&drv->kobj);
 	if (error)
 		goto out_put_bus;
@@ -851,6 +852,7 @@ int bus_register(struct bus_type * bus)
 		goto out;
 
 	bus->subsys.kobj.kset = &bus_subsys;
+	bus->subsys.kobj.ktype = &bus_ktype;
 
 	retval = subsystem_register(&bus->subsys);
 	if (retval)
@@ -868,7 +870,6 @@ int bus_register(struct bus_type * bus)
 
 	kobject_set_name(&bus->drivers.kobj, "drivers");
 	bus->drivers.kobj.parent = &bus->subsys.kobj;
-	bus->drivers.ktype = &driver_ktype;
 	retval = kset_register(&bus->drivers);
 	if (retval)
 		goto bus_drivers_fail;
diff --git a/drivers/base/class.c b/drivers/base/class.c
index a863bb0..8ad9892 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -71,7 +71,7 @@ static struct kobj_type class_ktype = {
 };
 
 /* Hotplug events for classes go to the class_obj subsys */
-static decl_subsys(class, &class_ktype, NULL);
+static decl_subsys(class, NULL);
 
 
 int class_create_file(struct class * cls, const struct class_attribute * attr)
@@ -150,6 +150,7 @@ int class_register(struct class * cls)
 		return error;
 
 	cls->subsys.kobj.kset = &class_subsys;
+	cls->subsys.kobj.ktype = &class_ktype;
 
 	error = subsystem_register(&cls->subsys);
 	if (!error) {
@@ -452,7 +453,7 @@ static struct kset_uevent_ops class_uevent_ops = {
 	.uevent =	class_uevent,
 };
 
-static decl_subsys(class_obj, &class_device_ktype, &class_uevent_ops);
+static decl_subsys(class_obj, &class_uevent_ops);
 
 
 static int class_device_add_attrs(struct class_device * cd)
@@ -537,7 +538,8 @@ static struct class_device_attribute class_uevent_attr =
 
 void class_device_initialize(struct class_device *class_dev)
 {
-	kobj_set_kset_s(class_dev, class_obj_subsys);
+	class_dev->kobj.kset = &class_obj_subsys;
+	class_dev->kobj.ktype = &class_device_ktype;
 	kobject_init(&class_dev->kobj);
 	INIT_LIST_HEAD(&class_dev->node);
 }
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 3f4d6aa..161ea6e 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -405,7 +405,7 @@ static struct device_attribute devt_attr =
  *	devices_subsys - structure to be registered with kobject core.
  */
 
-decl_subsys(devices, &device_ktype, &device_uevent_ops);
+decl_subsys(devices, &device_uevent_ops);
 
 
 /**
@@ -525,7 +525,8 @@ static void klist_children_put(struct klist_node *n)
 
 void device_initialize(struct device *dev)
 {
-	kobj_set_kset_s(dev, devices_subsys);
+	dev->kobj.kset = &devices_subsys;
+	dev->kobj.ktype = &device_ktype;
 	kobject_init(&dev->kobj);
 	klist_init(&dev->klist_children, klist_children_get,
 		   klist_children_put);
diff --git a/drivers/base/firmware.c b/drivers/base/firmware.c
index 90c8629..336be04 100644
--- a/drivers/base/firmware.c
+++ b/drivers/base/firmware.c
@@ -15,11 +15,12 @@
 
 #include "base.h"
 
-static decl_subsys(firmware, NULL, NULL);
+static decl_subsys(firmware, NULL);
 
 int firmware_register(struct kset *s)
 {
-	kobj_set_kset_s(s, firmware_subsys);
+	s->kobj.kset = &firmware_subsys;
+	s->kobj.ktype = NULL;
 	return subsystem_register(s);
 }
 
diff --git a/drivers/base/hypervisor.c b/drivers/base/hypervisor.c
index 7080b41..14e75e9 100644
--- a/drivers/base/hypervisor.c
+++ b/drivers/base/hypervisor.c
@@ -11,7 +11,7 @@
 
 #include "base.h"
 
-decl_subsys(hypervisor, NULL, NULL);
+decl_subsys(hypervisor, NULL);
 EXPORT_SYMBOL_GPL(hypervisor_subsys);
 
 int __init hypervisor_init(void)
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index ac7ff6d..7cf19fc 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -131,7 +131,7 @@ EXPORT_SYMBOL_GPL(sysdev_class_remove_file);
 /*
  * declare system_subsys
  */
-static decl_subsys(system, &ktype_sysdev_class, NULL);
+static decl_subsys(system, NULL);
 
 int sysdev_class_register(struct sysdev_class * cls)
 {
@@ -139,6 +139,7 @@ int sysdev_class_register(struct sysdev_class * cls)
 		 kobject_name(&cls->kset.kobj));
 	INIT_LIST_HEAD(&cls->drivers);
 	cls->kset.kobj.parent = &system_subsys.kobj;
+	cls->kset.kobj.ktype = &ktype_sysdev_class;
 	cls->kset.kobj.kset = &system_subsys;
 	return kset_register(&cls->kset);
 }
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 3706b2b..905fcd7 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -744,7 +744,6 @@ static struct kobj_type ktype_mc_set_attribs = {
  */
 static struct kset mc_kset = {
 	.kobj = {.ktype = &ktype_mc_set_attribs },
-	.ktype = &ktype_mci,
 };
 
 
@@ -767,6 +766,7 @@ int edac_mc_register_sysfs_main_kobj(struct mem_ctl_info *mci)
 
 	/* this instance become part of the mc_kset */
 	kobj_mci->kset = &mc_kset;
+	kobj_mci->ktype = &ktype_mci;
 
 	/* set the name of the mc<id> object */
 	err = kobject_set_name(kobj_mci, "mc%d", mci->mc_idx);
diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index 6942e06..fc567fa 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -631,7 +631,7 @@ static struct kobj_type edd_ktype = {
 	.default_attrs	= def_attrs,
 };
 
-static decl_subsys(edd, &edd_ktype, NULL);
+static decl_subsys(edd, NULL);
 
 
 /**
@@ -723,7 +723,8 @@ edd_device_register(struct edd_device *edev, int i)
 	edd_dev_set_info(edev, i);
 	kobject_set_name(&edev->kobj, "int13_dev%02x",
 			 0x80 + i);
-	kobj_set_kset_s(edev,edd_subsys);
+	edev->kobj.kset = &edd_subsys;
+	edev->kobj.ktype = &edd_ktype;
 	error = kobject_register(&edev->kobj);
 	if (!error)
 		edd_populate_dir(edev);
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 858a7b9..06ecdb9 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -583,8 +583,8 @@ static struct subsys_attribute *efi_subsys_attrs[] = {
 	NULL,	/* maybe more in the future? */
 };
 
-static decl_subsys(vars, &efivar_ktype, NULL);
-static decl_subsys(efi, NULL, NULL);
+static decl_subsys(vars, NULL);
+static decl_subsys(efi, NULL);
 
 /*
  * efivar_create_sysfs_entry()
@@ -629,7 +629,8 @@ efivar_create_sysfs_entry(unsigned long variable_name_size,
 	efi_guid_unparse(vendor_guid, short_name + strlen(short_name));
 
 	kobject_set_name(&new_efivar->kobj, "%s", short_name);
-	kobj_set_kset_s(new_efivar, vars_subsys);
+	new_efivar->kobj.kset = &vars_subsys;
+	new_efivar->kobj.ktype = &efivar_ktype;
 	i = kobject_register(&new_efivar->kobj);
 	if (i) {
 		kfree(short_name);
@@ -687,7 +688,7 @@ efivars_init(void)
 		goto out_free;
 	}
 
-	kobj_set_kset_s(&vars_subsys, efi_subsys);
+	vars_subsys.kobj.kset = &efi_subsys;
 
 	error = subsystem_register(&vars_subsys);
 
diff --git a/drivers/parisc/pdc_stable.c b/drivers/parisc/pdc_stable.c
index ebb09e9..1382be6 100644
--- a/drivers/parisc/pdc_stable.c
+++ b/drivers/parisc/pdc_stable.c
@@ -964,8 +964,8 @@ static struct subsys_attribute *pdcs_subsys_attrs[] = {
 	NULL,
 };
 
-static decl_subsys(paths, &ktype_pdcspath, NULL);
-static decl_subsys(stable, NULL, NULL);
+static decl_subsys(paths, NULL);
+static decl_subsys(stable, NULL);
 
 /**
  * pdcs_register_pathentries - Prepares path entries kobjects for sysfs usage.
@@ -997,7 +997,8 @@ pdcs_register_pathentries(void)
 
 		if ((err = kobject_set_name(&entry->kobj, "%s", entry->name)))
 			return err;
-		kobj_set_kset_s(entry, paths_subsys);
+		entry->kobj.kset = &paths_subsys;
+		entry->kobj.ktype = &ktype_pdcspath;
 		if ((err = kobject_register(&entry->kobj)))
 			return err;
 		
@@ -1072,7 +1073,7 @@ pdc_stable_init(void)
 			error = subsys_create_file(&stable_subsys, attr);
 	
 	/* register the paths subsys as a subsystem of stable subsys */
-	kobj_set_kset_s(&paths_subsys, stable_subsys);
+	paths_subsys.kobj.kset = &stable_subsys;
 	if ((rc = subsystem_register(&paths_subsys)))
 		goto fail_subsysreg;
 
diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 01c351c..ce1cff0 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -96,7 +96,7 @@ static struct kobj_type hotplug_slot_ktype = {
 	.release = &hotplug_slot_release,
 };
 
-decl_subsys_name(pci_hotplug_slots, slots, &hotplug_slot_ktype, NULL);
+decl_subsys_name(pci_hotplug_slots, slots, NULL);
 
 /* these strings match up with the values in pci_bus_speed */
 static char *pci_bus_speed_strings[] = {
@@ -633,7 +633,8 @@ int pci_hp_register (struct hotplug_slot *slot)
 	}
 
 	kobject_set_name(&slot->kobj, "%s", slot->name);
-	kobj_set_kset_s(slot, pci_hotplug_slots_subsys);
+	slot->kobj.kset = &pci_hotplug_slots_subsys;
+	slot->kobj.ktype = &hotplug_slot_ktype;
 
 	/* this can fail if we have already registered a slot with the same name */
 	if (kobject_register(&slot->kobj)) {
@@ -701,7 +702,7 @@ static int __init pci_hotplug_init (void)
 {
 	int result;
 
-	kobj_set_kset_s(&pci_hotplug_slots_subsys, pci_bus_type.subsys);
+	pci_hotplug_slots_subsys.kobj.kset = &pci_bus_type.subsys;
 	result = subsystem_register(&pci_hotplug_slots_subsys);
 	if (result) {
 		err("Register subsys with error %d\n", result);
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 865f32b..606aae7 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -160,7 +160,7 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 		if (!map_found) {
 			map_found = 1;
 			kobject_set_name(&idev->map_attr_kset.kobj,"maps");
-			idev->map_attr_kset.ktype = &map_attr_type;
+			idev->map_attr_kset.kobj.ktype = &map_attr_type;
 			idev->map_attr_kset.kobj.parent = &idev->dev->kobj;
 			ret = kset_register(&idev->map_attr_kset);
 			if (ret)
diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index 3bf0278..374ddbd 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -128,7 +128,7 @@ void configfs_release_fs(void)
 }
 
 
-static decl_subsys(config, NULL, NULL);
+static decl_subsys(config, NULL);
 
 static int __init configfs_init(void)
 {
@@ -140,7 +140,7 @@ static int __init configfs_init(void)
 	if (!configfs_dir_cachep)
 		goto out;
 
-	kobj_set_kset_s(&config_subsys, kernel_subsys);
+	config_subsys.kobj.kset = &kernel_subsys;
 	err = subsystem_register(&config_subsys);
 	if (err) {
 		kmem_cache_destroy(configfs_dir_cachep);
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 6a713b3..f7f1351 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -426,13 +426,13 @@ exit:
 }
 EXPORT_SYMBOL_GPL(debugfs_rename);
 
-static decl_subsys(debug, NULL, NULL);
+static decl_subsys(debug, NULL);
 
 static int __init debugfs_init(void)
 {
 	int retval;
 
-	kobj_set_kset_s(&debug_subsys, kernel_subsys);
+	debug_subsys.kobj.kset = &kernel_subsys;
 	retval = subsystem_register(&debug_subsys);
 	if (retval)
 		return retval;
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 6353a83..18e4a17 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -166,9 +166,7 @@ static struct kobj_type dlm_ktype = {
 	.release       = lockspace_kobj_release,
 };
 
-static struct kset dlm_kset = {
-	.ktype  = &dlm_ktype,
-};
+static struct kset dlm_kset;
 
 static int kobject_setup(struct dlm_ls *ls)
 {
@@ -228,7 +226,7 @@ int dlm_lockspace_init(void)
 	spin_lock_init(&lslist_lock);
 
 	kobject_set_name(&dlm_kset.kobj, "dlm");
-	kobj_set_kset_s(&dlm_kset, kernel_subsys);
+	dlm_kset.kobj.kset = &kernel_subsys;
 	error = kset_register(&dlm_kset);
 	if (error)
 		printk("dlm_lockspace_init: cannot register kset %d\n", error);
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 82b34f2..18ab012 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -730,7 +730,7 @@ static int ecryptfs_init_kmem_caches(void)
 	return 0;
 }
 
-static decl_subsys(ecryptfs, NULL, NULL);
+static decl_subsys(ecryptfs, NULL);
 
 static ssize_t version_show(struct kset *kset, char *buff)
 {
@@ -794,6 +794,7 @@ static int do_sysfs_registration(void)
 {
 	int rc;
 
+	ecryptfs_subsys.kobj.kset = &fs_subsys;
 	rc = subsystem_register(&ecryptfs_subsys);
 	if (rc) {
 		printk(KERN_ERR
@@ -841,7 +842,6 @@ static int __init ecryptfs_init(void)
 		printk(KERN_ERR "Failed to register filesystem\n");
 		goto out_free_kmem_caches;
 	}
-	kobj_set_kset_s(&ecryptfs_subsys, fs_subsys);
 	rc = do_sysfs_registration();
 	if (rc) {
 		printk(KERN_ERR "sysfs registration failed\n");
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 9a68d69..2df24c6 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -744,8 +744,8 @@ static inline void unregister_fuseblk(void)
 }
 #endif
 
-static decl_subsys(fuse, NULL, NULL);
-static decl_subsys(connections, NULL, NULL);
+static decl_subsys(fuse, NULL);
+static decl_subsys(connections, NULL);
 
 static void fuse_inode_init_once(struct kmem_cache *cachep, void *foo)
 {
@@ -795,12 +795,12 @@ static int fuse_sysfs_init(void)
 {
 	int err;
 
-	kobj_set_kset_s(&fuse_subsys, fs_subsys);
+	fuse_subsys.kobj.kset = &fs_subsys;
 	err = subsystem_register(&fuse_subsys);
 	if (err)
 		goto out_err;
 
-	kobj_set_kset_s(&connections_subsys, fuse_subsys);
+	connections_subsys.kobj.kset = &fuse_subsys;
 	err = subsystem_register(&connections_subsys);
 	if (err)
 		goto out_fuse_unregister;
diff --git a/fs/gfs2/locking/dlm/sysfs.c b/fs/gfs2/locking/dlm/sysfs.c
index ae9e6a2..93e66b2 100644
--- a/fs/gfs2/locking/dlm/sysfs.c
+++ b/fs/gfs2/locking/dlm/sysfs.c
@@ -189,9 +189,7 @@ static struct kobj_type gdlm_ktype = {
 	.sysfs_ops     = &gdlm_attr_ops,
 };
 
-static struct kset gdlm_kset = {
-	.ktype  = &gdlm_ktype,
-};
+static struct kset gdlm_kset;
 
 int gdlm_kobject_setup(struct gdlm_ls *ls, struct kobject *fskobj)
 {
@@ -224,7 +222,7 @@ int gdlm_sysfs_init(void)
 	int error;
 
 	kobject_set_name(&gdlm_kset.kobj, "lock_dlm");
-	kobj_set_kset_s(&gdlm_kset, kernel_subsys);
+	gdlm_kset.kobj.kset = &kernel_subsys;
 	error = kset_register(&gdlm_kset);
 	if (error)
 		printk("lock_dlm: cannot register kset %d\n", error);
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 06e0b77..d7fa544 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -221,9 +221,7 @@ static struct kobj_type gfs2_ktype = {
 	.sysfs_ops     = &gfs2_attr_ops,
 };
 
-static struct kset gfs2_kset = {
-	.ktype  = &gfs2_ktype,
-};
+static struct kset gfs2_kset;
 
 /*
  * display struct lm_lockstruct fields
@@ -551,7 +549,7 @@ int gfs2_sys_init(void)
 	gfs2_sys_margs = NULL;
 	spin_lock_init(&gfs2_sys_margs_lock);
 	kobject_set_name(&gfs2_kset.kobj, "gfs2");
-	kobj_set_kset_s(&gfs2_kset, fs_subsys);
+	gfs2_kset.kobj.kset = &fs_subsys;
 	return kset_register(&gfs2_kset);
 }
 
diff --git a/fs/namespace.c b/fs/namespace.c
index 0608388..a4a3f70 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -41,7 +41,7 @@ static struct kmem_cache *mnt_cache __read_mostly;
 static struct rw_semaphore namespace_sem;
 
 /* /sys/fs */
-decl_subsys(fs, NULL, NULL);
+decl_subsys(fs, NULL);
 EXPORT_SYMBOL_GPL(fs_subsys);
 
 static inline unsigned long hash(struct vfsmount *mnt, struct dentry *dentry)
diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index a4882c8..dead319 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -157,7 +157,7 @@ int mlog_sys_init(struct kset *o2cb_subsys)
 	mlog_attr_ptrs[i] = NULL;
 
 	kobject_set_name(&mlog_kset.kobj, "logmask");
-	kobj_set_kset_s(&mlog_kset, *o2cb_subsys);
+	mlog_kset.kobj.kset = o2cb_subsys;
 	return kset_register(&mlog_kset);
 }
 
diff --git a/fs/ocfs2/cluster/sys.c b/fs/ocfs2/cluster/sys.c
index 64f6f37..880d013 100644
--- a/fs/ocfs2/cluster/sys.c
+++ b/fs/ocfs2/cluster/sys.c
@@ -72,7 +72,7 @@ static struct kobj_type o2cb_subsys_type = {
 };
 
 /* gives us o2cb_subsys */
-static decl_subsys(o2cb, NULL, NULL);
+static decl_subsys(o2cb, NULL);
 
 static ssize_t
 o2cb_show(struct kobject * kobj, struct attribute * attr, char * buffer)
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 27d1785..4d6fba0 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -361,9 +361,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	/* if the kobject has no ktype, then we assume that it is a subsystem
 	 * itself, and use ops for it.
 	 */
-	if (kobj->kset && kobj->kset->ktype)
-		ops = kobj->kset->ktype->sysfs_ops;
-	else if (kobj->ktype)
+	if (kobj->ktype)
 		ops = kobj->ktype->sysfs_ops;
 	else
 		ops = &subsys_sysfs_ops;
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 4a0d27f..4dcf478 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -128,7 +128,6 @@ struct kset_uevent_ops {
  * define the attribute callbacks and other common events that happen to
  * a kobject.
  *
- * @ktype: the struct kobj_type for this specific kset
  * @list: the list of all kobjects for this kset
  * @list_lock: a lock for iterating over the kobjects
  * @kobj: the embedded kobject for this kset (recursion, isn't it fun...)
@@ -138,7 +137,6 @@ struct kset_uevent_ops {
  * desired.
  */
 struct kset {
-	struct kobj_type	*ktype;
 	struct list_head	list;
 	spinlock_t		list_lock;
 	struct kobject		kobj;
@@ -166,12 +164,9 @@ static inline void kset_put(struct kset * k)
 	kobject_put(&k->kobj);
 }
 
-static inline struct kobj_type * get_ktype(struct kobject * k)
+static inline struct kobj_type *get_ktype(struct kobject *kobj)
 {
-	if (k->kset && k->kset->ktype)
-		return k->kset->ktype;
-	else 
-		return k->ktype;
+	return kobj->ktype;
 }
 
 extern struct kobject * kset_find_obj(struct kset *, const char *);
@@ -184,16 +179,14 @@ extern struct kobject * kset_find_obj(struct kset *, const char *);
 #define set_kset_name(str)	.kset = { .kobj = { .k_name = str } }
 
 
-#define decl_subsys(_name,_type,_uevent_ops) \
+#define decl_subsys(_name,_uevent_ops) \
 struct kset _name##_subsys = { \
 	.kobj = { .k_name = __stringify(_name) }, \
-	.ktype = _type, \
 	.uevent_ops =_uevent_ops, \
 }
-#define decl_subsys_name(_varname,_name,_type,_uevent_ops) \
+#define decl_subsys_name(_varname,_name,_uevent_ops) \
 struct kset _varname##_subsys = { \
 	.kobj = { .k_name = __stringify(_name) }, \
-	.ktype = _type, \
 	.uevent_ops =_uevent_ops, \
 }
 
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 65daa53..094e2bc 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -94,7 +94,7 @@ static struct bin_attribute notes_attr = {
 	.read = &notes_read,
 };
 
-decl_subsys(kernel, NULL, NULL);
+decl_subsys(kernel, NULL);
 EXPORT_SYMBOL_GPL(kernel_subsys);
 
 static struct attribute * kernel_attrs[] = {
diff --git a/kernel/module.c b/kernel/module.c
index 3202c99..8240939 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1221,7 +1221,7 @@ int mod_sysfs_init(struct module *mod)
 	err = kobject_set_name(&mod->mkobj.kobj, "%s", mod->name);
 	if (err)
 		goto out;
-	kobj_set_kset_s(&mod->mkobj, module_subsys);
+	mod->mkobj.kobj.kset = &module_subsys;
 	mod->mkobj.mod = mod;
 
 	kobject_init(&mod->mkobj.kobj);
diff --git a/kernel/params.c b/kernel/params.c
index 16f269e..d4304b3 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -30,6 +30,8 @@
 #define DEBUGP(fmt, a...)
 #endif
 
+static struct kobj_type module_ktype;
+
 static inline char dash2underscore(char c)
 {
 	if (c == '-')
@@ -560,7 +562,8 @@ static void __init kernel_param_sysfs_setup(const char *name,
 	BUG_ON(!mk);
 
 	mk->mod = THIS_MODULE;
-	kobj_set_kset_s(mk, module_subsys);
+	mk->kobj.kset = &module_subsys;
+	mk->kobj.ktype = &module_ktype;
 	kobject_set_name(&mk->kobj, name);
 	kobject_init(&mk->kobj);
 	ret = kobject_add(&mk->kobj);
@@ -682,8 +685,6 @@ static struct sysfs_ops module_sysfs_ops = {
 	.store = module_attr_store,
 };
 
-static struct kobj_type module_ktype;
-
 static int uevent_filter(struct kset *kset, struct kobject *kobj)
 {
 	struct kobj_type *ktype = get_ktype(kobj);
@@ -697,7 +698,7 @@ static struct kset_uevent_ops module_uevent_ops = {
 	.filter = uevent_filter,
 };
 
-decl_subsys(module, &module_ktype, &module_uevent_ops);
+decl_subsys(module, &module_uevent_ops);
 int module_sysfs_initialized;
 
 static struct kobj_type module_ktype = {
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 3cdf95b..ce9bf12 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -273,7 +273,7 @@ EXPORT_SYMBOL(pm_suspend);
 
 #endif /* CONFIG_SUSPEND */
 
-decl_subsys(power,NULL,NULL);
+decl_subsys(power, NULL);
 
 
 /**
diff --git a/mm/slub.c b/mm/slub.c
index bcdb2c8..b821fdb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3978,7 +3978,7 @@ static struct kset_uevent_ops slab_uevent_ops = {
 	.filter = uevent_filter,
 };
 
-static decl_subsys(slab, &slab_ktype, &slab_uevent_ops);
+static decl_subsys(slab, &slab_uevent_ops);
 
 #define ID_STR_LENGTH 64
 
@@ -4041,8 +4041,9 @@ static int sysfs_slab_add(struct kmem_cache *s)
 		name = create_unique_id(s);
 	}
 
-	kobj_set_kset_s(s, slab_subsys);
 	kobject_set_name(&s->kobj, name);
+	s->kobj.kset = &slab_subsys;
+	s->kobj.ktype = &slab_ktype;
 	kobject_init(&s->kobj);
 	err = kobject_add(&s->kobj);
 	if (err)
diff --git a/security/inode.c b/security/inode.c
index b28a8ac..9e42f5f 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -315,13 +315,13 @@ void securityfs_remove(struct dentry *dentry)
 }
 EXPORT_SYMBOL_GPL(securityfs_remove);
 
-static decl_subsys(security, NULL, NULL);
+static decl_subsys(security, NULL);
 
 static int __init securityfs_init(void)
 {
 	int retval;
 
-	kobj_set_kset_s(&security_subsys, kernel_subsys);
+	security_subsys.kobj.kset = &kernel_subsys;
 	retval = subsystem_register(&security_subsys);
 	if (retval)
 		return retval;
-- 
1.5.3.4

