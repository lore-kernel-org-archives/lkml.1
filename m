Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbYGJSmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbYGJSmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbYGJSln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:28099 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbYGJSlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="409061606"
Message-Id: <20080710182237.344218000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:44 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 10/26] x64, x2apic/intr-remap: routines managing Interrupt remapping table entries.
Content-Disposition: inline; filename=irte_management_routines.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Routines handling the management of interrupt remapping table entries.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/drivers/pci/intr_remapping.c
===================================================================
--- tree-x86.orig/drivers/pci/intr_remapping.c	2008-07-10 09:52:03.000000000 -0700
+++ tree-x86/drivers/pci/intr_remapping.c	2008-07-10 09:52:05.000000000 -0700
@@ -2,6 +2,7 @@
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
 #include <linux/pci.h>
+#include <linux/irq.h>
 #include <asm/io_apic.h>
 #include "intel-iommu.h"
 #include "intr_remapping.h"
@@ -10,6 +11,248 @@
 static int ir_ioapic_num;
 int intr_remapping_enabled;
 
+static struct {
+	struct intel_iommu *iommu;
+	u16 irte_index;
+	u16 sub_handle;
+	u8  irte_mask;
+} irq_2_iommu[NR_IRQS];
+
+static DEFINE_SPINLOCK(irq_2_ir_lock);
+
+int irq_remapped(int irq)
+{
+	if (irq > NR_IRQS)
+		return 0;
+
+	if (!irq_2_iommu[irq].iommu)
+		return 0;
+
+	return 1;
+}
+
+int get_irte(int irq, struct irte *entry)
+{
+	int index;
+
+	if (!entry || irq > NR_IRQS)
+		return -1;
+
+	spin_lock(&irq_2_ir_lock);
+	if (!irq_2_iommu[irq].iommu) {
+		spin_unlock(&irq_2_ir_lock);
+		return -1;
+	}
+
+	index = irq_2_iommu[irq].irte_index + irq_2_iommu[irq].sub_handle;
+	*entry = *(irq_2_iommu[irq].iommu->ir_table->base + index);
+
+	spin_unlock(&irq_2_ir_lock);
+	return 0;
+}
+
+int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
+{
+	struct ir_table *table = iommu->ir_table;
+	u16 index, start_index;
+	unsigned int mask = 0;
+	int i;
+
+	if (!count)
+		return -1;
+
+	/*
+	 * start the IRTE search from index 0.
+	 */
+	index = start_index = 0;
+
+	if (count > 1) {
+		count = __roundup_pow_of_two(count);
+		mask = ilog2(count);
+	}
+
+	if (mask > ecap_max_handle_mask(iommu->ecap)) {
+		printk(KERN_ERR
+		       "Requested mask %x exceeds the max invalidation handle"
+		       " mask value %Lx\n", mask,
+		       ecap_max_handle_mask(iommu->ecap));
+		return -1;
+	}
+
+	spin_lock(&irq_2_ir_lock);
+	do {
+		for (i = index; i < index + count; i++)
+			if  (table->base[i].present)
+				break;
+		/* empty index found */
+		if (i == index + count)
+			break;
+
+		index = (index + count) % INTR_REMAP_TABLE_ENTRIES;
+
+		if (index == start_index) {
+			spin_unlock(&irq_2_ir_lock);
+			printk(KERN_ERR "can't allocate an IRTE\n");
+			return -1;
+		}
+	} while (1);
+
+	for (i = index; i < index + count; i++)
+		table->base[i].present = 1;
+
+	irq_2_iommu[irq].iommu = iommu;
+	irq_2_iommu[irq].irte_index =  index;
+	irq_2_iommu[irq].sub_handle = 0;
+	irq_2_iommu[irq].irte_mask = mask;
+
+	spin_unlock(&irq_2_ir_lock);
+
+	return index;
+}
+
+static void qi_flush_iec(struct intel_iommu *iommu, int index, int mask)
+{
+	struct qi_desc desc;
+
+	desc.low = QI_IEC_IIDEX(index) | QI_IEC_TYPE | QI_IEC_IM(mask)
+		   | QI_IEC_SELECTIVE;
+	desc.high = 0;
+
+	qi_submit_sync(&desc, iommu);
+}
+
+int map_irq_to_irte_handle(int irq, u16 *sub_handle)
+{
+	int index;
+
+	spin_lock(&irq_2_ir_lock);
+	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+		spin_unlock(&irq_2_ir_lock);
+		return -1;
+	}
+
+	*sub_handle = irq_2_iommu[irq].sub_handle;
+	index = irq_2_iommu[irq].irte_index;
+	spin_unlock(&irq_2_ir_lock);
+	return index;
+}
+
+int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
+{
+	spin_lock(&irq_2_ir_lock);
+	if (irq >= NR_IRQS || irq_2_iommu[irq].iommu) {
+		spin_unlock(&irq_2_ir_lock);
+		return -1;
+	}
+
+	irq_2_iommu[irq].iommu = iommu;
+	irq_2_iommu[irq].irte_index = index;
+	irq_2_iommu[irq].sub_handle = subhandle;
+	irq_2_iommu[irq].irte_mask = 0;
+
+	spin_unlock(&irq_2_ir_lock);
+
+	return 0;
+}
+
+int clear_irte_irq(int irq, struct intel_iommu *iommu, u16 index)
+{
+	spin_lock(&irq_2_ir_lock);
+	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+		spin_unlock(&irq_2_ir_lock);
+		return -1;
+	}
+
+	irq_2_iommu[irq].iommu = NULL;
+	irq_2_iommu[irq].irte_index = 0;
+	irq_2_iommu[irq].sub_handle = 0;
+	irq_2_iommu[irq].irte_mask = 0;
+
+	spin_unlock(&irq_2_ir_lock);
+
+	return 0;
+}
+
+int modify_irte(int irq, struct irte *irte_modified)
+{
+	int index;
+	struct irte *irte;
+	struct intel_iommu *iommu;
+
+	spin_lock(&irq_2_ir_lock);
+	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+		spin_unlock(&irq_2_ir_lock);
+		return -1;
+	}
+
+	iommu = irq_2_iommu[irq].iommu;
+
+	index = irq_2_iommu[irq].irte_index + irq_2_iommu[irq].sub_handle;
+	irte = &iommu->ir_table->base[index];
+
+	set_64bit((unsigned long *)irte, irte_modified->low | (1 << 1));
+	__iommu_flush_cache(iommu, irte, sizeof(*irte));
+
+	qi_flush_iec(iommu, index, 0);
+
+	spin_unlock(&irq_2_ir_lock);
+	return 0;
+}
+
+int flush_irte(int irq)
+{
+	int index;
+	struct intel_iommu *iommu;
+
+	spin_lock(&irq_2_ir_lock);
+	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+		spin_unlock(&irq_2_ir_lock);
+		return -1;
+	}
+
+	iommu = irq_2_iommu[irq].iommu;
+
+	index = irq_2_iommu[irq].irte_index + irq_2_iommu[irq].sub_handle;
+
+	qi_flush_iec(iommu, index, irq_2_iommu[irq].irte_mask);
+	spin_unlock(&irq_2_ir_lock);
+
+	return 0;
+}
+
+int free_irte(int irq)
+{
+	int index, i;
+	struct irte *irte;
+	struct intel_iommu *iommu;
+
+	spin_lock(&irq_2_ir_lock);
+	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+		spin_unlock(&irq_2_ir_lock);
+		return -1;
+	}
+
+	iommu = irq_2_iommu[irq].iommu;
+
+	index = irq_2_iommu[irq].irte_index + irq_2_iommu[irq].sub_handle;
+	irte = &iommu->ir_table->base[index];
+
+	if (!irq_2_iommu[irq].sub_handle) {
+		for (i = 0; i < (1 << irq_2_iommu[irq].irte_mask); i++)
+			set_64bit((unsigned long *)irte, 0);
+		qi_flush_iec(iommu, index, irq_2_iommu[irq].irte_mask);
+	}
+
+	irq_2_iommu[irq].iommu = NULL;
+	irq_2_iommu[irq].irte_index = 0;
+	irq_2_iommu[irq].sub_handle = 0;
+	irq_2_iommu[irq].irte_mask = 0;
+
+	spin_unlock(&irq_2_ir_lock);
+
+	return 0;
+}
+
 static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
 {
 	u64 addr;
Index: tree-x86/include/linux/dmar.h
===================================================================
--- tree-x86.orig/include/linux/dmar.h	2008-07-10 09:52:03.000000000 -0700
+++ tree-x86/include/linux/dmar.h	2008-07-10 09:52:05.000000000 -0700
@@ -98,7 +98,19 @@
 		__u64 high;
 	};
 };
