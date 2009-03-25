Return-Path: <linux-kernel-owner+w=401wt.eu-S1764213AbZCYSsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764213AbZCYSsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762369AbZCYSrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:47:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:2685 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759508AbZCYSrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:47:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,420,1233561600"; 
   d="scan'208";a="500786784"
Message-Id: <20090325184635.374969000@intel.com>
References: <20090325184548.012018000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Mar 2009 11:45:49 -0700
From: fenghua.yu@intel.com
To: mingo@elte.hu, dwmw2@infradead.org, amluto@gmail.com, kyle@redhat.com,
       mgross@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Fenghua Yu <fenghua.yu@intel.com>
Subject: [patch 1/2] Intel IOMMU Suspend/Resume Support for DMAR
Content-Disposition: inline; filename=iommu_sr_1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attached patch implements the suspend and resume feature for DMAR. It hooks
to kernel suspend and resume interface.  When suspend happens, it saves
necessary hardware registers. When resume happens it restores the registers and
restarts DMAR.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 drivers/pci/intel-iommu.c   |  158 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/intel-iommu.h |    4 +
 2 files changed, 162 insertions(+)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 49402c3..a969bc8 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -36,6 +36,8 @@
 #include <linux/iova.h>
 #include <linux/iommu.h>
 #include <linux/intel-iommu.h>
+#include <linux/sysdev.h>
+#include <asm/i8259.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 #include "pci.h"
@@ -2563,6 +2565,161 @@ static void __init init_no_remapping_devices(void)
 	}
 }
 
+#ifdef CONFIG_PM
+static int init_iommu_hw(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+
+		iommu = drhd->iommu;
+
+		if (iommu->qi)
+			dmar_reenable_qi(iommu);
+	}
+
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+
+		iommu = drhd->iommu;
+
+		iommu_flush_write_buffer(iommu);
+
+		iommu_set_root_entry(iommu);
+
+		iommu->flush.flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL,
+					   0);
+		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH,
+					 0);
+		iommu_disable_protect_mem_regions(iommu);
+		iommu_enable_translation(iommu);
+	}
+
+	return 0;
+}
+
+static void iommu_flush_all(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+
+		iommu = drhd->iommu;
+		iommu->flush.flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL,
+					   0);
+		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH,
+					 0);
+	}
+}
+
+static u32 iommu_state[MAX_IOMMUS][MAX_IOMMU_REGS];
+
+static int iommu_suspend(struct sys_device *dev, pm_message_t state)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	unsigned long flag;
+	int    i = 0;
+
+	iommu_flush_all();
+
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+
+		iommu = drhd->iommu;
+
+		iommu_disable_translation(iommu);
+
+		spin_lock_irqsave(&iommu->register_lock, flag);
+
+		iommu_state[i][DMAR_FECTL_REG] =
+			(u32) readl(iommu->reg + DMAR_FECTL_REG);
+		iommu_state[i][DMAR_FEDATA_REG] =
+			(u32) readl(iommu->reg + DMAR_FEDATA_REG);
+		iommu_state[i][DMAR_FEADDR_REG] =
+			(u32) readl(iommu->reg + DMAR_FEADDR_REG);
+		iommu_state[i][DMAR_FEUADDR_REG] =
+			(u32) readl(iommu->reg + DMAR_FEUADDR_REG);
+
+		spin_unlock_irqrestore(&iommu->register_lock, flag);
+		i++;
+	}
+	return 0;
+}
+
+static int iommu_resume(struct sys_device *dev)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	unsigned long flag;
+	int i = 0;
+
+	if (init_iommu_hw())
+		panic("IOMMU setup failed, DMAR can not start!\n");
+
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+
+		iommu = drhd->iommu;
+
+		spin_lock_irqsave(&iommu->register_lock, flag);
+
+		writel((u32) iommu_state[i][DMAR_FECTL_REG],
+			iommu->reg + DMAR_FECTL_REG);
+		writel((u32) iommu_state[i][DMAR_FEDATA_REG],
+			iommu->reg + DMAR_FEDATA_REG);
+		writel((u32) iommu_state[i][DMAR_FEADDR_REG],
+			iommu->reg + DMAR_FEADDR_REG);
+		writel((u32) iommu_state[i][DMAR_FEUADDR_REG],
+			iommu->reg + DMAR_FEUADDR_REG);
+
+		spin_unlock_irqrestore(&iommu->register_lock, flag);
+		i++;
+	}
+	return 0;
+}
+
+static struct sysdev_class iommu_sysclass = {
+	.name		= "iommu",
+	.resume		= iommu_resume,
+	.suspend	= iommu_suspend,
+};
+
+static struct sys_device device_iommu = {
+	.cls	= &iommu_sysclass,
+};
+
+static int __init init_iommu_sysfs(void)
+{
+	int error;
+
+	error = sysdev_class_register(&iommu_sysclass);
+	if (error)
+		return error;
+
+	error = sysdev_register(&device_iommu);
+	if (error)
+		sysdev_class_unregister(&iommu_sysclass);
+
+	return error;
+}
+
+#else
+static init __init init_iommu_sysfs(void)
+{
+	return 0;
+}
+#endif	/* CONFIG_PM */
+
 int __init intel_iommu_init(void)
 {
 	int ret = 0;
@@ -2598,6 +2755,7 @@ int __init intel_iommu_init(void)
 	init_timer(&unmap_timer);
 	force_iommu = 1;
 	dma_ops = &intel_dma_ops;
+	init_iommu_sysfs();
 
 	register_iommu(&intel_iommu_ops);
 
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 1d6c71d..5ec836b 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -205,6 +205,9 @@ static inline void dmar_writeq(void __iomem *addr, u64 val)
 /* low 64 bit */
 #define dma_frcd_page_addr(d) (d & (((u64)-1) << PAGE_SHIFT))
 
+#define MAX_IOMMUS      32
+#define MAX_IOMMU_REGS  0xc0
+
 #define IOMMU_WAIT_OP(iommu, offset, op, cond, sts)			\
 do {									\
 	cycles_t start_time = get_cycles();				\
@@ -322,6 +325,7 @@ extern int alloc_iommu(struct dmar_drhd_unit *drhd);
 extern void free_iommu(struct intel_iommu *iommu);
 extern int dmar_enable_qi(struct intel_iommu *iommu);
 extern void dmar_disable_qi(struct intel_iommu *iommu);
+extern int dmar_reenable_qi(struct intel_iommu *iommu);
 extern void qi_global_iec(struct intel_iommu *iommu);
 
 extern int qi_flush_context(struct intel_iommu *iommu, u16 did, u16 sid,

-- 

