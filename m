Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbYLAOJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbYLAOJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYLAOJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:09:07 -0500
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:43196 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbYLAOJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:09:05 -0500
From: Trent Piepho <xyzzy@speakeasy.org>
To: linux-kernel@vger.kernel.org
Cc: linux-pci <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       Alex Chiang <achiang@hp.com>, Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH] PCI: Legacy fakephp driver
Date: Mon,  1 Dec 2008 06:08:10 -0800
Message-Id: <1228140490-32199-2-git-send-email-xyzzy@speakeasy.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <Pine.LNX.4.58.0812010500330.2943@shell2.speakeasy.net>
References: <Pine.LNX.4.58.0812010500330.2943@shell2.speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This module has an interface that's compatible with how fakephp's has been.

It puts entries in /sys/bus/pci/slots with the names of all PCI
devices/functions.  Each one has a "power" attribute, which works the same
way as the fakephp driver's power attribute has worked.

There are a few improvements over fakephp, which couldn't handle PCI
devices being added or removed via a means other than fakephp's actions.
If is device was added another way, fakephp doesn't notice and create the
fake slot for it.  If a device was removed another way, fakephp doesn't
delete the fake slot for it (and accessing the stale slot will cause an
oops).  This is fixed.  As a consequence of this, removing a bridge with
other devices behind it works as well, which is something else fakephp
couldn't do.

This duplicates a tiny bit of the code in the PCI core that does this same
function.  Re-using that code ends up being more complex than duplicating
it, and it makes code in the PCI core more ugly just to support this legacy
fakephp interface compatibility layer.

Doing a rescan isn't supported yet.
---
 drivers/pci/hotplug/Kconfig          |    5 +
 drivers/pci/hotplug/Makefile         |    1 +
 drivers/pci/hotplug/legacy_fakephp.c |  163 ++++++++++++++++++++++++++++++++++
 3 files changed, 169 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pci/hotplug/legacy_fakephp.c

diff --git a/drivers/pci/hotplug/Kconfig b/drivers/pci/hotplug/Kconfig
index eacfb13..d26bc68 100644
--- a/drivers/pci/hotplug/Kconfig
+++ b/drivers/pci/hotplug/Kconfig
@@ -39,6 +39,11 @@ config HOTPLUG_PCI_FAKE
 
 	  When in doubt, say N.
 
+config HOTPLUG_PCI_LEGACY_FAKE
+	tristate "Legacy Fake PCI Hotplug driver"
+	help
+	  Provides an interface like the fakephp driver used to.
+
 config HOTPLUG_PCI_COMPAQ
 	tristate "Compaq PCI Hotplug driver"
 	depends on X86 && PCI_BIOS && PCI_LEGACY
diff --git a/drivers/pci/hotplug/Makefile b/drivers/pci/hotplug/Makefile
index 9bdbe1a..9ad009d 100644
--- a/drivers/pci/hotplug/Makefile
+++ b/drivers/pci/hotplug/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_HOTPLUG_PCI_SHPC)		+= shpchp.o
 obj-$(CONFIG_HOTPLUG_PCI_RPA)		+= rpaphp.o
 obj-$(CONFIG_HOTPLUG_PCI_RPA_DLPAR)	+= rpadlpar_io.o
 obj-$(CONFIG_HOTPLUG_PCI_SGI)		+= sgi_hotplug.o
+obj-$(CONFIG_HOTPLUG_PCI_LEGACY_FAKE)	+= legacy_fakephp.o
 
 # Link this last so it doesn't claim devices that have a real hotplug driver
 obj-$(CONFIG_HOTPLUG_PCI_FAKE)		+= fakephp.o
