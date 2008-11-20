Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbYKTPvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbYKTPvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbYKTPvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:51:04 -0500
Received: from mail10.svc.cra.dublin.eircom.net ([159.134.118.26]:47095 "HELO
	mail10.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754891AbYKTPvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:51:01 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       x86@kernel.org, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 4/8] intel-iommu: move DMA PTE defs out of dma_remapping.h
Date: Thu, 20 Nov 2008 15:49:46 +0000
Message-Id: <1227196190-488-4-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1227196190-488-3-git-send-email-markmc@redhat.com>
References: <1227191861.4901.24.camel@macbook.infradead.org>
 <1227196190-488-1-git-send-email-markmc@redhat.com>
 <1227196190-488-2-git-send-email-markmc@redhat.com>
 <1227196190-488-3-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA_PTE_READ/WRITE are needed by kvm.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/pci/intel-iommu.c     |   22 ++++++++++++++++++++++
 include/linux/dma_remapping.h |   22 ----------------------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 1c011bb..0f558c7 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -128,6 +128,28 @@ struct context_entry {
 	do {(c).hi |= ((val) & ((1 << 16) - 1)) << 8;} while (0)
 #define context_clear_entry(c) do {(c).lo = 0; (c).hi = 0;} while (0)
 
+/*
+ * 0: readable
+ * 1: writable
+ * 2-6: reserved
+ * 7: super page
+ * 8-11: available
+ * 12-63: Host physcial address
+ */
+struct dma_pte {
+	u64 val;
+};
+#define dma_clear_pte(p)	do {(p).val = 0;} while (0)
+
+#define dma_set_pte_readable(p) do {(p).val |= DMA_PTE_READ;} while (0)
+#define dma_set_pte_writable(p) do {(p).val |= DMA_PTE_WRITE;} while (0)
+#define dma_set_pte_prot(p, prot) \
+		do {(p).val = ((p).val & ~3) | ((prot) & 3); } while (0)
+#define dma_pte_addr(p) ((p).val & VTD_PAGE_MASK)
+#define dma_set_pte_addr(p, addr) do {\
+		(p).val |= ((addr) & VTD_PAGE_MASK); } while (0)
+#define dma_pte_present(p) (((p).val & 3) != 0)
+
 static void flush_unmaps_timeout(unsigned long data);
 
 DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
index 9a88f7d..9d5874e 100644
--- a/include/linux/dma_remapping.h
+++ b/include/linux/dma_remapping.h
@@ -11,31 +11,9 @@
 
 struct root_entry;
 
-/*
- * 0: readable
- * 1: writable
- * 2-6: reserved
- * 7: super page
- * 8-11: available
- * 12-63: Host physcial address
- */
-struct dma_pte {
-	u64 val;
-};
-#define dma_clear_pte(p)	do {(p).val = 0;} while (0)
-
 #define DMA_PTE_READ (1)
 #define DMA_PTE_WRITE (2)
 
-#define dma_set_pte_readable(p) do {(p).val |= DMA_PTE_READ;} while (0)
-#define dma_set_pte_writable(p) do {(p).val |= DMA_PTE_WRITE;} while (0)
-#define dma_set_pte_prot(p, prot) \
-		do {(p).val = ((p).val & ~3) | ((prot) & 3); } while (0)
-#define dma_pte_addr(p) ((p).val & VTD_PAGE_MASK)
-#define dma_set_pte_addr(p, addr) do {\
-		(p).val |= ((addr) & VTD_PAGE_MASK); } while (0)
-#define dma_pte_present(p) (((p).val & 3) != 0)
-
 struct intel_iommu;
 
 struct dmar_domain {
-- 
1.5.4.3

