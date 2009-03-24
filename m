Return-Path: <linux-kernel-owner+w=401wt.eu-S1764258AbZCYSss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764258AbZCYSss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764218AbZCYSsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:48:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:4324 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764164AbZCYSsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:48:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,420,1233561600"; 
   d="scan'208";a="124161099"
Date: Tue, 24 Mar 2009 15:37:23 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Lutomirski <amluto@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kyle McMartin <kyle@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       iommu@lists.linux-foundation.org
Subject: [PATCH 2/2] Intel IOMMU Suspend/Resume Support for Queued Invalidation
Message-ID: <20090324223723.GA24125@linux-os.sc.intel.com>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com> <20090324203259.GC26930@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324203259.GC26930@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports suspend/resume for queued invalidation. During suspend/
resume, queued invalidation is disabled and then reenabled. This patch also
consolidate queued invalidation hardware operation into one function.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 dmar.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index d313039..b318bd1 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -790,14 +790,39 @@ end:
 }
 
 /*
+ * Enable queued invalidation.
+ */
+static void __dmar_enable_qi(struct intel_iommu *iommu)
+{
+	u32 cmd, sts;
+	unsigned long flags;
+	struct q_inval *qi = iommu->qi;
+
+	qi->free_head = qi->free_tail = 0;
+	qi->free_cnt = QI_LENGTH;
+
+	spin_lock_irqsave(&iommu->register_lock, flags);
+	/* write zero to the tail reg */
+	writel(0, iommu->reg + DMAR_IQT_REG);
+
+	dmar_writeq(iommu->reg + DMAR_IQA_REG, virt_to_phys(qi->desc));
+
+	cmd = iommu->gcmd | DMA_GCMD_QIE;
+	iommu->gcmd |= DMA_GCMD_QIE;
+	writel(cmd, iommu->reg + DMAR_GCMD_REG);
+
+	/* Make sure hardware complete it */
+	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG, readl, (sts & DMA_GSTS_QIES), sts);
+	spin_unlock_irqrestore(&iommu->register_lock, flags);
+}
+
+/*
  * Enable Queued Invalidation interface. This is a must to support
  * interrupt-remapping. Also used by DMA-remapping, which replaces
  * register based IOTLB invalidation.
  */
 int dmar_enable_qi(struct intel_iommu *iommu)
 {
-	u32 cmd, sts;
-	unsigned long flags;
 	struct q_inval *qi;
 
 	if (!ecap_qis(iommu->ecap))
@@ -835,19 +860,7 @@ int dmar_enable_qi(struct intel_iommu *iommu)
 
 	spin_lock_init(&qi->q_lock);
 
-	spin_lock_irqsave(&iommu->register_lock, flags);
-	/* write zero to the tail reg */
-	writel(0, iommu->reg + DMAR_IQT_REG);
-
-	dmar_writeq(iommu->reg + DMAR_IQA_REG, virt_to_phys(qi->desc));
-
-	cmd = iommu->gcmd | DMA_GCMD_QIE;
-	iommu->gcmd |= DMA_GCMD_QIE;
-	writel(cmd, iommu->reg + DMAR_GCMD_REG);
-
-	/* Make sure hardware complete it */
-	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG, readl, (sts & DMA_GSTS_QIES), sts);
-	spin_unlock_irqrestore(&iommu->register_lock, flags);
+	__dmar_enable_qi(iommu);
 
 	return 0;
 }
@@ -1102,3 +1115,27 @@ int __init enable_drhd_fault_handling(void)
 
 	return 0;
 }
+
+/*
+ * Re-enable Queued Invalidation interface.
+ */
+int dmar_reenable_qi(struct intel_iommu *iommu)
+{
+	if (!ecap_qis(iommu->ecap))
+		return -ENOENT;
+
+	if (!iommu->qi)
+		return -ENOENT;
+
+	/*
+	 * First disable queued invalidation.
+	 */
+	dmar_disable_qi(iommu);
+	/* Then enable queued invalidation again. Since there is no pending
+	 * invalidation requests now, it's safe to re-enable queued
+	 * invalidation.
+	 */
+	__dmar_enable_qi(iommu);
+
+	return 0;
+}
