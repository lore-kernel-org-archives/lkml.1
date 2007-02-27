Return-Path: <linux-kernel-owner+w=401wt.eu-S1161081AbXB0J0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161081AbXB0J0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 04:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161086AbXB0J0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 04:26:51 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:50667 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161081AbXB0J0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 04:26:49 -0500
Date: Tue, 27 Feb 2007 10:27:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH,RFC] pci: do not mark exported functions as __devinit
Message-ID: <20070227092702.GA21337@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Functions marked __devinit will be removed after kernel init.
But being exported they are potentially called by a module
much later.
So the safer choice seems to be to keep the function even
in the non CONFIG_HOTPLUG case.

This silence the follwoing section mismatch warnings:
WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pci_bus_add_device from __ksymtab_gpl between '__ksymtab_pci_bus_add_device' (at offset 0x20) and '__ksymtab_pci_walk_bus'
WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pci_create_bus from __ksymtab_gpl between '__ksymtab_pci_create_bus' (at offset 0x40) and '__ksymtab_pci_stop_bus_device'
WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pci_bus_max_busnr from __ksymtab_gpl between '__ksymtab_pci_bus_max_busnr' (at offset 0xc0) and '__ksymtab_pci_assign_resource_fixed'
WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pci_claim_resource from __ksymtab_gpl between '__ksymtab_pci_claim_resource' (at offset 0xe0) and '__ksymtab_pcie_port_bus_type'
WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pci_bus_add_devices from __ksymtab between '__ksymtab_pci_bus_add_devices' (at offset 0x70) and '__ksymtab_pci_bus_alloc_resource'
WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pci_scan_bus_parented from __ksymtab between '__ksymtab_pci_scan_bus_parented' (at offset 0x90) and '__ksymtab_pci_root_buses'
WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pci_bus_assign_resources from __ksymtab between '__ksymtab_pci_bus_assign_resources' (at offset 0x4d0) and '__ksymtab_pci_bus_size_bridges'
WARNING: drivers/built-in.o - Section mismatch: reference to .init.text:pci_bus_size_bridges from __ksymtab between '__ksymtab_pci_bus_size_bridges' (at offset 0x4e0) and '__ksymtab_pci_setup_cardbus'

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
Is this the correct approach or do we allow __init symbols to be
exported? In that case we need to find a way to export them without
causing a section mismatch warning.

To catch the warnings you need to run modpost manually (until I have
a pending kbuild fix merged):
scripts/mod/modpost drivers/pci/built-in.o

	Sam


diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index aadaa3c..9e5ea07 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -77,7 +77,7 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
  * This adds a single pci device to the global
  * device list and adds sysfs and procfs entries
  */
-int __devinit pci_bus_add_device(struct pci_dev *dev)
+int pci_bus_add_device(struct pci_dev *dev)
 {
 	int retval;
 	retval = device_add(&dev->dev);
@@ -105,7 +105,7 @@ int __devinit pci_bus_add_device(struct pci_dev *dev)
  *
  * Call hotplug for each new devices.
  */
-void __devinit pci_bus_add_devices(struct pci_bus *bus)
+void pci_bus_add_devices(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
 	int retval;
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 1e74e1e..f5e19e4 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -34,8 +34,7 @@ unsigned long pci_cardbus_mem_size = DEFAULT_CARDBUS_MEM_SIZE;
  * Given a PCI bus, returns the highest PCI bus number present in the set
  * including the given PCI bus and its list of child PCI buses.
  */
-unsigned char __devinit
-pci_bus_max_busnr(struct pci_bus* bus)
+unsigned char pci_bus_max_busnr(struct pci_bus* bus)
 {
 	struct list_head *tmp;
 	unsigned char max, n;
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 2fe1d69..629edf3 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -364,7 +364,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 	}
 }
 
-static struct pci_bus * __devinit pci_alloc_bus(void)
+static struct pci_bus * pci_alloc_bus(void)
 {
 	struct pci_bus *b;
 
@@ -432,7 +432,7 @@ error_register:
 	return NULL;
 }
 
-struct pci_bus * __devinit pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev, int busnr)
+struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev, int busnr)
 {
 	struct pci_bus *child;
 
@@ -461,7 +461,7 @@ static void pci_enable_crs(struct pci_dev *dev)
 	pci_write_config_word(dev, rpcap + PCI_EXP_RTCTL, rpctl);
 }
 
-static void __devinit pci_fixup_parent_subordinate_busnr(struct pci_bus *child, int max)
+static void pci_fixup_parent_subordinate_busnr(struct pci_bus *child, int max)
 {
 	struct pci_bus *parent = child->parent;
 
@@ -477,7 +477,7 @@ static void __devinit pci_fixup_parent_subordinate_busnr(struct pci_bus *child,
 	}
 }
 
-unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus);
+unsigned int pci_scan_child_bus(struct pci_bus *bus);
 
 /*
  * If it's a bridge, configure it and scan the bus behind it.
@@ -489,7 +489,7 @@ unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus);
  * them, we proceed to assigning numbers to the remaining buses in
  * order to avoid overlaps between old and new bus numbers.
  */
-int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev * dev, int max, int pass)
+int pci_scan_bridge(struct pci_bus *bus, struct pci_dev * dev, int max, int pass)
 {
 	struct pci_bus *child;
 	int is_cardbus = (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS);
@@ -912,7 +912,7 @@ pci_scan_device(struct pci_bus *bus, int devfn)
 	return dev;
 }
 
-void __devinit pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
+void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 {
 	device_initialize(&dev->dev);
 	dev->dev.release = pci_release_dev;
@@ -935,8 +935,7 @@ void __devinit pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 	up_write(&pci_bus_sem);
 }
 
