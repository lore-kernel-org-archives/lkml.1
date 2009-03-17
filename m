Return-Path: <linux-kernel-owner+w=401wt.eu-S1762624AbZCQAaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762624AbZCQAaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761566AbZCQA2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:28:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:57059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758397AbZCQA2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:28:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,375,1233561600"; 
   d="scan'208";a="395024218"
Message-Id: <20090317001319.874336000@linux-os.sc.intel.com>
References: <20090317000452.805772000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 17:04:53 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org,
       yinghai@kernel.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 01/13] intr-remapping: fix "hard-safe -> hard-unsafe lock order detected" with irq_2_ir_lock
Content-Disposition: inline; filename=fix_lockdep_warning.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x2apic enabled system:
   [ INFO: hard-safe -> hard-unsafe lock order detected ]
   2.6.27-03151-g4480f15b #1
   ------------------------------------------------------
   swapper/1 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
    (irq_2_ir_lock){--..}, at: [<ffffffff8038ebc0>] get_irte+0x2f/0x95
   
   and this task is already holding:
    (&irq_desc_lock_class){+...}, at: [<ffffffff802649ed>] setup_irq+0x67/0x281
   which would create a new lock dependency:
    (&irq_desc_lock_class){+...} -> (irq_2_ir_lock){--..}
   
   but this new dependency connects a hard-irq-safe lock:
    (&irq_desc_lock_class){+...}
   ... which became hard-irq-safe at:
     [<ffffffffffffffff>] 0xffffffffffffffff
   
   to a hard-irq-unsafe lock:
    (irq_2_ir_lock){--..}
   ... which became hard-irq-unsafe at:
   ...  [<ffffffff802547b5>] __lock_acquire+0x571/0x706
     [<ffffffff8025499f>] lock_acquire+0x55/0x71
     [<ffffffff8062f2c4>] _spin_lock+0x2c/0x38
     [<ffffffff8038ee50>] alloc_irte+0x8a/0x14b
     [<ffffffff8021f733>] setup_IO_APIC_irq+0x119/0x30e
     [<ffffffff8090860e>] setup_IO_APIC+0x146/0x6e5
     [<ffffffff809058fc>] native_smp_prepare_cpus+0x24e/0x2e9
     [<ffffffff808f982c>] kernel_init+0x5a/0x176
     [<ffffffff8020c289>] child_rip+0xa/0x11
     [<ffffffffffffffff>] 0xffffffffffffffff

