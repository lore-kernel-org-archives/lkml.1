Return-Path: <linux-kernel-owner+w=401wt.eu-S1761036AbZCTVAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761036AbZCTVAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 17:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759575AbZCTU4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:56:55 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:45383 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759503AbZCTU4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:56:53 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v5 12/13] PCI Hotplug: rename legacy_fakephp to fakephp
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alex Chiang <achiang@hp.com>
Date: Fri, 20 Mar 2009 14:56:51 -0600
Message-ID: <20090320205651.12275.97108.stgit@bob.kio>
In-Reply-To: <20090320204327.12275.43010.stgit@bob.kio>
References: <20090320204327.12275.43010.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We wanted to replace fakephp wholesale, so rename legacy_fakephp back
to fakephp. Yes, this is a silly commit, but it produces a much easier
patch to read and review.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/Makefile         |    2 
 drivers/pci/hotplug/fakephp.c        |  162 ++++++++++++++++++++++++++++++++++
 drivers/pci/hotplug/legacy_fakephp.c |  162 ----------------------------------
 3 files changed, 163 insertions(+), 163 deletions(-)
 create mode 100644 drivers/pci/hotplug/fakephp.c
 delete mode 100644 drivers/pci/hotplug/legacy_fakephp.c

diff --git a/drivers/pci/hotplug/Makefile b/drivers/pci/hotplug/Makefile
index 3314fe8..2aa117c 100644
--- a/drivers/pci/hotplug/Makefile
+++ b/drivers/pci/hotplug/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_HOTPLUG_PCI_RPA_DLPAR)	+= rpadlpar_io.o
 obj-$(CONFIG_HOTPLUG_PCI_SGI)		+= sgi_hotplug.o
 
 # Link this last so it doesn't claim devices that have a real hotplug driver
-obj-$(CONFIG_HOTPLUG_PCI_FAKE)		+= legacy_fakephp.o
+obj-$(CONFIG_HOTPLUG_PCI_FAKE)		+= fakephp.o
 
 pci_hotplug-objs	:=	pci_hotplug_core.o
 
diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
new file mode 100644
index 0000000..2dc7828
--- /dev/null
+++ b/drivers/pci/hotplug/fakephp.c
@@ -0,0 +1,162 @@
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
+		pci_rescan_bus(slot->dev->bus);
+	else
+		sysfs_schedule_callback(&slot->dev->dev.kobj, remove_callback,
+					slot->dev, THIS_MODULE);
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
+	struct pci_dev *pdev = to_pci_dev(data);
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
diff --git a/drivers/pci/hotplug/legacy_fakephp.c b/drivers/pci/hotplug/legacy_fakephp.c
deleted file mode 100644
index 2dc7828..0000000
--- a/drivers/pci/hotplug/legacy_fakephp.c
+++ /dev/null
@@ -1,162 +0,0 @@
-/* Works like the fakephp driver used to, except a little better.
- *
- * - It's possible to remove devices with subordinate busses.
- * - New PCI devices that appear via any method, not just a fakephp triggered
- *   rescan, will be noticed.
- * - Devices that are removed via any method, not just a fakephp triggered
- *   removal, will also be noticed.
- *
- * Uses nothing from the pci-hotplug subsystem.
- *
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/list.h>
-#include <linux/kobject.h>
-#include <linux/sysfs.h>
-#include <linux/init.h>
-#include <linux/pci.h>
-#include "../pci.h"
-
-struct legacy_slot {
-	struct kobject		kobj;
-	struct pci_dev		*dev;
-	struct list_head	list;
-};
-
-static LIST_HEAD(legacy_list);
-
-static ssize_t legacy_show(struct kobject *kobj, struct attribute *attr,
-			   char *buf)
-{
-	struct legacy_slot *slot = container_of(kobj, typeof(*slot), kobj);
-	strcpy(buf, "1\n");
-	return 2;
-}
-
-static void remove_callback(void *data)
-{
-	pci_remove_bus_device((struct pci_dev *)data);
-}
-
-static ssize_t legacy_store(struct kobject *kobj, struct attribute *attr,
-			    const char *buf, size_t len)
-{
-	struct legacy_slot *slot = container_of(kobj, typeof(*slot), kobj);
-	unsigned long val;
-
-	if (strict_strtoul(buf, 0, &val) < 0)
-		return -EINVAL;
-
-	if (val)
-		pci_rescan_bus(slot->dev->bus);
-	else
-		sysfs_schedule_callback(&slot->dev->dev.kobj, remove_callback,
-					slot->dev, THIS_MODULE);
-	return len;
-}
-
-static struct attribute *legacy_attrs[] = {
-	&(struct attribute){ .name = "power", .mode = 0644 },
-	NULL,
-};
-
-static void legacy_release(struct kobject *kobj)
-{
-	struct legacy_slot *slot = container_of(kobj, typeof(*slot), kobj);
-
-	pci_dev_put(slot->dev);
-	kfree(slot);
-}
-
-static struct kobj_type legacy_ktype = {
-	.sysfs_ops = &(struct sysfs_ops){
-		.store = legacy_store, .show = legacy_show
-	},
-	.release = &legacy_release,
-	.default_attrs = legacy_attrs,
-};
-
-static int legacy_add_slot(struct pci_dev *pdev)
-{
-	struct legacy_slot *slot = kzalloc(sizeof(*slot), GFP_KERNEL);
-
-	if (!slot)
-		return -ENOMEM;
-
-	if (kobject_init_and_add(&slot->kobj, &legacy_ktype,
-				 &pci_slots_kset->kobj, "%s",
-				 pdev->dev.bus_id)) {
-		dev_warn(&pdev->dev, "Failed to created legacy fake slot\n");
-		return -EINVAL;
-	}
-	slot->dev = pci_dev_get(pdev);
-
-	list_add(&slot->list, &legacy_list);
-
-	return 0;
-}
-
-static int legacy_notify(struct notifier_block *nb,
-			 unsigned long action, void *data)
-{
-	struct pci_dev *pdev = to_pci_dev(data);
-
-	if (action == BUS_NOTIFY_ADD_DEVICE) {
-		legacy_add_slot(pdev);
-	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
-		struct legacy_slot *slot;
-
-		list_for_each_entry(slot, &legacy_list, list)
-			if (slot->dev == pdev)
-				goto found;
-
-		dev_warn(&pdev->dev, "Missing legacy fake slot?");
-		return -ENODEV;
-found:
-		kobject_del(&slot->kobj);
-		list_del(&slot->list);
-		kobject_put(&slot->kobj);
-	}
-
-	return 0;
-}
-
-static struct notifier_block legacy_notifier = {
-	.notifier_call = legacy_notify
-};
-
-static int __init init_legacy(void)
-{
-	struct pci_dev *pdev = NULL;
-
-	/* Add existing devices */
-	while ((pdev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pdev)))
-		legacy_add_slot(pdev);
-
-	/* Be alerted of any new ones */
-	bus_register_notifier(&pci_bus_type, &legacy_notifier);
-	return 0;
-}
-module_init(init_legacy);
-
-static void __exit remove_legacy(void)
-{
-	struct legacy_slot *slot, *tmp;
-
-	bus_unregister_notifier(&pci_bus_type, &legacy_notifier);
-
-	list_for_each_entry_safe(slot, tmp, &legacy_list, list) {
-		list_del(&slot->list);
-		kobject_del(&slot->kobj);
-		kobject_put(&slot->kobj);
-	}
-}
-module_exit(remove_legacy);
-
-
-MODULE_AUTHOR("Trent Piepho <xyzzy@speakeasy.org>");
-MODULE_DESCRIPTION("Legacy version of the fakephp interface");
-MODULE_LICENSE("GPL");

