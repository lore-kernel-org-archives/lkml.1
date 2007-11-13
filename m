Return-Path: <linux-kernel-owner+w=401wt.eu-S1760506AbXKMARV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760506AbXKMARV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 19:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbXKMARK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 19:17:10 -0500
Received: from palrel13.hp.com ([156.153.255.238]:50890 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbXKMARI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 19:17:08 -0500
Date: Mon, 12 Nov 2007 17:17:07 -0700
From: Alex Chiang <achiang@hp.com>
To: gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
       matthew@wil.cx, richard.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org,
       achiang@hp.com
Subject: [PATCH 4/5, RFC] ACPI PCI slot detection driver
Message-ID: <20071113001707.GE13341@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, gregkh@suse.de,
	kristen.c.accardi@intel.com, lenb@kernel.org, matthew@wil.cx,
	richard.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz,
	pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
References: <20071113000853.GA13341@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113000853.GA13341@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Detect all physical PCI slots as described by ACPI, and create
entries in /sys/bus/pci/slots/.

Not all physical slots are hotpluggable, and the acpiphp module
does not detect them. Now we know the physical PCI geography of
our system, without caring about hotplug.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

Looking to get comments on this patch, as it could use some
work.
 
I borrowed a lot of code from acpiphp_glue.c. If your work is
identifiable and feel that pci_slot.c should have your (c),
please let me know.

More importantly, in register_slot(), we are seeing a lot of
noisy output during boot, as acpi_get_pci_id() complains quite
often about not finding an ACPI-PCI binding on devices we pass
in. I'm not quite sure what is the best way to detect whether
we've already added a slot, so that we can avoid calling
acpi_get_pci_id() so often.

 drivers/acpi/Makefile   |    3 +-
 drivers/acpi/pci_slot.c |  168 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 170 insertions(+), 1 deletions(-)
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
index 0000000..a49a14e
--- /dev/null
+++ b/drivers/acpi/pci_slot.c
@@ -0,0 +1,168 @@
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
+	struct acpi_pci_id id;
+	struct pci_slot *pci_slot;
+	struct pci_bus *pci_bus = context;
+
+	status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
+	if (ACPI_FAILURE(status))
+		return AE_OK;
+	device = (adr >> 16) & 0xffff;
+
+	/*
+	 * If we get AE_NOT_FOUND, that means we're looking at an
+	 * ACPI SxFy object which we're not conerned with, so just return.
+	 *
+	 * Otherwise, If we can find an ACPI context for this device, use it.
+	 */
+	status = acpi_get_pci_id(handle, &id);
+	if (status == AE_NOT_FOUND)
+		return AE_OK;
+	if (ACPI_SUCCESS(status)) {
+		pci_bus = pci_find_bus(id.segment, id.bus);
+		device = id.device;
+	}
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
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, ACPI_UINT32_MAX,
+				     register_slot, pci_bus, NULL);
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