Fix this theoretical lock order issue by using spin_lock_irqsave() instead of
spin_lock()

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/drivers/pci/intr_remapping.c
===================================================================
--- tip.orig/drivers/pci/intr_remapping.c
+++ tip/drivers/pci/intr_remapping.c
@@ -117,21 +117,22 @@ int get_irte(int irq, struct irte *entry
 {
 	int index;
 	struct irq_2_iommu *irq_iommu;
+	unsigned long flags;
 
 	if (!entry)
 		return -1;
 
-	spin_lock(&irq_2_ir_lock);
+	spin_lock_irqsave(&irq_2_ir_lock, flags);
 	irq_iommu = valid_irq_2_iommu(irq);
 	if (!irq_iommu) {
-		spin_unlock(&irq_2_ir_lock);
+		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 		return -1;
 	}
 
 	index = irq_iommu->irte_index + irq_iommu->sub_handle;
 	*entry = *(irq_iommu->iommu->ir_table->base + index);
 
-	spin_unlock(&irq_2_ir_lock);
+	spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 	return 0;
 }
 
@@ -141,6 +142,7 @@ int alloc_irte(struct intel_iommu *iommu
 	struct irq_2_iommu *irq_iommu;
 	u16 index, start_index;
 	unsigned int mask = 0;
+	unsigned long flags;
 	int i;
 
 	if (!count)
@@ -170,7 +172,7 @@ int alloc_irte(struct intel_iommu *iommu
 		return -1;
 	}
 
-	spin_lock(&irq_2_ir_lock);
+	spin_lock_irqsave(&irq_2_ir_lock, flags);
 	do {
 		for (i = index; i < index + count; i++)
 			if  (table->base[i].present)
@@ -182,7 +184,7 @@ int alloc_irte(struct intel_iommu *iommu
 		index = (index + count) % INTR_REMAP_TABLE_ENTRIES;
 
 		if (index == start_index) {
-			spin_unlock(&irq_2_ir_lock);
+			spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 			printk(KERN_ERR "can't allocate an IRTE\n");
 			return -1;
 		}
@@ -193,7 +195,7 @@ int alloc_irte(struct intel_iommu *iommu
 
 	irq_iommu = irq_2_iommu_alloc(irq);
 	if (!irq_iommu) {
-		spin_unlock(&irq_2_ir_lock);
+		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 		printk(KERN_ERR "can't allocate irq_2_iommu\n");
 		return -1;
 	}
@@ -203,7 +205,7 @@ int alloc_irte(struct intel_iommu *iommu
 	irq_iommu->sub_handle = 0;
 	irq_iommu->irte_mask = mask;
 
-	spin_unlock(&irq_2_ir_lock);
+	spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 
 	return index;
 }
@@ -223,30 +225,32 @@ int map_irq_to_irte_handle(int irq, u16 
 {
 	int index;
 	struct irq_2_iommu *irq_iommu;
+	unsigned long flags;
 
-	spin_lock(&irq_2_ir_lock);
+	spin_lock_irqsave(&irq_2_ir_lock, flags);
 	irq_iommu = valid_irq_2_iommu(irq);
 	if (!irq_iommu) {
-		spin_unlock(&irq_2_ir_lock);
+		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 		return -1;
 	}
 
 	*sub_handle = irq_iommu->sub_handle;
 	index = irq_iommu->irte_index;
-	spin_unlock(&irq_2_ir_lock);
+	spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 	return index;
 }
 
 int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 {
 	struct irq_2_iommu *irq_iommu;
+	unsigned long flags;
 
-	spin_lock(&irq_2_ir_lock);
+	spin_lock_irqsave(&irq_2_ir_lock, flags);
 
 	irq_iommu = irq_2_iommu_alloc(irq);
 
 	if (!irq_iommu) {
-		spin_unlock(&irq_2_ir_lock);
+		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 		printk(KERN_ERR "can't allocate irq_2_iommu\n");
 		return -1;
 	}
@@ -256,7 +260,7 @@ int set_irte_irq(int irq, struct intel_i
 	irq_iommu->sub_handle = subhandle;
 	irq_iommu->irte_mask = 0;
 
-	spin_unlock(&irq_2_ir_lock);
+	spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 
 	return 0;
 }
@@ -264,11 +268,12 @@ int set_irte_irq(int irq, struct intel_i
 int clear_irte_irq(int irq, struct intel_iommu *iommu, u16 index)
 {
 	struct irq_2_iommu *irq_iommu;
+	unsigned long flags;
 
-	spin_lock(&irq_2_ir_lock);
+	spin_lock_irqsave(&irq_2_ir_lock, flags);
 	irq_iommu = valid_irq_2_iommu(irq);
 	if (!irq_iommu) {
-		spin_unlock(&irq_2_ir_lock);
+		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 		return -1;
 	}
 
@@ -277,7 +282,7 @@ int clear_irte_irq(int irq, struct intel
 	irq_iommu->sub_handle = 0;
 	irq_2_iommu(irq)->irte_mask = 0;
 
-	spin_unlock(&irq_2_ir_lock);
+	spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 
 	return 0;
 }
@@ -289,11 +294,12 @@ int modify_irte(int irq, struct irte *ir
 	struct irte *irte;
 	struct intel_iommu *iommu;
 	struct irq_2_iommu *irq_iommu;
+	unsigned long flags;
 
-	spin_lock(&irq_2_ir_lock);
+	spin_lock_irqsave(&irq_2_ir_lock, flags);
 	irq_iommu = valid_irq_2_iommu(irq);
 	if (!irq_iommu) {
-		spin_unlock(&irq_2_ir_lock);
+		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 		return -1;
 	}
 
@@ -306,7 +312,7 @@ int modify_irte(int irq, struct irte *ir
 	__iommu_flush_cache(iommu, irte, sizeof(*irte));
 
 	rc = qi_flush_iec(iommu, index, 0);
-	spin_unlock(&irq_2_ir_lock);
+	spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 
 	return rc;
 }
@@ -317,11 +323,12 @@ int flush_irte(int irq)
 	int index;
 	struct intel_iommu *iommu;
 	struct irq_2_iommu *irq_iommu;
+	unsigned long flags;
 
-	spin_lock(&irq_2_ir_lock);
+	spin_lock_irqsave(&irq_2_ir_lock, flags);
 	irq_iommu = valid_irq_2_iommu(irq);
 	if (!irq_iommu) {
-		spin_unlock(&irq_2_ir_lock);
+		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 		return -1;
 	}
 
@@ -330,7 +337,7 @@ int flush_irte(int irq)
 	index = irq_iommu->irte_index + irq_iommu->sub_handle;
 
 	rc = qi_flush_iec(iommu, index, irq_iommu->irte_mask);
-	spin_unlock(&irq_2_ir_lock);
+	spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 
 	return rc;
 }
@@ -363,11 +370,12 @@ int free_irte(int irq)
 	struct irte *irte;
 	struct intel_iommu *iommu;
 	struct irq_2_iommu *irq_iommu;
+	unsigned long flags;
 
-	spin_lock(&irq_2_ir_lock);
+	spin_lock_irqsave(&irq_2_ir_lock, flags);
 	irq_iommu = valid_irq_2_iommu(irq);
 	if (!irq_iommu) {
-		spin_unlock(&irq_2_ir_lock);
+		spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 		return -1;
 	}
 
@@ -387,7 +395,7 @@ int free_irte(int irq)
 	irq_iommu->sub_handle = 0;
 	irq_iommu->irte_mask = 0;
 
-	spin_unlock(&irq_2_ir_lock);
+	spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 
 	return rc;
 }

-- 

