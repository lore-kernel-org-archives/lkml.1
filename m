Return-Path: <linux-kernel-owner+w=401wt.eu-S1764339AbYECPWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764339AbYECPWc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 11:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762984AbYECPWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 11:22:00 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54358 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755896AbYECPVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 11:21:46 -0400
From: monstr@seznam.cz
To: paulus@samba.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 2/2] OF: Move of_device.c and of_platform.c to drivers/of/
Date: Sat,  3 May 2008 16:22:12 +0200
Message-Id: <d4e8123f6c2c78c3ae109fd32a9d6c491d6cb4cc.1209824033.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <765c6c8053679c45eb370255a110f7bc680a8f25.1209824033.git.monstr@monstr.eu>
References: <monstr@seznam.cz>
 <1209824532-7939-1-git-send-email-monstr@seznam.cz>
 <765c6c8053679c45eb370255a110f7bc680a8f25.1209824033.git.monstr@monstr.eu>
In-Reply-To: <765c6c8053679c45eb370255a110f7bc680a8f25.1209824033.git.monstr@monstr.eu>
References: <765c6c8053679c45eb370255a110f7bc680a8f25.1209824033.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/powerpc/kernel/Makefile      |    2 +-
 arch/powerpc/kernel/of_device.c   |  190 ----------------------
 arch/powerpc/kernel/of_platform.c |  325 -------------------------------------
 drivers/of/Makefile               |    6 +-
 drivers/of/of_device.c            |  190 ++++++++++++++++++++++
 drivers/of/of_platform.c          |  325 +++++++++++++++++++++++++++++++++++++
 6 files changed, 519 insertions(+), 519 deletions(-)
 delete mode 100644 arch/powerpc/kernel/of_device.c
 delete mode 100644 arch/powerpc/kernel/of_platform.c
 create mode 100644 drivers/of/of_device.c
 create mode 100644 drivers/of/of_platform.c

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index d14cebf..b169b23 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -25,7 +25,7 @@ obj-$(CONFIG_PPC64)		+= setup_64.o sys_ppc32.o \
 obj-$(CONFIG_PPC64)		+= vdso64/
 obj-$(CONFIG_ALTIVEC)		+= vecemu.o vector.o
 obj-$(CONFIG_PPC_970_NAP)	+= idle_power4.o
-obj-$(CONFIG_PPC_OF)		+= of_device.o of_platform.o prom_parse.o
+obj-$(CONFIG_PPC_OF)		+= prom_parse.o
 obj-$(CONFIG_PPC_CLOCK)		+= clock.o
 procfs-$(CONFIG_PPC64)		:= proc_ppc64.o
 obj-$(CONFIG_PROC_FS)		+= $(procfs-y)
