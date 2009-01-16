Return-Path: <linux-kernel-owner+w=401wt.eu-S1764285AbZAPIiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764285AbZAPIiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758980AbZAPIhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:37:37 -0500
Received: from smtp.nokia.com ([192.100.122.230]:30851 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbZAPIhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:37:33 -0500
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH 1/6] omap iommu: tlb and pagetable primitives
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org
Date: Fri, 16 Jan 2009 10:37:09 +0200
Message-ID: <20090116083709.18344.74524.stgit@oreo.research.nokia.com>
In-Reply-To: <20090116083003.18344.38307.stgit@oreo.research.nokia.com>
References: <20090116083003.18344.38307.stgit@oreo.research.nokia.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 08:37:11.0182 (UTC) FILETIME=[9FE01AE0:01C977B5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides:

- iotlb_*()     : iommu tlb operations
- iopgtable_*() : iommu pagetable(twl) operations
- iommu_*()     : the other generic operations

and the entry points to register and acquire iommu object.

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---

 arch/arm/plat-omap/include/mach/iommu.h |  157 +++++
 arch/arm/plat-omap/iommu.c              |  913 +++++++++++++++++++++++++++++++
 arch/arm/plat-omap/iopgtable.h          |   72 ++
 3 files changed, 1142 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-omap/include/mach/iommu.h
 create mode 100644 arch/arm/plat-omap/iommu.c
 create mode 100644 arch/arm/plat-omap/iopgtable.h

diff --git a/arch/arm/plat-omap/include/mach/iommu.h b/arch/arm/plat-omap/include/mach/iommu.h
new file mode 100644
index 0000000..8bd5c58
--- /dev/null
+++ b/arch/arm/plat-omap/include/mach/iommu.h
@@ -0,0 +1,157 @@
+/*
+ * omap iommu: main structures
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Written by Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __MACH_IOMMU_H
+#define __MACH_IOMMU_H
+
+struct iotlb_entry {
+	u32 da;
+	u32 pa;
+	u32 pgsz, prsvd, valid;
+	union {
+		u16 ap;
+		struct {
+			u32 endian, elsz, mixed;
+		};
+	};
+};
+
+struct iommu {
+	const char	*name;
+	struct module	*owner;
+	struct clk	*clk;
+	void __iomem	*regbase;
+	struct device	*dev;
+
+	unsigned int	refcount;
+	struct mutex	iommu_lock;	/* global for this whole object */
+
+	/*
+	 * We don't change iopgd for a situation like pgd for a task,
+	 * but share it globally for each iommu.
+	 */
+	u32		*iopgd;
+	spinlock_t	page_table_lock; /* protect iopgd */
+
+	int		nr_tlb_entries;
+
+	struct list_head	mmap;
+	struct mutex		mmap_lock; /* protect mmap */
+
+	int (*isr)(struct iommu *obj);
+
+	void *ctx; /* iommu context: registres saved area */
+};
+
+struct cr_regs {
+	union {
+		struct {
+			u16 cam_l;
+			u16 cam_h;
+		};
+		u32 cam;
+	};
+	union {
+		struct {
+			u16 ram_l;
+			u16 ram_h;
+		};
+		u32 ram;
+	};
+};
+
+struct iotlb_lock {
+	short base;
+	short vict;
+};
+
+/* architecture specific functions */
+struct iommu_functions {
+	unsigned long	version;
+
+	int (*enable)(struct iommu *obj);
+	void (*disable)(struct iommu *obj);
+	u32 (*fault_isr)(struct iommu *obj, u32 *ra);
+
+	void (*tlb_read_cr)(struct iommu *obj, struct cr_regs *cr);
+	void (*tlb_load_cr)(struct iommu *obj, struct cr_regs *cr);
+
+	struct cr_regs *(*alloc_cr)(struct iommu *obj, struct iotlb_entry *e);
+	int (*cr_valid)(struct cr_regs *cr);
+	u32 (*cr_to_virt)(struct cr_regs *cr);
+	void (*cr_to_e)(struct cr_regs *cr, struct iotlb_entry *e);
+	ssize_t (*dump_cr)(struct iommu *obj, struct cr_regs *cr, char *buf);
+
+	u32 (*get_pte_attr)(struct iotlb_entry *e);
+
+	void (*save_ctx)(struct iommu *obj);
+	void (*restore_ctx)(struct iommu *obj);
+	ssize_t (*dump_ctx)(struct iommu *obj, char *buf);
+};
+
+struct iommu_platform_data {
+	char	*name;
+	char	*clk_name;
+	int	nr_tlb_entries;
+};
+
+#include <mach/iommu2.h>
+
+/*
+ * utilities for super page(16MB, 1MB, 64KB and 4KB)
+ */
+
+#define iopgsz_max(bytes)			\
+	(((bytes) >= SZ_16M) ? SZ_16M :		\
+	 ((bytes) >= SZ_1M)  ? SZ_1M  :		\
+	 ((bytes) >= SZ_64K) ? SZ_64K :		\
+	 ((bytes) >= SZ_4K)  ? SZ_4K  :	0)
+
+#define bytes_to_iopgsz(bytes)				\
+	(((bytes) == SZ_16M) ? MMU_CAM_PGSZ_16M :	\
+	 ((bytes) == SZ_1M)  ? MMU_CAM_PGSZ_1M  :	\
+	 ((bytes) == SZ_64K) ? MMU_CAM_PGSZ_64K :	\
+	 ((bytes) == SZ_4K)  ? MMU_CAM_PGSZ_4K  : -1)
+
+#define iopgsz_to_bytes(iopgsz)				\
+	(((iopgsz) == MMU_CAM_PGSZ_16M)	? SZ_16M :	\
+	 ((iopgsz) == MMU_CAM_PGSZ_1M)	? SZ_1M  :	\
+	 ((iopgsz) == MMU_CAM_PGSZ_64K)	? SZ_64K :	\
+	 ((iopgsz) == MMU_CAM_PGSZ_4K)	? SZ_4K  : 0)
+
+#define iopgsz_ok(bytes) (bytes_to_iopgsz(bytes) >= 0)
+
+/*
+ * global functions
+ */
+extern u32 iommu_arch_version(void);
+
+extern int load_iotlb_entry(struct iommu *obj, struct iotlb_entry *e);
+extern void flush_iotlb_page(struct iommu *obj, u32 da);
+extern void flush_iotlb_range(struct iommu *obj, u32 start, u32 end);
+extern void flush_iotlb_all(struct iommu *obj);
+
+ssize_t iotlb_dump_cr(struct iommu *obj, struct cr_regs *cr, char *buf);
+
+extern int iopgtable_store_entry(struct iommu *obj, struct iotlb_entry *e);
+extern size_t iopgtable_clear_entry(struct iommu *obj, u32 iova);
+
+extern struct iommu *iommu_get(const char *name);
+extern void iommu_put(struct iommu *obj);
+
+extern void iommu_save_ctx(struct iommu *obj);
+extern void iommu_restore_ctx(struct iommu *obj);
+
+extern int install_iommu_arch(const struct iommu_functions *ops);
+extern void uninstall_iommu_arch(const struct iommu_functions *ops);
+
+#endif /* __MACH_IOMMU_H */
diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
new file mode 100644
index 0000000..986afbb
--- /dev/null
+++ b/arch/arm/plat-omap/iommu.c
@@ -0,0 +1,913 @@
+/*
+ * omap iommu: tlb and pagetable primitives
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Written by Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
+ *		Paul Mundt and Toshihiro Kobayashi
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+
+#include <asm/cacheflush.h>
+
+#include <mach/clock.h>
+#include <mach/iommu.h>
+
+#include "iopgtable.h"
+
+#define DRV_NAME "omap-iommu"
+
+/* accommodate the difference between omap1 and omap2/3 */
+static const struct iommu_functions *arch_iommu;
+
+static struct platform_driver omap_iommu_driver;
+static struct kmem_cache *iopte_cachep;
+
+int install_iommu_arch(const struct iommu_functions *ops)
+{
+	if (arch_iommu)
+		return -EBUSY;
+
+	arch_iommu = ops;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(install_iommu_arch);
+
+void uninstall_iommu_arch(const struct iommu_functions *ops)
+{
+	if (arch_iommu != ops)
+		pr_err("%s:\tnot your arch\n", __func__);
+
+	arch_iommu = NULL;
+}
+EXPORT_SYMBOL_GPL(uninstall_iommu_arch);
+
+void iommu_save_ctx(struct iommu *obj)
+{
+	arch_iommu->save_ctx(obj);
+}
+EXPORT_SYMBOL_GPL(iommu_save_ctx);
+
+void iommu_restore_ctx(struct iommu *obj)
+{
+	arch_iommu->restore_ctx(obj);
+}
+EXPORT_SYMBOL_GPL(iommu_restore_ctx);
+
+u32 iommu_arch_version(void)
+{
+	return arch_iommu->version;
+}
+EXPORT_SYMBOL_GPL(iommu_arch_version);
+
+static int iommu_enable(struct iommu *obj)
+{
+	int err;
+
+	BUG_ON(!arch_iommu || !arch_iommu->enable);
+
+	if (!obj)
+		return -EINVAL;
+
+	clk_enable(obj->clk);
+
+	err = arch_iommu->enable(obj);
+
+	clk_disable(obj->clk);
+	return err;
+}
+
+static void iommu_disable(struct iommu *obj)
+{
+	BUG_ON(!arch_iommu || !arch_iommu->disable);
+
+	if (!obj)
+		return;
+
+	clk_enable(obj->clk);
+
+	arch_iommu->disable(obj);
+
+	clk_disable(obj->clk);
+}
+
+#ifdef DEBUG
+static ssize_t iommu_dump_ctx(struct iommu *obj, char *buf)
+{
+	BUG_ON(!arch_iommu || !arch_iommu->dump_ctx);
+
+	if (!obj || !buf)
+		return -EINVAL;
+
+	return arch_iommu->dump_ctx(obj, buf);
+}
+#endif
+
+/*
+ *	TLB operations
+ */
+static inline void iotlb_cr_to_e(struct cr_regs *cr, struct iotlb_entry *e)
+{
+	BUG_ON(!arch_iommu || !arch_iommu->cr_to_e || !cr || !e);
+
+	arch_iommu->cr_to_e(cr, e);
+}
+
+static inline int iotlb_cr_valid(struct cr_regs *cr)
+{
+	BUG_ON(!arch_iommu || !arch_iommu->cr_valid);
+
+	if (!cr)
+		return -EINVAL;
+
+	return arch_iommu->cr_valid(cr);
+}
+
+static inline struct cr_regs *iotlb_alloc_cr(struct iommu *obj,
+					     struct iotlb_entry *e)
+{
+	BUG_ON(!arch_iommu || !arch_iommu->alloc_cr);
+
+	if (!e)
+		return NULL;
+
+	return arch_iommu->alloc_cr(obj, e);
+}
+
+static inline u32 iotlb_cr_to_virt(struct cr_regs *cr)
+{
+	BUG_ON(!arch_iommu || !arch_iommu->cr_to_virt || !cr);
+
+	return arch_iommu->cr_to_virt(cr);
+}
+
+static u32 get_iopte_attr(struct iotlb_entry *e)
+{
+	BUG_ON(!arch_iommu || !arch_iommu->get_pte_attr || !e);
+
+	return arch_iommu->get_pte_attr(e);
+}
+
+static u32 iommu_report_fault(struct iommu *obj, u32 *da)
+{
+	BUG_ON(!arch_iommu || !arch_iommu->fault_isr || !obj);
+
+	return arch_iommu->fault_isr(obj, da);
+}
+
+static void iotlb_lock_get(struct iommu *obj, struct iotlb_lock *l)
+{
+	u32 val;
+
+	BUG_ON(!obj || !l);
+
+	val = iommu_read_reg(obj, MMU_LOCK);
+
+	l->base = MMU_LOCK_BASE(val);
+	l->vict = MMU_LOCK_VICT(val);
+
+	BUG_ON(l->base != 0); /* Currently no preservation is used */
+}
+
+static void iotlb_lock_set(struct iommu *obj, struct iotlb_lock *l)
+{
+	u32 val;
+
+	BUG_ON(!obj || !l);
+	BUG_ON(l->base != 0); /* Currently no preservation is used */
+
+	val = (l->base << MMU_LOCK_BASE_SHIFT);
+	val |= (l->vict << MMU_LOCK_VICT_SHIFT);
+
+	iommu_write_reg(obj, val, MMU_LOCK);
+}
+
+static void iotlb_read_cr(struct iommu *obj, struct cr_regs *cr)
+{
+	BUG_ON(!obj || !cr);
+
+	arch_iommu->tlb_read_cr(obj, cr);
+}
+
+static void iotlb_load_cr(struct iommu *obj, struct cr_regs *cr)
+{
+	BUG_ON(!obj || !cr);
+
+	arch_iommu->tlb_load_cr(obj, cr);
+
+	iommu_write_reg(obj, 1, MMU_FLUSH_ENTRY);
+	iommu_write_reg(obj, 1, MMU_LD_TLB);
+}
+
+ssize_t iotlb_dump_cr(struct iommu *obj, struct cr_regs *cr, char *buf)
+{
+	BUG_ON(!arch_iommu || !arch_iommu->dump_cr || !cr || !buf);
+
+	return arch_iommu->dump_cr(obj, cr, buf);
+}
+EXPORT_SYMBOL_GPL(iotlb_dump_cr);
+
+int load_iotlb_entry(struct iommu *obj, struct iotlb_entry *e)
+{
+	int i;
+	int err = 0;
+	struct iotlb_lock l;
+	struct cr_regs *cr;
+
+	if (!obj || !obj->nr_tlb_entries || !e)
+		return -EINVAL;
+
+	clk_enable(obj->clk);
+
+	for (i = 0; i < obj->nr_tlb_entries; i++) {
+		struct cr_regs tmp;
+
+		iotlb_lock_get(obj, &l);
+		l.vict = i;
+		iotlb_lock_set(obj, &l);
+		iotlb_read_cr(obj, &tmp);
+		if (!iotlb_cr_valid(&tmp))
+			break;
+	}
+
+	if (i == obj->nr_tlb_entries) {
+		dev_dbg(obj->dev, "%s:\tfull: no entry\n", __func__);
+		err = -EBUSY;
+		goto out;
+	}
+
+	cr = iotlb_alloc_cr(obj, e);
+	if (IS_ERR(cr)) {
+		clk_disable(obj->clk);
+		return PTR_ERR(cr);
+	}
+
+	iotlb_load_cr(obj, cr);
+	kfree(cr);
+
+	/* increment victim for next tlb load */
+	if (++l.vict == obj->nr_tlb_entries)
+		l.vict = 0;
+	iotlb_lock_set(obj, &l);
+out:
+	clk_disable(obj->clk);
+	return err;
+}
+EXPORT_SYMBOL_GPL(load_iotlb_entry);
+
+void flush_iotlb_page(struct iommu *obj, u32 da)
+{
+	struct iotlb_lock l;
+	int i;
+
+	BUG_ON(!obj);
+
+	clk_enable(obj->clk);
+
+	for (i = 0; i < obj->nr_tlb_entries; i++) {
+		struct cr_regs cr;
+		u32 start;
+		size_t bytes;
+
+		iotlb_lock_get(obj, &l);
+		l.vict = i;
+		iotlb_lock_set(obj, &l);
+		iotlb_read_cr(obj, &cr);
+		if (!iotlb_cr_valid(&cr))
+			continue;
+
+		start = iotlb_cr_to_virt(&cr);
+		bytes = iopgsz_to_bytes(cr.cam & 3);
+
+		if ((start <= da) && (da < start + bytes)) {
+			dev_dbg(obj->dev, "%s:\t%08x<=%08x(%x)\n",
+				__func__, start, da, bytes);
+
+			iommu_write_reg(obj, 1, MMU_FLUSH_ENTRY);
+		}
+	}
+	clk_disable(obj->clk);
+
+	if (i == obj->nr_tlb_entries)
+		dev_dbg(obj->dev, "%s:\tno page for %08x\n", __func__, da);
+}
+EXPORT_SYMBOL_GPL(flush_iotlb_page);
+
+void flush_iotlb_range(struct iommu *obj, u32 start, u32 end)
+{
+	u32 da = start;
+
+	BUG_ON(!obj);
+
+	while (da < end) {
+		flush_iotlb_page(obj, da);
+		/* FIXME: Optimize for multiple page size */
+		da += IOPTE_SIZE;
+	}
+}
+EXPORT_SYMBOL_GPL(flush_iotlb_range);
+
+void flush_iotlb_all(struct iommu *obj)
+{
+	struct iotlb_lock l;
+
+	BUG_ON(!obj);
+
+	clk_enable(obj->clk);
+
+	l.base = 0;
+	l.vict = 0;
+	iotlb_lock_set(obj, &l);
+
+	iommu_write_reg(obj, 1, MMU_GFLUSH);
+
+	clk_disable(obj->clk);
+}
+EXPORT_SYMBOL_GPL(flush_iotlb_all);
+
+/*
+ *	H/W pagetable operations
+ */
+static void flush_iopgd_range(u32 *first, u32 *last)
+{
+	/* FIXME: L2 cache should be taken care of if it exists */
+	do {
+		asm("mcr	p15, 0, %0, c7, c10, 1 @ flush_pgd"
+		    : : "r" (first));
+		first += L1_CACHE_BYTES / sizeof(*first);
+	} while (first <= last);
+}
+
+static void flush_iopte_range(u32 *first, u32 *last)
+{
+	/* FIXME: L2 cache should be taken care of if it exists */
+	do {
+		asm("mcr	p15, 0, %0, c7, c10, 1 @ flush_pte"
+		    : : "r" (first));
+		first += L1_CACHE_BYTES / sizeof(*first);
+	} while (first <= last);
+}
+
+static void iopte_free(u32 *iopte)
+{
+	BUG_ON(!iopte);
+	/* Note: freed iopte's must be clean ready for re-use */
+	kmem_cache_free(iopte_cachep, iopte);
+}
+
+static u32 *iopte_alloc(struct iommu *obj, u32 *iopgd, u32 da)
+{
+	u32 *iopte;
+
+	/* a table has already existed */
+	if (*iopgd)
+		goto pte_ready;
+
+	/*
+	 * do the allocation outside the page table lock
+	 */
+	spin_unlock(&obj->page_table_lock);
+	iopte = kmem_cache_zalloc(iopte_cachep, GFP_KERNEL);
+	spin_lock(&obj->page_table_lock);
+
+	if (!*iopgd) {
+		if (!iopte)
+			return ERR_PTR(-ENOMEM);
+
+		*iopgd = virt_to_phys(iopte) | IOPGD_TABLE;
+		flush_iopgd_range(iopgd, iopgd);
+
+#ifdef DEBUG_VERBOSE
+		dev_dbg(obj->dev, "%s:\ta new pte:%p\n", __func__, iopte);
+#endif
+	} else {
+		/* We raced, free the reduniovant table */
+		iopte_free(iopte);
+	}
+
+pte_ready:
+	iopte = iopte_offset(iopgd, da);
+
+#ifdef DEBUG_VERBOSE
+	dev_dbg(obj->dev,
+		"%s:\tda:%08x pgd:%p *pgd:%08x pte:%p *pte:%08x\n",
+		__func__, da, iopgd, *iopgd, iopte, *iopte);
+#endif
+	return iopte;
+}
+
+static int iopgd_alloc_section(struct iommu *obj, u32 da, u32 pa, u32 prot)
+{
+	u32 *iopgd = iopgd_offset(obj, da);
+
+	*iopgd = (pa & IOSECTION_MASK) | prot | IOPGD_SECTION;
+	flush_iopgd_range(iopgd, iopgd);
+	return 0;
+}
+
+static int iopgd_alloc_super(struct iommu *obj, u32 da, u32 pa, u32 prot)
+{
+	u32 *iopgd = iopgd_offset(obj, da);
+	int i;
+
+	for (i = 0; i < 16; i++)
+		*(iopgd + i) = (pa & IOSUPER_MASK) | prot | IOPGD_SUPER;
+	flush_iopgd_range(iopgd, iopgd + 15);
+	return 0;
+}
+
+static int iopte_alloc_page(struct iommu *obj, u32 da, u32 pa, u32 prot)
+{
+	u32 *iopgd = iopgd_offset(obj, da);
+	u32 *iopte = iopte_alloc(obj, iopgd, da);
+
+	if (IS_ERR(iopte))
+		return PTR_ERR(iopte);
+
+	*iopte = (pa & IOPAGE_MASK) | prot | IOPTE_SMALL;
+	flush_iopte_range(iopte, iopte);
+
+#ifdef DEBUG_VERBOSE
+	dev_dbg(obj->dev, "%s:\tda:%08x pa:%08x pte:%p *pte:%08x\n",
+		__func__, da, pa, iopte, *iopte);
+#endif
+	return 0;
+}
+
+static int iopte_alloc_large(struct iommu *obj, u32 da, u32 pa, u32 prot)
+{
+	u32 *iopgd = iopgd_offset(obj, da);
+	u32 *iopte = iopte_alloc(obj, iopgd, da);
+	int i;
+
+	if (IS_ERR(iopte))
+		return PTR_ERR(iopte);
+
+	for (i = 0; i < 16; i++)
+		*(iopte + i) = (pa & IOLARGE_MASK) | prot | IOPTE_LARGE;
+	flush_iopte_range(iopte, iopte + 15);
+	return 0;
+}
+
+static int iopgtable_store_entry_core(struct iommu *obj, struct iotlb_entry *e)
+{
+	int (*fn)(struct iommu *, u32, u32, u32);
+	u32 prot;
+	int err;
+
+	if (!obj || !e)
+		return -EINVAL;
+
+	switch (e->pgsz) {
+	case MMU_CAM_PGSZ_16M:
+		fn = iopgd_alloc_super;
+		break;
+	case MMU_CAM_PGSZ_1M:
+		fn = iopgd_alloc_section;
+		break;
+	case MMU_CAM_PGSZ_64K:
+		fn = iopte_alloc_large;
+		break;
+	case MMU_CAM_PGSZ_4K:
+		fn = iopte_alloc_page;
+		break;
+	default:
+		fn = NULL;
+		BUG();
+		break;
+	}
+
+	prot = get_iopte_attr(e);
+
+	spin_lock(&obj->page_table_lock);
+	err = fn(obj, e->da, e->pa, prot);
+	spin_unlock(&obj->page_table_lock);
+
+	return err;
+}
+
+#ifdef DEBUG
+static void dump_tlb_entries(struct iommu *obj)
+{
+	int i;
+	struct iotlb_lock l;
+
+	clk_enable(obj->clk);
+
+	pr_info("%8s %8s\n", "cam:", "ram:");
+	pr_info("-----------------------------------------\n");
+
+	for (i = 0; i < obj->nr_tlb_entries; i++) {
+		struct cr_regs cr;
+		static char buf[4096];
+
+		iotlb_lock_get(obj, &l);
+		l.vict = i;
+		iotlb_lock_set(obj, &l);
+		iotlb_read_cr(obj, &cr);
+		if (!iotlb_cr_valid(&cr))
+			continue;
+
+		memset(buf, 0, 4096);
+		iotlb_dump_cr(obj, &cr, buf);
+		pr_info("%s", buf);
+	}
+
+	clk_disable(obj->clk);
+}
+#else
+static inline void dump_tlb_entries(struct iommu *obj) {}
+#endif
+
+int iopgtable_store_entry(struct iommu *obj, struct iotlb_entry *e)
+{
+	int err;
+
+	flush_iotlb_page(obj, e->da);
+	err = iopgtable_store_entry_core(obj, e);
+#ifdef USE_IOTLB
+	if (!err)
+		load_iotlb_entry(obj, e);
+#endif
+	return err;
+}
+EXPORT_SYMBOL_GPL(iopgtable_store_entry);
+
+void iopgtable_lookup_entry(struct iommu *obj, u32 da, u32 **ppgd, u32 **ppte)
+{
+	u32 *iopgd, *iopte = NULL;
+
+	iopgd = iopgd_offset(obj, da);
+	if (!*iopgd)
+		goto out;
+
+	if (*iopgd & IOPGD_TABLE)
+		iopte = iopte_offset(iopgd, da);
+out:
+	*ppgd = iopgd;
+	*ppte = iopte;
+}
+EXPORT_SYMBOL_GPL(iopgtable_lookup_entry);
+
+static size_t iopgtable_clear_entry_core(struct iommu *obj, u32 da)
+{
+	size_t bytes;
+	u32 *iopgd = iopgd_offset(obj, da);
+	int nent = 1;
+
+	if (!*iopgd)
+		return 0;
+
+	if (*iopgd & IOPGD_TABLE) {
+		int i;
+		u32 *iopte = iopte_offset(iopgd, da);
+
+		bytes = IOPTE_SIZE;
+		if (*iopte & IOPTE_LARGE) {
+			nent *= 16;
+			/* rewind to the 1st entry */
+			iopte = (u32 *)((u32)iopte & IOLARGE_MASK);
+		}
+		bytes *= nent;
+		memset(iopte, 0, nent * sizeof(*iopte));
+		flush_iopte_range(iopte, iopte + (nent - 1) * sizeof(*iopte));
+
+		/*
+		 * do table walk to check if this table is necessary or not
+		 */
+		iopte = iopte_offset(iopgd, 0);
+		for (i = 0; i < PTRS_PER_IOPTE; i++)
+			if (iopte[i])
+				goto out;
+
+		iopte_free(iopte);
+		nent = 1; /* for the next L1 entry */
+	} else {
+		bytes = IOPGD_SIZE;
+		if (*iopgd & IOPGD_SUPER) {
+			nent *= 16;
+			/* rewind to the 1st entry */
+			iopgd = (u32 *)((u32)iopgd & IOSUPER_MASK);
+		}
+		bytes *= nent;
+	}
+	memset(iopgd, 0, nent * sizeof(*iopgd));
+	flush_iopgd_range(iopgd, iopgd + (nent - 1) * sizeof(*iopgd));
+out:
+	return bytes;
+}
+
+size_t iopgtable_clear_entry(struct iommu *obj, u32 da)
+{
+	size_t bytes;
+
+	spin_lock(&obj->page_table_lock);
+
+	bytes = iopgtable_clear_entry_core(obj, da);
+	flush_iotlb_page(obj, da);
+
+	spin_unlock(&obj->page_table_lock);
+
+	return bytes;
+}
+EXPORT_SYMBOL_GPL(iopgtable_clear_entry);
+
+static void iopgtable_clear_entry_all(struct iommu *obj)
+{
+	int i;
+
+	spin_lock(&obj->page_table_lock);
+
+	for (i = 0; i < PTRS_PER_IOPGD; i++) {
+		u32 da;
+		u32 *iopgd;
+
+		da = i << IOPGD_SHIFT;
+		iopgd = iopgd_offset(obj, da);
+
+		if (!*iopgd)
+			continue;
+
+		if (*iopgd & IOPGD_TABLE)
+			iopte_free(iopte_offset(iopgd, 0));
+
+		*iopgd = 0;
+		flush_iopgd_range(iopgd, iopgd);
+	}
+
+	flush_iotlb_all(obj);
+
+	spin_unlock(&obj->page_table_lock);
+}
+
+/*
+ *	Device IOMMU generic operations
+ */
+static irqreturn_t iommu_fault_handler(int irq, void *data)
+{
+	u32 stat, da;
+	u32 *iopgd, *iopte;
+	int err = -EIO;
+	struct iommu *obj = data;
+
+	BUG_ON(!obj);
+
+	/* Dynamic loading TLB or PTE */
+	if (obj->isr)
+		err = obj->isr(obj);
+
+	if (!err)
+		return IRQ_HANDLED;
+
+	stat = iommu_report_fault(obj, &da);
+	if (!stat)
+		return IRQ_HANDLED;
+
+	iopgd = iopgd_offset(obj, da);
+
+	if (!(*iopgd & IOPGD_TABLE)) {
+		dev_err(obj->dev, "%s:\tda:%08x pgd:%p *pgd:%08x\n", __func__,
+			da, iopgd, *iopgd);
+		return IRQ_NONE;
+	}
+
+	iopte = iopte_offset(iopgd, da);
+
+	dev_err(obj->dev, "%s:\tda:%08x pgd:%p *pgd:%08x pte:%p *pte:%08x\n",
+		__func__, da, iopgd, *iopgd, iopte, *iopte);
+
+	dump_tlb_entries(obj);
+
+	return IRQ_NONE;
+}
+
+static int device_match_by_alias(struct device *dev, void *data)
+{
+	struct iommu *obj = to_iommu(dev);
+	const char *name = data;
+
+	pr_debug("%s:\t%s %s\n", __func__, obj->name, name);
+
+	return strcmp(obj->name, name) == 0;
+}
+
+struct iommu *iommu_get(const char *name)
+{
+	int err = -ENOMEM;
+	struct device *dev;
+	struct iommu *obj;
+
+	dev = driver_find_device(&omap_iommu_driver.driver, NULL, (void *)name,
+				 device_match_by_alias);
+	if (!dev)
+		return ERR_PTR(-ENODEV);
+
+	obj = to_iommu(dev);
+
+	mutex_lock(&obj->iommu_lock);
+
+	if (obj->refcount++ == 0) {
+		err = iommu_enable(obj);
+		if (err)
+			goto err_enable;
+		flush_iotlb_all(obj);
+	}
+
+	if (!try_module_get(obj->owner))
+		goto err_module;
+
+	mutex_unlock(&obj->iommu_lock);
+
+	dev_dbg(obj->dev, "%s:\t%s\n", __func__, obj->name);
+	return obj;
+
+err_module:
+	if (obj->refcount == 1)
+		iommu_disable(obj);
+err_enable:
+	mutex_unlock(&obj->iommu_lock);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(iommu_get);
+
+void iommu_put(struct iommu *obj)
+{
+	if (!obj && IS_ERR(obj))
+		return;
+
+	mutex_lock(&obj->iommu_lock);
+
+	if (--obj->refcount == 0)
+		iommu_disable(obj);
+
+	module_put(obj->owner);
+
+	mutex_unlock(&obj->iommu_lock);
+
+	dev_dbg(obj->dev, "%s:\t%s\n", __func__, obj->name);
+}
+EXPORT_SYMBOL_GPL(iommu_put);
+
+/*
+ *	OMAP Device MMU(IOMMU) detection
+ */
+static int __devinit omap_iommu_probe(struct platform_device *pdev)
+{
+	int err = -ENODEV;
+	void *p;
+	int irq;
+	struct iommu *obj;
+	struct resource *res;
+	struct iommu_platform_data *pdata = pdev->dev.platform_data;
+
+	if (pdev->num_resources != 2)
+		return -EINVAL;
+
+	obj = kzalloc(sizeof(*obj) + MMU_REG_SIZE, GFP_KERNEL);
+	if (!obj)
+		return -ENOMEM;
+
+	obj->clk = clk_get(NULL, pdata->clk_name);
+	if (IS_ERR(obj->clk))
+		goto err_clk;
+
+	obj->nr_tlb_entries = pdata->nr_tlb_entries;
+	obj->name = pdata->name;
+	obj->dev = &pdev->dev;
+	obj->ctx = (void *)obj + sizeof(*obj);
+
+	mutex_init(&obj->iommu_lock);
+	mutex_init(&obj->mmap_lock);
+	spin_lock_init(&obj->page_table_lock);
+	INIT_LIST_HEAD(&obj->mmap);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		err = -ENODEV;
+		goto err_mem;
+	}
+	obj->regbase = ioremap(res->start, resource_size(res));
+	if (!obj->regbase) {
+		err = -ENOMEM;
+		goto err_mem;
+	}
+
+	res = request_mem_region(res->start, resource_size(res),
+				 dev_name(&pdev->dev));
+	if (!res) {
+		err = -EIO;
+		goto err_mem;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		err = -ENODEV;
+		goto err_irq;
+	}
+	err = request_irq(irq, iommu_fault_handler, IRQF_SHARED,
+			  dev_name(&pdev->dev), obj);
+	if (err < 0)
+		goto err_irq;
+	platform_set_drvdata(pdev, obj);
+
+	p = (void *)__get_free_pages(GFP_KERNEL, get_order(IOPGD_TABLE_SIZE));
+	if (!p) {
+		err = -ENOMEM;
+		goto err_pgd;
+	}
+	memset(p, 0, IOPGD_TABLE_SIZE);
+	clean_dcache_area(p, IOPGD_TABLE_SIZE);
+	obj->iopgd = p;
+
+	BUG_ON(!IS_ALIGNED((unsigned long)obj->iopgd, IOPGD_TABLE_SIZE));
+
+	dev_info(&pdev->dev, "%s registered\n", obj->name);
+	return 0;
+
+err_pgd:
+	free_irq(irq, obj);
+err_irq:
+	release_mem_region(res->start, resource_size(res));
+	iounmap(obj->regbase);
+err_mem:
+	clk_put(obj->clk);
+err_clk:
+	kfree(obj);
+	return err;
+}
+
+static int __devexit omap_iommu_remove(struct platform_device *pdev)
+{
+	int irq;
+	struct resource *res;
+	struct iommu *obj = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+
+	iopgtable_clear_entry_all(obj);
+	free_pages((unsigned long)obj->iopgd, get_order(IOPGD_TABLE_SIZE));
+
+	irq = platform_get_irq(pdev, 0);
+	BUG_ON(irq < 0);
+	free_irq(irq, obj);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(res->start, resource_size(res));
+	iounmap(obj->regbase);
+
+	clk_put(obj->clk);
+	dev_info(&pdev->dev, "%s removed\n", obj->name);
+	kfree(obj);
+	return 0;
+}
+
+static struct platform_driver omap_iommu_driver = {
+	.probe	= omap_iommu_probe,
+	.remove	= __devexit_p(omap_iommu_remove),
+	.driver	= {
+		.name	= DRV_NAME,
+	},
+};
+
+static void iopte_cachep_ctor(void *iopte)
+{
+	clean_dcache_area(iopte, IOPTE_TABLE_SIZE);
+}
+
+static int __init omap_iommu_init(void)
+{
+	struct kmem_cache *p;
+	const unsigned long flags = SLAB_HWCACHE_ALIGN;
+
+	p = kmem_cache_create("iopte_cache", IOPTE_TABLE_SIZE, 0, flags,
+			      iopte_cachep_ctor);
+	if (!p)
+		return -ENOMEM;
+	iopte_cachep = p;
+
+	return platform_driver_register(&omap_iommu_driver);
+}
+module_init(omap_iommu_init);
+
+static void __exit omap_iommu_exit(void)
+{
+	kmem_cache_destroy(iopte_cachep);
+
+	platform_driver_unregister(&omap_iommu_driver);
+}
+module_exit(omap_iommu_exit);
+
+MODULE_DESCRIPTION("omap iommu: tlb and pagetable primitives");
+MODULE_ALIAS("platform:"DRV_NAME);
+MODULE_AUTHOR("Hiroshi DOYU, Paul Mundt and Toshihiro Kobayashi");
+MODULE_LICENSE("GPL v2");
diff --git a/arch/arm/plat-omap/iopgtable.h b/arch/arm/plat-omap/iopgtable.h
new file mode 100644
index 0000000..c31c36c
--- /dev/null
+++ b/arch/arm/plat-omap/iopgtable.h
@@ -0,0 +1,72 @@
+/*
+ * omap iommu: pagetable definitions
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Written by Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __PLAT_OMAP_IOMMU_H
+#define __PLAT_OMAP_IOMMU_H
+
+#define IOPGD_SHIFT		20
+#define IOPGD_SIZE		(1 << IOPGD_SHIFT)
+#define IOPGD_MASK		(~(IOPGD_SIZE - 1))
+#define IOSECTION_MASK		IOPGD_MASK
+#define PTRS_PER_IOPGD		(1 << (32 - IOPGD_SHIFT))
+#define IOPGD_TABLE_SIZE	(PTRS_PER_IOPGD * sizeof(u32))
+
+#define IOSUPER_SIZE		(IOPGD_SIZE << 4)
+#define IOSUPER_MASK		(~(IOSUPER_SIZE - 1))
+
+#define IOPTE_SHIFT		12
+#define IOPTE_SIZE		(1 << IOPTE_SHIFT)
+#define IOPTE_MASK		(~(IOPTE_SIZE - 1))
+#define IOPAGE_MASK		IOPTE_MASK
+#define PTRS_PER_IOPTE		(1 << (IOPGD_SHIFT - IOPTE_SHIFT))
+#define IOPTE_TABLE_SIZE	(PTRS_PER_IOPTE * sizeof(u32))
+
+#define IOLARGE_SIZE		(IOPTE_SIZE << 4)
+#define IOLARGE_MASK		(~(IOLARGE_SIZE - 1))
+
+#define IOPGD_TABLE		(1 << 0)
+#define IOPGD_SECTION		(2 << 0)
+#define IOPGD_SUPER		(1 << 18 | 2 << 0)
+
+#define IOPTE_SMALL		(2 << 0)
+#define IOPTE_LARGE		(1 << 0)
+
+#define iopgd_index(da)		(((da) >> IOPGD_SHIFT) & (PTRS_PER_IOPGD - 1))
+#define iopgd_offset(obj, da)	((obj)->iopgd + iopgd_index(da))
+
+#define iopte_paddr(iopgd)	(*iopgd & ~((1 << 10) - 1))
+#define iopte_vaddr(iopgd)	((u32 *)phys_to_virt(iopte_paddr(iopgd)))
+
+#define iopte_index(da)		(((da) >> IOPTE_SHIFT) & (PTRS_PER_IOPTE - 1))
+#define iopte_offset(iopgd, da)	(iopte_vaddr(iopgd) + iopte_index(da))
+
+static inline u32 iotlb_init_entry(struct iotlb_entry *e, u32 da, u32 pa,
+				   u32 flags)
+{
+	memset(e, 0, sizeof(*e));
+
+	e->da		= da;
+	e->pa		= pa;
+	e->valid	= 1;
+	/* FIXME: add OMAP1 support */
+	e->pgsz		= flags & MMU_CAM_PGSZ_MASK;
+	e->endian	= flags & MMU_RAM_ENDIAN_MASK;
+	e->elsz		= flags & MMU_RAM_ELSZ_MASK;
+	e->mixed	= flags & MMU_RAM_MIXED_MASK;
+
+	return iopgsz_to_bytes(e->pgsz);
+}
+
+#define to_iommu(dev)							\
+	(struct iommu *)platform_get_drvdata(to_platform_device(dev))
+
+#endif /* __PLAT_OMAP_IOMMU_H */

