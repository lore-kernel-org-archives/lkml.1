Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbZFYAis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbZFYAis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 20:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZFYAik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 20:38:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:24446 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbZFYAij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 20:38:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,285,1243839600"; 
   d="scan'208";a="702282735"
Date: Wed, 24 Jun 2009 17:38:41 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Tony Luck'" <tony.luck@intel.com>,
       "'Christopher Wright'" <chrisw@redhat.com>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'lkml'" <linux-kernel@vger.kernel.org>,
       "'iommu'" <iommu@lists.linux-foundation.org>,
       "'linux-ia64'" <linux-ia64@vger.kernel.org>
Subject: [PATCH] IA64 Compilation Error Fix for Intel IOMMU Identity Mapping Support
Message-ID: <20090625003841.GA12226@linux-os.sc.intel.com>
References: <20090327212321.070229000@intel.com> <20090416001957.GA1527@linux-os.sc.intel.com> <1240135508.3589.75.camel@macbook.infradead.org> <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com> <20090513231351.GA22386@linux-os.sc.intel.com> <1242314271.3393.11.camel@macbook.infradead.org> <20090514175944.GA5168@linux-os.sc.intel.com> <20090618180514.GA24082@linux-os.sc.intel.com> <20090618180835.GB6838@il.ibm.com> <A6AD88C3F2289247BE726C37303E1EB8B0044EC0@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8B0044EC0@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IA64 Compilation error fix for Intel IOMMU identity mapping

The Intel IOMMU identity mapping uses e820 to walk the memory map. This causes
compilation error on IA64 when IOMMU is configured:

drivers/pci/intel-iommu.c:42:22: error: asm/e820.h: No such file or directory

This patch fixes this compilation error on IA64. It defines architecture
dependent memory map walk functions on x86 and ia64 seperately to set up
identity mapping for all devices.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Tony Luck <tony.luck@intel.com>

---

This patch is against the latest upstream tree.

 arch/ia64/kernel/pci-dma.c  |   27 +++++++++++++++++++++++++++
 arch/x86/kernel/pci-dma.c   |   22 ++++++++++++++++++++++
 drivers/pci/intel-iommu.c   |   38 ++++++++++++++++++++++----------------
 include/linux/intel-iommu.h |    4 ++++
 4 files changed, 75 insertions(+), 16 deletions(-)

diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index 0569596..9cb3700 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -10,7 +10,9 @@
 #include <linux/dmar.h>
 #include <asm/iommu.h>
 #include <asm/machvec.h>
+#include <linux/efi.h>
 #include <linux/dma-mapping.h>
+#include <linux/intel-iommu.h>
 
 #include <asm/system.h>
 
@@ -122,4 +124,29 @@ void __init pci_iommu_alloc(void)
 #endif
 }
 
+static int __initdata identity_mapped = 1;
+
+static int __init __iommu_prepare_identity_map(u64 start, u64 end, void *pdev)
+{
+	int ret;
+
+	ret = iommu_prepare_identity_map((struct pci_dev *)pdev, start, end);
+	if (ret)  {
+		printk(KERN_INFO "1:1 mapping to one domain failed.\n");
+		identity_mapped = 0;
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+int __init iommu_setup_identity_map(struct pci_dev *pdev)
+{
+	efi_memmap_walk(__iommu_prepare_identity_map, pdev);
+	if (!identity_mapped)
+		return -EFAULT;
+
+	return 0;
+}
+
 #endif
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 4763047..775ece5 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -10,6 +10,7 @@
 #include <asm/gart.h>
 #include <asm/calgary.h>
 #include <asm/amd_iommu.h>
+#include <linux/intel-iommu.h>
 
 static int forbid_dac __read_mostly;
 
@@ -314,3 +315,24 @@ static __devinit void via_no_dac(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);
 #endif
+
+int iommu_setup_identity_map(struct pci_dev *pdev)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+
+		if (ei->type == E820_RAM) {
+			ret = iommu_prepare_identity_map(pdev,
+				ei->addr, ei->addr + ei->size);
+			if (ret)  {
+				printk(KERN_INFO "1:1 mapping to one domain failed.\n");
+				return -EFAULT;
+			}
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index e53eacd..009a79a 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -39,7 +39,6 @@
 #include <linux/sysdev.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
-#include <asm/e820.h>
 #include "pci.h"
 
 #define ROOT_SIZE		VTD_PAGE_SIZE
@@ -1845,9 +1844,8 @@ error:
 
 static int iommu_identity_mapping;
 
-static int iommu_prepare_identity_map(struct pci_dev *pdev,
-				      unsigned long long start,
-				      unsigned long long end)
+int iommu_prepare_identity_map(struct pci_dev *pdev, unsigned long long start,
+			       unsigned long long end)
 {
 	struct dmar_domain *domain;
 	unsigned long size;
@@ -2081,8 +2079,8 @@ static int domain_add_dev_info(struct dmar_domain *domain,
 
 static int iommu_prepare_static_identity_mapping(void)
 {
-	int i;
 	struct pci_dev *pdev = NULL;
+	int first_pdev = 1;
 	int ret;
 
 	ret = si_domain_init();
@@ -2091,17 +2089,25 @@ static int iommu_prepare_static_identity_mapping(void)
 
 	printk(KERN_INFO "IOMMU: Setting identity map:\n");
 	for_each_pci_dev(pdev) {
-		for (i = 0; i < e820.nr_map; i++) {
-			struct e820entry *ei = &e820.map[i];
-
-			if (ei->type == E820_RAM) {
-				ret = iommu_prepare_identity_map(pdev,
-					ei->addr, ei->addr + ei->size);
-				if (ret)  {
-					printk(KERN_INFO "1:1 mapping to one domain failed.\n");
-					return -EFAULT;
-				}
-			}
+		if (first_pdev) {
+			/*
+			 * first pdev sets up the whole page table for
+			 * si_domain.
+			 */
+			first_pdev = 0;
+			ret = iommu_setup_identity_map(pdev);
+			if (ret)
+				return ret;
+		} else {
+			/*
+			 * following pdev's just use the page table.
+			 */
+			printk(KERN_INFO "IOMMU: identity mapping for device %s\n",
+			       pci_name(pdev));
+			ret = domain_context_mapping(si_domain, pdev,
+						     CONTEXT_TT_MULTI_LEVEL);
+			if (ret)
+				return ret;
 		}
 		ret = domain_add_dev_info(si_domain, pdev);
 		if (ret)
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 482dc91..5d470cf 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -359,5 +359,9 @@ extern void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 qdep,
 			       u64 addr, unsigned mask);
 
 extern int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
+extern int iommu_prepare_identity_map(struct pci_dev *pdev,
+				      unsigned long long start,
+				      unsigned long long end);
 
+extern int iommu_setup_identity_map(struct pci_dev *pdev);
 #endif
