Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYKTPvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYKTPvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbYKTPvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:51:03 -0500
Received: from mail00.svc.cra.dublin.eircom.net ([159.134.118.16]:43431 "HELO
	mail00.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754760AbYKTPvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:51:00 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       x86@kernel.org, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 5/8] intel-iommu: move struct dmar_domain def out dma_remapping.h
Date: Thu, 20 Nov 2008 15:49:47 +0000
Message-Id: <1227196190-488-5-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1227196190-488-4-git-send-email-markmc@redhat.com>
References: <1227191861.4901.24.camel@macbook.infradead.org>
 <1227196190-488-1-git-send-email-markmc@redhat.com>
 <1227196190-488-2-git-send-email-markmc@redhat.com>
 <1227196190-488-3-git-send-email-markmc@redhat.com>
 <1227196190-488-4-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/pci/intel-iommu.c     |   18 ++++++++++++++++++
 include/linux/dma_remapping.h |   22 ++--------------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 0f558c7..14066b1 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -150,6 +150,24 @@ struct dma_pte {
 		(p).val |= ((addr) & VTD_PAGE_MASK); } while (0)
 #define dma_pte_present(p) (((p).val & 3) != 0)
 
+struct dmar_domain {
+	int	id;			/* domain id */
+	struct intel_iommu *iommu;	/* back pointer to owning iommu */
+
+	struct list_head devices; 	/* all devices' list */
+	struct iova_domain iovad;	/* iova's that belong to this domain */
+
+	struct dma_pte	*pgd;		/* virtual address */
+	spinlock_t	mapping_lock;	/* page table lock */
+	int		gaw;		/* max guest address width */
+
+	/* adjusted guest address width, 0 is level 2 30-bit */
+	int		agaw;
+
+#define DOMAIN_FLAG_MULTIPLE_DEVICES 1
+	int		flags;
+};
+
 static void flush_unmaps_timeout(unsigned long data);
 
 DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
index 9d5874e..3330144 100644
--- a/include/linux/dma_remapping.h
+++ b/include/linux/dma_remapping.h
@@ -9,30 +9,12 @@
 #define VTD_PAGE_MASK		(((u64)-1) << VTD_PAGE_SHIFT)
 #define VTD_PAGE_ALIGN(addr)	(((addr) + VTD_PAGE_SIZE - 1) & VTD_PAGE_MASK)
 
-struct root_entry;
-
 #define DMA_PTE_READ (1)
 #define DMA_PTE_WRITE (2)
 
 struct intel_iommu;
-
-struct dmar_domain {
-	int	id;			/* domain id */
-	struct intel_iommu *iommu;	/* back pointer to owning iommu */
-
-	struct list_head devices; 	/* all devices' list */
-	struct iova_domain iovad;	/* iova's that belong to this domain */
-
-	struct dma_pte	*pgd;		/* virtual address */
-	spinlock_t	mapping_lock;	/* page table lock */
-	int		gaw;		/* max guest address width */
-
-	/* adjusted guest address width, 0 is level 2 30-bit */
-	int		agaw;
-
-#define DOMAIN_FLAG_MULTIPLE_DEVICES 1
-	int		flags;
-};
+struct dmar_domain;
+struct root_entry;
 
 /* PCI domain-device relationship */
 struct device_domain_info {
-- 
1.5.4.3

