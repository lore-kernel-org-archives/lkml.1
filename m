Return-Path: <linux-kernel-owner+w=401wt.eu-S933440AbZIDJj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440AbZIDJj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933306AbZIDJjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:39:14 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:38884 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933367AbZIDJi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:38:28 -0400
X-SpamScore: 5
X-BigFish: VPS5(zba6lzzz1202hzzz32i203h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXG0-01-4M5-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/8] x86/amd-iommu: Add passthrough mode initialization functions
Date: Fri, 4 Sep 2009 11:36:29 +0200
Message-ID: <1252056994-31980-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
References: <1252056994-31980-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:36:43.0513 (UTC) FILETIME=[3692CE90:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When iommu=pt is passed on kernel command line the devices
should run untranslated. This requires the allocation of a
special domain for that purpose. This patch implements the
allocation and initialization path for iommu=pt.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu.h       |    1 +
 arch/x86/include/asm/amd_iommu_types.h |    4 ++
 arch/x86/kernel/amd_iommu.c            |   72 ++++++++++++++++++++++++++++----
 3 files changed, 69 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu.h b/arch/x86/include/asm/amd_iommu.h
index bdf96f1..ac95995 100644
--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -25,6 +25,7 @@
 #ifdef CONFIG_AMD_IOMMU
 extern int amd_iommu_init(void);
 extern int amd_iommu_init_dma_ops(void);
+extern int amd_iommu_init_passthrough(void);
 extern void amd_iommu_detect(void);
 extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
 extern void amd_iommu_flush_all_domains(void);
diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 0c878ca..49f7453 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -143,6 +143,7 @@
 #define EVT_BUFFER_SIZE		8192 /* 512 entries */
 #define EVT_LEN_MASK		(0x9ULL << 56)
 
+#define PAGE_MODE_NONE    0x00
 #define PAGE_MODE_1_LEVEL 0x01
 #define PAGE_MODE_2_LEVEL 0x02
 #define PAGE_MODE_3_LEVEL 0x03
@@ -194,6 +195,9 @@
 #define PD_DMA_OPS_MASK		(1UL << 0) /* domain used for dma_ops */
 #define PD_DEFAULT_MASK		(1UL << 1) /* domain is a default dma_ops
 					      domain for an IOMMU */
+#define PD_PASSTHROUGH_MASK	(1UL << 2) /* domain has no page
+					      translation */
+
 extern bool amd_iommu_dump;
 #define DUMP_printk(format, arg...)					\
 	do {								\
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0934348..7987f20 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -41,6 +41,12 @@ static DEFINE_RWLOCK(amd_iommu_devtable_lock);
 static LIST_HEAD(iommu_pd_list);
 static DEFINE_SPINLOCK(iommu_pd_list_lock);
 
+/*
+ * Domain for untranslated devices - only allocated
+ * if iommu=pt passed on kernel cmd line.
+ */
+static struct protection_domain *pt_domain;
+
 #ifdef CONFIG_IOMMU_API
 static struct iommu_ops amd_iommu_ops;
 #endif
@@ -1067,9 +1073,9 @@ static struct protection_domain *domain_for_device(u16 devid)
  * If a device is not yet associated with a domain, this function does
  * assigns it visible for the hardware
  */
-static void attach_device(struct amd_iommu *iommu,
-			  struct protection_domain *domain,
-			  u16 devid)
+static void __attach_device(struct amd_iommu *iommu,
+			    struct protection_domain *domain,
+			    u16 devid)
 {
 	unsigned long flags;
 	u64 pte_root = virt_to_phys(domain->pt_root);
@@ -1087,12 +1093,19 @@ static void attach_device(struct amd_iommu *iommu,
 
 	amd_iommu_pd_table[devid] = domain;
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+}
 
-       /*
-        * We might boot into a crash-kernel here. The crashed kernel
-        * left the caches in the IOMMU dirty. So we have to flush
-        * here to evict all dirty stuff.
-        */
+static void attach_device(struct amd_iommu *iommu,
+			  struct protection_domain *domain,
+			  u16 devid)
+{
+	__attach_device(iommu, domain, devid);
+
+	/*
+	 * We might boot into a crash-kernel here. The crashed kernel
+	 * left the caches in the IOMMU dirty. So we have to flush
+	 * here to evict all dirty stuff.
+	 */
 	iommu_queue_inv_dev_entry(iommu, devid);
 	iommu_flush_tlb_pde(iommu, domain->id);
 }
@@ -2219,3 +2232,46 @@ static struct iommu_ops amd_iommu_ops = {
 	.domain_has_cap = amd_iommu_domain_has_cap,
 };
 
+/*****************************************************************************
+ *
+ * The next functions do a basic initialization of IOMMU for pass through
+ * mode
+ *
+ * In passthrough mode the IOMMU is initialized and enabled but not used for
+ * DMA-API translation.
+ *
+ *****************************************************************************/
+
+int __init amd_iommu_init_passthrough(void)
+{
+	struct pci_dev *dev = NULL;
+	u16 devid, devid2;
+
+	/* allocate passthroug domain */
+	pt_domain = protection_domain_alloc();
+	if (!pt_domain)
+		return -ENOMEM;
+
+	pt_domain->mode |= PAGE_MODE_NONE;
+
+	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+		struct amd_iommu *iommu;
+
+		devid = calc_devid(dev->bus->number, dev->devfn);
+		if (devid > amd_iommu_last_bdf)
+			continue;
+
+		devid2 = amd_iommu_alias_table[devid];
+
+		iommu = amd_iommu_rlookup_table[devid2];
+		if (!iommu)
+			continue;
+
+		__attach_device(iommu, pt_domain, devid);
+		__attach_device(iommu, pt_domain, devid2);
+	}
+
+	pr_info("AMD-Vi: Initialized for Passthrough Mode\n");
+
+	return 0;
+}
-- 
1.6.3.3


