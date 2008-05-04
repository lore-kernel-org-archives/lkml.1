Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYEDNVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYEDNVs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 09:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbYEDNVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 09:21:38 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:50775 "EHLO
	seznam.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752484AbYEDNVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 09:21:32 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 04/56] microblaze_v2: Open firmware files
Date: Sun,  4 May 2008 13:40:53 +0200
Message-Id: <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/prom.c        | 1653 ++++++++++++++++++++++++++++++++++
 include/asm-microblaze/of_device.h   |   41 +
 include/asm-microblaze/of_platform.h |   45 +
 include/asm-microblaze/prom.h        |  311 +++++++
 4 files changed, 2050 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/prom.c
 create mode 100644 include/asm-microblaze/of_device.h
 create mode 100644 include/asm-microblaze/of_platform.h
 create mode 100644 include/asm-microblaze/prom.h

diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
new file mode 100644
index 0000000..7c9793a
--- /dev/null
+++ b/arch/microblaze/kernel/prom.c
@@ -0,0 +1,1653 @@
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
+#undef DEBUG
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
+#include <asm/io.h>
+#include <asm/system.h>
+#include <asm/mmu.h>
+#include <asm/pgtable.h>
+#include <asm/pci.h>
+#include <asm/sections.h>
+#include <asm/pci-bridge.h>
+
+#ifdef CONFIG_PPC_PSERIES
+#include <asm/rtas.h>
+#include <asm/kdump.h>
+#include <asm/smp.h>
+#include <asm/iommu.h>
+#include <asm/btext.h>
+#include <asm/machdep.h>
+#include <asm/pSeries_reconfig.h>
+#include <asm/phyp_dump.h>
+#include <asm/kexec.h>
+#endif
+
+static int __initdata dt_root_addr_cells;
+static int __initdata dt_root_size_cells;
+
+#ifdef CONFIG_PPC64
+int __initdata iommu_is_off;
+int __initdata iommu_force_on;
+unsigned long tce_alloc_start, tce_alloc_end;
+#endif
+
+typedef u32 cell_t;
+
+#if 0
+static struct boot_param_header *initial_boot_params __initdata;
+#else
+struct boot_param_header *initial_boot_params;
+#endif
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
+void* __init of_get_flat_dt_prop(unsigned long node, const char *name,
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
+			char *p = np->full_name;
+			/* rebuild full path for new format */
+			if (dad && dad->parent) {
+				strcpy(p, dad->full_name);
+#ifdef DEBUG
+				if ((strlen(p) + l + 1) != allocl) {
+					pr_debug("%s: p: %d, l: %d, a: %d\n",
+						pathp, (int)strlen(p),
+						l, allocl);
+				}
+#endif
+				p += strlen(p);
+			}
+			*(p++) = '/';
+			memcpy(p, pathp, l);
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
+#ifdef CONFIG_PPC_PSERIES
+static int __init early_parse_mem(char *p)
+{
+	if (!p)
+		return 1;
+
+	memory_limit = PAGE_ALIGN(memparse(p, &p));
+	pr_debug("memory limit = 0x%lx\n", memory_limit);
+
+	return 0;
+}
+early_param("mem", early_parse_mem);
+
+/**
+ * move_device_tree - move tree to an unused area, if needed.
+ *
+ * The device tree may be allocated beyond our memory limit, or inside the
+ * crash kernel region for kdump. If so, move it out of the way.
+ */
+static void __init move_device_tree(void)
+{
+	unsigned long start, size;
+	void *p;
+
+	pr_debug("-> move_device_tree\n");
+
+	start = __pa(initial_boot_params);
+	size = initial_boot_params->totalsize;
+
+	if ((memory_limit && (start + size) > memory_limit) ||
+			overlaps_crashkernel(start, size)) {
+		p = __va(lmb_alloc_base(size, PAGE_SIZE, lmb.rmo_size));
+		memcpy(p, initial_boot_params, size);
+		initial_boot_params = (struct boot_param_header *)p;
+		pr_debug("Moved device tree to 0x%p\n", p);
+	}
+
+	pr_debug("<- move_device_tree\n");
+}
+#endif
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
+#ifdef CONFIG_PPC_PSERIES
+/*
+ * ibm,pa-features is a per-cpu property that contains a string of
+ * attribute descriptors, each of which has a 2 byte header plus up
+ * to 254 bytes worth of processor attribute bits.  First header
+ * byte specifies the number of bytes following the header.
+ * Second header byte is an "attribute-specifier" type, of which
+ * zero is the only currently-defined value.
+ * Implementation:  Pass in the byte and bit offset for the feature
+ * that we are interested in.  The function will return -1 if the
+ * pa-features property is missing, or a 1/0 to indicate if the feature
+ * is supported/not supported.  Note that the bit numbers are
+ * big-endian to match the definition in PAPR.
+ */
+static struct ibm_pa_feature {
+	unsigned long	cpu_features;	/* CPU_FTR_xxx bit */
+	unsigned int	cpu_user_ftrs;	/* PPC_FEATURE_xxx bit */
+	unsigned char	pabyte;		/* byte number in ibm,pa-features */
+	unsigned char	pabit;		/* bit number (big-endian) */
+	unsigned char	invert;		/* if 1, pa bit set => clear feature */
+} ibm_pa_features[] __initdata = {
+	{0, PPC_FEATURE_HAS_MMU,	0, 0, 0},
+	{0, PPC_FEATURE_HAS_FPU,	0, 1, 0},
+	{CPU_FTR_SLB, 0,		0, 2, 0},
+	{CPU_FTR_CTRL, 0,		0, 3, 0},
+	{CPU_FTR_NOEXECUTE, 0,		0, 6, 0},
+	{CPU_FTR_NODSISRALIGN, 0,	1, 1, 1},
+	{CPU_FTR_CI_LARGE_PAGE, 0,	1, 2, 0},
+	{CPU_FTR_REAL_LE, PPC_FEATURE_TRUE_LE, 5, 0, 0},
+};
+
+static void __init scan_features(unsigned long node, unsigned char *ftrs,
+				 unsigned long tablelen,
+				 struct ibm_pa_feature *fp,
+				 unsigned long ft_size)
+{
+	unsigned long i, len, bit;
+
+	/* find descriptor with type == 0 */
+	for (;;) {
+		if (tablelen < 3)
+			return;
+		len = 2 + ftrs[0];
+		if (tablelen < len)
+			return;		/* descriptor 0 not found */
+		if (ftrs[1] == 0)
+			break;
+		tablelen -= len;
+		ftrs += len;
+	}
+
+	/* loop over bits we know about */
+	for (i = 0; i < ft_size; ++i, ++fp) {
+		if (fp->pabyte >= ftrs[0])
+			continue;
+		bit = (ftrs[2 + fp->pabyte] >> (7 - fp->pabit)) & 1;
+		if (bit ^ fp->invert) {
+			cur_cpu_spec->cpu_features |= fp->cpu_features;
+			cur_cpu_spec->cpu_user_features |= fp->cpu_user_ftrs;
+		} else {
+			cur_cpu_spec->cpu_features &= ~fp->cpu_features;
+			cur_cpu_spec->cpu_user_features &= ~fp->cpu_user_ftrs;
+		}
+	}
+}
+
+static void __init check_cpu_pa_features(unsigned long node)
+{
+	unsigned char *pa_ftrs;
+	unsigned long tablelen;
+
+	pa_ftrs = of_get_flat_dt_prop(node, "ibm,pa-features", &tablelen);
+	if (pa_ftrs == NULL)
+		return;
+
+	scan_features(node, pa_ftrs, tablelen,
+		      ibm_pa_features, ARRAY_SIZE(ibm_pa_features));
+}
+
+#ifdef CONFIG_PPC64
+static void __init check_cpu_slb_size(unsigned long node)
+{
+	u32 *slb_size_ptr;
+
+	slb_size_ptr = of_get_flat_dt_prop(node, "ibm,slb-size", NULL);
+	if (slb_size_ptr != NULL) {
+		mmu_slb_size = *slb_size_ptr;
+	}
+}
+#else
+#define check_cpu_slb_size(node) do { } while(0)
+#endif
+
+static struct feature_property {
+	const char *name;
+	u32 min_value;
+	unsigned long cpu_feature;
+	unsigned long cpu_user_ftr;
+} feature_properties[] __initdata = {
+#ifdef CONFIG_ALTIVEC
+	{"altivec", 0, CPU_FTR_ALTIVEC, PPC_FEATURE_HAS_ALTIVEC},
+	{"ibm,vmx", 1, CPU_FTR_ALTIVEC, PPC_FEATURE_HAS_ALTIVEC},
+#endif /* CONFIG_ALTIVEC */
+#ifdef CONFIG_PPC64
+	{"ibm,dfp", 1, 0, PPC_FEATURE_HAS_DFP},
+	{"ibm,purr", 1, CPU_FTR_PURR, 0},
+	{"ibm,spurr", 1, CPU_FTR_SPURR, 0},
+#endif /* CONFIG_PPC64 */
+};
+
+#if defined(CONFIG_44x) && defined(CONFIG_PPC_FPU)
+static inline void identical_pvr_fixup(unsigned long node)
+{
+	unsigned int pvr;
+	char *model = of_get_flat_dt_prop(node, "model", NULL);
+
+	/*
+	 * Since 440GR(x)/440EP(x) processors have the same pvr,
+	 * we check the node path and set bit 28 in the cur_cpu_spec
+	 * pvr for EP(x) processor version. This bit is always 0 in
+	 * the "real" pvr. Then we call identify_cpu again with
+	 * the new logical pvr to enable FPU support.
+	 */
+	if (model && strstr(model, "440EP")) {
+		pvr = cur_cpu_spec->pvr_value | 0x8;
+		identify_cpu(0, pvr);
+		DBG("Using logical pvr %x for %s\n", pvr, model);
+	}
+}
+#else
+#define identical_pvr_fixup(node) do { } while(0)
+#endif
+
+static void __init check_cpu_feature_properties(unsigned long node)
+{
+	unsigned long i;
+	struct feature_property *fp = feature_properties;
+	const u32 *prop;
+
+	for (i = 0; i < ARRAY_SIZE(feature_properties); ++i, ++fp) {
+		prop = of_get_flat_dt_prop(node, fp->name, NULL);
+		if (prop && *prop >= fp->min_value) {
+			cur_cpu_spec->cpu_features |= fp->cpu_feature;
+			cur_cpu_spec->cpu_user_features |= fp->cpu_user_ftr;
+		}
+	}
+}
+
+#endif /* CONFIG_PPC_PSERIES */
+
+static int __init early_init_dt_scan_cpus(unsigned long node,
+					  const char *uname, int depth,
+					  void *data)
+{
+	static int logical_cpuid;
+	char *type = of_get_flat_dt_prop(node, "device_type", NULL);
+#ifdef CONFIG_PPC_PSERIES
+	const u32 *prop;
+#endif
+	const u32 *intserv;
+	int i, nthreads;
+	unsigned long len;
+	int found = 0;
+
+	/* We are scanning "cpu" nodes only */
+	if (type == NULL || strcmp(type, "cpu") != 0)
+		return 0;
+
+	/* Get physical cpuid */
+	intserv = of_get_flat_dt_prop(node, "ibm,ppc-interrupt-server#s", &len);
+	if (intserv) {
+		nthreads = len / sizeof(int);
+	} else {
+		intserv = of_get_flat_dt_prop(node, "reg", NULL);
+		nthreads = 1;
+	}
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
+#ifdef CONFIG_PPC_PSERIES
+		set_hard_smp_processor_id(boot_cpuid, intserv[i]);
+
+		/*
+		 * PAPR defines "logical" PVR values for cpus that
+		 * meet various levels of the architecture:
+		 * 0x0f000001	Architecture version 2.04
+		 * 0x0f000002	Architecture version 2.05
+		 * If the cpu-version property in the cpu node contains
+		 * such a value, we call identify_cpu again with the
+		 * logical PVR value in order to use the cpu feature
+		 * bits appropriate for the architecture level.
+		 *
+		 * A POWER6 partition in "POWER6 architected" mode
+		 * uses the 0x0f000002 PVR value; in POWER5+ mode
+		 * it uses 0x0f000001.
+		 */
+		prop = of_get_flat_dt_prop(node, "cpu-version", NULL);
+		if (prop && (*prop & 0xff000000) == 0x0f000000)
+			identify_cpu(0, *prop);
+
+		identical_pvr_fixup(node);
+#endif
+	}
+
+#ifdef CONFIG_PPC_PSERIES
+	check_cpu_feature_properties(node);
+	check_cpu_pa_features(node);
+	check_cpu_slb_size(node);
+
+	if (nthreads > 1)
+		cur_cpu_spec->cpu_features |= CPU_FTR_SMT;
+	else
+		cur_cpu_spec->cpu_features &= ~CPU_FTR_SMT;
+#endif
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
+#ifdef CONFIG_PPC64
+	/* check if iommu is forced on or off */
+	if (of_get_flat_dt_prop(node, "linux,iommu-off", NULL) != NULL)
+		iommu_is_off = 1;
+	if (of_get_flat_dt_prop(node, "linux,iommu-force-on", NULL) != NULL)
+		iommu_force_on = 1;
+#endif
+
+#ifdef CONFIG_PPC_PSERIES
+	/* mem=x on the command line is the preferred mechanism */
+	lprop = of_get_flat_dt_prop(node, "linux,memory-limit", NULL);
+	if (lprop)
+		memory_limit = *lprop;
+#endif
+
+#ifdef CONFIG_PPC64
+	lprop = of_get_flat_dt_prop(node, "linux,tce-alloc-start", NULL);
+	if (lprop)
+		tce_alloc_start = *lprop;
+	lprop = of_get_flat_dt_prop(node, "linux,tce-alloc-end", NULL);
+	if (lprop)
+		tce_alloc_end = *lprop;
+#endif
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
+#ifdef CONFIG_PPC_PSERIES
+/*
+ * Interpret the ibm,dynamic-memory property in the
+ * /ibm,dynamic-reconfiguration-memory node.
+ * This contains a list of memory blocks along with NUMA affinity
+ * information.
+ */
+static int __init early_init_dt_scan_drconf_memory(unsigned long node)
+{
+	cell_t *dm, *ls;
+	unsigned long l, n, flags;
+	u64 base, size, lmb_size;
+
+	ls = (cell_t *)of_get_flat_dt_prop(node, "ibm,lmb-size", &l);
+	if (ls == NULL || l < dt_root_size_cells * sizeof(cell_t))
+		return 0;
+	lmb_size = dt_mem_next_cell(dt_root_size_cells, &ls);
+
+	dm = (cell_t *)of_get_flat_dt_prop(node, "ibm,dynamic-memory", &l);
+	if (dm == NULL || l < sizeof(cell_t))
+		return 0;
+
+	n = *dm++;	/* number of entries */
+	if (l < (n * (dt_root_addr_cells + 4) + 1) * sizeof(cell_t))
+		return 0;
+
+	for (; n != 0; --n) {
+		base = dt_mem_next_cell(dt_root_addr_cells, &dm);
+		flags = dm[3];
+		/* skip DRC index, pad, assoc. list index, flags */
+		dm += 4;
+		/* skip this block if the reserved bit is set in flags (0x80)
+		   or if the block is not assigned to this partition (0x8) */
+		if ((flags & 0x80) || !(flags & 0x8))
+			continue;
+		size = lmb_size;
+		if (iommu_is_off) {
+			if (base >= 0x80000000ul)
+				continue;
+			if ((base + size) > 0x80000000ul)
+				size = 0x80000000ul - base;
+		}
+		lmb_add(base, size);
+	}
+	lmb_dump_all();
+	return 0;
+}
+#else
+#define early_init_dt_scan_drconf_memory(node)	0
+#endif /* CONFIG_PPC_PSERIES */
+
+static int __init early_init_dt_scan_memory(unsigned long node,
+				const char *uname, int depth, void *data)
+{
+	char *type = of_get_flat_dt_prop(node, "device_type", NULL);
+	cell_t *reg, *endp;
+	unsigned long l;
+
+	/* Look for the ibm,dynamic-reconfiguration-memory node */
+	if (depth == 1 &&
+		strcmp(uname, "ibm,dynamic-reconfiguration-memory") == 0)
+		return early_init_dt_scan_drconf_memory(node);
+
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
+#ifdef CONFIG_PPC64
+		if (iommu_is_off) {
+			if (base >= 0x80000000ul)
+				continue;
+			if ((base + size) > 0x80000000ul)
+				size = 0x80000000ul - base;
+		}
+#endif
+		lmb_add(base, size);
+	}
+	return 0;
+}
+
+#ifdef CONFIG_PPC_PSERIES
+static void __init early_reserve_mem(void)
+{
+	u64 base, size;
+	u64 *reserve_map;
+	unsigned long self_base;
+	unsigned long self_size;
+
+	reserve_map = (u64 *)(((unsigned long)initial_boot_params) +
+					initial_boot_params->off_mem_rsvmap);
+
+	/* before we do anything, lets reserve the dt blob */
+	self_base = __pa((unsigned long)initial_boot_params);
+	self_size = initial_boot_params->totalsize;
+	lmb_reserve(self_base, self_size);
+
+#ifdef CONFIG_BLK_DEV_INITRD
+	/* then reserve the initrd, if any */
+	if (initrd_start && (initrd_end > initrd_start))
+		lmb_reserve(__pa(initrd_start), initrd_end - initrd_start);
+#endif /* CONFIG_BLK_DEV_INITRD */
+
+#ifdef CONFIG_PPC32
+	/*
+	 * Handle the case where we might be booting from an old kexec
+	 * image that setup the mem_rsvmap as pairs of 32-bit values
+	 */
+	if (*reserve_map > 0xffffffffull) {
+		u32 base_32, size_32;
+		u32 *reserve_map_32 = (u32 *)reserve_map;
+
+		while (1) {
+			base_32 = *(reserve_map_32++);
+			size_32 = *(reserve_map_32++);
+			if (size_32 == 0)
+				break;
+			/* skip if the reservation is for the blob */
+			if (base_32 == self_base && size_32 == self_size)
+				continue;
+			pr_debug("reserving: %x -> %x\n", base_32, size_32);
+			lmb_reserve(base_32, size_32);
+		}
+		return;
+	}
+#endif
+	while (1) {
+		base = *(reserve_map++);
+		size = *(reserve_map++);
+		if (size == 0)
+			break;
+		pr_debug("reserving: %llx -> %llx\n", base, size);
+		lmb_reserve(base, size);
+	}
+
+#if 0
+	pr_debug("memory reserved, lmbs :\n");
+	lmb_dump_all();
+#endif
+}
+#endif
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
+void __init early_init_devtree(void *params)
+{
+	pr_debug(" -> early_init_devtree(%p)\n", params);
+
+	/* Setup flat device-tree pointer */
+	initial_boot_params = params;
+
+#ifdef CONFIG_PPC_RTAS
+	/* Some machines might need RTAS info for debugging, grab it now. */
+	of_scan_flat_dt(early_init_dt_scan_rtas, NULL);
+#endif
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
+#ifdef CONFIG_PPC_PSERIES
+	/* Reserve LMB regions used by kernel, initrd, dt, etc... */
+	lmb_reserve(PHYSICAL_START, __pa(klimit) - PHYSICAL_START);
+	reserve_kdump_trampoline();
+	reserve_crashkernel();
+	early_reserve_mem();
+	phyp_dump_reserve_mem();
+
+	lmb_enforce_memory_limit(memory_limit);
+#endif
+
+	lmb_analyze();
+
+	pr_debug("Phys. mem: %lx\n", lmb_phys_mem_size());
+
+#ifdef CONFIG_PPC_PSERIES
+	/* We may need to relocate the flat tree, do it now.
+	 * FIXME .. and the initrd too? */
+	move_device_tree();
+#endif
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
+	for (np = allnodes; np != 0; np = np->allnext)
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
+	for (; np != 0; np = np->allnext)
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
+#ifdef CONFIG_PPC_PSERIES
+/*
+ * Fix up the uninitialized fields in a new device node:
+ * name, type and pci-specific fields
+ */
+
+static int of_finish_dynamic_node(struct device_node *node)
+{
+	struct device_node *parent = of_get_parent(node);
+	int err = 0;
+	const phandle *ibm_phandle;
+
+	node->name = of_get_property(node, "name", NULL);
+	node->type = of_get_property(node, "device_type", NULL);
+
+	if (!node->name)
+		node->name = "<NULL>";
+	if (!node->type)
+		node->type = "<NULL>";
+
+	if (!parent) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	/* We don't support that function on PowerMac, at least
+	 * not yet
+	 */
+	if (machine_is(powermac))
+		return -ENODEV;
+
+	/* fix up new node's linux_phandle field */
+	if ((ibm_phandle = of_get_property(node, "ibm,phandle", NULL)))
+		node->linux_phandle = *ibm_phandle;
+
+out:
+	of_node_put(parent);
+	return err;
+}
+
+static int prom_reconfig_notifier(struct notifier_block *nb,
+				  unsigned long action, void *node)
+{
+	int err;
+
+	switch (action) {
+	case PSERIES_RECONFIG_ADD:
+		err = of_finish_dynamic_node(node);
+		if (err < 0) {
+			printk(KERN_ERR "finish_node returned %d\n", err);
+			err = NOTIFY_BAD;
+		}
+		break;
+	default:
+		err = NOTIFY_DONE;
+		break;
+	}
+	return err;
+}
+
+static struct notifier_block prom_reconfig_nb = {
+	.notifier_call = prom_reconfig_notifier,
+	.priority = 10, /* This one needs to run first */
+};
+
+static int __init prom_reconfig_setup(void)
+{
+	return pSeries_reconfig_notifier_register(&prom_reconfig_nb);
+}
+__initcall(prom_reconfig_setup);
+#endif
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
+/* Find the device node for a given logical cpu number, also returns the cpu
+ * local thread number (index in ibm,interrupt-server#s) if relevant and
+ * asked for (non NULL)
+ */
+struct device_node *of_get_cpu_node(int cpu, unsigned int *thread)
+{
+	int hardid;
+	struct device_node *np;
+
+	hardid = boot_cpuid; /* get_hard_smp_processor_id(cpu);*/
+
+	for_each_node_by_type(np, "cpu") {
+		const u32 *intserv;
+		unsigned int plen, t;
+
+		/* Check for ibm,ppc-interrupt-server#s. If it doesn't exist
+		 * fallback to "reg" property and assume no threads
+		 */
+		intserv = of_get_property(np, "ibm,ppc-interrupt-server#s",
+				&plen);
+		if (intserv == NULL) {
+			const u32 *reg = of_get_property(np, "reg", NULL);
+			if (reg == NULL)
+				continue;
+			if (*reg == hardid) {
+				if (thread)
+					*thread = 0;
+				return np;
+			}
+		} else {
+			plen /= sizeof(u32);
+			for (t = 0; t < plen; t++) {
+				if (hardid == intserv[t]) {
+					if (thread)
+						*thread = t;
+					return np;
+				}
+			}
+		}
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(of_get_cpu_node);
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
+__initcall(export_flat_device_tree);
+#endif
diff --git a/include/asm-microblaze/of_device.h b/include/asm-microblaze/of_device.h
new file mode 100644
index 0000000..5a324cf
--- /dev/null
+++ b/include/asm-microblaze/of_device.h
@@ -0,0 +1,41 @@
+/*
+ * include/asm-microblaze/of_device.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
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
+extern struct of_device *of_device_alloc(struct device_node *np,
+					 const char *bus_id,
+					 struct device *parent);
+
+extern ssize_t of_device_get_modalias(struct of_device *ofdev,
+					char *str, ssize_t len);
+extern int of_device_uevent(struct device *dev,
+			    struct kobj_uevent_env *env);
+
+/* This is just here during the transition */
+#include <linux/of_device.h>
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_MICROBLAZE_OF_DEVICE_H */
diff --git a/include/asm-microblaze/of_platform.h b/include/asm-microblaze/of_platform.h
new file mode 100644
index 0000000..9c6f8cc
--- /dev/null
+++ b/include/asm-microblaze/of_platform.h
@@ -0,0 +1,45 @@
+/*
+ * include/asm-microblaze/of_platform.h
+ *
+ * Copyright (C) 2006 Benjamin Herrenschmidt, IBM Corp.
+ *			<benh@kernel.crashing.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ */
+
+#ifndef _ASM_MICROBLAZE_OF_PLATFORM_H
+#define _ASM_MICROBLAZE_OF_PLATFORM_H
+
+/* This is just here during the transition */
+#include <linux/of_platform.h>
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
diff --git a/include/asm-microblaze/prom.h b/include/asm-microblaze/prom.h
new file mode 100644
index 0000000..2f439b4
--- /dev/null
+++ b/include/asm-microblaze/prom.h
@@ -0,0 +1,311 @@
+/*
+ * include/asm-microblaze/prom.h
+ *
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
-- 
1.5.4.GIT

