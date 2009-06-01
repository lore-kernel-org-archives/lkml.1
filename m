Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbZFAKh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbZFAKh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbZFAKhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:37:17 -0400
Received: from mail119.messagelabs.com ([216.82.241.195]:42050 "EHLO
	mail119.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423AbZFAKhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:37:15 -0400
X-VirusChecked: Checked
X-Env-Sender: yuan-bo.ye@motorola.com
X-Msg-Ref: server-2.tower-119.messagelabs.com!1243852635!31712771!1
X-StarScan-Version: 6.0.0; banners=-,-,-
X-Originating-IP: [136.182.1.15]
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Janboe Ye <yuan-bo.ye@motorola.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       jwboyer@linux.vnet.ibm.com, grant.likely@secretlab.ca, paulus@samba.org
In-Reply-To: <20090531100843.GB18650@n2100.arm.linux.org.uk>
References: <1243408083.13460.14.camel@debian-nb>
	 <20090531100843.GB18650@n2100.arm.linux.org.uk>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 01 Jun 2009 18:36:44 +0800
Message-Id: <1243852604.4439.25.camel@debian-nb>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, Russell

Thank you for comments.

I update my patch according to your comments except one comments.


> diff --git a/arch/arm/kernel/prom.c b/arch/arm/kernel/prom.c
> > new file mode 100644
> > index 0000000..9d1c835
> > --- /dev/null
> > +++ b/arch/arm/kernel/prom.c
> > @@ -0,0 +1,414 @@
> > +/*
> > + * Procedures for creating, accessing and interpreting the device tree.
> 
> Again, we don't have a PROM, but maybe this file is just misnamed.  Is
> there a better name for it?
> 
the file named as prom.[ch] is because the main codes are from PPC's prom code, and fs/proc/proc_devicetree.c also include prom.h directly.

Changelogs:
1 remove of_platform and of_device support function declaration. Maybe of_platform and of_device could be added later.
2 clean up functions declaration which is used boottime in prom.h which is not needed now. It could be added if some information need to be setup before paging_init. 
3 put OF configuration in kernel feature menu

Signed-off-by: janboe <yuan-bo.ye@motorola.com>

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index f430e15..b6a0dfd 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -915,6 +915,17 @@ config NODES_SHIFT
 	default "2"
 	depends on NEED_MULTIPLE_NODES
 
+config OF
+        bool "Support for device tree"
+
+config PROC_DEVICETREE
+        bool "Support for device tree in /proc"
+        depends on PROC_FS && OF
+        help
+          This option adds a device-tree directory under /proc which contains
+          an image of the device tree that the kernel copies from Open
+          Firmware or other boot firmware. If unsure, say Y here.
+
 source "mm/Kconfig"
 
 config LEDS
diff --git a/arch/arm/include/asm/prom.h b/arch/arm/include/asm/prom.h
new file mode 100644
index 0000000..5949d7d
--- /dev/null
+++ b/arch/arm/include/asm/prom.h
@@ -0,0 +1,142 @@
+#ifndef _ARM_PROM_H
+#define _ARM_PROM_H
+#ifdef __KERNEL__
+
+/*
+ * Copyright (C) 1996-2005 Paul Mackerras.
+ *
+ * Updates for PPC64 by Peter Bergner & David Engebretsen, IBM Corp.
+ *
+ * Updates for ARM by Motorola Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/types.h>
+#include <linux/proc_fs.h>
+#include <linux/platform_device.h>
+
+#define OF_ROOT_NODE_ADDR_CELLS_DEFAULT	1
+#define OF_ROOT_NODE_SIZE_CELLS_DEFAULT	1
+
+#define of_compat_cmp(s1, s2, l)	strcasecmp((s1), (s2))
+#define of_prop_cmp(s1, s2)		strcmp((s1), (s2))
+#define of_node_cmp(s1, s2)		strcasecmp((s1), (s2))
+
+/* Definitions used by the flattened device tree */
+#define OF_DT_HEADER		0xd00dfeed	/* marker */
+#define OF_DT_BEGIN_NODE	0x1		/* Start of node, full name */
+#define OF_DT_END_NODE		0x2		/* End node */
+#define OF_DT_PROP		0x3		/* Property: name off, size,
+						 * content */
+#define OF_DT_NOP		0x4		/* nop */
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
+	u32	magic;			/* magic word OF_DT_HEADER */
+	u32	totalsize;		/* total size of DT block */
+	u32	off_dt_struct;		/* offset to structure */
+	u32	off_dt_strings;		/* offset to strings */
+	u32	off_mem_rsvmap;		/* offset to memory reserve map */
+	u32	version;		/* format version */
+	u32	last_comp_version;	/* last compatible version */
+	/* version 2 fields below */
+	u32	boot_cpuid_phys;	/* Physical CPU id we're booting on */
+	/* version 3 fields below */
+	u32	dt_strings_size;	/* size of the DT strings block */
+	/* version 17 fields below */
+	u32	dt_struct_size;		/* size of the DT structure block */
+};
+
+
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
+	struct  property *deadprops; /* removed properties */
+	struct	device_node *parent;
+	struct	device_node *child;
+	struct	device_node *sibling;
+	struct	device_node *next;	/* next device of same type */
+	struct	device_node *allnext;	/* next in list of all nodes */
+	struct  proc_dir_entry *pde;	/* this node's proc directory */
+	struct  kref kref;
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
+
+#define HAVE_ARCH_DEVTREE_FIXUPS
+
+static inline void set_node_proc_entry(struct device_node *dn,
+					struct proc_dir_entry *de)
+{
+	dn->pde = de;
+}
+
+extern struct device_node *of_node_get(struct device_node *node);
+extern void of_node_put(struct device_node *node);
+
+/* Other Prototypes */
+extern void unflatten_device_tree(void);
+
+/*
+ * NB:  This is here while we transition from using asm/prom.h
+ * to linux/of.h
+ */
+#include <linux/of.h>
+
+/* align addr on a size boundary - adjust address up/down if needed */
+#define _ALIGN_UP(addr, size)	(((addr) + ((size) - 1)) & (~((size) - 1)))
+#define _ALIGN_DOWN(addr, size)	((addr) & (~((size) - 1)))
+
+/* align addr on a size boundary - adjust address up if needed */
+#define _ALIGN(addr, size)     _ALIGN_UP(addr, size)
+
+#endif /* __KERNEL__ */
+#endif /* _ARM_PROM_H */
diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index 7ffbb29..8d9f4bd 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -150,6 +150,13 @@ struct tag_memclk {
 	__u32 fmemclk;
 };
 
