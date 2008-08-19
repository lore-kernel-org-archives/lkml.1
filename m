Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbYHSSzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbYHSSzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYHSSzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:55:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:24346 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbYHSSzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:55:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,236,1217833200"; 
   d="scan'208";a="327466397"
Date: Tue, 19 Aug 2008 11:54:41 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: yhlu.kernel@gmail.com, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, x86@kernel.org
Subject: [patch] fix intr-remap with dyn_array/nr_irqs changes
Message-ID: <20080819185441.GC1152@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't find time to closely review the dyn_array/nr_irqs changes. But
the appended patch is needed to fix the broken intr-remapping support on
x86/tip

And also, I don't see any locks used in to_irq_desc_with_new(). How are
we handling the concurrent usage scenarios. And also, this code can use
some cleanups (like the names, to_irq_desc_with_new()?) etc.

thanks,
suresh
---

In irq_2_iommu_with_new() and set_irte_irq(), irq_desc or
irq_2_iommu pointers may not be allocated. So use the routines which
will allocate them if they are not already allocated.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 3593f0f..fbd82ff 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -76,7 +76,10 @@ static struct irq_2_iommu *irq_2_iommu_with_new(unsigned int irq)
 	struct irq_desc *desc;
 	struct irq_2_iommu *irq_iommu;
 
-	desc = to_irq_desc(irq);
+	/*
+	 * alloc irq desc if not allocated already.
+	 */
+	desc = to_irq_desc_with_new(irq);
 
 	BUG_ON(!desc);
 
@@ -255,11 +258,7 @@ int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 	struct irq_2_iommu *irq_iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	irq_iommu = valid_irq_2_iommu(irq);
-	if (!irq_iommu) {
-		spin_unlock(&irq_2_ir_lock);
-		return -1;
-	}
+	irq_iommu = irq_2_iommu_with_new(irq);
 
 	irq_iommu->iommu = iommu;
 	irq_iommu->irte_index = index;