+extern int get_irte(int irq, struct irte *entry);
+extern int modify_irte(int irq, struct irte *irte_modified);
+extern int alloc_irte(struct intel_iommu *iommu, int irq, u16 count);
+extern int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index,
+   			u16 sub_handle);
+extern int map_irq_to_irte_handle(int irq, u16 *sub_handle);
+extern int clear_irte_irq(int irq, struct intel_iommu *iommu, u16 index);
+extern int flush_irte(int irq);
+extern int free_irte(int irq);
+
+extern int irq_remapped(int irq);
 #else
+#define irq_remapped(irq)		(0)
 #define enable_intr_remapping(mode)	(-1)
 #define intr_remapping_enabled		(0)
 #endif
Index: tree-x86/drivers/pci/intel-iommu.h
===================================================================
--- tree-x86.orig/drivers/pci/intel-iommu.h	2008-07-10 09:52:03.000000000 -0700
+++ tree-x86/drivers/pci/intel-iommu.h	2008-07-10 09:52:05.000000000 -0700
@@ -123,6 +123,7 @@
 #define ecap_qis(e)		((e) & 0x2)
 #define ecap_eim_support(e)	((e >> 4) & 0x1)
 #define ecap_ir_support(e)	((e >> 3) & 0x1)
+#define ecap_max_handle_mask(e) ((e >> 20) & 0xf)
 
 
 /* IOTLB_REG */
@@ -255,6 +256,8 @@
 #define INTR_REMAP_PAGE_ORDER	8
 #define INTR_REMAP_TABLE_REG_SIZE	0xf
 
+#define INTR_REMAP_TABLE_ENTRIES	65536
+
 struct ir_table {
 	struct irte *base;
 };
@@ -300,4 +303,5 @@
 extern int dmar_enable_qi(struct intel_iommu *iommu);
 extern void qi_global_iec(struct intel_iommu *iommu);
 
+extern void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 #endif

-- 

