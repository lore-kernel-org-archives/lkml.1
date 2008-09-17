Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbYIQQ5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbYIQQ5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbYIQQxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:23 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:11713 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbYIQQxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:19 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K7CMW8-04-URS-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/23] AMD IOMMU: add MSI interrupt support
Date: Wed, 17 Sep 2008 18:52:43 +0200
Message-ID: <1221670377-19295-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:58.0017 (UTC) FILETIME=[D6632910:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMD IOMMU can generate interrupts for various reasons. This patch
adds the basic interrupt enabling infrastructure to the driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/Kconfig                  |    1 +
 arch/x86/kernel/amd_iommu.c       |   11 ++++
 arch/x86/kernel/amd_iommu_init.c  |   99 ++++++++++++++++++++++++++++++++++++-
 include/asm-x86/amd_iommu.h       |    3 +
 include/asm-x86/amd_iommu_types.h |    7 +++
 5 files changed, 120 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5258240..9c2898c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -567,6 +567,7 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
 config AMD_IOMMU
 	bool "AMD IOMMU support"
 	select SWIOTLB
+	select PCI_MSI
 	depends on X86_64 && PCI && ACPI
 	help
 	  With this option you can enable support for AMD IOMMU hardware in
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index fdec963..3caef6b 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -51,6 +51,17 @@ static int iommu_has_npcache(struct amd_iommu *iommu)
 
 /****************************************************************************
  *
+ * Interrupt handling functions
+ *
+ ****************************************************************************/
+
+irqreturn_t amd_iommu_int_handler(int irq, void *data)
+{
+	return IRQ_NONE;
+}
+
+/****************************************************************************
+ *
  * IOMMU command queuing functions
  *
  ****************************************************************************/
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index da619fc..ce3130d 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -22,6 +22,8 @@
 #include <linux/gfp.h>
 #include <linux/list.h>
 #include <linux/sysdev.h>
+#include <linux/interrupt.h>
+#include <linux/msi.h>
 #include <asm/pci-direct.h>
 #include <asm/amd_iommu_types.h>
 #include <asm/amd_iommu.h>
@@ -516,17 +518,20 @@ static void __init set_device_exclusion_range(u16 devid, struct ivmd_header *m)
 static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 {
 	int cap_ptr = iommu->cap_ptr;
-	u32 range;
+	u32 range, misc;
 
 	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_CAP_HDR_OFFSET,
 			      &iommu->cap);
 	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_RANGE_OFFSET,
 			      &range);
+	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_MISC_OFFSET,
+			      &misc);
 
 	iommu->first_device = calc_devid(MMIO_GET_BUS(range),
 					 MMIO_GET_FD(range));
 	iommu->last_device = calc_devid(MMIO_GET_BUS(range),
 					MMIO_GET_LD(range));
