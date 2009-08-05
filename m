Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbZHEFKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbZHEFKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 01:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbZHEFKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 01:10:30 -0400
Received: from sh.osrg.net ([192.16.179.4]:38965 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbZHEFKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 01:10:16 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org
Cc: galak@kernel.crashing.orga, beckyb@kernel.crashing.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -v2 1/7] powerpc: remove addr_needs_map in struct dma_mapping_ops
Date: Wed,  5 Aug 2009 14:08:22 +0900
Message-Id: <1249448908-18985-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 05 Aug 2009 14:09:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds max_direct_dma_addr to struct dev_archdata to remove
addr_needs_map in struct dma_mapping_ops. It also converts
dma_capable() to use max_direct_dma_addr.

max_direct_dma_addr is initialized in pci_dma_dev_setup_swiotlb(),
called via ppc_md.pci_dma_dev_setup hook.

For further information:
http://marc.info/?t=124719060200001&r=1&w=2

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 arch/powerpc/include/asm/device.h          |    3 ++
 arch/powerpc/include/asm/dma-mapping.h     |    8 +++---
 arch/powerpc/include/asm/swiotlb.h         |    5 +--
 arch/powerpc/kernel/dma-swiotlb.c          |   36 +++++++++++----------------
 arch/powerpc/platforms/85xx/mpc8536_ds.c   |    1 +
 arch/powerpc/platforms/85xx/mpc85xx_ds.c   |    1 +
 arch/powerpc/platforms/85xx/mpc85xx_mds.c  |    1 +
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c |    1 +
 8 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/include/asm/device.h b/arch/powerpc/include/asm/device.h