diff --git a/arch/powerpc/kernel/of_device.c b/arch/powerpc/kernel/of_device.c
deleted file mode 100644
index db9ed02..0000000
--- a/arch/powerpc/kernel/of_device.c
+++ /dev/null
@@ -1,190 +0,0 @@
-#include <linux/string.h>
-#include <linux/kernel.h>
-#include <linux/of.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mod_devicetable.h>
-#include <linux/slab.h>
-#include <linux/of_device.h>
-
-#include <asm/errno.h>
-
-#ifdef CONFIG_PPC_PSERIES
-#include <asm/dcr.h>
-#endif
-
-static void of_device_make_bus_id(struct of_device *dev)
-{
-	static atomic_t bus_no_reg_magic;
-	struct device_node *node = dev->node;
-	char *name = dev->dev.bus_id;
-	const u32 *reg;
-	u64 addr;
-	int magic;
-
-	/*
-	 * If it's a DCR based device, use 'd' for native DCRs
-	 * and 'D' for MMIO DCRs.
-	 */
-#ifdef CONFIG_PPC_DCR
-	reg = of_get_property(node, "dcr-reg", NULL);
-	if (reg) {
-#ifdef CONFIG_PPC_DCR_NATIVE
-		snprintf(name, BUS_ID_SIZE, "d%x.%s",
-			 *reg, node->name);
-#else /* CONFIG_PPC_DCR_NATIVE */
-		addr = of_translate_dcr_address(node, *reg, NULL);
-		if (addr != OF_BAD_ADDR) {
-			snprintf(name, BUS_ID_SIZE,
-				 "D%llx.%s", (unsigned long long)addr,
-				 node->name);
-			return;
-		}
-#endif /* !CONFIG_PPC_DCR_NATIVE */
-	}
-#endif /* CONFIG_PPC_DCR */
-
-	/*
-	 * For MMIO, get the physical address
-	 */
-	reg = of_get_property(node, "reg", NULL);
-	if (reg) {
-		addr = of_translate_address(node, reg);
-		if (addr != OF_BAD_ADDR) {
-			snprintf(name, BUS_ID_SIZE,
-				 "%llx.%s", (unsigned long long)addr,
-				 node->name);
-			return;
-		}
-	}
-
-	/*
-	 * No BusID, use the node name and add a globally incremented
-	 * counter (and pray...)
-	 */
-	magic = atomic_add_return(1, &bus_no_reg_magic);
-	snprintf(name, BUS_ID_SIZE, "%s.%d", node->name, magic - 1);
-}
-
-struct of_device *of_device_alloc(struct device_node *np,
-				  const char *bus_id,
-				  struct device *parent)
-{
-	struct of_device *dev;
-
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev)
-		return NULL;
-
-	dev->node = of_node_get(np);
-	dev->dev.dma_mask = &dev->dma_mask;
-	dev->dev.parent = parent;
-	dev->dev.release = of_release_dev;
-	dev->dev.archdata.of_node = np;
-	dev->dev.archdata.numa_node = of_node_to_nid(np);
-
-	if (bus_id)
-		strlcpy(dev->dev.bus_id, bus_id, BUS_ID_SIZE);
-	else
-		of_device_make_bus_id(dev);
-
-	return dev;
-}
-EXPORT_SYMBOL(of_device_alloc);
-
-ssize_t of_device_get_modalias(struct of_device *ofdev,
-				char *str, ssize_t len)
-{
-	const char *compat;
-	int cplen, i;
-	ssize_t tsize, csize, repend;
-
-	/* Name & Type */
-	csize = snprintf(str, len, "of:N%sT%s",
-				ofdev->node->name, ofdev->node->type);
-
-	/* Get compatible property if any */
-	compat = of_get_property(ofdev->node, "compatible", &cplen);
-	if (!compat)
-		return csize;
-
-	/* Find true end (we tolerate multiple \0 at the end */
-	for (i = (cplen-1); i >= 0 && !compat[i]; i--)
-		cplen--;
-	if (!cplen)
-		return csize;
-	cplen++;
-
-	/* Check space (need cplen+1 chars including final \0) */
-	tsize = csize + cplen;
-	repend = tsize;
-
-	if (csize >= len)	/* @ the limit, all is already filled */
-		return tsize;
-
-	if (tsize >= len) {	/* limit compat list */
-		cplen = len - csize - 1;
-		repend = len;
-	}
-
-	/* Copy and do char replacement */
-	memcpy(&str[csize+1], compat, cplen);
-	for (i = csize; i < repend; i++) {
-		char c = str[i];
-		if (c == '\0')
-			str[i] = 'C';
-		else if (c == ' ')
-			str[i] = '_';
-	}
-
-	return tsize;
-}
-EXPORT_SYMBOL(of_device_get_modalias);
-
-int of_device_uevent(struct device *dev, struct kobj_uevent_env *env)
-{
-	struct of_device *ofdev;
-	const char *compat;
-	int seen = 0, cplen, sl;
-
-	if (!dev)
-		return -ENODEV;
-
-	ofdev = to_of_device(dev);
-
-	if (add_uevent_var(env, "OF_NAME=%s", ofdev->node->name))
-		return -ENOMEM;
-
-	if (add_uevent_var(env, "OF_TYPE=%s", ofdev->node->type))
-		return -ENOMEM;
-
-	/* Since the compatible field can contain pretty much anything
-	 * it's not really legal to split it out with commas. We split it
-	 * up using a number of environment variables instead. */
-
-	compat = of_get_property(ofdev->node, "compatible", &cplen);
-	while (compat && *compat && cplen > 0) {
-		if (add_uevent_var(env, "OF_COMPATIBLE_%d=%s", seen, compat))
-			return -ENOMEM;
-
-		sl = strlen (compat) + 1;
-		compat += sl;
-		cplen -= sl;
-		seen++;
-	}
-
-	if (add_uevent_var(env, "OF_COMPATIBLE_N=%d", seen))
-		return -ENOMEM;
-
-	/* modalias is trickier, we add it in 2 steps */
-	if (add_uevent_var(env, "MODALIAS="))
-		return -ENOMEM;
-	sl = of_device_get_modalias(ofdev, &env->buf[env->buflen-1],
-				    sizeof(env->buf) - env->buflen);
-	if (sl >= (sizeof(env->buf) - env->buflen))
-		return -ENOMEM;
-	env->buflen += sl;
-
-	return 0;
-}
-EXPORT_SYMBOL(of_device_uevent);
diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
deleted file mode 100644
index cd9336e..0000000
--- a/arch/powerpc/kernel/of_platform.c
+++ /dev/null
@@ -1,325 +0,0 @@
-/*
- *    Copyright (C) 2006 Benjamin Herrenschmidt, IBM Corp.
- *			 <benh@kernel.crashing.org>
- *    and		 Arnd Bergmann, IBM Corp.
- *
- *  This program is free software; you can redistribute it and/or
- *  modify it under the terms of the GNU General Public License
- *  as published by the Free Software Foundation; either version
- *  2 of the License, or (at your option) any later version.
- *
- */
-
-#undef DEBUG
-
-#include <linux/string.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mod_devicetable.h>
-#include <linux/slab.h>
-#include <linux/pci.h>
-#include <linux/of.h>
-#include <linux/of_device.h>
-#include <linux/of_platform.h>
-
-#include <asm/errno.h>
-#include <asm/topology.h>
-#include <asm/pci-bridge.h>
-#include <asm/atomic.h>
-
-#ifdef CONFIG_PPC_PSERIES
-#include <asm/ppc-pci.h>
-#endif
-
-/*
- * The list of OF IDs below is used for matching bus types in the
- * system whose devices are to be exposed as of_platform_devices.
- *
- * This is the default list valid for most platforms. This file provides
- * functions who can take an explicit list if necessary though
- *
- * The search is always performed recursively looking for children of
- * the provided device_node and recursively if such a children matches
- * a bus type in the list
- */
-
-static const struct of_device_id of_default_bus_ids[] = {
-	{ .type = "soc", },
-	{ .compatible = "soc", },
-	{ .type = "spider", },
-	{ .type = "axon", },
-	{ .type = "plb5", },
-	{ .type = "plb4", },
-	{ .type = "opb", },
-	{ .type = "ebc", },
-	{},
-};
-
-struct bus_type of_platform_bus_type = {
-       .uevent	= of_device_uevent,
-};
-EXPORT_SYMBOL(of_platform_bus_type);
-
-static int __init of_bus_driver_init(void)
-{
-	return of_bus_type_init(&of_platform_bus_type, "of_platform");
-}
-
-postcore_initcall(of_bus_driver_init);
-
-struct of_device* of_platform_device_create(struct device_node *np,
-					    const char *bus_id,
-					    struct device *parent)
-{
-	struct of_device *dev;
-
-	dev = of_device_alloc(np, bus_id, parent);
-	if (!dev)
-		return NULL;
-
-	dev->dma_mask = 0xffffffffUL;
-	dev->dev.bus = &of_platform_bus_type;
-
-	/* We do not fill the DMA ops for platform devices by default.
-	 * This is currently the responsibility of the platform code
-	 * to do such, possibly using a device notifier
-	 */
-
-	if (of_device_register(dev) != 0) {
-		of_device_free(dev);
-		return NULL;
-	}
-
-	return dev;
-}
-EXPORT_SYMBOL(of_platform_device_create);
-
-
-
-/**
- * of_platform_bus_create - Create an OF device for a bus node and all its
- * children. Optionally recursively instanciate matching busses.
- * @bus: device node of the bus to instanciate
- * @matches: match table, NULL to use the default, OF_NO_DEEP_PROBE to
- * disallow recursive creation of child busses
- */
-static int of_platform_bus_create(const struct device_node *bus,
-				  const struct of_device_id *matches,
-				  struct device *parent)
-{
-	struct device_node *child;
-	struct of_device *dev;
-	int rc = 0;
-
-	for_each_child_of_node(bus, child) {
-		pr_debug("   create child: %s\n", child->full_name);
-		dev = of_platform_device_create(child, NULL, parent);
-		if (dev == NULL)
-			rc = -ENOMEM;
-		else if (!of_match_node(matches, child))
-			continue;
-		if (rc == 0) {
-			pr_debug("   and sub busses\n");
-			rc = of_platform_bus_create(child, matches, &dev->dev);
-		} if (rc) {
-			of_node_put(child);
-			break;
-		}
-	}
-	return rc;
-}
-
-/**
- * of_platform_bus_probe - Probe the device-tree for platform busses
- * @root: parent of the first level to probe or NULL for the root of the tree
- * @matches: match table, NULL to use the default
- * @parent: parent to hook devices from, NULL for toplevel
- *
- * Note that children of the provided root are not instanciated as devices
- * unless the specified root itself matches the bus list and is not NULL.
- */
-
-int of_platform_bus_probe(struct device_node *root,
-			  const struct of_device_id *matches,
-			  struct device *parent)
-{
-	struct device_node *child;
-	struct of_device *dev;
-	int rc = 0;
-
-	if (matches == NULL)
-		matches = of_default_bus_ids;
-	if (matches == OF_NO_DEEP_PROBE)
-		return -EINVAL;
-	if (root == NULL)
-		root = of_find_node_by_path("/");
-	else
-		of_node_get(root);
-
-	pr_debug("of_platform_bus_probe()\n");
-	pr_debug(" starting at: %s\n", root->full_name);
-
-	/* Do a self check of bus type, if there's a match, create
-	 * children
-	 */
-	if (of_match_node(matches, root)) {
-		pr_debug(" root match, create all sub devices\n");
-		dev = of_platform_device_create(root, NULL, parent);
-		if (dev == NULL) {
-			rc = -ENOMEM;
-			goto bail;
-		}
-		pr_debug(" create all sub busses\n");
-		rc = of_platform_bus_create(root, matches, &dev->dev);
-		goto bail;
-	}
-	for_each_child_of_node(root, child) {
-		if (!of_match_node(matches, child))
-			continue;
-
-		pr_debug("  match: %s\n", child->full_name);
-		dev = of_platform_device_create(child, NULL, parent);
-		if (dev == NULL)
-			rc = -ENOMEM;
-		else
-			rc = of_platform_bus_create(child, matches, &dev->dev);
-		if (rc) {
-			of_node_put(child);
-			break;
-		}
-	}
- bail:
-	of_node_put(root);
-	return rc;
-}
-EXPORT_SYMBOL(of_platform_bus_probe);
-
-static int of_dev_node_match(struct device *dev, void *data)
-{
-	return to_of_device(dev)->node == data;
-}
-
-struct of_device *of_find_device_by_node(struct device_node *np)
-{
-	struct device *dev;
-
-	dev = bus_find_device(&of_platform_bus_type,
-			      NULL, np, of_dev_node_match);
-	if (dev)
-		return to_of_device(dev);
-	return NULL;
-}
-EXPORT_SYMBOL(of_find_device_by_node);
-
-static int of_dev_phandle_match(struct device *dev, void *data)
-{
-	phandle *ph = data;
-	return to_of_device(dev)->node->linux_phandle == *ph;
-}
-
-struct of_device *of_find_device_by_phandle(phandle ph)
-{
-	struct device *dev;
-
-	dev = bus_find_device(&of_platform_bus_type,
-			      NULL, &ph, of_dev_phandle_match);
-	if (dev)
-		return to_of_device(dev);
-	return NULL;
-}
-EXPORT_SYMBOL(of_find_device_by_phandle);
-
-
-#ifdef CONFIG_PPC_OF_PLATFORM_PCI
-
-/* The probing of PCI controllers from of_platform is currently
- * 64 bits only, mostly due to gratuitous differences between
- * the 32 and 64 bits PCI code on PowerPC and the 32 bits one
- * lacking some bits needed here.
- */
-
-static int __devinit of_pci_phb_probe(struct of_device *dev,
-				      const struct of_device_id *match)
-{
-	struct pci_controller *phb;
-
-	/* Check if we can do that ... */
-	if (ppc_md.pci_setup_phb == NULL)
-		return -ENODEV;
-
-	printk(KERN_INFO "Setting up PCI bus %s\n", dev->node->full_name);
-
-	/* Alloc and setup PHB data structure */
-	phb = pcibios_alloc_controller(dev->node);
-	if (!phb)
-		return -ENODEV;
-
-	/* Setup parent in sysfs */
-	phb->parent = &dev->dev;
-
-	/* Setup the PHB using arch provided callback */
-	if (ppc_md.pci_setup_phb(phb)) {
-		pcibios_free_controller(phb);
-		return -ENODEV;
-	}
-
-	/* Process "ranges" property */
-	pci_process_bridge_OF_ranges(phb, dev->node, 0);
-
-	/* Init pci_dn data structures */
-	pci_devs_phb_init_dynamic(phb);
-
-	/* Register devices with EEH */
-#ifdef CONFIG_EEH
-	if (dev->node->child)
-		eeh_add_device_tree_early(dev->node);
-#endif /* CONFIG_EEH */
-
-	/* Scan the bus */
-	scan_phb(phb);
-	if (phb->bus == NULL)
-		return -ENXIO;
-
-	/* Claim resources. This might need some rework as well depending
-	 * wether we are doing probe-only or not, like assigning unassigned
-	 * resources etc...
-	 */
-	pcibios_claim_one_bus(phb->bus);
-
-	/* Finish EEH setup */
-#ifdef CONFIG_EEH
-	eeh_add_device_tree_late(phb->bus);
-#endif
-
-	/* Add probed PCI devices to the device model */
-	pci_bus_add_devices(phb->bus);
-
-	return 0;
-}
-
-static struct of_device_id of_pci_phb_ids[] = {
-	{ .type = "pci", },
-	{ .type = "pcix", },
-	{ .type = "pcie", },
-	{ .type = "pciex", },
-	{ .type = "ht", },
-	{}
-};
-
-static struct of_platform_driver of_pci_phb_driver = {
-	.match_table = of_pci_phb_ids,
-	.probe = of_pci_phb_probe,
-	.driver = {
-		.name = "of-pci",
-	},
-};
-
-static __init int of_pci_phb_init(void)
-{
-	return of_register_platform_driver(&of_pci_phb_driver);
-}
-
-device_initcall(of_pci_phb_init);
-
-#endif /* CONFIG_PPC_OF_PLATFORM_PCI */
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index 548772e..e18eb8a 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -1,4 +1,4 @@
-obj-y = base.o
-obj-$(CONFIG_OF_DEVICE) += device.o platform.o
-obj-$(CONFIG_OF_GPIO)   += gpio.o
+obj-y = base.o of_device.o of_platform.o
+obj-$(CONFIG_OF_DEVICE)	+= device.o platform.o
+obj-$(CONFIG_OF_GPIO)	+= gpio.o
 obj-$(CONFIG_OF_I2C)	+= of_i2c.o