+	iommu->evt_msi_num = MMIO_MSI_NUM(misc);
 }
 
 /*
@@ -697,6 +702,8 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	if (!iommu->evt_buf)
 		return -ENOMEM;
 
+	iommu->int_enabled = false;
+
 	init_iommu_from_pci(iommu);
 	init_iommu_from_acpi(iommu, h);
 	init_iommu_devices(iommu);
@@ -744,6 +751,95 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 
 /****************************************************************************
  *
+ * The following functions initialize the MSI interrupts for all IOMMUs
+ * in the system. Its a bit challenging because there could be multiple
+ * IOMMUs per PCI BDF but we can call pci_enable_msi(x) only once per
+ * pci_dev.
+ *
+ ****************************************************************************/
+
+static int __init iommu_setup_msix(struct amd_iommu *iommu)
+{
+	struct amd_iommu *curr;
+	struct msix_entry entries[32]; /* only 32 supported by AMD IOMMU */
+	int nvec = 0, i;
+
+	list_for_each_entry(curr, &amd_iommu_list, list) {
+		if (curr->dev == iommu->dev) {
+			entries[nvec].entry = curr->evt_msi_num;
+			entries[nvec].vector = 0;
+			curr->int_enabled = true;
+			nvec++;
+		}
+	}
+
+	if (pci_enable_msix(iommu->dev, entries, nvec)) {
+		pci_disable_msix(iommu->dev);
+		return 1;
+	}
+
+	for (i = 0; i < nvec; ++i) {
+		int r = request_irq(entries->vector, amd_iommu_int_handler,
+				    IRQF_SAMPLE_RANDOM,
+				    "AMD IOMMU",
+				    NULL);
+		if (r)
+			goto out_free;
+	}
+
+	return 0;
+
+out_free:
+	for (i -= 1; i >= 0; --i)
+		free_irq(entries->vector, NULL);
+
+	pci_disable_msix(iommu->dev);
+
+	return 1;
+}
+
+static int __init iommu_setup_msi(struct amd_iommu *iommu)
+{
+	int r;
+	struct amd_iommu *curr;
+
+	list_for_each_entry(curr, &amd_iommu_list, list) {
+		if (curr->dev == iommu->dev)
+			curr->int_enabled = true;
+	}
+
+
+	if (pci_enable_msi(iommu->dev))
+		return 1;
+
+	r = request_irq(iommu->dev->irq, amd_iommu_int_handler,
+			IRQF_SAMPLE_RANDOM,
+			"AMD IOMMU",
+			NULL);
+
+	if (r) {
+		pci_disable_msi(iommu->dev);
+		return 1;
+	}
+
+	return 0;
+}
+
+static int __init iommu_init_msi(struct amd_iommu *iommu)
+{
+	if (iommu->int_enabled)
+		return 0;
+
+	if (pci_find_capability(iommu->dev, PCI_CAP_ID_MSIX))
+		return iommu_setup_msix(iommu);
+	else if (pci_find_capability(iommu->dev, PCI_CAP_ID_MSI))
+		return iommu_setup_msi(iommu);
+
+	return 1;
+}
+
+/****************************************************************************
+ *
  * The next functions belong to the third pass of parsing the ACPI
  * table. In this last pass the memory mapping requirements are
  * gathered (like exclusion and unity mapping reanges).
@@ -863,6 +959,7 @@ static void __init enable_iommus(void)
 
 	list_for_each_entry(iommu, &amd_iommu_list, list) {
 		iommu_set_exclusion_range(iommu);
+		iommu_init_msi(iommu);
 		iommu_enable(iommu);
 	}
 }
diff --git a/include/asm-x86/amd_iommu.h b/include/asm-x86/amd_iommu.h
index 783f43e..041d0db 100644
--- a/include/asm-x86/amd_iommu.h
+++ b/include/asm-x86/amd_iommu.h
@@ -20,10 +20,13 @@
 #ifndef ASM_X86__AMD_IOMMU_H
 #define ASM_X86__AMD_IOMMU_H
 
+#include <linux/irqreturn.h>
+
 #ifdef CONFIG_AMD_IOMMU
 extern int amd_iommu_init(void);
 extern int amd_iommu_init_dma_ops(void);
 extern void amd_iommu_detect(void);
+extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
 #else
 static inline int amd_iommu_init(void) { return -ENODEV; }
 static inline void amd_iommu_detect(void) { }
diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index 58c80f0..6ed8ffa 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -37,6 +37,7 @@
 /* Capability offsets used by the driver */
 #define MMIO_CAP_HDR_OFFSET	0x00
 #define MMIO_RANGE_OFFSET	0x0c
+#define MMIO_MISC_OFFSET	0x10
 
 /* Masks, shifts and macros to parse the device range capability */
 #define MMIO_RANGE_LD_MASK	0xff000000
@@ -48,6 +49,7 @@
 #define MMIO_GET_LD(x)  (((x) & MMIO_RANGE_LD_MASK) >> MMIO_RANGE_LD_SHIFT)
 #define MMIO_GET_FD(x)  (((x) & MMIO_RANGE_FD_MASK) >> MMIO_RANGE_FD_SHIFT)
 #define MMIO_GET_BUS(x) (((x) & MMIO_RANGE_BUS_MASK) >> MMIO_RANGE_BUS_SHIFT)
+#define MMIO_MSI_NUM(x)	((x) & 0x1f)
 
 /* Flag masks for the AMD IOMMU exclusion range */
 #define MMIO_EXCL_ENABLE_MASK 0x01ULL
@@ -255,10 +257,15 @@ struct amd_iommu {
 	u8 *evt_buf;
 	/* size of event buffer */
 	u32 evt_buf_size;
+	/* MSI number for event interrupt */
+	u16 evt_msi_num;
 
 	/* if one, we need to send a completion wait command */
 	int need_sync;
 
+	/* true if interrupts for this IOMMU are already enabled */
+	bool int_enabled;
+
 	/* default dma_ops domain for that IOMMU */
 	struct dma_ops_domain *default_dom;
 };
-- 
1.5.6.4


