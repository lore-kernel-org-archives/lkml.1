Return-Path: <linux-kernel-owner+w=401wt.eu-S1751730AbZL1GNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbZL1GNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 01:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZL1GNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 01:13:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:7038 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbZL1GMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 01:12:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="227061005"
From: Huang Ying <ying.huang@intel.com>
To: lenb@kernel.org
Cc: ak@linux.intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>
Subject: [PATCH 1/5] ACPI, IO memory pre-mapping and atomic accessing
Date: Mon, 28 Dec 2009 14:12:20 +0800
Message-Id: <1261980744-4450-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1261980744-4450-1-git-send-email-ying.huang@intel.com>
References: <1261980744-4450-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some ACPI IO accessing need to be done in atomic context. For example,
APEI ERST operations may be used for permanent storage in hardware
error handler. That is, it may be called in atomic contexts such as
IRQ or NMI, etc. And, ERST/EINJ implement their operations via IO
memory/port accessing.  But the IO memory accessing method provided by
ACPI (acpi_read/acpi_write) maps the IO memory during it is accessed,
so it can not be used in atomic context. To solve the issue, the IO
memory should be pre-mapped during EINJ/ERST initializing. A linked
list is used to record which memory area has been mapped, when memory
is accessed in hardware error handler, search the linked list for the
mapped virtual address from the given physical address.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/Makefile   |    1 +
 drivers/acpi/atomicio.c |  360 +++++++++++++++++++++++++++++++++++++++++++++++
 include/acpi/atomicio.h |   10 ++
 3 files changed, 371 insertions(+), 0 deletions(-)
 create mode 100644 drivers/acpi/atomicio.c
 create mode 100644 include/acpi/atomicio.h

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 66cc3f3..3b53767 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -19,6 +19,7 @@ obj-y				+= acpi.o \
 
 # All the builtin files are in the "acpi." module_param namespace.
 acpi-y				+= osl.o utils.o reboot.o
+acpi-y				+= atomicio.o
 acpi-y				+= hest.o
 
 # sleep related files