diff --git a/drivers/of/of_device.c b/drivers/of/of_device.c
new file mode 100644
index 0000000..db9ed02
--- /dev/null
+++ b/drivers/of/of_device.c
@@ -0,0 +1,190 @@
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/slab.h>
+#include <linux/of_device.h>
+
+#include <asm/errno.h>
+
+#ifdef CONFIG_PPC_PSERIES
+#include <asm/dcr.h>
+#endif
+
+static void of_device_make_bus_id(struct of_device *dev)
+{
+	static atomic_t bus_no_reg_magic;
+	struct device_node *node = dev->node;
+	char *name = dev->dev.bus_id;
+	const u32 *reg;
+	u64 addr;
+	int magic;
+
+	/*
+	 * If it's a DCR based device, use 'd' for native DCRs
+	 * and 'D' for MMIO DCRs.
+	 */
+#ifdef CONFIG_PPC_DCR
+	reg = of_get_property(node, "dcr-reg", NULL);
+	if (reg) {
+#ifdef CONFIG_PPC_DCR_NATIVE
+		snprintf(name, BUS_ID_SIZE, "d%x.%s",
+			 *reg, node->name);
+#else /* CONFIG_PPC_DCR_NATIVE */
+		addr = of_translate_dcr_address(node, *reg, NULL);
+		if (addr != OF_BAD_ADDR) {
+			snprintf(name, BUS_ID_SIZE,
+				 "D%llx.%s", (unsigned long long)addr,
+				 node->name);
+			return;
+		}
+#endif /* !CONFIG_PPC_DCR_NATIVE */
+	}
+#endif /* CONFIG_PPC_DCR */
+
+	/*
+	 * For MMIO, get the physical address
+	 */
+	reg = of_get_property(node, "reg", NULL);
+	if (reg) {
+		addr = of_translate_address(node, reg);
+		if (addr != OF_BAD_ADDR) {
+			snprintf(name, BUS_ID_SIZE,
+				 "%llx.%s", (unsigned long long)addr,
+				 node->name);
+			return;
+		}
+	}
+
+	/*
+	 * No BusID, use the node name and add a globally incremented
+	 * counter (and pray...)
+	 */
+	magic = atomic_add_return(1, &bus_no_reg_magic);
+	snprintf(name, BUS_ID_SIZE, "%s.%d", node->name, magic - 1);
+}
+
+struct of_device *of_device_alloc(struct device_node *np,
+				  const char *bus_id,
+				  struct device *parent)
+{
+	struct of_device *dev;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+
+	dev->node = of_node_get(np);
+	dev->dev.dma_mask = &dev->dma_mask;
+	dev->dev.parent = parent;
+	dev->dev.release = of_release_dev;
+	dev->dev.archdata.of_node = np;
+	dev->dev.archdata.numa_node = of_node_to_nid(np);
+
+	if (bus_id)
+		strlcpy(dev->dev.bus_id, bus_id, BUS_ID_SIZE);
+	else
+		of_device_make_bus_id(dev);
+
+	return dev;
+}
+EXPORT_SYMBOL(of_device_alloc);
+
+ssize_t of_device_get_modalias(struct of_device *ofdev,
+				char *str, ssize_t len)
+{
+	const char *compat;
+	int cplen, i;
+	ssize_t tsize, csize, repend;
+
+	/* Name & Type */
+	csize = snprintf(str, len, "of:N%sT%s",
+				ofdev->node->name, ofdev->node->type);
+
+	/* Get compatible property if any */
+	compat = of_get_property(ofdev->node, "compatible", &cplen);
+	if (!compat)
+		return csize;
+
+	/* Find true end (we tolerate multiple \0 at the end */
+	for (i = (cplen-1); i >= 0 && !compat[i]; i--)
+		cplen--;
+	if (!cplen)
+		return csize;
+	cplen++;
+
+	/* Check space (need cplen+1 chars including final \0) */
+	tsize = csize + cplen;
+	repend = tsize;
+
+	if (csize >= len)	/* @ the limit, all is already filled */
+		return tsize;
+
+	if (tsize >= len) {	/* limit compat list */
+		cplen = len - csize - 1;
+		repend = len;
+	}
+
+	/* Copy and do char replacement */
+	memcpy(&str[csize+1], compat, cplen);
+	for (i = csize; i < repend; i++) {
+		char c = str[i];
+		if (c == '\0')
+			str[i] = 'C';
+		else if (c == ' ')
+			str[i] = '_';
+	}
+
+	return tsize;
+}
+EXPORT_SYMBOL(of_device_get_modalias);
+
+int of_device_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	struct of_device *ofdev;
+	const char *compat;
+	int seen = 0, cplen, sl;
+
+	if (!dev)
+		return -ENODEV;
+
+	ofdev = to_of_device(dev);
+
+	if (add_uevent_var(env, "OF_NAME=%s", ofdev->node->name))
+		return -ENOMEM;
+
+	if (add_uevent_var(env, "OF_TYPE=%s", ofdev->node->type))
+		return -ENOMEM;
+
+	/* Since the compatible field can contain pretty much anything
+	 * it's not really legal to split it out with commas. We split it
+	 * up using a number of environment variables instead. */
+
+	compat = of_get_property(ofdev->node, "compatible", &cplen);
+	while (compat && *compat && cplen > 0) {
+		if (add_uevent_var(env, "OF_COMPATIBLE_%d=%s", seen, compat))
+			return -ENOMEM;
+
+		sl = strlen (compat) + 1;
+		compat += sl;
+		cplen -= sl;
+		seen++;
+	}
+
+	if (add_uevent_var(env, "OF_COMPATIBLE_N=%d", seen))
+		return -ENOMEM;
+
+	/* modalias is trickier, we add it in 2 steps */
+	if (add_uevent_var(env, "MODALIAS="))
+		return -ENOMEM;
+	sl = of_device_get_modalias(ofdev, &env->buf[env->buflen-1],
+				    sizeof(env->buf) - env->buflen);
+	if (sl >= (sizeof(env->buf) - env->buflen))
+		return -ENOMEM;
+	env->buflen += sl;
+
+	return 0;
+}
+EXPORT_SYMBOL(of_device_uevent);
diff --git a/drivers/of/of_platform.c b/drivers/of/of_platform.c
new file mode 100644
index 0000000..cd9336e
--- /dev/null
+++ b/drivers/of/of_platform.c
@@ -0,0 +1,325 @@
+/*
+ *    Copyright (C) 2006 Benjamin Herrenschmidt, IBM Corp.
+ *			 <benh@kernel.crashing.org>
+ *    and		 Arnd Bergmann, IBM Corp.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version
+ *  2 of the License, or (at your option) any later version.
+ *
+ */
+
+#undef DEBUG
+
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/slab.h>
+#include <linux/pci.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+
+#include <asm/errno.h>
+#include <asm/topology.h>
+#include <asm/pci-bridge.h>
+#include <asm/atomic.h>
+
+#ifdef CONFIG_PPC_PSERIES
+#include <asm/ppc-pci.h>
+#endif
+
+/*
+ * The list of OF IDs below is used for matching bus types in the
+ * system whose devices are to be exposed as of_platform_devices.
+ *
+ * This is the default list valid for most platforms. This file provides
+ * functions who can take an explicit list if necessary though
+ *
+ * The search is always performed recursively looking for children of
+ * the provided device_node and recursively if such a children matches
+ * a bus type in the list
+ */
+
+static const struct of_device_id of_default_bus_ids[] = {
+	{ .type = "soc", },
+	{ .compatible = "soc", },
+	{ .type = "spider", },
+	{ .type = "axon", },
+	{ .type = "plb5", },
+	{ .type = "plb4", },
+	{ .type = "opb", },
+	{ .type = "ebc", },
+	{},
+};
+
+struct bus_type of_platform_bus_type = {
+       .uevent	= of_device_uevent,
+};
+EXPORT_SYMBOL(of_platform_bus_type);
+
+static int __init of_bus_driver_init(void)
+{
+	return of_bus_type_init(&of_platform_bus_type, "of_platform");
+}
+
+postcore_initcall(of_bus_driver_init);
+
+struct of_device* of_platform_device_create(struct device_node *np,
+					    const char *bus_id,
+					    struct device *parent)
+{
+	struct of_device *dev;
+
+	dev = of_device_alloc(np, bus_id, parent);
+	if (!dev)
+		return NULL;
+
+	dev->dma_mask = 0xffffffffUL;
+	dev->dev.bus = &of_platform_bus_type;
+
+	/* We do not fill the DMA ops for platform devices by default.
+	 * This is currently the responsibility of the platform code
+	 * to do such, possibly using a device notifier
+	 */
+
+	if (of_device_register(dev) != 0) {
+		of_device_free(dev);
+		return NULL;
+	}
+
+	return dev;
+}
+EXPORT_SYMBOL(of_platform_device_create);
+
+
+
+/**
+ * of_platform_bus_create - Create an OF device for a bus node and all its
+ * children. Optionally recursively instanciate matching busses.
+ * @bus: device node of the bus to instanciate
+ * @matches: match table, NULL to use the default, OF_NO_DEEP_PROBE to
+ * disallow recursive creation of child busses
+ */
+static int of_platform_bus_create(const struct device_node *bus,
+				  const struct of_device_id *matches,
+				  struct device *parent)
+{
+	struct device_node *child;
+	struct of_device *dev;
+	int rc = 0;
+
+	for_each_child_of_node(bus, child) {
+		pr_debug("   create child: %s\n", child->full_name);
+		dev = of_platform_device_create(child, NULL, parent);
+		if (dev == NULL)
+			rc = -ENOMEM;
+		else if (!of_match_node(matches, child))
+			continue;
+		if (rc == 0) {
+			pr_debug("   and sub busses\n");
+			rc = of_platform_bus_create(child, matches, &dev->dev);
+		} if (rc) {
+			of_node_put(child);
+			break;
+		}
+	}
+	return rc;
+}
+
+/**
+ * of_platform_bus_probe - Probe the device-tree for platform busses
+ * @root: parent of the first level to probe or NULL for the root of the tree
+ * @matches: match table, NULL to use the default
+ * @parent: parent to hook devices from, NULL for toplevel
+ *
+ * Note that children of the provided root are not instanciated as devices
+ * unless the specified root itself matches the bus list and is not NULL.
+ */
+
+int of_platform_bus_probe(struct device_node *root,
+			  const struct of_device_id *matches,
+			  struct device *parent)
+{
+	struct device_node *child;
+	struct of_device *dev;
+	int rc = 0;
+
+	if (matches == NULL)
+		matches = of_default_bus_ids;
+	if (matches == OF_NO_DEEP_PROBE)
+		return -EINVAL;
+	if (root == NULL)
+		root = of_find_node_by_path("/");
+	else
+		of_node_get(root);
+
+	pr_debug("of_platform_bus_probe()\n");
+	pr_debug(" starting at: %s\n", root->full_name);
+
+	/* Do a self check of bus type, if there's a match, create
+	 * children
+	 */
+	if (of_match_node(matches, root)) {
+		pr_debug(" root match, create all sub devices\n");
+		dev = of_platform_device_create(root, NULL, parent);
+		if (dev == NULL) {
+			rc = -ENOMEM;
+			goto bail;
+		}
+		pr_debug(" create all sub busses\n");
+		rc = of_platform_bus_create(root, matches, &dev->dev);
+		goto bail;
+	}
+	for_each_child_of_node(root, child) {
+		if (!of_match_node(matches, child))
+			continue;
+
+		pr_debug("  match: %s\n", child->full_name);
+		dev = of_platform_device_create(child, NULL, parent);
+		if (dev == NULL)
+			rc = -ENOMEM;
+		else
+			rc = of_platform_bus_create(child, matches, &dev->dev);
+		if (rc) {
+			of_node_put(child);
+			break;
+		}
+	}
+ bail:
+	of_node_put(root);
+	return rc;
+}
+EXPORT_SYMBOL(of_platform_bus_probe);
+
+static int of_dev_node_match(struct device *dev, void *data)
+{
+	return to_of_device(dev)->node == data;
+}
+
+struct of_device *of_find_device_by_node(struct device_node *np)
+{
+	struct device *dev;
+
+	dev = bus_find_device(&of_platform_bus_type,
+			      NULL, np, of_dev_node_match);
+	if (dev)
+		return to_of_device(dev);
+	return NULL;
+}
+EXPORT_SYMBOL(of_find_device_by_node);
+
+static int of_dev_phandle_match(struct device *dev, void *data)
+{
+	phandle *ph = data;
+	return to_of_device(dev)->node->linux_phandle == *ph;
+}
+
+struct of_device *of_find_device_by_phandle(phandle ph)
+{
+	struct device *dev;
+
+	dev = bus_find_device(&of_platform_bus_type,
+			      NULL, &ph, of_dev_phandle_match);
+	if (dev)
+		return to_of_device(dev);
+	return NULL;
+}
+EXPORT_SYMBOL(of_find_device_by_phandle);
+
+
+#ifdef CONFIG_PPC_OF_PLATFORM_PCI
+
+/* The probing of PCI controllers from of_platform is currently
+ * 64 bits only, mostly due to gratuitous differences between
+ * the 32 and 64 bits PCI code on PowerPC and the 32 bits one
+ * lacking some bits needed here.
+ */
+
+static int __devinit of_pci_phb_probe(struct of_device *dev,
+				      const struct of_device_id *match)
+{
+	struct pci_controller *phb;
+
+	/* Check if we can do that ... */
+	if (ppc_md.pci_setup_phb == NULL)
+		return -ENODEV;
+
+	printk(KERN_INFO "Setting up PCI bus %s\n", dev->node->full_name);
+
+	/* Alloc and setup PHB data structure */
+	phb = pcibios_alloc_controller(dev->node);
+	if (!phb)
+		return -ENODEV;
+
+	/* Setup parent in sysfs */
+	phb->parent = &dev->dev;
+
+	/* Setup the PHB using arch provided callback */
+	if (ppc_md.pci_setup_phb(phb)) {
+		pcibios_free_controller(phb);
+		return -ENODEV;
+	}
+
+	/* Process "ranges" property */
+	pci_process_bridge_OF_ranges(phb, dev->node, 0);
+
+	/* Init pci_dn data structures */
+	pci_devs_phb_init_dynamic(phb);
+
+	/* Register devices with EEH */
+#ifdef CONFIG_EEH
+	if (dev->node->child)
+		eeh_add_device_tree_early(dev->node);
+#endif /* CONFIG_EEH */
+
+	/* Scan the bus */
+	scan_phb(phb);
+	if (phb->bus == NULL)
+		return -ENXIO;
+
+	/* Claim resources. This might need some rework as well depending
+	 * wether we are doing probe-only or not, like assigning unassigned
+	 * resources etc...
+	 */
+	pcibios_claim_one_bus(phb->bus);
+
+	/* Finish EEH setup */
+#ifdef CONFIG_EEH
+	eeh_add_device_tree_late(phb->bus);
+#endif
+
+	/* Add probed PCI devices to the device model */
+	pci_bus_add_devices(phb->bus);
+
+	return 0;
+}
+
+static struct of_device_id of_pci_phb_ids[] = {
+	{ .type = "pci", },
+	{ .type = "pcix", },
+	{ .type = "pcie", },
+	{ .type = "pciex", },
+	{ .type = "ht", },
+	{}
+};
+
+static struct of_platform_driver of_pci_phb_driver = {
+	.match_table = of_pci_phb_ids,
+	.probe = of_pci_phb_probe,
+	.driver = {
+		.name = "of-pci",
+	},
+};
+
+static __init int of_pci_phb_init(void)
+{
+	return of_register_platform_driver(&of_pci_phb_driver);
+}
+
+device_initcall(of_pci_phb_init);
+
+#endif /* CONFIG_PPC_OF_PLATFORM_PCI */
-- 
1.5.4.GIT