diff --git a/drivers/pci/hotplug/legacy_fakephp.c b/drivers/pci/hotplug/legacy_fakephp.c
new file mode 100644
index 0000000..a13cf98
--- /dev/null
+++ b/drivers/pci/hotplug/legacy_fakephp.c
@@ -0,0 +1,163 @@
+/* Works like the fakephp driver used to, except a little better.
+ *
+ * - It's possible to remove devices with subordinate busses.
+ * - New PCI devices that appear via any method, not just a fakephp triggered
+ *   rescan, will be noticed.
+ * - Devices that are removed via any method, not just a fakephp triggered
+ *   removal, will also be noticed.
+ *
+ * Uses nothing from the pci-hotplug subsystem.
+ *
+ * Currently you can't do a bus rescan, but that should be fixed.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include "../pci.h"
+
+struct legacy_slot {
+	struct kobject		kobj;
+	struct pci_dev		*dev;
+	struct list_head	list;
+};
+
+static LIST_HEAD(legacy_list);
+
+static ssize_t legacy_show(struct kobject *kobj, struct attribute *attr,
+			   char *buf)
+{
+	struct legacy_slot *slot = container_of(kobj, typeof(*slot), kobj);
+	strcpy(buf, "1\n");
+	return 2;
+}
+
+static void remove_callback(void *data)
+{
+	pci_remove_bus_device((struct pci_dev *)data);
+}
+
+static ssize_t legacy_store(struct kobject *kobj, struct attribute *attr,
+			    const char *buf, size_t len)
+{
+	struct legacy_slot *slot = container_of(kobj, typeof(*slot), kobj);
+	unsigned long val;
+
+	if (strict_strtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (val)
+		return len; /* rescan should go here */
+	else
+		sysfs_schedule_callback(&slot->dev->dev.kobj, remove_callback,
+		                        slot->dev, THIS_MODULE);
+	return len;
+}
+
+static struct attribute *legacy_attrs[] = {
+	&(struct attribute){ .name = "power", .mode = 0644 },
+	NULL,
+};
+
+static void legacy_release(struct kobject *kobj)
+{
+	struct legacy_slot *slot = container_of(kobj, typeof(*slot), kobj);
+
+	pci_dev_put(slot->dev);
+	kfree(slot);
+}
+
+static struct kobj_type legacy_ktype = {
+	.sysfs_ops = &(struct sysfs_ops){
+		.store = legacy_store, .show = legacy_show
+	},
+	.release = &legacy_release,
+	.default_attrs = legacy_attrs,
+};
+
+static int legacy_add_slot(struct pci_dev *pdev)
+{
+	struct legacy_slot *slot = kzalloc(sizeof(*slot), GFP_KERNEL);
+
+	if (!slot)
+		return -ENOMEM;
+
+	if (kobject_init_and_add(&slot->kobj, &legacy_ktype,
+				 &pci_slots_kset->kobj, "%s",
+				 pdev->dev.bus_id)) {
+		dev_warn(&pdev->dev, "Failed to created legacy fake slot\n");
+		return -EINVAL;
+	}
+	slot->dev = pci_dev_get(pdev);
+
+	list_add(&slot->list, &legacy_list);
+
+	return 0;
+}
+
+static int legacy_notify(struct notifier_block *nb,
+			 unsigned long action, void *data)
+{
+        struct pci_dev *pdev = to_pci_dev(data);
+
+	if (action == BUS_NOTIFY_ADD_DEVICE) {
+		legacy_add_slot(pdev);
+	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
+		struct legacy_slot *slot;
+
+		list_for_each_entry(slot, &legacy_list, list)
+			if (slot->dev == pdev)
+				goto found;
+
+		dev_warn(&pdev->dev, "Missing legacy fake slot?");
+		return -ENODEV;
+found:
+		kobject_del(&slot->kobj);
+		list_del(&slot->list);
+		kobject_put(&slot->kobj);
+	}
+
+	return 0;
+}
+
+static struct notifier_block legacy_notifier = {
+	.notifier_call = legacy_notify
+};
+
+static int __init init_legacy(void)
+{
+	struct pci_dev *pdev = NULL;
+
+	/* Add existing devices */
+	while ((pdev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pdev)))
+		legacy_add_slot(pdev);
+
+	/* Be alerted of any new ones */
+	bus_register_notifier(&pci_bus_type, &legacy_notifier);
+	return 0;
+}
+module_init(init_legacy);
+
+static void __exit remove_legacy(void)
+{
+	struct legacy_slot *slot, *tmp;
+
+	bus_unregister_notifier(&pci_bus_type, &legacy_notifier);
+
+	list_for_each_entry_safe(slot, tmp, &legacy_list, list) {
+		list_del(&slot->list);
+		kobject_del(&slot->kobj);
+		kobject_put(&slot->kobj);
+	}
+}
+module_exit(remove_legacy);
+
+
+MODULE_AUTHOR("Trent Piepho <xyzzy@speakeasy.org>");
+MODULE_DESCRIPTION("Legacy version of the fakephp interface");
+MODULE_LICENSE("GPL");
-- 
1.5.4.1