+/* Flat dev tree address */
+#define ATAG_FLAT_DEV_TREE_ADDRESS 0x5441000A
+struct tag_flat_dev_tree_address {
+	u32 address;
+	u32 size;
+};
+
 struct tag {
 	struct tag_header hdr;
 	union {
@@ -177,6 +184,7 @@ struct tag {
 		 * DC21285 specific
 		 */
 		struct tag_memclk	memclk;
+		struct tag_flat_dev_tree_address flat_dev_tree;
 	} u;
 };
 
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 4305345..adbdd3b 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_ATAGS_PROC)	+= atags.o
 obj-$(CONFIG_OABI_COMPAT)	+= sys_oabi-compat.o
 obj-$(CONFIG_ARM_THUMBEE)	+= thumbee.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
+obj-$(CONFIG_OF)		+= prom.o
 
 obj-$(CONFIG_CRUNCH)		+= crunch.o crunch-bits.o
 AFLAGS_crunch-bits.o		:= -Wa,-mcpu=ep9312
diff --git a/arch/arm/kernel/prom.c b/arch/arm/kernel/prom.c
new file mode 100644
index 0000000..03d5e4c
--- /dev/null
+++ b/arch/arm/kernel/prom.c
@@ -0,0 +1,402 @@
+/*
+ * Procedures for creating, accessing and interpreting the device tree.
+ *
+ * Paul Mackerras       August 1996.
+ * Copyright (C) 1996-2005 Paul Mackerras.
+ *
+ *  Adapted for 64bit PowerPC by Dave Engebretsen and Peter Bergner.
+ *    {engebret|bergner}@us.ibm.com
+ *
+ *  Adapted for ARM by Motorola Inc.
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
+#include <linux/bootmem.h>
+#include <linux/kexec.h>
+#include <linux/debugfs.h>
+#include <linux/irq.h>
+#include <asm/prom.h>
+#include <asm/setup.h>
+#include <asm/memory.h>
+#ifdef DEBUG
+#define DBG(fmt...) printk(KERN_ERR fmt)
+#else
+#define DBG(fmt...)
+#endif
+
+static struct boot_param_header *initial_boot_params;
+
+extern struct device_node *allnodes;	/* temporary while merging */
+
+extern rwlock_t devtree_lock;	/* temporary while merging */
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
+static void *__init unflatten_dt_alloc(unsigned long *mem, unsigned long size,
+				       unsigned long align)
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
+					      unsigned long *p,
+					      struct device_node *dad,
+					      struct device_node ***allnextpp,
+					      unsigned long fpsize)
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
+
+	np = unflatten_dt_alloc(&mem, sizeof(struct device_node) + allocl,
+				__alignof__(struct device_node));
+	if (allnextpp) {
+		memset(np, 0, sizeof(*np));
+		np->full_name = ((char *)np) + sizeof(struct device_node);
+		if (new_format) {
+			int n = scnprintf(np->full_name, allocl, "%s/%s",
+                                dad && dad->parent ? dad->full_name : "",
+                                pathp);
+#ifdef DEBUG
+			if (n != allocl) {
+				DBG("%s: p: %d, l: %d, a: %d\n",
+				    pathp, (int)strlen(p), l, allocl);
+			}
+#endif
+		} else
+			memcpy(np->full_name, pathp, l);
+		prev_pp = &np->properties;
+		**allnextpp = np;
+		*allnextpp = &np->allnext;
+		if (dad != NULL) {
+			np->parent = dad;
+			/* we temporarily use the next field as `last_child'*/
+			if (dad->next == 0)
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
+			printk(KERN_INFO "Can't find property name in list!\n");
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
+		char *p = pathp, *ps = pathp, *pa = NULL;
+		int sz;
+
+		while (*p) {
+			if ((*p) == '@')
+				pa = p;
+			if ((*p) == '/')
+				ps = p + 1;
+			p++;
+		}
+		if (pa < ps)
+			pa = p;
+		sz = (pa - ps) + 1;
+		pp = unflatten_dt_alloc(&mem, sizeof(struct property) + sz,
+					__alignof__(struct property));
+		if (allnextpp) {
+			pp->name = "name";
+			pp->length = sz;
+			pp->value = pp + 1;
+			*prev_pp = pp;
+			prev_pp = &pp->next;
+			strlcpy(pp->value, ps, sz);
+			DBG("fixed up name for %s -> %s\n", pathp,
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
+	unsigned long start, size;
+	void *mem;
+	u32 *mem_endmarker;
+	struct device_node **allnextp = &allnodes;
+
+	DBG(" -> unflatten_device_tree()\n");
+	if (!initial_boot_params)
+		return;
+	/* First pass, scan for size */
+	start = ((unsigned long)initial_boot_params) +
+		initial_boot_params->off_dt_struct;
+	size = unflatten_dt_node(0, &start, NULL, NULL, 0);
+	size = ALIGN(size, __alignof__(u32));
+
+	DBG("  size is %lx, allocating...\n", size);
+
+	/* Allocate memory for the expanded device tree */
+	mem = __alloc_bootmem(size + sizeof(u32),
+			__alignof__(struct device_node), 0);
+	mem_endmarker = mem + size;
+	*mem_endmarker = 0xdeadbeef;
+
+	DBG("  unflattening %lx...\n", mem);
+
+	/* Second pass, do actual unflattening */
+	start = ((unsigned long)initial_boot_params) +
+		initial_boot_params->off_dt_struct;
+	unflatten_dt_node((unsigned long)mem, &start, NULL, &allnextp, 0);
+	if (*((u32 *)start) != OF_DT_END)
+		printk(KERN_WARNING "Weird tag at end of tree: %08x\n",
+			*((u32 *)start));
+	if (*mem_endmarker != 0xdeadbeef)
+		printk(KERN_WARNING "End of tree marker overwritten: %08x\n",
+		       *mem_endmarker);
+	*allnextp = NULL;
+
+	/* Get pointer to OF "/chosen" node for use everywhere */
+	of_chosen = of_find_node_by_path("/chosen");
+	if (of_chosen == NULL)
+		of_chosen = of_find_node_by_path("/chosen@0");
+
+	DBG(" <- unflatten_device_tree()\n");
+}
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
+	for (np = allnodes; np != 0; np = np->allnext)
+		if (np->linux_phandle == handle)
+			break;
+	of_node_get(np);
+	read_unlock(&devtree_lock);
+	return np;
+}
+EXPORT_SYMBOL(of_find_node_by_phandle);
+
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
+		printk(KERN_WARNING "WARNING: Bad of_node_put() on %s\n",
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
+int have_of;
+
+/* process flat device tree for hardware configuration */
+static int __init parse_tag_flat_dev_tree_address(const struct tag *tag)
+{
+    if (tag->u.flat_dev_tree.size)
+	initial_boot_params = phys_to_virt(tag->u.flat_dev_tree.address);
+
+    have_of = 1;
+    printk(KERN_INFO
+	"flat_dev_tree_address=0x%08x, flat_dev_tree_size == 0x%08X\n",
+	tag->u.flat_dev_tree.address,
+	tag->u.flat_dev_tree.size);
+
+    return 0;
+}
+
+__tagtable(ATAG_FLAT_DEV_TREE_ADDRESS, parse_tag_flat_dev_tree_address);
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 68d6494..5f163b5 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -35,6 +35,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cachetype.h>
 #include <asm/tlbflush.h>
+#include <asm/prom.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/irq.h>
@@ -725,6 +726,9 @@ void __init setup_arch(char **cmdline_p)
 	boot_command_line[COMMAND_LINE_SIZE-1] = '\0';
 	parse_cmdline(cmdline_p, from);
 	paging_init(mdesc);
+#ifdef CONFIG_OF
+	unflatten_device_tree();
+#endif
 	request_standard_resources(&meminfo, mdesc);
 
 #ifdef CONFIG_SMP
