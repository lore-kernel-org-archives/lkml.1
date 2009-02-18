Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbZBRQ4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbZBRQ4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 11:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZBRQ4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 11:56:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:20359 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbZBRQ4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:56:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,230,1233561600"; 
   d="scan'208";a="491068348"
Date: Wed, 18 Feb 2009 08:56:33 -0800
From: Fenghua Yu <fenghua.yu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Cc: 'iommu@lists.linux-foundation.org', LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Suspend and Resume Support for Intel IOMMU
Message-ID: <20090218165633.GA20167@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Current Intel IOMMU does not support suspend and resume. In S3 event, kernel
crashes when IOMMU is enabled. The attached patch implements the suspend and
resume feature for Intel IOMMU. It hooks to kernel suspend and resume interface.
When suspend happens, it saves necessary hardware registers. When resume happens
it restores the registers and restarts IOMMU.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 drivers/pci/intel-iommu.c   |  164 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/intel-iommu.h |    1 
 include/linux/iommu.h       |    3 
 3 files changed, 168 insertions(+)


diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index c842438..83a206e 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -282,6 +282,7 @@ int dmar_disabled = 1;
 static int __initdata dmar_map_gfx = 1;
 static int dmar_forcedac;
 static int intel_iommu_strict;
+static int vtd_enabled;
 
 #define DUMMY_DEVICE_DOMAIN_INFO ((struct device_domain_info *)(-1))
 static DEFINE_SPINLOCK(device_domain_lock);
@@ -2763,6 +2764,7 @@ int __init intel_iommu_init(void)
 	init_timer(&unmap_timer);
 	force_iommu = 1;
 	dma_ops = &intel_dma_ops;
+	vtd_enabled = 1;
 
 	register_iommu(&intel_iommu_ops);
 
@@ -3168,3 +3170,165 @@ static void __devinit quirk_cantiga_iommu(struct pci_dev *dev)
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2a40, quirk_iommu_rwbf);
+
+#ifdef CONFIG_PM
+static int init_iommu_hw(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	int ret, unit = 0;
+
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+
+		iommu = drhd->iommu;
+		if (dmar_enable_qi(iommu)) {
+			/*
+			 * Queued Invalidate not enabled, use Register Based
+			 * Invalidate
+			 */
+			iommu->flush.flush_context = __iommu_flush_context;
+			iommu->flush.flush_iotlb = __iommu_flush_iotlb;
+			printk(KERN_INFO "IOMMU 0x%Lx: using Register based "
+			       "invalidation\n",
+			       (unsigned long long)drhd->reg_base_addr);
+		} else {
+			iommu->flush.flush_context = qi_flush_context;
+			iommu->flush.flush_iotlb = qi_flush_iotlb;
+			printk(KERN_INFO "IOMMU 0x%Lx: using Queued "
+			       "invalidation\n",
+			       (unsigned long long)drhd->reg_base_addr);
+		}
+	}
+
+	/*
+	 * for each drhd
+	 *   enable fault log
+	 *   global invalidate context cache
+	 *   global invalidate iotlb
+	 *   enable translation
+	 */
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+		iommu = drhd->iommu;
+		sprintf(iommu->name, "dmar%d", unit++);
+
+		iommu_flush_write_buffer(iommu);
+
+		ret = dmar_set_interrupt(iommu);
+		if (ret)
+			goto error;
+
+		iommu_set_root_entry(iommu);
+
+		iommu->flush.flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL,
+					   0);
+		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH,
+					 0);
+		iommu_disable_protect_mem_regions(iommu);
+
+	}
+
+	return 0;
+error:
+	return ret;
+}
+
+static void iommu_flush_all(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+
+	for_each_drhd_unit(drhd) {
+		iommu = drhd->iommu;
+		iommu->flush.flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL,
+					   0);
+		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH,
+					 0);
+	}
+}
+
+static u32 iommu_state[MAX_IOMMUS][MAX_IOMMU_REGS];
+static int iommu_suspend(struct sys_device *dev, pm_message_t state)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	int    i = 0;
+
+	if (!vtd_enabled)
+		return 0;
+
+	iommu_flush_all();
+
+	for_each_drhd_unit(drhd) {
+		iommu = drhd->iommu;
+
+		iommu_state[i][DMAR_FECTL_REG] =
+			(u32) readl(iommu->reg + DMAR_FECTL_REG);
+		iommu_state[i][DMAR_FEDATA_REG] =
+			(u32) readl(iommu->reg + DMAR_FEDATA_REG);
+		iommu_state[i][DMAR_FEADDR_REG] =
+			(u32) readl(iommu->reg + DMAR_FEADDR_REG);
+		iommu_state[i][DMAR_FEUADDR_REG] =
+			(u32) readl(iommu->reg + DMAR_FEUADDR_REG);
+		i++;
+	}
+	return 0;
+}
+
+static int iommu_resume(struct sys_device *dev)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	int i = 0;
+
+	if (!vtd_enabled)
+		return 0;
+
+	iommu_flush_all();
+
+	if (init_iommu_hw())
+		panic("IOMMU setup failed, DMAR can not start!\n");
+
+	for_each_drhd_unit(drhd) {
+		iommu = drhd->iommu;
+
+		writel((u32) iommu_state[i][DMAR_FECTL_REG],
+			iommu->reg + DMAR_FECTL_REG);
+		writel((u32) iommu_state[i][DMAR_FEDATA_REG],
+			iommu->reg + DMAR_FEDATA_REG);
+		writel((u32) iommu_state[i][DMAR_FEADDR_REG],
+			iommu->reg + DMAR_FEADDR_REG);
+		writel((u32) iommu_state[i][DMAR_FEUADDR_REG],
+			iommu->reg + DMAR_FEUADDR_REG);
+		iommu_enable_translation(iommu);
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
+	.id	= 0,
+	.cls	= &iommu_sysclass,
+};
+
+static int __init init_iommu_sysfs(void)
+{
+	int error;
+
+	error = sysdev_class_register(&iommu_sysclass);
+	if (!error)
+		error = sysdev_register(&device_iommu);
+	return error;
+}
+device_initcall(init_iommu_sysfs);
+
+#endif	/* CONFIG_PM */
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index c4f6c10..5bc2da7 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -23,6 +23,7 @@
 #define _INTEL_IOMMU_H_
 
 #include <linux/types.h>
+#include <linux/sysdev.h>
 #include <linux/iova.h>
 #include <linux/io.h>
 #include <linux/dma_remapping.h>
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 8a7bfb1..01942ca 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -22,6 +22,9 @@
 #define IOMMU_READ	(1)
 #define IOMMU_WRITE	(2)
 
+#define MAX_IOMMUS	32
+#define MAX_IOMMU_REGS	0xc0
+
 struct device;
 
 struct iommu_domain {
