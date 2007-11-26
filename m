Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbXKZW2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbXKZW2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbXKZW2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:28:22 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:41695 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbXKZW2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:28:20 -0500
Date: Mon, 26 Nov 2007 15:28:19 -0700
From: Alex Chiang <achiang@hp.com>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       kaneshige.kenji@jp.fujitsu.com, pcihpd-discuss@lists.sourceforge.net,
       linux-acpi@vger.kernel.org
Subject: [PATCH 4/4, v5] ACPI, PCI: ACPI PCI slot detection driver
Message-ID: <20071126222819.GC31708@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
	gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
	pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
References: <20071117182954.GA25003@ldl.fc.hp.com> <20071119233225.GA6931@us.ibm.com> <20071126222253.GA31708@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126222253.GA31708@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Detect all physical PCI slots as described by ACPI, and create
entries in /sys/bus/pci/slots/.

Not all physical slots are hotpluggable, and the acpiphp module
does not detect them. Now we know the physical PCI geography of
our system, without caring about hotplug.

v4 -> v5:
	Convert to a tristate module.

	Remove #ifdef CONFIG_ACPI_PCI_SLOT, as struct pci_slot
	objects are properly refcounted, and multiple calls to
	pci_create/destroy_slot work just fine.

	Remove prior -EBUSY changes, as they have been folded
	into the Introduce pci_slot patch.

v3 -> v4:
	Always attempt to call pci_create_slot from pcihp_core to
	cover cases of
		a) user did not say Y to Kconfig option ACPI_PCI_SLOT
		b) native PCIe hotplug driver registering on a
		non-ACPI system.

	Return -EBUSY if an hp driver attempts to register a slot
	that is already registered to another driver. Do not
	consider that to be an error condition in acpiphp and pciehp.

v2 -> v3:
	Add Kconfig option to driver, allowing users to [de]config
	this driver. If configured, take slightly different code
	paths in pci_hp_register and pci_hp_deregister.

v1 -> v2:
	Now recursively discovering p2p bridges and slots
	underneath them. Hopefully, this will prevent us
	from trying to register the same slot multiple times.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
 drivers/acpi/Kconfig                   |    9 +
 drivers/acpi/Makefile                  |    1 +
 drivers/acpi/pci_slot.c                |  294 ++++++++++++++++++++++++++++++++
 drivers/pci/hotplug/pci_hotplug_core.c |   11 +-
 drivers/pci/hotplug/pciehp_core.c      |    2 +-
 drivers/pci/hotplug/sgi_hotplug.c      |    2 +-
 6 files changed, 316 insertions(+), 3 deletions(-)
 create mode 100644 drivers/acpi/pci_slot.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index ce9dead..f1eae4f 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -292,6 +292,15 @@ config ACPI_EC
 	  the battery and thermal drivers.  If you are compiling for a 
 	  mobile system, say Y.
 
+config ACPI_PCI_SLOT
+	tristate "PCI slot detection driver"
+	default n
+	help
+	  This driver will attempt to discover all PCI slots in your system,
+	  and creates entries in /sys/bus/pci/slots/. This feature can
+	  help you correlate PCI bus addresses with the physical geography
+	  of your slots. If you are unsure, say N.
+
 config ACPI_POWER
 	bool
 	default y
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 54e3ab0..d89000e 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_ACPI_DOCK)		+= dock.o
 obj-$(CONFIG_ACPI_BAY)		+= bay.o
 obj-$(CONFIG_ACPI_VIDEO)	+= video.o
 obj-y				+= pci_root.o pci_link.o pci_irq.o pci_bind.o
+obj-$(CONFIG_ACPI_PCI_SLOT)	+= pci_slot.o
 obj-$(CONFIG_ACPI_POWER)	+= power.o
 obj-$(CONFIG_ACPI_PROCESSOR)	+= processor.o
 obj-$(CONFIG_ACPI_CONTAINER)	+= container.o
diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
new file mode 100644
index 0000000..724f4f0
--- /dev/null
+++ b/drivers/acpi/pci_slot.c
@@ -0,0 +1,294 @@
+/*
+ *  pci_slot.c - ACPI PCI Slot Driver
+ *
+ *  The code here is heavily leveraged from the acpiphp module.
+ *  Thanks to Matthew Wilcox <matthew@wil.cx> for much guidance.
+ *
+ *  Copyright (C) 2007 Alex Chiang <achiang@hp.com>
+ *  Copyright (C) 2007 Hewlett-Packard Development Company, L.P.
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms and conditions of the GNU General Public License,
+ *  version 2, as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/acpi.h>
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_drivers.h>
+
+#define DRIVER_VERSION 	"0.1"
+#define DRIVER_AUTHOR	"Alex Chiang <achiang@hp.com>"
+#define DRIVER_DESC	"ACPI PCI Slot Detection Driver"
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
+
+#define _COMPONENT		ACPI_PCI_COMPONENT
+ACPI_MODULE_NAME("pci_slot");
+
+#define MY_NAME "pci_slot"
+#define err(format, arg...) printk(KERN_ERR "%s: " format , MY_NAME , ## arg)
+#define info(format, arg...) printk(KERN_INFO "%s: " format , MY_NAME , ## arg)
+
+static int acpi_pci_slot_add(acpi_handle handle);
+static void acpi_pci_slot_remove(acpi_handle handle);
+
+static struct acpi_pci_driver acpi_pci_slot_driver = {
+	.add = acpi_pci_slot_add,
+	.remove = acpi_pci_slot_remove,
+};
+
+static int
+check_slot(acpi_handle handle, int *device, unsigned long *sun)
+{
+	unsigned long adr;
+	acpi_status status;
+
+	status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
+	if (ACPI_FAILURE(status))
+		return -1;
+	*device = (adr >> 16) & 0xffff;
+
+	/* No _SUN == not a slot == bail */
+	status = acpi_evaluate_integer(handle, "_SUN", NULL, sun);
+	if (ACPI_FAILURE(status))
+		return -1;
+
+	return 0;
+}
+
+/*
+ * unregister_slot
+ *
+ * Called once for each SxFy object in the namespace. Each call to
+ * pci_destroy_slot decrements the refcount on the pci_slot, and
+ * eventually calls kobject_unregister at the appropriate time.
+ */
+static acpi_status
+unregister_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
+{
+	int device;
+	unsigned long sun;
+	struct pci_slot *slot;
+	struct pci_bus *pci_bus = context;
+
+	if (check_slot(handle, &device, &sun))
+		return AE_OK;
+
+	for (slot = pci_bus->slot; slot; slot = slot->next) {
+		if (slot->number == device)
+			pci_destroy_slot(slot);
+	}
+
+	return AE_OK;
+}
+
+/*
+ * register_slot
+ *
+ * Called once for each SxFy object in the namespace. Don't worry about
+ * calling pci_create_slot multiple times for the same pci_bus:device,
+ * since each subsequent call simply bumps the refcount on the pci_slot.
+ *
+ * The number of calls to pci_destroy_slot from unregister_slot is
+ * symmetrical.
+ */
+static acpi_status
+register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
+{
+	int device;
+	unsigned long sun;
+	char name[KOBJ_NAME_LEN];
+
+	struct pci_slot *pci_slot;
+	struct pci_bus *pci_bus = context;
+
+	if (check_slot(handle, &device, &sun))
+		return AE_OK;
+
+	snprintf(name, sizeof(name), "%u", (u32)sun);
+	pci_slot = pci_create_slot(pci_bus, device, name);
+	if (IS_ERR(pci_slot))
+		err("pci_create_slot returned %ld\n", PTR_ERR(pci_slot));
+
+	return AE_OK;
+}
+
+struct p2p_bridge_context
+{
+	acpi_walk_callback	user_function;
+	struct pci_bus		*pci_bus;
+};
+
+/*
+ * walk_p2p_bridge - discover and walk p2p bridges
+ * @handle: points to an acpi_pci_root
+ * @context: p2p_bridge_context pointer
+ *
+ * Note that when we call ourselves recursively, we pass a different
+ * value of pci_bus in the child_context.
+ */
+static acpi_status
+walk_p2p_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
+{
+	int device, function;
+	unsigned long adr;
+	acpi_status status;
+	acpi_handle dummy_handle;
+	acpi_walk_callback user_function;
+
+	struct pci_dev *dev;
+	struct pci_bus *pci_bus;
+	struct p2p_bridge_context child_context;
+	struct p2p_bridge_context *parent_context = context;
+
+	pci_bus = parent_context->pci_bus;
+	user_function = parent_context->user_function;
+
+	status = acpi_get_handle(handle, "_ADR", &dummy_handle);
+	if (ACPI_FAILURE(status))
+		return AE_OK;
+
+	status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
+	if (ACPI_FAILURE(status))
+		return AE_OK;
+
+	device = (adr >> 16) & 0xffff;
+	function = adr & 0xffff;
+
+	dev = pci_get_slot(pci_bus, PCI_DEVFN(device, function));
+	if (!dev || !dev->subordinate)
+		goto out;
+
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
+				     user_function, dev->subordinate, NULL);
+	if (ACPI_FAILURE(status))
+		goto out;
+
+	child_context.pci_bus = dev->subordinate;
+	child_context.user_function = user_function;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
+				     walk_p2p_bridge, &child_context, NULL);
+out:
+	pci_dev_put(dev);
+	return AE_OK;
+}
+
+#define ACPI_STA_FUNCTIONING            (0x00000008)
+
+/*
+ * walk_root_bridge - generic root bridge walker
+ * @handle: points to an acpi_pci_root
+ * @user_function: user callback for slot objects
+ *
+ * Call user_function for all objects underneath this root bridge.
+ * Walk p2p bridges underneath us and call user_function on those too.
+ */
+static int
+walk_root_bridge(acpi_handle handle, acpi_walk_callback user_function)
+{
+	int seg, bus;
+	unsigned long tmp;
+	acpi_status status;
+	acpi_handle dummy_handle;
+	struct pci_bus *pci_bus;
+	struct p2p_bridge_context context;
+
+	/* If the bridge doesn't have _STA, we assume it is always there */
+	status = acpi_get_handle(handle, "_STA", &dummy_handle);
+	if (ACPI_SUCCESS(status)) {
+		status = acpi_evaluate_integer(handle, "_STA", NULL, &tmp);
+		if (ACPI_FAILURE(status)) {
+			info("%s: _STA evaluation failure\n", __FUNCTION__);
+			return 0;
+		}
+		if ((tmp & ACPI_STA_FUNCTIONING) == 0)
+			/* don't register this object */
+			return 0;
+	}
+
+	status = acpi_evaluate_integer(handle, "_SEG", NULL, &tmp);
+	seg = ACPI_SUCCESS(status) ? tmp : 0;
+
+	status = acpi_evaluate_integer(handle, "_BBN", NULL, &tmp);
+	bus = ACPI_SUCCESS(status) ? tmp : 0;
+
+	pci_bus = pci_find_bus(seg, bus);
+	if (!pci_bus)
+		return 0;
+
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
+				     user_function, pci_bus, NULL);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	context.pci_bus = pci_bus;
+	context.user_function = user_function;
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
+				     walk_p2p_bridge, &context, NULL);
+	if (ACPI_FAILURE(status))
+		err("%s: walk_p2p_bridge failure - %d\n", __FUNCTION__, status);
+
+	return status;
+}
+
+/*
+ * acpi_pci_slot_add
+ * @handle: points to an acpi_pci_root
+ */
+static int
+acpi_pci_slot_add(acpi_handle handle)
+{
+	acpi_status status;
+
+	status = walk_root_bridge(handle, register_slot);
+	if (ACPI_FAILURE(status))
+		err("%s: register_slot failure - %d\n", __FUNCTION__, status);
+
+	return status;
+}
+
+/*
+ * acpi_pci_slot_remove
+ * @handle: points to an acpi_pci_root
+ */
+static void
+acpi_pci_slot_remove(acpi_handle handle)
+{
+	acpi_status status;
+
+	status = walk_root_bridge(handle, unregister_slot);
+	if (ACPI_FAILURE(status))
+		err("%s: unregister_slot failure - %d\n", __FUNCTION__, status);
+}
+
+static int __init
+acpi_pci_slot_init(void)
+{
+	acpi_pci_register_driver(&acpi_pci_slot_driver);
+	return 0;
+}
+
+
+static void __exit
+acpi_pci_slot_exit(void)
+{
+	acpi_pci_unregister_driver(&acpi_pci_slot_driver);
+}
+
+module_init(acpi_pci_slot_init);
+module_exit(acpi_pci_slot_exit);
diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 9a259eb..5dd8e12 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -567,6 +567,11 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
 		return -EINVAL;
 	}
 
+	/*
+	 * No problems if we call this interface from both ACPI_PCI_SLOT
+	 * driver and call it here again. If we've already created the
+	 * pci_slot, the interface will simply bump the refcount.
+	 */
 	pci_slot = pci_create_slot(bus, slot_nr, slot->name);
 	if (IS_ERR(pci_slot))
 		return PTR_ERR(pci_slot);
@@ -612,8 +617,12 @@ int pci_hp_deregister(struct hotplug_slot *hotplug)
 
 	slot = hotplug->pci_slot;
 	fs_remove_slot(slot);
-	pci_destroy_slot(slot);
 	dbg("Removed slot %s from the list\n", hotplug->name);
+
+	hotplug_release(slot);
+	slot->release = NULL;
+	pci_destroy_slot(slot);
+
 	return 0;
 }
 
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 0e9eaf6..299f6fa 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -249,7 +249,7 @@ static int init_slots(struct controller *ctrl)
 		if (retval == -EBUSY)
 			goto error_info;
 		if (retval) {
-			err ("pci_hp_register failed with error %d\n", retval);
+			err("pci_hp_register failed with error %d\n", retval);
 			goto error_info;
 		}
 		/* create additional sysfs entries */
-- 
1.5.3.1.g1e61

