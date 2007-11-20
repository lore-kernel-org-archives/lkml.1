Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbXKTDHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbXKTDHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 22:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbXKTDHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 22:07:42 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:24050 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbXKTDHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 22:07:40 -0500
Date: Mon, 19 Nov 2007 20:07:38 -0700
From: Alex Chiang <achiang@hp.com>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       gregkh@suse.de, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       kaneshige.kenji@jp.fujitsu.com, pcihpd-discuss@lists.sourceforge.net,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4, v4] ACPI, PCI: ACPI PCI slot detection driver
Message-ID: <20071120030738.GA15633@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
	gregkh@suse.de, lenb@kernel.org, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	kaneshige.kenji@jp.fujitsu.com, pcihpd-discuss@lists.sourceforge.net,
	linux-acpi@vger.kernel.org
References: <20071117182954.GA25003@ldl.fc.hp.com> <20071117183818.GD26452@ldl.fc.hp.com> <20071119220418.GE32540@ldl.fc.hp.com> <20071119142631.4aa650eb@appleyard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119142631.4aa650eb@appleyard>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Kristen Carlson Accardi <kristen.c.accardi@intel.com>:
> On Mon, 19 Nov 2007 15:04:18 -0700
> Alex Chiang <achiang@hp.com> wrote:
> 
> >  Documentation/accounting/getdelays.c         |   43 +-
> >  Documentation/feature-removal-schedule.txt   |    9 -
> >  Documentation/hwmon/sysfs-interface          |   31 +
> >  Documentation/markers.txt                    |    6 +-
> >  <snip>
> 
> Clearly something went horrifically wrong here.... 

Ugh, seems that stacked git got very confused when I did a
git-fetch && git-rebase origin. Also, guess it figures that I
shouldn't try and send a patch as I'm running out the door. :-/
Sorry about that.

Here is the correct version of Patch 4/4, v4. Note the small
changes in acpiphp and pciehp to disregard -EBUSY as an error
condition when returned from pci_hp_register. If you try and load
both drivers, whoever is in 2nd place will let you know that
another driver has already claimed the slot.

I didn't have the courage to go through and modify all the other
pcihp drivers, so if you have a system with both acpiphp and
shpcphp/cpciphp/etc., the dmesg output may be a little noisy (but
the behavior should be correct). 

I'll have to digest Gary's recommendation for a boot-time kernel
option tomorrow.

Thanks.

From: Alex Chiang <achiang@hp.com>

Detect all physical PCI slots as described by ACPI, and create
entries in /sys/bus/pci/slots/.

Not all physical slots are hotpluggable, and the acpiphp module
does not detect them. Now we know the physical PCI geography of
our system, without caring about hotplug.

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
 drivers/acpi/Kconfig                   |    9 ++
 drivers/acpi/Makefile                  |    1 +
 drivers/acpi/pci_slot.c                |  203 ++++++++++++++++++++++++++++++++
 drivers/pci/hotplug/acpiphp_core.c     |    2 +
 drivers/pci/hotplug/acpiphp_glue.c     |    7 +-
 drivers/pci/hotplug/pci_hotplug_core.c |   22 +++-
 drivers/pci/hotplug/pciehp_core.c      |   11 ++-
 drivers/pci/slot.c                     |    5 +
 9 files changed, 256 insertions(+), 6 deletions(-)
 create mode 100644 drivers/acpi/pci_slot.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index ce9dead..c6da1e0 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -292,6 +292,15 @@ config ACPI_EC
 	  the battery and thermal drivers.  If you are compiling for a 
 	  mobile system, say Y.
 
+config ACPI_PCI_SLOT
+	bool "PCI slot detection driver"
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
index 0000000..22f076b
--- /dev/null
+++ b/drivers/acpi/pci_slot.c
@@ -0,0 +1,203 @@
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
+/*
+ * register_slot - callback function to discover / create physical PCI slots
+ * @handle: any device underneath an acpi_pci_root (sometimes it's a slot
+ * device, sometimes not)
+ * @context: struct pci_bus
+ * The possible error conditions are non-fatal, so we always return
+ * AE_OK, as to not terminate our namespace walk prematurely.
+ */
+static acpi_status
+register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
+{
+	int device;
+	unsigned long adr, sun;
+	acpi_status status;
+	char name[KOBJ_NAME_LEN];
+
+	struct pci_slot *pci_slot;
+	struct pci_bus *pci_bus = context;
+
+	status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
+	if (ACPI_FAILURE(status))
+		return AE_OK;
+	device = (adr >> 16) & 0xffff;
+
+	/* No _SUN == not a slot == bail */
+	status = acpi_evaluate_integer(handle, "_SUN", NULL, &sun);
+	if (ACPI_FAILURE(status))
+		return AE_OK;
+
+	snprintf(name, sizeof(name), "%u", (u32)sun);
+	pci_slot = pci_create_slot(pci_bus, device, name);
+	if (IS_ERR(pci_slot)) {
+		err("pci_create_slot returned %ld\n", PTR_ERR(pci_slot));
+		return AE_OK;
+	}
+
+	return AE_OK;
+}
+
+/*
+ * find_p2p_bridge - callback function to discover p2p bridges
+ */
+static acpi_status
+find_p2p_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
+{
+	int device, function;
+	unsigned long adr;
+	acpi_status status;
+	acpi_handle dummy_handle;
+
+	struct pci_dev *dev;
+	struct pci_bus *pci_bus = context;
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
+				     register_slot, dev->subordinate, NULL);
+	if (ACPI_FAILURE(status))
+		goto out;
+
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
+				     find_p2p_bridge, dev->subordinate, NULL);
+out:
+	pci_dev_put(dev);
+	return AE_OK;
+}
+
+#define ACPI_STA_FUNCTIONING            (0x00000008)
+
+/*
+ * acpi_pci_slot_add - walk namespace under a PCI root bridge
+ * @handle: points to an acpi_pci_root
+ */
+static int
+acpi_pci_slot_add(acpi_handle handle)
+{
+	int seg, bus;
+	unsigned long tmp;
+	acpi_status status;
+	acpi_handle dummy_handle;
+	struct pci_bus *pci_bus;
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
+				     register_slot, pci_bus, NULL);
+	if (ACPI_FAILURE(status)) {
+		err("%s: register_slot failure - %d\n", __FUNCTION__, status);
+		return status;
+	}
+
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
+				     find_p2p_bridge, pci_bus, NULL);
+	if (ACPI_FAILURE(status))
+		err("%s: find_p2p_bridge failure - %d\n", __FUNCTION__, status);
+
+	return status;
+}
+
+static int __init
+acpi_pci_slot_init(void)
+{
+	acpi_pci_register_driver(&acpi_pci_slot_driver);
+	return 0;
+}
+
+/*
+ * acpi_pci_slot_remove and acpi_pci_slot_exit are empty for now, since
+ * /sys/bus/pci/slots/ entries shouldn't ever really go away.
+ */
+static void
+acpi_pci_slot_remove(acpi_handle handle)
+{
+}
+
+static void __exit
+acpi_pci_slot_exit(void)
+{
+}
+
+module_init(acpi_pci_slot_init);
+module_exit(acpi_pci_slot_exit);
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index 34b8d0b..518dcd6 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -346,6 +346,8 @@ int acpiphp_register_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
 	retval = pci_hp_register(slot->hotplug_slot,
 					acpiphp_slot->bridge->pci_bus,
 					acpiphp_slot->device);