-struct pci_dev * __devinit
-pci_scan_single_device(struct pci_bus *bus, int devfn)
+struct pci_dev *pci_scan_single_device(struct pci_bus *bus, int devfn)
 {
 	struct pci_dev *dev;
 
@@ -958,7 +957,7 @@ pci_scan_single_device(struct pci_bus *bus, int devfn)
  * discovered devices to the @bus->devices list.  New devices
  * will have an empty dev->global_list head.
  */
-int __devinit pci_scan_slot(struct pci_bus *bus, int devfn)
+int pci_scan_slot(struct pci_bus *bus, int devfn)
 {
 	int func, nr = 0;
 	int scan_all_fns;
@@ -991,7 +990,7 @@ int __devinit pci_scan_slot(struct pci_bus *bus, int devfn)
 	return nr;
 }
 
-unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
+unsigned int pci_scan_child_bus(struct pci_bus *bus)
 {
 	unsigned int devfn, pass, max = bus->secondary;
 	struct pci_dev *dev;
@@ -1041,7 +1040,7 @@ unsigned int __devinit pci_do_scan_bus(struct pci_bus *bus)
 	return max;
 }
 
-struct pci_bus * __devinit pci_create_bus(struct device *parent,
+struct pci_bus * pci_create_bus(struct device *parent,
 		int bus, struct pci_ops *ops, void *sysdata)
 {
 	int error;
@@ -1119,7 +1118,7 @@ err_out:
 }
 EXPORT_SYMBOL_GPL(pci_create_bus);
 
-struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
+struct pci_bus *pci_scan_bus_parented(struct device *parent,
 		int bus, struct pci_ops *ops, void *sysdata)
 {
 	struct pci_bus *b;
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index ff98ead..4b894ed 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -15,8 +15,7 @@
 
 DECLARE_RWSEM(pci_bus_sem);
 
-static struct pci_bus * __devinit
-pci_do_find_bus(struct pci_bus* bus, unsigned char busnr)
+static struct pci_bus *pci_do_find_bus(struct pci_bus* bus, unsigned char busnr)
 {
 	struct pci_bus* child;
 	struct list_head *tmp;
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 3554f39..5ec297d 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -36,8 +36,7 @@
 
 #define ROUND_UP(x, a)		(((x) + (a) - 1) & ~((a) - 1))
 
-static void __devinit
-pbus_assign_resources_sorted(struct pci_bus *bus)
+static void pbus_assign_resources_sorted(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
 	struct resource *res;
@@ -220,8 +219,7 @@ pci_setup_bridge(struct pci_bus *bus)
 /* Check whether the bridge supports optional I/O and
    prefetchable memory ranges. If not, the respective
    base/limit registers must be read-only and read as 0. */
-static void __devinit
-pci_bridge_check_ranges(struct pci_bus *bus)
+static void pci_bridge_check_ranges(struct pci_bus *bus)
 {
 	u16 io;
 	u32 pmem;
@@ -259,8 +257,7 @@ pci_bridge_check_ranges(struct pci_bus *bus)
    bus resource of a given type. Note: we intentionally skip
    the bus resources which have already been assigned (that is,
    have non-NULL parent resource). */
-static struct resource * __devinit
-find_free_bus_resource(struct pci_bus *bus, unsigned long type)
+static struct resource *find_free_bus_resource(struct pci_bus *bus, unsigned long type)
 {
 	int i;
 	struct resource *r;
@@ -281,8 +278,7 @@ find_free_bus_resource(struct pci_bus *bus, unsigned long type)
    since these windows have 4K granularity and the IO ranges
    of non-bridge PCI devices are limited to 256 bytes.
    We must be careful with the ISA aliasing though. */
-static void __devinit
-pbus_size_io(struct pci_bus *bus)
+static void pbus_size_io(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
 	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
@@ -326,8 +322,7 @@ pbus_size_io(struct pci_bus *bus)
 
 /* Calculate the size of the bus and minimal alignment which
    guarantees that all child resources fit in this size. */
-static int __devinit
-pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long type)
+static int pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long type)
 {
 	struct pci_dev *dev;
 	unsigned long min_align, align, size;
@@ -447,8 +442,7 @@ pci_bus_size_cardbus(struct pci_bus *bus)
 	}
 }
 
-void __devinit
-pci_bus_size_bridges(struct pci_bus *bus)
+void pci_bus_size_bridges(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
 	unsigned long mask, prefmask;
@@ -498,8 +492,7 @@ pci_bus_size_bridges(struct pci_bus *bus)
 }
 EXPORT_SYMBOL(pci_bus_size_bridges);
 
-void __devinit
-pci_bus_assign_resources(struct pci_bus *bus)
+void pci_bus_assign_resources(struct pci_bus *bus)
 {
 	struct pci_bus *b;
 	struct pci_dev *dev;
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index cb4ced3..6dfd861 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -101,8 +101,7 @@ pci_update_resource(struct pci_dev *dev, struct resource *res, int resno)
 		new & ~PCI_REGION_FLAG_MASK);
 }
 
-int __devinit
-pci_claim_resource(struct pci_dev *dev, int resource)
+int pci_claim_resource(struct pci_dev *dev, int resource)
 {
 	struct resource *res = &dev->resource[resource];
 	struct resource *root = NULL;
@@ -212,8 +211,7 @@ EXPORT_SYMBOL_GPL(pci_assign_resource_fixed);
 #endif
 
 /* Sort resources by alignment */
-void __devinit
-pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
+void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 {
 	int i;
 