diff --git a/drivers/acpi/atomicio.c b/drivers/acpi/atomicio.c
new file mode 100644
index 0000000..4ed1385
--- /dev/null
+++ b/drivers/acpi/atomicio.c
@@ -0,0 +1,360 @@
+/*
+ * atomicio.c - ACPI IO memory pre-mapping/post-unmapping, then
+ * accessing in atomic context.
+ *
+ * This is used for NMI handler to access IO memory area, because
+ * ioremap/iounmap can not be used in NMI handler. The IO memory area
+ * is pre-mapped in process context and accessed in NMI handler.
+ *
+ * Copyright (C) 2009, Intel Corp.
+ *	Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/acpi.h>
+#include <linux/io.h>
+#include <linux/kref.h>
+#include <linux/rculist.h>
+#include <linux/interrupt.h>
+#include <acpi/atomicio.h>
+
+#define ACPI_PFX "ACPI: "
+
+static LIST_HEAD(acpi_iomaps);
+/*
+ * Used for mutual exclusion between writers of acpi_iomaps list, for
+ * synchronization between readers and writer, RCU is used.
+ */
+static DEFINE_SPINLOCK(acpi_iomaps_lock);
+
+struct acpi_iomap {
+	struct list_head list;
+	void __iomem *vaddr;
+	unsigned long size;
+	phys_addr_t paddr;
+	struct kref ref;
+};
+
+/* acpi_iomaps_lock or RCU read lock must be held before calling */
+static struct acpi_iomap *__acpi_find_iomap(phys_addr_t paddr,
+					    unsigned long size)
+{
+	struct acpi_iomap *map;
+
+	list_for_each_entry_rcu(map, &acpi_iomaps, list) {
+		if (map->paddr + map->size >= paddr + size &&
+		    map->paddr <= paddr)
+			return map;
+	}
+	return NULL;
+}
+
+/*
+ * Atomic "ioremap" used by NMI handler, if the specified IO memory
+ * area is not pre-mapped, NULL will be returned.
+ *
+ * acpi_iomaps_lock or RCU read lock must be held before calling
+ */
+static void __iomem *__acpi_ioremap_fast(phys_addr_t paddr,
+					 unsigned long size)
+{
+	struct acpi_iomap *map;
+
+	map = __acpi_find_iomap(paddr, size);
+	if (map)
+		return map->vaddr + (paddr - map->paddr);
+	else
+		return NULL;
+}
+
+/* acpi_iomaps_lock must be held before calling */
+static void __iomem *__acpi_try_ioremap(phys_addr_t paddr,
+					unsigned long size)
+{
+	struct acpi_iomap *map;
+
+	map = __acpi_find_iomap(paddr, size);
+	if (map) {
+		kref_get(&map->ref);
+		return map->vaddr + (paddr - map->paddr);
+	} else
+		return NULL;
+}
+
+/*
+ * Used to pre-map the specified IO memory area. First try to find
+ * whether the area is already pre-mapped, if it is, increase the
+ * reference count (in __acpi_try_ioremap) and return; otherwise, do
+ * the real ioremap, and add the mapping into acpi_iomaps list.
+ */
+static void __iomem *acpi_pre_map(phys_addr_t paddr,
+				  unsigned long size)
+{
+	void __iomem *vaddr;
+	struct acpi_iomap *map;
+	unsigned long pg_sz, flags;
+	phys_addr_t pg_off;
+
+	spin_lock_irqsave(&acpi_iomaps_lock, flags);
+	vaddr = __acpi_try_ioremap(paddr, size);
+	spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
+	if (vaddr)
+		return vaddr;
+
+	pg_off = paddr & PAGE_MASK;
+	pg_sz = ((paddr + size + PAGE_SIZE - 1) & PAGE_MASK) - pg_off;
+	vaddr = ioremap(pg_off, pg_sz);
+	if (!vaddr)
+		return NULL;
+	map = kmalloc(sizeof(*map), GFP_KERNEL);
+	if (!map)
+		goto err_unmap;
+	INIT_LIST_HEAD(&map->list);
+	map->paddr = pg_off;
+	map->size = pg_sz;
+	map->vaddr = vaddr;
+	kref_init(&map->ref);
+
+	spin_lock_irqsave(&acpi_iomaps_lock, flags);
+	vaddr = __acpi_try_ioremap(paddr, size);
+	if (vaddr) {
+		spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
+		iounmap(map->vaddr);
+		kfree(map);
+		return vaddr;
+	}
+	list_add_tail_rcu(&map->list, &acpi_iomaps);
+	spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
+
+	return vaddr + (paddr - pg_off);
+err_unmap:
+	iounmap(vaddr);
+	return NULL;
+}
+
+/* acpi_iomaps_lock must be held before calling */
+static void __acpi_kref_del_iomap(struct kref *ref)
+{
+	struct acpi_iomap *map;
+
+	map = container_of(ref, struct acpi_iomap, ref);
+	list_del_rcu(&map->list);
+}
+
+/*
+ * Used to post-unmap the specified IO memory area. The iounmap is
+ * done only if the reference count goes zero.
+ */
+static void acpi_post_unmap(phys_addr_t paddr, unsigned long size)
+{
+	struct acpi_iomap *map;
+	unsigned long flags;
+	int del;
+
+	spin_lock_irqsave(&acpi_iomaps_lock, flags);
+	map = __acpi_find_iomap(paddr, size);
+	BUG_ON(!map);
+	del = kref_put(&map->ref, __acpi_kref_del_iomap);
+	spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
+
+	if (!del)
+		return;
+
+	synchronize_rcu();
+	iounmap(map->vaddr);
+	kfree(map);
+}
+
+/* In NMI handler, should set silent = 1 */
+static int acpi_check_gar(struct acpi_generic_address *reg,
+			  u64 *paddr, int silent)
+{
+	u32 width, space_id;
+
+	width = reg->bit_width;
+	space_id = reg->space_id;
+	/* Handle possible alignment issues */
+	memcpy(paddr, &reg->address, sizeof(*paddr));
+	if (!*paddr) {
+		if (!silent)
+			pr_info(ACPI_PFX FW_BUG
+			"Invalid physical address in GAR [0x%llx/%u/%u]\n",
+				*paddr, width, space_id);
+		return -EINVAL;
+	}
+
+	if ((width != 8) && (width != 16) && (width != 32) && (width != 64)) {
+		if (!silent)
+			pr_info(ACPI_PFX FW_BUG
+				"Invalid bit width in GAR [0x%llx/%u/%u]\n",
+				*paddr, width, space_id);
+		return -EINVAL;
+	}
+
+	if (space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY &&
+	    space_id != ACPI_ADR_SPACE_SYSTEM_IO) {
+		if (!silent)
+			pr_info(ACPI_PFX FW_BUG
+			"Invalid address space type in GAR [0x%llx/%u/%u]\n",
+				*paddr, width, space_id);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Pre-map, working on GAR */
+int acpi_pre_map_gar(struct acpi_generic_address *reg)
+{
+	u64 paddr;
+	void __iomem *vaddr;
+	int rc;
+
+	if (reg->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
+		return 0;
+
+	rc = acpi_check_gar(reg, &paddr, 0);
+	if (rc)
+		return rc;
+
+	vaddr = acpi_pre_map(paddr, reg->bit_width / 8);
+	if (!vaddr)
+		return -EIO;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(acpi_pre_map_gar);
+
+/* Post-unmap, working on GAR */
+int acpi_post_unmap_gar(struct acpi_generic_address *reg)
+{
+	u64 paddr;
+	int rc;
+
+	if (reg->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
+		return 0;
+
+	rc = acpi_check_gar(reg, &paddr, 0);
+	if (rc)
+		return rc;
+
+	acpi_post_unmap(paddr, reg->bit_width / 8);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(acpi_post_unmap_gar);
+
+/*
+ * Can be used in atomic (including NMI) or process context. RCU read
+ * lock can only be released after the IO memory area accessing.
+ */
+static int acpi_atomic_read_mem(u64 paddr, u64 *val, u32 width)
+{
+	void __iomem *addr;
+
+	rcu_read_lock();
+	addr = __acpi_ioremap_fast(paddr, width);
+	switch (width) {
+	case 8:
+		*val = readb(addr);
+		break;
+	case 16:
+		*val = readw(addr);
+		break;
+	case 32:
+		*val = readl(addr);
+		break;
+	case 64:
+		*val = readq(addr);
+		break;
+	default:
+		return -EINVAL;
+	}
+	rcu_read_unlock();
+
+	return 0;
+}
+
+static int acpi_atomic_write_mem(u64 paddr, u64 val, u32 width)
+{
+	void __iomem *addr;
+
+	rcu_read_lock();
+	addr = __acpi_ioremap_fast(paddr, width);
+	switch (width) {
+	case 8:
+		writeb(val, addr);
+		break;
+	case 16:
+		writew(val, addr);
+		break;
+	case 32:
+		writel(val, addr);
+		break;
+	case 64:
+		writeq(val, addr);
+		break;
+	default:
+		return -EINVAL;
+	}
+	rcu_read_unlock();
+
+	return 0;
+}
+
+/* GAR accessing in atomic (including NMI) or process context */
+int acpi_atomic_read(u64 *val, struct acpi_generic_address *reg)
+{
+	u64 paddr;
+	int rc;
+
+	rc = acpi_check_gar(reg, &paddr, 1);
+	if (rc)
+		return rc;
+
+	*val = 0;
+	switch (reg->space_id) {
+	case ACPI_ADR_SPACE_SYSTEM_MEMORY:
+		return acpi_atomic_read_mem(paddr, val, reg->bit_width);
+	case ACPI_ADR_SPACE_SYSTEM_IO:
+		return acpi_os_read_port(paddr, (u32 *)val, reg->bit_width);
+	default:
+		return -EINVAL;
+	}
+}
+EXPORT_SYMBOL_GPL(acpi_atomic_read);
+
+int acpi_atomic_write(u64 val, struct acpi_generic_address *reg)
+{
+	u64 paddr;
+	int rc;
+
+	rc = acpi_check_gar(reg, &paddr, 1);
+	if (rc)
+		return rc;
+
+	switch (reg->space_id) {
+	case ACPI_ADR_SPACE_SYSTEM_MEMORY:
+		return acpi_atomic_write_mem(paddr, val, reg->bit_width);
+	case ACPI_ADR_SPACE_SYSTEM_IO:
+		return acpi_os_write_port(paddr, val, reg->bit_width);
+	default:
+		return -EINVAL;
+	}
+}
+EXPORT_SYMBOL_GPL(acpi_atomic_write);
diff --git a/include/acpi/atomicio.h b/include/acpi/atomicio.h
new file mode 100644
index 0000000..8b9fb4b
--- /dev/null
+++ b/include/acpi/atomicio.h
@@ -0,0 +1,10 @@
+#ifndef ACPI_ATOMIC_IO_H
+#define ACPI_ATOMIC_IO_H
+
+int acpi_pre_map_gar(struct acpi_generic_address *reg);
+int acpi_post_unmap_gar(struct acpi_generic_address *reg);
+
+int acpi_atomic_read(u64 *val, struct acpi_generic_address *reg);
+int acpi_atomic_write(u64 val, struct acpi_generic_address *reg);
+
+#endif
-- 
1.6.5

