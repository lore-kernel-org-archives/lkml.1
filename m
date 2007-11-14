Return-Path: <linux-kernel-owner+w=401wt.eu-S1764530AbXKNTjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764530AbXKNTjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762763AbXKNTjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:39:25 -0500
Received: from palrel12.hp.com ([156.153.255.237]:43870 "EHLO palrel12.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648AbXKNTjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:39:23 -0500
Date: Wed, 14 Nov 2007 12:39:00 -0700
From: Alex Chiang <achiang@hp.com>
To: Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       Greg KH <greg@kroah.com>, gregkh@suse.de, kristen.c.accardi@intel.com,
       lenb@kernel.org, rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: [PATCH 5/5] ACPI PCI slot detection driver
Message-ID: <20071114193900.GF25002@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
	Greg KH <greg@kroah.com>, gregkh@suse.de,
	kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	kaneshige.kenji@jp.fujitsu.com, pcihpd-discuss@lists.sourceforge.net,
	linux-acpi@vger.kernel.org
References: <20071114193605.GA25002@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114193605.GA25002@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Detect all physical PCI slots as described by ACPI, and create
entries in /sys/bus/pci/slots/.

Not all physical slots are hotpluggable, and the acpiphp module
does not detect them. Now we know the physical PCI geography of
our system, without caring about hotplug.

v1 -> v2:
	Now recursively discovering p2p bridges and slots
	underneath them. Hopefully, this will prevent us
	from trying to register the same slot multiple times.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
 drivers/acpi/Makefile   |    3 +-
 drivers/acpi/pci_slot.c |  203 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 205 insertions(+), 1 deletions(-)
 create mode 100644 drivers/acpi/pci_slot.c

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 54e3ab0..f6caec8 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -47,7 +47,8 @@ obj-$(CONFIG_ACPI_FAN)		+= fan.o
 obj-$(CONFIG_ACPI_DOCK)		+= dock.o
 obj-$(CONFIG_ACPI_BAY)		+= bay.o
 obj-$(CONFIG_ACPI_VIDEO)	+= video.o
-obj-y				+= pci_root.o pci_link.o pci_irq.o pci_bind.o
+obj-y				+= pci_root.o pci_link.o pci_irq.o pci_bind.o \
+				   pci_slot.o
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
-- 
1.5.3.1.1.g1e61