index 7d2277c..0086f8d 100644
--- a/arch/powerpc/include/asm/device.h
+++ b/arch/powerpc/include/asm/device.h
@@ -16,6 +16,9 @@ struct dev_archdata {
 	/* DMA operations on that device */
 	struct dma_mapping_ops	*dma_ops;
 	void			*dma_data;
+#ifdef CONFIG_SWIOTLB
+	dma_addr_t		max_direct_dma_addr;
+#endif
 };
 
 static inline void dev_archdata_set_node(struct dev_archdata *ad,
diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index 0c34371..1765c37 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -87,8 +87,6 @@ struct dma_mapping_ops {
 				dma_addr_t dma_address, size_t size,
 				enum dma_data_direction direction,
 				struct dma_attrs *attrs);
-	int		(*addr_needs_map)(struct device *dev, dma_addr_t addr,
-				size_t size);
 #ifdef CONFIG_PPC_NEED_DMA_SYNC_OPS
 	void            (*sync_single_range_for_cpu)(struct device *hwdev,
 				dma_addr_t dma_handle, unsigned long offset,
@@ -426,10 +424,12 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
 {
-	struct dma_mapping_ops *ops = get_dma_ops(dev);
+#ifdef CONFIG_SWIOTLB
+	struct dev_archdata *sd = &dev->archdata;
 
-	if (ops->addr_needs_map && ops->addr_needs_map(dev, addr, size))
+	if (sd->max_direct_dma_addr && addr + size > sd->max_direct_dma_addr)
 		return 0;
+#endif
 
 	if (!dev->dma_mask)
 		return 0;
diff --git a/arch/powerpc/include/asm/swiotlb.h b/arch/powerpc/include/asm/swiotlb.h
index 30891d6..31e0e43 100644
--- a/arch/powerpc/include/asm/swiotlb.h
+++ b/arch/powerpc/include/asm/swiotlb.h
@@ -16,12 +16,11 @@
 extern struct dma_mapping_ops swiotlb_dma_ops;
 extern struct dma_mapping_ops swiotlb_pci_dma_ops;
 
-int swiotlb_arch_address_needs_mapping(struct device *, dma_addr_t,
-				       size_t size);
-
 static inline void dma_mark_clean(void *addr, size_t size) {}
 
 extern unsigned int ppc_swiotlb_enable;
 int __init swiotlb_setup_bus_notifier(void);
 
+extern void pci_dma_dev_setup_swiotlb(struct pci_dev *pdev);
+
 #endif /* __ASM_SWIOTLB_H */
diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/dma-swiotlb.c
index e8a57de..c9f6a30 100644
--- a/arch/powerpc/kernel/dma-swiotlb.c
+++ b/arch/powerpc/kernel/dma-swiotlb.c
@@ -25,26 +25,6 @@ int swiotlb __read_mostly;
 unsigned int ppc_swiotlb_enable;
 
 /*
- * Determine if an address is reachable by a pci device, or if we must bounce.
- */
-static int
-swiotlb_pci_addr_needs_map(struct device *hwdev, dma_addr_t addr, size_t size)
-{
-	dma_addr_t max;
-	struct pci_controller *hose;
-	struct pci_dev *pdev = to_pci_dev(hwdev);
-
-	hose = pci_bus_to_host(pdev->bus);
-	max = hose->dma_window_base_cur + hose->dma_window_size;
-
-	/* check that we're within mapped pci window space */
-	if ((addr + size > max) | (addr < hose->dma_window_base_cur))
-		return 1;
-
-	return 0;
-}
-
-/*
  * At the moment, all platforms that use this code only require
  * swiotlb to be used if we're operating on HIGHMEM.  Since
  * we don't ever call anything other than map_sg, unmap_sg,
@@ -73,22 +53,36 @@ struct dma_mapping_ops swiotlb_pci_dma_ops = {
 	.dma_supported = swiotlb_dma_supported,
 	.map_page = swiotlb_map_page,
 	.unmap_page = swiotlb_unmap_page,
-	.addr_needs_map = swiotlb_pci_addr_needs_map,
 	.sync_single_range_for_cpu = swiotlb_sync_single_range_for_cpu,
 	.sync_single_range_for_device = swiotlb_sync_single_range_for_device,
 	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
 	.sync_sg_for_device = swiotlb_sync_sg_for_device
 };
 
+void pci_dma_dev_setup_swiotlb(struct pci_dev *pdev)
+{
+	struct pci_controller *hose;
+	struct dev_archdata *sd;
+
+	hose = pci_bus_to_host(pdev->bus);
+	sd = &pdev->dev.archdata;
+	sd->max_direct_dma_addr =
+		hose->dma_window_base_cur + hose->dma_window_size;
+}
+
 static int ppc_swiotlb_bus_notify(struct notifier_block *nb,
 				  unsigned long action, void *data)
 {
 	struct device *dev = data;
+	struct dev_archdata *sd;
 
 	/* We are only intereted in device addition */
 	if (action != BUS_NOTIFY_ADD_DEVICE)
 		return 0;
 
+	sd = &dev->archdata;
+	sd->max_direct_dma_addr = 0;
+
 	/* May need to bounce if the device can't address all of DRAM */
 	if (dma_get_mask(dev) < lmb_end_of_DRAM())
 		set_dma_ops(dev, &swiotlb_dma_ops);
diff --git a/arch/powerpc/platforms/85xx/mpc8536_ds.c b/arch/powerpc/platforms/85xx/mpc8536_ds.c
index 055ff41..bf052c0 100644
--- a/arch/powerpc/platforms/85xx/mpc8536_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc8536_ds.c
@@ -97,6 +97,7 @@ static void __init mpc8536_ds_setup_arch(void)
 	if (lmb_end_of_DRAM() > max) {
 		ppc_swiotlb_enable = 1;
 		set_pci_dma_ops(&swiotlb_pci_dma_ops);
+		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
 	}
 #endif
 
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
index 849c0ac..c6f92cc 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
@@ -193,6 +193,7 @@ static void __init mpc85xx_ds_setup_arch(void)
 	if (lmb_end_of_DRAM() > max) {
 		ppc_swiotlb_enable = 1;
 		set_pci_dma_ops(&swiotlb_pci_dma_ops);
+		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
 	}
 #endif
 
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
index bfb3283..e1f82f8 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -255,6 +255,7 @@ static void __init mpc85xx_mds_setup_arch(void)
 	if (lmb_end_of_DRAM() > max) {
 		ppc_swiotlb_enable = 1;
 		set_pci_dma_ops(&swiotlb_pci_dma_ops);
+		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
 	}
 #endif
 }
diff --git a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
index 6632702..8032301 100644
--- a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
+++ b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
@@ -106,6 +106,7 @@ mpc86xx_hpcn_setup_arch(void)
 	if (lmb_end_of_DRAM() > max) {
 		ppc_swiotlb_enable = 1;
 		set_pci_dma_ops(&swiotlb_pci_dma_ops);
+		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
 	}
 #endif
 }
-- 
1.6.0.6

