Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab0BQUU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:20:59 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:43632 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab0BQUUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:20:04 -0500
Subject: [PATCH v4 3/5] PCI: add pci_bus_for_each_resource(),
	remove direct bus->resource[] refs
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
Date: Wed, 17 Feb 2010 13:20:03 -0700
Message-ID: <20100217202003.4013.89942.stgit@bob.kio>
In-Reply-To: <20100217201654.4013.70201.stgit@bob.kio>
References: <20100217201654.4013.70201.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No functional change; this converts loops that iterate from 0 to
PCI_BUS_NUM_RESOURCES through pci_bus resource[] table to use the
pci_bus_for_each_resource() iterator instead.

This doesn't change the way resources are stored; it merely removes
dependencies on the fact that they're in a table.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/ia64/pci/pci.c                  |    5 ++---
 arch/mn10300/unit-asb2305/pci.c      |    6 ++----
 arch/powerpc/kernel/pci-common.c     |   11 ++++-------
 arch/powerpc/platforms/fsl_uli1575.c |   12 ++++++------
 drivers/pci/bus.c                    |    4 ++--
 drivers/pci/hotplug/shpchp_sysfs.c   |    9 +++------
 drivers/pci/pci.c                    |    5 ++---
 drivers/pci/setup-bus.c              |   10 ++++------
 drivers/pcmcia/rsrc_nonstatic.c      |    3 +--
 drivers/pcmcia/yenta_socket.c        |    5 +++--
 include/linux/pci.h                  |    3 +++
 11 files changed, 32 insertions(+), 41 deletions(-)


diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 783c83b..89f957c 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -452,13 +452,12 @@ EXPORT_SYMBOL(pcibios_bus_to_resource);
 static int __devinit is_valid_resource(struct pci_dev *dev, int idx)
 {
 	unsigned int i, type_mask = IORESOURCE_IO | IORESOURCE_MEM;
-	struct resource *devr = &dev->resource[idx];
+	struct resource *devr = &dev->resource[idx], *busr;
 
 	if (!dev->bus)
 		return 0;
-	for (i=0; i<PCI_BUS_NUM_RESOURCES; i++) {
-		struct resource *busr = dev->bus->resource[i];
 
+	pci_bus_for_each_resource(dev->bus, busr, i) {
 		if (!busr || ((busr->flags ^ devr->flags) & type_mask))
 			continue;
 		if ((devr->start) && (devr->start >= busr->start) &&
diff --git a/arch/mn10300/unit-asb2305/pci.c b/arch/mn10300/unit-asb2305/pci.c
index 2cb7e75..6d8720a 100644
--- a/arch/mn10300/unit-asb2305/pci.c
+++ b/arch/mn10300/unit-asb2305/pci.c
@@ -331,12 +331,10 @@ static int __init pci_check_direct(void)
 static int __devinit is_valid_resource(struct pci_dev *dev, int idx)
 {
 	unsigned int i, type_mask = IORESOURCE_IO | IORESOURCE_MEM;
-	struct resource *devr = &dev->resource[idx];
+	struct resource *devr = &dev->resource[idx], *busr;
 
 	if (dev->bus) {
-		for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
-			struct resource *busr = dev->bus->resource[i];
-
+		pci_bus_for_each_resource(dev->bus, busr, i) {
 			if (!busr || (busr->flags ^ devr->flags) & type_mask)
 				continue;
 
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index e640810..2597f95 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1047,10 +1047,8 @@ static void __devinit pcibios_fixup_bridge(struct pci_bus *bus)
 
 	struct pci_dev *dev = bus->self;
 
-	for (i = 0; i < PCI_BUS_NUM_RESOURCES; ++i) {
-		if ((res = bus->resource[i]) == NULL)
-			continue;
-		if (!res->flags)
+	pci_bus_for_each_resource(bus, res, i) {
+		if (!res || !res->flags)
 			continue;
 		if (i >= 3 && bus->self->transparent)
 			continue;
@@ -1277,9 +1275,8 @@ void pcibios_allocate_bus_resources(struct pci_bus *bus)
 	pr_debug("PCI: Allocating bus resources for %04x:%02x...\n",
 		 pci_domain_nr(bus), bus->number);
 
-	for (i = 0; i < PCI_BUS_NUM_RESOURCES; ++i) {
-		if ((res = bus->resource[i]) == NULL || !res->flags
-		    || res->start > res->end || res->parent)
+	pci_bus_for_each_resource(bus, res, i) {
+		if (!res || !res->flags || res->start > res->end || res->parent)
 			continue;
 		if (bus->parent == NULL)
 			pr = (res->flags & IORESOURCE_IO) ?
diff --git a/arch/powerpc/platforms/fsl_uli1575.c b/arch/powerpc/platforms/fsl_uli1575.c
index fd23a1d..8b0c208 100644
--- a/arch/powerpc/platforms/fsl_uli1575.c
+++ b/arch/powerpc/platforms/fsl_uli1575.c
@@ -222,6 +222,7 @@ static void __devinit quirk_final_uli5249(struct pci_dev *dev)
 	int i;
 	u8 *dummy;
 	struct pci_bus *bus = dev->bus;
+	struct resource *res;
 	resource_size_t end = 0;
 
 	for (i = PCI_BRIDGE_RESOURCES; i < PCI_BRIDGE_RESOURCES+3; i++) {
@@ -230,13 +231,12 @@ static void __devinit quirk_final_uli5249(struct pci_dev *dev)
 			end = pci_resource_end(dev, i);
 	}
 
-	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
-		if ((bus->resource[i]) &&
-			(bus->resource[i]->flags & IORESOURCE_MEM)) {
-			if (bus->resource[i]->end == end)
-				dummy = ioremap(bus->resource[i]->start, 0x4);
+	pci_bus_for_each_resource(bus, res, i) {
+		if (res && res->flags & IORESOURCE_MEM) {
+			if (res->end == end)
+				dummy = ioremap(res->start, 0x4);
 			else
-				dummy = ioremap(bus->resource[i]->end - 3, 0x4);
+				dummy = ioremap(res->end - 3, 0x4);
 			if (dummy) {
 				in_8(dummy);
 				iounmap(dummy);
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index a26135b..e75d219 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -43,6 +43,7 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 		void *alignf_data)
 {
 	int i, ret = -ENOMEM;
+	struct resource *r;
 	resource_size_t max = -1;
 
 	type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
@@ -51,8 +52,7 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 	if (!(res->flags & IORESOURCE_MEM_64))
 		max = PCIBIOS_MAX_MEM_32;
 
-	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
-		struct resource *r = bus->resource[i];
+	pci_bus_for_each_resource(bus, r, i) {
 		if (!r)
 			continue;
 
diff --git a/drivers/pci/hotplug/shpchp_sysfs.c b/drivers/pci/hotplug/shpchp_sysfs.c
index 29fa9d2..071b7dc 100644
--- a/drivers/pci/hotplug/shpchp_sysfs.c
+++ b/drivers/pci/hotplug/shpchp_sysfs.c
@@ -47,8 +47,7 @@ static ssize_t show_ctrl (struct device *dev, struct device_attribute *attr, cha
 	bus = pdev->subordinate;
 
 	out += sprintf(buf, "Free resources: memory\n");
-	for (index = 0; index < PCI_BUS_NUM_RESOURCES; index++) {
-		res = bus->resource[index];
+	pci_bus_for_each_resource(bus, res, index) {
 		if (res && (res->flags & IORESOURCE_MEM) &&
 				!(res->flags & IORESOURCE_PREFETCH)) {
 			out += sprintf(out, "start = %8.8llx, "
@@ -58,8 +57,7 @@ static ssize_t show_ctrl (struct device *dev, struct device_attribute *attr, cha
 		}
 	}
 	out += sprintf(out, "Free resources: prefetchable memory\n");
-	for (index = 0; index < PCI_BUS_NUM_RESOURCES; index++) {
-		res = bus->resource[index];
+	pci_bus_for_each_resource(bus, res, index) {
 		if (res && (res->flags & IORESOURCE_MEM) &&
 			       (res->flags & IORESOURCE_PREFETCH)) {
 			out += sprintf(out, "start = %8.8llx, "
@@ -69,8 +67,7 @@ static ssize_t show_ctrl (struct device *dev, struct device_attribute *attr, cha
 		}
 	}
 	out += sprintf(out, "Free resources: IO\n");
-	for (index = 0; index < PCI_BUS_NUM_RESOURCES; index++) {
-		res = bus->resource[index];
+	pci_bus_for_each_resource(bus, res, index) {
 		if (res && (res->flags & IORESOURCE_IO)) {
 			out += sprintf(out, "start = %8.8llx, "
 					"length = %8.8llx\n",
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d62a5de..f4a2738 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -386,10 +386,9 @@ pci_find_parent_resource(const struct pci_dev *dev, struct resource *res)
 {
 	const struct pci_bus *bus = dev->bus;
 	int i;
-	struct resource *best = NULL;
+	struct resource *best = NULL, *r;
 
-	for(i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
-		struct resource *r = bus->resource[i];
+	pci_bus_for_each_resource(bus, r, i) {
 		if (!r)
 			continue;
 		if (res->start && !(res->start >= r->start && res->end <= r->end))
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 743ed8c..bf32f07 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -387,8 +387,7 @@ static struct resource *find_free_bus_resource(struct pci_bus *bus, unsigned lon
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 
-	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
-		r = bus->resource[i];
+	pci_bus_for_each_resource(bus, r, i) {
 		if (r == &ioport_resource || r == &iomem_resource)
 			continue;
 		if (r && (r->flags & type_mask) == type && !r->parent)
@@ -803,11 +802,10 @@ static void __ref pci_bus_release_bridge_resources(struct pci_bus *bus,
 
 static void pci_bus_dump_res(struct pci_bus *bus)
 {
-        int i;
-
-        for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
-                struct resource *res = bus->resource[i];
+	struct resource *res;
+	int i;
 
+	pci_bus_for_each_resource(bus, res, i) {
 		if (!res || !res->end || !res->flags)
                         continue;
 
diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index 45d75dc..c67638f 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -803,8 +803,7 @@ static int nonstatic_autoadd_resources(struct pcmcia_socket *s)
 		return -EINVAL;
 #endif
 
-	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
-		res = s->cb_dev->bus->resource[i];
+	pci_bus_for_each_resource(s->cb_dev->bus, res, i) {
 		if (!res)
 			continue;
 
diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index e4d12ac..1f2039d 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -649,9 +649,10 @@ static int yenta_search_one_res(struct resource *root, struct resource *res,
 static int yenta_search_res(struct yenta_socket *socket, struct resource *res,
 			    u32 min)
 {
+	struct resource *root;
 	int i;
-	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
-		struct resource *root = socket->dev->bus->resource[i];
+
+	pci_bus_for_each_resource(socket->dev->bus, root, i) {
 		if (!root)
 			continue;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index df2a12f..8891d3b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -828,6 +828,9 @@ int pci_request_selected_regions_exclusive(struct pci_dev *, int, const char *);
 void pci_release_selected_regions(struct pci_dev *, int);
 
 /* drivers/pci/bus.c */
+#define pci_bus_for_each_resource(bus, res, i)				\
+	for (i = 0; res = bus->resource[i], i < PCI_BUS_NUM_RESOURCES; i++)
+
 int __must_check pci_bus_alloc_resource(struct pci_bus *bus,
 			struct resource *res, resource_size_t size,
 			resource_size_t align, resource_size_t min,