+	if (retval == -EBUSY)
+		goto error_hpslot;
 	if (retval) {
 		err("pci_hp_register failed with error %d\n", retval);
 		goto error_hpslot;
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 02a2fd7..bb0eada 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -259,7 +259,12 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 				bridge->pci_bus->number, slot->device);
 		retval = acpiphp_register_hotplug_slot(slot);
 		if (retval) {
-			warn("acpiphp_register_hotplug_slot failed(err code = 0x%x)\n", retval);
+			if (retval == -EBUSY)
+				warn("Slot %d already registered by another "
+					"hotplug driver\n", slot->sun);
+			else
+				warn("acpiphp_register_hotplug_slot failed "
+					"(err code = 0x%x)\n", retval);
 			goto err_exit;
 		}
 	}
diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 1be5b0d..61ade06 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -567,6 +567,14 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
 		return -EINVAL;
 	}
 
+	/*
+	 * No problems if we call this interface from both ACPI_PCI_SLOT
+	 * driver and call it here again. If we've already created the
+	 * pci_slot, the interface will just return without error.
+	 *
+	 * We need this second call if we haven't already created the
+	 * pci_slot (in the case of native PCIe hp slot).
+	 */
 	pci_slot = pci_create_slot(bus, slot_nr, slot->name);
 	if (IS_ERR(pci_slot))
 		return PTR_ERR(pci_slot);
@@ -581,7 +589,7 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
 	list_add(&slot->slot_list, &pci_hotplug_slot_list);
 
 	result = fs_add_slot(pci_slot);
-	dbg ("Added slot %s to the list\n", slot->name);
+	dbg("Added slot %s to the list\n", slot->name);
 	return result;
 }
 
@@ -610,8 +618,18 @@ int pci_hp_deregister(struct hotplug_slot *hotplug)
 
 	slot = hotplug->pci_slot;
 	fs_remove_slot(slot);
-	pci_destroy_slot(slot);
 	dbg("Removed slot %s from the list\n", hotplug->name);
+#ifdef CONFIG_ACPI_PCI_SLOT
+	/*
+	 * If we are using the ACPI-PCI slot driver, we don't want to
+	 * destroy the pci_slot object. Rather, just release the
+	 * hotplug_slot associated with it.
+	 */
+	hotplug_release(slot);
+	slot->release = NULL;
+#else
+	pci_destroy_slot(slot);
+#endif
 	return 0;
 }
 
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 19aa33e..299f6fa 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -246,8 +246,10 @@ static int init_slots(struct controller *ctrl)
 		retval = pci_hp_register(hotplug_slot,
 					 ctrl->pci_dev->subordinate,
 					 slot->device);
+		if (retval == -EBUSY)
+			goto error_info;
 		if (retval) {
-			err ("pci_hp_register failed with error %d\n", retval);
+			err("pci_hp_register failed with error %d\n", retval);
 			goto error_info;
 		}
 		/* create additional sysfs entries */
@@ -452,7 +454,12 @@ static int pciehp_probe(struct pcie_device *dev, const struct pcie_port_service_
 	/* Setup the slot information structures */
 	rc = init_slots(ctrl);
 	if (rc) {
-		err("%s: slot initialization failed\n", PCIE_MODULE_NAME);
+		if (rc == -EBUSY)
+			warn("%s: slot already registered by another "
+				"hotplug driver\n", PCIE_MODULE_NAME);
+		else
+			err("%s: slot initialization failed\n", 
+				PCIE_MODULE_NAME);
 		goto err_out_release_ctlr;
 	}
 
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index f4ca61b..d2dc5dd 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -93,6 +93,11 @@ struct pci_slot *pci_slot_add_hotplug(struct pci_bus *parent, int slot_nr,
 		goto out;
 	}
 
+	if (slot->release) {
+		slot = ERR_PTR(-EBUSY);
+		goto out;
+	}
+
 	slot->release = release;
  out:
 	up_write(&pci_bus_sem);
-- 
1.5.3.1.1.g1e61

