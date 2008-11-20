Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbYKTPvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbYKTPvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbYKTPvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:51:01 -0500
Received: from mail03.svc.cra.dublin.eircom.net ([159.134.118.19]:33216 "HELO
	mail03.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751307AbYKTPvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:51:00 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       x86@kernel.org, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 2/8] intel-iommu: move root entry defs from dma_remapping.h
Date: Thu, 20 Nov 2008 15:49:44 +0000
Message-Id: <1227196190-488-2-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1227196190-488-1-git-send-email-markmc@redhat.com>
References: <1227191861.4901.24.camel@macbook.infradead.org>
 <1227196190-488-1-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We keep the struct root_entry forward declaration for the
pointer in struct intel_iommu.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/pci/intel-iommu.c     |   33 +++++++++++++++++++++++++++++++++
 include/linux/dma_remapping.h |   34 +---------------------------------
 2 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index a9032e6..2e56e5a 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -57,6 +57,39 @@
 #define DMA_32BIT_PFN		IOVA_PFN(DMA_32BIT_MASK)
 #define DMA_64BIT_PFN		IOVA_PFN(DMA_64BIT_MASK)
 
+/*
+ * 0: Present
+ * 1-11: Reserved
+ * 12-63: Context Ptr (12 - (haw-1))
+ * 64-127: Reserved
+ */
+struct root_entry {
+	u64	val;
+	u64	rsvd1;
+};
+#define ROOT_ENTRY_NR (VTD_PAGE_SIZE/sizeof(struct root_entry))
+static inline bool root_present(struct root_entry *root)
+{
+	return (root->val & 1);
+}
+static inline void set_root_present(struct root_entry *root)
+{
+	root->val |= 1;
+}
+static inline void set_root_value(struct root_entry *root, unsigned long value)
+{
+	root->val |= value & VTD_PAGE_MASK;
+}
+
+static inline struct context_entry *
+get_context_addr_from_root(struct root_entry *root)
+{
+	return (struct context_entry *)
+		(root_present(root)?phys_to_virt(
+		root->val & VTD_PAGE_MASK) :
+		NULL);
+}
+
 static void flush_unmaps_timeout(unsigned long data);
 
 DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
index 2e5a5c0..d852166 100644
--- a/include/linux/dma_remapping.h
+++ b/include/linux/dma_remapping.h
@@ -9,39 +9,7 @@
 #define VTD_PAGE_MASK		(((u64)-1) << VTD_PAGE_SHIFT)
 #define VTD_PAGE_ALIGN(addr)	(((addr) + VTD_PAGE_SIZE - 1) & VTD_PAGE_MASK)
 
-/*
- * 0: Present
- * 1-11: Reserved
- * 12-63: Context Ptr (12 - (haw-1))
- * 64-127: Reserved
- */
-struct root_entry {
-	u64	val;
-	u64	rsvd1;
-};
-#define ROOT_ENTRY_NR (VTD_PAGE_SIZE/sizeof(struct root_entry))
-static inline bool root_present(struct root_entry *root)
-{
-	return (root->val & 1);
-}
-static inline void set_root_present(struct root_entry *root)
-{
-	root->val |= 1;
-}
-static inline void set_root_value(struct root_entry *root, unsigned long value)
-{
-	root->val |= value & VTD_PAGE_MASK;
-}
-
-struct context_entry;
-static inline struct context_entry *
-get_context_addr_from_root(struct root_entry *root)
-{
-	return (struct context_entry *)
-		(root_present(root)?phys_to_virt(
-		root->val & VTD_PAGE_MASK) :
-		NULL);
-}
+struct root_entry;
 
 /*
  * low 64 bits:
-- 
1.5.4.3

