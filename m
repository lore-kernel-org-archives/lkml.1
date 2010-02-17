Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab0BQUUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:20:16 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:43778 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab0BQUUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:20:09 -0500
Subject: [PATCH v4 4/5] PCI: augment bus resource table with a list
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
       Peter Haight <peterh@sapros.com>, Gary Hade <garyhade@us.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-am33-list@redhat.com, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Date: Wed, 17 Feb 2010 13:20:08 -0700
Message-ID: <20100217202008.4013.56938.stgit@bob.kio>
In-Reply-To: <20100217201654.4013.70201.stgit@bob.kio>
References: <20100217201654.4013.70201.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Previously we used a table of size PCI_BUS_NUM_RESOURCES (16) for resources
forwarded to a bus by its upstream bridge.  We've increased this size
several times when the table overflowed.

But there's no good limit on the number of resources because host bridges
and subtractive decode bridges can forward any number of ranges to their
secondary buses.

This patch reduces the table to only PCI_BRIDGE_RESOURCE_NUM (4) entries,
which corresponds to the number of windows a PCI-to-PCI (3) or CardBus (4)
bridge can positively decode.  Any additional resources, e.g., PCI host
bridge windows or subtractively-decoded regions, are kept in a list.

I'd prefer a single list rather than this split table/list approach, but
that requires simultaneous changes to every architecture.  This approach
only requires immediate changes where we set up (a) host bridges with more
than four windows and (b) subtractive-decode P2P bridges, and we can
incrementally change other architectures to use the list.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/ia64/pci/pci.c     |   12 +++---------
 arch/x86/pci/acpi.c     |   33 ++++-----------------------------
 arch/x86/pci/bus_numa.c |    3 ++-
 arch/x86/pci/bus_numa.h |    3 +--
 drivers/pci/bus.c       |   45 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/probe.c     |   17 +++++++++++++----
 include/linux/pci.h     |   35 +++++++++++++++++++++++++++++------
 7 files changed, 97 insertions(+), 51 deletions(-)


diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 89f957c..64aff52 100644
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
index f939d60..12d54ff 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -36,13 +36,14 @@ void x86_pci_root_bus_res_quirks(struct pci_bus *b)
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
diff --git a/arch/x86/pci/bus_numa.h b/arch/x86/pci/bus_numa.h
index adbc23f..731b64e 100644
--- a/arch/x86/pci/bus_numa.h
+++ b/arch/x86/pci/bus_numa.h
@@ -2,8 +2,7 @@
 
 /*
  * sub bus (transparent) will use entres from 3 to store extra from
- * root, so need to make sure we have enough slot there, Should we
- * increase PCI_BUS_NUM_RESOURCES?
+ * root, so need to make sure we have enough slot there.
  */
 #define RES_NUM 16
 struct pci_root_info {
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index e75d219..087c732 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -17,6 +17,51 @@
 
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
+struct resource *pci_bus_resource_n(const struct pci_bus *bus, int n)
+{
+	struct pci_bus_resource *bus_res;
+
+	if (n < PCI_BRIDGE_RESOURCE_NUM)
+		return bus->resource[n];
+
+	n -= PCI_BRIDGE_RESOURCE_NUM;
+	list_for_each_entry(bus_res, &bus->resources, list) {
+		if (n-- == 0)
+			return bus_res->res;
+	}
+	return NULL;
+}
+
+void pci_bus_remove_resources(struct pci_bus *bus)
+{
+	struct pci_bus_resource *bus_res, *tmp;
+	int i;
+
+	for (i = 0; i < PCI_BRIDGE_RESOURCE_NUM; i++)
+		bus->resource[i] = 0;
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
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 70c4ed2..270d069 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -89,6 +89,7 @@ static void release_pcibus_dev(struct device *dev)
 
 	if (pci_bus->bridge)
 		put_device(pci_bus->bridge);
+	pci_bus_remove_resources(pci_bus);
 	kfree(pci_bus);
 }
 
@@ -394,6 +395,7 @@ static void __devinit pci_read_bridge_mmio_pref(struct pci_bus *child)
 void __devinit pci_read_bridge_bases(struct pci_bus *child)
 {
 	struct pci_dev *dev = child->self;
+	struct resource *res;
 	int i;
 
 	if (pci_is_root_bus(child))	/* It's a host bus, nothing to read */
@@ -403,17 +405,23 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		 child->secondary, child->subordinate,
 		 dev->transparent ? " (subtractive decode)" : "");
 
+	pci_bus_remove_resources(child);
+	for (i = 0; i < PCI_BRIDGE_RESOURCE_NUM; i++)
+		child->resource[i] = &dev->resource[PCI_BRIDGE_RESOURCES+i];
+
 	pci_read_bridge_io(child);
 	pci_read_bridge_mmio(child);
 	pci_read_bridge_mmio_pref(child);
 
 	if (dev->transparent) {
-		for (i = 3; i < PCI_BUS_NUM_RESOURCES; i++) {
-			child->resource[i] = child->parent->resource[i - 3];
-			if (child->resource[i])
+		pci_bus_for_each_resource(child->parent, res, i) {
+			if (res) {
+				pci_bus_add_resource(child, res,
+						     PCI_SUBTRACTIVE_DECODE);
 				dev_printk(KERN_DEBUG, &dev->dev,
 					   "  bridge window %pR (subtractive decode)\n",
-					   child->resource[i]);
+					   res);
+			}
 		}
 	}
 }
