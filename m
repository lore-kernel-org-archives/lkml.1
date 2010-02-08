Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab0BHWow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 17:44:52 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:34412 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab0BHWor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 17:44:47 -0500
Subject: [PATCH v2 5/7] PCI: replace bus resource table with a list
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-pci@vger.kernel.org, Peter Haight <peterh@sapros.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 08 Feb 2010 15:44:43 -0700
Message-ID: <20100208224443.27954.29048.stgit@bob.kio>
In-Reply-To: <20100208224236.27954.4358.stgit@bob.kio>
References: <20100208224236.27954.4358.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Previously we used a table of size PCI_BUS_NUM_RESOURCES for resources
forwarded to a bus by its upstream bridge.  We've increased this size
several times when the table overflowed.

But there's no good limit on the number of resources for a bus because
host bridges can forward any number of ranges to their secondary buses
(i.e., PCI root buses).

This patch replaces the fixed-size table with a list.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/ia64/pci/pci.c                |   20 +++---
 arch/x86/pci/acpi.c                |   33 +----------
 arch/x86/pci/bus_numa.c            |    9 ++-
 drivers/pci/bus.c                  |   50 +++++++++++++++-
 drivers/pci/hotplug/shpchp_sysfs.c |   15 +++--
 drivers/pci/pci.c                  |    6 +-
 drivers/pci/probe.c                |   35 +++++++----
 drivers/pci/setup-bus.c            |  111 +++++++++++++++++-------------------
 drivers/pcmcia/rsrc_nonstatic.c    |    7 +-
 drivers/pcmcia/yenta_socket.c      |    7 +-
 include/linux/pci.h                |   16 ++++-
 11 files changed, 169 insertions(+), 140 deletions(-)


diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 783c83b..ad64554 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -320,9 +320,9 @@ static __devinit acpi_status add_window(struct acpi_resource *res, void *data)
 static void __devinit
 pcibios_setup_root_windows(struct pci_bus *bus, struct pci_controller *ctrl)
 {
-	int i, j;
+	int i;
 
-	j = 0;
+	pci_bus_remove_resources(bus);
 	for (i = 0; i < ctrl->windows; i++) {
 		struct resource *res = &ctrl->window[i].resource;
 		/* HP's firmware has a hack to work around a Windows bug.
@@ -330,13 +330,7 @@ pcibios_setup_root_windows(struct pci_bus *bus, struct pci_controller *ctrl)
 		if ((res->flags & IORESOURCE_MEM) &&
 		    (res->end - res->start < 16))
 			continue;
-		if (j >= PCI_BUS_NUM_RESOURCES) {
-			dev_warn(&bus->dev,
-				 "ignoring host bridge window %pR (no space)\n",
-				 res);
-			continue;
-		}
-		bus->resource[j++] = res;
+		pci_bus_add_resource(bus, res, 0);
 	}
 }
 
@@ -451,13 +445,15 @@ EXPORT_SYMBOL(pcibios_bus_to_resource);
 
 static int __devinit is_valid_resource(struct pci_dev *dev, int idx)
 {
-	unsigned int i, type_mask = IORESOURCE_IO | IORESOURCE_MEM;
+	unsigned int type_mask = IORESOURCE_IO | IORESOURCE_MEM;
 	struct resource *devr = &dev->resource[idx];
+	struct pci_bus_resource *bus_res;
 
 	if (!dev->bus)
 		return 0;
-	for (i=0; i<PCI_BUS_NUM_RESOURCES; i++) {
-		struct resource *busr = dev->bus->resource[i];
+
+	list_for_each_entry(bus_res, &dev->bus->resources, list) {
+		struct resource *busr = bus_res->res;
 
 		if (!busr || ((busr->flags ^ devr->flags) & type_mask))
 			continue;
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 959e548..a2f8cdb 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -45,20 +45,6 @@ count_resource(struct acpi_resource *acpi_res, void *data)
 	return AE_OK;
 }
 
-static int
-bus_has_transparent_bridge(struct pci_bus *bus)
-{
-	struct pci_dev *dev;
-
-	list_for_each_entry(dev, &bus->devices, bus_list) {
-		u16 class = dev->class >> 8;
-
-		if (class == PCI_CLASS_BRIDGE_PCI && dev->transparent)
-			return true;
-	}
-	return false;
-}
-
 static void
 align_resource(struct acpi_device *bridge, struct resource *res)
 {
@@ -92,12 +78,8 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 	acpi_status status;
 	unsigned long flags;
 	struct resource *root;
-	int max_root_bus_resources = PCI_BUS_NUM_RESOURCES;
 	u64 start, end;
 
-	if (bus_has_transparent_bridge(info->bus))
-		max_root_bus_resources -= 3;
-
 	status = resource_to_addr(acpi_res, &addr);
 	if (!ACPI_SUCCESS(status))
 		return AE_OK;
@@ -115,15 +97,6 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 
 	start = addr.minimum + addr.translation_offset;
 	end = start + addr.address_length - 1;
-	if (info->res_num >= max_root_bus_resources) {
-		if (pci_probe & PCI_USE__CRS)
-			printk(KERN_WARNING "PCI: Failed to allocate "
-			       "0x%lx-0x%lx from %s for %s due to _CRS "
-			       "returning more than %d resource descriptors\n",
-			       (unsigned long) start, (unsigned long) end,
-			       root->name, info->name, max_root_bus_resources);
-		return AE_OK;
-	}
 
 	res = &info->res[info->res_num];
 	res->name = info->name;
@@ -143,7 +116,7 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 		dev_err(&info->bridge->dev,
 			"can't allocate host bridge window %pR\n", res);
 	} else {
-		info->bus->resource[info->res_num] = res;
+		pci_bus_add_resource(info->bus, res, 0);
 		info->res_num++;
 		if (addr.translation_offset)
 			dev_info(&info->bridge->dev, "host bridge window %pR "
@@ -164,7 +137,9 @@ get_current_resources(struct acpi_device *device, int busnum,
 	struct pci_root_info info;
 	size_t size;
 
-	if (!(pci_probe & PCI_USE__CRS))
+	if (pci_probe & PCI_USE__CRS)
+		pci_bus_remove_resources(bus);
+	else
 		dev_info(&device->dev,
 			 "ignoring host bridge windows from ACPI; "
 			 "boot with \"pci=use_crs\" to use them\n");
diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index f939d60..6999970 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -12,10 +12,12 @@ void x86_pci_root_bus_res_quirks(struct pci_bus *b)
 	int i;
 	int j;
 	struct pci_root_info *info;
+	struct pci_bus_resource *bus_res;
 
 	/* don't go for it if _CRS is used already */
-	if (b->resource[0] != &ioport_resource ||
-	    b->resource[1] != &iomem_resource)
+	bus_res = list_first_entry(&b->resources, struct pci_bus_resource,
+				   list);
+	if (bus_res->res != &ioport_resource)
 		return;
 
 	if (!pci_root_num)
@@ -36,13 +38,14 @@ void x86_pci_root_bus_res_quirks(struct pci_bus *b)
 	printk(KERN_DEBUG "PCI: peer root bus %02x res updated from pci conf\n",
 			b->number);
 
+	pci_bus_remove_resources(b);
 	info = &pci_root_info[i];
 	for (j = 0; j < info->res_num; j++) {
 		struct resource *res;
 		struct resource *root;
 
 		res = &info->res[j];
-		b->resource[j] = res;
+		pci_bus_add_resource(b, res, 0);
 		if (res->flags & IORESOURCE_IO)
 			root = &ioport_resource;
 		else
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index a26135b..9725846 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -17,6 +17,49 @@
 
 #include "pci.h"
 
+void pci_bus_add_resource(struct pci_bus *bus, struct resource *res,
+			  unsigned int flags)
+{
+	struct pci_bus_resource *bus_res;
+
+	bus_res = kzalloc(sizeof(struct pci_bus_resource), GFP_KERNEL);
+	if (!bus_res) {
+		dev_err(&bus->dev, "can't add %pR resource\n", res);
+		return;
+	}
+
+	bus_res->res = res;
+	bus_res->flags = flags;
+	list_add_tail(&bus_res->list, &bus->resources);
+}
+
+struct resource *pci_bus_get_resource(struct pci_bus *bus, unsigned long flags,
+		int num)
+{
+	struct pci_bus_resource *bus_res;
+	struct resource *res;
+
+	list_for_each_entry(bus_res, &bus->resources, list) {
+		if (!(bus_res->flags & PCI_POSITIVE_DECODE))
+			continue;
+
+		res = bus_res->res;
+		if (((res->flags & flags) == flags) && num-- == 0)
+			return res;
+	}
+	return NULL;
+}
+
+void pci_bus_remove_resources(struct pci_bus *bus)
+{
+	struct pci_bus_resource *bus_res, *tmp;
+
+	list_for_each_entry_safe(bus_res, tmp, &bus->resources, list) {
+		list_del(&bus_res->list);
+		kfree(bus_res);
+	}
+}
+
 /**
  * pci_bus_alloc_resource - allocate a resource from a parent bus
  * @bus: PCI bus
@@ -42,7 +85,8 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 					  resource_size_t),
 		void *alignf_data)
 {
-	int i, ret = -ENOMEM;
+	int ret = -ENOMEM;
+	struct pci_bus_resource *bus_res;
 	resource_size_t max = -1;
 
 	type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
@@ -51,8 +95,8 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 	if (!(res->flags & IORESOURCE_MEM_64))
 		max = PCIBIOS_MAX_MEM_32;
 
-	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
-		struct resource *r = bus->resource[i];
+	list_for_each_entry(bus_res, &bus->resources, list) {
+		struct resource *r = bus_res->res;
 		if (!r)
 			continue;
 
diff --git a/drivers/pci/hotplug/shpchp_sysfs.c b/drivers/pci/hotplug/shpchp_sysfs.c
index 29fa9d2..e1a9d6a 100644
--- a/drivers/pci/hotplug/shpchp_sysfs.c
+++ b/drivers/pci/hotplug/shpchp_sysfs.c
@@ -39,16 +39,17 @@ static ssize_t show_ctrl (struct device *dev, struct device_attribute *attr, cha
 {
 	struct pci_dev *pdev;
 	char * out = buf;
-	int index, busnr;
+	int busnr;
 	struct resource *res;
 	struct pci_bus *bus;
+	struct pci_bus_resource *bus_res;
 
 	pdev = container_of (dev, struct pci_dev, dev);
 	bus = pdev->subordinate;
 
 	out += sprintf(buf, "Free resources: memory\n");
-	for (index = 0; index < PCI_BUS_NUM_RESOURCES; index++) {
-		res = bus->resource[index];
+	list_for_each_entry(bus_res, &bus->resources, list) {
+		res = bus_res->res;
 		if (res && (res->flags & IORESOURCE_MEM) &&
 				!(res->flags & IORESOURCE_PREFETCH)) {
 			out += sprintf(out, "start = %8.8llx, "
@@ -58,8 +59,8 @@ static ssize_t show_ctrl (struct device *dev, struct device_attribute *attr, cha
 		}
 	}
 	out += sprintf(out, "Free resources: prefetchable memory\n");
-	for (index = 0; index < PCI_BUS_NUM_RESOURCES; index++) {
-		res = bus->resource[index];
+	list_for_each_entry(bus_res, &bus->resources, list) {
+		res = bus_res->res;
 		if (res && (res->flags & IORESOURCE_MEM) &&
 			       (res->flags & IORESOURCE_PREFETCH)) {
 			out += sprintf(out, "start = %8.8llx, "
@@ -69,8 +70,8 @@ static ssize_t show_ctrl (struct device *dev, struct device_attribute *attr, cha
 		}
 	}
 	out += sprintf(out, "Free resources: IO\n");
-	for (index = 0; index < PCI_BUS_NUM_RESOURCES; index++) {
-		res = bus->resource[index];
+	list_for_each_entry(bus_res, &bus->resources, list) {
+		res = bus_res->res;
 		if (res && (res->flags & IORESOURCE_IO)) {
 			out += sprintf(out, "start = %8.8llx, "
 					"length = %8.8llx\n",
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d62a5de..60a6a88 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -385,11 +385,11 @@ struct resource *
 pci_find_parent_resource(const struct pci_dev *dev, struct resource *res)
 {
 	const struct pci_bus *bus = dev->bus;
-	int i;
+	struct pci_bus_resource *bus_res;
 	struct resource *best = NULL;
 
-	for(i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
-		struct resource *r = bus->resource[i];
+	list_for_each_entry(bus_res, &bus->resources, list) {
+		struct resource *r = bus_res->res;
 		if (!r)
 			continue;
 		if (res->start && !(res->start >= r->start && res->end <= r->end))
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 838a2c4..04e7e97 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -89,6 +89,7 @@ static void release_pcibus_dev(struct device *dev)
 
 	if (pci_bus->bridge)
 		put_device(pci_bus->bridge);
+	pci_bus_remove_resources(pci_bus);
 	kfree(pci_bus);
 }
 
@@ -288,7 +289,8 @@ static void __devinit pci_read_bridge_io(struct pci_bus *child)
 	unsigned long base, limit;
 	struct resource *res;
 
-	res = child->resource[0];
+	res = &dev->resource[PCI_BRIDGE_RESOURCES + 0];
+
 	pci_read_config_byte(dev, PCI_IO_BASE, &io_base_lo);
 	pci_read_config_byte(dev, PCI_IO_LIMIT, &io_limit_lo);
 	base = (io_base_lo & PCI_IO_RANGE_MASK) << 8;
@@ -323,7 +325,8 @@ static void __devinit pci_read_bridge_mmio(struct pci_bus *child)
 	unsigned long base, limit;
 	struct resource *res;
 
-	res = child->resource[1];
+	res = &dev->resource[PCI_BRIDGE_RESOURCES + 1];
+
 	pci_read_config_word(dev, PCI_MEMORY_BASE, &mem_base_lo);
 	pci_read_config_word(dev, PCI_MEMORY_LIMIT, &mem_limit_lo);
 	base = (mem_base_lo & PCI_MEMORY_RANGE_MASK) << 16;
@@ -347,7 +350,8 @@ static void __devinit pci_read_bridge_mmio_pref(struct pci_bus *child)
 	unsigned long base, limit;
 	struct resource *res;
 
-	res = child->resource[2];
+	res = &dev->resource[PCI_BRIDGE_RESOURCES + 2];
+
 	pci_read_config_word(dev, PCI_PREF_MEMORY_BASE, &mem_base_lo);
 	pci_read_config_word(dev, PCI_PREF_MEMORY_LIMIT, &mem_limit_lo);
 	base = (mem_base_lo & PCI_PREF_RANGE_MASK) << 16;
@@ -394,7 +398,7 @@ static void __devinit pci_read_bridge_mmio_pref(struct pci_bus *child)
 void __devinit pci_read_bridge_bases(struct pci_bus *child)
 {
 	struct pci_dev *dev = child->self;
-	int i;
+	struct pci_bus_resource *bus_res;
 
 	if (pci_is_root_bus(child))	/* It's a host bus, nothing to read */
 		return;
@@ -408,12 +412,11 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 	pci_read_bridge_mmio_pref(child);
 
 	if (dev->transparent) {
-		for (i = 3; i < PCI_BUS_NUM_RESOURCES; i++) {
-			child->resource[i] = child->parent->resource[i - 3];
-			if (child->resource[i])
-				dev_printk(KERN_DEBUG, &dev->dev,
-					   "  bridge window %pR (subtractive decode)\n",
-					   child->resource[i]);
+		list_for_each_entry(bus_res, &child->parent->resources, list) {
+			pci_bus_add_resource(child, bus_res->res, 0);
+			dev_printk(KERN_DEBUG, &dev->dev,
+				   "  bridge window %pR (subtractive decode)\n",
+				   bus_res->res);
 		}
 	}
 }
@@ -428,6 +431,7 @@ static struct pci_bus * pci_alloc_bus(void)
 		INIT_LIST_HEAD(&b->children);
 		INIT_LIST_HEAD(&b->devices);
 		INIT_LIST_HEAD(&b->slots);
+		INIT_LIST_HEAD(&b->resources);
 		b->max_bus_speed = PCI_SPEED_UNKNOWN;
 		b->cur_bus_speed = PCI_SPEED_UNKNOWN;
 	}
@@ -573,6 +577,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 {
 	struct pci_bus *child;
 	int i;
+	struct resource *res;
 
 	/*
 	 * Allocate a new bus, and inherit stuff from the parent..
@@ -611,9 +616,11 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 
 	/* Set up default resource pointers and names.. */
 	for (i = 0; i < PCI_BRIDGE_RESOURCE_NUM; i++) {
-		child->resource[i] = &bridge->resource[PCI_BRIDGE_RESOURCES+i];
-		child->resource[i]->name = child->name;
+		res = &bridge->resource[PCI_BRIDGE_RESOURCES + i];
+		res->name = child->name;
+		pci_bus_add_resource(child, res, PCI_POSITIVE_DECODE);
 	}
+
 	bridge->subordinate = child;
 
 	return child;
@@ -1449,8 +1456,8 @@ struct pci_bus * pci_create_bus(struct device *parent,
 	pci_create_legacy_files(b);
 
 	b->number = b->secondary = bus;
-	b->resource[0] = &ioport_resource;
-	b->resource[1] = &iomem_resource;
+	pci_bus_add_resource(b, &ioport_resource, 0);
+	pci_bus_add_resource(b, &iomem_resource, 0);
 
 	return b;
 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 743ed8c..8a3b512 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -138,58 +138,53 @@ static void pbus_assign_resources_sorted(const struct pci_bus *bus,
 	__assign_resources_sorted(&head, fail_head);
 }
 
-void pci_setup_cardbus(struct pci_bus *bus)
+static void pci_setup_cardbus_window(struct pci_dev *bridge, char *type, int n,
+		struct resource *res, int base_reg, int limit_reg)
 {
-	struct pci_dev *bridge = bus->self;
-	struct resource *res;
 	struct pci_bus_region region;
+	u32 base, limit;
 
-	dev_info(&bridge->dev, "CardBus bridge to [bus %02x-%02x]\n",
-		 bus->secondary, bus->subordinate);
-
-	res = bus->resource[0];
-	pcibios_resource_to_bus(bridge, &region, res);
-	if (res->flags & IORESOURCE_IO) {
+	if (!res) {
 		/*
-		 * The IO resource is allocated a range twice as large as it
-		 * would normally need.  This allows us to set both IO regs.
+		 * Maybe we should disable the window, but the previous
+		 * code left it alone.
 		 */
-		dev_info(&bridge->dev, "  bridge window %pR\n", res);
-		pci_write_config_dword(bridge, PCI_CB_IO_BASE_0,
-					region.start);
-		pci_write_config_dword(bridge, PCI_CB_IO_LIMIT_0,
-					region.end);
+		pci_read_config_dword(bridge, base_reg, &base);
+		pci_read_config_dword(bridge, limit_reg, &limit);
+		dev_info(&bridge->dev, "  no %s%d resource, leaving bridge programmed with base %#08x limit %#08x\n",
+			 type, n, base, limit);
+		return;
 	}
 
-	res = bus->resource[1];
 	pcibios_resource_to_bus(bridge, &region, res);
-	if (res->flags & IORESOURCE_IO) {
-		dev_info(&bridge->dev, "  bridge window %pR\n", res);
-		pci_write_config_dword(bridge, PCI_CB_IO_BASE_1,
-					region.start);
-		pci_write_config_dword(bridge, PCI_CB_IO_LIMIT_1,
-					region.end);
-	}
+	pci_write_config_dword(bridge, base_reg, region.start);
+	pci_write_config_dword(bridge, limit_reg, region.end);
+	dev_info(&bridge->dev, "  bridge window %pR\n", res);
+}
 
-	res = bus->resource[2];
-	pcibios_resource_to_bus(bridge, &region, res);
-	if (res->flags & IORESOURCE_MEM) {
-		dev_info(&bridge->dev, "  bridge window %pR\n", res);
-		pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_0,
-					region.start);
-		pci_write_config_dword(bridge, PCI_CB_MEMORY_LIMIT_0,
-					region.end);
-	}
+void pci_setup_cardbus(struct pci_bus *bus)
+{
+	struct pci_dev *bridge = bus->self;
 
-	res = bus->resource[3];
-	pcibios_resource_to_bus(bridge, &region, res);
-	if (res->flags & IORESOURCE_MEM) {
-		dev_info(&bridge->dev, "  bridge window %pR\n", res);
-		pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_1,
-					region.start);
-		pci_write_config_dword(bridge, PCI_CB_MEMORY_LIMIT_1,
-					region.end);
-	}
+	dev_info(&bridge->dev, "CardBus bridge to [bus %02x-%02x]\n",
+		 bus->secondary, bus->subordinate);
+
+	/*
+	 * The IO resource is allocated a range twice as large as it
+	 * would normally need.  This allows us to set both IO regs.
+	 */
+	pci_setup_cardbus_window(bridge, "io", 0,
+		pci_bus_get_resource(bus, IORESOURCE_IO, 0),
+		PCI_CB_IO_BASE_0, PCI_CB_IO_LIMIT_0);
+	pci_setup_cardbus_window(bridge, "io", 1,
+		pci_bus_get_resource(bus, IORESOURCE_IO, 1),
+		PCI_CB_IO_BASE_1, PCI_CB_IO_LIMIT_1);
+	pci_setup_cardbus_window(bridge, "mem", 0,
+		pci_bus_get_resource(bus, IORESOURCE_MEM, 0),
+		PCI_CB_MEMORY_BASE_0, PCI_CB_MEMORY_LIMIT_0);
+	pci_setup_cardbus_window(bridge, "mem", 1,
+		pci_bus_get_resource(bus, IORESOURCE_MEM, 1),
+		PCI_CB_MEMORY_BASE_1, PCI_CB_MEMORY_LIMIT_1);
 }
 EXPORT_SYMBOL(pci_setup_cardbus);
 
@@ -212,9 +207,9 @@ static void pci_setup_bridge_io(struct pci_bus *bus)
 	u32 l, io_upper16;
 
 	/* Set up the top and bottom of the PCI I/O segment for this bus. */
-	res = bus->resource[0];
-	pcibios_resource_to_bus(bridge, &region, res);
-	if (res->flags & IORESOURCE_IO) {
+	res = pci_bus_get_resource(bus, IORESOURCE_IO, 0);
+	if (res) {
+		pcibios_resource_to_bus(bridge, &region, res);
 		pci_read_config_dword(bridge, PCI_IO_BASE, &l);
 		l &= 0xffff0000;
 		l |= (region.start >> 8) & 0x00f0;
@@ -244,9 +239,9 @@ static void pci_setup_bridge_mmio(struct pci_bus *bus)
 	u32 l;
 
 	/* Set up the top and bottom of the PCI Memory segment for this bus. */
-	res = bus->resource[1];
-	pcibios_resource_to_bus(bridge, &region, res);
-	if (res->flags & IORESOURCE_MEM) {
+	res = pci_bus_get_resource(bus, IORESOURCE_MEM, 0);
+	if (res) {
+		pcibios_resource_to_bus(bridge, &region, res);
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
 		dev_info(&bridge->dev, "  bridge window %pR\n", res);
@@ -271,9 +266,9 @@ static void pci_setup_bridge_mmio_pref(struct pci_bus *bus)
 
 	/* Set up PREF base/limit. */
 	bu = lu = 0;
-	res = bus->resource[2];
-	pcibios_resource_to_bus(bridge, &region, res);
-	if (res->flags & IORESOURCE_PREFETCH) {
+	res = pci_bus_get_resource(bus, IORESOURCE_MEM | IORESOURCE_PREFETCH, 0);
+	if (res) {
+		pcibios_resource_to_bus(bridge, &region, res);
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
 		if (res->flags & IORESOURCE_MEM_64) {
@@ -382,13 +377,13 @@ static void pci_bridge_check_ranges(struct pci_bus *bus)
    have non-NULL parent resource). */
 static struct resource *find_free_bus_resource(struct pci_bus *bus, unsigned long type)
 {
-	int i;
+	struct pci_bus_resource *bus_res;
 	struct resource *r;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 
-	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
-		r = bus->resource[i];
+	list_for_each_entry(bus_res, &bus->resources, list) {
+		r = bus_res->res;
 		if (r == &ioport_resource || r == &iomem_resource)
 			continue;
 		if (r && (r->flags & type_mask) == type && !r->parent)
@@ -803,15 +798,15 @@ static void __ref pci_bus_release_bridge_resources(struct pci_bus *bus,
 
 static void pci_bus_dump_res(struct pci_bus *bus)
 {
-        int i;
+	struct pci_bus_resource *bus_res;
 
-        for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
-                struct resource *res = bus->resource[i];
+	list_for_each_entry(bus_res, &bus->resources, list) {
+		struct resource *res = bus_res->res;
 
 		if (!res || !res->end || !res->flags)
                         continue;
 
-		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %pR\n", i, res);
+		dev_printk(KERN_DEBUG, &bus->dev, "resource %pR\n", res);
         }
 }
 
diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index 45d75dc..cd15c51 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -786,8 +786,9 @@ static int adjust_io(struct pcmcia_socket *s, unsigned int action, unsigned long
 #ifdef CONFIG_PCI
 static int nonstatic_autoadd_resources(struct pcmcia_socket *s)
 {
+	struct pci_bus_resource *bus_res;
 	struct resource *res;
-	int i, done = 0;
+	int done = 0;
 
 	if (!s->cb_dev || !s->cb_dev->bus)
 		return -ENODEV;
@@ -803,8 +804,8 @@ static int nonstatic_autoadd_resources(struct pcmcia_socket *s)
 		return -EINVAL;
 #endif
 
-	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
-		res = s->cb_dev->bus->resource[i];
+	list_for_each_entry(bus_res, &s->cb_dev->bus->resources, list) {
+		res = bus_res->res;
 		if (!res)
 			continue;
 
diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index e4d12ac..9c5a80e 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -649,9 +649,10 @@ static int yenta_search_one_res(struct resource *root, struct resource *res,
 static int yenta_search_res(struct yenta_socket *socket, struct resource *res,
 			    u32 min)
 {
-	int i;
-	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
-		struct resource *root = socket->dev->bus->resource[i];
+	struct pci_bus_resource *bus_res;
+
+	list_for_each_entry(bus_res, &socket->dev->bus->resources, list) {
+		struct resource *root = bus_res->res;
 		if (!root)
 			continue;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index df2a12f..44e2f0e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -363,9 +363,13 @@ static inline void pci_add_saved_cap(struct pci_dev *pci_dev,
 	hlist_add_head(&new_cap->next, &pci_dev->saved_cap_space);
 }
 
-#ifndef PCI_BUS_NUM_RESOURCES
-#define PCI_BUS_NUM_RESOURCES	16
-#endif
+#define PCI_POSITIVE_DECODE	1
+
+struct pci_bus_resource {
+	struct list_head list;
+	struct resource *res;
+	unsigned int flags;
+};
 
 #define PCI_REGION_FLAG_MASK	0x0fU	/* These bits of resource flags tell us the PCI region flags */
 
@@ -376,8 +380,7 @@ struct pci_bus {
 	struct list_head devices;	/* list of devices on this bus */
 	struct pci_dev	*self;		/* bridge device as seen by parent */
 	struct list_head slots;		/* list of slots on this bus */
-	struct resource	*resource[PCI_BUS_NUM_RESOURCES];
-					/* address space routed to this bus */
+	struct list_head resources;	/* address space routed to this bus */
 
 	struct pci_ops	*ops;		/* configuration access functions */
 	void		*sysdata;	/* hook for sys-specific extension */
@@ -828,6 +831,9 @@ int pci_request_selected_regions_exclusive(struct pci_dev *, int, const char *);
 void pci_release_selected_regions(struct pci_dev *, int);
 
 /* drivers/pci/bus.c */
+void pci_bus_add_resource(struct pci_bus *bus, struct resource *res, unsigned int flags);
+struct resource *pci_bus_get_resource(struct pci_bus *bus, unsigned long flags, int num);
+void pci_bus_remove_resources(struct pci_bus *bus);
 int __must_check pci_bus_alloc_resource(struct pci_bus *bus,
 			struct resource *res, resource_size_t size,
 			resource_size_t align, resource_size_t min,

