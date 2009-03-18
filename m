Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbZCRUeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbZCRUeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbZCRUbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:31:50 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:56204 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752131AbZCRUbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:31:41 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 04/57] microblaze_v7: Open firmware files
Date: Wed, 18 Mar 2009 21:30:31 +0100
Message-Id: <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/of_device.h   |   45 ++
 arch/microblaze/include/asm/of_platform.h |   64 ++
 arch/microblaze/include/asm/prom.h        |  313 ++++++++
 arch/microblaze/kernel/of_device.c        |  115 +++
 arch/microblaze/kernel/of_platform.c      |  201 +++++
 arch/microblaze/kernel/prom.c             | 1147 +++++++++++++++++++++++++++++
 arch/microblaze/kernel/prom_parse.c       | 1025 ++++++++++++++++++++++++++
 7 files changed, 2910 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/of_device.h
 create mode 100644 arch/microblaze/include/asm/of_platform.h
 create mode 100644 arch/microblaze/include/asm/prom.h
 create mode 100644 arch/microblaze/kernel/of_device.c
 create mode 100644 arch/microblaze/kernel/of_platform.c
 create mode 100644 arch/microblaze/kernel/prom.c
 create mode 100644 arch/microblaze/kernel/prom_parse.c

diff --git a/arch/microblaze/include/asm/of_device.h b/arch/microblaze/include/asm/of_device.h
new file mode 100644
index 0000000..ba917cf
--- /dev/null
+++ b/arch/microblaze/include/asm/of_device.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ *
+ * based on PowerPC of_device.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_OF_DEVICE_H
+#define _ASM_MICROBLAZE_OF_DEVICE_H
+#ifdef __KERNEL__
+
+#include <linux/device.h>
+#include <linux/of.h>
+
+/*
+ * The of_device is a kind of "base class" that is a superset of
+ * struct device for use by devices attached to an OF node and
+ * probed using OF properties.
+ */
+struct of_device {
+	struct device_node	*node; /* to be obsoleted */
+	u64			dma_mask; /* DMA mask */
+	struct device		dev; /* Generic device interface */
+};
+
+extern ssize_t of_device_get_modalias(struct of_device *ofdev,
+					char *str, ssize_t len);
+
+extern struct of_device *of_device_alloc(struct device_node *np,
+					 const char *bus_id,
+					 struct device *parent);
+
+extern int of_device_uevent(struct device *dev,
+			    struct kobj_uevent_env *env);
+
+extern void of_device_make_bus_id(struct of_device *dev);
+
+/* This is just here during the transition */
+#include <linux/of_device.h>
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_MICROBLAZE_OF_DEVICE_H */
diff --git a/arch/microblaze/include/asm/of_platform.h b/arch/microblaze/include/asm/of_platform.h
new file mode 100644
index 0000000..187c0ee
--- /dev/null
+++ b/arch/microblaze/include/asm/of_platform.h
@@ -0,0 +1,64 @@
+/*
+ * Copyright (C) 2006 Benjamin Herrenschmidt, IBM Corp.
+ *			<benh@kernel.crashing.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_MICROBLAZE_OF_PLATFORM_H
+#define _ASM_MICROBLAZE_OF_PLATFORM_H
+
+/* This is just here during the transition */
+#include <linux/of_platform.h>
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
+	{ .type = "plb5", },
+	{ .type = "plb4", },
+	{ .type = "opb", },
+	{ .type = "simple", },
+	{},
+};
+
+/* Platform drivers register/unregister */
+static inline int of_register_platform_driver(struct of_platform_driver *drv)
+{
+	return of_register_driver(drv, &of_platform_bus_type);
+}
+static inline void of_unregister_platform_driver(struct of_platform_driver *drv)
+{
+	of_unregister_driver(drv);
+}
+
+/* Platform devices and busses creation */
+extern struct of_device *of_platform_device_create(struct device_node *np,
+						const char *bus_id,
+						struct device *parent);
+/* pseudo "matches" value to not do deep probe */
+#define OF_NO_DEEP_PROBE ((struct of_device_id *)-1)
+
+extern int of_platform_bus_probe(struct device_node *root,
+				const struct of_device_id *matches,
+				struct device *parent);
+
+extern struct of_device *of_find_device_by_phandle(phandle ph);
+
+extern void of_instantiate_rtc(void);
+
+#endif /* _ASM_MICROBLAZE_OF_PLATFORM_H */
diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
new file mode 100644
index 0000000..20f7b3a
--- /dev/null
+++ b/arch/microblaze/include/asm/prom.h
@@ -0,0 +1,313 @@
+/*
+ * Definitions for talking to the Open Firmware PROM on
+ * Power Macintosh computers.
+ *
+ * Copyright (C) 1996-2005 Paul Mackerras.
+ *
+ * Updates for PPC64 by Peter Bergner & David Engebretsen, IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_MICROBLAZE_PROM_H
+#define _ASM_MICROBLAZE_PROM_H
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <linux/proc_fs.h>
+#include <linux/platform_device.h>
+#include <asm/irq.h>
+#include <asm/atomic.h>
+
+#define OF_ROOT_NODE_ADDR_CELLS_DEFAULT	1
+#define OF_ROOT_NODE_SIZE_CELLS_DEFAULT	1
+
+#define of_compat_cmp(s1, s2, l)	strncasecmp((s1), (s2), (l))
+#define of_prop_cmp(s1, s2)		strcmp((s1), (s2))
+#define of_node_cmp(s1, s2)		strcasecmp((s1), (s2))
+
+/* Definitions used by the flattened device tree */
+#define OF_DT_HEADER		0xd00dfeed /* marker */
+#define OF_DT_BEGIN_NODE	0x1 /* Start of node, full name */
+#define OF_DT_END_NODE		0x2 /* End node */
+#define OF_DT_PROP		0x3 /* Property: name off, size, content */
+#define OF_DT_NOP		0x4 /* nop */
+#define OF_DT_END		0x9
+
+#define OF_DT_VERSION		0x10
+
+/*
+ * This is what gets passed to the kernel by prom_init or kexec
+ *
+ * The dt struct contains the device tree structure, full pathes and
+ * property contents. The dt strings contain a separate block with just
+ * the strings for the property names, and is fully page aligned and
+ * self contained in a page, so that it can be kept around by the kernel,
+ * each property name appears only once in this page (cheap compression)
+ *
+ * the mem_rsvmap contains a map of reserved ranges of physical memory,
+ * passing it here instead of in the device-tree itself greatly simplifies
+ * the job of everybody. It's just a list of u64 pairs (base/size) that
+ * ends when size is 0
+ */
+struct boot_param_header {
+	u32	magic; /* magic word OF_DT_HEADER */
+	u32	totalsize; /* total size of DT block */
+	u32	off_dt_struct; /* offset to structure */
+	u32	off_dt_strings; /* offset to strings */
+	u32	off_mem_rsvmap; /* offset to memory reserve map */
+	u32	version; /* format version */
+	u32	last_comp_version; /* last compatible version */
+	/* version 2 fields below */
+	u32	boot_cpuid_phys; /* Physical CPU id we're booting on */
+	/* version 3 fields below */
+	u32	dt_strings_size; /* size of the DT strings block */
+	/* version 17 fields below */
+	u32	dt_struct_size; /* size of the DT structure block */
+};
+
+typedef u32 phandle;
+typedef u32 ihandle;
+
+struct property {
+	char	*name;
+	int	length;
+	void	*value;
+	struct property *next;
+};
+
+struct device_node {
+	const char *name;
+	const char *type;
+	phandle	node;
+	phandle linux_phandle;
+	char	*full_name;
+
+	struct	property *properties;
+	struct	property *deadprops; /* removed properties */
+	struct	device_node *parent;
+	struct	device_node *child;
+	struct	device_node *sibling;
+	struct	device_node *next; /* next device of same type */
+	struct	device_node *allnext; /* next in list of all nodes */
+	struct	proc_dir_entry *pde; /* this node's proc directory */
+	struct	kref kref;
+	unsigned long _flags;
+	void	*data;
+};
+
+extern struct device_node *of_chosen;
+
+static inline int of_node_check_flag(struct device_node *n, unsigned long flag)
+{
+	return test_bit(flag, &n->_flags);
+}
+
+static inline void of_node_set_flag(struct device_node *n, unsigned long flag)
+{
+	set_bit(flag, &n->_flags);
+}
+
+#define HAVE_ARCH_DEVTREE_FIXUPS
+
+static inline void set_node_proc_entry(struct device_node *dn,
+					struct proc_dir_entry *de)
+{
+	dn->pde = de;
+}
+
+extern struct device_node *allnodes;	/* temporary while merging */
+extern rwlock_t devtree_lock;	/* temporary while merging */
+
+extern struct device_node *of_find_all_nodes(struct device_node *prev);
+extern struct device_node *of_node_get(struct device_node *node);
+extern void of_node_put(struct device_node *node);
+
+/* For scanning the flat device-tree at boot time */
+extern int __init of_scan_flat_dt(int (*it)(unsigned long node,
+					const char *uname, int depth,
+					void *data),
+				void *data);
+extern void *__init of_get_flat_dt_prop(unsigned long node, const char *name,
+					unsigned long *size);
+extern int __init
+		of_flat_dt_is_compatible(unsigned long node, const char *name);
+extern unsigned long __init of_get_flat_dt_root(void);
+
+/* For updating the device tree at runtime */
+extern void of_attach_node(struct device_node *);
+extern void of_detach_node(struct device_node *);
+
+/* Other Prototypes */
+extern void finish_device_tree(void);
+extern void unflatten_device_tree(void);
+extern int early_uartlite_console(void);
+extern void early_init_devtree(void *);
+extern int machine_is_compatible(const char *compat);
+extern void print_properties(struct device_node *node);
+extern int prom_n_intr_cells(struct device_node *np);
+extern void prom_get_irq_senses(unsigned char *senses, int off, int max);
+extern int prom_add_property(struct device_node *np, struct property *prop);
+extern int prom_remove_property(struct device_node *np, struct property *prop);
+extern int prom_update_property(struct device_node *np,
+				struct property *newprop,
+				struct property *oldprop);
+
+extern struct resource *request_OF_resource(struct device_node *node,
+				int index, const char *name_postfix);
+extern int release_OF_resource(struct device_node *node, int index);
+
+/*
+ * OF address retreival & translation
+ */
+
+/* Helper to read a big number; size is in cells (not bytes) */
+static inline u64 of_read_number(const u32 *cell, int size)
+{
+	u64 r = 0;
+	while (size--)
+		r = (r << 32) | *(cell++);
+	return r;
+}
+
+/* Like of_read_number, but we want an unsigned long result */
+#define of_read_ulong(cell, size)	of_read_number(cell, size)
+
+/* Translate an OF address block into a CPU physical address
+ */
+extern u64 of_translate_address(struct device_node *np, const u32 *addr);
+
+/* Extract an address from a device, returns the region size and
+ * the address space flags too. The PCI version uses a BAR number
+ * instead of an absolute index
+ */
+extern const u32 *of_get_address(struct device_node *dev, int index,
+			u64 *size, unsigned int *flags);
+extern const u32 *of_get_pci_address(struct device_node *dev, int bar_no,
+			u64 *size, unsigned int *flags);
+
+/* Get an address as a resource. Note that if your address is
+ * a PIO address, the conversion will fail if the physical address
+ * can't be internally converted to an IO token with
+ * pci_address_to_pio(), that is because it's either called to early
+ * or it can't be matched to any host bridge IO space
+ */
+extern int of_address_to_resource(struct device_node *dev, int index,
+				struct resource *r);
+extern int of_pci_address_to_resource(struct device_node *dev, int bar,
+				struct resource *r);
+
+/* Parse the ibm,dma-window property of an OF node into the busno, phys and
+ * size parameters.
+ */
+void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
+		unsigned long *busno, unsigned long *phys, unsigned long *size);
+
+extern void kdump_move_device_tree(void);
+
+/* CPU OF node matching */
+struct device_node *of_get_cpu_node(int cpu, unsigned int *thread);
+
+/* Get the MAC address */
+extern const void *of_get_mac_address(struct device_node *np);
+
+/*
+ * OF interrupt mapping
+ */
+
+/* This structure is returned when an interrupt is mapped. The controller
+ * field needs to be put() after use
+ */
+
+#define OF_MAX_IRQ_SPEC		4 /* We handle specifiers of at most 4 cells */
+
+struct of_irq {
+	struct device_node *controller; /* Interrupt controller node */
+	u32 size; /* Specifier size */
+	u32 specifier[OF_MAX_IRQ_SPEC]; /* Specifier copy */
+};
+
+/**
+ * of_irq_map_init - Initialize the irq remapper
+ * @flags:	flags defining workarounds to enable
+ *
+ * Some machines have bugs in the device-tree which require certain workarounds
+ * to be applied. Call this before any interrupt mapping attempts to enable
+ * those workarounds.
+ */
+#define OF_IMAP_OLDWORLD_MAC	0x00000001
+#define OF_IMAP_NO_PHANDLE	0x00000002
+
+extern void of_irq_map_init(unsigned int flags);
+
+/**
+ * of_irq_map_raw - Low level interrupt tree parsing
+ * @parent:	the device interrupt parent
+ * @intspec:	interrupt specifier ("interrupts" property of the device)
+ * @ointsize:	size of the passed in interrupt specifier
+ * @addr:	address specifier (start of "reg" property of the device)
+ * @out_irq:	structure of_irq filled by this function
+ *
+ * Returns 0 on success and a negative number on error
+ *
+ * This function is a low-level interrupt tree walking function. It
+ * can be used to do a partial walk with synthetized reg and interrupts
+ * properties, for example when resolving PCI interrupts when no device
+ * node exist for the parent.
+ *
+ */
+
+extern int of_irq_map_raw(struct device_node *parent, const u32 *intspec,
+			u32 ointsize, const u32 *addr,
+			struct of_irq *out_irq);
+
+/**
+ * of_irq_map_one - Resolve an interrupt for a device
+ * @device:	the device whose interrupt is to be resolved
+ * @index:	index of the interrupt to resolve
+ * @out_irq:	structure of_irq filled by this function
+ *
+ * This function resolves an interrupt, walking the tree, for a given
+ * device-tree node. It's the high level pendant to of_irq_map_raw().
+ * It also implements the workarounds for OldWolrd Macs.
+ */
+extern int of_irq_map_one(struct device_node *device, int index,
+			struct of_irq *out_irq);
+
+/**
+ * of_irq_map_pci - Resolve the interrupt for a PCI device
+ * @pdev:	the device whose interrupt is to be resolved
+ * @out_irq:	structure of_irq filled by this function
+ *
+ * This function resolves the PCI interrupt for a given PCI device. If a
+ * device-node exists for a given pci_dev, it will use normal OF tree
+ * walking. If not, it will implement standard swizzling and walk up the
+ * PCI tree until an device-node is found, at which point it will finish
+ * resolving using the OF tree walking.
+ */
+struct pci_dev;
+extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
+
+extern int of_irq_to_resource(struct device_node *dev, int index,
+			struct resource *r);
+
+/**
+ * of_iomap - Maps the memory mapped IO for a given device_node
+ * @device:	the device whose io range will be mapped
+ * @index:	index of the io range
+ *
+ * Returns a pointer to the mapped memory
+ */
+extern void __iomem *of_iomap(struct device_node *device, int index);
+
+/*
+ * NB: This is here while we transition from using asm/prom.h
+ * to linux/of.h
+ */
+#include <linux/of.h>
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_MICROBLAZE_PROM_H */
diff --git a/arch/microblaze/kernel/of_device.c b/arch/microblaze/kernel/of_device.c
new file mode 100644
index 0000000..717edf4
--- /dev/null
+++ b/arch/microblaze/kernel/of_device.c
@@ -0,0 +1,115 @@
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/slab.h>
+#include <linux/of_device.h>
+
+#include <linux/errno.h>
+
+void of_device_make_bus_id(struct of_device *dev)
+{
+	static atomic_t bus_no_reg_magic;
+	struct device_node *node = dev->node;
+	char *name = dev->dev.bus_id;
+	const u32 *reg;
+	u64 addr;
+	int magic;
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
+EXPORT_SYMBOL(of_device_make_bus_id);
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
+		sl = strlen(compat) + 1;
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
diff --git a/arch/microblaze/kernel/of_platform.c b/arch/microblaze/kernel/of_platform.c
new file mode 100644
index 0000000..acf4574
--- /dev/null
+++ b/arch/microblaze/kernel/of_platform.c
@@ -0,0 +1,201 @@
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
+#include <linux/errno.h>
+#include <linux/topology.h>
+#include <asm/atomic.h>
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
+postcore_initcall(of_bus_driver_init);
+
+struct of_device *of_platform_device_create(struct device_node *np,
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
+		}
+		if (rc) {
+			of_node_put(child);
+			break;
+		}
+	}
+	return rc;
+}
+
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
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
new file mode 100644
index 0000000..475b1fa
--- /dev/null
+++ b/arch/microblaze/kernel/prom.c
@@ -0,0 +1,1147 @@
+/*
+ * Procedures for creating, accessing and interpreting the device tree.
+ *
+ * Paul Mackerras	August 1996.
+ * Copyright (C) 1996-2005 Paul Mackerras.
+ *
+ *  Adapted for 64bit PowerPC by Dave Engebretsen and Peter Bergner.
+ *    {engebret|bergner}@us.ibm.com
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <stdarg.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/init.h>
+#include <linux/threads.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/stringify.h>
+#include <linux/delay.h>
+#include <linux/initrd.h>
+#include <linux/bitops.h>
+#include <linux/module.h>
+#include <linux/kexec.h>
+#include <linux/debugfs.h>
+#include <linux/irq.h>
+#include <linux/lmb.h>
+
+#include <asm/prom.h>
+#include <asm/page.h>
+#include <asm/processor.h>
+#include <asm/irq.h>
+#include <linux/io.h>
+#include <asm/system.h>
+#include <asm/mmu.h>
+#include <asm/pgtable.h>
+#include <linux/pci.h>
+#include <asm/sections.h>
+#include <asm/pci-bridge.h>
+
+static int __initdata dt_root_addr_cells;
+static int __initdata dt_root_size_cells;
+
+typedef u32 cell_t;
+
+static struct boot_param_header *initial_boot_params;
+
+/* export that to outside world */
+struct device_node *of_chosen;
+
+static inline char *find_flat_dt_string(u32 offset)
+{
+	return ((char *)initial_boot_params) +
+		initial_boot_params->off_dt_strings + offset;
+}
+
+/**
+ * This function is used to scan the flattened device-tree, it is
+ * used to extract the memory informations at boot before we can
+ * unflatten the tree
+ */
+int __init of_scan_flat_dt(int (*it)(unsigned long node,
+				     const char *uname, int depth,
+				     void *data),
+			   void *data)
+{
+	unsigned long p = ((unsigned long)initial_boot_params) +
+		initial_boot_params->off_dt_struct;
+	int rc = 0;
+	int depth = -1;
+
+	do {
+		u32 tag = *((u32 *)p);
+		char *pathp;
+
+		p += 4;
+		if (tag == OF_DT_END_NODE) {
+			depth--;
+			continue;
+		}
+		if (tag == OF_DT_NOP)
+			continue;
+		if (tag == OF_DT_END)
+			break;
+		if (tag == OF_DT_PROP) {
+			u32 sz = *((u32 *)p);
+			p += 8;
+			if (initial_boot_params->version < 0x10)
+				p = _ALIGN(p, sz >= 8 ? 8 : 4);
+			p += sz;
+			p = _ALIGN(p, 4);
+			continue;
+		}
+		if (tag != OF_DT_BEGIN_NODE) {
+			printk(KERN_WARNING "Invalid tag %x scanning flattened"
+				" device tree !\n", tag);
+			return -EINVAL;
+		}
+		depth++;
+		pathp = (char *)p;
+		p = _ALIGN(p + strlen(pathp) + 1, 4);
+		if ((*pathp) == '/') {
+			char *lp, *np;
+			for (lp = NULL, np = pathp; *np; np++)
+				if ((*np) == '/')
+					lp = np+1;
+			if (lp != NULL)
+				pathp = lp;
+		}
+		rc = it(p, pathp, depth, data);
+		if (rc != 0)
+			break;
+	} while (1);
+
+	return rc;
+}
+
+unsigned long __init of_get_flat_dt_root(void)
+{
+	unsigned long p = ((unsigned long)initial_boot_params) +
+		initial_boot_params->off_dt_struct;
+
+	while (*((u32 *)p) == OF_DT_NOP)
+		p += 4;
+	BUG_ON(*((u32 *)p) != OF_DT_BEGIN_NODE);
+	p += 4;
+	return _ALIGN(p + strlen((char *)p) + 1, 4);
+}
+
+/**
+ * This function can be used within scan_flattened_dt callback to get
+ * access to properties
+ */
+void *__init of_get_flat_dt_prop(unsigned long node, const char *name,
+				unsigned long *size)
+{
+	unsigned long p = node;
+
+	do {
+		u32 tag = *((u32 *)p);
+		u32 sz, noff;
+		const char *nstr;
+
+		p += 4;
+		if (tag == OF_DT_NOP)
+			continue;
+		if (tag != OF_DT_PROP)
+			return NULL;
+
+		sz = *((u32 *)p);
+		noff = *((u32 *)(p + 4));
+		p += 8;
+		if (initial_boot_params->version < 0x10)
+			p = _ALIGN(p, sz >= 8 ? 8 : 4);
+
+		nstr = find_flat_dt_string(noff);
+		if (nstr == NULL) {
+			printk(KERN_WARNING "Can't find property index"
+				" name !\n");
+			return NULL;
+		}
+		if (strcmp(name, nstr) == 0) {
+			if (size)
+				*size = sz;
+			return (void *)p;
+		}
+		p += sz;
+		p = _ALIGN(p, 4);
+	} while (1);
+}
+
+int __init of_flat_dt_is_compatible(unsigned long node, const char *compat)
+{
+	const char *cp;
+	unsigned long cplen, l;
+
+	cp = of_get_flat_dt_prop(node, "compatible", &cplen);
+	if (cp == NULL)
+		return 0;
+	while (cplen > 0) {
+		if (strncasecmp(cp, compat, strlen(compat)) == 0)
+			return 1;
+		l = strlen(cp) + 1;
+		cp += l;
+		cplen -= l;
+	}
+
+	return 0;
+}
+
+static void *__init unflatten_dt_alloc(unsigned long *mem, unsigned long size,
+					unsigned long align)
+{
+	void *res;
+
+	*mem = _ALIGN(*mem, align);
+	res = (void *)*mem;
+	*mem += size;
+
+	return res;
+}
+
+static unsigned long __init unflatten_dt_node(unsigned long mem,
+					unsigned long *p,
+					struct device_node *dad,
+					struct device_node ***allnextpp,
+					unsigned long fpsize)
+{
+	struct device_node *np;
+	struct property *pp, **prev_pp = NULL;
+	char *pathp;
+	u32 tag;
+	unsigned int l, allocl;
+	int has_name = 0;
+	int new_format = 0;
+
+	tag = *((u32 *)(*p));
+	if (tag != OF_DT_BEGIN_NODE) {
+		printk("Weird tag at start of node: %x\n", tag);
+		return mem;
+	}
+	*p += 4;
+	pathp = (char *)*p;
+	l = allocl = strlen(pathp) + 1;
+	*p = _ALIGN(*p + l, 4);
+
+	/* version 0x10 has a more compact unit name here instead of the full
+	 * path. we accumulate the full path size using "fpsize", we'll rebuild
+	 * it later. We detect this because the first character of the name is
+	 * not '/'.
+	 */
+	if ((*pathp) != '/') {
+		new_format = 1;
+		if (fpsize == 0) {
+			/* root node: special case. fpsize accounts for path
+			 * plus terminating zero. root node only has '/', so
+			 * fpsize should be 2, but we want to avoid the first
+			 * level nodes to have two '/' so we use fpsize 1 here
+			 */
+			fpsize = 1;
+			allocl = 2;
+		} else {
+			/* account for '/' and path size minus terminal 0
+			 * already in 'l'
+			 */
+			fpsize += l;
+			allocl = fpsize;
+		}
+	}
+
+	np = unflatten_dt_alloc(&mem, sizeof(struct device_node) + allocl,
+				__alignof__(struct device_node));
+	if (allnextpp) {
+		memset(np, 0, sizeof(*np));
+		np->full_name = ((char *)np) + sizeof(struct device_node);
+		if (new_format) {
+			char *p2 = np->full_name;
+			/* rebuild full path for new format */
+			if (dad && dad->parent) {
+				strcpy(p2, dad->full_name);
+#ifdef DEBUG
+				if ((strlen(p2) + l + 1) != allocl) {
+					pr_debug("%s: p: %d, l: %d, a: %d\n",
+						pathp, (int)strlen(p2),
+						l, allocl);
+				}
+#endif
+				p2 += strlen(p2);
+			}
+			*(p2++) = '/';
+			memcpy(p2, pathp, l);
+		} else
+			memcpy(np->full_name, pathp, l);
+		prev_pp = &np->properties;
+		**allnextpp = np;
+		*allnextpp = &np->allnext;
+		if (dad != NULL) {
+			np->parent = dad;
+			/* we temporarily use the next field as `last_child'*/
+			if (dad->next == NULL)
+				dad->child = np;
+			else
+				dad->next->sibling = np;
+			dad->next = np;
+		}
+		kref_init(&np->kref);
+	}
+	while (1) {
+		u32 sz, noff;
+		char *pname;
+
+		tag = *((u32 *)(*p));
+		if (tag == OF_DT_NOP) {
+			*p += 4;
+			continue;
+		}
+		if (tag != OF_DT_PROP)
+			break;
+		*p += 4;
+		sz = *((u32 *)(*p));
+		noff = *((u32 *)((*p) + 4));
+		*p += 8;
+		if (initial_boot_params->version < 0x10)
+			*p = _ALIGN(*p, sz >= 8 ? 8 : 4);
+
+		pname = find_flat_dt_string(noff);
+		if (pname == NULL) {
+			printk(KERN_INFO
+				"Can't find property name in list !\n");
+			break;
+		}
+		if (strcmp(pname, "name") == 0)
+			has_name = 1;
+		l = strlen(pname) + 1;
+		pp = unflatten_dt_alloc(&mem, sizeof(struct property),
+					__alignof__(struct property));
+		if (allnextpp) {
+			if (strcmp(pname, "linux,phandle") == 0) {
+				np->node = *((u32 *)*p);
+				if (np->linux_phandle == 0)
+					np->linux_phandle = np->node;
+			}
+			if (strcmp(pname, "ibm,phandle") == 0)
+				np->linux_phandle = *((u32 *)*p);
+			pp->name = pname;
+			pp->length = sz;
+			pp->value = (void *)*p;
+			*prev_pp = pp;
+			prev_pp = &pp->next;
+		}
+		*p = _ALIGN((*p) + sz, 4);
+	}
+	/* with version 0x10 we may not have the name property, recreate
+	 * it here from the unit name if absent
+	 */
+	if (!has_name) {
+		char *p1 = pathp, *ps = pathp, *pa = NULL;
+		int sz;
+
+		while (*p1) {
+			if ((*p1) == '@')
+				pa = p1;
+			if ((*p1) == '/')
+				ps = p1 + 1;
+			p1++;
+		}
+		if (pa < ps)
+			pa = p1;
+		sz = (pa - ps) + 1;
+		pp = unflatten_dt_alloc(&mem, sizeof(struct property) + sz,
+					__alignof__(struct property));
+		if (allnextpp) {
+			pp->name = "name";
+			pp->length = sz;
+			pp->value = pp + 1;
+			*prev_pp = pp;
+			prev_pp = &pp->next;
+			memcpy(pp->value, ps, sz - 1);
+			((char *)pp->value)[sz - 1] = 0;
+			pr_debug("fixed up name for %s -> %s\n", pathp,
+				(char *)pp->value);
+		}
+	}
+	if (allnextpp) {
+		*prev_pp = NULL;
+		np->name = of_get_property(np, "name", NULL);
+		np->type = of_get_property(np, "device_type", NULL);
+
+		if (!np->name)
+			np->name = "<NULL>";
+		if (!np->type)
+			np->type = "<NULL>";
+	}
+	while (tag == OF_DT_BEGIN_NODE) {
+		mem = unflatten_dt_node(mem, p, np, allnextpp, fpsize);
+		tag = *((u32 *)(*p));
+	}
+	if (tag != OF_DT_END_NODE) {
+		printk(KERN_INFO "Weird tag at end of node: %x\n", tag);
+		return mem;
+	}
+	*p += 4;
+	return mem;
+}
+
+/**
+ * unflattens the device-tree passed by the firmware, creating the
+ * tree of struct device_node. It also fills the "name" and "type"
+ * pointers of the nodes so the normal device-tree walking functions
+ * can be used (this used to be done by finish_device_tree)
+ */
+void __init unflatten_device_tree(void)
+{
+	unsigned long start, mem, size;
+	struct device_node **allnextp = &allnodes;
+
+	pr_debug(" -> unflatten_device_tree()\n");
+
+	/* First pass, scan for size */
+	start = ((unsigned long)initial_boot_params) +
+		initial_boot_params->off_dt_struct;
+	size = unflatten_dt_node(0, &start, NULL, NULL, 0);
+	size = (size | 3) + 1;
+
+	pr_debug("  size is %lx, allocating...\n", size);
+
+	/* Allocate memory for the expanded device tree */
+	mem = lmb_alloc(size + 4, __alignof__(struct device_node));
+	mem = (unsigned long) __va(mem);
+
+	((u32 *)mem)[size / 4] = 0xdeadbeef;
+
+	pr_debug("  unflattening %lx...\n", mem);
+
+	/* Second pass, do actual unflattening */
+	start = ((unsigned long)initial_boot_params) +
+		initial_boot_params->off_dt_struct;
+	unflatten_dt_node(mem, &start, NULL, &allnextp, 0);
+	if (*((u32 *)start) != OF_DT_END)
+		printk(KERN_WARNING "Weird tag at end of tree: %08x\n",
+			*((u32 *)start));
+	if (((u32 *)mem)[size / 4] != 0xdeadbeef)
+		printk(KERN_WARNING "End of tree marker overwritten: %08x\n",
+			((u32 *)mem)[size / 4]);
+	*allnextp = NULL;
+
+	/* Get pointer to OF "/chosen" node for use everywhere */
+	of_chosen = of_find_node_by_path("/chosen");
+	if (of_chosen == NULL)
+		of_chosen = of_find_node_by_path("/chosen@0");
+
+	pr_debug(" <- unflatten_device_tree()\n");
+}
+
+#define early_init_dt_scan_drconf_memory(node) 0
+
+static int __init early_init_dt_scan_cpus(unsigned long node,
+					  const char *uname, int depth,
+					  void *data)
+{
+	static int logical_cpuid;
+	char *type = of_get_flat_dt_prop(node, "device_type", NULL);
+	const u32 *intserv;
+	int i, nthreads;
+	int found = 0;
+
+	/* We are scanning "cpu" nodes only */
+	if (type == NULL || strcmp(type, "cpu") != 0)
+		return 0;
+
+	/* Get physical cpuid */
+	intserv = of_get_flat_dt_prop(node, "reg", NULL);
+	nthreads = 1;
+
+	/*
+	 * Now see if any of these threads match our boot cpu.
+	 * NOTE: This must match the parsing done in smp_setup_cpu_maps.
+	 */
+	for (i = 0; i < nthreads; i++) {
+		/*
+		 * version 2 of the kexec param format adds the phys cpuid of
+		 * booted proc.
+		 */
+		if (initial_boot_params && initial_boot_params->version >= 2) {
+			if (intserv[i] ==
+					initial_boot_params->boot_cpuid_phys) {
+				found = 1;
+				break;
+			}
+		} else {
+			/*
+			 * Check if it's the boot-cpu, set it's hw index now,
+			 * unfortunately this format did not support booting
+			 * off secondary threads.
+			 */
+			if (of_get_flat_dt_prop(node,
+					"linux,boot-cpu", NULL) != NULL) {
+				found = 1;
+				break;
+			}
+		}
+
+#ifdef CONFIG_SMP
+		/* logical cpu id is always 0 on UP kernels */
+		logical_cpuid++;
+#endif
+	}
+
+	if (found) {
+		pr_debug("boot cpu: logical %d physical %d\n", logical_cpuid,
+			intserv[i]);
+		boot_cpuid = logical_cpuid;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+static void __init early_init_dt_check_for_initrd(unsigned long node)
+{
+	unsigned long l;
+	u32 *prop;
+
+	pr_debug("Looking for initrd properties... ");
+
+	prop = of_get_flat_dt_prop(node, "linux,initrd-start", &l);
+	if (prop) {
+		initrd_start = (unsigned long)__va(of_read_ulong(prop, l/4));
+
+		prop = of_get_flat_dt_prop(node, "linux,initrd-end", &l);
+		if (prop) {
+			initrd_end = (unsigned long)
+					__va(of_read_ulong(prop, l/4));
+			initrd_below_start_ok = 1;
+		} else {
+			initrd_start = 0;
+		}
+	}
+
+	pr_debug("initrd_start=0x%lx  initrd_end=0x%lx\n",
+					initrd_start, initrd_end);
+}
+#else
+static inline void early_init_dt_check_for_initrd(unsigned long node)
+{
+}
+#endif /* CONFIG_BLK_DEV_INITRD */
+
+static int __init early_init_dt_scan_chosen(unsigned long node,
+				const char *uname, int depth, void *data)
+{
+	unsigned long l;
+	char *p;
+
+	pr_debug("search \"chosen\", depth: %d, uname: %s\n", depth, uname);
+
+	if (depth != 1 ||
+		(strcmp(uname, "chosen") != 0 &&
+				strcmp(uname, "chosen@0") != 0))
+		return 0;
+
+#ifdef CONFIG_KEXEC
+	lprop = (u64 *)of_get_flat_dt_prop(node,
+				"linux,crashkernel-base", NULL);
+	if (lprop)
+		crashk_res.start = *lprop;
+
+	lprop = (u64 *)of_get_flat_dt_prop(node,
+				"linux,crashkernel-size", NULL);
+	if (lprop)
+		crashk_res.end = crashk_res.start + *lprop - 1;
+#endif
+
+	early_init_dt_check_for_initrd(node);
+
+	/* Retreive command line */
+	p = of_get_flat_dt_prop(node, "bootargs", &l);
+	if (p != NULL && l > 0)
+		strlcpy(cmd_line, p, min((int)l, COMMAND_LINE_SIZE));
+
+#ifdef CONFIG_CMDLINE
+	if (p == NULL || l == 0 || (l == 1 && (*p) == 0))
+		strlcpy(cmd_line, CONFIG_CMDLINE, COMMAND_LINE_SIZE);
+#endif /* CONFIG_CMDLINE */
+
+	pr_debug("Command line is: %s\n", cmd_line);
+
+	/* break now */
+	return 1;
+}
+
+static int __init early_init_dt_scan_root(unsigned long node,
+				const char *uname, int depth, void *data)
+{
+	u32 *prop;
+
+	if (depth != 0)
+		return 0;
+
+	prop = of_get_flat_dt_prop(node, "#size-cells", NULL);
+	dt_root_size_cells = (prop == NULL) ? 1 : *prop;
+	pr_debug("dt_root_size_cells = %x\n", dt_root_size_cells);
+
+	prop = of_get_flat_dt_prop(node, "#address-cells", NULL);
+	dt_root_addr_cells = (prop == NULL) ? 2 : *prop;
+	pr_debug("dt_root_addr_cells = %x\n", dt_root_addr_cells);
+
+	/* break now */
+	return 1;
+}
+
+static u64 __init dt_mem_next_cell(int s, cell_t **cellp)
+{
+	cell_t *p = *cellp;
+
+	*cellp = p + s;
+	return of_read_number(p, s);
+}
+
+static int __init early_init_dt_scan_memory(unsigned long node,
+				const char *uname, int depth, void *data)
+{
+	char *type = of_get_flat_dt_prop(node, "device_type", NULL);
+	cell_t *reg, *endp;
+	unsigned long l;
+
+	/* Look for the ibm,dynamic-reconfiguration-memory node */
+/*	if (depth == 1 &&
+		strcmp(uname, "ibm,dynamic-reconfiguration-memory") == 0)
+		return early_init_dt_scan_drconf_memory(node);
+*/
+	/* We are scanning "memory" nodes only */
+	if (type == NULL) {
+		/*
+		 * The longtrail doesn't have a device_type on the
+		 * /memory node, so look for the node called /memory@0.
+		 */
+		if (depth != 1 || strcmp(uname, "memory@0") != 0)
+			return 0;
+	} else if (strcmp(type, "memory") != 0)
+		return 0;
+
+	reg = (cell_t *)of_get_flat_dt_prop(node, "linux,usable-memory", &l);
+	if (reg == NULL)
+		reg = (cell_t *)of_get_flat_dt_prop(node, "reg", &l);
+	if (reg == NULL)
+		return 0;
+
+	endp = reg + (l / sizeof(cell_t));
+
+	pr_debug("memory scan node %s, reg size %ld, data: %x %x %x %x,\n",
+		uname, l, reg[0], reg[1], reg[2], reg[3]);
+
+	while ((endp - reg) >= (dt_root_addr_cells + dt_root_size_cells)) {
+		u64 base, size;
+
+		base = dt_mem_next_cell(dt_root_addr_cells, &reg);
+		size = dt_mem_next_cell(dt_root_size_cells, &reg);
+
+		if (size == 0)
+			continue;
+		pr_debug(" - %llx ,  %llx\n", (unsigned long long)base,
+			(unsigned long long)size);
+
+		lmb_add(base, size);
+	}
+	return 0;
+}
+
+#ifdef CONFIG_PHYP_DUMP
+/**
+ * phyp_dump_calculate_reserve_size() - reserve variable boot area 5% or arg
+ *
+ * Function to find the largest size we need to reserve
+ * during early boot process.
+ *
+ * It either looks for boot param and returns that OR
+ * returns larger of 256 or 5% rounded down to multiples of 256MB.
+ *
+ */
+static inline unsigned long phyp_dump_calculate_reserve_size(void)
+{
+	unsigned long tmp;
+
+	if (phyp_dump_info->reserve_bootvar)
+		return phyp_dump_info->reserve_bootvar;
+
+	/* divide by 20 to get 5% of value */
+	tmp = lmb_end_of_DRAM();
+	do_div(tmp, 20);
+
+	/* round it down in multiples of 256 */
+	tmp = tmp & ~0x0FFFFFFFUL;
+
+	return (tmp > PHYP_DUMP_RMR_END ? tmp : PHYP_DUMP_RMR_END);
+}
+
+/**
+ * phyp_dump_reserve_mem() - reserve all not-yet-dumped mmemory
+ *
+ * This routine may reserve memory regions in the kernel only
+ * if the system is supported and a dump was taken in last
+ * boot instance or if the hardware is supported and the
+ * scratch area needs to be setup. In other instances it returns
+ * without reserving anything. The memory in case of dump being
+ * active is freed when the dump is collected (by userland tools).
+ */
+static void __init phyp_dump_reserve_mem(void)
+{
+	unsigned long base, size;
+	unsigned long variable_reserve_size;
+
+	if (!phyp_dump_info->phyp_dump_configured) {
+		printk(KERN_ERR "Phyp-dump not supported on this hardware\n");
+		return;
+	}
+
+	if (!phyp_dump_info->phyp_dump_at_boot) {
+		printk(KERN_INFO "Phyp-dump disabled at boot time\n");
+		return;
+	}
+
+	variable_reserve_size = phyp_dump_calculate_reserve_size();
+
+	if (phyp_dump_info->phyp_dump_is_active) {
+		/* Reserve *everything* above RMR.Area freed by userland tools*/
+		base = variable_reserve_size;
+		size = lmb_end_of_DRAM() - base;
+
+		/* XXX crashed_ram_end is wrong, since it may be beyond
+		 * the memory_limit, it will need to be adjusted. */
+		lmb_reserve(base, size);
+
+		phyp_dump_info->init_reserve_start = base;
+		phyp_dump_info->init_reserve_size = size;
+	} else {
+		size = phyp_dump_info->cpu_state_size +
+			phyp_dump_info->hpte_region_size +
+			variable_reserve_size;
+		base = lmb_end_of_DRAM() - size;
+		lmb_reserve(base, size);
+		phyp_dump_info->init_reserve_start = base;
+		phyp_dump_info->init_reserve_size = size;
+	}
+}
+#else
+static inline void __init phyp_dump_reserve_mem(void) {}
+#endif /* CONFIG_PHYP_DUMP  && CONFIG_PPC_RTAS */
+
+#ifdef CONFIG_EARLY_PRINTK
+/* MS this is Microblaze specifig function */
+static int __init early_init_dt_scan_serial(unsigned long node,
+				const char *uname, int depth, void *data)
+{
+	unsigned long l;
+	char *p;
+	int *addr;
+
+	pr_debug("search \"chosen\", depth: %d, uname: %s\n", depth, uname);
+
+/* find all serial nodes */
+	if (strncmp(uname, "serial", 6) != 0)
+		return 0;
+
+	early_init_dt_check_for_initrd(node);
+
+/* find compatible node with uartlite */
+	p = of_get_flat_dt_prop(node, "compatible", &l);
+	if ((strncmp(p, "xlnx,xps-uartlite", 17) != 0) &&
+			(strncmp(p, "xlnx,opb-uartlite", 17) != 0))
+		return 0;
+
+	addr = of_get_flat_dt_prop(node, "reg", &l);
+	return *addr; /* return address */
+}
+
+/* this function is looking for early uartlite console - Microblaze specific */
+int __init early_uartlite_console(void)
+{
+	return of_scan_flat_dt(early_init_dt_scan_serial, NULL);
+}
+#endif
+
+void __init early_init_devtree(void *params)
+{
+	pr_debug(" -> early_init_devtree(%p)\n", params);
+
+	/* Setup flat device-tree pointer */
+	initial_boot_params = params;
+
+#ifdef CONFIG_PHYP_DUMP
+	/* scan tree to see if dump occured during last boot */
+	of_scan_flat_dt(early_init_dt_scan_phyp_dump, NULL);
+#endif
+
+	/* Retrieve various informations from the /chosen node of the
+	 * device-tree, including the platform type, initrd location and
+	 * size, TCE reserve, and more ...
+	 */
+	of_scan_flat_dt(early_init_dt_scan_chosen, NULL);
+
+	/* Scan memory nodes and rebuild LMBs */
+	lmb_init();
+	of_scan_flat_dt(early_init_dt_scan_root, NULL);
+	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
+
+	/* Save command line for /proc/cmdline and then parse parameters */
+	strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
+	parse_early_param();
+
+	lmb_analyze();
+
+	pr_debug("Phys. mem: %lx\n", (unsigned long) lmb_phys_mem_size());
+
+	pr_debug("Scanning CPUs ...\n");
+
+	/* Retreive CPU related informations from the flat tree
+	 * (altivec support, boot CPU ID, ...)
+	 */
+	of_scan_flat_dt(early_init_dt_scan_cpus, NULL);
+
+	pr_debug(" <- early_init_devtree()\n");
+}
+
+/**
+ * Indicates whether the root node has a given value in its
+ * compatible property.
+ */
+int machine_is_compatible(const char *compat)
+{
+	struct device_node *root;
+	int rc = 0;
+
+	root = of_find_node_by_path("/");
+	if (root) {
+		rc = of_device_is_compatible(root, compat);
+		of_node_put(root);
+	}
+	return rc;
+}
+EXPORT_SYMBOL(machine_is_compatible);
+
+/*******
+ *
+ * New implementation of the OF "find" APIs, return a refcounted
+ * object, call of_node_put() when done.  The device tree and list
+ * are protected by a rw_lock.
+ *
+ * Note that property management will need some locking as well,
+ * this isn't dealt with yet.
+ *
+ *******/
+
+/**
+ *	of_find_node_by_phandle - Find a node given a phandle
+ *	@handle:	phandle of the node to find
+ *
+ *	Returns a node pointer with refcount incremented, use
+ *	of_node_put() on it when done.
+ */
+struct device_node *of_find_node_by_phandle(phandle handle)
+{
+	struct device_node *np;
+
+	read_lock(&devtree_lock);
+	for (np = allnodes; np != NULL; np = np->allnext)
+		if (np->linux_phandle == handle)
+			break;
+	of_node_get(np);
+	read_unlock(&devtree_lock);
+	return np;
+}
+EXPORT_SYMBOL(of_find_node_by_phandle);
+
+/**
+ *	of_find_all_nodes - Get next node in global list
+ *	@prev:	Previous node or NULL to start iteration
+ *		of_node_put() will be called on it
+ *
+ *	Returns a node pointer with refcount incremented, use
+ *	of_node_put() on it when done.
+ */
+struct device_node *of_find_all_nodes(struct device_node *prev)
+{
+	struct device_node *np;
+
+	read_lock(&devtree_lock);
+	np = prev ? prev->allnext : allnodes;
+	for (; np != NULL; np = np->allnext)
+		if (of_node_get(np))
+			break;
+	of_node_put(prev);
+	read_unlock(&devtree_lock);
+	return np;
+}
+EXPORT_SYMBOL(of_find_all_nodes);
+
+/**
+ *	of_node_get - Increment refcount of a node
+ *	@node:	Node to inc refcount, NULL is supported to
+ *		simplify writing of callers
+ *
+ *	Returns node.
+ */
+struct device_node *of_node_get(struct device_node *node)
+{
+	if (node)
+		kref_get(&node->kref);
+	return node;
+}
+EXPORT_SYMBOL(of_node_get);
+
+static inline struct device_node *kref_to_device_node(struct kref *kref)
+{
+	return container_of(kref, struct device_node, kref);
+}
+
+/**
+ *	of_node_release - release a dynamically allocated node
+ *	@kref:  kref element of the node to be released
+ *
+ *	In of_node_put() this function is passed to kref_put()
+ *	as the destructor.
+ */
+static void of_node_release(struct kref *kref)
+{
+	struct device_node *node = kref_to_device_node(kref);
+	struct property *prop = node->properties;
+
+	/* We should never be releasing nodes that haven't been detached. */
+	if (!of_node_check_flag(node, OF_DETACHED)) {
+		printk(KERN_INFO "WARNING: Bad of_node_put() on %s\n",
+			node->full_name);
+		dump_stack();
+		kref_init(&node->kref);
+		return;
+	}
+
+	if (!of_node_check_flag(node, OF_DYNAMIC))
+		return;
+
+	while (prop) {
+		struct property *next = prop->next;
+		kfree(prop->name);
+		kfree(prop->value);
+		kfree(prop);
+		prop = next;
+
+		if (!prop) {
+			prop = node->deadprops;
+			node->deadprops = NULL;
+		}
+	}
+	kfree(node->full_name);
+	kfree(node->data);
+	kfree(node);
+}
+
+/**
+ *	of_node_put - Decrement refcount of a node
+ *	@node:	Node to dec refcount, NULL is supported to
+ *		simplify writing of callers
+ *
+ */
+void of_node_put(struct device_node *node)
+{
+	if (node)
+		kref_put(&node->kref, of_node_release);
+}
+EXPORT_SYMBOL(of_node_put);
+
+/*
+ * Plug a device node into the tree and global list.
+ */
+void of_attach_node(struct device_node *np)
+{
+	unsigned long flags;
+
+	write_lock_irqsave(&devtree_lock, flags);
+	np->sibling = np->parent->child;
+	np->allnext = allnodes;
+	np->parent->child = np;
+	allnodes = np;
+	write_unlock_irqrestore(&devtree_lock, flags);
+}
+
+/*
+ * "Unplug" a node from the device tree.  The caller must hold
+ * a reference to the node.  The memory associated with the node
+ * is not freed until its refcount goes to zero.
+ */
+void of_detach_node(struct device_node *np)
+{
+	struct device_node *parent;
+	unsigned long flags;
+
+	write_lock_irqsave(&devtree_lock, flags);
+
+	parent = np->parent;
+	if (!parent)
+		goto out_unlock;
+
+	if (allnodes == np)
+		allnodes = np->allnext;
+	else {
+		struct device_node *prev;
+		for (prev = allnodes;
+		     prev->allnext != np;
+		     prev = prev->allnext)
+			;
+		prev->allnext = np->allnext;
+	}
+
+	if (parent->child == np)
+		parent->child = np->sibling;
+	else {
+		struct device_node *prevsib;
+		for (prevsib = np->parent->child;
+		     prevsib->sibling != np;
+		     prevsib = prevsib->sibling)
+			;
+		prevsib->sibling = np->sibling;
+	}
+
+	of_node_set_flag(np, OF_DETACHED);
+
+out_unlock:
+	write_unlock_irqrestore(&devtree_lock, flags);
+}
+
+/*
+ * Add a property to a node
+ */
+int prom_add_property(struct device_node *np, struct property *prop)
+{
+	struct property **next;
+	unsigned long flags;
+
+	prop->next = NULL;
+	write_lock_irqsave(&devtree_lock, flags);
+	next = &np->properties;
+	while (*next) {
+		if (strcmp(prop->name, (*next)->name) == 0) {
+			/* duplicate ! don't insert it */
+			write_unlock_irqrestore(&devtree_lock, flags);
+			return -1;
+		}
+		next = &(*next)->next;
+	}
+	*next = prop;
+	write_unlock_irqrestore(&devtree_lock, flags);
+
+#ifdef CONFIG_PROC_DEVICETREE
+	/* try to add to proc as well if it was initialized */
+	if (np->pde)
+		proc_device_tree_add_prop(np->pde, prop);
+#endif /* CONFIG_PROC_DEVICETREE */
+
+	return 0;
+}
+
+/*
+ * Remove a property from a node.  Note that we don't actually
+ * remove it, since we have given out who-knows-how-many pointers
+ * to the data using get-property.  Instead we just move the property
+ * to the "dead properties" list, so it won't be found any more.
+ */
+int prom_remove_property(struct device_node *np, struct property *prop)
+{
+	struct property **next;
+	unsigned long flags;
+	int found = 0;
+
+	write_lock_irqsave(&devtree_lock, flags);
+	next = &np->properties;
+	while (*next) {
+		if (*next == prop) {
+			/* found the node */
+			*next = prop->next;
+			prop->next = np->deadprops;
+			np->deadprops = prop;
+			found = 1;
+			break;
+		}
+		next = &(*next)->next;
+	}
+	write_unlock_irqrestore(&devtree_lock, flags);
+
+	if (!found)
+		return -ENODEV;
+
+#ifdef CONFIG_PROC_DEVICETREE
+	/* try to remove the proc node as well */
+	if (np->pde)
+		proc_device_tree_remove_prop(np->pde, prop);
+#endif /* CONFIG_PROC_DEVICETREE */
+
+	return 0;
+}
+
+/*
+ * Update a property in a node.  Note that we don't actually
+ * remove it, since we have given out who-knows-how-many pointers
+ * to the data using get-property.  Instead we just move the property
+ * to the "dead properties" list, and add the new property to the
+ * property list
+ */
+int prom_update_property(struct device_node *np,
+			 struct property *newprop,
+			 struct property *oldprop)
+{
+	struct property **next;
+	unsigned long flags;
+	int found = 0;
+
+	write_lock_irqsave(&devtree_lock, flags);
+	next = &np->properties;
+	while (*next) {
+		if (*next == oldprop) {
+			/* found the node */
+			newprop->next = oldprop->next;
+			*next = newprop;
+			oldprop->next = np->deadprops;
+			np->deadprops = oldprop;
+			found = 1;
+			break;
+		}
+		next = &(*next)->next;
+	}
+	write_unlock_irqrestore(&devtree_lock, flags);
+
+	if (!found)
+		return -ENODEV;
+
+#ifdef CONFIG_PROC_DEVICETREE
+	/* try to add to proc as well if it was initialized */
+	if (np->pde)
+		proc_device_tree_update_prop(np->pde, newprop, oldprop);
+#endif /* CONFIG_PROC_DEVICETREE */
+
+	return 0;
+}
+
+#if defined(CONFIG_DEBUG_FS) && defined(DEBUG)
+static struct debugfs_blob_wrapper flat_dt_blob;
+
+static int __init export_flat_device_tree(void)
+{
+	struct dentry *d;
+
+	flat_dt_blob.data = initial_boot_params;
+	flat_dt_blob.size = initial_boot_params->totalsize;
+
+	d = debugfs_create_blob("flat-device-tree", S_IFREG | S_IRUSR,
+				of_debugfs_root, &flat_dt_blob);
+	if (!d)
+		return 1;
+
+	return 0;
+}
+device_initcall(export_flat_device_tree);
+#endif
diff --git a/arch/microblaze/kernel/prom_parse.c b/arch/microblaze/kernel/prom_parse.c
new file mode 100644
index 0000000..ae0352e
--- /dev/null
+++ b/arch/microblaze/kernel/prom_parse.c
@@ -0,0 +1,1025 @@
+#undef DEBUG
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/pci_regs.h>
+#include <linux/module.h>
+#include <linux/ioport.h>
+#include <linux/etherdevice.h>
+#include <asm/prom.h>
+#include <asm/pci-bridge.h>
+
+#define PRu64	"%llx"
+
+/* Max address size we deal with */
+#define OF_MAX_ADDR_CELLS	4
+#define OF_CHECK_COUNTS(na, ns)	((na) > 0 && (na) <= OF_MAX_ADDR_CELLS && \
+			(ns) > 0)
+
+static struct of_bus *of_match_bus(struct device_node *np);
+static int __of_address_to_resource(struct device_node *dev,
+		const u32 *addrp, u64 size, unsigned int flags,
+		struct resource *r);
+
+/* Debug utility */
+#ifdef DEBUG
+static void of_dump_addr(const char *s, const u32 *addr, int na)
+{
+	printk(KERN_INFO "%s", s);
+	while (na--)
+		printk(KERN_INFO " %08x", *(addr++));
+	printk(KERN_INFO "\n");
+}
+#else
+static void of_dump_addr(const char *s, const u32 *addr, int na) { }
+#endif
+
+/* Callbacks for bus specific translators */
+struct of_bus {
+	const char	*name;
+	const char	*addresses;
+	int		(*match)(struct device_node *parent);
+	void		(*count_cells)(struct device_node *child,
+					int *addrc, int *sizec);
+	u64		(*map)(u32 *addr, const u32 *range,
+				int na, int ns, int pna);
+	int		(*translate)(u32 *addr, u64 offset, int na);
+	unsigned int	(*get_flags)(const u32 *addr);
+};
+
+/*
+ * Default translator (generic bus)
+ */
+
+static void of_bus_default_count_cells(struct device_node *dev,
+					int *addrc, int *sizec)
+{
+	if (addrc)
+		*addrc = of_n_addr_cells(dev);
+	if (sizec)
+		*sizec = of_n_size_cells(dev);
+}
+
+static u64 of_bus_default_map(u32 *addr, const u32 *range,
+		int na, int ns, int pna)
+{
+	u64 cp, s, da;
+
+	cp = of_read_number(range, na);
+	s  = of_read_number(range + na + pna, ns);
+	da = of_read_number(addr, na);
+
+	pr_debug("OF: default map, cp="PRu64", s="PRu64", da="PRu64"\n",
+		cp, s, da);
+
+	if (da < cp || da >= (cp + s))
+		return OF_BAD_ADDR;
+	return da - cp;
+}
+
+static int of_bus_default_translate(u32 *addr, u64 offset, int na)
+{
+	u64 a = of_read_number(addr, na);
+	memset(addr, 0, na * 4);
+	a += offset;
+	if (na > 1)
+		addr[na - 2] = a >> 32;
+	addr[na - 1] = a & 0xffffffffu;
+
+	return 0;
+}
+
+static unsigned int of_bus_default_get_flags(const u32 *addr)
+{
+	return IORESOURCE_MEM;
+}
+
+#ifdef CONFIG_PCI
+/*
+ * PCI bus specific translator
+ */
+
+static int of_bus_pci_match(struct device_node *np)
+{
+	/* "vci" is for the /chaos bridge on 1st-gen PCI powermacs */
+	return !strcmp(np->type, "pci") || !strcmp(np->type, "vci");
+}
+
+static void of_bus_pci_count_cells(struct device_node *np,
+				int *addrc, int *sizec)
+{
+	if (addrc)
+		*addrc = 3;
+	if (sizec)
+		*sizec = 2;
+}
+
+static u64 of_bus_pci_map(u32 *addr, const u32 *range, int na, int ns, int pna)
+{
+	u64 cp, s, da;
+
+	/* Check address type match */
+	if ((addr[0] ^ range[0]) & 0x03000000)
+		return OF_BAD_ADDR;
+
+	/* Read address values, skipping high cell */
+	cp = of_read_number(range + 1, na - 1);
+	s  = of_read_number(range + na + pna, ns);
+	da = of_read_number(addr + 1, na - 1);
+
+	pr_debug("OF: PCI map, cp="PRu64", s="PRu64", da="PRu64"\n", cp, s, da);
+
+	if (da < cp || da >= (cp + s))
+		return OF_BAD_ADDR;
+	return da - cp;
+}
+
+static int of_bus_pci_translate(u32 *addr, u64 offset, int na)
+{
+	return of_bus_default_translate(addr + 1, offset, na - 1);
+}
+
+static unsigned int of_bus_pci_get_flags(const u32 *addr)
+{
+	unsigned int flags = 0;
+	u32 w = addr[0];
+
+	switch ((w >> 24) & 0x03) {
+	case 0x01:
+		flags |= IORESOURCE_IO;
+		break;
+	case 0x02: /* 32 bits */
+	case 0x03: /* 64 bits */
+		flags |= IORESOURCE_MEM;
+		break;
+	}
+	if (w & 0x40000000)
+		flags |= IORESOURCE_PREFETCH;
+	return flags;
+}
+
+const u32 *of_get_pci_address(struct device_node *dev, int bar_no, u64 *size,
+			unsigned int *flags)
+{
+	const u32 *prop;
+	unsigned int psize;
+	struct device_node *parent;
+	struct of_bus *bus;
+	int onesize, i, na, ns;
+
+	/* Get parent & match bus type */
+	parent = of_get_parent(dev);
+	if (parent == NULL)
+		return NULL;
+	bus = of_match_bus(parent);
+	if (strcmp(bus->name, "pci")) {
+		of_node_put(parent);
+		return NULL;
+	}
+	bus->count_cells(dev, &na, &ns);
+	of_node_put(parent);
+	if (!OF_CHECK_COUNTS(na, ns))
+		return NULL;
+
+	/* Get "reg" or "assigned-addresses" property */
+	prop = of_get_property(dev, bus->addresses, &psize);
+	if (prop == NULL)
+		return NULL;
+	psize /= 4;
+
+	onesize = na + ns;
+	for (i = 0; psize >= onesize; psize -= onesize, prop += onesize, i++)
+		if ((prop[0] & 0xff) == ((bar_no * 4) + PCI_BASE_ADDRESS_0)) {
+			if (size)
+				*size = of_read_number(prop + na, ns);
+			if (flags)
+				*flags = bus->get_flags(prop);
+			return prop;
+		}
+	return NULL;
+}
+EXPORT_SYMBOL(of_get_pci_address);
+
+int of_pci_address_to_resource(struct device_node *dev, int bar,
+				struct resource *r)
+{
+	const u32	*addrp;
+	u64		size;
+	unsigned int	flags;
+
+	addrp = of_get_pci_address(dev, bar, &size, &flags);
+	if (addrp == NULL)
+		return -EINVAL;
+	return __of_address_to_resource(dev, addrp, size, flags, r);
+}
+EXPORT_SYMBOL_GPL(of_pci_address_to_resource);
+
+static u8 of_irq_pci_swizzle(u8 slot, u8 pin)
+{
+	return (((pin - 1) + slot) % 4) + 1;
+}
+
+int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq)
+{
+	struct device_node *dn, *ppnode;
+	struct pci_dev *ppdev;
+	u32 lspec;
+	u32 laddr[3];
+	u8 pin;
+	int rc;
+
+	/* Check if we have a device node, if yes, fallback to standard OF
+	 * parsing
+	 */
+	dn = pci_device_to_OF_node(pdev);
+	if (dn)
+		return of_irq_map_one(dn, 0, out_irq);
+
+	/* Ok, we don't, time to have fun. Let's start by building up an
+	 * interrupt spec.  we assume #interrupt-cells is 1, which is standard
+	 * for PCI. If you do different, then don't use that routine.
+	 */
+	rc = pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &pin);
+	if (rc != 0)
+		return rc;
+	/* No pin, exit */
+	if (pin == 0)
+		return -ENODEV;
+
+	/* Now we walk up the PCI tree */
+	lspec = pin;
+	for (;;) {
+		/* Get the pci_dev of our parent */
+		ppdev = pdev->bus->self;
+
+		/* Ouch, it's a host bridge... */
+		if (ppdev == NULL) {
+			struct pci_controller *host;
+			host = pci_bus_to_host(pdev->bus);
+			ppnode = host ? host->arch_data : NULL;
+			/* No node for host bridge ? give up */
+			if (ppnode == NULL)
+				return -EINVAL;
+		} else
+			/* We found a P2P bridge, check if it has a node */
+			ppnode = pci_device_to_OF_node(ppdev);
+
+		/* Ok, we have found a parent with a device-node, hand over to
+		 * the OF parsing code.
+		 * We build a unit address from the linux device to be used for
+		 * resolution. Note that we use the linux bus number which may
+		 * not match your firmware bus numbering.
+		 * Fortunately, in most cases, interrupt-map-mask doesn't
+		 * include the bus number as part of the matching.
+		 * You should still be careful about that though if you intend
+		 * to rely on this function (you ship  a firmware that doesn't
+		 * create device nodes for all PCI devices).
+		 */
+		if (ppnode)
+			break;
+
+		/* We can only get here if we hit a P2P bridge with no node,
+		 * let's do standard swizzling and try again
+		 */
+		lspec = of_irq_pci_swizzle(PCI_SLOT(pdev->devfn), lspec);
+		pdev = ppdev;
+	}
+
+	laddr[0] = (pdev->bus->number << 16)
+		| (pdev->devfn << 8);
+	laddr[1]  = laddr[2] = 0;
+	return of_irq_map_raw(ppnode, &lspec, 1, laddr, out_irq);
+}
+EXPORT_SYMBOL_GPL(of_irq_map_pci);
+#endif /* CONFIG_PCI */
+
+/*
+ * ISA bus specific translator
+ */
+
+static int of_bus_isa_match(struct device_node *np)
+{
+	return !strcmp(np->name, "isa");
+}
+
+static void of_bus_isa_count_cells(struct device_node *child,
+				int *addrc, int *sizec)
+{
+	if (addrc)
+		*addrc = 2;
+	if (sizec)
+		*sizec = 1;
+}
+
+static u64 of_bus_isa_map(u32 *addr, const u32 *range, int na, int ns, int pna)
+{
+	u64 cp, s, da;
+
+	/* Check address type match */
+	if ((addr[0] ^ range[0]) & 0x00000001)
+		return OF_BAD_ADDR;
+
+	/* Read address values, skipping high cell */
+	cp = of_read_number(range + 1, na - 1);
+	s  = of_read_number(range + na + pna, ns);
+	da = of_read_number(addr + 1, na - 1);
+
+	pr_debug("OF: ISA map, cp="PRu64", s="PRu64", da="PRu64"\n", cp, s, da);
+
+	if (da < cp || da >= (cp + s))
+		return OF_BAD_ADDR;
+	return da - cp;
+}
+
+static int of_bus_isa_translate(u32 *addr, u64 offset, int na)
+{
+	return of_bus_default_translate(addr + 1, offset, na - 1);
+}
+
+static unsigned int of_bus_isa_get_flags(const u32 *addr)
+{
+	unsigned int flags = 0;
+	u32 w = addr[0];
+
+	if (w & 1)
+		flags |= IORESOURCE_IO;
+	else
+		flags |= IORESOURCE_MEM;
+	return flags;
+}
+
+/*
+ * Array of bus specific translators
+ */
+
+static struct of_bus of_busses[] = {
+#ifdef CONFIG_PCI
+	/* PCI */
+	{
+		.name = "pci",
+		.addresses = "assigned-addresses",
+		.match = of_bus_pci_match,
+		.count_cells = of_bus_pci_count_cells,
+		.map = of_bus_pci_map,
+		.translate = of_bus_pci_translate,
+		.get_flags = of_bus_pci_get_flags,
+	},
+#endif /* CONFIG_PCI */
+	/* ISA */
+	{
+		.name = "isa",
+		.addresses = "reg",
+		.match = of_bus_isa_match,
+		.count_cells = of_bus_isa_count_cells,
+		.map = of_bus_isa_map,
+		.translate = of_bus_isa_translate,
+		.get_flags = of_bus_isa_get_flags,
+	},
+	/* Default */
+	{
+		.name = "default",
+		.addresses = "reg",
+		.match = NULL,
+		.count_cells = of_bus_default_count_cells,
+		.map = of_bus_default_map,
+		.translate = of_bus_default_translate,
+		.get_flags = of_bus_default_get_flags,
+	},
+};
+
+static struct of_bus *of_match_bus(struct device_node *np)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(of_busses); i++)
+		if (!of_busses[i].match || of_busses[i].match(np))
+			return &of_busses[i];
+	BUG();
+	return NULL;
+}
+
+static int of_translate_one(struct device_node *parent, struct of_bus *bus,
+			struct of_bus *pbus, u32 *addr,
+			int na, int ns, int pna)
+{
+	const u32 *ranges;
+	unsigned int rlen;
+	int rone;
+	u64 offset = OF_BAD_ADDR;
+
+	/* Normally, an absence of a "ranges" property means we are
+	 * crossing a non-translatable boundary, and thus the addresses
+	 * below the current not cannot be converted to CPU physical ones.
+	 * Unfortunately, while this is very clear in the spec, it's not
+	 * what Apple understood, and they do have things like /uni-n or
+	 * /ht nodes with no "ranges" property and a lot of perfectly
+	 * useable mapped devices below them. Thus we treat the absence of
+	 * "ranges" as equivalent to an empty "ranges" property which means
+	 * a 1:1 translation at that level. It's up to the caller not to try
+	 * to translate addresses that aren't supposed to be translated in
+	 * the first place. --BenH.
+	 */
+	ranges = of_get_property(parent, "ranges", (int *) &rlen);
+	if (ranges == NULL || rlen == 0) {
+		offset = of_read_number(addr, na);
+		memset(addr, 0, pna * 4);
+		pr_debug("OF: no ranges, 1:1 translation\n");
+		goto finish;
+	}
+
+	pr_debug("OF: walking ranges...\n");
+
+	/* Now walk through the ranges */
+	rlen /= 4;
+	rone = na + pna + ns;
+	for (; rlen >= rone; rlen -= rone, ranges += rone) {
+		offset = bus->map(addr, ranges, na, ns, pna);
+		if (offset != OF_BAD_ADDR)
+			break;
+	}
+	if (offset == OF_BAD_ADDR) {
+		pr_debug("OF: not found !\n");
+		return 1;
+	}
+	memcpy(addr, ranges + na, 4 * pna);
+
+ finish:
+	of_dump_addr("OF: parent translation for:", addr, pna);
+	pr_debug("OF: with offset: "PRu64"\n", offset);
+
+	/* Translate it into parent bus space */
+	return pbus->translate(addr, offset, pna);
+}
+
+/*
+ * Translate an address from the device-tree into a CPU physical address,
+ * this walks up the tree and applies the various bus mappings on the
+ * way.
+ *
+ * Note: We consider that crossing any level with #size-cells == 0 to mean
+ * that translation is impossible (that is we are not dealing with a value
+ * that can be mapped to a cpu physical address). This is not really specified
+ * that way, but this is traditionally the way IBM at least do things
+ */
+u64 of_translate_address(struct device_node *dev, const u32 *in_addr)
+{
+	struct device_node *parent = NULL;
+	struct of_bus *bus, *pbus;
+	u32 addr[OF_MAX_ADDR_CELLS];
+	int na, ns, pna, pns;
+	u64 result = OF_BAD_ADDR;
+
+	pr_debug("OF: ** translation for device %s **\n", dev->full_name);
+
+	/* Increase refcount at current level */
+	of_node_get(dev);
+
+	/* Get parent & match bus type */
+	parent = of_get_parent(dev);
+	if (parent == NULL)
+		goto bail;
+	bus = of_match_bus(parent);
+
+	/* Cound address cells & copy address locally */
+	bus->count_cells(dev, &na, &ns);
+	if (!OF_CHECK_COUNTS(na, ns)) {
+		printk(KERN_ERR "prom_parse: Bad cell count for %s\n",
+			dev->full_name);
+		goto bail;
+	}
+	memcpy(addr, in_addr, na * 4);
+
+	pr_debug("OF: bus is %s (na=%d, ns=%d) on %s\n",
+		bus->name, na, ns, parent->full_name);
+	of_dump_addr("OF: translating address:", addr, na);
+
+	/* Translate */
+	for (;;) {
+		/* Switch to parent bus */
+		of_node_put(dev);
+		dev = parent;
+		parent = of_get_parent(dev);
+
+		/* If root, we have finished */
+		if (parent == NULL) {
+			pr_debug("OF: reached root node\n");
+			result = of_read_number(addr, na);
+			break;
+		}
+
+		/* Get new parent bus and counts */
+		pbus = of_match_bus(parent);
+		pbus->count_cells(dev, &pna, &pns);
+		if (!OF_CHECK_COUNTS(pna, pns)) {
+			printk(KERN_ERR "prom_parse: Bad cell count for %s\n",
+				dev->full_name);
+			break;
+		}
+
+		pr_debug("OF: parent bus is %s (na=%d, ns=%d) on %s\n",
+			pbus->name, pna, pns, parent->full_name);
+
+		/* Apply bus translation */
+		if (of_translate_one(dev, bus, pbus, addr, na, ns, pna))
+			break;
+
+		/* Complete the move up one level */
+		na = pna;
+		ns = pns;
+		bus = pbus;
+
+		of_dump_addr("OF: one level translation:", addr, na);
+	}
+ bail:
+	of_node_put(parent);
+	of_node_put(dev);
+
+	return result;
+}
+EXPORT_SYMBOL(of_translate_address);
+
+const u32 *of_get_address(struct device_node *dev, int index, u64 *size,
+			unsigned int *flags)
+{
+	const u32 *prop;
+	unsigned int psize;
+	struct device_node *parent;
+	struct of_bus *bus;
+	int onesize, i, na, ns;
+
+	/* Get parent & match bus type */
+	parent = of_get_parent(dev);
+	if (parent == NULL)
+		return NULL;
+	bus = of_match_bus(parent);
+	bus->count_cells(dev, &na, &ns);
+	of_node_put(parent);
+	if (!OF_CHECK_COUNTS(na, ns))
+		return NULL;
+
+	/* Get "reg" or "assigned-addresses" property */
+	prop = of_get_property(dev, bus->addresses, (int *) &psize);
+	if (prop == NULL)
+		return NULL;
+	psize /= 4;
+
+	onesize = na + ns;
+	for (i = 0; psize >= onesize; psize -= onesize, prop += onesize, i++)
+		if (i == index) {
+			if (size)
+				*size = of_read_number(prop + na, ns);
+			if (flags)
+				*flags = bus->get_flags(prop);
+			return prop;
+		}
+	return NULL;
+}
+EXPORT_SYMBOL(of_get_address);
+
+static int __of_address_to_resource(struct device_node *dev, const u32 *addrp,
+				u64 size, unsigned int flags,
+				struct resource *r)
+{
+	u64 taddr;
+
+	if ((flags & (IORESOURCE_IO | IORESOURCE_MEM)) == 0)
+		return -EINVAL;
+	taddr = of_translate_address(dev, addrp);
+	if (taddr == OF_BAD_ADDR)
+		return -EINVAL;
+	memset(r, 0, sizeof(struct resource));
+	if (flags & IORESOURCE_IO) {
+		unsigned long port;
+		port = -1; /* pci_address_to_pio(taddr); */
+		if (port == (unsigned long)-1)
+			return -EINVAL;
+		r->start = port;
+		r->end = port + size - 1;
+	} else {
+		r->start = taddr;
+		r->end = taddr + size - 1;
+	}
+	r->flags = flags;
+	r->name = dev->name;
+	return 0;
+}
+
+int of_address_to_resource(struct device_node *dev, int index,
+			struct resource *r)
+{
+	const u32	*addrp;
+	u64		size;
+	unsigned int	flags;
+
+	addrp = of_get_address(dev, index, &size, &flags);
+	if (addrp == NULL)
+		return -EINVAL;
+	return __of_address_to_resource(dev, addrp, size, flags, r);
+}
+EXPORT_SYMBOL_GPL(of_address_to_resource);
+
+void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
+		unsigned long *busno, unsigned long *phys, unsigned long *size)
+{
+	const u32 *dma_window;
+	u32 cells;
+	const unsigned char *prop;
+
+	dma_window = dma_window_prop;
+
+	/* busno is always one cell */
+	*busno = *(dma_window++);
+
+	prop = of_get_property(dn, "ibm,#dma-address-cells", NULL);
+	if (!prop)
+		prop = of_get_property(dn, "#address-cells", NULL);
+
+	cells = prop ? *(u32 *)prop : of_n_addr_cells(dn);
+	*phys = of_read_number(dma_window, cells);
+
+	dma_window += cells;
+
+	prop = of_get_property(dn, "ibm,#dma-size-cells", NULL);
+	cells = prop ? *(u32 *)prop : of_n_size_cells(dn);
+	*size = of_read_number(dma_window, cells);
+}
+
+/*
+ * Interrupt remapper
+ */
+
+static unsigned int of_irq_workarounds;
+static struct device_node *of_irq_dflt_pic;
+
+static struct device_node *of_irq_find_parent(struct device_node *child)
+{
+	struct device_node *p;
+	const phandle *parp;
+
+	if (!of_node_get(child))
+		return NULL;
+
+	do {
+		parp = of_get_property(child, "interrupt-parent", NULL);
+		if (parp == NULL)
+			p = of_get_parent(child);
+		else {
+			if (of_irq_workarounds & OF_IMAP_NO_PHANDLE)
+				p = of_node_get(of_irq_dflt_pic);
+			else
+				p = of_find_node_by_phandle(*parp);
+		}
+		of_node_put(child);
+		child = p;
+	} while (p && of_get_property(p, "#interrupt-cells", NULL) == NULL);
+
+	return p;
+}
+
+/* This doesn't need to be called if you don't have any special workaround
+ * flags to pass
+ */
+void of_irq_map_init(unsigned int flags)
+{
+	of_irq_workarounds = flags;
+
+	/* OldWorld, don't bother looking at other things */
+	if (flags & OF_IMAP_OLDWORLD_MAC)
+		return;
+
+	/* If we don't have phandles, let's try to locate a default interrupt
+	 * controller (happens when booting with BootX). We do a first match
+	 * here, hopefully, that only ever happens on machines with one
+	 * controller.
+	 */
+	if (flags & OF_IMAP_NO_PHANDLE) {
+		struct device_node *np;
+
+		for (np = NULL; (np = of_find_all_nodes(np)) != NULL;) {
+			if (of_get_property(np, "interrupt-controller", NULL)
+				== NULL)
+				continue;
+			/* Skip /chosen/interrupt-controller */
+			if (strcmp(np->name, "chosen") == 0)
+				continue;
+			/* It seems like at least one person on this planet
+			 * wants to use BootX on a machine with an AppleKiwi
+			 * controller which happens to pretend to be an
+			 * interrupt controller too.
+			 */
+			if (strcmp(np->name, "AppleKiwi") == 0)
+				continue;
+			/* I think we found one ! */
+			of_irq_dflt_pic = np;
+			break;
+		}
+	}
+
+}
+
+int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
+		const u32 *addr, struct of_irq *out_irq)
+{
+	struct device_node *ipar, *tnode, *old = NULL, *newpar = NULL;
+	const u32 *tmp, *imap, *imask;
+	u32 intsize = 1, addrsize, newintsize = 0, newaddrsize = 0;
+	int imaplen, match, i;
+
+	pr_debug("of_irq_map_raw: par=%s,intspec=[0x%08x 0x%08x...],"
+		"ointsize=%d\n",
+		parent->full_name, intspec[0], intspec[1], ointsize);
+
+	ipar = of_node_get(parent);
+
+	/* First get the #interrupt-cells property of the current cursor
+	 * that tells us how to interpret the passed-in intspec. If there
+	 * is none, we are nice and just walk up the tree
+	 */
+	do {
+		tmp = of_get_property(ipar, "#interrupt-cells", NULL);
+		if (tmp != NULL) {
+			intsize = *tmp;
+			break;
+		}
+		tnode = ipar;
+		ipar = of_irq_find_parent(ipar);
+		of_node_put(tnode);
+	} while (ipar);
+	if (ipar == NULL) {
+		pr_debug(" -> no parent found !\n");
+		goto fail;
+	}
+
+	pr_debug("of_irq_map_raw: ipar=%s, size=%d\n",
+			ipar->full_name, intsize);
+
+	if (ointsize != intsize)
+		return -EINVAL;
+
+	/* Look for this #address-cells. We have to implement the old linux
+	 * trick of looking for the parent here as some device-trees rely on it
+	 */
+	old = of_node_get(ipar);
+	do {
+		tmp = of_get_property(old, "#address-cells", NULL);
+		tnode = of_get_parent(old);
+		of_node_put(old);
+		old = tnode;
+	} while (old && tmp == NULL);
+	of_node_put(old);
+	old = NULL;
+	addrsize = (tmp == NULL) ? 2 : *tmp;
+
+	pr_debug(" -> addrsize=%d\n", addrsize);
+
+	/* Now start the actual "proper" walk of the interrupt tree */
+	while (ipar != NULL) {
+		/* Now check if cursor is an interrupt-controller and if it is
+		 * then we are done
+		 */
+		if (of_get_property(ipar, "interrupt-controller", NULL) !=
+				NULL) {
+			pr_debug(" -> got it !\n");
+			memcpy(out_irq->specifier, intspec,
+				intsize * sizeof(u32));
+			out_irq->size = intsize;
+			out_irq->controller = ipar;
+			of_node_put(old);
+			return 0;
+		}
+
+		/* Now look for an interrupt-map */
+		imap = of_get_property(ipar, "interrupt-map", &imaplen);
+		/* No interrupt map, check for an interrupt parent */
+		if (imap == NULL) {
+			pr_debug(" -> no map, getting parent\n");
+			newpar = of_irq_find_parent(ipar);
+			goto skiplevel;
+		}
+		imaplen /= sizeof(u32);
+
+		/* Look for a mask */
+		imask = of_get_property(ipar, "interrupt-map-mask", NULL);
+
+		/* If we were passed no "reg" property and we attempt to parse
+		 * an interrupt-map, then #address-cells must be 0.
+		 * Fail if it's not.
+		 */
+		if (addr == NULL && addrsize != 0) {
+			pr_debug(" -> no reg passed in when needed !\n");
+			goto fail;
+		}
+
+		/* Parse interrupt-map */
+		match = 0;
+		while (imaplen > (addrsize + intsize + 1) && !match) {
+			/* Compare specifiers */
+			match = 1;
+			for (i = 0; i < addrsize && match; ++i) {
+				u32 mask = imask ? imask[i] : 0xffffffffu;
+				match = ((addr[i] ^ imap[i]) & mask) == 0;
+			}
+			for (; i < (addrsize + intsize) && match; ++i) {
+				u32 mask = imask ? imask[i] : 0xffffffffu;
+				match =
+					((intspec[i-addrsize] ^ imap[i])
+						& mask) == 0;
+			}
+			imap += addrsize + intsize;
+			imaplen -= addrsize + intsize;
+
+			pr_debug(" -> match=%d (imaplen=%d)\n", match, imaplen);
+
+			/* Get the interrupt parent */
+			if (of_irq_workarounds & OF_IMAP_NO_PHANDLE)
+				newpar = of_node_get(of_irq_dflt_pic);
+			else
+				newpar =
+					of_find_node_by_phandle((phandle)*imap);
+			imap++;
+			--imaplen;
+
+			/* Check if not found */
+			if (newpar == NULL) {
+				pr_debug(" -> imap parent not found !\n");
+				goto fail;
+			}
+
+			/* Get #interrupt-cells and #address-cells of new
+			 * parent
+			 */
+			tmp = of_get_property(newpar, "#interrupt-cells", NULL);
+			if (tmp == NULL) {
+				pr_debug(" -> parent lacks "
+						"#interrupt-cells!\n");
+				goto fail;
+			}
+			newintsize = *tmp;
+			tmp = of_get_property(newpar, "#address-cells", NULL);
+			newaddrsize = (tmp == NULL) ? 0 : *tmp;
+
+			pr_debug(" -> newintsize=%d, newaddrsize=%d\n",
+				newintsize, newaddrsize);
+
+			/* Check for malformed properties */
+			if (imaplen < (newaddrsize + newintsize))
+				goto fail;
+
+			imap += newaddrsize + newintsize;
+			imaplen -= newaddrsize + newintsize;
+
+			pr_debug(" -> imaplen=%d\n", imaplen);
+		}
+		if (!match)
+			goto fail;
+
+		of_node_put(old);
+		old = of_node_get(newpar);
+		addrsize = newaddrsize;
+		intsize = newintsize;
+		intspec = imap - intsize;
+		addr = intspec - addrsize;
+
+skiplevel:
+		/* Iterate again with new parent */
+		pr_debug(" -> new parent: %s\n",
+				newpar ? newpar->full_name : "<>");
+		of_node_put(ipar);
+		ipar = newpar;
+		newpar = NULL;
+	}
+fail:
+	of_node_put(ipar);
+	of_node_put(old);
+	of_node_put(newpar);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(of_irq_map_raw);
+
+int of_irq_map_one(struct device_node *device,
+			int index, struct of_irq *out_irq)
+{
+	struct device_node *p;
+	const u32 *intspec, *tmp, *addr;
+	u32 intsize, intlen;
+	int res;
+
+	pr_debug("of_irq_map_one: dev=%s, index=%d\n",
+			device->full_name, index);
+
+	/* Get the interrupts property */
+	intspec = of_get_property(device, "interrupts", (int *) &intlen);
+	if (intspec == NULL)
+		return -EINVAL;
+	intlen /= sizeof(u32);
+
+	pr_debug(" intspec=%d intlen=%d\n", *intspec, intlen);
+
+	/* Get the reg property (if any) */
+	addr = of_get_property(device, "reg", NULL);
+
+	/* Look for the interrupt parent. */
+	p = of_irq_find_parent(device);
+	if (p == NULL)
+		return -EINVAL;
+
+	/* Get size of interrupt specifier */
+	tmp = of_get_property(p, "#interrupt-cells", NULL);
+	if (tmp == NULL) {
+		of_node_put(p);
+		return -EINVAL;
+	}
+	intsize = *tmp;
+
+	pr_debug(" intsize=%d intlen=%d\n", intsize, intlen);
+
+	/* Check index */
+	if ((index + 1) * intsize > intlen)
+		return -EINVAL;
+
+	/* Get new specifier and map it */
+	res = of_irq_map_raw(p, intspec + index * intsize, intsize,
+				addr, out_irq);
+	of_node_put(p);
+	return res;
+}
+EXPORT_SYMBOL_GPL(of_irq_map_one);
+
+/**
+ * Search the device tree for the best MAC address to use.  'mac-address' is
+ * checked first, because that is supposed to contain to "most recent" MAC
+ * address. If that isn't set, then 'local-mac-address' is checked next,
+ * because that is the default address.  If that isn't set, then the obsolete
+ * 'address' is checked, just in case we're using an old device tree.
+ *
+ * Note that the 'address' property is supposed to contain a virtual address of
+ * the register set, but some DTS files have redefined that property to be the
+ * MAC address.
+ *
+ * All-zero MAC addresses are rejected, because those could be properties that
+ * exist in the device tree, but were not set by U-Boot.  For example, the
+ * DTS could define 'mac-address' and 'local-mac-address', with zero MAC
+ * addresses.  Some older U-Boots only initialized 'local-mac-address'.  In
+ * this case, the real MAC is in 'local-mac-address', and 'mac-address' exists
+ * but is all zeros.
+*/
+const void *of_get_mac_address(struct device_node *np)
+{
+	struct property *pp;
+
+	pp = of_find_property(np, "mac-address", NULL);
+	if (pp && (pp->length == 6) && is_valid_ether_addr(pp->value))
+		return pp->value;
+
+	pp = of_find_property(np, "local-mac-address", NULL);
+	if (pp && (pp->length == 6) && is_valid_ether_addr(pp->value))
+		return pp->value;
+
+	pp = of_find_property(np, "address", NULL);
+	if (pp && (pp->length == 6) && is_valid_ether_addr(pp->value))
+		return pp->value;
+
+	return NULL;
+}
+EXPORT_SYMBOL(of_get_mac_address);
+
+int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
+{
+	struct of_irq out_irq;
+	int irq;
+	int res;
+
+	res = of_irq_map_one(dev, index, &out_irq);
+
+	/* Get irq for the device */
+	if (res) {
+		pr_debug("IRQ not found... code = %d", res);
+		return NO_IRQ;
+	}
+	/* Assuming single interrupt controller... */
+	irq = out_irq.specifier[0];
+
+	pr_debug("IRQ found = %d", irq);
+
+	/* Only dereference the resource if both the
+	 * resource and the irq are valid. */
+	if (r && irq != NO_IRQ) {
+		r->start = r->end = irq;
+		r->flags = IORESOURCE_IRQ;
+	}
+
+	return irq;
+}
+EXPORT_SYMBOL_GPL(of_irq_to_resource);
+
+void __iomem *of_iomap(struct device_node *np, int index)
+{
+	struct resource res;
+
+	if (of_address_to_resource(np, index, &res))
+		return NULL;
+
+	return ioremap(res.start, 1 + res.end - res.start);
+}
+EXPORT_SYMBOL(of_iomap);
-- 
1.5.5.1