@@ -428,6 +436,7 @@ static struct pci_bus * pci_alloc_bus(void)
 		INIT_LIST_HEAD(&b->children);
 		INIT_LIST_HEAD(&b->devices);
 		INIT_LIST_HEAD(&b->slots);
+		INIT_LIST_HEAD(&b->resources);
 		b->max_bus_speed = PCI_SPEED_UNKNOWN;
 		b->cur_bus_speed = PCI_SPEED_UNKNOWN;
 	}
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8891d3b..2af5eab 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -363,9 +363,26 @@ static inline void pci_add_saved_cap(struct pci_dev *pci_dev,
 	hlist_add_head(&new_cap->next, &pci_dev->saved_cap_space);
 }
 
-#ifndef PCI_BUS_NUM_RESOURCES
-#define PCI_BUS_NUM_RESOURCES	16
-#endif
+/*
+ * The first PCI_BRIDGE_RESOURCE_NUM PCI bus resources (those that correspond
+ * to P2P or CardBus bridge windows) go in a table.  Additional ones (for
+ * buses below host bridges or subtractive decode bridges) go in the list.
+ * Use pci_bus_for_each_resource() to iterate through all the resources.
+ */
+
+/*
+ * PCI_SUBTRACTIVE_DECODE means the bridge forwards the window implicitly
+ * and there's no way to program the bridge with the details of the window.
+ * This does not apply to ACPI _CRS windows, even with the _DEC subtractive-
+ * decode bit set, because they are explicit and can be programmed with _SRS.
+ */
+#define PCI_SUBTRACTIVE_DECODE	0x1
+
+struct pci_bus_resource {
+	struct list_head list;
+	struct resource *res;
+	unsigned int flags;
+};
 
 #define PCI_REGION_FLAG_MASK	0x0fU	/* These bits of resource flags tell us the PCI region flags */
 
@@ -376,8 +393,8 @@ struct pci_bus {
 	struct list_head devices;	/* list of devices on this bus */
 	struct pci_dev	*self;		/* bridge device as seen by parent */
 	struct list_head slots;		/* list of slots on this bus */
-	struct resource	*resource[PCI_BUS_NUM_RESOURCES];
-					/* address space routed to this bus */
+	struct resource *resource[PCI_BRIDGE_RESOURCE_NUM];
+	struct list_head resources;	/* address space routed to this bus */
 
 	struct pci_ops	*ops;		/* configuration access functions */
 	void		*sysdata;	/* hook for sys-specific extension */
@@ -828,8 +845,14 @@ int pci_request_selected_regions_exclusive(struct pci_dev *, int, const char *);
 void pci_release_selected_regions(struct pci_dev *, int);
 
 /* drivers/pci/bus.c */
+void pci_bus_add_resource(struct pci_bus *bus, struct resource *res, unsigned int flags);
+struct resource *pci_bus_resource_n(const struct pci_bus *bus, int n);
+void pci_bus_remove_resources(struct pci_bus *bus);
+
 #define pci_bus_for_each_resource(bus, res, i)				\
-	for (i = 0; res = bus->resource[i], i < PCI_BUS_NUM_RESOURCES; i++)
+	for (i = 0;							\
+	    (res = pci_bus_resource_n(bus, i)) || i < PCI_BRIDGE_RESOURCE_NUM; \
+	     i++)
 
 int __must_check pci_bus_alloc_resource(struct pci_bus *bus,
 			struct resource *res, resource_size_t size,

